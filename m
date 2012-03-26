Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab2CZFqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 01:46:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38906 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab2CZFqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 01:46:49 -0400
Message-ID: <1332740804.15735.3.camel@phoenix>
Subject: [PATCH RFT] regulator: Convert tps65023 to set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcus Folkesson <marcus.folkesson@gmail.com>,
        Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 26 Mar 2012 13:46:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also changes the define for TPS65023_LDO_CTRL_LDOx_MASK,
because regmap_update_bits actually does:
        (orig & ~mask) | (val & mask)
This change makes the code consists for all regmap_update_bits calls.

Also removes some uninformative comments.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |  107 ++++++-------------------------
 1 files changed, 21 insertions(+), 86 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 43e4902..08b3b41 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -72,7 +72,7 @@
 
 /* LDO_CTRL bitfields */
 #define TPS65023_LDO_CTRL_LDOx_SHIFT(ldo_id)	((ldo_id)*4)
-#define TPS65023_LDO_CTRL_LDOx_MASK(ldo_id)	(0xF0 >> ((ldo_id)*4))
+#define TPS65023_LDO_CTRL_LDOx_MASK(ldo_id)	(0x0F << ((ldo_id)*4))
 
 /* Number of step-down converters available */
 #define TPS65023_NUM_DCDC		3
@@ -261,50 +261,28 @@ static int tps65023_dcdc_get_voltage(struct regulator_dev *dev)
 		return tps->info[dcdc]->min_uV;
 }
 
-static int tps65023_dcdc_set_voltage(struct regulator_dev *dev,
-				     int min_uV, int max_uV,
-				     unsigned *selector)
+static int tps65023_dcdc_set_voltage_sel(struct regulator_dev *dev,
+					 unsigned selector)
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
 	int dcdc = rdev_get_id(dev);
-	int vsel;
 	int ret;
 
 	if (dcdc != tps->core_regulator)
 		return -EINVAL;
-	if (min_uV < tps->info[dcdc]->min_uV
-			|| min_uV > tps->info[dcdc]->max_uV)
-		return -EINVAL;
-	if (max_uV < tps->info[dcdc]->min_uV
-			|| max_uV > tps->info[dcdc]->max_uV)
-		return -EINVAL;
-
-	for (vsel = 0; vsel < tps->info[dcdc]->table_len; vsel++) {
-		int mV = tps->info[dcdc]->table[vsel];
-		int uV = mV * 1000;
-
-		/* Break at the first in-range value */
-		if (min_uV <= uV && uV <= max_uV)
-			break;
-	}
 
-	*selector = vsel;
-
-	if (vsel == tps->info[dcdc]->table_len)
-		goto failed;
-
-	ret = regmap_write(tps->regmap, TPS65023_REG_DEF_CORE, vsel);
+	ret = regmap_write(tps->regmap, TPS65023_REG_DEF_CORE, selector);
+	if (ret)
+		goto out;
 
 	/* Tell the chip that we have changed the value in DEFCORE
 	 * and its time to update the core voltage
 	 */
-	regmap_update_bits(tps->regmap, TPS65023_REG_CON_CTRL2,
-			TPS65023_REG_CTRL2_GO, TPS65023_REG_CTRL2_GO);
+	ret = regmap_update_bits(tps->regmap, TPS65023_REG_CON_CTRL2,
+				 TPS65023_REG_CTRL2_GO, TPS65023_REG_CTRL2_GO);
 
+out:
 	return ret;
-
-failed:
-	return -EINVAL;
 }
 
 static int tps65023_ldo_get_voltage(struct regulator_dev *dev)
@@ -325,42 +303,15 @@ static int tps65023_ldo_get_voltage(struct regulator_dev *dev)
 	return tps->info[ldo]->table[data] * 1000;
 }
 
