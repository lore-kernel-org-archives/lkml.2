Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab2LJK71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:59:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39286 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2LJK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:59:25 -0500
Date: Mon, 10 Dec 2012 02:58:25 -0800
From: Chris Moeller <kode54@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 0/1] Input: xpad - Implement wireless controller LED
 setting and fix connect time LED setting
Message-ID: <20121210025825.197ddc25@umaro.lan>
In-Reply-To: <20121203074318.GC28682@core.coreip.homeip.net>
References: <20121130135406.38c9bdc9@umaro.lan>
	<1994333.0mnJMZMWGT@dtor-d630.eng.vmware.com>
	<20121130201329.3f8aefa0@umaro.lan>
	<20121203074318.GC28682@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2012 23:43:18 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Fri, Nov 30, 2012 at 08:13:29PM -0800, Chris Moeller wrote:
> > On Fri, 30 Nov 2012 14:30:23 -0800
> > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > 
> > > Hi Chris,
> > > 
> > > On Friday, November 30, 2012 01:54:06 PM Chris Moeller wrote:
> > > > I've submitted versions of this with prior patch sets, and this
> > > > part was never accepted, possibly because it depended on other
> > > > patches to work, or possibly because it wasn't so cleanly
> > > > organized. This time, I've split the LED setting command off
> > > > into its own static function, then call that on controller
> > > > connect and optionally on LED setting commands. The static
> > > > function does not include any locking, because locking inside
> > > > the function which receives the incoming packets deadlocks the
> > > > driver, and does not appear to be necessary anyway.
> > > > 
> > > > It also removes all traces of the original bulk out function
> > > > which was designed for the purpose of setting the LED status on
> > > > connect, as I found that it actually does not work at all. It
> > > > appears to try to send the data, but nothing actually happens
> > > > to the controller LEDs.
> > > 
> > > Attached is a reply I sent to on 7/4/11 to which you unfortunately
> > > never responded. The issue is that of force feedback (rumble) and
> > > LED share the same URB then access to that URB should be
> > > arbitrated. The attached message contains a patch that attempts
> > > to implement that arbitration, could you please try it out and
> > > see what changes are needed to make it work?
> > > 
> > > Thanks.
> > > 
> > 
> > So sorry I missed your reply. That's what I get for filtering the
> > mailing list messages past my inbox, then never following up on my
> > filter/folder set for replies to my own messages. I recall you
> > mentioned that potential race condition when I first submitted, but
> > I forgot to do anything about it. I'm glad at least one of us has
> > our stuff together. It seems to work just fine, but there may be a
> > force feedback issue with the following test program, where it
> > leaves the effect playing indefinitely after the program
> > terminates, and then the controller itself ceases to respond until
> > the module is removed and reloaded.
> 
> Just to confirm, you see this problem only with the patch being
> discussed and do not see it without it, right?
> 

Yeah, the problem only happens with this patch. Here's a silly mess
which fixes it. If you can think of a better way to handle pending
commands outside of the IRQ, be my guest. The problem seems to be that
it doesn't like sending further commands from inside the output irq
callback, so further commands are not sent, and the spinlock is left
locked or something. So it seems that it needs to be such that the
callback merely signals when the packet has completed sending, and the
actual queue must be handled outside of the irq, and somehow kindly
wait for the irq to complete for each command. Unless, you know,
there's some other way to queue up multiple commands without waiting on
each one to complete. I know bulk out doesn't work for the LED setting
command, at least. Anyway, here goes.

