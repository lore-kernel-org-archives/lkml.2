Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2DQGLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:11:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59929 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2DQGLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:11:41 -0400
Message-ID: <1334643091.22780.2.camel@phoenix>
Subject: [PATCH RFT] regulator: rc5t583: Use generic regmap enable/disable
 operations
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 17 Apr 2012 14:11:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/rc5t583-regulator.c |   63 +++-----------------------------
 1 files changed, 6 insertions(+), 57 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index b567c9e..81a74d1 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -37,8 +37,6 @@ struct rc5t583_regulator_info {
 	int			deepsleep_id;
 
 	/* Regulator register address.*/
-	uint8_t			reg_en_reg;
-	uint8_t			en_bit;
 	uint8_t			reg_disc_reg;
 	uint8_t			disc_bit;
 	uint8_t			vout_reg;
@@ -67,56 +65,6 @@ struct rc5t583_regulator {
 	struct regulator_dev	*rdev;
 };
 
-static int rc5t583_reg_is_enabled(struct regulator_dev *rdev)
-{
-	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
-	struct rc5t583_regulator_info *ri = reg->reg_info;
-	uint8_t control;
-	int ret;
-
-	ret = rc5t583_read(reg->mfd->dev, ri->reg_en_reg, &control);
-	if (ret < 0) {
-		dev_err(&rdev->dev,
-			"Error in reading the control register 0x%02x\n",
-			ri->reg_en_reg);
-		return ret;
-	}
-	return !!(control & BIT(ri->en_bit));
-}
-
-static int rc5t583_reg_enable(struct regulator_dev *rdev)
-{
-	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
-	struct rc5t583_regulator_info *ri = reg->reg_info;
-	int ret;
-
-	ret = rc5t583_set_bits(reg->mfd->dev, ri->reg_en_reg,
-				(1 << ri->en_bit));
-	if (ret < 0) {
-		dev_err(&rdev->dev,
-			"Error in setting bit of STATE register 0x%02x\n",
-			ri->reg_en_reg);
-		return ret;
-	}
-	return ret;
-}
-
-static int rc5t583_reg_disable(struct regulator_dev *rdev)
-{
-	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
-	struct rc5t583_regulator_info *ri = reg->reg_info;
-	int ret;
-
-	ret = rc5t583_clear_bits(reg->mfd->dev, ri->reg_en_reg,
-				(1 << ri->en_bit));
-	if (ret < 0)
-		dev_err(&rdev->dev,
-			"Error in clearing bit of STATE register 0x%02x\n",
-			ri->reg_en_reg);
-
-	return ret;
-}
-
 static int rc5t583_list_voltage(struct regulator_dev *rdev, unsigned selector)
 {
 	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
@@ -193,9 +141,9 @@ static int rc5t583_set_voltage_time_sel(struct regulator_dev *rdev,
 
 
 static struct regulator_ops rc5t583_ops = {
-	.is_enabled		= rc5t583_reg_is_enabled,
-	.enable			= rc5t583_reg_enable,
-	.disable		= rc5t583_reg_disable,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
 	.enable_time		= rc5t583_regulator_enable_time,
 	.get_voltage_sel	= rc5t583_get_voltage_sel,
 	.set_voltage		= rc5t583_set_voltage,
@@ -206,8 +154,6 @@ static struct regulator_ops rc5t583_ops = {
 #define RC5T583_REG(_id, _en_reg, _en_bit, _disc_reg, _disc_bit, \
 		_vout_mask, _min_mv, _max_mv, _step_uV, _enable_mv) \
 {								\
-	.reg_en_reg	= RC5T583_REG_##_en_reg,		\
-	.en_bit		= _en_bit,				\
 	.reg_disc_reg	= RC5T583_REG_##_disc_reg,		\
 	.disc_bit	= _disc_bit,				\
 	.vout_reg	= RC5T583_REG_##_id##DAC,		\
@@ -226,6 +172,8 @@ static struct regulator_ops rc5t583_ops = {
 		.ops = &rc5t583_ops,				\
 		.type = REGULATOR_VOLTAGE,			\
 		.owner = THIS_MODULE,				\
+		.enable_reg = RC5T583_REG_##_en_reg,		\
+		.enable_mask = BIT(_en_bit),			\
 	},							\
 }
 
@@ -304,6 +252,7 @@ skip_ext_pwr_config:
 		config.dev = &pdev->dev;
 		config.init_data = reg_data;
 		config.driver_data = reg;
+		config.regmap = rc5t583->regmap;
 
 		rdev = regulator_register(&ri->desc, &config);
 		if (IS_ERR(rdev)) {
-- 
1.7.5.4



