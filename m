Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab2CLEME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 00:12:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41837 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2CLELz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 00:11:55 -0400
Message-ID: <1331525506.8110.2.camel@phoenix>
Subject: [PATCH] regulator: Merge tps65217_pmic_ldo234_ops and
 tps65217_pmic_dcdc_ops to tps65217_pmic_ops
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: AnilKumar Ch <anilkumar@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 12 Mar 2012 12:11:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most callback functions implementation for tps65217_pmic_ldo234_ops and
tps65217_pmic_dcdc_ops are the same except the rid range checking.

This patch uses tps65217_pmic_ops for all DCDCx, LDO2, LDO3, and LDO4.
And rework tps65217_pmic_set_voltage to make it can be called for
DCDCx, LDO2, LDO3, and LDO4.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65217-regulator.c |  259 +++++++++-----------------------
 1 files changed, 72 insertions(+), 187 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 15f2fa0..e39521b 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -151,166 +151,69 @@ static struct tps_info tps65217_pmic_regs[] = {
 			TPS65217_REG_DEFLS2, TPS65217_DEFLDO4_LDO4_MASK),
 };
 
-static int tps65217_pmic_dcdc_is_enabled(struct regulator_dev *dev)
+static int tps65217_pmic_is_enabled(struct regulator_dev *dev)
 {
 	int ret;
 	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int data, dcdc = rdev_get_id(dev);
+	unsigned int data, rid = rdev_get_id(dev);
 
-	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
+	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
 		return -EINVAL;
 
 	ret = tps65217_reg_read(tps, TPS65217_REG_ENABLE, &data);
 	if (ret)
 		return ret;
 
-	return (data & tps->info[dcdc]->enable_mask) ? 1 : 0;
+	return (data & tps->info[rid]->enable_mask) ? 1 : 0;
 }
 
-static int tps65217_pmic_ldo_is_enabled(struct regulator_dev *dev)
+static int tps65217_pmic_enable(struct regulator_dev *dev)
 {
-	int ret;
 	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int data, ldo = rdev_get_id(dev);
+	unsigned int rid = rdev_get_id(dev);
 
-	if (ldo < TPS65217_LDO_1 || ldo > TPS65217_LDO_4)
-		return -EINVAL;
-
-	ret = tps65217_reg_read(tps, TPS65217_REG_ENABLE, &data);
-	if (ret)
-		return ret;
-
-	return (data & tps->info[ldo]->enable_mask) ? 1 : 0;
-}
-
-static int tps65217_pmic_dcdc_enable(struct regulator_dev *dev)
-{
-	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int dcdc = rdev_get_id(dev);
-
-	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
+	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
 		return -EINVAL;
 
 	/* Enable the regulator and password protection is level 1 */
 	return tps65217_set_bits(tps, TPS65217_REG_ENABLE,
-				tps->info[dcdc]->enable_mask,
-				tps->info[dcdc]->enable_mask,
+				tps->info[rid]->enable_mask,
+				tps->info[rid]->enable_mask,
 				TPS65217_PROTECT_L1);
 }
 
-static int tps65217_pmic_dcdc_disable(struct regulator_dev *dev)
+static int tps65217_pmic_disable(struct regulator_dev *dev)
 {
 	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int dcdc = rdev_get_id(dev);
+	unsigned int rid = rdev_get_id(dev);
 
-	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
+	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
 		return -EINVAL;
 
 	/* Disable the regulator and password protection is level 1 */
 	return tps65217_clear_bits(tps, TPS65217_REG_ENABLE,
-			tps->info[dcdc]->enable_mask, TPS65217_PROTECT_L1);
-}
-
-static int tps65217_pmic_ldo_enable(struct regulator_dev *dev)
-{
-	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int ldo = rdev_get_id(dev);
-
-	if (ldo < TPS65217_LDO_1 || ldo > TPS65217_LDO_4)
-		return -EINVAL;
-
-	/* Enable the regulator and password protection is level 1 */
-	return tps65217_set_bits(tps, TPS65217_REG_ENABLE,
-				tps->info[ldo]->enable_mask,
-				tps->info[ldo]->enable_mask,
-				TPS65217_PROTECT_L1);
-}
-
-static int tps65217_pmic_ldo_disable(struct regulator_dev *dev)
-{
-	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int ldo = rdev_get_id(dev);
-
-	if (ldo < TPS65217_LDO_1 || ldo > TPS65217_LDO_4)
-		return -EINVAL;
-
-	/* Disable the regulator and password protection is level 1 */
-	return tps65217_clear_bits(tps, TPS65217_REG_ENABLE,
-			tps->info[ldo]->enable_mask, TPS65217_PROTECT_L1);
-}
-
-static int tps65217_pmic_dcdc_get_voltage_sel(struct regulator_dev *dev)
-{
-	int ret;
-	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int selector, dcdc = rdev_get_id(dev);
-
-	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
-		return -EINVAL;
-
-	ret = tps65217_reg_read(tps, tps->info[dcdc]->set_vout_reg, &selector);
-	if (ret)
-		return ret;
-
-	selector &= tps->info[dcdc]->set_vout_mask;
-
-	return selector;
+			tps->info[rid]->enable_mask, TPS65217_PROTECT_L1);
 }
 
