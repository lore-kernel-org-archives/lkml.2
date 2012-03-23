Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab2CWCvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 22:51:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57048 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab2CWCvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 22:51:20 -0400
Message-ID: <1332471074.13074.4.camel@phoenix>
Subject: [PATCH 2/2] regulator: Convert lp3972 to set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 23 Mar 2012 10:51:14 +0800
In-Reply-To: <1332470994.13074.2.camel@phoenix>
References: <1332470994.13074.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/lp3972.c |   63 ++++++++++++-------------------------------
 1 files changed, 18 insertions(+), 45 deletions(-)

diff --git a/drivers/regulator/lp3972.c b/drivers/regulator/lp3972.c
index 49a15ee..4f28d36 100644
--- a/drivers/regulator/lp3972.c
+++ b/drivers/regulator/lp3972.c
@@ -245,6 +245,11 @@ static int lp3972_set_bits(struct lp3972 *lp3972, u8 reg, u16 mask, u16 val)
 static int lp3972_ldo_list_voltage(struct regulator_dev *dev, unsigned index)
 {
 	int ldo = rdev_get_id(dev) - LP3972_LDO1;
+
+	if (index < LP3972_LDO_VOL_MIN_IDX(ldo) ||
+	    index > LP3972_LDO_VOL_MAX_IDX(ldo))
+		return -EINVAL;
+
 	return 1000 * LP3972_LDO_VOL_VALUE_MAP(ldo)[index];
 }
 
@@ -292,34 +297,16 @@ static int lp3972_ldo_get_voltage(struct regulator_dev *dev)
 	return 1000 * LP3972_LDO_VOL_VALUE_MAP(ldo)[val];
 }
 
-static int lp3972_ldo_set_voltage(struct regulator_dev *dev,
-				  int min_uV, int max_uV,
-				  unsigned int *selector)
+static int lp3972_ldo_set_voltage_sel(struct regulator_dev *dev,
+				      unsigned int selector)
 {
 	struct lp3972 *lp3972 = rdev_get_drvdata(dev);
 	int ldo = rdev_get_id(dev) - LP3972_LDO1;
-	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
-	const int *vol_map = LP3972_LDO_VOL_VALUE_MAP(ldo);
-	u16 val;
 	int shift, ret;
 
-	if (min_vol < vol_map[LP3972_LDO_VOL_MIN_IDX(ldo)] ||
-	    min_vol > vol_map[LP3972_LDO_VOL_MAX_IDX(ldo)])
-		return -EINVAL;
-
-	for (val = LP3972_LDO_VOL_MIN_IDX(ldo);
-		val <= LP3972_LDO_VOL_MAX_IDX(ldo); val++)
-		if (vol_map[val] >= min_vol)
-			break;
-
-	if (val > LP3972_LDO_VOL_MAX_IDX(ldo) || vol_map[val] > max_vol)
-		return -EINVAL;
-
-	*selector = val;
-
 	shift = LP3972_LDO_VOL_CONTR_SHIFT(ldo);
 	ret = lp3972_set_bits(lp3972, LP3972_LDO_VOL_CONTR_REG(ldo),
-		LP3972_LDO_VOL_MASK(ldo) << shift, val << shift);
+		LP3972_LDO_VOL_MASK(ldo) << shift, selector << shift);
 
 	if (ret)
 		return ret;
@@ -355,12 +342,17 @@ static struct regulator_ops lp3972_ldo_ops = {
 	.enable = lp3972_ldo_enable,
 	.disable = lp3972_ldo_disable,
 	.get_voltage = lp3972_ldo_get_voltage,
-	.set_voltage = lp3972_ldo_set_voltage,
+	.set_voltage_sel = lp3972_ldo_set_voltage_sel,
 };
 
 static int lp3972_dcdc_list_voltage(struct regulator_dev *dev, unsigned index)
 {
 	int buck = rdev_get_id(dev) - LP3972_DCDC1;
+
+	if (index < LP3972_BUCK_VOL_MIN_IDX(buck) ||
+	    index > LP3972_BUCK_VOL_MAX_IDX(buck))
+		return -EINVAL;
+
 	return 1000 * buck_voltage_map[buck][index];
 }
 
@@ -419,34 +411,15 @@ static int lp3972_dcdc_get_voltage(struct regulator_dev *dev)
 	return val;
 }
 
-static int lp3972_dcdc_set_voltage(struct regulator_dev *dev,
-				   int min_uV, int max_uV,
-				   unsigned int *selector)
+static int lp3972_dcdc_set_voltage_sel(struct regulator_dev *dev,
+				       unsigned int selector)
 {
 	struct lp3972 *lp3972 = rdev_get_drvdata(dev);
 	int buck = rdev_get_id(dev) - LP3972_DCDC1;
-	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
-	const int *vol_map = buck_voltage_map[buck];
-	u16 val;
 	int ret;
 
-	if (min_vol < vol_map[LP3972_BUCK_VOL_MIN_IDX(buck)] ||
-	    min_vol > vol_map[LP3972_BUCK_VOL_MAX_IDX(buck)])
-		return -EINVAL;
-
-	for (val = LP3972_BUCK_VOL_MIN_IDX(buck);
-		val <= LP3972_BUCK_VOL_MAX_IDX(buck); val++)
-		if (vol_map[val] >= min_vol)
-			break;
-
-	if (val > LP3972_BUCK_VOL_MAX_IDX(buck) ||
-	    vol_map[val] > max_vol)
-		return -EINVAL;
-
-	*selector = val;
-
 	ret = lp3972_set_bits(lp3972, LP3972_BUCK_VOL1_REG(buck),
-				LP3972_BUCK_VOL_MASK, val);
+				LP3972_BUCK_VOL_MASK, selector);
 	if (ret)
 		return ret;
 
@@ -468,7 +441,7 @@ static struct regulator_ops lp3972_dcdc_ops = {
 	.enable = lp3972_dcdc_enable,
 	.disable = lp3972_dcdc_disable,
 	.get_voltage = lp3972_dcdc_get_voltage,
-	.set_voltage = lp3972_dcdc_set_voltage,
+	.set_voltage_sel = lp3972_dcdc_set_voltage_sel,
 };
 
 static struct regulator_desc regulators[] = {
-- 
1.7.5.4



