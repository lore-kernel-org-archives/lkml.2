Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2KHPIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:08:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38977 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab2KHPIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:08:15 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] usb: spear-ehci/ohci: Use devm_*() routines
Date: Thu,  8 Nov 2012 20:37:59 +0530
Message-Id: <39b46bbf101f787c970efe6e282c17bfc8e4ec0e.1352387166.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <19a629d4f79bb0a5904588ee7f546c461e8be6c4.1352387166.git.viresh.kumar@linaro.org>
References: <19a629d4f79bb0a5904588ee7f546c461e8be6c4.1352387166.git.viresh.kumar@linaro.org>
In-Reply-To: <19a629d4f79bb0a5904588ee7f546c461e8be6c4.1352387166.git.viresh.kumar@linaro.org>
References: <19a629d4f79bb0a5904588ee7f546c461e8be6c4.1352387166.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch frees SPEAr ehci/ohci drivers from tension of freeing resources :)
devm_* derivatives of multiple routines are used while allocating resources,
which would be freed automatically by kernel.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/usb/host/ehci-spear.c | 37 +++++++++++++------------------------
 drivers/usb/host/ohci-spear.c | 33 ++++++++++++---------------------
 2 files changed, 25 insertions(+), 45 deletions(-)

diff --git a/drivers/usb/host/ehci-spear.c b/drivers/usb/host/ehci-spear.c
index d08506a..3fadff8 100644
--- a/drivers/usb/host/ehci-spear.c
+++ b/drivers/usb/host/ehci-spear.c
@@ -116,7 +116,7 @@ static int spear_ehci_hcd_drv_probe(struct platform_device *pdev)
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		retval = irq;
-		goto fail_irq_get;
+		goto fail;
 	}
 
 	/*
@@ -127,38 +127,38 @@ static int spear_ehci_hcd_drv_probe(struct platform_device *pdev)
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &spear_ehci_dma_mask;
 
-	usbh_clk = clk_get(&pdev->dev, NULL);
+	usbh_clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(usbh_clk)) {
 		dev_err(&pdev->dev, "Error getting interface clock\n");
 		retval = PTR_ERR(usbh_clk);
-		goto fail_get_usbh_clk;
+		goto fail;
 	}
 
 	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
 	if (!hcd) {
 		retval = -ENOMEM;
-		goto fail_create_hcd;
+		goto fail;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		retval = -ENODEV;
-		goto fail_request_resource;
+		goto err_put_hcd;
 	}
 
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
+	if (!devm_request_mem_region(&pdev->dev, hcd->rsrc_start, hcd->rsrc_len,
 				driver->description)) {
 		retval = -EBUSY;
-		goto fail_request_resource;
+		goto err_put_hcd;
 	}
 
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = devm_ioremap(&pdev->dev, hcd->rsrc_start, hcd->rsrc_len);
 	if (hcd->regs == NULL) {
 		dev_dbg(&pdev->dev, "error mapping memory\n");
 		retval = -ENOMEM;
-		goto fail_ioremap;
+		goto err_put_hcd;
 	}
 
 	ehci = (struct spear_ehci *)hcd_to_ehci(hcd);
@@ -167,21 +167,15 @@ static int spear_ehci_hcd_drv_probe(struct platform_device *pdev)
 	spear_start_ehci(ehci);
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval)
-		goto fail_add_hcd;
+		goto err_stop_ehci;
 
 	return retval;
 
-fail_add_hcd:
+err_stop_ehci:
 	spear_stop_ehci(ehci);
-	iounmap(hcd->regs);
-fail_ioremap:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-fail_request_resource:
+err_put_hcd:
 	usb_put_hcd(hcd);
-fail_create_hcd:
-	clk_put(usbh_clk);
-fail_get_usbh_clk:
-fail_irq_get:
+fail:
 	dev_err(&pdev->dev, "init fail, %d\n", retval);
 
 	return retval ;
@@ -200,13 +194,8 @@ static int spear_ehci_hcd_drv_remove(struct platform_device *pdev)
 
 	if (ehci_p->clk)
 		spear_stop_ehci(ehci_p);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 
-	if (ehci_p->clk)
-		clk_put(ehci_p->clk);
-
 	return 0;
 }
 
diff --git a/drivers/usb/host/ohci-spear.c b/drivers/usb/host/ohci-spear.c
index 9747708..c69725d 100644
--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -105,7 +105,7 @@ static int spear_ohci_hcd_drv_probe(struct platform_device *pdev)
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		retval = irq;
-		goto fail_irq_get;
+		goto fail;
 	}
 
 	/*
@@ -116,38 +116,39 @@ static int spear_ohci_hcd_drv_probe(struct platform_device *pdev)
 	if (!pdev->dev.dma_mask)
 		pdev->dev.dma_mask = &spear_ohci_dma_mask;
 
-	usbh_clk = clk_get(&pdev->dev, NULL);
+	usbh_clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(usbh_clk)) {
 		dev_err(&pdev->dev, "Error getting interface clock\n");
 		retval = PTR_ERR(usbh_clk);
-		goto fail_get_usbh_clk;
+		goto fail;
 	}
 
 	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
 	if (!hcd) {
 		retval = -ENOMEM;
-		goto fail_create_hcd;
+		goto fail;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		retval = -ENODEV;
-		goto fail_request_resource;
+		goto err_put_hcd;
 	}
 
 	hcd->rsrc_start = pdev->resource[0].start;
 	hcd->rsrc_len = resource_size(res);
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
+	if (!devm_request_mem_region(&pdev->dev, hcd->rsrc_start, hcd->rsrc_len,
+				hcd_name)) {
 		dev_dbg(&pdev->dev, "request_mem_region failed\n");
 		retval = -EBUSY;
-		goto fail_request_resource;
+		goto err_put_hcd;
 	}
 
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = devm_ioremap(&pdev->dev, hcd->rsrc_start, hcd->rsrc_len);
 	if (!hcd->regs) {
 		dev_dbg(&pdev->dev, "ioremap failed\n");
 		retval = -ENOMEM;
-		goto fail_ioremap;
+		goto err_put_hcd;
 	}
 
 	ohci_p = (struct spear_ohci *)hcd_to_ohci(hcd);
@@ -160,15 +161,9 @@ static int spear_ohci_hcd_drv_probe(struct platform_device *pdev)
 		return retval;
 
 	spear_stop_ohci(ohci_p);
-	iounmap(hcd->regs);
-fail_ioremap:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-fail_request_resource:
+err_put_hcd:
 	usb_put_hcd(hcd);
-fail_create_hcd:
-	clk_put(usbh_clk);
-fail_get_usbh_clk:
-fail_irq_get:
+fail:
 	dev_err(&pdev->dev, "init fail, %d\n", retval);
 
 	return retval;
@@ -183,12 +178,8 @@ static int spear_ohci_hcd_drv_remove(struct platform_device *pdev)
 	if (ohci_p->clk)
 		spear_stop_ohci(ohci_p);
 
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 
-	if (ohci_p->clk)
-		clk_put(ohci_p->clk);
 	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e

