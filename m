Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab2IDUnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:43:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51788 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2IDUnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:43:50 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V4] regulator: tps6586x: add support for SYS rail
Date: Tue,  4 Sep 2012 14:43:39 -0600
Message-Id: <1346791419-31290-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laxman Dewangan <ldewangan@nvidia.com>

Device have SYS rail which is always ON. It is system power bus. LDO5
and LDO_RTC get powered through this rail internally. Add support for
this rail and make the LDO5/LDO_RTC supply by it. Update document
accordingly.

[swarren: Instantiate the sys regulator from board-harmony-power.c to
 avoid regression.]

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Mark, this patch is based on v3.6-rc3. As we discussed, lets put this into
a TPS6586x driver topic branch in the regulator tree, so that I can merge
it into the Tegra tree for the regulator DT conversion. Note that Laxman
posted patch "regulator: tps6586x: register regulator even if no init data"
which depends on this patch, so I guess they should both go through the
topic branch.

 .../devicetree/bindings/regulator/tps6586x.txt     |   65 ++++++++++++--------
 arch/arm/mach-tegra/board-harmony-power.c          |   12 +++-
 drivers/mfd/tps6586x.c                             |   13 ++++
 drivers/regulator/tps6586x-regulator.c             |   20 ++++++-
 include/linux/mfd/tps6586x.h                       |    1 +
 5 files changed, 81 insertions(+), 30 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/tps6586x.txt b/Documentation/devicetree/bindings/regulator/tps6586x.txt
index da80c2a..a2436e1 100644
--- a/Documentation/devicetree/bindings/regulator/tps6586x.txt
+++ b/Documentation/devicetree/bindings/regulator/tps6586x.txt
@@ -8,7 +8,8 @@ Required properties:
 - gpio-controller: mark the device as a GPIO controller
 - regulators: list of regulators provided by this controller, must have
   property "regulator-compatible" to match their hardware counterparts:
-  sm[0-2], ldo[0-9] and ldo_rtc
+  sys, sm[0-2], ldo[0-9] and ldo_rtc
+- sys-supply: The input supply for SYS.
 - vin-sm0-supply: The input supply for the SM0.
 - vin-sm1-supply: The input supply for the SM1.
 - vin-sm2-supply: The input supply for the SM2.
@@ -20,6 +21,9 @@ Required properties:
 
 Each regulator is defined using the standard binding for regulators.
 
