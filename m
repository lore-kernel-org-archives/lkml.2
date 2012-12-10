Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2LJNZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:25:05 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:50365 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2LJNZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:25:02 -0500
Date: Mon, 10 Dec 2012 05:24:02 -0800
From: Chris Moeller <kode54@gmail.com>
To: Chris Moeller <kode54@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 0/1] Input: xpad - Implement wireless controller LED
 setting and fix connect time LED setting
Message-ID: <20121210052402.3ddb0020@umaro.lan>
In-Reply-To: <20121210044354.5d562079@umaro.lan>
References: <20121130135406.38c9bdc9@umaro.lan>
	<1994333.0mnJMZMWGT@dtor-d630.eng.vmware.com>
	<20121130201329.3f8aefa0@umaro.lan>
	<20121203074318.GC28682@core.coreip.homeip.net>
	<20121210025825.197ddc25@umaro.lan>
	<20121210044354.5d562079@umaro.lan>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012 04:43:54 -0800
Chris Moeller <kode54@gmail.com> wrote:

> On Mon, 10 Dec 2012 02:58:25 -0800
> Chris Moeller <kode54@gmail.com> wrote:
> 
> > On Sun, 2 Dec 2012 23:43:18 -0800
> > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > 
> > > On Fri, Nov 30, 2012 at 08:13:29PM -0800, Chris Moeller wrote:
> > > > On Fri, 30 Nov 2012 14:30:23 -0800
> > > > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > > 
> > > > > Hi Chris,
> > > > > 
> > > > > On Friday, November 30, 2012 01:54:06 PM Chris Moeller wrote:
> > > > > > I've submitted versions of this with prior patch sets, and
> > > > > > this part was never accepted, possibly because it depended
> > > > > > on other patches to work, or possibly because it wasn't so
> > > > > > cleanly organized. This time, I've split the LED setting
> > > > > > command off into its own static function, then call that on
> > > > > > controller connect and optionally on LED setting commands.
> > > > > > The static function does not include any locking, because
> > > > > > locking inside the function which receives the incoming
> > > > > > packets deadlocks the driver, and does not appear to be
> > > > > > necessary anyway.
> > > > > > 
> > > > > > It also removes all traces of the original bulk out function
> > > > > > which was designed for the purpose of setting the LED status
> > > > > > on connect, as I found that it actually does not work at
> > > > > > all. It appears to try to send the data, but nothing
> > > > > > actually happens to the controller LEDs.
> > > > > 
> > > > > Attached is a reply I sent to on 7/4/11 to which you
> > > > > unfortunately never responded. The issue is that of force
> > > > > feedback (rumble) and LED share the same URB then access to
> > > > > that URB should be arbitrated. The attached message contains a
> > > > > patch that attempts to implement that arbitration, could you
> > > > > please try it out and see what changes are needed to make it
> > > > > work?
> > > > > 
> > > > > Thanks.
> > > > > 
> > > > 
> > > > So sorry I missed your reply. That's what I get for filtering
> > > > the mailing list messages past my inbox, then never following
> > > > up on my filter/folder set for replies to my own messages. I
> > > > recall you mentioned that potential race condition when I first
> > > > submitted, but I forgot to do anything about it. I'm glad at
> > > > least one of us has our stuff together. It seems to work just
> > > > fine, but there may be a force feedback issue with the
> > > > following test program, where it leaves the effect playing
> > > > indefinitely after the program terminates, and then the
> > > > controller itself ceases to respond until the module is removed
> > > > and reloaded.
> > > 
> > > Just to confirm, you see this problem only with the patch being
> > > discussed and do not see it without it, right?
> > > 
> > 
> > Yeah, the problem only happens with this patch. Here's a silly mess
> > which fixes it. If you can think of a better way to handle pending
> > commands outside of the IRQ, be my guest. The problem seems to be
> > that it doesn't like sending further commands from inside the
> > output irq callback, so further commands are not sent, and the
> > spinlock is left locked or something. So it seems that it needs to
> > be such that the callback merely signals when the packet has
> > completed sending, and the actual queue must be handled outside of
> > the irq, and somehow kindly wait for the irq to complete for each
> > command. Unless, you know, there's some other way to queue up
> > multiple commands without waiting on each one to complete. I know
> > bulk out doesn't work for the LED setting command, at least.
> > Anyway, here goes.
> 
> Disregard this patch, it locks up frequently. I'm working on something
> else instead.

Okay, this one seems to work. LED setting doesn't lock up like the old
mutex regulated LED setting mode, and I can successfully power off and
on the controller while that previously posted test program is still
running on the event device, without the LED setting clobbering the
rumble packets, and vice versa.

