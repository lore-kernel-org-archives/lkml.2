Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab2FCIqC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 04:46:02 -0400
Received: from www84.your-server.de ([213.133.104.84]:44047 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2FCIp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 04:45:58 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de,
        alan@lxorguk.ukuu.org.uk
Cc: thomas.braunstorfinger@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH] add new NRP power meter USB device driver
Date: Sun,  3 Jun 2012 10:46:12 +0200
Message-Id: <1338713172-7496-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This driver supports all of the Rohde&Schwarz RF Power Meter NRP Sensors. These
sensors are intelligent standalone instruments that communicate via USB.

A power meter is a device for analyzing the RF power output level of an
electrical device, similar to an oscilloscope.

The Power Meter Sensors will be used in a wide range of environements, like

- Manufacturing (e.g. air planes and smart phones)
- Radio and TV broadcasting
- Mobile communications
- Engeeniering
- Science Labs
- Education

The NRP Power Meters support the following measurements:

 - Dynamic range: up to 90 dB (sensor dependent)
 - Level range: -67 dBm to +45 dBm (sensor dependent)
 - Frequency range: DC to 67 GHz (sensor dependent)
 - Measurement speed: 1500 measurements per second in the buffered mode
 - Linearity uncertainty: 0.007 dB
 - Precise average power measurements irrespective of modulation and bandwidth
 - Flexible measurements on up to 128 time slots per power sensor
 - S parameter correction of components between sensor and test object

