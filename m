Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab1CXPVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:21:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59836 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab1CXPV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:21:27 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, vapier@gentoo.org, Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Date: Thu, 24 Mar 2011 15:21:08 +0000
Message-Id: <1300980071-24645-2-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OTP memory is typically found in some embedded devices and can be
used for storing boot code, cryptographic keys and other persistent
information onchip.  This patch adds a generic layer that devices can
register OTP with and allows access through a set of character
device nodes.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 Documentation/ABI/testing/sysfs-bus-otp |   68 +++
 drivers/Kconfig                         |    2 +
 drivers/Makefile                        |    1 +
 drivers/otp/Kconfig                     |   10 +
 drivers/otp/Makefile                    |    1 +
 drivers/otp/otp.c                       |  878 +++++++++++++++++++++++++++++++
 include/linux/otp.h                     |  221 ++++++++
 7 files changed, 1181 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-otp
 create mode 100644 drivers/otp/Kconfig
 create mode 100644 drivers/otp/Makefile
 create mode 100644 drivers/otp/otp.c
 create mode 100644 include/linux/otp.h

diff --git a/Documentation/ABI/testing/sysfs-bus-otp b/Documentation/ABI/testing/sysfs-bus-otp
new file mode 100644
index 0000000..4dbc652
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-otp
@@ -0,0 +1,68 @@
+What:           /sys/bus/otp/
+Date:           March 2011
+KernelVersion:  2.6.40+
+Contact:        Jamie Iles <jamie@jamieiles.com>
+Description:
+                The otp bus presents a number of devices where each
+		device represents a region or device in the SoC. Each region
+		will create a device node which allows the region to be
+		written with read()/write() calls and the device on the bus
+		has attributes for controlling the redundancy format and
+		getting the region size.
+
+What:		/sys/bus/otp[a-z]/write_enable
+Date:		March 2011
+KernelVersion:	2.6.40+
+Contact:	"Jamie Iles" <jamie@jamieiles.com>
+Description:
+		This file controls whether the OTP device can be written to.
+		If set to "enabled" then the regions may be written, the
+		number of regions may be changed and the format of any region
+		may be changed.
+
+What:		/sys/bus/otp[a-z]/num_regions
+Date:		March 2011
+KernelVersion:	2.6.40+
+Contact:	"Jamie Iles" <jamie@jamieiles.com>
+Description:
+		This file controls the number of regions in the OTP device.
+		Valid values are 1, 2, 4 and 8. The number of regions may be
+		increased but never decreased. Increasing the number of
+		regions will create new devices on the otp bus.
+
+What:		/sys/bus/otp[a-z]/strict_programming
+Date:		March 2011
+KernelVersion:	2.6.40+
+Contact:	"Jamie Iles" <jamie@jamieiles.com>
+Description:
+		This file indicates whether all words in a redundant format
+		must be programmed correctly to indicate success.  Disabling
+		this will mean that programming will be considered a success
+		if the word can be read back correctly in it's redundant
+		format.
+
+What:           /sys/bus/otp/devices/otp[a-z][0-9]*/format
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
+		It is possible to increase redundancy of a region but care
+		will be needed if there is data already in the region.
+
+What:           /sys/bus/otp/devices/otp[a-z][0-9]*/size
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
index 0000000..5694216
--- /dev/null
+++ b/drivers/otp/Kconfig
@@ -0,0 +1,10 @@
+#
+# Character device configuration
+#
+
+menuconfig OTP
+	bool "OTP memory support"
+	help
+	  Say y here to support OTP memory found in some embedded devices.
+	  This memory can commonly be used to store boot code, cryptographic
+	  keys and other persistent data.
diff --git a/drivers/otp/Makefile b/drivers/otp/Makefile
new file mode 100644
index 0000000..84fd03e
--- /dev/null
+++ b/drivers/otp/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_OTP)	+= otp.o
diff --git a/drivers/otp/otp.c b/drivers/otp/otp.c
new file mode 100644
index 0000000..dd47cf1
--- /dev/null
+++ b/drivers/otp/otp.c
@@ -0,0 +1,878 @@
+/*
+ * Copyright 2010-2011 Picochip LTD, Jamie Iles
+ * http://www.picochip.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#define pr_fmt(fmt) "otp: " fmt
+
+#undef DEBUG
+#include <linux/cdev.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/io.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/otp.h>
+#include <linux/semaphore.h>
+#include <linux/slab.h>
+#include <linux/sysfs.h>
+#include <linux/uaccess.h>
+
+static int otp_open(struct inode *inode, struct file *filp);
+static int otp_release(struct inode *inode, struct file *filp);
+static ssize_t otp_write(struct file *filp, const char __user *buf,
+			 size_t len, loff_t *offs);
+static ssize_t otp_read(struct file *filp, char __user *buf, size_t len,
+			loff_t *offs);
+static loff_t otp_llseek(struct file *filp, loff_t offs, int origin);
+
+static const struct file_operations otp_fops = {
+	.owner	    = THIS_MODULE,
+	.open	    = otp_open,
+	.release    = otp_release,
+	.write	    = otp_write,
+	.read	    = otp_read,
+	.llseek	    = otp_llseek,
+};
+
+static DEFINE_SEMAPHORE(otp_sem);
+static int otp_we, otp_strict_programming;
+static struct otp_device *otp;
+static dev_t otp_devno;
+
+/*
+ * Given a device for one of the otpN devices, get the corresponding
+ * otp_region.
+ */
+static inline struct otp_region *to_otp_region(struct device *dev)
+{
+	return dev ? container_of(dev, struct otp_region, dev) : NULL;
+}
+
+static inline struct otp_device *to_otp_device(struct device *dev)
+{
+	return dev ? container_of(dev, struct otp_device, dev) : NULL;
+}
+
+bool otp_strict_programming_enabled(void)
+{
+	return otp_strict_programming;
+}
+EXPORT_SYMBOL_GPL(otp_strict_programming_enabled);
+
+static ssize_t otp_format_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct otp_region *region = to_otp_region(dev);
+	enum otp_redundancy_fmt fmt;
+	const char *fmt_string;
+
+	if (down_interruptible(&otp_sem))
+		return -ERESTARTSYS;
+
+	if (region->ops->get_fmt(region))
+		fmt = region->ops->get_fmt(region);
+	else
+		fmt = OTP_REDUNDANCY_FMT_SINGLE_ENDED;
+
+	up(&otp_sem);
+
+	if (OTP_REDUNDANCY_FMT_SINGLE_ENDED == fmt)
+		fmt_string = "single-ended";
+	else if (OTP_REDUNDANCY_FMT_REDUNDANT == fmt)
+		fmt_string = "redundant";
+	else if (OTP_REDUNDANCY_FMT_DIFFERENTIAL == fmt)
+		fmt_string = "differential";
+	else if (OTP_REDUNDANCY_FMT_DIFFERENTIAL_REDUNDANT == fmt)
+		fmt_string = "differential-redundant";
+	else
+		fmt_string = NULL;
+
+	return fmt_string ? sprintf(buf, "%s\n", fmt_string) : -EINVAL;
+}
+
+static ssize_t otp_format_store(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t len)
+{
+	int err = 0;
+	struct otp_region *region = to_otp_region(dev);
+	enum otp_redundancy_fmt new_fmt;
+
+	if (!region->ops->set_fmt)
+		return -EOPNOTSUPP;
+
+	if (down_interruptible(&otp_sem))
+		return -ERESTARTSYS;
+
+	/* This is irreversible so don't make it too easy to break it! */
+	if (!otp_we) {
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
+	else {
+		err = -EINVAL;
+		goto out;
+	}
+
+	region->ops->set_fmt(region, new_fmt);
+
+out:
+	up(&otp_sem);
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
+	size_t region_sz;
+
+	if (down_interruptible(&otp_sem))
+		return -ERESTARTSYS;
+
+	region_sz = region->ops->get_size(region);
+
+	up(&otp_sem);
+
+	return sprintf(buf, "%zu\n", region_sz);
+}
+static DEVICE_ATTR(size, S_IRUSR, otp_size_show, NULL);
+
+
+static struct bus_type otp_bus_type = {
+	.name		= "otp",
+};
+
+struct attribute *region_attrs[] = {
+	&dev_attr_format.attr,
+	&dev_attr_size.attr,
+	NULL,
+};
+
+const struct attribute_group region_attr_group = {
+	.attrs		= region_attrs,
+};
+
+const struct attribute_group *region_attr_groups[] = {
+	&region_attr_group,
+	NULL,
+};
+
+struct device_type region_type = {
+	.name		= "region",
+	.groups		= region_attr_groups,
+};
+
+/*
+ * Show the current write enable state of the OTP. Users can only program the
+ * OTP when this shows 'enabled'.
+ */
+static ssize_t otp_we_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	int ret;
+
+	if (down_interruptible(&otp_sem))
+		return -ERESTARTSYS;
+
+	ret = sprintf(buf, "%s\n", otp_we ? "enabled" : "disabled");
+
+	up(&otp_sem);
+
+	return ret;
+}
+
+/*
+ * Set the write enable state of the OTP. 'enabled' will enable programming
+ * and 'disabled' will prevent further programming from occuring. On loading
+ * the module, this will default to 'disabled'.
+ */
+static ssize_t otp_we_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t len)
+{
+	int err = 0;
+
+	if (down_interruptible(&otp_sem))
+		return -ERESTARTSYS;
+
+	if (sysfs_streq(buf, "enabled"))
+		otp_we = 1;
+	else if (sysfs_streq(buf, "disabled"))
+		otp_we = 0;
+	else
+		err = -EINVAL;
+
+	up(&otp_sem);
+
+	return err ?: len;
+}
+static DEVICE_ATTR(write_enable, S_IRUSR | S_IWUSR, otp_we_show, otp_we_store);
+
+/*
+ * Show the current strict programming state of the OTP. If set to "enabled",
+ * then when programming, all raw words must program correctly to succeed. If
+ * disabled, then as long as the word reads back correctly in the redundant
+ * mode, then some bits may be allowed to be incorrect in the raw words.
+ */
+static ssize_t otp_strict_programming_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	int ret;
+
+	if (down_interruptible(&otp_sem))
+		return -ERESTARTSYS;
+
+	ret = sprintf(buf, "%s\n", otp_strict_programming ? "enabled" :
+			"disabled");
+
+	up(&otp_sem);
+
+	return ret;
+}
+
+/*
+ * Set the current strict programming state of the OTP. If set to "enabled",
+ * then when programming, all raw words must program correctly to succeed. If
+ * disabled, then as long as the word reads back correctly in the redundant
+ * mode, then some bits may be allowed to be incorrect in the raw words.
+ */
+static ssize_t otp_strict_programming_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t len)
+{
+	int err = 0;
+
+	if (down_interruptible(&otp_sem))
+		return -ERESTARTSYS;
+
+	if (sysfs_streq(buf, "enabled"))
+		otp_strict_programming = 1;
+	else if (sysfs_streq(buf, "disabled"))
+		otp_strict_programming = 0;
+	else
+		err = -EINVAL;
+
+	up(&otp_sem);
+
+	return err ?: len;
+}
+static DEVICE_ATTR(strict_programming, S_IRUSR | S_IWUSR,
+		   otp_strict_programming_show, otp_strict_programming_store);
+
+static ssize_t otp_num_regions_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	int nr_regions;
+
+	if (down_interruptible(&otp_sem))
+		return -ERESTARTSYS;
+
+	nr_regions = otp->ops->get_nr_regions(otp);
+
+	up(&otp_sem);
+
+	if (nr_regions <= 0)
+		return -EINVAL;
+
+	return sprintf(buf, "%u\n", nr_regions);
+}
+
+static ssize_t otp_num_regions_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	unsigned long nr_regions;
+	int err = 0;
+
+	if (!otp->ops->set_nr_regions)
+		return -EOPNOTSUPP;
+
+	err = strict_strtoul(buf, 0, &nr_regions);
+	if (err)
+		return err;
+
+	if (down_interruptible(&otp_sem))
+		return -ERESTARTSYS;
+
+	if (!otp_we) {
+		err = -EPERM;
+		goto out;
+	}
+
+	err = otp->ops->set_nr_regions(otp, nr_regions);
+
+out:
+	up(&otp_sem);
+
+	return err ?: len;
+}
+static DEVICE_ATTR(num_regions, S_IRUSR | S_IWUSR, otp_num_regions_show,
+		   otp_num_regions_store);
+
+struct attribute *otp_attrs[] = {
+	&dev_attr_strict_programming.attr,
+	&dev_attr_num_regions.attr,
+	&dev_attr_write_enable.attr,
+	NULL,
+};
+
+const struct attribute_group otp_attr_group = {
+	.attrs		= otp_attrs,
+};
+
+const struct attribute_group *otp_attr_groups[] = {
+	&otp_attr_group,
+	NULL,
+};
+
+struct device_type otp_type = {
+	.name		= "otp",
+	.groups		= otp_attr_groups,
+};
+
+static void otp_dev_release(struct device *dev)
+{
+	struct otp_device *otp = to_otp_device(dev);
+
+	kfree(otp);
+	otp = NULL;
+}
+
+struct otp_device *otp_device_alloc(struct device *dev,
+				    const struct otp_device_ops *ops,
+				    size_t size)
+{
+	struct otp_device *otp_dev = NULL;
+	int err = -EINVAL;
+
+	down(&otp_sem);
+
+	if (dev && !get_device(dev)) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	if (otp) {
+		pr_warning("an otp device already registered\n");
+		err = -EBUSY;
+		goto out_put;
+	}
+
+	otp_dev = kzalloc(sizeof(*otp_dev), GFP_KERNEL);
+	if (!otp_dev) {
+		err = -ENOMEM;
+		goto out_put;
+	}
+
+	INIT_LIST_HEAD(&otp_dev->regions);
+	otp_dev->ops		= ops;
+	otp_dev->dev.release	= otp_dev_release;
+	otp_dev->dev.bus	= &otp_bus_type;
+	otp_dev->dev.type	= &otp_type;
+	otp_dev->dev.parent	= dev;
+	otp_dev->size		= size;
+	dev_set_name(&otp_dev->dev, "otpa");
+
+	otp = otp_dev;
+	err = device_register(&otp_dev->dev);
+	if (err) {
+		dev_err(&otp_dev->dev, "couldn't add device\n");
+		goto out_put;
+	}
+	pr_info("device %s of %zu bytes registered\n", ops->name, size);
+	goto out;
+
+out_put:
+	if (dev)
+		put_device(dev);
+out:
+	up(&otp_sem);
+
+	return err ? ERR_PTR(err) : otp_dev;
+}
+EXPORT_SYMBOL_GPL(otp_device_alloc);
+
+void otp_device_unregister(struct otp_device *dev)
+{
+	struct otp_region *region, *tmp;
+
+	down(&otp_sem);
+	list_for_each_entry_safe(region, tmp, &dev->regions, head)
+		otp_region_unregister(region);
+	device_unregister(&dev->dev);
+	up(&otp_sem);
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
+struct otp_region *otp_region_alloc_unlocked(struct otp_device *dev,
+					     const struct otp_region_ops *ops,
+					     int region_nr)
+{
+	struct otp_region *region;
+	int err = 0;
+	dev_t devno = MKDEV(MAJOR(otp_devno), region_nr + 1);
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
+	region->dev.bus		= &otp_bus_type;
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
+	down(&otp_sem);
+	ret = otp_region_alloc_unlocked(dev, ops, region_nr);
+	up(&otp_sem);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(otp_region_alloc);
+
+void otp_region_unregister(struct otp_region *region)
+{
+	device_unregister(&region->dev);
+}
+EXPORT_SYMBOL_GPL(otp_region_unregister);
+
+static int otp_open(struct inode *inode, struct file *filp)
+{
+	struct otp_region *region;
+	int ret = 0;
+
+	if (down_interruptible(&otp_sem))
+		return -ERESTARTSYS;
+
+	if (!try_module_get(otp->ops->owner)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	region = container_of(inode->i_cdev, struct otp_region, cdev);
+	if (!get_device(&region->dev)) {
+		ret = -ENODEV;
+		goto out_put_module;
+	}
+	filp->private_data = region;
+
+	goto out;
+
+out_put_module:
+	module_put(otp->ops->owner);
+out:
+	up(&otp_sem);
+
+	return ret;
+}
+
+static int otp_release(struct inode *inode, struct file *filp)
+{
+	struct otp_region *region;
+
+	if (down_interruptible(&otp_sem))
+		return -ERESTARTSYS;
+	region = filp->private_data;
+	put_device(&region->dev);
+	module_put(otp->ops->owner);
+	up(&otp_sem);
+
+	return 0;
+}
+
+/*
+ * Write to the OTP memory from a userspace buffer. This requires that the
+ * write_enable attribute is set to "enabled" in
+ * /sys/devices/platform/otp/write_enable
+ *
+ * If writing is not enabled, this should return -EPERM.
+ *
+ * The write method takes a buffer from userspace and writes it into the
+ * corresponding bits of the OTP. The current file offset refers to the byte
+ * address of the words in the OTP region that should be written to.
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
+	unsigned pos = (unsigned)*offs;
+	enum otp_redundancy_fmt fmt;
+
+	if (down_interruptible(&otp_sem))
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
+	if (!otp_we) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	len = min(len, region->ops->get_size(region) - (unsigned)*offs);
+	if (!len) {
+		ret = 0;
+		goto out;
+	}
+
+	if (otp->ops->set_fmt)
+		otp->ops->set_fmt(otp, fmt);
+
+	if (pos & (OTP_WORD_SIZE - 1)) {
+		/*
+		 * We're not currently on an 8 byte boundary so we need to do
+		 * a read-modify-write.
+		 */
+		unsigned word_addr = pos / OTP_WORD_SIZE;
+		unsigned offset = pos % OTP_WORD_SIZE;
+		size_t bytes = min_t(size_t, OTP_WORD_SIZE - offset, len);
+
+		if (region->ops->read_word(region, word_addr, &word)) {
+			ret = -EIO;
+			goto out;
+		}
+
+		if (copy_from_user((void *)(&word) + offset, buf, bytes)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		if (region->ops->write_word(region, word_addr, word)) {
+			ret = -EIO;
+			goto out;
+		}
+
+		written += bytes;
+		len -= bytes;
+		buf += bytes;
+		pos += bytes;
+	}
+
+	/*
+	 * We're now aligned to an 8 byte boundary so we can simply copy words
+	 * from userspace and write them into the OTP.
+	 */
+	while (len >= OTP_WORD_SIZE) {
+		if (copy_from_user(&word, buf, OTP_WORD_SIZE)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		if (region->ops->write_word(region, pos / OTP_WORD_SIZE,
+					    word)) {
+			ret = -EIO;
+			goto out;
+		}
+
+		written += OTP_WORD_SIZE;
+		len -= OTP_WORD_SIZE;
+		buf += OTP_WORD_SIZE;
+		pos += OTP_WORD_SIZE;
+	}
+
+	/*
+	 * We might have less than 8 bytes left so we'll need to do another
+	 * read-modify-write.
+	 */
+	if (len) {
+		if (region->ops->read_word(region, pos / OTP_WORD_SIZE,
+					   &word)) {
+			ret = -EIO;
+			goto out;
+		}
+
+		if (copy_from_user(&word, buf, len)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		if (region->ops->write_word(region, pos / OTP_WORD_SIZE,
+					    word)) {
+			ret = -EIO;
+			goto out;
+		}
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
+	up(&otp_sem);
+	return ret ?: written;
+}
+
+/*
+ * Read an OTP region. This switches the OTP into the appropriate redundancy
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
+	unsigned pos = (unsigned)*offs;
+	enum otp_redundancy_fmt fmt;
+
+	if (down_interruptible(&otp_sem))
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
+	if (otp->ops->set_fmt)
+		otp->ops->set_fmt(otp, fmt);
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
+		if (region->ops->read_word(region, word_addr, &word)) {
+			ret = -EIO;
+			goto out;
+		}
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
+		if (region->ops->read_word(region, pos / OTP_WORD_SIZE,
+					   &word)) {
+			ret = -EIO;
+			goto out;
+		}
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
+		if (region->ops->read_word(region, pos / OTP_WORD_SIZE,
+					   &word)) {
+			ret = -EIO;
+			goto out;
+		}
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
+	up(&otp_sem);
+	return ret ?: bytes_read;
+}
+
+/*
+ * Seek to a specified position in the OTP region. This can be used if
+ * userspace doesn't have pread()/pwrite() and needs to write to a specified
+ * offset in the OTP.
+ */
+static loff_t otp_llseek(struct file *filp, loff_t offs, int origin)
+{
+	struct otp_region *region = filp->private_data;
+	int ret = 0;
+	loff_t end;
+
+	if (down_interruptible(&otp_sem))
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
+	up(&otp_sem);
+
+	return ret ?: filp->f_pos;
+}
+
+static int __init otp_init(void)
+{
+	int err;
+
+	err = bus_register(&otp_bus_type);
+	if (err)
+		return err;
+
+	err = alloc_chrdev_region(&otp_devno, 0, 9, "otp");
+	if (err)
+		goto out_bus_unregister;
+
+	return 0;
+
+out_bus_unregister:
+	bus_unregister(&otp_bus_type);
+
+	return err;
+}
+module_init(otp_init);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jamie Iles");
+MODULE_DESCRIPTION("OTP interface driver");
diff --git a/include/linux/otp.h b/include/linux/otp.h
new file mode 100644
index 0000000..93ccf8b
--- /dev/null
+++ b/include/linux/otp.h
@@ -0,0 +1,221 @@
+/*
+ * Copyright 2010-2011 Picochip LTD, Jamie Iles
+ * http://www.picochip.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * This driver implements a user interface for reading and writing OTP
+ * memory. This OTP can be used for executing secure boot code or for the
+ * secure storage of keys and any other user data.  We support multiple
+ * backends for different OTP macros.
+ *
+ * The OTP is configured through sysfs and is read and written through device
+ * nodes. The OTP device in the device model (the platform device) gains
+ * write_enable, num_regions, and strict_programming attributes. We also
+ * create an otp bus to which we add a device per region. The OTP can supports
+ * multiple regions and when we divide the regions down we create a new child
+ * device on the otp bus. This child device has format and size attributes.
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
+/*
+ * The OTP works in 64 bit words. When we are programming or reading,
+ * everything is done with 64 bit word addresses.
+ */
+#define OTP_WORD_SIZE			8
+
+enum otp_redundancy_fmt {
+	OTP_REDUNDANCY_FMT_SINGLE_ENDED,
+	OTP_REDUNDANCY_FMT_REDUNDANT,
+	OTP_REDUNDANCY_FMT_DIFFERENTIAL,
+	OTP_REDUNDANCY_FMT_DIFFERENTIAL_REDUNDANT,
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
+ * struct otp_device - a picoxcell OTP device.
+ *
+ * @ops:		The operations to use for manipulating the device.
+ * @dev:		The parent device (typically a platform_device) that
+ *			provides the OTP.
+ * @regions:		The regions registered to the device.
+ * @size:		The size of the OTP in bytes.
+ * @driver_data:	Private driver data.
+ */
+struct otp_device {
+	const struct otp_device_ops	*ops;
+	struct device			dev;
+	struct list_head		regions;
+	size_t				size;
+	void				*driver_data;
+};
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
+ * otp_device_alloc - create a new picoxcell OTP device.
+ *
+ * Returns the newly created OTP device on success or a ERR_PTR() encoded
+ * errno on failure.  The new device is automatically registered and can be
+ * released with otp_device_unregister().  This will increase the reference
+ * count on dev.
+ *
+ * @dev:	The parent device that provides the OTP implementation.
+ * @ops:	The operations to manipulate the OTP device.
+ * @size:	The size, in bytes of the OTP device.
+ */
+struct otp_device *otp_device_alloc(struct device *dev,
+				    const struct otp_device_ops *ops,
+				    size_t size);
+
+/**
+ * otp_device_unregister - deregister an existing struct otp_device.
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
+void otp_region_unregister(struct otp_region *region);
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
+ */
+bool otp_strict_programming_enabled(void);
+
+#endif /* __OTP_H__ */
-- 
1.7.4

