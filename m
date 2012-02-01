Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab2BAVOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:14:42 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51158 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932631Ab2BAVKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:34 -0500
X-Sasl-enc: UQ2pUR92GnwOmGIsxMobYQbO1aYgmf075CWoS4p48NdL 1328130632
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:48 2012
Message-Id: <20120201210048.912206126@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: [57/89] usb: gadget: langwell: dont call gadgets disconnect()
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 37fd37108449d574da11aa9055c5c8afb39ff226 upstream.

UDC core will call disconnect() and unbind() for us upon the gadget
removal, so we should not do it ourselves. Otherwise, a composite
gadget will explode, for example. Others might too.

This was introduced during conversion to new style gadget in 2c7f0989
(usb: gadget: langwell: convert to new style).

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/langwell_udc.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -1522,8 +1522,7 @@ static void langwell_udc_stop(struct lan
 
 
 /* stop all USB activities */
-static void stop_activity(struct langwell_udc *dev,
-		struct usb_gadget_driver *driver)
+static void stop_activity(struct langwell_udc *dev)
 {
 	struct langwell_ep	*ep;
 	dev_dbg(&dev->pdev->dev, "---> %s()\n", __func__);
@@ -1535,9 +1534,9 @@ static void stop_activity(struct langwel
 	}
 
 	/* report disconnect; the driver is already quiesced */
-	if (driver) {
+	if (dev->driver) {
 		spin_unlock(&dev->lock);
-		driver->disconnect(&dev->gadget);
+		dev->driver->disconnect(&dev->gadget);
 		spin_lock(&dev->lock);
 	}
 
@@ -1925,11 +1924,10 @@ static int langwell_stop(struct usb_gadg
 
 	/* stop all usb activities */
 	dev->gadget.speed = USB_SPEED_UNKNOWN;
-	stop_activity(dev, driver);
-	spin_unlock_irqrestore(&dev->lock, flags);
-
 	dev->gadget.dev.driver = NULL;
 	dev->driver = NULL;
+	stop_activity(dev);
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	device_remove_file(&dev->pdev->dev, &dev_attr_function);
 
@@ -2733,7 +2731,7 @@ static void handle_usb_reset(struct lang
 		dev->bus_reset = 1;
 
 		/* reset all the queues, stop all USB activities */
-		stop_activity(dev, dev->driver);
+		stop_activity(dev);
 		dev->usb_state = USB_STATE_DEFAULT;
 	} else {
 		dev_vdbg(&dev->pdev->dev, "device controller reset\n");
@@ -2741,7 +2739,7 @@ static void handle_usb_reset(struct lang
 		langwell_udc_reset(dev);
 
 		/* reset all the queues, stop all USB activities */
-		stop_activity(dev, dev->driver);
+		stop_activity(dev);
 
 		/* reset ep0 dQH and endptctrl */
 		ep0_reset(dev);
@@ -3367,7 +3365,7 @@ static int langwell_udc_suspend(struct p
 
 	spin_lock_irq(&dev->lock);
 	/* stop all usb activities */
-	stop_activity(dev, dev->driver);
+	stop_activity(dev);
 	spin_unlock_irq(&dev->lock);
 
 	/* free dTD dma_pool and dQH */


