Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab2F2Bp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 21:45:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47811 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab2F2Bp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 21:45:26 -0400
Message-ID: <1340934316.14052.2.camel@phoenix>
Subject: [PATCH RFT] regulator: tps65217: Convert LDO1 to use
 regulator_list_voltage_table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>, "Girdwood, Liam" <lrg@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 29 Jun 2012 09:45:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert tps65217_pmic_ldo1_ops to use regulator_list_voltage_table.

We have n_voltages and volt_table settings in regulator_desc,
so we don't need the table and table_len fields in struct tps_info.
Thus remove them from struct tps_info.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65217-regulator.c |   47 +++++++++++++++-----------------
 include/linux/mfd/tps65217.h           |    4 ---
 2 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index f5fa05b..3a2b839 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -26,7 +26,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/mfd/tps65217.h>
 
-#define TPS65217_REGULATOR(_name, _id, _ops, _n, _vr, _vm, _em)	\
+#define TPS65217_REGULATOR(_name, _id, _ops, _n, _vr, _vm, _em, _t) \
 	{						\
 		.name		= _name,		\
 		.id		= _id,			\
@@ -38,20 +38,19 @@
 		.vsel_mask	= _vm,			\
 		.enable_reg	= TPS65217_REG_ENABLE,	\
 		.enable_mask	= _em,			\
+		.volt_table	= _t,			\
 	}						\
 
-#define TPS65217_INFO(_nm, _min, _max, _f1, _f2, _t, _n)\
+#define TPS65217_INFO(_nm, _min, _max, _f1, _f2)	\
 	{						\
 		.name		= _nm,			\
 		.min_uV		= _min,			\
 		.max_uV		= _max,			\
 		.vsel_to_uv	= _f1,			\
 		.uv_to_vsel	= _f2,			\
-		.table		= _t,			\
-		.table_len	= _n,			\
 	}
 
-static const int LDO1_VSEL_table[] = {
+static const unsigned int LDO1_VSEL_table[] = {
 	1000000, 1100000, 1200000, 1250000,
 	1300000, 1350000, 1400000, 1500000,
 	1600000, 1800000, 2500000, 2750000,
@@ -128,19 +127,18 @@ static int tps65217_uv_to_vsel2(int uV, unsigned int *vsel)
 
 static struct tps_info tps65217_pmic_regs[] = {
 	TPS65217_INFO("DCDC1", 900000, 1800000, tps65217_vsel_to_uv1,
-			tps65217_uv_to_vsel1, NULL, 64),
+			tps65217_uv_to_vsel1),
 	TPS65217_INFO("DCDC2", 900000, 3300000, tps65217_vsel_to_uv1,
-			tps65217_uv_to_vsel1, NULL, 64),
+			tps65217_uv_to_vsel1),
 	TPS65217_INFO("DCDC3", 900000, 1500000, tps65217_vsel_to_uv1,
-			tps65217_uv_to_vsel1, NULL, 64),
-	TPS65217_INFO("LDO1", 1000000, 3300000, NULL, NULL, LDO1_VSEL_table,
-			16),
+			tps65217_uv_to_vsel1),
+	TPS65217_INFO("LDO1", 1000000, 3300000, NULL, NULL),
 	TPS65217_INFO("LDO2", 900000, 3300000, tps65217_vsel_to_uv1,
-			tps65217_uv_to_vsel1, NULL, 64),
+			tps65217_uv_to_vsel1),
 	TPS65217_INFO("LDO3", 1800000, 3300000, tps65217_vsel_to_uv2,
-			tps65217_uv_to_vsel2, NULL, 32),
+			tps65217_uv_to_vsel2),
 	TPS65217_INFO("LDO4", 1800000, 3300000, tps65217_vsel_to_uv2,
-			tps65217_uv_to_vsel2, NULL, 32),
+			tps65217_uv_to_vsel2),
 };
 
 static int tps65217_pmic_enable(struct regulator_dev *dev)
@@ -230,12 +228,9 @@ static int tps65217_pmic_list_voltage(struct regulator_dev *dev,
 	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
 		return -EINVAL;
 
-	if (selector >= tps->info[rid]->table_len)
+	if (selector >= dev->desc->n_voltages)
 		return -EINVAL;
 
-	if (tps->info[rid]->table)
-		return tps->info[rid]->table[selector];
-
 	return tps->info[rid]->vsel_to_uv(selector);
 }
 
