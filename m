Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1HXUX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:23:58 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:45148 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab1HXUXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:23:53 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Subject: [PATCH 4/4] x86: (TS-5500) add ADC support
Date: Wed, 24 Aug 2011 16:23:27 -0400
Message-Id: <1314217407-31249-5-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314217407-31249-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1314217407-31249-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>


Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 MAINTAINERS                           |    2 +
 arch/x86/platform/ts5500/Kconfig      |    6 +
 arch/x86/platform/ts5500/Makefile     |    3 +-
 arch/x86/platform/ts5500/ts5500.c     |   77 ++++++++
 arch/x86/platform/ts5500/ts5500_adc.c |  326 +++++++++++++++++++++++++++++++++
 arch/x86/platform/ts5500/ts5500_adc.h |   62 +++++++
 6 files changed, 475 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/platform/ts5500/ts5500_adc.c
 create mode 100644 arch/x86/platform/ts5500/ts5500_adc.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 034a25f..967f5cc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6143,6 +6143,8 @@ F:  arch/x86/platform/ts5500/ts5500.c
 F:  arch/x86/platform/ts5500/ts5500_gpio.c
 F:  arch/x86/platform/ts5500/ts5500_gpio.h
 F:  arch/x86/platform/ts5500/ts5500_leds.c
+F:  arch/x86/platform/ts5500/ts5500_adc.c
+F:  arch/x86/platform/ts5500/ts5500_adc.h
 
 TEGRA SUPPORT
 M:	Colin Cross <ccross@android.com>
diff --git a/arch/x86/platform/ts5500/Kconfig b/arch/x86/platform/ts5500/Kconfig
index e7fbf34..f38c8b6 100644
--- a/arch/x86/platform/ts5500/Kconfig
+++ b/arch/x86/platform/ts5500/Kconfig
@@ -19,3 +19,9 @@ config TS5500_LEDS
 	default y
 	help
 	  This option enables support for the on-chip LED.
+
+config TS5500_ADC
+	bool "TS-5500 ADC"
+	depends on TS5500
+	help
+      Support for the A/D converter on Technologic Systems TS-5500 SBCs.
diff --git a/arch/x86/platform/ts5500/Makefile b/arch/x86/platform/ts5500/Makefile
index 4d23812..79b8d10 100644
--- a/arch/x86/platform/ts5500/Makefile
+++ b/arch/x86/platform/ts5500/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_TS5500)			+= ts5500.o
 obj-$(CONFIG_TS5500_GPIO)		+= ts5500_gpio.o
-obj-$(CONFIG_TS5500_LEDS)		+= ts5500_leds.o
\ No newline at end of file
+obj-$(CONFIG_TS5500_LEDS)		+= ts5500_leds.o
+obj-$(CONFIG_TS5500_ADC)		+= ts5500_adc.o
diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
index a455178..d0c496a 100644
--- a/arch/x86/platform/ts5500/ts5500.c
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -27,6 +27,7 @@
 #include <linux/leds.h>
 #include <linux/gpio.h>
 #include "ts5500_gpio.h"
+#include "ts5500_adc.h"
 
 /* Hardware info for pre-detection */
 #define AMD_ELAN_FAMILY			4
@@ -197,6 +198,71 @@ static struct platform_device ts5500_gpio_device = {
 	}
 };
 #endif
