Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2DXB4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:56:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63990 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2DXB4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:56:49 -0400
Message-ID: <1335232603.6470.5.camel@phoenix>
Subject: [PATCH RFT 3/3] regulator: rc5t583: Use
 regulator_get_voltage_sel_regmap()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 24 Apr 2012 09:56:43 +0800
In-Reply-To: <1335232352.6470.1.camel@phoenix>
References: <1335232352.6470.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/rc5t583-regulator.c |   33 +++++++++------------------------
 1 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index f35dc527..7951260 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -38,8 +38,6 @@ struct rc5t583_regulator_info {
 	/* Regulator register address.*/
 	uint8_t			reg_disc_reg;
 	uint8_t			disc_bit;
-	uint8_t			vout_reg;
-	uint8_t			vout_mask;
 	uint8_t			deepsleep_reg;
 
 	/* Chip constraints on regulator behavior */
@@ -90,33 +88,20 @@ static int rc5t583_set_voltage(struct regulator_dev *rdev,
 
 	*selector = sel;
 
-	ret = rc5t583_update(reg->mfd->dev, ri->vout_reg, sel, ri->vout_mask);
+	ret = rc5t583_update(reg->mfd->dev, rdev->desc->vsel_reg, sel,
+			     rdev->desc->vsel_mask);
 	if (ret < 0)
-		dev_err(&rdev->dev,
-		    "Error in update voltage register 0x%02x\n", ri->vout_reg);
+		dev_err(&rdev->dev, "Error in update voltage register 0x%02x\n",
+			rdev->desc->vsel_reg);
 	return ret;
 }
 
-static int rc5t583_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
-	struct rc5t583_regulator_info *ri = reg->reg_info;
-	uint8_t vsel;
-	int ret;
-	ret = rc5t583_read(reg->mfd->dev, ri->vout_reg, &vsel);
-	if (ret < 0) {
-		dev_err(&rdev->dev,
-		    "Error in reading voltage register 0x%02x\n", ri->vout_reg);
-		return ret;
-	}
-	return vsel & ri->vout_mask;
-}
-
 static int rc5t583_regulator_enable_time(struct regulator_dev *rdev)
 {
 	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
-	int vsel = rc5t583_get_voltage_sel(rdev);
+	int vsel = regulator_get_voltage_sel_regmap(rdev);
 	int curr_uV = rc5t583_list_voltage(rdev, vsel);
+
 	return DIV_ROUND_UP(curr_uV, reg->reg_info->enable_uv_per_us);
 }
 
@@ -144,7 +129,7 @@ static struct regulator_ops rc5t583_ops = {
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
 	.enable_time		= rc5t583_regulator_enable_time,
-	.get_voltage_sel	= rc5t583_get_voltage_sel,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage		= rc5t583_set_voltage,
 	.list_voltage		= rc5t583_list_voltage,
 	.set_voltage_time_sel	= rc5t583_set_voltage_time_sel,
@@ -155,8 +140,6 @@ static struct regulator_ops rc5t583_ops = {
 {								\
 	.reg_disc_reg	= RC5T583_REG_##_disc_reg,		\
 	.disc_bit	= _disc_bit,				\
-	.vout_reg	= RC5T583_REG_##_id##DAC,		\
-	.vout_mask	= _vout_mask,				\
 	.deepsleep_reg	= RC5T583_REG_##_id##DAC_DS,		\
 	.min_uV		= _min_mv * 1000,			\
 	.max_uV		= _max_mv * 1000,			\
@@ -171,6 +154,8 @@ static struct regulator_ops rc5t583_ops = {
 		.ops = &rc5t583_ops,				\
 		.type = REGULATOR_VOLTAGE,			\
 		.owner = THIS_MODULE,				\
+		.vsel_reg = RC5T583_REG_##_id##DAC,		\
+		.vsel_mask = _vout_mask,			\
 		.enable_reg = RC5T583_REG_##_en_reg,		\
 		.enable_mask = BIT(_en_bit),			\
 	},							\
-- 
1.7.5.4



