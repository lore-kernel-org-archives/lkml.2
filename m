Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab1KGRnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:43:17 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45811 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab1KGRnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:43:16 -0500
From: Jonathan Cameron <jic23@kernel.org>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: guenter.roeck@ericsson.com, khali@linux-fr.org, dmitry.torokhov@gmail.com,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de, linus.walleij@linaro.org,
        lars@metafoo.de, maxime.ripard@free-electrons.com,
        lm-sensors@lm-sensors.org, thomas.petazzoni@free-electrons.com,
        zdevai@gmail.com, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH] IIO:hwmon interface client driver.
Date: Mon,  7 Nov 2011 17:43:01 +0000
Message-Id: <1320687781-15306-1-git-send-email-jic23@kernel.org>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <4EB817C6.5070503@kernel.org>
References: <4EB817C6.5070503@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

Should move to drivers/hwmon once people are happy with it.

Minimal support of simple in, curr and temp attributes
so far.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
Fixed up the missing free Guenter spotted.
Thanks!
 drivers/iio/Kconfig     |    8 ++
 drivers/iio/Makefile    |    1 +
 drivers/iio/iio_hwmon.c |  228 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 237 insertions(+), 0 deletions(-)
 create mode 100644 drivers/iio/iio_hwmon.c

diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index 308bc97..c2f0970 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -11,6 +11,14 @@ menuconfig IIO
 
 if IIO
 
+config IIO_HWMON
+       tristate "Hwmon driver that uses channels specified via iio maps"
+       depends on HWMON
+       help
+	  This is a platform driver that in combination with a suitable
+	  map allows IIO devices to provide  basic hwmon functionality
+	  for those channels specified in the map.
+
 source "drivers/iio/adc/Kconfig"
 source "drivers/iio/imu/Kconfig"
 source "drivers/iio/light/Kconfig"
diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
index cfb588a..5f9c01a 100644
--- a/drivers/iio/Makefile
+++ b/drivers/iio/Makefile
@@ -6,6 +6,7 @@ obj-y = inkern.o
 obj-$(CONFIG_IIO) += iio.o
 industrialio-y := core.o
 
+obj-$(CONFIG_IIO_HWMON) += iio_hwmon.o
 obj-y += adc/
 obj-y += imu/
 obj-y += light/
