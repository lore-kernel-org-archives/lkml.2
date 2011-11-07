Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1KGPER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:04:17 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55954 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1KGPC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:02:59 -0500
From: jic23@cam.ac.uk
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: guenter.roeck@ericsson.com, khali@linux-fr.org, dmitry.torokhov@gmail.com,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de, linus.walleij@linaro.org,
        lars@metafoo.de, maxime.ripard@free-electrons.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 1/6] IIO: Core sysfs only support.
Date: Mon,  7 Nov 2011 14:52:38 +0000
Message-Id: <1320677563-18378-2-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1320677563-18378-1-git-send-email-jic23@cam.ac.uk>
References: <1320677563-18378-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

Add support for simple sysfs only interfaces.

Bulk of patch is concerned with taking struct iio_chan_spec
arrays and generating all the relevant interfaces from them.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/Kconfig           |    2 +
 drivers/Makefile          |    3 +
 drivers/iio/Kconfig       |   11 +
 drivers/iio/Makefile      |    6 +
 drivers/iio/iio.c         |  591 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iio/iio.h   |  244 +++++++++++++++++++
 include/linux/iio/sysfs.h |   68 +++++
 include/linux/iio/types.h |   52 ++++
 8 files changed, 977 insertions(+), 0 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index b5e6f24..7410537 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -136,4 +136,6 @@ source "drivers/hv/Kconfig"
 
 source "drivers/devfreq/Kconfig"
 
+source "drivers/iio/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 1b31421..216bba4 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -129,6 +129,9 @@ obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
 
 # Virtualization drivers
 obj-$(CONFIG_VIRT_DRIVERS)	+= virt/
+
 obj-$(CONFIG_HYPERV)		+= hv/
 
 obj-$(CONFIG_PM_DEVFREQ)	+= devfreq/
