Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab2KHOhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:37:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45640 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab2KHOhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:37:53 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: akpm@linux-foundation.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        a.zummo@towertech.it, spear-devel@list.st.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/3] rtc: rtc-spear: Use devm_*() routines
Date: Thu,  8 Nov 2012 20:07:39 +0530
Message-Id: <bb089953c3f5b07c9a299b409ed4ed26dfbc3c62.1352385320.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch frees rtc-spear driver from tension of freeing resources :)
devm_* derivatives of multiple routines are used while allocating resources,
which would be freed automatically by kernel.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/rtc/rtc-spear.c | 87 ++++++++++++++++++-------------------------------
 1 file changed, 31 insertions(+), 56 deletions(-)

diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index bb507d2..480ecc3 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -363,35 +363,48 @@ static int __devinit spear_rtc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "no resource defined\n");
 		return -EBUSY;
 	}
-	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
+	if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
+				pdev->name)) {
 		dev_err(&pdev->dev, "rtc region already claimed\n");
 		return -EBUSY;
 	}
 
-	config = kzalloc(sizeof(*config), GFP_KERNEL);
+	config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
 	if (!config) {
 		dev_err(&pdev->dev, "out of memory\n");
-		status = -ENOMEM;
-		goto err_release_region;
+		return -ENOMEM;
 	}
 
-	config->clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(config->clk)) {
-		status = PTR_ERR(config->clk);
-		goto err_kfree;
+	/* alarm irqs */
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no update irq?\n");
+		return irq;
 	}
 
-	status = clk_enable(config->clk);
-	if (status < 0)
-		goto err_clk_put;
+	status = devm_request_irq(&pdev->dev, irq, spear_rtc_irq, 0, pdev->name,
+			config);
+	if (status) {
+		dev_err(&pdev->dev, "Alarm interrupt IRQ%d already claimed\n",
+				irq);
+		return status;
+	}
 
-	config->ioaddr = ioremap(res->start, resource_size(res));
+	config->ioaddr = devm_ioremap(&pdev->dev, res->start,
+			resource_size(res));
 	if (!config->ioaddr) {
 		dev_err(&pdev->dev, "ioremap fail\n");
-		status = -ENOMEM;
-		goto err_disable_clock;
+		return -ENOMEM;
 	}
 
+	config->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(config->clk))
+		return PTR_ERR(config->clk);
+
+	status = clk_enable(config->clk);
+	if (status < 0)
+		return status;
+
 	spin_lock_init(&config->lock);
 	platform_set_drvdata(pdev, config);
 
@@ -401,22 +414,7 @@ static int __devinit spear_rtc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
 				PTR_ERR(config->rtc));
 		status = PTR_ERR(config->rtc);
-		goto err_iounmap;
-	}
-
-	/* alarm irqs */
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(&pdev->dev, "no update irq?\n");
-		status = irq;
-		goto err_clear_platdata;
-	}
-
-	status = request_irq(irq, spear_rtc_irq, 0, pdev->name, config);
-	if (status) {
-		dev_err(&pdev->dev, "Alarm interrupt IRQ%d already \
-				claimed\n", irq);
-		goto err_clear_platdata;
+		goto err_disable_clock;
 	}
 
 	if (!device_can_wakeup(&pdev->dev))
@@ -424,19 +422,9 @@ static int __devinit spear_rtc_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_clear_platdata:
-	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(config->rtc);
-err_iounmap:
-	iounmap(config->ioaddr);
 err_disable_clock:
+	platform_set_drvdata(pdev, NULL);
 	clk_disable(config->clk);
-err_clk_put:
-	clk_put(config->clk);
-err_kfree:
-	kfree(config);
-err_release_region:
-	release_mem_region(res->start, resource_size(res));
 
 	return status;
 }
@@ -444,24 +432,11 @@ err_release_region:
 static int __devexit spear_rtc_remove(struct platform_device *pdev)
 {
 	struct spear_rtc_config *config = platform_get_drvdata(pdev);
-	int irq;
-	struct resource *res;
 
-	/* leave rtc running, but disable irqs */
+	rtc_device_unregister(config->rtc);
 	spear_rtc_disable_interrupt(config);
-	device_init_wakeup(&pdev->dev, 0);
-	irq = platform_get_irq(pdev, 0);
-	if (irq)
-		free_irq(irq, pdev);
 	clk_disable(config->clk);
-	clk_put(config->clk);
-	iounmap(config->ioaddr);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res)
-		release_mem_region(res->start, resource_size(res));
-	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(config->rtc);
-	kfree(config);
+	device_init_wakeup(&pdev->dev, 0);
 
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e

