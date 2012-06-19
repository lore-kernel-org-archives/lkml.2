Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2FSJM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 05:12:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39427 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2FSJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 05:12:28 -0400
Message-ID: <1340097138.28289.1.camel@phoenix>
Subject: [PATCH RFT 1/3] regulator: tps65023: Convert to
 regulator_list_voltage_table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 19 Jun 2012 17:12:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current mapping table settings, min_uV/max_uV are always
equal to volt_table[0] and volt_table[table_len -1].
Thus remove min_uV and max_uV from struct tps_info.

The table based mapping with table_len == 1 means fixed voltage.
So we don't need fixed flag to differentiate if it is fixed or not.

This patch adds DCDC_FIXED_3300000_VSEL_table and DCDC_FIXED_1800000_VSEL_table
for fixed voltage cases. So we can convert tps65023_dcdc_ops to
regulator_list_voltage_table. This makes the code simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |  153 ++++++++++----------------------
 1 file changed, 49 insertions(+), 104 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 6fab428..332cbc5 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -91,48 +91,53 @@
 #define TPS65023_MAX_REG_ID		TPS65023_LDO_2
 
 /* Supported voltage values for regulators */
-static const u16 VCORE_VSEL_table[] = {
-	800, 825, 850, 875,
-	900, 925, 950, 975,
-	1000, 1025, 1050, 1075,
-	1100, 1125, 1150, 1175,
-	1200, 1225, 1250, 1275,
-	1300, 1325, 1350, 1375,
-	1400, 1425, 1450, 1475,
-	1500, 1525, 1550, 1600,
+static const unsigned int VCORE_VSEL_table[] = {
+	800000, 825000, 850000, 875000,
+	900000, 925000, 950000, 975000,
+	1000000, 1025000, 1050000, 1075000,
+	1100000, 1125000, 1150000, 1175000,
+	1200000, 1225000, 1250000, 1275000,
+	1300000, 1325000, 1350000, 1375000,
+	1400000, 1425000, 1450000, 1475000,
+	1500000, 1525000, 1550000, 1600000,
+};
+
+static const unsigned int DCDC_FIXED_3300000_VSEL_table[] = {
+	3300000,
+};
+
+static const unsigned int DCDC_FIXED_1800000_VSEL_table[] = {
+	1800000,
 };
 
 /* Supported voltage values for LDO regulators for tps65020 */
-static const u16 TPS65020_LDO1_VSEL_table[] = {
-	1000, 1050, 1100, 1300,
-	1800, 2500, 3000, 3300,
+static const unsigned int TPS65020_LDO1_VSEL_table[] = {
+	1000000, 1050000, 1100000, 1300000,
+	1800000, 2500000, 3000000, 3300000,
 };
 
-static const u16 TPS65020_LDO2_VSEL_table[] = {
-	1000, 1050, 1100, 1300,
-	1800, 2500, 3000, 3300,
+static const unsigned int TPS65020_LDO2_VSEL_table[] = {
+	1000000, 1050000, 1100000, 1300000,
+	1800000, 2500000, 3000000, 3300000,
 };
 
 /* Supported voltage values for LDO regulators
  * for tps65021 and tps65023 */
-static const u16 TPS65023_LDO1_VSEL_table[] = {
-	1000, 1100, 1300, 1800,
-	2200, 2600, 2800, 3150,
+static const unsigned int TPS65023_LDO1_VSEL_table[] = {
+	1000000, 1100000, 1300000, 1800000,
+	2200000, 2600000, 2800000, 3150000,
 };
 
-static const u16 TPS65023_LDO2_VSEL_table[] = {
-	1050, 1200, 1300, 1800,
-	2500, 2800, 3000, 3300,
+static const unsigned int TPS65023_LDO2_VSEL_table[] = {
+	1050000, 1200000, 1300000, 1800000,
+	2500000, 2800000, 3000000, 3300000,
 };
 
 /* Regulator specific details */
 struct tps_info {
 	const char *name;
-	unsigned min_uV;
-	unsigned max_uV;
-	bool fixed;
 	u8 table_len;
-	const u16 *table;
+	const unsigned int *table;
 };
 
 /* PMIC details */
@@ -164,9 +169,9 @@ static int tps65023_dcdc_get_voltage(struct regulator_dev *dev)
 		if (ret != 0)
 			return ret;
 		data &= (tps->info[dcdc]->table_len - 1);
-		return tps->info[dcdc]->table[data] * 1000;
+		return tps->info[dcdc]->table[data];
 	} else
-		return tps->info[dcdc]->min_uV;
+		return tps->info[dcdc]->table[0];
 }
 
 static int tps65023_dcdc_set_voltage_sel(struct regulator_dev *dev,
@@ -208,7 +213,7 @@ static int tps65023_ldo_get_voltage(struct regulator_dev *dev)
 
 	data >>= (TPS65023_LDO_CTRL_LDOx_SHIFT(ldo - TPS65023_LDO_1));
 	data &= (tps->info[ldo]->table_len - 1);
-	return tps->info[ldo]->table[data] * 1000;
+	return tps->info[ldo]->table[data];
 }
 
 static int tps65023_ldo_set_voltage_sel(struct regulator_dev *dev,
@@ -222,39 +227,6 @@ static int tps65023_ldo_set_voltage_sel(struct regulator_dev *dev,
 			selector << TPS65023_LDO_CTRL_LDOx_SHIFT(ldo_index));
 }
 
-static int tps65023_dcdc_list_voltage(struct regulator_dev *dev,
-					unsigned selector)
-{
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
-	int dcdc = rdev_get_id(dev);
-
-	if (dcdc < TPS65023_DCDC_1 || dcdc > TPS65023_DCDC_3)
-		return -EINVAL;
-
-	if (dcdc == tps->core_regulator) {
-		if (selector >= tps->info[dcdc]->table_len)
-			return -EINVAL;
-		else
-			return tps->info[dcdc]->table[selector] * 1000;
-	} else
-		return tps->info[dcdc]->min_uV;
-}
-
-static int tps65023_ldo_list_voltage(struct regulator_dev *dev,
-					unsigned selector)
-{
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
-	int ldo = rdev_get_id(dev);
-
-	if (ldo < TPS65023_LDO_1 || ldo > TPS65023_LDO_2)
-		return -EINVAL;
-
-	if (selector >= tps->info[ldo]->table_len)
-		return -EINVAL;
-	else
-		return tps->info[ldo]->table[selector] * 1000;
-}
-
 /* Operations permitted on VDCDCx */
 static struct regulator_ops tps65023_dcdc_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
@@ -262,7 +234,7 @@ static struct regulator_ops tps65023_dcdc_ops = {
 	.disable = regulator_disable_regmap,
 	.get_voltage = tps65023_dcdc_get_voltage,
 	.set_voltage_sel = tps65023_dcdc_set_voltage_sel,
-	.list_voltage = tps65023_dcdc_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 };
 
 /* Operations permitted on LDOx */
@@ -272,7 +244,7 @@ static struct regulator_ops tps65023_ldo_ops = {
 	.disable = regulator_disable_regmap,
 	.get_voltage = tps65023_ldo_get_voltage,
 	.set_voltage_sel = tps65023_ldo_set_voltage_sel,
-	.list_voltage = tps65023_ldo_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 };
 
 static struct regmap_config tps65023_regmap_config = {
@@ -324,10 +296,8 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 
 		tps->desc[i].name = info->name;
 		tps->desc[i].id = i;
-		if (info->fixed)
-			tps->desc[i].n_voltages = 1;
-		else
-			tps->desc[i].n_voltages = info->table_len;
+		tps->desc[i].n_voltages = info->table_len;
+		tps->desc[i].volt_table = info->table;
 		tps->desc[i].ops = (i > TPS65023_DCDC_3 ?
 					&tps65023_ldo_ops : &tps65023_dcdc_ops);
 		tps->desc[i].type = REGULATOR_VOLTAGE;
@@ -387,35 +357,26 @@ static int __devexit tps_65023_remove(struct i2c_client *client)
 static const struct tps_info tps65020_regs[] = {
 	{
 		.name = "VDCDC1",
-		.min_uV = 3300000,
-		.max_uV = 3300000,
-		.fixed	= 1,
+		.table_len = ARRAY_SIZE(DCDC_FIXED_3300000_VSEL_table),
+		.table = DCDC_FIXED_3300000_VSEL_table,
 	},
 	{
 		.name = "VDCDC2",
-		.min_uV =  1800000,
-		.max_uV = 1800000,
-		.fixed = 1,
+		.table_len = ARRAY_SIZE(DCDC_FIXED_1800000_VSEL_table),
+		.table = DCDC_FIXED_1800000_VSEL_table,
 	},
 	{
 		.name = "VDCDC3",
-		.min_uV =  800000,
-		.max_uV = 1600000,
 		.table_len = ARRAY_SIZE(VCORE_VSEL_table),
 		.table = VCORE_VSEL_table,
 	},
-
 	{
 		.name = "LDO1",
-		.min_uV = 1000000,
-		.max_uV = 3150000,
 		.table_len = ARRAY_SIZE(TPS65020_LDO1_VSEL_table),
 		.table = TPS65020_LDO1_VSEL_table,
 	},
 	{
 		.name = "LDO2",
-		.min_uV = 1050000,
-		.max_uV = 3300000,
 		.table_len = ARRAY_SIZE(TPS65020_LDO2_VSEL_table),
 		.table = TPS65020_LDO2_VSEL_table,
 	},
@@ -424,34 +385,26 @@ static const struct tps_info tps65020_regs[] = {
 static const struct tps_info tps65021_regs[] = {
 	{
 		.name = "VDCDC1",
-		.min_uV =  3300000,
-		.max_uV = 3300000,
-		.fixed = 1,
+		.table_len = ARRAY_SIZE(DCDC_FIXED_3300000_VSEL_table),
+		.table = DCDC_FIXED_3300000_VSEL_table,
 	},
 	{
 		.name = "VDCDC2",
-		.min_uV =  1800000,
-		.max_uV = 1800000,
-		.fixed = 1,
+		.table_len = ARRAY_SIZE(DCDC_FIXED_1800000_VSEL_table),
+		.table = DCDC_FIXED_1800000_VSEL_table,
 	},
 	{
 		.name = "VDCDC3",
-		.min_uV =  800000,
-		.max_uV = 1600000,
 		.table_len = ARRAY_SIZE(VCORE_VSEL_table),
 		.table = VCORE_VSEL_table,
 	},
 	{
 		.name = "LDO1",
-		.min_uV = 1000000,
-		.max_uV = 3150000,
 		.table_len = ARRAY_SIZE(TPS65023_LDO1_VSEL_table),
 		.table = TPS65023_LDO1_VSEL_table,
 	},
 	{
 		.name = "LDO2",
-		.min_uV = 1050000,
-		.max_uV = 3300000,
 		.table_len = ARRAY_SIZE(TPS65023_LDO2_VSEL_table),
 		.table = TPS65023_LDO2_VSEL_table,
 	},
@@ -460,34 +413,26 @@ static const struct tps_info tps65021_regs[] = {
 static const struct tps_info tps65023_regs[] = {
 	{
 		.name = "VDCDC1",
-		.min_uV =  800000,
-		.max_uV = 1600000,
 		.table_len = ARRAY_SIZE(VCORE_VSEL_table),
 		.table = VCORE_VSEL_table,
 	},
 	{
 		.name = "VDCDC2",
-		.min_uV =  3300000,
-		.max_uV = 3300000,
-		.fixed = 1,
+		.table_len = ARRAY_SIZE(DCDC_FIXED_3300000_VSEL_table),
+		.table = DCDC_FIXED_3300000_VSEL_table,
 	},
 	{
 		.name = "VDCDC3",
-		.min_uV =  1800000,
-		.max_uV = 1800000,
-		.fixed = 1,
+		.table_len = ARRAY_SIZE(DCDC_FIXED_1800000_VSEL_table),
+		.table = DCDC_FIXED_1800000_VSEL_table,
 	},
 	{
 		.name = "LDO1",
-		.min_uV = 1000000,
-		.max_uV = 3150000,
 		.table_len = ARRAY_SIZE(TPS65023_LDO1_VSEL_table),
 		.table = TPS65023_LDO1_VSEL_table,
 	},
 	{
 		.name = "LDO2",
-		.min_uV = 1050000,
-		.max_uV = 3300000,
 		.table_len = ARRAY_SIZE(TPS65023_LDO2_VSEL_table),
 		.table = TPS65023_LDO2_VSEL_table,
 	},
-- 
1.7.9.5



