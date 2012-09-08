Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2IHKwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 06:52:41 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:34685 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133Ab2IHKwi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 06:52:38 -0400
From: Yunfan Zhang <yfzhang@marvell.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 8 Sep 2012 03:52:18 -0700
Subject: [PATCH v2] regulator: Fairchild fan53555 support
Thread-Topic: [PATCH v2] regulator: Fairchild fan53555 support
Thread-Index: Ac2NsAPo79I2BMepSxmFvQS3d8sfdg==
Message-ID: <4737A960563B524DA805CA602BE04B3064CC590645@SC-VEXCH2.marvell.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: PVk= 4wY= ++I= BCJd B/09 FIRY GorA I4SR JqM+ NZjR OHRu
 PIaq Rvuz SXa4 UK25
 Wi/n;2;YgByAG8AbwBuAGkAZQBAAG8AcABlAG4AcwBvAHUAcgBjAGUALgB3AG8AbABmAHMAbwBuAG0AaQBjAHIAbwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{FDE37B06-5F80-4938-908C-F907FA5E5EA4};eQBmAHoAaABhAG4AZwBAAG0AYQByAHYAZQBsAGwALgBjAG8AbQA=;Sat,
 08 Sep 2012 10:52:18
 GMT;WwBQAEEAVABDAEgAIAB2ADIAXQAgAHIAZQBnAHUAbABhAHQAbwByADoAIABGAGEAaQByAGMAaABpAGwAZAAgAGYAYQBuADUAMwA1ADUANQAgAHMAdQBwAHAAbwByAHQA
x-cr-puzzleid: {FDE37B06-5F80-4938-908C-F907FA5E5EA4}
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports Fairchild FAN53555 Digitally Programmable
TinyBuck Regulator. The FAN53555 is a step-down switching voltage
regulator that delivers a digitally programmable output from an
input voltage supply of 2.5V to 5.5V. The output voltage is
programmed through an I2C interface.

Signed-off-by: Yunfan Zhang <yfzhang@marvell.com>
---
 drivers/regulator/Kconfig          |   11 ++
 drivers/regulator/Makefile         |    1 +
 drivers/regulator/fan53555.c       |  325 ++++++++++++++++++++++++++++++++++++
 include/linux/regulator/fan53555.h |   60 +++++++
 4 files changed, 397 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/fan53555.c
 create mode 100644 include/linux/regulator/fan53555.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 129c827..e98a5e7 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -109,6 +109,17 @@ config REGULATOR_DA9052
 	  This driver supports the voltage regulators of DA9052-BC and
 	  DA9053-AA/Bx PMIC.
 
+config REGULATOR_FAN53555
+	tristate "Fairchild FAN53555 Regulator"
+	depends on I2C
+	select REGMAP_I2C
+	help
+	  This driver supports Fairchild FAN53555 Digitally Programmable
+	  TinyBuck Regulator. The FAN53555 is a step-down switching voltage
+	  regulator that delivers a digitally programmable output from an
+	  input voltage supply of 2.5V to 5.5V. The output voltage is
+	  programmed through an I2C interface.
+
 config REGULATOR_ANATOP
 	tristate "Freescale i.MX on-chip ANATOP LDO regulators"
 	depends on MFD_ANATOP
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 3a0dbc5..e431eed 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
 obj-$(CONFIG_REGULATOR_DBX500_PRCMU) += dbx500-prcmu.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
+obj-$(CONFIG_REGULATOR_FAN53555) += fan53555.o
 obj-$(CONFIG_REGULATOR_GPIO) += gpio-regulator.o
 obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
