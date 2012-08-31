Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2HaBnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 21:43:11 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:46638 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab2HaBnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 21:43:10 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: lm-sensors@lm-sensors.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] hwmon: add Maxim MAX197 support
Date: Thu, 30 Aug 2012 21:42:57 -0400
Message-Id: <1346377377-24717-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX197 is an A/D converter, made by Maxim. This driver currently
supports the MAX197, and MAX199. They are both 8-Channel, Multi-Range,
5V, 12-Bit DAS with 8+4 Bus Interface and Fault Protection.

The available ranges for the MAX197 are {0,-5V} to 5V, and {0,-10V} to
10V, while they are {0,-2V} to 2V, and {0,-4V} to 4V on the MAX199.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 Documentation/hwmon/max197           |  60 ++++++
 drivers/hwmon/Kconfig                |   9 +
 drivers/hwmon/Makefile               |   1 +
 drivers/hwmon/max197.c               | 349 +++++++++++++++++++++++++++++++++++
 include/linux/platform_data/max197.h |  21 +++
 5 files changed, 440 insertions(+)
 create mode 100644 Documentation/hwmon/max197
 create mode 100644 drivers/hwmon/max197.c
 create mode 100644 include/linux/platform_data/max197.h

diff --git a/Documentation/hwmon/max197 b/Documentation/hwmon/max197
new file mode 100644
index 0000000..8d89b90
--- /dev/null
+++ b/Documentation/hwmon/max197
@@ -0,0 +1,60 @@
+Maxim MAX197 driver
+===================
+
+Author:
+  * Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+
+Supported chips:
+  * Maxim MAX197
+    Prefix: 'max197'
+    Datasheet: http://datasheets.maxim-ic.com/en/ds/MAX197.pdf
+
+  * Maxim MAX199
+    Prefix: 'max199'
+    Datasheet: http://datasheets.maxim-ic.com/en/ds/MAX199.pdf
+
+Description
+-----------
+
+The A/D converters MAX197, and MAX199 are both 8-Channel, Multi-Range, 5V,
+12-Bit DAS with 8+4 Bus Interface and Fault Protection.
+
+The available ranges for the MAX197 are {0,-5V} to 5V, and {0,-10V} to 10V,
+while they are {0,-2V} to 2V, and {0,-4V} to 4V on the MAX199.
+
+Platform data
+-------------
+
+The MAX197 platform data (defined in linux/platform_data/max197.h) should be
+filled with a pointer to a conversion function, defined like:
+
+    int convert(u8 ctrl);
+
+ctrl is the control byte to write to start a new conversion.
+On success, the function must return the 12-bit raw value read from the chip,
+or a negative error code otherwise.
+
+Control byte format:
+
+Bit     Name       Description
+7,6     PD1,PD0    Clock and Power-Down modes
+5       ACQMOD     Internal or External Controlled Acquisition
+4       RNG        Full-scale voltage magnitude at the input
+3       BIP        Unipolar or Bipolar conversion mode
+2,1,0   A2,A1,A0   Channel
+
+Sysfs interface
+---------------
+
+* in[0-7]_input: The conversion value for the corresponding channel.
+                 RO
+
+* in[0-7]_min:   The lower limit (in mV) for the corresponding channel.
+                 For the MAX197, it will be adjusted to -10000, -5000, or 0.
+                 For the MAX199, it will be adjusted to -4000, -2000, or 0.
+                 RW
+
+* in[0-7]_max:   The higher limit (in mV) for the corresponding channel.
+                 For the MAX197, it will be adjusted to 0, 5000, or 10000.
+                 For the MAX199, it will be adjusted to 0, 2000, or 4000.
+                 RW
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index b0a2e4c..2196869 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -803,6 +803,15 @@ config SENSORS_MAX1668
 	  This driver can also be built as a module.  If so, the module
 	  will be called max1668.
 
