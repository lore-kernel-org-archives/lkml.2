Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab2ACSug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:50:36 -0500
Received: from unserver.de ([88.198.20.135]:52745 "EHLO unserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab2ACSue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:50:34 -0500
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jan 2012 13:50:33 EST
Date: Tue, 3 Jan 2012 19:40:33 +0100
From: Jan Steinhoff <mail@jan-steinhoff.de>
To: Alessandro Rubini <rubini@cvml.unipv.it>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] input: Synaptics USB device driver
Message-ID: <20120103194033.779cb829@greyhound>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Steinhoff <mail@jan-steinhoff.de>

This patch adds a driver for Synaptics USB touchpad or pointing stick
devices. These USB devices emulate an USB mouse by default, so one can
also use the usbhid driver. However, in combination with special user
space drivers this kernel driver allows one to customize the behaviour
of the device.

An extended version of this driver with support for the cPad background
display can be found at
<http://jan-steinhoff.de/linux/synaptics-usb.html>.

Signed-off-by: Jan Steinhoff <mail@jan-steinhoff.de>
---
 drivers/input/mouse/Kconfig         |   14 +
 drivers/input/mouse/Makefile        |    1 +
 drivers/input/mouse/synaptics_usb.c |  593 +++++++++++++++++++++++++++++++++++
 drivers/input/mouse/synaptics_usb.h |   66 ++++
 4 files changed, 674 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/mouse/synaptics_usb.c
 create mode 100644 drivers/input/mouse/synaptics_usb.h

diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index 9c1e6ee..f258089 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -322,4 +322,18 @@ config MOUSE_SYNAPTICS_I2C
 	  To compile this driver as a module, choose M here: the
 	  module will be called synaptics_i2c.
 
+config MOUSE_SYNAPTICS_USB
+	tristate "Synaptics USB device support"
+	depends on USB
+	help
+	  Say Y here if you want to use a Synaptics USB touchpad or pointing stick.
+	  These Synaptics USB devices emulate an USB mouse by default, so you can
+	  also use the usbhid driver. However, in combination with special X.Org
+	  drivers this kernel driver allows you to customize the behaviour of the
+	  device. More information can be found at:
+	  <http://jan-steinhoff.de/linux/synaptics-usb.html>
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called synaptics_usb.
+
 endif
diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index 570c84a4..4718eff 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_MOUSE_PXA930_TRKBALL)	+= pxa930_trkball.o
 obj-$(CONFIG_MOUSE_RISCPC)		+= rpcmouse.o
 obj-$(CONFIG_MOUSE_SERIAL)		+= sermouse.o
 obj-$(CONFIG_MOUSE_SYNAPTICS_I2C)	+= synaptics_i2c.o
+obj-$(CONFIG_MOUSE_SYNAPTICS_USB)	+= synaptics_usb.o
 obj-$(CONFIG_MOUSE_VSXXXAA)		+= vsxxxaa.o
 
 psmouse-objs := psmouse-base.o synaptics.o
