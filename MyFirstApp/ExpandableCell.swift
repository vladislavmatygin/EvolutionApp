import UIKit
import SnapKit

class ExpandableCell: UICollectionViewCell {
    
    //MARK: Переопределяем isSelected, чтобы на каждое изменение вызывать updateAppearance()
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    
    //MARK: Констреинт для расширенного состояния
    private var expandedConstraint: Constraint!
    
    //MARK: Констреинт для сжатого состояния
    private var collapsedConstraint: Constraint!
    
    private lazy var mainContainer = UIView()
    private lazy var topContainer = UIView()
    private lazy var bottomContainer = UIView()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "arrow_down")!.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureView()
    }
    
    //MARK: При изменении состояния выбора ячейки переключаем констрейнт и анимируем поворот стрелки
    private func updateAppearance() {
        collapsedConstraint.isActive = !isSelected
        expandedConstraint.isActive = isSelected
        
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * -0.999)
            self.arrowImageView.transform = self.isSelected ? upsideDown: .identity
        }
    }
    
    private func configureView() {
        mainContainer.clipsToBounds = true
        topContainer.backgroundColor = UIColor.systemYellow
        bottomContainer.backgroundColor = UIColor.systemGreen
        
        makeConstraints()
        updateAppearance()
    }
    
    private func makeConstraints() {
        contentView.addSubview(mainContainer)
        
        mainContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        mainContainer.addSubview(topContainer)
        mainContainer.addSubview(bottomContainer)
        
        topContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        //MARK: Констрейнт для сжатого состояния (низ ячейки совпадает с низом верхнего контейнера)
        topContainer.snp.prepareConstraints { make in
            collapsedConstraint = make.bottom.equalToSuperview().constraint
            collapsedConstraint.layoutConstraints.first?.priority = .defaultLow
        }
        
        topContainer.addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(topContainer.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        //MARK: Констреин для расширенного состяния (низ ячейки совпадает с низом нижнего контейнера)
        bottomContainer.snp.prepareConstraints { make in
            expandedConstraint = make.bottom.equalToSuperview().constraint
            expandedConstraint.layoutConstraints.first?.priority = .defaultLow
        }
    }
}
