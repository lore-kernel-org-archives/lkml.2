Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab2KWHGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:06:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58608 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797Ab2KWHGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:06:51 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, patches@linaro.org
Subject: [PATCH 2/2] drivers/rtc/rtc-s3c.c: Convert to use devm_* API
Date: Fri, 23 Nov 2012 12:30:19 +0530
Message-Id: <1353654019-1099-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353654019-1099-1-git-send-email-tushar.behera@linaro.org>
References: <1353654019-1099-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc-s3c driver is modified to use devm_request_and_ioremap() (combining
request_mem_region and ioremap), devm_clk_get() and devm_request_irq()
APIs. Since this removes the necessity of freeing the related resources
the return path is also simplified.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/rtc/rtc-s3c.c |   45 ++++++++-------------------------------------
 1 files changed, 8 insertions(+), 37 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index df7b478..b74720f 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -47,8 +47,6 @@ struct s3c_rtc_drv_data {
 /* I have yet to find an S3C implementation with more than one
  * of these rtc blocks in */
 
-static struct resource *s3c_rtc_mem;
-
 static struct clk *rtc_clk;
 static void __iomem *s3c_rtc_base;
 static int s3c_rtc_alarmno = NO_IRQ;
@@ -427,21 +425,13 @@ static int __devexit s3c_rtc_remove(struct platform_device *dev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(dev);
 
-	free_irq(s3c_rtc_alarmno, rtc);
-	free_irq(s3c_rtc_tickno, rtc);
-
 	platform_set_drvdata(dev, NULL);
 	rtc_device_unregister(rtc);
 
 	s3c_rtc_setaie(&dev->dev, 0);
 
-	clk_put(rtc_clk);
 	rtc_clk = NULL;
 
-	iounmap(s3c_rtc_base);
-	release_resource(s3c_rtc_mem);
-	kfree(s3c_rtc_mem);
-
 	return 0;
 }
 
@@ -496,27 +486,18 @@ static int __devinit s3c_rtc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	s3c_rtc_mem = request_mem_region(res->start, resource_size(res),
-					 pdev->name);
-
-	if (s3c_rtc_mem == NULL) {
-		dev_err(&pdev->dev, "failed to reserve memory region\n");
-		return -ENOENT;
-	}
-
-	s3c_rtc_base = ioremap(res->start, resource_size(res));
+	s3c_rtc_base = devm_request_and_ioremap(&pdev->dev, res);
 	if (s3c_rtc_base == NULL) {
-		dev_err(&pdev->dev, "failed ioremap()\n");
-		ret = -EINVAL;
-		goto err_nomap;
+		dev_err(&pdev->dev, "failed to ioremap memory region\n");
+		return -EINVAL;
 	}
 
-	rtc_clk = clk_get(&pdev->dev, "rtc");
+	rtc_clk = devm_clk_get(&pdev->dev, "rtc");
 	if (IS_ERR(rtc_clk)) {
 		dev_err(&pdev->dev, "failed to find rtc clock source\n");
 		ret = PTR_ERR(rtc_clk);
 		rtc_clk = NULL;
-		goto err_clk;
+		return ret;
 	}
 
 	clk_enable(rtc_clk);
@@ -575,28 +556,24 @@ static int __devinit s3c_rtc_probe(struct platform_device *pdev)
 
 	s3c_rtc_setfreq(&pdev->dev, 1);
 
-	ret = request_irq(s3c_rtc_alarmno, s3c_rtc_alarmirq,
+	ret = devm_request_irq(&pdev->dev, s3c_rtc_alarmno, s3c_rtc_alarmirq,
 			  0,  "s3c2410-rtc alarm", rtc);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_alarmno, ret);
 		goto err_alarm_irq;
 	}
 
-	ret = request_irq(s3c_rtc_tickno, s3c_rtc_tickirq,
+	ret = devm_request_irq(&pdev->dev, s3c_rtc_tickno, s3c_rtc_tickirq,
 			  0,  "s3c2410-rtc tick", rtc);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_tickno, ret);
-		free_irq(s3c_rtc_alarmno, rtc);
-		goto err_tick_irq;
+		goto err_alarm_irq;
 	}
 
 	clk_disable(rtc_clk);
 
 	return 0;
 
- err_tick_irq:
-	free_irq(s3c_rtc_alarmno, rtc);
-
  err_alarm_irq:
 	platform_set_drvdata(pdev, NULL);
 	rtc_device_unregister(rtc);
@@ -604,13 +581,7 @@ static int __devinit s3c_rtc_probe(struct platform_device *pdev)
  err_nortc:
 	s3c_rtc_enable(pdev, 0);
 	clk_disable(rtc_clk);
-	clk_put(rtc_clk);
-
- err_clk:
-	iounmap(s3c_rtc_base);
 
- err_nomap:
-	release_resource(s3c_rtc_mem);
 	return ret;
 }
 
-- 
1.7.4.1

