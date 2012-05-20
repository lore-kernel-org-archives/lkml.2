Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab2ETCcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:32:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59822 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab2ETCcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:32:04 -0400
Message-ID: <1337481118.7204.3.camel@phoenix>
Subject: [PATCH RFC/RFT 2/7] regulator: ab3100: Use
 regulator_list_voltage_table()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Sun, 20 May 2012 10:31:58 +0800
In-Reply-To: <1337481021.7204.1.camel@phoenix>
References: <1337481021.7204.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab3100.c |   50 ++++++++++++-------------------------------
 1 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 03f4d9c..b088b6c 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -45,9 +45,6 @@
  * @regreg: regulator register number in the AB3100
  * @fixed_voltage: a fixed voltage for this regulator, if this
  *          0 the voltages array is used instead.
- * @typ_voltages: an array of available typical voltages for
- *          this regulator
- * @voltages_len: length of the array of available voltages
  */
 struct ab3100_regulator {
 	struct regulator_dev *rdev;
@@ -55,8 +52,6 @@ struct ab3100_regulator {
 	struct ab3100_platform_data *plfdata;
 	u8 regreg;
 	int fixed_voltage;
-	int const *typ_voltages;
-	u8 voltages_len;
 };
 
 /* The order in which registers are initialized */
@@ -80,7 +75,7 @@ static const u8 ab3100_reg_init_order[AB3100_NUM_REGULATORS+2] = {
 #define LDO_C_VOLTAGE 2650000
 #define LDO_D_VOLTAGE 2650000
 
-static const int ldo_e_buck_typ_voltages[] = {
+static const unsigned int ldo_e_buck_typ_voltages[] = {
 	1800000,
 	1400000,
 	1300000,
@@ -90,7 +85,7 @@ static const int ldo_e_buck_typ_voltages[] = {
 	900000,
 };
 
-static const int ldo_f_typ_voltages[] = {
+static const unsigned int ldo_f_typ_voltages[] = {
 	1800000,
 	1400000,
 	1300000,
@@ -101,21 +96,21 @@ static const int ldo_f_typ_voltages[] = {
 	2650000,
 };
 
-static const int ldo_g_typ_voltages[] = {
+static const unsigned int ldo_g_typ_voltages[] = {
 	2850000,
 	2750000,
 	1800000,
 	1500000,
 };
 
-static const int ldo_h_typ_voltages[] = {
+static const unsigned int ldo_h_typ_voltages[] = {
 	2750000,
 	1800000,
 	1500000,
 	1200000,
 };
 
-static const int ldo_k_typ_voltages[] = {
+static const unsigned int ldo_k_typ_voltages[] = {
 	2750000,
 	1800000,
 };
@@ -138,28 +133,18 @@ ab3100_regulators[AB3100_NUM_REGULATORS] = {
 	},
 	{
 		.regreg = AB3100_LDO_E,
-		.typ_voltages = ldo_e_buck_typ_voltages,
-		.voltages_len = ARRAY_SIZE(ldo_e_buck_typ_voltages),
 	},
 	{
 		.regreg = AB3100_LDO_F,
-		.typ_voltages = ldo_f_typ_voltages,
-		.voltages_len = ARRAY_SIZE(ldo_f_typ_voltages),
 	},
 	{
 		.regreg = AB3100_LDO_G,
-		.typ_voltages = ldo_g_typ_voltages,
-		.voltages_len = ARRAY_SIZE(ldo_g_typ_voltages),
 	},
 	{
 		.regreg = AB3100_LDO_H,
-		.typ_voltages = ldo_h_typ_voltages,
-		.voltages_len = ARRAY_SIZE(ldo_h_typ_voltages),
 	},
 	{
 		.regreg = AB3100_LDO_K,
-		.typ_voltages = ldo_k_typ_voltages,
-		.voltages_len = ARRAY_SIZE(ldo_k_typ_voltages),
 	},
 	{
 		.regreg = AB3100_LDO_EXT,
@@ -167,8 +152,6 @@ ab3100_regulators[AB3100_NUM_REGULATORS] = {
 	},
 	{
 		.regreg = AB3100_BUCK,
-		.typ_voltages = ldo_e_buck_typ_voltages,
-		.voltages_len = ARRAY_SIZE(ldo_e_buck_typ_voltages),
 	},
 };
 
@@ -257,16 +240,6 @@ static int ab3100_is_enabled_regulator(struct regulator_dev *reg)
 	return regval & AB3100_REG_ON_MASK;
 }
 
-static int ab3100_list_voltage_regulator(struct regulator_dev *reg,
-					 unsigned selector)
-{
-	struct ab3100_regulator *abreg = reg->reg_data;
-
-	if (selector >= abreg->voltages_len)
-		return -EINVAL;
-	return abreg->typ_voltages[selector];
-}
-
 static int ab3100_get_voltage_regulator(struct regulator_dev *reg)
 {
 	struct ab3100_regulator *abreg = reg->reg_data;
@@ -294,14 +267,14 @@ static int ab3100_get_voltage_regulator(struct regulator_dev *reg)
 	regval &= 0xE0;
 	regval >>= 5;
 
-	if (regval >= abreg->voltages_len) {
+	if (regval >= reg->desc->n_voltages) {
 		dev_err(&reg->dev,
 			"regulator register %02x contains an illegal voltage setting\n",
 			abreg->regreg);
 		return -EINVAL;
 	}
 
-	return abreg->typ_voltages[regval];
+	return reg->desc->volt_table[regval];
 }
 
 static int ab3100_set_voltage_regulator_sel(struct regulator_dev *reg,
@@ -423,7 +396,7 @@ static struct regulator_ops regulator_ops_variable = {
 	.is_enabled  = ab3100_is_enabled_regulator,
 	.get_voltage = ab3100_get_voltage_regulator,
 	.set_voltage_sel = ab3100_set_voltage_regulator_sel,
-	.list_voltage = ab3100_list_voltage_regulator,
+	.list_voltage = regulator_list_voltage_table,
 	.enable_time = ab3100_enable_time_regulator,
 };
 
@@ -434,7 +407,7 @@ static struct regulator_ops regulator_ops_variable_sleepable = {
 	.get_voltage = ab3100_get_voltage_regulator,
 	.set_voltage_sel = ab3100_set_voltage_regulator_sel,
 	.set_suspend_voltage = ab3100_set_suspend_voltage_regulator,
-	.list_voltage = ab3100_list_voltage_regulator,
+	.list_voltage = regulator_list_voltage_table,
 	.enable_time = ab3100_enable_time_regulator,
 };
 
@@ -479,6 +452,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.id   = AB3100_LDO_E,
 		.ops  = &regulator_ops_variable_sleepable,
 		.n_voltages = ARRAY_SIZE(ldo_e_buck_typ_voltages),
+		.volt_table = ldo_e_buck_typ_voltages,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -487,6 +461,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.id   = AB3100_LDO_F,
 		.ops  = &regulator_ops_variable,
 		.n_voltages = ARRAY_SIZE(ldo_f_typ_voltages),
+		.volt_table = ldo_f_typ_voltages,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -495,6 +470,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.id   = AB3100_LDO_G,
 		.ops  = &regulator_ops_variable,
 		.n_voltages = ARRAY_SIZE(ldo_g_typ_voltages),
+		.volt_table = ldo_g_typ_voltages,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -503,6 +479,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.id   = AB3100_LDO_H,
 		.ops  = &regulator_ops_variable,
 		.n_voltages = ARRAY_SIZE(ldo_h_typ_voltages),
+		.volt_table = ldo_h_typ_voltages,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -511,6 +488,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.id   = AB3100_LDO_K,
 		.ops  = &regulator_ops_variable,
 		.n_voltages = ARRAY_SIZE(ldo_k_typ_voltages),
+		.volt_table = ldo_k_typ_voltages,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
-- 
1.7.5.4