-static int tps65023_ldo_set_voltage(struct regulator_dev *dev,
-				    int min_uV, int max_uV, unsigned *selector)
+static int tps65023_ldo_set_voltage_sel(struct regulator_dev *dev,
+					unsigned selector)
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
-	int data, vsel, ldo = rdev_get_id(dev);
-	int ret;
-
-	if (ldo < TPS65023_LDO_1 || ldo > TPS65023_LDO_2)
-		return -EINVAL;
-
-	if (min_uV < tps->info[ldo]->min_uV || min_uV > tps->info[ldo]->max_uV)
-		return -EINVAL;
-	if (max_uV < tps->info[ldo]->min_uV || max_uV > tps->info[ldo]->max_uV)
-		return -EINVAL;
+	int ldo_index = rdev_get_id(dev) - TPS65023_LDO_1;
 
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
-		return -EINVAL;
-
-	*selector = vsel;
-
-	ret = regmap_read(tps->regmap, TPS65023_REG_LDO_CTRL, &data);
-	if (ret != 0)
-		return ret;
-
-	data &= TPS65023_LDO_CTRL_LDOx_MASK(ldo - TPS65023_LDO_1);
-	data |= (vsel << (TPS65023_LDO_CTRL_LDOx_SHIFT(ldo - TPS65023_LDO_1)));
-	return regmap_write(tps->regmap, TPS65023_REG_LDO_CTRL, data);
+	return regmap_update_bits(tps->regmap, TPS65023_REG_LDO_CTRL,
+			TPS65023_LDO_CTRL_LDOx_MASK(ldo_index),
+			selector << TPS65023_LDO_CTRL_LDOx_SHIFT(ldo_index));
 }
 
 static int tps65023_dcdc_list_voltage(struct regulator_dev *dev,
@@ -402,7 +353,7 @@ static struct regulator_ops tps65023_dcdc_ops = {
 	.enable = tps65023_dcdc_enable,
 	.disable = tps65023_dcdc_disable,
 	.get_voltage = tps65023_dcdc_get_voltage,
-	.set_voltage = tps65023_dcdc_set_voltage,
+	.set_voltage_sel = tps65023_dcdc_set_voltage_sel,
 	.list_voltage = tps65023_dcdc_list_voltage,
 };
 
@@ -412,7 +363,7 @@ static struct regulator_ops tps65023_ldo_ops = {
 	.enable = tps65023_ldo_enable,
 	.disable = tps65023_ldo_disable,
 	.get_voltage = tps65023_ldo_get_voltage,
-	.set_voltage = tps65023_ldo_set_voltage,
+	.set_voltage_sel = tps65023_ldo_set_voltage_sel,
 	.list_voltage = tps65023_ldo_list_voltage,
 };
 
@@ -503,12 +454,6 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 	return error;
 }
 
-/**
- * tps_65023_remove - TPS65023 driver i2c remove handler
- * @client: i2c driver client device structure
- *
- * Unregister TPS driver as an i2c client device driver
- */
 static int __devexit tps_65023_remove(struct i2c_client *client)
 {
 	struct tps_pmic *tps = i2c_get_clientdata(client);
@@ -638,13 +583,13 @@ static struct tps_driver_data tps65020_drv_data = {
 };
 
 static struct tps_driver_data tps65021_drv_data = {
-		.info = tps65021_regs,
-		.core_regulator = TPS65023_DCDC_3,
+	.info = tps65021_regs,
+	.core_regulator = TPS65023_DCDC_3,
 };
 
 static struct tps_driver_data tps65023_drv_data = {
-		.info = tps65023_regs,
-		.core_regulator = TPS65023_DCDC_1,
+	.info = tps65023_regs,
+	.core_regulator = TPS65023_DCDC_1,
 };
 
 static const struct i2c_device_id tps_65023_id[] = {
@@ -669,22 +614,12 @@ static struct i2c_driver tps_65023_i2c_driver = {
 	.id_table = tps_65023_id,
 };
 
-/**
- * tps_65023_init
- *
- * Module init function
- */
 static int __init tps_65023_init(void)
 {
 	return i2c_add_driver(&tps_65023_i2c_driver);
 }
 subsys_initcall(tps_65023_init);
 
-/**
- * tps_65023_cleanup
- *
- * Module exit function
- */
 static void __exit tps_65023_cleanup(void)
 {
 	i2c_del_driver(&tps_65023_i2c_driver);
-- 
1.7.5.4