---
diff -urpN a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c	2012-09-30 16:47:46.000000000 -0700
+++ b/drivers/input/joystick/xpad.c	2012-12-10 02:49:27.402691386 -0800
@@ -258,23 +258,28 @@ struct usb_xpad {
 	struct usb_device *udev;	/* usb device */
 	struct usb_interface *intf;	/* usb interface */
 
-	int pad_present;
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
+	volatile bool irq_out_pending;
+
+	bool led_pending;
+	int led_command;
+
+	bool ff_pending;
+	u16 rumble_strong;
+	u16 rumble_weak;
 #endif
 
-#if defined(CONFIG_JOYSTICK_XPAD_LEDS)
+#ifdef CONFIG_JOYSTICK_XPAD_LEDS
 	struct xpad_led *led;
 #endif
 
@@ -284,6 +289,383 @@ struct usb_xpad {
 	int xtype;			/* type of xbox device */
 };
 
+#if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
+static void xpad_send_pending_output(struct usb_xpad *xpad);
+#endif
+
+#ifdef CONFIG_JOYSTICK_XPAD_FF
+static bool xpad_format_rumble(struct usb_xpad *xpad, u16 strong, u16 weak)
+{
+	switch (xpad->xtype) {
+
+	case XTYPE_XBOX:
+		xpad->odata[0] = 0x00;
+		xpad->odata[1] = 0x06;
+		xpad->odata[2] = 0x00;
+		xpad->odata[3] = strong / 256;	/* left actuator */
+		xpad->odata[4] = 0x00;
+		xpad->odata[5] = weak / 256;	/* right actuator */
+		xpad->irq_out->transfer_buffer_length = 6;
+
+		return true;
+
+	case XTYPE_XBOX360:
+		xpad->odata[0] = 0x00;
+		xpad->odata[1] = 0x08;
+		xpad->odata[2] = 0x00;
+		xpad->odata[3] = strong / 256;  /* left actuator? */
+		xpad->odata[4] = weak / 256;	/* right actuator? */
+		xpad->odata[5] = 0x00;
+		xpad->odata[6] = 0x00;
+		xpad->odata[7] = 0x00;
+		xpad->irq_out->transfer_buffer_length = 8;
+
+		return true;
+
+	case XTYPE_XBOX360W:
+		xpad->odata[0] = 0x00;
+		xpad->odata[1] = 0x01;
+		xpad->odata[2] = 0x0F;
+		xpad->odata[3] = 0xC0;
+		xpad->odata[4] = 0x00;
+		xpad->odata[5] = strong / 256;
+		xpad->odata[6] = weak / 256;
+		xpad->odata[7] = 0x00;
+		xpad->odata[8] = 0x00;
+		xpad->odata[9] = 0x00;
+		xpad->odata[10] = 0x00;
+		xpad->odata[11] = 0x00;
+		xpad->irq_out->transfer_buffer_length = 12;
+
+		return true;
+
+	default:
+		dev_dbg("%s - rumble command sent to unsupported xpad type: %d",
+			__func__, xpad->xtype);
+		return false;
+	}
+}
+
+static int xpad_play_effect(struct input_dev *dev, void *data, struct ff_effect *effect)
+{
+	struct usb_xpad *xpad = input_get_drvdata(dev);
+
+	if (effect->type == FF_RUMBLE) {
+		u16 strong = effect->u.rumble.strong_magnitude;
+		u16 weak = effect->u.rumble.weak_magnitude;
+		unsigned long flags;
+
+		xpad_send_pending_output(xpad);
+
+		spin_lock_irqsave(&xpad->odata_lock, flags);
+
+		xpad->rumble_strong = strong;
+		xpad->rumble_weak = weak;
+		xpad->ff_pending = true;
+
+		spin_unlock_irqrestore(&xpad->odata_lock, flags);
+
+		xpad_send_pending_output(xpad);
+	}
+
+	return 0;
+}
+
+static int xpad_init_ff(struct usb_xpad *xpad)
+{
+	if (xpad->xtype == XTYPE_UNKNOWN)
+		return 0;
+
+	input_set_capability(xpad->dev, EV_FF, FF_RUMBLE);
+
+	return input_ff_create_memless(xpad->dev, NULL, xpad_play_effect);
+}
+
+#else
+
+static int xpad_init_ff(struct usb_xpad *xpad)
+{
+	return 0;
+}
+
+#ifdef CONFIG_JOYSTICK_XPAD_LEDS
+static bool xpad_format_rumble(struct usb_xpad *xpad, u16 strong, u16 weak)
+{
+	return false;
+}
+#endif
+
+#endif
+
+#ifdef CONFIG_JOYSTICK_XPAD_LEDS
+#include <linux/leds.h>
+
+struct xpad_led {
+	char name[16];
+	struct led_classdev led_cdev;
+	struct usb_xpad *xpad;
+};
+
+static bool xpad_format_led_command(struct usb_xpad *xpad, int command)
+{
+	switch (xpad->xtype) {
+	case XTYPE_XBOX:
+	case XTYPE_XBOX360:
+		if (command >= 0 && command < 14) {
+			xpad->odata[0] = 0x01;
+			xpad->odata[1] = 0x03;
+			xpad->odata[2] = command;
+			xpad->irq_out->transfer_buffer_length = 3;
+			return true;
+		}
+		break;
+
+	case XTYPE_XBOX360W:
+		if (command >= 0 && command <= 16) {
+			if (command == 16)
+				command = 2 + (xpad->interface_number & 6) / 2;
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
+			return true;
+		}
+		break;
+	}
+
+	return false;
+}
+
+static void xpad_send_led_command(struct usb_xpad *xpad, int command)
+{
+	unsigned long flags;
+
+	xpad_send_pending_output(xpad);
+
+	spin_lock_irqsave(&xpad->odata_lock, flags);
+
+	xpad->led_command = command;
+	xpad->led_pending = true;
+
+	spin_unlock_irqrestore(&xpad->odata_lock, flags);
+
+	xpad_send_pending_output(xpad);
+}
+
+static void xpad_led_set(struct led_classdev *led_cdev,
+			 enum led_brightness value)
+{
+	struct xpad_led *xpad_led = container_of(led_cdev,
+						 struct xpad_led, led_cdev);
+
+	xpad_send_led_command(xpad_led->xpad, value);
+}
+
+static int xpad_led_probe(struct usb_xpad *xpad)
+{
+	static atomic_t led_seq	= ATOMIC_INIT(0);
+	long led_no;
+	struct xpad_led *led;
+	struct led_classdev *led_cdev;
+	int error;
+
+	if (xpad->xtype != XTYPE_XBOX360 && xpad->xtype != XTYPE_XBOX360W)
+		return 0;
+
+	xpad->led = led = kzalloc(sizeof(struct xpad_led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led_no = (long)atomic_inc_return(&led_seq) - 1;
+
+	snprintf(led->name, sizeof(led->name), "xpad%ld", led_no);
+	led->xpad = xpad;
+
+	led_cdev = &led->led_cdev;
+	led_cdev->name = led->name;
+	led_cdev->brightness_set = xpad_led_set;
+
+	error = led_classdev_register(&xpad->udev->dev, led_cdev);
+	if (error) {
+		kfree(led);
+		xpad->led = NULL;
+		return error;
+	}
+
+	/*
+	 * Light up the segment corresponding to controller number
+	 */
+	if (xpad->xtype == XTYPE_XBOX360)
+		xpad_send_led_command(xpad, (led_no % 4) + 2);
+
+	return 0;
+}
+
+static void xpad_led_disconnect(struct usb_xpad *xpad)
+{
+	struct xpad_led *xpad_led = xpad->led;
+
+	if (xpad_led) {
+		led_classdev_unregister(&xpad_led->led_cdev);
+		kfree(xpad_led);
+	}
+}
+
+#else
+
+static int xpad_led_probe(struct usb_xpad *xpad)
+{
+	return 0;
+}
+
+static void xpad_led_disconnect(struct usb_xpad *xpad)
+{
+}
+
+#ifdef CONFIG_JOYSTICK_XPAD_FF
+static bool xpad_format_led_command(struct usb_xpad *xpad, int command)
+{
+	return false;
+}
+#endif
+
+static void xpad_send_led_command(struct usb_xpad *xpad, int command)
+{
+}
+
+#endif
+
+#if defined(CONFIG_JOYSTICK_XPAD_FF) || defined(CONFIG_JOYSTICK_XPAD_LEDS)
+static void xpad_send_pending_output(struct usb_xpad *xpad)
+{
+	unsigned int flags;
+	while (xpad->irq_out_pending) {
+		msleep(1);
+	}
+	spin_lock_irqsave(&xpad->odata_lock, flags);
+	if (xpad->ff_pending) {
+		xpad->ff_pending = false;
+		if (xpad_format_rumble(xpad, xpad->rumble_strong, xpad->rumble_weak)) {
+			xpad->irq_out_pending = true;
+			usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
+		}
+	}
+	spin_unlock_irqrestore(&xpad->odata_lock, flags);
+	while (xpad->irq_out_pending) {
+		msleep(1);
+	}
+	spin_lock_irqsave(&xpad->odata_lock, flags);
+	if (xpad->led_pending) {
+		xpad->led_pending = false;
+		if (xpad_format_led_command(xpad, xpad->led_command)) {
+			xpad->irq_out_pending = true;
+			usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
+		}
+	}
+	spin_unlock_irqrestore(&xpad->odata_lock, flags);
+}
+
+static void xpad_irq_out(struct urb *urb)
+{
+	struct usb_xpad *xpad = urb->context;
+	int status = urb->status;
+	int retval;
+	unsigned long flags;
+
+	switch (status) {
+	case 0:
+		/* success */
+		spin_lock_irqsave(&xpad->odata_lock, flags);
+		xpad->irq_out_pending = false;
+		spin_unlock_irqrestore(&xpad->odata_lock, flags);
+
+		return;
+
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+		/* this urb is terminated, clean up */
+		dev_dbg("%s - urb shutting down with status: %d", __func__, status);
+		return;
+
+	default:
+		dev_dbg("%s - nonzero urb status received: %d", __func__, status);
+		goto exit;
+	}
+
+exit:
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
+	if (retval)
+		dev_err("%s - usb_submit_urb failed with result %d",
+		    __func__, retval);
+}
+
+static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad)
+{
+	struct usb_endpoint_descriptor *ep_irq_out;
+	int error;
+
+	if (xpad->xtype == XTYPE_UNKNOWN)
+		return 0;
+
+	spin_lock_init(&xpad->odata_lock);
+
+	xpad->odata = usb_alloc_coherent(xpad->udev, XPAD_PKT_LEN,
+					 GFP_KERNEL, &xpad->odata_dma);
+	if (!xpad->odata) {
+		error = -ENOMEM;
+		goto fail1;
+	}
+
+	xpad->irq_out = usb_alloc_urb(0, GFP_KERNEL);
+	if (!xpad->irq_out) {
+		error = -ENOMEM;
+		goto fail2;
+	}
+
+	ep_irq_out = &intf->cur_altsetting->endpoint[1].desc;
+	usb_fill_int_urb(xpad->irq_out, xpad->udev,
+			 usb_sndintpipe(xpad->udev, ep_irq_out->bEndpointAddress),
+			 xpad->odata, XPAD_PKT_LEN,
+			 xpad_irq_out, xpad, ep_irq_out->bInterval);
+	xpad->irq_out->transfer_dma = xpad->odata_dma;
+	xpad->irq_out->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+	return 0;
+
+ fail2:	usb_free_coherent(xpad->udev, XPAD_PKT_LEN, xpad->odata, xpad->odata_dma);
+ fail1:	return error;
+}
+
+static void xpad_stop_output(struct usb_xpad *xpad)
+{
+	if (xpad->xtype != XTYPE_UNKNOWN)
+		usb_kill_urb(xpad->irq_out);
+}
+
+static void xpad_deinit_output(struct usb_xpad *xpad)
+{
+	if (xpad->xtype != XTYPE_UNKNOWN) {
+		usb_free_urb(xpad->irq_out);
+		usb_free_coherent(xpad->udev, XPAD_PKT_LEN,
+				  xpad->odata, xpad->odata_dma);
+	}
+}
+#else
+static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad) { return 0; }
+static void xpad_deinit_output(struct usb_xpad *xpad) { }
+static void xpad_stop_output(struct usb_xpad *xpad) { }
+#endif
+
 /*
  *	xpad_process_packet
  *
@@ -444,13 +826,8 @@ static void xpad360_process_packet(struc
 static void xpad360w_process_packet(struct usb_xpad *xpad, u16 cmd, unsigned char *data)
 {
 	/* Presence change */
-	if (data[0] & 0x08) {
-		if (data[1] & 0x80) {
-			xpad->pad_present = 1;
-			usb_submit_urb(xpad->bulk_out, GFP_ATOMIC);
-		} else
-			xpad->pad_present = 0;
-	}
+	if ((data[0] & 0x08) && (data[1] & 0x80))
+		xpad_send_led_command(xpad, 16);
 
 	/* Valid pad data */
 	if (!(data[1] & 0x1))
@@ -502,282 +879,6 @@ exit:
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
-static void xpad_irq_out(struct urb *urb)
-{
-	struct usb_xpad *xpad = urb->context;
-	struct device *dev = &xpad->intf->dev;
-	int retval, status;
-
-	status = urb->status;
-
-	switch (status) {
-	case 0:
-		/* success */
-		return;
-
-	case -ECONNRESET:
-	case -ENOENT:
-	case -ESHUTDOWN:
-		/* this urb is terminated, clean up */
-		dev_dbg(dev, "%s - urb shutting down with status: %d\n",
-			__func__, status);
-		return;
-
-	default:
-		dev_dbg(dev, "%s - nonzero urb status received: %d\n",
-			__func__, status);
-		goto exit;
-	}
-
-exit:
-	retval = usb_submit_urb(urb, GFP_ATOMIC);
-	if (retval)
-		dev_err(dev, "%s - usb_submit_urb failed with result %d\n",
-			__func__, retval);
-}
-
-static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad)
-{
-	struct usb_endpoint_descriptor *ep_irq_out;
-	int error;
-
-	if (xpad->xtype == XTYPE_UNKNOWN)
-		return 0;
-
-	xpad->odata = usb_alloc_coherent(xpad->udev, XPAD_PKT_LEN,
-					 GFP_KERNEL, &xpad->odata_dma);
-	if (!xpad->odata) {
-		error = -ENOMEM;
-		goto fail1;
-	}
-
-	mutex_init(&xpad->odata_mutex);
-
-	xpad->irq_out = usb_alloc_urb(0, GFP_KERNEL);
-	if (!xpad->irq_out) {
-		error = -ENOMEM;
-		goto fail2;
-	}
-
-	ep_irq_out = &intf->cur_altsetting->endpoint[1].desc;
-	usb_fill_int_urb(xpad->irq_out, xpad->udev,
-			 usb_sndintpipe(xpad->udev, ep_irq_out->bEndpointAddress),
-			 xpad->odata, XPAD_PKT_LEN,
-			 xpad_irq_out, xpad, ep_irq_out->bInterval);
-	xpad->irq_out->transfer_dma = xpad->odata_dma;
-	xpad->irq_out->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-
-	return 0;
-
- fail2:	usb_free_coherent(xpad->udev, XPAD_PKT_LEN, xpad->odata, xpad->odata_dma);
- fail1:	return error;
-}
-
-static void xpad_stop_output(struct usb_xpad *xpad)
-{
-	if (xpad->xtype != XTYPE_UNKNOWN)
-		usb_kill_urb(xpad->irq_out);
-}
-
-static void xpad_deinit_output(struct usb_xpad *xpad)
-{
-	if (xpad->xtype != XTYPE_UNKNOWN) {
-		usb_free_urb(xpad->irq_out);
-		usb_free_coherent(xpad->udev, XPAD_PKT_LEN,
-				xpad->odata, xpad->odata_dma);
-	}
-}
-#else
-static int xpad_init_output(struct usb_interface *intf, struct usb_xpad *xpad) { return 0; }
-static void xpad_deinit_output(struct usb_xpad *xpad) {}
-static void xpad_stop_output(struct usb_xpad *xpad) {}
-#endif
-
-#ifdef CONFIG_JOYSTICK_XPAD_FF
-static int xpad_play_effect(struct input_dev *dev, void *data, struct ff_effect *effect)
-{
-	struct usb_xpad *xpad = input_get_drvdata(dev);
-
-	if (effect->type == FF_RUMBLE) {
-		__u16 strong = effect->u.rumble.strong_magnitude;
-		__u16 weak = effect->u.rumble.weak_magnitude;
-
-		switch (xpad->xtype) {
-
-		case XTYPE_XBOX:
-			xpad->odata[0] = 0x00;
-			xpad->odata[1] = 0x06;
-			xpad->odata[2] = 0x00;
-			xpad->odata[3] = strong / 256;	/* left actuator */
-			xpad->odata[4] = 0x00;
-			xpad->odata[5] = weak / 256;	/* right actuator */
-			xpad->irq_out->transfer_buffer_length = 6;
-
-			return usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
-
-		case XTYPE_XBOX360:
-			xpad->odata[0] = 0x00;
-			xpad->odata[1] = 0x08;
-			xpad->odata[2] = 0x00;
-			xpad->odata[3] = strong / 256;  /* left actuator? */
-			xpad->odata[4] = weak / 256;	/* right actuator? */
-			xpad->odata[5] = 0x00;
-			xpad->odata[6] = 0x00;
-			xpad->odata[7] = 0x00;
-			xpad->irq_out->transfer_buffer_length = 8;
-
-			return usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
-
-		case XTYPE_XBOX360W:
-			xpad->odata[0] = 0x00;
-			xpad->odata[1] = 0x01;
-			xpad->odata[2] = 0x0F;
-			xpad->odata[3] = 0xC0;
-			xpad->odata[4] = 0x00;
-			xpad->odata[5] = strong / 256;
-			xpad->odata[6] = weak / 256;
-			xpad->odata[7] = 0x00;
-			xpad->odata[8] = 0x00;
-			xpad->odata[9] = 0x00;
-			xpad->odata[10] = 0x00;
-			xpad->odata[11] = 0x00;
-			xpad->irq_out->transfer_buffer_length = 12;
-
-			return usb_submit_urb(xpad->irq_out, GFP_ATOMIC);
-
-		default:
-			dev_dbg(&xpad->dev->dev,
-				"%s - rumble command sent to unsupported xpad type: %d\n",
-				__func__, xpad->xtype);
-			return -1;
-		}
-	}
-
-	return 0;
-}
-
-static int xpad_init_ff(struct usb_xpad *xpad)
-{
-	if (xpad->xtype == XTYPE_UNKNOWN)
-		return 0;
-
-	input_set_capability(xpad->dev, EV_FF, FF_RUMBLE);
-
-	return input_ff_create_memless(xpad->dev, NULL, xpad_play_effect);
-}
-
-#else
-static int xpad_init_ff(struct usb_xpad *xpad) { return 0; }
-#endif
-
-#if defined(CONFIG_JOYSTICK_XPAD_LEDS)
-#include <linux/leds.h>
-
-struct xpad_led {
-	char name[16];
-	struct led_classdev led_cdev;
-	struct usb_xpad *xpad;
-};
-
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
-static void xpad_led_set(struct led_classdev *led_cdev,
-			 enum led_brightness value)
-{
-	struct xpad_led *xpad_led = container_of(led_cdev,
-						 struct xpad_led, led_cdev);
-
-	xpad_send_led_command(xpad_led->xpad, value);
-}
-
-static int xpad_led_probe(struct usb_xpad *xpad)
-{
-	static atomic_t led_seq	= ATOMIC_INIT(0);
-	long led_no;
-	struct xpad_led *led;
-	struct led_classdev *led_cdev;
-	int error;
-
-	if (xpad->xtype != XTYPE_XBOX360)
-		return 0;
-
-	xpad->led = led = kzalloc(sizeof(struct xpad_led), GFP_KERNEL);
-	if (!led)
-		return -ENOMEM;
-
-	led_no = (long)atomic_inc_return(&led_seq) - 1;
-
-	snprintf(led->name, sizeof(led->name), "xpad%ld", led_no);
-	led->xpad = xpad;
-
-	led_cdev = &led->led_cdev;
-	led_cdev->name = led->name;
-	led_cdev->brightness_set = xpad_led_set;
-
-	error = led_classdev_register(&xpad->udev->dev, led_cdev);
-	if (error) {
-		kfree(led);
-		xpad->led = NULL;
-		return error;
-	}
-
-	/*
-	 * Light up the segment corresponding to controller number
-	 */
-	xpad_send_led_command(xpad, (led_no % 4) + 2);
-
-	return 0;
-}
-
-static void xpad_led_disconnect(struct usb_xpad *xpad)
-{
-	struct xpad_led *xpad_led = xpad->led;
-
-	if (xpad_led) {
-		led_classdev_unregister(&xpad_led->led_cdev);
-		kfree(xpad_led);
-	}
-}
-#else
-static int xpad_led_probe(struct usb_xpad *xpad) { return 0; }
-static void xpad_led_disconnect(struct usb_xpad *xpad) { }
-#endif
-
-
 static int xpad_open(struct input_dev *dev)
 {
 	struct usb_xpad *xpad = input_get_drvdata(dev);
@@ -959,43 +1060,9 @@ static int xpad_probe(struct usb_interfa
 
 	usb_set_intfdata(intf, xpad);
 
-	if (xpad->xtype == XTYPE_XBOX360W) {
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
+	xpad->interface_number = intf->cur_altsetting->desc.bInterfaceNumber;
 
+	if (xpad->xtype == XTYPE_XBOX360W) {
 		/*
 		 * Submit the int URB immediately rather than waiting for open
 		 * because we get status messages from the device whether
@@ -1006,13 +1073,11 @@ static int xpad_probe(struct usb_interfa
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
@@ -1036,8 +1101,6 @@ static void xpad_disconnect(struct usb_i
 	xpad_deinit_output(xpad);
 
 	if (xpad->xtype == XTYPE_XBOX360W) {
-		usb_kill_urb(xpad->bulk_out);
-		usb_free_urb(xpad->bulk_out);
 		usb_kill_urb(xpad->irq_in);
 	}
 
@@ -1045,7 +1108,6 @@ static void xpad_disconnect(struct usb_i
 	usb_free_coherent(xpad->udev, XPAD_PKT_LEN,
 			xpad->idata, xpad->idata_dma);
 
-	kfree(xpad->bdata);
 	kfree(xpad);
 
 	usb_set_intfdata(intf, NULL);
