Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab1G0KdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:33:11 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50208 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab1G0KdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:33:09 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH 2/3] regulator: tps65023: Setting correct core regulator for tps65021
Date: Wed, 27 Jul 2011 12:32:46 +0200
Message-Id: <1311762767-20263-3-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
 <1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS65023 is using VDCDC1 as core regulator and TPS65021 is using VDCDC3.
Core-regulator, voltage-tables and size of voltage-table may differ between
different regulators. All those three is now passed as driver data.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |  113 ++++++++++++++++++++++++++------
 1 files changed, 93 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index d43533b..5cc7344 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -92,7 +92,7 @@
 #define TPS65023_MAX_REG_ID		TPS65023_LDO_2
 
 /* Supported voltage values for regulators */
-static const u16 VDCDC1_VSEL_table[] = {
+static const u16 VCORE_VSEL_table[] = {
 	800, 825, 850, 875,
 	900, 925, 950, 975,
 	1000, 1025, 1050, 1075,
@@ -103,19 +103,35 @@ static const u16 VDCDC1_VSEL_table[] = {
 	1500, 1525, 1550, 1600,
 };
 
-static const u16 LDO1_VSEL_table[] = {
+
+
+/* Supported voltage values for LDO regulators
+ * for tps65021 and tps65023 */
+static const u16 TPS65023_LDO1_VSEL_table[] = {
 	1000, 1100, 1300, 1800,
 	2200, 2600, 2800, 3150,
 };
 
-static const u16 LDO2_VSEL_table[] = {
+static const u16 TPS65023_LDO2_VSEL_table[] = {
 	1050, 1200, 1300, 1800,
 	2500, 2800, 3000, 3300,
 };
 
-static unsigned int num_voltages[] = {ARRAY_SIZE(VDCDC1_VSEL_table),
-				0, 0, ARRAY_SIZE(LDO1_VSEL_table),
-				ARRAY_SIZE(LDO2_VSEL_table)};
+static unsigned int tps65021_num_voltages[] = {
+				0,
+				0,
+				ARRAY_SIZE(VCORE_VSEL_table),
+				ARRAY_SIZE(TPS65023_LDO1_VSEL_table),
+				ARRAY_SIZE(TPS65023_LDO2_VSEL_table),
+};
+
+static unsigned int tps65023_num_voltages[] = {
+				ARRAY_SIZE(VCORE_VSEL_table),
+				0,
+				0,
+				ARRAY_SIZE(TPS65023_LDO1_VSEL_table),
+				ARRAY_SIZE(TPS65023_LDO2_VSEL_table),
+};
 
 /* Regulator specific details */
 struct tps_info {
@@ -134,6 +150,14 @@ struct tps_pmic {
 	struct regulator_dev *rdev[TPS65023_NUM_REGULATOR];
 	const struct tps_info *info[TPS65023_NUM_REGULATOR];
 	struct regmap *regmap;
+	u8 core_regulator;
+};
+
+/* Struct passed as driver data */
+struct tps_driver_data {
+	struct tps_info *info;
+	u8 core_regulator;
+	unsigned int *num_voltages;
 };
 
 static int tps_65023_set_bits(struct tps_pmic *tps, u8 reg, u8 mask)
@@ -260,7 +284,7 @@ static int tps65023_dcdc_get_voltage(struct regulator_dev *dev)
 	if (dcdc < TPS65023_DCDC_1 || dcdc > TPS65023_DCDC_3)
 		return -EINVAL;
 
-	if (dcdc == TPS65023_DCDC_1) {
+	if (dcdc == tps->core_regulator) {
 		data = tps_65023_reg_read(tps, TPS65023_REG_DEF_CORE);
 		if (data < 0)
 			return data;
@@ -279,9 +303,8 @@ static int tps65023_dcdc_set_voltage(struct regulator_dev *dev,
 	int vsel;
 	int ret;
 
-	if (dcdc != TPS65023_DCDC_1)
+	if (dcdc != tps->core_regulator)
 		return -EINVAL;
-
 	if (min_uV < tps->info[dcdc]->min_uV
 			|| min_uV > tps->info[dcdc]->max_uV)
 		return -EINVAL;
@@ -379,7 +402,7 @@ static int tps65023_dcdc_list_voltage(struct regulator_dev *dev,
 	if (dcdc < TPS65023_DCDC_1 || dcdc > TPS65023_DCDC_3)
 		return -EINVAL;
 
-	if (dcdc == TPS65023_DCDC_1) {
+	if (dcdc == tps->core_regulator) {
 		if (selector >= tps->info[dcdc]->table_len)
 			return -EINVAL;
 		else
@@ -431,7 +454,8 @@ static struct regmap_config tps65023_regmap_config = {
 static int __devinit tps_65023_probe(struct i2c_client *client,
 				     const struct i2c_device_id *id)
 {
-	const struct tps_info *info = (void *)id->driver_data;
+	const struct tps_driver_data *drv_data = (void *)id->driver_data;
+	const struct tps_info *info = drv_data->info;
 	struct regulator_init_data *init_data;
 	struct regulator_dev *rdev;
 	struct tps_pmic *tps;
@@ -463,6 +487,7 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 
 	/* common for all regulators */
 	tps->client = client;
+	tps->core_regulator = drv_data->core_regulator;
 
 	for (i = 0; i < TPS65023_NUM_REGULATOR; i++, info++, init_data++) {
 		/* Store regulator specific information */
@@ -470,7 +495,7 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 
 		tps->desc[i].name = info->name;
 		tps->desc[i].id = i;
-		tps->desc[i].n_voltages = num_voltages[i];
+		tps->desc[i].n_voltages = drv_data->num_voltages[i];
 		tps->desc[i].ops = (i > TPS65023_DCDC_3 ?
 					&tps65023_ldo_ops : &tps65023_dcdc_ops);
 		tps->desc[i].type = REGULATOR_VOLTAGE;
@@ -528,13 +553,49 @@ static int __devexit tps_65023_remove(struct i2c_client *client)
 	return 0;
 }
 
+static const struct tps_info tps65021_regs[] = {
+	{
+		.name = "VDCDC1",
+		.min_uV =  3300000,
+		.max_uV = 3300000,
+		.fixed = 1,
+	},
+	{
+		.name = "VDCDC2",
+		.min_uV =  1800000,
+		.max_uV = 1800000,
+		.fixed = 1,
+	},
+	{
+		.name = "VDCDC3",
+		.min_uV =  800000,
+		.max_uV = 1600000,
+		.table_len = ARRAY_SIZE(VCORE_VSEL_table),
+		.table = VCORE_VSEL_table,
+	},
+	{
+		.name = "LDO1",
+		.min_uV = 1000000,
+		.max_uV = 3150000,
+		.table_len = ARRAY_SIZE(TPS65023_LDO1_VSEL_table),
+		.table = TPS65023_LDO1_VSEL_table,
+	},
+	{
+		.name = "LDO2",
+		.min_uV = 1050000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(TPS65023_LDO2_VSEL_table),
+		.table = TPS65023_LDO2_VSEL_table,
+	},
+};
+
 static const struct tps_info tps65023_regs[] = {
 	{
 		.name = "VDCDC1",
 		.min_uV =  800000,
 		.max_uV = 1600000,
-		.table_len = ARRAY_SIZE(VDCDC1_VSEL_table),
-		.table = VDCDC1_VSEL_table,
+		.table_len = ARRAY_SIZE(VCORE_VSEL_table),
+		.table = VCORE_VSEL_table,
 	},
 	{
 		.name = "VDCDC2",
@@ -552,23 +613,35 @@ static const struct tps_info tps65023_regs[] = {
 		.name = "LDO1",
 		.min_uV = 1000000,
 		.max_uV = 3150000,
-		.table_len = ARRAY_SIZE(LDO1_VSEL_table),
-		.table = LDO1_VSEL_table,
+		.table_len = ARRAY_SIZE(TPS65023_LDO1_VSEL_table),
+		.table = TPS65023_LDO1_VSEL_table,
 	},
 	{
 		.name = "LDO2",
 		.min_uV = 1050000,
 		.max_uV = 3300000,
-		.table_len = ARRAY_SIZE(LDO2_VSEL_table),
-		.table = LDO2_VSEL_table,
+		.table_len = ARRAY_SIZE(TPS65023_LDO2_VSEL_table),
+		.table = TPS65023_LDO2_VSEL_table,
 	},
 };
 
+static struct tps_driver_data tps65021_drv_data = {
+		.info = (struct tps_info *) tps65021_regs,
+		.core_regulator = TPS65023_DCDC_3,
+		.num_voltages = tps65021_num_voltages,
+};
+
+static struct tps_driver_data tps65023_drv_data = {
+		.info = (struct tps_info *) tps65023_regs,
+		.core_regulator = TPS65023_DCDC_1,
+		.num_voltages = tps65023_num_voltages,
+};
+
 static const struct i2c_device_id tps_65023_id[] = {
 	{.name = "tps65023",
-	.driver_data = (unsigned long) tps65023_regs,},
+	.driver_data = (unsigned long) &tps65023_drv_data},
 	{.name = "tps65021",
-	.driver_data = (unsigned long) tps65023_regs,},
+	.driver_data = (unsigned long) &tps65021_drv_data,},
 	{ },
 };
 
-- 
1.7.4.1

