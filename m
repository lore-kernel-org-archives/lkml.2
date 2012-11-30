Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab2K3Vy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 16:54:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56021 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2K3Vyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 16:54:54 -0500
Date: Fri, 30 Nov 2012 13:54:13 -0800
From: Chris Moeller <kode54@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Chris Moeller <kode54@gmail.com>
Subject: [PATCH v2 1/1] Input: xpad - Implement wireless controller LED
 setting and fix connect time LED setting
Message-ID: <20121130135413.582a5966@umaro.lan>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.13; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Moeller <kode54@gmail.com>
---

diff -urpN a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c	2012-11-30 12:33:10.604607590 -0800
+++ b/drivers/input/joystick/xpad.c	2012-11-30 12:41:19.374756212 -0800
@@ -260,13 +260,12 @@ struct usb_xpad {
 
 	int pad_present;
 
+	int interface_number;
+
 	struct urb *irq_in;		/* urb for interrupt in report */
 	unsigned char *idata;		/* input data */
 	dma_addr_t idata_dma;
 
-	struct urb *bulk_out;
-	unsigned char *bdata;
-
 #if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
 	struct urb *irq_out;		/* urb for interrupt out report */
 	unsigned char *odata;		/* output data */
@@ -427,6 +426,33 @@ static void xpad360_process_packet(struc
 }
 
 /*
+ * xpad360w_send_led_command
+ *
+ * Sends an LED state change command without any mutex locking. It is designed
+ * for private use, or by public interfaces which have already requested the
+ * appropriate locks.
+ *
+ */
+
+static void xpad360w_send_led_command(struct usb_xpad *xpad, int command)
+{
+	xpad->odata[0] = 0x00;
+	xpad->odata[1] = 0x00;
+	xpad->odata[2] = 0x08;
+	xpad->odata[3] = 0x40 + command;
+	xpad->odata[4] = 0x00;
+	xpad->odata[5] = 0x00;
+	xpad->odata[6] = 0x00;
+	xpad->odata[7] = 0x00;
+	xpad->odata[8] = 0x00;
+	xpad->odata[9] = 0x00;
+	xpad->odata[10] = 0x00;
+	xpad->odata[11] = 0x00;
+	xpad->irq_out->transfer_buffer_length = 12;
+	usb_submit_urb(xpad->irq_out, GFP_KERNEL);	
+}
+
+/*
  * xpad360w_process_packet
  *
  * Completes a request by converting the data into events for the
@@ -447,7 +473,7 @@ static void xpad360w_process_packet(stru
 	if (data[0] & 0x08) {
 		if (data[1] & 0x80) {
 			xpad->pad_present = 1;
-			usb_submit_urb(xpad->bulk_out, GFP_ATOMIC);
+			xpad360w_send_led_command(xpad, 2 + (xpad->interface_number & 6) / 2);
 		} else
 			xpad->pad_present = 0;
 	}
@@ -502,28 +528,6 @@ exit:
 			__func__, retval);
 }
 
-static void xpad_bulk_out(struct urb *urb)
-{
-	struct usb_xpad *xpad = urb->context;
-	struct device *dev = &xpad->intf->dev;
-
-	switch (urb->status) {
-	case 0:
-		/* success */
-		break;
-	case -ECONNRESET:
-	case -ENOENT:
-	case -ESHUTDOWN:
-		/* this urb is terminated, clean up */
-		dev_dbg(dev, "%s - urb shutting down with status: %d\n",
-			__func__, urb->status);
-		break;
-	default:
-		dev_dbg(dev, "%s - nonzero urb status received: %d\n",
-			__func__, urb->status);
-	}
-}
-
 #if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
 static void xpad_irq_out(struct urb *urb)
 {
@@ -704,14 +708,24 @@ struct xpad_led {
 
 static void xpad_send_led_command(struct usb_xpad *xpad, int command)
 {
-	if (command >= 0 && command < 14) {
-		mutex_lock(&xpad->odata_mutex);
-		xpad->odata[0] = 0x01;
-		xpad->odata[1] = 0x03;
-		xpad->odata[2] = command;
-		xpad->irq_out->transfer_buffer_length = 3;
-		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
-		mutex_unlock(&xpad->odata_mutex);
+	if (xpad->xtype == XTYPE_XBOX || xpad->xtype == XTYPE_XBOX360) {
+		if (command >= 0 && command < 14) {
+			mutex_lock(&xpad->odata_mutex);
+			xpad->odata[0] = 0x01;
+			xpad->odata[1] = 0x03;
+			xpad->odata[2] = command;
+			xpad->irq_out->transfer_buffer_length = 3;
+			usb_submit_urb(xpad->irq_out, GFP_KERNEL);
+			mutex_unlock(&xpad->odata_mutex);
+		}
+	} else if (xpad->xtype == XTYPE_XBOX360W) {
+		if (command >= 0 && command < 17) {
+			if (command == 16)
+				command = 2 + (xpad->interface_number & 6) / 2;
+			mutex_lock(&xpad->odata_mutex);
+			xpad360w_send_led_command(xpad, command);
+			mutex_unlock(&xpad->odata_mutex);
+		}
 	}
 }
 
@@ -732,7 +746,7 @@ static int xpad_led_probe(struct usb_xpa
 	struct led_classdev *led_cdev;
 	int error;
 
-	if (xpad->xtype != XTYPE_XBOX360)
+	if (xpad->xtype != XTYPE_XBOX360 && xpad->xtype != XTYPE_XBOX360W)
 		return 0;
 
 	xpad->led = led = kzalloc(sizeof(struct xpad_led), GFP_KERNEL);
@@ -758,7 +772,8 @@ static int xpad_led_probe(struct usb_xpa
 	/*
 	 * Light up the segment corresponding to controller number
 	 */
-	xpad_send_led_command(xpad, (led_no % 4) + 2);
+    if (xpad->xtype == XTYPE_XBOX360)
+		xpad_send_led_command(xpad, (led_no % 4) + 2);
 
 	return 0;
 }
@@ -960,42 +975,7 @@ static int xpad_probe(struct usb_interfa
 	usb_set_intfdata(intf, xpad);
 
 	if (xpad->xtype == XTYPE_XBOX360W) {
-		/*
-		 * Setup the message to set the LEDs on the
-		 * controller when it shows up
-		 */
-		xpad->bulk_out = usb_alloc_urb(0, GFP_KERNEL);
-		if (!xpad->bulk_out) {
-			error = -ENOMEM;
-			goto fail7;
-		}
-
-		xpad->bdata = kzalloc(XPAD_PKT_LEN, GFP_KERNEL);
-		if (!xpad->bdata) {
-			error = -ENOMEM;
-			goto fail8;
-		}
-
-		xpad->bdata[2] = 0x08;
-		switch (intf->cur_altsetting->desc.bInterfaceNumber) {
-		case 0:
-			xpad->bdata[3] = 0x42;
-			break;
-		case 2:
-			xpad->bdata[3] = 0x43;
-			break;
-		case 4:
-			xpad->bdata[3] = 0x44;
-			break;
-		case 6:
-			xpad->bdata[3] = 0x45;
-		}
-
-		ep_irq_in = &intf->cur_altsetting->endpoint[1].desc;
-		usb_fill_bulk_urb(xpad->bulk_out, udev,
-				usb_sndbulkpipe(udev, ep_irq_in->bEndpointAddress),
-				xpad->bdata, XPAD_PKT_LEN, xpad_bulk_out, xpad);
-
+		xpad->interface_number = intf->cur_altsetting->desc.bInterfaceNumber;
 		/*
 		 * Submit the int URB immediately rather than waiting for open
 		 * because we get status messages from the device whether
@@ -1006,13 +986,11 @@ static int xpad_probe(struct usb_interfa
 		xpad->irq_in->dev = xpad->udev;
 		error = usb_submit_urb(xpad->irq_in, GFP_KERNEL);
 		if (error)
-			goto fail9;
+			goto fail7;
 	}
 
 	return 0;
 
- fail9:	kfree(xpad->bdata);
- fail8:	usb_free_urb(xpad->bulk_out);
  fail7:	input_unregister_device(input_dev);
 	input_dev = NULL;
  fail6:	xpad_led_disconnect(xpad);
@@ -1036,8 +1014,6 @@ static void xpad_disconnect(struct usb_i
 	xpad_deinit_output(xpad);
 
 	if (xpad->xtype == XTYPE_XBOX360W) {
-		usb_kill_urb(xpad->bulk_out);
-		usb_free_urb(xpad->bulk_out);
 		usb_kill_urb(xpad->irq_in);
 	}
 
@@ -1045,7 +1021,6 @@ static void xpad_disconnect(struct usb_i
 	usb_free_coherent(xpad->udev, XPAD_PKT_LEN,
 			xpad->idata, xpad->idata_dma);
 
-	kfree(xpad->bdata);
 	kfree(xpad);
 
 	usb_set_intfdata(intf, NULL);