@@ -257,31 +252,33 @@ static struct regulator_ops tps65217_pmic_ldo1_ops = {
 	.disable		= tps65217_pmic_disable,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= tps65217_pmic_set_voltage_sel,
-	.list_voltage		= tps65217_pmic_list_voltage,
+	.list_voltage		= regulator_list_voltage_table,
 };
 
 static const struct regulator_desc regulators[] = {
 	TPS65217_REGULATOR("DCDC1", TPS65217_DCDC_1, tps65217_pmic_ops, 64,
 			   TPS65217_REG_DEFDCDC1, TPS65217_DEFDCDCX_DCDC_MASK,
-			   TPS65217_ENABLE_DC1_EN),
+			   TPS65217_ENABLE_DC1_EN, NULL),
 	TPS65217_REGULATOR("DCDC2", TPS65217_DCDC_2, tps65217_pmic_ops, 64,
 			   TPS65217_REG_DEFDCDC2, TPS65217_DEFDCDCX_DCDC_MASK,
-			   TPS65217_ENABLE_DC2_EN),
+			   TPS65217_ENABLE_DC2_EN, NULL),
 	TPS65217_REGULATOR("DCDC3", TPS65217_DCDC_3, tps65217_pmic_ops, 64,
 			   TPS65217_REG_DEFDCDC3, TPS65217_DEFDCDCX_DCDC_MASK,
-			   TPS65217_ENABLE_DC3_EN),
+			   TPS65217_ENABLE_DC3_EN, NULL),
 	TPS65217_REGULATOR("LDO1", TPS65217_LDO_1, tps65217_pmic_ldo1_ops, 16,
 			   TPS65217_REG_DEFLDO1, TPS65217_DEFLDO1_LDO1_MASK,
-			   TPS65217_ENABLE_LDO1_EN),
+			   TPS65217_ENABLE_LDO1_EN, LDO1_VSEL_table),
 	TPS65217_REGULATOR("LDO2", TPS65217_LDO_2, tps65217_pmic_ops, 64,
 			   TPS65217_REG_DEFLDO2, TPS65217_DEFLDO2_LDO2_MASK,
-			   TPS65217_ENABLE_LDO2_EN),
+			   TPS65217_ENABLE_LDO2_EN, NULL),
 	TPS65217_REGULATOR("LDO3", TPS65217_LDO_3, tps65217_pmic_ops, 32,
 			   TPS65217_REG_DEFLS1, TPS65217_DEFLDO3_LDO3_MASK,
-			   TPS65217_ENABLE_LS1_EN | TPS65217_DEFLDO3_LDO3_EN),
+			   TPS65217_ENABLE_LS1_EN | TPS65217_DEFLDO3_LDO3_EN,
+			   NULL),
 	TPS65217_REGULATOR("LDO4", TPS65217_LDO_4, tps65217_pmic_ops, 32,
 			   TPS65217_REG_DEFLS2, TPS65217_DEFLDO4_LDO4_MASK,
-			   TPS65217_ENABLE_LS2_EN | TPS65217_DEFLDO4_LDO4_EN),
+			   TPS65217_ENABLE_LS2_EN | TPS65217_DEFLDO4_LDO4_EN,
+			   NULL),
 };
 
 static int __devinit tps65217_regulator_probe(struct platform_device *pdev)
diff --git a/include/linux/mfd/tps65217.h b/include/linux/mfd/tps65217.h
index 4e035a4..3a80da1 100644
--- a/include/linux/mfd/tps65217.h
+++ b/include/linux/mfd/tps65217.h
@@ -227,8 +227,6 @@ struct tps65217_board {
  * @max_uV:		minimum micro volts
  * @vsel_to_uv:		Function pointer to get voltage from selector
  * @uv_to_vsel:		Function pointer to get selector from voltage
- * @table:		Table for non-uniform voltage step-size
- * @table_len:		Length of the voltage table
  *
  * This data is used to check the regualtor voltage limits while setting.
  */
@@ -238,8 +236,6 @@ struct tps_info {
 	int max_uV;
 	int (*vsel_to_uv)(unsigned int vsel);
 	int (*uv_to_vsel)(int uV, unsigned int *vsel);
-	const int *table;
-	unsigned int table_len;
 };
 
 /**
-- 
1.7.9.5



