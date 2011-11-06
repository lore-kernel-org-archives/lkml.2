Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1KFXfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:35:10 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:37129 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1KFXfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:35:09 -0500
From: jhbird.choi@samsung.com
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] regulator: Use regmap_read/write(), regmap_update_bits functions directly
Date: Mon,  7 Nov 2011 08:16:04 +0900
Message-Id: <1320621364-25711-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

Current driver had the regmapcalls within the bodies of the driver specific read/write fuctions.
This patch removes the original read/write functions and makes the call sites use regmap directly.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/regulator/tps65023-regulator.c |   87 ++++++++++++--------------------
 1 files changed, 32 insertions(+), 55 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 9fb4c7b..e0bcd75 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -152,48 +152,21 @@ struct tps_driver_data {
 	u8 core_regulator;
 };
 
-static int tps_65023_set_bits(struct tps_pmic *tps, u8 reg, u8 mask)
-{
-	return regmap_update_bits(tps->regmap, reg, mask, mask);
-}
-
-static int tps_65023_clear_bits(struct tps_pmic *tps, u8 reg, u8 mask)
-{
-	return regmap_update_bits(tps->regmap, reg, mask, 0);
-}
-
-static int tps_65023_reg_read(struct tps_pmic *tps, u8 reg)
-{
-	unsigned int val;
-	int ret;
-
-	ret = regmap_read(tps->regmap, reg, &val);
-
-	if (ret != 0)
-		return ret;
-	else
-		return val;
-}
-
-static int tps_65023_reg_write(struct tps_pmic *tps, u8 reg, u8 val)
-{
-	return regmap_write(tps->regmap, reg, val);
-}
-
 static int tps65023_dcdc_is_enabled(struct regulator_dev *dev)
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
 	int data, dcdc = rdev_get_id(dev);
+	int ret;
 	u8 shift;
 
 	if (dcdc < TPS65023_DCDC_1 || dcdc > TPS65023_DCDC_3)
 		return -EINVAL;
 
 	shift = TPS65023_NUM_REGULATOR - dcdc;
-	data = tps_65023_reg_read(tps, TPS65023_REG_REG_CTRL);
+	ret = regmap_read(tps->regmap, TPS65023_REG_REG_CTRL, &data);
 
-	if (data < 0)
-		return data;
+	if (ret != 0)
+		return ret;
 	else
 		return (data & 1<<shift) ? 1 : 0;
 }
@@ -202,16 +175,17 @@ static int tps65023_ldo_is_enabled(struct regulator_dev *dev)
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
 	int data, ldo = rdev_get_id(dev);
+	int ret;
 	u8 shift;
 
 	if (ldo < TPS65023_LDO_1 || ldo > TPS65023_LDO_2)
 		return -EINVAL;
 
 	shift = (ldo == TPS65023_LDO_1 ? 1 : 2);
-	data = tps_65023_reg_read(tps, TPS65023_REG_REG_CTRL);
+	ret = regmap_read(tps->regmap, TPS65023_REG_REG_CTRL, &data);
 
-	if (data < 0)
-		return data;
+	if (ret != 0)
+		return ret;
 	else
 		return (data & 1<<shift) ? 1 : 0;
 }
@@ -226,7 +200,7 @@ static int tps65023_dcdc_enable(struct regulator_dev *dev)
 		return -EINVAL;
 
 	shift = TPS65023_NUM_REGULATOR - dcdc;
-	return tps_65023_set_bits(tps, TPS65023_REG_REG_CTRL, 1 << shift);
+	return regmap_update_bits(tps->regmap, TPS65023_REG_REG_CTRL, 1 << shift, 1 << shift);
 }
 
 static int tps65023_dcdc_disable(struct regulator_dev *dev)
@@ -239,7 +213,7 @@ static int tps65023_dcdc_disable(struct regulator_dev *dev)
 		return -EINVAL;
 
 	shift = TPS65023_NUM_REGULATOR - dcdc;
-	return tps_65023_clear_bits(tps, TPS65023_REG_REG_CTRL, 1 << shift);
+	return regmap_update_bits(tps->regmap, TPS65023_REG_REG_CTRL, 1 << shift, 0);
 }
 
 static int tps65023_ldo_enable(struct regulator_dev *dev)
@@ -252,7 +226,7 @@ static int tps65023_ldo_enable(struct regulator_dev *dev)
 		return -EINVAL;
 
 	shift = (ldo == TPS65023_LDO_1 ? 1 : 2);
-	return tps_65023_set_bits(tps, TPS65023_REG_REG_CTRL, 1 << shift);
+	return regmap_update_bits(tps->regmap, TPS65023_REG_REG_CTRL, 1 << shift, 1 << shift);
 }
 
 static int tps65023_ldo_disable(struct regulator_dev *dev)
@@ -265,21 +239,22 @@ static int tps65023_ldo_disable(struct regulator_dev *dev)
 		return -EINVAL;
 
 	shift = (ldo == TPS65023_LDO_1 ? 1 : 2);
