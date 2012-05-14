Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab2ENQNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:13:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50211 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab2ENQNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:13:16 -0400
Message-ID: <1337011990.13224.2.camel@phoenix>
Subject: [PATCH 2/4] regulator: max8649: Use
 regulator_get_voltage_sel_regmap()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonghwan Choi <jhbird.choi@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 15 May 2012 00:13:10 +0800
In-Reply-To: <1337011930.13224.1.camel@phoenix>
References: <1337011930.13224.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8649.c |   45 +++++++++++++++---------------------------
 1 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 3b73a7f..575cf48 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -53,7 +53,6 @@ struct max8649_regulator_info {
 	struct device		*dev;
 	struct regmap		*regmap;
 
-	int		vol_reg;
 	unsigned	mode:2;	/* bit[1:0] = VID1, VID0 */
 	unsigned	extclk_freq:2;
 	unsigned	extclk:1;
@@ -76,20 +75,6 @@ static int max8649_list_voltage(struct regulator_dev *rdev, unsigned index)
 	return (MAX8649_DCDC_VMIN + index * MAX8649_DCDC_STEP);
 }
 
-static int max8649_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct max8649_regulator_info *info = rdev_get_drvdata(rdev);
-	unsigned int val;
-	unsigned char data;
-	int ret;
-
-	ret = regmap_read(info->regmap, info->vol_reg, &val);
-	if (ret != 0)
-		return ret;
-	data = (unsigned char)val & MAX8649_VOL_MASK;
-	return data;
-}
-
 static int max8649_set_voltage(struct regulator_dev *rdev,
 			       int min_uV, int max_uV, unsigned *selector)
 {
@@ -105,7 +90,8 @@ static int max8649_set_voltage(struct regulator_dev *rdev,
 	mask = MAX8649_VOL_MASK;
 	*selector = data & mask;
 
-	return regmap_update_bits(info->regmap, info->vol_reg, mask, data);
+	return regmap_update_bits(info->regmap, rdev->desc->vsel_reg, mask,
+				  data);
 }
 
 /* EN_PD means pulldown on EN input */
@@ -145,7 +131,7 @@ static int max8649_enable_time(struct regulator_dev *rdev)
 	unsigned int val;
 
 	/* get voltage */
-	ret = regmap_read(info->regmap, info->vol_reg, &val);
+	ret = regmap_read(info->regmap, rdev->desc->vsel_reg, &val);
 	if (ret != 0)
 		return ret;
 	val &= MAX8649_VOL_MASK;
@@ -167,11 +153,11 @@ static int max8649_set_mode(struct regulator_dev *rdev, unsigned int mode)
 
 	switch (mode) {
 	case REGULATOR_MODE_FAST:
-		regmap_update_bits(info->regmap, info->vol_reg, MAX8649_FORCE_PWM,
-				   MAX8649_FORCE_PWM);
+		regmap_update_bits(info->regmap, rdev->desc->vsel_reg,
+				   MAX8649_FORCE_PWM, MAX8649_FORCE_PWM);
 		break;
 	case REGULATOR_MODE_NORMAL:
-		regmap_update_bits(info->regmap, info->vol_reg,
+		regmap_update_bits(info->regmap, rdev->desc->vsel_reg,
 				   MAX8649_FORCE_PWM, 0);
 		break;
 	default:
@@ -186,7 +172,7 @@ static unsigned int max8649_get_mode(struct regulator_dev *rdev)
 	unsigned int val;
 	int ret;
 
-	ret = regmap_read(info->regmap, info->vol_reg, &val);
+	ret = regmap_read(info->regmap, rdev->desc->vsel_reg, &val);
 	if (ret != 0)
 		return ret;
 	if (val & MAX8649_FORCE_PWM)
@@ -196,7 +182,7 @@ static unsigned int max8649_get_mode(struct regulator_dev *rdev)
 
 static struct regulator_ops max8649_dcdc_ops = {
 	.set_voltage	= max8649_set_voltage,
-	.get_voltage_sel = max8649_get_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage	= max8649_list_voltage,
 	.enable		= max8649_enable,
 	.disable	= max8649_disable,
@@ -207,12 +193,13 @@ static struct regulator_ops max8649_dcdc_ops = {
 
 };
 
-static const struct regulator_desc dcdc_desc = {
+static struct regulator_desc dcdc_desc = {
 	.name		= "max8649",
 	.ops		= &max8649_dcdc_ops,
 	.type		= REGULATOR_VOLTAGE,
 	.n_voltages	= 1 << 6,
 	.owner		= THIS_MODULE,
+	.vsel_mask	= MAX8649_VOL_MASK,
 };
 
 static struct regmap_config max8649_regmap_config = {
@@ -250,16 +237,16 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 	info->mode = pdata->mode;
 	switch (info->mode) {
 	case 0:
-		info->vol_reg = MAX8649_MODE0;
+		dcdc_desc.vsel_reg = MAX8649_MODE0;
 		break;
 	case 1:
-		info->vol_reg = MAX8649_MODE1;
+		dcdc_desc.vsel_reg = MAX8649_MODE1;
 		break;
 	case 2:
-		info->vol_reg = MAX8649_MODE2;
+		dcdc_desc.vsel_reg = MAX8649_MODE2;
 		break;
 	case 3:
-		info->vol_reg = MAX8649_MODE3;
+		dcdc_desc.vsel_reg = MAX8649_MODE3;
 		break;
 	default:
 		break;
@@ -279,7 +266,8 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 	/* enable/disable external clock synchronization */
 	info->extclk = pdata->extclk;
 	data = (info->extclk) ? MAX8649_SYNC_EXTCLK : 0;
-	regmap_update_bits(info->regmap, info->vol_reg, MAX8649_SYNC_EXTCLK, data);
+	regmap_update_bits(info->regmap, dcdc_desc.vsel_reg,
+			   MAX8649_SYNC_EXTCLK, data);
 	if (info->extclk) {
 		/* set external clock frequency */
 		info->extclk_freq = pdata->extclk_freq;
@@ -356,4 +344,3 @@ module_exit(max8649_exit);
 MODULE_DESCRIPTION("MAXIM 8649 voltage regulator driver");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
 MODULE_LICENSE("GPL");
-
-- 
1.7.5.4