diff --git a/drivers/iio/iio_hwmon.c b/drivers/iio/iio_hwmon.c
new file mode 100644
index 0000000..880ce6d
--- /dev/null
+++ b/drivers/iio/iio_hwmon.c
@@ -0,0 +1,228 @@
+/* Hwmon client for industrial I/O devices
+ *
+ * Copyright (c) 2011 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * Limited functionality currently supported.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/iio/inkern.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+
+/**
+ * struct iio_hwmon_state - device instance state
+ * @channels:		filled with null terminated array of channels from iio
+ * @num_channels:	number of channels in channels (saves counting twice)
+ * @hwmon_dev:		associated hwmon device
+ * @attr_group:	the group of attributes
+ * @attrs:		null terminated array of attribute pointers.
+ */
+struct iio_hwmon_state {
+	struct iio_channel **channels;
+	int num_channels;
+	struct device *hwmon_dev;
+	struct attribute_group attr_group;
+	struct attribute **attrs;
+};
+
+/*
+ * Assumes that IIO and hwmon operate in the same base units.
+ * This is supposed to be true, but needs verification for
+ * new channel types.
+ */
+static ssize_t iio_hwmon_read_val(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	long result;
+	int val, ret, scaleint, scalepart;
+	struct sensor_device_attribute *sattr = to_sensor_dev_attr(attr);
+	struct iio_hwmon_state *state = dev_get_drvdata(dev);
+
+	/*
+	 * No locking between this pair, so theoretically possible
+	 * the scale has changed.
+	 */
+	ret = iio_read_channel_raw(state->channels[sattr->index],
+				   &val);
+	if (ret < 0)
+		return ret;
+
+	ret = iio_read_channel_scale(state->channels[sattr->index],
+				     &scaleint, &scalepart);
+	if (ret < 0)
+		return ret;
+	switch (ret) {
+	case IIO_VAL_INT:
+		result = val * scaleint;
+		break;
+	case IIO_VAL_INT_PLUS_MICRO:
+		result = (long)val * (long)scaleint +
+			div_s64((s64)val * (s64)scalepart, 1000000LL);
+		break;
+	case IIO_VAL_INT_PLUS_NANO:
+		result = (long)val * (long)scaleint +
+			div_s64((s64)val * (s64)scalepart, 1000000000LL);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return sprintf(buf, "%ld\n", result);
+}
+
+static void iio_hwmon_free_attrs(struct iio_hwmon_state *st)
+{
+	int i;
+	struct sensor_device_attribute *a;
+	for (i = 0; i < st->num_channels; i++)
+		if (st->attrs[i]) {
+			a = to_sensor_dev_attr(
+				container_of(st->attrs[i],
+					     struct device_attribute,
+					     attr));
+			kfree(a);
+		}
+}
+
+static int __devinit iio_hwmon_probe(struct platform_device *pdev)
+{
+	struct iio_hwmon_state *st;
+	struct sensor_device_attribute *a;
+	int ret, i;
+	int in_i = 1, temp_i = 1, curr_i = 1;
+
+	st = kzalloc(sizeof(*st), GFP_KERNEL);
+	if (st == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+
+	st->channels = iio_channel_get_all(&pdev->dev, NULL);
+	if (IS_ERR(st->channels)) {
+		ret = PTR_ERR(st->channels);
+		goto error_free_state;
+	}
+
+	/* count how many attributes we have */
+	while (st->channels[st->num_channels])
+		st->num_channels++;
+
+	st->attrs = kzalloc(sizeof(st->attrs) * (st->num_channels + 1),
+			    GFP_KERNEL);
+	if (st->attrs == NULL) {
+		ret = -ENOMEM;
+		goto error_release_channels;
+	}
+	for (i = 0; i < st->num_channels; i++) {
+		a = kzalloc(sizeof(*a), GFP_KERNEL);
+		if (a == NULL) {
+			ret = -ENOMEM;
+			goto error_free_attrs;
+		}
+
+		sysfs_attr_init(&a->dev_attr.attr);
+		switch (iio_get_channel_type(st->channels[i])) {
+		case IIO_VOLTAGE:
+			a->dev_attr.attr.name = kasprintf(GFP_KERNEL,
+							  "in%d_input",
+							  in_i++);
+			break;
+		case IIO_TEMP:
+			a->dev_attr.attr.name = kasprintf(GFP_KERNEL,
+							  "temp%d_input",
+							  temp_i++);
+			break;
+		case IIO_CURRENT:
+			a->dev_attr.attr.name = kasprintf(GFP_KERNEL,
+							  "curr%d_input",
+							  curr_i++);
+			break;
+		default:
+			ret = -EINVAL;
+			kfree(a);
+			goto error_free_attrs;
+		}
+		if (a->dev_attr.attr.name == NULL) {
+			kfree(a);
+			ret = -ENOMEM;
+			goto error_free_attrs;
+		}
+		a->dev_attr.show = iio_hwmon_read_val;
+		a->dev_attr.attr.mode = S_IRUGO;
+		a->index = i;
+		st->attrs[i] = &a->dev_attr.attr;
+	}
+
+	st->attr_group.attrs = st->attrs;
+	platform_set_drvdata(pdev, st);
+	ret = sysfs_create_group(&pdev->dev.kobj, &st->attr_group);
+	if (ret < 0)
+		goto error_free_attrs;
+
+	st->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(st->hwmon_dev)) {
+		ret = PTR_ERR(st->hwmon_dev);
+		goto error_remove_group;
+	}
+	return 0;
+
+error_remove_group:
+	sysfs_remove_group(&pdev->dev.kobj, &st->attr_group);
+error_free_attrs:
+	iio_hwmon_free_attrs(st);
+	kfree(st->attrs);
+error_release_channels:
+	iio_channel_release_all(st->channels);
+error_free_state:
+	kfree(st);
+error_ret:
+	return ret;
+}
+
+static int __devexit iio_hwmon_remove(struct platform_device *pdev)
+{
+	struct iio_hwmon_state *st = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(st->hwmon_dev);
+	sysfs_remove_group(&pdev->dev.kobj, &st->attr_group);
+	iio_hwmon_free_attrs(st);
+	kfree(st->attrs);
+	iio_channel_release_all(st->channels);
+	kfree(st);
+
+	return 0;
+}
+
+static struct platform_driver __refdata iio_hwmon_driver = {
+	.driver = {
+		.name = "iio_hwmon",
+		.owner = THIS_MODULE,
+	},
+	.probe = iio_hwmon_probe,
+	.remove = __devexit_p(iio_hwmon_remove),
+};
+
+static int iio_inkern_init(void)
+{
+	return platform_driver_register(&iio_hwmon_driver);
+}
+module_init(iio_inkern_init);
+
+static void iio_inkern_exit(void)
+{
+	platform_driver_unregister(&iio_hwmon_driver);
+}
+module_exit(iio_inkern_exit);
+
+MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
+MODULE_DESCRIPTION("IIO to hwmon driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.7.2

