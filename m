Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab2EOHSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:18:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49218 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2EOHSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:18:07 -0400
Message-ID: <1337066278.7340.1.camel@phoenix>
Subject: [PATCH RFT] regulator: tps65217: Convert to set_voltage_sel and
 map_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: AnilKumar Ch <anilkumar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 15 May 2012 15:17:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert tps65217_pmic_ops to use set_voltage_sel and map_voltage.
After this convertion, we can also use tps65217_pmic_set_voltage_sel()
for set_voltage_sel callback of tps65217_pmic_ldo1_ops.
Thus this patch also removes tps65217_pmic_ldo1_set_voltage_sel() function.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65217-regulator.c |   68 ++++++++++++++------------------
 1 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 00c5c1c..9d371d2 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -213,65 +213,56 @@ static int tps65217_pmic_get_voltage_sel(struct regulator_dev *dev)
 	return selector;
 }
 
-static int tps65217_pmic_ldo1_set_voltage_sel(struct regulator_dev *dev,
-						unsigned selector)
+static int tps65217_pmic_set_voltage_sel(struct regulator_dev *dev,
+					 unsigned selector)
 {
+	int ret;
 	struct tps65217 *tps = rdev_get_drvdata(dev);
-	int ldo = rdev_get_id(dev);
+	unsigned int rid = rdev_get_id(dev);
 
-	if (ldo != TPS65217_LDO_1)
-		return -EINVAL;
+	/* Set the voltage based on vsel value and write protect level is 2 */
+	ret = tps65217_set_bits(tps, tps->info[rid]->set_vout_reg,
+				tps->info[rid]->set_vout_mask,
+				selector, TPS65217_PROTECT_L2);
 
-	if (selector >= tps->info[ldo]->table_len)
-		return -EINVAL;
+	/* Set GO bit for DCDCx to initiate voltage transistion */
+	switch (rid) {
+	case TPS65217_DCDC_1 ... TPS65217_DCDC_3:
+		ret = tps65217_set_bits(tps, TPS65217_REG_DEFSLEW,
+				       TPS65217_DEFSLEW_GO, TPS65217_DEFSLEW_GO,
+				       TPS65217_PROTECT_L2);
+		break;
+	}
 
-	/* Set the voltage based on vsel value and write protect level is 2 */
-	return tps65217_set_bits(tps, tps->info[ldo]->set_vout_reg,
-					tps->info[ldo]->set_vout_mask,
-					selector, TPS65217_PROTECT_L2);
+	return ret;
 }
 
-static int tps65217_pmic_set_voltage(struct regulator_dev *dev,
-				  int min_uV, int max_uV, unsigned *selector)
+static int tps65217_pmic_map_voltage(struct regulator_dev *dev,
+				     int min_uV, int max_uV)
 {
-	int ret;
+
 	struct tps65217 *tps = rdev_get_drvdata(dev);
-	unsigned int rid = rdev_get_id(dev);
+	unsigned int sel, rid = rdev_get_id(dev);
+	int ret;
 
-	/* LDO1 implements set_voltage_sel callback */
+	/* LDO1 uses regulator_map_voltage_iterate() */
 	if (rid == TPS65217_LDO_1)
 		return -EINVAL;
 
 	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
 		return -EINVAL;
 
-	if (min_uV < tps->info[rid]->min_uV
-		|| min_uV > tps->info[rid]->max_uV)
+	if (min_uV < tps->info[rid]->min_uV || min_uV > tps->info[rid]->max_uV)
 		return -EINVAL;
 
-	if (max_uV < tps->info[rid]->min_uV
-		|| max_uV > tps->info[rid]->max_uV)
+	if (max_uV < tps->info[rid]->min_uV || max_uV > tps->info[rid]->max_uV)
 		return -EINVAL;
 
-	ret = tps->info[rid]->uv_to_vsel(min_uV, selector);
+	ret = tps->info[rid]->uv_to_vsel(min_uV, &sel);
 	if (ret)
 		return ret;
 
-	/* Set the voltage based on vsel value and write protect level is 2 */
-	ret = tps65217_set_bits(tps, tps->info[rid]->set_vout_reg,
-				tps->info[rid]->set_vout_mask,
-				*selector, TPS65217_PROTECT_L2);
-
-	/* Set GO bit for DCDCx to initiate voltage transistion */
-	switch (rid) {
-	case TPS65217_DCDC_1 ... TPS65217_DCDC_3:
-		ret = tps65217_set_bits(tps, TPS65217_REG_DEFSLEW,
-				       TPS65217_DEFSLEW_GO, TPS65217_DEFSLEW_GO,
-				       TPS65217_PROTECT_L2);
-		break;
-	}
-
-	return ret;
+	return sel;
 }
 
 static int tps65217_pmic_list_voltage(struct regulator_dev *dev,
@@ -298,8 +289,9 @@ static struct regulator_ops tps65217_pmic_ops = {
 	.enable			= tps65217_pmic_enable,
 	.disable		= tps65217_pmic_disable,
 	.get_voltage_sel	= tps65217_pmic_get_voltage_sel,
-	.set_voltage		= tps65217_pmic_set_voltage,
+	.set_voltage_sel	= tps65217_pmic_set_voltage_sel,
 	.list_voltage		= tps65217_pmic_list_voltage,
+	.map_voltage		= tps65217_pmic_map_voltage,
 };
 
 /* Operations permitted on LDO1 */
@@ -308,7 +300,7 @@ static struct regulator_ops tps65217_pmic_ldo1_ops = {
 	.enable			= tps65217_pmic_enable,
 	.disable		= tps65217_pmic_disable,
 	.get_voltage_sel	= tps65217_pmic_get_voltage_sel,
-	.set_voltage_sel	= tps65217_pmic_ldo1_set_voltage_sel,
+	.set_voltage_sel	= tps65217_pmic_set_voltage_sel,
 	.list_voltage		= tps65217_pmic_list_voltage,
 };
 
-- 
1.7.5.4



