Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab2CWCuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 22:50:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60416 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab2CWCuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 22:50:03 -0400
Message-ID: <1332470994.13074.2.camel@phoenix>
Subject: [PATCH 1/2] regulator: Convert lp3971 to set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 23 Mar 2012 10:49:54 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/lp3971.c |   58 +++++++++++--------------------------------
 1 files changed, 15 insertions(+), 43 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 0cfabd3..49bcdb0 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -124,6 +124,10 @@ static const int *ldo_voltage_map[] = {
 static int lp3971_ldo_list_voltage(struct regulator_dev *dev, unsigned index)
 {
 	int ldo = rdev_get_id(dev) - LP3971_LDO1;
+
+	if (index > LDO_VOL_MAX_IDX)
+		return -EINVAL;
+
 	return 1000 * LDO_VOL_VALUE_MAP(ldo)[index];
 }
 
@@ -168,32 +172,15 @@ static int lp3971_ldo_get_voltage(struct regulator_dev *dev)
 	return 1000 * LDO_VOL_VALUE_MAP(ldo)[val];
 }
 
-static int lp3971_ldo_set_voltage(struct regulator_dev *dev,
-				  int min_uV, int max_uV,
-				  unsigned int *selector)
+static int lp3971_ldo_set_voltage_sel(struct regulator_dev *dev,
+				      unsigned int selector)
 {
 	struct lp3971 *lp3971 = rdev_get_drvdata(dev);
 	int ldo = rdev_get_id(dev) - LP3971_LDO1;
-	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
-	const int *vol_map = LDO_VOL_VALUE_MAP(ldo);
-	u16 val;
-
-	if (min_vol < vol_map[LDO_VOL_MIN_IDX] ||
-	    min_vol > vol_map[LDO_VOL_MAX_IDX])
-		return -EINVAL;
-
-	for (val = LDO_VOL_MIN_IDX; val <= LDO_VOL_MAX_IDX; val++)
-		if (vol_map[val] >= min_vol)
-			break;
-
-	if (val > LDO_VOL_MAX_IDX || vol_map[val] > max_vol)
-		return -EINVAL;
-
-	*selector = val;
 
 	return lp3971_set_bits(lp3971, LP3971_LDO_VOL_CONTR_REG(ldo),
 			LDO_VOL_CONTR_MASK << LDO_VOL_CONTR_SHIFT(ldo),
-			val << LDO_VOL_CONTR_SHIFT(ldo));
+			selector << LDO_VOL_CONTR_SHIFT(ldo));
 }
 
 static struct regulator_ops lp3971_ldo_ops = {
@@ -202,11 +189,14 @@ static struct regulator_ops lp3971_ldo_ops = {
 	.enable = lp3971_ldo_enable,
 	.disable = lp3971_ldo_disable,
 	.get_voltage = lp3971_ldo_get_voltage,
-	.set_voltage = lp3971_ldo_set_voltage,
+	.set_voltage_sel = lp3971_ldo_set_voltage_sel,
 };
 
 static int lp3971_dcdc_list_voltage(struct regulator_dev *dev, unsigned index)
 {
+	if (index < BUCK_TARGET_VOL_MIN_IDX || index > BUCK_TARGET_VOL_MAX_IDX)
+		return -EINVAL;
+
 	return 1000 * buck_voltage_map[index];
 }
 
@@ -259,33 +249,15 @@ static int lp3971_dcdc_get_voltage(struct regulator_dev *dev)
 	return val;
 }
 
-static int lp3971_dcdc_set_voltage(struct regulator_dev *dev,
-				   int min_uV, int max_uV,
-				   unsigned int *selector)
+static int lp3971_dcdc_set_voltage_sel(struct regulator_dev *dev,
+				       unsigned int selector)
 {
 	struct lp3971 *lp3971 = rdev_get_drvdata(dev);
 	int buck = rdev_get_id(dev) - LP3971_DCDC1;
-	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
-	const int *vol_map = buck_voltage_map;
-	u16 val;
 	int ret;
 
-	if (min_vol < vol_map[BUCK_TARGET_VOL_MIN_IDX] ||
-	    min_vol > vol_map[BUCK_TARGET_VOL_MAX_IDX])
-		return -EINVAL;
-
-	for (val = BUCK_TARGET_VOL_MIN_IDX; val <= BUCK_TARGET_VOL_MAX_IDX;
-	     val++)
-		if (vol_map[val] >= min_vol)
-			break;
-
-	if (val > BUCK_TARGET_VOL_MAX_IDX || vol_map[val] > max_vol)
-		return -EINVAL;
-
-	*selector = val;
-
 	ret = lp3971_set_bits(lp3971, LP3971_BUCK_TARGET_VOL1_REG(buck),
-	       BUCK_TARGET_VOL_MASK, val);
+	       BUCK_TARGET_VOL_MASK, selector);
 	if (ret)
 		return ret;
 
@@ -306,7 +278,7 @@ static struct regulator_ops lp3971_dcdc_ops = {
 	.enable = lp3971_dcdc_enable,
 	.disable = lp3971_dcdc_disable,
 	.get_voltage = lp3971_dcdc_get_voltage,
-	.set_voltage = lp3971_dcdc_set_voltage,
+	.set_voltage_sel = lp3971_dcdc_set_voltage_sel,
 };
 
 static struct regulator_desc regulators[] = {
-- 
1.7.5.4



