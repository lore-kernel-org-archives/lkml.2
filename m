Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965628Ab2EOCZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:25:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40589 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965569Ab2EOCZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:25:03 -0400
Message-ID: <1337048696.26683.5.camel@phoenix>
Subject: [PATCH RFT] regulator: da903x: Kill
 da903x_[get|set]_[ldo12|ldo14]_voltage_sel() functions
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 15 May 2012 10:24:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the implementation of da903x_set_voltage_sel, da9030_set_ldo14_voltage_sel,
and da9034_set_ldo12_voltage_sel are exactly the same.

da903x_get_voltage_sel, da9030_get_ldo14_voltage_sel and
da9034_get_ldo12_voltage_sel are exactly the same.

So we can use da903x_[get|set]_voltage_sel and kill other functions.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is on top of below patches.
[PATCH RFT 1/2] regulator: da903x: Convert to regulator_list_voltage_linear()
[PATCH RFT 2/2] regulator: da903x: Convert to set_voltage_sel and map_voltage

I should send it as a serial, but I just generate this patch after I sent above 2 patches.

Regards,
Axel
 drivers/regulator/da903x.c |   73 +++----------------------------------------
 1 files changed, 6 insertions(+), 67 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 6e78ef1..1005f5f 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -101,8 +101,7 @@ static inline int check_range(struct da903x_regulator_info *info,
 }
 
 /* DA9030/DA9034 common operations */
-static int da903x_set_ldo_voltage_sel(struct regulator_dev *rdev,
-				      unsigned selector)
+static int da903x_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 {
 	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
 	struct device *da9034_dev = to_da903x_dev(rdev);
@@ -185,19 +184,6 @@ static int da9030_set_ldo1_15_voltage_sel(struct regulator_dev *rdev,
 	return da903x_update(da903x_dev, info->vol_reg, val, mask);
 }
 
-static int da9030_set_ldo14_voltage_sel(struct regulator_dev *rdev,
-					unsigned selector)
-{
-	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da903x_dev = to_da903x_dev(rdev);
-	uint8_t val, mask;
-
-	val = selector << info->vol_shift;
-	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
-
-	return da903x_update(da903x_dev, info->vol_reg, val, mask);
-}
-
 static int da9030_map_ldo14_voltage(struct regulator_dev *rdev,
 				    int min_uV, int max_uV)
 {
@@ -220,23 +206,6 @@ static int da9030_map_ldo14_voltage(struct regulator_dev *rdev,
 	return sel;
 }
 
-static int da9030_get_ldo14_voltage_sel(struct regulator_dev *rdev)
-{
-	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da903x_dev = to_da903x_dev(rdev);
-	uint8_t val, mask;
-	int ret;
-
-	ret = da903x_read(da903x_dev, info->vol_reg, &val);
-	if (ret)
-		return ret;
-
-	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
-	val = (val & mask) >> info->vol_shift;
-
-	return val;
-}
-
 static int da9030_list_ldo14_voltage(struct regulator_dev *rdev,
 				     unsigned selector)
 {
@@ -277,19 +246,6 @@ static int da9034_set_dvc_voltage_sel(struct regulator_dev *rdev,
 	return ret;
 }
 
-static int da9034_set_ldo12_voltage_sel(struct regulator_dev *rdev,
-					unsigned selector)
-{
-	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da9034_dev = to_da903x_dev(rdev);
-	uint8_t val, mask;
-
-	val = selector << info->vol_shift;
-	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
-
-	return da903x_update(da9034_dev, info->vol_reg, val, mask);
-}
-
 static int da9034_map_ldo12_voltage(struct regulator_dev *rdev,
 				    int min_uV, int max_uV)
 {
@@ -307,23 +263,6 @@ static int da9034_map_ldo12_voltage(struct regulator_dev *rdev,
 	return sel;
 }
 
-static int da9034_get_ldo12_voltage_sel(struct regulator_dev *rdev)
-{
-	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
-	struct device *da9034_dev = to_da903x_dev(rdev);
-	uint8_t val, mask;
-	int ret;
-
-	ret = da903x_read(da9034_dev, info->vol_reg, &val);
-	if (ret)
-		return ret;
-
-	mask = ((1 << info->vol_nbits) - 1)  << info->vol_shift;
-	val = (val & mask) >> info->vol_shift;
-
-	return val;
-}
-
 static int da9034_list_ldo12_voltage(struct regulator_dev *rdev,
 				     unsigned selector)
 {
@@ -342,7 +281,7 @@ static int da9034_list_ldo12_voltage(struct regulator_dev *rdev,
 }
 
 static struct regulator_ops da903x_regulator_ldo_ops = {
-	.set_voltage_sel = da903x_set_ldo_voltage_sel,
+	.set_voltage_sel = da903x_set_voltage_sel,
 	.get_voltage_sel = da903x_get_voltage_sel,
 	.list_voltage	= regulator_list_voltage_linear,
 	.map_voltage	= regulator_map_voltage_linear,
@@ -353,8 +292,8 @@ static struct regulator_ops da903x_regulator_ldo_ops = {
 
 /* NOTE: this is dedicated for the insane DA9030 LDO14 */
 static struct regulator_ops da9030_regulator_ldo14_ops = {
-	.set_voltage_sel = da9030_set_ldo14_voltage_sel,
-	.get_voltage_sel = da9030_get_ldo14_voltage_sel,
+	.set_voltage_sel = da903x_set_voltage_sel,
+	.get_voltage_sel = da903x_get_voltage_sel,
 	.list_voltage	= da9030_list_ldo14_voltage,
 	.map_voltage	= da9030_map_ldo14_voltage,
 	.enable		= da903x_enable,
@@ -385,8 +324,8 @@ static struct regulator_ops da9034_regulator_dvc_ops = {
 
 /* NOTE: this is dedicated for the insane LDO12 */
 static struct regulator_ops da9034_regulator_ldo12_ops = {
-	.set_voltage_sel = da9034_set_ldo12_voltage_sel,
-	.get_voltage_sel = da9034_get_ldo12_voltage_sel,
+	.set_voltage_sel = da903x_set_voltage_sel,
+	.get_voltage_sel = da903x_get_voltage_sel,
 	.list_voltage	= da9034_list_ldo12_voltage,
 	.map_voltage	= da9034_map_ldo12_voltage,
 	.enable		= da903x_enable,
-- 
1.7.5.4



