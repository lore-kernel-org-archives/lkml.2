Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1DZLhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:37:11 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.186]:46954
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754633Ab1DZLhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:37:09 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eK2176Mc8kzz1202hzz8275bhz32i2a8h668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Dajun Chen <Dajun.Chen@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Date: Tue, 26 Apr 2011 17:06:06 +0530
Subject: [PATCHv1 -next] HWMON: HWMON module of DA9052 PMIC driver
Thread-Topic: [PATCHv1 -next] HWMON: HWMON module of DA9052 PMIC driver
Thread-Index: AcwEBiFmS6qXxMZgRnu9GChtXrHztg==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B89B21E@KCINPUNHJCMS01.kpit.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3QBbJHR017283

Hi,

HWMON Driver for Dialog Semiconductor DA9052 PMICs.

Changes made since last submission:
. Changed the return format for charging current, bat temperature
	and junction temperature
. conversion of temperature to mill degree

Signed-off-by: D. Chen <dchen@diasemi.com>
---

diff -Naur linux-next-20110421.orig/Documentation/hwmon/da9052 linux-next-20110421/Documentation/hwmon/da9052
--- linux-next-20110421.orig/Documentation/hwmon/da9052	1970-01-01 05:00:00.000000000 +0500
+++ linux-next-20110421/Documentation/hwmon/da9052	2011-04-26 14:58:54.000000000 +0500
@@ -0,0 +1,54 @@
+Kernel driver da9052-hwmon
+==========================
+
+Supported chips:
+  * Dialog Semiconductors DA9052 PMICs
+    Prefix: 'da9052'
+    Datasheet: Kindly visit www.dialog-semiconductor.com and request for the
+               official datasheet.
+
+Authors: David Dajun Chen <dchen@diasemi.com>
+
+Description
+-----------
+
+The DA9052 provides an Analogue to Digital Converter (ADC) with 10 bits
+resolution and track and hold circuitry combined with an analogue input
+multiplexer. The analogue input multiplexer will allow conversion of up to 10
+different inputs. The track and hold circuit ensures stable input voltages at
+the input of the ADC during the conversion.
+
+The ADC is used to measure the following inputs:
+Channel 0: VDDOUT - measurement of the system voltage
+Channel 1: ICH - internal battery charger current measurement
+Channel 2: TBAT - output from the battery NTC
+Channel 3: VBAT - measurement of the battery voltage
+Channel 4: ADC_IN4 - high impedance input (0 - 2.5V)
+Channel 5: ADC_IN5 - high impedance input (0 - 2.5V)
+Channel 6: ADC_IN6 - high impedance input (0 - 2.5V)
+Channel 7: XY - TSI interface to measure the X and Y voltage of the touch
+screen resistive potentiometers
+Channel 8: Internal Tjunc. - sense (internal temp. sensor)
+Channel 9: VBBAT - measurement of the backup battery voltage
+
+By using sysfs attributes we can measure the system voltage VDDOUT, the battery
+charging current ICH, battery temperature TBAT, battery junction temperature
+TJUNC, battery voltage VBAT and the back up battery voltage VBBAT.
+
+Voltage Monitoring
+------------------
+
+Voltages are sampled by a 10 bit ADC.  Voltages in millivolts are 1.465
+times the ADC value.
+
+Temperature Monitoring
+----------------------
+
+Temperatures are sampled by a 10 bit ADC.  Chip and battery temperatures
+are available.  The chip temperature is calculated as:
+
+	Degrees celsius = (512.18 - data) / 1.0983
+
+while the battery temperature calculation will depend on the NTC
+thermistor component.
+
diff -Naur linux-next-20110421.orig/drivers/hwmon/da9052-hwmon.c linux-next-20110421/drivers/hwmon/da9052-hwmon.c
--- linux-next-20110421.orig/drivers/hwmon/da9052-hwmon.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-next-20110421/drivers/hwmon/da9052-hwmon.c	2011-04-26 14:16:50.000000000 +0500
@@ -0,0 +1,329 @@
+/*
+ * HWMON Driver for Dialog DA9052
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
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
+
+#define DA9052_ADC_CHANNELS(id, func_name, name)\
+	static SENSOR_DEVICE_ATTR(in##id##_label, S_IRUGO, show_label,\
+				  NULL, name);\
+	static SENSOR_DEVICE_ATTR(in##id##_input, S_IRUGO, func_name,\
+				  NULL, name)
+
+struct da9052_hwmon {
+	struct da9052	*da9052;
+	struct device	*class_device;
+	struct mutex 	hwmon_lock;
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
+	[DA9052_ADC_VBBAT]	=	"BACK-UP BATTERY VOLTAGE",
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
+	ret &= ~DA9052_ADCCONT_AUTOVDDEN;
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
+	mutex_lock(&hwmon->hwmon_lock);
+
+	ret = da9052_enable_vddout_channel(hwmon->da9052);
+	if (ret < 0)
+		goto hwmon_err;
+
+	ret = da9052_reg_read(hwmon->da9052, DA9052_VDD_RES_REG);
+	if (ret < 0)
+		goto hwmon_err;
+
+	ret = da9052_disable_vddout_channel(hwmon->da9052);
+	if (ret < 0)
+		goto hwmon_err;
+
+	mutex_unlock(&hwmon->hwmon_lock);
+	return sprintf(buf, "%u\n", ret);
+
+hwmon_err:
+	mutex_unlock(&hwmon->hwmon_lock);
+	return ret;
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
+
+	/* Equivalent to 3.9mA/bit in register ICHG_AV */
+	ret = DIV_ROUND_CLOSEST(ret * 39, 10);
+	return sprintf(buf, "%d\n", ret);
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
+
+	/* Degrees celsius = (512.18-ret) / 1.0983 */
+	ret = 512180 - (ret * 1000);
+	ret = DIV_ROUND_CLOSEST(ret * 10000, 10983);
+	return sprintf(buf, "%d\n", ret);
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
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%u\n", ret);
+}
+
+static ssize_t da9052_read_tjunc(struct device *dev,
+	struct device_attribute *devattr, char *buf)
+{
+	struct da9052_hwmon *hwmon = dev_get_drvdata(dev);
+	int temp;
+	int ret;
+
+	ret = da9052_reg_read(hwmon->da9052, DA9052_TJUNC_RES_REG);
+	if (ret < 0)
+		return ret;
+
+	temp = ret;
+
+	ret = da9052_reg_read(hwmon->da9052, DA9052_T_OFFSET_REG);
+	if (ret < 0)
+		return ret;
+
+	/* Degrees celsius = 1.708 * (TJUNC_RES - T_OFFSET) - 108.8 */
+	ret = 1708 * (temp - ret) - 108800;
+	return sprintf(buf, "%d\n", ret);
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
+	return sprintf(buf, "%s\n", input_names[to_sensor_dev_attr(devattr)->index]);
+}
+
+DA9052_ADC_CHANNELS(0, da9052_read_vddout, DA9052_ADC_VDDOUT);
+DA9052_ADC_CHANNELS(3, da9052_read_vbat, DA9052_ADC_VBAT);
+DA9052_ADC_CHANNELS(4, da9052_read_misc_channel, DA9052_ADC_IN4);
+DA9052_ADC_CHANNELS(5, da9052_read_misc_channel, DA9052_ADC_IN5);
+DA9052_ADC_CHANNELS(6, da9052_read_misc_channel, DA9052_ADC_IN6);
+DA9052_ADC_CHANNELS(9, da9052_read_vbbat, DA9052_ADC_VBBAT);
+static SENSOR_DEVICE_ATTR(curr1_input, S_IRUGO, da9052_read_ich, NULL,
+				DA9052_ADC_ICH);
+static SENSOR_DEVICE_ATTR(curr1_label, S_IRUGO, show_label, NULL,
+				DA9052_ADC_TJUNC);
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, da9052_read_tbat, NULL,
+				DA9052_ADC_TBAT);
+static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_label, NULL,
+				DA9052_ADC_TBAT);
+static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, da9052_read_tjunc, NULL,
+				DA9052_ADC_TJUNC);
+static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, show_label, NULL,
+				DA9052_ADC_TJUNC);
+
+static DEVICE_ATTR(name, S_IRUGO, da9052_hwmon_show_name, NULL);
+
+static struct attribute *da9052_attr[] = {
+	&dev_attr_name.attr,
+
+	&sensor_dev_attr_in0_input.dev_attr.attr,
+	&sensor_dev_attr_in0_label.dev_attr.attr,
+	&sensor_dev_attr_curr1_input.dev_attr.attr,
+	&sensor_dev_attr_curr1_label.dev_attr.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_label.dev_attr.attr,
+	&sensor_dev_attr_in3_input.dev_attr.attr,
+	&sensor_dev_attr_in3_label.dev_attr.attr,
+	&sensor_dev_attr_in4_input.dev_attr.attr,
+	&sensor_dev_attr_in4_label.dev_attr.attr,
+	&sensor_dev_attr_in5_input.dev_attr.attr,
+	&sensor_dev_attr_in5_label.dev_attr.attr,
+	&sensor_dev_attr_in6_input.dev_attr.attr,
+	&sensor_dev_attr_in6_label.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_label.dev_attr.attr,
+	&sensor_dev_attr_in9_input.dev_attr.attr,
+	&sensor_dev_attr_in9_label.dev_attr.attr,
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
+	mutex_init(&hwmon->hwmon_lock);
+	hwmon->da9052 = dev_get_drvdata(pdev->dev.parent);
+
+	platform_set_drvdata(pdev, hwmon);
+
+	hwmon->class_device = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(hwmon->class_device)) {
+		ret = PTR_ERR(hwmon->class_device);
+		goto err_mem;
+	}
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &da9052_attr_group);
+	if (ret)
+		goto err_sysfs;
+
+	return 0;
+
+err_sysfs:
+	hwmon_device_unregister(hwmon->class_device);
+err_mem:
+	kfree(hwmon);
+	return ret;
+}
+
+static int __devexit da9052_hwmon_remove(struct platform_device *pdev)
+{
+	struct da9052_hwmon *hwmon = platform_get_drvdata(pdev);
+
+	mutex_destroy(&hwmon->hwmon_lock);
+	hwmon_device_unregister(hwmon->class_device);
+	sysfs_remove_group(&pdev->dev.kobj, &da9052_attr_group);
+	kfree(hwmon);
+
+	return 0;
+}
+
+static struct platform_driver da9052_hwmon_driver = {
+	.driver = {	
+		.name		= "da9052-hwmon",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= da9052_hwmon_probe,
+	.remove		= __devexit_p(da9052_hwmon_remove),
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
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("DA9052 ADC driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9052-hwmon");
diff -Naur linux-next-20110421.orig/drivers/hwmon/Kconfig linux-next-20110421/drivers/hwmon/Kconfig
--- linux-next-20110421.orig/drivers/hwmon/Kconfig	2011-04-26 09:31:34.000000000 +0500
+++ linux-next-20110421/drivers/hwmon/Kconfig	2011-04-26 14:27:08.000000000 +0500
@@ -303,6 +303,16 @@
 	  This driver can also be built as a module.  If so, the module
 	  will be called ds1621.

+config SENSORS_DA9052_ADC
+	tristate "Dialog DA9052 HWMON"
+	depends on PMIC_DA9052
+	help
+	  Say y here to support the ADC found on
+	  Dialog Semiconductor DA9052 PMIC.
+
+	  This driver can also be built as module. If so, the module
+	  will be called da9052-hwmon.
+
 config SENSORS_I5K_AMB
 	tristate "FB-DIMM AMB temperature sensor on Intel 5000 series chipsets"
 	depends on PCI && EXPERIMENTAL
diff -Naur linux-next-20110421.orig/drivers/hwmon/Makefile linux-next-20110421/drivers/hwmon/Makefile
--- linux-next-20110421.orig/drivers/hwmon/Makefile	2011-04-26 09:31:34.000000000 +0500
+++ linux-next-20110421/drivers/hwmon/Makefile	2011-04-26 14:24:49.000000000 +0500
@@ -41,6 +41,7 @@
 obj-$(CONFIG_SENSORS_ATXP1)		+= atxp1.o
 obj-$(CONFIG_SENSORS_CORETEMP)	+= coretemp.o
 obj-$(CONFIG_SENSORS_PKGTEMP)	+= pkgtemp.o
+obj-$(CONFIG_SENSORS_DA9052_ADC)	+= da9052-hwmon.o
 obj-$(CONFIG_SENSORS_DME1737)	+= dme1737.o
 obj-$(CONFIG_SENSORS_DS620)		+= ds620.o
 obj-$(CONFIG_SENSORS_DS1621)		+= ds1621.o



Regards,
Ashish


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
