Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab0ELPpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:45:19 -0400
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:33343 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755954Ab0ELPpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:45:15 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net 9584F1079D2
Subject: [PATCH 5/5] HID: add chardev to propagate special events of Roccat
 hardware to userland
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, wylda@volny.cz,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Jerome Vidal <jerom3@free.fr>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 17:45:12 +0200
Message-ID: <1273679112.2927.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fd85b3029af2759170adcb7bdb340676ef22ac9b Mon Sep 17 00:00:00 2001
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Date: Sat, 8 May 2010 17:51:18 +0200
Subject: [PATCH 5/5] HID: add chardev to propagate special events of
Roccat hardware to userland

Module roccat is a char device used to report special events of roccat
hardware to userland. These events include requests for
on-screen-display of
profile or dpi settings or requests for execution of macro sequences
that are
not stored in device. The information in these events depends on hid
device
implementation and contains data that is not available in a single hid
event
or else hidraw could have been used.
It is inspired by hidraw, but uses only one circular buffer for all
readers.
The device is as generic as possible so that the functionality is usable
by all (kone and upcomming) roccat device drivers.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/Kconfig           |    8 +
 drivers/hid/Makefile          |    1 +
 drivers/hid/hid-roccat-kone.c |   49 +++++
 drivers/hid/hid-roccat-kone.h |    9 +
 drivers/hid/hid-roccat.c      |  428
+++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-roccat.h      |   31 +++
 6 files changed, 526 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hid/hid-roccat.c
 create mode 100644 drivers/hid/hid-roccat.h

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 44b4691..2c7018b 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -268,6 +268,14 @@ config HID_QUANTA
 	---help---
 	Support for Quanta Optical Touch dual-touch panels.
 
+config HID_ROCCAT
+	tristate "Roccat special event support"
+	depends on USB_HID
+	---help---
+	Support for Roccat special events.
+	Say Y here if you have a Roccat mouse or keyboard and want OSD or
+	macro execution support.
+
 config HID_ROCCAT_KONE
 	tristate "Roccat Kone Mouse support"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 08b83cc..77fad93 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_HID_ORTEK)		+= hid-ortek.o
 obj-$(CONFIG_HID_QUANTA)	+= hid-quanta.o
 obj-$(CONFIG_HID_PANTHERLORD)	+= hid-pl.o
 obj-$(CONFIG_HID_PETALYNX)	+= hid-petalynx.o
+obj-$(CONFIG_HID_ROCCAT)	+= hid-roccat.o
 obj-$(CONFIG_HID_ROCCAT_KONE)	+= hid-roccat-kone.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
diff --git a/drivers/hid/hid-roccat-kone.c
b/drivers/hid/hid-roccat-kone.c
index 66e6940..892654e 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -37,6 +37,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include "hid-ids.h"
+#include "hid-roccat.h"
 #include "hid-roccat-kone.h"
 
 static void kone_set_settings_checksum(struct kone_settings *settings)
@@ -849,6 +850,16 @@ static int kone_init_specials(struct hid_device
*hdev)
 					"couldn't init struct kone_device\n");
 			goto exit_free;
 		}
+
+		retval = roccat_connect(hdev);
+		if (retval < 0) {
+			dev_err(&hdev->dev, "couldn't init char dev\n");
+			/* be tolerant about not getting chrdev */
+		} else {
+			kone->roccat_claimed = 1;
+			kone->chrdev_minor = retval;
+		}
+
 		retval = kone_create_sysfs_attributes(intf);
 		if (retval) {
 			dev_err(&hdev->dev, "cannot create sysfs files\n");
@@ -868,10 +879,14 @@ exit_free:
 static void kone_remove_specials(struct hid_device *hdev)
 {
 	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+	struct kone_device *kone;
 
 	if (intf->cur_altsetting->desc.bInterfaceProtocol
 			== USB_INTERFACE_PROTOCOL_MOUSE) {
 		kone_remove_sysfs_attributes(intf);
+		kone = hid_get_drvdata(hdev);
+		if (kone->roccat_claimed)
+			roccat_disconnect(kone->chrdev_minor);
 		kfree(hid_get_drvdata(hdev));
 	}
 }
@@ -930,6 +945,37 @@ static void kone_keep_values_up_to_date(struct
kone_device *kone,
 	}
 }
 