+config SENSORS_MAX197
+	tristate "Maxim MAX197 and compatibles"
+	help
+	  Support for the Maxim MAX197 A/D converter.
+	  Support will include, but not be limited to, MAX197, and MAX199.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called max197.
+
 config SENSORS_MAX6639
 	tristate "Maxim MAX6639 sensor chip"
 	depends on I2C && EXPERIMENTAL
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 7aa9811..1e8f690 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -94,6 +94,7 @@ obj-$(CONFIG_SENSORS_MAX1111)	+= max1111.o
 obj-$(CONFIG_SENSORS_MAX16065)	+= max16065.o
 obj-$(CONFIG_SENSORS_MAX1619)	+= max1619.o
 obj-$(CONFIG_SENSORS_MAX1668)	+= max1668.o
+obj-$(CONFIG_SENSORS_MAX197)	+= max197.o
 obj-$(CONFIG_SENSORS_MAX6639)	+= max6639.o
 obj-$(CONFIG_SENSORS_MAX6642)	+= max6642.o
 obj-$(CONFIG_SENSORS_MAX6650)	+= max6650.o
diff --git a/drivers/hwmon/max197.c b/drivers/hwmon/max197.c
new file mode 100644
index 0000000..6304f26
--- /dev/null
+++ b/drivers/hwmon/max197.c
@@ -0,0 +1,349 @@
+/*
+ * Maxim MAX197 A/D Converter driver
+ *
+ * Copyright (c) 2012 Savoir-faire Linux Inc.
+ *          Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * For further information, see the Documentation/hwmon/max197 file.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+#include <linux/sysfs.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/max197.h>
+
+#define MAX199_LIMIT	4000		/* 4V */
+#define MAX197_LIMIT	10000		/* 10V */
+
+#define MAX197_NUM_CH	8		/* 8 Analog Input Channels */
+
+/* Control byte format */
+#define MAX197_BIP	(1 << 3)	/* Bipolarity */
+#define MAX197_RNG	(1 << 4)	/* Full range */
+
+#define MAX197_SCALE	12207		/* Scale coefficient for raw data */
+
+/* List of supported chips */
+enum max197_chips { max197, max199 };
+
+/**
+ * struct max197_data - device instance specific data
+ * @pdata:		Platform data.
+ * @hwmon_dev:		The hwmon device.
+ * @lock:		Read/Write mutex.
+ * @limit:		Max range value (10V for MAX197, 4V for MAX199).
+ * @scale:		Need to scale.
+ * @ctrl_bytes:		Channels control byte.
+ */
+struct max197_data {
+	struct max197_platform_data *pdata;
+	struct device *hwmon_dev;
+	struct mutex lock;
+	int limit;
+	bool scale;
+	u8 ctrl_bytes[MAX197_NUM_CH];
+};
+
+static inline void max197_set_unipolarity(struct max197_data *data, int channel)
+{
+	data->ctrl_bytes[channel] &= ~MAX197_BIP;
+}
+
+static inline void max197_set_bipolarity(struct max197_data *data, int channel)
+{
+	data->ctrl_bytes[channel] |= MAX197_BIP;
+}
+
+static inline void max197_set_half_range(struct max197_data *data, int channel)
+{
+	data->ctrl_bytes[channel] &= ~MAX197_RNG;
+}
+
+static inline void max197_set_full_range(struct max197_data *data, int channel)
+{
+	data->ctrl_bytes[channel] |= MAX197_RNG;
+}
+
+static inline bool max197_is_bipolar(struct max197_data *data, int channel)
+{
+	return data->ctrl_bytes[channel] & MAX197_BIP;
+}
+
+static inline bool max197_is_full_range(struct max197_data *data, int channel)
+{
+	return data->ctrl_bytes[channel] & MAX197_RNG;
+}
+
+/* Function called on read access on in{0,1,2,3,4,5,6,7}_{min,max} */
+static ssize_t max197_show_range(struct device *dev,
+				 struct device_attribute *devattr, char *buf)
+{
+	struct max197_data *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+	int channel = attr->index;
+	bool is_min = attr->nr;
+	int range;
+
+	if (mutex_lock_interruptible(&data->lock))
+		return -ERESTARTSYS;
+
+	range = max197_is_full_range(data, channel) ?
+		data->limit : data->limit / 2;
+	if (is_min) {
+		if (max197_is_bipolar(data, channel))
+			range = -range;
+		else
+			range = 0;
+	}
+
+	mutex_unlock(&data->lock);
+
+	return sprintf(buf, "%d\n", range);
+}
+
+/* Function called on write access on in{0,1,2,3,4,5,6,7}_{min,max} */
+static ssize_t max197_store_range(struct device *dev,
+				  struct device_attribute *devattr,
+				  const char *buf, size_t count)
+{
+	struct max197_data *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+	int channel = attr->index;
+	bool is_min = attr->nr;
+	long value;
+	int half = data->limit / 2;
+	int full = data->limit;
+
+	if (kstrtol(buf, 10, &value))
+		return -EINVAL;
+
+	if (is_min) {
+		if (value <= -full)
+			value = -full;
+		else if (value < 0)
+			value = -half;
+		else
+			value = 0;
+	} else {
+		if (value >= full)
+			value = full;
+		else
+			value = half;
+	}
+
+	if (mutex_lock_interruptible(&data->lock))
+		return -ERESTARTSYS;
+
+	if (value == 0) {
+		/* We can deduce only the polarity */
+		max197_set_unipolarity(data, channel);
+	} else if (value == -half) {
+		max197_set_bipolarity(data, channel);
+		max197_set_half_range(data, channel);
+	} else if (value == -full) {
+		max197_set_bipolarity(data, channel);
+		max197_set_full_range(data, channel);
+	} else if (value == half) {
+		/* We can deduce only the range */
+		max197_set_half_range(data, channel);
+	} else if (value == full) {
+		/* We can deduce only the range */
+		max197_set_full_range(data, channel);
+	}
+
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+/* Function called on read access on in{0,1,2,3,4,5,6,7}_input */
+static ssize_t max197_show_input(struct device *dev,
+				 struct device_attribute *devattr,
+				 char *buf)
+{
+	struct max197_data *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	int channel = attr->index;
+	s32 value;
+	int ret;
+
+	if (mutex_lock_interruptible(&data->lock))
+		return -ERESTARTSYS;
+
+	ret = data->pdata->convert(data->ctrl_bytes[channel]);
+	if (ret < 0) {
+		dev_err(dev, "conversion failed\n");
+		goto unlock;
+	}
+	value = ret;
+
+	/*
+	 * Coefficient to apply on raw value.
+	 * See Table 1. Full Scale and Zero Scale in the MAX197 datasheet.
+	 */
+	if (data->scale) {
+		value *= MAX197_SCALE;
+		if (max197_is_full_range(data, channel))
+			value *= 2;
+		value /= 10000;
+	}
+
+	ret = sprintf(buf, "%d\n", value);
+
+unlock:
+	mutex_unlock(&data->lock);
+	return ret;
+}
+
+static ssize_t max197_show_name(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	return sprintf(buf, "%s\n", pdev->name);
+}
+
+#define MAX197_SENSOR_DEVICE_ATTR_CH(chan)				\
+	static SENSOR_DEVICE_ATTR(in##chan##_input, S_IRUGO,		\
+				  max197_show_input, NULL, chan);	\
+	static SENSOR_DEVICE_ATTR_2(in##chan##_min, S_IRUGO | S_IWUSR,	\
+				    max197_show_range,			\
+				    max197_store_range,			\
+				    true, chan);			\
+	static SENSOR_DEVICE_ATTR_2(in##chan##_max, S_IRUGO | S_IWUSR,	\
+				    max197_show_range,			\
+				    max197_store_range,			\
+				    false, chan)
+
+#define MAX197_SENSOR_DEV_ATTR_IN(chan)					\
+	&sensor_dev_attr_in##chan##_input.dev_attr.attr,		\
+	&sensor_dev_attr_in##chan##_max.dev_attr.attr,			\
+	&sensor_dev_attr_in##chan##_min.dev_attr.attr
+
+static DEVICE_ATTR(name, S_IRUGO, max197_show_name, NULL);
+
+MAX197_SENSOR_DEVICE_ATTR_CH(0);
+MAX197_SENSOR_DEVICE_ATTR_CH(1);
+MAX197_SENSOR_DEVICE_ATTR_CH(2);
+MAX197_SENSOR_DEVICE_ATTR_CH(3);
+MAX197_SENSOR_DEVICE_ATTR_CH(4);
+MAX197_SENSOR_DEVICE_ATTR_CH(5);
+MAX197_SENSOR_DEVICE_ATTR_CH(6);
+MAX197_SENSOR_DEVICE_ATTR_CH(7);
+
+static const struct attribute_group max197_sysfs_group = {
+	.attrs = (struct attribute *[]) {
+		&dev_attr_name.attr,
+		MAX197_SENSOR_DEV_ATTR_IN(0),
+		MAX197_SENSOR_DEV_ATTR_IN(1),
+		MAX197_SENSOR_DEV_ATTR_IN(2),
+		MAX197_SENSOR_DEV_ATTR_IN(3),
+		MAX197_SENSOR_DEV_ATTR_IN(4),
+		MAX197_SENSOR_DEV_ATTR_IN(5),
+		MAX197_SENSOR_DEV_ATTR_IN(6),
+		MAX197_SENSOR_DEV_ATTR_IN(7),
+		NULL
+	},
+};
+
+static int __devinit max197_probe(struct platform_device *pdev)
+{
+	int ch, ret;
+	struct max197_data *data;
+	struct max197_platform_data *pdata = pdev->dev.platform_data;
+	enum max197_chips chip = platform_get_device_id(pdev)->driver_data;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "no platform data supplied\n");
+		return -EINVAL;
+	}
+
+	if (pdata->convert == NULL) {
+		dev_err(&pdev->dev, "no convert function supplied\n");
+		return -EINVAL;
+	}
+
+	data = devm_kzalloc(&pdev->dev, sizeof(struct max197_data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&pdev->dev, "devm_kzalloc failed\n");
+		return -ENOMEM;
+	}
+
+	data->pdata = pdata;
+	mutex_init(&data->lock);
+
+	if (chip == max197) {
+		data->limit = MAX197_LIMIT;
+		data->scale = true;
+	} else {
+		data->limit = MAX199_LIMIT;
+		data->scale = false;
+	}
+
+	for (ch = 0; ch < MAX197_NUM_CH; ch++)
+		data->ctrl_bytes[ch] = (u8) ch;
+
+	platform_set_drvdata(pdev, data);
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &max197_sysfs_group);
+	if (ret) {
+		dev_err(&pdev->dev, "sysfs create group failed\n");
+		return ret;
+	}
+
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		ret = PTR_ERR(data->hwmon_dev);
+		dev_err(&pdev->dev, "hwmon device register failed\n");
+		goto error;
+	}
+
+	return 0;
+
+error:
+	sysfs_remove_group(&pdev->dev.kobj, &max197_sysfs_group);
+	return ret;
+}
+
+static int __devexit max197_remove(struct platform_device *pdev)
+{
+	struct max197_data *data = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&pdev->dev.kobj, &max197_sysfs_group);
+
+	return 0;
+}
+
+static struct platform_device_id max197_device_ids[] = {
+	{ "max197", max197 },
+	{ "max199", max199 },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, max197_device_ids);
+
+static struct platform_driver max197_driver = {
+	.driver = {
+		.name = "max197",
+		.owner = THIS_MODULE,
+	},
+	.probe = max197_probe,
+	.remove = __devexit_p(max197_remove),
+	.id_table = max197_device_ids,
+};
+module_platform_driver(max197_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>");
+MODULE_DESCRIPTION("Maxim MAX197 A/D Converter driver");
diff --git a/include/linux/platform_data/max197.h b/include/linux/platform_data/max197.h
new file mode 100644
index 0000000..e2a41dd
--- /dev/null
+++ b/include/linux/platform_data/max197.h
@@ -0,0 +1,21 @@
+/*
+ * Maxim MAX197 A/D Converter Driver
+ *
+ * Copyright (c) 2012 Savoir-faire Linux Inc.
+ *          Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * For further information, see the Documentation/hwmon/max197 file.
+ */
+
+/**
+ * struct max197_platform_data - MAX197 connectivity info
+ * @convert:	Function used to start a conversion with control byte ctrl.
+ *		It must return the raw data, or a negative error code.
+ */
+struct max197_platform_data {
+	int (*convert)(u8 ctrl);
+};
-- 
1.7.11.4

