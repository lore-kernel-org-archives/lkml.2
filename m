Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab1KGPpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:45:49 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43071 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1KGPop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:44:45 -0500
From: Jonathan Cameron <jic23@kernel.org>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: guenter.roeck@ericsson.com, khali@linux-fr.org, dmitry.torokhov@gmail.com,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de, linus.walleij@linaro.org,
        lars@metafoo.de, maxime.ripard@free-electrons.com,
        lm-sensors@lm-sensors.org, thomas.petazzoni@free-electrons.com,
        zdevai@gmail.com, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 3/5] IIO:CORE add in kernel interface mapping and getting IIO channels.
Date: Mon,  7 Nov 2011 15:44:39 +0000
Message-Id: <1320680681-5635-4-git-send-email-jic23@kernel.org>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1320680681-5635-1-git-send-email-jic23@kernel.org>
References: <1320680681-5635-1-git-send-email-jic23@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

Two elements here:
* Map as defined in include/linux/iio/inkern.h
* Matching code to actually get the iio_dev and channel
that we want from the global list of IIO devices.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/Makefile           |    2 +-
 drivers/iio/Makefile       |    1 +
 drivers/iio/iio.c          |  264 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/iio/inkern.c       |   20 ++++
 include/linux/iio/iio.h    |    6 +-
 include/linux/iio/inkern.h |   95 ++++++++++++++++
 6 files changed, 381 insertions(+), 7 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index 216bba4..cf3d1f7 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -134,4 +134,4 @@ obj-$(CONFIG_HYPERV)		+= hv/
 
 obj-$(CONFIG_PM_DEVFREQ)	+= devfreq/
 
-obj-$(CONFIG_IIO)		+= iio/
+obj-y				+= iio/
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
index 9a98f5f..683a3db 100644
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
 
 static DEFINE_IDA(iio_ida);
 
@@ -66,6 +68,263 @@ static const char * const iio_chan_info_postfix[] = {
 	[IIO_CHAN_INFO_QUADRATURE_CORRECTION_RAW] = "quadrature_correction_raw",
 };
 
