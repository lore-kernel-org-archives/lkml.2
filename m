Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1CYRO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:14:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37607 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab1CYROx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:14:53 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: vapier@gentoo.org, gregkh@suse.de, Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCHv3 1/4] drivers/otp: add initial support for OTP memory
Date: Fri, 25 Mar 2011 17:14:40 +0000
Message-Id: <1301073283-30821-2-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1301073283-30821-1-git-send-email-jamie@jamieiles.com>
References: <1301073283-30821-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OTP memory is typically found in some embedded devices and can be
used for storing boot code, cryptographic keys and other persistent
information onchip.  This patch adds a generic layer that devices can
register OTP with and allows access through a set of character
device nodes.

Changes since v3:
	- Updated ABI documentation.
	- Don't put the OTP regions directly in /sys/bus/otp/devices.
	- Squash the ioctl addition patch into this one.
	- Add CONFIG_OTP_WRITE_ENABLE to allow OTP support to be build
	  without allowing write accesses to OTP.
	- Add the "ecc" redundancy format.
	- Permit registration of multiple OTP devices.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 Documentation/ABI/testing/sysfs-bus-otp |   93 ++++
 drivers/Kconfig                         |    2 +
 drivers/Makefile                        |    1 +
 drivers/otp/Kconfig                     |   28 +
 drivers/otp/Makefile                    |    1 +
 drivers/otp/otp.c                       |  913 +++++++++++++++++++++++++++++++
 include/linux/otp.h                     |  277 ++++++++++
 7 files changed, 1315 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-otp
 create mode 100644 drivers/otp/Kconfig
 create mode 100644 drivers/otp/Makefile
 create mode 100644 drivers/otp/otp.c
 create mode 100644 include/linux/otp.h

diff --git a/Documentation/ABI/testing/sysfs-bus-otp b/Documentation/ABI/testing/sysfs-bus-otp
new file mode 100644
index 0000000..fb98efa
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-otp
@@ -0,0 +1,93 @@
+What:           /sys/bus/otp/
+Date:           March 2011
+KernelVersion:  2.6.40+
+Contact:        Jamie Iles <jamie@jamieiles.com>
+Description:
+		The otp bus presents a number of devices where each
+		device represents and OTP device in the system.  An OTP device
+		may have a number of regions (which can be thought of as
+		partitions) and the regions are child devices.  Each region
+		will create a device node which allows the region to be
+		written with read()/write() calls and the device on the bus
+		has attributes for controlling the redundancy format and
+		getting the region size.
+
+What:		/sys/bus/devices/otp#/
+Date:		March 2011
+KernelVersion:	2.6.40+
+Contact:	Jamie Iles <jamie@jamieiles.com>
+Description:
+		Each otp# directory represents an OTP device in the system.
+		The device has attributes that affect all of the regions in
+		the device such as write_enable and the number of regions.
+
+What:		/sys/bus/devices/otp#/otp#N
+Date:		March 2011
+KernelVersion:	2.6.40+
+Contact:	Jamie Iles <jamie@jamieiles.com>
+Description:
+		Each otp#N directory represents a region in the otp# device.
+		A region may be read from/written to through the character
+		device node named after the otp#N name.
+
+What:		/sys/bus/devices/otp#/write_enable
+Date:		March 2011
+KernelVersion:	2.6.40+
+Contact:	Jamie Iles <jamie@jamieiles.com>
+Description:
+		This file controls whether the OTP device can be written to.
+		If set to "enabled" then the regions may be written, the
+		number of regions may be changed and the format of any region
+		may be changed.
+
+What:		/sys/bus/devices/otp#/num_regions
+Date:		March 2011
+KernelVersion:	2.6.40+
+Contact:	Jamie Iles <jamie@jamieiles.com>
+Description:
+		This file controls the number of regions in the OTP device.
+		Valid values are 1, 2, 4 and 8. The number of regions may be
+		increased but never decreased. Increasing the number of
+		regions will create new devices on the otp bus.
+
+What:		/sys/bus/devices/otp#/strict_programming
+Date:		March 2011
+KernelVersion:	2.6.40+
+Contact:	Jamie Iles <jamie@jamieiles.com>
+Description:
+		This file indicates whether all words in a redundant format
+		must be programmed correctly to indicate success.  For
+		example, using the "redundant format", the same word is
+		written to two locations and wire-OR'd when reading back.
+		Disabling this will mean that programming will be considered a
+		success if the word can be read back correctly in its
+		redundant format even if there are bit errors when programming
+		the extra redundancy words.
+
+What:           /sys/bus/otp/devices/otp#/otp#N/format
+Date:           March 2011
+KernelVersion:  2.6.40+
+Contact:        Jamie Iles <jamie@jamieiles.com>
+Description:
+                The redundancy format of the region. Valid values are:
+			- single-ended (1 bit of storage per data bit).
+			- redundant (2 bits of storage, wire-OR'd per data
+			  bit).
+			- differential (2 bits of storage, differential
+			  voltage per data bit).
+			- differential-redundant (4 bits of storage, combining
+			  redundant and differential).
+			- ecc (transparent to the user)
+		Depending on the device type, it may be possible to increase
+		redundancy of a region but care will be needed if there is
+		data already in the region.
+
+What:           /sys/bus/otp/devices/otp#/otp#N/size
+Date:           March 2011
+KernelVersion:  2.6.40+
+Contact:        Jamie Iles <jamie@jamieiles.com>
+Description:
+                The effective storage size of the region. This is the amount
+		of data that a user can store in the region taking into
+		account the number of regions and the redundancy format of the
+		region itself.
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 177c7d1..77da156 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -119,4 +119,6 @@ source "drivers/platform/Kconfig"
 source "drivers/clk/Kconfig"
 
 source "drivers/hwspinlock/Kconfig"