new file mode 100644
index 0000000..890f2b3
--- /dev/null
+++ b/drivers/regulator/fan53555.c
@@ -0,0 +1,325 @@
+/*
+ * FAN53555 Fairchild Digitally Programmable TinyBuck Regulator Driver.
+ *
+ * Supported Part Numbers:
+ * FAN53555UC00X/01X/03X/04X/05X
+ *
+ * Copyright (c) 2012 Marvell Technology Ltd.
+ * Yunfan Zhang <yfzhang@marvell.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/module.h>
+#include <linux/param.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/regmap.h>
+#include <linux/regulator/fan53555.h>
+
+/* Voltage setting */
+#define FAN53555_VSEL0		0x00
+#define FAN53555_VSEL1		0x01
+/* Control register */
+#define FAN53555_CONTROL	0x02
+/* IC Type */
+#define FAN53555_ID1		0x03
+/* IC mask version */
+#define FAN53555_ID2		0x04
+/* Monitor register */
+#define FAN53555_MONITOR	0x05
+
+/* VSEL bit definitions */
+#define VSEL_BUCK_EN	(1 << 7)
+#define VSEL_MODE		(1 << 6)
+#define VSEL_NSEL_MASK	0x3F
+/* Chip ID and Verison */
+#define DIE_ID		0x0F	/* ID1 */
+#define DIE_REV		0x0F	/* ID2 */
+/* Control bit definitions */
+#define CTL_OUTPUT_DISCHG	(1 << 7)
+#define CTL_SLEW_MASK		(0x7 << 4)
+#define CTL_SLEW_SHIFT		4
+#define CTL_RESET			(1 << 2)
+
+#define FAN53555_NVOLTAGES	64	/* Numbers of voltages */
+
+/* IC Type */
+enum {
+	FAN53555_CHIP_ID_00 = 0,
+	FAN53555_CHIP_ID_01,
+	FAN53555_CHIP_ID_02,
+	FAN53555_CHIP_ID_03,
+	FAN53555_CHIP_ID_04,
+	FAN53555_CHIP_ID_05,
+};
+
+struct fan53555_device_info {
+	struct regmap *regmap;
+	struct device *dev;
+	struct regulator_desc desc;
+	struct regulator_dev *rdev;
+	struct regulator_init_data *regulator;
+	/* IC Type and Rev */
+	int chip_id;
+	int chip_rev;
+	/* Voltage setting register */
+	unsigned int vol_reg;
+	unsigned int sleep_reg;
+	/* Voltage range and step(linear) */
+	unsigned int vsel_min;
+	unsigned int vsel_max;
+	unsigned int vsel_step;
+	/* Voltage slew rate limiting */
+	unsigned int slew_rate;
+	/* Sleep voltage cache */
+	unsigned int sleep_vol_cache;
+};
+
+static int fan53555_set_suspend_voltage(struct regulator_dev *rdev, int uV)
+{
+	struct fan53555_device_info *di = rdev_get_drvdata(rdev);
+	int ret;
+
+	if (di->sleep_vol_cache == uV)
+		return 0;
+	ret = regulator_map_voltage_linear(rdev, uV, uV);
+	if (ret < 0)
+		return -EINVAL;
+	ret = regmap_update_bits(di->regmap, di->sleep_reg,
+					VSEL_NSEL_MASK, ret);
+	if (ret < 0)
+		return -EINVAL;
+	/* Cache the sleep voltage setting.
+	 * Might not be the real voltage which is rounded */
+	di->sleep_vol_cache = uV;
+
+	return 0;
+}
+
+static int fan53555_set_mode(struct regulator_dev *rdev, unsigned int mode)
+{
+	struct fan53555_device_info *di = rdev_get_drvdata(rdev);
+
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		regmap_update_bits(di->regmap, di->vol_reg,
+				VSEL_MODE, VSEL_MODE);
+		break;
+	case REGULATOR_MODE_NORMAL:
+		regmap_update_bits(di->regmap, di->vol_reg, VSEL_MODE, 0);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static unsigned int fan53555_get_mode(struct regulator_dev *rdev)
+{
+	struct fan53555_device_info *di = rdev_get_drvdata(rdev);
+	unsigned int val;
+	int ret = 0;
+
+	ret = regmap_read(di->regmap, di->vol_reg, &val);
+	if (ret < 0)
+		return ret;
+	if (val & VSEL_MODE)
+		return REGULATOR_MODE_FAST;
+	else
+		return REGULATOR_MODE_NORMAL;
+}
+
+static struct regulator_ops fan53555_regulator_ops = {
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.map_voltage = regulator_map_voltage_linear,
+	.list_voltage = regulator_list_voltage_linear,
+	.set_suspend_voltage = fan53555_set_suspend_voltage,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+	.set_mode = fan53555_set_mode,
+	.get_mode = fan53555_get_mode,
+};
+
+/* For 00,01,03,05 options:
+ * VOUT = 0.60V + NSELx * 10mV, from 0.60 to 1.23V.
+ * For 04 option:
+ * VOUT = 0.603V + NSELx * 12.826mV, from 0.603 to 1.411V.
+ * */
+static int fan53555_device_setup(struct fan53555_device_info *di,
+				struct fan53555_platform_data *pdata)
+{
+	unsigned int reg, data, mask;
+
+	/* Setup voltage control register */
+	switch (pdata->sleep_vsel_id) {
+	case FAN53555_VSEL_ID_0:
+		di->sleep_reg = FAN53555_VSEL0;
+		di->vol_reg = FAN53555_VSEL1;
+		break;
+	case FAN53555_VSEL_ID_1:
+		di->sleep_reg = FAN53555_VSEL1;
+		di->vol_reg = FAN53555_VSEL0;
+		break;
+	default:
+		dev_err(di->dev, "Invalid VSEL ID!\n");
+		return -EINVAL;
+	}
+	/* Init voltage range and step */
+	switch (di->chip_id) {
+	case FAN53555_CHIP_ID_00:
+	case FAN53555_CHIP_ID_01:
+	case FAN53555_CHIP_ID_03:
+	case FAN53555_CHIP_ID_05:
+		di->vsel_min = 600000;
+		di->vsel_max = 1230000;
+		di->vsel_step = 10000;
+		break;
+	case FAN53555_CHIP_ID_04:
+		di->vsel_min = 603000;
+		di->vsel_max = 1411000;
+		di->vsel_step = 12826;
+		break;
+	default:
+		dev_err(di->dev,
+			"Chip ID[%d]\n not supported!\n", di->chip_id);
+		return -EINVAL;
+	}
+	/* Init slew rate */
+	if (pdata->slew_rate & 0x7)
+		di->slew_rate = pdata->slew_rate;
+	else
+		di->slew_rate = FAN53555_SLEW_RATE_64MV;
+	reg = FAN53555_CONTROL;
+	data = di->slew_rate << CTL_SLEW_SHIFT;
+	mask = CTL_SLEW_MASK;
+	return regmap_update_bits(di->regmap, reg, mask, data);
+}
+
+static int fan53555_regulator_register(struct fan53555_device_info *di,
+			struct regulator_config *config)
+{
+	struct regulator_desc *rdesc = &di->desc;
+
+	rdesc->name = "fan53555-reg";
+	rdesc->ops = &fan53555_regulator_ops;
+	rdesc->type = REGULATOR_VOLTAGE;
+	rdesc->n_voltages = FAN53555_NVOLTAGES;
+	rdesc->enable_reg = di->vol_reg;
+	rdesc->enable_mask = VSEL_BUCK_EN;
+	rdesc->min_uV = di->vsel_min;
+	rdesc->uV_step = di->vsel_step;
+	rdesc->vsel_reg = di->vol_reg;
+	rdesc->vsel_mask = VSEL_NSEL_MASK;
+	rdesc->owner = THIS_MODULE;
+
+	di->rdev = regulator_register(&di->desc, config);
+	if (IS_ERR(di->rdev))
+		return PTR_ERR(di->rdev);
+	return 0;
+
+}
+
+static struct regmap_config fan53555_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int __devinit fan53555_regulator_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct fan53555_device_info *di;
+	struct fan53555_platform_data *pdata;
+	struct regulator_config config = { };
+	unsigned int val;
+	int ret;
+
+	pdata = client->dev.platform_data;
+	if (!pdata || !pdata->regulator) {
+		dev_err(&client->dev, "Platform data not found!\n");
+		return -ENODEV;
+	}
+
+	di = devm_kzalloc(&client->dev, sizeof(struct fan53555_device_info),
+					GFP_KERNEL);
+	if (!di) {
+		dev_err(&client->dev, "Failed to allocate device info data!\n");
+		return -ENOMEM;
+	}
+	di->regmap = devm_regmap_init_i2c(client, &fan53555_regmap_config);
+	if (IS_ERR(di->regmap)) {
+		dev_err(&client->dev, "Failed to allocate regmap!\n");
+		return PTR_ERR(di->regmap);
+	}
+	di->dev = &client->dev;
+	di->regulator = pdata->regulator;
+	i2c_set_clientdata(client, di);
+	/* Get chip ID */
+	ret = regmap_read(di->regmap, FAN53555_ID1, &val);
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed to get chip ID!\n");
+		return -ENODEV;
+	}
+	di->chip_id = val & DIE_ID;
+	/* Get chip revision */
+	ret = regmap_read(di->regmap, FAN53555_ID2, &val);
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed to get chip Rev!\n");
+		return -ENODEV;
+	}
+	di->chip_rev = val & DIE_REV;
+	dev_info(&client->dev, "FAN53555 Option[%d] Rev[%d] Detected!\n",
+				di->chip_id, di->chip_rev);
+	/* Device init */
+	ret = fan53555_device_setup(di, pdata);
+	if (ret < 0) {
+		dev_err(&client->dev, "Failed to setup device!\n");
+		return ret;
+	}
+	/* Register regulator */
+	config.dev = di->dev;
+	config.init_data = di->regulator;
+	config.regmap = di->regmap;
+	config.driver_data = di;
+	ret = fan53555_regulator_register(di, &config);
+	if (ret < 0)
+		dev_err(&client->dev, "Failed to register regulator!\n");
+	return ret;
+
+}
+
+static int __devexit fan53555_regulator_remove(struct i2c_client *client)
+{
+	struct fan53555_device_info *di = i2c_get_clientdata(client);
+
+	regulator_unregister(di->rdev);
+	return 0;
+}
+
+static const struct i2c_device_id fan53555_id[] = {
+	{"fan53555", -1},
+	{ },
+};
+
+static struct i2c_driver fan53555_regulator_driver = {
+	.driver = {
+		.name = "fan53555-regulator",
+	},
+	.probe = fan53555_regulator_probe,
+	.remove = __devexit_p(fan53555_regulator_remove),
+	.id_table = fan53555_id,
+};
+
+module_i2c_driver(fan53555_regulator_driver);
+
+MODULE_AUTHOR("Yunfan Zhang <yfzhang@marvell.com>");
+MODULE_DESCRIPTION("FAN53555 regulator driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regulator/fan53555.h b/include/linux/regulator/fan53555.h
new file mode 100644
index 0000000..5c45c85
--- /dev/null
+++ b/include/linux/regulator/fan53555.h
@@ -0,0 +1,60 @@
+/*
+ * fan53555.h - Fairchild Regulator FAN53555 Driver
+ *
+ * Copyright (C) 2012 Marvell Technology Ltd.
+ * Yunfan Zhang <yfzhang@marvell.com>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __FAN53555_H__
+
+/* VSEL ID */
+enum {
+	FAN53555_VSEL_ID_0 = 0,
+	FAN53555_VSEL_ID_1,
+};
+
+/* Transition slew rate limiting from a low to high voltage.
+ * -----------------------
+ *   Bin |Slew Rate(mV/uS)
+ * ------|----------------
+ *   000 |    64.00
+ * ------|----------------
+ *   001 |    32.00
+ * ------|----------------
+ *   010 |    16.00
+ * ------|----------------
+ *   011 |     8.00
+ * ------|----------------
+ *   100 |     4.00
+ * ------|----------------
+ *   101 |     2.00
+ * ------|----------------
+ *   110 |     1.00
+ * ------|----------------
+ *   111 |     0.50
+ * -----------------------
+ */
+enum {
+	FAN53555_SLEW_RATE_64MV = 0,
+	FAN53555_SLEW_RATE_32MV,
+	FAN53555_SLEW_RATE_16MV,
+	FAN53555_SLEW_RATE_8MV,
+	FAN53555_SLEW_RATE_4MV,
+	FAN53555_SLEW_RATE_2MV,
+	FAN53555_SLEW_RATE_1MV,
+	FAN53555_SLEW_RATE_0_5MV,
+};
+
+struct fan53555_platform_data {
+	struct regulator_init_data *regulator;
+	unsigned int slew_rate;
+	/* Sleep VSEL ID */
+	unsigned int sleep_vsel_id;
+};
+
+#endif /* __FAN53555_H__ */
-- 
1.7.0.4

