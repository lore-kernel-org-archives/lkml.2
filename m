Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab1DFMnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:43:12 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:44278
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496Ab1DFMnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:43:11 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cK936eKc8kzz1202hzz8275bh84d07hz32i2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:kcinpunhjhc02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Date: Wed, 6 Apr 2011 18:12:39 +0530
Subject: [PATCHv1 6/11] HWMON: HWMON module of DA9052 PMIC driver
Thread-Topic: [PATCHv1 6/11] HWMON: HWMON module of DA9052 PMIC driver
Thread-Index: Acv0WB1hNPx41kJfRb+FkRbLZS36Hw==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B451EE9@KCINPUNHJCMS01.kpit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p36ChODo000763

Hi Randy,

HWMON Driver for Dialog Semiconductor DA9052 PMICs.

Changes made since last submission:
. read and write operation moved to MFD.
. Used kernel error codes.

Some additional information of this patch:
. This patch is thoroughly tested with the Samsung 6410 board using sysfs. 

Linux Kernel Version: 2.6.37

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -Naur orig_linux-2.6.37/drivers/hwmon/da9052-hwmon.c linux-2.6.37/drivers/hwmon/da9052-hwmon.c
--- orig_linux-2.6.37/drivers/hwmon/da9052-hwmon.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/drivers/hwmon/da9052-hwmon.c	2011-03-31 19:42:00.000000000 +0500
@@ -0,0 +1,316 @@
+/*
+ * da9052-hwmon.c  --  HWMON Driver for Dialog DA9052
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dajun Chen <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/hwmon.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/platform_device.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/hwmon.h>
+
+struct da9052_hwmon {
+	struct da9052	*da9052;
+	struct device	*class_device;
+};
+
+static const char *input_names[] = {
+	[DA9052_ADC_VDDOUT]	=	"VDDOUT",
+	[DA9052_ADC_ICH]		=	"CHARGING CURRENT",
+	[DA9052_ADC_TBAT]		=	"BATTERY TEMP",
+	[DA9052_ADC_VBAT]		=	"BATTERY VOLTAGE",
+	[DA9052_ADC_IN4]		=	"ADC IN4",
+	[DA9052_ADC_IN5]		=	"ADC IN5",
+	[DA9052_ADC_IN6]		=	"ADC IN6",
+	[DA9052_ADC_TJUNC]	=	"BATTERY JUNCTION TEMP",
+	[DA9052_ADC_VBBAT]	=	"BACK-UP BATTERY TEMP",
+};
+
+static int da9052_enable_vddout_channel(struct da9052 *da9052)
+{
+	int ret;
+
+	ret = da9052_reg_read(da9052, DA9052_ADC_CONT_REG);
+	if (ret < 0)
+		return ret;
+
+	ret |= DA9052_ADCCONT_AUTOVDDEN;
+	return da9052_reg_write(da9052, DA9052_ADC_CONT_REG, ret);
+}
+
+static int da9052_disable_vddout_channel(struct da9052 *da9052)
+{
+	int ret;
+
+	ret = da9052_reg_read(da9052, DA9052_ADC_CONT_REG);
+	if (ret < 0)
+		return ret;
+
+	ret |= ~DA9052_ADCCONT_AUTOVDDEN;
+	return da9052_reg_write(da9052, DA9052_ADC_CONT_REG, ret);
+
+}
+
+static ssize_t da9052_read_vddout(struct device *dev,
+	struct device_attribute *devattr, char *buf)
+{
+	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
+	int ret = -EIO;
+
+	ret = da9052_enable_vddout_channel(hwmon->da9052);
+	if (ret < 0)
+		return ret;
+
+	ret = da9052_reg_read(hwmon->da9052, DA9052_VDD_RES_REG);
+	if (ret < 0)
+		return ret;
+	*buf = ret;
+
+	ret = da9052_disable_vddout_channel(hwmon->da9052);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%u\n", *buf);
+
+}
+
+static ssize_t da9052_read_ich(struct device *dev,
+	struct device_attribute *devattr, char *buf)
+{
+	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
+	int ret;
+
+	ret = da9052_reg_read(hwmon->da9052, DA9052_ICHG_AV_REG);
+	if (ret < 0)
+		return ret;
+	*buf = ret;
+	return sprintf(buf, "%u\n", *buf);
+}
+
+static ssize_t da9052_read_tbat(struct device *dev,
+	struct device_attribute *devattr, char *buf)
+{
+	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
+	int ret;
+
+	ret = da9052_reg_read(hwmon->da9052, DA9052_TBAT_RES_REG);
+	if (ret < 0)
+		return ret;
+	*buf = ret;
+	return sprintf(buf, "%u\n", *buf);
+
+}
+
+static ssize_t da9052_read_vbat(struct device *dev,
+	struct device_attribute *devattr, char *buf)
+{
+	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
+	int ret;
+
+	ret = da9052_adc_manual_read(hwmon->da9052, DA9052_ADC_VBAT);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%u\n", ret);
+}
+
+static ssize_t da9052_read_misc_channel(struct device *dev,
+	struct device_attribute *devattr, char *buf)
+{
+	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
+	int channel = to_sensor_dev_attr(devattr)->index;
+	int ret;
+
+	ret = da9052_adc_manual_read(hwmon->da9052, channel);
+		if (ret < 0)
+			return -EIO;
+
+	return sprintf(buf, "%u\n", ret);
+}
+
+static ssize_t da9052_read_tjunc(struct device *dev,
+	struct device_attribute *devattr, char *buf)
+{
+	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
+	unsigned char temp;
+	int ret;
+
+	ret = da9052_reg_read(hwmon->da9052, DA9052_TJUNC_RES_REG);
+	if (ret < 0)
+		return ret;
+	*buf = ret;
+
+	temp = *buf;
+
+	*buf = 0;
+	ret = da9052_reg_read(hwmon->da9052, DA9052_T_OFFSET_REG);
+	if (ret < 0)
+		return ret;
+	*buf = ret;
+
+	temp -= *buf;
+	*buf = temp;
+
+	return sprintf(buf, "%u\n", *buf);
+
+}
+
+static ssize_t da9052_read_vbbat(struct device *dev,
+	struct device_attribute *devattr, char *buf)
+{
+	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
+	int ret;
+
+	ret = da9052_adc_manual_read(hwmon->da9052, DA9052_ADC_VBBAT);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%u\n", ret);
+
+}
+
+static ssize_t da9052_hwmon_show_name(struct device *dev,
+		struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "da9052-hwmon\n");
+}
+
+static ssize_t show_label(struct device *dev,
+			  struct device_attribute *devattr, char *buf)
+{
+	int channel = to_sensor_dev_attr(devattr)->index;
+
+	return sprintf(buf, "%s\n", input_names[channel]);
+}
+
+#define DA9052_ADC_CHANNELS(id, func_name, name)\
+	static SENSOR_DEVICE_ATTR(in##id##_label, S_IRUGO, show_label,\
+				  NULL, name);\
+	static SENSOR_DEVICE_ATTR(in##id##_input, S_IRUGO, func_name,\
+				  NULL, name)\
+
+DA9052_ADC_CHANNELS(0, da9052_read_vddout, DA9052_ADC_VDDOUT);
+DA9052_ADC_CHANNELS(1, da9052_read_ich, DA9052_ADC_ICH);
+DA9052_ADC_CHANNELS(2, da9052_read_tbat, DA9052_ADC_TBAT);
+DA9052_ADC_CHANNELS(3, da9052_read_vbat, DA9052_ADC_VBAT);
+DA9052_ADC_CHANNELS(4, da9052_read_misc_channel, DA9052_ADC_IN4);
+DA9052_ADC_CHANNELS(5, da9052_read_misc_channel, DA9052_ADC_IN5);
+DA9052_ADC_CHANNELS(6, da9052_read_misc_channel, DA9052_ADC_IN6);
+DA9052_ADC_CHANNELS(8, da9052_read_tjunc, DA9052_ADC_TJUNC);
+DA9052_ADC_CHANNELS(9, da9052_read_vbbat, DA9052_ADC_VBBAT);
+
+static DEVICE_ATTR(name, S_IRUGO, da9052_hwmon_show_name, NULL);
+
+static struct attribute *da9052_attr[] = {
+	&dev_attr_name.attr,
+
+	&sensor_dev_attr_in0_input.dev_attr.attr,
+	&sensor_dev_attr_in0_label.dev_attr.attr,
+	&sensor_dev_attr_in1_input.dev_attr.attr,
+	&sensor_dev_attr_in1_label.dev_attr.attr,
+	&sensor_dev_attr_in2_input.dev_attr.attr,
+	&sensor_dev_attr_in2_label.dev_attr.attr,
+	&sensor_dev_attr_in3_input.dev_attr.attr,
+	&sensor_dev_attr_in3_label.dev_attr.attr,
+	&sensor_dev_attr_in4_input.dev_attr.attr,
+	&sensor_dev_attr_in4_label.dev_attr.attr,
+	&sensor_dev_attr_in5_input.dev_attr.attr,
+	&sensor_dev_attr_in5_label.dev_attr.attr,
+	&sensor_dev_attr_in6_input.dev_attr.attr,
+	&sensor_dev_attr_in6_label.dev_attr.attr,
+	&sensor_dev_attr_in8_input.dev_attr.attr,
+	&sensor_dev_attr_in8_label.dev_attr.attr,
+	&sensor_dev_attr_in9_input.dev_attr.attr,
+	&sensor_dev_attr_in9_label.dev_attr.attr,
+
+	NULL
+};
+
+static const struct attribute_group da9052_attr_group = {.attrs = da9052_attr};
+
+static int __init da9052_hwmon_probe(struct platform_device *pdev)
+{
+	struct da9052_hwmon *hwmon;
+	int ret;
+
+	hwmon = kzalloc(sizeof(struct da9052_hwmon), GFP_KERNEL);
+	if (!hwmon)
+		return -ENOMEM;
+
+	hwmon->da9052 = dev_get_drvdata(pdev->dev.parent);
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &da9052_attr_group);
+	if (ret)
+		goto err_mem;
+
+	hwmon->class_device = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(hwmon->class_device)) {
+		ret = PTR_ERR(hwmon->class_device);
+		goto err_sysfs;
+	}
+
+	platform_set_drvdata(pdev, hwmon);
+
+	return 0;
+
+err_sysfs:
+	sysfs_remove_group(&pdev->dev.kobj, &da9052_attr_group);
+err_mem:
+	kfree(hwmon);
+	return ret;
+}
+
+static int __devexit da9052_hwmon_remove(struct platform_device *pdev)
+{
+	struct da9052_hwmon *hwmon = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(hwmon->class_device);
+	sysfs_remove_group(&pdev->dev.kobj, &da9052_attr_group);
+	kfree(hwmon);
+
+	return 0;
+}
+
+static struct platform_driver da9052_hwmon_driver = {
+	.driver.name	= "da9052-hwmon",
+	.driver.owner	= THIS_MODULE,
+	.probe			= da9052_hwmon_probe,
+	.remove			= __devexit_p(da9052_hwmon_remove),
+
+};
+
+static int __init da9052_hwmon_init(void)
+{
+
+	return platform_driver_register(&da9052_hwmon_driver);
+}
+module_init(da9052_hwmon_init);
+
+static void __exit da9052_hwmon_exit(void)
+{
+	platform_driver_unregister(&da9052_hwmon_driver);
+}
+module_exit(da9052_hwmon_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>")
+MODULE_DESCRIPTION("DA9052 ADC driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9052-hwmon");
+
diff -Naur orig_linux-2.6.37/drivers/hwmon/Kconfig linux-2.6.37/drivers/hwmon/Kconfig
--- orig_linux-2.6.37/drivers/hwmon/Kconfig	2011-01-05 05:50:19.000000000 +0500
+++ linux-2.6.37/drivers/hwmon/Kconfig	2011-03-31 19:41:38.000000000 +0500
@@ -1171,6 +1171,13 @@
         help
           Support for the A/D converter on MC13783 PMIC.

+config SENSORS_DA9052_ADC
+        tristate "Dialog DA9052 HWMON"
+        depends on PMIC_DA9052
+        help
+          Say y here to support the ADC found on
+          Dialog Semiconductor DA9052 PMIC.
+
 if ACPI

 comment "ACPI drivers"
diff -Naur orig_linux-2.6.37/drivers/hwmon/Makefile linux-2.6.37/drivers/hwmon/Makefile
--- orig_linux-2.6.37/drivers/hwmon/Makefile	2011-01-05 05:50:19.000000000 +0500
+++ linux-2.6.37/drivers/hwmon/Makefile	2011-03-31 19:41:45.000000000 +0500
@@ -41,6 +41,7 @@
 obj-$(CONFIG_SENSORS_CORETEMP)	+= coretemp.o
 obj-$(CONFIG_SENSORS_PKGTEMP)	+= pkgtemp.o
 obj-$(CONFIG_SENSORS_DME1737)	+= dme1737.o
+obj-$(CONFIG_SENSORS_DA9052_ADC)	+= da9052-hwmon.o
 obj-$(CONFIG_SENSORS_DS1621)		+= ds1621.o
 obj-$(CONFIG_SENSORS_EMC1403)	+= emc1403.o
 obj-$(CONFIG_SENSORS_EMC2103)	+= emc2103.o
diff -Naur orig_linux-2.6.37/include/linux/mfd/da9052/hwmon.h linux-2.6.37/include/linux/mfd/da9052/hwmon.h
--- orig_linux-2.6.37/include/linux/mfd/da9052/hwmon.h	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/include/linux/mfd/da9052/hwmon.h	2011-03-31 19:44:33.000000000 +0500
@@ -0,0 +1,38 @@
+/*
+ * da9052 ADC module declarations.
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
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
+ */
+
+#ifndef __LINUX_MFD_DA9052_HWMON_H
+#define __LINUX_MFD_DA9052_HWMON_H
+
+
+/* Channel Definations */
+#define DA9052_ADC_VDDOUT				0
+#define DA9052_ADC_ICH					1
+#define DA9052_ADC_TBAT				2
+#define DA9052_ADC_VBAT				3
+#define DA9052_ADC_IN4					4
+#define DA9052_ADC_IN5					5
+#define DA9052_ADC_IN6					6
+#define DA9052_ADC_TSI					7
+#define DA9052_ADC_TJUNC				8
+#define DA9052_ADC_VBBAT				9
+
+#endif

Regards,
Ashish


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
