Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2HOPUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:20:08 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:6246 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2HOPS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:18:28 -0400
Message-Id: <201208151518.q7FFIMHq011609@latitude.olech.com>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Wed, 15 Aug 2012 16:05:24 +0100
Subject: [NEW DRIVER V3 7/8] DA9058 HWMON driver
To: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: lm-sensors@lm-sensors.org
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: David Dajun Chen <david.chen@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the HWMON component driver of the Dialog DA9058 PMIC.
This driver is just one component of the whole DA9058 PMIC driver.
It depends on the CORE and ADC component drivers of the DA9058 MFD.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
---
 Documentation/hwmon/da9058   |   30 +++
 drivers/hwmon/Kconfig        |   10 +
 drivers/hwmon/Makefile       |    1 +
 drivers/hwmon/da9058-hwmon.c |  425 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 466 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hwmon/da9058
 create mode 100644 drivers/hwmon/da9058-hwmon.c

diff --git a/Documentation/hwmon/da9058 b/Documentation/hwmon/da9058
new file mode 100644
index 0000000..60634c5
--- /dev/null
+++ b/Documentation/hwmon/da9058
@@ -0,0 +1,30 @@
+Kernel driver da9058-hwmon
+==========================
+
+Supported chips:
+  * Dialog Semiconductor DA9058 PMIC
+    Prefix: 'da9058'
+    Datasheet:
+	http://www.dialog-semiconductor.com/products/power-management/da9058
+
+Authors: Opensource [Anthony Olech] <anthony.olech.opensource@diasemi.com>
+
+Description
+-----------
+
+The DA9058 PMIC contains a 5 channel ADC which can be used to monitor a
+range of system operating parameters, including the battery voltage and
+temperature.  The ADC measures voltage, but two of the ADC channels can
+be configured to supply a current, so that if an NTC termister is connected
+then the voltage reading can be converted to a temperature. Currently the
+driver provides reporting of all the input values but does not provide any
+alarms.
+
+Voltage Monitoring
+------------------
+
+Voltages are sampled in either 'automatic' or 'manual' mode, which is an
+initialization parameter set in the platform data by the machine driver.
+In manual mode the ADC conversion is 12 bit and in automatic mode it is
+10 bit. However all the raw readings are reported as 12 bit numbers.
+
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 6f1d167..0986f43 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -294,6 +294,16 @@ config SENSORS_ATXP1
 	  This driver can also be built as a module.  If so, the module
 	  will be called atxp1.
 
+config SENSORS_DA9058
+	tristate "Dialog Semiconductor DA9058 ADC"
+	depends on I2C
+	help
+	  If you say yes here you get support for ADC on the Dialog
+	  Semiconductor DA9058 PMIC.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called da9058-hwmon.
+
 config SENSORS_DS620
 	tristate "Dallas Semiconductor DS620"
 	depends on I2C
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index e1eeac1..be99572 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_SENSORS_ASC7621)	+= asc7621.o
 obj-$(CONFIG_SENSORS_ATXP1)	+= atxp1.o
 obj-$(CONFIG_SENSORS_CORETEMP)	+= coretemp.o
 obj-$(CONFIG_SENSORS_DME1737)	+= dme1737.o
+obj-$(CONFIG_SENSORS_DA9058)	+= da9058-hwmon.o
 obj-$(CONFIG_SENSORS_DS620)	+= ds620.o
 obj-$(CONFIG_SENSORS_DS1621)	+= ds1621.o
 obj-$(CONFIG_SENSORS_EMC1403)	+= emc1403.o
