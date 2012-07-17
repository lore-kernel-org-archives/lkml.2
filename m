Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2GQGMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 02:12:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7396 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab2GQGMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 02:12:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 16 Jul 2012 23:12:23 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <rob.herring@calxeda.com>, <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH REBASE] regulator: tps65910: set input_supply on desc unconditionally
Date: Tue, 17 Jul 2012 11:34:06 +0530
Message-ID: <1342505046-8176-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the supply_name in the regulator descriptor unconditionally
and make this parameter as required parameter in the device
node for successfully registration of the regulator.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
The changes are based on on discussion on patch
[PATCH 1/3] ARM: dt: tegra: seaboard: add regulators
on which the input supply name should be require in DT case and 
unconditionally set on the desc.supply_name.

Although the support was accepted earlier but as per discussion,
it was not so good and hence this is the change.
Becasue no-one is using this device as of now in dt file, it is safe
to change now and provide guidance to the new user of this device.

There is problem in apply patch. Rebased against Mark's topic/drivers
and sending.

 Documentation/devicetree/bindings/mfd/tps65910.txt |   33 +++++++++++++------
 drivers/regulator/tps65910-regulator.c             |   11 +------
 include/linux/mfd/tps65910.h                       |    2 -
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/tps65910.txt b/Documentation/devicetree/bindings/mfd/tps65910.txt
index 31be5a3..d2802d4 100644
--- a/Documentation/devicetree/bindings/mfd/tps65910.txt
+++ b/Documentation/devicetree/bindings/mfd/tps65910.txt
@@ -25,17 +25,12 @@ Required properties:
   tps65911: vrtc, vio, vdd1, vdd3, vddctrl, ldo1, ldo2, ldo3, ldo4, ldo5,
             ldo6, ldo7, ldo8
 
-Optional properties:
-- ti,vmbch-threshold: (tps65911) main battery charged threshold
-  comparator. (see VMBCH_VSEL in TPS65910 datasheet)
-- ti,vmbch2-threshold: (tps65911) main battery discharged threshold
-  comparator. (see VMBCH_VSEL in TPS65910 datasheet)
-- ti,en-gpio-sleep: enable sleep control for gpios
-  There should be 9 entries here, one for each gpio.
 - xxx-supply: Input voltage supply regulator.
-  Missing of these properties will be assume as there is no supply regulator
-  for that input pins and always powered on.
-  The valid input supply properties are:
+  These entries are require if regulators are enabled for a device. Missing of these
+  properties can cause the regulator registration fails.
+  If some of input supply is powered through battery or always-on supply then
+  also it is require to have these parameters with proper node handle of always
+  on power supply.
   tps65910:
 	vcc1-supply: VDD1 input.
 	vcc2-supply: VDD2 input.
@@ -55,6 +50,16 @@ Optional properties:
 	vcc7-supply: VRTC input.
 	vccio-supply: VIO input.
 
+Optional properties:
+- ti,vmbch-threshold: (tps65911) main battery charged threshold
+  comparator. (see VMBCH_VSEL in TPS65910 datasheet)
+- ti,vmbch2-threshold: (tps65911) main battery discharged threshold
+  comparator. (see VMBCH_VSEL in TPS65910 datasheet)
+- ti,en-ck32k-xtal: enable external 32-kHz crystal oscillator (see CK32K_CTRL
+  in TPS6591X datasheet)
+- ti,en-gpio-sleep: enable sleep control for gpios
+  There should be 9 entries here, one for each gpio.
+
 Regulator Optional properties:
 - ti,regulator-ext-sleep-control: enable external sleep
   control through external inputs [0 (not enabled), 1 (EN1), 2 (EN2) or 4(EN3)]
@@ -79,8 +84,14 @@ Example:
 
 		ti,en-gpio-sleep = <0 0 1 0 0 0 0 0 0>;
 
-		vcc7-supply = <&reg_parent>;
 		vcc1-supply = <&reg_parent>;
+		vcc2-supply = <&some_reg>;
+		vcc3-supply = <...>;
+		vcc4-supply = <...>;
+		vcc5-supply = <...>;
+		vcc6-supply = <...>;
+		vcc7-supply = <...>;
+		vccio-supply = <...>;
 
 		regulators {
 			#address-cells = <1>;
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index d2ba066..793adda 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1001,9 +1001,6 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 	*tps65910_reg_matches = matches;
 
 	for (idx = 0; idx < count; idx++) {
-		struct tps_info *info = matches[idx].driver_data;
-		char in_supply[32]; /* 32 is max size of property name */
-
 		if (!matches[idx].init_data || !matches[idx].of_node)
 			continue;
 
@@ -1015,12 +1012,6 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 		if (!ret)
 			pmic_plat_data->regulator_ext_sleep_control[idx] = prop;
 
-		if (info->vin_name) {
-			snprintf(in_supply, 32, "%s-supply", info->vin_name);
-			if (of_find_property(np, in_supply, 0))
-				pmic_plat_data->input_supply[idx] =
-								info->vin_name;
-		}
 	}
 
 	return pmic_plat_data;
@@ -1123,7 +1114,7 @@ static __devinit int tps65910_probe(struct platform_device *pdev)
 		pmic->info[i] = info;
 
 		pmic->desc[i].name = info->name;
-		pmic->desc[i].supply_name = pmic_plat_data->input_supply[i];
+		pmic->desc[i].supply_name = info->vin_name;
 		pmic->desc[i].id = i;
 		pmic->desc[i].n_voltages = info->n_voltages;
 		pmic->desc[i].enable_time = info->enable_time_us;
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 1aca1fb..6c4c478 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -799,7 +799,6 @@ struct tps65910_sleep_keepon_data {
 /**
  * struct tps65910_board
  * Board platform data may be used to initialize regulators.
- * @input_supply: Name of input supply regulator.
  */
 
 struct tps65910_board {
@@ -812,7 +811,6 @@ struct tps65910_board {
 	struct tps65910_sleep_keepon_data *slp_keepon;
 	bool en_gpio_sleep[TPS6591X_MAX_NUM_GPIO];
 	unsigned long regulator_ext_sleep_control[TPS65910_NUM_REGS];
-	const char *input_supply[TPS65910_NUM_REGS];
 	struct regulator_init_data *tps65910_pmic_init_data[TPS65910_NUM_REGS];
 };
 
-- 
1.7.1.1