The device will be controlled by a SCPI like interface.
(https://en.wikipedia.org/wiki/Standard_Commands_for_Programmable_Instruments)

The patch is against linux 3.5.0
(commit 829f51dbd825256197fb2a89705d42ad83f958ef)

The source is checked with checkpatch.pl and has no errors. Only 10
"line over 80 characters" warnings are left. I see no reason to satisfy this
boring punch card limit for this lines, since it will make the source noisier.

make C=1 is quiet.

ChangeLog:

2012-06-03 Fixes suggested by Oliver Neukum
           kicked out NRPZ_GETSENSORINFO suggest by Greg KH
2012-06-02 Fixes suggested by Alan Cox, Oliver Neukum and Greg KH
2012-05-29 First public release under GPL
2012-05-18 V4.0 - revamp for kernel inclusion
2007-12-07 V3.0 - Rewritten, multi urbs for read and write
2007-05-15 V2.0 - Ported the driver to kernel 2.6, mostly rewritten
2001-05-01 V0.1 - first version

Regards,
Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/misc/Kconfig       |   12 +
 drivers/usb/misc/Makefile      |    1 +
 drivers/usb/misc/nrpz.c        | 1012 ++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/nrpzmodule.h |   47 ++
 4 files changed, 1072 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/misc/nrpz.c
 create mode 100644 include/linux/usb/nrpzmodule.h

diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index 1bfcd02..2c55d5f 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -244,3 +244,15 @@ config USB_YUREX
 	  To compile this driver as a module, choose M here: the
 	  module will be called yurex.
 
+config USB_NRPZ
+	tristate "USB NRPZ power sensor driver support"
+	depends on USB
+	help
+	  This driver supports the Rohde&Schwarz NRP RF Power Meter Sensors.
+
+	  These sensors are intelligent standalone instruments that
+	  communicate via USB and provide a wide range of measurements.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called nrpz.
+
diff --git a/drivers/usb/misc/Makefile b/drivers/usb/misc/Makefile
index 796ce7e..9a0364c 100644
--- a/drivers/usb/misc/Makefile
+++ b/drivers/usb/misc/Makefile
@@ -25,5 +25,6 @@ obj-$(CONFIG_USB_TRANCEVIBRATOR)	+= trancevibrator.o
 obj-$(CONFIG_USB_USS720)		+= uss720.o
 obj-$(CONFIG_USB_SEVSEG)		+= usbsevseg.o
 obj-$(CONFIG_USB_YUREX)			+= yurex.o
+obj-$(CONFIG_USB_NRPZ)			+= nrpz.o
 
 obj-$(CONFIG_USB_SISUSBVGA)		+= sisusbvga/
diff --git a/drivers/usb/misc/nrpz.c b/drivers/usb/misc/nrpz.c
new file mode 100644
index 0000000..777f8fb
--- /dev/null
+++ b/drivers/usb/misc/nrpz.c
@@ -0,0 +1,1012 @@
+/*
+ * Rohde & Schwarz USB NRP Zxx power meter kernel module driver
+ *
+ * Version: 4.0
+ *
+ * Copyright (c) 2012 by Rohde & Scharz GmbH & Co. KG
+ *  written by Stefani Seibold <stefani@seibold.net>
+ *
+ * This driver supports the RF Power Meter R&S ® NRP Sensors. These
+ * sensors are intelligent standalone instruments that communicate via USB
+ * and support the following measurements:
+ *
+ * - Dynamic range: up to 90 dB (sensor dependent)
+ * - Level range: -67 dBm to +45 dBm (sensor dependent)
+ * - Frequency range: DC to 67 GHz (sensor dependent)
+ * - Measurement speed: 1500 measurements per second in the buffered mode
+ * - Linearity uncertainty: 0.007 dB
+ * - Precise average power measurements irrespective of modulation and bandwidth
+ * - Flexible measurements on up to 128 time slots per power sensor
+ * - S parameter correction of components between sensor and test object
+ *
+ * History:
+ *
+ * 2012-05-18 - v4.0 revamp for kernel inclusion
+ * 2007-12-07 - v3.0 Rewritten, multi urbs for read and write
+ * 2007-05-15 - v2.0 Ported the driver to kernel 2.6, mostly rewritten
+ * 2001-05-01 - v0.1 first version
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ *
+ */
+
+/*
+ * Internal format of the NRPZ USB messages:
+ *
+ *  Byte 0:	Signature
+ *  Byte 1:	Error Code
+ *  Byte 2/3:	Array Index
+ *		or State (Byte 2)
+ *		or Group Number (Byte 2) / Param Number (Byte 3)
+ *  Byte 4-15:	Data depening on signature type (Byte 0):
+ *		floats, bit fields and integer are 32 bit
+ *
+ * Signature types:
+ *  'E':	single float value
+ *  'e':	single value
+ *  'A':	float array
+ *  'P':	auxiliary or peak float array
+ *  'a':	interim float array
+ *  'p':	interim auxiliary or peak float array
+ *  'F':	feature bit field
+ *  'U':	float parameter (32 bit)
+ *  'V':	bit field parameter (32 bit)
+ *  'W':	integer parameter (32 bit)
+ *  'T':	string data
+ *  'R':	receipt data (string or binary data)
+ *  'X':	internal error
+ *  'Z':	current state (Byte 2)
+ *  'z':	life sign package
+ *  'L':	float value (32 bit)
+ *  'M':	bit field value (32 bit)
+ *  'N':	long value (32 bit)
+ *  'B':	binary data
+ *
+ * State values:
+ *   0:		trigger idle
+ *   1:		trigger reserved
+ *   2:		wait for trigger
+ *   3:		trigger measuring
+ *
+ * Communication in direction from host to the device are mostly like SCPI.
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/signal.h>
+#include <linux/errno.h>
+#include <linux/poll.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/fcntl.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/usb.h>
+#include <linux/version.h>
+#include <linux/kref.h>
+#include <linux/bitops.h>
+#include <linux/mutex.h>
+
+#include <linux/usb/nrpzmodule.h>
+
+/* Version Information */
+#define DRIVER_VERSION	"v4.02"
+#define DRIVER_AUTHOR	"Stefani Seibold <stefani@seibold.net>"
+#define DRIVER_DESC	"Rohde&Schwarz NRP-Zxx USB power meter driver"
+
+/* Get a minor range for your devices from the usb maintainer */
+#define NRPZ_MINOR_BASE		192
+
+#define USB_RS_VENDOR_ID	0x0aad
+#define USB_NRP_PRODUCT_ID	0x0002
+#define USB_NRPZ21_PRODUCT_ID	0x0003
+#define USB_NRPFU_PRODUCT_ID	0x0004
+#define USB_FSHZ1_PRODUCT_ID	0x000b
+#define USB_NRPZ11_PRODUCT_ID	0x000c
+#define USB_NRPZ22_PRODUCT_ID	0x0013
+#define USB_NRPZ23_PRODUCT_ID	0x0014
+#define USB_NRPZ24_PRODUCT_ID	0x0015
+#define USB_NRPZ51_PRODUCT_ID	0x0016
+#define USB_NRPZ52_PRODUCT_ID	0x0017
+#define USB_NRPZ55_PRODUCT_ID	0x0018
+#define USB_NRPZ56_PRODUCT_ID	0x0019
+#define USB_FSHZ18_PRODUCT_ID	0x001a
+#define USB_NRPZ91_PRODUCT_ID	0x0021
+#define USB_NRPZ81_PRODUCT_ID	0x0023
+#define USB_NRPZ31_PRODUCT_ID	0x002c
+#define USB_NRPZ37_PRODUCT_ID	0x002d
+#define USB_NRPZ96_PRODUCT_ID	0x002e
+#define USB_NRPZ27_PRODUCT_ID	0x002f
+#define USB_NRPZ28_PRODUCT_ID	0x0051
+#define USB_NRPZ98_PRODUCT_ID	0x0052
+#define USB_NRPZ92_PRODUCT_ID	0x0062
+#define USB_NRPZ57_PRODUCT_ID	0x0070
+#define USB_NRPZ85_PRODUCT_ID	0x0083
+#define USB_NRPC40_PRODUCT_ID	0x008F
+#define USB_NRPC50_PRODUCT_ID	0x0090
+#define USB_NRPZ86_PRODUCT_ID	0x0095
+#define USB_NRPZ41_PRODUCT_ID	0x0096
+#define USB_NRPZ61_PRODUCT_ID	0x0097
+#define USB_NRPZ71_PRODUCT_ID	0x0098
+#define USB_NRPZ32_PRODUCT_ID	0x009A
+#define USB_NRPZ211_PRODUCT_ID	0x00A6
+#define USB_NRPZ221_PRODUCT_ID	0x00A7
+#define USB_NRPZ58_PRODUCT_ID	0x00A8
+#define USB_NRPC33_PRODUCT_ID	0x00B6
+#define USB_NRPC18_PRODUCT_ID	0x00BF
+
+/* table of devices that work with this driver */
+static struct usb_device_id nrpz_table[] = {
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRP_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ21_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPFU_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_FSHZ1_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ11_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ22_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ23_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ24_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ51_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ52_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ55_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ56_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ57_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_FSHZ18_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ91_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ81_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ31_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ37_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ96_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ27_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ28_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ98_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ92_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ85_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPC40_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPC50_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ86_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ41_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ61_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ71_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ32_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ211_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ221_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPZ58_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPC33_PRODUCT_ID)},
+	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRPC18_PRODUCT_ID)},
+	{} /* Terminating entry */
+};
+MODULE_DEVICE_TABLE(usb, nrpz_table);
+
+struct usb_nrpz {
+	struct usb_interface *intf;	/* usb interface */
+
+	size_t in_size;			/* size of the receive buffer */
+	size_t out_size;		/* size of the send buffer */
+	__u8 in_epAddr;			/* address of the bulk in endpoint */
+	__u8 out_epAddr;		/* address of the bulk out endpoint */
+	bool in_use;			/* in use flag */
+	bool connected;			/* true if device is still connected */
+
+	struct kref kref;
+	wait_queue_head_t wq;
+
+	struct usb_anchor out_running;	/* list of in use output buffers */
+	struct list_head out_avail;	/* list of available output buffers */
+	spinlock_t write_lock;		/* spinlock for transmit list */
+	struct mutex write_mutex;	/* exclusive write data semaphore */
+
+	struct usb_anchor in_running;	/* list of in use input buffers */
+	struct list_head in_avail;	/* list of available input buffers */
+	spinlock_t read_lock;		/* spinlock for receive list */
+	struct mutex read_mutex;	/* exclusive read data semaphore */
+
+	struct urb out_urbs[64];	/* array of urb's for output */
+	struct urb in_urbs[64];		/* array of urb's for input */
+};
+
+/* forward declaration */
+static struct usb_driver nrpz_driver;
+
+static inline void urb_list_add(spinlock_t *lock, struct urb *urb,
+				struct list_head *head)
+{
+	spin_lock_irq(lock);
+	list_add(&urb->urb_list, head);
+	spin_unlock_irq(lock);
+}
+
+static inline void urb_list_add_tail(spinlock_t *lock, struct urb *urb,
+				struct list_head *head)
+{
+	spin_lock_irq(lock);
+	list_add_tail(&urb->urb_list, head);
+	spin_unlock_irq(lock);
+}
+
+static struct urb *urb_list_get(spinlock_t *lock, struct list_head *head)
+{
+	struct list_head *p;
+
+	spin_lock_irq(lock);
+
+	if (list_empty(head)) {
+		spin_unlock_irq(lock);
+		return NULL;
+	}
+
+	p = head->next;
+	list_del(p);
+	spin_unlock_irq(lock);
+
+	return list_entry(p, struct urb, urb_list);
+}
+
+/*
+ * bulks_release
+ *
+ * release all allocated urb's and and usb buffers
+ */
+static void bulks_release(struct urb *urb, unsigned n, int buf_size)
+{
+	while (n--) {
+		if (urb->transfer_buffer)
+			usb_free_coherent(urb->dev,
+				buf_size,
+				urb->transfer_buffer,
+				urb->transfer_dma);
+		++urb;
+	}
+}
+
+/*
+ * bulks_init
+ *
+ * preallocate urb's and and usb buffers
+ */
+static int bulks_init(struct usb_nrpz *dev,
+		struct usb_device *udev,
+		struct urb *urb,
+		unsigned n,
+		unsigned int pipe,
+		int buf_size,
+		usb_complete_t complete_fn)
+{
+	void *buffer;
+
+	while (n--) {
+		usb_init_urb(urb);
+
+		buffer = usb_alloc_coherent(udev,
+				buf_size,
+				GFP_KERNEL,
+				&urb->transfer_dma);
+		if (!buffer)
+			return -ENOMEM;
+
+		/* set up our read urb */
+		usb_fill_bulk_urb(urb,
+			udev,
+			pipe,
+			buffer,
+			buf_size,
+			complete_fn,
+			dev);
+
+		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+		++urb;
+	}
+	return 0;
+}
+
+static int bulks_in_submit(struct usb_nrpz *dev, gfp_t gfp)
+{
+	int ret;
+	unsigned i;
+
+	for (i = 0; i != ARRAY_SIZE(dev->in_urbs); ++i) {
+		usb_anchor_urb(&dev->in_urbs[i], &dev->in_running);
+
+		ret = usb_submit_urb(&dev->in_urbs[i], gfp);
+		if (ret) {
+			usb_kill_anchored_urbs(&dev->in_running);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static void nrpz_read_callback(struct urb *urb)
+{
+	struct usb_nrpz *dev = (struct usb_nrpz *)urb->context;
+
+	if (urb->status) {
+		if (!(urb->status == -ENOENT ||
+		      urb->status == -EPIPE ||
+		      urb->status == -ECONNRESET ||
+		      urb->status == -ESHUTDOWN))
+			dev_err(&urb->dev->dev,
+				"Nonzero read bulk status: %d", urb->status);
+	}
+
+	spin_lock(&dev->read_lock);
+	list_add_tail(&urb->urb_list, &dev->in_avail);
+	spin_unlock(&dev->read_lock);
+	wake_up_all(&dev->wq);
+}
+
+static void nrpz_write_callback(struct urb *urb)
+{
+	struct usb_nrpz *dev = (struct usb_nrpz *)urb->context;
+
+	if (urb->status) {
+		if (!(urb->status == -ENOENT ||
+		      urb->status == -EPIPE ||
+		      urb->status == -ECONNRESET ||
+		      urb->status == -ESHUTDOWN))
+			dev_err(&urb->dev->dev,
+				"Nonzero write bulk status: %d", urb->status);
+	}
+
+	spin_lock(&dev->write_lock);
+	list_add_tail(&urb->urb_list, &dev->out_avail);
+	spin_unlock(&dev->write_lock);
+	wake_up_all(&dev->wq);
+}
+
+static void nrpz_delete(struct kref *kref)
+{
+	struct usb_nrpz *dev = container_of(kref, struct usb_nrpz, kref);
+
+	usb_put_dev(interface_to_usbdev(dev->intf));
+	kfree(dev);
+}
+
+static ssize_t nrpz_read(struct file *file, char __user *buffer, size_t count,
+				loff_t *ppos)
+{
+	struct usb_nrpz *dev = file->private_data;
+	int ret;
+	struct urb *urb;
+	size_t n;
+
+	/* verify that we actually have some data to read */
+	if (!count)
+		return 0;
+
+	/* lock the read data */
+	if (file->f_flags & O_NONBLOCK) {
+		if (!mutex_trylock(&dev->read_mutex))
+			return -EAGAIN;
+	} else {
+		ret = mutex_lock_interruptible(&dev->read_mutex);
+		if (ret)
+			return ret;
+	}
+
+	for (;;) {
+		urb = urb_list_get(&dev->read_lock, &dev->in_avail);
+		if (urb)
+			break;
+
+		/* verify that the device wasn't unplugged */
+		if (!dev->connected) {
+			ret = -ENODEV;
+			goto exit;
+		}
+
+		if (file->f_flags & O_NONBLOCK) {
+			ret = -EAGAIN;
+			goto exit;
+		}
+
+		ret = wait_event_interruptible(dev->wq,
+			!list_empty(&dev->in_avail) || !dev->connected);
+		if (ret) {
+			ret = -ERESTARTSYS;
+			goto exit;
+		}
+	}
+
+	if (!urb->status) {
+		n = min(count, urb->actual_length);
+
+		if (copy_to_user(buffer, urb->transfer_buffer, n)) {
+			urb_list_add(&dev->read_lock, urb, &dev->in_avail);
+			ret = -EFAULT;
+			goto exit;
+		}
+	} else {
+		n = -EPIPE;
+	}
+
+	usb_anchor_urb(urb, &dev->in_running);
+
+	ret = usb_submit_urb(urb, GFP_KERNEL);
+	if (ret) {
+		usb_unanchor_urb(urb);
+
+		if (dev->connected) {
+			urb_list_add_tail(&dev->read_lock, urb, &dev->in_avail);
+			urb->status = ret;
+			dev_err(&urb->dev->dev,
+				"Failed submitting read urb (error %d)", ret);
+		}
+	}
+
+	ret = n;
+exit:
+	mutex_unlock(&dev->read_mutex);
+	return ret;
+}
+
+static ssize_t nrpz_write(struct file *file, const char __user *buffer,
+			size_t count, loff_t *ppos)
+{
+	struct usb_nrpz *dev = file->private_data;
+	int ret;
+	size_t len = 0;
+	struct urb *urb;
+	size_t n;
+
+	/* lock the write data */
+	if (file->f_flags & O_NONBLOCK) {
+		if (!mutex_trylock(&dev->write_mutex))
+			return -EAGAIN;
+	} else {
+		ret = mutex_lock_interruptible(&dev->write_mutex);
+		if (ret)
+			return ret;
+	}
+
+	do {
+		for (;;) {
+			/* verify that the device wasn't unplugged */
+			if (!dev->connected) {
+				ret = -ENODEV;
+				goto exit;
+			}
+
+			urb = urb_list_get(&dev->write_lock, &dev->out_avail);
+			if (urb)
+				break;
+
+			if (file->f_flags & O_NONBLOCK) {
+				ret = -EAGAIN;
+				goto exit;
+			}
+
+			ret = wait_event_interruptible(dev->wq,
+				!list_empty(&dev->out_avail) || !dev->connected);
+			if (ret) {
+				ret = -ERESTARTSYS;
+				goto exit;
+			}
+		}
+
+		n = min(count, dev->out_size);
+
+		if (copy_from_user(urb->transfer_buffer, buffer, n)) {
+			urb_list_add(&dev->write_lock, urb, &dev->out_avail);
+			ret = -EFAULT;
+			break;
+		}
+
+		urb->transfer_buffer_length = n;
+
+		usb_anchor_urb(urb, &dev->out_running);
+
+		ret = usb_submit_urb(urb, GFP_KERNEL);
+		if (ret) {
+			usb_unanchor_urb(urb);
+			urb_list_add_tail(&dev->write_lock, urb, &dev->out_avail);
+			dev_err(&urb->dev->dev,
+				"Failed submitting write urb (error %d)", ret);
+			break;
+		}
+
+		count -= n;
+		buffer += n;
+		len += n;
+	} while (count);
+exit:
+	if (len)
+		ret = len;
+
+	mutex_unlock(&dev->write_mutex);
+	return ret;
+}
+
+#define	VRT_RESET_ALL		1
+#define	VRT_GET_DEVICE_INFO	6
+#define	VRI_DEVICE_NAME		5
+#define	DEVICE_STATE_SIZE	128
+
+static long nrpz_compat_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
+{
+	struct usb_nrpz *dev = file->private_data;
+	struct usb_interface *intf = dev->intf;
+	struct usb_device *udev;
+	int ret;
+
+	/* verify that the device wasn't unplugged */
+	if (!dev->connected)
+		return -ENODEV;
+
+	udev = interface_to_usbdev(intf);
+
+	switch (cmd) {
+	case NRPZ_START:
+	 {
+		u8 *device_state;
+
+		device_state = kzalloc(DEVICE_STATE_SIZE, GFP_KERNEL);
+
+		ret = usb_control_msg(udev,
+			usb_rcvctrlpipe(udev, 0),
+			VRT_GET_DEVICE_INFO,
+			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			0,
+			VRI_DEVICE_NAME,
+			device_state,
+			DEVICE_STATE_SIZE,
+			5000);
+
+		if (ret < 0)
+			goto done;
+
+		dev_dbg(&intf->dev,
+			"device state:%s", device_state);
+
+		if (strncmp(device_state, "Boot ", 5)) {
+			ret = 0;
+			goto done;
+		}
+
+		ret = usb_control_msg(udev,
+			usb_sndctrlpipe(udev, 0),
+			VRT_RESET_ALL,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			1,
+			1,
+			device_state,
+			sizeof(device_state),
+			5000);
+done:
+		kfree(device_state);
+		return ret;
+	 }
+	case NRPZ_WRITE_DONE:
+		if (arg) {
+			ret = wait_event_interruptible_timeout(
+				dev->out_running.wait,
+				list_empty(&dev->out_running.urb_list),
+				msecs_to_jiffies(arg));
+			if (!ret)
+				return -ETIMEDOUT;
+			if (ret < 0)
+				return ret;
+			return 0;
+		} else {
+			return wait_event_interruptible(
+				dev->out_running.wait,
+				list_empty(&dev->out_running.urb_list));
+		}
+		break;
+	case NRPZ_VENDOR_CONTROL_MSG_OUT:
+	 {
+		struct nrpz_control_req ncr;
+		u8 *data;
+		u16 size;
+
+		if (copy_from_user(&ncr, (struct nrpz_control_req __user *)arg, sizeof(ncr)))
+			return -EFAULT;
+
+		if (ncr.data) {
+			size = ncr.size;
+
+			if (!access_ok(VERIFY_READ, (void __user *)ncr.data, size))
+				return -EFAULT;
+
+			data = kzalloc(size, GFP_KERNEL);
+			if (!data)
+				return -ENOMEM;
+
+			memcpy(data, ncr.data, size);
+		} else {
+			size = 0;
+			data = NULL;
+		}
+
+		ret = usb_control_msg(udev,
+				usb_sndctrlpipe(udev, 0),
+				ncr.request,
+				ncr.type,
+				ncr.value,
+				ncr.index,
+				data,
+				size,
+				0);
+
+		kfree(data);
+
+		return ret;
+	 }
+	case NRPZ_VENDOR_CONTROL_MSG_IN:
+	 {
+		struct nrpz_control_req ncr;
+		u8 *data;
+		u16 size;
+
+		if (copy_from_user(&ncr, (struct nrpz_control_req __user *)arg, sizeof(ncr)))
+			return -EFAULT;
+
+		if (ncr.data) {
+			size = ncr.size;
+
+			if (!access_ok(VERIFY_WRITE, (void __user *)ncr.data, size))
+				return -EFAULT;
+
+			data = kzalloc(size, GFP_KERNEL);
+			if (!data)
+				return -ENOMEM;
+		} else {
+			size = 0;
+			data = NULL;
+		}
+
+		ret = usb_control_msg(udev,
+				usb_rcvctrlpipe(udev, 0),
+				ncr.request,
+				ncr.type,
+				ncr.value,
+				ncr.index,
+				data,
+				size,
+				0);
+
+		if (data) {
+			memcpy(ncr.data, data, size);
+			kfree(data);
+		}
+
+		return ret;
+	 }
+	default:
+		dev_dbg(&intf->dev,
+			"Invalid ioctl call (%08x)", cmd);
+		return -ENOTTY;
+	}
+
+	return ret;
+}
+
+static long nrpz_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
+{
+	return nrpz_compat_ioctl(file, cmd, arg);
+}
+
+static int nrpz_open(struct inode *inode, struct file *file)
+{
+	struct usb_nrpz *dev;
+	int minor;
+	struct usb_interface *intf;
+	struct usb_device *udev;
+	int ret;
+	unsigned i;
+
+	minor = iminor(inode);
+
+	intf = usb_find_interface(&nrpz_driver, minor);
+	if (!intf)
+		return -ENODEV;
+
+	dev = usb_get_intfdata(intf);
+	if (!dev || !dev->connected)
+		return -ENODEV;
+
+	spin_lock_irq(&dev->read_lock);
+	if (dev->in_use) {
+		spin_unlock_irq(&dev->read_lock);
+		return -EBUSY;
+	}
+	dev->in_use = true;
+	spin_unlock_irq(&dev->read_lock);
+
+	/* increment our usage count for the device */
+	kref_get(&dev->kref);
+
+	/* save our object in the file's private structure */
+	file->private_data = dev;
+
+	INIT_LIST_HEAD(&dev->in_avail);
+	INIT_LIST_HEAD(&dev->out_avail);
+
+	udev = interface_to_usbdev(intf);
+
+	ret = bulks_init(dev,
+			 udev,
+			 dev->in_urbs,
+			 ARRAY_SIZE(dev->in_urbs),
+			 usb_rcvbulkpipe(udev, dev->in_epAddr),
+			 dev->in_size,
+			 nrpz_read_callback);
+	if (ret)
+		goto error;
+
+	ret = bulks_init(dev,
+			 udev,
+			 dev->out_urbs,
+			 ARRAY_SIZE(dev->out_urbs),
+			 usb_sndbulkpipe(udev, dev->out_epAddr),
+			 dev->out_size,
+			 nrpz_write_callback);
+	if (ret)
+		goto error;
+
+	ret = bulks_in_submit(dev, GFP_KERNEL);
+	if (ret)
+		goto error;
+
+	for (i = 0; i != ARRAY_SIZE(dev->out_urbs); ++i)
+		list_add(&dev->out_urbs[i].urb_list, &dev->out_avail);
+
+	return 0;
+error:
+	bulks_release(dev->out_urbs, ARRAY_SIZE(dev->out_urbs), dev->out_size);
+	bulks_release(dev->in_urbs, ARRAY_SIZE(dev->in_urbs), dev->in_size);
+
+	return 0;
+}
+
+static int nrpz_release(struct inode *inode, struct file *file)
+{
+	struct usb_nrpz *dev = file->private_data;
+
+	if (dev == NULL)
+		return -ENODEV;
+
+	usb_kill_anchored_urbs(&dev->in_running);
+	usb_kill_anchored_urbs(&dev->out_running);
+
+	bulks_release(dev->out_urbs, ARRAY_SIZE(dev->out_urbs), dev->out_size);
+	bulks_release(dev->in_urbs, ARRAY_SIZE(dev->in_urbs), dev->in_size);
+
+	spin_lock_irq(&dev->read_lock);
+	dev->in_use = false;
+	spin_unlock_irq(&dev->read_lock);
+
+	/* decrement the count on our device */
+	kref_put(&dev->kref, nrpz_delete);
+
+	return 0;
+}
+
+static int nrpz_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	struct usb_nrpz *dev = file->private_data;
+	int ret;
+
+	if (dev == NULL)
+		return -ENODEV;
+
+	/* lock the write data */
+	ret = mutex_lock_interruptible(&dev->write_mutex);
+	if (ret)
+		return ret;
+
+	/* verify that the device wasn't unplugged */
+	if (!dev->connected) {
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	ret = wait_event_interruptible(dev->out_running.wait,
+				list_empty(&dev->out_running.urb_list));
+	if (ret) {
+		ret = -ERESTARTSYS;
+		goto exit;
+	}
+exit:
+	mutex_unlock(&dev->write_mutex);
+
+	return ret;
+}
+
+static int nrpz_flush(struct file *file, fl_owner_t id)
+{
+	return nrpz_fsync(file, 0, LLONG_MAX, 0);
+}
+
+static unsigned int nrpz_poll(struct file *file, poll_table *wait)
+{
+	struct usb_nrpz *dev = file->private_data;
+	int ret = 0;
+
+	poll_wait(file, &dev->wq, wait);
+
+	if (!dev->connected)
+		ret = POLLIN | POLLOUT | POLLPRI | POLLERR | POLLHUP;
+	else {
+		if (!list_empty(&dev->in_avail))
+			ret |= POLLIN;
+
+		if (!list_empty(&dev->out_avail))
+			ret |= POLLOUT;
+	}
+
+	return ret;
+}
+
+static const struct file_operations nrpz_fops = {
+	.owner = THIS_MODULE,
+	.read = nrpz_read,
+	.write = nrpz_write,
+	.unlocked_ioctl = nrpz_ioctl,
+	.compat_ioctl = nrpz_compat_ioctl,
+	.open = nrpz_open,
+	.release = nrpz_release,
+	.fsync = nrpz_fsync,
+	.flush = nrpz_flush,
+	.poll = nrpz_poll,
+	.llseek = noop_llseek,
+};
+
+static struct usb_class_driver nrpz_class = {
+	.name = "nrpz%d",
+	.fops = &nrpz_fops,
+	.minor_base = NRPZ_MINOR_BASE,
+};
+
+static int nrpz_probe(struct usb_interface *intf,
+			const struct usb_device_id *id)
+{
+	int i;
+	int ret;
+	struct usb_endpoint_descriptor *endpoint;
+	struct usb_host_interface *iface_desc;
+	struct usb_nrpz *dev;
+
+	/* allocate memory for our device state and intialize it */
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		dev_err(&intf->dev, "Out of memory");
+		return -ENOMEM;
+	}
+
+	ret = -EIO;
+
+	init_waitqueue_head(&dev->wq);
+	kref_init(&dev->kref);
+
+	mutex_init(&dev->read_mutex);
+	mutex_init(&dev->write_mutex);
+
+	spin_lock_init(&dev->read_lock);
+	spin_lock_init(&dev->write_lock);
+
+	init_usb_anchor(&dev->in_running);
+	init_usb_anchor(&dev->out_running);
+
+	usb_get_dev(interface_to_usbdev(intf));
+
+	dev->in_use = false;
+	dev->intf = intf;
+	dev->connected = true;
+
+	/* set up the endpoint information */
+	/* check out the endpoints */
+	iface_desc = intf->cur_altsetting;
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
+		endpoint = &iface_desc->endpoint[i].desc;
+
+		if (!dev->in_epAddr && usb_endpoint_is_bulk_in(endpoint)) {
+			/* we found a bulk in endpoint */
+			dev->in_size = le16_to_cpu(endpoint->wMaxPacketSize);
+			dev->in_epAddr = endpoint->bEndpointAddress;
+		} else
+		if (!dev->out_epAddr && usb_endpoint_is_bulk_out(endpoint)) {
+			/* we found a bulk out endpoint */
+			dev->out_size = le16_to_cpu(endpoint->wMaxPacketSize);
+			dev->out_epAddr = endpoint->bEndpointAddress;
+		}
+	}
+	if (!(dev->in_epAddr && dev->out_epAddr)) {
+		dev_err(&intf->dev,
+			"Could not find both bulk in and out endpoints");
+		goto error;
+	}
+
+	usb_set_intfdata(intf, dev);
+
+	ret = usb_register_dev(intf, &nrpz_class);
+	if (ret) {
+		dev_err(&intf->dev,
+			"Not able to get a minor for this device\n");
+		goto error;
+	}
+
+	/* let the user know what node this device is now attached to */
+	dev_info(&intf->dev,
+		"Device attached to nrpz%u", intf->minor - NRPZ_MINOR_BASE);
+
+	return 0;
+error:
+	usb_set_intfdata(intf, NULL);
+	nrpz_delete(&dev->kref);
+	return ret;
+}
+
+static void nrpz_disconnect(struct usb_interface *intf)
+{
+	struct usb_nrpz *dev;
+
+	dev_info(&intf->dev,
+		"nrpz%u disconnected", intf->minor - NRPZ_MINOR_BASE);
+
+	dev = usb_get_intfdata(intf);
+	usb_set_intfdata(intf, NULL);
+
+	/* give back our minor */
+	usb_deregister_dev(intf, &nrpz_class);
+
+	/* prevent more I/O from starting */
+	dev->connected = false;
+
+	usb_kill_anchored_urbs(&dev->in_running);
+	usb_kill_anchored_urbs(&dev->out_running);
+
+	wake_up_all(&dev->wq);
+
+	/* decrement our usage count */
+	kref_put(&dev->kref, nrpz_delete);
+}
+
+static void nrpz_draw_down(struct usb_nrpz *dev)
+{
+	int time;
+
+	time = usb_wait_anchor_empty_timeout(&dev->out_running, 1000);
+	if (!time)
+		usb_kill_anchored_urbs(&dev->out_running);
+
+	usb_kill_anchored_urbs(&dev->in_running);
+}
+
+static int nrpz_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct usb_nrpz *dev = usb_get_intfdata(intf);
+
+	if (dev)
+		nrpz_draw_down(dev);
+	return 0;
+}
+
+static int nrpz_resume(struct usb_interface *intf)
+{
+	struct usb_nrpz *dev = usb_get_intfdata(intf);
+
+	if (dev)
+		return bulks_in_submit(dev, GFP_NOIO);
+	return 0;
+}
+
+static struct usb_driver nrpz_driver = {
+	.name = "nrpz",
+	.probe = nrpz_probe,
+	.disconnect = nrpz_disconnect,
+	.suspend = nrpz_suspend,
+	.resume = nrpz_resume,
+	.id_table = nrpz_table,
+};
+
+module_usb_driver(nrpz_driver);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
diff --git a/include/linux/usb/nrpzmodule.h b/include/linux/usb/nrpzmodule.h
new file mode 100644
index 0000000..8a39aef
--- /dev/null
+++ b/include/linux/usb/nrpzmodule.h
@@ -0,0 +1,46 @@
+#ifndef __NRPZMODULE_H_
+#define __NRPZMODULE_H_
+
+#include "linux/ioctl.h"
+
+#define NRPZ_IOC_MAGIC	'N'
+
+#define NRPZ_START			_IO(NRPZ_IOC_MAGIC, 0x02)
+#define NRPZ_WRITE_DONE			_IOW(NRPZ_IOC_MAGIC, 0x03, unsigned long)
+#define NRPZ_VENDOR_CONTROL_MSG		_IOW(NRPZ_IOC_MAGIC, 0x06, struct nrpz_control_req *)
+#define NRPZ_VENDOR_CONTROL_MSG_OUT	_IOW(NRPZ_IOC_MAGIC, 0x06, struct nrpz_control_req *)
+#define NRPZ_VENDOR_CONTROL_MSG_IN	_IOW(NRPZ_IOC_MAGIC, 0x07, struct nrpz_control_req *)
+
+struct nrpz_sensor_info {
+	unsigned char bDescriptorType;
+	unsigned short bcdUSB;
+	unsigned char bDeviceClass;
+	unsigned char bDeviceSubClass;
+	unsigned char bDeviceProtocol;
+	unsigned char bMaxPacketSize0;
+	unsigned short vendorId;
+	unsigned short productId;
+	unsigned short bcdDevice;
+	unsigned char iManufacturer;
+	unsigned char iProduct;
+	unsigned char iSerialNumber;
+	unsigned char bNumConfigurations;
+	char protocol[128];
+	char manufacturer[128];
+	char productName[128];
+	char serialNumber[128];
+};
+
+/*
+ * struct for NRPZ_VENDOR_CONTROL
+ */
+struct nrpz_control_req {
+	unsigned char request;
+	unsigned char type;
+	unsigned short value;
+	unsigned short index;
+	unsigned char *data;
+	unsigned short size;
+};
+
+#endif
-- 
1.7.8.6

