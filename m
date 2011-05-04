Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab1EDUEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:04:50 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:14686 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab1EDUEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:04:47 -0400
Message-Id: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 4 May 2011 15:10:32 -0400
Subject: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM driver
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 04 May 2011 20:04:47.0027 (UTC) FILETIME=[8470F830:01CC0A96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit does two things: it adds the infrastructure for a new
arch/tile/drivers/ directory, and it populates it with the first
instance of a driver for that directory, a SPI Flash ROM (srom) driver.

The directory is motivated as follows.  While some classes of
driver implementations should be grouped together so they are easily
modified as a class (network, ATA, RTC, PCI, I2C, etc etc) there are
"miscellaneous" drivers that don't benefit from any sharing with other
driver implementations.  If those drivers are for hardware that can
plausibly be used by multiple architectures, it makes sense to put
them somewhere like drivers/char.  But if they are only usable on
a single architecture (in this case drivers written for the Tilera
para-virtualization model using our hypervisor) it makes sense to group
such drivers with their architecture, to avoid cluttering the "drivers"
hierarchy for other architectures that can't use that driver.

The actual SROM driver is fairly uncontroversial, and is just a simple
driver that allows user space to read and write the SROM at a raw level.
(A separate MTD driver exists for "tile", but this is not that driver.)
The driver is particularly useful since the Tile chip can boot directly
from the SROM, so providing this driver interface allows for updating
the boot image prior to a reboot.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig                    |    2 +
 arch/tile/Makefile                   |    2 +
 arch/tile/configs/tile_defconfig     |    1 +
 arch/tile/configs/tilegx_defconfig   |    1 +
 arch/tile/drivers/Kconfig            |    8 +
 arch/tile/drivers/Makefile           |   13 +
 arch/tile/drivers/srom.c             |  499 ++++++++++++++++++++++++++++++++++
 arch/tile/include/hv/drv_srom_intf.h |   41 +++
 8 files changed, 567 insertions(+), 0 deletions(-)
 create mode 100644 arch/tile/drivers/Kconfig
 create mode 100644 arch/tile/drivers/Makefile
 create mode 100644 arch/tile/drivers/srom.c
 create mode 100644 arch/tile/include/hv/drv_srom_intf.h

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 635e1bf..be47e07 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -315,6 +315,8 @@ config KERNEL_PL
 	  kernel will be built to run at.  Generally you should use
 	  the default value here.
 
+source "arch/tile/drivers/Kconfig"
+
 endmenu  # Tilera-specific configuration
 
 menu "Bus options"
diff --git a/arch/tile/Makefile b/arch/tile/Makefile
index 17acce7..d7f778c 100644
--- a/arch/tile/Makefile
+++ b/arch/tile/Makefile
@@ -50,6 +50,8 @@ head-y		:= arch/tile/kernel/head_$(BITS).o
 libs-y		+= arch/tile/lib/
 libs-y		+= $(LIBGCC_PATH)
 
+drivers-y	+= arch/tile/drivers/
+
 # See arch/tile/Kbuild for content of core part of the kernel
 core-y		+= arch/tile/
 
diff --git a/arch/tile/configs/tile_defconfig b/arch/tile/configs/tile_defconfig
index cb47612..041c456 100644
--- a/arch/tile/configs/tile_defconfig
+++ b/arch/tile/configs/tile_defconfig
@@ -224,6 +224,7 @@ CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
 CONFIG_VMALLOC_RESERVE=0x1000000
 CONFIG_HARDWALL=y
 CONFIG_KERNEL_PL=1
+CONFIG_TILE_SROM=y
 
 #
 # Bus options
diff --git a/arch/tile/configs/tilegx_defconfig b/arch/tile/configs/tilegx_defconfig
index 776ec0c..6343962 100644
--- a/arch/tile/configs/tilegx_defconfig
+++ b/arch/tile/configs/tilegx_defconfig
@@ -251,6 +251,7 @@ CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
 CONFIG_VMALLOC_RESERVE=0x1000000
 CONFIG_HARDWALL=y
 CONFIG_KERNEL_PL=1
+CONFIG_TILE_SROM=y
 
 #
 # Bus options
diff --git a/arch/tile/drivers/Kconfig b/arch/tile/drivers/Kconfig
new file mode 100644
index 0000000..e1f9551
--- /dev/null
+++ b/arch/tile/drivers/Kconfig
@@ -0,0 +1,8 @@
+config TILE_SROM
+	bool "Character-device access to the Tilera on-board SROM"
+	default y
+	---help---
+	  This device provides character-level read-write access
+	  to the SROM, typically via the "0", "1", "2", and "info"
+	  devices in /dev/srom/.
+
diff --git a/arch/tile/drivers/Makefile b/arch/tile/drivers/Makefile
new file mode 100644
index 0000000..311e741
--- /dev/null
+++ b/arch/tile/drivers/Makefile
@@ -0,0 +1,13 @@
+#
+# Makefile for TILE drivers that don't belong elsewhere in the tree.
+# Typically these are drivers that just present a simple char
+# file_operations interface.
+#
+# For other Tilera-specific drivers, see:
+#
+#  drivers/net/tile/			network
+#  drivers/tty/hvc/hvc_tile.c		hypervisor console
+#  drivers/edac/tile_edac.c		EDAC driver
+#
+
+obj-$(CONFIG_TILE_SROM)		+= srom.o
diff --git a/arch/tile/drivers/srom.c b/arch/tile/drivers/srom.c
new file mode 100644
index 0000000..1a5b070
--- /dev/null
+++ b/arch/tile/drivers/srom.c
@@ -0,0 +1,499 @@
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
+#define SROM_CHUNK_SIZE 4096
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
+/**
+ * Macro to complete a read/write transaction. Returns last hv
+ * syscall return value.
+ */
+#define SROM_RD_OR_WR(func, ...) \
+	({								\
+	int _hv_retval = func(__VA_ARGS__);				\
+	int retries;							\
+									\
+	while (_hv_retval < 0) {					\
+		if (_hv_retval == HV_EBUSY) {				\
+			retries = SROM_MAX_WAIT_TRY_TIMES;		\
+									\
+			while (retries > 0) {				\
+				_hv_retval = func(__VA_ARGS__);		\
+				if (_hv_retval == HV_EBUSY) {		\
+					msleep(SROM_WAIT_TRY_INTERVAL);	\
+					retries--;			\
+				} else {				\
+					break;				\
+				}					\
+			}						\
+									\
+			if (_hv_retval == HV_EBUSY) {			\
+				pr_err("srom: "#func" failed ("		\
+				       "timeout)\n");			\
+				retval = -EIO;				\
+				goto op_done;				\
+			}						\
+		} else if (_hv_retval == HV_EAGAIN) {			\
+			_hv_retval = func(__VA_ARGS__);			\
+		} else {						\
+			pr_err("srom: "#func" failed, "			\
+				"error %d\n", _hv_retval);		\
+			retval = -EIO;					\
+			goto op_done;					\
+		}							\
+	}								\
+	_hv_retval;							\
+	})
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
+				hv_dev_pread(dev->hv_devhdl, 0,
+					     (HV_VirtAddr)&dev->size,
+					     sizeof(dev->size),
+					     SROM_TOTAL_SIZE_OFF);
+				mutex_unlock(&dev->srom_lock);
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
+				hv_dev_pread(dev->hv_devhdl, 0,
+					     (HV_VirtAddr)&sector_size,
+					     sizeof(sector_size),
+					     SROM_SECTOR_SIZE_OFF);
+				hv_dev_pread(dev->hv_devhdl, 0,
+					     (HV_VirtAddr)&page_size,
+					     sizeof(page_size),
+					     SROM_PAGE_SIZE_OFF);
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
+	if (dev->hv_devhdl > 0) {
+		SROM_RD_OR_WR(hv_dev_pwrite, dev->hv_devhdl,
+			      0, (HV_VirtAddr)&dummy, 1, SROM_FLUSH_OFF);
+	}
+
+op_done:
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
+		int bytes_this_pass = count;
+
+		if (bytes_this_pass > SROM_CHUNK_SIZE)
+			bytes_this_pass = SROM_CHUNK_SIZE;
+
+		hv_retval = SROM_RD_OR_WR(hv_dev_pread, dev->hv_devhdl,
+			      0, (HV_VirtAddr) kernbuf, bytes_this_pass,
+			      *f_pos);
+
+		if (hv_retval > 0) {
+			if (copy_to_user(buf, kernbuf, hv_retval) != 0) {
+				retval = -EFAULT;
+				break;
+			}
+		} else if (hv_retval == 0) {
+			break;
+		}
+
+		retval += hv_retval;
+		*f_pos += hv_retval;
+		buf += hv_retval;
+		count -= hv_retval;
+	}
+
+op_done:
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
+		int bytes_this_pass = count;
+
+		if (bytes_this_pass > SROM_CHUNK_SIZE)
+			bytes_this_pass = SROM_CHUNK_SIZE;
+
+		if (copy_from_user(kernbuf, buf, bytes_this_pass) != 0) {
+			retval = -EFAULT;
+			break;
+		}
+
+		hv_retval = SROM_RD_OR_WR(hv_dev_pwrite, dev->hv_devhdl,
+			      0, (HV_VirtAddr) kernbuf, bytes_this_pass,
+			      *f_pos);
+
+		if (hv_retval == 0)
+			break;
+
+		retval += hv_retval;
+		*f_pos += hv_retval;
+		buf += hv_retval;
+		count -= hv_retval;
+	}
+
+op_done:
+	mutex_unlock(&dev->srom_lock);
+	kfree(kernbuf);
+
+	return retval;
+}
+
+/**
+ * srom_llseek() - Change the current device offset.
+ * @filp: File for this specific open of the device.
+ * @off: New offset value.
+ * @whence: Base for new offset value.
+ *
+ * Returns new offset, or an error code.
+ */
+static loff_t srom_llseek(struct file *filp, loff_t off, int whence)
+{
+	struct srom_dev *dev = filp->private_data;
+	long newpos;
+
+	switch (whence) {
+	case 0: /* SEEK_SET */
+		newpos = off;
+		break;
+
+	case 1: /* SEEK_CUR */
+		newpos = filp->f_pos + off;
+		break;
+
+	case 2: /* SEEK_END */
+		newpos = dev->size + off;
+		break;
+
+	default: /* can't happen */
+		return -EINVAL;
+	}
+
+	if (newpos < 0 || newpos > dev->size)
+		return -EINVAL;
+
+	filp->f_pos = newpos;
+	return newpos;
+}
+
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
-- 
1.6.5.2

