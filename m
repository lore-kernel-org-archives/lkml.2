Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1ISMfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 08:35:03 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:31229
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755815Ab1ISMfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 08:35:00 -0400
X-SpamScore: 10
X-BigFish: VPS10(zzc8kzz1202h10d2nzz8275bhz32i2a8h668h839h67h)
X-Spam-TCS-SCL: 6:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH 01/11] MFD: DA9052/53 MFD core module v6
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <sameo@openedhand.com>, <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>, <linaro-dev@lists.linaro.org>,
        <arnd@arndb.de>
Content-Type: text/plain; charset="cp1252"
Date: Mon, 19 Sep 2011 18:03:16 +0530
Message-ID: <1316435596.344.132.camel@L-0761.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.37]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DA9052/53 is a highly integrated PMIC subsystem with supply domain flexibility
to support wide range of high performance application.

It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
control and other functionality.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
Changes since v6:
- Move inlined device I/O functions to header file
Changes since v5:
- Inline device I/O
- Unhandle IRQ return RQ_NONE
- Remove register address conversion
Changes since v4:
- Modify KConfig 
- Use device registration for detemining chip id
- Remove preprocessor directive with runtime bustype variable
- Replace module_init() for spi with subsys_initcall()
- Remove platform string from MODULE_ALIAS of spi module.
Changes since v3:
- Code refactored to use REGMAP API.
- Add Battery resources.
- da9052_set_bits() and da9052_clear_bits() replaced by da9052_reg_update().
- Add support for DA9053 PMIC
Changes since v2:
- Drop da9052_irqs[] table.
- Move struct da9052_subdev_info[].
- Remove initialization of static member.
- Care for NULL pdata init().
- Check removal of subdevices on errors.
- Remove open source spi code.
- Remove '_spi' from the driver name.
- Move tbat_lookup table from header file.
- Remove irq.h 
- Remove num_gpio variable from pdata
---
 drivers/mfd/Kconfig               |   26 ++
 drivers/mfd/Makefile              |    7 +
 drivers/mfd/da9052-core.c         |  333 ++++++++++++++++
 drivers/mfd/da9052-i2c.c          |  142 +++++++
 drivers/mfd/da9052-irq.c          |  173 ++++++++
 drivers/mfd/da9052-spi.c          |  166 ++++++++
 include/linux/mfd/da9052/da9052.h |  139 +++++++
 include/linux/mfd/da9052/pdata.h  |   42 ++
 include/linux/mfd/da9052/reg.h    |  777 +++++++++++++++++++++++++++++++++++++
 9 files changed, 1805 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/da9052-core.c
 create mode 100644 drivers/mfd/da9052-i2c.c
 create mode 100644 drivers/mfd/da9052-irq.c
 create mode 100644 drivers/mfd/da9052-spi.c
 create mode 100644 include/linux/mfd/da9052/da9052.h
 create mode 100644 include/linux/mfd/da9052/pdata.h
 create mode 100644 include/linux/mfd/da9052/reg.h
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 21574bd..572a6a8 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -343,6 +343,32 @@ config PMIC_DA903X
 	  individual components like LCD backlight, voltage regulators,
 	  LEDs and battery-charger under the corresponding menus.
 
+config PMIC_DA9052
+	bool
+	select MFD_CORE
+
+config MFD_DA9052_SPI
+	bool "Support Dialog Semiconductor DA9052/53 PMIC variants with SPI"
+	select REGMAP_SPI
+	select PMIC_DA9052
+	depends on SPI_MASTER=y
+	help
+	  Support for the Dialog Semiconductor DA9052 PMIC
+	  when controlled using SPI. This driver provides common support
+	  for accessing the device, additional drivers must be enabled in
+	  order to use the functionality of the device.
+
+config MFD_DA9052_I2C
+	bool "Support Dialog Semiconductor DA9052/53 PMIC variants with I2C"
+	select REGMAP_I2C
+	select PMIC_DA9052
+	depends on I2C=y
+	help
+	  Support for the Dialog Semiconductor DA9052 PMIC
+	  when controlled using I2C. This driver provides common support
+	  for accessing the device, additional drivers must be enabled in
+	  order to use the functionality of the device.
+
 config PMIC_ADP5520
 	bool "Analog Devices ADP5520/01 MFD PMIC Core Support"
 	depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index c580203..89a5837 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -67,6 +67,13 @@ endif
 obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_core.o
 
 obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
+
+da9052-objs			:= da9052-core.o da9052-irq.o
+obj-$(CONFIG_PMIC_DA9052)	+= da9052.o
+
+obj-$(CONFIG_MFD_DA9052_SPI)	+= da9052-spi.o
+obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
+
 max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
 obj-$(CONFIG_MFD_MAX8997)	+= max8997.o max8997-irq.o
diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
new file mode 100644
index 0000000..9a439b3
--- /dev/null
+++ b/drivers/mfd/da9052-core.c
@@ -0,0 +1,333 @@
+/*
+ * Device access for Dialog DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/mutex.h>
+#include <linux/mfd/core.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/pdata.h>
+#include <linux/mfd/da9052/reg.h>
+
+#define DA9052_IRQ_DCIN	0
+#define DA9052_IRQ_VBUS	1
+#define DA9052_IRQ_DCINREM	2
+#define DA9052_IRQ_VBUSREM	3
+#define DA9052_IRQ_ALARM	5
+#define DA9052_IRQ_NONKEY	8
+#define DA9052_IRQ_CHGEND	11
+#define DA9052_IRQ_TBAT	12
+#define DA9052_IRQ_PENDOWN	14
+#define DA9052_IRQ_TSIREADY	15
+
+/*
+ * TBAT look-up table is computed from the R90 reg (8 bit register)
+ * reading as below. The battery temperature is in milliCentigrade
+ * TBAT = (1/(t1+1/298) - 273) * 1000 mC
+ * where t1 = (1/B)* ln(( ADCval * 2.5)/(R25*ITBAT*255))
+ * Default values are R25 = 10e3, B = 3380, ITBAT = 50e-6
+ * Example:
+ * R25=10E3, B=3380, ITBAT=50e-6, ADCVAL=62d calculates
+ * TBAT = 20015 mili degrees Centrigrade
+ *
+*/
+static const int32_t tbat_lookup[255] = {
+	183258, 144221, 124334, 111336, 101826, 94397, 88343, 83257,
+	78889, 75071, 71688, 68656, 65914, 63414, 61120, 59001,
+	570366, 55204, 53490, 51881, 50364, 48931, 47574, 46285,
+	45059, 43889, 42772, 41703, 40678, 39694, 38748, 37838,
+	36961, 36115, 35297, 34507, 33743, 33002, 32284, 31588,
+	30911, 30254, 29615, 28994, 28389, 27799, 27225, 26664,
+	26117, 25584, 25062, 24553, 24054, 23567, 23091, 22624,
+	22167, 21719, 21281, 20851, 20429, 20015, 19610, 19211,
+	18820, 18436, 18058, 17688, 17323, 16965, 16612, 16266,
+	15925, 15589, 15259, 14933, 14613, 14298, 13987, 13681,
+	13379, 13082, 12788, 12499, 12214, 11933, 11655, 11382,
+	11112, 10845, 10582, 10322, 10066, 9812, 9562, 9315,
+	9071, 8830, 8591, 8356, 8123, 7893, 7665, 7440,
+	7218, 6998, 6780, 6565, 6352, 6141, 5933, 5726,
+	5522, 5320, 5120, 4922, 4726, 4532, 4340, 4149,
+	3961, 3774, 3589, 3406, 3225, 3045, 2867, 2690,
+	2516, 2342, 2170, 2000, 1831, 1664, 1498, 1334,
+	1171, 1009, 849, 690, 532, 376, 221, 67,
+	-84, -236, -386, -535, -683, -830, -975, -1119,
+	-1263, -1405, -1546, -1686, -1825, -1964, -2101, -2237,
+	-2372, -2506, -2639, -2771, -2902, -3033, -3162, -3291,
+	-3418, -3545, -3671, -3796, -3920, -4044, -4166, -4288,
+	-4409, -4529, -4649, -4767, -4885, -5002, -5119, -5235,
+	-5349, -5464, -5577, -5690, -5802, -5913, -6024, -6134,
+	-6244, -6352, -6461, -6568, -6675, -6781, -6887, -6992,
+	-7096, -7200, -7303, -7406, -7508, -7609, -7710, -7810,
+	-7910, -8009, -8108, -8206, -8304, -8401, -8497, -8593,
+	-8689, -8784, -8878, -8972, -9066, -9159, -9251, -9343,
+	-9435, -9526, -9617, -9707, -9796, -9886, -9975, -10063,
+	-10151, -10238, -10325, -10412, -10839, -10923, -11007, -11090,
+	-11173, -11256, -11338, -11420, -11501, -11583, -11663, -11744,
+	-11823, -11903, -11982
+};
+
+static const u8 chan_mux[DA9052_ADC_VBBAT + 1] = {
+	[DA9052_ADC_VDDOUT]	= DA9052_ADC_MAN_MUXSEL_VDDOUT,
+	[DA9052_ADC_ICH]	= DA9052_ADC_MAN_MUXSEL_ICH,
+	[DA9052_ADC_TBAT]	= DA9052_ADC_MAN_MUXSEL_TBAT,
+	[DA9052_ADC_VBAT]	= DA9052_ADC_MAN_MUXSEL_VBAT,
+	[DA9052_ADC_IN4]	= DA9052_ADC_MAN_MUXSEL_AD4,
+	[DA9052_ADC_IN5]	= DA9052_ADC_MAN_MUXSEL_AD5,
+	[DA9052_ADC_IN6]	= DA9052_ADC_MAN_MUXSEL_AD6,
+	[DA9052_ADC_VBBAT]	= DA9052_ADC_MAN_MUXSEL_VBBAT
+};
+
+int da9052_adc_manual_read(struct da9052 *da9052, unsigned char channel)
+{
+	unsigned long timeout;
+	unsigned short calc_data;
+	unsigned short data;
+	int ret;
+	unsigned char mux_sel;
+
+	if (channel > DA9052_ADC_VBBAT)
+		return -EINVAL;
+
+	mutex_lock(&da9052->auxadc_lock);
+
+	/* Channel gets activated on enabling the Conversion bit */
+	mux_sel = chan_mux[channel] | DA9052_ADC_MAN_MAN_CONV;
+
+	ret = da9052_reg_read(da9052, DA9052_ADC_MAN_REG);
+	if (ret < 0)
+		goto err;
+
+	if (ret & DA9052_ADC_MAN_MAN_CONV) {
+		ret = -EBUSY;
+		goto err;
+	}
+
+	ret = da9052_reg_write(da9052, DA9052_ADC_MAN_REG, mux_sel);
+	if (ret < 0)
+		goto err;
+
+	timeout = jiffies + msecs_to_jiffies(100);
+	do {
+		ret = da9052_reg_read(da9052, DA9052_ADC_MAN_REG);
+		if (ret < 0)
+			goto err;
+
+		if (!(ret & DA9052_ADC_MAN_MAN_CONV)) {
+			timeout = 0;
+			break;
+		}
+		msleep(1);
+
+	} while (time_before(jiffies, timeout));
+
+	if (timeout != 0) {
+		ret = -EBUSY;
+		goto err;
+	}
+
+	ret = da9052_reg_read(da9052, DA9052_ADC_RES_H_REG);
+	if (ret < 0)
+		goto err;
+
+	calc_data = (unsigned short)ret;
+	data = calc_data << 2;
+
+	ret = da9052_reg_read(da9052, DA9052_ADC_RES_L_REG);
+	if (ret < 0)
+		goto err;
+
+	calc_data = (unsigned short)(ret & DA9052_ADC_RES_LSB);
+	data |= calc_data;
+
+	ret = data;
+
+err:
+	mutex_unlock(&da9052->auxadc_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(da9052_adc_manual_read);
+
+int da9052_adc_temperature_read(struct da9052 *da9052)
+{
+	int tbat;
+
+	tbat = da9052_reg_read(da9052, DA9052_TBAT_RES_REG);
+
+	if (tbat < 0)
+		return tbat;
+
+	if (tbat == 0) {
+		pr_debug("TBAT R[90] = 0 is undefined.\n");
+		return -EINVAL;
+	}
+
+	/* ARRAY_SIZE check is not needed since TBAT is a 8-bit register */
+	return tbat_lookup[tbat - 1];
+}
+EXPORT_SYMBOL_GPL(da9052_adc_temperature_read);
+
+static struct resource da9052_rtc_resource = {
+	.name = "ALM",
+	.start = DA9052_IRQ_ALARM,
+	.end   = DA9052_IRQ_ALARM,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct resource da9052_onkey_resource = {
+	.name = "ONKEY",
+	.start = DA9052_IRQ_NONKEY,
+	.end   = DA9052_IRQ_NONKEY,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct resource da9052_power_resources[] = {
+	{
+		.name = "BATT TEMP",
+		.start = DA9052_IRQ_TBAT,
+		.end   = DA9052_IRQ_TBAT,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "DCIN DET",
+		.start = DA9052_IRQ_DCIN,
+		.end   = DA9052_IRQ_DCIN,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "DCIN REM",
+		.start = DA9052_IRQ_DCINREM,
+		.end   = DA9052_IRQ_DCINREM,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS DET",
+		.start = DA9052_IRQ_VBUS,
+		.end   = DA9052_IRQ_VBUS,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS REM",
+		.start = DA9052_IRQ_VBUSREM,
+		.end   = DA9052_IRQ_VBUSREM,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "CHG END",
+		.start = DA9052_IRQ_CHGEND,
+		.end   = DA9052_IRQ_CHGEND,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource da9052_tsi_resources[] = {
+	{
+		.name = "PENDWN",
+		.start = DA9052_IRQ_PENDOWN,
+		.end   = DA9052_IRQ_PENDOWN,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "TSIRDY",
+		.start = DA9052_IRQ_TSIREADY,
+		.end   = DA9052_IRQ_TSIREADY,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+int da9052_add_regulator_devices(struct da9052 *da9052,
+				  struct da9052_pdata *pdata)
+{
+	struct platform_device *pdev;
+	int i, ret;
+
+	for (i = 0; i < pdata->num_regulators; i++) {
+		pdev = platform_device_alloc("da9052-regulator", i);
+		if (!pdev)
+			return -ENOMEM;
+
+		pdev->dev.parent = da9052->dev;
+		ret = platform_device_add(pdev);
+		if (ret) {
+			platform_device_put(pdev);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static struct mfd_cell __initdata da9052_subdev_info[] = {
+	{"da9052-onkey", .resources = &da9052_onkey_resource,
+	 .num_resources = 1},
+	{"da9052-rtc", .resources = &da9052_rtc_resource,
+	 .num_resources = 1},
+	{"da9052-gpio"},
+	{"da9052-hwmon"},
+	{"da9052-leds"},
+	{"da9052-wled1"},
+	{"da9052-wled2"},
+	{"da9052-wled3"},
+	{"da9052-tsi", .resources = da9052_tsi_resources,
+	 .num_resources = ARRAY_SIZE(da9052_tsi_resources)},
+	{"da9052-bat", .resources = da9052_power_resources,
+	 .num_resources = ARRAY_SIZE(da9052_power_resources)},
+	{"da9052-watchdog"},
+};
+
+int da9052_device_init(struct da9052 *da9052, u8 chip_id)
+{
+	struct da9052_pdata *pdata = da9052->dev->platform_data;
+	int ret;
+
+	mutex_init(&da9052->io_lock);
+	mutex_init(&da9052->auxadc_lock);
+
+	if (pdata->init != NULL)
+		pdata->init(da9052);
+
+	da9052->chip_id = chip_id;
+
+	ret = da9052_add_regulator_devices(da9052, pdata);
+	if (ret)
+		goto err;
+
+	ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
+			      ARRAY_SIZE(da9052_subdev_info), NULL, 0);
+	if (ret)
+		goto err;
+
+	ret = da9052_irq_init(da9052, pdata);
+	if (ret != 0)
+		goto err;
+
+	return 0;
+
+err:
+	mfd_remove_devices(da9052->dev);
+	return ret;
+}
+
+void da9052_device_exit(struct da9052 *da9052)
+{
+	mfd_remove_devices(da9052->dev);
+	da9052_irq_exit(da9052);
+}
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("DA9052 MFD Core");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
new file mode 100644
index 0000000..0124141
--- /dev/null
+++ b/drivers/mfd/da9052-i2c.c
@@ -0,0 +1,142 @@
+/*
+ * I2C access for DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/input.h>
+#include <linux/mfd/core.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+static int da9052_i2c_enable_multiwrite(struct da9052 *da9052)
+{
+	int reg_val, ret;
+
+	ret = regmap_read(da9052->regmap, DA9052_CONTROL_B_REG, &reg_val);
+	if (ret < 0)
+		return ret;
+
+	if (reg_val & DA9052_CONTROL_B_WRITEMODE) {
+		reg_val = ~DA9052_CONTROL_B_WRITEMODE;
+		ret = regmap_write(da9052->regmap, DA9052_CONTROL_B_REG,
+				   reg_val);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static struct regmap_config da9052_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int __devinit da9052_i2c_probe(struct i2c_client *client,
+				       const struct i2c_device_id *id)
+{
+	struct da9052 *da9052_i2c;
+	int ret;
+
+	da9052_i2c = kzalloc(sizeof(struct da9052), GFP_KERNEL);
+	if (!da9052_i2c)
+		return -ENOMEM;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_info(&client->dev, "Error in %s:i2c_check_functionality\n",
+			 __func__);
+		return -ENODEV;
+	}
+
+	da9052_i2c->bustype = BUS_I2C;
+	da9052_i2c->dev = &client->dev;
+
+	i2c_set_clientdata(client, da9052_i2c);
+
+	da9052_i2c->regmap = regmap_init_i2c(client, &da9052_regmap_config);
+	if (IS_ERR(da9052_i2c->regmap)) {
+		ret = PTR_ERR(da9052_i2c->regmap);
+		dev_err(&client->dev, "Failed to allocate register map: %d\n",
+			ret);
+		goto err;
+	}
+
+	ret = da9052_i2c_enable_multiwrite(da9052_i2c);
+	if (ret < 0)
+		goto err;
+
+	ret = da9052_device_init(da9052_i2c, id->driver_data);
+	if (ret != 0)
+		goto err;
+
+	return 0;
+
+err:
+	kfree(da9052_i2c);
+	return ret;
+}
+
+static int da9052_i2c_remove(struct i2c_client *client)
+{
+	struct da9052 *da9052 = i2c_get_clientdata(client);
+
+	da9052_device_exit(da9052);
+	kfree(da9052);
+
+	return 0;
+}
+
+static struct i2c_device_id da9052_i2c_id[] = {
+	{"da9052", DA9052},
+	{"da9053-aa", DA9053_AA},
+	{"da9053-ba", DA9053_BA},
+	{"da9053-bb", DA9053_BB},
+	{}
+};
+
+static struct i2c_driver da9052_i2c_driver = {
+	.probe = da9052_i2c_probe,
+	.remove = da9052_i2c_remove,
+	.id_table = da9052_i2c_id,
+	.driver = {
+		.name = "da9052",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init da9052_i2c_init(void)
+{
+	int ret;
+
+	ret = i2c_add_driver(&da9052_i2c_driver);
+	if (ret != 0) {
+		pr_err("DA9052 I2C registration failed %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+subsys_initcall(da9052_i2c_init);
+
+static void __exit da9052_i2c_exit(void)
+{
+	i2c_del_driver(&da9052_i2c_driver);
+}
+module_exit(da9052_i2c_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("I2C driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/da9052-irq.c b/drivers/mfd/da9052-irq.c
new file mode 100644
index 0000000..efbfd79
--- /dev/null
+++ b/drivers/mfd/da9052-irq.c
@@ -0,0 +1,173 @@
+/*
+ * Interrupt controller support for Dilaog DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <linux/mfd/core.h>
+#include <linux/interrupt.h>
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/pdata.h>
+
+#define DA9052_FIXME() {udelay(50); }
+
+static void da9052_irq_lock(struct irq_data *data)
+{
+	struct da9052 *da9052 = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&da9052->irq_lock);
+}
+
+static void da9052_irq_sync_unlock(struct irq_data *data)
+{
+	struct da9052 *da9052 = irq_data_get_irq_chip_data(data);
+	unsigned int offset, v;
+
+	offset = (data->irq - da9052->irq_base) / 8;
+	v = (da9052->events_mask >> (offset * 8)) & 0xff;
+
+	da9052_reg_write(da9052, DA9052_IRQ_MASK_A_REG + offset, v);
+
+	mutex_unlock(&da9052->irq_lock);
+}
+
+static void da9052_irq_unmask(struct irq_data *data)
+{
+	struct da9052 *da9052 = irq_data_get_irq_chip_data(data);
+	unsigned int mask;
+
+	mask = 1 << ((data->irq - da9052->irq_base) % 8);
+
+	da9052->events_mask &= ~mask;
+}
+
+static void da9052_irq_mask(struct irq_data *data)
+{
+	struct da9052 *da9052 = irq_data_get_irq_chip_data(data);
+	unsigned int mask;
+
+	mask = 1 << ((data->irq - da9052->irq_base) % 8);
+
+	da9052->events_mask |= mask;
+}
+
+int da9052_read_events(struct da9052 *da9052, unsigned char reg,
+			unsigned int *events)
+{
+	uint8_t v[4] = {0, 0, 0, 0};
+	int ret;
+
+	ret = da9052_group_read(da9052, reg, 4, v);
+	if (ret < 0)
+		return ret;
+
+	*events = (v[3] << 24) | (v[2] << 16) | (v[1] << 8) | v[0];
+
+	return 0;
+}
+
+static irqreturn_t da9052_irq_thread(int irq, void *data)
+{
+	struct da9052 *da9052 = data;
+	uint8_t v[4] = {0xFF, 0xFF, 0xFF, 0xFF};
+	unsigned short i;
+	unsigned int events;
+
+	if (da9052_read_events(da9052, DA9052_EVENT_A_REG, &events))
+		goto err;
+
+	events &= ~da9052->events_mask;
+
+	if (events == 0)
+		goto err;
+
+	for (i = 0; i < 32; i++) {
+		if (events & (1 << i))
+			handle_nested_irq(da9052->irq_base + i);
+	}
+
+	da9052_group_write(da9052, DA9052_EVENT_A_REG, 4, v);
+
+	if (da9052->chip_id == DA9052 || da9052->chip_id == DA9053_AA)
+		DA9052_FIXME();
+
+	return IRQ_HANDLED;
+
+err:
+	return IRQ_NONE;
+}
+
+static struct irq_chip da9052_irq_chip = {
+	.name = "da9052",
+	.irq_bus_lock = da9052_irq_lock,
+	.irq_bus_sync_unlock = da9052_irq_sync_unlock,
+	.irq_mask = da9052_irq_mask,
+	.irq_unmask = da9052_irq_unmask,
+};
+
+int da9052_irq_init(struct da9052 *da9052, struct da9052_pdata *pdata)
+{
+	int cur_irq;
+	int ret;
+	int events;
+
+	da9052->chip_irq = pdata->irq;
+	da9052->irq_base = pdata->irq_base;
+
+	if (!da9052->chip_irq) {
+		dev_err(da9052->dev, "No IRQ configured\n");
+		return -EINVAL;
+	}
+
+	mutex_init(&da9052->irq_lock);
+
+	da9052_read_events(da9052, DA9052_IRQ_MASK_A_REG, &events);
+	da9052->events_mask = events;
+
+	for (cur_irq = da9052->irq_base; cur_irq < 32 + da9052->irq_base;
+	     cur_irq++) {
+		irq_set_chip_data(cur_irq, da9052);
+		irq_set_chip_and_handler(cur_irq, &da9052_irq_chip,
+					 handle_simple_irq);
+		irq_set_nested_thread(cur_irq, 1);
+
+		/* ARM needs us to explicitly flag the IRQ as valid
+		 * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+		set_irq_flags(cur_irq, IRQF_VALID);
+#else
+		set_irq_noprobe(cur_irq);
+#endif
+	}
+
+	ret = request_threaded_irq(da9052->chip_irq, NULL, da9052_irq_thread,
+				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				   "da9052", da9052);
+	if (ret != 0) {
+		dev_err(da9052->dev, "Failed to request IRQ %d: %d\n",
+			da9052->chip_irq, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+void da9052_irq_exit(struct da9052 *da9052)
+{
+	if (da9052->chip_irq)
+		free_irq(da9052->chip_irq, da9052);
+}
diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
new file mode 100644
index 0000000..6025eb7
--- /dev/null
+++ b/drivers/mfd/da9052-spi.c
@@ -0,0 +1,166 @@
+/*
+ * SPI access for Dialog DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/input.h>
+#include <linux/mfd/core.h>
+#include <linux/spi/spi.h>
+#include <linux/err.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+static struct regmap_config da9052_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int da9052_spi_probe(struct spi_device *spi)
+{
+	int ret;
+	u8 chip_id = 0;
+	struct da9052 *da9052_spi = kzalloc(sizeof(struct da9052), GFP_KERNEL);
+
+	if (!da9052_spi)
+		return -ENOMEM;
+
+	if (strcmp(spi->modalias, "da9052") == 0)
+		chip_id = DA9052;
+	else if (strcmp(spi->modalias, "da9053-aa") == 0)
+		chip_id = DA9053_AA;
+	else if (strcmp(spi->modalias, "da9053-ba") == 0)
+		chip_id = DA9053_BA;
+	else if (strcmp(spi->modalias, "da9053-bb") == 0)
+		chip_id = DA9053_BB;
+
+	spi->mode = SPI_MODE_0 | SPI_CPOL;
+	spi->bits_per_word = 8;
+	spi_setup(spi);
+
+	da9052_spi->bustype = BUS_SPI;
+	da9052_spi->dev = &spi->dev;
+	da9052_spi->spi_dev = spi;
+
+	dev_set_drvdata(&spi->dev, da9052_spi);
+
+	da9052_spi->regmap = regmap_init_spi(spi, &da9052_regmap_config);
+	if (IS_ERR(da9052_spi->regmap)) {
+		ret = PTR_ERR(da9052_spi->regmap);
+		dev_err(&spi->dev, "Failed to allocate register map: %d\n",
+			ret);
+		goto err;
+	}
+
+	ret = da9052_device_init(da9052_spi, chip_id);
+	if (ret != 0)
+		goto err;
+
+	return 0;
+
+err:
+	kfree(da9052_spi);
+	return ret;
+}
+
+static int da9052_spi_remove(struct spi_device *spi)
+{
+	struct da9052 *da9052 = dev_get_drvdata(&spi->dev);
+
+	da9052_device_exit(da9052);
+	kfree(da9052);
+
+	return 0;
+}
+
+static struct spi_driver da9052_spi_driver = {
+	.probe = da9052_spi_probe,
+	.remove = __devexit_p(da9052_spi_remove),
+	.driver = {
+		.name = "da9052",
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
+	},
+};
+
+static struct spi_driver da9053_aa_spi_driver = {
+	.probe = da9052_spi_probe,
+	.remove = __devexit_p(da9052_spi_remove),
+	.driver = {
+		.name = "da9053-aa",
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
+	},
+};
+
+static struct spi_driver da9053_ba_spi_driver = {
+	.probe = da9052_spi_probe,
+	.remove = __devexit_p(da9052_spi_remove),
+	.driver = {
+		.name = "da9053-ba",
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
+	},
+};
+
+static struct spi_driver da9053_bb_spi_driver = {
+	.probe = da9052_spi_probe,
+	.remove = __devexit_p(da9052_spi_remove),
+	.driver = {
+		.name = "da9053-bb",
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init da9052_spi_init(void)
+{
+	int ret;
+
+	ret = spi_register_driver(&da9052_spi_driver);
+	if (ret != 0) {
+		pr_err("Failed to register DA9052 SPI driver, %d\n", ret);
+		return ret;
+	}
+
+	ret = spi_register_driver(&da9053_aa_spi_driver);
+	if (ret != 0) {
+		pr_err("Failed to register DA9053-AA SPI driver, %d\n", ret);
+		return ret;
+	}
+
+	ret = spi_register_driver(&da9053_ba_spi_driver);
+	if (ret != 0) {
+		pr_err("Failed to register DA9053-BA SPI driver, %d\n", ret);
+		return ret;
+	}
+
+	ret = spi_register_driver(&da9053_bb_spi_driver);
+	if (ret != 0) {
+		pr_err("Failed to register DA9053-BB SPI driver, %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+subsys_initcall(da9052_spi_init);
+
+static void __exit da9052_spi_exit(void)
+{
+	spi_unregister_driver(&da9052_spi_driver);
+}
+module_exit(da9052_spi_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("SPI driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
new file mode 100644
index 0000000..d5480ea
--- /dev/null
+++ b/include/linux/mfd/da9052/da9052.h
@@ -0,0 +1,139 @@
+/*
+ * da9052 declarations for DA952 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
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
+#ifndef __MFD_DA9052_DA9052_H
+#define __MFD_DA9052_DA9052_H
+
+#include <linux/interrupt.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/mfd/core.h>
+
+#include <linux/mfd/da9052/reg.h>
+
+/* HWMON Channel Definations */
+#define DA9052_ADC_VDDOUT	0
+#define DA9052_ADC_ICH		1
+#define DA9052_ADC_TBAT	2
+#define DA9052_ADC_VBAT	3
+#define DA9052_ADC_IN4		4
+#define DA9052_ADC_IN5		5
+#define DA9052_ADC_IN6		6
+#define DA9052_ADC_TSI		7
+#define DA9052_ADC_TJUNC	8
+#define DA9052_ADC_VBBAT	9
+
+enum da9052_chip_id {
+	DA9052,
+	DA9053_AA,
+	DA9053_BA,
+	DA9053_BB,
+};
+
+struct da9052_pdata;
+
+struct da9052 {
+	struct mutex io_lock;
+	struct mutex irq_lock;
+	struct mutex auxadc_lock;
+
+	struct device *dev;
+	struct spi_device *spi_dev;
+	struct i2c_client *i2c_client;
+	struct regmap *regmap;
+
+	int irq_base;
+	u8 bustype;
+	u8 chip_id;
+	u32 events_mask;
+
+	int chip_irq;
+};
+
+/* ADC API */
+int da9052_adc_manual_read(struct da9052 *da9052,
+			    unsigned char channel);
+int da9052_adc_temperature_read(struct da9052 *da9052);
+
+/* Device I/O API */
+static inline int da9052_reg_read(struct da9052 *da9052, unsigned char reg)
+{
+	int val, ret;
+
+	if (reg > DA9052_MAX_REG_CNT) {
+		dev_err(da9052->dev, "invalid reg %x\n", reg);
+		return -EINVAL;
+	}
+
+	ret = regmap_read(da9052->regmap, reg, &val);
+	if (ret < 0)
+		return ret;
+	return val;
+}
+
+static inline int da9052_reg_write(struct da9052 *da9052, unsigned char reg,
+				    unsigned char val)
+{
+	if (reg > DA9052_MAX_REG_CNT) {
+		dev_err(da9052->dev, "invalid reg %x\n", reg);
+		return -EINVAL;
+	}
+
+	return regmap_write(da9052->regmap, reg, val);
+}
+
+static inline int da9052_group_read(struct da9052 *da9052, unsigned char reg,
+				     unsigned reg_cnt, unsigned char *val)
+{
+	if (reg > DA9052_MAX_REG_CNT) {
+		dev_err(da9052->dev, "invalid reg %x\n", reg);
+		return -EINVAL;
+	}
+
+	return regmap_bulk_read(da9052->regmap, reg, val, reg_cnt);
+}
+
+static inline int da9052_group_write(struct da9052 *da9052, unsigned char reg,
+				      unsigned reg_cnt, unsigned char *val)
+{
+	return regmap_raw_write(da9052->regmap, reg, val, reg_cnt);
+}
+
+static inline int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
+				     unsigned char bit_mask, unsigned char reg_val)
+{
+	if (reg > DA9052_MAX_REG_CNT) {
+		dev_err(da9052->dev, "invalid reg %x\n", reg);
+		return -EINVAL;
+	}
+
+	return regmap_update_bits(da9052->regmap, reg, bit_mask, reg_val);
+}
+
+int da9052_device_init(struct da9052 *da9052, u8 chip_id);
+void da9052_device_exit(struct da9052 *da9052);
+
+int da9052_irq_init(struct da9052 *da9052, struct da9052_pdata *pdata);
+void da9052_irq_exit(struct da9052 *da9052);
+
+#endif /* __MFD_DA9052_DA9052_H */
diff --git a/include/linux/mfd/da9052/pdata.h b/include/linux/mfd/da9052/pdata.h
new file mode 100644
index 0000000..b56aa7a
--- /dev/null
+++ b/include/linux/mfd/da9052/pdata.h
@@ -0,0 +1,42 @@
+/*
+ * Platform data declarations for DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
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
+#ifndef __MFD_DA9052_PDATA_H__
+#define __MFD_DA9052_PDATA_H__
+
+#define DA9052_MAX_REGULATORS	15
+
+struct da9052;
+
+struct da9052_pdata {
+	struct led_platform_data *pled;
+	int (*init) (struct da9052 *da9052);
+	int irq;
+	int irq_base;
+	int num_regulators;
+	int gpio_base;
+	int use_for_apm;
+	struct regulator_init_data *regulators[DA9052_MAX_REGULATORS];
+};
+
+#endif
diff --git a/include/linux/mfd/da9052/reg.h b/include/linux/mfd/da9052/reg.h
new file mode 100644
index 0000000..9cbd86f
--- /dev/null
+++ b/include/linux/mfd/da9052/reg.h
@@ -0,0 +1,777 @@
+/*
+ * Register declarations for DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
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
+#ifndef __LINUX_MFD_DA9052_REG_H
+#define __LINUX_MFD_DA9052_REG_H
+
+#define DA9052_MAX_REG_CNT		128
+
+/*STATUS REGISTERS*/
+#define DA9052_STATUS_A_REG		1
+#define DA9052_STATUS_B_REG		2
+#define DA9052_STATUS_C_REG		3
+#define DA9052_STATUS_D_REG		4
+
+/*EVENT REGISTERS*/
+#define DA9052_EVENT_A_REG		5
+#define DA9052_EVENT_B_REG		6
+#define DA9052_EVENT_C_REG		7
+#define DA9052_EVENT_D_REG		8
+#define DA9052_FAULTLOG_REG		9
+
+/*IRQ REGISTERS*/
+#define DA9052_IRQ_MASK_A_REG		10
+#define DA9052_IRQ_MASK_B_REG		11
+#define DA9052_IRQ_MASK_C_REG		12
+#define DA9052_IRQ_MASK_D_REG		13
+
+/*CONTROL REGISTERS*/
+#define DA9052_CONTROL_A_REG		14
+#define DA9052_CONTROL_B_REG		15
+#define DA9052_CONTROL_C_REG		16
+#define DA9052_CONTROL_D_REG		17
+
+#define DA9052_PDDIS_REG		18
+#define DA9052_INTERFACE_REG		19
+#define DA9052_RESET_REG		20
+
+/*GPIO REGISTERS*/
+#define DA9052_GPIO_0_1_REG		21
+#define DA9052_GPIO_2_3_REG		22
+#define DA9052_GPIO_4_5_REG		23
+#define DA9052_GPIO_6_7_REG		24
+#define DA9052_GPIO_14_15_REG		28
+
+/*LDO AND BUCK REGISTERS*/
+#define DA9052_BUCKA_REG		44
+#define DA9052_BUCKB_REG		45
+#define DA9052_BUCKCORE_REG		46
+#define DA9052_BUCKPRO_REG		47
+#define DA9052_BUCKMEM_REG		48
+#define DA9052_BUCKPERI_REG		49
+#define DA9052_LDO1_REG		50
+#define DA9052_LDO2_REG		51
+#define DA9052_LDO3_REG		52
+#define DA9052_LDO4_REG		53
+#define DA9052_LDO5_REG		54
+#define DA9052_LDO6_REG		55
+#define DA9052_LDO7_REG		56
+#define DA9052_LDO8_REG		57
+#define DA9052_LDO9_REG		58
+#define DA9052_LDO10_REG		59
+#define DA9052_SUPPLY_REG		60
+#define DA9052_PULLDOWN_REG		61
+#define DA9052_CHGBUCK_REG		62
+#define DA9052_WAITCONT_REG		63
+#define DA9052_ISET_REG		64
+#define DA9052_BATCHG_REG		65
+
+/*BATTERY CONTROL REGISTRS*/
+#define DA9052_CHG_CONT_REG		66
+#define DA9052_INPUT_CONT_REG		67
+#define DA9052_CHG_TIME_REG		68
+#define DA9052_BBAT_CONT_REG		69
+
+/*LED CONTROL REGISTERS*/
+#define DA9052_BOOST_REG		70
+#define DA9052_LED_CONT_REG		71
+#define DA9052_LEDMIN123_REG		72
+#define DA9052_LED1_CONF_REG		73
+#define DA9052_LED2_CONF_REG		74
+#define DA9052_LED3_CONF_REG		75
+#define DA9052_LED1CONT_REG		76
+#define DA9052_LED2CONT_REG		77
+#define DA9052_LED3CONT_REG		78
+#define DA9052_LED_CONT_4_REG		79
+#define DA9052_LED_CONT_5_REG		80
+
+/*ADC CONTROL REGISTERS*/
+#define DA9052_ADC_MAN_REG		81
+#define DA9052_ADC_CONT_REG		82
+#define DA9052_ADC_RES_L_REG		83
+#define DA9052_ADC_RES_H_REG		84
+#define DA9052_VDD_RES_REG		85
+#define DA9052_VDD_MON_REG		86
+
+/*SM CONTROL REGISTERS*/
+#define DA9052_ICHG_AV_REG		87
+#define DA9052_ICHG_THD_REG		88
+#define DA9052_ICHG_END_REG		89
+#define DA9052_TBAT_RES_REG		90
+#define DA9052_TBAT_HIGHP_REG		91
+#define DA9052_TBAT_HIGHIN_REG		92
+#define DA9052_TBAT_LOW_REG		93
+#define DA9052_T_OFFSET_REG		94
+
+/*TSI CONTROL REGISTERS*/
+#define DA9052_TJUNC_RES_REG		104
+#define DA9052_TSI_CONT_A_REG		105
+#define DA9052_TSI_CONT_B_REG		106
+#define DA9052_TSI_X_MSB_REG		107
+#define DA9052_TSI_Y_MSB_REG		108
+#define DA9052_TSI_LSB_REG		109
+#define DA9052_TSI_Z_MSB_REG		110
+
+/*RTC COUNT REGISTERS*/
+#define DA9052_COUNT_S_REG		111
+#define DA9052_COUNT_MI_REG		112
+#define DA9052_COUNT_H_REG		113
+#define DA9052_COUNT_D_REG		114
+#define DA9052_COUNT_MO_REG		115
+#define DA9052_COUNT_Y_REG		116
+
+/*RTC CONTROL REGISTERS*/
+#define DA9052_ALARM_MI_REG		117
+#define DA9052_ALARM_H_REG		118
+#define DA9052_ALARM_D_REG		119
+#define DA9052_ALARM_MO_REG		120
+#define DA9052_ALARM_Y_REG		121
+
+/* Reg Page Configuration */
+#define DA9052_PAGECON0_REGPAGE	0x80
+
+/* Onkey Event Registers */
+#define DA9052_M_nONKEY		0x0100
+#define DA9052_E_nONKEY		0x01
+
+/* TSI Event Registers */
+#define DA9052_E_PEN_DOWN		0x4000
+#define DA9052_E_TSI_READY		0x8000
+
+/* PAGE CONFIGURATION 128 REGISTER */
+#define DA9052_PAGECON128_REGPAGE	0x80
+
+/* STATUS REGISTER A */
+#define DA9052_STATUSA_VDATDET		0x80
+#define DA9052_STATUSA_VBUSSEL		0x40
+#define DA9052_STATUSA_DCINSEL		0x20
+#define DA9052_STATUSA_VBUSDET		0x10
+#define DA9052_STATUSA_DCINDET		0x08
+#define DA9052_STATUSA_IDGND		0x04
+#define DA9052_STATUSA_IDFLOAT		0x02
+#define DA9052_STATUSA_NONKEY		0x01
+
+/* STATUS REGISTER B */
+#define DA9052_STATUSB_COMPDET		0x80
+#define DA9052_STATUSB_SEQUENCING	0x40
+#define DA9052_STATUSB_GPFB2		0x20
+#define DA9052_STATUSB_CHGTO		0x10
+#define DA9052_STATUSB_CHGEND		0x08
+#define DA9052_STATUSB_CHGLIM		0x04
+#define DA9052_STATUSB_CHGPRE		0x02
+#define DA9052_STATUSB_CHGATT		0x01
+
+/* STATUS REGISTER C */
+#define DA9052_STATUSC_GPI7		0x80
+#define DA9052_STATUSC_GPI6		0x40
+#define DA9052_STATUSC_GPI5		0x20
+#define DA9052_STATUSC_GPI4		0x10
+#define DA9052_STATUSC_GPI3		0x08
+#define DA9052_STATUSC_GPI2		0x04
+#define DA9052_STATUSC_GPI1		0x02
+#define DA9052_STATUSC_GPI0		0x01
+
+/* STATUS REGISTER D */
+#define DA9052_STATUSD_GPI15		0x80
+#define DA9052_STATUSD_GPI14		0x40
+#define DA9052_STATUSD_GPI13		0x20
+#define DA9052_STATUSD_GPI12		0x10
+#define DA9052_STATUSD_GPI11		0x08
+#define DA9052_STATUSD_GPI10		0x04
+#define DA9052_STATUSD_GPI9		0x02
+#define DA9052_STATUSD_GPI8		0x01
+
+/* EVENT REGISTER A */
+#define DA9052_EVENTA_ECOMP1V2		0x80
+#define DA9052_EVENTA_ESEQRDY		0x40
+#define DA9052_EVENTA_EALRAM		0x20
+#define DA9052_EVENTA_EVDDLOW		0x10
+#define DA9052_EVENTA_EVBUSREM		0x08
+#define DA9052_EVENTA_EDCINREM		0x04
+#define DA9052_EVENTA_EVBUSDET		0x02
+#define DA9052_EVENTA_EDCINDET		0x01
+
+/* EVENT REGISTER B */
+#define DA9052_EVENTB_ETSIREADY	0x80
+#define DA9052_EVENTB_EPENDOWN		0x40
+#define DA9052_EVENTB_EADCEOM		0x20
+#define DA9052_EVENTB_ETBAT		0x10
+#define DA9052_EVENTB_ECHGEND		0x08
+#define DA9052_EVENTB_EIDGND		0x04
+#define DA9052_EVENTB_EIDFLOAT		0x02
+#define DA9052_EVENTB_ENONKEY		0x01
+
+/* EVENT REGISTER C */
+#define DA9052_EVENTC_EGPI7		0x80
+#define DA9052_EVENTC_EGPI6		0x40
+#define DA9052_EVENTC_EGPI5		0x20
+#define DA9052_EVENTC_EGPI4		0x10
+#define DA9052_EVENTC_EGPI3		0x08
+#define DA9052_EVENTC_EGPI2		0x04
+#define DA9052_EVENTC_EGPI1		0x02
+#define DA9052_EVENTC_EGPI0		0x01
+
+/* EVENT REGISTER D */
+#define DA9052_EVENTD_EGPI15		0x80
+#define DA9052_EVENTD_EGPI14		0x40
+#define DA9052_EVENTD_EGPI13		0x20
+#define DA9052_EVENTD_EGPI12		0x10
+#define DA9052_EVENTD_EGPI11		0x08
+#define DA9052_EVENTD_EGPI10		0x04
+#define DA9052_EVENTD_EGPI9		0x02
+#define DA9052_EVENTD_EGPI8		0x01
+
+/* FAULT LOG REGISTER */
+#define DA9052_FAULTLOG_WAITSET	0x80
+#define DA9052_FAULTLOG_NSDSET		0x40
+#define DA9052_FAULTLOG_KEYSHUT	0x20
+#define DA9052_FAULTLOG_TEMPOVER	0x08
+#define DA9052_FAULTLOG_VDDSTART	0x04
+#define DA9052_FAULTLOG_VDDFAULT	0x02
+#define DA9052_FAULTLOG_TWDERROR	0x01
+
+/* CONTROL REGISTER A */
+#define DA9052_CONTROLA_GPIV		0x80
+#define DA9052_CONTROLA_PMOTYPE	0x20
+#define DA9052_CONTROLA_PMOV		0x10
+#define DA9052_CONTROLA_PMIV		0x08
+#define DA9052_CONTROLA_PMIFV		0x08
+#define DA9052_CONTROLA_PWR1EN		0x04
+#define DA9052_CONTROLA_PWREN		0x02
+#define DA9052_CONTROLA_SYSEN		0x01
+
+/* CONTROL REGISTER B */
+#define DA9052_CONTROLB_SHUTDOWN	0x80
+#define DA9052_CONTROLB_DEEPSLEEP	0x40
+#define DA9052_CONTROL_B_WRITEMODE	0x20
+#define DA9052_CONTROLB_BBATEN		0x10
+#define DA9052_CONTROLB_OTPREADEN	0x08
+#define DA9052_CONTROLB_AUTOBOOT	0x04
+#define DA9052_CONTROLB_ACTDIODE	0x02
+#define DA9052_CONTROLB_BUCKMERGE	0x01
+
+/* CONTROL REGISTER C */
+#define DA9052_CONTROLC_BLINKDUR	0x80
+#define DA9052_CONTROLC_BLINKFRQ	0x60
+#define DA9052_CONTROLC_DEBOUNCING	0x1C
+#define DA9052_CONTROLC_PMFB2PIN	0x02
+#define DA9052_CONTROLC_PMFB1PIN	0x01
+
+/* CONTROL REGISTER D */
+#define DA9052_CONTROLD_WATCHDOG	0x80
+#define DA9052_CONTROLD_ACCDETEN	0x40
+#define DA9052_CONTROLD_GPI1415SD	0x20
+#define DA9052_CONTROLD_NONKEYSD	0x10
+#define DA9052_CONTROLD_KEEPACTEN	0x08
+#define DA9052_CONTROLD_TWDSCALE	0x07
+/* POWER DOWN DISABLE REGISTER */
+#define DA9052_PDDIS_PMCONTPD		0x80
+#define DA9052_PDDIS_OUT32KPD		0x40
+#define DA9052_PDDIS_CHGBBATPD		0x20
+#define DA9052_PDDIS_CHGPD		0x10
+#define DA9052_PDDIS_HS2WIREPD		0x08
+#define DA9052_PDDIS_PMIFPD		0x04
+#define DA9052_PDDIS_GPADCPD		0x02
+#define DA9052_PDDIS_GPIOPD		0x01
+
+/* CONTROL REGISTER D */
+#define DA9052_INTERFACE_IFBASEADDR	0xE0
+#define DA9052_INTERFACE_NCSPOL	0x10
+#define DA9052_INTERFACE_RWPOL		0x08
+#define DA9052_INTERFACE_CPHA		0x04
+#define DA9052_INTERFACE_CPOL		0x02
+#define DA9052_INTERFACE_IFTYPE	0x01
+
+/* CONTROL REGISTER D */
+#define DA9052_RESET_RESETEVENT	0xC0
+#define DA9052_RESET_RESETTIMER	0x3F
+
+/* GPIO REGISTERS */
+
+/* GPIO control register */
+#define DA9052_GPIO_EVEN_PORT_PIN	0x03
+#define DA9052_GPIO_EVEN_PORT_TYPE	0x04
+#define DA9052_GPIO_EVEN_PORT_MODE	0x08
+
+#define DA9052_GPIO_ODD_PORT_PIN	0x30
+#define DA9052_GPIO_ODD_PORT_TYPE	0x40
+#define DA9052_GPIO_ODD_PORT_MODE	0x80
+
+/*POWER SEQUENCER REGISTER*/
+
+/* SEQ control register for ID 0 and 1 */
+#define DA9052_ID01_LDO1STEP		0xF0
+#define DA9052_ID01_SYSPRE		0x04
+#define DA9052_ID01_DEFSUPPLY		0x02
+#define DA9052_ID01_nRESMODE		0x01
+
+/* SEQ control register for ID 2 and 3 */
+#define DA9052_ID23_LDO3STEP		0xF0
+#define DA9052_ID23_LDO2STEP		0x0F
+
+/* SEQ control register for ID 4 and 5 */
+#define DA9052_ID45_LDO5STEP		0xF0
+#define DA9052_ID45_LDO4STEP		0x0F
+
+/* SEQ control register for ID 6 and 7 */
+#define DA9052_ID67_LDO7STEP		0xF0
+#define DA9052_ID67_LDO6STEP		0x0F
+
+/* SEQ control register for ID 8 and 9 */
+#define DA9052_ID89_LDO9STEP		0xF0
+#define DA9052_ID89_LDO8STEP		0x0F
+
+/* SEQ control register for ID 10 and 11 */
+#define DA9052_ID1011_PDDISSTEP	0xF0
+#define DA9052_ID1011_LDO10STEP	0x0F
+
+/* SEQ control register for ID 12 and 13 */
+#define DA9052_ID1213_VMEMSWSTEP	0xF0
+#define DA9052_ID1213_VPERISWSTEP	0x0F
+
+/* SEQ control register for ID 14 and 15 */
+#define DA9052_ID1415_BUCKPROSTEP	0xF0
+#define DA9052_ID1415_BUCKCORESTEP	0x0F
+
+/* SEQ control register for ID 16 and 17 */
+#define DA9052_ID1617_BUCKPERISTEP	0xF0
+#define DA9052_ID1617_BUCKMEMSTEP	0x0F
+
+/* SEQ control register for ID 18 and 19 */
+#define DA9052_ID1819_GPRISE2STEP	0xF0
+#define DA9052_ID1819_GPRISE1STEP	0x0F
+
+/* SEQ control register for ID 20 and 21 */
+#define DA9052_ID2021_GPFALL2STEP	0xF0
+#define DA9052_ID2021_GPFALL1STEP	0x0F
+
+/* Power SEQ Status register */
+#define DA9052_SEQSTATUS_SEQPOINTER	0xF0
+#define DA9052_SEQSTATUS_WAITSTEP	0x0F
+
+/* Power SEQ A register */
+#define DA9052_SEQA_POWEREND		0xF0
+#define DA9052_SEQA_SYSTEMEND		0x0F
+
+/* Power SEQ B register */
+#define DA9052_SEQB_PARTDOWN		0xF0
+#define DA9052_SEQB_MAXCOUNT		0x0F
+
+/* Power SEQ TIMER register */
+#define DA9052_SEQTIMER_SEQDUMMY	0xF0
+#define DA9052_SEQTIMER_SEQTIME	0x0F
+
+/*POWER SUPPLY CONTROL REGISTER*/
+
+/* BUCK REGISTER A */
+#define DA9052_BUCKA_BPROILIM		0xC0
+#define DA9052_BUCKA_BPROMODE		0x30
+#define DA9052_BUCKA_BCOREILIM		0x0C
+#define DA9052_BUCKA_BCOREMODE		0x03
+
+/* BUCK REGISTER B */
+#define DA9052_BUCKB_BERIILIM		0xC0
+#define DA9052_BUCKB_BPERIMODE		0x30
+#define DA9052_BUCKB_BMEMILIM		0x0C
+#define DA9052_BUCKB_BMEMMODE		0x03
+
+/* BUCKCORE REGISTER */
+#define DA9052_BUCKCORE_BCORECONF	0x80
+#define DA9052_BUCKCORE_BCOREEN	0x40
+#define DA9052_BUCKCORE_VBCORE		0x3F
+
+/* BUCKPRO REGISTER */
+#define DA9052_BUCKPRO_BPROCONF	0x80
+#define DA9052_BUCKPRO_BPROEN		0x40
+#define DA9052_BUCKPRO_VBPRO		0x3F
+
+/* BUCKMEM REGISTER */
+#define DA9052_BUCKMEM_BMEMCONF	0x80
+#define DA9052_BUCKMEM_BMEMEN		0x40
+#define DA9052_BUCKMEM_VBMEM		0x3F
+
+/* BUCKPERI REGISTER */
+#define DA9052_BUCKPERI_BPERICONF	0x80
+#define DA9052_BUCKPERI_BPERIEN	0x40
+#define DA9052_BUCKPERI_BPERIHS	0x20
+#define DA9052_BUCKPERI_VBPERI		0x1F
+
+/* LDO1 REGISTER */
+#define DA9052_LDO1_LDO1CONF		0x80
+#define DA9052_LDO1_LDO1EN		0x40
+#define DA9052_LDO1_VLDO1		0x1F
+
+/* LDO2 REGISTER */
+#define DA9052_LDO2_LDO2CONF		0x80
+#define DA9052_LDO2_LDO2EN		0x40
+#define DA9052_LDO2_VLDO2		0x3F
+
+/* LDO3 REGISTER */
+#define DA9052_LDO3_LDO3CONF		0x80
+#define DA9052_LDO3_LDO3EN		0x40
+#define DA9052_LDO3_VLDO3		0x3F
+
+/* LDO4 REGISTER */
+#define DA9052_LDO4_LDO4CONF		0x80
+#define DA9052_LDO4_LDO4EN		0x40
+#define DA9052_LDO4_VLDO4		0x3F
+
+/* LDO5 REGISTER */
+#define DA9052_LDO5_LDO5CONF		0x80
+#define DA9052_LDO5_LDO5EN		0x40
+#define DA9052_LDO5_VLDO5		0x3F
+
+/* LDO6 REGISTER */
+#define DA9052_LDO6_LDO6CONF		0x80
+#define DA9052_LDO6_LDO6EN		0x40
+#define DA9052_LDO6_VLDO6		0x3F
+
+/* LDO7 REGISTER */
+#define DA9052_LDO7_LDO7CONF		0x80
+#define DA9052_LDO7_LDO7EN		0x40
+#define DA9052_LDO7_VLDO7		0x3F
+
+/* LDO8 REGISTER */
+#define DA9052_LDO8_LDO8CONF		0x80
+#define DA9052_LDO8_LDO8EN		0x40
+#define DA9052_LDO8_VLDO8		0x3F
+
+/* LDO9 REGISTER */
+#define DA9052_LDO9_LDO9CONF		0x80
+#define DA9052_LDO9_LDO9EN		0x40
+#define DA9052_LDO9_VLDO9		0x3F
+
+/* LDO10 REGISTER */
+#define DA9052_LDO10_LDO10CONF		0x80
+#define DA9052_LDO10_LDO10EN		0x40
+#define DA9052_LDO10_VLDO10		0x3F
+
+/* SUPPLY REGISTER */
+#define DA9052_SUPPLY_VLOCK		0x80
+#define DA9052_SUPPLY_VMEMSWEN		0x40
+#define DA9052_SUPPLY_VPERISWEN	0x20
+#define DA9052_SUPPLY_VLDO3GO		0x10
+#define DA9052_SUPPLY_VLDO2GO		0x08
+#define DA9052_SUPPLY_VBMEMGO		0x04
+#define DA9052_SUPPLY_VBPROGO		0x02
+#define DA9052_SUPPLY_VBCOREGO		0x01
+
+/* PULLDOWN REGISTER */
+#define DA9052_PULLDOWN_LDO5PDDIS	0x20
+#define DA9052_PULLDOWN_LDO2PDDIS	0x10
+#define DA9052_PULLDOWN_LDO1PDDIS	0x08
+#define DA9052_PULLDOWN_MEMPDDIS	0x04
+#define DA9052_PULLDOWN_PROPDDIS	0x02
+#define DA9052_PULLDOWN_COREPDDIS	0x01
+
+/* BAT CHARGER REGISTER */
+
+/* CHARGER BUCK REGISTER */
+#define DA9052_CHGBUCK_CHGTEMP		0x80
+#define DA9052_CHGBUCK_CHGUSBILIM	0x40
+#define DA9052_CHGBUCK_CHGBUCKLP	0x20
+#define DA9052_CHGBUCK_CHGBUCKEN	0x10
+#define DA9052_CHGBUCK_ISETBUCK	0x0F
+
+/* WAIT COUNTER REGISTER */
+#define DA9052_WAITCONT_WAITDIR	0x80
+#define DA9052_WAITCONT_RTCCLOCK	0x40
+#define DA9052_WAITCONT_WAITMODE	0x20
+#define DA9052_WAITCONT_EN32KOUT	0x10
+#define DA9052_WAITCONT_DELAYTIME	0x0F
+
+/* ISET CONTROL REGISTER */
+#define DA9052_ISET_ISETDCIN		0xF0
+#define DA9052_ISET_ISETVBUS		0x0F
+
+/* BATTERY CHARGER CONTROL REGISTER */
+#define DA9052_BATCHG_ICHGPRE		0xC0
+#define DA9052_BATCHG_ICHGBAT		0x3F
+
+/* CHARGER COUNTER REGISTER */
+#define DA9052_CHG_CONT_VCHG_BAT	0xF8
+#define DA9052_CHG_CONT_TCTR		0x07
+
+/* INPUT CONTROL REGISTER */
+#define DA9052_INPUT_CONT_TCTR_MODE	0x80
+#define DA9052_INPUT_CONT_VBUS_SUSP	0x10
+#define DA9052_INPUT_CONT_DCIN_SUSP	0x08
+
+/* CHARGING TIME REGISTER */
+#define DA9052_CHGTIME_CHGTIME		0xFF
+
+/* BACKUP BATTERY CONTROL REGISTER */
+#define DA9052_BBATCONT_BCHARGERISET	0xF0
+#define DA9052_BBATCONT_BCHARGERVSET	0x0F
+
+/* LED REGISTERS */
+/* LED BOOST REGISTER */
+#define DA9052_BOOST_EBFAULT		0x80
+#define DA9052_BOOST_MBFAULT		0x40
+#define DA9052_BOOST_BOOSTFRQ		0x20
+#define DA9052_BOOST_BOOSTILIM		0x10
+#define DA9052_BOOST_LED3INEN		0x08
+#define DA9052_BOOST_LED2INEN		0x04
+#define DA9052_BOOST_LED1INEN		0x02
+#define DA9052_BOOST_BOOSTEN		0x01
+
+/* LED CONTROL REGISTER */
+#define DA9052_LEDCONT_SELLEDMODE	0x80
+#define DA9052_LEDCONT_LED3ICONT	0x40
+#define DA9052_LEDCONT_LED3RAMP	0x20
+#define DA9052_LEDCONT_LED3EN		0x10
+#define DA9052_LEDCONT_LED2RAMP	0x08
+#define DA9052_LEDCONT_LED2EN		0x04
+#define DA9052_LEDCONT_LED1RAMP	0x02
+#define DA9052_LEDCONT_LED1EN		0x01
+
+/* LEDMIN123  REGISTER */
+#define DA9052_LEDMIN123_LEDMINCURRENT	0xFF
+
+/* LED1CONF  REGISTER */
+#define DA9052_LED1CONF_LED1CURRENT	0xFF
+
+/* LED2CONF  REGISTER */
+#define DA9052_LED2CONF_LED2CURRENT	0xFF
+
+/* LED3CONF  REGISTER */
+#define DA9052_LED3CONF_LED3CURRENT	0xFF
+
+/* LED COUNT  REGISTER */
+#define DA9052_LED_CONT_DIM		0x80
+
+/* ADC MAN registers */
+#define DA9052_ADC_MAN_MAN_CONV	0x10
+#define DA9052_ADC_MAN_MUXSEL_VDDOUT	0x0
+#define DA9052_ADC_MAN_MUXSEL_ICH	0x01
+#define DA9052_ADC_MAN_MUXSEL_TBAT	0x02
+#define DA9052_ADC_MAN_MUXSEL_VBAT	0x03
+#define DA9052_ADC_MAN_MUXSEL_AD4	0x04
+#define DA9052_ADC_MAN_MUXSEL_AD5	0x05
+#define DA9052_ADC_MAN_MUXSEL_AD6	0x06
+#define DA9052_ADC_MAN_MUXSEL_VBBAT	0x09
+
+/* ADC CONTROL regsisters */
+#define DA9052_ADCCONT_COMP1V2EN	0x80
+#define DA9052_ADCCONT_ADCMODE		0x40
+#define DA9052_ADCCONT_TBATISRCEN	0x20
+#define DA9052_ADCCONT_AD4ISRCEN	0x10
+#define DA9052_ADCCONT_AUTOAD6EN	0x08
+#define DA9052_ADCCONT_AUTOAD5EN	0x04
+#define DA9052_ADCCONT_AUTOAD4EN	0x02
+#define DA9052_ADCCONT_AUTOVDDEN	0x01
+
+/* ADC 10 BIT MANUAL CONVERSION RESULT LOW register */
+#define DA9052_ADC_RES_LSB		0x03
+
+/* ADC 10 BIT MANUAL CONVERSION RESULT HIGH register */
+#define DA9052_ADCRESH_ADCRESMSB	0xFF
+
+/* VDD RES regsister*/
+#define DA9052_VDDRES_VDDOUTRES	0xFF
+
+/* VDD MON regsister*/
+#define DA9052_VDDMON_VDDOUTMON	0xFF
+
+/* ICHG_AV regsister*/
+#define DA9052_ICHGAV_ICHGAV		0xFF
+
+/* ICHG_THD regsister*/
+#define DA9052_ICHGTHD_ICHGTHD		0xFF
+
+/* ICHG_END regsister*/
+#define DA9052_ICHGEND_ICHGEND		0xFF
+
+/* TBAT_RES regsister*/
+#define DA9052_TBATRES_TBATRES		0xFF
+
+/* TBAT_HIGHP regsister*/
+#define DA9052_TBATHIGHP_TBATHIGHP	0xFF
+
+/* TBAT_HIGHN regsister*/
+#define DA9052_TBATHIGHN_TBATHIGHN	0xFF
+
+/* TBAT_LOW regsister*/
+#define DA9052_TBATLOW_TBATLOW		0xFF
+
+/* T_OFFSET regsister*/
+#define DA9052_TOFFSET_TOFFSET		0xFF
+
+/* ADCIN4_RES regsister*/
+#define DA9052_ADCIN4RES_ADCIN4RES	0xFF
+
+/* ADCIN4_HIGH regsister*/
+#define DA9052_AUTO4HIGH_AUTO4HIGH	0xFF
+
+/* ADCIN4_LOW regsister*/
+#define DA9052_AUTO4LOW_AUTO4LOW	0xFF
+
+/* ADCIN5_RES regsister*/
+#define DA9052_ADCIN5RES_ADCIN5RES	0xFF
+
+/* ADCIN5_HIGH regsister*/
+#define DA9052_AUTO5HIGH_AUTOHIGH	0xFF
+
+/* ADCIN5_LOW regsister*/
+#define DA9052_AUTO5LOW_AUTO5LOW	0xFF
+
+/* ADCIN6_RES regsister*/
+#define DA9052_ADCIN6RES_ADCIN6RES	0xFF
+
+/* ADCIN6_HIGH regsister*/
+#define DA9052_AUTO6HIGH_AUTO6HIGH	0xFF
+
+/* ADCIN6_LOW regsister*/
+#define DA9052_AUTO6LOW_AUTO6LOW	0xFF
+
+/* TJUNC_RES regsister*/
+#define DA9052_TJUNCRES_TJUNCRES	0xFF
+
+/* TSI REGISTER */
+
+/* TSI Control Register A */
+#define DA9052_TSICONTA_TSIDELAY	0xC0
+#define DA9052_TSICONTA_TSISKIP	0x38
+#define DA9052_TSICONTA_TSIMODE	0x04
+#define DA9052_TSICONTA_PENDETEN	0x02
+#define DA9052_TSICONTA_AUTOTSIEN	0x01
+
+/* TSI Control Register B */
+#define DA9052_TSICONTB_ADCREF		0x80
+#define DA9052_TSICONTB_TSIMAN		0x40
+#define DA9052_TSICONTB_TSIMUX		0x30
+#define DA9052_TSICONTB_TSISEL3	0x08
+#define DA9052_TSICONTB_TSISEL2	0x04
+#define DA9052_TSICONTB_TSISEL1	0x02
+#define DA9052_TSICONTB_TSISEL0	0x01
+
+/* TSI X Co-ordinate MSB Result register */
+#define DA9052_TSIXMSB_TSIXM		0xFF
+
+/* TSI Y Co-ordinate MSB Result register */
+#define DA9052_TSIYMSB_TSIYM		0xFF
+
+/* TSI Co-ordinate LSB Result register */
+#define DA9052_TSILSB_PENDOWN		0x40
+#define DA9052_TSILSB_TSIZL		0x30
+#define DA9052_TSILSB_TSIYL		0x0C
+#define DA9052_TSILSB_TSIXL		0x03
+
+/* TSI Z Measurement MSB Result register */
+#define DA9052_TSIZMSB_TSIZM		0xFF
+
+/* RTC REGISTER */
+
+/* RTC TIMER SECONDS REGISTER */
+#define DA9052_COUNTS_MONITOR		0x40
+#define DA9052_RTC_SEC			0x3F
+
+/* RTC TIMER MINUTES REGISTER */
+#define DA9052_RTC_MIN			0x3F
+
+/* RTC TIMER HOUR REGISTER */
+#define DA9052_RTC_HOUR		0x1F
+
+/* RTC TIMER DAYS REGISTER */
+#define DA9052_RTC_DAY			0x1F
+
+/* RTC TIMER MONTHS REGISTER */
+#define DA9052_RTC_MONTH		0x0F
+
+/* RTC TIMER YEARS REGISTER */
+#define DA9052_RTC_YEAR		0x3F
+
+/* RTC ALARM MINUTES REGISTER */
+#define DA9052_ALARMM_I_TICK_TYPE	0x80
+#define DA9052_ALARMMI_ALARMTYPE	0x40
+
+/* RTC ALARM YEARS REGISTER */
+#define DA9052_ALARM_Y_TICK_ON		0x80
+#define DA9052_ALARM_Y_ALARM_ON	0x40
+
+/* RTC SECONDS REGISTER  A*/
+#define DA9052_SECONDA_SECONDSA	0xFF
+
+/* RTC SECONDS REGISTER  B*/
+#define DA9052_SECONDB_SECONDSB	0xFF
+
+/* RTC SECONDS REGISTER  C*/
+#define DA9052_SECONDC_SECONDSC	0xFF
+
+/* RTC SECONDS REGISTER  D*/
+#define DA9052_SECONDD_SECONDSD	0xFF
+
+/* OTP REGISTER */
+
+/* CHIP IDENTIFICATION REGISTER */
+#define DA9052_CHIPID_MRC		0xF0
+#define DA9052_CHIPID_TRC		0x0F
+
+/* CONFIGURATION IDENTIFICATION REGISTER */
+#define DA9052_CONFIGID_CUSTOMERID	0xF8
+#define DA9052_CONFIGID_CONFID		0x07
+
+/* OTP CONTROL REGISTER */
+#define DA9052_OTPCONT_GPWRITEDIS	0x80
+#define DA9052_OTPCONT_OTPCONFLOCK	0x40
+#define DA9052_OTPCONT_OTPGPLOCK	0x20
+#define DA9052_OTPCONT_OTPCONFG	0x08
+#define DA9052_OTPCONT_OTPGP		0x04
+#define DA9052_OTPCONT_OTPRP		0x02
+#define DA9052_OTPCONT_OTPTRANSFER	0x01
+
+/* RTC OSCILLATOR TRIM REGISTER */
+#define DA9052_OSCTRIM_TRIM32K		0xFF
+
+/* GP ID REGISTER 0 */
+#define DA9052_GPID0_GP0		0xFF
+
+/* GP ID REGISTER 1 */
+#define DA9052_GPID1_GP1		0xFF
+
+/* GP ID REGISTER 2 */
+#define DA9052_GPID2_GP2		0xFF
+
+/* GP ID REGISTER 3 */
+#define DA9052_GPID3_GP3		0xFF
+
+/* GP ID REGISTER 4 */
+#define DA9052_GPID4_GP4		0xFF
+
+/* GP ID REGISTER 5 */
+#define DA9052_GPID5_GP5		0xFF
+
+/* GP ID REGISTER 6 */
+#define DA9052_GPID6_GP6		0xFF
+
+/* GP ID REGISTER 7 */
+#define DA9052_GPID7_GP7		0xFF
+
+/* GP ID REGISTER 8 */
+#define DA9052_GPID8_GP8		0xFF
+
+/* GP ID REGISTER 9 */
+#define DA9052_GPID9_GP9		0xFF
+
+#endif
+/* __LINUX_MFD_DA9052_REG_H */


