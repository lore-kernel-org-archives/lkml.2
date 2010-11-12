Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0KLCrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 21:47:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38407 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab0KLCrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 21:47:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DbA0xMxkg/ut4W+PCdHK2cU66/l19RK0oHGK0tcwX1VFjZx5UnmueLHAXqQO62wZav
         vCdMcsuwC02joHqbL2fjJOwbUIT+zgk0Emg2Fer03XH9giBlgDqrjR6urnmpRI4wSD7G
         rXsnH9aGaWXsB3uw9a06P4TDm0kWwdV/mpMVQ=
Subject: [PATCH 3/3] Input: xpad - fix resource reclaim in xpad_probe error
	path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Marko Friedemann <mfr@bmx-chemnitz.de>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        linux-input@vger.kernel.org
In-Reply-To: <1289530116.20782.2.camel@mola>
References: <1289530116.20782.2.camel@mola>
Content-Type: text/plain
Date: Fri, 12 Nov 2010 10:51:21 +0800
Message-Id: <1289530281.20782.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly free the resources in error path by the reverse order of resource
allocation.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/joystick/xpad.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 26b2f2b..f581301 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -896,15 +896,15 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 
 	error = xpad_init_output(intf, xpad);
 	if (error)
-		goto fail2;
+		goto fail3;
 
 	error = xpad_init_ff(xpad);
 	if (error)
-		goto fail3;
+		goto fail4;
 
 	error = xpad_led_probe(xpad);
 	if (error)
-		goto fail3;
+		goto fail5;
 
 	ep_irq_in = &intf->cur_altsetting->endpoint[0].desc;
 	usb_fill_int_urb(xpad->irq_in, udev,
@@ -916,7 +916,7 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 
 	error = input_register_device(xpad->dev);
 	if (error)
-		goto fail4;
+		goto fail6;
 
 	usb_set_intfdata(intf, xpad);
 
@@ -931,7 +931,7 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 		xpad->irq_in->dev = xpad->udev;
 		error = usb_submit_urb(xpad->irq_in, GFP_KERNEL);
 		if (error)
-			goto fail4;
+			goto fail7;
 
 		/*
 		 * Setup the message to set the LEDs on the
@@ -940,13 +940,13 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 		xpad->bulk_out = usb_alloc_urb(0, GFP_KERNEL);
 		if (!xpad->bulk_out) {
 			error = -ENOMEM;
-			goto fail5;
+			goto fail8;
 		}
 
 		xpad->bdata = kzalloc(XPAD_PKT_LEN, GFP_KERNEL);
 		if (!xpad->bdata) {
 			error = -ENOMEM;
-			goto fail6;
+			goto fail9;
 		}
 
 		xpad->bdata[2] = 0x08;
@@ -972,10 +972,15 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 
 	return 0;
 
- fail6:	usb_free_urb(xpad->bulk_out);
- fail5:	usb_kill_urb(xpad->irq_in);
- fail4:	usb_free_urb(xpad->irq_in);
- fail3:	xpad_deinit_output(xpad);
+ fail9:	usb_free_urb(xpad->bulk_out);
+ fail8:	usb_kill_urb(xpad->irq_in);
+ fail7:	input_unregister_device(input_dev);
+	input_dev = NULL;
+ fail6:	xpad_led_disconnect(xpad);
+ fail5:	if (input_dev)
+		input_ff_destroy(input_dev);
+ fail4:	xpad_deinit_output(xpad);
+ fail3:	usb_free_urb(xpad->irq_in);
  fail2:	usb_free_coherent(udev, XPAD_PKT_LEN, xpad->idata, xpad->idata_dma);
  fail1:	input_free_device(input_dev);
 	kfree(xpad);
-- 
1.7.2