diff --git a/drivers/hwmon/da9058-hwmon.c b/drivers/hwmon/da9058-hwmon.c
new file mode 100644
index 0000000..8953170
--- /dev/null
+++ b/drivers/hwmon/da9058-hwmon.c
@@ -0,0 +1,425 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/regmap.h>
+#include <linux/mfd/core.h>
+
+#include <linux/mfd/da9058/version.h>
+#include <linux/mfd/da9058/registers.h>
+#include <linux/mfd/da9058/core.h>
+#include <linux/mfd/da9058/hwmon.h>
+
+static ssize_t da9058_vbat_show_txt(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "vbat\n");
+}
+
+static ssize_t da9058_vbat_show_min(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "2500\n");
+}
+
+static ssize_t da9058_vbat_show_max(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "4500\n");
+}
+
+static ssize_t da9058_vbat_show_adc(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
+	int voltage; /* x000 .. xFFF = 2500 .. 4500 mV */
+	int ret;
+
+	ret = da9058_adc_read(hwmon->da9058, DA9058_ADCMAN_MUXSEL_VBAT,
+					hwmon->use_automatic_adc, &voltage);
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%d\n", 2500 + voltage * 2000 / 0xFFF);
+}
+
+static ssize_t da9058_tbat_show_txt(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "tbat\n");
+}
+
+static ssize_t da9058_tbat_show_type(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "4\n");	/* thermistor */
+}
+
+static ssize_t da9058_tbat_show_min(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "0\n");
+}
+
+static ssize_t da9058_tbat_show_max(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "2500\n");
+}
+
+static ssize_t da9058_tbat_show_adc(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
+	int voltage; /* x000 .. xFFF = 0 .. 2500 mV */
+	int ret;
+
+	ret = da9058_adc_read(hwmon->da9058, DA9058_ADCMAN_MUXSEL_TEMP,
+					hwmon->use_automatic_adc, &voltage);
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%d\n", voltage * 2500 / 0xFFF);
+}
+
+static ssize_t da9058_gp_show_txt(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "gp\n"); /* general purpose */
+}
+
+static ssize_t da9058_gp_show_min(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "0\n");
+}
+
+static ssize_t da9058_gp_show_max(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "2500\n");
+}
+
+static ssize_t da9058_gp_show_adc(struct device *dev,
+					struct device_attribute *devattr,
+					char *buf)
+{
+	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
+	int channel = to_sensor_dev_attr(devattr)->index;
+	int voltage; /* xFFF .. x800 = 0 .. 2500 mV */
+	int ret;
+
+	ret = da9058_adc_read(hwmon->da9058, channel,
+				hwmon->use_automatic_adc, &voltage);
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%d\n", (0xFFF - voltage) * 2500 / 0x7FF);
+}
+
+static ssize_t da9058_tjunc_show_txt(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "tjunc\n");
+}
+
+static ssize_t da9058_tjunc_show_min(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
+	unsigned int toffreg;
+	int ret = da9058_reg_read(hwmon->da9058, DA9058_TOFFSET_REG, &toffreg);
+
+	if (ret < 0) {
+		/*
+		 * just report worst theorectically possible case
+		 *	-325716 .. -108800 .. +109824
+		 */
+		return sprintf(buf, "-325716\n");
+	} else {
+		int toffset = (signed)((u8)toffreg);
+		return sprintf(buf, "%d\n", -(1708*toffset + 108800));
+	}
+}
+
+static ssize_t da9058_tjunc_show_max(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
+	unsigned int toffreg;
+	int ret = da9058_reg_read(hwmon->da9058, DA9058_TOFFSET_REG, &toffreg);
+
+	if (ret < 0) {
+		/*
+		 * just report worst theorectically possible case
+		 *	+109824 .. +326740 .. +545364
+		 */
+		return sprintf(buf, "545364\n");
+	} else {
+		int toffset = (signed)((u8)toffreg);
+		return sprintf(buf, "%d\n", 1708*(255 - toffset) - 108800);
+	}
+}
+
+/*
+ *  The algorithm for converting the value is
+ *  Degrees celsius = 1.708 * (TJUNC_RES - T_OFFSET) - 108.8
+ *  T_OFFSET is a trim value used to improve accuracy of the result
+ */
+static ssize_t da9058_tjunc_show_adc(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
+	int tjunc;
+	unsigned int toffreg;
+	s8 toffint;
+	int toffset;
+	int ret;
+
+	ret = da9058_reg_read(hwmon->da9058, DA9058_TOFFSET_REG, &toffreg);
+	if (ret < 0)
+		return ret;
+
+	toffint = toffreg & 0xFF;
+	toffset = toffint;
+
+	ret = da9058_adc_read(hwmon->da9058, DA9058_ADCMAN_MUXSEL_TJUNC,
+					hwmon->use_automatic_adc, &tjunc);
+	if (ret < 0)
+		return ret;
+	tjunc >>= 4;	/* to recover the most sig 8 bits */
+
+	return sprintf(buf, "%d\n", 1708 * (tjunc - toffset) - 108800);
+}
+
+static ssize_t da9058_vfpin_show_txt(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "vfpin\n");
+}
+
+static ssize_t da9058_vfpin_show_min(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "0\n");
+}
+
+static ssize_t da9058_vfpin_show_max(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "4095\n");
+}
+
+static ssize_t da9058_vfpin_show_adc(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
+	int voltage; /* x000 .. xFFF = 0 .. 4095 mV */
+	int ret;
+
+	ret = da9058_adc_read(hwmon->da9058, DA9058_ADCMAN_MUXSEL_VF,
+					hwmon->use_automatic_adc, &voltage);
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%d\n", voltage);
+}
+
+static ssize_t da9058_hwmon_show_name(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "da9058\n");
+}
+
+static DEVICE_ATTR(name, S_IRUGO, da9058_hwmon_show_name, NULL);
+
+static SENSOR_DEVICE_ATTR(in0_label, S_IRUGO, da9058_vbat_show_txt, NULL, 0);
+static SENSOR_DEVICE_ATTR(in0_min, S_IRUGO, da9058_vbat_show_min, NULL, 0);
+static SENSOR_DEVICE_ATTR(in0_max, S_IRUGO, da9058_vbat_show_max, NULL, 0);
+static SENSOR_DEVICE_ATTR(in0_value, S_IRUGO, da9058_vbat_show_adc, NULL, 0);
+
+static SENSOR_DEVICE_ATTR(temp0_label, S_IRUGO, da9058_tbat_show_txt, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp0_type, S_IRUGO, da9058_tbat_show_type, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp0_min, S_IRUGO, da9058_tbat_show_min, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp0_max, S_IRUGO, da9058_tbat_show_max, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp0_value, S_IRUGO, da9058_tbat_show_adc, NULL, 0);
+
+static SENSOR_DEVICE_ATTR(in1_label, S_IRUGO, da9058_vfpin_show_txt, NULL, 0);
+static SENSOR_DEVICE_ATTR(in1_min, S_IRUGO, da9058_vfpin_show_min, NULL, 0);
+static SENSOR_DEVICE_ATTR(in1_max, S_IRUGO, da9058_vfpin_show_max, NULL, 0);
+static SENSOR_DEVICE_ATTR(in1_value, S_IRUGO, da9058_vfpin_show_adc, NULL, 0);
+
+static SENSOR_DEVICE_ATTR(in2_label, S_IRUGO, da9058_gp_show_txt, NULL,
+				DA9058_ADCMAN_MUXSEL_ADCIN);
+static SENSOR_DEVICE_ATTR(in2_min, S_IRUGO, da9058_gp_show_min, NULL,
+				DA9058_ADCMAN_MUXSEL_ADCIN);
+static SENSOR_DEVICE_ATTR(in2_max, S_IRUGO, da9058_gp_show_max, NULL,
+				DA9058_ADCMAN_MUXSEL_ADCIN);
+static SENSOR_DEVICE_ATTR(in2_value, S_IRUGO, da9058_gp_show_adc, NULL,
+				DA9058_ADCMAN_MUXSEL_ADCIN);
+
+static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, da9058_tjunc_show_txt, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_min, S_IRUGO, da9058_tjunc_show_min, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_max, S_IRUGO, da9058_tjunc_show_max, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_value, S_IRUGO, da9058_tjunc_show_adc, NULL, 0);
+
+static struct attribute *da9058_attr[] = {
+	&dev_attr_name.attr,
+	&sensor_dev_attr_in0_label.dev_attr.attr,
+	&sensor_dev_attr_in0_min.dev_attr.attr,
+	&sensor_dev_attr_in0_max.dev_attr.attr,
+	&sensor_dev_attr_in0_value.dev_attr.attr,
+	&sensor_dev_attr_temp0_label.dev_attr.attr,
+	&sensor_dev_attr_temp0_type.dev_attr.attr,
+	&sensor_dev_attr_temp0_min.dev_attr.attr,
+	&sensor_dev_attr_temp0_max.dev_attr.attr,
+	&sensor_dev_attr_temp0_value.dev_attr.attr,
+	&sensor_dev_attr_in1_label.dev_attr.attr,
+	&sensor_dev_attr_in1_min.dev_attr.attr,
+	&sensor_dev_attr_in1_max.dev_attr.attr,
+	&sensor_dev_attr_in1_value.dev_attr.attr,
+	&sensor_dev_attr_in2_label.dev_attr.attr,
+	&sensor_dev_attr_in2_min.dev_attr.attr,
+	&sensor_dev_attr_in2_max.dev_attr.attr,
+	&sensor_dev_attr_in2_value.dev_attr.attr,
+	&sensor_dev_attr_temp1_label.dev_attr.attr,
+	&sensor_dev_attr_temp1_min.dev_attr.attr,
+	&sensor_dev_attr_temp1_max.dev_attr.attr,
+	&sensor_dev_attr_temp1_value.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group da9058_attr_group = {.attrs = da9058_attr};
+
+static int __devinit da9058_hwmon_probe(struct platform_device *pdev)
+{
+	struct da9058 *da9058 = dev_get_drvdata(pdev->dev.parent);
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct da9058_hwmon_pdata *hwmon_pdata;
+	struct da9058_hwmon *hwmon;
+	int ret;
+
+	if (cell == NULL) {
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	hwmon_pdata = cell->platform_data;
+
+	if (hwmon_pdata == NULL) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	if (hwmon_pdata->use_automatic_adc & !hwmon_pdata->temp_adc_resistance
+	) {
+		return -EINVAL; /* impossible setting */
+		goto exit;
+	}
+
+	hwmon = devm_kzalloc(&pdev->dev, sizeof(struct da9058_hwmon),
+				GFP_KERNEL);
+	if (!hwmon) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	platform_set_drvdata(pdev, hwmon);
+
+	hwmon->da9058 = da9058;
+	hwmon->pdev = pdev;
+	hwmon->use_automatic_adc = hwmon_pdata->use_automatic_adc;
+	hwmon->temp_adc_resistance = hwmon_pdata->temp_adc_resistance;
+	hwmon->vf_adc_resistance = hwmon_pdata->vf_adc_resistance;
+
+	if (hwmon->use_automatic_adc) {
+		unsigned int mode = DA9058_ADCCONT_AUTOADCEN |
+				DA9058_ADCCONT_TEMPISRCEN |
+				DA9058_ADCCONT_AUTOVBATEN |
+				DA9058_ADCCONT_AUTOVFEN |
+				DA9058_ADCCONT_AUTOAINEN;
+
+		if (hwmon->vf_adc_resistance)
+			mode |= DA9058_ADCCONT_VFISRCEN;
+
+		ret = da9058_reg_write(da9058, DA9058_ADCCONT_REG, mode);
+		if (ret)
+			goto exit;
+	} else {
+		unsigned int mode = 0;
+
+		if (hwmon->temp_adc_resistance)
+			mode |= DA9058_ADCCONT_TEMPISRCEN;
+		if (hwmon->vf_adc_resistance)
+			mode |= DA9058_ADCCONT_VFISRCEN;
+
+		ret = da9058_reg_write(da9058, DA9058_ADCCONT_REG, mode);
+		if (ret)
+			goto exit;
+	}
+
+	mutex_init(&hwmon->hwmon_lock);
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &da9058_attr_group);
+	if (ret)
+		goto exit;
+
+	hwmon->exit_hwmon_platform_callback =
+				hwmon_pdata->exit_hwmon_platform_callback;
+	hwmon->init_hwmon_platform_callback =
+				hwmon_pdata->init_hwmon_platform_callback;
+
+	if (hwmon_pdata->init_hwmon_platform_callback)
+			hwmon_pdata->init_hwmon_platform_callback(hwmon);
+
+	hwmon->class_device = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(hwmon->class_device)) {
+		ret = PTR_ERR(hwmon->class_device);
+		goto failed_to_register_device;
+	}
+
+	goto exit;
+
+failed_to_register_device:
+	sysfs_remove_group(&pdev->dev.kobj, &da9058_attr_group);
+exit:
+	return ret;
+}
+
+static int __devexit da9058_hwmon_remove(struct platform_device *pdev)
+{
+	struct da9058_hwmon *hwmon = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(hwmon->class_device);
+	if (hwmon->exit_hwmon_platform_callback)
+				hwmon->exit_hwmon_platform_callback(hwmon);
+	sysfs_remove_group(&pdev->dev.kobj, &da9058_attr_group);
+
+	return 0;
+}
+
+static struct platform_driver da9058_hwmon_driver = {
+	.probe = da9058_hwmon_probe,
+	.remove = __devexit_p(da9058_hwmon_remove),
+	.driver = {
+		.name = "da9058-hwmon",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(da9058_hwmon_driver);
+
+MODULE_DESCRIPTION("Dialog DA9058 PMIC HardWare Monitor Driver");
+MODULE_AUTHOR("Anthony Olech <Anthony.Olech@diasemi.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9058-hwmon");
-- 
end-of-patch for NEW DRIVER V3

