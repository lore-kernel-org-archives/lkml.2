Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761592Ab2FEJj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:39:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44670 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758120Ab2FEJis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:38:48 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>
Subject: [PATCH 5/5] drivers: usb: otg: twl: use devres API to allocate resources
Date: Tue, 5 Jun 2012 15:08:38 +0530
Message-ID: <1338889118-10032-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338889118-10032-1-git-send-email-kishon@ti.com>
References: <1338889118-10032-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

used devres API while allocating memory resource in twl4030 and twl6030
so that these resources are released automatically on driver detach.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/otg/twl4030-usb.c |   15 +++------------
 drivers/usb/otg/twl6030-usb.c |   16 +++-------------
 2 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index 03368c3..49b127a 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -589,15 +589,13 @@ static int __devinit twl4030_usb_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	twl = kzalloc(sizeof *twl, GFP_KERNEL);
+	twl = devm_kzalloc(&pdev->dev, sizeof *twl, GFP_KERNEL);
 	if (!twl)
 		return -ENOMEM;
 
-	otg = kzalloc(sizeof *otg, GFP_KERNEL);
-	if (!otg) {
-		kfree(twl);
+	otg = devm_kzalloc(&pdev->dev, sizeof *otg, GFP_KERNEL);
+	if (!otg)
 		return -ENOMEM;
-	}
 
 	twl->dev		= &pdev->dev;
 	twl->irq		= platform_get_irq(pdev, 0);
@@ -621,8 +619,6 @@ static int __devinit twl4030_usb_probe(struct platform_device *pdev)
 	err = twl4030_usb_ldo_init(twl);
 	if (err) {
 		dev_err(&pdev->dev, "ldo init failed\n");
-		kfree(otg);
-		kfree(twl);
 		return err;
 	}
 	usb_add_phy(&twl->phy, USB_PHY_TYPE_USB2);
@@ -646,8 +642,6 @@ static int __devinit twl4030_usb_probe(struct platform_device *pdev)
 	if (status < 0) {
 		dev_dbg(&pdev->dev, "can't get IRQ %d, err %d\n",
 			twl->irq, status);
-		kfree(otg);
-		kfree(twl);
 		return status;
 	}
 
@@ -691,9 +685,6 @@ static int __exit twl4030_usb_remove(struct platform_device *pdev)
 	regulator_put(twl->usb1v8);
 	regulator_put(twl->usb3v1);
 
-	kfree(twl->phy.otg);
-	kfree(twl);
-
 	return 0;
 }
 
diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
index 66cfea7..600c27a 100644
--- a/drivers/usb/otg/twl6030-usb.c
+++ b/drivers/usb/otg/twl6030-usb.c
@@ -395,15 +395,13 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	pdata = dev->platform_data;
 
-	twl = kzalloc(sizeof *twl, GFP_KERNEL);
+	twl = devm_kzalloc(dev, sizeof *twl, GFP_KERNEL);
 	if (!twl)
 		return -ENOMEM;
 
-	otg = kzalloc(sizeof *otg, GFP_KERNEL);
-	if (!otg) {
-		kfree(twl);
+	otg = devm_kzalloc(dev, sizeof *otg, GFP_KERNEL);
+	if (!otg)
 		return -ENOMEM;
-	}
 
 	twl->dev		= &pdev->dev;
 	twl->irq1		= platform_get_irq(pdev, 0);
@@ -430,8 +428,6 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 	err = twl6030_usb_ldo_init(twl);
 	if (err) {
 		dev_err(&pdev->dev, "ldo init failed\n");
-		kfree(otg);
-		kfree(twl);
 		return err;
 	}
 	usb_add_phy(&twl->phy, USB_PHY_TYPE_USB2);
@@ -450,8 +446,6 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
 			twl->irq1, status);
 		device_remove_file(twl->dev, &dev_attr_vbus);
-		kfree(otg);
-		kfree(twl);
 		return status;
 	}
 
@@ -463,8 +457,6 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 			twl->irq2, status);
 		free_irq(twl->irq1, twl);
 		device_remove_file(twl->dev, &dev_attr_vbus);
-		kfree(otg);
-		kfree(twl);
 		return status;
 	}
 
@@ -495,8 +487,6 @@ static int __exit twl6030_usb_remove(struct platform_device *pdev)
 	pdata->phy_exit(twl->dev);
 	device_remove_file(twl->dev, &dev_attr_vbus);
 	cancel_work_sync(&twl->set_vbus_work);
-	kfree(twl->phy.otg);
-	kfree(twl);
 
 	return 0;
 }
-- 
1.7.5.4

