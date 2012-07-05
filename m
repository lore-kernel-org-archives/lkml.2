Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab2GEOJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:09:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18844 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2GEOI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:08:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Jul 2012 07:05:17 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <lrg@ti.com>, <swarren@nvidia.com>
CC: <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: tps65910: add support for input supply
Date: Thu, 5 Jul 2012 19:33:24 +0530
Message-ID: <1341497004-23537-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is multiple voltage input pins on device which
takes the voltage input for different voltage regulator.
Support to configure the voltage input supplied by
different regulator for each regulators.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
This patch is for supporting the input supply regulators
for different device output rails.
The development is based on the discussion happen on patch
[PATCH 1/3] ARM: dt: tegra: seaboard: add regulators
excerpts for discussion are:

Laxman:
the input to different regulator
is from the pin of the chips and so the name should be the 
<pin-name>-supply which should be part of chip-dt binding, not
to the particular rail.

Mark:
More specifically, all the supplies for a device (including those
that happen to be inputs for regulators) should be specified in
exactly the same fashion.  This makes the binding more regular and
means that users can just go through the schematic adding the
mappings without worrying about what what the supply happens to
be.

 Documentation/devicetree/bindings/mfd/tps65910.txt |   25 ++++++++++++++
 drivers/regulator/tps65910-regulator.c             |   36 ++++++++++++++++++++
 include/linux/mfd/tps65910.h                       |    2 +
 3 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/tps65910.txt b/Documentation/devicetree/bindings/mfd/tps65910.txt
index b51d206..b390600 100644
--- a/Documentation/devicetree/bindings/mfd/tps65910.txt
+++ b/Documentation/devicetree/bindings/mfd/tps65910.txt
@@ -32,6 +32,28 @@ Optional properties:
   comparator. (see VMBCH_VSEL in TPS65910 datasheet)
 - ti,en-gpio-sleep: enable sleep control for gpios
   There should be 9 entries here, one for each gpio.
+- vin-xxx-supply: Input voltage supply regulator.
+  Missing of these properties will be assume as there is no parent regulator
+  for that input pins and always powered on.
+  The valid input supply properties are:
+  tps65910:
+	vin-vcc7-supply: VRTC input.
+	vin-vccio-supply: VIO input.
+	vin-vcc1-supply: VDD1 input.
+	vin-vcc2-supply: VDD2 input.
+	vin-vcc6-supply: VDIG1 and VDIG2 input.
+	vin-vcc5-supply: VPLL and VDAC input.
+	vin-vcc4-supply: VAUX1 and VAUX2 input.
+	vin-vcc3-supply: VAUX33 and VMMC input.
+  tps65911:
+	vin-vcc7-supply: VRTC input.
+	vin-vcc1-supply: VDD1 input.
+	vin-vcc2-supply: VDD2 input.
+	vin-vccio-supply: VIO input.
+	vin-vcc6-supply: LDO1 and LDO2 input.
+	vin-vcc5-supply: LDO3 and LDO4 input.
+	vin-vcc4-supply: LDO5 input.
+	vin-vcc3-supply: LDO6, LDO7 and LDO8 input.
 
 Regulator Optional properties:
 - ti,regulator-ext-sleep-control: enable external sleep
@@ -57,6 +79,9 @@ Example:
 
 		ti,en-gpio-sleep = <0 0 1 0 0 0 0 0 0>;
 
