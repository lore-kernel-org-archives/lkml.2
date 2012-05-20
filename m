Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab2ETCdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:33:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50496 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab2ETCdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:33:41 -0400
Message-ID: <1337481215.7204.4.camel@phoenix>
Subject: [PATCH RFC/RFT 3/7] regulator: ab8500: Use
 regulator_list_voltage_table()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Sun, 20 May 2012 10:33:35 +0800
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
 drivers/regulator/ab8500.c |   64 ++++++++++++++++---------------------------
 1 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index e1b8c54..da883e6 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -40,8 +40,6 @@
  * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
- * @voltages: supported voltage table
- * @voltages_len: number of supported voltages for the regulator
  * @delay: startup/set voltage delay in us
  */
 struct ab8500_regulator_info {
@@ -58,13 +56,11 @@ struct ab8500_regulator_info {
 	u8 voltage_bank;
 	u8 voltage_reg;
 	u8 voltage_mask;
-	int const *voltages;
-	int voltages_len;
 	unsigned int delay;
 };
 
 /* voltage tables for the vauxn/vintcore supplies */
-static const int ldo_vauxn_voltages[] = {
+static const unsigned int ldo_vauxn_voltages[] = {
 	1100000,
 	1200000,
 	1300000,
@@ -83,7 +79,7 @@ static const int ldo_vauxn_voltages[] = {
 	3300000,
 };
 
-static const int ldo_vaux3_voltages[] = {
+static const unsigned int ldo_vaux3_voltages[] = {
 	1200000,
 	1500000,
 	1800000,
@@ -94,7 +90,7 @@ static const int ldo_vaux3_voltages[] = {
 	2910000,
 };
 
-static const int ldo_vintcore_voltages[] = {
+static const unsigned int ldo_vintcore_voltages[] = {
 	1200000,
 	1225000,
 	1250000,
@@ -185,25 +181,6 @@ static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
 		return false;
 }
 
-static int ab8500_list_voltage(struct regulator_dev *rdev, unsigned selector)
-{
-	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
-
-	if (info == NULL) {
-		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
-		return -EINVAL;
-	}
-
-	/* return the uV for the fixed regulators */
-	if (info->fixed_uV)
-		return info->fixed_uV;
-
-	if (selector >= info->voltages_len)
-		return -EINVAL;
-
-	return info->voltages[selector];
-}
-
 static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
 {
 	int ret, val;
@@ -296,11 +273,24 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.is_enabled	= ab8500_regulator_is_enabled,
 	.get_voltage_sel = ab8500_regulator_get_voltage_sel,
 	.set_voltage_sel = ab8500_regulator_set_voltage_sel,
-	.list_voltage	= ab8500_list_voltage,
+	.list_voltage	= regulator_list_voltage_table,
 	.enable_time	= ab8500_regulator_enable_time,
 	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
 };
 
+static int ab8500_fixed_list_voltage(struct regulator_dev *rdev,
+				     unsigned selector)
+{
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	return info->fixed_uV;
+}
+
 static int ab8500_fixed_get_voltage(struct regulator_dev *rdev)
 {
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
@@ -318,7 +308,7 @@ static struct regulator_ops ab8500_regulator_fixed_ops = {
 	.disable	= ab8500_regulator_disable,
 	.is_enabled	= ab8500_regulator_is_enabled,
 	.get_voltage	= ab8500_fixed_get_voltage,
-	.list_voltage	= ab8500_list_voltage,
+	.list_voltage	= ab8500_fixed_list_voltage,
 	.enable_time	= ab8500_regulator_enable_time,
 	.set_voltage_time_sel = ab8500_regulator_set_voltage_time_sel,
 };
@@ -329,7 +319,7 @@ static struct ab8500_regulator_info
 	 * Variable Voltage Regulators
 	 *   name, min mV, max mV,
 	 *   update bank, reg, mask, enable val
-	 *   volt bank, reg, mask, table, table length
+	 *   volt bank, reg, mask
 	 */
 	[AB8500_LDO_AUX1] = {
 		.desc = {
@@ -339,6 +329,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.min_uV			= 1100000,
 		.max_uV			= 3300000,
@@ -349,8 +340,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x1f,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8500_LDO_AUX2] = {
 		.desc = {
@@ -360,6 +349,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+			.volt_table	= ldo_vauxn_voltages,
 		},
 		.min_uV			= 1100000,
 		.max_uV			= 3300000,
@@ -370,8 +360,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x20,
 		.voltage_mask		= 0x0f,
-		.voltages		= ldo_vauxn_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
 	},
 	[AB8500_LDO_AUX3] = {
 		.desc = {
@@ -381,6 +369,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
+			.volt_table	= ldo_vaux3_voltages,
 		},
 		.min_uV			= 1100000,
 		.max_uV			= 3300000,
@@ -391,8 +380,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x21,
 		.voltage_mask		= 0x07,
-		.voltages		= ldo_vaux3_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaux3_voltages),
 	},
 	[AB8500_LDO_INTCORE] = {
 		.desc = {
@@ -402,6 +389,7 @@ static struct ab8500_regulator_info
 			.id		= AB8500_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+			.volt_table	= ldo_vintcore_voltages,
 		},
 		.min_uV			= 1100000,
 		.max_uV			= 3300000,
@@ -412,8 +400,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x80,
 		.voltage_mask		= 0x38,
-		.voltages		= ldo_vintcore_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
 	},
 
 	/*
@@ -769,9 +755,7 @@ static __devinit int ab8500_regulator_register(struct platform_device *pdev,
 		if (info->desc.id == AB8500_LDO_AUX3) {
 			info->desc.n_voltages =
 				ARRAY_SIZE(ldo_vauxn_voltages);
-			info->voltages = ldo_vauxn_voltages;
-			info->voltages_len =
-				ARRAY_SIZE(ldo_vauxn_voltages);
+			info->desc.volt_table = ldo_vauxn_voltages;
 			info->voltage_mask = 0xf;
 		}
 	}
-- 
1.7.5.4



