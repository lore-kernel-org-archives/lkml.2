Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2GYAv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 20:51:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2GYAvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 20:51:55 -0400
Message-ID: <1343177504.9132.3.camel@phoenix>
Subject: [PATCH RFT] regulator: tps6586x: Convert to
 regulator_[enable|disable|is_enabled|get_voltage_sel]_regmap
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Rapoport <mike@compulab.co.il>, Danny Huang <dahuang@nvidia.com>,
        Liam Girdwood <lrg@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jul 2012 08:51:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch depends on Laxman's patches converting tps6586x mfd driver to use
regmap APIs. ( merged in mfd tree )

 drivers/regulator/tps6586x-regulator.c |   76 +++++---------------------------
 1 file changed, 11 insertions(+), 65 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index e6da90a..2855d0c 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -57,9 +57,6 @@
 struct tps6586x_regulator {
 	struct regulator_desc desc;
 
-	int volt_reg;
-	int volt_shift;
-	int volt_nbits;
 	int enable_bit[2];
 	int enable_reg[2];
 
@@ -81,10 +78,10 @@ static int tps6586x_set_voltage_sel(struct regulator_dev *rdev,
 	int ret, val, rid = rdev_get_id(rdev);
 	uint8_t mask;
 
-	val = selector << ri->volt_shift;
-	mask = ((1 << ri->volt_nbits) - 1) << ri->volt_shift;
+	val = selector << (ffs(rdev->desc->vsel_mask) - 1);
+	mask = rdev->desc->vsel_mask;
 
-	ret = tps6586x_update(parent, ri->volt_reg, val, mask);
+	ret = tps6586x_update(parent, rdev->desc->vsel_reg, val, mask);
 	if (ret)
 		return ret;
 
@@ -100,66 +97,14 @@ static int tps6586x_set_voltage_sel(struct regulator_dev *rdev,
 	return ret;
 }
 
-static int tps6586x_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct tps6586x_regulator *ri = rdev_get_drvdata(rdev);
-	struct device *parent = to_tps6586x_dev(rdev);
-	uint8_t val, mask;
-	int ret;
-
-	ret = tps6586x_read(parent, ri->volt_reg, &val);
-	if (ret)
-		return ret;
-
-	mask = ((1 << ri->volt_nbits) - 1) << ri->volt_shift;
-	val = (val & mask) >> ri->volt_shift;
-
-	if (val >= ri->desc.n_voltages)
-		BUG();
-
-	return val;
-}
-
-static int tps6586x_regulator_enable(struct regulator_dev *rdev)
-{
-	struct tps6586x_regulator *ri = rdev_get_drvdata(rdev);
-	struct device *parent = to_tps6586x_dev(rdev);
-
-	return tps6586x_set_bits(parent, ri->enable_reg[0],
-				 1 << ri->enable_bit[0]);
-}
-
-static int tps6586x_regulator_disable(struct regulator_dev *rdev)
-{
-	struct tps6586x_regulator *ri = rdev_get_drvdata(rdev);
-	struct device *parent = to_tps6586x_dev(rdev);
-
-	return tps6586x_clr_bits(parent, ri->enable_reg[0],
-				 1 << ri->enable_bit[0]);
-}
-
-static int tps6586x_regulator_is_enabled(struct regulator_dev *rdev)
-{
-	struct tps6586x_regulator *ri = rdev_get_drvdata(rdev);
-	struct device *parent = to_tps6586x_dev(rdev);
-	uint8_t reg_val;
-	int ret;
-
-	ret = tps6586x_read(parent, ri->enable_reg[0], &reg_val);
-	if (ret)
-		return ret;
-
-	return !!(reg_val & (1 << ri->enable_bit[0]));
-}
-
 static struct regulator_ops tps6586x_regulator_ops = {
 	.list_voltage = regulator_list_voltage_table,
-	.get_voltage_sel = tps6586x_get_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = tps6586x_set_voltage_sel,
 
-	.is_enabled = tps6586x_regulator_is_enabled,
-	.enable = tps6586x_regulator_enable,
-	.disable = tps6586x_regulator_disable,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
 };
 
 static const unsigned int tps6586x_ldo0_voltages[] = {
@@ -202,10 +147,11 @@ static const unsigned int tps6586x_dvm_voltages[] = {
 		.n_voltages = ARRAY_SIZE(tps6586x_##vdata##_voltages),	\
 		.volt_table = tps6586x_##vdata##_voltages,		\
 		.owner	= THIS_MODULE,					\
+		.enable_reg = TPS6586X_SUPPLY##ereg0,			\
+		.enable_mask = 1 << (ebit0),				\
+		.vsel_reg = TPS6586X_##vreg,				\
+		.vsel_mask = ((1 << (nbits)) - 1) << (shift),		\
 	},								\
-	.volt_reg	= TPS6586X_##vreg,				\
-	.volt_shift	= (shift),					\
-	.volt_nbits	= (nbits),					\
 	.enable_reg[0]	= TPS6586X_SUPPLY##ereg0,			\
 	.enable_bit[0]	= (ebit0),					\
 	.enable_reg[1]	= TPS6586X_SUPPLY##ereg1,			\
-- 
1.7.9.5



