Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1E1PQr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:16:47 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:6292 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1E1PQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:16:45 -0400
Message-Id: <201105281516.p4SFGfHg024703@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sat, 28 May 2011 11:13:54 -0400
Subject: [PATCH v2] arch/tile: add hypervisor-based character driver for SPI flash ROM
To: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Eric Biederman <ebiederm@aristanetworks.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
In-Reply-To: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>
	<4DD6FB9E.2050604@tilera.com>
	<20110521032102.GD19907@suse.de>
	<201105211133.50238.arnd@arndb.de>
	<4DD7C3A7.5010402@tilera.com>
	<BANLkTim-d-8w1_idg4u302aB3MqTo7q4Sg@mail.gmail.com>
X-OriginalArrivalTime: 28 May 2011 15:16:44.0824 (UTC) FILETIME=[415C1180:01CC1D4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first version of this patch proposed an arch/tile/drivers/ directory,
but the consensus was that this was probably a poor choice for a place to
group Tilera-specific drivers, and that in any case grouping by platform
was discouraged, and grouping by function was preferred.

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
 drivers/char/tile-srom.c             |  453 ++++++++++++++++++++++++++++++++++
 4 files changed, 507 insertions(+), 0 deletions(-)
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
index ad59b4e..d3c84c5 100644
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
index 0000000..9e03826
--- /dev/null
+++ b/drivers/char/tile-srom.c
@@ -0,0 +1,453 @@
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
+ * Drivers" by Alessandro Rubini and Jonathan Corbet, published by
+ * O'Reilly & Associates.
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
+	struct cdev cdev;		/* Character device structure */
+	int hv_devhdl;			/* Handle for hypervisor device */
+	u32 size;		        /* Size of this device */
+	char *info_string;		/* String returned by the info device
+					   if this is it; NULL otherwise */
+	struct mutex srom_lock;		/* Allow only one accessor at a time */
+};
+
+static int srom_major;		/* Dynamic major by default */
+static int srom_devs =    4;	/* One per SROM partition plus one info file */
+
+/* Minor number of the info file */
+static inline int srom_info_minor(void)
+{
+	return srom_devs - 1;
+}
+
+module_param(srom_major, int, 0);
+module_param(srom_devs, int, 0);
+MODULE_AUTHOR("Tilera Corporation");
+MODULE_LICENSE("Dual BSD/GPL");
+
+static struct srom_dev *srom_devices; /* allocated in srom_init */
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
+	struct srom_dev *dev;
+
+	/* Find the device */
+	dev = container_of(inode->i_cdev, struct srom_dev, cdev);
+
+	/* Now open the hypervisor device if we haven't already. */
+	if (dev->hv_devhdl == 0) {
+		char buf[20];
+		int instance = iminor(inode);
+		if (instance != srom_info_minor()) {
+			sprintf(buf, "srom/0/%d", instance);
+			dev->hv_devhdl = hv_dev_open((HV_VirtAddr)buf, 0);
+			if (dev->hv_devhdl > 0) {
+				dev->size = 0;
+				if (mutex_lock_interruptible(&dev->srom_lock))
+					return -ERESTARTSYS;
+				_srom_read(dev->hv_devhdl, &dev->size,
+					   SROM_TOTAL_SIZE_OFF,
+					   sizeof(dev->size));
+				mutex_unlock(&dev->srom_lock);
+				i_size_write(inode, dev->size);
+			}
+		} else {
+			u32 sector_size = 0;
+			u32 page_size = 0;
+
+			sprintf(buf, "srom/0/0");
+			dev->hv_devhdl = hv_dev_open((HV_VirtAddr)buf, 0);
+			if (dev->hv_devhdl > 0) {
+				static const int info_string_size = 80;
+
+				if (mutex_lock_interruptible(&dev->srom_lock))
+					return -ERESTARTSYS;
+				_srom_read(dev->hv_devhdl, &sector_size,
+					   SROM_SECTOR_SIZE_OFF,
+					   sizeof(sector_size));
+				_srom_read(dev->hv_devhdl, &page_size,
+					   SROM_PAGE_SIZE_OFF,
+					   sizeof(page_size));
+				mutex_unlock(&dev->srom_lock);
+
+				dev->info_string = kmalloc(info_string_size,
+							GFP_KERNEL);
+				snprintf(dev->info_string, info_string_size,
+					"sector_size: %d\npage_size: %d\n",
+					sector_size, page_size);
+			}
+		}
+	}
+
+	/* If we tried and failed to open it, fail. */
+	if (dev->hv_devhdl < 0) {
+		switch (dev->hv_devhdl)	{
+		case HV_ENODEV:
+			return -ENODEV;
+		default:
+			return (ssize_t)dev->hv_devhdl;
+		}
+	}
+
+	filp->private_data = dev;
+
+	return 0;          /* success */
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
+	struct srom_dev *dev = filp->private_data;
+	int retval = 0;
+	char dummy;
+
+	/*
+	 * First we need to make sure we've flushed anything written to
+	 * the ROM.
+	 */
+	if (mutex_lock_interruptible(&dev->srom_lock)) {
+		retval = -ERESTARTSYS;
+		filp->private_data = NULL;
+		return retval;
+	}
+
+	if (dev->hv_devhdl > 0)
+		_srom_write(dev->hv_devhdl, &dummy, SROM_FLUSH_OFF, 1);
+
+	mutex_unlock(&dev->srom_lock);
+	filp->private_data = NULL;
+
+	return retval;
+}
+
+
+/**
+ * srom_read() - Read (control) data from the device.
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
+	struct srom_dev *dev = filp->private_data;
+
+	if (dev->hv_devhdl < 0)
+		return -EINVAL;
+
+	if (dev->info_string) {
+		int info_len = strlen(dev->info_string);
+		int bytes_avail = info_len - *f_pos;
+		int xfer_len = (bytes_avail < count) ? bytes_avail : count;
+
+		if (xfer_len <= 0)
+			return 0;
+
+		if (copy_to_user(buf, dev->info_string + *f_pos, xfer_len))
+			return -EFAULT;
+		*f_pos += xfer_len;
+		return xfer_len;
+	}
+
+	kernbuf = kmalloc(SROM_CHUNK_SIZE, GFP_KERNEL);
+	if (!kernbuf)
+		return -ENOMEM;
+
+	if (mutex_lock_interruptible(&dev->srom_lock)) {
+		retval = -ERESTARTSYS;
+		kfree(kernbuf);
+		return retval;
+	}
+
+	while (count) {
+		int hv_retval;
+		int bytes_this_pass = min(count, SROM_CHUNK_SIZE);
+
+		hv_retval = _srom_read(dev->hv_devhdl, kernbuf,
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
+	mutex_unlock(&dev->srom_lock);
+	kfree(kernbuf);
+
+	return retval;
+}
+
+/**
+ * srom_write() - Write (control) data to the device.
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
+	struct srom_dev *dev = filp->private_data;
+
+	if (dev->hv_devhdl < 0 || dev->info_string)
+		return -EINVAL;
+
+	kernbuf = kmalloc(SROM_CHUNK_SIZE, GFP_KERNEL);
+	if (!kernbuf)
+		return -ENOMEM;
+
+	if (mutex_lock_interruptible(&dev->srom_lock)) {
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
+		hv_retval = _srom_write(dev->hv_devhdl, kernbuf,
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
+	mutex_unlock(&dev->srom_lock);
+	kfree(kernbuf);
+
+	return retval;
+}
+
+
+/*
+ * The fops
+ */
+static const struct file_operations srom_fops = {
+	.owner =     THIS_MODULE,
+	.llseek =    generic_file_llseek,
+	.read =	     srom_read,
+	.write =     srom_write,
+	.open =	     srom_open,
+	.release =   srom_release,
+};
+
+/**
+ * srom_setup_cdev() - Set up a device instance in the cdev table.
+ * @dev: Per-device SROM state.
+ * @index: Device to set up.
+ */
+static void srom_setup_cdev(struct srom_dev *dev, int index)
+{
+	int err, devno = MKDEV(srom_major, index);
+
+	cdev_init(&dev->cdev, &srom_fops);
+	dev->cdev.owner = THIS_MODULE;
+	dev->cdev.ops = &srom_fops;
+	err = cdev_add(&dev->cdev, devno, 1);
+	/* Fail gracefully if need be */
+	if (err)
+		pr_notice("Error %d adding srom%d", err, index);
+}
+
+/** srom_init() - Initialize the driver's module. */
+static int srom_init(void)
+{
+	int result, i;
+	dev_t dev = MKDEV(srom_major, 0);
+
+	/*
+	 * Register our major, and accept a dynamic number.
+	 */
+	if (srom_major)
+		result = register_chrdev_region(dev, srom_devs, "srom");
+	else {
+		result = alloc_chrdev_region(&dev, 0, srom_devs, "srom");
+		srom_major = MAJOR(dev);
+	}
+	if (result < 0)
+		return result;
+
+
+	/*
+	 * Allocate the devices -- we can't have them static, as the number
+	 * can be specified at load time.
+	 */
+	srom_devices = kzalloc(srom_devs * sizeof(struct srom_dev),
+			       GFP_KERNEL);
+	if (!srom_devices) {
+		unregister_chrdev_region(dev, srom_devs);
+		return -ENOMEM;
+	}
+	for (i = 0; i < srom_devs; i++) {
+		srom_setup_cdev(srom_devices + i, i);
+		mutex_init(&srom_devices[i].srom_lock);
+	}
+
+	return 0; /* succeed */
+}
+
+/** srom_cleanup() - Clean up the driver's module. */
+static void srom_cleanup(void)
+{
+	int i;
+
+	for (i = 0; i < srom_devs; i++) {
+		cdev_del(&srom_devices[i].cdev);
+		kfree(srom_devices[i].info_string);
+	}
+	kfree(srom_devices);
+	unregister_chrdev_region(MKDEV(srom_major, 0), srom_devs);
+}
+
+module_init(srom_init);
+module_exit(srom_cleanup);
-- 
1.6.5.2

