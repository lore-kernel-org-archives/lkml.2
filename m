Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab2HYVbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 17:31:41 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:59193 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2HYVbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 17:31:39 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhZMANdCOVBV5qoUPGdsb2JhbABFhRqFI7AtGQEBAQEeGQ0ngk4gDxMBDxiBAgoaCgmIEa1GjiYUinSHEQObQI0P
X-IronPort-AV: E=Sophos;i="4.77,828,1336341600"; 
   d="scan'208";a="180688937"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] Input: bcm5974 - only setup button urb for TYPE1 devices
Date: Sat, 25 Aug 2012 23:36:37 +0200
Message-Id: <1345930597-5228-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The early generations with this trackpad used the separate mouse
interface to produce button events. With the introduction of the
button pads, this information was moved to the trackpad interface,
leaving the mouse interface unused. The driver is still setting up
both interfaces, which has not caused any problems - until now.

It turns out that without the CONFIG_USB_EHCI_TT_NEWSCHED option, the
driver may return an ENOSPC upon bt_urb submission, resulting in a
failure to open the device. This happens everytime on the MacBookPro
Retina (and likely on other mid-2012 models), but earlier MacBook
models seem to work fine.

This patch skips the bt_urb setup for TYPE2 devices, which arguably
should have been done in the first place.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Dmitry,

also for 3.7, since no distro seems to have hit this problem. I will
put it in my tree once the dust has settled.

Thanks,
Henrik

 drivers/input/mouse/bcm5974.c | 43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 6fddee6..9555aa5 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -656,9 +656,11 @@ static int bcm5974_start_traffic(struct bcm5974 *dev)
 		goto err_out;
 	}
 
-	error = usb_submit_urb(dev->bt_urb, GFP_KERNEL);
-	if (error)
-		goto err_reset_mode;
+	if (dev->bt_urb) {
+		error = usb_submit_urb(dev->bt_urb, GFP_KERNEL);
+		if (error)
+			goto err_reset_mode;
+	}
 
 	error = usb_submit_urb(dev->tp_urb, GFP_KERNEL);
 	if (error)
@@ -782,19 +784,23 @@ static int bcm5974_probe(struct usb_interface *iface,
 	mutex_init(&dev->pm_mutex);
 
 	/* setup urbs */
-	dev->bt_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!dev->bt_urb)
-		goto err_free_devs;
+	if (cfg->tp_type == TYPE1) {
+		dev->bt_urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (!dev->bt_urb)
+			goto err_free_devs;
+	}
 
 	dev->tp_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!dev->tp_urb)
 		goto err_free_bt_urb;
 
-	dev->bt_data = usb_alloc_coherent(dev->udev,
+	if (dev->bt_urb) {
+		dev->bt_data = usb_alloc_coherent(dev->udev,
 					  dev->cfg.bt_datalen, GFP_KERNEL,
 					  &dev->bt_urb->transfer_dma);
-	if (!dev->bt_data)
-		goto err_free_urb;
+		if (!dev->bt_data)
+			goto err_free_urb;
+	}
 
 	dev->tp_data = usb_alloc_coherent(dev->udev,
 					  dev->cfg.tp_datalen, GFP_KERNEL,
@@ -802,10 +808,11 @@ static int bcm5974_probe(struct usb_interface *iface,
 	if (!dev->tp_data)
 		goto err_free_bt_buffer;
 
-	usb_fill_int_urb(dev->bt_urb, udev,
-			 usb_rcvintpipe(udev, cfg->bt_ep),
-			 dev->bt_data, dev->cfg.bt_datalen,
-			 bcm5974_irq_button, dev, 1);
+	if (dev->bt_urb)
+		usb_fill_int_urb(dev->bt_urb, udev,
+				 usb_rcvintpipe(udev, cfg->bt_ep),
+				 dev->bt_data, dev->cfg.bt_datalen,
+				 bcm5974_irq_button, dev, 1);
 
 	usb_fill_int_urb(dev->tp_urb, udev,
 			 usb_rcvintpipe(udev, cfg->tp_ep),
@@ -843,8 +850,9 @@ err_free_buffer:
 	usb_free_coherent(dev->udev, dev->cfg.tp_datalen,
 		dev->tp_data, dev->tp_urb->transfer_dma);
 err_free_bt_buffer:
-	usb_free_coherent(dev->udev, dev->cfg.bt_datalen,
-		dev->bt_data, dev->bt_urb->transfer_dma);
+	if (dev->bt_urb)
+		usb_free_coherent(dev->udev, dev->cfg.bt_datalen,
+				  dev->bt_data, dev->bt_urb->transfer_dma);
 err_free_urb:
 	usb_free_urb(dev->tp_urb);
 err_free_bt_urb:
@@ -865,8 +873,9 @@ static void bcm5974_disconnect(struct usb_interface *iface)
 	input_unregister_device(dev->input);
 	usb_free_coherent(dev->udev, dev->cfg.tp_datalen,
 			  dev->tp_data, dev->tp_urb->transfer_dma);
-	usb_free_coherent(dev->udev, dev->cfg.bt_datalen,
-			  dev->bt_data, dev->bt_urb->transfer_dma);
+	if (dev->bt_urb)
+		usb_free_coherent(dev->udev, dev->cfg.bt_datalen,
+				  dev->bt_data, dev->bt_urb->transfer_dma);
 	usb_free_urb(dev->tp_urb);
 	usb_free_urb(dev->bt_urb);
 	kfree(dev);
-- 
1.7.12
