Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2DPLDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:03:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65000 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab2DPLDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:03:14 -0400
Message-ID: <1334574189.2673.4.camel@phoenix>
Subject: [PATCH RFT] regulator: tps65023: Use generic regmap enable/disable
 operations
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 16 Apr 2012 19:03:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |  112 +++++---------------------------
 1 files changed, 16 insertions(+), 96 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 2db7149..e913e0f 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -151,96 +151,6 @@ struct tps_driver_data {
 	u8 core_regulator;
 };
 
-static int tps65023_dcdc_is_enabled(struct regulator_dev *dev)
-{
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
-	int data, dcdc = rdev_get_id(dev);
-	int ret;
-	u8 shift;
-
-	if (dcdc < TPS65023_DCDC_1 || dcdc > TPS65023_DCDC_3)
-		return -EINVAL;
-
-	shift = TPS65023_NUM_REGULATOR - dcdc;
-	ret = regmap_read(tps->regmap, TPS65023_REG_REG_CTRL, &data);
-
-	if (ret != 0)
-		return ret;
-	else
-		return (data & 1<<shift) ? 1 : 0;
-}
-
-static int tps65023_ldo_is_enabled(struct regulator_dev *dev)
-{
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
-	int data, ldo = rdev_get_id(dev);
-	int ret;
-	u8 shift;
-
-	if (ldo < TPS65023_LDO_1 || ldo > TPS65023_LDO_2)
-		return -EINVAL;
-
-	shift = (ldo == TPS65023_LDO_1 ? 1 : 2);
-	ret = regmap_read(tps->regmap, TPS65023_REG_REG_CTRL, &data);
-
-	if (ret != 0)
-		return ret;
-	else
-		return (data & 1<<shift) ? 1 : 0;
-}
-
-static int tps65023_dcdc_enable(struct regulator_dev *dev)
-{
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
-	int dcdc = rdev_get_id(dev);
-	u8 shift;
-
-	if (dcdc < TPS65023_DCDC_1 || dcdc > TPS65023_DCDC_3)
-		return -EINVAL;
-
-	shift = TPS65023_NUM_REGULATOR - dcdc;
-	return regmap_update_bits(tps->regmap, TPS65023_REG_REG_CTRL, 1 << shift, 1 << shift);
-}
-
-static int tps65023_dcdc_disable(struct regulator_dev *dev)
-{
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
-	int dcdc = rdev_get_id(dev);
-	u8 shift;
-
-	if (dcdc < TPS65023_DCDC_1 || dcdc > TPS65023_DCDC_3)
-		return -EINVAL;
-
-	shift = TPS65023_NUM_REGULATOR - dcdc;
-	return regmap_update_bits(tps->regmap, TPS65023_REG_REG_CTRL, 1 << shift, 0);
-}
-
-static int tps65023_ldo_enable(struct regulator_dev *dev)
-{
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
-	int ldo = rdev_get_id(dev);
-	u8 shift;
-
-	if (ldo < TPS65023_LDO_1 || ldo > TPS65023_LDO_2)
-		return -EINVAL;
-
-	shift = (ldo == TPS65023_LDO_1 ? 1 : 2);
-	return regmap_update_bits(tps->regmap, TPS65023_REG_REG_CTRL, 1 << shift, 1 << shift);
-}
-
-static int tps65023_ldo_disable(struct regulator_dev *dev)
-{
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
-	int ldo = rdev_get_id(dev);
-	u8 shift;
-
-	if (ldo < TPS65023_LDO_1 || ldo > TPS65023_LDO_2)
-		return -EINVAL;
-
-	shift = (ldo == TPS65023_LDO_1 ? 1 : 2);
-	return regmap_update_bits(tps->regmap, TPS65023_REG_REG_CTRL, 1 << shift, 0);
-}
-
 static int tps65023_dcdc_get_voltage(struct regulator_dev *dev)
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
@@ -348,9 +258,9 @@ static int tps65023_ldo_list_voltage(struct regulator_dev *dev,
 
 /* Operations permitted on VDCDCx */
 static struct regulator_ops tps65023_dcdc_ops = {
-	.is_enabled = tps65023_dcdc_is_enabled,
-	.enable = tps65023_dcdc_enable,
-	.disable = tps65023_dcdc_disable,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
 	.get_voltage = tps65023_dcdc_get_voltage,
 	.set_voltage_sel = tps65023_dcdc_set_voltage_sel,
 	.list_voltage = tps65023_dcdc_list_voltage,
@@ -358,9 +268,9 @@ static struct regulator_ops tps65023_dcdc_ops = {
 
 /* Operations permitted on LDOx */
 static struct regulator_ops tps65023_ldo_ops = {
-	.is_enabled = tps65023_ldo_is_enabled,
-	.enable = tps65023_ldo_enable,
-	.disable = tps65023_ldo_disable,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
 	.get_voltage = tps65023_ldo_get_voltage,
 	.set_voltage_sel = tps65023_ldo_set_voltage_sel,
 	.list_voltage = tps65023_ldo_list_voltage,
@@ -421,9 +331,19 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 		tps->desc[i].type = REGULATOR_VOLTAGE;
 		tps->desc[i].owner = THIS_MODULE;
 
+		tps->desc[i].enable_reg = TPS65023_REG_REG_CTRL;
+		if (i == TPS65023_LDO_1)
+			tps->desc[i].enable_mask = 1 << 1;
+		else if (i == TPS65023_LDO_2)
+			tps->desc[i].enable_mask = 1 << 2;
+		else /* DCDCx */
+			tps->desc[i].enable_mask =
+					1 << (TPS65023_NUM_REGULATOR - i);
+
 		config.dev = &client->dev;
 		config.init_data = init_data;
 		config.driver_data = tps;
+		config.regmap = tps->regmap;
 
 		/* Register the regulators */
 		rdev = regulator_register(&tps->desc[i], &config);
-- 
1.7.5.4



