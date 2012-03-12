Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2CLH6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 03:58:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59825 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2CLH6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 03:58:01 -0400
Message-ID: <1331539070.13086.2.camel@phoenix>
Subject: [PATCH RFC/RFT 1/2] regulator: Refactor tps6507x to use one
 tps6507x_pmic_ops for all LDOs and DCDCs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 12 Mar 2012 15:57:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the callback functions implementation for DCDCx and LDOx are very similar,
I think it is ok to use one tps6507x_pmic_ops for all LDOs and DCDCs.
This refactor removes a couple of duplicated code.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6507x-regulator.c |  268 ++++++++------------------------
 1 files changed, 67 insertions(+), 201 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 0b63ef7..e140a15 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -238,16 +238,16 @@ static int tps6507x_pmic_reg_write(struct tps6507x_pmic *tps, u8 reg, u8 val)
 	return err;
 }
 
-static int tps6507x_pmic_dcdc_is_enabled(struct regulator_dev *dev)
+static int tps6507x_pmic_is_enabled(struct regulator_dev *dev)
 {
 	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int data, dcdc = rdev_get_id(dev);
+	int data, rid = rdev_get_id(dev);
 	u8 shift;
 
-	if (dcdc < TPS6507X_DCDC_1 || dcdc > TPS6507X_DCDC_3)
+	if (rid < TPS6507X_DCDC_1 || rid > TPS6507X_LDO_2)
 		return -EINVAL;
 
-	shift = TPS6507X_MAX_REG_ID - dcdc;
+	shift = TPS6507X_MAX_REG_ID - rid;
 	data = tps6507x_pmic_reg_read(tps, TPS6507X_REG_CON_CTRL1);
 
 	if (data < 0)
@@ -256,99 +256,65 @@ static int tps6507x_pmic_dcdc_is_enabled(struct regulator_dev *dev)
 		return (data & 1<<shift) ? 1 : 0;
 }
 
-static int tps6507x_pmic_ldo_is_enabled(struct regulator_dev *dev)
+static int tps6507x_pmic_enable(struct regulator_dev *dev)
 {
 	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int data, ldo = rdev_get_id(dev);
+	int rid = rdev_get_id(dev);
 	u8 shift;
 
-	if (ldo < TPS6507X_LDO_1 || ldo > TPS6507X_LDO_2)
+	if (rid < TPS6507X_DCDC_1 || rid > TPS6507X_LDO_2)
 		return -EINVAL;
 
-	shift = TPS6507X_MAX_REG_ID - ldo;
-	data = tps6507x_pmic_reg_read(tps, TPS6507X_REG_CON_CTRL1);
-
-	if (data < 0)
-		return data;
-	else
-		return (data & 1<<shift) ? 1 : 0;
-}
-
-static int tps6507x_pmic_dcdc_enable(struct regulator_dev *dev)
-{
-	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int dcdc = rdev_get_id(dev);
-	u8 shift;
-
-	if (dcdc < TPS6507X_DCDC_1 || dcdc > TPS6507X_DCDC_3)
-		return -EINVAL;
-
-	shift = TPS6507X_MAX_REG_ID - dcdc;
-	return tps6507x_pmic_set_bits(tps, TPS6507X_REG_CON_CTRL1, 1 << shift);
-}
-
-static int tps6507x_pmic_dcdc_disable(struct regulator_dev *dev)
-{
-	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int dcdc = rdev_get_id(dev);
-	u8 shift;
-
-	if (dcdc < TPS6507X_DCDC_1 || dcdc > TPS6507X_DCDC_3)
-		return -EINVAL;
-
-	shift = TPS6507X_MAX_REG_ID - dcdc;
-	return tps6507x_pmic_clear_bits(tps, TPS6507X_REG_CON_CTRL1,
-					1 << shift);
-}
-
-static int tps6507x_pmic_ldo_enable(struct regulator_dev *dev)
-{
-	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int ldo = rdev_get_id(dev);
-	u8 shift;
-
-	if (ldo < TPS6507X_LDO_1 || ldo > TPS6507X_LDO_2)
-		return -EINVAL;
-
-	shift = TPS6507X_MAX_REG_ID - ldo;
+	shift = TPS6507X_MAX_REG_ID - rid;
 	return tps6507x_pmic_set_bits(tps, TPS6507X_REG_CON_CTRL1, 1 << shift);
 }
 