-static int tps65217_pmic_dcdc_set_voltage(struct regulator_dev *dev,
-				  int min_uV, int max_uV, unsigned *selector)
+static int tps65217_pmic_get_voltage_sel(struct regulator_dev *dev)
 {
 	int ret;
 	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int dcdc = rdev_get_id(dev);
-
-	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
-		return -EINVAL;
+	unsigned int selector, rid = rdev_get_id(dev);
 
-	if (min_uV < tps->info[dcdc]->min_uV
-		|| min_uV > tps->info[dcdc]->max_uV)
+	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
 		return -EINVAL;
 
-	if (max_uV < tps->info[dcdc]->min_uV
-		|| max_uV > tps->info[dcdc]->max_uV)
-		return -EINVAL;
-
-	ret = tps->info[dcdc]->uv_to_vsel(min_uV, selector);
+	ret = tps65217_reg_read(tps, tps->info[rid]->set_vout_reg, &selector);
 	if (ret)
 		return ret;
 
-	/* Set the voltage based on vsel value and write protect level is 2 */
-	ret = tps65217_set_bits(tps, tps->info[dcdc]->set_vout_reg,
-					tps->info[dcdc]->set_vout_mask,
-					*selector, TPS65217_PROTECT_L2);
-	if (ret)
-		return ret;
-
-	/* Set GO bit to initiate voltage transistion */
-	return tps65217_set_bits(tps, TPS65217_REG_DEFSLEW,
-				TPS65217_DEFSLEW_GO, TPS65217_DEFSLEW_GO,
-				TPS65217_PROTECT_L2);
-}
-
-static int tps65217_pmic_ldo_get_voltage_sel(struct regulator_dev *dev)
-{
-	int ret;
-	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int selector, ldo = rdev_get_id(dev);
-
-	if (ldo < TPS65217_LDO_1 || ldo > TPS65217_LDO_4)
-		return -EINVAL;
-
-	ret = tps65217_reg_read(tps, tps->info[ldo]->set_vout_reg, &selector);
-	if (ret)
-		return ret;
-
-	selector &= tps->info[ldo]->set_vout_mask;
+	selector &= tps->info[rid]->set_vout_mask;
 
 	return selector;
 }
 
