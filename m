Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab2ADJwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 04:52:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36051 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab2ADJwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 04:52:34 -0500
From: AnilKumar Ch <anilkumar@ti.com>
To: <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH V3 2/2] regulator: tps65217: Add tps65217 regulator driver
Date: Wed, 4 Jan 2012 15:22:27 +0530
Message-ID: <1325670747-31429-1-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds tps65217 PMIC as a regulator

The regulator module consists of 3 DCDCs and 4 LDOs. The output
voltages are configurable and are meant to supply power to the
main processor and other components

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
---
 drivers/regulator/Kconfig              |    9 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps65217-regulator.c |  435 ++++++++++++++++++++++++++++++++
 3 files changed, 445 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/tps65217-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 9713b1b..529c591 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -259,6 +259,15 @@ config REGULATOR_TPS6507X
 	  three step-down converters and two general-purpose LDO voltage regulators.
 	  It supports TI's software based Class-2 SmartReflex implementation.
 
+config REGULATOR_TPS65217
+	tristate "TI TPS65217 Power regulators"
+	depends on MFD_TPS65217
+	help
+	  This driver supports TPS65217 voltage regulator chips. TPS65217
+	  provides three step-down converters and four general-purpose LDO
+	  voltage regulators. It supports software based voltage control
+	  for different voltage domains
+
 config REGULATOR_TPS65912
 	tristate "TI TPS65912 Power regulator"
 	depends on (MFD_TPS65912_I2C || MFD_TPS65912_SPI)
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 93a6318..aeae546 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
 obj-$(CONFIG_REGULATOR_TPS6105X) += tps6105x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6507X) += tps6507x-regulator.o