+static void kone_report_to_chrdev(struct kone_device const *kone,
+		struct kone_mouse_event const *event)
+{
+	struct kone_roccat_report roccat_report;
+
+	switch (event->event) {
+	case kone_mouse_event_switch_profile:
+	case kone_mouse_event_switch_dpi:
+	case kone_mouse_event_osd_profile:
+	case kone_mouse_event_osd_dpi:
+		roccat_report.event = event->event;
+		roccat_report.value = event->value;
+		roccat_report.key = 0;
+		roccat_report_event(kone->chrdev_minor,
+				(uint8_t *)&roccat_report,
+				sizeof(struct kone_roccat_report));
+		break;
+	case kone_mouse_event_call_overlong_macro:
+		if (event->value == kone_keystroke_action_press) {
+			roccat_report.event = kone_mouse_event_call_overlong_macro;
+			roccat_report.value = kone->actual_profile;
+			roccat_report.key = event->macro_key;
+			roccat_report_event(kone->chrdev_minor,
+					(uint8_t *)&roccat_report,
+					sizeof(struct kone_roccat_report));
+		}
+		break;
+	}
+
+}
+
 /*
  * Is called for keyboard- and mousepart.
  * Only mousepart gets informations about special events in its
extended event
@@ -958,6 +1004,9 @@ static int kone_raw_event(struct hid_device *hdev,
struct hid_report *report,
 
 	kone_keep_values_up_to_date(kone, event);
 
+	if (kone->roccat_claimed)
+		kone_report_to_chrdev(kone, event);
+
 	return 0; /* always do further processing */
 }
 
diff --git a/drivers/hid/hid-roccat-kone.h
b/drivers/hid/hid-roccat-kone.h
index b413b10..003e6f8 100644
--- a/drivers/hid/hid-roccat-kone.h
+++ b/drivers/hid/hid-roccat-kone.h
@@ -189,6 +189,12 @@ enum kone_commands {
 	kone_command_firmware = 0xe5a
 };
 