+
+source "drivers/otp/Kconfig"
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 3f135b6..6ae2f815 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -119,3 +119,4 @@ obj-y				+= ieee802154/
 obj-y				+= clk/
 
 obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
+obj-$(CONFIG_OTP)		+= otp/
diff --git a/drivers/otp/Kconfig b/drivers/otp/Kconfig
new file mode 100644
index 0000000..9a529c6
--- /dev/null
+++ b/drivers/otp/Kconfig
@@ -0,0 +1,28 @@
+#
+# OTP memory configuration
+#
+
+menuconfig OTP
+	bool "OTP memory support"
+	help
+	  Say Y here to support OTP memory.  This memory can commonly be used
+	  to store boot code, cryptographic keys and other persistent data.
+	  This memory is typically a few KBytes in size and different devices
+	  may have different characterstics.  This provides a character device
+	  interface to these devices to allow the OTP to be programmed and
+	  read.
+
+if OTP
+
+config WRITE_ENABLE
+	bool "Enable writing support of OTP pages"
+	default n
+	help
+	  If you say Y here, you will enable support for writing of the
+	  OTP pages.  This is dangerous by nature as you can only program
+	  the pages once, so only enable this option when you actually
+	  need it so as to not inadvertently clobber data.
+
+	  If unsure, say N.
+
+endif
diff --git a/drivers/otp/Makefile b/drivers/otp/Makefile
new file mode 100644
index 0000000..84fd03e
--- /dev/null
+++ b/drivers/otp/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_OTP)	+= otp.o
diff --git a/drivers/otp/otp.c b/drivers/otp/otp.c
new file mode 100644
index 0000000..42e3016
--- /dev/null
+++ b/drivers/otp/otp.c
@@ -0,0 +1,913 @@
+/*
+ * Copyright (c) 2011 Picochip Ltd., Jamie Iles
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * All enquiries to support@picochip.com
+ */
+#define pr_fmt(fmt) "otp: " fmt
+
+#include <linux/cdev.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/io.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/otp.h>
+#include <linux/slab.h>
+#include <linux/sysfs.h>
+#include <linux/uaccess.h>
+
+/* We'll allow OTP devices to be named otpa-otpz. */
+#define MAX_OTP_DEVICES		26
+
+static unsigned long registered_otp_map[BITS_TO_LONGS(MAX_OTP_DEVICES)];
+static DEFINE_MUTEX(otp_register_mutex);
+
+/*
+ * The otp currently works in 64 bit words. When we are programming or
+ * reading, everything is done with 64 bit word addresses.
+ */
+#define OTP_WORD_SIZE			8
+
+bool otp_strict_programming_enabled(struct otp_device *otp_dev)
+{
+	return otp_dev->strict_programming;
+}
+EXPORT_SYMBOL_GPL(otp_strict_programming_enabled);
+
+bool otp_write_enabled(struct otp_device *otp_dev)
+{
+#ifdef CONFIG_OTP_WRITE_ENABLE
+	return otp_dev->write_enable;
+#else /* CONFIG_OTP_WRITE_ENABLE */
+	return false;
+#endif /* CONFIG_OTP_WRITE_ENABLE */
+}
+EXPORT_SYMBOL_GPL(otp_write_enabled);
+
+static ssize_t otp_format_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct otp_region *region = to_otp_region(dev);
+	struct otp_device *otp_dev = to_otp_device(region->dev.parent);
+	enum otp_redundancy_fmt fmt;
+	const char *fmt_string;
+
+	if (mutex_lock_interruptible(&otp_dev->lock))
+		return -ERESTARTSYS;
+
+	if (region->ops->get_fmt(region))
+		fmt = region->ops->get_fmt(region);
+	else
+		fmt = OTP_REDUNDANCY_FMT_SINGLE_ENDED;
+
+	mutex_unlock(&otp_dev->lock);
+
+	if (fmt == OTP_REDUNDANCY_FMT_SINGLE_ENDED)
+		fmt_string = "single-ended";
+	else if (fmt == OTP_REDUNDANCY_FMT_REDUNDANT)
+		fmt_string = "redundant";
+	else if (fmt == OTP_REDUNDANCY_FMT_DIFFERENTIAL)
+		fmt_string = "differential";
+	else if (fmt == OTP_REDUNDANCY_FMT_DIFFERENTIAL_REDUNDANT)
+		fmt_string = "differential-redundant";
+	else if (fmt == OTP_REDUNDANCY_FMT_ECC)
+		fmt_string = "ecc";
+	else
+		return -EINVAL;
+
+	return sprintf(buf, "%s\n", fmt_string);
+}
+
+static ssize_t otp_format_store(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t len)
+{
+	int err = 0;
+	struct otp_region *region = to_otp_region(dev);
+	struct otp_device *otp_dev = to_otp_device(region->dev.parent);
+	enum otp_redundancy_fmt new_fmt;
+
+	if (!region->ops->set_fmt)
+		return -EOPNOTSUPP;
+
+	if (mutex_lock_interruptible(&otp_dev->lock))
+		return -ERESTARTSYS;
+
+	/* This is irreversible so don't make it too easy to break it! */
+	if (!otp_write_enabled(otp_dev)) {
+		err = -EPERM;
+		goto out;
+	}
+
+	if (sysfs_streq(buf, "single-ended"))
+		new_fmt = OTP_REDUNDANCY_FMT_SINGLE_ENDED;
+	else if (sysfs_streq(buf, "redundant"))
+		new_fmt = OTP_REDUNDANCY_FMT_REDUNDANT;
+	else if (sysfs_streq(buf, "differential"))
+		new_fmt = OTP_REDUNDANCY_FMT_DIFFERENTIAL;
+	else if (sysfs_streq(buf, "differential-redundant"))
+		new_fmt = OTP_REDUNDANCY_FMT_DIFFERENTIAL_REDUNDANT;
+	else if (sysfs_streq(buf, "ecc"))
+		new_fmt = OTP_REDUNDANCY_FMT_ECC;
+	else {
+		err = -EINVAL;
+		goto out;
+	}
+
+	region->ops->set_fmt(region, new_fmt);
+
+out:
+	mutex_unlock(&otp_dev->lock);
+
+	return err ?: len;
+}
+static DEVICE_ATTR(format, S_IRUSR | S_IWUSR, otp_format_show,
+		   otp_format_store);
+
+static ssize_t otp_size_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct otp_region *region = to_otp_region(dev);
+	struct otp_device *otp_dev = to_otp_device(region->dev.parent);
+	size_t region_sz;
+
+	if (mutex_lock_interruptible(&otp_dev->lock))
+		return -ERESTARTSYS;
+
+	region_sz = region->ops->get_size(region);
+
+	mutex_unlock(&otp_dev->lock);
+
+	return sprintf(buf, "%zu\n", region_sz);
+}
+static DEVICE_ATTR(size, S_IRUSR, otp_size_show, NULL);
+
+static struct bus_type otp_bus_type = {
+	.name		= "otp",
+};
+
+static struct attribute *region_attrs[] = {
+	&dev_attr_format.attr,
+	&dev_attr_size.attr,
+	NULL,
+};
+
+static const struct attribute_group region_attr_group = {
+	.attrs		= region_attrs,
+};
+
+const struct attribute_group *region_attr_groups[] = {
+	&region_attr_group,
+	NULL,
+};
+
+static struct device_type region_type = {
+	.name		= "region",
+	.groups		= region_attr_groups,
+};
+
+static ssize_t otp_attr_store_enabled(struct device *dev, const char *buf,
+				      size_t len, int *param)
+{
+	ssize_t err = 0;
+	struct otp_device *otp_dev = to_otp_device(dev);
+
+	if (mutex_lock_interruptible(&otp_dev->lock))
+		return -ERESTARTSYS;
+
+	if (sysfs_streq(buf, "enabled"))
+		*param = 1;
+	else if (sysfs_streq(buf, "disabled"))
+		*param = 0;
+	else
+		err = -EINVAL;
+
+	mutex_unlock(&otp_dev->lock);
+
+	return err ?: len;
+}
+
+static ssize_t otp_attr_show_enabled(struct device *dev, char *buf, int param)
+{
+	ssize_t ret;
+	struct otp_device *otp_dev = to_otp_device(dev);
+
+	if (mutex_lock_interruptible(&otp_dev->lock))
+		return -ERESTARTSYS;
+
+	ret = sprintf(buf, "%s\n", param ? "enabled" : "disabled");
+
+	mutex_unlock(&otp_dev->lock);
+
+	return ret;
+}
+
+/*
+ * Show the current write enable state of the otp. Users can only program the
+ * otp when this shows 'enabled'.
+ */
+static ssize_t otp_we_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct otp_device *otp_dev = to_otp_device(dev);
+
+	return otp_attr_show_enabled(dev, buf, otp_dev->write_enable);
+}
+
+/*
+ * Set the write enable state of the otp. 'enabled' will enable programming
+ * and 'disabled' will prevent further programming from occurring. On loading
+ * the module, this will default to 'disabled'.
+ */
+#ifdef CONFIG_OTP_WRITE_ENABLE
+static ssize_t otp_we_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t len)
+{
+	struct otp_device *otp_dev = to_otp_device(dev);
+
+	return otp_attr_store_enabled(dev, buf, len, &otp_dev->write_enable);
+}
+#else
+static ssize_t otp_we_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t len)
+{
+	if (!sysfs_streq(buf, "disabled"))
+		return -EACCES;
+	return len;
+}
+#endif
+static DEVICE_ATTR(write_enable, S_IRUSR | S_IWUSR, otp_we_show, otp_we_store);
+
+/*
+ * Show the current strict programming state of the otp. If set to "enabled",
+ * then when programming, all raw words must program correctly to succeed. If
+ * disabled, then as long as the word reads back correctly in the redundant
+ * mode, then some bits may be allowed to be incorrect in the raw words.
+ */
+static ssize_t otp_strict_programming_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct otp_device *otp_dev = to_otp_device(dev);
+
+	return otp_attr_show_enabled(dev, buf, otp_dev->strict_programming);
+}
+
+/*
+ * Set the current strict programming state of the otp. If set to "enabled",
+ * then when programming, all raw words must program correctly to succeed. If
+ * disabled, then as long as the word reads back correctly in the redundant
+ * mode, then some bits may be allowed to be incorrect in the raw words.
+ */
+static ssize_t otp_strict_programming_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t len)
+{
+	struct otp_device *otp_dev = to_otp_device(dev);
+
+	return otp_attr_store_enabled(dev, buf, len,
+				      &otp_dev->strict_programming);
+}
+static DEVICE_ATTR(strict_programming, S_IRUSR | S_IWUSR,
+		   otp_strict_programming_show, otp_strict_programming_store);
+
+static ssize_t otp_num_regions_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct otp_device *otp_dev = to_otp_device(dev);
+	int nr_regions;
+
+	if (mutex_lock_interruptible(&otp_dev->lock))
+		return -ERESTARTSYS;
+	nr_regions = otp_dev->ops->get_nr_regions(otp_dev);
+	mutex_unlock(&otp_dev->lock);
+
+	if (nr_regions < 0)
+		return (ssize_t)nr_regions;
+
+	return sprintf(buf, "%d\n", nr_regions);
+}
+
+static ssize_t otp_num_regions_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	struct otp_device *otp_dev = to_otp_device(dev);
+	unsigned long nr_regions;
+	ssize_t err = 0;
+
+	if (!otp_dev->ops->set_nr_regions)
+		return -EOPNOTSUPP;
+
+	err = strict_strtoul(buf, 0, &nr_regions);
+	if (err)
+		return err;
+
+	if (mutex_lock_interruptible(&otp_dev->lock))
+		return -ERESTARTSYS;
+
+	if (!otp_write_enabled(otp_dev)) {
+		err = -EPERM;
+		goto out;
+	}
+
+	err = otp_dev->ops->set_nr_regions(otp_dev, nr_regions);
+
+out:
+	mutex_unlock(&otp_dev->lock);
+
+	return err ?: len;
+}
+static DEVICE_ATTR(num_regions, S_IRUSR | S_IWUSR, otp_num_regions_show,
+		   otp_num_regions_store);
+
+static struct attribute *otp_attrs[] = {
+	&dev_attr_strict_programming.attr,
+	&dev_attr_num_regions.attr,
+	&dev_attr_write_enable.attr,
+	NULL,
+};
+
+static const struct attribute_group otp_attr_group = {
+	.attrs		= otp_attrs,
+};
+
+static const struct attribute_group *otp_attr_groups[] = {
+	&otp_attr_group,
+	NULL,
+};
+
+static struct device_type otp_type = {
+	.name		= "otp",
+	.groups		= otp_attr_groups,
+};
+
+static void otp_dev_release(struct device *dev)
+{
+	struct otp_device *otp_dev = to_otp_device(dev);
+
+	mutex_lock(&otp_register_mutex);
+	clear_bit(otp_dev->dev_nr, registered_otp_map);
+	mutex_unlock(&otp_register_mutex);
+	unregister_chrdev_region(otp_dev->devno, otp_dev->max_regions);
+	kfree(otp_dev);
+}
+
+struct otp_device *otp_device_alloc(struct device *dev,
+				    const struct otp_device_ops *ops,
+				    size_t size, size_t word_sz,
+				    unsigned max_regions,
+				    unsigned long flags)
+{
+	struct otp_device *otp_dev;
+	int err = -EBUSY, otp_nr;
+
+	mutex_lock(&otp_register_mutex);
+	otp_nr = find_first_zero_bit(registered_otp_map, MAX_OTP_DEVICES);
+	if (otp_nr < MAX_OTP_DEVICES)
+		set_bit(otp_nr, registered_otp_map);
+	mutex_unlock(&otp_register_mutex);
+
+	if (otp_nr == MAX_OTP_DEVICES)
+		goto out;
+
+	if (word_sz != OTP_WORD_SIZE) {
+		dev_err(dev, "otp word size of %zu is not supported\n",
+			word_sz);
+		err = -EINVAL;
+		goto out_clear;
+	}
+
+	if (!dev || !get_device(dev)) {
+		err = -ENODEV;
+		goto out_clear;
+	}
+
+	otp_dev = kzalloc(sizeof(*otp_dev), GFP_KERNEL);
+	if (!otp_dev) {
+		err = -ENOMEM;
+		goto out_put;
+	}
+
+	err = alloc_chrdev_region(&otp_dev->devno, 0, max_regions, "otp");
+	if (err)
+		goto out_put;
+
+	INIT_LIST_HEAD(&otp_dev->regions);
+	mutex_init(&otp_dev->lock);
+	otp_dev->ops		= ops;
+	otp_dev->dev.release	= otp_dev_release;
+	otp_dev->dev.bus	= &otp_bus_type;
+	otp_dev->dev.type	= &otp_type;
+	otp_dev->dev.parent	= dev;
+	otp_dev->size		= size;
+	otp_dev->max_regions	= max_regions;
+	otp_dev->dev_nr		= otp_nr;
+	otp_dev->flags		= flags;
+	otp_dev->word_sz	= word_sz;
+	dev_set_name(&otp_dev->dev, "otp%c", 'a' + otp_dev->dev_nr);
+
+	otp_dev = otp_dev;
+	err = device_register(&otp_dev->dev);
+	if (err) {
+		dev_err(&otp_dev->dev, "couldn't add device\n");
+		goto out_unalloc_chrdev;
+	}
+	pr_info("device %s of %zu bytes registered\n", ops->name, size);
+	return otp_dev;
+
+out_unalloc_chrdev:
+	unregister_chrdev_region(otp_dev->devno, otp_dev->max_regions);
+out_put:
+	if (dev)
+		put_device(dev);
+out_clear:
+	clear_bit(otp_nr, registered_otp_map);
+out:
+	return err ? ERR_PTR(err) : otp_dev;
+}
+EXPORT_SYMBOL_GPL(otp_device_alloc);
+
+void otp_device_unregister(struct otp_device *dev)
+{
+	struct otp_region *region, *tmp;
+
+	list_for_each_entry_safe(region, tmp, &dev->regions, head)
+		otp_region_unregister(region);
+	device_unregister(&dev->dev);
+}
+EXPORT_SYMBOL_GPL(otp_device_unregister);
+
+static void otp_region_release(struct device *dev)
+{
+	struct otp_region *region = to_otp_region(dev);
+
+	cdev_del(&region->cdev);
+	list_del(&region->head);
+	kfree(region);
+}
+
+static int otp_open(struct inode *inode, struct file *filp)
+{
+	struct otp_region *region;
+	struct otp_device *otp_dev;
+	int ret = 0;
+
+	region = container_of(inode->i_cdev, struct otp_region, cdev);
+	otp_dev = to_otp_device(region->dev.parent);
+
+	if (!try_module_get(otp_dev->ops->owner)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (!get_device(&region->dev)) {
+		ret = -ENODEV;
+		goto out_put_module;
+	}
+	filp->private_data = region;
+
+	goto out;
+
+out_put_module:
+	module_put(otp_dev->ops->owner);
+out:
+	return ret;
+}
+
+static int otp_release(struct inode *inode, struct file *filp)
+{
+	struct otp_region *region;
+	struct otp_device *otp_dev;
+
+	region = container_of(inode->i_cdev, struct otp_region, cdev);
+	otp_dev = to_otp_device(region->dev.parent);
+
+	region = filp->private_data;
+	put_device(&region->dev);
+	module_put(otp_dev->ops->owner);
+
+	return 0;
+}
+
+#ifdef CONFIG_OTP_WRITE_ENABLE
+/*
+ * Write to the otp memory from a userspace buffer. This requires that the
+ * write_enable attribute is set to "enabled" in
+ * /sys/bus/otp/devices/otp#/write_enable
+ *
+ * If writing is not enabled, this should return -EPERM.
+ *
+ * The write method takes a buffer from userspace and writes it into the
+ * corresponding bits of the otp. The current file offset refers to the byte
+ * address of the words in the otp region that should be written to.
+ * Therefore:
+ *
+ *	- we may have to do a read-modify-write to get up to an aligned
+ *	boundary, then
+ *	- do a series of word writes, followed by,
+ *	- an optional final read-modify-write if there are less than
+ *	OTP_WORD_SIZE bytes left to write.
+ *
+ * After writing, the file offset will be updated to the next byte address. If
+ * one word fails to write then the writing is aborted at that point and no
+ * further data is written. If the user can carry on then they may call
+ * write(2) again with an updated offset.
+ */
+static ssize_t otp_write(struct file *filp, const char __user *buf, size_t len,
+			 loff_t *offs)
+{
+	ssize_t ret = 0;
+	u64 word;
+	ssize_t written = 0;
+	struct otp_region *region = filp->private_data;
+	struct otp_device *otp_dev = to_otp_device(region->dev.parent);
+	unsigned pos = (unsigned)*offs;
+	enum otp_redundancy_fmt fmt;
+
+	if (mutex_lock_interruptible(&otp_dev->lock))
+		return -ERESTARTSYS;
+
+	if (region->ops->get_fmt)
+		fmt = region->ops->get_fmt(region);
+	else
+		fmt = OTP_REDUNDANCY_FMT_SINGLE_ENDED;
+
+	if (*offs >= region->ops->get_size(region)) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	if (!otp_write_enabled(otp_dev)) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	len = min_t(size_t, len, region->ops->get_size(region) - *offs);
+	if (!len) {
+		ret = 0;
+		goto out;
+	}
+
+	if ((otp_dev->flags & OTP_DEVICE_FNO_SUBWORD_WRITE) &&
+	    ((len & otp_dev->word_sz) || (pos & otp_dev->word_sz))) {
+		dev_info(&otp_dev->dev, "unable to perform partial word writes\n");
+		ret = -EMSGSIZE;
+		goto out;
+	}
+
+	if (otp_dev->ops->set_fmt)
+		otp_dev->ops->set_fmt(otp_dev, fmt);
+
+	if (pos & (OTP_WORD_SIZE - 1)) {
+		/*
+		 * We're not currently on a otp word aligned boundary so we
+		 * need to do a read-modify-write.
+		 */
+		unsigned word_addr = pos / OTP_WORD_SIZE;
+		unsigned offset = pos % OTP_WORD_SIZE;
+		size_t bytes = min_t(size_t, OTP_WORD_SIZE - offset, len);
+
+		ret = region->ops->read_word(region, word_addr, &word);
+		if (ret)
+			goto out;
+
+		if (copy_from_user((void *)(&word) + offset, buf, bytes)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		ret = region->ops->write_word(region, word_addr, word);
+		if (ret)
+			goto out;
+
+		written += bytes;
+		len -= bytes;
+		buf += bytes;
+		pos += bytes;
+	}
+
+	/*
+	 * We're now aligned to OTP word byte boundary so we can simply copy
+	 * words from userspace and write them into the otp.
+	 */
+	while (len >= OTP_WORD_SIZE) {
+		if (copy_from_user(&word, buf, OTP_WORD_SIZE)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		ret = region->ops->write_word(region, pos / OTP_WORD_SIZE,
+					      word);
+		if (ret)
+			goto out;
+
+		written += OTP_WORD_SIZE;
+		len -= OTP_WORD_SIZE;
+		buf += OTP_WORD_SIZE;
+		pos += OTP_WORD_SIZE;
+	}
+
+	/*
+	 * We might have less than a full OTP word left so we'll need to do
+	 * another read-modify-write.
+	 */
+	if (len) {
+		ret = region->ops->read_word(region, pos / OTP_WORD_SIZE,
+					     &word);
+		if (ret)
+			goto out;
+
+		if (copy_from_user(&word, buf, len)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		ret = region->ops->write_word(region, pos / OTP_WORD_SIZE,
+					      word);
+		if (ret)
+			goto out;
+
+		written += len;
+		buf += len;
+		pos += len;
+		len = 0;
+	}
+
+	*offs += written;
+
+out:
+	mutex_unlock(&otp_dev->lock);
+	return ret ?: written;
+}
+#else /* CONFIG_OTP_WRITE_ENABLE */
+static ssize_t otp_write(struct file *filp, const char __user *buf, size_t len,
+			 loff_t *offs)
+{
+	return -EACCES;
+}
+#endif /* CONFIG_OTP_WRITE_ENABLE */
+
+static long otp_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
+{
+	struct otp_region *region = filp->private_data;
+	struct otp_device *otp_dev = to_otp_device(region->dev.parent);
+	long ret = -ENOTTY;
+
+	if (!region->ops->ioctl)
+		return -ENOTTY;
+
+	if (mutex_lock_interruptible(&otp_dev->lock))
+		return -ERESTARTSYS;
+	ret = region->ops->ioctl(region, cmd, arg);
+	mutex_unlock(&otp_dev->lock);
+
+	return ret;
+}
+
+/*
+ * Read an otp region. This switches the otp into the appropriate redundancy
+ * format so we can simply read from the beginning of the region and copy it
+ * into the user buffer.
+ */
+static ssize_t otp_read(struct file *filp, char __user *buf, size_t len,
+			loff_t *offs)
+{
+	ssize_t ret = 0;
+	u64 word;
+	ssize_t bytes_read = 0;
+	struct otp_region *region = filp->private_data;
+	struct otp_device *otp_dev = to_otp_device(region->dev.parent);
+	unsigned pos = (unsigned)*offs;
+	enum otp_redundancy_fmt fmt;
+
+	if (mutex_lock_interruptible(&otp_dev->lock))
+		return -ERESTARTSYS;
+
+	if (region->ops->get_fmt)
+		fmt = region->ops->get_fmt(region);
+	else
+		fmt = OTP_REDUNDANCY_FMT_SINGLE_ENDED;
+
+	if (*offs >= region->ops->get_size(region)) {
+		ret = 0;
+		goto out;
+	}
+
+	len = min(len, region->ops->get_size(region) - (unsigned)*offs);
+	if (!len) {
+		ret = 0;
+		goto out;
+	}
+
+	if (otp_dev->ops->set_fmt)
+		otp_dev->ops->set_fmt(otp_dev, fmt);
+
+	if (pos & (OTP_WORD_SIZE - 1)) {
+		/*
+		 * We're not currently on an 8 byte boundary so we need to
+		 * read to a bounce buffer then do the copy_to_user() with an
+		 * offset.
+		 */
+		unsigned word_addr = pos / OTP_WORD_SIZE;
+		unsigned offset = pos % OTP_WORD_SIZE;
+		size_t bytes = min_t(size_t, OTP_WORD_SIZE - offset, len);
+
+		ret = region->ops->read_word(region, word_addr, &word);
+		if (ret)
+			goto out;
+
+		if (copy_to_user(buf, (void *)(&word) + offset, bytes)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		bytes_read += bytes;
+		len -= bytes;
+		buf += bytes;
+		pos += bytes;
+	}
+
+	/*
+	 * We're now aligned to an 8 byte boundary so we can simply copy words
+	 * from the bounce buffer directly with a copy_to_user().
+	 */
+	while (len >= OTP_WORD_SIZE) {
+		ret = region->ops->read_word(region, pos / OTP_WORD_SIZE,
+					     &word);
+		if (ret)
+			goto out;
+
+		if (copy_to_user(buf, &word, OTP_WORD_SIZE)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		bytes_read += OTP_WORD_SIZE;
+		len -= OTP_WORD_SIZE;
+		buf += OTP_WORD_SIZE;
+		pos += OTP_WORD_SIZE;
+	}
+
+	/*
+	 * We might have less than 8 bytes left so we'll need to do another
+	 * copy_to_user() but with a partial word length.
+	 */
+	if (len) {
+		ret = region->ops->read_word(region, pos / OTP_WORD_SIZE,
+					     &word);
+		if (ret)
+			goto out;
+
+		if (copy_to_user(buf, &word, len)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		bytes_read += len;
+		buf += len;
+		pos += len;
+		len = 0;
+	}
+
+	*offs += bytes_read;
+
+out:
+	mutex_unlock(&otp_dev->lock);
+	return ret ?: bytes_read;
+}
+
+/*
+ * Seek to a specified position in the otp region. This can be used if
+ * userspace doesn't have pread()/pwrite() and needs to write to a specified
+ * offset in the otp.
+ */
+static loff_t otp_llseek(struct file *filp, loff_t offs, int origin)
+{
+	struct otp_region *region = filp->private_data;
+	struct otp_device *otp_dev = to_otp_device(region->dev.parent);
+	int ret = 0;
+	loff_t end;
+
+	if (mutex_lock_interruptible(&otp_dev->lock))
+		return -ERESTARTSYS;
+
+	switch (origin) {
+	case SEEK_CUR:
+		if (filp->f_pos + offs < 0 ||
+		    filp->f_pos + offs >= region->ops->get_size(region))
+			ret = -EINVAL;
+		else
+			filp->f_pos += offs;
+		break;
+
+	case SEEK_SET:
+		if (offs < 0 || offs >= region->ops->get_size(region))
+			ret = -EINVAL;
+		else
+			filp->f_pos = offs;
+		break;
+
+	case SEEK_END:
+		end = region->ops->get_size(region) - 1;
+		if (end + offs < 0 || end + offs >= end)
+			ret = -EINVAL;
+		else
+			filp->f_pos = end + offs;
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+
+	mutex_unlock(&otp_dev->lock);
+
+	return ret ?: filp->f_pos;
+}
+
+static const struct file_operations otp_fops = {
+	.owner		= THIS_MODULE,
+	.open		= otp_open,
+	.release	= otp_release,
+	.write		= otp_write,
+	.read		= otp_read,
+	.llseek		= otp_llseek,
+	.unlocked_ioctl	= otp_ioctl,
+};
+
+struct otp_region *otp_region_alloc_unlocked(struct otp_device *dev,
+					     const struct otp_region_ops *ops,
+					     int region_nr)
+{
+	struct otp_region *region;
+	int err = 0;
+	dev_t devno = MKDEV(MAJOR(dev->devno), region_nr + 1);
+
+	region = kzalloc(sizeof(*region), GFP_KERNEL);
+	if (!region) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	region->ops		= ops;
+	region->region_nr	= region_nr;
+	region->dev.parent	= &dev->dev;
+	region->dev.release	= otp_region_release;
+	region->dev.devt	= devno;
+	region->dev.type	= &region_type;
+	dev_set_name(&region->dev, "otpa%d", region_nr + 1);
+
+	cdev_init(&region->cdev, &otp_fops);
+	err = cdev_add(&region->cdev, devno, 1);
+	if (err) {
+		dev_err(&region->dev, "couldn't create cdev\n");
+		goto out_free;
+	}
+
+	err = device_register(&region->dev);
+	if (err) {
+		dev_err(&region->dev, "couldn't add device\n");
+		goto out_cdev_del;
+	}
+
+	list_add_tail(&region->head, &dev->regions);
+	goto out;
+
+out_cdev_del:
+	cdev_del(&region->cdev);
+out_free:
+	kfree(region);
+out:
+	return err ? ERR_PTR(err) : region;
+}
+EXPORT_SYMBOL_GPL(otp_region_alloc_unlocked);
+
+struct otp_region *otp_region_alloc(struct otp_device *dev,
+				    const struct otp_region_ops *ops,
+				    int region_nr)
+{
+	struct otp_region *ret;
+
+	mutex_lock(&dev->lock);
+	ret = otp_region_alloc_unlocked(dev, ops, region_nr);
+	mutex_unlock(&dev->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(otp_region_alloc);
+
+static int __init otp_init(void)
+{
+	return bus_register(&otp_bus_type);
+}
+module_init(otp_init);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jamie Iles");
+MODULE_DESCRIPTION("OTP bus driver");
diff --git a/include/linux/otp.h b/include/linux/otp.h
new file mode 100644
index 0000000..51ee6ae
--- /dev/null
+++ b/include/linux/otp.h
@@ -0,0 +1,277 @@
+/*
+ * Copyright (c) 2011 Picochip Ltd., Jamie Iles
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * All enquiries to support@picochip.com
+ *
+ * This driver implements a user interface for reading and writing OTP
+ * memory. This OTP can be used for executing secure boot code or for the
+ * secure storage of keys and any other user data.  We support multiple
+ * backends for different OTP macros.
+ *
+ * The OTP is configured through sysfs and is read and written through device
+ * nodes. The top level OTP device gains write_enable, num_regions, and
+ * strict_programming attributes. We also create an otp bus to which we add a
+ * device per region. The OTP can supports multiple regions and when we divide
+ * the regions down we create a new child device on the otp bus. This child
+ * device has format and size attributes.
+ *
+ * To update the number of regions, the format of a region or to program a
+ * region, the write_enable attribute of the OTP device must be set to
+ * "enabled".
+ */
+#ifndef __OTP_H__
+#define __OTP_H__
+
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/module.h>
+
+enum otp_redundancy_fmt {
+	OTP_REDUNDANCY_FMT_SINGLE_ENDED,
+	OTP_REDUNDANCY_FMT_REDUNDANT,
+	OTP_REDUNDANCY_FMT_DIFFERENTIAL,
+	OTP_REDUNDANCY_FMT_DIFFERENTIAL_REDUNDANT,
+	OTP_REDUNDANCY_FMT_ECC,
+};
+
+struct otp_device;
+struct otp_region;
+
+/**
+ * struct otp_device_ops - operations for the OTP device.
+ *
+ * @name:		The name of the driver backend.
+ * @owner:		The owning module.
+ * @get_nr_regions:	Get the number of regions that the OTP is partitioned
+ *			into.  Note that this is the number of regions in the
+ *			device, not the number of regions registered.
+ * @set_nr_regions:	Increase the number of partitions in the device.
+ *			Returns zero on success, negative errno on failure.
+ * @set_fmt:		Set the read-mode redundancy for the region.  The OTP
+ *			devices need to be put into the right redundancy mode
+ *			before reading/writing.
+ */
+struct otp_device_ops {
+	const char	*name;
+	struct module	*owner;
+	int		(*get_nr_regions)(struct otp_device *dev);
+	int		(*set_nr_regions)(struct otp_device *dev,
+					  int nr_regions);
+	int		(*set_fmt)(struct otp_device *dev,
+				   enum otp_redundancy_fmt fmt);
+};
+
+/**
+ * enum otp_device_flags - Flags to indicate capabilities for the OTP device.
+ *
+ * @OTP_DEVICE_FNO_SUBWORD_WRITE:	only full word sized writes may be
+ *					performed.  Don't use
+ *					read-modify-write cycles for
+ *					performing unaligned writes.
+ */
+enum otp_device_flags {
+	OTP_DEVICE_FNO_SUBWORD_WRITE	= (1 << 0),
+};
+
+/**
+ * struct otp_device - a picoxcell OTP device.
+ *
+ * @ops:		The operations to use for manipulating the device.
+ * @dev:		The parent device (typically a platform_device) that
+ *			provides the OTP.
+ * @regions:		The regions registered to the device.
+ * @size:		The size of the OTP in bytes.
+ * @max_regions:	The maximum number of regions the device may have.
+ * @dev_nr:		The OTP device ID, used for creating the otp%c
+ *			identifier.
+ * @flags:		Flags to indicate features of the OTP that the upper
+ *			layer should handle.
+ * @word_sz:		The size of the words of storage in the OTP (in
+ *			bytes).
+ */
+struct otp_device {
+	struct mutex			lock;
+	int				write_enable;
+	int				strict_programming;
+	const struct otp_device_ops	*ops;
+	struct device			dev;
+	struct list_head		regions;
+	size_t				size;
+	dev_t				devno;
+	unsigned			max_regions;
+	int				dev_nr;
+	size_t				word_sz;
+	unsigned long			flags;
+};
+
+static inline void *otp_dev_get_drvdata(struct otp_device *otp_dev)
+{
+	return dev_get_drvdata(&otp_dev->dev);
+}
+
+static inline void otp_dev_set_drvdata(struct otp_device *otp_dev,
+				       void *data)
+{
+	dev_set_drvdata(&otp_dev->dev, data);
+}
+
+/**
+ * struct otp_region_ops - operations to manipulate OTP regions.
+ *
+ * @set_fmt:		Permanently set the format of the region.  Returns
+ *			zero on success.
+ * @get_fmt:		Get the redundancy format of the region.
+ * @write_word:		Write a 64-bit word to the OTP.
+ * @read_word:		Read a 64-bit word from the OTP.
+ * @get_size:		Get the effective storage size of the region.
+ *			Depending on the number of regions in the device and
+ *			the redundancy format of the region, this may vary.
+ * @ioctl:		Optional region ioctl.
+ */
+struct otp_region_ops {
+	int			(*set_fmt)(struct otp_region *region,
+					   enum otp_redundancy_fmt fmt);
+	enum otp_redundancy_fmt	(*get_fmt)(struct otp_region *region);
+	int			(*write_word)(struct otp_region *region,
+					      unsigned long word_addr,
+					      u64 value);
+	int			(*read_word)(struct otp_region *region,
+					     unsigned long word_addr,
+					     u64 *value);
+	ssize_t			(*get_size)(struct otp_region *region);
+	long			(*ioctl)(struct otp_region *dev,
+					 unsigned cmd, unsigned long arg);
+};
+
+/**
+ * struct otp_region: a single region of OTP.
+ *
+ * @ops:	Operations for manipulating the region.
+ * @dev:	The device to register with the driver model.
+ * @cdev:	The character device used to provide userspace access to the
+ *		region.
+ * @head:	The position in the devices region list.
+ * @region_nr:	The region number of the region.  Devices number their regions
+ *		from 1 upwards.
+ */
+struct otp_region {
+	const struct otp_region_ops	*ops;
+	struct device			dev;
+	struct cdev			cdev;
+	struct list_head		head;
+	unsigned			region_nr;
+};
+
+/**
+ * otp_device_alloc - create a new OTP device.
+ *
+ * Returns the newly created OTP device on success or a ERR_PTR() encoded
+ * errno on failure.  The new device is automatically registered and can be
+ * released with otp_device_unregister().  This will increase the reference
+ * count on dev.
+ *
+ * @dev:	The parent device that provides the OTP implementation.
+ * @ops:	The operations to manipulate the OTP device.
+ * @size:	The size, in bytes of the OTP device.
+ * @word_sz:	The size of the words in the OTP memory.
+ * @max_regions:The maximum number of regions in the device.
+ * @flags:	Bitmask of enum otp_device_flags for the device.
+ */
+struct otp_device *otp_device_alloc(struct device *dev,
+				    const struct otp_device_ops *ops,
+				    size_t size, size_t word_sz,
+				    unsigned max_regions,
+				    unsigned long flags);
+
+/**
+ * otp_device_unregister - unregister an existing struct otp_device.
+ *
+ * This unregisters an otp_device and any regions that have been registered to
+ * it.  Once all regions have been released, the parent reference count is
+ * decremented and the otp_device will be freed.  Callers must assume that dev
+ * is invalidated during this call.
+ *
+ * @dev:	The otp_device to unregister.
+ */
+void otp_device_unregister(struct otp_device *dev);
+
+/**
+ * otp_region_alloc - create and register a new OTP region.
+ *
+ * Create and register a new region in an existing device with specified
+ * region operations.  Returns a pointer to the region on success, or an
+ * ERR_PTR() encoded errno on failure.
+ *
+ * Note: this takes the OTP semaphore so may not be called from one of the
+ * otp_device_ops or otp_region_ops callbacks or this may lead to deadlock.
+ *
+ * @dev:	The device to add the region to.
+ * @ops:	The operations for the region.
+ * @region_nr:	The region ID.  Must be unique for the region.
+ */
+struct otp_region *otp_region_alloc(struct otp_device *dev,
+				    const struct otp_region_ops *ops,
+				    int region_nr);
+
+/**
+ * otp_region_alloc_unlocked - create and register a new OTP region.
+ *
+ * This is the same as otp_region_alloc() but does not take the OTP semaphore
+ * so may only be called from inside one of the otp_device_ops or
+ * otp_region_ops callbacks.
+ *
+ * @dev:	The device to add the region to.
+ * @ops:	The operations for the region.
+ * @region_nr:	The region ID.  Must be unique for the region.
+ */
+struct otp_region *otp_region_alloc_unlocked(struct otp_device *dev,
+					     const struct otp_region_ops *ops,
+					     int region_nr);
+
+/**
+ * otp_region_unregister - unregister a given OTP region.
+ *
+ * This unregisters a region from the device and forms part of
+ * otp_device_unregister().
+ *
+ * @region:	The region to unregister.
+ */
+#define otp_region_unregister(region)	device_unregister(&(region)->dev)
+
+/**
+ * otp_strict_programming_enabled - check if we are in strict programming
+ * mode.
+ *
+ * Some OTP devices support different redundancy modes.  These devices often
+ * need multiple words programmed to represent a single word in that
+ * redundancy format.  If strict programming is enabled then all of the
+ * redundancy words must program correctly to indicate success.  If strict
+ * programming is disabled then we will allow errors in the redundant word as
+ * long as the contents of the whole word are read back correctly with the
+ * required redundancy mode.
+ *
+ * @otp_dev:	The device to interrogate.
+ */
+bool otp_strict_programming_enabled(struct otp_device *otp_dev);
+
+/**
+ * otp_write_enabled - check whether writes are allowed to the device.
+ */
+bool otp_write_enabled(struct otp_device *otp_dev);
+
+static inline struct otp_region *to_otp_region(struct device *dev)
+{
+	return container_of(dev, struct otp_region, dev);
+}
+
+static inline struct otp_device *to_otp_device(struct device *dev)
+{
+	return container_of(dev, struct otp_device, dev);
+}
+
+#endif /* __OTP_H__ */
-- 
1.7.4

