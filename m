Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab0LUSKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:10:15 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58346 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0LUSKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:10:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=jJjJIr7Pga8m7I9i4U6wrEAZh/E8j9po7m9gkyjPsU7rtx4sA71MMcgkZfAcS+NdbC
         jxbjSzAKA0ujBJ2ZtMQfFpfyBkREQo+JP14tAJc2M5P3mESj9jsttIz2T/ps1xxymmS3
         b6B0+SqRsetyZeNwt6M5qYXl0rV2oQ7VqZREI=
MIME-Version: 1.0
Date: Tue, 21 Dec 2010 19:10:12 +0100
Message-ID: <AANLkTimCp+q54oO0iKbrgR8q=3an9h0qQ7iLYJtiqcw9@mail.gmail.com>
Subject: [PATCHv5 5/11] REGULATOR: Regulator module of DA9052 device driver
From: dd diasemi <dd.diasemi@gmail.com>
To: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulator module for DA9052 PMIC device from Dialog Semiconductor.

Changes made since last submission:
. added device structure
. sorted Kconfig entries

Linux Kernel Version: 2.6.34

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -urpN linux-2.6.34-orig2/drivers/regulator/da9052-regulator.c
linux-2.6.34/drivers/regulator/da9052-regulator.c
--- linux-2.6.34-orig2/drivers/regulator/da9052-regulator.c	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34/drivers/regulator/da9052-regulator.c	2010-10-13
15:32:54.000000000 +0500
@@ -0,0 +1,457 @@
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
+#include <linux/module.h>
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
+static struct regulator_ops da9052_ldo_buck_ops;
+
+
+struct regulator {
+	struct device *dev;
+	struct list_head list;
+	int uA_load;
+	int min_uV;
+	int max_uV;
+	int enabled;
+	char *supply_name;
+	struct device_attribute dev_attr;
+	struct regulator_dev *rdev;
+};
+
+
+
+
+#define DA9052_LDO(_id, max, min, step_v, reg, mbits, cbits) \
+{\
+		.reg_desc	= {\
+		.name		= #_id,\
+		.ops		= &da9052_ldo_buck_ops,\
+		.type		= REGULATOR_VOLTAGE,\
+		.id			= _id,\
+		.owner		= THIS_MODULE,\
+	},\
+	.reg_const = {\
+		.max_uV		= (max) * 1000,\
+		.min_uV		= (min) * 1000,\
+		.valid_ops_mask	= REGULATOR_CHANGE_VOLTAGE\
+		| REGULATOR_CHANGE_STATUS | REGULATOR_CHANGE_MODE,\
+		.valid_modes_mask = REGULATOR_MODE_NORMAL,\
+	},\
+		.step_uV		= (step_v) * 1000,\
+		.reg_add		= (reg),\
+		.mask_bits		= (mbits),\
+		.en_bit_mask	= (cbits),\
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
+	DA9052_LDO(DA9052_LDO1, DA9052_LDO1_VOLT_UPPER, DA9052_LDO1_VOLT_LOWER,
+			DA9052_LDO1_VOLT_STEP, DA9052_LDO1_REG,
+			DA9052_LDO1_VLDO1, DA9052_LDO1_LDO1EN),
+
+	DA9052_LDO(DA9052_LDO2,
+			DA9052_LDO2_VOLT_UPPER, DA9052_LDO2_VOLT_LOWER,
+			DA9052_LDO2_VOLT_STEP, DA9052_LDO2_REG,
+			DA9052_LDO2_VLDO2,
+			DA9052_LDO2_LDO2EN),
+
+	DA9052_LDO(DA9052_LDO3, DA9052_LDO34_VOLT_UPPER,
+			DA9052_LDO34_VOLT_LOWER,
+			DA9052_LDO34_VOLT_STEP, DA9052_LDO3_REG,
+			DA9052_LDO3_VLDO3, DA9052_LDO3_LDO3EN),
+
+	DA9052_LDO(DA9052_LDO4, DA9052_LDO34_VOLT_UPPER,
+			DA9052_LDO34_VOLT_LOWER,
+			DA9052_LDO34_VOLT_STEP, DA9052_LDO4_REG,
+			DA9052_LDO4_VLDO4, DA9052_LDO4_LDO4EN),
+
+	DA9052_LDO(DA9052_LDO5, DA9052_LDO567810_VOLT_UPPER,
+			DA9052_LDO567810_VOLT_LOWER,
+			DA9052_LDO567810_VOLT_STEP, DA9052_LDO5_REG,
+			DA9052_LDO5_VLDO5, DA9052_LDO5_LDO5EN),
+
+	DA9052_LDO(DA9052_LDO6, DA9052_LDO567810_VOLT_UPPER,
+			DA9052_LDO567810_VOLT_LOWER,
+			DA9052_LDO567810_VOLT_STEP, DA9052_LDO6_REG,
+			DA9052_LDO6_VLDO6, DA9052_LDO6_LDO6EN),
+
+	DA9052_LDO(DA9052_LDO7, DA9052_LDO567810_VOLT_UPPER,
+			DA9052_LDO567810_VOLT_LOWER,
+			DA9052_LDO567810_VOLT_STEP, DA9052_LDO7_REG,
+			DA9052_LDO7_VLDO7, DA9052_LDO7_LDO7EN),
+
+	DA9052_LDO(DA9052_LDO8, DA9052_LDO567810_VOLT_UPPER,
+			DA9052_LDO567810_VOLT_LOWER,
+			DA9052_LDO567810_VOLT_STEP, DA9052_LDO8_REG,
+			DA9052_LDO8_VLDO8, DA9052_LDO8_LDO8EN),
+
+	DA9052_LDO(DA9052_LDO9, DA9052_LDO9_VOLT_UPPER,
+			DA9052_LDO9_VOLT_LOWER,
+			DA9052_LDO9_VOLT_STEP,
+			DA9052_LDO9_REG, DA9052_LDO9_VLDO9,
+			DA9052_LDO9_LDO9EN),
+
+	DA9052_LDO(DA9052_LDO10, DA9052_LDO567810_VOLT_UPPER,
+			DA9052_LDO567810_VOLT_LOWER,
+			DA9052_LDO567810_VOLT_STEP, DA9052_LDO10_REG,
+			DA9052_LDO10_VLDO10, DA9052_LDO10_LDO10EN),
+
+	/* BUCKS */
+	DA9052_LDO(DA9052_BUCK_CORE, DA9052_BUCK_CORE_PRO_VOLT_UPPER,
+			DA9052_BUCK_CORE_PRO_VOLT_LOWER,
+			DA9052_BUCK_CORE_PRO_STEP, DA9052_BUCKCORE_REG,
+			DA9052_BUCKCORE_VBCORE, DA9052_BUCKCORE_BCOREEN),
+
+	DA9052_LDO(DA9052_BUCK_PRO, DA9052_BUCK_CORE_PRO_VOLT_UPPER,
+			DA9052_BUCK_CORE_PRO_VOLT_LOWER,
+			DA9052_BUCK_CORE_PRO_STEP, DA9052_BUCKPRO_REG,
+			DA9052_BUCKPRO_VBPRO, DA9052_BUCKPRO_BPROEN),
+
+	DA9052_LDO(DA9052_BUCK_MEM, DA9052_BUCK_MEM_VOLT_UPPER,
+			DA9052_BUCK_MEM_VOLT_LOWER,
+			DA9052_BUCK_MEM_STEP, DA9052_BUCKMEM_REG,
+			DA9052_BUCKMEM_VBMEM, DA9052_BUCKMEM_BMEMEN),
+
+	DA9052_LDO(DA9052_BUCK_PERI, DA9052_BUCK_PERI_VOLT_UPPER,
+			DA9052_BUCK_PERI_VOLT_LOWER,
+			DA9052_BUCK_PERI_STEP_BELOW_3000, DA9052_BUCKPERI_REG,
+			DA9052_BUCKPERI_VBPERI, DA9052_BUCKPERI_BPERIEN),
+};
+
+int da9052_ldo_buck_enable(struct regulator_dev *rdev)
+{
+	struct da9052_regulator_priv *priv = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret = 0;
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
+
+	ssc_msg.data = (ssc_msg.data | da9052_regulators[id].en_bit_mask);
+
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
+
+int da9052_ldo_buck_disable(struct regulator_dev *rdev)
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
+
+	ssc_msg.data = (ssc_msg.data & ~(da9052_regulators[id].en_bit_mask));
+
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
+
+static int da9052_ldo_buck_is_enabled(struct regulator_dev *rdev)
+{
+	struct da9052_regulator_priv *priv = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+	int ret;
+	struct da9052_ssc_msg ssc_msg;
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
+	return (ssc_msg.data & da9052_regulators[id].en_bit_mask) != 0;
+}
+
+int da9052_ldo_buck_set_voltage(struct regulator_dev *rdev,
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
+	if (min_uV < da9052_regulators[id].reg_const.min_uV ||
+		min_uV > da9052_regulators[id].reg_const.max_uV)
+		return -EINVAL;
+	if (max_uV < da9052_regulators[id].reg_const.min_uV ||
+		max_uV > da9052_regulators[id].reg_const.max_uV)
+		return -EINVAL;
+
+	/* Get the ldo register value */
+	/* Varying step size for BUCK PERI */
+	if ((da9052_regulators[id].reg_desc.id == DA9052_BUCK_PERI) &&
+			(min_uV >= DA9052_BUCK_PERI_VALUES_3000)) {
+		ldo_volt = (DA9052_BUCK_PERI_VALUES_3000 -
+			da9052_regulators[id].reg_const.min_uV)/
+			(da9052_regulators[id].step_uV);
+		ldo_volt += (min_uV - DA9052_BUCK_PERI_VALUES_3000)/
+			(DA9052_BUCK_PERI_STEP_ABOVE_3000);
+	} else{
+		ldo_volt = (min_uV - da9052_regulators[id].reg_const.min_uV)/
+			(da9052_regulators[id].step_uV);
+		/* Check for maximum value */
+		if ((ldo_volt * da9052_regulators[id].step_uV) +
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
+
+	ssc_msg.data = (ssc_msg.data & ~(da9052_regulators[id].mask_bits));
+	ssc_msg.data |= ldo_volt;
+
+	ret = priv->da9052->write(priv->da9052, &ssc_msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EIO;
+	}
+
+	/* Set the GO LDO/BUCk bits so that the voltage changes */
+	ssc_msg.addr = DA9052_SUPPLY_REG;
+	ssc_msg.data = 0;
+
+	ret = priv->da9052->read(priv->da9052, &ssc_msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EIO;
+	}
+
+	switch (id) {
+	case DA9052_LDO2:
+		ssc_msg.data = (ssc_msg.data | DA9052_SUPPLY_VLDO2GO);
+	break;
+	case DA9052_LDO3:
+		ssc_msg.data = (ssc_msg.data | DA9052_SUPPLY_VLDO3GO);
+	break;
+	case DA9052_BUCK_CORE:
+		ssc_msg.data = (ssc_msg.data | DA9052_SUPPLY_VBCOREGO);
+	break;
+	case DA9052_BUCK_PRO:
+		ssc_msg.data = (ssc_msg.data | DA9052_SUPPLY_VBPROGO);
+	break;
+	case DA9052_BUCK_MEM:
+		ssc_msg.data = (ssc_msg.data | DA9052_SUPPLY_VBMEMGO);
+	break;
+	default:
+		da9052_unlock(priv->da9052);
+		return -EINVAL;
+	}
+
+	ret = priv->da9052->write(priv->da9052, &ssc_msg);
+	if (ret) {
+		da9052_unlock(priv->da9052);
+		return -EIO;
+	}
+
+	da9052_unlock(priv->da9052);
+
+	return 0;
+}
+
+
+int da9052_ldo_buck_get_voltage(struct regulator_dev *rdev)
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
+		if (ldo_volt >= DA9052_BUCK_PERI_VALUES_UPTO_3000) {
+			ldo_volt_uV = ((DA9052_BUCK_PERI_VALUES_UPTO_3000 *
+				da9052_regulators[id].step_uV)
+				+ da9052_regulators[id].reg_const.min_uV);
+			ldo_volt_uV = (ldo_volt_uV +
+				(ldo_volt - DA9052_BUCK_PERI_VALUES_UPTO_3000)
+				* (DA9052_BUCK_PERI_STEP_ABOVE_3000));
+		} else {
+			ldo_volt_uV =
+				(ldo_volt * da9052_regulators[id].step_uV)
+				+ da9052_regulators[id].reg_const.min_uV;
+		}
+	} else {
+		ldo_volt_uV = (ldo_volt * da9052_regulators[id].step_uV) +
+				da9052_regulators[id].reg_const.min_uV;
+	}
+	return ldo_volt_uV;
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
+static int __devinit da9052_regulator_probe(struct platform_device *pdev)
+{
+	struct da9052_regulator_priv *priv;
+	struct da9052_regulator_platform_data *pdata =
+				(pdev->dev.platform_data);
+	struct da9052 *da9052 = dev_get_drvdata(pdev->dev.parent);
+	struct regulator_init_data  *init_data;
+	int i, ret = 0;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL)
+		return -ENOMEM;
+
+	priv->da9052 = da9052;
+	for (i = 0; i < 14; i++) {
+
+		init_data = &pdata->regulators[i];
+		init_data->driver_data = da9052;
+		pdev->dev.platform_data = init_data;
+		priv->regulators[i] = regulator_register(
+				&da9052_regulators[i].reg_desc,
+				&pdev->dev, pdev->dev.platform_data,
+				&da9052_regulators[i]);
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
+	kfree(priv);
+	return ret;
+}
+
+static int __devexit da9052_regulator_remove(struct platform_device *pdev)
+{
+	struct da9052_regulator_priv *priv = platform_get_drvdata(pdev);
+	struct da9052_platform_data *pdata = pdev->dev.platform_data;
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
+		.name	= DRIVER_NAME,
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
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Power Regulator driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff -urpN linux-2.6.34-orig2/drivers/regulator/Kconfig
linux-2.6.34/drivers/regulator/Kconfig
--- linux-2.6.34-orig2/drivers/regulator/Kconfig	2010-10-13
15:28:04.000000000 +0500
+++ linux-2.6.34/drivers/regulator/Kconfig	2010-10-13 10:28:44.000000000 +0500
@@ -142,6 +142,13 @@ config REGULATOR_DA903X
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
diff -urpN linux-2.6.34-orig2/drivers/regulator/Makefile
linux-2.6.34/drivers/regulator/Makefile
--- linux-2.6.34-orig2/drivers/regulator/Makefile	2010-10-13
15:28:16.000000000 +0500
+++ linux-2.6.34/drivers/regulator/Makefile	2010-10-13 10:28:56.000000000 +0500
@@ -23,6 +23,7 @@ obj-$(CONFIG_REGULATOR_WM8350) += wm8350
 obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
 obj-$(CONFIG_REGULATOR_WM8994) += wm8994-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
+obj-$(CONFIG_REGULATOR_DA9052)  += da9052-regulator.o
 obj-$(CONFIG_REGULATOR_PCF50633) += pcf50633-regulator.o
 obj-$(CONFIG_REGULATOR_PCAP) += pcap-regulator.o
 obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
diff -urpN linux-2.6.34-orig2/include/linux/mfd/da9052/pm.h
linux-2.6.34/include/linux/mfd/da9052/pm.h
--- linux-2.6.34-orig2/include/linux/mfd/da9052/pm.h	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34/include/linux/mfd/da9052/pm.h	2010-10-11
11:05:51.000000000 +0500
@@ -0,0 +1,75 @@
+/*
+ * da9052 Power Management module declarations.
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
+#ifndef __LINUX_MFD_DA9052_PM_H
+#define __LINUX_MFD_DA9052_PM_H
+
+/* PM Device name and static Major number macros */
+#define DRIVER_NAME				"da9052-regulator"
+
+/* PM Device Macros */
+#define DA9052_LDO1				0
+#define DA9052_LDO2				1
+#define DA9052_LDO3				2
+#define DA9052_LDO4				3
+#define DA9052_LDO5				4
+#define DA9052_LDO6				5
+#define DA9052_LDO7				6
+#define DA9052_LDO8				7
+#define DA9052_LDO9				8
+#define DA9052_LDO10				9
+#define DA9052_BUCK_CORE			10
+#define DA9052_BUCK_PRO				11
+#define DA9052_BUCK_MEM				12
+#define DA9052_BUCK_PERI			13
+
+/* PM Device Error Codes */
+
+/* Buck Config Validation Macros */
+#define DA9052_BUCK_CORE_PRO_VOLT_UPPER		2075
+#define DA9052_BUCK_CORE_PRO_VOLT_LOWER		500
+#define DA9052_BUCK_CORE_PRO_STEP		25
+#define DA9052_BUCK_MEM_VOLT_UPPER		2500
+#define DA9052_BUCK_MEM_VOLT_LOWER		925
+#define DA9052_BUCK_MEM_STEP			25
+#define DA9052_BUCK_PERI_VOLT_UPPER		3600
+#define DA9052_BUCK_PERI_VOLT_LOWER		1800
+#define DA9052_BUCK_PERI_STEP_BELOW_3000	50
+#define DA9052_BUCK_PERI_STEP_ABOVE_3000	100000
+#define DA9052_BUCK_PERI_VALUES_UPTO_3000	24
+#define DA9052_BUCK_PERI_VALUES_3000		3000000
+#define DA9052_LDO1_VOLT_UPPER			1800
+#define DA9052_LDO1_VOLT_LOWER			600
+#define DA9052_LDO1_VOLT_STEP			50
+#define DA9052_LDO2_VOLT_UPPER			1800
+#define DA9052_LDO2_VOLT_LOWER			600
+#define DA9052_LDO2_VOLT_STEP			25
+#define DA9052_LDO34_VOLT_UPPER			3300
+#define DA9052_LDO34_VOLT_LOWER			1725
+#define DA9052_LDO34_VOLT_STEP			25
+#define DA9052_LDO567810_VOLT_UPPER		3600
+#define DA9052_LDO567810_VOLT_LOWER		1200
+#define DA9052_LDO567810_VOLT_STEP		50
+#define DA9052_LDO9_VOLT_STEP			50
+#define DA9052_LDO9_VOLT_LOWER			1250
+#define DA9052_LDO9_VOLT_UPPER			3650
+
+#endif /* __LINUX_MFD_DA9052_PM_H */
