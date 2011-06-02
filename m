Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab1FBPKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 11:10:55 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:55083 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1FBPKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 11:10:54 -0400
Message-Id: <201106021510.p52FAlmb028120@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 2 Jun 2011 11:04:37 -0400
Subject: [PATCH v3] arch/tile: add hypervisor-based character driver for SPI flash ROM
To: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <gregkh@suse.de>, Eric Biederman <ebiederm@aristanetworks.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
In-Reply-To: <201105281516.p4SFGfHg024703@farm-0010.internal.tilera.com>
References: <201105281516.p4SFGfHg024703@farm-0010.internal.tilera.com>
	<201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>
	<4DD6FB9E.2050604@tilera.com>
	<20110521032102.GD19907@suse.de>
	<201105211133.50238.arnd@arndb.de>
	<4DD7C3A7.5010402@tilera.com>
	<BANLkTim-d-8w1_idg4u302aB3MqTo7q4Sg@mail.gmail.com>
X-OriginalArrivalTime: 02 Jun 2011 15:10:53.0100 (UTC) FILETIME=[43C7FEC0:01CC2137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first version of this patch proposed an arch/tile/drivers/ directory,
but the consensus was that this was probably a poor choice for a place to
group Tilera-specific drivers, and that in any case grouping by platform
was discouraged, and grouping by function was preferred.

This version of the patch addresses various issues raised in the
community, primarily the absence of sysfs integration.  The sysfs
integration now handles passing information on sector size, page size,
and total partition size to userspace as well.  In addition, we now
use a single "struct cdev" to manage all the partition minor devices,
and dynamically discover the correct number of partitions from the
hypervisor rather than using a module_param with a default value.

This driver has no particular "peer" drivers it can be grouped with.
It is sort of like an MTD driver for SPI ROM, but it doesn't group well
with the other MTD devices since it relies on hypervisor virtualization
to handle many of the irritating aspects of flash ROM management: sector
awareness, background read for sub-sector writes, bit examination to
determine whether a sector erase needs to be issued, etc.  It is in fact
more like an EEPROM driver, but the hypervisor virtualization does require
a "flush" command if you wish to commit a sector write prior to writing
to a different sector, and this is sufficiently different from generic
I2C/SPI EEPROMs that as a result it doesn't group well with them either.

The simple character device is already in use by a range of Tilera
SPI ROM management tools, as well as by customers.  In addition, using
the simple character device actually simplifies the userspace tools,
since they don't need to manage sector erase, background read, etc.
This both simplifies the code (since we can uniformly manage plain files
and the SPI ROM) as well as makes the user code portable to non-Linux
platforms that don't offer the same MTD ioctls.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/hv/drv_srom_intf.h |   41 +++
 drivers/char/Kconfig                 |   11 +
 drivers/char/Makefile                |    2 +
 drivers/char/tile-srom.c             |  481 ++++++++++++++++++++++++++++++++++
 4 files changed, 535 insertions(+), 0 deletions(-)
 create mode 100644 arch/tile/include/hv/drv_srom_intf.h
 create mode 100644 drivers/char/tile-srom.c

diff --git a/arch/tile/include/hv/drv_srom_intf.h b/arch/tile/include/hv/drv_srom_intf.h
new file mode 100644
index 0000000..6395faa
--- /dev/null
+++ b/arch/tile/include/hv/drv_srom_intf.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/**
+ * @file drv_srom_intf.h
+ * Interface definitions for the SPI Flash ROM driver.
+ */
+
+#ifndef _SYS_HV_INCLUDE_DRV_SROM_INTF_H
+#define _SYS_HV_INCLUDE_DRV_SROM_INTF_H
+
+/** Read this offset to get the total device size. */
+#define SROM_TOTAL_SIZE_OFF   0xF0000000
+
+/** Read this offset to get the device sector size. */
+#define SROM_SECTOR_SIZE_OFF  0xF0000004
+
+/** Read this offset to get the device page size. */
+#define SROM_PAGE_SIZE_OFF    0xF0000008
+
+/** Write this offset to flush any pending writes. */
+#define SROM_FLUSH_OFF        0xF1000000
+
+/** Write this offset, plus the byte offset of the start of a sector, to
+ *  erase a sector.  Any write data is ignored, but there must be at least
+ *  one byte of write data.  Only applies when the driver is in MTD mode.
+ */
+#define SROM_ERASE_OFF        0xF2000000
+
+#endif /* _SYS_HV_INCLUDE_DRV_SROM_INTF_H */
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 49502bc..5afd610 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -616,5 +616,16 @@ config MSM_SMD_PKT
 	  Enables userspace clients to read and write to some packet SMD
 	  ports via device interface for MSM chipset.
 
+config TILE_SROM
+	bool "Character-device access via hypervisor to the Tilera SPI ROM"
+	depends on TILE
+	default y
+	---help---
+	  This device provides character-level read-write access
+	  to the SROM, typically via the "0", "1", "2", and "info"
+	  devices in /dev/srom/.  The Tilera hypervisor makes the
+	  flash device appear much like a simple EEPROM, and knows
+	  how to partition a single ROM for multiple purposes.
+
 endmenu
 
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 7a00672..32762ba 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -63,3 +63,5 @@ obj-$(CONFIG_RAMOOPS)		+= ramoops.o
 
 obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
+
+obj-$(CONFIG_TILE_SROM)		+= tile-srom.o
diff --git a/drivers/char/tile-srom.c b/drivers/char/tile-srom.c
new file mode 100644
index 0000000..cf3ee00
--- /dev/null
+++ b/drivers/char/tile-srom.c
@@ -0,0 +1,481 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * SPI Flash ROM driver
+ *
+ * This source code is derived from code provided in "Linux Device
+ * Drivers, Third Edition", by Jonathan Corbet, Alessandro Rubini, and
+ * Greg Kroah-Hartman, published by O'Reilly Media, Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/kernel.h>	/* printk() */
+#include <linux/slab.h>		/* kmalloc() */
+#include <linux/fs.h>		/* everything... */
+#include <linux/errno.h>	/* error codes */
+#include <linux/types.h>	/* size_t */
+#include <linux/proc_fs.h>
+#include <linux/fcntl.h>	/* O_ACCMODE */
+#include <linux/aio.h>
+#include <linux/pagemap.h>
+#include <linux/hugetlb.h>
+#include <linux/uaccess.h>
+#include <linux/platform_device.h>
+#include <hv/hypervisor.h>
+#include <linux/ioctl.h>
+#include <linux/cdev.h>
+#include <linux/delay.h>
+#include <hv/drv_srom_intf.h>
+
+/*
+ * Size of our hypervisor I/O requests.  We break up large transfers
+ * so that we don't spend large uninterrupted spans of time in the
+ * hypervisor.  Erasing an SROM sector takes a significant fraction of
+ * a second, so if we allowed the user to, say, do one I/O to write the
+ * entire ROM, we'd get soft lockup timeouts, or worse.
+ */
+#define SROM_CHUNK_SIZE ((size_t)4096)
+
+/*
+ * When hypervisor is busy (e.g. erasing), poll the status periodically.
+ */
+
+/*
+ * Interval to poll the state in msec
+ */
+#define SROM_WAIT_TRY_INTERVAL 20
+
+/*
+ * Maximum times to poll the state
+ */
+#define SROM_MAX_WAIT_TRY_TIMES 1000
+
+struct srom_dev {
+	int hv_devhdl;			/* Handle for hypervisor device */
+	u32 total_size;			/* Size of this device */
+	u32 sector_size;		/* Size of a sector */
+	u32 page_size;			/* Size of a page */
+	struct mutex lock;		/* Allow only one accessor at a time */
+};
+
+static int srom_major;			/* Dynamic major by default */
+module_param(srom_major, int, 0);
+MODULE_AUTHOR("Tilera Corporation");
+MODULE_LICENSE("GPL");
+
+static int srom_devs;			/* Number of SROM partitions */
+static struct cdev srom_cdev;
+static struct class *srom_class;
+static struct srom_dev *srom_devices;
+
+/*
+ * Handle calling the hypervisor and managing EAGAIN/EBUSY.
+ */
+
+static ssize_t _srom_read(int hv_devhdl, void *buf,
+			  loff_t off, size_t count)
+{
+	int retval, retries = SROM_MAX_WAIT_TRY_TIMES;
+	for (;;) {
+		retval = hv_dev_pread(hv_devhdl, 0, (HV_VirtAddr)buf,
+				      count, off);
+		if (retval >= 0)
+			return retval;
+		if (retval == HV_EAGAIN)
+			continue;
+		if (retval == HV_EBUSY && --retries > 0) {
+			msleep(SROM_WAIT_TRY_INTERVAL);
+			continue;
+		}
+		pr_err("_srom_read: error %d\n", retval);
+		return -EIO;
+	}
+}
+
+static ssize_t _srom_write(int hv_devhdl, const void *buf,
+			   loff_t off, size_t count)
+{
+	int retval, retries = SROM_MAX_WAIT_TRY_TIMES;
+	for (;;) {
+		retval = hv_dev_pwrite(hv_devhdl, 0, (HV_VirtAddr)buf,
+				       count, off);
+		if (retval >= 0)
+			return retval;
+		if (retval == HV_EAGAIN)
+			continue;
+		if (retval == HV_EBUSY && --retries > 0) {
+			msleep(SROM_WAIT_TRY_INTERVAL);
+			continue;
+		}
+		pr_err("_srom_write: error %d\n", retval);
+		return -EIO;
+	}
+}
+
+/**
+ * srom_open() - Device open routine.
+ * @inode: Inode for this device.
+ * @filp: File for this specific open of the device.
+ *
+ * Returns zero, or an error code.
+ */
+static int srom_open(struct inode *inode, struct file *filp)
+{
+	filp->private_data = &srom_devices[iminor(inode)];
+	return 0;
+}
+
+
+/**
+ * srom_release() - Device release routine.
+ * @inode: Inode for this device.
+ * @filp: File for this specific open of the device.
+ *
+ * Returns zero, or an error code.
+ */
+static int srom_release(struct inode *inode, struct file *filp)
+{
+	struct srom_dev *srom = filp->private_data;
+	char dummy;
+
+	/* Make sure we've flushed anything written to the ROM. */
+	mutex_lock(&srom->lock);
+	if (srom->hv_devhdl >= 0)
+		_srom_write(srom->hv_devhdl, &dummy, SROM_FLUSH_OFF, 1);
+	mutex_unlock(&srom->lock);
+
+	filp->private_data = NULL;
+
+	return 0;
+}
+
+
+/**
+ * srom_read() - Read data from the device.
+ * @filp: File for this specific open of the device.
+ * @buf: User's data buffer.
+ * @count: Number of bytes requested.
+ * @f_pos: File position.
+ *
+ * Returns number of bytes read, or an error code.
+ */
+static ssize_t srom_read(struct file *filp, char __user *buf,
+			 size_t count, loff_t *f_pos)
+{
+	int retval = 0;
+	void *kernbuf;
+	struct srom_dev *srom = filp->private_data;
+
+	kernbuf = kmalloc(SROM_CHUNK_SIZE, GFP_KERNEL);
+	if (!kernbuf)
+		return -ENOMEM;
+
+	if (mutex_lock_interruptible(&srom->lock)) {
+		retval = -ERESTARTSYS;
+		kfree(kernbuf);
+		return retval;
+	}
+
+	while (count) {
+		int hv_retval;
+		int bytes_this_pass = min(count, SROM_CHUNK_SIZE);
+
+		hv_retval = _srom_read(srom->hv_devhdl, kernbuf,
+				       *f_pos, bytes_this_pass);
+		if (hv_retval > 0) {
+			if (copy_to_user(buf, kernbuf, hv_retval) != 0) {
+				retval = -EFAULT;
+				break;
+			}
+		} else if (hv_retval <= 0) {
+			if (retval == 0)
+				retval = hv_retval;
+			break;
+		}
+
+		retval += hv_retval;
+		*f_pos += hv_retval;
+		buf += hv_retval;
+		count -= hv_retval;
+	}
+
+	mutex_unlock(&srom->lock);
+	kfree(kernbuf);
+
+	return retval;
+}
+
+/**
+ * srom_write() - Write data to the device.
+ * @filp: File for this specific open of the device.
+ * @buf: User's data buffer.
+ * @count: Number of bytes requested.
+ * @f_pos: File position.
+ *
+ * Returns number of bytes written, or an error code.
+ */
+static ssize_t srom_write(struct file *filp, const char __user *buf,
+			  size_t count, loff_t *f_pos)
+{
+	int retval = 0;
+	void *kernbuf;
+	struct srom_dev *srom = filp->private_data;
+
+	kernbuf = kmalloc(SROM_CHUNK_SIZE, GFP_KERNEL);
+	if (!kernbuf)
+		return -ENOMEM;
+
+	if (mutex_lock_interruptible(&srom->lock)) {
+		retval = -ERESTARTSYS;
+		kfree(kernbuf);
+		return retval;
+	}
+
+	while (count) {
+		int hv_retval;
+		int bytes_this_pass = min(count, SROM_CHUNK_SIZE);
+
+		if (copy_from_user(kernbuf, buf, bytes_this_pass) != 0) {
+			retval = -EFAULT;
+			break;
+		}
+
+		hv_retval = _srom_write(srom->hv_devhdl, kernbuf,
+					*f_pos, bytes_this_pass);
+		if (hv_retval <= 0) {
+			if (retval == 0)
+				retval = hv_retval;
+			break;
+		}
+
+		retval += hv_retval;
+		*f_pos += hv_retval;
+		buf += hv_retval;
+		count -= hv_retval;
+	}
+
+	mutex_unlock(&srom->lock);
+	kfree(kernbuf);
+
+	return retval;
+}
+
+/* Provide our own implementation so we can use srom->total_size. */
+loff_t srom_llseek(struct file *filp, loff_t offset, int origin)
+{
+	struct srom_dev *srom = filp->private_data;
+
+	if (mutex_lock_interruptible(&srom->lock))
+		return -ERESTARTSYS;
+
+	switch (origin) {
+	case SEEK_END:
+		offset += srom->total_size;
+		break;
+	case SEEK_CUR:
+		offset += filp->f_pos;
+		break;
+	}
+
+	if (offset < 0 || offset > srom->total_size) {
+		offset = -EINVAL;
+	} else {
+		filp->f_pos = offset;
+		filp->f_version = 0;
+	}
+
+	mutex_unlock(&srom->lock);
+
+	return offset;
+}
+
+static ssize_t total_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct srom_dev *srom = dev_get_drvdata(dev);
+	return sprintf(buf, "%u\n", srom->total_size);
+}
+
+static ssize_t sector_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	struct srom_dev *srom = dev_get_drvdata(dev);
+	return sprintf(buf, "%u\n", srom->sector_size);
+}
+
+static ssize_t page_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	struct srom_dev *srom = dev_get_drvdata(dev);
+	return sprintf(buf, "%u\n", srom->page_size);
+}
+
+static struct device_attribute srom_dev_attrs[] = {
+	__ATTR(total_size, S_IRUGO, total_show, NULL),
+	__ATTR(sector_size, S_IRUGO, sector_show, NULL),
+	__ATTR(page_size, S_IRUGO, page_show, NULL),
+	__ATTR_NULL
+};
+
+static char *srom_devnode(struct device *dev, mode_t *mode)
+{
+	*mode = S_IRUGO | S_IWUSR;
+	return kasprintf(GFP_KERNEL, "srom/%s", dev_name(dev));
+}
+
+/*
+ * The fops
+ */
+static const struct file_operations srom_fops = {
+	.owner =     THIS_MODULE,
+	.llseek =    srom_llseek,
+	.read =	     srom_read,
+	.write =     srom_write,
+	.open =	     srom_open,
+	.release =   srom_release,
+};
+
+/**
+ * srom_setup_minor() - Initialize per-minor information.
+ * @srom: Per-device SROM state.
+ * @index: Device to set up.
+ */
+static int srom_setup_minor(struct srom_dev *srom, int index)
+{
+	struct device *dev;
+	int devhdl = srom->hv_devhdl;
+
+	mutex_init(&srom->lock);
+
+	if (_srom_read(devhdl, &srom->total_size,
+		       SROM_TOTAL_SIZE_OFF, sizeof(srom->total_size)) < 0)
+		return -EIO;
+	if (_srom_read(devhdl, &srom->sector_size,
+		       SROM_SECTOR_SIZE_OFF, sizeof(srom->sector_size)) < 0)
+		return -EIO;
+	if (_srom_read(devhdl, &srom->page_size,
+		       SROM_PAGE_SIZE_OFF, sizeof(srom->page_size)) < 0)
+		return -EIO;
+
+	dev = device_create(srom_class, &platform_bus,
+			    MKDEV(srom_major, index), srom, "%d", index);
+	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+}
+
+/** srom_init() - Initialize the driver's module. */
+static int srom_init(void)
+{
+	int result, i;
+	dev_t dev = MKDEV(srom_major, 0);
+
+	/*
+	 * Start with a plausible number of partitions; the krealloc() call
+	 * below will yield about log(srom_devs) additional allocations.
+	 */
+	srom_devices = kzalloc(4 * sizeof(struct srom_dev), GFP_KERNEL);
+
+	/* Discover the number of srom partitions. */
+	for (i = 0; ; i++) {
+		int devhdl;
+		char buf[20];
+		struct srom_dev *new_srom_devices =
+			krealloc(srom_devices, (i+1) * sizeof(struct srom_dev),
+				 GFP_KERNEL | __GFP_ZERO);
+		if (!new_srom_devices) {
+			result = -ENOMEM;
+			goto fail_mem;
+		}
+		srom_devices = new_srom_devices;
+		sprintf(buf, "srom/0/%d", i);
+		devhdl = hv_dev_open((HV_VirtAddr)buf, 0);
+		if (devhdl < 0) {
+			if (devhdl != HV_ENODEV)
+				pr_notice("srom/%d: hv_dev_open failed: %d.\n",
+					  i, devhdl);
+			break;
+		}
+		srom_devices[i].hv_devhdl = devhdl;
+	}
+	srom_devs = i;
+
+	/* Bail out early if we have no partitions at all. */
+	if (srom_devs == 0) {
+		result = -ENODEV;
+		goto fail_mem;
+	}
+
+	/* Register our major, and accept a dynamic number. */
+	if (srom_major)
+		result = register_chrdev_region(dev, srom_devs, "srom");
+	else {
+		result = alloc_chrdev_region(&dev, 0, srom_devs, "srom");
+		srom_major = MAJOR(dev);
+	}
+	if (result < 0)
+		goto fail_mem;
+
+	/* Register a character device. */
+	cdev_init(&srom_cdev, &srom_fops);
+	srom_cdev.owner = THIS_MODULE;
+	srom_cdev.ops = &srom_fops;
+	result = cdev_add(&srom_cdev, dev, srom_devs);
+	if (result < 0)
+		goto fail_chrdev;
+
+	/* Create a sysfs class. */
+	srom_class = class_create(THIS_MODULE, "srom");
+	if (IS_ERR(srom_class)) {
+		result = PTR_ERR(srom_class);
+		goto fail_cdev;
+	}
+	srom_class->dev_attrs = srom_dev_attrs;
+	srom_class->devnode = srom_devnode;
+
+	/* Do per-partition initialization */
+	for (i = 0; i < srom_devs; i++) {
+		result = srom_setup_minor(srom_devices + i, i);
+		if (result < 0)
+			goto fail_class;
+	}
+
+	return 0;
+
+fail_class:
+	for (i = 0; i < srom_devs; i++)
+		device_destroy(srom_class, MKDEV(srom_major, i));
+	class_destroy(srom_class);
+fail_cdev:
+	cdev_del(&srom_cdev);
+fail_chrdev:
+	unregister_chrdev_region(dev, srom_devs);
+fail_mem:
+	kfree(srom_devices);
+	return result;
+}
+
+/** srom_cleanup() - Clean up the driver's module. */
+static void srom_cleanup(void)
+{
+	int i;
+	for (i = 0; i < srom_devs; i++)
+		device_destroy(srom_class, MKDEV(srom_major, i));
+	class_destroy(srom_class);
+	cdev_del(&srom_cdev);
+	unregister_chrdev_region(MKDEV(srom_major, 0), srom_devs);
+	kfree(srom_devices);
+}
+
+module_init(srom_init);
+module_exit(srom_cleanup);
-- 
1.6.5.2

