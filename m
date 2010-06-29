Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab0F2NPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:15:51 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:4158 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab0F2NPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:15:49 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv4 5/11] REGULATOR: Removal of testing framework and redundancy
Date: Tue, 29 Jun 2010 14:15:46 +0100
Message-ID: <3495EC08FA53E94AAA00CC4743D5BA7E013FA7EB@pandora.diasemi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv4 5/11] REGULATOR: Removal of testing framework and redundancy
Thread-Index: AcsXjS+H/4xzydTrSI+Cji/1ExXrPA==
From: "David Dajun Chen" <Dajun.Chen@diasemi.com>
To: <lrg@slimlogic.co.uk>, <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Jun 2010 13:15:47.0759 (UTC) FILETIME=[304113F0:01CB178D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

REGULATOR module of the device driver for DA9052 PMIC device from Dialog
Semiconductor.

Changes made since last submission:
. registration of regulator driver is done via MFD
. removal of driver test framework
. removal of redundant printk and comments
. removal of redundant headers

Linux Kernel Version: 2.6.34

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -urpN linux-2.6.34/drivers/mfd/da9052-core.c
linux-2.6.34_test/drivers/mfd/da9052-core.c
--- linux-2.6.34/drivers/mfd/da9052-core.c	2010-06-28
19:48:06.000000000 +0500
+++ linux-2.6.34_test/drivers/mfd/da9052-core.c	2010-06-28
19:47:32.000000000 +0500
@@ -532,6 +532,7 @@ static int __init da9052_ssc_init(void)
 	int ret, cnt;
 	struct da9052 *da9052;
 	struct da9052_platform_data *pdata;
+	struct da9052_regulator_platform_data regulator_pdata;
 
 	da9052 = kzalloc(sizeof(*da9052), GFP_KERNEL);
 	if (!da9052)
@@ -558,6 +559,16 @@ static int __init da9052_ssc_init(void)
 	da9052_add_subdevice(da9052, "da9052-backlight");
 	da9052_add_subdevice(da9052, "da9052-rtc");
 
+#if defined(CONFIG_MFD_DA9052_SPI)
+	pdata = dev_get_platdata(&da9052->spi_dev->dev);
+#elif defined(CONFIG_MFD_DA9052_I2C)
+	pdata = dev_get_platdata(da9052->dev);
+#endif
+	regulator_pdata.num_regulators = pdata->num_regulators;
+	regulator_pdata.regulators = pdata->regulators;
+	da9052_add_subdevice_pdata(da9052, "da9052-regulator",
+				&regulator_pdata,
sizeof(regulator_pdata));
+
 	/* Initialize ssc cache */
 	da9052_init_ssc_cache();
 
diff -urpN linux-2.6.34/drivers/regulator/da9052-regulator.c
linux-2.6.34_test/drivers/regulator/da9052-regulator.c
--- linux-2.6.34/drivers/regulator/da9052-regulator.c	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/drivers/regulator/da9052-regulator.c
2010-06-28 19:49:08.000000000 +0500
@@ -0,0 +1,455 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052-regulator.c: Regulator driver for DA9052
+ */
+
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/pm.h>
+
+static struct regulator_ops da9052_ldo_buck_ops;
+
+#define DA9052_LDO(_id, max, min, step_v, reg, mbits, cbits) \
+{\
+	.reg_desc	= {\
+		.name		= #_id,\
+		.ops		= &da9052_ldo_buck_ops,\
+		.type		= REGULATOR_VOLTAGE,\
+		.id			= _id,\
+		.owner		= THIS_MODULE,\
+	},\
+	.reg_const = {\
+		.max_uV		= (max) * 1000,\
+		.min_uV		= (min) * 1000,\
+	},\
+	.step_uV		= (step_v) * 1000,\
+	.reg_add		= (reg),\
+	.mask_bits		= (mbits),\
+	.en_bit_mask	= (cbits),\
+}
+
+struct regulator_info {
+	struct regulator_desc reg_desc;
+	struct regulation_constraints reg_const;
+	int step_uV;
+	unsigned char reg_add;
+	unsigned char mask_bits;
+	unsigned char en_bit_mask;
+};
+
+struct da9052_regulator_priv {
+	struct da9052 *da9052;
+	struct regulator_dev *regulators[];
+};
+
+struct regulator_info da9052_regulators[] = {
+	/* LD01 - LDO10*/
+	DA9052_LDO(DA9052_LDO1, LDO1_VOLT_UPPER, LDO1_VOLT_LOWER,
+			LDO1_VOLT_STEP, DA9052_LDO1_REG,
+			DA9052_LDO1_VLDO1, DA9052_LDO1_LDO1EN),
+
+	DA9052_LDO(DA9052_LDO2, LDO2_VOLT_UPPER, LDO2_VOLT_LOWER,
+			LDO2_VOLT_STEP, DA9052_LDO2_REG,
DA9052_LDO2_VLDO2,\
+			DA9052_LDO2_LDO2EN),
+
+	DA9052_LDO(DA9052_LDO3, LDO34_VOLT_UPPER, LDO34_VOLT_LOWER,\
+			LDO34_VOLT_STEP, DA9052_LDO3_REG,\
+			DA9052_LDO3_VLDO3, DA9052_LDO3_LDO3EN),
+
+	DA9052_LDO(DA9052_LDO4, LDO34_VOLT_UPPER, LDO34_VOLT_LOWER,\
+			LDO34_VOLT_STEP, DA9052_LDO4_REG,\
+			DA9052_LDO4_VLDO4, DA9052_LDO4_LDO4EN),
+
+	DA9052_LDO(DA9052_LDO5, LDO567810_VOLT_UPPER,
LDO567810_VOLT_LOWER,\
+			LDO567810_VOLT_STEP, DA9052_LDO5_REG,\
+			DA9052_LDO5_VLDO5, DA9052_LDO5_LDO5EN),
+
+	DA9052_LDO(DA9052_LDO6, LDO567810_VOLT_UPPER,
LDO567810_VOLT_LOWER,\
+			LDO567810_VOLT_STEP, DA9052_LDO6_REG,\
+			DA9052_LDO6_VLDO6, DA9052_LDO6_LDO6EN),
+
+	DA9052_LDO(DA9052_LDO7, LDO567810_VOLT_UPPER,
LDO567810_VOLT_LOWER,\
+			LDO567810_VOLT_STEP, DA9052_LDO7_REG,\
+			DA9052_LDO7_VLDO7, DA9052_LDO7_LDO7EN),
+
+	DA9052_LDO(DA9052_LDO8, LDO567810_VOLT_UPPER,
LDO567810_VOLT_LOWER,\
+			LDO567810_VOLT_STEP, DA9052_LDO8_REG,\
+			DA9052_LDO8_VLDO8, DA9052_LDO8_LDO8EN),
+
+	DA9052_LDO(DA9052_LDO9, LDO9_VOLT_UPPER, LDO9_VOLT_LOWER,\
+			LDO9_VOLT_STEP, DA9052_LDO9_REG,
DA9052_LDO9_VLDO9,\
+			DA9052_LDO9_LDO9EN),
+
+	DA9052_LDO(DA9052_LDO10, LDO567810_VOLT_UPPER,
LDO567810_VOLT_LOWER,\
+			LDO567810_VOLT_STEP, DA9052_LDO10_REG,\
+			DA9052_LDO10_VLDO10, DA9052_LDO10_LDO10EN),
+
+	/* BUCKS */
+	DA9052_LDO(DA9052_BUCK_CORE, BUCK_CORE_PRO_VOLT_UPPER,
+			BUCK_CORE_PRO_VOLT_LOWER,\
+			BUCK_CORE_PRO_STEP, DA9052_BUCKCORE_REG,\
+			DA9052_BUCKCORE_VBCORE,
DA9052_BUCKCORE_BCOREEN),
+
+	DA9052_LDO(DA9052_BUCK_PRO, BUCK_CORE_PRO_VOLT_UPPER,
+			BUCK_CORE_PRO_VOLT_LOWER,\
+			BUCK_CORE_PRO_STEP, DA9052_BUCKPRO_REG,\
+			DA9052_BUCKPRO_VBPRO, DA9052_BUCKPRO_BPROEN),
+
+	DA9052_LDO(DA9052_BUCK_MEM, BUCK_MEM_VOLT_UPPER,
BUCK_MEM_VOLT_LOWER,\
+			BUCK_MEM_STEP, DA9052_BUCKMEM_REG,\
+			DA9052_BUCKMEM_VBMEM, DA9052_BUCKMEM_BMEMEN),
+
+	/* To be done */
+	DA9052_LDO(DA9052_BUCK_PERI, BUCK_PERI_VOLT_UPPER,
+			BUCK_PERI_VOLT_LOWER,\
+			BUCK_PERI_STEP_BELOW_3000, DA9052_BUCKPERI_REG,\
+			DA9052_BUCKPERI_VBPERI,
DA9052_BUCKPERI_BPERIEN),
+};
+
+static int da9052_ldo_buck_enable(struct regulator_dev *rdev)
+{
+	struct da9052_regulator_priv *priv = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+	struct da9052_ssc_msg ssc_msg;
+
+	ssc_msg.addr = da9052_regulators[id].reg_add;
+	ssc_msg.data = 0;
+
+	da9052_lock(priv->da9052);
+	ret = priv->da9052->read(priv->da9052, &ssc_msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EIO;
+	}
+	da9052_unlock(priv->da9052);
+
+	ssc_msg.data = (ssc_msg.data |
da9052_regulators[id].en_bit_mask);
+
+	da9052_lock(priv->da9052);
+	ret = priv->da9052->write(priv->da9052, &ssc_msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EIO;
+	}
+	da9052_unlock(priv->da9052);
+
+	return 0;
+}
+
+static int da9052_ldo_buck_disable(struct regulator_dev *rdev)
+{
+	struct da9052_regulator_priv *priv = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+	struct da9052_ssc_msg ssc_msg;
+
+	ssc_msg.addr = da9052_regulators[id].reg_add;
+	ssc_msg.data = 0;
+
+	da9052_lock(priv->da9052);
+	ret = priv->da9052->read(priv->da9052, &ssc_msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EIO;
+	}
+	da9052_unlock(priv->da9052);
+
+	ssc_msg.data = (ssc_msg.data &
~(da9052_regulators[id].en_bit_mask));
+
+	da9052_lock(priv->da9052);
+	ret = priv->da9052->write(priv->da9052, &ssc_msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EIO;
+	}
+	da9052_unlock(priv->da9052);
+
+	return 0;
+}
+
+static int da9052_ldo_buck_is_enabled(struct regulator_dev *rdev)
+{
+	struct da9052_regulator_priv *priv = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+	struct da9052_ssc_msg ssc_msg;
+
+	ssc_msg.addr = da9052_regulators[id].reg_add;
+	ssc_msg.data = 0;
+
+	da9052_lock(priv->da9052);
+	ret = priv->da9052->read(priv->da9052, &ssc_msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EIO;
+	}
+	da9052_unlock(priv->da9052);
+
+	return (ssc_msg.data & da9052_regulators[id].en_bit_mask) != 0;
+}
+
+static int da9052_ldo_buck_set_voltage(struct regulator_dev *rdev,\
+					int min_uV, int max_uV)
+{
+	struct da9052_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct da9052_ssc_msg ssc_msg;
+	int id = rdev_get_id(rdev);
+	int ret;
+	int ldo_volt = 0;
+
+	/* Compare voltage range */
+	if (min_uV > max_uV)
+		return -EINVAL;
+
+	/* Check Minimum/ Maximum voltage range */
+	if (min_uV < da9052_regulators[id].reg_const.min_uV ||\
+		min_uV > da9052_regulators[id].reg_const.max_uV)
+		return -EINVAL;
+	if (max_uV < da9052_regulators[id].reg_const.min_uV ||\
+		max_uV > da9052_regulators[id].reg_const.max_uV)
+		return -EINVAL;
+
+	/* Get the ldo register value */
+	/* Varying step size for BUCK PERI */
+	if ((da9052_regulators[id].reg_desc.id == DA9052_BUCK_PERI) &&\
+			(min_uV >= BUCK_PERI_VALUES_3000)) {
+		ldo_volt = (BUCK_PERI_VALUES_3000 -\
+			da9052_regulators[id].reg_const.min_uV)/\
+			(da9052_regulators[id].step_uV);
+		ldo_volt += (min_uV - BUCK_PERI_VALUES_3000)/\
+			(BUCK_PERI_STEP_ABOVE_3000);
+	} else{
+		ldo_volt = (min_uV -
da9052_regulators[id].reg_const.min_uV)/\
+			(da9052_regulators[id].step_uV);
+		/* Check for maximum value */
+		if ((ldo_volt * da9052_regulators[id].step_uV) +\
+			da9052_regulators[id].reg_const.min_uV > max_uV)
+			return -EINVAL;
+	}
+
+	/* Configure LDO Voltage, CONF bits */
+	ssc_msg.addr = da9052_regulators[id].reg_add;
+	ssc_msg.data = 0;
+
+	/* Read register */
+	da9052_lock(priv->da9052);
+	ret = priv->da9052->read(priv->da9052, &ssc_msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EIO;
+	}
+	da9052_unlock(priv->da9052);
+
+	ssc_msg.data = (ssc_msg.data &
~(da9052_regulators[id].mask_bits));
+	ssc_msg.data |= ldo_volt;
+
+	/* Write register */
+	da9052_lock(priv->da9052);
+	ret = priv->da9052->write(priv->da9052, &ssc_msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EIO;
+	}
+	da9052_unlock(priv->da9052);
+
+	/* Set the GO LDO/BUCk bits so that the voltage changes */
+	ssc_msg.addr = DA9052_SUPPLY_REG;
+	ssc_msg.data = 0;
+
+	da9052_lock(priv->da9052);
+	ret = priv->da9052->read(priv->da9052, &ssc_msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EIO;
+	}
+	da9052_unlock(priv->da9052);
+
+	switch (id) {
+	case DA9052_LDO2:
+		ssc_msg.data = (ssc_msg.data | DA9052_SUPPLY_VLDO2GO);
+		break;
+	case DA9052_LDO3:
+		ssc_msg.data = (ssc_msg.data | DA9052_SUPPLY_VLDO3GO);
+		break;
+	case DA9052_BUCK_CORE:
+		ssc_msg.data = (ssc_msg.data | DA9052_SUPPLY_VBCOREGO);
+		break;
+	case DA9052_BUCK_PRO:
+		ssc_msg.data = (ssc_msg.data | DA9052_SUPPLY_VBPROGO);
+		break;
+	case DA9052_BUCK_MEM:
+		ssc_msg.data = (ssc_msg.data | DA9052_SUPPLY_VBMEMGO);
+		break;
+	default:
+		return INVALID_LDO_NUM;
+		break;
+	}
+
+	da9052_lock(priv->da9052);
+	ret = priv->da9052->write(priv->da9052, &ssc_msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EIO;
+	}
+	da9052_unlock(priv->da9052);
+
+	return 0;
+}
+
+static int da9052_ldo_buck_get_voltage(struct regulator_dev *rdev)
+{
+	struct da9052_regulator_priv *priv = rdev_get_drvdata(rdev);
+	struct da9052_ssc_msg ssc_msg;
+	int id = rdev_get_id(rdev);
+	int ldo_volt = 0;
+	int ldo_volt_uV = 0;
+	int ret;
+
+	ssc_msg.addr = da9052_regulators[id].reg_add;
+	ssc_msg.data = 0;
+	/* Read register */
+	da9052_lock(priv->da9052);
+	ret = priv->da9052->read(priv->da9052, &ssc_msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EIO;
+	}
+	da9052_unlock(priv->da9052);
+
+	ldo_volt = ssc_msg.data & da9052_regulators[id].mask_bits;
+	if (da9052_regulators[id].reg_desc.id == DA9052_BUCK_PERI) {
+		if (ldo_volt >= BUCK_PERI_VALUES_UPTO_3000) {
+			ldo_volt_uV = ((BUCK_PERI_VALUES_UPTO_3000 *\
+				da9052_regulators[id].step_uV)\
+				+
da9052_regulators[id].reg_const.min_uV);
+			ldo_volt_uV = (ldo_volt_uV +\
+				(ldo_volt - BUCK_PERI_VALUES_UPTO_3000)\
+				* (BUCK_PERI_STEP_ABOVE_3000));
+		} else {
+			ldo_volt_uV =
+				(ldo_volt *
da9052_regulators[id].step_uV)\
+				+
da9052_regulators[id].reg_const.min_uV;
+		}
+	} else {
+		ldo_volt_uV = (ldo_volt * da9052_regulators[id].step_uV)
+\
+				da9052_regulators[id].reg_const.min_uV;
+	}
+	return ldo_volt_uV;
+
+}
+
+
+static struct regulator_ops da9052_ldo_buck_ops = {
+	.is_enabled = da9052_ldo_buck_is_enabled,
+	.enable = da9052_ldo_buck_enable,
+	.disable = da9052_ldo_buck_disable,
+	.get_voltage = da9052_ldo_buck_get_voltage,
+	.set_voltage = da9052_ldo_buck_set_voltage,
+};
+
+
+
+static inline struct regulator_info *find_regulator_info(int id)
+{
+	struct regulator_info *ri;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(da9052_regulators); i++) {
+		ri = &da9052_regulators[i];
+		if (ri->reg_desc.id == id)
+			return ri;
+	}
+	return NULL;
+}
+
+
+static int __devinit da9052_regulator_probe(struct platform_device
*pdev)
+{
+
+	struct da9052_regulator_priv *priv;
+	struct da9052 *da9052 = dev_get_drvdata(pdev->dev.parent);
+	struct da9052_regulator_platform_data *pdata =
+		dev_get_platdata(&pdev->dev);
+	struct da9052_regulator_init_data *init_data;
+	int i, ret = 0;
+
+	priv = kzalloc(sizeof(*priv) +
+			pdata->num_regulators *
sizeof(priv->regulators[0]),
+			GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->da9052 = da9052;
+
+	for (i = 0; i < pdata->num_regulators; i++) {
+		init_data = &pdata->regulators[i];
+
+		priv->regulators[i] = regulator_register(
+
&da9052_regulators[init_data->id].reg_desc,
+				&pdev->dev, init_data->init_data, priv);
+
+		if (IS_ERR(priv->regulators[i])) {
+			ret = PTR_ERR(priv->regulators[i]);
+			goto err;
+		}
+	}
+	platform_set_drvdata(pdev, priv);
+	return 0;
+err:
+	while (--i >= 0)
+		regulator_unregister(priv->regulators[i]);
+
+	kfree(priv);
+
+	return ret;
+}
+
+static int __devexit da9052_regulator_remove(struct platform_device
*pdev)
+{
+	struct da9052_regulator_priv *priv = platform_get_drvdata(pdev);
+	struct da9052_regulator_platform_data *pdata =
+		dev_get_platdata(&pdev->dev);
+	int i;
+
+	for (i = 0; i < pdata->num_regulators; i++)
+		regulator_unregister(priv->regulators[i]);
+
+	return 0;
+}
+
+static struct platform_driver da9052_regulator_driver = {
+	.probe		= da9052_regulator_probe,
+	.remove		= __devexit_p(da9052_regulator_remove),
+	.driver		= {
+		.name	= DA9052_PM_DEVICE_NAME,
+		.owner	= THIS_MODULE,
+	},
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
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Power Regulator driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff -urpN linux-2.6.34/drivers/regulator/Kconfig
linux-2.6.34_test/drivers/regulator/Kconfig
--- linux-2.6.34/drivers/regulator/Kconfig	2010-05-17
02:17:36.000000000 +0500
+++ linux-2.6.34_test/drivers/regulator/Kconfig	2010-06-28
19:49:22.000000000 +0500
@@ -201,5 +201,11 @@ config REGULATOR_88PM8607
 	help
 	  This driver supports 88PM8607 voltage regulator chips.
 
+config REGULATOR_DA9052
+	tristate "Support regulators on Dialog Semiconductor DA9052
PMIC"
+	depends on PMIC_DA9052
+	help
+	  Say y here to support the BUCKs and LDOs regulators found on
+	  Dialog Semiconductor DA9052 PMIC.
 endif
 
diff -urpN linux-2.6.34/drivers/regulator/Makefile
linux-2.6.34_test/drivers/regulator/Makefile
--- linux-2.6.34/drivers/regulator/Makefile	2010-05-17
02:17:36.000000000 +0500
+++ linux-2.6.34_test/drivers/regulator/Makefile	2010-06-28
19:49:16.000000000 +0500
@@ -31,5 +31,6 @@ obj-$(CONFIG_REGULATOR_AB3100) += ab3100
 obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6507X) += tps6507x-regulator.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
+obj-$(CONFIG_REGULATOR_DA9052)  += da9052-regulator.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff -urpN linux-2.6.34/include/linux/mfd/da9052/pm.h
linux-2.6.34_test/include/linux/mfd/da9052/pm.h
--- linux-2.6.34/include/linux/mfd/da9052/pm.h	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/include/linux/mfd/da9052/pm.h	2010-06-28
19:49:53.000000000 +0500
@@ -0,0 +1,87 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * pm.h: Power Manager for DA9052
+ * Header file contain the structure, prototype and defines needed for
+ * PM driver API's
+ */
+
+#ifndef _PM_H
+#define _PM_H
+
+/* PM Device name and static Major number macros */
+#define DA9052_PM_DEVICE_NAME		"da9052_regulator"
+
+/* PM Device Macros */
+#define DA9052_LDO1			1
+#define DA9052_LDO2			2
+#define DA9052_LDO3			3
+#define DA9052_LDO4			4
+#define DA9052_LDO5			5
+#define DA9052_LDO6			6
+#define DA9052_LDO7			7
+#define DA9052_LDO8			8
+#define DA9052_LDO9			9
+#define DA9052_LDO10			10
+#define DA9052_BUCK_CORE		11
+#define DA9052_BUCK_PRO			12
+#define DA9052_BUCK_MEM			13
+#define DA9052_BUCK_PERI		14
+
+/* PM Device Error Codes */
+#define INVALID_BUCK_NUM			2
+#define INVALID_LDO_NUM				3
+#define INVALID_PM_EVENT			4
+#define INVALID_BUCKCORE_VOLT_VALUE		5
+#define INVALID_BUCKPRO_VOLT_VALUE		6
+#define INVALID_BUCKMEM_VOLT_VALUE		7
+#define INVALID_BUCKPERI_VOLT_VALUE		8
+#define INVALID_LDO1_VOLT_VALUE			9
+#define INVALID_LDO2_VOLT_VALUE			10
+#define INVALID_LDO3_VOLT_VALUE			11
+#define INVALID_LDO4_VOLT_VALUE			12
+#define INVALID_LDO5_VOLT_VALUE			13
+#define INVALID_LDO6_VOLT_VALUE			14
+#define INVALID_LDO7_VOLT_VALUE			15
+#define INVALID_LDO8_VOLT_VALUE			16
+#define INVALID_LDO9_VOLT_VALUE			17
+#define INVALID_LDO10_VOLT_VALUE		18
+#define INVALID_PM_IOCTL			19
+#define INVALID_OPERATION_ON_MERGED_BUCK	20
+#define INVALID_PD_FUNCTION			21
+
+/* Buck Config Validation Macros */
+#define BUCK_CORE_PRO_VOLT_UPPER	2075
+#define BUCK_CORE_PRO_VOLT_LOWER	500
+#define BUCK_CORE_PRO_STEP		25
+#define BUCK_MEM_VOLT_UPPER		2500
+#define BUCK_MEM_VOLT_LOWER		925
+#define BUCK_MEM_STEP			25
+#define BUCK_PERI_VOLT_UPPER		3600
+#define BUCK_PERI_VOLT_LOWER		1800
+#define BUCK_PERI_STEP_BELOW_3000	50
+#define BUCK_PERI_STEP_ABOVE_3000	100000
+#define BUCK_PERI_VALUES_UPTO_3000	24
+#define BUCK_PERI_VALUES_3000		3000000
+#define LDO1_VOLT_UPPER			1800
+#define LDO1_VOLT_LOWER			600
+#define LDO1_VOLT_STEP			50
+#define LDO2_VOLT_UPPER			1800
+#define LDO2_VOLT_LOWER			600
+#define LDO2_VOLT_STEP			25
+#define LDO34_VOLT_UPPER		3300
+#define LDO34_VOLT_LOWER		1725
+#define LDO34_VOLT_STEP			25
+#define LDO567810_VOLT_UPPER		3600
+#define LDO567810_VOLT_LOWER		1200
+#define LDO567810_VOLT_STEP		50
+#define LDO9_VOLT_UPPER			3650
+#define LDO9_VOLT_LOWER			1250
+#define LDO9_VOLT_STEP			50
+
+#endif /* _PM_H */
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