+struct kone_roccat_report {
+	uint8_t event;
+	uint8_t value; /* holds dpi or profile value */
+	uint8_t key; /* macro key on overlong macro execution */
+};
+
 #pragma pack(pop)
 
 struct kone_device {
@@ -219,6 +225,9 @@ struct kone_device {
 	 * so it's read only once
 	 */
 	int firmware_version;
+
+	int roccat_claimed;
+	int chrdev_minor;
 };
 
 #endif
diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
new file mode 100644
index 0000000..e05d48e
--- /dev/null
+++ b/drivers/hid/hid-roccat.c
@@ -0,0 +1,428 @@
+/*
+ * Roccat driver for Linux
+ *
+ * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License as published by
the Free
+ * Software Foundation; either version 2 of the License, or (at your
option)
+ * any later version.
+ */
+
+/*
+ * Module roccat is a char device used to report special events of
roccat
+ * hardware to userland. These events include requests for
on-screen-display of
+ * profile or dpi settings or requests for execution of macro sequences
that are
+ * not stored in device. The information in these events depends on hid
device
+ * implementation and contains data that is not available in a single
hid event
+ * or else hidraw could have been used.
+ * It is inspired by hidraw, but uses only one circular buffer for all
readers.
+ */
+
+#include <linux/cdev.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+
+#include "hid-roccat.h"
+
+#define ROCCAT_FIRST_MINOR 0
+#define ROCCAT_MAX_DEVICES 8
+
+/* should be a power of 2 for performance reason */
+#define ROCCAT_CBUF_SIZE 16
+
+struct roccat_report {
+	uint8_t *value;
+	int len;
+};
+
+struct roccat_device {
+	unsigned int minor;
+	int open;
+	int exist;
+	wait_queue_head_t wait;
+	struct device *dev;
+	struct hid_device *hid;
+	struct list_head readers;
+	/* protects modifications of readers list */
+	struct mutex readers_lock;
+
+	/*
+	 * circular_buffer has one writer and multiple readers with their own
+	 * read pointers
+	 */
+	struct roccat_report cbuf[ROCCAT_CBUF_SIZE];
+	int cbuf_end;
+	struct mutex cbuf_lock;
+};
+
+struct roccat_reader {
+	struct list_head node;
+	struct roccat_device *device;
+	int cbuf_start;
+};
+
+static int roccat_major;
+static struct class *roccat_class;
+static struct cdev roccat_cdev;
+
+static struct roccat_device *devices[ROCCAT_MAX_DEVICES];
+/* protects modifications of devices array */
+static DEFINE_MUTEX(devices_lock);
+
+static ssize_t roccat_read(struct file *file, char __user *buffer,
+		size_t count, loff_t *ppos)
+{
+	struct roccat_reader *reader = file->private_data;
+	struct roccat_device *device = reader->device;
+	struct roccat_report *report;
+	ssize_t retval = 0, len;
+	DECLARE_WAITQUEUE(wait, current);
+
+	mutex_lock(&device->cbuf_lock);
+
+	/* no data? */
+	if (reader->cbuf_start == device->cbuf_end) {
+		add_wait_queue(&device->wait, &wait);
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		/* wait for data */
+		while (reader->cbuf_start == device->cbuf_end) {
+			if (file->f_flags & O_NONBLOCK) {
+				retval = -EAGAIN;
+				break;
+			}
+			if (signal_pending(current)) {
+				retval = -ERESTARTSYS;
+				break;
+			}
+			if (!device->exist) {
+				retval = -EIO;
+				break;
+			}
+
+			mutex_unlock(&device->cbuf_lock);
+			schedule();
+			mutex_lock(&device->cbuf_lock);
+			set_current_state(TASK_INTERRUPTIBLE);
+		}
+
+		set_current_state(TASK_RUNNING);
+		remove_wait_queue(&device->wait, &wait);
+	}
+
+	/* here we either have data or a reason to return if retval is set */
+	if (retval)
+		goto exit_unlock;
+
+	report = &device->cbuf[reader->cbuf_start];
+	/*
+	 * If report is larger than requested amount of data, rest of report
+	 * is lost!
+	 */
+	len = report->len > count ? count : report->len;
+
+	if (copy_to_user(buffer, report->value, len)) {
+		retval = -EFAULT;
+		goto exit_unlock;
+	}
+	retval += len;
+	reader->cbuf_start = (reader->cbuf_start + 1) % ROCCAT_CBUF_SIZE;
+
+exit_unlock:
+	mutex_unlock(&device->cbuf_lock);
+	return retval;
+}
+
+static unsigned int roccat_poll(struct file *file, poll_table *wait)
+{
+	struct roccat_reader *reader = file->private_data;
+	poll_wait(file, &reader->device->wait, wait);
+	if (reader->cbuf_start != reader->device->cbuf_end)
+		return POLLIN | POLLRDNORM;
+	if (!reader->device->exist)
+		return POLLERR | POLLHUP;
+	return 0;
+}
+
+static int roccat_open(struct inode *inode, struct file *file)
+{
+	unsigned int minor = iminor(inode);
+	struct roccat_reader *reader;
+	struct roccat_device *device;
+	int error = 0;
+
+	reader = kzalloc(sizeof(struct roccat_reader), GFP_KERNEL);
+	if (!reader)
+		return -ENOMEM;
+
+	mutex_lock(&devices_lock);
+
+	device = devices[minor];
+
+	mutex_lock(&device->readers_lock);
+
+	if (!device) {
+		printk(KERN_EMERG "roccat device with minor %d doesn't exist\n",
+				minor);
+		error = -ENODEV;
+		goto exit_unlock;
+	}
+
+	if (!device->open++) {
+		/* power on device on adding first reader */
+		if (device->hid->ll_driver->power) {
+			error = device->hid->ll_driver->power(device->hid,
+					PM_HINT_FULLON);
+			if (error < 0) {
+				--device->open;
+				goto exit_unlock;
+			}
+		}
+		error = device->hid->ll_driver->open(device->hid);
+		if (error < 0) {
+			if (device->hid->ll_driver->power)
+				device->hid->ll_driver->power(device->hid,
+						PM_HINT_NORMAL);
+			--device->open;
+			goto exit_unlock;
+		}
+	}
+
+	reader->device = device;
+	/* new reader doesn't get old events */
+	reader->cbuf_start = device->cbuf_end;
+
+	list_add_tail(&reader->node, &device->readers);
+	file->private_data = reader;
+
+exit_unlock:
+	mutex_unlock(&device->readers_lock);
+	mutex_unlock(&devices_lock);
+	return error;
+}
+
+static int roccat_release(struct inode *inode, struct file *file)
+{
+	unsigned int minor = iminor(inode);
+	struct roccat_reader *reader = file->private_data;
+	struct roccat_device *device;
+
+	mutex_lock(&devices_lock);
+
+	device = devices[minor];
+	if (!device) {
+		mutex_unlock(&devices_lock);
+		printk(KERN_EMERG "roccat device with minor %d doesn't exist\n",
+				minor);
+		return -ENODEV;
+	}
+
+	mutex_lock(&device->readers_lock);
+	list_del(&reader->node);
+	mutex_unlock(&device->readers_lock);
+	kfree(reader);
+
+	if (!--device->open) {
+		/* removing last reader */
+		if (device->exist) {
+			if (device->hid->ll_driver->power)
+				device->hid->ll_driver->power(device->hid,
+						PM_HINT_NORMAL);
+			device->hid->ll_driver->close(device->hid);
+		} else {
+			kfree(device);
+		}
+	}
+
+	mutex_unlock(&devices_lock);
+
+	return 0;
+}
+
+/*
+ * roccat_report_event() - output data to readers
+ * @minor: minor device number returned by roccat_connect()
+ * @data: pointer to data
+ * @len: size of data
+ *
+ * Return value is zero on success, a negative error code on failure.
+ *
+ * This is called from interrupt handler.
+ */
+int roccat_report_event(int minor, u8 const *data, int len)
+{
+	struct roccat_device *device;
+	struct roccat_reader *reader;
+	struct roccat_report *report;
+	uint8_t *new_value;
+
+	new_value = kmemdup(data, len, GFP_ATOMIC);
+	if (!new_value)
+		return -ENOMEM;
+
+	device = devices[minor];
+
+	report = &device->cbuf[device->cbuf_end];
+
+	/* passing NULL is safe */
+	kfree(report->value);
+
+	report->value = new_value;
+	report->len = len;
+	device->cbuf_end = (device->cbuf_end + 1) % ROCCAT_CBUF_SIZE;
+
+	list_for_each_entry(reader, &device->readers, node) {
+		/*
+		 * As we already inserted one element, the buffer can't be
+		 * empty. If start and end are equal, buffer is full and we
+		 * increase start, so that slow reader misses one event, but
+		 * gets the newer ones in the right order.
+		 */
+		if (reader->cbuf_start == device->cbuf_end)
+			reader->cbuf_start = (reader->cbuf_start + 1) % ROCCAT_CBUF_SIZE;
+	}
+
+	wake_up_interruptible(&device->wait);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(roccat_report_event);
+
+/*
+ * roccat_connect() - create a char device for special event output
+ * @hid: the hid device the char device should be connected to.
+ *
+ * Return value is minor device number in Range [0, ROCCAT_MAX_DEVICES]
on
+ * success, a negative error code on failure.
+ */
+int roccat_connect(struct hid_device *hid)
+{
+	unsigned int minor;
+	struct roccat_device *device;
+	int temp;
+
+	device = kzalloc(sizeof(struct roccat_device), GFP_KERNEL);
+	if (!device)
+		return -ENOMEM;
+
+	mutex_lock(&devices_lock);
+
+	for (minor = 0; minor < ROCCAT_MAX_DEVICES; ++minor) {
+		if (devices[minor])
+			continue;
+		break;
+	}
+
+	if (minor < ROCCAT_MAX_DEVICES) {
+		devices[minor] = device;
+	} else {
+		mutex_unlock(&devices_lock);
+		kfree(device);
+		return -EINVAL;
+	}
+
+	device->dev = device_create(roccat_class, &hid->dev,
+			MKDEV(roccat_major, minor), NULL,
+			"%s%s%d", "roccat", hid->driver->name, minor);
+
+	if (IS_ERR(device->dev)) {
+		devices[minor] = NULL;
+		mutex_unlock(&devices_lock);
+		temp = PTR_ERR(device->dev);
+		kfree(device);
+		return temp;
+	}
+
+	mutex_unlock(&devices_lock);
+
+	init_waitqueue_head(&device->wait);
+	INIT_LIST_HEAD(&device->readers);
+	mutex_init(&device->readers_lock);
+	mutex_init(&device->cbuf_lock);
+	device->minor = minor;
+	device->hid = hid;
+	device->exist = 1;
+	device->cbuf_end = 0;
+
+	return minor;
+}
+EXPORT_SYMBOL_GPL(roccat_connect);
+
+/* roccat_disconnect() - remove char device from hid device
+ * @minor: the minor device number returned by roccat_connect()
+ */
+void roccat_disconnect(int minor)
+{
+	struct roccat_device *device;
+
+	mutex_lock(&devices_lock);
+	device = devices[minor];
+	devices[minor] = NULL;
+	mutex_unlock(&devices_lock);
+
+	device->exist = 0; /* TODO exist maybe not needed */
+
+	device_destroy(roccat_class, MKDEV(roccat_major, minor));
+
+	if (device->open) {
+		device->hid->ll_driver->close(device->hid);
+		wake_up_interruptible(&device->wait);
+	} else {
+		kfree(device);
+	}
+}
+EXPORT_SYMBOL_GPL(roccat_disconnect);
+
+static const struct file_operations roccat_ops = {
+	.owner = THIS_MODULE,
+	.read = roccat_read,
+	.poll = roccat_poll,
+	.open = roccat_open,
+	.release = roccat_release,
+};
+
+static int __init roccat_init(void)
+{
+	int retval;
+	dev_t dev_id;
+
+	retval = alloc_chrdev_region(&dev_id, ROCCAT_FIRST_MINOR,
+			ROCCAT_MAX_DEVICES, "roccat");
+
+	roccat_major = MAJOR(dev_id);
+
+	if (retval < 0) {
+		printk(KERN_WARNING "roccat: can't get major number\n");
+		return retval;
+	}
+
+	roccat_class = class_create(THIS_MODULE, "roccat");
+	if (IS_ERR(roccat_class)) {
+		retval = PTR_ERR(roccat_class);
+		unregister_chrdev_region(dev_id, ROCCAT_MAX_DEVICES);
+		return retval;
+	}
+
+	cdev_init(&roccat_cdev, &roccat_ops);
+	cdev_add(&roccat_cdev, dev_id, ROCCAT_MAX_DEVICES);
+
+	return 0;
+}
+
+static void __exit roccat_exit(void)
+{
+	dev_t dev_id = MKDEV(roccat_major, 0);
+
+	cdev_del(&roccat_cdev);
+	class_destroy(roccat_class);
+	unregister_chrdev_region(dev_id, ROCCAT_MAX_DEVICES);
+}
+
+module_init(roccat_init);
+module_exit(roccat_exit);
+
+MODULE_AUTHOR("Stefan Achatz");
+MODULE_DESCRIPTION("USB Roccat char device");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat.h b/drivers/hid/hid-roccat.h
new file mode 100644
index 0000000..40cca5b
--- /dev/null
+++ b/drivers/hid/hid-roccat.h
@@ -0,0 +1,31 @@
+#ifndef __HID_ROCCAT_H
+#define __HID_ROCCAT_H
+
+/*
+ * Copyright (c) 2010 Stefan Achatz <erazor_de@users.sourceforge.net>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
it
+ * under the terms of the GNU General Public License as published by
the Free
+ * Software Foundation; either version 2 of the License, or (at your
option)
+ * any later version.
+ */
+
+#include <linux/hid.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_HID_ROCCAT
+int roccat_connect(struct hid_device *hid);
+void roccat_disconnect(int minor);
+int roccat_report_event(int minor, u8 const *data, int len);
+#else
+static inline int roccat_connect(struct hid_device *hid) { return -1; }
+static inline void roccat_disconnect(int minor) {}
+static inline int roccat_report_event(int minor, u8 const *data, int
len)
+{
+	return 0;
+}
+#endif
+
+#endif
-- 
1.6.6.1



