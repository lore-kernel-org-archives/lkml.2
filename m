Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab2FTOaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:30:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46509 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab2FTOaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:30:24 -0400
Message-ID: <1340202615.8003.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: tps6524x: Convert to
 regulator_list_voltage_table()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cyril Chemparathy <cyril@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 20 Jun 2012 22:30:15 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds fixed_5000000_voltage table for fixed voltage,
so we can convert regulator_ops to regulator_list_voltage_table.

We can differentiate fixed voltage by checking rdev->desc->n_voltages == 1,
thus remove the FIXED_VOLTAGE flag usage.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6524x-regulator.c |   52 ++++++++++++--------------------
 1 file changed, 19 insertions(+), 33 deletions(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 1b299aa..48e37bd 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -111,7 +111,6 @@
 #define N_REGULATORS		(N_DCDC + N_LDO + N_SWITCH)
 
 #define FIXED_ILIMSEL		BIT(0)
-#define FIXED_VOLTAGE		BIT(1)
 
 #define CMD_READ(reg)		((reg) << 6)
 #define CMD_WRITE(reg)		(BIT(5) | (reg) << 6)
@@ -129,8 +128,7 @@ struct field {
 struct supply_info {
 	const char	*name;
 	int		n_voltages;
-	const int	*voltages;
-	int		fixed_voltage;
+	const unsigned int *voltages;
 	int		n_ilimsels;
 	const int	*ilimsels;
 	int		fixed_ilimsel;
@@ -307,7 +305,7 @@ static int write_field(struct tps6524x *hw, const struct field *field,
 				    val << field->shift);
 }
 
-static const int dcdc1_voltages[] = {
+static const unsigned int dcdc1_voltages[] = {
 	 800000,  825000,  850000,  875000,
 	 900000,  925000,  950000,  975000,
 	1000000, 1025000, 1050000, 1075000,
@@ -318,7 +316,7 @@ static const int dcdc1_voltages[] = {
 	1500000, 1525000, 1550000, 1575000,
 };
 
-static const int dcdc2_voltages[] = {
+static const unsigned int dcdc2_voltages[] = {
 	1400000, 1450000, 1500000, 1550000,
 	1600000, 1650000, 1700000, 1750000,
 	1800000, 1850000, 1900000, 1950000,
@@ -329,7 +327,7 @@ static const int dcdc2_voltages[] = {
 	2800000, 2850000, 2900000, 2950000,
 };
 
-static const int dcdc3_voltages[] = {
+static const unsigned int dcdc3_voltages[] = {
 	2400000, 2450000, 2500000, 2550000, 2600000,
 	2650000, 2700000, 2750000, 2800000, 2850000,
 	2900000, 2950000, 3000000, 3050000, 3100000,
@@ -337,20 +335,24 @@ static const int dcdc3_voltages[] = {
 	3400000, 3450000, 3500000, 3550000, 3600000,
 };
 
-static const int ldo1_voltages[] = {
+static const unsigned int ldo1_voltages[] = {
 	4300000, 4350000, 4400000, 4450000,
 	4500000, 4550000, 4600000, 4650000,
 	4700000, 4750000, 4800000, 4850000,
 	4900000, 4950000, 5000000, 5050000,
 };
 
-static const int ldo2_voltages[] = {
+static const unsigned int ldo2_voltages[] = {
 	1100000, 1150000, 1200000, 1250000,
 	1300000, 1700000, 1750000, 1800000,
 	1850000, 1900000, 3150000, 3200000,
 	3250000, 3300000, 3350000, 3400000,
 };
 
+static const unsigned int fixed_5000000_voltage[] = {
+	5000000
+};
+
 static const int ldo_ilimsel[] = {
 	400000, 1500000
 };
@@ -424,8 +426,8 @@ static const struct supply_info supply_info[N_REGULATORS] = {
 	},
 	{
 		.name		= "USB",
-		.flags		= FIXED_VOLTAGE,
-		.fixed_voltage	= 5000000,
+		.n_voltages	= ARRAY_SIZE(fixed_5000000_voltage),
+		.voltages	= fixed_5000000_voltage,
 		.n_ilimsels	= ARRAY_SIZE(usb_ilimsel),
 		.ilimsels	= usb_ilimsel,
 		.enable		= __MK_FIELD(REG_BLOCK_EN, BLOCK_MASK,
@@ -435,29 +437,15 @@ static const struct supply_info supply_info[N_REGULATORS] = {
 	},
 	{
 		.name		= "LCD",
-		.flags		= FIXED_VOLTAGE | FIXED_ILIMSEL,
-		.fixed_voltage	= 5000000,
+		.n_voltages	= ARRAY_SIZE(fixed_5000000_voltage),
+		.voltages	= fixed_5000000_voltage,
+		.flags		= FIXED_ILIMSEL,
 		.fixed_ilimsel	=  400000,
 		.enable		= __MK_FIELD(REG_BLOCK_EN, BLOCK_MASK,
 					     BLOCK_LCD_SHIFT),
 	},
 };
 
-static int list_voltage(struct regulator_dev *rdev, unsigned selector)
-{
-	const struct supply_info *info;
-	struct tps6524x *hw;
-
-	hw	= rdev_get_drvdata(rdev);
-	info	= &supply_info[rdev_get_id(rdev)];
-
-	if (info->flags & FIXED_VOLTAGE)
-		return selector ? -EINVAL : info->fixed_voltage;
-
-	return ((selector < info->n_voltages) ?
-		info->voltages[selector] : -EINVAL);
-}
-
 static int set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 {
 	const struct supply_info *info;
@@ -466,7 +454,7 @@ static int set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 	hw	= rdev_get_drvdata(rdev);
 	info	= &supply_info[rdev_get_id(rdev)];
 
-	if (info->flags & FIXED_VOLTAGE)
+	if (rdev->desc->n_voltages == 1)
 		return -EINVAL;
 
 	return write_field(hw, &info->voltage, selector);
@@ -481,7 +469,7 @@ static int get_voltage_sel(struct regulator_dev *rdev)
 	hw	= rdev_get_drvdata(rdev);
 	info	= &supply_info[rdev_get_id(rdev)];
 
-	if (info->flags & FIXED_VOLTAGE)
+	if (rdev->desc->n_voltages == 1)
 		return 0;
 
 	ret = read_field(hw, &info->voltage);
@@ -577,7 +565,7 @@ static struct regulator_ops regulator_ops = {
 	.disable		= disable_supply,
 	.get_voltage_sel	= get_voltage_sel,
 	.set_voltage_sel	= set_voltage_sel,
-	.list_voltage		= list_voltage,
+	.list_voltage		= regulator_list_voltage_table,
 	.set_current_limit	= set_current_limit,
 	.get_current_limit	= get_current_limit,
 };
@@ -629,13 +617,11 @@ static int __devinit pmic_probe(struct spi_device *spi)
 		hw->desc[i].name	= info->name;
 		hw->desc[i].id		= i;
 		hw->desc[i].n_voltages	= info->n_voltages;
+		hw->desc[i].volt_table	= info->voltages;
 		hw->desc[i].ops		= &regulator_ops;
 		hw->desc[i].type	= REGULATOR_VOLTAGE;
 		hw->desc[i].owner	= THIS_MODULE;
 
-		if (info->flags & FIXED_VOLTAGE)
-			hw->desc[i].n_voltages = 1;
-
 		config.dev = dev;
 		config.init_data = init_data;
 		config.driver_data = hw;
-- 
1.7.9.5