-	return tps_65023_clear_bits(tps, TPS65023_REG_REG_CTRL, 1 << shift);
+	return regmap_update_bits(tps->regmap, TPS65023_REG_REG_CTRL, 1 << shift, 0);
 }
 
 static int tps65023_dcdc_get_voltage(struct regulator_dev *dev)
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
+	int ret;
 	int data, dcdc = rdev_get_id(dev);
 
 	if (dcdc < TPS65023_DCDC_1 || dcdc > TPS65023_DCDC_3)
 		return -EINVAL;
 
 	if (dcdc == tps->core_regulator) {
-		data = tps_65023_reg_read(tps, TPS65023_REG_DEF_CORE);
-		if (data < 0)
-			return data;
+		ret = regmap_read(tps->regmap, TPS65023_REG_DEF_CORE, &data);
+		if (ret != 0)
+			return ret;
 		data &= (tps->info[dcdc]->table_len - 1);
 		return tps->info[dcdc]->table[data] * 1000;
 	} else
@@ -318,13 +293,13 @@ static int tps65023_dcdc_set_voltage(struct regulator_dev *dev,
 	if (vsel == tps->info[dcdc]->table_len)
 		goto failed;
 
-	ret = tps_65023_reg_write(tps, TPS65023_REG_DEF_CORE, vsel);
+	ret = regmap_write(tps->regmap, TPS65023_REG_DEF_CORE, vsel);
 
 	/* Tell the chip that we have changed the value in DEFCORE
 	 * and its time to update the core voltage
 	 */
-	tps_65023_set_bits(tps, TPS65023_REG_CON_CTRL2,
-						TPS65023_REG_CTRL2_GO);
+	regmap_update_bits(tps->regmap, TPS65023_REG_CON_CTRL2,
+			TPS65023_REG_CTRL2_GO, TPS65023_REG_CTRL2_GO);
 
 	return ret;
 
@@ -336,13 +311,14 @@ static int tps65023_ldo_get_voltage(struct regulator_dev *dev)
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
 	int data, ldo = rdev_get_id(dev);
+	int ret;
 
 	if (ldo < TPS65023_LDO_1 || ldo > TPS65023_LDO_2)
 		return -EINVAL;
 
-	data = tps_65023_reg_read(tps, TPS65023_REG_LDO_CTRL);
-	if (data < 0)
-		return data;
+	ret = regmap_read(tps->regmap, TPS65023_REG_LDO_CTRL, &data);
+	if (ret != 0)
+		return ret;
 
 	data >>= (TPS65023_LDO_CTRL_LDOx_SHIFT(ldo - TPS65023_LDO_1));
 	data &= (tps->info[ldo]->table_len - 1);
@@ -354,6 +330,7 @@ static int tps65023_ldo_set_voltage(struct regulator_dev *dev,
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
 	int data, vsel, ldo = rdev_get_id(dev);
+	int ret;
 
 	if (ldo < TPS65023_LDO_1 || ldo > TPS65023_LDO_2)
 		return -EINVAL;
@@ -377,13 +354,13 @@ static int tps65023_ldo_set_voltage(struct regulator_dev *dev,
 
 	*selector = vsel;
 
-	data = tps_65023_reg_read(tps, TPS65023_REG_LDO_CTRL);
-	if (data < 0)
-		return data;
+	ret = regmap_read(tps->regmap, TPS65023_REG_LDO_CTRL, &data);
+	if (ret != 0)
+		return ret;
 
 	data &= TPS65023_LDO_CTRL_LDOx_MASK(ldo - TPS65023_LDO_1);
 	data |= (vsel << (TPS65023_LDO_CTRL_LDOx_SHIFT(ldo - TPS65023_LDO_1)));
-	return tps_65023_reg_write(tps, TPS65023_REG_LDO_CTRL, data);
+	return regmap_write(tps->regmap, TPS65023_REG_LDO_CTRL, data);
 }
 
 static int tps65023_dcdc_list_voltage(struct regulator_dev *dev,
@@ -511,12 +488,12 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, tps);
 
 	/* Enable setting output voltage by I2C */
-	tps_65023_clear_bits(tps, TPS65023_REG_CON_CTRL2,
-						TPS65023_REG_CTRL2_CORE_ADJ);
+	regmap_update_bits(tps->regmap, TPS65023_REG_CON_CTRL2,
+			TPS65023_REG_CTRL2_CORE_ADJ, TPS65023_REG_CTRL2_CORE_ADJ);
 
 	/* Enable setting output voltage by I2C */
-	tps_65023_clear_bits(tps, TPS65023_REG_CON_CTRL2,
-						TPS65023_REG_CTRL2_CORE_ADJ);
+	regmap_update_bits(tps->regmap, TPS65023_REG_CON_CTRL2,
+			TPS65023_REG_CTRL2_CORE_ADJ, TPS65023_REG_CTRL2_CORE_ADJ);
 
 	return 0;
 
-- 
1.7.1

