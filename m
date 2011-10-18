Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab1JRP3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:29:45 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:41272 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab1JRP3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:29:39 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc: linus.ml.walleij@gmail.com, zdevai@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 4/6] IIO:Core add in kernel interface mapping and getting IIO channels.
Date: Tue, 18 Oct 2011 16:29:34 +0100
Message-Id: <1318951776-19393-5-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318951776-19393-1-git-send-email-jic23@cam.ac.uk>
References: <1318951776-19393-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two elements here:
* Map as defined in include/linux/iio/inkern.h
* Matching code to actually get the iio_dev and channel
that we want from the global list of IIO devices.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/Makefile           |    2 +-
 drivers/iio/Makefile       |    1 +
 drivers/iio/iio.c          |  112 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/iio/inkern.c       |   21 ++++++++
 include/linux/iio/iio.h    |    7 ++-
 include/linux/iio/inkern.h |   63 +++++++++++++++++++++++++
 6 files changed, 204 insertions(+), 2 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index df39628..2b389c5 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -130,5 +130,5 @@ obj-$(CONFIG_VIRT_DRIVERS)	+= virt/
 
 obj-$(CONFIG_HYPERV)		+= hv/
 
-obj-$(CONFIG_IIO)		+= iio/
+obj-y		+= iio/
 
diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
index db3c426..cfb588a 100644
--- a/drivers/iio/Makefile
+++ b/drivers/iio/Makefile
@@ -1,6 +1,7 @@
 #
 # Makefile for the Industrial I/O subsystem
 #
+obj-y = inkern.o
 
 obj-$(CONFIG_IIO) += iio.o
 industrialio-y := core.o
diff --git a/drivers/iio/iio.c b/drivers/iio/iio.c
index 246a093..ae2daf0 100644
--- a/drivers/iio/iio.c
+++ b/drivers/iio/iio.c
@@ -12,8 +12,10 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
+#include <linux/err.h>
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
+#include <linux/iio/inkern.h>
 
 static DEFINE_MUTEX(iio_device_list_lock);
 static LIST_HEAD(iio_device_list);
@@ -71,6 +73,116 @@ static const char * const iio_chan_info_postfix[] = {
 	= "quadrature_correction_raw",
 };
 