+
+obj-$(CONFIG_IIO)		+= iio/
diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
new file mode 100644
index 0000000..012ebb0
--- /dev/null
+++ b/drivers/iio/Kconfig
@@ -0,0 +1,11 @@
+#
+# Industrial I/O subsystem
+#
+
+menuconfig IIO
+	tristate "Industrial I/O support"
+	depends on GENERIC_HARDIRQS
+	help
+	  The Industrial input / output subsystem provides a unified
+	  framework for many different types of embedded sensor.
+
diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
new file mode 100644
index 0000000..733846b
--- /dev/null
+++ b/drivers/iio/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for the Industrial I/O subsystem
+#
+
+obj-$(CONFIG_IIO) += iio.o
+industrialio-y := core.o
diff --git a/drivers/iio/iio.c b/drivers/iio/iio.c
new file mode 100644
index 0000000..9a98f5f
--- /dev/null
+++ b/drivers/iio/iio.c
@@ -0,0 +1,591 @@
+/* The industrial I/O core
+ *
+ * Copyright (c) 2008-2011 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * Based on elements of hwmon and input subsystems.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/idr.h>
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+
+static DEFINE_IDA(iio_ida);
+
+static struct bus_type iio_bus_type = {
+	.name = "iio",
+};
+
+static const char * const iio_data_type_name[] = {
+	[IIO_RAW] = "raw",
+	[IIO_PROCESSED] = "input",
+};
+
+static const char * const iio_chan_type_name_spec[] = {
+	[IIO_VOLTAGE] = "voltage",
+	[IIO_CURRENT] = "current",
+	[IIO_POWER] = "power",
+	[IIO_ACCEL] = "accel",
+	[IIO_ANGL_VEL] = "anglvel",
+	[IIO_MAGN] = "magn",
+	[IIO_LIGHT] = "illuminance",
+	[IIO_INTENSITY] = "intensity",
+	[IIO_PROXIMITY] = "proximity",
+	[IIO_TEMP] = "temp",
+	[IIO_INCLI] = "incli",
+	[IIO_ROT] = "rot",
+	[IIO_ANGL] = "angl",
+	[IIO_TIMESTAMP] = "timestamp",
+};
+
+static const char * const iio_direction_name[] = {
+	[IIO_IN] = "in",
+	[IIO_OUT] = "out",
+};
+
+static const char * const iio_modifier_names[] = {
+	[IIO_MOD_X] = "x",
+	[IIO_MOD_Y] = "y",
+	[IIO_MOD_Z] = "z",
+	[IIO_MOD_LIGHT_BOTH] = "both",
+	[IIO_MOD_LIGHT_INFRARED] = "ir",
+};
+
+static const char * const iio_chan_info_postfix[] = {
+	[IIO_CHAN_INFO_SCALE] = "scale",
+	[IIO_CHAN_INFO_OFFSET] = "offset",
+	[IIO_CHAN_INFO_CALIBSCALE] = "calibscale",
+	[IIO_CHAN_INFO_CALIBBIAS] = "calibbias",
+	[IIO_CHAN_INFO_PEAK] = "peak_raw",
+	[IIO_CHAN_INFO_PEAK_SCALE] = "peak_scale",
+	[IIO_CHAN_INFO_QUADRATURE_CORRECTION_RAW] = "quadrature_correction_raw",
+};
+
+static void iio_device_free_read_attr(struct iio_dev *indio_dev,
+						 struct iio_dev_attr *p)
+{
+	kfree(p->dev_attr.attr.name);
+	kfree(p);
+}
+
+static void iio_device_unregister_sysfs(struct iio_dev *indio_dev)
+{
+
+	struct iio_dev_attr *p, *n;
+
+	list_for_each_entry_safe(p, n, &indio_dev->channel_attr_list, l) {
+		list_del(&p->l);
+		iio_device_free_read_attr(indio_dev, p);
+	}
+	kfree(indio_dev->chan_attr_group.attrs);
+}
+
+static void iio_dev_release(struct device *device)
+{
+	struct iio_dev *indio_dev = container_of(device, struct iio_dev, dev);
+	iio_device_unregister_sysfs(indio_dev);
+}
+
+static struct device_type iio_dev_type = {
+	.name = "iio_device",
+	.release = iio_dev_release,
+};
+
+struct iio_dev *iio_device_allocate(int sizeof_priv)
+{
+	struct iio_dev *dev;
+	size_t alloc_size;
+
+	alloc_size = sizeof(struct iio_dev);
+	if (sizeof_priv) {
+		alloc_size = ALIGN(alloc_size, IIO_ALIGN);
+		alloc_size += sizeof_priv;
+	}
+	/* ensure cacheline alignment of whole construct */
+	alloc_size += IIO_ALIGN - 1;
+
+	dev = kzalloc(alloc_size, GFP_KERNEL);
+
+	if (dev) {
+		dev->dev.groups = dev->groups;
+		dev->dev.type = &iio_dev_type;
+		dev->dev.bus = &iio_bus_type;
+		device_initialize(&dev->dev);
+		dev_set_drvdata(&dev->dev, (void *)dev);
+		mutex_init(&dev->mlock);
+	}
+
+	return dev;
+}
+EXPORT_SYMBOL_GPL(iio_device_allocate);
+
+void iio_device_free(struct iio_dev *dev)
+{
+	if (dev)
+		iio_put_device(dev);
+}
+EXPORT_SYMBOL_GPL(iio_device_free);
+
+ssize_t __iio_read_const_attr(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	return sprintf(buf, "%s\n",
+		       container_of(attr,
+				    struct iio_const_attr,
+				    dev_attr)->string);
+}
+EXPORT_SYMBOL_GPL(__iio_read_const_attr);
+
+static ssize_t iio_read_channel_info(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	int val, val2;
+	int ret = indio_dev->info->read_raw(indio_dev, this_attr->c,
+					    &val, &val2, this_attr->address);
+
+	if (ret < 0)
+		return ret;
+
+	if (ret == IIO_VAL_INT)
+		return sprintf(buf, "%d\n", val);
+	else if (ret == IIO_VAL_INT_PLUS_MICRO) {
+		if (val2 < 0)
+			return sprintf(buf, "-%d.%06u\n", val, -val2);
+		else
+			return sprintf(buf, "%d.%06u\n", val, val2);
+	} else if (ret == IIO_VAL_INT_PLUS_NANO) {
+		if (val2 < 0)
+			return sprintf(buf, "-%d.%09u\n", val, -val2);
+		else
+			return sprintf(buf, "%d.%09u\n", val, val2);
+	} else
+		return 0;
+}
+
+static ssize_t iio_write_channel_info(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf,
+				      size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	int ret, integer = 0, fract = 0, fract_mult = 100000;
+	bool integer_part = true, negative = false;
+
+	/* Assumes decimal - precision based on number of digits */
+	if (!indio_dev->info->write_raw)
+		return -EINVAL;
+
+	if (indio_dev->info->write_raw_get_fmt)
+		switch (indio_dev->info->write_raw_get_fmt(indio_dev,
+			this_attr->c, this_attr->address)) {
+		case IIO_VAL_INT_PLUS_MICRO:
+			fract_mult = 100000;
+			break;
+		case IIO_VAL_INT_PLUS_NANO:
+			fract_mult = 100000000;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+	if (buf[0] == '-') {
+		negative = true;
+		buf++;
+	}
+
+	while (*buf) {
+		if ('0' <= *buf && *buf <= '9') {
+			if (integer_part)
+				integer = integer*10 + *buf - '0';
+			else {
+				fract += fract_mult*(*buf - '0');
+				if (fract_mult == 1)
+					break;
+				fract_mult /= 10;
+			}
+		} else if (*buf == '\n') {
+			if (*(buf + 1) == '\0')
+				break;
+			else
+				return -EINVAL;
+		} else if (*buf == '.') {
+			integer_part = false;
+		} else {
+			return -EINVAL;
+		}
+		buf++;
+	}
+	if (negative) {
+		if (integer)
+			integer = -integer;
+		else
+			fract = -fract;
+	}
+
+	ret = indio_dev->info->write_raw(indio_dev, this_attr->c,
+					 integer, fract, this_attr->address);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static
+int __iio_device_attr_init(struct device_attribute *dev_attr,
+			   const char *postfix,
+			   struct iio_chan_spec const *chan,
+			   ssize_t (*readfunc)(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf),
+			   ssize_t (*writefunc)(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf,
+						size_t len),
+			   bool generic)
+{
+	int ret;
+	char *name_format, *full_postfix;
+	sysfs_attr_init(&dev_attr->attr);
+
+	/* Build up postfix of <extend_name>_<modifier>_postfix */
+	if (chan->modified && !generic) {
+		if (chan->extend_name)
+			full_postfix = kasprintf(GFP_KERNEL, "%s_%s_%s",
+						 iio_modifier_names[chan
+								    ->channel2],
+						 chan->extend_name,
+						 postfix);
+		else
+			full_postfix = kasprintf(GFP_KERNEL, "%s_%s",
+						 iio_modifier_names[chan
+								    ->channel2],
+						 postfix);
+	} else {
+		if (chan->extend_name == NULL)
+			full_postfix = kstrdup(postfix, GFP_KERNEL);
+		else
+			full_postfix = kasprintf(GFP_KERNEL,
+						 "%s_%s",
+						 chan->extend_name,
+						 postfix);
+	}
+	if (full_postfix == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+
+	if (chan->differential) { /* Differential  can not have modifier */
+		if (generic)
+			name_format
+				= kasprintf(GFP_KERNEL, "%s_%s-%s_%s",
+					    iio_direction_name[chan->output],
+					    iio_chan_type_name_spec[chan->type],
+					    iio_chan_type_name_spec[chan->type],
+					    full_postfix);
+		else if (chan->indexed)
+			name_format
+				= kasprintf(GFP_KERNEL, "%s_%s%d-%s%d_%s",
+					    iio_direction_name[chan->output],
+					    iio_chan_type_name_spec[chan->type],
+					    chan->channel,
+					    iio_chan_type_name_spec[chan->type],
+					    chan->channel2,
+					    full_postfix);
+		else {
+			WARN_ON("Differential channels must be indexed\n");
+			ret = -EINVAL;
+			goto error_free_full_postfix;
+		}
+	} else { /* Single ended */
+		if (generic)
+			name_format
+				= kasprintf(GFP_KERNEL, "%s_%s_%s",
+					    iio_direction_name[chan->output],
+					    iio_chan_type_name_spec[chan->type],
+					    full_postfix);
+		else if (chan->indexed)
+			name_format
+				= kasprintf(GFP_KERNEL, "%s_%s%d_%s",
+					    iio_direction_name[chan->output],
+					    iio_chan_type_name_spec[chan->type],
+					    chan->channel,
+					    full_postfix);
+		else
+			name_format
+				= kasprintf(GFP_KERNEL, "%s_%s_%s",
+					    iio_direction_name[chan->output],
+					    iio_chan_type_name_spec[chan->type],
+					    full_postfix);
+	}
+	if (name_format == NULL) {
+		ret = -ENOMEM;
+		goto error_free_full_postfix;
+	}
+	dev_attr->attr.name = kasprintf(GFP_KERNEL,
+					name_format,
+					chan->channel,
+					chan->channel2);
+	if (dev_attr->attr.name == NULL) {
+		ret = -ENOMEM;
+		goto error_free_name_format;
+	}
+
+	if (readfunc) {
+		dev_attr->attr.mode |= S_IRUGO;
+		dev_attr->show = readfunc;
+	}
+
+	if (writefunc) {
+		dev_attr->attr.mode |= S_IWUSR;
+		dev_attr->store = writefunc;
+	}
+	kfree(name_format);
+	kfree(full_postfix);
+
+	return 0;
+
+error_free_name_format:
+	kfree(name_format);
+error_free_full_postfix:
+	kfree(full_postfix);
+error_ret:
+	return ret;
+}
+
+static void __iio_device_attr_deinit(struct device_attribute *dev_attr)
+{
+	kfree(dev_attr->attr.name);
+}
+
+static
+int __iio_add_chan_devattr(const char *postfix,
+			   struct iio_chan_spec const *chan,
+			   ssize_t (*readfunc)(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf),
+			   ssize_t (*writefunc)(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf,
+						size_t len),
+			   u64 mask,
+			   bool generic,
+			   struct device *dev,
+			   struct list_head *attr_list)
+{
+	int ret;
+	struct iio_dev_attr *iio_attr, *t;
+
+	iio_attr = kzalloc(sizeof *iio_attr, GFP_KERNEL);
+	if (iio_attr == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	ret = __iio_device_attr_init(&iio_attr->dev_attr,
+				     postfix, chan,
+				     readfunc, writefunc, generic);
+	if (ret)
+		goto error_iio_dev_attr_free;
+	iio_attr->c = chan;
+	iio_attr->address = mask;
+	list_for_each_entry(t, attr_list, l)
+		if (strcmp(t->dev_attr.attr.name,
+			   iio_attr->dev_attr.attr.name) == 0) {
+			if (!generic)
+				dev_err(dev, "tried to double register : %s\n",
+					t->dev_attr.attr.name);
+			ret = -EBUSY;
+			goto error_device_attr_deinit;
+		}
+
+	list_add(&iio_attr->l, attr_list);
+
+	return 0;
+
+error_device_attr_deinit:
+	__iio_device_attr_deinit(&iio_attr->dev_attr);
+error_iio_dev_attr_free:
+	kfree(iio_attr);
+error_ret:
+	return ret;
+}
+
+static int iio_device_add_channel_sysfs(struct iio_dev *indio_dev,
+					struct iio_chan_spec const *chan)
+{
+	int ret, i, attrcount = 0;
+
+	if (chan->channel < 0)
+		return 0;
+	ret = __iio_add_chan_devattr(iio_data_type_name[chan->processed_val],
+				     chan,
+				     &iio_read_channel_info,
+				     (chan->output ?
+				      &iio_write_channel_info : NULL),
+				     0,
+				     0,
+				     &indio_dev->dev,
+				     &indio_dev->channel_attr_list);
+	if (ret)
+		goto error_ret;
+	attrcount++;
+
+	for_each_set_bit(i, &chan->info_mask,
+			 ARRAY_SIZE(iio_chan_info_postfix)*2) {
+		ret = __iio_add_chan_devattr(iio_chan_info_postfix[i/2],
+					     chan,
+					     &iio_read_channel_info,
+					     &iio_write_channel_info,
+					     i/2,
+					     !(i%2),
+					     &indio_dev->dev,
+					     &indio_dev->channel_attr_list);
+		if (ret == -EBUSY && (i%2 == 0)) {
+			ret = 0;
+			continue;
+		}
+		if (ret < 0)
+			goto error_ret;
+		attrcount++;
+	}
+	ret = attrcount;
+error_ret:
+	return ret;
+}
+
+static ssize_t iio_show_dev_name(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	return sprintf(buf, "%s\n", indio_dev->name);
+}
+
+static DEVICE_ATTR(name, S_IRUGO, iio_show_dev_name, NULL);
+
+static int iio_device_register_sysfs(struct iio_dev *indio_dev)
+{
+	int i, ret = 0, attrcount, attrn, attrcount_orig = 0;
+	struct iio_dev_attr *p, *n;
+	struct attribute **attr;
+
+	/* First count elements in any existing group */
+	if (indio_dev->info->attrs) {
+		attr = indio_dev->info->attrs->attrs;
+		while (*attr++ != NULL)
+			attrcount_orig++;
+	}
+	attrcount = attrcount_orig;
+
+	INIT_LIST_HEAD(&indio_dev->channel_attr_list);
+	if (indio_dev->channels)
+		for (i = 0; i < indio_dev->num_channels; i++) {
+			ret = iio_device_add_channel_sysfs(indio_dev,
+							   &indio_dev
+							   ->channels[i]);
+			if (ret < 0)
+				goto error_clear_attrs;
+			attrcount += ret;
+		}
+	if (indio_dev->name)
+		attrcount++;
+
+	indio_dev->chan_attr_group.attrs
+		= kzalloc(sizeof(indio_dev->chan_attr_group.attrs[0])*
+			  (attrcount + 1),
+			  GFP_KERNEL);
+	if (indio_dev->chan_attr_group.attrs == NULL) {
+		ret = -ENOMEM;
+		goto error_clear_attrs;
+	}
+	/* Copy across original attributes */
+	if (indio_dev->info->attrs)
+		memcpy(indio_dev->chan_attr_group.attrs,
+		       indio_dev->info->attrs->attrs,
+		       sizeof(indio_dev->chan_attr_group.attrs[0])
+		       *attrcount_orig);
+	attrn = attrcount_orig;
+	/* Add all elements from the list. */
+	list_for_each_entry(p, &indio_dev->channel_attr_list, l)
+		indio_dev->chan_attr_group.attrs[attrn++] = &p->dev_attr.attr;
+	if (indio_dev->name)
+		indio_dev->chan_attr_group.attrs[attrn++] = &dev_attr_name.attr;
+
+	indio_dev->groups[indio_dev->groupcounter++] =
+		&indio_dev->chan_attr_group;
+
+	return 0;
+
+error_clear_attrs:
+	list_for_each_entry_safe(p, n,
+				 &indio_dev->channel_attr_list, l) {
+		list_del(&p->l);
+		iio_device_free_read_attr(indio_dev, p);
+	}
+
+	return ret;
+}
+
+int iio_device_register(struct iio_dev *indio_dev)
+{
+	int ret;
+
+	indio_dev->id = ida_simple_get(&iio_ida, 0, 0, GFP_KERNEL);
+	if (indio_dev->id < 0) {
+		ret = indio_dev->id;
+		goto error_ret;
+	}
+
+	dev_set_name(&indio_dev->dev, "iio:device%d", indio_dev->id);
+
+	ret = iio_device_register_sysfs(indio_dev);
+	if (ret) {
+		dev_err(indio_dev->dev.parent,
+			"Failed to register sysfs interfaces\n");
+		goto error_free_ida;
+	}
+	ret = device_add(&indio_dev->dev);
+	if (ret)
+		goto error_free_sysfs;
+
+	return 0;
+
+error_free_sysfs:
+	iio_device_unregister_sysfs(indio_dev);
+error_free_ida:
+	ida_simple_remove(&iio_ida, indio_dev->id);
+error_ret:
+	return ret;
+}
+EXPORT_SYMBOL(iio_device_register);
+
+void iio_device_unregister(struct iio_dev *indio_dev)
+{
+	device_unregister(&indio_dev->dev);
+}
+EXPORT_SYMBOL(iio_device_unregister);
+
+static int __init iio_init(void)
+{
+	return bus_register(&iio_bus_type);
+}
+subsys_initcall(iio_init);
+
+static void __exit iio_exit(void)
+{
+	bus_unregister(&iio_bus_type);
+}
+module_exit(iio_exit);
+
+MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
+MODULE_DESCRIPTION("Industrial I/O core");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
new file mode 100644
index 0000000..4367d82
--- /dev/null
+++ b/include/linux/iio/iio.h
@@ -0,0 +1,244 @@
+/*
+ * The industrial I/O core
+ *
+ * Copyright (c) 2008-2011 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#ifndef _IIO_H_
+#define _IIO_H_
+
+#include <linux/klist.h>
+#include <linux/device.h>
+#include <linux/iio/types.h>
+
+/* Minimum alignment of priv within iio_dev */
+#define IIO_ALIGN L1_CACHE_BYTES
+
+enum iio_data_type {
+	IIO_RAW,
+	IIO_PROCESSED,
+};
+
+enum iio_chan_info_enum {
+	IIO_CHAN_INFO_SCALE = 1,
+	IIO_CHAN_INFO_OFFSET,
+	IIO_CHAN_INFO_CALIBSCALE,
+	IIO_CHAN_INFO_CALIBBIAS,
+	IIO_CHAN_INFO_PEAK,
+	IIO_CHAN_INFO_PEAK_SCALE,
+	IIO_CHAN_INFO_QUADRATURE_CORRECTION_RAW,
+};
+
+#define IIO_CHAN_INFO_SHARED_BIT(type) BIT(type*2)
+#define IIO_CHAN_INFO_SEPARATE_BIT(type) BIT(type*2 + 1)
+
+#define IIO_CHAN_INFO_SCALE_SEPARATE_BIT		\
+	IIO_CHAN_INFO_SEPARATE_BIT(IIO_CHAN_INFO_SCALE)
+#define IIO_CHAN_INFO_SCALE_SHARED_BIT			\
+	IIO_CHAN_INFO_SHARED_BIT(IIO_CHAN_INFO_SCALE)
+#define IIO_CHAN_INFO_OFFSET_SEPARATE_BIT			\
+	IIO_CHAN_INFO_SEPARATE_BIT(IIO_CHAN_INFO_OFFSET)
+#define IIO_CHAN_INFO_OFFSET_SHARED_BIT			\
+	IIO_CHAN_INFO_SHARED_BIT(IIO_CHAN_INFO_OFFSET)
+#define IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT			\
+	IIO_CHAN_INFO_SEPARATE_BIT(IIO_CHAN_INFO_CALIBSCALE)
+#define IIO_CHAN_INFO_CALIBSCALE_SHARED_BIT			\
+	IIO_CHAN_INFO_SHARED_BIT(IIO_CHAN_INFO_CALIBSCALE)
+#define IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT			\
+	IIO_CHAN_INFO_SEPARATE_BIT(IIO_CHAN_INFO_CALIBBIAS)
+#define IIO_CHAN_INFO_CALIBBIAS_SHARED_BIT			\
+	IIO_CHAN_INFO_SHARED_BIT(IIO_CHAN_INFO_CALIBBIAS)
+#define IIO_CHAN_INFO_PEAK_SEPARATE_BIT			\
+	IIO_CHAN_INFO_SEPARATE_BIT(IIO_CHAN_INFO_PEAK)
+#define IIO_CHAN_INFO_PEAK_SHARED_BIT			\
+	IIO_CHAN_INFO_SHARED_BIT(IIO_CHAN_INFO_PEAK)
+#define IIO_CHAN_INFO_PEAKSCALE_SEPARATE_BIT			\
+	IIO_CHAN_INFO_SEPARATE_BIT(IIO_CHAN_INFO_PEAKSCALE)
+#define IIO_CHAN_INFO_PEAKSCALE_SHARED_BIT			\
+	IIO_CHAN_INFO_SHARED_BIT(IIO_CHAN_INFO_PEAKSCALE)
+#define IIO_CHAN_INFO_QUADRATURE_CORRECTION_RAW_SEPARATE_BIT	\
+	IIO_CHAN_INFO_SEPARATE_BIT(				\
+		IIO_CHAN_INFO_QUADRATURE_CORRECTION_RAW)
+#define IIO_CHAN_INFO_QUADRATURE_CORRECTION_RAW_SHARED_BIT	\
+	IIO_CHAN_INFO_SHARED_BIT(				\
+		IIO_CHAN_INFO_QUADRATURE_CORRECTION_RAW)
+#define IIO_CHAN_INFO_AVERAGE_RAW_SEPARATE_BIT			\
+	IIO_CHAN_INFO_SEPARATE_BIT(IIO_CHAN_INFO_AVERAGE_RAW)
+#define IIO_CHAN_INFO_AVERAGE_RAW_SHARED_BIT			\
+	IIO_CHAN_INFO_SHARED_BIT(IIO_CHAN_INFO_AVERAGE_RAW)
+
+
+enum iio_direction {
+	IIO_IN,
+	IIO_OUT,
+};
+
+/**
+ * struct iio_chan_spec - specification of a single channel
+ * @type:		What type of measurement is the channel making.
+ * @channel:		What number or name do we wish to asign the channel.
+ * @channel2:		If there is a second number for a differential
+ *			channel then this is it. If modified is set then the
+ *			value here specifies the modifier.
+ * @address:		Driver specific identifier.
+ * @scan_type:		Description of data format.
+ * @info_mask:		What information is to be exported about this channel.
+ *			This includes calibbias, scale etc.
+ * @extend_name:	Allows labeling of channel attributes with an
+ *			informative name. Note this has no effect codes etc,
+ *			unlike modifiers.
+ * @processed_val:	Flag to specify the data access attribute should be
+ *			*_input rather than *_raw.
+ * @modified:		Does a modifier apply to this channel. What these are
+ *			depends on the channel type.  Modifier is set in
+ *			channel2. Examples are IIO_MOD_X for axial sensors about
+ *			the 'x' axis.
+ * @indexed:		Specify the channel has a numerical index. If not,
+ *			the value in channel will be suppressed for attribute
+ *			but not for event codes. Typically set it to 0 when
+ *			the index is false.
+ * @output:		Specify the channel is an output channel (DAC).
+ * @differential:	Is the channel a differential channel. Cannot coexist
+ *			with modified and requires indexed.
+ */
+struct iio_chan_spec {
+	enum iio_chan_type	type;
+	int			channel;
+	int			channel2;
+	unsigned long		address;
+	/**
+	 * struct scan_type - description of the data format
+	 * @sign:	Set if signed value
+	 * @realbits:	Number of valid bits of data
+	 * @shift:	Shift right by this before masking out realbits.
+	 */
+	struct {
+		char		sign;
+		u8		realbits;
+		u8		shift;
+	} scan_type;
+	long                    info_mask;
+	char			*extend_name;
+	unsigned		processed_val:1;
+	unsigned		modified:1;
+	unsigned		indexed:1;
+	unsigned		output:1;
+	unsigned		differential:1;
+};
+
+struct iio_dev;
+
+/**
+ * struct iio_info - constant information about device
+ * @driver_module:	module structure used to ensure correct
+ *			ownership of chrdevs etc
+ * @attrs:		general purpose device attributes
+ * @read_raw:		function to request a value from the device.
+ *			mask specifies which value. Note 0 means a reading of
+ *			the channel in question.  Return value will specify the
+ *			type of value returned by the device. val and val2 will
+ *			contain the elements making up the returned value.
+ * @write_raw:		function to write a value to the device.
+ *			Parameters are the same as for read_raw.
+ * @write_raw_get_fmt:	callback function to query the expected
+ *			format/precision. If not set by the driver, write_raw
+ *			returns IIO_VAL_INT_PLUS_MICRO.
+ **/
+struct iio_info {
+	struct module			*driver_module;
+	const struct attribute_group	*attrs;
+
+	int (*read_raw)(struct iio_dev *indio_dev,
+			struct iio_chan_spec const *chan,
+			int *val,
+			int *val2,
+			long mask);
+
+	int (*write_raw)(struct iio_dev *indio_dev,
+			 struct iio_chan_spec const *chan,
+			 int val,
+			 int val2,
+			 long mask);
+
+	int (*write_raw_get_fmt)(struct iio_dev *indio_dev,
+			 struct iio_chan_spec const *chan,
+			 long mask);
+};
+
+/**
+ * struct iio_dev - industrial I/O device
+ * @id:			[INTERN] used to identify device internally
+ * @dev:		[DRIVER] device structure, should be assigned a parent
+ *			and owner
+ * @mlock:		[INTERN] lock used to prevent simultaneous device state
+ *			changes
+ * @available_scan_masks: [DRIVER] optional array of allowed bitmasks
+ * @channels:		[DRIVER] channel specification structure table
+ * @num_channels:	[DRIVER] number of chanels specified in @channels
+ * @channel_attr_list:	[INTERN] keep track of automatically created channel
+ *			attributes
+ * @chan_attr_group:	[INTERN] group for all attrs in base directory
+ * @name:		[DRIVER] name of the device
+ * @info:		[DRIVER] callbacks and constant info from driver
+ * @groups:		[INTERN] attribute groups
+ * @groupcounter:	[INTERN] index of next attribute group
+ **/
+struct iio_dev {
+	int				id;
+	struct device			dev;
+	struct mutex			mlock;
+	unsigned long			*available_scan_masks;
+	struct iio_chan_spec const	*channels;
+	int				num_channels;
+	struct list_head		channel_attr_list;
+	struct attribute_group		chan_attr_group;
+	const char			*name;
+	const struct iio_info		*info;
+#define IIO_MAX_GROUPS 1
+	const struct attribute_group	*groups[IIO_MAX_GROUPS + 1];
+	int				groupcounter;
+};
+
+/**
+ * iio_device_allocate() - allocate an iio_dev from a driver
+ * @sizeof_priv:	Space to allocate for private structure.
+ **/
+struct iio_dev *iio_device_allocate(int sizeof_priv);
+
+static inline void *iio_priv(const struct iio_dev *dev)
+{
+	return (char *)dev + ALIGN(sizeof(struct iio_dev), IIO_ALIGN);
+}
+
+/**
+ * iio_device_free() - free an iio_dev from a driver
+ * @dev: the iio_dev associated with the device
+ **/
+void iio_device_free(struct iio_dev *dev);
+
+/**
+ * iio_device_register() - register a device with the IIO subsystem
+ * @indio_dev:		Device structure filled by the device driver
+ **/
+int iio_device_register(struct iio_dev *indio_dev);
+
+/**
+ * iio_device_unregister() - unregister a device from the IIO subsystem
+ * @indio_dev:		Device structure representing the device.
+ **/
+void iio_device_unregister(struct iio_dev *indio_dev);
+
+/**
+ * iio_put_device() - reference counted deallocation of struct device
+ * @indio_dev: the iio_device containing the device
+ **/
+static inline void iio_put_device(struct iio_dev *indio_dev)
+{
+	if (indio_dev)
+		put_device(&indio_dev->dev);
+};
+
+#endif /* _IIO_H_ */
diff --git a/include/linux/iio/sysfs.h b/include/linux/iio/sysfs.h
new file mode 100644
index 0000000..c6735bf
--- /dev/null
+++ b/include/linux/iio/sysfs.h
@@ -0,0 +1,68 @@
+/*
+ * The industrial I/O core
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * General attributes
+ */
+
+#include <linux/klist.h>
+#include <linux/device.h>
+
+#ifndef _IIO_SYSFS_H_
+#define _IIO_SYSFS_H_
+
+struct iio_chan_spec;
+
+/**
+ * struct iio_dev_attr - iio specific device attribute
+ * @dev_attr:	underlying device attribute
+ * @address:	associated register address
+ * @l:		list head for maintaining list of dynamically created attrs
+ * @c:		channel spec for channel with which attr is associated if any
+ */
+struct iio_dev_attr {
+	struct device_attribute dev_attr;
+	int address;
+	struct list_head l;
+	struct iio_chan_spec const *c;
+};
+
+#define to_iio_dev_attr(_dev_attr)				\
+	container_of(_dev_attr, struct iio_dev_attr, dev_attr)
+
+#define IIO_ATTR(_name, _mode, _show, _store, _addr)		\
+	{ .dev_attr = __ATTR(_name, _mode, _show, _store),	\
+	  .address = _addr }
+
+#define IIO_DEVICE_ATTR(_name, _mode, _show, _store, _addr)	\
+	struct iio_dev_attr iio_dev_attr_##_name		\
+	= IIO_ATTR(_name, _mode, _show, _store, _addr)
+
+/**
+ * struct iio_const_attr - constant device specific attribute
+ *                         often used for things like available modes
+ * @string:	attribute string
+ * @dev_attr:	underlying device attribute
+ */
+struct iio_const_attr {
+	const char *string;
+	struct device_attribute dev_attr;
+};
+
+#define to_iio_const_attr(_dev_attr) \
+	container_of(_dev_attr, struct iio_const_attr, dev_attr)
+
+ssize_t __iio_read_const_attr(struct device *dev,
+			      struct device_attribute *attr,
+			      char *len);
+
+#define IIO_CONST_ATTR(_name, _string)					\
+	struct iio_const_attr iio_const_attr_##_name			\
+	= { .string = _string,						\
+	    .dev_attr = __ATTR(_name, S_IRUGO, __iio_read_const_attr, NULL) }
+#endif /* _IIO_SYSFS_H_ */
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
new file mode 100644
index 0000000..4cb24aa
--- /dev/null
+++ b/include/linux/iio/types.h
@@ -0,0 +1,52 @@
+/* industrial I/O data types needed both in and out of kernel
+ *
+ * Copyright (c) 2011 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _IIO_TYPES_H_
+#define _IIO_TYPES_H_
+
+enum iio_chan_type {
+	IIO_VOLTAGE,
+	IIO_CURRENT,
+	IIO_POWER,
+	IIO_CAPACITANCE,
+	IIO_ACCEL,
+	IIO_ANGL_VEL,
+	IIO_MAGN,
+	IIO_LIGHT,
+	IIO_INTENSITY,
+	IIO_PROXIMITY,
+	IIO_TEMP,
+	IIO_INCLI,
+	IIO_ROT,
+	IIO_ANGL,
+	IIO_TIMESTAMP,
+};
+
+enum iio_modifier {
+	IIO_NO_MOD,
+	IIO_MOD_X,
+	IIO_MOD_Y,
+	IIO_MOD_Z,
+	IIO_MOD_X_AND_Y,
+	IIO_MOD_X_ANX_Z,
+	IIO_MOD_Y_AND_Z,
+	IIO_MOD_X_AND_Y_AND_Z,
+	IIO_MOD_X_OR_Y,
+	IIO_MOD_X_OR_Z,
+	IIO_MOD_Y_OR_Z,
+	IIO_MOD_X_OR_Y_OR_Z,
+	IIO_MOD_LIGHT_BOTH,
+	IIO_MOD_LIGHT_INFRARED,
+};
+
+#define IIO_VAL_INT 1
+#define IIO_VAL_INT_PLUS_MICRO 2
+#define IIO_VAL_INT_PLUS_NANO 3
+
+#endif /* _IIO_TYPES_H_ */
-- 
1.7.7.2