-static int tps65217_pmic_ldo_set_voltage_sel(struct regulator_dev *dev,
+static int tps65217_pmic_ldo1_set_voltage_sel(struct regulator_dev *dev,
 						unsigned selector)
 {
 	struct tps65217 *tps = rdev_get_drvdata(dev);
@@ -328,112 +231,95 @@ static int tps65217_pmic_ldo_set_voltage_sel(struct regulator_dev *dev,
 					selector, TPS65217_PROTECT_L2);
 }
 
-static int tps65217_pmic_ldo_set_voltage(struct regulator_dev *dev,
+static int tps65217_pmic_set_voltage(struct regulator_dev *dev,
 				  int min_uV, int max_uV, unsigned *selector)
 {
 	int ret;
 	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int ldo = rdev_get_id(dev);
+	unsigned int rid = rdev_get_id(dev);
 
-	if (ldo < TPS65217_LDO_2 || ldo > TPS65217_LDO_4)
+	/* LDO1 implements set_voltage_sel callback */
+	if (rid == TPS65217_LDO_1)
 		return -EINVAL;
 
-	if (min_uV < tps->info[ldo]->min_uV
-		|| min_uV > tps->info[ldo]->max_uV)
+	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
 		return -EINVAL;
 
-	if (max_uV < tps->info[ldo]->min_uV
-		|| max_uV > tps->info[ldo]->max_uV)
+	if (min_uV < tps->info[rid]->min_uV
+		|| min_uV > tps->info[rid]->max_uV)
 		return -EINVAL;
 
-	ret = tps->info[ldo]->uv_to_vsel(min_uV, selector);
+	if (max_uV < tps->info[rid]->min_uV
+		|| max_uV > tps->info[rid]->max_uV)
+		return -EINVAL;
+
+	ret = tps->info[rid]->uv_to_vsel(min_uV, selector);
 	if (ret)
 		return ret;
 
 	/* Set the voltage based on vsel value and write protect level is 2 */
-	return tps65217_set_bits(tps, tps->info[ldo]->set_vout_reg,
-					tps->info[ldo]->set_vout_mask,
-					*selector, TPS65217_PROTECT_L2);
-}
-
-static int tps65217_pmic_dcdc_list_voltage(struct regulator_dev *dev,
-					unsigned selector)
-{
-	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int dcdc = rdev_get_id(dev);
-
-	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
-		return -EINVAL;
-
-	if (selector >= tps->info[dcdc]->table_len)
-		return -EINVAL;
+	ret = tps65217_set_bits(tps, tps->info[rid]->set_vout_reg,
+				tps->info[rid]->set_vout_mask,
+				*selector, TPS65217_PROTECT_L2);
+
+	/* Set GO bit for DCDCx to initiate voltage transistion */
+	switch (rid) {
+	case TPS65217_DCDC_1 ... TPS65217_DCDC_3:
+		ret = tps65217_set_bits(tps, TPS65217_REG_DEFSLEW,
+				       TPS65217_DEFSLEW_GO, TPS65217_DEFSLEW_GO,
+				       TPS65217_PROTECT_L2);
+		break;
+	}
 
-	return tps->info[dcdc]->vsel_to_uv(selector);
+	return ret;
 }
 
-static int tps65217_pmic_ldo_list_voltage(struct regulator_dev *dev,
+static int tps65217_pmic_list_voltage(struct regulator_dev *dev,
 					unsigned selector)
 {
 	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int ldo = rdev_get_id(dev);
+	unsigned int rid = rdev_get_id(dev);
 
-	if (ldo < TPS65217_LDO_1 || ldo > TPS65217_LDO_4)
+	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
 		return -EINVAL;
 
-	if (selector >= tps->info[ldo]->table_len)
+	if (selector >= tps->info[rid]->table_len)
 		return -EINVAL;
 
-	if (tps->info[ldo]->table)
-		return tps->info[ldo]->table[selector];
+	if (tps->info[rid]->table)
+		return tps->info[rid]->table[selector];
 
-	return tps->info[ldo]->vsel_to_uv(selector);
+	return tps->info[rid]->vsel_to_uv(selector);
 }
 
-/* Operations permitted on DCDCx */
-static struct regulator_ops tps65217_pmic_dcdc_ops = {
-	.is_enabled		= tps65217_pmic_dcdc_is_enabled,
-	.enable			= tps65217_pmic_dcdc_enable,
-	.disable		= tps65217_pmic_dcdc_disable,
-	.get_voltage_sel	= tps65217_pmic_dcdc_get_voltage_sel,
-	.set_voltage		= tps65217_pmic_dcdc_set_voltage,
-	.list_voltage		= tps65217_pmic_dcdc_list_voltage,
+/* Operations permitted on DCDCx, LDO2, LDO3 and LDO4 */
+static struct regulator_ops tps65217_pmic_ops = {
+	.is_enabled		= tps65217_pmic_is_enabled,
+	.enable			= tps65217_pmic_enable,
+	.disable		= tps65217_pmic_disable,
+	.get_voltage_sel	= tps65217_pmic_get_voltage_sel,
+	.set_voltage		= tps65217_pmic_set_voltage,
+	.list_voltage		= tps65217_pmic_list_voltage,
 };
 
 /* Operations permitted on LDO1 */
 static struct regulator_ops tps65217_pmic_ldo1_ops = {
-	.is_enabled		= tps65217_pmic_ldo_is_enabled,
-	.enable			= tps65217_pmic_ldo_enable,
-	.disable		= tps65217_pmic_ldo_disable,
-	.get_voltage_sel	= tps65217_pmic_ldo_get_voltage_sel,
-	.set_voltage_sel	= tps65217_pmic_ldo_set_voltage_sel,
-	.list_voltage		= tps65217_pmic_ldo_list_voltage,
-};
-
-/* Operations permitted on LDO2, LDO3 and LDO4 */
-static struct regulator_ops tps65217_pmic_ldo234_ops = {
-	.is_enabled		= tps65217_pmic_ldo_is_enabled,
-	.enable			= tps65217_pmic_ldo_enable,
-	.disable		= tps65217_pmic_ldo_disable,
-	.get_voltage_sel	= tps65217_pmic_ldo_get_voltage_sel,
-	.set_voltage		= tps65217_pmic_ldo_set_voltage,
-	.list_voltage		= tps65217_pmic_ldo_list_voltage,
+	.is_enabled		= tps65217_pmic_is_enabled,
+	.enable			= tps65217_pmic_enable,
+	.disable		= tps65217_pmic_disable,
+	.get_voltage_sel	= tps65217_pmic_get_voltage_sel,
+	.set_voltage_sel	= tps65217_pmic_ldo1_set_voltage_sel,
+	.list_voltage		= tps65217_pmic_list_voltage,
 };
 
 static struct regulator_desc regulators[] = {
-	TPS65217_REGULATOR("DCDC1", TPS65217_DCDC_1,
-				tps65217_pmic_dcdc_ops, 64),
-	TPS65217_REGULATOR("DCDC2",TPS65217_DCDC_2,
-				tps65217_pmic_dcdc_ops, 64),
-	TPS65217_REGULATOR("DCDC3", TPS65217_DCDC_3,
-				tps65217_pmic_dcdc_ops, 64),
-	TPS65217_REGULATOR("LDO1", TPS65217_LDO_1,
-				tps65217_pmic_ldo1_ops, 16),
-	TPS65217_REGULATOR("LDO2", TPS65217_LDO_2,
-				tps65217_pmic_ldo234_ops, 64),
-	TPS65217_REGULATOR("LDO3", TPS65217_LDO_3,
-				tps65217_pmic_ldo234_ops, 32),
-	TPS65217_REGULATOR("LDO4", TPS65217_LDO_4,
-				tps65217_pmic_ldo234_ops, 32),
+	TPS65217_REGULATOR("DCDC1", TPS65217_DCDC_1, tps65217_pmic_ops, 64),
+	TPS65217_REGULATOR("DCDC2", TPS65217_DCDC_2, tps65217_pmic_ops, 64),
+	TPS65217_REGULATOR("DCDC3", TPS65217_DCDC_3, tps65217_pmic_ops, 64),
+	TPS65217_REGULATOR("LDO1", TPS65217_LDO_1, tps65217_pmic_ldo1_ops, 16),
+	TPS65217_REGULATOR("LDO2", TPS65217_LDO_2, tps65217_pmic_ops, 64),
+	TPS65217_REGULATOR("LDO3", TPS65217_LDO_3, tps65217_pmic_ops, 32),
+	TPS65217_REGULATOR("LDO4", TPS65217_LDO_4, tps65217_pmic_ops, 32),
 };
 
 static int __devinit tps65217_regulator_probe(struct platform_device *pdev)
@@ -486,7 +372,6 @@ static void __exit tps65217_regulator_exit(void)
 }
 module_exit(tps65217_regulator_exit);
 
-
 MODULE_AUTHOR("AnilKumar Ch <anilkumar@ti.com>");
 MODULE_DESCRIPTION("TPS65217 voltage regulator driver");
 MODULE_ALIAS("platform:tps65217-pmic");
-- 
1.7.5.4



