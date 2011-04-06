Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1DFMtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:49:52 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.186]:17844
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763Ab1DFMtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:49:51 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cK936eKc8kzz1202hzz8275bh84d07hz32i2a8h668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:kcinpunhjhc02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Date: Wed, 6 Apr 2011 18:19:15 +0530
Subject: [PATCHv1 5/11] REGULATOR: Regulator module of DA9052 PMIC driver
Thread-Topic: [PATCHv1 5/11] REGULATOR: Regulator module of DA9052 PMIC
 driver
Thread-Index: Acv0WQkyOYGmLFS+RhGQGE/ihn2F5g==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B451F17@KCINPUNHJCMS01.kpit.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p36Co2iM000782

Hi Mark,

Regulator Driver for Dialog Semiconductor DA9052 PMICs.

Changes made since last submission:
. read and write operation moved to MFD
. added macros

Some additional information of this patch:
. This patch is tested with the Samsung 6410 board using sysfs interface. 

Linux Kernel Version: 2.6.37

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -Naur orig_linux-2.6.37/drivers/regulator/da9052-regulator.c linux-2.6.37/drivers/regulator/da9052-regulator.c
--- orig_linux-2.6.37/drivers/regulator/da9052-regulator.c	1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/drivers/regulator/da9052-regulator.c	2011-03-31 21:49:02.000000000 +0500
@@ -0,0 +1,442 @@
+/*
+* da9052-regulator.c: Regulator driver for DA9052
+*
+* Copyright(c) 2009 Dialog Semiconductor Ltd.
+*
+*Author: Dajun Chen <dchen@diasemi.com>
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License as published by
+* the Free Software Foundation; either version 2 of the License, or
+* (at your option) any later version.
+*
+*/
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/pm.h>
+
+/* LDO and Buck index */
+#define DA9052_BUCK_CORE		0
+#define DA9052_BUCK_PRO		1
+#define DA9052_BUCK_MEM		2
+#define DA9052_BUCK_PERI		3
+
+#define DA9052_LDO2			4
+#define DA9052_LDO3			5
+
+/* Buck step size Macros */
+#define DA9052_BUCK_PERI_3uV_STEP		100000
+#define DA9052_BUCK_PERI_REG_MAP_UPTO_3uV	24
+#define DA9052_CONST_3uV			3000000
+
+static struct regulator_ops da9052_regulator_ops;
+
+static struct regulator_consumer_supply da9052_vddarm_consumers[] = {
+	{
+		.supply = "vcc",
+	}
+};
+
+#define DA9052_BUCKCORE_INIT(max, min) \
+{\
+	.constraints = {\
+		.max_uV		= (max) * 1000,\
+		.min_uV		= (min) * 1000,\
+		.valid_ops_mask	= REGULATOR_CHANGE_VOLTAGE\
+		|REGULATOR_CHANGE_STATUS | REGULATOR_CHANGE_MODE,\
+		.valid_modes_mask = REGULATOR_MODE_NORMAL,\
+	},\
+	.num_consumer_supplies = ARRAY_SIZE(da9052_vddarm_consumers),\
+	.consumer_supplies = da9052_vddarm_consumers,\
+}
+
+
+#define DA9052_REGULATOR_INIT(max, min) \
+{\
+	.constraints = {\
+		.max_uV		= (max) * 1000,\
+		.min_uV		= (min) * 1000,\
+		.valid_ops_mask	= REGULATOR_CHANGE_VOLTAGE\
+		|REGULATOR_CHANGE_STATUS | REGULATOR_CHANGE_MODE,\
+		.valid_modes_mask = REGULATOR_MODE_NORMAL,\
+	},\
+}
+
+struct regulator_init_data da9052_regulators_init[] = {
+	/* BUCKS */
+	DA9052_BUCKCORE_INIT(2075, 500),
+	DA9052_REGULATOR_INIT(2075, 500),
+	DA9052_REGULATOR_INIT(2500, 925),
+	DA9052_REGULATOR_INIT(3600, 1800),
+
+	/* LDO */
+	DA9052_REGULATOR_INIT(1800, 600),
+	DA9052_REGULATOR_INIT(1800, 600),
+	DA9052_REGULATOR_INIT(3300, 1725),
+	DA9052_REGULATOR_INIT(3300, 1725),
+	DA9052_REGULATOR_INIT(3600, 1200),
+	DA9052_REGULATOR_INIT(3600, 1200),
+	DA9052_REGULATOR_INIT(3600, 1200),
+	DA9052_REGULATOR_INIT(3600, 1200),
+	DA9052_REGULATOR_INIT(3650, 1250),
+	DA9052_REGULATOR_INIT(3600, 1200),
+
+};
+
+
+#define DA9052_LDO(_id, step, sbits, ebits) \
+{\
+		.reg_desc	= {\
+		.name		= "LDO" #_id,\
+		.ops		= &da9052_regulator_ops,\
+		.type		= REGULATOR_VOLTAGE,\
+		.id		= _id,\
+		.owner		= THIS_MODULE,\
+	},\
+		.step_uV		= (step) * 1000,\
+		.volt_shift		= (sbits),\
+		.enable_bit		= (ebits),\
+}
+
+#define DA9052_DCDC(_id, step, sbits, ebits) \
+{\
+		.reg_desc	= {\
+		.name		= "BUCK" #_id,\
+		.ops		= &da9052_regulator_ops,\
+		.type		= REGULATOR_VOLTAGE,\
+		.id		= _id,\
+		.owner		= THIS_MODULE,\
+	},\
+		.step_uV		= (step) * 1000,\
+		.volt_shift		= (sbits),\
+		.enable_bit		= (ebits),\
+}
+
+struct da9052_regulator_info {
+	struct regulator_desc reg_desc;
+	int step_uV;
+	unsigned char volt_shift;
+	unsigned char enable_bit;
+};
+
+struct da9052_regulator {
+	struct da9052 *da9052;
+	struct regulator_dev *regulators[];
+};
+
+struct da9052_regulator_info da9052_regulator_info[] = {
+	/* Buck1 - 4*/
+	DA9052_DCDC(0, 25, 6, 6),
+
+	DA9052_DCDC(1, 25, 6, 6),
+
+	DA9052_DCDC(2, 25, 6, 6),
+
+	DA9052_DCDC(3, 50, 5, 6),
+
+	/* LD01 - LDO10*/
+	DA9052_LDO(4, 50, 5, 6),
+
+	DA9052_LDO(5 , 25, 6, 6),
+
+	DA9052_LDO(6, 25, 6, 6),
+
+	DA9052_LDO(7, 25, 6, 6),
+
+	DA9052_LDO(8, 50, 6, 6),
+
+	DA9052_LDO(9, 50, 6, 6),
+
+	DA9052_LDO(10, 50, 6, 6),
+
+	DA9052_LDO(11, 50, 6, 6),
+
+	DA9052_LDO(12, 50, 6, 6),
+
+	DA9052_LDO(13, 50, 6, 6),
+
+};
+
+static inline int da9052_regulator_uvolts_to_regVal(struct regulator_dev *rdev,
+						unsigned int val)
+{
+	struct regulation_constraints *constraints = rdev->constraints;
+	int offset = rdev_get_id(rdev);
+	int reg_val = 0;
+
+	/* Care for the varying step size of BUCK PERI */
+	if ((offset == DA9052_BUCK_PERI) && (val >= DA9052_CONST_3uV)) {
+		reg_val = (DA9052_CONST_3uV - constraints->min_uV)/
+				  (da9052_regulator_info[offset].step_uV);
+		reg_val += ((val - DA9052_CONST_3uV) /
+					(DA9052_BUCK_PERI_3uV_STEP));
+	} else{
+		reg_val = (val - constraints->min_uV)/
+				  (da9052_regulator_info[offset].step_uV);
+
+		/* Validate reg_val */
+		if ((reg_val * da9052_regulator_info[offset].step_uV) +
+			constraints->min_uV > constraints->max_uV)
+			return -EINVAL;
+	}
+
+	return reg_val;
+
+}
+
+static inline int da9052_regulator_val_to_uvolts(struct regulator_dev *rdev,
+						unsigned int regval)
+{
+	struct regulation_constraints *constraints = rdev->constraints;
+	int offset = rdev_get_id(rdev);
+	int regval_uV = 0;
+
+	if (offset == DA9052_BUCK_PERI) {
+		if (regval >= DA9052_BUCK_PERI_REG_MAP_UPTO_3uV) {
+			regval_uV = ((DA9052_BUCK_PERI_REG_MAP_UPTO_3uV *
+				da9052_regulator_info[offset].step_uV)
+				+ constraints->min_uV);
+			regval_uV += (regval -
+				DA9052_BUCK_PERI_REG_MAP_UPTO_3uV)
+				*(DA9052_BUCK_PERI_3uV_STEP);
+		} else {
+			regval_uV =
+				(regval * da9052_regulator_info[offset].step_uV)
+				+ constraints->min_uV;
+		}
+	} else {
+		regval_uV = (regval * da9052_regulator_info[offset].step_uV) +
+				constraints->min_uV;
+	}
+
+	return regval_uV;
+}
+
+static int da9052_regulator_enable(struct regulator_dev *rdev)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	int offset = rdev_get_id(rdev);
+	int ret = 0;
+
+	ret = da9052_reg_update(regulator->da9052,
+			DA9052_BUCKCORE_REG + offset,
+			1 << da9052_regulator_info[offset].enable_bit,
+			1 << da9052_regulator_info[offset].enable_bit);
+	if (ret < 0)
+		return -EIO;
+
+	return 0;
+}
+
+static int da9052_regulator_disable(struct regulator_dev *rdev)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	int offset = rdev_get_id(rdev);
+	int ret = 0;
+
+	ret = da9052_reg_update(regulator->da9052,
+			DA9052_BUCKCORE_REG + offset,
+			1 << da9052_regulator_info[offset].enable_bit,
+			0);
+	if (ret < 0)
+		return -EIO;
+
+	return 0;
+}
+
+static int da9052_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	int offset = rdev_get_id(rdev);
+	int ret;
+
+	ret = da9052_reg_read(regulator->da9052,
+			      DA9052_BUCKCORE_REG + offset);
+
+	if (ret < 0)
+		return -EIO;
+
+	return ret & (1 << da9052_regulator_info[offset].enable_bit);
+
+}
+
+static int da9052_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
+				 int max_uV)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	struct regulation_constraints *constraints = rdev->constraints;
+	int offset = rdev_get_id(rdev);
+	int ret;
+	int reg_val = 0;
+
+	/* Compare voltage range */
+	if (min_uV > max_uV)
+		return -EINVAL;
+
+	if (min_uV < constraints->min_uV || min_uV > constraints->max_uV)
+		return -EINVAL;
+	if (max_uV < constraints->min_uV || max_uV > constraints->max_uV)
+		return -EINVAL;
+
+	reg_val = da9052_regulator_uvolts_to_regVal(rdev, min_uV);
+
+	ret = da9052_reg_update(regulator->da9052,
+			DA9052_BUCKCORE_REG + offset,
+			(1 << da9052_regulator_info[offset].volt_shift) - 1,
+			reg_val);
+	if (ret < 0)
+		return -EIO;
+
+	/* Set the GO LDO/BUCk bits so that the voltage changes */
+	switch (offset) {
+	case DA9052_LDO2:
+		ret = da9052_reg_update(regulator->da9052,
+				DA9052_SUPPLY_REG, 0,
+				DA9052_SUPPLY_VLDO2GO);
+		if (ret < 0)
+			return -EIO;
+	break;
+	case DA9052_LDO3:
+		ret = da9052_reg_update(regulator->da9052,
+				DA9052_SUPPLY_REG, 0,
+				DA9052_SUPPLY_VLDO3GO);
+		if (ret < 0)
+			return -EIO;
+	break;
+	case DA9052_BUCK_CORE:
+		ret = da9052_reg_update(regulator->da9052,
+				DA9052_SUPPLY_REG, 0,
+				DA9052_SUPPLY_VBCOREGO);
+		if (ret < 0)
+			return -EIO;
+	break;
+	case DA9052_BUCK_PRO:
+		ret = da9052_reg_update(regulator->da9052,
+				DA9052_SUPPLY_REG, 0,
+				DA9052_SUPPLY_VBPROGO);
+		if (ret < 0)
+			return -EIO;
+	break;
+	case DA9052_BUCK_MEM:
+		ret = da9052_reg_update(regulator->da9052,
+				DA9052_SUPPLY_REG, 0,
+				DA9052_SUPPLY_VBMEMGO);
+		if (ret  < 0)
+			return -EIO;
+	break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int da9052_regulator_get_voltage(struct regulator_dev *rdev)
+{
+	struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
+	int offset = rdev_get_id(rdev);
+	int ret;
+
+	ret = da9052_reg_read(regulator->da9052,
+			DA9052_BUCKCORE_REG + offset);
+	if (ret < 0)
+		return -EIO;
+
+	return da9052_regulator_val_to_uvolts(rdev,
+		ret &
+		((1 << da9052_regulator_info[offset].volt_shift) - 1));
+}
+
+static struct regulator_ops da9052_regulator_ops = {
+	.is_enabled		= da9052_regulator_is_enabled,
+	.enable		= da9052_regulator_enable,
+	.disable		= da9052_regulator_disable,
+	.get_voltage	= da9052_regulator_get_voltage,
+	.set_voltage	= da9052_regulator_set_voltage,
+};
+
+static int __devinit da9052_regulator_probe(struct platform_device *pdev)
+{
+	struct da9052_regulator *regulator;
+	struct da9052 *da9052 = dev_get_drvdata(pdev->dev.parent);
+	struct regulator_init_data  *init_data;
+	int i, ret = 0;
+
+	regulator = kzalloc(sizeof(struct da9052_regulator), GFP_KERNEL);
+	if (!regulator)
+		return -ENOMEM;
+
+	regulator->da9052 = da9052;
+
+	for (i = 0; i < ARRAY_SIZE(da9052_regulator_info); i++) {
+		init_data = &da9052_regulators_init[i];
+		init_data->driver_data = da9052;
+		pdev->dev.platform_data = init_data;
+		regulator->regulators[i] = regulator_register(
+					&da9052_regulator_info[i].reg_desc,
+					&pdev->dev,
+					pdev->dev.platform_data,
+					regulator
+					);
+		if (IS_ERR(regulator->regulators[i])) {
+			ret = PTR_ERR(regulator->regulators[i]);
+			dev_err(da9052->dev, "Failed to register regulator[%d] \
+					   %d \n", i+1, ret);
+			goto err;
+		}
+	}
+
+	platform_set_drvdata(pdev, regulator);
+
+	return 0;
+err:
+	while (--i >= 0)
+		regulator_unregister(regulator->regulators[i]);
+	kfree(regulator);
+	return ret;
+}
+
+static int __devexit da9052_regulator_remove(struct platform_device *pdev)
+{
+	struct da9052_regulator *regulator = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(da9052_regulator_info); i++)
+		regulator_unregister(regulator->regulators[i]);
+
+	kfree(regulator);
+	return 0;
+}
+
+static struct platform_driver da9052_regulator_driver = {
+	.driver.name	= "da9052-regulator",
+	.driver.owner	= THIS_MODULE,
+	.probe		= da9052_regulator_probe,
+	.remove		= __devexit_p(da9052_regulator_remove),
+};
+
+static int __init da9052_regulator_init(void)
+{
+	return platform_driver_register(&da9052_regulator_driver);
+}
+subsys_initcall(da9052_regulator_init);
+
+static void __exit da9052_regulator_exit(void)
+{
+	platform_driver_unregister(&da9052_regulator_driver);
+}
+module_exit(da9052_regulator_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Power Regulator driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9052-regulator");
diff -Naur orig_linux-2.6.37/drivers/regulator/Kconfig linux-2.6.37/drivers/regulator/Kconfig
--- orig_linux-2.6.37/drivers/regulator/Kconfig	2011-01-05 05:50:19.000000000 +0500
+++ linux-2.6.37/drivers/regulator/Kconfig	2011-03-31 21:48:51.000000000 +0500
@@ -158,6 +158,13 @@
 	  Say y here to support the BUCKs and LDOs regulators found on
 	  Dialog Semiconductor DA9030/DA9034 PMIC.

+config REGULATOR_DA9052
+	tristate "Dialog DA9052 regulators"
+	depends on PMIC_DA9052
+	help
+	  Say y here to support the BUCKs and LDOs regulators found on
+	  Dialog Semiconductor DA9052 PMIC.
+
 config REGULATOR_PCF50633
 	tristate "PCF50633 regulator driver"
         depends on MFD_PCF50633
diff -Naur orig_linux-2.6.37/drivers/regulator/Makefile linux-2.6.37/drivers/regulator/Makefile
--- orig_linux-2.6.37/drivers/regulator/Makefile	2011-01-05 05:50:19.000000000 +0500
+++ linux-2.6.37/drivers/regulator/Makefile	2011-03-31 21:48:45.000000000 +0500
@@ -27,6 +27,7 @@
 obj-$(CONFIG_REGULATOR_WM8994) 	+= wm8994-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6586X)	+= tps6586x-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
+obj-$(CONFIG_REGULATOR_DA9052)  	+= da9052-regulator.o
 obj-$(CONFIG_REGULATOR_PCF50633) 	+= pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_PCAP) 	+= pcap-regulator.o
 obj-$(CONFIG_REGULATOR_MC13783) 	+= mc13783-regulator.o

Regards,
Ashish


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
