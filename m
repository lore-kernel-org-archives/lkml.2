Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab2ETCex (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:34:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34021 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2ETCew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:34:52 -0400
Message-ID: <1337481285.7204.5.camel@phoenix>
Subject: [PATCH RFC/RFT 4/7] regulator: lp3971: Use
 regulator_list_voltage_table()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Date: Sun, 20 May 2012 10:34:45 +0800
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
 drivers/regulator/lp3971.c |   64 +++++++++++++++----------------------------
 1 files changed, 22 insertions(+), 42 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 981bea9..87d0a5b 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -65,11 +65,11 @@ static const int buck_base_addr[] = {
 #define LP3971_BUCK_TARGET_VOL1_REG(x) (buck_base_addr[x])
 #define LP3971_BUCK_TARGET_VOL2_REG(x) (buck_base_addr[x]+1)
 
-static const int buck_voltage_map[] = {
-	   0,  800,  850,  900,  950, 1000, 1050, 1100,
-	1150, 1200, 1250, 1300, 1350, 1400, 1450, 1500,
-	1550, 1600, 1650, 1700, 1800, 1900, 2500, 2800,
-	3000, 3300,
+static const unsigned int buck_voltage_map[] = {
+	      0,  800000,  850000,  900000,  950000, 1000000, 1050000, 1100000,
+	1150000, 1200000, 1250000, 1300000, 1350000, 1400000, 1450000, 1500000,
+	1550000, 1600000, 1650000, 1700000, 1800000, 1900000, 2500000, 2800000,
+	3000000, 3300000,
 };
 
 #define BUCK_TARGET_VOL_MASK 0x3f
@@ -98,39 +98,19 @@ static const int buck_voltage_map[] = {
 #define LDO_VOL_CONTR_SHIFT(x) ((x & 1) << 2)
 #define LDO_VOL_CONTR_MASK 0x0f
 
-static const int ldo45_voltage_map[] = {
-	1000, 1050, 1100, 1150, 1200, 1250, 1300, 1350,
-	1400, 1500, 1800, 1900, 2500, 2800, 3000, 3300,
+static const unsigned int ldo45_voltage_map[] = {
+	1000000, 1050000, 1100000, 1150000, 1200000, 1250000, 1300000, 1350000,
+	1400000, 1500000, 1800000, 1900000, 2500000, 2800000, 3000000, 3300000,
 };
 
-static const int ldo123_voltage_map[] = {
-	1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500,
-	2600, 2700, 2800, 2900, 3000, 3100, 3200, 3300,
+static const unsigned int ldo123_voltage_map[] = {
+	1800000, 1900000, 2000000, 2100000, 2200000, 2300000, 2400000, 2500000,
+	2600000, 2700000, 2800000, 2900000, 3000000, 3100000, 3200000, 3300000,
 };
 
-static const int *ldo_voltage_map[] = {
-	ldo123_voltage_map, /* LDO1 */
-	ldo123_voltage_map, /* LDO2 */
-	ldo123_voltage_map, /* LDO3 */
-	ldo45_voltage_map, /* LDO4 */
-	ldo45_voltage_map, /* LDO5 */
-};
-
-#define LDO_VOL_VALUE_MAP(x) (ldo_voltage_map[(x - LP3971_LDO1)])
-
 #define LDO_VOL_MIN_IDX 0x00
 #define LDO_VOL_MAX_IDX 0x0f
 
-static int lp3971_ldo_list_voltage(struct regulator_dev *dev, unsigned index)
-{
-	int ldo = rdev_get_id(dev) - LP3971_LDO1;
-
-	if (index > LDO_VOL_MAX_IDX)
-		return -EINVAL;
-
-	return 1000 * LDO_VOL_VALUE_MAP(ldo)[index];
-}
-
 static int lp3971_ldo_is_enabled(struct regulator_dev *dev)
 {
 	struct lp3971 *lp3971 = rdev_get_drvdata(dev);
@@ -169,7 +149,7 @@ static int lp3971_ldo_get_voltage(struct regulator_dev *dev)
 	reg = lp3971_reg_read(lp3971, LP3971_LDO_VOL_CONTR_REG(ldo));
 	val = (reg >> LDO_VOL_CONTR_SHIFT(ldo)) & LDO_VOL_CONTR_MASK;
 
-	return 1000 * LDO_VOL_VALUE_MAP(ldo)[val];
+	return dev->desc->volt_table[val];
 }
 
 static int lp3971_ldo_set_voltage_sel(struct regulator_dev *dev,
@@ -184,7 +164,7 @@ static int lp3971_ldo_set_voltage_sel(struct regulator_dev *dev,
 }
 
 static struct regulator_ops lp3971_ldo_ops = {
-	.list_voltage = lp3971_ldo_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 	.is_enabled = lp3971_ldo_is_enabled,
 	.enable = lp3971_ldo_enable,
 	.disable = lp3971_ldo_disable,
@@ -192,14 +172,6 @@ static struct regulator_ops lp3971_ldo_ops = {
 	.set_voltage_sel = lp3971_ldo_set_voltage_sel,
 };
 
-static int lp3971_dcdc_list_voltage(struct regulator_dev *dev, unsigned index)
-{
-	if (index < BUCK_TARGET_VOL_MIN_IDX || index > BUCK_TARGET_VOL_MAX_IDX)
-		return -EINVAL;
-
-	return 1000 * buck_voltage_map[index];
-}
-
 static int lp3971_dcdc_is_enabled(struct regulator_dev *dev)
 {
 	struct lp3971 *lp3971 = rdev_get_drvdata(dev);
@@ -273,7 +245,7 @@ static int lp3971_dcdc_set_voltage_sel(struct regulator_dev *dev,
 }
 
 static struct regulator_ops lp3971_dcdc_ops = {
-	.list_voltage = lp3971_dcdc_list_voltage,
+	.list_voltage = regulator_list_voltage_table,
 	.is_enabled = lp3971_dcdc_is_enabled,
 	.enable = lp3971_dcdc_enable,
 	.disable = lp3971_dcdc_disable,
@@ -287,6 +259,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3971_LDO1,
 		.ops = &lp3971_ldo_ops,
 		.n_voltages = ARRAY_SIZE(ldo123_voltage_map),
+		.volt_table = ldo123_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -295,6 +268,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3971_LDO2,
 		.ops = &lp3971_ldo_ops,
 		.n_voltages = ARRAY_SIZE(ldo123_voltage_map),
+		.volt_table = ldo123_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -303,6 +277,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3971_LDO3,
 		.ops = &lp3971_ldo_ops,
 		.n_voltages = ARRAY_SIZE(ldo123_voltage_map),
+		.volt_table = ldo123_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -311,6 +286,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3971_LDO4,
 		.ops = &lp3971_ldo_ops,
 		.n_voltages = ARRAY_SIZE(ldo45_voltage_map),
+		.volt_table = ldo45_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -319,6 +295,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3971_LDO5,
 		.ops = &lp3971_ldo_ops,
 		.n_voltages = ARRAY_SIZE(ldo45_voltage_map),
+		.volt_table = ldo45_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -327,6 +304,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3971_DCDC1,
 		.ops = &lp3971_dcdc_ops,
 		.n_voltages = ARRAY_SIZE(buck_voltage_map),
+		.volt_table = buck_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -335,6 +313,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3971_DCDC2,
 		.ops = &lp3971_dcdc_ops,
 		.n_voltages = ARRAY_SIZE(buck_voltage_map),
+		.volt_table = buck_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
@@ -343,6 +322,7 @@ static const struct regulator_desc regulators[] = {
 		.id = LP3971_DCDC3,
 		.ops = &lp3971_dcdc_ops,
 		.n_voltages = ARRAY_SIZE(buck_voltage_map),
+		.volt_table = buck_voltage_map,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
 	},
-- 
1.7.5.4



