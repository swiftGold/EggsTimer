//
//  ViewController.swift
//  EggTimer
//
//  Created by Сергей Золотухин on 24.01.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "How do you like your eggs?"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = label.font.withSize(32)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var softEggButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("soft", for: .normal)
        button.setImage(UIImage(named: "soft_egg"), for: .normal)
        button.addTarget(self, action: #selector(softEggButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        return button
    }()

    private lazy var mediumEggButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("medium", for: .normal)
        button.setImage(UIImage(named: "medium_egg"), for: .normal)
        button.addTarget(self, action: #selector(mediumEggButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 2
        return button
    }()
    
    private lazy var hardEggButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("hard", for: .normal)
        button.setImage(UIImage(named: "hard_egg"), for: .normal)
        button.addTarget(self, action: #selector(hardEggButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 3
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = label.font.withSize(64)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stopTimerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stop timer", for: .normal)
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let eggsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var player: AVAudioPlayer?
    private var timerTest : Timer?
    
    var softTime = 300
    var mediumTime = 420
    var hardTime = 720
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    @objc
    private func softEggButtonTapped() {
        stopTimer()
        guard timerTest == nil else { return }
        timerTest = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(softEggTimer), userInfo: nil, repeats: true)
    }
    
    @objc
    private func mediumEggButtonTapped() {
        stopTimer()
        guard timerTest == nil else { return }
        timerTest = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(mediumEggTimer), userInfo: nil, repeats: true)
    }
    
    @objc
    private func hardEggButtonTapped() {
        stopTimer()
        guard timerTest == nil else { return }
        timerTest = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(hardEggTimer), userInfo: nil, repeats: true)
    }
    
    @objc
    private func stopButtonTapped() {
        stopTimer()
    }
    
    @objc
    private func softEggTimer() {
        if softTime >= 0 {
            timerLabel.text = String(softTime)
            softTime -= 1
        } else {
            playSound()
        }
    }
    
    @objc
    private func mediumEggTimer() {
        if mediumTime >= 0 {
            timerLabel.text = String(mediumTime)
            mediumTime -= 1
        } else {
            playSound()
        }
    }
    
    @objc
    private func hardEggTimer() {
        if hardTime >= 0 {
            timerLabel.text = String(hardTime)
            hardTime -= 1
        } else {
            playSound()
        }
    }
}

private extension ViewController {
    
    func stopTimer() {
        timerTest?.invalidate()
        timerTest = nil
    }
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "alarm_sound", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func setupViewController() {
        
        view.backgroundColor = UIColor(red: 203/255, green: 242/255, blue: 252/255, alpha: 1)
        
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(eggsStackView)
        mainStackView.addArrangedSubview(timerLabel)
        
        eggsStackView.addArrangedSubview(softEggButton)
        eggsStackView.addArrangedSubview(mediumEggButton)
        eggsStackView.addArrangedSubview(hardEggButton)
        
        view.addSubview(mainStackView)
        view.addSubview(stopTimerButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: stopTimerButton.topAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            eggsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            eggsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            softEggButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            softEggButton.bottomAnchor.constraint(equalTo: timerLabel.topAnchor, constant: -60),
            
            stopTimerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stopTimerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopTimerButton.heightAnchor.constraint(equalToConstant: 50),
            stopTimerButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}

