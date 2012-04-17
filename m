Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2DQDdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:33:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62349 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab2DQDdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:33:06 -0400
Message-ID: <1334633577.22293.1.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: 88pm8607: Use generic regmap
 enable/disable operations
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Jett.Zhou" <jtzhou@marvell.com>
Date: Tue, 17 Apr 2012 11:32:57 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/88pm8607.c |   50 ++++++++++-------------------------------
 1 files changed, 12 insertions(+), 38 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index d04fbe9..ad748db 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -31,8 +31,6 @@ struct pm8607_regulator_info {
 	int	vol_shift;
 	int	update_reg;
 	int	update_bit;
-	int	enable_reg;
-	int	enable_bit;
 	int	slope_double;
 };
 
@@ -262,42 +260,13 @@ static int pm8607_get_voltage_sel(struct regulator_dev *rdev)
 	return val;
 }
 
-static int pm8607_enable(struct regulator_dev *rdev)
-{
-	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
-
-	return pm860x_set_bits(info->i2c, info->enable_reg,
-			       1 << info->enable_bit,
-			       1 << info->enable_bit);
-}
-
-static int pm8607_disable(struct regulator_dev *rdev)
-{
-	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
-
-	return pm860x_set_bits(info->i2c, info->enable_reg,
-			       1 << info->enable_bit, 0);
-}
-
-static int pm8607_is_enabled(struct regulator_dev *rdev)
-{
-	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
-	int ret;
-
-	ret = pm860x_reg_read(info->i2c, info->enable_reg);
-	if (ret < 0)
-		return ret;
-
-	return !!((unsigned char)ret & (1 << info->enable_bit));
-}
-
 static struct regulator_ops pm8607_regulator_ops = {
 	.list_voltage	= pm8607_list_voltage,
 	.set_voltage_sel = pm8607_set_voltage_sel,
 	.get_voltage_sel = pm8607_get_voltage_sel,
-	.enable		= pm8607_enable,
-	.disable	= pm8607_disable,
-	.is_enabled	= pm8607_is_enabled,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
 };
 
 #define PM8607_DVC(vreg, ureg, ubit, ereg, ebit)			\
@@ -309,13 +278,13 @@ static struct regulator_ops pm8607_regulator_ops = {
 		.id	= PM8607_ID_##vreg,				\
 		.owner	= THIS_MODULE,					\
 		.n_voltages = ARRAY_SIZE(vreg##_table),			\
+		.enable_reg = PM8607_##ereg,				\
+		.enable_mask = 1 << (ebit),				\
 	},								\
 	.vol_reg	= PM8607_##vreg,				\
 	.vol_shift	= (0),						\
 	.update_reg	= PM8607_##ureg,				\
 	.update_bit	= (ubit),					\
-	.enable_reg	= PM8607_##ereg,				\
-	.enable_bit	= (ebit),					\
 	.slope_double	= (0),						\
 	.vol_table	= (unsigned int *)&vreg##_table,		\
 	.vol_suspend	= (unsigned int *)&vreg##_suspend_table,	\
@@ -330,11 +299,11 @@ static struct regulator_ops pm8607_regulator_ops = {
 		.id	= PM8607_ID_LDO##_id,				\
 		.owner	= THIS_MODULE,					\
 		.n_voltages = ARRAY_SIZE(LDO##_id##_table),		\
+		.enable_reg = PM8607_##ereg,				\
+		.enable_mask = 1 << (ebit),				\
 	},								\
 	.vol_reg	= PM8607_##vreg,				\
 	.vol_shift	= (shift),					\
-	.enable_reg	= PM8607_##ereg,				\
-	.enable_bit	= (ebit),					\
 	.slope_double	= (0),						\
 	.vol_table	= (unsigned int *)&LDO##_id##_table,		\
 	.vol_suspend	= (unsigned int *)&LDO##_id##_suspend_table,	\
@@ -395,6 +364,11 @@ static int __devinit pm8607_regulator_probe(struct platform_device *pdev)
 	config.init_data = pdata;
 	config.driver_data = info;
 
+	if (chip->id == CHIP_PM8607)
+		config.regmap = chip->regmap;
+	else
+		config.regmap = chip->regmap_companion;
+
 	/* replace driver_data with info */
 	info->regulator = regulator_register(&info->desc, &config);
 	if (IS_ERR(info->regulator)) {
-- 
1.7.5.4



