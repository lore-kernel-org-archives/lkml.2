Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2EHLrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:47:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36427 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab2EHLry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:47:54 -0400
Message-ID: <1336477667.13339.6.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: da903x: Convert to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 08 May 2012 19:47:47 +0800
In-Reply-To: <1336477570.13339.4.camel@phoenix>
References: <1336477570.13339.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da903x.c |   48 +++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index a9c4590..c75e7b7 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -88,10 +88,6 @@ struct da903x_regulator_info {
 	int	enable_bit;
 };
 
-static int da9034_ldo12_data[] = { 1700, 1750, 1800, 1850, 1900, 1950,
-				   2000, 2050, 2700, 2750, 2800, 2850,
-				   2900, 2950, 3000, 3050 };
-
 static inline struct device *to_da903x_dev(struct regulator_dev *rdev)
 {
 	return rdev_get_dev(rdev)->parent->parent;
@@ -127,7 +123,7 @@ static int da903x_set_ldo_voltage(struct regulator_dev *rdev,
 	return da903x_update(da9034_dev, info->vol_reg, val, mask);
 }
 
-static int da903x_get_voltage(struct regulator_dev *rdev)
+static int da903x_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da9034_dev = to_da903x_dev(rdev);
@@ -141,7 +137,7 @@ static int da903x_get_voltage(struct regulator_dev *rdev)
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 	val = (val & mask) >> info->vol_shift;
 
-	return info->min_uV + info->step_uV * val;
+	return val;
 }
 
 static int da903x_enable(struct regulator_dev *rdev)
@@ -246,7 +242,7 @@ static int da9030_set_ldo14_voltage(struct regulator_dev *rdev,
 	return da903x_update(da903x_dev, info->vol_reg, val, mask);
 }
 
-static int da9030_get_ldo14_voltage(struct regulator_dev *rdev)
+static int da9030_get_ldo14_voltage_sel(struct regulator_dev *rdev)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da903x_dev = to_da903x_dev(rdev);
@@ -260,11 +256,7 @@ static int da9030_get_ldo14_voltage(struct regulator_dev *rdev)
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 	val = (val & mask) >> info->vol_shift;
 
-	if (val & 0x4)
-		return info->min_uV + info->step_uV * (3 - (val & ~0x4));
-	else
-		return (info->max_uV + info->min_uV) / 2 +
-			info->step_uV * (val & ~0x4);
+	return val;
 }
 
 static int da9030_list_ldo14_voltage(struct regulator_dev *rdev,
@@ -334,7 +326,7 @@ static int da9034_set_ldo12_voltage(struct regulator_dev *rdev,
 	return da903x_update(da9034_dev, info->vol_reg, val, mask);
 }
 
-static int da9034_get_ldo12_voltage(struct regulator_dev *rdev)
+static int da9034_get_ldo12_voltage_sel(struct regulator_dev *rdev)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da9034_dev = to_da903x_dev(rdev);
@@ -348,23 +340,29 @@ static int da9034_get_ldo12_voltage(struct regulator_dev *rdev)
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 	val = (val & mask) >> info->vol_shift;
 
-	if (val >= 8)
-		return 2700000 + info->step_uV * (val - 8);
-
-	return info->min_uV + info->step_uV * val;
+	return val;
 }
 
 static int da9034_list_ldo12_voltage(struct regulator_dev *rdev,
 				     unsigned selector)
 {
-	if (selector >= ARRAY_SIZE(da9034_ldo12_data))
+	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
+	int volt;
+
+	if (selector >= 8)
+		volt = 2700000 + info->step_uV * (selector - 8);
+	else
+		volt = info->min_uV + info->step_uV * selector;
+
+	if (volt > info->max_uV)
 		return -EINVAL;
-	return da9034_ldo12_data[selector] * 1000;
+
+	return volt;
 }
 
 static struct regulator_ops da903x_regulator_ldo_ops = {
 	.set_voltage	= da903x_set_ldo_voltage,
-	.get_voltage	= da903x_get_voltage,
+	.get_voltage_sel = da903x_get_voltage_sel,
 	.list_voltage	= da903x_list_voltage,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
@@ -374,7 +372,7 @@ static struct regulator_ops da903x_regulator_ldo_ops = {
 /* NOTE: this is dedicated for the insane DA9030 LDO14 */
 static struct regulator_ops da9030_regulator_ldo14_ops = {
 	.set_voltage	= da9030_set_ldo14_voltage,
-	.get_voltage	= da9030_get_ldo14_voltage,
+	.get_voltage_sel = da9030_get_ldo14_voltage_sel,
 	.list_voltage	= da9030_list_ldo14_voltage,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
@@ -384,7 +382,7 @@ static struct regulator_ops da9030_regulator_ldo14_ops = {
 /* NOTE: this is dedicated for the DA9030 LDO1 and LDO15 that have locks  */
 static struct regulator_ops da9030_regulator_ldo1_15_ops = {
 	.set_voltage	= da9030_set_ldo1_15_voltage,
-	.get_voltage	= da903x_get_voltage,
+	.get_voltage_sel = da903x_get_voltage_sel,
 	.list_voltage	= da903x_list_voltage,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
@@ -393,7 +391,7 @@ static struct regulator_ops da9030_regulator_ldo1_15_ops = {
 
 static struct regulator_ops da9034_regulator_dvc_ops = {
 	.set_voltage	= da9034_set_dvc_voltage,
-	.get_voltage	= da903x_get_voltage,
+	.get_voltage_sel = da903x_get_voltage_sel,
 	.list_voltage	= da903x_list_voltage,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
@@ -403,7 +401,7 @@ static struct regulator_ops da9034_regulator_dvc_ops = {
 /* NOTE: this is dedicated for the insane LDO12 */
 static struct regulator_ops da9034_regulator_ldo12_ops = {
 	.set_voltage	= da9034_set_ldo12_voltage,
-	.get_voltage	= da9034_get_ldo12_voltage,
+	.get_voltage_sel = da9034_get_ldo12_voltage_sel,
 	.list_voltage	= da9034_list_ldo12_voltage,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
@@ -546,7 +544,7 @@ static int __devinit da903x_regulator_probe(struct platform_device *pdev)
 	/* Workaround for the weird LDO12 voltage setting */
 	if (ri->desc.id == DA9034_ID_LDO12) {
 		ri->desc.ops = &da9034_regulator_ldo12_ops;
-		ri->desc.n_voltages = ARRAY_SIZE(da9034_ldo12_data);
+		ri->desc.n_voltages = 16;
 	}
 
 	if (ri->desc.id == DA9030_ID_LDO14)
-- 
1.7.5.4



