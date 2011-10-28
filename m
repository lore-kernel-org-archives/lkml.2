Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab1J1Mf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:35:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:24307 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661Ab1J1Mf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:35:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,418,1315206000"; 
   d="scan'208";a="68013622"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hema HK <hemahk@ti.com>
Subject: [PATCHv6 12/19] usb: otg: twl6030: Start using struct usb_otg
Date: Fri, 28 Oct 2011 15:35:18 +0300
Message-Id: <1319805325-24689-13-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct usb_otg members with OTG specific functions instead
of usb_phy members.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Hema HK <hemahk@ti.com>
---
 drivers/usb/otg/twl6030-usb.c |  103 ++++++++++++++++++++++------------------
 1 files changed, 57 insertions(+), 46 deletions(-)

diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
index 2f5c299..6de03fd 100644
--- a/drivers/usb/otg/twl6030-usb.c
+++ b/drivers/usb/otg/twl6030-usb.c
@@ -87,7 +87,7 @@
 #define	VBUS_DET			BIT(2)
 
 struct twl6030_usb {
-	struct usb_phy	otg;
+	struct usb_phy		xceiv;
 	struct device		*dev;
 
 	/* for vbus reporting with irqs disabled */
@@ -107,7 +107,7 @@ struct twl6030_usb {
 	unsigned long		features;
 };
 
-#define xceiv_to_twl(x)		container_of((x), struct twl6030_usb, otg)
+#define xceiv_to_twl(x)		container_of((x), struct twl6030_usb, xceiv)
 
 /*-------------------------------------------------------------------------*/
 
@@ -178,9 +178,9 @@ static int twl6030_phy_suspend(struct usb_phy *x, int suspend)
 	return 0;
 }
 