+		vin-vcc7-supply = <&reg_parent>;
+		vin-vcc1-supply = <&reg_parent>;
+
 		regulators {
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index a534e08..89c0f2e 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -85,6 +85,7 @@ static const unsigned int VMMC_VSEL_table[] = {
 
 struct tps_info {
 	const char *name;
+	const char *vin_name;
 	u8 n_voltages;
 	const unsigned int *voltage_table;
 	int enable_time_us;
@@ -93,20 +94,24 @@ struct tps_info {
 static struct tps_info tps65910_regs[] = {
 	{
 		.name = "vrtc",
+		.vin_name = "vin-vcc7",
 		.enable_time_us = 2200,
 	},
 	{
 		.name = "vio",
+		.vin_name = "vin-vccio",
 		.n_voltages = ARRAY_SIZE(VIO_VSEL_table),
 		.voltage_table = VIO_VSEL_table,
 		.enable_time_us = 350,
 	},
 	{
 		.name = "vdd1",
+		.vin_name = "vin-vcc1",
 		.enable_time_us = 350,
 	},
 	{
 		.name = "vdd2",
+		.vin_name = "vin-vcc2",
 		.enable_time_us = 350,
 	},
 	{
@@ -117,48 +122,56 @@ static struct tps_info tps65910_regs[] = {
 	},
 	{
 		.name = "vdig1",
+		.vin_name = "vin-vcc6",
 		.n_voltages = ARRAY_SIZE(VDIG1_VSEL_table),
 		.voltage_table = VDIG1_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vdig2",
+		.vin_name = "vin-vcc6",
 		.n_voltages = ARRAY_SIZE(VDIG2_VSEL_table),
 		.voltage_table = VDIG2_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vpll",
+		.vin_name = "vin-vcc5",
 		.n_voltages = ARRAY_SIZE(VPLL_VSEL_table),
 		.voltage_table = VPLL_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vdac",
+		.vin_name = "vin-vcc5",
 		.n_voltages = ARRAY_SIZE(VDAC_VSEL_table),
 		.voltage_table = VDAC_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vaux1",
+		.vin_name = "vin-vcc4",
 		.n_voltages = ARRAY_SIZE(VAUX1_VSEL_table),
 		.voltage_table = VAUX1_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vaux2",
+		.vin_name = "vin-vcc4",
 		.n_voltages = ARRAY_SIZE(VAUX2_VSEL_table),
 		.voltage_table = VAUX2_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vaux33",
+		.vin_name = "vin-vcc3",
 		.n_voltages = ARRAY_SIZE(VAUX33_VSEL_table),
 		.voltage_table = VAUX33_VSEL_table,
 		.enable_time_us = 100,
 	},
 	{
 		.name = "vmmc",
+		.vin_name = "vin-vcc3",
 		.n_voltages = ARRAY_SIZE(VMMC_VSEL_table),
 		.voltage_table = VMMC_VSEL_table,
 		.enable_time_us = 100,
@@ -168,21 +181,25 @@ static struct tps_info tps65910_regs[] = {
 static struct tps_info tps65911_regs[] = {
 	{
 		.name = "vrtc",
+		.vin_name = "vin-vcc7",
 		.enable_time_us = 2200,
 	},
 	{
 		.name = "vio",
+		.vin_name = "vin-vccio",
 		.n_voltages = ARRAY_SIZE(VIO_VSEL_table),
 		.voltage_table = VIO_VSEL_table,
 		.enable_time_us = 350,
 	},
 	{
 		.name = "vdd1",
+		.vin_name = "vin-vcc1",
 		.n_voltages = 73,
 		.enable_time_us = 350,
 	},
 	{
 		.name = "vdd2",
+		.vin_name = "vin-vcc2",
 		.n_voltages = 73,
 		.enable_time_us = 350,
 	},
@@ -193,41 +210,49 @@ static struct tps_info tps65911_regs[] = {
 	},
 	{
 		.name = "ldo1",
+		.vin_name = "vin-vcc6",
 		.n_voltages = 47,
 		.enable_time_us = 420,
 	},
 	{
 		.name = "ldo2",
+		.vin_name = "vin-vcc6",
 		.n_voltages = 47,
 		.enable_time_us = 420,
 	},
 	{
 		.name = "ldo3",
+		.vin_name = "vin-vcc5",
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo4",
+		.vin_name = "vin-vcc5",
 		.n_voltages = 47,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo5",
+		.vin_name = "vin-vcc4",
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo6",
+		.vin_name = "vin-vcc3",
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo7",
+		.vin_name = "vin-vcc3",
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
 	{
 		.name = "ldo8",
+		.vin_name = "vin-vcc3",
 		.n_voltages = 24,
 		.enable_time_us = 230,
 	},
@@ -1013,6 +1038,9 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 	*tps65910_reg_matches = matches;
 
 	for (idx = 0; idx < count; idx++) {
+		struct tps_info *info = matches[idx].driver_data;
+		char in_supply[32]; /* 32 is max size of property name */
+
 		if (!matches[idx].init_data || !matches[idx].of_node)
 			continue;
 
@@ -1023,6 +1051,13 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 				"ti,regulator-ext-sleep-control", &prop);
 		if (!ret)
 			pmic_plat_data->regulator_ext_sleep_control[idx] = prop;
+
+		if (info->vin_name) {
+			snprintf(in_supply, 32, "%s-supply", info->vin_name);
+			if (of_find_property(np, in_supply, 0))
+				pmic_plat_data->input_supply[idx] =
+								info->vin_name;
+		}
 	}
 
 	return pmic_plat_data;
@@ -1126,6 +1161,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		pmic->info[i] = info;
 
 		pmic->desc[i].name = info->name;
+		pmic->desc[i].supply_name = pmic_plat_data->input_supply[i];
 		pmic->desc[i].id = i;
 		pmic->desc[i].n_voltages = info->n_voltages;
 		pmic->desc[i].enable_time = info->enable_time_us;
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index dd8dc0a..c5f8060 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -799,6 +799,7 @@ struct tps65910_sleep_keepon_data {
 /**
  * struct tps65910_board
  * Board platform data may be used to initialize regulators.
+ * @input_supply: Name of input supply regulator.
  */
 
 struct tps65910_board {
@@ -811,6 +812,7 @@ struct tps65910_board {
 	struct tps65910_sleep_keepon_data *slp_keepon;
 	bool en_gpio_sleep[TPS6591X_MAX_NUM_GPIO];
 	unsigned long regulator_ext_sleep_control[TPS65910_NUM_REGS];
+	const char *input_supply[TPS65910_NUM_REGS];
 	struct regulator_init_data *tps65910_pmic_init_data[TPS65910_NUM_REGS];
 };
 
-- 
1.7.1.1