+struct iio_channel *iio_channel_get(const struct device *dev,
+				    const char *name,
+				    const char *channel_name)
+{
+	struct iio_map *c_i = NULL, *c = NULL;
+	struct iio_dev *i_i = NULL, *indio_dev = NULL;
+	const struct iio_chan_spec *chan = NULL;
+
+	int i;
+	struct iio_channel *channel;
+
+	if (dev == NULL && name == NULL && channel_name == NULL)
+		return ERR_PTR(-ENODEV);
+	/* first find matching entry the channel map */
+	list_for_each_entry(c_i, &iio_map_list, l) {
+		if (dev && dev != c_i->consumer_dev)
+			continue;
+		if (name && strcmp(name, c_i->consumer_dev_name) != 0)
+			continue;
+
+		if (channel_name && strcmp(channel_name, c_i->consumer_channel)
+		    != 0)
+			continue;
+		c = c_i;
+		break;
+	}
+	if (c == NULL)
+		return ERR_PTR(-ENODEV);
+
+	mutex_lock(&iio_device_list_lock);
+	/* now find the iio device if it has been registered */
+	if (c->adc_dev) {
+		list_for_each_entry(i_i, &iio_device_list,
+				    dev_list_entry) {
+			if (i_i->info->get_hardware_id && c->adc_dev ==
+			    indio_dev->info->get_hardware_id(indio_dev)) {
+				indio_dev = i_i;
+				break;
+			} else if (indio_dev->dev.parent &&
+				   c->adc_dev == indio_dev->dev.parent) {
+				indio_dev = i_i;
+				break;
+			}
+		}
+	} else if (c->adc_dev_name) {
+		list_for_each_entry(i_i, &iio_device_list,
+				    dev_list_entry) {
+			if (i_i->info->get_hardware_id) {
+				if (c->adc_dev_name ==
+				    dev_name(i_i->info->get_hardware_id(i_i))) {
+					indio_dev = i_i;
+					break;
+				}
+			} else if (i_i->dev.parent) {
+				if (strcmp(c->adc_dev_name,
+					   dev_name(i_i->dev.parent)) == 0) {
+					indio_dev = i_i;
+					break;
+				}
+			} else {
+				printk(KERN_ERR "invalid map\n");
+				mutex_unlock(&iio_device_list_lock);
+				return ERR_PTR(-ENODEV);
+			}
+		}
+	}
+	if (indio_dev)
+		get_device(&indio_dev->dev);
+	mutex_unlock(&iio_device_list_lock);
+	if (indio_dev == NULL)
+		return ERR_PTR(-ENODEV);
+
+	/* finally verify the channel exists */
+	if (c->adc_channel_label)
+		for (i = 0; i < indio_dev->num_channels; i++)
+			if (indio_dev->channels[i].datasheet_name &&
+			    strcmp(c->adc_channel_label,
+				       indio_dev->channels[i].datasheet_name)
+			    == 0) {
+				chan = &indio_dev->channels[i];
+				break;
+			}
+	channel = kmalloc(sizeof(*channel), GFP_KERNEL);
+	if (channel == NULL)
+		return ERR_PTR(-ENOMEM);
+	channel->indio_dev = indio_dev;
+	if (chan == NULL)
+		channel->channel = &indio_dev->channels[c->channel_number];
+	else
+		channel->channel = chan;
+	return channel;
+}
+EXPORT_SYMBOL_GPL(iio_channel_get);
+
+void iio_channel_release(struct iio_channel *channel)
+{
+	put_device(&channel->indio_dev->dev);
+	kfree(channel);
+}
+EXPORT_SYMBOL_GPL(iio_channel_release);
+
+
+int iio_read_channel_raw(struct iio_channel *chan, int *val)
+{
+	int val2;
+	return chan->indio_dev->info->read_raw(chan->indio_dev, chan->channel,
+					       val, &val2, 0);
+}
+EXPORT_SYMBOL_GPL(iio_read_channel_raw);
+
 static void iio_device_free_read_attr(struct iio_dev *indio_dev,
 						 struct iio_dev_attr *p)
 {
diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
new file mode 100644
index 0000000..e2ba5d6
--- /dev/null
+++ b/drivers/iio/inkern.c
@@ -0,0 +1,21 @@
+/* The industrial I/O core in kernel channel mapping
+ *
+ * Copyright (c) 2011 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#include <linux/iio/inkern.h>
+#include <linux/err.h>
+
+LIST_HEAD(iio_map_list);
+EXPORT_SYMBOL_GPL(iio_map_list);
+void iio_map_array_register(struct iio_map *map, int nummaps)
+{
+	int i;
+	for (i = 0; i < nummaps; i++)
+		list_add(&map[i].l, &iio_map_list);
+}
+EXPORT_SYMBOL(iio_map_array_register);
+
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index f14e7dc..34c51b7 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -153,7 +153,10 @@ struct iio_dev;
  * @write_raw_get_fmt:	callback function to query the expected
  *			format/precision. If not set by the driver, write_raw
  *			returns IIO_VAL_INT_PLUS_MICRO.
- **/
+ * @get_hardware_id:	obtain device relating to hardware. Typically based on
+ *			the parent device (actual hardware).  Note that if
+ *			not specified then iio_dev.dev->parent is used.
+ */
 struct iio_info {
 	struct module			*driver_module;
 	const struct attribute_group	*attrs;
@@ -173,6 +176,7 @@ struct iio_info {
 	int (*write_raw_get_fmt)(struct iio_dev *indio_dev,
 			 struct iio_chan_spec const *chan,
 			 long mask);
+	struct device *(*get_hardware_id)(struct iio_dev *indio_dev);
 };
 
 /**
@@ -208,6 +212,7 @@ struct iio_dev {
 #define IIO_MAX_GROUPS 1
 	const struct attribute_group	*groups[IIO_MAX_GROUPS + 1];
 	int				groupcounter;
+	struct list_head		dev_list_entry;
 };
 
 /**
diff --git a/include/linux/iio/inkern.h b/include/linux/iio/inkern.h
new file mode 100644
index 0000000..89b43d32
--- /dev/null
+++ b/include/linux/iio/inkern.h
@@ -0,0 +1,63 @@
+#include <linux/device.h>
+#include <linux/list.h>
+
+struct iio_dev;
+struct iio_chan_spec;
+
+struct iio_channel {
+	struct iio_dev *indio_dev;
+	const struct iio_chan_spec *channel;
+};
+
+extern struct list_head iio_map_list;
+
+struct iio_map {
+	/* iio device side */
+	struct device *adc_dev;
+	const char *adc_dev_name;
+	const char *adc_channel_label;
+	int channel_number; /*naughty starting point */
+
+	/* consumer side */
+	struct device *consumer_dev;
+	const char *consumer_dev_name;
+	const char *consumer_channel;
+
+	/* management - probably neater ways of doing this */
+	struct list_head l;
+};
+
+void iio_map_array_register(struct iio_map *map, int nummaps);
+/**
+ * iio_channel_get() - get an opaque reference to a specified device.
+ */
+struct iio_channel *iio_channel_get(const struct device *dev,
+				    const char *name,
+				    const char *consumer_channel);
+void iio_channel_release(struct iio_channel *chan);
+
+/**
+ * iio_read_channel_raw() - read from a given channel
+ * @channel:	the channel being queried.
+ * @val:	value read back.
+ *
+ * Note raw reads from iio channels are in adc counts and hence
+ * scale will need to be applied if standard units required.
+ *
+ * Maybe want to pass the type as a sanity check.
+ */
+int iio_read_channel_raw(struct iio_channel *chan,
+			 int *val);
+
+/**
+ * iio_read_channel_scale() - read the scale value for a channel
+ * @channel:	the channel being queried.
+ * @val:	first part of value read back.
+ * @val2:	second part of value read back.
+ *
+ * Note returns a description of what is in val and val2, such
+ * as IIO_VAL_INT_PLUS_MICRO telling us we have a value of val
+ * + val2/1e6
+ */
+int iio_read_channel_scale(struct iio_channel *chan, int *val,
+			   int *val2);
-- 
1.7.7

