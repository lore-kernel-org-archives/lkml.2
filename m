Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934795Ab2DMArN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:47:13 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:52808 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2DMArJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:47:09 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH v6 1/3] hwmon: Maxim MAX197 support
Date: Thu, 12 Apr 2012 20:28:53 -0400
Message-Id: <1334276935-11258-2-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1334276935-11258-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1334276935-11258-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 Documentation/hwmon/max197 |   59 +++++++
 drivers/hwmon/Kconfig      |    9 +
 drivers/hwmon/Makefile     |    1 +
 drivers/hwmon/max197.c     |  398 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/max197.h     |   20 +++
 5 files changed, 487 insertions(+)
 create mode 100644 Documentation/hwmon/max197
 create mode 100644 drivers/hwmon/max197.c
 create mode 100644 include/linux/max197.h

diff --git a/Documentation/hwmon/max197 b/Documentation/hwmon/max197
new file mode 100644
index 0000000..318f6d1
--- /dev/null
+++ b/Documentation/hwmon/max197
@@ -0,0 +1,59 @@
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
+The A/D converters MAX197 and MAX199 are both 8-Channel, Multi-Range, 5V,
+12-Bit DAS with 8+4 Bus Interface and Fault Protection.
+
+The available ranges for the MAX197 are {0,-5V} to 5V, and {0,-10V} to 10V,
+while they are {0,-2V} to 2V, and {0,-4V} to 4V on the MAX199.
+
+Platform data
+-------------
+
+The MAX197 platform data (defined in linux/max197.h) should be filled with a
+pointer to a conversion function, defined like:
+
+    int convert(u8 ctrl, u16 *raw);
+
+ctrl is the control byte to write to start a new conversion, and raw is a
+pointer to the raw value read from the chip.
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
index 8deedc1..f5eefe6 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1376,6 +1376,15 @@ config SENSORS_MC13783_ADC
         help
           Support for the A/D converter on MC13783 and MC13892 PMIC.
 
+config SENSORS_MAX197
+	tristate "Maxim MAX197 and compatibles."
+	help
+	  If you say yes here you get support for the Maxim MAX197,
+	  and MAX199 A/D converters.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called max197.
+
 if ACPI
 
 comment "ACPI drivers"
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 6d3f11f..a69b8c6 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -126,6 +126,7 @@ obj-$(CONFIG_SENSORS_W83L785TS)	+= w83l785ts.o
 obj-$(CONFIG_SENSORS_W83L786NG)	+= w83l786ng.o
 obj-$(CONFIG_SENSORS_WM831X)	+= wm831x-hwmon.o
 obj-$(CONFIG_SENSORS_WM8350)	+= wm8350-hwmon.o
+obj-$(CONFIG_SENSORS_MAX197)	+= max197.o
 
 obj-$(CONFIG_PMBUS)		+= pmbus/
 