+obj-$(CONFIG_REGULATOR_TPS65217) += tps65217-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6524X) += tps6524x-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65912) += tps65912-regulator.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
new file mode 100644
index 0000000..a5d7d9f
--- /dev/null
+++ b/drivers/regulator/tps65217-regulator.c
@@ -0,0 +1,435 @@
+/*
+ * tps65217-regulator.c
+ *
+ * Regulator driver for TPS65217 PMIC
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/mfd/tps65217.h>
+
+#define TPS65217_REGULATOR(_name, _id, _ops, _n)	\
+	{						\
+		.name		= _name,		\
+		.id		= _id,			\
+		.ops		= &_ops,		\
+		.n_voltages	= _n,			\
+		.type		= REGULATOR_VOLTAGE,	\
+		.owner		= THIS_MODULE,		\
+	}						\
+
+#define TPS65217_INFO(_name, _fun, _n, _emsk, _vreg, _vmsk)	\
+	{						\
+		.name		= _name,		\
+		.tps_range	= _fun,			\
+		.table_len	= _n,			\
+		.enable_mask	= _emsk,		\
+		.set_vout_reg	= _vreg,		\
+		.set_vout_mask	= _vmsk,		\
+	}
+
+static int tps65217_vsel_to_uv_range0(unsigned int vsel)
+{
+	int uV = 0;
+
+	if (vsel > 63)
+		return -EINVAL;
+
+	if (vsel <= 24)
+		uV = vsel * 25000 + 900000;
+	else if (vsel <= 52)
+		uV = (vsel - 24) * 50000 + 1500000;
+	else if (vsel < 56)
+		uV = (vsel - 52) * 100000 + 2900000;
+	else
+		uV = 3300000;
+
+	return uV;
+}
+
+static int tps65217_vsel_to_uv_range1(unsigned int vsel)
+{
+	int uV = 0;
+
+	if (vsel > 15)
+		return -EINVAL;
+
+	if (vsel <= 2)
+		uV = vsel * 100000 + 1000000;
+	else if (vsel <= 6)
+		uV = (vsel - 2) * 50000 + 1200000;
+	else if (vsel <= 9)
+		uV = (vsel - 6) * 100000 + 1400000;
+	else if (vsel == 10)
+		uV = 2500000;
+	else if (vsel == 11)
+		uV = 2750000;
+	else if (vsel == 12)
+		uV = 2800000;
+	else if (vsel == 13)
+		uV = 3000000;
+	else if (vsel == 14)
+		uV = 3100000;
+	else
+		uV = 3300000;
+
+	return uV;
+}
+
+static int tps65217_vsel_to_uv_range2(unsigned int vsel)
+{
+	int uV = 0;
+
+	if (vsel > 31)
+		return -EINVAL;
+
+	if (vsel <= 8)
+		uV = vsel * 50000 + 1500000;
+	else if (vsel <= 13)
+		uV = (vsel - 8) * 100000 + 1900000;
+	else
+		uV = (vsel - 13) * 50000 + 2400000;
+
+	return uV;
+}
+
+static struct tps_info tps65217_pmic_regs[] = {
+	TPS65217_INFO("DCDC1", tps65217_vsel_to_uv_range0, 64,
+			TPS65217_ENABLE_DC1_EN, TPS65217_REG_DEFDCDC1,
+			TPS65217_DEFDCDCX_DCDC_MASK),
+	TPS65217_INFO("DCDC2", tps65217_vsel_to_uv_range0, 64,
+			TPS65217_ENABLE_DC2_EN, TPS65217_REG_DEFDCDC2,
+			TPS65217_DEFDCDCX_DCDC_MASK),
+	TPS65217_INFO("DCDC3", tps65217_vsel_to_uv_range0, 64,
+			TPS65217_ENABLE_DC3_EN, TPS65217_REG_DEFDCDC3,
+			TPS65217_DEFDCDCX_DCDC_MASK),
+	TPS65217_INFO("LDO1", tps65217_vsel_to_uv_range1, 16,
+			TPS65217_ENABLE_LDO1_EN, TPS65217_REG_DEFLDO1,
+			TPS65217_DEFLDO1_LDO1_MASK),
+	TPS65217_INFO("LDO2", tps65217_vsel_to_uv_range0, 64,
+			TPS65217_ENABLE_LDO2_EN, TPS65217_REG_DEFLDO2,
+			TPS65217_DEFLDO2_LDO2_MASK),
+	TPS65217_INFO("LDO3", tps65217_vsel_to_uv_range2, 32,
+			TPS65217_ENABLE_LS1_EN | TPS65217_DEFLDO3_LDO3_EN,
+			TPS65217_REG_DEFLS1, TPS65217_DEFLDO3_LDO3_MASK),
+	TPS65217_INFO("LDO4", tps65217_vsel_to_uv_range2, 32,
+			TPS65217_ENABLE_LS2_EN | TPS65217_DEFLDO4_LDO4_EN,
+			TPS65217_REG_DEFLS2, TPS65217_DEFLDO4_LDO4_MASK),
+};
+
+static int tps65217_pmic_dcdc_is_enabled(struct regulator_dev *dev)
+{
+	int ret;
+	struct tps65217 *tps = rdev_get_drvdata(dev);
+	unsigned int data, dcdc = rdev_get_id(dev);
+
+	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
+		return -EINVAL;
+
+	ret = tps65217_reg_read(tps, TPS65217_REG_ENABLE, &data);
+	if (ret)
+		return ret;
+
+	return (data & tps->info[dcdc]->enable_mask) ? 1 : 0;
+}
+
+static int tps65217_pmic_ldo_is_enabled(struct regulator_dev *dev)
+{
+	int ret;
+	struct tps65217 *tps = rdev_get_drvdata(dev);
+	unsigned int data, ldo = rdev_get_id(dev);
+
+	if (ldo < TPS65217_LDO_1 || ldo > TPS65217_LDO_4)
+		return -EINVAL;
+
+	ret = tps65217_reg_read(tps, TPS65217_REG_ENABLE, &data);
+	if (ret)
+		return ret;
+
+	return (data & tps->info[ldo]->enable_mask) ? 1 : 0;
+}
+
+static int tps65217_pmic_dcdc_enable(struct regulator_dev *dev)
+{
+	struct tps65217 *tps = rdev_get_drvdata(dev);
+	unsigned int dcdc = rdev_get_id(dev);
+
+	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
+		return -EINVAL;
+
+	/* Enable the regulator and password protection is level 1 */
+	return tps65217_set_bits(tps, TPS65217_REG_ENABLE,
+				tps->info[dcdc]->enable_mask,
+				tps->info[dcdc]->enable_mask,
+				TPS65217_PROTECT_L1);
+}
+
+static int tps65217_pmic_dcdc_disable(struct regulator_dev *dev)
+{
+	struct tps65217 *tps = rdev_get_drvdata(dev);
+	unsigned int dcdc = rdev_get_id(dev);
+
+	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
+		return -EINVAL;
+
+	/* Disable the regulator and password protection is level 1 */
+	return tps65217_clear_bits(tps, TPS65217_REG_ENABLE,
+			tps->info[dcdc]->enable_mask, TPS65217_PROTECT_L1);
+}
+
+static int tps65217_pmic_ldo_enable(struct regulator_dev *dev)
+{
+	struct tps65217 *tps = rdev_get_drvdata(dev);
+	unsigned int ldo = rdev_get_id(dev);
+
+	if (ldo < TPS65217_LDO_1 || ldo > TPS65217_LDO_4)
+		return -EINVAL;
+
+	/* Enable the regulator and password protection is level 1 */
+	return tps65217_set_bits(tps, TPS65217_REG_ENABLE,
+				tps->info[ldo]->enable_mask,
+				tps->info[ldo]->enable_mask,
+				TPS65217_PROTECT_L1);
+}
+
+static int tps65217_pmic_ldo_disable(struct regulator_dev *dev)
+{
+	struct tps65217 *tps = rdev_get_drvdata(dev);
+	unsigned int ldo = rdev_get_id(dev);
+
+	if (ldo < TPS65217_LDO_1 || ldo > TPS65217_LDO_4)
+		return -EINVAL;
+
+	/* Disable the regulator and password protection is level 1 */
+	return tps65217_clear_bits(tps, TPS65217_REG_ENABLE,
+			tps->info[ldo]->enable_mask, TPS65217_PROTECT_L1);
+}
+
+static int tps65217_pmic_dcdc_get_voltage(struct regulator_dev *dev)
+{
+	int ret;
+	struct tps65217 *tps = rdev_get_drvdata(dev);
+	unsigned int data, dcdc = rdev_get_id(dev);
+
+	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
+		return -EINVAL;
+
+	ret = tps65217_reg_read(tps, tps->info[dcdc]->set_vout_reg, &data);
+	if (ret)
+		return ret;
+
+	data &= tps->info[dcdc]->set_vout_mask;
+
+	ret = tps->info[dcdc]->tps_range(data);
+	if (ret < 0)
+		dev_err(&dev->dev, "Failed to get voltage\n");
+
+	return ret;
+}
+
+static int tps65217_pmic_dcdc_set_voltage(struct regulator_dev *dev,
+						unsigned selector)
+{
+	int ret;
+	struct tps65217 *tps = rdev_get_drvdata(dev);
+	int dcdc = rdev_get_id(dev);
+
+	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
+		return -EINVAL;
+
+	if (selector >= tps->info[dcdc]->table_len)
+		return -EINVAL;
+
+	/* Set the voltage based on vsel value and write protect level is 2 */
+	ret = tps65217_set_bits(tps, tps->info[dcdc]->set_vout_reg,
+					tps->info[dcdc]->set_vout_mask,
+					selector, TPS65217_PROTECT_L2);
+	if (ret)
+		return ret;
+
+	/* Set GO bit to initiate voltage transistion */
+	return tps65217_set_bits(tps, TPS65217_REG_DEFSLEW,
+				TPS65217_DEFSLEW_GO, TPS65217_DEFSLEW_GO,
+				TPS65217_PROTECT_L2);
+}
+
+static int tps65217_pmic_ldo_get_voltage(struct regulator_dev *dev)
+{
+	int ret;
+	struct tps65217 *tps = rdev_get_drvdata(dev);
+	unsigned int data, ldo = rdev_get_id(dev);
+
+	if (ldo < TPS65217_LDO_1 || ldo > TPS65217_LDO_4)
+		return -EINVAL;
+
+	ret = tps65217_reg_read(tps, tps->info[ldo]->set_vout_reg, &data);
+	if (ret)
+		return ret;
+
+	data &= tps->info[ldo]->set_vout_mask;
+
+	ret = tps->info[ldo]->tps_range(data);
+	if (ret < 0)
+		dev_err(&dev->dev, "Failed to get voltage\n");
+
+	return ret;
+}
+
+static int tps65217_pmic_ldo_set_voltage(struct regulator_dev *dev,
+						unsigned selector)
+{
+	struct tps65217 *tps = rdev_get_drvdata(dev);
+	int ldo = rdev_get_id(dev);
+
+	if (ldo < TPS65217_LDO_1 || ldo > TPS65217_LDO_4)
+		return -EINVAL;
+
+	if (selector >= tps->info[ldo]->table_len)
+		return -EINVAL;
+
+	/* Set the voltage based on vsel value and write protect level is 2 */
+	return tps65217_set_bits(tps, tps->info[ldo]->set_vout_reg,
+					tps->info[ldo]->set_vout_mask,
+					selector, TPS65217_PROTECT_L2);
+}
+
+static int tps65217_pmic_dcdc_list_voltage(struct regulator_dev *dev,
+					unsigned selector)
+{
+	struct tps65217 *tps = rdev_get_drvdata(dev);
+	unsigned int dcdc = rdev_get_id(dev);
+
+	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
+		return -EINVAL;
+
+	if (selector >= tps->info[dcdc]->table_len)
+		return -EINVAL;
+
+	return tps->info[dcdc]->tps_range(selector);
+}
+
+static int tps65217_pmic_ldo_list_voltage(struct regulator_dev *dev,
+					unsigned selector)
+{
+	struct tps65217 *tps = rdev_get_drvdata(dev);
+	unsigned int ldo = rdev_get_id(dev);
+
+	if (ldo < TPS65217_LDO_1 || ldo > TPS65217_LDO_4)
+		return -EINVAL;
+
+	if (selector >= tps->info[ldo]->table_len)
+		return -EINVAL;
+
+	return tps->info[ldo]->tps_range(selector);
+}
+
+/* Operations permitted on DCDCx */
+static struct regulator_ops tps65217_pmic_dcdc_ops = {
+	.is_enabled		= tps65217_pmic_dcdc_is_enabled,
+	.enable			= tps65217_pmic_dcdc_enable,
+	.disable		= tps65217_pmic_dcdc_disable,
+	.get_voltage		= tps65217_pmic_dcdc_get_voltage,
+	.set_voltage_sel	= tps65217_pmic_dcdc_set_voltage,
+	.list_voltage		= tps65217_pmic_dcdc_list_voltage,
+};
+
+/* Operations permitted on LDOx */
+static struct regulator_ops tps65217_pmic_ldo_ops = {
+	.is_enabled		= tps65217_pmic_ldo_is_enabled,
+	.enable			= tps65217_pmic_ldo_enable,
+	.disable		= tps65217_pmic_ldo_disable,
+	.get_voltage		= tps65217_pmic_ldo_get_voltage,
+	.set_voltage_sel	= tps65217_pmic_ldo_set_voltage,
+	.list_voltage		= tps65217_pmic_ldo_list_voltage,
+};
+
+static struct regulator_desc regulators[] = {
+	TPS65217_REGULATOR("DCDC1", TPS65217_DCDC_1,
+				tps65217_pmic_dcdc_ops, 64),
+	TPS65217_REGULATOR("DCDC2",TPS65217_DCDC_2,
+				tps65217_pmic_dcdc_ops, 64),
+	TPS65217_REGULATOR("DCDC3", TPS65217_DCDC_3,
+				tps65217_pmic_dcdc_ops, 64),
+	TPS65217_REGULATOR("LDO1", TPS65217_LDO_1,
+				tps65217_pmic_ldo_ops, 16),
+	TPS65217_REGULATOR("LDO2", TPS65217_LDO_2,
+				tps65217_pmic_ldo_ops, 64),
+	TPS65217_REGULATOR("LDO3", TPS65217_LDO_3,
+				tps65217_pmic_ldo_ops, 32),
+	TPS65217_REGULATOR("LDO4", TPS65217_LDO_4,
+				tps65217_pmic_ldo_ops, 32),
+};
+
+static int __devinit tps65217_regulator_probe(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev;
+	struct tps65217 *tps;
+	struct tps_info *info = &tps65217_pmic_regs[pdev->id];
+
+	/* Already set by core driver */
+	tps = dev_to_tps65217(pdev->dev.parent);
+	tps->info[pdev->id] = info;
+
+	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
+				  pdev->dev.platform_data, tps);
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+
+	platform_set_drvdata(pdev, rdev);
+
+	return 0;
+}
+
+static int __devexit tps65217_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	regulator_unregister(rdev);
+
+	return 0;
+}
+
+static struct platform_driver tps65217_regulator_driver = {
+	.driver = {
+		.name = "tps65217-pmic",
+	},
+	.probe = tps65217_regulator_probe,
+	.remove = __devexit_p(tps65217_regulator_remove),
+};
+
+static int __init tps65217_regulator_init(void)
+{
+	return platform_driver_register(&tps65217_regulator_driver);
+}
+subsys_initcall(tps65217_regulator_init);
+
+static void __exit tps65217_regulator_exit(void)
+{
+	platform_driver_unregister(&tps65217_regulator_driver);
+}
+module_exit(tps65217_regulator_exit);
+
+
+MODULE_AUTHOR("AnilKumar Ch <anilkumar@ti.com>");
+MODULE_DESCRIPTION("TPS65217 voltage regulator driver");
+MODULE_ALIAS("platform:tps65217-pmic");
+MODULE_LICENSE("GPL v2");
-- 
1.7.0.4

