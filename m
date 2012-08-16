Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab2HPPfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:35:07 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:39514 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757399Ab2HPPfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:35:01 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        gregkh@linuxfoundation.org, bigeasy@linutronix.de, arnd@arndb.de,
        aletes.xgr@gmail.com, kevin.wells@nxp.com, srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop interface
Date: Thu, 16 Aug 2012 17:34:36 +0200
Message-Id: <1345131276-28982-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adjusts the LPC32xx USB gadget driver to the new udc_start /
udc_stop interface.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to v3.6-rc1

 drivers/usb/gadget/lpc32xx_udc.c |   44 +++++++++++++--------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

--- linux-2.6.orig/drivers/usb/gadget/lpc32xx_udc.c
+++ linux-2.6/drivers/usb/gadget/lpc32xx_udc.c
@@ -2599,9 +2599,8 @@ static int lpc32xx_pullup(struct usb_gad
 	return 0;
 }
 
-static int lpc32xx_start(struct usb_gadget_driver *driver,
-			 int (*bind)(struct usb_gadget *));
-static int lpc32xx_stop(struct usb_gadget_driver *driver);
+static int lpc32xx_start(struct usb_gadget *, struct usb_gadget_driver *);
+static int lpc32xx_stop(struct usb_gadget *, struct usb_gadget_driver *);
 
 static const struct usb_gadget_ops lpc32xx_udc_ops = {
 	.get_frame		= lpc32xx_get_frame,
@@ -2609,8 +2608,8 @@ static const struct usb_gadget_ops lpc32
 	.set_selfpowered	= lpc32xx_set_selfpowered,
 	.vbus_session		= lpc32xx_vbus_session,
 	.pullup			= lpc32xx_pullup,
-	.start			= lpc32xx_start,
-	.stop			= lpc32xx_stop,
+	.udc_start		= lpc32xx_start,
+	.udc_stop		= lpc32xx_stop,
 };
 
 static void nop_release(struct device *dev)
@@ -2987,14 +2986,14 @@ static irqreturn_t lpc32xx_usb_vbus_irq(
 	return IRQ_HANDLED;
 }
 
-static int lpc32xx_start(struct usb_gadget_driver *driver,
-			 int (*bind)(struct usb_gadget *))
+static int lpc32xx_start(struct usb_gadget *gadget,
+			 struct usb_gadget_driver *driver)
 {
-	struct lpc32xx_udc *udc = &controller;
-	int retval, i;
+	struct lpc32xx_udc *udc =
+		container_of(gadget, struct lpc32xx_udc, gadget);
+	int i;
 
-	if (!driver || driver->max_speed < USB_SPEED_FULL ||
-	    !bind || !driver->setup) {
+	if (!driver || driver->max_speed < USB_SPEED_FULL || !driver->setup) {
 		dev_err(udc->dev, "bad parameter.\n");
 		return -EINVAL;
 	}
@@ -3011,18 +3010,6 @@ static int lpc32xx_start(struct usb_gadg
 	udc->selfpowered = 1;
 	udc->vbus = 0;
 
-	retval = bind(&udc->gadget);
-	if (retval) {
-		dev_err(udc->dev, "bind() returned %d\n", retval);
-		udc->enabled = 0;
-		udc->selfpowered = 0;
-		udc->driver = NULL;
-		udc->gadget.dev.driver = NULL;
-		return retval;
-	}
-
-	dev_dbg(udc->dev, "bound to %s\n", driver->driver.name);
-
 	/* Force VBUS process once to check for cable insertion */
 	udc->last_vbus = udc->vbus = 0;
 	schedule_work(&udc->vbus_job);
@@ -3034,12 +3021,14 @@ static int lpc32xx_start(struct usb_gadg
 	return 0;
 }
 
-static int lpc32xx_stop(struct usb_gadget_driver *driver)
+static int lpc32xx_stop(struct usb_gadget *gadget,
+			struct usb_gadget_driver *driver)
 {
 	int i;
-	struct lpc32xx_udc *udc = &controller;
+	struct lpc32xx_udc *udc =
+		container_of(gadget, struct lpc32xx_udc, gadget);
 
-	if (!driver || driver != udc->driver || !driver->unbind)
+	if (!driver || driver != udc->driver)
 		return -EINVAL;
 
 	/* Disable USB pullup */
@@ -3049,7 +3038,6 @@ static int lpc32xx_stop(struct usb_gadge
 		disable_irq(udc->udp_irq[i]);
 
 	if (udc->clocked) {
-
 		spin_lock(&udc->lock);
 		stop_activity(udc);
 		spin_unlock(&udc->lock);
@@ -3071,11 +3059,9 @@ static int lpc32xx_stop(struct usb_gadge
 	udc->enabled = 0;
 	pullup(udc, 0);
 
-	driver->unbind(&udc->gadget);
 	udc->gadget.dev.driver = NULL;
 	udc->driver = NULL;
 
-	dev_dbg(udc->dev, "unbound from %s\n", driver->driver.name);
 	return 0;
 }
 
