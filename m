Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab2CXBme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 21:42:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55704 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab2CXBmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 21:42:32 -0400
Message-ID: <1332553346.14114.5.camel@phoenix>
Subject: [PATCH 3/4] regulator: Convert tps6586x to set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Danny Huang <dahuang@nvidia.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 24 Mar 2012 09:42:26 +0800
In-Reply-To: <1332553050.14114.1.camel@phoenix>
References: <1332553050.14114.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert both tps6586x_[ldo|dvm]_set_voltage to one set_voltage_sel callback.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6586x-regulator.c |   70 +++++++++----------------------
 1 files changed, 21 insertions(+), 49 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index af3559b..51ca882 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -89,44 +89,31 @@ static int tps6586x_ldo_list_voltage(struct regulator_dev *rdev,
 }
 
 
-static int __tps6586x_ldo_set_voltage(struct device *parent,
-				      struct tps6586x_regulator *ri,
-				      int min_uV, int max_uV,
-				      unsigned *selector)
+static int tps6586x_set_voltage_sel(struct regulator_dev *rdev,
+				    unsigned selector)
 {
-	int val, uV;
+	struct tps6586x_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps6586x_dev(rdev);
+	int ret, val, rid = rdev_get_id(rdev);
 	uint8_t mask;
 
-	for (val = 0; val < ri->desc.n_voltages; val++) {
-		uV = ri->voltages[val] * 1000;
-
-		/* LDO0 has minimal voltage 1.2 rather than 1.25 */
-		if (ri->desc.id == TPS6586X_ID_LDO_0 && val == 0)
-			uV -= 50 * 1000;
-
-		/* use the first in-range value */
-		if (min_uV <= uV && uV <= max_uV) {
-
-			*selector = val;
+	val = selector << ri->volt_shift;
+	mask = ((1 << ri->volt_nbits) - 1) << ri->volt_shift;
 
-			val <<= ri->volt_shift;
-			mask = ((1 << ri->volt_nbits) - 1) << ri->volt_shift;
+	ret = tps6586x_update(parent, ri->volt_reg, val, mask);
+	if (ret)
+		return ret;
 
-			return tps6586x_update(parent, ri->volt_reg, val, mask);
-		}
+	/* Update go bit for DVM regulators */
+	switch (rid) {
+	case TPS6586X_ID_LDO_2:
+	case TPS6586X_ID_LDO_4:
+	case TPS6586X_ID_SM_0:
+	case TPS6586X_ID_SM_1:
+		ret = tps6586x_set_bits(parent, ri->go_reg, 1 << ri->go_bit);
+		break;
 	}
-
-	return -EINVAL;
-}
-
-static int tps6586x_ldo_set_voltage(struct regulator_dev *rdev,
-				    int min_uV, int max_uV, unsigned *selector)
-{
-	struct tps6586x_regulator *ri = rdev_get_drvdata(rdev);
-	struct device *parent = to_tps6586x_dev(rdev);
-
-	return __tps6586x_ldo_set_voltage(parent, ri, min_uV, max_uV,
-					  selector);
+	return ret;
 }
 
 static int tps6586x_get_voltage_sel(struct regulator_dev *rdev)
@@ -149,21 +136,6 @@ static int tps6586x_get_voltage_sel(struct regulator_dev *rdev)
 	return val;
 }
 
-static int tps6586x_dvm_set_voltage(struct regulator_dev *rdev,
-				    int min_uV, int max_uV, unsigned *selector)
-{
-	struct tps6586x_regulator *ri = rdev_get_drvdata(rdev);
-	struct device *parent = to_tps6586x_dev(rdev);
-	int ret;
-
-	ret = __tps6586x_ldo_set_voltage(parent, ri, min_uV, max_uV,
-					 selector);
-	if (ret)
-		return ret;
-
-	return tps6586x_set_bits(parent, ri->go_reg, 1 << ri->go_bit);
-}
-
 static int tps6586x_regulator_enable(struct regulator_dev *rdev)
 {
 	struct tps6586x_regulator *ri = rdev_get_drvdata(rdev);
@@ -199,7 +171,7 @@ static int tps6586x_regulator_is_enabled(struct regulator_dev *rdev)
 static struct regulator_ops tps6586x_regulator_ldo_ops = {
 	.list_voltage = tps6586x_ldo_list_voltage,
 	.get_voltage_sel = tps6586x_get_voltage_sel,
-	.set_voltage = tps6586x_ldo_set_voltage,
+	.set_voltage_sel = tps6586x_set_voltage_sel,
 
 	.is_enabled = tps6586x_regulator_is_enabled,
 	.enable = tps6586x_regulator_enable,
@@ -209,7 +181,7 @@ static struct regulator_ops tps6586x_regulator_ldo_ops = {
 static struct regulator_ops tps6586x_regulator_dvm_ops = {
 	.list_voltage = tps6586x_ldo_list_voltage,
 	.get_voltage_sel = tps6586x_get_voltage_sel,
-	.set_voltage = tps6586x_dvm_set_voltage,
+	.set_voltage_sel = tps6586x_set_voltage_sel,
 
 	.is_enabled = tps6586x_regulator_is_enabled,
 	.enable = tps6586x_regulator_enable,
-- 
1.7.5.4