-static int twl6030_start_srp(struct usb_phy *x)
+static int twl6030_start_srp(struct usb_otg *otg)
 {
-	struct twl6030_usb *twl = xceiv_to_twl(x);
+	struct twl6030_usb *twl = xceiv_to_twl(otg->xceiv);
 
 	twl6030_writeb(twl, TWL_MODULE_USB, 0x24, USB_VBUS_CTRL_SET);
 	twl6030_writeb(twl, TWL_MODULE_USB, 0x84, USB_VBUS_CTRL_SET);
@@ -256,6 +256,7 @@ static DEVICE_ATTR(vbus, 0444, twl6030_usb_vbus_show, NULL);
 static irqreturn_t twl6030_usb_irq(int irq, void *_twl)
 {
 	struct twl6030_usb *twl = _twl;
+	struct usb_otg *otg = twl->xceiv.otg;
 	int status;
 	u8 vbus_state, hw_state;
 
@@ -268,18 +269,18 @@ static irqreturn_t twl6030_usb_irq(int irq, void *_twl)
 			regulator_enable(twl->usb3v3);
 			twl->asleep = 1;
 			status = USB_EVENT_VBUS;
-			twl->otg.default_a = false;
-			twl->otg.state = USB_PHY_STATE_B_IDLE;
+			otg->default_a = false;
+			twl->xceiv.state = USB_PHY_STATE_B_IDLE;
 			twl->linkstat = status;
-			twl->otg.last_event = status;
-			atomic_notifier_call_chain(&twl->otg.notifier,
-						status, twl->otg.gadget);
+			twl->xceiv.last_event = status;
+			atomic_notifier_call_chain(&twl->xceiv.notifier,
+						status, otg->gadget);
 		} else {
 			status = USB_EVENT_NONE;
 			twl->linkstat = status;
-			twl->otg.last_event = status;
-			atomic_notifier_call_chain(&twl->otg.notifier,
-						status, twl->otg.gadget);
+			twl->xceiv.last_event = status;
+			atomic_notifier_call_chain(&twl->xceiv.notifier,
+						status, otg->gadget);
 			if (twl->asleep) {
 				regulator_disable(twl->usb3v3);
 				twl->asleep = 0;
@@ -294,6 +295,7 @@ static irqreturn_t twl6030_usb_irq(int irq, void *_twl)
 static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
 {
 	struct twl6030_usb *twl = _twl;
+	struct usb_otg *otg = twl->xceiv.otg;
 	int status = USB_EVENT_NONE;
 	u8 hw_state;
 
@@ -307,12 +309,12 @@ static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
 		twl6030_writeb(twl, TWL_MODULE_USB, USB_ID_INT_EN_HI_SET,
 								0x10);
 		status = USB_EVENT_ID;
-		twl->otg.default_a = true;
-		twl->otg.state = USB_PHY_STATE_A_IDLE;
+		otg->default_a = true;
+		twl->xceiv.state = USB_PHY_STATE_A_IDLE;
 		twl->linkstat = status;
-		twl->otg.last_event = status;
-		atomic_notifier_call_chain(&twl->otg.notifier, status,
-							twl->otg.gadget);
+		twl->xceiv.last_event = status;
+		atomic_notifier_call_chain(&twl->xceiv.notifier, status,
+							otg->gadget);
 	} else  {
 		twl6030_writeb(twl, TWL_MODULE_USB, USB_ID_INT_EN_HI_CLR,
 								0x10);
@@ -324,18 +326,15 @@ static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
 	return IRQ_HANDLED;
 }
 
-static int twl6030_set_peripheral(struct usb_phy *x,
+static int twl6030_set_peripheral(struct usb_otg *otg,
 		struct usb_gadget *gadget)
 {
-	struct twl6030_usb *twl;
-
-	if (!x)
+	if (!otg)
 		return -ENODEV;
 
-	twl = xceiv_to_twl(x);
-	twl->otg.gadget = gadget;
+	otg->gadget = gadget;
 	if (!gadget)
-		twl->otg.state = USB_PHY_STATE_UNDEFINED;
+		otg->xceiv->state = USB_PHY_STATE_UNDEFINED;
 
 	return 0;
 }
@@ -376,9 +375,9 @@ static void otg_set_vbus_work(struct work_struct *data)
 							CHARGERUSB_CTRL1);
 }
 
-static int twl6030_set_vbus(struct usb_phy *x, bool enabled)
+static int twl6030_set_vbus(struct usb_otg *otg, bool enabled)
 {
-	struct twl6030_usb *twl = xceiv_to_twl(x);
+	struct twl6030_usb *twl = xceiv_to_twl(otg->xceiv);
 
 	twl->vbus_enable = enabled;
 	schedule_work(&twl->set_vbus_work);
@@ -386,17 +385,14 @@ static int twl6030_set_vbus(struct usb_phy *x, bool enabled)
 	return 0;
 }
 
-static int twl6030_set_host(struct usb_phy *x, struct usb_bus *host)
+static int twl6030_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
-	struct twl6030_usb *twl;
-
-	if (!x)
+	if (!otg)
 		return -ENODEV;
 
-	twl = xceiv_to_twl(x);
-	twl->otg.host = host;
+	otg->host = host;
 	if (!host)
-		twl->otg.state = USB_PHY_STATE_UNDEFINED;
+		otg->xceiv->state = USB_PHY_STATE_UNDEFINED;
 	return 0;
 }
 
@@ -405,6 +401,7 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 	struct twl6030_usb	*twl;
 	int			status, err;
 	struct twl4030_usb_data *pdata;
+	struct usb_otg		*otg;
 	struct device *dev = &pdev->dev;
 	pdata = dev->platform_data;
 
@@ -412,19 +409,29 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 	if (!twl)
 		return -ENOMEM;
 
+	otg = kzalloc(sizeof *otg, GFP_KERNEL);
+	if (!otg) {
+		kfree(twl);
+		return -ENOMEM;
+	}
+
 	twl->dev		= &pdev->dev;
 	twl->irq1		= platform_get_irq(pdev, 0);
 	twl->irq2		= platform_get_irq(pdev, 1);
 	twl->features		= pdata->features;
-	twl->otg.dev		= twl->dev;
-	twl->otg.label		= "twl6030";
-	twl->otg.set_host	= twl6030_set_host;
-	twl->otg.set_peripheral	= twl6030_set_peripheral;
-	twl->otg.set_vbus	= twl6030_set_vbus;
-	twl->otg.init		= twl6030_phy_init;
-	twl->otg.shutdown	= twl6030_phy_shutdown;
-	twl->otg.set_suspend	= twl6030_phy_suspend;
-	twl->otg.start_srp	= twl6030_start_srp;
+
+	twl->xceiv.dev		= twl->dev;
+	twl->xceiv.label	= "twl6030";
+	twl->xceiv.otg		= otg;
+	twl->xceiv.init		= twl6030_phy_init;
+	twl->xceiv.shutdown	= twl6030_phy_shutdown;
+	twl->xceiv.set_suspend	= twl6030_phy_suspend;
+
+	otg->xceiv		= &twl->xceiv;
+	otg->set_host		= twl6030_set_host;
+	otg->set_peripheral	= twl6030_set_peripheral;
+	otg->set_vbus		= twl6030_set_vbus;
+	otg->start_srp		= twl6030_start_srp;
 
 	/* init spinlock for workqueue */
 	spin_lock_init(&twl->lock);
@@ -432,16 +439,17 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 	err = twl6030_usb_ldo_init(twl);
 	if (err) {
 		dev_err(&pdev->dev, "ldo init failed\n");
+		kfree(otg);
 		kfree(twl);
 		return err;
 	}
-	otg_set_transceiver(&twl->otg);
+	usb_set_transceiver(&twl->xceiv);
 
 	platform_set_drvdata(pdev, twl);
 	if (device_create_file(&pdev->dev, &dev_attr_vbus))
 		dev_warn(&pdev->dev, "could not create sysfs file\n");
 
-	ATOMIC_INIT_NOTIFIER_HEAD(&twl->otg.notifier);
+	ATOMIC_INIT_NOTIFIER_HEAD(&twl->xceiv.notifier);
 
 	INIT_WORK(&twl->set_vbus_work, otg_set_vbus_work);
 
@@ -453,6 +461,7 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
 			twl->irq1, status);
 		device_remove_file(twl->dev, &dev_attr_vbus);
+		kfree(otg);
 		kfree(twl);
 		return status;
 	}
@@ -465,14 +474,15 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
 			twl->irq2, status);
 		free_irq(twl->irq1, twl);
 		device_remove_file(twl->dev, &dev_attr_vbus);
+		kfree(otg);
 		kfree(twl);
 		return status;
 	}
 
 	twl->asleep = 0;
 	pdata->phy_init(dev);
-	twl6030_phy_suspend(&twl->otg, 0);
-	twl6030_enable_irq(&twl->otg);
+	twl6030_phy_suspend(&twl->xceiv, 0);
+	twl6030_enable_irq(&twl->xceiv);
 	dev_info(&pdev->dev, "Initialized TWL6030 USB module\n");
 
 	return 0;
@@ -496,6 +506,7 @@ static int __exit twl6030_usb_remove(struct platform_device *pdev)
 	pdata->phy_exit(twl->dev);
 	device_remove_file(twl->dev, &dev_attr_vbus);
 	cancel_work_sync(&twl->set_vbus_work);
+	kfree(twl->xceiv.otg);
 	kfree(twl);
 
 	return 0;
-- 
1.7.4.1

