Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab2KUSVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:21:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60659 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab2KUSVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:21:14 -0500
Date: Wed, 21 Nov 2012 19:21:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: Magnus Damm <magnus.damm@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] regulator: add a regulator driver for the AS3711 PMIC
In-Reply-To: <Pine.LNX.4.64.1211211916160.842@axis700.grange>
Message-ID: <Pine.LNX.4.64.1211211918330.842@axis700.grange>
References: <Pine.LNX.4.64.1211211916160.842@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:0BogBjcJt99/FXGyahxdZJDrxA0W4bXpy8ZnlvKPuU1
 ppMyVeW8a0OIzYkbW2iEinSgsTuMoZRSxSXSL3lG6oXZcMwVgX
 1y/tEB318qSeA3SRs0gE25Uq8VAd33LLlxk5Ce0FJSJA6CG/SD
 5ORDLfrTs2+0SIJ6RV7RLk79GwVXj7XlqLvudLkw4yklKKJYM1
 5NqdC+ORuZGBPBCoTsNOf7vbhU/Atvfrn288xWjgJQPI2gGgXc
 Yu7+csSiszfTXv/bpsVT6AjrBMar12rOulDg/7qUyGCDr/pEwd
 USMmorSHohzt8fhTynYcbUsx9CoJ//BlacXBcTNN+MxWFu3bji
 G4D7xOlrR/4UB4WRj64n5KlR1L/YnhmkQML2pNwxrpb7kxh4hS
 7ByKxZxGJy6IQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports the 4 DCDC and 8 LDO regulators on the AS3711 PMIC.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/regulator/as3711-regulator.c |  381 ++++++++++++++++++++++++++++++++++
 1 files changed, 381 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/as3711-regulator.c

diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
new file mode 100644
index 0000000..d097572
--- /dev/null
+++ b/drivers/regulator/as3711-regulator.c
@@ -0,0 +1,381 @@
+/*
+ * AS3711 PMIC regulator driver, using DCDC Step Down and LDO supplies
+ *
+ * Copyright (C) 2012 Renesas Electronics Corporation
+ * Author: Guennadi Liakhovetski, <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the version 2 of the GNU General Public License as
+ * published by the Free Software Foundation
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/mfd/as3711.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/regulator/driver.h>
+#include <linux/slab.h>
+
+struct as3711_regulator_info {
+	struct regulator_desc	desc;
+	unsigned int		max_uV;
+};
+
+struct as3711_regulator {
+	struct as3711_regulator_info *reg_info;
+	struct regulator_dev *rdev;
+};
+
+static int as3711_list_voltage_sd(struct regulator_dev *rdev,
+				  unsigned int selector)
+{
+	if (selector >= rdev->desc->n_voltages)
+		return -EINVAL;
+
+	if (!selector)
+		return 0;
+	if (selector < 0x41)
+		return 600000 + selector * 12500;
+	if (selector < 0x71)
+		return 1400000 + (selector - 0x40) * 25000;
+	return 2600000 + (selector - 0x70) * 50000;
+}
+
+static int as3711_list_voltage_aldo(struct regulator_dev *rdev,
+				    unsigned int selector)
+{
+	if (selector >= rdev->desc->n_voltages)
+		return -EINVAL;
+
+	if (selector < 0x10)
+		return 1200000 + selector * 50000;
+	return 1800000 + (selector - 0x10) * 100000;
+}
+
+static int as3711_list_voltage_dldo(struct regulator_dev *rdev,
+				    unsigned int selector)
+{
+	if (selector >= rdev->desc->n_voltages ||
+	    (selector > 0x10 && selector < 0x20))
+		return -EINVAL;
+
+	if (selector < 0x11)
+		return 900000 + selector * 50000;
+	return 1750000 + (selector - 0x20) * 50000;
+}
+
+static int as3711_bound_check(struct regulator_dev *rdev,
+			      int *min_uV, int *max_uV)
+{
+	struct as3711_regulator_info *info = container_of(rdev->desc,
+					struct as3711_regulator_info, desc);
+	struct as3711_regulator *reg = rdev->reg_data;
+
+	WARN_ON(reg->reg_info != info);
+
+	dev_dbg(&rdev->dev, "%s(), %d, %d, %d\n", __func__,
+		*min_uV, rdev->desc->min_uV, info->max_uV);
+
+	if (*max_uV < *min_uV ||
+	    *min_uV >= info->max_uV || rdev->desc->min_uV >= *max_uV)
+		return -EINVAL;
+
+	if (rdev->desc->n_voltages == 1)
+		return 0;
+
+	if (*max_uV > info->max_uV)
+		*max_uV = info->max_uV;
+
+	if (*min_uV < rdev->desc->min_uV)
+		*min_uV = rdev->desc->min_uV;
+
+	return *min_uV;
+}
+
+static int as3711_sel_check(int min, int max, int bottom, int step)
+{
+	int ret, voltage;
+
+	/* Round up min, when dividing: keeps us within the range */
+	ret = (min - bottom + step - 1) / step;
+	voltage = ret * step + bottom;
+	pr_debug("%s(): select %d..%d in %d+N*%d: %d\n", __func__,
+	       min, max, bottom, step, ret);
+	if (voltage > max) {
+		/*
+		 * Try 1 down. It will take us below min, but as long we stay
+		 * above bottom, we're fine.
+		 */
+		ret--;
+		voltage = ret * step + bottom;
+		if (voltage < bottom)
+			return -EINVAL;
+	}
+	return ret;
+}
+
+static int as3711_map_voltage_sd(struct regulator_dev *rdev,
+				 int min_uV, int max_uV)
+{
+	int ret;
+
+	ret = as3711_bound_check(rdev, &min_uV, &max_uV);
+	if (ret <= 0)
+		return ret;
+
+	if (min_uV <= 1400000)
+		return as3711_sel_check(min_uV, max_uV, 600000, 12500);
+
+	if (min_uV <= 2600000)
+		return as3711_sel_check(min_uV, max_uV, 1400000, 25000) + 0x40;
+
+	return as3711_sel_check(min_uV, max_uV, 2600000, 50000) + 0x70;
+}
+
+/*
+ * The regulator API supports 4 modes of operataion: FAST, NORMAL, IDLE and
+ * STANDBY. We map them in the following way to AS3711 SD1-4 DCDC modes:
+ * FAST:	sdX_fast=1
+ * NORMAL:	low_noise=1
+ * IDLE:	low_noise=0
+ */
+
+static int as3711_set_mode_sd(struct regulator_dev *rdev, unsigned int mode)
+{
+	unsigned int fast_bit = rdev->desc->enable_mask,
+		low_noise_bit = fast_bit << 4;
+	u8 val;
+
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		val = fast_bit | low_noise_bit;
+		break;
+	case REGULATOR_MODE_NORMAL:
+		val = low_noise_bit;
+		break;
+	case REGULATOR_MODE_IDLE:
+		val = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return regmap_update_bits(rdev->regmap, AS3711_SD_CONTROL_1,
+				  low_noise_bit | fast_bit, val);
+}
+
+static unsigned int as3711_get_mode_sd(struct regulator_dev *rdev)
+{
+	unsigned int fast_bit = rdev->desc->enable_mask,
+		low_noise_bit = fast_bit << 4, mask = fast_bit | low_noise_bit;
+	unsigned int val;
+	int ret = regmap_read(rdev->regmap, AS3711_SD_CONTROL_1, &val);
+
+	if (ret < 0)
+		return ret;
+
+	if ((val & mask) == mask)
+		return REGULATOR_MODE_FAST;
+
+	if ((val & mask) == low_noise_bit)
+		return REGULATOR_MODE_NORMAL;
+
+	if (!(val & mask))
+		return REGULATOR_MODE_IDLE;
+
+	return -EINVAL;
+}
+
+static int as3711_map_voltage_aldo(struct regulator_dev *rdev,
+				  int min_uV, int max_uV)
+{
+	int ret;
+
+	ret = as3711_bound_check(rdev, &min_uV, &max_uV);
+	if (ret <= 0)
+		return ret;
+
+	if (min_uV <= 1800000)
+		return as3711_sel_check(min_uV, max_uV, 1200000, 50000);
+
+	return as3711_sel_check(min_uV, max_uV, 1800000, 100000) + 0x10;
+}
+
+static int as3711_map_voltage_dldo(struct regulator_dev *rdev,
+				  int min_uV, int max_uV)
+{
+	int ret;
+
+	ret = as3711_bound_check(rdev, &min_uV, &max_uV);
+	if (ret <= 0)
+		return ret;
+
+	if (min_uV <= 1700000)
+		return as3711_sel_check(min_uV, max_uV, 900000, 50000);
+
+	return as3711_sel_check(min_uV, max_uV, 1750000, 50000) + 0x20;
+}
+
+static struct regulator_ops as3711_sd_ops = {
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.list_voltage		= as3711_list_voltage_sd,
+	.map_voltage		= as3711_map_voltage_sd,
+	.get_mode		= as3711_get_mode_sd,
+	.set_mode		= as3711_set_mode_sd,
+};
+
+static struct regulator_ops as3711_aldo_ops = {
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.list_voltage		= as3711_list_voltage_aldo,
+	.map_voltage		= as3711_map_voltage_aldo,
+};
+
+static struct regulator_ops as3711_dldo_ops = {
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.list_voltage		= as3711_list_voltage_dldo,
+	.map_voltage		= as3711_map_voltage_dldo,
+};
+
+#define AS3711_REG(_id, _en_reg, _en_bit, _vmask, _vshift, _min_uV, _max_uV, _sfx)	\
+	[AS3711_REGULATOR_ ## _id] = {							\
+	.desc = {									\
+		.name = "as3711-regulator-" # _id,					\
+		.id = AS3711_REGULATOR_ ## _id,						\
+		.n_voltages = (_vmask + 1),						\
+		.ops = &as3711_ ## _sfx ## _ops,					\
+		.type = REGULATOR_VOLTAGE,						\
+		.owner = THIS_MODULE,							\
+		.vsel_reg = AS3711_ ## _id ## _VOLTAGE,					\
+		.vsel_mask = _vmask << _vshift,						\
+		.enable_reg = AS3711_ ## _en_reg,					\
+		.enable_mask = BIT(_en_bit),						\
+		.min_uV	= _min_uV,							\
+	},										\
+	.max_uV = _max_uV,								\
+}
+
+static struct as3711_regulator_info as3711_reg_info[] = {
+	AS3711_REG(SD_1, SD_CONTROL, 0, 0x7f, 0, 612500, 3350000, sd),
+	AS3711_REG(SD_2, SD_CONTROL, 1, 0x7f, 0, 612500, 3350000, sd),
+	AS3711_REG(SD_3, SD_CONTROL, 2, 0x7f, 0, 612500, 3350000, sd),
+	AS3711_REG(SD_4, SD_CONTROL, 3, 0x7f, 0, 612500, 3350000, sd),
+	AS3711_REG(LDO_1, LDO_1_VOLTAGE, 7, 0x1f, 0, 1200000, 3300000, aldo),
+	AS3711_REG(LDO_2, LDO_2_VOLTAGE, 7, 0x1f, 0, 1200000, 3300000, aldo),
+	AS3711_REG(LDO_3, LDO_3_VOLTAGE, 7, 0x3f, 0, 900000, 3300000, dldo),
+	AS3711_REG(LDO_4, LDO_4_VOLTAGE, 7, 0x3f, 0, 900000, 3300000, dldo),
+	AS3711_REG(LDO_5, LDO_5_VOLTAGE, 7, 0x3f, 0, 900000, 3300000, dldo),
+	AS3711_REG(LDO_6, LDO_6_VOLTAGE, 7, 0x3f, 0, 900000, 3300000, dldo),
+	AS3711_REG(LDO_7, LDO_7_VOLTAGE, 7, 0x3f, 0, 900000, 3300000, dldo),
+	AS3711_REG(LDO_8, LDO_8_VOLTAGE, 7, 0x3f, 0, 900000, 3300000, dldo),
+	/* StepUp output voltage depends on supplying regulator */
+};
+
+#define AS3711_REGULATOR_NUM ARRAY_SIZE(as3711_reg_info)
+
+static int as3711_regulator_probe(struct platform_device *pdev)
+{
+	struct as3711_regulator_pdata *pdata = dev_get_platdata(&pdev->dev);
+	struct as3711 *as3711 = dev_get_drvdata(pdev->dev.parent);
+	struct regulator_init_data *reg_data;
+	struct regulator_config config = {.dev = &pdev->dev,};
+	struct as3711_regulator *reg = NULL;
+	struct as3711_regulator *regs;
+	struct regulator_dev *rdev;
+	struct as3711_regulator_info *ri;
+	int ret;
+	int id;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data, exiting...\n");
+		return -ENODEV;
+	}
+
+	regs = devm_kzalloc(&pdev->dev, AS3711_REGULATOR_NUM *
+			sizeof(struct as3711_regulator), GFP_KERNEL);
+	if (!regs) {
+		dev_err(&pdev->dev, "Memory allocation failed exiting..\n");
+		return -ENOMEM;
+	}
+
+	for (id = 0, ri = as3711_reg_info; id < AS3711_REGULATOR_NUM; ++id, ri++) {
+		reg_data = pdata->init_data[id];
+
+		/* No need to register if there is no regulator data */
+		if (!ri->desc.name || !reg_data)
+			continue;
+
+		reg = &regs[id];
+		reg->reg_info = ri;
+
+		config.init_data = reg_data;
+		config.driver_data = reg;
+		config.regmap = as3711->regmap;
+
+		rdev = regulator_register(&ri->desc, &config);
+		if (IS_ERR(rdev)) {
+			dev_err(&pdev->dev, "Failed to register regulator %s\n",
+				ri->desc.name);
+			ret = PTR_ERR(rdev);
+			goto eregreg;
+		}
+		reg->rdev = rdev;
+	}
+	platform_set_drvdata(pdev, regs);
+	return 0;
+
+eregreg:
+	while (--id >= 0)
+		regulator_unregister(regs[id].rdev);
+
+	return ret;
+}
+
+static int as3711_regulator_remove(struct platform_device *pdev)
+{
+	struct as3711_regulator *regs = platform_get_drvdata(pdev);
+	int id;
+
+	for (id = 0; id < AS3711_REGULATOR_NUM; ++id)
+		regulator_unregister(regs[id].rdev);
+	return 0;
+}
+
+static struct platform_driver as3711_regulator_driver = {
+	.driver	= {
+		.name	= "as3711-regulator",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= as3711_regulator_probe,
+	.remove		= as3711_regulator_remove,
+};
+
+static int __init as3711_regulator_init(void)
+{
+	return platform_driver_register(&as3711_regulator_driver);
+}
+subsys_initcall(as3711_regulator_init);
+
+static void __exit as3711_regulator_exit(void)
+{
+	platform_driver_unregister(&as3711_regulator_driver);
+}
+module_exit(as3711_regulator_exit);
+
+MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
+MODULE_DESCRIPTION("AS3711 regulator driver");
+MODULE_ALIAS("platform:as3711-regulator");
+MODULE_LICENSE("GPL v2");
-- 
1.7.2.5

