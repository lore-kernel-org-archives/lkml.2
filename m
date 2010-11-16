Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187Ab0KPCLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 21:11:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41089 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759132Ab0KPCLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 21:11:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=nr5seBsj/4eg5detTi+fnNNEODFqz6bJDOJXM/6eDgizWBokj7m+8bcLlRk+TstK/O
         L7Iw7oNrbNRjIuMOQ8gCxLrHuGTUJEVFM9QBtTpzhBz5bJp3Zl+3x44W45pBgJPhviVI
         P672wcKth+61sniJ6mtTI6/DHEw01LWYGhjYc=
Subject: [PATCH] Input: xpad - ensure xpad->bulk_out is initialized before
	submitting urb
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Oliver Neukum <oneukum@suse.de>,
        Marko Friedemann <mfr@bmx-chemnitz.de>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain
Date: Tue, 16 Nov 2010 10:15:31 +0800
Message-Id: <1289873732.7485.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Oliver Neukum:
xpad->irq_in is currently submitted before xpad->bulk_out is allocated.
That however is a race, because the callback for irq_in can call
xpad360w_process_packet(), which will in turn submit the bulk URB.

This patch moves initialization for xpad->bulk_out earlier, so we can
ensure xpad->bulk_out is initialized before submitting urb.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/joystick/xpad.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 4875de9..56abf3d 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -921,19 +921,7 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 
 	usb_set_intfdata(intf, xpad);
 
-	/*
-	 * Submit the int URB immediately rather than waiting for open
-	 * because we get status messages from the device whether
-	 * or not any controllers are attached.  In fact, it's
-	 * exactly the message that a controller has arrived that
-	 * we're waiting for.
-	 */
 	if (xpad->xtype == XTYPE_XBOX360W) {
-		xpad->irq_in->dev = xpad->udev;
-		error = usb_submit_urb(xpad->irq_in, GFP_KERNEL);
-		if (error)
-			goto fail7;
-
 		/*
 		 * Setup the message to set the LEDs on the
 		 * controller when it shows up
@@ -941,13 +929,13 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 		xpad->bulk_out = usb_alloc_urb(0, GFP_KERNEL);
 		if (!xpad->bulk_out) {
 			error = -ENOMEM;
-			goto fail8;
+			goto fail7;
 		}
 
 		xpad->bdata = kzalloc(XPAD_PKT_LEN, GFP_KERNEL);
 		if (!xpad->bdata) {
 			error = -ENOMEM;
-			goto fail9;
+			goto fail8;
 		}
 
 		xpad->bdata[2] = 0x08;
@@ -969,12 +957,24 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 		usb_fill_bulk_urb(xpad->bulk_out, udev,
 				usb_sndbulkpipe(udev, ep_irq_in->bEndpointAddress),
 				xpad->bdata, XPAD_PKT_LEN, xpad_bulk_out, xpad);
+
+		/*
+		 * Submit the int URB immediately rather than waiting for open
+		 * because we get status messages from the device whether
+		 * or not any controllers are attached.  In fact, it's
+		 * exactly the message that a controller has arrived that
+		 * we're waiting for.
+		 */
+		xpad->irq_in->dev = xpad->udev;
+		error = usb_submit_urb(xpad->irq_in, GFP_KERNEL);
+		if (error)
+			goto fail9;
 	}
 
 	return 0;
 
- fail9:	usb_free_urb(xpad->bulk_out);
- fail8:	usb_kill_urb(xpad->irq_in);
+ fail9:	kfree(xpad->bdata);
+ fail8:	usb_free_urb(xpad->bulk_out);
  fail7:	input_unregister_device(input_dev);
 	input_dev = NULL;
  fail6:	xpad_led_disconnect(xpad);
-- 
1.7.2