diff --git a/drivers/hwmon/max197.c b/drivers/hwmon/max197.c
new file mode 100644
index 0000000..e2317da
--- /dev/null
+++ b/drivers/hwmon/max197.c
@@ -0,0 +1,398 @@
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
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/sysfs.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/max197.h>
+
+#define MAX199_LIMIT	4000	/* 4V */
+#define MAX197_LIMIT	10000	/* 10V */
+
+#define MAX197_NUM_CH	8	/* 8 Analog Input Channels */
+
+/* Control byte format */
+#define MAX197_A0	0x01	/* Channel bit 0 */
+#define MAX197_A1	0x02	/* Channel bit 1 */
+#define MAX197_A2	0x04	/* Channel bit 2 */
+#define MAX197_BIP	0x08	/* Bipolarity */
+#define MAX197_RNG	0x10	/* Full range */
+#define MAX197_ACQMOD	0x20	/* Internal/External controlled acquisition */
+#define MAX197_PD0	0x40	/* Clock/Power-Down modes bit 1 */
+#define MAX197_PD1	0x80	/* Clock/Power-Down modes bit 2 */
+
+#define MAX197_SCALE	12207	/* Scale coefficient for raw data */
+
+/**
+ * struct max197_chip - device instance specific data
+ * @pdata:		Platform data.
+ * @hwmon_dev:		The hwmon device.
+ * @lock:		Read/Write mutex.
+ * @limit:		Max range value (10V for MAX197, 4V for MAX199).
+ * @scale:		Need to scale.
+ * @ctrl_bytes:		Channels control byte.
+ */
+struct max197_chip {
+	struct max197_platform_data *pdata;
+	struct device *hwmon_dev;
+	struct mutex lock;
+	int limit;
+	bool scale;
+	u8 ctrl_bytes[MAX197_NUM_CH];
+};
+
+static inline void max197_set_unipolarity(struct max197_chip *chip, int channel)
+{
+	chip->ctrl_bytes[channel] &= ~MAX197_BIP;
+}
+
+static inline void max197_set_bipolarity(struct max197_chip *chip, int channel)
+{
+	chip->ctrl_bytes[channel] |= MAX197_BIP;
+}
+
+static inline void max197_set_half_range(struct max197_chip *chip, int channel)
+{
+	chip->ctrl_bytes[channel] &= ~MAX197_RNG;
+}
+
+static inline void max197_set_full_range(struct max197_chip *chip, int channel)
+{
+	chip->ctrl_bytes[channel] |= MAX197_RNG;
+}
+
+static inline bool max197_is_bipolar(struct max197_chip *chip, int channel)
+{
+	return chip->ctrl_bytes[channel] & MAX197_BIP;
+}
+
+static inline bool max197_is_full_range(struct max197_chip *chip, int channel)
+{
+	return chip->ctrl_bytes[channel] & MAX197_RNG;
+}
+
+/**
+ * max197_show_range() - Display range on user output
+ *
+ * Function called on read access on in{0,1,2,3,4,5,6,7}_{min,max}
+ */
+static ssize_t max197_show_range(struct device *dev,
+				 struct device_attribute *devattr, char *buf)
+{
+	struct max197_chip *chip = dev_get_drvdata(dev);
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+	int channel = attr->index;
+	bool is_min = attr->nr;
+	int range;
+
+	if (mutex_lock_interruptible(&chip->lock))
+		return -ERESTARTSYS;
+
+	range = max197_is_full_range(chip, channel) ?
+		chip->limit : chip->limit / 2;
+	if (is_min) {
+		if (max197_is_bipolar(chip, channel))
+			range = -range;
+		else
+			range = 0;
+	}
+
+	mutex_unlock(&chip->lock);
+
+	return sprintf(buf, "%d\n", range);
+}
+
+/**
+ * max197_store_range() - Write range from user input
+ *
+ * Function called on write access on in{0,1,2,3,4,5,6,7}_{min,max}
+ */
+static ssize_t max197_store_range(struct device *dev,
+				  struct device_attribute *devattr,
+				  const char *buf, size_t count)
+{
+	struct max197_chip *chip = dev_get_drvdata(dev);
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+	int channel = attr->index;
+	bool is_min = attr->nr;
+	long value;
+	int half = chip->limit / 2;
+	int full = chip->limit;
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
+	if (mutex_lock_interruptible(&chip->lock))
+		return -ERESTARTSYS;
+
+	if (value == 0) {
+		/* We can deduce only the polarity */
+		max197_set_unipolarity(chip, channel);
+	} else if (value == -half) {
+		max197_set_bipolarity(chip, channel);
+		max197_set_half_range(chip, channel);
+	} else if (value == -full) {
+		max197_set_bipolarity(chip, channel);
+		max197_set_full_range(chip, channel);
+	} else if (value == half) {
+		/* We can deduce only the range */
+		max197_set_half_range(chip, channel);
+	} else if (value == full) {
+		/* We can deduce only the range */
+		max197_set_full_range(chip, channel);
+	}
+
+	mutex_unlock(&chip->lock);
+
+	return count;
+}
+
+/**
+ * max197_show_input() - Show channel input
+ *
+ * Function called on read access on in{0,1,2,3,4,5,6,7}_input
+ */
+static ssize_t max197_show_input(struct device *dev,
+				 struct device_attribute *devattr,
+				 char *buf)
+{
+	struct max197_chip *chip = dev_get_drvdata(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	int channel = attr->index;
+	u16 raw;
+	s32 scaled;
+	int ret;
+
+	if (mutex_lock_interruptible(&chip->lock))
+		return -ERESTARTSYS;
+
+	ret = chip->pdata->convert(chip->ctrl_bytes[channel], &raw);
+	if (ret) {
+		dev_err(dev, "conversion failed\n");
+		goto unlock;
+	}
+
+	/*
+	 * Coefficient to apply on raw value.
+	 * See Table 1. Full Scale and Zero Scale in the MAX197 datasheet.
+	 */
+	scaled = raw;
+	if (chip->scale) {
+		scaled *= MAX197_SCALE;
+		if (max197_is_full_range(chip, channel))
+			scaled *= 2;
+		scaled /= 10000;
+	}
+
+	ret = sprintf(buf, "%d\n", scaled);
+
+unlock:
+	mutex_unlock(&chip->lock);
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
+	}
+};
+
+static int __devinit max197_probe(struct platform_device *pdev)
+{
+	struct max197_chip *chip = kzalloc(sizeof *chip, GFP_KERNEL);
+	int ch, ret;
+
+	if (chip == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	platform_set_drvdata(pdev, chip);
+
+	mutex_init(&chip->lock);
+
+	if (pdev->dev.platform_data == NULL) {
+		dev_err(&pdev->dev, "no platform data supplied\n");
+		ret = -EINVAL;
+		goto error_free_chip;
+	}
+	chip->pdata = pdev->dev.platform_data;
+
+	if (chip->pdata->convert == NULL) {
+		dev_err(&pdev->dev, "no convert function supplied\n");
+		ret = -EINVAL;
+		goto error_free_chip;
+	}
+
+	if (strcmp("max197", pdev->name) == 0) {
+		chip->limit = MAX197_LIMIT;
+		chip->scale = true;
+	} else {
+		chip->limit = MAX199_LIMIT;
+		chip->scale = false;
+	}
+
+	for (ch = 0; ch < MAX197_NUM_CH; ch++)
+		chip->ctrl_bytes[ch] = (u8) ch;
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &max197_sysfs_group);
+	if (ret) {
+		dev_err(&pdev->dev, "sysfs create group failed\n");
+		goto error_free_chip;
+	}
+
+	chip->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(chip->hwmon_dev)) {
+		dev_err(&pdev->dev, "hwmon device register failed\n");
+		ret = PTR_ERR(chip->hwmon_dev);
+		goto error_release_sysfs_group;
+	}
+
+	return 0;
+
+error_release_sysfs_group:
+	sysfs_remove_group(&pdev->dev.kobj, &max197_sysfs_group);
+error_free_chip:
+	kfree(chip);
+error_ret:
+	return ret;
+}
+
+static int __devexit max197_remove(struct platform_device *pdev)
+{
+	struct max197_chip *chip = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(chip->hwmon_dev);
+	sysfs_remove_group(&pdev->dev.kobj, &max197_sysfs_group);
+	kfree(chip);
+
+	return 0;
+}
+
+static struct platform_driver __refdata maxim_drivers[] = {
+	{
+		.driver = {
+			.name = "max197",
+			.owner = THIS_MODULE,
+		},
+		.probe = max197_probe,
+		.remove = __devexit_p(max197_remove),
+	}, {
+		.driver = {
+			.name = "max199",
+			.owner = THIS_MODULE,
+		},
+		.probe = max197_probe,
+		.remove = __devexit_p(max197_remove),
+	}
+};
+
+static int __init max197_init(void)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(maxim_drivers); i++) {
+		ret = platform_driver_register(&maxim_drivers[i]);
+		if (ret)
+			goto error_unregister;
+	}
+
+	return 0;
+
+error_unregister:
+	while (--i >= 0)
+		platform_driver_unregister(&maxim_drivers[i]);
+
+	return ret;
+}
+module_init(max197_init);
+
+static void __exit max197_exit(void)
+{
+	int i;
+	for (i = ARRAY_SIZE(maxim_drivers) - 1; i >= 0; i--)
+		platform_driver_unregister(&maxim_drivers[i]);
+}
+module_exit(max197_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>");
+MODULE_DESCRIPTION("Maxim MAX197 ADC driver");
diff --git a/include/linux/max197.h b/include/linux/max197.h
new file mode 100644
index 0000000..0ed5399
--- /dev/null
+++ b/include/linux/max197.h
@@ -0,0 +1,20 @@
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
+ * @convert:	start a conversion, and read the raw data from the chip.
+ */
+struct max197_platform_data {
+	int (*convert)(u8 ctrl, u16 *raw);
+};
-- 
1.7.9.2