-static int tps6507x_pmic_ldo_disable(struct regulator_dev *dev)
+static int tps6507x_pmic_disable(struct regulator_dev *dev)
 {
 	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int ldo = rdev_get_id(dev);
+	int rid = rdev_get_id(dev);
 	u8 shift;
 
-	if (ldo < TPS6507X_LDO_1 || ldo > TPS6507X_LDO_2)
+	if (rid < TPS6507X_DCDC_1 || rid > TPS6507X_LDO_2)
 		return -EINVAL;
 
-	shift = TPS6507X_MAX_REG_ID - ldo;
+	shift = TPS6507X_MAX_REG_ID - rid;
 	return tps6507x_pmic_clear_bits(tps, TPS6507X_REG_CON_CTRL1,
 					1 << shift);
 }
 
-static int tps6507x_pmic_dcdc_get_voltage(struct regulator_dev *dev)
+static int tps6507x_pmic_get_voltage(struct regulator_dev *dev)
 {
 	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int data, dcdc = rdev_get_id(dev);
-	u8 reg;
+	int data, rid = rdev_get_id(dev);
+	u8 reg, mask;
 
-	switch (dcdc) {
+	switch (rid) {
 	case TPS6507X_DCDC_1:
 		reg = TPS6507X_REG_DEFDCDC1;
+		mask = TPS6507X_DEFDCDCX_DCDC_MASK;
 		break;
 	case TPS6507X_DCDC_2:
-		if (tps->info[dcdc]->defdcdc_default)
+		if (tps->info[rid]->defdcdc_default)
 			reg = TPS6507X_REG_DEFDCDC2_HIGH;
 		else
 			reg = TPS6507X_REG_DEFDCDC2_LOW;
+		mask = TPS6507X_DEFDCDCX_DCDC_MASK;
 		break;
 	case TPS6507X_DCDC_3:
-		if (tps->info[dcdc]->defdcdc_default)
+		if (tps->info[rid]->defdcdc_default)
 			reg = TPS6507X_REG_DEFDCDC3_HIGH;
 		else
 			reg = TPS6507X_REG_DEFDCDC3_LOW;
+		mask = TPS6507X_DEFDCDCX_DCDC_MASK;
+		break;
+	case TPS6507X_LDO_1:
+		reg = TPS6507X_REG_LDO_CTRL1;
+		mask = TPS6507X_REG_LDO_CTRL1_LDO1_MASK;
+		break;
+	case TPS6507X_LDO_2:
+		reg = TPS6507X_REG_DEFLDO2;
+		mask = TPS6507X_REG_DEFLDO2_LDO2_MASK;
 		break;
 	default:
 		return -EINVAL;
@@ -358,47 +324,56 @@ static int tps6507x_pmic_dcdc_get_voltage(struct regulator_dev *dev)
 	if (data < 0)
 		return data;
 
-	data &= TPS6507X_DEFDCDCX_DCDC_MASK;
-	return tps->info[dcdc]->table[data] * 1000;
+	data &= mask;
+	return tps->info[rid]->table[data] * 1000;
 }
 
-static int tps6507x_pmic_dcdc_set_voltage(struct regulator_dev *dev,
+static int tps6507x_pmic_set_voltage(struct regulator_dev *dev,
 					  int min_uV, int max_uV,
 					  unsigned *selector)
 {
 	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int data, vsel, dcdc = rdev_get_id(dev);
-	u8 reg;
+	int data, vsel, rid = rdev_get_id(dev);
+	u8 reg, mask;
 
-	switch (dcdc) {
+	switch (rid) {
 	case TPS6507X_DCDC_1:
 		reg = TPS6507X_REG_DEFDCDC1;
+		mask = TPS6507X_DEFDCDCX_DCDC_MASK;
 		break;
 	case TPS6507X_DCDC_2:
-		if (tps->info[dcdc]->defdcdc_default)
+		if (tps->info[rid]->defdcdc_default)
 			reg = TPS6507X_REG_DEFDCDC2_HIGH;
 		else
 			reg = TPS6507X_REG_DEFDCDC2_LOW;
+		mask = TPS6507X_DEFDCDCX_DCDC_MASK;
 		break;
 	case TPS6507X_DCDC_3:
-		if (tps->info[dcdc]->defdcdc_default)
+		if (tps->info[rid]->defdcdc_default)
 			reg = TPS6507X_REG_DEFDCDC3_HIGH;
 		else
 			reg = TPS6507X_REG_DEFDCDC3_LOW;
+		mask = TPS6507X_DEFDCDCX_DCDC_MASK;
+		break;
+	case TPS6507X_LDO_1:
+		reg = TPS6507X_REG_LDO_CTRL1;
+		mask = TPS6507X_REG_LDO_CTRL1_LDO1_MASK;
+		break;
+	case TPS6507X_LDO_2:
+		reg = TPS6507X_REG_DEFLDO2;
+		mask = TPS6507X_REG_DEFLDO2_LDO2_MASK;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (min_uV < tps->info[dcdc]->min_uV
-		|| min_uV > tps->info[dcdc]->max_uV)
+	if (min_uV < tps->info[rid]->min_uV || min_uV > tps->info[rid]->max_uV)
 		return -EINVAL;
-	if (max_uV < tps->info[dcdc]->min_uV
-		|| max_uV > tps->info[dcdc]->max_uV)
+	if (max_uV < tps->info[rid]->min_uV || max_uV > tps->info[rid]->max_uV)
 		return -EINVAL;
 
-	for (vsel = 0; vsel < tps->info[dcdc]->table_len; vsel++) {
-		int mV = tps->info[dcdc]->table[vsel];
+	for (vsel = 0; vsel < tps->info[rid]->table_len; vsel++) {
+		int mV = tps->info[rid]->table[vsel];
 		int uV = mV * 1000;
 
 		/* Break at the first in-range value */
@@ -407,78 +382,7 @@ static int tps6507x_pmic_dcdc_set_voltage(struct regulator_dev *dev,
 	}
 
 	/* write to the register in case we found a match */
-	if (vsel == tps->info[dcdc]->table_len)
-		return -EINVAL;
-
-	*selector = vsel;
-
-	data = tps6507x_pmic_reg_read(tps, reg);
-	if (data < 0)
-		return data;
-
-	data &= ~TPS6507X_DEFDCDCX_DCDC_MASK;
-	data |= vsel;
-
-	return tps6507x_pmic_reg_write(tps, reg, data);
-}
-
-static int tps6507x_pmic_ldo_get_voltage(struct regulator_dev *dev)
-{
-	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int data, ldo = rdev_get_id(dev);
-	u8 reg, mask;
-
-	if (ldo < TPS6507X_LDO_1 || ldo > TPS6507X_LDO_2)
-		return -EINVAL;
-	else {
-		reg = (ldo == TPS6507X_LDO_1 ?
-			TPS6507X_REG_LDO_CTRL1 : TPS6507X_REG_DEFLDO2);
-		mask = (ldo == TPS6507X_LDO_1 ?
-			TPS6507X_REG_LDO_CTRL1_LDO1_MASK :
-				TPS6507X_REG_DEFLDO2_LDO2_MASK);
-	}
-
-	data = tps6507x_pmic_reg_read(tps, reg);
-	if (data < 0)
-		return data;
-
-	data &= mask;
-	return tps->info[ldo]->table[data] * 1000;
-}
-
-static int tps6507x_pmic_ldo_set_voltage(struct regulator_dev *dev,
-					 int min_uV, int max_uV,
-					 unsigned *selector)
-{
-	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int data, vsel, ldo = rdev_get_id(dev);
-	u8 reg, mask;
-
-	if (ldo < TPS6507X_LDO_1 || ldo > TPS6507X_LDO_2)
-		return -EINVAL;
-	else {
-		reg = (ldo == TPS6507X_LDO_1 ?
-			TPS6507X_REG_LDO_CTRL1 : TPS6507X_REG_DEFLDO2);
-		mask = (ldo == TPS6507X_LDO_1 ?
-			TPS6507X_REG_LDO_CTRL1_LDO1_MASK :
-				TPS6507X_REG_DEFLDO2_LDO2_MASK);
-	}
-
-	if (min_uV < tps->info[ldo]->min_uV || min_uV > tps->info[ldo]->max_uV)
-		return -EINVAL;
-	if (max_uV < tps->info[ldo]->min_uV || max_uV > tps->info[ldo]->max_uV)
-		return -EINVAL;
-
-	for (vsel = 0; vsel < tps->info[ldo]->table_len; vsel++) {
-		int mV = tps->info[ldo]->table[vsel];
-		int uV = mV * 1000;
-
-		/* Break at the first in-range value */
-		if (min_uV <= uV && uV <= max_uV)
-			break;
-	}
-
-	if (vsel == tps->info[ldo]->table_len)
+	if (vsel == tps->info[rid]->table_len)
 		return -EINVAL;
 
 	*selector = vsel;
@@ -493,58 +397,31 @@ static int tps6507x_pmic_ldo_set_voltage(struct regulator_dev *dev,
 	return tps6507x_pmic_reg_write(tps, reg, data);
 }
 
-static int tps6507x_pmic_dcdc_list_voltage(struct regulator_dev *dev,
+static int tps6507x_pmic_list_voltage(struct regulator_dev *dev,
 					unsigned selector)
 {
 	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int dcdc = rdev_get_id(dev);
+	int rid = rdev_get_id(dev);
 
-	if (dcdc < TPS6507X_DCDC_1 || dcdc > TPS6507X_DCDC_3)
+	if (rid < TPS6507X_DCDC_1 || rid > TPS6507X_LDO_2)
 		return -EINVAL;
 
-	if (selector >= tps->info[dcdc]->table_len)
+	if (selector >= tps->info[rid]->table_len)
 		return -EINVAL;
 	else
-		return tps->info[dcdc]->table[selector] * 1000;
+		return tps->info[rid]->table[selector] * 1000;
 }
 
-static int tps6507x_pmic_ldo_list_voltage(struct regulator_dev *dev,
-					unsigned selector)
-{
-	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
-	int ldo = rdev_get_id(dev);
-
-	if (ldo < TPS6507X_LDO_1 || ldo > TPS6507X_LDO_2)
-		return -EINVAL;
-
-	if (selector >= tps->info[ldo]->table_len)
-		return -EINVAL;
-	else
-		return tps->info[ldo]->table[selector] * 1000;
-}
-
-/* Operations permitted on VDCDCx */
-static struct regulator_ops tps6507x_pmic_dcdc_ops = {
-	.is_enabled = tps6507x_pmic_dcdc_is_enabled,
-	.enable = tps6507x_pmic_dcdc_enable,
-	.disable = tps6507x_pmic_dcdc_disable,
-	.get_voltage = tps6507x_pmic_dcdc_get_voltage,
-	.set_voltage = tps6507x_pmic_dcdc_set_voltage,
-	.list_voltage = tps6507x_pmic_dcdc_list_voltage,
+static struct regulator_ops tps6507x_pmic_ops = {
+	.is_enabled = tps6507x_pmic_is_enabled,
+	.enable = tps6507x_pmic_enable,
+	.disable = tps6507x_pmic_disable,
+	.get_voltage = tps6507x_pmic_get_voltage,
+	.set_voltage = tps6507x_pmic_set_voltage,
+	.list_voltage = tps6507x_pmic_list_voltage,
 };
 
-/* Operations permitted on LDOx */
-static struct regulator_ops tps6507x_pmic_ldo_ops = {
-	.is_enabled = tps6507x_pmic_ldo_is_enabled,
-	.enable = tps6507x_pmic_ldo_enable,
-	.disable = tps6507x_pmic_ldo_disable,
-	.get_voltage = tps6507x_pmic_ldo_get_voltage,
-	.set_voltage = tps6507x_pmic_ldo_set_voltage,
-	.list_voltage = tps6507x_pmic_ldo_list_voltage,
-};
-
-static __devinit
-int tps6507x_pmic_probe(struct platform_device *pdev)
+static __devinit int tps6507x_pmic_probe(struct platform_device *pdev)
 {
 	struct tps6507x_dev *tps6507x_dev = dev_get_drvdata(pdev->dev.parent);
 	struct tps_info *info = &tps6507x_pmic_regs[0];
@@ -593,8 +470,7 @@ int tps6507x_pmic_probe(struct platform_device *pdev)
 		tps->desc[i].name = info->name;
 		tps->desc[i].id = i;
 		tps->desc[i].n_voltages = info->table_len;
-		tps->desc[i].ops = (i > TPS6507X_DCDC_3 ?
-		&tps6507x_pmic_ldo_ops : &tps6507x_pmic_dcdc_ops);
+		tps->desc[i].ops = &tps6507x_pmic_ops;
 		tps->desc[i].type = REGULATOR_VOLTAGE;
 		tps->desc[i].owner = THIS_MODULE;
 
@@ -648,22 +524,12 @@ static struct platform_driver tps6507x_pmic_driver = {
 	.remove = __devexit_p(tps6507x_pmic_remove),
 };
 
-/**
- * tps6507x_pmic_init
- *
- * Module init function
- */
 static int __init tps6507x_pmic_init(void)
 {
 	return platform_driver_register(&tps6507x_pmic_driver);
 }
 subsys_initcall(tps6507x_pmic_init);
 
-/**
- * tps6507x_pmic_cleanup
- *
- * Module exit function
- */
 static void __exit tps6507x_pmic_cleanup(void)
 {
 	platform_driver_unregister(&tps6507x_pmic_driver);
-- 
1.7.5.4



