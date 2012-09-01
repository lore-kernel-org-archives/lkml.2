Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab2IATms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 15:42:48 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:34153 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab2IATmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 15:42:46 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An9PAG1kQlBV5qoUPGdsb2JhbABEhRyFI7BfGQEBAQEeGQ0ngiEBBScgDxMBDxAISTkKFAYBCQmIEawWjiEUinmHIwObR40R
X-IronPort-AV: E=Sophos;i="4.80,353,1344204000"; 
   d="scan'208";a="107233714"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH v3 11/20] Input: bcm5974 - only setup button urb for TYPE1 devices
Date: Sat,  1 Sep 2012 21:47:06 +0200
Message-Id: <1346528835-363-12-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346528835-363-1-git-send-email-rydberg@euromail.se>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
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
 drivers/input/mouse/bcm5974.c | 43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index d528c23..39ac9ff 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -742,9 +742,11 @@ static int bcm5974_start_traffic(struct bcm5974 *dev)
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
@@ -868,19 +870,23 @@ static int bcm5974_probe(struct usb_interface *iface,
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
@@ -888,10 +894,11 @@ static int bcm5974_probe(struct usb_interface *iface,
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
@@ -929,8 +936,9 @@ err_free_buffer:
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
@@ -951,8 +959,9 @@ static void bcm5974_disconnect(struct usb_interface *iface)
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