+static void iio_dev_release(struct device *device);
+static struct device_type iio_dev_type = {
+	.name = "iio_device",
+	.release = iio_dev_release,
+};
+
+static int iio_match_dev(struct device *dev, void *data)
+{
+	struct iio_dev *indio_dev;
+	struct device *dev2 = data;
+
+	if (dev->type != &iio_dev_type)
+		return 0;
+
+	indio_dev = container_of(dev, struct iio_dev, dev);
+	if (indio_dev->info->get_hardware_id)
+		return indio_dev->info->get_hardware_id(indio_dev) == dev2;
+	else
+		return indio_dev->dev.parent == dev2;
+}
+
+static int iio_match_dev_name(struct device *dev, void *data)
+{
+	struct iio_dev *indio_dev;
+	const char *name = data;
+
+	if (dev->type != &iio_dev_type)
+		return 0;
+
+	indio_dev = container_of(dev, struct iio_dev, dev);
+	if (indio_dev->info->get_hardware_id)
+		return !strcmp(dev_name(indio_dev->info
+					->get_hardware_id(indio_dev)),
+			       name);
+	else if (indio_dev->dev.parent)
+		return !strcmp(dev_name(indio_dev->dev.parent), name);
+	return 0;
+}
+
+static const struct iio_chan_spec
+*iio_chan_spec_from_name(const struct iio_dev *indio_dev,
+			 const char *name)
+{
+	int i;
+	const struct iio_chan_spec *chan = NULL;
+	for (i = 0; i < indio_dev->num_channels; i++)
+		if (indio_dev->channels[i].datasheet_name &&
+		    strcmp(name, indio_dev->channels[i].datasheet_name) == 0) {
+			chan = &indio_dev->channels[i];
+			break;
+		}
+	return chan;
+}
+
+struct iio_channel *iio_channel_get(const struct device *dev,
+				    const char *name,
+				    const char *channel_name)
+{
+	struct iio_map *c_i = NULL, *c = NULL;
+	struct device *dev_i;
+	struct iio_channel *channel;
+
+	if (dev == NULL && name == NULL && channel_name == NULL)
+		return ERR_PTR(-ENODEV);
+	/* first find matching entry the channel map */
+	list_for_each_entry(c_i, &iio_map_list, l) {
+		if ((dev && dev != c_i->consumer_dev) ||
+		    (name && strcmp(name, c_i->consumer_dev_name) != 0) ||
+		    (channel_name &&
+		     strcmp(channel_name, c_i->consumer_channel) != 0))
+			continue;
+		c = c_i;
+		break;
+	}
+	if (c == NULL)
+		return ERR_PTR(-ENODEV);
+
+	/* now find the iio device if it has been registered */
+	if (c->adc_dev)
+		dev_i = bus_find_device(&iio_bus_type, NULL, c->adc_dev,
+					&iio_match_dev);
+	else if (c->adc_dev_name)
+		dev_i = bus_find_device(&iio_bus_type, NULL,
+					(void *)c->adc_dev_name,
+					&iio_match_dev_name);
+	else
+		return ERR_PTR(-EINVAL);
+	if (IS_ERR(dev_i))
+		return (void *)dev_i;
+	if (dev_i == NULL)
+		return ERR_PTR(-ENODEV);
+
+	channel = kmalloc(sizeof(*channel), GFP_KERNEL);
+	if (channel == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	channel->indio_dev = container_of(dev_i, struct iio_dev, dev);
+
+	if (c->adc_channel_label)
+		channel->channel =
+			iio_chan_spec_from_name(channel->indio_dev,
+						c->adc_channel_label);
+	if (channel->channel == NULL)
+		channel->channel =
+			&channel->indio_dev->channels[c->channel_number];
+
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
+struct iio_channel **iio_channel_get_all(const struct device *dev,
+					const char *name)
+{
+	struct iio_channel **chans;
+	struct iio_map *c = NULL;
+	int nummaps = 0;
+	int mapind = 0;
+	int i, ret;
+	struct device *dev_i;
+
+	if (dev == NULL && name == NULL) {
+		ret = -EINVAL;
+		goto error_ret;
+	}
+
+	/* first count the matching maps */
+	list_for_each_entry(c, &iio_map_list, l)
+		if ((dev && dev != c->consumer_dev) ||
+		    (name && strcmp(name, c->consumer_dev_name) != 0))
+			continue;
+		else
+			nummaps++;
+
+	if (nummaps == 0) {
+		ret = -ENODEV;
+		goto error_ret;
+	}
+
+	/* for each map fill in the chans element */
+	chans = kzalloc(sizeof(*chans)*(nummaps + 1), GFP_KERNEL);
+	if (chans == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	for (i = 0; i < nummaps; i++) {
+		chans[i] = kzalloc(sizeof(*chans[0]), GFP_KERNEL);
+		if (chans[i] == NULL) {
+			ret = -ENOMEM;
+			goto error_free_chans;
+		}
+	}
+
+	/* for each map fill in the chans element */
+	list_for_each_entry(c, &iio_map_list, l) {
+		dev_i = NULL;
+		if (dev && dev != c->consumer_dev)
+			continue;
+		if (name && strcmp(name, c->consumer_dev_name) != 0)
+			continue;
+		while (1) {
+			if (c->adc_dev) {
+				dev_i = bus_find_device(&iio_bus_type,
+							dev_i,
+							c->adc_dev,
+							&iio_match_dev);
+			} else if (c->adc_dev_name) {
+				dev_i = bus_find_device(&iio_bus_type,
+							dev_i,
+							(void *)c->adc_dev_name,
+							&iio_match_dev_name);
+			} else {
+				ret = -EINVAL;
+				goto error_free_chans;
+			}
+			if (IS_ERR(dev_i)) {
+				ret = PTR_ERR(dev_i);
+				goto error_free_chans;
+			}
+			if (dev_i == NULL)
+				break;
+
+			chans[mapind]->indio_dev =
+				container_of(dev_i, struct iio_dev, dev);
+			chans[mapind]->channel =
+				iio_chan_spec_from_name(chans[mapind]->
+							indio_dev,
+							c->adc_channel_label);
+			if (chans[mapind]->channel == NULL) {
+				ret = -EINVAL;
+				put_device(&chans[mapind]->indio_dev->dev);
+				goto error_free_chans;
+			}
+			mapind++;
+		}
+	}
+	return chans;
+
+error_free_chans:
+	for (i = 0; i < nummaps; i++)
+		if (chans[i]) {
+			put_device(&chans[i]->indio_dev->dev);
+			kfree(chans[i]);
+		}
+	kfree(chans);
+error_ret:
+
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(iio_channel_get_all);
+
+void iio_channel_release_all(struct iio_channel **channels)
+{
+	int i = 0;
+	struct iio_channel *chan = channels[i];
+
+	while (chan) {
+		put_device(&chan->indio_dev->dev);
+		kfree(chan);
+		i++;
+		chan = channels[i];
+	}
+	kfree(channels);
+}
+EXPORT_SYMBOL_GPL(iio_channel_release_all);
+
+int iio_read_channel_raw(struct iio_channel *chan, int *val)
+{
+	int val2;
+	return chan->indio_dev->info->read_raw(chan->indio_dev, chan->channel,
+					       val, &val2, 0);
+}
+EXPORT_SYMBOL_GPL(iio_read_channel_raw);
+
+int iio_read_channel_scale(struct iio_channel *chan, int *val, int *val2)
+{
+	/* Does this channel have shared scale? */
+	return chan->indio_dev
+		->info->read_raw(chan->indio_dev,
+				 chan->channel,
+				 val, val2,
+				 (1 << IIO_CHAN_INFO_SCALE));
+}
+EXPORT_SYMBOL_GPL(iio_read_channel_scale);
+
+enum iio_chan_type iio_get_channel_type(struct iio_channel *channel)
+{
+	return channel->channel->type;
+}
+EXPORT_SYMBOL_GPL(iio_get_channel_type);
+
 static void iio_device_free_read_attr(struct iio_dev *indio_dev,
 						 struct iio_dev_attr *p)
 {
@@ -91,11 +350,6 @@ static void iio_dev_release(struct device *device)
 	iio_device_unregister_sysfs(indio_dev);
 }
 
-static struct device_type iio_dev_type = {
-	.name = "iio_device",
-	.release = iio_dev_release,
-};
-
 struct iio_dev *iio_device_allocate(int sizeof_priv)
 {
 	struct iio_dev *dev;
diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
new file mode 100644
index 0000000..b7c2788
--- /dev/null
+++ b/drivers/iio/inkern.c
@@ -0,0 +1,20 @@
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
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 36a50b2..875704d 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -147,7 +147,10 @@ struct iio_dev;
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
@@ -167,6 +170,7 @@ struct iio_info {
 	int (*write_raw_get_fmt)(struct iio_dev *indio_dev,
 			 struct iio_chan_spec const *chan,
 			 long mask);
+	struct device *(*get_hardware_id)(struct iio_dev *indio_dev);
 };
 
 /**
diff --git a/include/linux/iio/inkern.h b/include/linux/iio/inkern.h
new file mode 100644
index 0000000..de15c00
--- /dev/null
+++ b/include/linux/iio/inkern.h
@@ -0,0 +1,95 @@
+/*
+ * The industrial I/O core - in kernel channel mapping infrastructure
+ *
+ * Copyright (c) 2011 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _IIO_INKERN_H_
+#define _IIO_INKERN_H_
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/iio/types.h>
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
+ * iio_channel_get_all() - get all channels associated with a client
+ *
+ * returns a null terminated array of pointers to iio_channel structures.
+ */
+struct iio_channel **iio_channel_get_all(const struct device *dev,
+					const char *name);
+
+void iio_channel_release_all(struct iio_channel **chan);
+
+/**
+ * iio_st_read_channel_raw() - read from a given channel
+ * @channel:	the channel being queried.
+ * @val:	value read back.
+ *
+ * Note raw reads from iio channels are in adc counts and hence
+ * scale will need to be applied if standard units required.
+ *
+ * Maybe want to pass the type as a sanity check.
+ */
+int iio_read_channel_raw(struct iio_channel *chan,
+			    int *val);
+
+/**
+ * iio_get_channel_type() - get the type of a channel
+ * @channel:	the channel being queried.
+ *
+ * returns the enum iio_chan_type of the channel
+ */
+enum iio_chan_type iio_get_channel_type(struct iio_channel *channel);
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
+			      int *val2);
+
+#endif
-- 
1.7.7.2

