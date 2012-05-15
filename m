Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861Ab2EOCGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:06:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39136 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab2EOCGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:06:33 -0400
Message-ID: <1337047587.26683.3.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: da903x: Convert to set_voltage_sel and
 map_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 15 May 2012 10:06:27 +0800
In-Reply-To: <1337047463.26683.1.camel@phoenix>
References: <1337047463.26683.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da903x.c |  110 +++++++++++++++++++++----------------------
 1 files changed, 54 insertions(+), 56 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 3a0d080..6e78ef1 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -101,21 +101,14 @@ static inline int check_range(struct da903x_regulator_info *info,
 }
 
 /* DA9030/DA9034 common operations */
-static int da903x_set_ldo_voltage(struct regulator_dev *rdev,
-				  int min_uV, int max_uV, unsigned *selector)
+static int da903x_set_ldo_voltage_sel(struct regulator_dev *rdev,
+				      unsigned selector)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da9034_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 
-	if (check_range(info, min_uV, max_uV)) {
-		pr_err("invalid voltage range (%d, %d) uV\n", min_uV, max_uV);
-		return -EINVAL;
-	}
-
-	val = DIV_ROUND_UP(min_uV - info->desc.min_uV, info->desc.uV_step);
-	*selector = val;
-	val <<= info->vol_shift;
+	val = selector << info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 
 	return da903x_update(da9034_dev, info->vol_reg, val, mask);
@@ -171,23 +164,15 @@ static int da903x_is_enabled(struct regulator_dev *rdev)
 }
 
 /* DA9030 specific operations */
-static int da9030_set_ldo1_15_voltage(struct regulator_dev *rdev,
-				      int min_uV, int max_uV,
-				      unsigned *selector)
+static int da9030_set_ldo1_15_voltage_sel(struct regulator_dev *rdev,
+					  unsigned selector)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da903x_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 	int ret;
 
-	if (check_range(info, min_uV, max_uV)) {
-		pr_err("invalid voltage range (%d, %d) uV\n", min_uV, max_uV);
-		return -EINVAL;
-	}
-
-	val = DIV_ROUND_UP(min_uV - info->desc.min_uV, info->desc.uV_step);
-	*selector = val;
-	val <<= info->vol_shift;
+	val = selector << info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 	val |= DA9030_LDO_UNLOCK; /* have to set UNLOCK bits */
 	mask |= DA9030_LDO_UNLOCK_MASK;
@@ -200,14 +185,24 @@ static int da9030_set_ldo1_15_voltage(struct regulator_dev *rdev,
 	return da903x_update(da903x_dev, info->vol_reg, val, mask);
 }
 
