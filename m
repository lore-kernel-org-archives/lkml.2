Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2ENCyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:54:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45177 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab2ENCyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:54:52 -0400
Message-ID: <1336964086.24732.7.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: rc5t583: Convert to
 regulator_list_voltage_linear()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 14 May 2012 10:54:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/rc5t583-regulator.c |   28 +++++++++-------------------
 1 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index 7951260..f5d8537 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -41,9 +41,7 @@ struct rc5t583_regulator_info {
 	uint8_t			deepsleep_reg;
 
 	/* Chip constraints on regulator behavior */
-	int			min_uV;
 	int			max_uV;
-	int			step_uV;
 
 	/* Regulator specific turn-on delay  and voltage settling time*/
 	int			enable_uv_per_us;
@@ -62,24 +60,16 @@ struct rc5t583_regulator {
 	struct regulator_dev	*rdev;
 };
 
-static int rc5t583_list_voltage(struct regulator_dev *rdev, unsigned selector)
-{
-	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
-	struct rc5t583_regulator_info *ri = reg->reg_info;
-	return ri->min_uV + (ri->step_uV * selector);
-}
-
 static int rc5t583_set_voltage(struct regulator_dev *rdev,
 			       int min_uV, int max_uV, unsigned *selector)
 {
 	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
-	struct rc5t583_regulator_info *ri = reg->reg_info;
 	int sel, ret;
 
-	if (min_uV < ri->min_uV)
-		min_uV = ri->min_uV;
+	if (min_uV < rdev->desc->min_uV)
+		min_uV = rdev->desc->min_uV;
 
-	sel = DIV_ROUND_UP(min_uV - ri->min_uV, ri->step_uV);
+	sel = DIV_ROUND_UP(min_uV - rdev->desc->min_uV, rdev->desc->uV_step);
 
 	if (sel >= rdev->desc->n_voltages) {
 		dev_err(&rdev->dev, "Invalid selector 0x%02x\n", sel);
@@ -100,7 +90,7 @@ static int rc5t583_regulator_enable_time(struct regulator_dev *rdev)
 {
 	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
 	int vsel = regulator_get_voltage_sel_regmap(rdev);
-	int curr_uV = rc5t583_list_voltage(rdev, vsel);
+	int curr_uV = regulator_list_voltage_linear(rdev, vsel);
 
 	return DIV_ROUND_UP(curr_uV, reg->reg_info->enable_uv_per_us);
 }
@@ -110,12 +100,12 @@ static int rc5t583_set_voltage_time_sel(struct regulator_dev *rdev,
 {
 	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
 	int old_uV, new_uV;
-	old_uV = rc5t583_list_voltage(rdev, old_selector);
+	old_uV = regulator_list_voltage_linear(rdev, old_selector);
 
 	if (old_uV < 0)
 		return old_uV;
 
-	new_uV = rc5t583_list_voltage(rdev, new_selector);
+	new_uV = regulator_list_voltage_linear(rdev, new_selector);
 	if (new_uV < 0)
 		return new_uV;
 
@@ -131,7 +121,7 @@ static struct regulator_ops rc5t583_ops = {
 	.enable_time		= rc5t583_regulator_enable_time,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage		= rc5t583_set_voltage,
-	.list_voltage		= rc5t583_list_voltage,
+	.list_voltage		= regulator_list_voltage_linear,
 	.set_voltage_time_sel	= rc5t583_set_voltage_time_sel,
 };
 
@@ -141,9 +131,7 @@ static struct regulator_ops rc5t583_ops = {
 	.reg_disc_reg	= RC5T583_REG_##_disc_reg,		\
 	.disc_bit	= _disc_bit,				\
 	.deepsleep_reg	= RC5T583_REG_##_id##DAC_DS,		\
-	.min_uV		= _min_mv * 1000,			\
 	.max_uV		= _max_mv * 1000,			\
-	.step_uV	= _step_uV,				\
 	.enable_uv_per_us = _enable_mv * 1000,			\
 	.change_uv_per_us = 40 * 1000,				\
 	.deepsleep_id	= RC5T583_DS_##_id,			\
@@ -158,6 +146,8 @@ static struct regulator_ops rc5t583_ops = {
 		.vsel_mask = _vout_mask,			\
 		.enable_reg = RC5T583_REG_##_en_reg,		\
 		.enable_mask = BIT(_en_bit),			\
+		.min_uV	= _min_mv * 1000,			\
+		.uV_step = _step_uV,				\
 	},							\
 }
 
-- 
1.7.5.4



