Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab1J1MiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:38:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:24307 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805Ab1J1Mfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:35:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,418,1315206000"; 
   d="scan'208";a="68013616"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv6 11/19] usb: otg: twl4030: Start using struct usb_otg
Date: Fri, 28 Oct 2011 15:35:17 +0300
Message-Id: <1319805325-24689-12-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct usb_otg members with OTG specific functions instead
of usb_phy members.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/otg/twl4030-usb.c |   77 +++++++++++++++++++++++------------------
 1 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index 9eed1f3..4151004 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -144,7 +144,7 @@
 #define GPIO_USB_4PIN_ULPI_2430C	(3 << 0)
 
 struct twl4030_usb {
-	struct usb_phy		otg;
+	struct usb_phy		xceiv;
 	struct device		*dev;
 
 	/* TWL4030 internal USB regulator supplies */
@@ -166,7 +166,7 @@ struct twl4030_usb {
 };
 
 /* internal define on top of container_of */
-#define xceiv_to_twl(x)		container_of((x), struct twl4030_usb, otg)
+#define xceiv_to_twl(x)		container_of((x), struct twl4030_usb, xceiv)
 
 /*-------------------------------------------------------------------------*/
 
@@ -250,6 +250,7 @@ static enum usb_phy_events twl4030_usb_linkstat(struct twl4030_usb *twl)
 {
 	int	status;
 	int	linkstat = USB_EVENT_NONE;
+	struct usb_otg *otg = twl->xceiv.otg;
 
 	twl->vbus_supplied = false;
 
@@ -281,7 +282,7 @@ static enum usb_phy_events twl4030_usb_linkstat(struct twl4030_usb *twl)
 	dev_dbg(twl->dev, "HW_CONDITIONS 0x%02x/%d; link %d\n",
 			status, status, linkstat);
 
-	twl->otg.last_event = linkstat;
+	twl->xceiv.last_event = linkstat;
 
 	/* REVISIT this assumes host and peripheral controllers
 	 * are registered, and that both are active...
@@ -290,11 +291,11 @@ static enum usb_phy_events twl4030_usb_linkstat(struct twl4030_usb *twl)
 	spin_lock_irq(&twl->lock);
 	twl->linkstat = linkstat;
 	if (linkstat == USB_EVENT_ID) {
-		twl->otg.default_a = true;
-		twl->otg.state = USB_PHY_STATE_A_IDLE;
+		otg->default_a = true;
+		twl->xceiv.state = USB_PHY_STATE_A_IDLE;
 	} else {
-		twl->otg.default_a = false;
-		twl->otg.state = USB_PHY_STATE_B_IDLE;
+		otg->default_a = false;
+		twl->xceiv.state = USB_PHY_STATE_B_IDLE;
 	}
 	spin_unlock_irq(&twl->lock);
 
@@ -520,8 +521,8 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 		else
 			twl4030_phy_resume(twl);
 
-		atomic_notifier_call_chain(&twl->otg.notifier, status,
-				twl->otg.gadget);
+		atomic_notifier_call_chain(&twl->xceiv.notifier, status,
+				twl->xceiv.otg->gadget);
 	}
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
 
@@ -542,8 +543,8 @@ static void twl4030_usb_phy_init(struct twl4030_usb *twl)
 			twl->asleep = 0;
 		}
 
-		atomic_notifier_call_chain(&twl->otg.notifier, status,
-				twl->otg.gadget);
+		atomic_notifier_call_chain(&twl->xceiv.notifier, status,
+				twl->xceiv.otg->gadget);
 	}
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
 }
@@ -560,33 +561,27 @@ static int twl4030_set_suspend(struct usb_phy *x, int suspend)
 	return 0;
 }
 
-static int twl4030_set_peripheral(struct usb_phy *x,
-		struct usb_gadget *gadget)
+static int twl4030_set_peripheral(struct usb_otg *otg,
+					struct usb_gadget *gadget)
 {
-	struct twl4030_usb *twl;
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
 
-static int twl4030_set_host(struct usb_phy *x, struct usb_bus *host)
+static int twl4030_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
-	struct twl4030_usb *twl;
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
@@ -596,6 +591,7 @@ static int __devinit twl4030_usb_probe(struct platform_device *pdev)
 	struct twl4030_usb_data *pdata = pdev->dev.platform_data;
 	struct twl4030_usb	*twl;
 	int			status, err;
+	struct usb_otg		*otg;
 
 	if (!pdata) {
 		dev_dbg(&pdev->dev, "platform_data not available\n");
@@ -606,16 +602,26 @@ static int __devinit twl4030_usb_probe(struct platform_device *pdev)
 	if (!twl)
 		return -ENOMEM;
 
+	otg = kzalloc(sizeof *otg, GFP_KERNEL);
+	if (!otg) {
+		kfree(twl);
+		return -ENOMEM;
+	}
+
 	twl->dev		= &pdev->dev;
 	twl->irq		= platform_get_irq(pdev, 0);
-	twl->otg.dev		= twl->dev;
-	twl->otg.label		= "twl4030";
-	twl->otg.set_host	= twl4030_set_host;
-	twl->otg.set_peripheral	= twl4030_set_peripheral;
-	twl->otg.set_suspend	= twl4030_set_suspend;
 	twl->usb_mode		= pdata->usb_mode;
 	twl->vbus_supplied	= false;
-	twl->asleep = 1;
+	twl->asleep		= 1;
+
+	twl->xceiv.dev		= twl->dev;
+	twl->xceiv.label	= "twl4030";
+	twl->xceiv.otg		= otg;
+	twl->xceiv.set_suspend	= twl4030_set_suspend;
+
+	otg->xceiv		= &twl->xceiv;
+	otg->set_host		= twl4030_set_host;
+	otg->set_peripheral	= twl4030_set_peripheral;
 
 	/* init spinlock for workqueue */
 	spin_lock_init(&twl->lock);
@@ -623,16 +629,17 @@ static int __devinit twl4030_usb_probe(struct platform_device *pdev)
 	err = twl4030_usb_ldo_init(twl);
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
 
 	/* Our job is to use irqs and status from the power module
 	 * to keep the transceiver disabled when nothing's connected.
@@ -649,6 +656,7 @@ static int __devinit twl4030_usb_probe(struct platform_device *pdev)
 	if (status < 0) {
 		dev_dbg(&pdev->dev, "can't get IRQ %d, err %d\n",
 			twl->irq, status);
+		kfree(otg);
 		kfree(twl);
 		return status;
 	}
@@ -693,6 +701,7 @@ static int __exit twl4030_usb_remove(struct platform_device *pdev)
 	regulator_put(twl->usb1v8);
 	regulator_put(twl->usb3v1);
 
+	kfree(twl->xceiv.otg);
 	kfree(twl);
 
 	return 0;
-- 
1.7.4.1