-static int da9030_set_ldo14_voltage(struct regulator_dev *rdev,
-				    int min_uV, int max_uV,
-				    unsigned *selector)
+static int da9030_set_ldo14_voltage_sel(struct regulator_dev *rdev,
+					unsigned selector)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da903x_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
-	int thresh;
+
+	val = selector << info->vol_shift;
+	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
+
+	return da903x_update(da903x_dev, info->vol_reg, val, mask);
+}
+
+static int da9030_map_ldo14_voltage(struct regulator_dev *rdev,
+				    int min_uV, int max_uV)
+{
+	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
+	int thresh, sel;
 
 	if (check_range(info, min_uV, max_uV)) {
 		pr_err("invalid voltage range (%d, %d) uV\n", min_uV, max_uV);
@@ -216,17 +211,13 @@ static int da9030_set_ldo14_voltage(struct regulator_dev *rdev,
 
 	thresh = (info->max_uV + info->desc.min_uV) / 2;
 	if (min_uV < thresh) {
-		val = DIV_ROUND_UP(thresh - min_uV, info->desc.uV_step);
-		val |= 0x4;
+		sel = DIV_ROUND_UP(thresh - min_uV, info->desc.uV_step);
+		sel |= 0x4;
 	} else {
-		val = DIV_ROUND_UP(min_uV - thresh, info->desc.uV_step);
+		sel = DIV_ROUND_UP(min_uV - thresh, info->desc.uV_step);
 	}
 
-	*selector = val;
-	val <<= info->vol_shift;
-	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
-
-	return da903x_update(da903x_dev, info->vol_reg, val, mask);
+	return sel;
 }
 
 static int da9030_get_ldo14_voltage_sel(struct regulator_dev *rdev)
@@ -266,22 +257,15 @@ static int da9030_list_ldo14_voltage(struct regulator_dev *rdev,
 }
 
 /* DA9034 specific operations */
-static int da9034_set_dvc_voltage(struct regulator_dev *rdev,
-				  int min_uV, int max_uV, unsigned *selector)
+static int da9034_set_dvc_voltage_sel(struct regulator_dev *rdev,
+				      unsigned selector)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da9034_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 	int ret;
 
-	if (check_range(info, min_uV, max_uV)) {
-		pr_err("invalid voltage range (%d, %d) uV\n", min_uV, max_uV);
-		return -EINVAL;
-	}
-
-	val = DIV_ROUND_UP(min_uV - info->desc.min_uV, info->desc.uV_step);
-	*selector = val;
-	val <<= info->vol_shift;
+	val = selector << info->vol_shift;
 	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
 
 	ret = da903x_update(da9034_dev, info->vol_reg, val, mask);
@@ -293,25 +277,34 @@ static int da9034_set_dvc_voltage(struct regulator_dev *rdev,
 	return ret;
 }
 
-static int da9034_set_ldo12_voltage(struct regulator_dev *rdev,
-				    int min_uV, int max_uV, unsigned *selector)
+static int da9034_set_ldo12_voltage_sel(struct regulator_dev *rdev,
+					unsigned selector)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da9034_dev = to_da903x_dev(rdev);
 	uint8_t val, mask;
 
+	val = selector << info->vol_shift;
+	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
+
+	return da903x_update(da9034_dev, info->vol_reg, val, mask);
+}
+
+static int da9034_map_ldo12_voltage(struct regulator_dev *rdev,
+				    int min_uV, int max_uV)
+{
+	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
+	int sel;
+
 	if (check_range(info, min_uV, max_uV)) {
 		pr_err("invalid voltage range (%d, %d) uV\n", min_uV, max_uV);
 		return -EINVAL;
 	}
 
-	val = DIV_ROUND_UP(min_uV - info->desc.min_uV, info->desc.uV_step);
-	val = (val >= 20) ? val - 12 : ((val > 7) ? 8 : val);
-	*selector = val;
-	val <<= info->vol_shift;
-	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
+	sel = DIV_ROUND_UP(min_uV - info->desc.min_uV, info->desc.uV_step);
+	sel = (sel >= 20) ? sel - 12 : ((sel > 7) ? 8 : sel);
 
-	return da903x_update(da9034_dev, info->vol_reg, val, mask);
+	return sel;
 }
 
 static int da9034_get_ldo12_voltage_sel(struct regulator_dev *rdev)
@@ -349,9 +342,10 @@ static int da9034_list_ldo12_voltage(struct regulator_dev *rdev,
 }
 
 static struct regulator_ops da903x_regulator_ldo_ops = {
-	.set_voltage	= da903x_set_ldo_voltage,
+	.set_voltage_sel = da903x_set_ldo_voltage_sel,
 	.get_voltage_sel = da903x_get_voltage_sel,
 	.list_voltage	= regulator_list_voltage_linear,
+	.map_voltage	= regulator_map_voltage_linear,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
 	.is_enabled	= da903x_is_enabled,
@@ -359,9 +353,10 @@ static struct regulator_ops da903x_regulator_ldo_ops = {
 
 /* NOTE: this is dedicated for the insane DA9030 LDO14 */
 static struct regulator_ops da9030_regulator_ldo14_ops = {
-	.set_voltage	= da9030_set_ldo14_voltage,
+	.set_voltage_sel = da9030_set_ldo14_voltage_sel,
 	.get_voltage_sel = da9030_get_ldo14_voltage_sel,
 	.list_voltage	= da9030_list_ldo14_voltage,
+	.map_voltage	= da9030_map_ldo14_voltage,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
 	.is_enabled	= da903x_is_enabled,
@@ -369,18 +364,20 @@ static struct regulator_ops da9030_regulator_ldo14_ops = {
 
 /* NOTE: this is dedicated for the DA9030 LDO1 and LDO15 that have locks  */
 static struct regulator_ops da9030_regulator_ldo1_15_ops = {
-	.set_voltage	= da9030_set_ldo1_15_voltage,
+	.set_voltage_sel = da9030_set_ldo1_15_voltage_sel,
 	.get_voltage_sel = da903x_get_voltage_sel,
 	.list_voltage	= regulator_list_voltage_linear,
+	.map_voltage	= regulator_map_voltage_linear,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
 	.is_enabled	= da903x_is_enabled,
 };
 
 static struct regulator_ops da9034_regulator_dvc_ops = {
-	.set_voltage	= da9034_set_dvc_voltage,
+	.set_voltage_sel = da9034_set_dvc_voltage_sel,
 	.get_voltage_sel = da903x_get_voltage_sel,
 	.list_voltage	= regulator_list_voltage_linear,
+	.map_voltage	= regulator_map_voltage_linear,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
 	.is_enabled	= da903x_is_enabled,
@@ -388,9 +385,10 @@ static struct regulator_ops da9034_regulator_dvc_ops = {
 
 /* NOTE: this is dedicated for the insane LDO12 */
 static struct regulator_ops da9034_regulator_ldo12_ops = {
-	.set_voltage	= da9034_set_ldo12_voltage,
+	.set_voltage_sel = da9034_set_ldo12_voltage_sel,
 	.get_voltage_sel = da9034_get_ldo12_voltage_sel,
 	.list_voltage	= da9034_list_ldo12_voltage,
+	.map_voltage	= da9034_map_ldo12_voltage,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
 	.is_enabled	= da903x_is_enabled,
-- 
1.7.5.4



