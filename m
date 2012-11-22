Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2KVSqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:46:16 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:43510 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab2KVSqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:46:10 -0500
From: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
To: rob.herring@calxeda.com, robherring2@gmail.com,
        francescolavra.fl@gmail.com, anton.vorontsov@linaro.org
Cc: lee.jones@linaro.org, arnd@arndb.de, linus.walleij@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux@list.st.com, rajanikanth.hv@stericsson.com,
        "Rajanikanth H.V" <rajanikanth.hv@linaro.org>
Subject: [PATCH 1/4] mfd: ab8500: add devicetree support for fuelgauge
Date: Fri, 23 Nov 2012 00:13:44 +0530
Message-Id: <1353609827-8218-2-git-send-email-rajanikanth.hv@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353609827-8218-1-git-send-email-rajanikanth.hv@linaro.org>
References: <1353609827-8218-1-git-send-email-rajanikanth.hv@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rajanikanth H.V" <rajanikanth.hv@linaro.org>

- This patch adds device tree support for fuelgauge driver
- optimize bm devices platform_data usage and of_probe(...)
  Note: of_probe() routine for battery managed devices is made
  common across all bm drivers.
- test status:
  - interrupt numbers assigned differs between legacy and FDT mode.

Signed-off-by: Rajanikanth H.V <rajanikanth.hv@linaro.org>
---
 Documentation/devicetree/bindings/mfd/ab8500.txt   |    7 +-
 .../devicetree/bindings/power_supply/ab8500/fg.txt |   58 +++
 arch/arm/boot/dts/dbx5x0.dtsi                      |   10 +
 drivers/mfd/ab8500-core.c                          |    5 +
 drivers/power/Makefile                             |    2 +-
 drivers/power/ab8500_bmdata.c                      |  514 ++++++++++++++++++++
 drivers/power/ab8500_btemp.c                       |   16 +-
 drivers/power/ab8500_charger.c                     |   16 +-
 drivers/power/ab8500_fg.c                          |   81 +--
 drivers/power/abx500_chargalg.c                    |    7 +-
 include/linux/mfd/abx500.h                         |   36 +-
 11 files changed, 659 insertions(+), 93 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
 create mode 100644 drivers/power/ab8500_bmdata.c

diff --git a/Documentation/devicetree/bindings/mfd/ab8500.txt b/Documentation/devicetree/bindings/mfd/ab8500.txt
index ce83c8d..6ca8d81 100644
--- a/Documentation/devicetree/bindings/mfd/ab8500.txt
+++ b/Documentation/devicetree/bindings/mfd/ab8500.txt
@@ -24,7 +24,12 @@ ab8500-bm                :                      :              : Battery Manager
 ab8500-btemp             :                      :              : Battery Temperature
 ab8500-charger           :                      :              : Battery Charger
 ab8500-codec             :                      :              : Audio Codec
-ab8500-fg                :                      :              : Fuel Gauge
+ab8500-fg                : 			: vddadc       : Fuel Gauge
+			 : NCONV_ACCU           :	       : Accumulate N Sample Conversion
+			 : BATT_OVV		:	       : Battery Over Voltage
+			 : LOW_BAT_F		:	       : LOW threshold battery voltage
+			 : CC_INT_CALIB		:	       : Coulomb Counter Internal Calibration
+			 : CCEOC		:	       : Coulomb Counter End of Conversion
 ab8500-gpadc             : HW_CONV_END          : vddadc       : Analogue to Digital Converter
                            SW_CONV_END          :              :
 ab8500-gpio              :                      :              : GPIO Controller
diff --git a/Documentation/devicetree/bindings/power_supply/ab8500/fg.txt b/Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
new file mode 100644
index 0000000..ccafcb9
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
@@ -0,0 +1,58 @@
+=== AB8500 Fuel Gauge Driver ===
+
+AB8500 is a mixed signal multimedia and power management
+device comprising: power and energy-management-module,
+wall-charger, usb-charger, audio codec, general purpose adc,
+tvout, clock management and sim card interface.
+
+Fuelgauge support is part of energy-management-modules, other
+components of this module are:
+main-charger, usb-combo-charger and battery-temperature-monitoring.
+
+The properties below describes the node for fuelgauge driver.
+
+Required Properties:
+- compatible = This shall be: "stericsson,ab8500-fg"
+- battery = Shall be battery specific information
+	Example:
+	ab8500_fg {
+		compatible = "stericsson,ab8500-fg";
+		battery	   = <&ab8500_battery>;
+	};
+
+dependent node:
+	ab8500_battery: ab8500_battery {
+	};
+	This node will provide information on 'thermistor interface' and
+	'battery technology type' used.
+
+Properties of this node are:
+thermistor-on-batctrl:
+	A boolean value indicating thermistor interface	to battery
+
+	Note:
+	'btemp' and 'batctrl' are the pins interfaced for battery temperature
+	measurement, 'btemp' signal is used when NTC(negative temperature
+	coefficient) resister is interfaced external to battery whereas
+	'batctrl' pin is used when NTC resister is internal to battery.
+
+	Example:
+	ab8500_battery: ab8500_battery {
+		thermistor-on-batctrl;
+	};
+	indicates: NTC resister is internal to battery, 'batctrl' is used
+		for thermal measurement.
+
+	The absence of property 'thermal-on-batctrl' indicates
+	NTC resister is external to battery and  'btemp' signal is used
+	for thermal measurement.
+
+battery-type:
+	This shall be the battery manufacturing technology type,
+	allowed types are:
+		"UNKNOWN" "NiMH" "LION" "LIPO" "LiFe" "NiCd" "LiMn"
+	Example:
+	ab8500_battery: ab8500_battery {
+		stericsson,battery-type = "LIPO";
+	}
+
diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 4b0e0ca..155cf53 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -352,6 +352,16 @@
 					vddadc-supply = <&ab8500_ldo_tvout_reg>;
 				};
 
