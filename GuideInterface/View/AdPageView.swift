//
//  AdPageView.swift
//  GuideInterface
//
//  Created by 佐毅 on 16/2/11.
//  Copyright © 2016年 上海乐住信息技术有限公司. All rights reserved.
//

import Foundation

class AdPageView: UIView,UIScrollViewDelegate {
    
    private let showTime:NSTimeInterval = 3;
    private var pageControl:UIPageControl = UIPageControl();
    private var scrollView:UIScrollView = UIScrollView();
    private var imgPre:UIImageView = UIImageView();
    private var imgCur:UIImageView = UIImageView();
    private var imgNext:UIImageView = UIImageView();
    private var indexShow:NSInteger = 0;
    private var imagesList:NSArray = NSArray();
    
    private var timer:NSTimer = NSTimer();
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!;
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.initUI(self);
    }
    
    private func initUI(superView : UIView) {
        scrollView = UIScrollView(frame: CGRectMake(0, 0, superView.frame.width, superView.frame.height));
        scrollView.delegate = self;
        scrollView.backgroundColor = UIColor.whiteColor();
        scrollView.contentSize = CGSizeMake(superView.frame.size.width * 3, superView.frame.height);
        scrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        scrollView.pagingEnabled = true;
        scrollView.bounces = false;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        superView.addSubview(scrollView);
        
        scrollView.addSubview(imgPre);
        scrollView.addSubview(imgCur);
        scrollView.addSubview(imgNext);
        
        imgPre.frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height);
        imgCur.frame = CGRectMake(superView.frame.size.width, 0, superView.frame.size.width, superView.frame.size.height);
        imgNext.frame = CGRectMake(superView.frame.size.width * 2, 0, superView.frame.size.width, superView.frame.size.height);
        scrollView.scrollRectToVisible(CGRectMake(superView.frame.width, 0, superView.frame.width, 0), animated: false);
        
        pageControl.frame = CGRectMake(0, self.frame.height - 30, self.frame.width, 20);
        pageControl.currentPageIndicatorTintColor = UIColor.redColor();
        pageControl.pageIndicatorTintColor = UIColor.grayColor();
        self.addSubview(pageControl);
        
    }
    
    private func reloadImages() {
        if (indexShow >= imagesList.count) {
            indexShow = 0;
        }
        if (indexShow < 0) {
            indexShow = imagesList.count - 1;
        }
        self.showImage();
    }
    
    private func showImage() {
        //return;
        var indexPre:NSInteger = indexShow - 1;
        if (indexPre < 0) {
            indexPre = imagesList.count - 1;
        }
        
        pageControl.currentPage = indexShow;
        
        let namePre:String = imagesList.objectAtIndex(indexPre) as! String;
        
        let nameCur:String = imagesList.objectAtIndex(indexShow) as! String;
        
        var indexNext:NSInteger = indexShow + 1;
        if (indexNext >= imagesList.count) {
            indexNext = 0;
        }
        let nameNext:String = imagesList.objectAtIndex(indexNext) as! String;
        
        imgPre.image = UIImage(named: namePre as String);
        imgCur.image = UIImage(named: nameCur as String);
        imgNext.image = UIImage(named: nameNext as String);
        
        self.scrollView.scrollRectToVisible(CGRectMake(self.scrollView.frame.width, 0, self.scrollView.frame.width, 0), animated: false);
    }
    
    private func doTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(showTime, target: self, selector: "timerAction", userInfo: nil, repeats: true);
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer.invalidate();
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x >= self.frame.size.width*2) {
            indexShow++;
        }
        else if (scrollView.contentOffset.x < self.frame.size.width) {
            indexShow--;
        }
        self.reloadImages();
        self.doTimer();
    }
        
    func setImageList(imgList:NSArray) {
        if (imgList.count == 0) {
            return;
        }
        pageControl.numberOfPages = imgList.count;
        imagesList = imgList.copy() as! NSArray;
        self.showImage();
        self.doTimer();
    }
    
    func timerAction() {
        self.scrollView.scrollRectToVisible(CGRectMake(self.scrollView.frame.width*2, 0, self.scrollView.frame.width,0), animated: true);
        indexShow++;
        dispatch_async(dispatch_get_global_queue(0, 0), {
            NSThread.sleepForTimeInterval(0.3);
            dispatch_async(dispatch_get_main_queue(), {
                self.reloadImages();
            });
        });
    }
}