---
diff -urpN a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c	2012-12-10 03:59:14.407669714 -0800
+++ b/drivers/input/joystick/xpad.c	2012-12-10 05:13:22.835479280 -0800
@@ -259,19 +259,17 @@ struct usb_xpad {
 	struct usb_interface *intf;	/* usb interface */
 
 	int pad_present;
+	int interface_number;
 
 	struct urb *irq_in;		/* urb for interrupt in report */
 	unsigned char *idata;		/* input data */
 	dma_addr_t idata_dma;
 
-	struct urb *bulk_out;
-	unsigned char *bdata;
-
 #if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
 	struct urb *irq_out;		/* urb for interrupt out report */
 	unsigned char *odata;		/* output data */
 	dma_addr_t odata_dma;
-	struct mutex odata_mutex;
+	spinlock_t odata_lock;
 #endif
 
 #if defined(CONFIG_JOYSTICK_XPAD_LEDS)
@@ -441,13 +439,15 @@ static void xpad360_process_packet(struc
  *
  */
 
+static void xpad_send_led_command(struct usb_xpad *xpad, int command);
+
 static void xpad360w_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *data)
 {
 	/* Presence change */
 	if (data[0] & 0x08) {
 		if (data[1] & 0x80) {
 			xpad->pad_present = 1;
-			usb_submit_urb(xpad->bulk_out, GFP_ATOMIC);
+			xpad_send_led_command(xpad, 16);
 		} else
 			xpad->pad_present = 0;
 	}
@@ -502,29 +502,6 @@ exit:
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
-#if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
 static void xpad_irq_out(struct urb *urb)
 {
 	struct usb_xpad *xpad = urb->context;
@@ -574,7 +551,7 @@ static int xpad_init_output(struct usb_i
 		goto fail1;
 	}
 
-	mutex_init(&xpad->odata_mutex);
+	spin_lock_init(&xpad->odata_lock);
 
 	xpad->irq_out = usb_alloc_urb(0, GFP_KERNEL);
 	if (!xpad->irq_out) {
@@ -610,15 +587,12 @@ static void xpad_deinit_output(struct us
 				xpad->odata, xpad->odata_dma);
 	}
 }
-#else
-static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad) { return 0; }
-static void xpad_deinit_output(struct usb_xpad *xpad) {}
-static void xpad_stop_output(struct usb_xpad *xpad) {}
-#endif
 
 #ifdef CONFIG_JOYSTICK_XPAD_FF
 static int xpad_play_effect(struct input_dev *dev, void *data, struct ff_effect *effect)
 {
+	int retval;
+	unsigned long flags;
 	struct usb_xpad *xpad = input_get_drvdata(dev);
 
 	if (effect->type == FF_RUMBLE) {
@@ -628,6 +602,7 @@ static int xpad_play_effect(struct input
 		switch (xpad->xtype) {
 
 		case XTYPE_XBOX:
+			spin_lock_irqsave(&xpad->odata_lock, flags);
 			xpad->odata[0] = 0x00;
 			xpad->odata[1] = 0x06;
 			xpad->odata[2] = 0x00;
@@ -636,9 +611,13 @@ static int xpad_play_effect(struct input
 			xpad->odata[5] = weak / 256;	/* right actuator */
 			xpad->irq_out->transfer_buffer_length = 6;
 
-			return usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
+			retval = usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
+			spin_unlock_irqrestore(&xpad->odata_lock, flags);
+
+			return retval;
 
 		case XTYPE_XBOX360:
+			spin_lock_irqsave(&xpad->odata_lock, flags);
 			xpad->odata[0] = 0x00;
 			xpad->odata[1] = 0x08;
 			xpad->odata[2] = 0x00;
@@ -649,9 +628,13 @@ static int xpad_play_effect(struct input
 			xpad->odata[7] = 0x00;
 			xpad->irq_out->transfer_buffer_length = 8;
 
-			return usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
+			retval = usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
+			spin_unlock_irqrestore(&xpad->odata_lock, flags);
+
+			return retval;
 
 		case XTYPE_XBOX360W:
+			spin_lock_irqsave(&xpad->odata_lock, flags);
 			xpad->odata[0] = 0x00;
 			xpad->odata[1] = 0x01;
 			xpad->odata[2] = 0x0F;
@@ -666,7 +649,10 @@ static int xpad_play_effect(struct input
 			xpad->odata[11] = 0x00;
 			xpad->irq_out->transfer_buffer_length = 12;
 
-			return usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
+			retval = usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
+			spin_unlock_irqrestore(&xpad->odata_lock, flags);
+
+			return retval;
 
 		default:
 			dev_dbg(&xpad->dev->dev,
@@ -693,6 +679,43 @@ static int xpad_init_ff(struct usb_xpad
 static int xpad_init_ff(struct usb_xpad *xpad) { return 0; }
 #endif
 
+static void xpad_send_led_command(struct usb_xpad *xpad, int command)
+{
+	unsigned long flags;
+	if (xpad->xtype == XTYPE_XBOX360) {
+		if (command >= 0 && command < 14) {
+			spin_lock_irqsave(&xpad->odata_lock, flags);
+			xpad->odata[0] = 0x01;
+			xpad->odata[1] = 0x03;
+			xpad->odata[2] = command;
+			xpad->irq_out->transfer_buffer_length = 3;
+			usb_submit_urb(xpad->irq_out, GFP_KERNEL);
+			spin_unlock_irqrestore(&xpad->odata_lock, flags);
+		}
+	} else if (xpad->xtype == XTYPE_XBOX360W) {
+		if (command >= 0 && command < 17) {
+			if (command == 16)
+				command = 0x02 + xpad->interface_number;
+			spin_lock_irqsave(&xpad->odata_lock, flags);
+			xpad->odata[0] = 0x00;
+			xpad->odata[1] = 0x00;
+			xpad->odata[2] = 0x08;
+			xpad->odata[3] = 0x40 + command;
+			xpad->odata[4] = 0x00;
+			xpad->odata[5] = 0x00;
+			xpad->odata[6] = 0x00;
+			xpad->odata[7] = 0x00;
+			xpad->odata[8] = 0x00;
+			xpad->odata[9] = 0x00;
+			xpad->odata[10] = 0x00;
+			xpad->odata[11] = 0x00;
+			xpad->irq_out->transfer_buffer_length = 12;
+			usb_submit_urb(xpad->irq_out, GFP_KERNEL);
+			spin_unlock_irqrestore(&xpad->odata_lock, flags);
+		}
+	}
+}
+
 #if defined(CONFIG_JOYSTICK_XPAD_LEDS)
 #include <linux/leds.h>
 
@@ -702,19 +725,6 @@ struct xpad_led {
 	struct usb_xpad *xpad;
 };
 
-static void xpad_send_led_command(struct usb_xpad *xpad, int command)
-{
-	if (command >= 0 && command < 14) {
-		mutex_lock(&xpad->odata_mutex);
-		xpad->odata[0] = 0x01;
-		xpad->odata[1] = 0x03;
-		xpad->odata[2] = command;
-		xpad->irq_out->transfer_buffer_length = 3;
-		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
-		mutex_unlock(&xpad->odata_mutex);
-	}
-}
-
 static void xpad_led_set(struct led_classdev *led_cdev,
 			 enum led_brightness value)
 {
@@ -732,7 +742,7 @@ static int xpad_led_probe(struct usb_xpa
 	struct led_classdev *led_cdev;
 	int error;
 
-	if (xpad->xtype != XTYPE_XBOX360)
+	if (xpad->xtype != XTYPE_XBOX360 && xpad->xtype != XTYPE_XBOX360W)
 		return 0;
 
 	xpad->led = led = kzalloc(sizeof(struct xpad_led), GFP_KERNEL);
@@ -758,7 +768,8 @@ static int xpad_led_probe(struct usb_xpa
 	/*
 	 * Light up the segment corresponding to controller number
 	 */
-	xpad_send_led_command(xpad, (led_no % 4) + 2);
+	if (xpad->xtype == XTYPE_XBOX360)
+		xpad_send_led_command(xpad, (led_no % 4) + 2);
 
 	return 0;
 }
@@ -960,42 +971,7 @@ static int xpad_probe(struct usb_interfa
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
+		xpad->interface_number = intf->cur_altsetting->desc.bInterfaceNumber / 2;
 		/*
 		 * Submit the int URB immediately rather than waiting for open
 		 * because we get status messages from the device whether
@@ -1006,13 +982,11 @@ static int xpad_probe(struct usb_interfa
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
@@ -1036,8 +1010,6 @@ static void xpad_disconnect(struct usb_i
 	xpad_deinit_output(xpad);
 
 	if (xpad->xtype == XTYPE_XBOX360W) {
-		usb_kill_urb(xpad->bulk_out);
-		usb_free_urb(xpad->bulk_out);
 		usb_kill_urb(xpad->irq_in);
 	}
 
@@ -1045,9 +1017,6 @@ static void xpad_disconnect(struct usb_i
 	usb_free_coherent(xpad->udev, XPAD_PKT_LEN,
 			xpad->idata, xpad->idata_dma);
 
-	kfree(xpad->bdata);
-	kfree(xpad);
-
 	usb_set_intfdata(intf, NULL);
 }
 