+
+#ifdef CONFIG_TS5500_ADC
+static void ts5500_adc_release(struct device *dev)
+{
+	/* noop */
+}
+
+static struct resource ts5500_adc_resources[] = {
+	{
+		.name  = "ts5500_adc" "-data",
+		.start = TS5500_ADC_INIT_LSB_REG,
+		.end   = TS5500_ADC_MSB_REG,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "ts5500_adc" "-ctrl",
+		.start = TS5500_ADC_CTRL_REG,
+		.end   = TS5500_ADC_CTRL_REG,
+		.flags = IORESOURCE_IO,
+	}
+};
+
+static struct ts5500_adc_platform_data ts5500_adc_platform_data = {
+	.name = TS5500_ADC_NAME,
+	.ioaddr = {
+		.data = TS5500_ADC_INIT_LSB_REG,
+		.ctrl = TS5500_ADC_CTRL_REG,
+	},
+	.read = {
+		.delay     = TS5500_ADC_READ_DELAY,
+		.busy_mask = TS5500_ADC_READ_BUSY_MASK,
+	},
+	.ctrl = {
+		{ TS5500_ADC_UNIPOLAR | TS5500_ADC_RANGE_5V,
+		  TS5500_ADC_UNIPOLAR | TS5500_ADC_RANGE_10V },
+		{ TS5500_ADC_BIPOLAR  | TS5500_ADC_RANGE_5V,
+		  TS5500_ADC_BIPOLAR  | TS5500_ADC_RANGE_10V },
+	},
+	.ranges = {
+		.min = {
+			{  0,     0 },
+			{ -5000, -10000 },
+		},
+		.max = {
+			{  5000,  10000 },
+			{  5000,  10000 },
+		},
+	},
+	.scale = {
+		{ 12207, 24414 },
+		{ 24414, 48828 },
+	},
+};
+
+static struct platform_device ts5500_adc_device = {
+	.name = "ts5500_adc",
+	.id = -1,
+	.resource = ts5500_adc_resources,
+	.num_resources = ARRAY_SIZE(ts5500_adc_resources),
+	.dev = {
+		.platform_data = &ts5500_adc_platform_data,
+		.release = ts5500_adc_release,
+	},
+};
+#endif
 static struct platform_device *ts5500_devices[] __initdata = {
 #ifdef CONFIG_TS5500_LEDS
 	&ts5500_led_device,
@@ -335,6 +401,17 @@ static int __init ts5500_init(void)
 	if (ret)
 		goto release_pdev;
 
+#ifdef CONFIG_TS5500_ADC
+	if (ts5500->adc) {
+		ret = platform_device_register(&ts5500_adc_device);
+		if (ret)
+			goto release_pdev;
+	} else {
+		pr_warn("ADC config enabled, "
+			"but the platform has no A/D converter!");
+	}
+#endif
+
 	ret = sysfs_create_group(&pdev->dev.kobj,
 				 &ts5500_attr_group);
 	if (ret)
diff --git a/arch/x86/platform/ts5500/ts5500_adc.c b/arch/x86/platform/ts5500/ts5500_adc.c
new file mode 100644
index 0000000..6a85edf
--- /dev/null
+++ b/arch/x86/platform/ts5500/ts5500_adc.c
@@ -0,0 +1,326 @@
+/*
+ * Technologic Systems TS-5500 boards - Mapped MAX197 ADC driver
+ *
+ * Copyright (c) 2010 Savoir-faire Linux Inc.
+ *          Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
+ *
+ * Portions Copyright (C) 2008 Marc Pignat <marc.pignat@hevs.ch>
+ *
+ * The driver uses direct access for communication with the ADC.
+ * Should work unchanged with the MAX199 chip.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * The TS-5500 uses a CPLD to abstract the interface to a MAX197.
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
+#include "ts5500_adc.h"
+
+#define ts5500_adc_test_bit(bit, map)	(test_bit(bit, map) != 0)
+
+/**
+ * struct ts5500_adc_chip
+ * @hwmon_dev:		The hwmon device.
+ * @lock:		Read/Write mutex.
+ * @spec:		The mapped MAX197 platform data.
+ * @polarity:		bitmap for polarity.
+ * @range:		bitmap for range.
+ */
+struct ts5500_adc_chip {
+	struct device *hwmon_dev;
+	struct mutex lock;
+	struct ts5500_adc_platform_data spec;
+	DECLARE_BITMAP(polarity, TS5500_ADC_CHANNELS_MAX);
+	DECLARE_BITMAP(range, TS5500_ADC_CHANNELS_MAX);
+};
+
+static s32 ts5500_adc_scale(struct ts5500_adc_chip *chip, s16 raw,
+			    int polarity, int range)
+{
+	s32 scaled = raw;
+
+	scaled *= chip->spec.scale[polarity][range];
+	scaled /= 10000;
+
+	return scaled;
+}
+
+static int ts5500_adc_range(struct ts5500_adc_chip *chip, int is_min,
+			       int polarity, int range)
+{
+	if (is_min)
+		return chip->spec.ranges.min[polarity][range];
+	return chip->spec.ranges.max[polarity][range];
+}
+
+static int ts5500_adc_strtol(const char *buf, long *value, int range1,
+				int range2)
+{
+	if (strict_strtol(buf, 10, value))
+		return -EINVAL;
+
+	if (range1 < range2)
+		*value = SENSORS_LIMIT(*value, range1, range2);
+	else
+		*value = SENSORS_LIMIT(*value, range2, range1);
+
+	return 0;
+}
+
+static struct ts5500_adc_chip *ts5500_adc_get_drvdata(struct device *dev)
+{
+	return platform_get_drvdata(to_platform_device(dev));
+}
+
+/**
+ * ts5500_adc_show_range() - Display range on user output
+ *
+ * Function called on read access on
+ * /sys/devices/platform/ts5500-adc/in{0,1,2,3,4,5,6,7}_{min,max}
+ */
+static ssize_t ts5500_adc_show_range(struct device *dev,
+				 struct device_attribute *devattr, char *buf)
+{
+	struct ts5500_adc_chip *chip = ts5500_adc_get_drvdata(dev);
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+	int is_min = attr->nr != 0;
+	int polarity, range;
+
+	if (mutex_lock_interruptible(&chip->lock))
+		return -ERESTARTSYS;
+
+	polarity = ts5500_adc_test_bit(attr->index, chip->polarity);
+	range = ts5500_adc_test_bit(attr->index, chip->range);
+
+	mutex_unlock(&chip->lock);
+
+	return sprintf(buf, "%d\n",
+		       ts5500_adc_range(chip, is_min, polarity, range));
+}
+
+/**
+ * ts5500_adc_store_range() - Write range from user input
+ *
+ * Function called on write access on
+ * /sys/devices/platform/ts5500-adc/in{0,1,2,3,4,5,6,7}_{min,max}
+ */
+static ssize_t ts5500_adc_store_range(struct device *dev,
+				  struct device_attribute *devattr,
+				  const char *buf, size_t count)
+{
+	struct ts5500_adc_chip *chip = ts5500_adc_get_drvdata(dev);
+	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
+	int is_min = attr->nr != 0;
+	int range1 = ts5500_adc_range(chip, is_min, 0, 0);
+	int range2 = ts5500_adc_range(chip, is_min, 1, 1);
+	long value;
+
+	if (ts5500_adc_strtol(buf, &value, range1, range2))
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&chip->lock))
+		return -ERESTARTSYS;
+
+	if (abs(value) > 5000)
+		set_bit(attr->index, chip->range);
+	else
+		clear_bit(attr->index, chip->range);
+
+	if (is_min) {
+		if (value < 0)
+			set_bit(attr->index, chip->polarity);
+		else
+			clear_bit(attr->index, chip->polarity);
+	}
+
+	mutex_unlock(&chip->lock);
+
+	return count;
+}
+
+/**
+ * ts5500_adc_show_input() - Show channel input
+ *
+ * Function called on read access on
+ * /sys/devices/platform/ts5500-adc/in{0,1,2,3,4,5,6,7}_input
+ */
+static ssize_t ts5500_adc_show_input(struct device *dev,
+				     struct device_attribute *devattr,
+				     char *buf)
+{
+	struct ts5500_adc_chip *chip = ts5500_adc_get_drvdata(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	int polarity, range;
+	int ret;
+	u8 command;
+
+	if (mutex_lock_interruptible(&chip->lock))
+		return -ERESTARTSYS;
+
+	polarity = ts5500_adc_test_bit(attr->index, chip->polarity);
+	range = ts5500_adc_test_bit(attr->index, chip->range);
+
+	command = attr->index | chip->spec.ctrl[polarity][range];
+
+	outb(command, chip->spec.ioaddr.data);
+
+	udelay(chip->spec.read.delay);
+	ret = inb(chip->spec.ioaddr.ctrl);
+
+	if (ret & chip->spec.read.busy_mask) {
+		dev_err(dev, "device not ready (ret=0x0%x, try=%d)\n", ret,
+			range);
+		ret = -EIO;
+	} else {
+		/* LSB of conversion is at 0x196 and MSB is at 0x197 */
+		u8 lsb = inb(chip->spec.ioaddr.data);
+		u8 msb = inb(chip->spec.ioaddr.data + 1);
+		s16 raw = (msb << 8) | lsb;
+		s32 scaled = ts5500_adc_scale(chip, raw, polarity, range);
+
+		ret = sprintf(buf, "%d\n", scaled);
+	}
+
+	mutex_unlock(&chip->lock);
+	return ret;
+}
+
+static ssize_t ts5500_adc_show_name(struct device *dev,
+	struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "%s\n", ts5500_adc_get_drvdata(dev)->spec.name);
+}
+
+#define TS5500_ADC_HWMON_CHANNEL(chan)				\
+	SENSOR_DEVICE_ATTR(in##chan##_input, S_IRUGO,		\
+			   ts5500_adc_show_input, NULL, chan);	\
+	SENSOR_DEVICE_ATTR_2(in##chan##_max, S_IRUGO | S_IWUSR,	\
+			     ts5500_adc_show_range,		\
+			     ts5500_adc_store_range, 0, chan);	\
+	SENSOR_DEVICE_ATTR_2(in##chan##_min, S_IRUGO | S_IWUSR,	\
+			     ts5500_adc_show_range,		\
+			     ts5500_adc_store_range, 1, chan)	\
+
+#define TS5500_ADC_SYSFS_CHANNEL(chan)				\
+	&sensor_dev_attr_in##chan##_input.dev_attr.attr,	\
+	&sensor_dev_attr_in##chan##_max.dev_attr.attr,		\
+	&sensor_dev_attr_in##chan##_min.dev_attr.attr
+
+static DEVICE_ATTR(name, S_IRUGO, ts5500_adc_show_name, NULL);
+
+static TS5500_ADC_HWMON_CHANNEL(0);
+static TS5500_ADC_HWMON_CHANNEL(1);
+static TS5500_ADC_HWMON_CHANNEL(2);
+static TS5500_ADC_HWMON_CHANNEL(3);
+static TS5500_ADC_HWMON_CHANNEL(4);
+static TS5500_ADC_HWMON_CHANNEL(5);
+static TS5500_ADC_HWMON_CHANNEL(6);
+static TS5500_ADC_HWMON_CHANNEL(7);
+
+static const struct attribute_group ts5500_adc_sysfs_group = {
+	.attrs = (struct attribute *[]) {
+		&dev_attr_name.attr,
+		TS5500_ADC_SYSFS_CHANNEL(0),
+		TS5500_ADC_SYSFS_CHANNEL(1),
+		TS5500_ADC_SYSFS_CHANNEL(2),
+		TS5500_ADC_SYSFS_CHANNEL(3),
+		TS5500_ADC_SYSFS_CHANNEL(4),
+		TS5500_ADC_SYSFS_CHANNEL(5),
+		TS5500_ADC_SYSFS_CHANNEL(6),
+		TS5500_ADC_SYSFS_CHANNEL(7),
+		NULL
+	}
+};
+
+static int __devinit ts5500_adc_probe(struct platform_device *pdev)
+{
+	struct ts5500_adc_platform_data *pdata = pdev->dev.platform_data;
+	struct ts5500_adc_chip *chip;
+	int ret;
+
+	if (pdata == NULL)
+		return -ENODEV;
+
+	chip = kzalloc(sizeof *chip, GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->spec = *pdata;
+
+	mutex_init(&chip->lock);
+	mutex_lock(&chip->lock);
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &ts5500_adc_sysfs_group);
+	if (ret) {
+		dev_err(&pdev->dev, "sysfs_create_group failed.\n");
+		goto error_unlock_and_free;
+	}
+
+	chip->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(chip->hwmon_dev)) {
+		dev_err(&pdev->dev, "hwmon_device_register failed.\n");
+		ret = PTR_ERR(chip->hwmon_dev);
+		goto error_unregister_device;
+	}
+
+	platform_set_drvdata(pdev, chip);
+	mutex_unlock(&chip->lock);
+	return 0;
+
+error_unregister_device:
+	sysfs_remove_group(&pdev->dev.kobj, &ts5500_adc_sysfs_group);
+
+error_unlock_and_free:
+	mutex_unlock(&chip->lock);
+	kfree(chip);
+	return ret;
+}
+
+static struct platform_driver ts5500_adc_driver = {
+	.driver	= {
+		.name	= "ts5500_adc",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= ts5500_adc_probe
+};
+
+static const struct platform_device_id ts5500_devices[] = {
+	{ "ts5500_adc", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(platform, ts5500_devices);
+
+static int __init ts5500_adc_init(void)
+{
+	return platform_driver_register(&ts5500_adc_driver);
+}
+module_init(ts5500_adc_init);
+
+MODULE_DESCRIPTION("TS-5500 mapped MAX197 ADC device driver");
+MODULE_AUTHOR("Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>");
+MODULE_LICENSE("GPL");
diff --git a/arch/x86/platform/ts5500/ts5500_adc.h b/arch/x86/platform/ts5500/ts5500_adc.h
new file mode 100644
index 0000000..76d389f
--- /dev/null
+++ b/arch/x86/platform/ts5500/ts5500_adc.h
@@ -0,0 +1,62 @@
+#ifndef _TS5500_ADC_H
+#define _TS5500_ADC_H
+
+#define TS5500_ADC_CTRL_REG		0x195	/* Conversion state register */
+#define TS5500_ADC_INIT_LSB_REG		0x196	/* Init conv. / LSB register */
+#define TS5500_ADC_MSB_REG		0x197	/* MSB register */
+/*
+ * Control bits of A/D command
+ * bits 0-2:	selected channel (0 - 7)
+ * bits 3:	uni/bipolar (0 = unipolar (ie 0 to +5V))
+ *			    (1 = bipolar (ie -5 to +5V))
+ * bit 4:	selected range (0 = 5v range, 1 = 10V range)
+ * bit 5-7:	padded zero (unused)
+ */
+
+#define TS5500_ADC_CHANNELS_MAX		8	/* 0 to 7 channels on device */
+
+#define TS5500_ADC_BIPOLAR		0x08
+#define TS5500_ADC_UNIPOLAR		0x00
+#define TS5500_ADC_RANGE_5V		0x00	/* 0 to 5V range */
+#define TS5500_ADC_RANGE_10V		0x10	/* 0 to 10V range */
+
+#define TS5500_ADC_READ_DELAY		15	/* usec */
+#define TS5500_ADC_READ_BUSY_MASK	0x01
+#define TS5500_ADC_NAME			"MAX197 (8 channels)"
+
+/**
+ * struct ts5500_adc_platform_data
+ * @name:	Name of the device.
+ * @ioaddr:	I/O address containing:
+ *		.data:		Data register for conversion reading.
+ *		.ctrl:		A/D Control Register (bit 0 = 0 when
+ *				conversion completed).
+ * @read:	Information about conversion reading, with:
+ *		.delay:		Delay before next conversion.
+ *		.busy_mask:	Control register bit 0 equals 1 means
+ *				conversion is not completed yet.
+ * @ctrl:	Data tables addressable by [polarity][range].
+ * @ranges:	Ranges.
+ *		.min:		Min value.
+ *		.max:		Max value.
+ * @scale:	Polarity/Range coefficients to scale raw conversion reading.
+ */
+struct ts5500_adc_platform_data {
+	const char *name;
+	struct {
+		int data;
+		int ctrl;
+	} ioaddr;
+	struct {
+		u8 delay;
+		u8 busy_mask;
+	} read;
+	u8 ctrl[2][2];
+	struct {
+		int min[2][2];
+		int max[2][2];
+	} ranges;
+	int scale[2][2];
+};
+
+#endif
-- 
1.7.6

