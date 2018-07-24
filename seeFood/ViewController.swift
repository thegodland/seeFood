//
//  ViewController.swift
//  seeFood
//
//  Created by 刘祥 on 7/23/18.
//  Copyright © 2018 shaneliu90. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = pickImage
            guard let ciimage = CIImage(image: pickImage) else {fatalError()}
            detect(ciImage: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(ciImage : CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {fatalError()}
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {fatalError()}
            if let firstGuess = result.first{
                if firstGuess.identifier.contains("hotdog"){
                    self.navigationItem.title = "HotDog"
                }else{
                    self.navigationItem.title = "Not a Hotdog"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do{
            try handler.perform([request])
        }catch{
            print(error)
        }
    }


    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)

    }
    

}