diff --git a/drivers/input/mouse/synaptics_usb.c b/drivers/input/mouse/synaptics_usb.c
new file mode 100644
index 0000000..717bfe8
--- /dev/null
+++ b/drivers/input/mouse/synaptics_usb.c
@@ -0,0 +1,593 @@
+/****
+ * USB Synaptics device driver
+ *
+ *  Copyright (c) 2002 Rob Miller (rob@inpharmatica . co . uk)
+ *  Copyright (c) 2003 Ron Lee (ron@debian.org)
+ *	cPad driver for kernel 2.4
+ *
+ *  Copyright (c) 2004 Jan Steinhoff (cpad@jan-steinhoff . de)
+ *  Copyright (c) 2004 Ron Lee (ron@debian.org)
+ *	rewritten for kernel 2.6
+ *
+ *  cPad display character device part is not included. It can be found at
+ *  http://jan-steinhoff.de/linux/synaptics-usb.html
+ *
+ * Bases on:	usb_skeleton.c v2.2 by Greg Kroah-Hartman
+ *		drivers/hid/usbhid/usbmouse.c by Vojtech Pavlik
+ *		drivers/input/mouse/synaptics.c by Peter Osterlund
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * Trademarks are the property of their respective owners.
+ */
+
+/****
+ * There are three different types of Synaptics USB devices: Touchpads,
+ * touchsticks (or trackpoints), and touchscreens. Touchpads are well supported
+ * by this driver, touchstick support has not been tested much yet, and
+ * touchscreens have not been tested at all. The only difference between pad
+ * and stick seems to be that the x and y finger positions are unsigned 13 bit
+ * integers in the first case, but are signed ones in the second case.
+ *
+ * Up to three alternate settings are possible:
+ *	setting 0: one int endpoint for relative movement (used by usbhid.ko)
+ *	setting 1: one int endpoint for absolute finger position
+ *	setting 2 (cPad only): one int endpoint for absolute finger position and
+ *		   two bulk endpoints for the display (in/out)
+ * This driver uses setting 1.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kref.h>
+#include <linux/usb.h>
+#include <linux/input.h>
+#include <linux/usb/input.h>
+#include <linux/workqueue.h>
+
+#include "synaptics_usb.h"
+
+
+/*
+ * input device code
+ */
+
+MODULE_PARM_DESC(xmin, "minimal horizontal finger position for touchpads");
+MODULE_PARM_DESC(xmax, "maximal horizontal finger position for touchpads");
+MODULE_PARM_DESC(ymin, "minimal vertical finger position for touchpads");
+MODULE_PARM_DESC(ymax, "maximal vertical finger position for touchpads");
+static int xmin = 1472;
+static int xmax = 5472;
+static int ymin = 1408;
+static int ymax = 4448;
+module_param(xmin, int, 0444);
+module_param(xmax, int, 0444);
+module_param(ymin, int, 0444);
+module_param(ymax, int, 0444);
+
+MODULE_PARM_DESC(btn_middle, "if set, cPad menu button is reported "
+			     "as a middle button");
+static int btn_middle = 1;
+module_param(btn_middle, int, 0644);
+
+static const char synusb_pad_name[] = "Synaptics USB TouchPad";
+static const char synusb_stick_name[] = "Synaptics USB Styk";
+static const char synusb_screen_name[] = "Synaptics USB TouchScreen";
+
+static const char *synusb_get_name(struct synusb *synusb)
+{
+	switch (synusb->input_type) {
+	case SYNUSB_PAD:
+		return synusb_pad_name;
+	case SYNUSB_STICK:
+		return synusb_stick_name;
+	case SYNUSB_SCREEN:
+		return synusb_screen_name;
+	}
+	return NULL;
+}
+
+/* report tool_width for touchpads */
+static void synusb_report_width(struct input_dev *idev, int pressure, int w)
+{
+	int num_fingers, tool_width;
+
+	if (pressure > 0) {
+		num_fingers = 1;
+		tool_width = 5;
+		switch (w) {
+		case 0 ... 1:
+			num_fingers = 2 + w;
+			break;
+		case 2:	                /* pen, pretend its a finger */
+			break;
+		case 4 ... 15:
+			tool_width = w;
+			break;
+		}
+	} else {
+		num_fingers = 0;
+		tool_width = 0;
+	}
+
+	input_report_abs(idev, ABS_TOOL_WIDTH, tool_width);
+
+	input_report_key(idev, BTN_TOOL_FINGER, num_fingers == 1);
+	input_report_key(idev, BTN_TOOL_DOUBLETAP, num_fingers == 2);
+	input_report_key(idev, BTN_TOOL_TRIPLETAP, num_fingers == 3);
+}
+
+/* convert signed or unsigned 13 bit number to int */
+static inline int us13_to_int(u8 high, u8 low, int has_sign)
+{
+	int res;
+
+	res = ((int)(high & 0x1f) << 8) | low;
+	if (has_sign && (high & 0x10))
+		res -= 0x2000;
+
+	return res;
+}
+
+static void synusb_input_callback(struct urb *urb)
+{
+	struct synusb *synusb = (struct synusb *)urb->context;
+	u8 *data = urb->transfer_buffer;
+	struct input_dev *idev = synusb->idev;
+	int res, x, y, pressure;
+	int is_stick = (synusb->input_type == SYNUSB_STICK) ? 1 : 0;
+
+	if (urb->status) {
+		if (synusb_urb_status_error(urb)) {
+			synusb_err(synusb, "nonzero int in status received: %d",
+				   urb->status);
+			/* an error occured, try to resubmit */
+			goto resubmit;
+		}
+
+		/* unlink urb, do not resubmit */
+		return;
+	}
+
+	pressure = data[6];
+	x = us13_to_int(data[2], data[3], is_stick);
+	y = us13_to_int(data[4], data[5], is_stick);
+
+	if (is_stick) {
+		y = -y;
+		if (pressure > 6)
+			input_report_key(idev, BTN_TOUCH, 1);
+		if (pressure < 5)
+			input_report_key(idev, BTN_TOUCH, 0);
+		input_report_key(idev, BTN_TOOL_FINGER, pressure ? 1 : 0);
+	} else {
+		if (pressure > 30)
+			input_report_key(idev, BTN_TOUCH, 1);
+		if (pressure < 25)
+			input_report_key(idev, BTN_TOUCH, 0);
+		synusb_report_width(idev, pressure, data[0] & 0x0f);
+		y = ymin + ymax - y;
+	}
+
+	if (pressure > 0) {
+		input_report_abs(idev, ABS_X, x);
+		input_report_abs(idev, ABS_Y, y);
+	}
+	input_report_abs(idev, ABS_PRESSURE, pressure);
+
+	input_report_key(idev, BTN_LEFT, data[1] & 0x04);
+	input_report_key(idev, BTN_RIGHT, data[1] & 0x01);
+	input_report_key(idev, BTN_MIDDLE, data[1] & 0x02);
+	if (synusb->has_display)
+		input_report_key(idev, btn_middle ? BTN_MIDDLE : BTN_MISC,
+				 data[1] & 0x08);
+
+	input_sync(idev);
+resubmit:
+	res = usb_submit_urb(urb, GFP_ATOMIC);
+	if (res)
+		synusb_err(synusb, "submit int in urb failed with result %d",
+			   res);
+}
+
+/* Data must always be fetched from the int endpoint, otherwise the device
+ * would reconnect to force driver reload. So this is always scheduled by probe.
+ */
+static void synusb_submit_int(struct work_struct *work)
+{
+	struct synusb *synusb = container_of(work, struct synusb, isubmit.work);
+	int res;
+
+	res = usb_submit_urb(synusb->iurb, GFP_KERNEL);
+	if (res)
+		synusb_err(synusb, "submit int in urb failed with result %d",
+			   res);
+}
+
+static int synusb_init_input(struct synusb *synusb)
+{
+	struct input_dev *idev;
+	struct usb_device *udev = synusb->udev;
+	int is_stick = (synusb->input_type == SYNUSB_STICK) ? 1 : 0;
+	int retval = -ENOMEM;
+
+	idev = input_allocate_device();
+	if (idev == NULL) {
+		synusb_err(synusb, "Can not allocate input device");
+		goto error;
+	}
+
+	__set_bit(EV_ABS, idev->evbit);
+	__set_bit(EV_KEY, idev->evbit);
+
+	if (is_stick) {
+		input_set_abs_params(idev, ABS_X, -512, 512, 0, 0);
+		input_set_abs_params(idev, ABS_Y, -512, 512, 0, 0);
+		input_set_abs_params(idev, ABS_PRESSURE, 0, 127, 0, 0);
+	} else {
+		input_set_abs_params(idev, ABS_X, xmin, xmax, 0, 0);
+		input_set_abs_params(idev, ABS_Y, ymin, ymax, 0, 0);
+		input_set_abs_params(idev, ABS_PRESSURE, 0, 255, 0, 0);
+		input_set_abs_params(idev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
+		__set_bit(BTN_TOOL_DOUBLETAP, idev->keybit);
+		__set_bit(BTN_TOOL_TRIPLETAP, idev->keybit);
+	}
+
+	__set_bit(BTN_TOUCH, idev->keybit);
+	__set_bit(BTN_TOOL_FINGER, idev->keybit);
+	__set_bit(BTN_LEFT, idev->keybit);
+	__set_bit(BTN_RIGHT, idev->keybit);
+	__set_bit(BTN_MIDDLE, idev->keybit);
+	if (synusb->has_display)
+		__set_bit(BTN_MISC, idev->keybit);
+
+	usb_make_path(udev, synusb->iphys, sizeof(synusb->iphys));
+	strlcat(synusb->iphys, "/input0", sizeof(synusb->iphys));
+	idev->phys = synusb->iphys;
+	idev->name = synusb_get_name(synusb);
+	usb_to_input_id(udev, &idev->id);
+	idev->dev.parent = &synusb->interface->dev;
+	input_set_drvdata(idev, synusb);
+
+	retval = input_register_device(idev);
+	if (retval) {
+		synusb_err(synusb, "Can not register input device");
+		goto error;
+	}
+	synusb->idev = idev;
+
+	synusb->interface->needs_remote_wakeup = 1;
+
+	return 0;
+error:
+	if (idev)
+		input_free_device(idev);
+
+	return retval;
+}
+
+
+/*
+ * initialization of usb data structures
+ */
+
+static int synusb_setup_iurb(struct synusb *synusb,
+			     struct usb_endpoint_descriptor *endpoint)
+{
+	char *buf;
+
+	if (endpoint->wMaxPacketSize < 8)
+		return 0;
+	if (synusb->iurb) {
+		synusb_warn(synusb, "Found more than one possible "
+				    "int in endpoint");
+		return 0;
+	}
+	synusb->iurb = usb_alloc_urb(0, GFP_KERNEL);
+	if (synusb->iurb == NULL)
+		return -ENOMEM;
+	buf = usb_alloc_coherent(synusb->udev, 8, GFP_ATOMIC,
+				 &synusb->iurb->transfer_dma);
+	if (buf == NULL)
+		return -ENOMEM;
+	usb_fill_int_urb(synusb->iurb, synusb->udev,
+			 usb_rcvintpipe(synusb->udev,
+					endpoint->bEndpointAddress),
+			 buf, 8, synusb_input_callback,
+			 synusb, endpoint->bInterval);
+	synusb->iurb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	return 0;
+}
+
+static inline int synusb_match_endpoint(struct usb_endpoint_descriptor *ep)
+{
+	if (((ep->bEndpointAddress & USB_DIR_IN) == USB_DIR_IN) &&
+	    ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
+			== USB_ENDPOINT_XFER_INT))
+		return 0;
+
+	return -ENODEV;
+}
+
+static int synusb_setup_endpoints(struct synusb *synusb)
+{
+	struct usb_host_interface *iface_desc;
+	struct usb_endpoint_descriptor *endpoint;
+	int int_num = synusb->interface->cur_altsetting->desc.bInterfaceNumber;
+	unsigned altsetting;
+	int i, res;
+
+	altsetting = min((unsigned) 1, synusb->interface->num_altsetting);
+	res = usb_set_interface(synusb->udev, int_num, altsetting);
+	if (res) {
+		synusb_err(synusb, "Can not set alternate setting to %i, "
+				   "error: %i", altsetting, res);
+		return res;
+	}
+
+	/* go through all endpoints */
+	iface_desc = synusb->interface->cur_altsetting;
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
+		endpoint = &iface_desc->endpoint[i].desc;
+		if (synusb_match_endpoint(endpoint) == 0) {
+			res = synusb_setup_iurb(synusb, endpoint);
+			if (res)
+				return res;
+		}
+	}
+
+	/* check whether an int in endpoint has been set up */
+	if (!synusb->iurb)
+		return -ENODEV;
+
+	return 0;
+}
+
+/* disable stick support by default, as the device becomes unusable without
+ * corresponding user space driver otherwise */
+MODULE_PARM_DESC(enable_stick, "enable trackpoint support");
+static int enable_stick;
+module_param(enable_stick, int, 0644);
+
+static int synusb_detect_type(struct synusb *synusb,
+			      const struct usb_device_id *id)
+{
+	int int_num = synusb->interface->cur_altsetting->desc.bInterfaceNumber;
+
+	synusb->has_display = 0;
+	if (id->idVendor == USB_VID_SYNAPTICS) {
+		switch (id->idProduct) {
+		case USB_DID_SYN_TS:
+			synusb->input_type = SYNUSB_SCREEN;
+			break;
+		case USB_DID_SYN_STICK:
+			synusb->input_type = SYNUSB_STICK;
+			break;
+		case USB_DID_SYN_COMP_TP:
+			if (int_num == 1)
+				synusb->input_type = SYNUSB_STICK;
+			else
+				synusb->input_type = SYNUSB_PAD;
+			break;
+		case USB_DID_SYN_CPAD:
+			synusb->has_display = 1;
+		default:
+			synusb->input_type = SYNUSB_PAD;
+		}
+	} else {
+		synusb->input_type = SYNUSB_PAD;
+	}
+
+	if ((synusb->input_type == SYNUSB_STICK) && !enable_stick)
+		return -ENODEV;
+	if (synusb->input_type == SYNUSB_SCREEN)
+		synusb_warn(synusb, "driver has not been tested "
+				    "with touchscreens!");
+
+	return 0;
+}
+
+static void synusb_free_urb(struct urb *urb)
+{
+	if (urb == NULL)
+		return;
+	usb_free_coherent(urb->dev, urb->transfer_buffer_length,
+			  urb->transfer_buffer, urb->transfer_dma);
+	usb_free_urb(urb);
+}
+
+static void synusb_delete(struct kref *kref)
+{
+	struct synusb *synusb = container_of(kref, struct synusb, kref);
+
+	synusb_free_urb(synusb->iurb);
+	if (synusb->idev)
+		input_unregister_device(synusb->idev);
+
+	usb_put_dev(synusb->udev);
+	kfree(synusb);
+}
+
+static int synusb_probe(struct usb_interface *interface,
+			const struct usb_device_id *id)
+{
+	struct synusb *synusb = NULL;
+	struct usb_device *udev = interface_to_usbdev(interface);
+	int retval = -ENOMEM;
+
+	synusb = kzalloc(sizeof(*synusb), GFP_KERNEL);
+	if (synusb == NULL) {
+		dev_err(&interface->dev, "Out of memory in synusb_probe\n");
+		goto error;
+	}
+
+	synusb->udev = usb_get_dev(udev);
+	synusb->interface = interface;
+	kref_init(&synusb->kref);
+	usb_set_intfdata(interface, synusb);
+
+	if (synusb_detect_type(synusb, id))
+		goto error;
+
+	retval = synusb_setup_endpoints(synusb);
+	if (retval) {
+		synusb_err(synusb, "Can not set up endpoints, error: %i",
+			   retval);
+		goto error;
+	}
+
+	retval = synusb_init_input(synusb);
+	if (retval)
+		goto error;
+
+	/* submit the int in urb */
+	INIT_DELAYED_WORK(&synusb->isubmit, synusb_submit_int);
+	schedule_delayed_work(&synusb->isubmit, msecs_to_jiffies(10));
+
+	return 0;
+
+error:
+	if (synusb) {
+		usb_set_intfdata(interface, NULL);
+		kref_put(&synusb->kref, synusb_delete);
+	}
+	return retval;
+}
+
+static void synusb_disconnect(struct usb_interface *interface)
+{
+	struct synusb *synusb;
+
+	synusb = usb_get_intfdata(interface);
+	usb_set_intfdata(interface, NULL);
+
+	cancel_delayed_work_sync(&synusb->isubmit);
+
+	usb_kill_urb(synusb->iurb);
+	input_unregister_device(synusb->idev);
+	synusb->idev = NULL;
+
+	kref_put(&synusb->kref, synusb_delete);
+
+	dev_info(&interface->dev, "Synaptics device disconnected\n");
+}
+
+
+/*
+ * suspend code
+ */
+
+static void synusb_draw_down(struct synusb *synusb)
+{
+	cancel_delayed_work_sync(&synusb->isubmit);
+	usb_kill_urb(synusb->iurb);
+}
+
+static int synusb_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct synusb *synusb = usb_get_intfdata(intf);
+
+	if (synusb == NULL)
+		return 0;
+
+	synusb_draw_down(synusb);
+
+	return 0;
+}
+
+static int synusb_resume(struct usb_interface *intf)
+{
+	struct synusb *synusb = usb_get_intfdata(intf);
+	int res;
+
+	res = usb_submit_urb(synusb->iurb, GFP_ATOMIC);
+	if (res)
+		synusb_err(synusb, "submit int in urb failed during resume "
+				   "with result %d", res);
+
+	return res;
+}
+
+static int synusb_pre_reset(struct usb_interface *intf)
+{
+	struct synusb *synusb = usb_get_intfdata(intf);
+
+	synusb_draw_down(synusb);
+
+	return 0;
+}
+
+static int synusb_post_reset(struct usb_interface *intf)
+{
+	struct synusb *synusb = usb_get_intfdata(intf);
+	int res;
+
+	res = usb_submit_urb(synusb->iurb, GFP_ATOMIC);
+	if (res)
+		synusb_err(synusb, "submit int in urb failed in during "
+				   "post_reset with result %d", res);
+
+	return res;
+}
+
+static int synusb_reset_resume(struct usb_interface *intf)
+{
+	struct synusb *synusb = usb_get_intfdata(intf);
+	int res;
+
+	res = usb_submit_urb(synusb->iurb, GFP_ATOMIC);
+	if (res)
+		synusb_err(synusb, "submit int in urb failed during "
+				   "reset-resume with result %d", res);
+
+	return res;
+}
+
+/* the id table is filled via sysfs, so usbhid is always the default driver */
+static struct usb_device_id synusb_idtable[] = { { } };
+MODULE_DEVICE_TABLE(usb, synusb_idtable);
+
+static struct usb_driver synusb_driver = {
+	.name =		"synaptics_usb",
+	.probe =	synusb_probe,
+	.disconnect =	synusb_disconnect,
+	.id_table =	synusb_idtable,
+	.suspend =	synusb_suspend,
+	.resume =	synusb_resume,
+	.pre_reset =	synusb_pre_reset,
+	.post_reset =	synusb_post_reset,
+	.reset_resume = synusb_reset_resume,
+	.supports_autosuspend = 1,
+};
+
+static int __init synusb_init(void)
+{
+	int result;
+
+	result = usb_register(&synusb_driver);
+	if (result)
+		err("usb_register failed. Error number %d", result);
+	else
+		pr_info(DRIVER_DESC " " DRIVER_VERSION "\n");
+
+	return result;
+}
+
+static void __exit synusb_exit(void)
+{
+	usb_deregister(&synusb_driver);
+}
+
+module_init(synusb_init);
+module_exit(synusb_exit);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/mouse/synaptics_usb.h b/drivers/input/mouse/synaptics_usb.h
new file mode 100644
index 0000000..f42a1e1
--- /dev/null
+++ b/drivers/input/mouse/synaptics_usb.h
@@ -0,0 +1,66 @@
+#ifndef _SYNAPTICS_USB_H
+#define _SYNAPTICS_USB_H
+
+#include <linux/usb.h>
+#include <linux/input.h>
+#include <linux/workqueue.h>
+
+#define DRIVER_VERSION	"v1.5"
+#define DRIVER_AUTHOR	"Rob Miller (rob@inpharmatica . co . uk), "\
+			"Ron Lee (ron@debian.org), "\
+			"Jan Steinhoff (cpad@jan-steinhoff . de)"
+#define DRIVER_DESC	"USB Synaptics device driver"
+
+/* vendor and device IDs */
+#define USB_VID_SYNAPTICS	0x06cb	/* Synaptics vendor ID */
+#define USB_DID_SYN_TP		0x0001	/* Synaptics USB TouchPad */
+#define USB_DID_SYN_INT_TP	0x0002	/* Synaptics Integrated USB TouchPad */
+#define USB_DID_SYN_CPAD	0x0003	/* Synaptics cPad */
+#define USB_DID_SYN_TS		0x0006	/* Synaptics TouchScreen */
+#define USB_DID_SYN_STICK	0x0007	/* Synaptics USB Styk */
+#define USB_DID_SYN_WP		0x0008	/* Synaptics USB WheelPad */
+#define USB_DID_SYN_COMP_TP	0x0009	/* Synaptics Composite USB TouchPad */
+#define USB_DID_SYN_WTP		0x0010	/* Synaptics Wireless TouchPad */
+#define USB_DID_SYN_DP		0x0013	/* Synaptics DisplayPad */
+
+/* structure to hold all of our device specific data */
+struct synusb {
+	struct usb_device	*udev;
+	struct usb_interface	*interface;
+	struct kref		kref;
+
+	/* characteristics of the device */
+	unsigned int		input_type:8;
+	unsigned int		buttons:8;
+	unsigned int		has_display:1;
+
+	/* input device related data structures */
+	struct input_dev	*idev;
+	char			iphys[64];
+	struct delayed_work	isubmit;
+	struct urb		*iurb;
+};
+
+/* possible values for synusb.input_type */
+#define SYNUSB_PAD		0
+#define SYNUSB_STICK		1
+#define SYNUSB_SCREEN		2
+
+static inline int synusb_urb_status_error(struct urb *urb)
+{
+	/* sync/async unlink faults aren't errors */
+	if (urb->status == -ENOENT ||
+	    urb->status == -ECONNRESET ||
+	    urb->status == -ESHUTDOWN)
+		return 0;
+	else
+		return urb->status;
+}
+
+/* helper functions for printk */
+#define synusb_err(_synusb, format, arg...)	\
+	dev_err(&(_synusb)->interface->dev, format "\n", ## arg)
+#define synusb_warn(_synusb, format, arg...)	\
+	dev_warn(&(_synusb)->interface->dev, format "\n", ## arg)
+
+#endif /* _SYNAPTICS_USB_H */
-- 
1.7.5.4