+				ab8500_battery: ab8500_battery {
+					stericsson,battery-type = "LIPO";
+					thermistor-on-batctrl;
+				};
+
+				ab8500-fg {
+					compatible = "stericsson,ab8500-fg";
+					battery	   = <&ab8500_battery>;
+				};
+
 				ab8500-usb {
 					compatible = "stericsson,ab8500-usb";
 					interrupts = < 90 0x4
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 1667c77..7c3017b 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1051,8 +1051,13 @@ static struct mfd_cell __devinitdata ab8500_bm_devs[] = {
 	},
 	{
 		.name = "ab8500-fg",
+		.of_compatible = "stericsson,ab8500-fg",
 		.num_resources = ARRAY_SIZE(ab8500_fg_resources),
 		.resources = ab8500_fg_resources,
+#ifndef CONFIG_OF
+		.platform_data = &ab8500_bm_data,
+		.pdata_size = sizeof(ab8500_bm_data),
+#endif
 	},
 	{
 		.name = "ab8500-chargalg",
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index b949cf8..9103665 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -37,7 +37,7 @@ obj-$(CONFIG_CHARGER_88PM860X)	+= 88pm860x_charger.o
 obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
 obj-$(CONFIG_BATTERY_JZ4740)	+= jz4740-battery.o
 obj-$(CONFIG_BATTERY_INTEL_MID)	+= intel_mid_battery.o
-obj-$(CONFIG_AB8500_BM)		+= ab8500_charger.o ab8500_btemp.o ab8500_fg.o abx500_chargalg.o
+obj-$(CONFIG_AB8500_BM)		+= ab8500_bmdata.o ab8500_charger.o ab8500_fg.o ab8500_btemp.o abx500_chargalg.o
 obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
 obj-$(CONFIG_CHARGER_MAX8903)	+= max8903_charger.o
 obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
new file mode 100644
index 0000000..0366270
--- /dev/null
+++ b/drivers/power/ab8500_bmdata.c
@@ -0,0 +1,514 @@
+#include <linux/export.h>
+#include <linux/power_supply.h>
+#include <linux/of.h>
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
+#include <linux/mfd/abx500/ab8500-bm.h>
+
+/*
+ * These are the defined batteries that uses a NTC and ID resistor placed
+ * inside of the battery pack.
+ * Note that the res_to_temp table must be strictly sorted by falling resistance
+ * values to work.
+ */
+static struct abx500_res_to_temp temp_tbl_A_thermistor[] = {
+	{-5, 53407},
+	{ 0, 48594},
+	{ 5, 43804},
+	{10, 39188},
+	{15, 34870},
+	{20, 30933},
+	{25, 27422},
+	{30, 24347},
+	{35, 21694},
+	{40, 19431},
+	{45, 17517},
+	{50, 15908},
+	{55, 14561},
+	{60, 13437},
+	{65, 12500},
+};
+static struct abx500_res_to_temp temp_tbl_B_thermistor[] = {
+	{-5, 165418},
+	{ 0, 159024},
+	{ 5, 151921},
+	{10, 144300},
+	{15, 136424},
+	{20, 128565},
+	{25, 120978},
+	{30, 113875},
+	{35, 107397},
+	{40, 101629},
+	{45,  96592},
+	{50,  92253},
+	{55,  88569},
+	{60,  85461},
+	{65,  82869},
+};
+static struct abx500_v_to_cap cap_tbl_A_thermistor[] = {
+	{4171,	100},
+	{4114,	 95},
+	{4009,	 83},
+	{3947,	 74},
+	{3907,	 67},
+	{3863,	 59},
+	{3830,	 56},
+	{3813,	 53},
+	{3791,	 46},
+	{3771,	 33},
+	{3754,	 25},
+	{3735,	 20},
+	{3717,	 17},
+	{3681,	 13},
+	{3664,	  8},
+	{3651,	  6},
+	{3635,	  5},
+	{3560,	  3},
+	{3408,    1},
+	{3247,	  0},
+};
+static struct abx500_v_to_cap cap_tbl_B_thermistor[] = {
+	{4161,	100},
+	{4124,	 98},
+	{4044,	 90},
+	{4003,	 85},
+	{3966,	 80},
+	{3933,	 75},
+	{3888,	 67},
+	{3849,	 60},
+	{3813,	 55},
+	{3787,	 47},
+	{3772,	 30},
+	{3751,	 25},
+	{3718,	 20},
+	{3681,	 16},
+	{3660,	 14},
+	{3589,	 10},
+	{3546,	  7},
+	{3495,	  4},
+	{3404,	  2},
+	{3250,	  0},
+};
+
+static struct abx500_v_to_cap cap_tbl[] = {
+	{4186,	100},
+	{4163,	 99},
+	{4114,	 95},
+	{4068,	 90},
+	{3990,	 80},
+	{3926,	 70},
+	{3898,	 65},
+	{3866,	 60},
+	{3833,	 55},
+	{3812,	 50},
+	{3787,	 40},
+	{3768,	 30},
+	{3747,	 25},
+	{3730,	 20},
+	{3705,	 15},
+	{3699,	 14},
+	{3684,	 12},
+	{3672,	  9},
+	{3657,	  7},
+	{3638,	  6},
+	{3556,	  4},
+	{3424,	  2},
+	{3317,	  1},
+	{3094,	  0},
+};
+
+/*
+ * Note that the res_to_temp table must be strictly sorted by falling
+ * resistance values to work.
+ */
+static struct abx500_res_to_temp temp_tbl[] = {
+	{-5, 214834},
+	{ 0, 162943},
+	{ 5, 124820},
+	{10,  96520},
+	{15,  75306},
+	{20,  59254},
+	{25,  47000},
+	{30,  37566},
+	{35,  30245},
+	{40,  24520},
+	{45,  20010},
+	{50,  16432},
+	{55,  13576},
+	{60,  11280},
+	{65,   9425},
+};
+
+/*
+ * Note that the batres_vs_temp table must be strictly sorted by falling
+ * temperature values to work.
+ */
+struct batres_vs_temp temp_to_batres_tbl_thermistor[] = {
+	{ 40, 120},
+	{ 30, 135},
+	{ 20, 165},
+	{ 10, 230},
+	{ 00, 325},
+	{-10, 445},
+	{-20, 595},
+};
+
+/*
+ * Note that the batres_vs_temp table must be strictly sorted by falling
+ * temperature values to work.
+ */
+struct batres_vs_temp temp_to_batres_tbl_ext_thermistor[] = {
+	{ 60, 300},
+	{ 30, 300},
+	{ 20, 300},
+	{ 10, 300},
+	{ 00, 300},
+	{-10, 300},
+	{-20, 300},
+};
+
+/* battery resistance table for LI ION 9100 battery */
+struct batres_vs_temp temp_to_batres_tbl_9100[] = {
+	{ 60, 180},
+	{ 30, 180},
+	{ 20, 180},
+	{ 10, 180},
+	{ 00, 180},
+	{-10, 180},
+	{-20, 180},
+};
+
+struct abx500_battery_type bat_type_thermistor[] = {
+[BATTERY_UNKNOWN] = {
+	/* First element always represent the UNKNOWN battery */
+	.name = POWER_SUPPLY_TECHNOLOGY_UNKNOWN,
+	.resis_high = 0,
+	.resis_low = 0,
+	.battery_resistance = 300,
+	.charge_full_design = 612,
+	.nominal_voltage = 3700,
+	.termination_vol = 4050,
+	.termination_curr = 200,
+	.recharge_vol = 3990,
+	.normal_cur_lvl = 400,
+	.normal_vol_lvl = 4100,
+	.maint_a_cur_lvl = 400,
+	.maint_a_vol_lvl = 4050,
+	.maint_a_chg_timer_h = 60,
+	.maint_b_cur_lvl = 400,
+	.maint_b_vol_lvl = 4000,
+	.maint_b_chg_timer_h = 200,
+	.low_high_cur_lvl = 300,
+	.low_high_vol_lvl = 4000,
+	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
+	.r_to_t_tbl = temp_tbl,
+	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
+	.v_to_cap_tbl = cap_tbl,
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+	.batres_tbl = temp_to_batres_tbl_thermistor,
+},
+{
+	.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
+	.resis_high = 53407,
+	.resis_low = 12500,
+	.battery_resistance = 300,
+	.charge_full_design = 900,
+	.nominal_voltage = 3600,
+	.termination_vol = 4150,
+	.termination_curr = 80,
+	.recharge_vol = 4130,
+	.normal_cur_lvl = 700,
+	.normal_vol_lvl = 4200,
+	.maint_a_cur_lvl = 600,
+	.maint_a_vol_lvl = 4150,
+	.maint_a_chg_timer_h = 60,
+	.maint_b_cur_lvl = 600,
+	.maint_b_vol_lvl = 4100,
+	.maint_b_chg_timer_h = 200,
+	.low_high_cur_lvl = 300,
+	.low_high_vol_lvl = 4000,
+	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_A_thermistor),
+	.r_to_t_tbl = temp_tbl_A_thermistor,
+	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_A_thermistor),
+	.v_to_cap_tbl = cap_tbl_A_thermistor,
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+	.batres_tbl = temp_to_batres_tbl_thermistor,
+
+},
+{
+	.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
+	.resis_high = 165418,
+	.resis_low = 82869,
+	.battery_resistance = 300,
+	.charge_full_design = 900,
+	.nominal_voltage = 3600,
+	.termination_vol = 4150,
+	.termination_curr = 80,
+	.recharge_vol = 4130,
+	.normal_cur_lvl = 700,
+	.normal_vol_lvl = 4200,
+	.maint_a_cur_lvl = 600,
+	.maint_a_vol_lvl = 4150,
+	.maint_a_chg_timer_h = 60,
+	.maint_b_cur_lvl = 600,
+	.maint_b_vol_lvl = 4100,
+	.maint_b_chg_timer_h = 200,
+	.low_high_cur_lvl = 300,
+	.low_high_vol_lvl = 4000,
+	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_B_thermistor),
+	.r_to_t_tbl = temp_tbl_B_thermistor,
+	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_B_thermistor),
+	.v_to_cap_tbl = cap_tbl_B_thermistor,
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+	.batres_tbl = temp_to_batres_tbl_thermistor,
+},
+};
+
+struct abx500_battery_type bat_type_ext_thermistor[] = {
+[BATTERY_UNKNOWN] = {
+	/* First element always represent the UNKNOWN battery */
+	.name = POWER_SUPPLY_TECHNOLOGY_UNKNOWN,
+	.resis_high = 0,
+	.resis_low = 0,
+	.battery_resistance = 300,
+	.charge_full_design = 612,
+	.nominal_voltage = 3700,
+	.termination_vol = 4050,
+	.termination_curr = 200,
+	.recharge_vol = 3990,
+	.normal_cur_lvl = 400,
+	.normal_vol_lvl = 4100,
+	.maint_a_cur_lvl = 400,
+	.maint_a_vol_lvl = 4050,
+	.maint_a_chg_timer_h = 60,
+	.maint_b_cur_lvl = 400,
+	.maint_b_vol_lvl = 4000,
+	.maint_b_chg_timer_h = 200,
+	.low_high_cur_lvl = 300,
+	.low_high_vol_lvl = 4000,
+	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
+	.r_to_t_tbl = temp_tbl,
+	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
+	.v_to_cap_tbl = cap_tbl,
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+	.batres_tbl = temp_to_batres_tbl_thermistor,
+},
+/*
+ * These are the batteries that doesn't have an internal NTC resistor to measure
+ * its temperature. The temperature in this case is measure with a NTC placed
+ * near the battery but on the PCB.
+ */
+{
+	.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
+	.resis_high = 76000,
+	.resis_low = 53000,
+	.battery_resistance = 300,
+	.charge_full_design = 900,
+	.nominal_voltage = 3700,
+	.termination_vol = 4150,
+	.termination_curr = 100,
+	.recharge_vol = 4130,
+	.normal_cur_lvl = 700,
+	.normal_vol_lvl = 4200,
+	.maint_a_cur_lvl = 600,
+	.maint_a_vol_lvl = 4150,
+	.maint_a_chg_timer_h = 60,
+	.maint_b_cur_lvl = 600,
+	.maint_b_vol_lvl = 4100,
+	.maint_b_chg_timer_h = 200,
+	.low_high_cur_lvl = 300,
+	.low_high_vol_lvl = 4000,
+	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
+	.r_to_t_tbl = temp_tbl,
+	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
+	.v_to_cap_tbl = cap_tbl,
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+	.batres_tbl = temp_to_batres_tbl_thermistor,
+},
+{
+	.name = POWER_SUPPLY_TECHNOLOGY_LION,
+	.resis_high = 30000,
+	.resis_low = 10000,
+	.battery_resistance = 300,
+	.charge_full_design = 950,
+	.nominal_voltage = 3700,
+	.termination_vol = 4150,
+	.termination_curr = 100,
+	.recharge_vol = 4130,
+	.normal_cur_lvl = 700,
+	.normal_vol_lvl = 4200,
+	.maint_a_cur_lvl = 600,
+	.maint_a_vol_lvl = 4150,
+	.maint_a_chg_timer_h = 60,
+	.maint_b_cur_lvl = 600,
+	.maint_b_vol_lvl = 4100,
+	.maint_b_chg_timer_h = 200,
+	.low_high_cur_lvl = 300,
+	.low_high_vol_lvl = 4000,
+	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
+	.r_to_t_tbl = temp_tbl,
+	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
+	.v_to_cap_tbl = cap_tbl,
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+	.batres_tbl = temp_to_batres_tbl_thermistor,
+},
+{
+	.name = POWER_SUPPLY_TECHNOLOGY_LION,
+	.resis_high = 95000,
+	.resis_low = 76001,
+	.battery_resistance = 300,
+	.charge_full_design = 950,
+	.nominal_voltage = 3700,
+	.termination_vol = 4150,
+	.termination_curr = 100,
+	.recharge_vol = 4130,
+	.normal_cur_lvl = 700,
+	.normal_vol_lvl = 4200,
+	.maint_a_cur_lvl = 600,
+	.maint_a_vol_lvl = 4150,
+	.maint_a_chg_timer_h = 60,
+	.maint_b_cur_lvl = 600,
+	.maint_b_vol_lvl = 4100,
+	.maint_b_chg_timer_h = 200,
+	.low_high_cur_lvl = 300,
+	.low_high_vol_lvl = 4000,
+	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
+	.r_to_t_tbl = temp_tbl,
+	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
+	.v_to_cap_tbl = cap_tbl,
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
+	.batres_tbl = temp_to_batres_tbl_thermistor,
+},
+};
+
+static const struct abx500_bm_capacity_levels cap_levels = {
+	.critical	= 2,
+	.low		= 10,
+	.normal		= 70,
+	.high		= 95,
+	.full		= 100,
+};
+
+static const struct abx500_fg_parameters fg = {
+	.recovery_sleep_timer = 10,
+	.recovery_total_time = 100,
+	.init_timer = 1,
+	.init_discard_time = 5,
+	.init_total_time = 40,
+	.high_curr_time = 60,
+	.accu_charging = 30,
+	.accu_high_curr = 30,
+	.high_curr_threshold = 50,
+	.lowbat_threshold = 3100,
+	.battok_falling_th_sel0 = 2860,
+	.battok_raising_th_sel1 = 2860,
+	.user_cap_limit = 15,
+	.maint_thres = 97,
+};
+
+static const struct abx500_maxim_parameters maxi_params = {
+	.ena_maxi = true,
+	.chg_curr = 910,
+	.wait_cycles = 10,
+	.charger_curr_step = 100,
+};
+
+static const struct abx500_bm_charger_parameters chg = {
+	.usb_volt_max		= 5500,
+	.usb_curr_max		= 1500,
+	.ac_volt_max		= 7500,
+	.ac_curr_max		= 1500,
+};
+
+struct abx500_bm_data ab8500_bm_data = {
+	.temp_under		= 3,
+	.temp_low		= 8,
+	.temp_high		= 43,
+	.temp_over		= 48,
+	.main_safety_tmr_h	= 4,
+	.temp_interval_chg	= 20,
+	.temp_interval_nochg	= 120,
+	.usb_safety_tmr_h	= 4,
+	.bkup_bat_v		= BUP_VCH_SEL_2P6V,
+	.bkup_bat_i		= BUP_ICH_SEL_150UA,
+	.no_maintenance		= false,
+	.adc_therm		= ABx500_ADC_THERM_BATCTRL,
+	.chg_unknown_bat	= false,
+	.enable_overshoot	= false,
+	.fg_res			= 100,
+	.cap_levels		= &cap_levels,
+	.bat_type		= bat_type_thermistor,
+	.n_btypes		= 3,
+	.batt_id		= 0,
+	.interval_charging	= 5,
+	.interval_not_charging	= 120,
+	.temp_hysteresis	= 3,
+	.gnd_lift_resistance	= 34,
+	.maxi			= &maxi_params,
+	.chg_params		= &chg,
+	.fg_params		= &fg,
+};
+
+int __devinit
+bmdevs_of_probe(struct device *dev,
+		struct device_node *np,
+		struct abx500_bm_data **battery)
+{
+	struct	abx500_battery_type *btype;
+	struct  device_node *np_bat_supply;
+	struct	abx500_bm_data *bat;
+	const char *btech;
+	int i, thermistor;
+
+	*battery = &ab8500_bm_data;
+
+	/* get phandle to 'battery-info' node */
+	np_bat_supply = of_parse_phandle(np, "battery", 0);
+	if (!np_bat_supply) {
+		dev_err(dev, "missing property battery\n");
+		return -EINVAL;
+	}
+	if (of_property_read_bool(np_bat_supply,
+			"thermistor-on-batctrl"))
+		thermistor = NTC_INTERNAL;
+	else
+		thermistor = NTC_EXTERNAL;
+
+	bat = *battery;
+	if (thermistor == NTC_EXTERNAL) {
+		bat->n_btypes  = 4;
+		bat->bat_type  = bat_type_ext_thermistor;
+		bat->adc_therm = ABx500_ADC_THERM_BATTEMP;
+	}
+	btech = of_get_property(np_bat_supply,
+		"stericsson,battery-type", NULL);
+	if (!btech) {
+		dev_warn(dev, "missing property battery-name/type\n");
+		return -EINVAL;
+	}
+	if (strncmp(btech, "LION", 4) == 0) {
+		bat->no_maintenance  = true;
+		bat->chg_unknown_bat = true;
+		bat->bat_type[BATTERY_UNKNOWN].charge_full_design = 2600;
+		bat->bat_type[BATTERY_UNKNOWN].termination_vol    = 4150;
+		bat->bat_type[BATTERY_UNKNOWN].recharge_vol	  = 4130;
+		bat->bat_type[BATTERY_UNKNOWN].normal_cur_lvl	  = 520;
+		bat->bat_type[BATTERY_UNKNOWN].normal_vol_lvl	  = 4200;
+	}
+	/* select the battery resolution table */
+	for (i = 0; i < bat->n_btypes; ++i) {
+		btype = (bat->bat_type + i);
+		if (thermistor == NTC_EXTERNAL) {
+			btype->batres_tbl =
+				temp_to_batres_tbl_ext_thermistor;
+		} else if (strncmp(btech, "LION", 4) == 0) {
+			btype->batres_tbl =
+				temp_to_batres_tbl_9100;
+		} else {
+			btype->batres_tbl =
+				temp_to_batres_tbl_thermistor;
+		}
+	}
+	of_node_put(np_bat_supply);
+	return 0;
+}
diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index e3b6395..abc2abc 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -93,7 +93,7 @@ struct ab8500_btemp {
 	struct ab8500 *parent;
 	struct ab8500_gpadc *gpadc;
 	struct ab8500_fg *fg;
-	struct abx500_btemp_platform_data *pdata;
+	struct abx500_bmdevs_plat_data *pdata;
 	struct abx500_bm_data *bat;
 	struct power_supply btemp_psy;
 	struct ab8500_btemp_events events;
@@ -962,10 +962,10 @@ static int __devexit ab8500_btemp_remove(struct platform_device *pdev)
 
 static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 {
+	struct abx500_bmdevs_plat_data *plat_data = pdev->dev.platform_data;
+	struct ab8500_btemp *di;
 	int irq, i, ret = 0;
 	u8 val;
-	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
-	struct ab8500_btemp *di;
 
 	if (!plat_data) {
 		dev_err(&pdev->dev, "No platform data\n");
@@ -982,21 +982,13 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 
 	/* get btemp specific platform data */
-	di->pdata = plat_data->btemp;
+	di->pdata = plat_data;
 	if (!di->pdata) {
 		dev_err(di->dev, "no btemp platform data supplied\n");
 		ret = -EINVAL;
 		goto free_device_info;
 	}
 
-	/* get battery specific platform data */
-	di->bat = plat_data->battery;
-	if (!di->bat) {
-		dev_err(di->dev, "no battery platform data supplied\n");
-		ret = -EINVAL;
-		goto free_device_info;
-	}
-
 	/* BTEMP supply */
 	di->btemp_psy.name = "ab8500_btemp";
 	di->btemp_psy.type = POWER_SUPPLY_TYPE_BATTERY;
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 26ff759..723edb4 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -220,7 +220,7 @@ struct ab8500_charger {
 	bool autopower;
 	struct ab8500 *parent;
 	struct ab8500_gpadc *gpadc;
-	struct abx500_charger_platform_data *pdata;
+	struct abx500_bmdevs_plat_data *pdata;
 	struct abx500_bm_data *bat;
 	struct ab8500_charger_event_flags flags;
 	struct ab8500_charger_usb_state usb_state;
@@ -2533,9 +2533,9 @@ static int __devexit ab8500_charger_remove(struct platform_device *pdev)
 
 static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 {
-	int irq, i, charger_status, ret = 0;
-	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
+	struct abx500_bmdevs_plat_data *plat_data = pdev->dev.platform_data;
 	struct ab8500_charger *di;
+	int irq, i, charger_status, ret = 0;
 
 	if (!plat_data) {
 		dev_err(&pdev->dev, "No platform data\n");
@@ -2555,21 +2555,13 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 	spin_lock_init(&di->usb_state.usb_lock);
 
 	/* get charger specific platform data */
-	di->pdata = plat_data->charger;
+	di->pdata = plat_data;
 	if (!di->pdata) {
 		dev_err(di->dev, "no charger platform data supplied\n");
 		ret = -EINVAL;
 		goto free_device_info;
 	}
 
-	/* get battery specific platform data */
-	di->bat = plat_data->battery;
-	if (!di->bat) {
-		dev_err(di->dev, "no battery platform data supplied\n");
-		ret = -EINVAL;
-		goto free_device_info;
-	}
-
 	di->autopower = false;
 
 	/* AC supply */
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 2db8cc2..20ac3b8 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -22,15 +22,16 @@
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 #include <linux/kobject.h>
-#include <linux/mfd/abx500/ab8500.h>
-#include <linux/mfd/abx500.h>
 #include <linux/slab.h>
-#include <linux/mfd/abx500/ab8500-bm.h>
 #include <linux/delay.h>
-#include <linux/mfd/abx500/ab8500-gpadc.h>
-#include <linux/mfd/abx500.h>
 #include <linux/time.h>
+#include <linux/of.h>
 #include <linux/completion.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
+#include <linux/mfd/abx500/ab8500-bm.h>
+#include <linux/mfd/abx500/ab8500-gpadc.h>
 
 #define MILLI_TO_MICRO			1000
 #define FG_LSB_IN_MA			1627
@@ -172,7 +173,6 @@ struct inst_curr_result_list {
  * @avg_cap:		Average capacity filter
  * @parent:		Pointer to the struct ab8500
  * @gpadc:		Pointer to the struct gpadc
- * @pdata:		Pointer to the abx500_fg platform data
  * @bat:		Pointer to the abx500_bm platform data
  * @fg_psy:		Structure that holds the FG specific battery properties
  * @fg_wq:		Work queue for running the FG algorithm
@@ -212,7 +212,6 @@ struct ab8500_fg {
 	struct ab8500_fg_avg_cap avg_cap;
 	struct ab8500 *parent;
 	struct ab8500_gpadc *gpadc;
-	struct abx500_fg_platform_data *pdata;
 	struct abx500_bm_data *bat;
 	struct power_supply fg_psy;
 	struct workqueue_struct *fg_wq;
@@ -2429,7 +2428,6 @@ static int __devexit ab8500_fg_remove(struct platform_device *pdev)
 	flush_scheduled_work();
 	power_supply_unregister(&di->fg_psy);
 	platform_set_drvdata(pdev, NULL);
-	kfree(di);
 	return ret;
 }
 
@@ -2442,21 +2440,39 @@ static struct ab8500_fg_interrupts ab8500_fg_irq[] = {
 	{"CCEOC", ab8500_fg_cc_data_end_handler},
 };
 
+static char *supply_interface[] = {
+	"ab8500_chargalg",
+	"ab8500_usb",
+};
+
 static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
+	struct ab8500_fg *di;
 	int i, irq;
 	int ret = 0;
-	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
-	struct ab8500_fg *di;
-
-	if (!plat_data) {
-		dev_err(&pdev->dev, "No platform data\n");
-		return -EINVAL;
-	}
 
-	di = kzalloc(sizeof(*di), GFP_KERNEL);
-	if (!di)
+	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
+	if (!di) {
+		dev_err(&pdev->dev, "%s no mem for ab8500_fg\n", __func__);
 		return -ENOMEM;
+	}
+	di->bat = pdev->mfd_cell->platform_data;
+	if (!di->bat) {
+		if (np) {
+			ret = bmdevs_of_probe(&pdev->dev, np, &di->bat);
+			if (ret) {
+				dev_err(&pdev->dev,
+					"failed to get battery information\n");
+				return ret;
+			}
+		} else {
+			dev_err(&pdev->dev, "missing dt node for ab8500_fg\n");
+			return -EINVAL;
+		}
+	} else {
+		dev_info(&pdev->dev, "falling back to legacy platform data\n");
+	}
 
 	mutex_init(&di->cc_lock);
 
@@ -2465,29 +2481,13 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 	di->parent = dev_get_drvdata(pdev->dev.parent);
 	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 
-	/* get fg specific platform data */
-	di->pdata = plat_data->fg;
-	if (!di->pdata) {
-		dev_err(di->dev, "no fg platform data supplied\n");
-		ret = -EINVAL;
-		goto free_device_info;
-	}
-
-	/* get battery specific platform data */
-	di->bat = plat_data->battery;
-	if (!di->bat) {
-		dev_err(di->dev, "no battery platform data supplied\n");
-		ret = -EINVAL;
-		goto free_device_info;
-	}
-
 	di->fg_psy.name = "ab8500_fg";
 	di->fg_psy.type = POWER_SUPPLY_TYPE_BATTERY;
 	di->fg_psy.properties = ab8500_fg_props;
 	di->fg_psy.num_properties = ARRAY_SIZE(ab8500_fg_props);
 	di->fg_psy.get_property = ab8500_fg_get_property;
-	di->fg_psy.supplied_to = di->pdata->supplied_to;
-	di->fg_psy.num_supplicants = di->pdata->num_supplicants;
+	di->fg_psy.supplied_to = supply_interface;
+	di->fg_psy.num_supplicants = ARRAY_SIZE(supply_interface),
 	di->fg_psy.external_power_changed = ab8500_fg_external_power_changed;
 
 	di->bat_cap.max_mah_design = MILLI_TO_MICRO *
@@ -2506,8 +2506,7 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 	di->fg_wq = create_singlethread_workqueue("ab8500_fg_wq");
 	if (di->fg_wq == NULL) {
 		dev_err(di->dev, "failed to create work queue\n");
-		ret = -ENOMEM;
-		goto free_device_info;
+		return -ENOMEM;
 	}
 
 	/* Init work for running the fg algorithm instantly */
@@ -2606,12 +2605,15 @@ free_irq:
 	}
 free_inst_curr_wq:
 	destroy_workqueue(di->fg_wq);
-free_device_info:
-	kfree(di);
 
 	return ret;
 }
 
+static const struct of_device_id ab8500_fg_match[] = {
+	{ .compatible = "stericsson,ab8500-fg", },
+	{ },
+};
+
 static struct platform_driver ab8500_fg_driver = {
 	.probe = ab8500_fg_probe,
 	.remove = __devexit_p(ab8500_fg_remove),
@@ -2620,6 +2622,7 @@ static struct platform_driver ab8500_fg_driver = {
 	.driver = {
 		.name = "ab8500-fg",
 		.owner = THIS_MODULE,
+		.of_match_table = ab8500_fg_match,
 	},
 };
 
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 4d30280..94bf69b 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -231,7 +231,7 @@ struct abx500_chargalg {
 	struct abx500_chargalg_charger_info chg_info;
 	struct abx500_chargalg_battery_data batt_data;
 	struct abx500_chargalg_suspension_status susp_status;
-	struct abx500_chargalg_platform_data *pdata;
+	struct abx500_bmdevs_plat_data *pdata;
 	struct abx500_bm_data *bat;
 	struct power_supply chargalg_psy;
 	struct ux500_charger *ac_chg;
@@ -1802,7 +1802,7 @@ static int __devexit abx500_chargalg_remove(struct platform_device *pdev)
 
 static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
 {
-	struct abx500_bm_plat_data *plat_data;
+	struct abx500_bmdevs_plat_data *plat_data;
 	int ret = 0;
 
 	struct abx500_chargalg *di =
@@ -1814,8 +1814,7 @@ static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
 	di->dev = &pdev->dev;
 
 	plat_data = pdev->dev.platform_data;
-	di->pdata = plat_data->chargalg;
-	di->bat = plat_data->battery;
+	di->pdata = plat_data;
 
 	/* chargalg supply */
 	di->chargalg_psy.name = "abx500_chargalg";
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 5d5298d..33f2c58 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -267,39 +267,27 @@ struct abx500_bm_data {
 	int gnd_lift_resistance;
 	const struct abx500_maxim_parameters *maxi;
 	const struct abx500_bm_capacity_levels *cap_levels;
-	const struct abx500_battery_type *bat_type;
+	struct abx500_battery_type *bat_type;
 	const struct abx500_bm_charger_parameters *chg_params;
 	const struct abx500_fg_parameters *fg_params;
 };
 
-struct abx500_chargalg_platform_data {
-	char **supplied_to;
-	size_t num_supplicants;
-};
-
-struct abx500_charger_platform_data {
-	char **supplied_to;
-	size_t num_supplicants;
-	bool autopower_cfg;
-};
+extern struct abx500_bm_data ab8500_bm_data;
 
-struct abx500_btemp_platform_data {
-	char **supplied_to;
-	size_t num_supplicants;
+struct abx500_bmdevs_plat_data {
+	char	**supplied_to;
+	size_t	num_supplicants;
+	bool	autopower_cfg;
 };
 
-struct abx500_fg_platform_data {
-	char **supplied_to;
-	size_t num_supplicants;
+enum {
+	NTC_EXTERNAL = 0,
+	NTC_INTERNAL,
 };
 
-struct abx500_bm_plat_data {
-	struct abx500_bm_data *battery;
-	struct abx500_charger_platform_data *charger;
-	struct abx500_btemp_platform_data *btemp;
-	struct abx500_fg_platform_data *fg;
-	struct abx500_chargalg_platform_data *chargalg;
-};
+int bmdevs_of_probe(struct device *dev,
+		struct device_node *np,
+		struct abx500_bm_data **battery);
 
 int abx500_set_register_interruptible(struct device *dev, u8 bank, u8 reg,
 	u8 value);
-- 
1.7.10.4

