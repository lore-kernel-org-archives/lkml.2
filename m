Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031719Ab2I1TwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:52:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964988Ab2I1S5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:57:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Marc Kleine-Budde <mkl@pengutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [ 079/262] usb: chipidea: udc: add pullup fuction, needed by the uvc gadget
Date: Fri, 28 Sep 2012 11:50:08 -0700
Message-Id: <20120928183007.425925433@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit c0a48e6c75f2ac190d812bea5fc339696e434c2e upstream.

Add function to physicaly enable or disable of pullup connection on the USB-D+
line. The uvc gaget will fail, if this function is not implemented.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/udc.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -77,8 +77,7 @@ static inline int ep_to_bit(struct ci13x
 }
 
 /**
- * hw_device_state: enables/disables interrupts & starts/stops device (execute
- *                  without interruption)
+ * hw_device_state: enables/disables interrupts (execute without interruption)
  * @dma: 0 => disable, !0 => enable and set dma engine
  *
  * This function returns an error code
@@ -92,7 +91,6 @@ static int hw_device_state(struct ci13xx
 			     USBi_UI|USBi_UEI|USBi_PCI|USBi_URI|USBi_SLI);
 		hw_write(udc, OP_USBCMD, USBCMD_RS, USBCMD_RS);
 	} else {
-		hw_write(udc, OP_USBCMD, USBCMD_RS, 0);
 		hw_write(udc, OP_USBINTR, ~0, 0);
 	}
 	return 0;
@@ -1419,6 +1417,21 @@ static int ci13xxx_vbus_draw(struct usb_
 	return -ENOTSUPP;
 }
 
+/* Change Data+ pullup status
+ * this func is used by usb_gadget_connect/disconnet
+ */
+static int ci13xxx_pullup(struct usb_gadget *_gadget, int is_on)
+{
+	struct ci13xxx *ci = container_of(_gadget, struct ci13xxx, gadget);
+
+	if (is_on)
+		hw_write(ci, OP_USBCMD, USBCMD_RS, USBCMD_RS);
+	else
+		hw_write(ci, OP_USBCMD, USBCMD_RS, 0);
+
+	return 0;
+}
+
 static int ci13xxx_start(struct usb_gadget *gadget,
 			 struct usb_gadget_driver *driver);
 static int ci13xxx_stop(struct usb_gadget *gadget,
@@ -1431,6 +1444,7 @@ static int ci13xxx_stop(struct usb_gadge
 static const struct usb_gadget_ops usb_gadget_ops = {
 	.vbus_session	= ci13xxx_vbus_session,
 	.wakeup		= ci13xxx_wakeup,
+	.pullup		= ci13xxx_pullup,
 	.vbus_draw	= ci13xxx_vbus_draw,
 	.udc_start	= ci13xxx_start,
 	.udc_stop	= ci13xxx_stop,