+Note: LDO5 and LDO_RTC is supplied by SYS regulator internally and driver
+      take care of making proper parent child relationship.
+
 Example:
 
 	pmu: tps6586x@34 {
@@ -30,6 +34,7 @@ Example:
 		#gpio-cells = <2>;
 		gpio-controller;
 
+		sys-supply = <&some_reg>;
 		vin-sm0-supply = <&some_reg>;
 		vin-sm1-supply = <&some_reg>;
 		vin-sm2-supply = <&some_reg>;
@@ -43,8 +48,16 @@ Example:
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-			sm0_reg: regulator@0 {
+			sys_reg: regulator@0 {
 				reg = <0>;
+				regulator-compatible = "sys";
+				regulator-name = "vdd_sys";
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			sm0_reg: regulator@1 {
+				reg = <1>;
 				regulator-compatible = "sm0";
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
@@ -52,8 +65,8 @@ Example:
 				regulator-always-on;
 			};
 
-			sm1_reg: regulator@1 {
-				reg = <1>;
+			sm1_reg: regulator@2 {
+				reg = <2>;
 				regulator-compatible = "sm1";
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
@@ -61,8 +74,8 @@ Example:
 				regulator-always-on;
 			};
 
-			sm2_reg: regulator@2 {
-				reg = <2>;
+			sm2_reg: regulator@3 {
+				reg = <3>;
 				regulator-compatible = "sm2";
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <4550000>;
@@ -70,72 +83,72 @@ Example:
 				regulator-always-on;
 			};
 
-			ldo0_reg: regulator@3 {
-				reg = <3>;
+			ldo0_reg: regulator@4 {
+				reg = <4>;
 				regulator-compatible = "ldo0";
 				regulator-name = "PCIE CLK";
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo1_reg: regulator@4 {
-				reg = <4>;
+			ldo1_reg: regulator@5 {
+				reg = <5>;
 				regulator-compatible = "ldo1";
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 			};
 
-			ldo2_reg: regulator@5 {
-				reg = <5>;
+			ldo2_reg: regulator@6 {
+				reg = <6>;
 				regulator-compatible = "ldo2";
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 			};
 
-			ldo3_reg: regulator@6 {
-				reg = <6>;
+			ldo3_reg: regulator@7 {
+				reg = <7>;
 				regulator-compatible = "ldo3";
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo4_reg: regulator@7 {
-				reg = <7>;
+			ldo4_reg: regulator@8 {
+				reg = <8>;
 				regulator-compatible = "ldo4";
 				regulator-min-microvolt = <1700000>;
 				regulator-max-microvolt = <2475000>;
 			};
 
-			ldo5_reg: regulator@8 {
-				reg = <8>;
+			ldo5_reg: regulator@9 {
+				reg = <9>;
 				regulator-compatible = "ldo5";
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo6_reg: regulator@9 {
-				reg = <9>;
+			ldo6_reg: regulator@10 {
+				reg = <10>;
 				regulator-compatible = "ldo6";
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo7_reg: regulator@10 {
-				reg = <10>;
+			ldo7_reg: regulator@11 {
+				reg = <11>;
 				regulator-compatible = "ldo7";
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo8_reg: regulator@11 {
-				reg = <11>;
+			ldo8_reg: regulator@12 {
+				reg = <12>;
 				regulator-compatible = "ldo8";
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo9_reg: regulator@12 {
-				reg = <12>;
+			ldo9_reg: regulator@13 {
+				reg = <13>;
 				regulator-compatible = "ldo9";
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
diff --git a/arch/arm/mach-tegra/board-harmony-power.c b/arch/arm/mach-tegra/board-harmony-power.c
index b7344be..94486e7 100644
--- a/arch/arm/mach-tegra/board-harmony-power.c
+++ b/arch/arm/mach-tegra/board-harmony-power.c
@@ -67,6 +67,13 @@ static struct regulator_init_data ldo0_data = {
 		},							\
 	}
 
+static struct regulator_init_data sys_data = {
+	.supply_regulator = "vdd_5v0",
+	.constraints = {
+		.name = "vdd_sys",
+	},
+};
+
 HARMONY_REGULATOR_INIT(sm0,  "vdd_sm0",  "vdd_sys", 725, 1500, 1);
 HARMONY_REGULATOR_INIT(sm1,  "vdd_sm1",  "vdd_sys", 725, 1500, 1);
 HARMONY_REGULATOR_INIT(sm2,  "vdd_sm2",  "vdd_sys", 3000, 4550, 1);
@@ -74,7 +81,7 @@ HARMONY_REGULATOR_INIT(ldo1, "vdd_ldo1", "vdd_sm2", 725, 1500, 1);
 HARMONY_REGULATOR_INIT(ldo2, "vdd_ldo2", "vdd_sm2", 725, 1500, 0);
 HARMONY_REGULATOR_INIT(ldo3, "vdd_ldo3", "vdd_sm2", 1250, 3300, 1);
 HARMONY_REGULATOR_INIT(ldo4, "vdd_ldo4", "vdd_sm2", 1700, 2475, 1);
-HARMONY_REGULATOR_INIT(ldo5, "vdd_ldo5", NULL,	    1250, 3300, 1);
+HARMONY_REGULATOR_INIT(ldo5, "vdd_ldo5", "vdd_sys", 1250, 3300, 1);
 HARMONY_REGULATOR_INIT(ldo6, "vdd_ldo6", "vdd_sm2", 1250, 3300, 0);
 HARMONY_REGULATOR_INIT(ldo7, "vdd_ldo7", "vdd_sm2", 1250, 3300, 0);
 HARMONY_REGULATOR_INIT(ldo8, "vdd_ldo8", "vdd_sm2", 1250, 3300, 0);
@@ -88,6 +95,7 @@ HARMONY_REGULATOR_INIT(ldo9, "vdd_ldo9", "vdd_sm2", 1250, 3300, 1);
 	}
 
 static struct tps6586x_subdev_info tps_devs[] = {
+	TPS_REG(SYS, &sys_data),
 	TPS_REG(SM_0, &sm0_data),
 	TPS_REG(SM_1, &sm1_data),
 	TPS_REG(SM_2, &sm2_data),
@@ -120,7 +128,7 @@ static struct i2c_board_info __initdata harmony_regulators[] = {
 
 int __init harmony_regulator_init(void)
 {
-	regulator_register_always_on(0, "vdd_sys",
+	regulator_register_always_on(0, "vdd_5v0",
 		NULL, 0, 5000000);
 
 	if (machine_is_harmony()) {
diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 353c348..380a3c8 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -25,6 +25,7 @@
 #include <linux/i2c.h>
 #include <linux/regmap.h>
 #include <linux/regulator/of_regulator.h>
+#include <linux/regulator/machine.h>
 
 #include <linux/mfd/core.h>
 #include <linux/mfd/tps6586x.h>
@@ -346,6 +347,7 @@ failed:
 
 #ifdef CONFIG_OF
 static struct of_regulator_match tps6586x_matches[] = {
+	{ .name = "sys",     .driver_data = (void *)TPS6586X_ID_SYS     },
 	{ .name = "sm0",     .driver_data = (void *)TPS6586X_ID_SM_0    },
 	{ .name = "sm1",     .driver_data = (void *)TPS6586X_ID_SM_1    },
 	{ .name = "sm2",     .driver_data = (void *)TPS6586X_ID_SM_2    },
@@ -369,6 +371,7 @@ static struct tps6586x_platform_data *tps6586x_parse_dt(struct i2c_client *clien
 	struct tps6586x_platform_data *pdata;
 	struct tps6586x_subdev_info *devs;
 	struct device_node *regs;
+	const char *sys_rail_name = NULL;
 	unsigned int count;
 	unsigned int i, j;
 	int err;
@@ -391,12 +394,22 @@ static struct tps6586x_platform_data *tps6586x_parse_dt(struct i2c_client *clien
 		return NULL;
 
 	for (i = 0, j = 0; i < num && j < count; i++) {
+		struct regulator_init_data *reg_idata;
+
 		if (!tps6586x_matches[i].init_data)
 			continue;
 
+		reg_idata  = tps6586x_matches[i].init_data;
 		devs[j].name = "tps6586x-regulator";
 		devs[j].platform_data = tps6586x_matches[i].init_data;
 		devs[j].id = (int)tps6586x_matches[i].driver_data;
+		if (devs[j].id == TPS6586X_ID_SYS)
+			sys_rail_name = reg_idata->constraints.name;
+
+		if ((devs[j].id == TPS6586X_ID_LDO_5) ||
+			(devs[j].id == TPS6586X_ID_LDO_RTC))
+			reg_idata->supply_regulator = sys_rail_name;
+
 		devs[j].of_node = tps6586x_matches[i].of_node;
 		j++;
 	}
diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 19241fc..8212526 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -162,6 +162,9 @@ static struct regulator_ops tps6586x_regulator_ops = {
 	.disable = tps6586x_regulator_disable,
 };
 
+static struct regulator_ops tps6586x_sys_regulator_ops = {
+};
+
 static const unsigned int tps6586x_ldo0_voltages[] = {
 	1200000, 1500000, 1800000, 2500000, 2700000, 2850000, 3100000, 3300000,
 };
@@ -230,15 +233,28 @@ static const unsigned int tps6586x_dvm_voltages[] = {
 	TPS6586X_REGULATOR_DVM_GOREG(goreg, gobit)			\
 }
 
+#define TPS6586X_SYS_REGULATOR()					\
+{									\
+	.desc	= {							\
+		.supply_name = "sys",					\
+		.name	= "REG-SYS",					\
+		.ops	= &tps6586x_sys_regulator_ops,			\
+		.type	= REGULATOR_VOLTAGE,				\
+		.id	= TPS6586X_ID_SYS,				\
+		.owner	= THIS_MODULE,					\
+	},								\
+}
+
 static struct tps6586x_regulator tps6586x_regulator[] = {
+	TPS6586X_SYS_REGULATOR(),
 	TPS6586X_LDO(LDO_0, "vinldo01", ldo0, SUPPLYV1, 5, 3, ENC, 0, END, 0),
 	TPS6586X_LDO(LDO_3, "vinldo23", ldo, SUPPLYV4, 0, 3, ENC, 2, END, 2),
-	TPS6586X_LDO(LDO_5, NULL, ldo, SUPPLYV6, 0, 3, ENE, 6, ENE, 6),
+	TPS6586X_LDO(LDO_5, "REG-SYS", ldo, SUPPLYV6, 0, 3, ENE, 6, ENE, 6),
 	TPS6586X_LDO(LDO_6, "vinldo678", ldo, SUPPLYV3, 0, 3, ENC, 4, END, 4),
 	TPS6586X_LDO(LDO_7, "vinldo678", ldo, SUPPLYV3, 3, 3, ENC, 5, END, 5),
 	TPS6586X_LDO(LDO_8, "vinldo678", ldo, SUPPLYV2, 5, 3, ENC, 6, END, 6),
 	TPS6586X_LDO(LDO_9, "vinldo9", ldo, SUPPLYV6, 3, 3, ENE, 7, ENE, 7),
-	TPS6586X_LDO(LDO_RTC, NULL, ldo, SUPPLYV4, 3, 3, V4, 7, V4, 7),
+	TPS6586X_LDO(LDO_RTC, "REG-SYS", ldo, SUPPLYV4, 3, 3, V4, 7, V4, 7),
 	TPS6586X_LDO(LDO_1, "vinldo01", dvm, SUPPLYV1, 0, 5, ENC, 1, END, 1),
 	TPS6586X_LDO(SM_2, "vin-sm2", sm2, SUPPLYV2, 0, 5, ENC, 7, END, 7),
 
diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
index f350fd0..9451471 100644
--- a/include/linux/mfd/tps6586x.h
+++ b/include/linux/mfd/tps6586x.h
@@ -14,6 +14,7 @@
 #define TPS6586X_SLEW_RATE_MASK         0x07
 
 enum {
+	TPS6586X_ID_SYS,
 	TPS6586X_ID_SM_0,
 	TPS6586X_ID_SM_1,
 	TPS6586X_ID_SM_2,
-- 
1.7.0.4

