Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1IGRJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:09:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:14777 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab1IGQ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:59:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="45953760"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCHv4 06/19] usb: otg: gpio_vbus: Start using struct usb_otg
Date: Wed,  7 Sep 2011 10:15:59 +0300
Message-Id: <1315379772-8830-7-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct usb_otg members with OTG specific functions instead
of usb_phy members.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/usb/otg/gpio_vbus.c |   61 +++++++++++++++++++++++++-----------------
 1 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/otg/gpio_vbus.c b/drivers/usb/otg/gpio_vbus.c
index 14f48e8..548720c 100644
--- a/drivers/usb/otg/gpio_vbus.c
+++ b/drivers/usb/otg/gpio_vbus.c
@@ -31,7 +31,7 @@
  * Needs to be loaded before the UDC driver that will use it.
  */
 struct gpio_vbus_data {
-	struct usb_phy		otg;
+	struct usb_phy		xceiv;
 	struct device          *dev;
 	struct regulator       *vbus_draw;
 	int			vbus_draw_enabled;
@@ -97,7 +97,7 @@ static void gpio_vbus_work(struct work_struct *work)
 	struct gpio_vbus_mach_info *pdata = gpio_vbus->dev->platform_data;
 	int gpio;
 
-	if (!gpio_vbus->otg.gadget)
+	if (!gpio_vbus->xceiv.otg->gadget)
 		return;
 
 	/* Peripheral controllers which manage the pullup themselves won't have
@@ -107,8 +107,8 @@ static void gpio_vbus_work(struct work_struct *work)
 	 */
 	gpio = pdata->gpio_pullup;
 	if (is_vbus_powered(pdata)) {
-		gpio_vbus->otg.state = USB_PHY_STATE_B_PERIPHERAL;
-		usb_gadget_vbus_connect(gpio_vbus->otg.gadget);
+		gpio_vbus->xceiv.state = USB_PHY_STATE_B_PERIPHERAL;
+		usb_gadget_vbus_connect(gpio_vbus->xceiv.otg->gadget);
 
 		/* drawing a "unit load" is *always* OK, except for OTG */
 		set_vbus_draw(gpio_vbus, 100);
@@ -123,8 +123,8 @@ static void gpio_vbus_work(struct work_struct *work)
 
 		set_vbus_draw(gpio_vbus, 0);
 
-		usb_gadget_vbus_disconnect(gpio_vbus->otg.gadget);
-		gpio_vbus->otg.state = USB_PHY_STATE_B_IDLE;
+		usb_gadget_vbus_disconnect(gpio_vbus->xceiv.otg->gadget);
+		gpio_vbus->xceiv.state = USB_PHY_STATE_B_IDLE;
 	}
 }
 
@@ -134,12 +134,13 @@ static irqreturn_t gpio_vbus_irq(int irq, void *data)
 	struct platform_device *pdev = data;
 	struct gpio_vbus_mach_info *pdata = pdev->dev.platform_data;
 	struct gpio_vbus_data *gpio_vbus = platform_get_drvdata(pdev);
+	struct usb_otg *otg = gpio_vbus->xceiv.otg;
 
 	dev_dbg(&pdev->dev, "VBUS %s (gadget: %s)\n",
 		is_vbus_powered(pdata) ? "supplied" : "inactive",
-		gpio_vbus->otg.gadget ? gpio_vbus->otg.gadget->name : "none");
+		otg->gadget ? otg->gadget->name : "none");
 
-	if (gpio_vbus->otg.gadget)
+	if (otg->gadget)
 		schedule_work(&gpio_vbus->work);
 
 	return IRQ_HANDLED;
@@ -148,15 +149,15 @@ static irqreturn_t gpio_vbus_irq(int irq, void *data)
 /* OTG transceiver interface */
 
 /* bind/unbind the peripheral controller */
