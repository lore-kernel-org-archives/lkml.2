Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab2FEOwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:52:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49512 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2FEOwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:52:15 -0400
Message-ID: <1338907926.5581.1.camel@phoenix>
Subject: [PATCH RFT] regulator: tps6586x: Convert to
 regulator_list_voltage_table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>, Danny Huang <dahuang@nvidia.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 05 Jun 2012 22:52:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also adds tps6586x_ldo0_voltages mapping table for LDO0, so we can remove the
hack in tps6586x_list_voltage() and convert it to regulator_list_voltage_table.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6586x-regulator.c |   61 +++++++++++++-------------------
 1 file changed, 25 insertions(+), 36 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index c0a2145..c0ac241 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -63,8 +63,6 @@ struct tps6586x_regulator {
 	int enable_bit[2];
 	int enable_reg[2];
 
-	int *voltages;
-
 	/* for DVM regulators */
 	int go_reg;
 	int go_bit;
@@ -75,19 +73,6 @@ static inline struct device *to_tps6586x_dev(struct regulator_dev *rdev)
 	return rdev_get_dev(rdev)->parent->parent;
 }
 
-static int tps6586x_list_voltage(struct regulator_dev *rdev, unsigned selector)
-{
-	struct tps6586x_regulator *info = rdev_get_drvdata(rdev);
-	int rid = rdev_get_id(rdev);
-
-	/* LDO0 has minimal voltage 1.2V rather than 1.25V */
-	if ((rid == TPS6586X_ID_LDO_0) && (selector == 0))
-		return (info->voltages[0] - 50) * 1000;
-
-	return info->voltages[selector] * 1000;
-}
-
-
 static int tps6586x_set_voltage_sel(struct regulator_dev *rdev,
 				    unsigned selector)
 {
@@ -168,7 +153,7 @@ static int tps6586x_regulator_is_enabled(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops tps6586x_regulator_ops = {
-	.list_voltage = tps6586x_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 	.get_voltage_sel = tps6586x_get_voltage_sel,
 	.set_voltage_sel = tps6586x_set_voltage_sel,
 
@@ -177,29 +162,33 @@ static struct regulator_ops tps6586x_regulator_ops = {
 	.disable = tps6586x_regulator_disable,
 };
 
-static int tps6586x_ldo_voltages[] = {
-	1250, 1500, 1800, 2500, 2700, 2850, 3100, 3300,
+static const unsigned int tps6586x_ldo0_voltages[] = {
+	1200000, 1500000, 1800000, 2500000, 2700000, 2850000, 3100000, 3300000,
+};
+
+static const unsigned int tps6586x_ldo4_voltages[] = {
+	1700000, 1725000, 1750000, 1775000, 1800000, 1825000, 1850000, 1875000,
+	1900000, 1925000, 1950000, 1975000, 2000000, 2025000, 2050000, 2075000,
+	2100000, 2125000, 2150000, 2175000, 2200000, 2225000, 2250000, 2275000,
+	2300000, 2325000, 2350000, 2375000, 2400000, 2425000, 2450000, 2475000,
 };
 
-static int tps6586x_ldo4_voltages[] = {
-	1700, 1725, 1750, 1775, 1800, 1825, 1850, 1875,
-	1900, 1925, 1950, 1975, 2000, 2025, 2050, 2075,
-	2100, 2125, 2150, 2175, 2200, 2225, 2250, 2275,
-	2300, 2325, 2350, 2375, 2400, 2425, 2450, 2475,
+static const unsigned int tps6586x_ldo_voltages[] = {
+	1250000, 1500000, 1800000, 2500000, 2700000, 2850000, 3100000, 3300000,
 };
 
-static int tps6586x_sm2_voltages[] = {
-	3000, 3050, 3100, 3150, 3200, 3250, 3300, 3350,
-	3400, 3450, 3500, 3550, 3600, 3650, 3700, 3750,
-	3800, 3850, 3900, 3950, 4000, 4050, 4100, 4150,
-	4200, 4250, 4300, 4350, 4400, 4450, 4500, 4550,
+static const unsigned int tps6586x_sm2_voltages[] = {
+	3000000, 3050000, 3100000, 3150000, 3200000, 3250000, 3300000, 3350000,
+	3400000, 3450000, 3500000, 3550000, 3600000, 3650000, 3700000, 3750000,
+	3800000, 3850000, 3900000, 3950000, 4000000, 4050000, 4100000, 4150000,
+	4200000, 4250000, 4300000, 4350000, 4400000, 4450000, 4500000, 4550000,
 };
 
-static int tps6586x_dvm_voltages[] = {
-	 725,  750,  775,  800,  825,  850,  875,  900,
-	 925,  950,  975, 1000, 1025, 1050, 1075, 1100,
-	1125, 1150, 1175, 1200, 1225, 1250, 1275, 1300,
-	1325, 1350, 1375, 1400, 1425, 1450, 1475, 1500,
+static const unsigned int tps6586x_dvm_voltages[] = {
+	 725000,  750000,  775000,  800000,  825000,  850000,  875000,  900000,
+	 925000,  950000,  975000, 1000000, 1025000, 1050000, 1075000, 1100000,
+	1125000, 1150000, 1175000, 1200000, 1225000, 1250000, 1275000, 1300000,
+	1325000, 1350000, 1375000, 1400000, 1425000, 1450000, 1475000, 1500000,
 };
 
 #define TPS6586X_REGULATOR(_id, vdata, vreg, shift, nbits,		\
@@ -210,6 +199,7 @@ static int tps6586x_dvm_voltages[] = {
 		.type	= REGULATOR_VOLTAGE,				\
 		.id	= TPS6586X_ID_##_id,				\
 		.n_voltages = ARRAY_SIZE(tps6586x_##vdata##_voltages),	\
+		.volt_table = tps6586x_##vdata##_voltages,		\
 		.owner	= THIS_MODULE,					\
 	},								\
 	.volt_reg	= TPS6586X_##vreg,				\
@@ -218,8 +208,7 @@ static int tps6586x_dvm_voltages[] = {
 	.enable_reg[0]	= TPS6586X_SUPPLY##ereg0,			\
 	.enable_bit[0]	= (ebit0),					\
 	.enable_reg[1]	= TPS6586X_SUPPLY##ereg1,			\
-	.enable_bit[1]	= (ebit1),					\
-	.voltages	= tps6586x_##vdata##_voltages,
+	.enable_bit[1]	= (ebit1),
 
 #define TPS6586X_REGULATOR_DVM_GOREG(goreg, gobit)			\
 	.go_reg = TPS6586X_##goreg,					\
@@ -241,7 +230,7 @@ static int tps6586x_dvm_voltages[] = {
 }
 
 static struct tps6586x_regulator tps6586x_regulator[] = {
-	TPS6586X_LDO(LDO_0, ldo, SUPPLYV1, 5, 3, ENC, 0, END, 0),
+	TPS6586X_LDO(LDO_0, ldo0, SUPPLYV1, 5, 3, ENC, 0, END, 0),
 	TPS6586X_LDO(LDO_3, ldo, SUPPLYV4, 0, 3, ENC, 2, END, 2),
 	TPS6586X_LDO(LDO_5, ldo, SUPPLYV6, 0, 3, ENE, 6, ENE, 6),
 	TPS6586X_LDO(LDO_6, ldo, SUPPLYV3, 0, 3, ENC, 4, END, 4),
-- 
1.7.9.5



