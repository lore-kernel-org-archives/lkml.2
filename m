Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837Ab2EOCEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:04:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34080 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717Ab2EOCEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:04:32 -0400
Message-ID: <1337047463.26683.1.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: da903x: Convert to
 regulator_list_voltage_linear()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 15 May 2012 10:04:23 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use regulator_list_voltage_linear() to replace da903x_list_voltage().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da903x.c |   54 +++++++++++++++++--------------------------
 1 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index c75e7b7..3a0d080 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -76,9 +76,7 @@
 struct da903x_regulator_info {
 	struct regulator_desc desc;
 
-	int	min_uV;
 	int	max_uV;
-	int	step_uV;
 	int	vol_reg;
 	int	vol_shift;
 	int	vol_nbits;
@@ -96,7 +94,7 @@ static inline struct device *to_da903x_dev(struct regulator_dev *rdev)
 static inline int check_range(struct da903x_regulator_info *info,
 				int min_uV, int max_uV)
 {
-	if (min_uV < info->min_uV || min_uV > info->max_uV)
+	if (min_uV < info->desc.min_uV || min_uV > info->max_uV)
 		return -EINVAL;
 
 	return 0;
@@ -115,7 +113,7 @@ static int da903x_set_ldo_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	val = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
+	val = DIV_ROUND_UP(min_uV - info->desc.min_uV, info->desc.uV_step);
 	*selector = val;
 	val <<= info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
@@ -172,17 +170,6 @@ static int da903x_is_enabled(struct regulator_dev *rdev)
 	return !!(reg_val & (1 << info->enable_bit));
 }
 
-static int da903x_list_voltage(struct regulator_dev *rdev, unsigned selector)
-{
-	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	int ret;
-
-	ret = info->min_uV + info->step_uV * selector;
-	if (ret > info->max_uV)
-		return -EINVAL;
-	return ret;
-}
-
 /* DA9030 specific operations */
 static int da9030_set_ldo1_15_voltage(struct regulator_dev *rdev,
 				      int min_uV, int max_uV,
@@ -198,7 +185,7 @@ static int da9030_set_ldo1_15_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	val = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
+	val = DIV_ROUND_UP(min_uV - info->desc.min_uV, info->desc.uV_step);
 	*selector = val;
 	val <<= info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
@@ -227,12 +214,12 @@ static int da9030_set_ldo14_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	thresh = (info->max_uV + info->min_uV) / 2;
+	thresh = (info->max_uV + info->desc.min_uV) / 2;
 	if (min_uV < thresh) {
-		val = DIV_ROUND_UP(thresh - min_uV, info->step_uV);
+		val = DIV_ROUND_UP(thresh - min_uV, info->desc.uV_step);
 		val |= 0x4;
 	} else {
-		val = DIV_ROUND_UP(min_uV - thresh, info->step_uV);
+		val = DIV_ROUND_UP(min_uV - thresh, info->desc.uV_step);
 	}
 
 	*selector = val;
@@ -266,10 +253,11 @@ static int da9030_list_ldo14_voltage(struct regulator_dev *rdev,
 	int volt;
 
 	if (selector & 0x4)
-		volt = info->min_uV + info->step_uV * (3 - (selector & ~0x4));
+		volt = rdev->desc->min_uV +
+		       rdev->desc->uV_step * (3 - (selector & ~0x4));
 	else
-		volt = (info->max_uV + info->min_uV) / 2 +
-		       info->step_uV * (selector & ~0x4);
+		volt = (info->max_uV + rdev->desc->min_uV) / 2 +
+		       rdev->desc->uV_step * (selector & ~0x4);
 
 	if (volt > info->max_uV)
 		return -EINVAL;
@@ -291,7 +279,7 @@ static int da9034_set_dvc_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	val = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
+	val = DIV_ROUND_UP(min_uV - info->desc.min_uV, info->desc.uV_step);
 	*selector = val;
 	val <<= info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
@@ -317,7 +305,7 @@ static int da9034_set_ldo12_voltage(struct regulator_dev *rdev,
 		return -EINVAL;
 	}
 
-	val = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
+	val = DIV_ROUND_UP(min_uV - info->desc.min_uV, info->desc.uV_step);
 	val = (val >= 20) ? val - 12 : ((val > 7) ? 8 : val);
 	*selector = val;
 	val <<= info->vol_shift;
@@ -350,9 +338,9 @@ static int da9034_list_ldo12_voltage(struct regulator_dev *rdev,
 	int volt;
 
 	if (selector >= 8)
-		volt = 2700000 + info->step_uV * (selector - 8);
+		volt = 2700000 + rdev->desc->uV_step * (selector - 8);
 	else
-		volt = info->min_uV + info->step_uV * selector;
+		volt = rdev->desc->min_uV + rdev->desc->uV_step * selector;
 
 	if (volt > info->max_uV)
 		return -EINVAL;
@@ -363,7 +351,7 @@ static int da9034_list_ldo12_voltage(struct regulator_dev *rdev,
 static struct regulator_ops da903x_regulator_ldo_ops = {
 	.set_voltage	= da903x_set_ldo_voltage,
 	.get_voltage_sel = da903x_get_voltage_sel,
-	.list_voltage	= da903x_list_voltage,
+	.list_voltage	= regulator_list_voltage_linear,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
 	.is_enabled	= da903x_is_enabled,
@@ -383,7 +371,7 @@ static struct regulator_ops da9030_regulator_ldo14_ops = {
 static struct regulator_ops da9030_regulator_ldo1_15_ops = {
 	.set_voltage	= da9030_set_ldo1_15_voltage,
 	.get_voltage_sel = da903x_get_voltage_sel,
-	.list_voltage	= da903x_list_voltage,
+	.list_voltage	= regulator_list_voltage_linear,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
 	.is_enabled	= da903x_is_enabled,
@@ -392,7 +380,7 @@ static struct regulator_ops da9030_regulator_ldo1_15_ops = {
 static struct regulator_ops da9034_regulator_dvc_ops = {
 	.set_voltage	= da9034_set_dvc_voltage,
 	.get_voltage_sel = da903x_get_voltage_sel,
-	.list_voltage	= da903x_list_voltage,
+	.list_voltage	= regulator_list_voltage_linear,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
 	.is_enabled	= da903x_is_enabled,
@@ -417,10 +405,10 @@ static struct regulator_ops da9034_regulator_ldo12_ops = {
 		.id	= _pmic##_ID_LDO##_id,				\
 		.n_voltages = (step) ? ((max - min) / step + 1) : 1,	\
 		.owner	= THIS_MODULE,					\
+		.min_uV	 = (min) * 1000,				\
+		.uV_step = (step) * 1000,				\
 	},								\
-	.min_uV		= (min) * 1000,					\
 	.max_uV		= (max) * 1000,					\
-	.step_uV	= (step) * 1000,				\
 	.vol_reg	= _pmic##_##vreg,				\
 	.vol_shift	= (shift),					\
 	.vol_nbits	= (nbits),					\
@@ -437,10 +425,10 @@ static struct regulator_ops da9034_regulator_ldo12_ops = {
 		.id	= _pmic##_ID_##_id,				\
 		.n_voltages = (step) ? ((max - min) / step + 1) : 1,	\
 		.owner	= THIS_MODULE,					\
+		.min_uV = (min) * 1000,					\
+		.uV_step = (step) * 1000,				\
 	},								\
-	.min_uV		= (min) * 1000,					\
 	.max_uV		= (max) * 1000,					\
-	.step_uV	= (step) * 1000,				\
 	.vol_reg	= _pmic##_##vreg,				\
 	.vol_shift	= (0),						\
 	.vol_nbits	= (nbits),					\
-- 
1.7.5.4