-static int gpio_vbus_set_peripheral(struct usb_phy *otg,
-				struct usb_gadget *gadget)
+static int gpio_vbus_set_peripheral(struct usb_otg *otg,
+					struct usb_gadget *gadget)
 {
 	struct gpio_vbus_data *gpio_vbus;
 	struct gpio_vbus_mach_info *pdata;
 	struct platform_device *pdev;
 	int gpio, irq;
 
-	gpio_vbus = container_of(otg, struct gpio_vbus_data, otg);
+	gpio_vbus = container_of(otg->xceiv, struct gpio_vbus_data, xceiv);
 	pdev = to_platform_device(gpio_vbus->dev);
 	pdata = gpio_vbus->dev->platform_data;
 	irq = gpio_to_irq(pdata->gpio_vbus);
@@ -173,7 +174,7 @@ static int gpio_vbus_set_peripheral(struct usb_phy *otg,
 		set_vbus_draw(gpio_vbus, 0);
 
 		usb_gadget_vbus_disconnect(otg->gadget);
-		otg->state = USB_PHY_STATE_UNDEFINED;
+		otg->xceiv->state = USB_PHY_STATE_UNDEFINED;
 
 		otg->gadget = NULL;
 		return 0;
@@ -188,23 +189,23 @@ static int gpio_vbus_set_peripheral(struct usb_phy *otg,
 }
 
 /* effective for B devices, ignored for A-peripheral */
-static int gpio_vbus_set_power(struct usb_phy *otg, unsigned mA)
+static int gpio_vbus_set_power(struct usb_phy *xceiv, unsigned mA)
 {
 	struct gpio_vbus_data *gpio_vbus;
 
-	gpio_vbus = container_of(otg, struct gpio_vbus_data, otg);
+	gpio_vbus = container_of(xceiv, struct gpio_vbus_data, xceiv);
 
-	if (otg->state == USB_PHY_STATE_B_PERIPHERAL)
+	if (xceiv->state == USB_PHY_STATE_B_PERIPHERAL)
 		set_vbus_draw(gpio_vbus, mA);
 	return 0;
 }
 
 /* for non-OTG B devices: set/clear transceiver suspend mode */
-static int gpio_vbus_set_suspend(struct usb_phy *otg, int suspend)
+static int gpio_vbus_set_suspend(struct usb_phy *xceiv, int suspend)
 {
 	struct gpio_vbus_data *gpio_vbus;
 
-	gpio_vbus = container_of(otg, struct gpio_vbus_data, otg);
+	gpio_vbus = container_of(xceiv, struct gpio_vbus_data, xceiv);
 
 	/* draw max 0 mA from vbus in suspend mode; or the previously
 	 * recorded amount of current if not suspended
@@ -212,7 +213,7 @@ static int gpio_vbus_set_suspend(struct usb_phy *otg, int suspend)
 	 * NOTE: high powered configs (mA > 100) may draw up to 2.5 mA
 	 * if they're wake-enabled ... we don't handle that yet.
 	 */
-	return gpio_vbus_set_power(otg, suspend ? 0 : gpio_vbus->mA);
+	return gpio_vbus_set_power(xceiv, suspend ? 0 : gpio_vbus->mA);
 }
 
 /* platform driver interface */
@@ -232,13 +233,21 @@ static int __init gpio_vbus_probe(struct platform_device *pdev)
 	if (!gpio_vbus)
 		return -ENOMEM;
 
+	gpio_vbus->xceiv.otg = kzalloc(sizeof(struct usb_otg), GFP_KERNEL);
+	if (!gpio_vbus->xceiv.otg) {
+		kfree(gpio_vbus);
+		return -ENOMEM;
+	}
+
 	platform_set_drvdata(pdev, gpio_vbus);
 	gpio_vbus->dev = &pdev->dev;
-	gpio_vbus->otg.label = "gpio-vbus";
-	gpio_vbus->otg.state = USB_PHY_STATE_UNDEFINED;
-	gpio_vbus->otg.set_peripheral = gpio_vbus_set_peripheral;
-	gpio_vbus->otg.set_power = gpio_vbus_set_power;
-	gpio_vbus->otg.set_suspend = gpio_vbus_set_suspend;
+	gpio_vbus->xceiv.label = "gpio-vbus";
+	gpio_vbus->xceiv.set_power = gpio_vbus_set_power;
+	gpio_vbus->xceiv.set_suspend = gpio_vbus_set_suspend;
+	gpio_vbus->xceiv.state = USB_PHY_STATE_UNDEFINED;
+
+	gpio_vbus->xceiv.otg->xceiv = &gpio_vbus->xceiv;
+	gpio_vbus->xceiv.otg->set_peripheral = gpio_vbus_set_peripheral;
 
 	err = gpio_request(gpio, "vbus_detect");
 	if (err) {
@@ -287,7 +296,7 @@ static int __init gpio_vbus_probe(struct platform_device *pdev)
 	}
 
 	/* only active when a gadget is registered */
-	err = otg_set_transceiver(&gpio_vbus->otg);
+	err = usb_set_transceiver(&gpio_vbus->xceiv);
 	if (err) {
 		dev_err(&pdev->dev, "can't register transceiver, err: %d\n",
 			err);
@@ -303,6 +312,7 @@ err_irq:
 	gpio_free(pdata->gpio_vbus);
 err_gpio:
 	platform_set_drvdata(pdev, NULL);
+	kfree(gpio_vbus->xceiv.otg);
 	kfree(gpio_vbus);
 	return err;
 }
@@ -315,13 +325,14 @@ static int __exit gpio_vbus_remove(struct platform_device *pdev)
 
 	regulator_put(gpio_vbus->vbus_draw);
 
-	otg_set_transceiver(NULL);
+	usb_set_transceiver(NULL);
 
 	free_irq(gpio_to_irq(gpio), &pdev->dev);
 	if (gpio_is_valid(pdata->gpio_pullup))
 		gpio_free(pdata->gpio_pullup);
 	gpio_free(gpio);
 	platform_set_drvdata(pdev, NULL);
+	kfree(gpio_vbus->xceiv.otg);
 	kfree(gpio_vbus);
 
 	return 0;
-- 
1.7.4.1

