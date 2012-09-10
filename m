Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab2IJJob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:44:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60212 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2IJJo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:44:29 -0400
MIME-Version: 1.0
Date: Mon, 10 Sep 2012 15:14:29 +0530
Message-ID: <CAB4BAkvdwEDViLGXfHHzYjkoL6qPZca2dzOin3GhBrqRJ3xNAg@mail.gmail.com>
Subject: [PATCH] mfd: Implement devicetree support for AB8500 fg
From: Rajanikanth HV <rajanikanth.hv@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        linus.walleij@stericsson.com, STEricsson_nomadik_linux@list.st.com,
        linaro-dev@lists.linaro.org, Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support for
fuel guage driver

Signed-off-by: Rajanikanth H.V <rajanikanth.hv@stericsson.com>
---
 Documentation/devicetree/bindings/mfd/ab8500.txt   |    8 +-
 .../devicetree/bindings/power_supply/ab8500/fg.txt |   61 +++
 arch/arm/boot/dts/dbx5x0.dtsi                      |    8 +
 drivers/mfd/ab8500-core.c                          |    1 +
 drivers/power/Makefile                             |    2 +-
 drivers/power/ab8500_bmdata.h                      |  442 ++++++++++++++++++++
 drivers/power/ab8500_fg.c                          |  148 ++++++-
 include/linux/mfd/abx500.h                         |    2 +-
 8 files changed, 664 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
 create mode 100644 drivers/power/ab8500_bmdata.h

diff --git a/Documentation/devicetree/bindings/mfd/ab8500.txt
b/Documentation/devicetree/bindings/mfd/ab8500.txt
index ce83c8d..762dc11 100644
--- a/Documentation/devicetree/bindings/mfd/ab8500.txt
+++ b/Documentation/devicetree/bindings/mfd/ab8500.txt
@@ -24,7 +24,13 @@ ab8500-bm                :                      :
           : Battery Manager
 ab8500-btemp             :                      :              :
Battery Temperature
 ab8500-charger           :                      :              :
Battery Charger
 ab8500-codec             :                      :              : Audio Codec
-ab8500-fg                :                      :              : Fuel Gauge
+ab8500-fg                : 			: vddadc       : Fuel Gauge
+			 : NCONV_ACCU           :	       : Accumulate N Sample Conversion
+			 : BATT_OVV		:	       : Battery Over Voltage
+			 : LOW_BAT_F		:	       : LOW threshold battery voltage
+			 : CC_INT_CALIB		:	       : Counter Counter Internal Calibration
+			 : CCEOC		:	       : Coulomb Counter End of Conversion
+			 :			:	       :
 ab8500-gpadc             : HW_CONV_END          : vddadc       :
Analogue to Digital Converter
                            SW_CONV_END          :              :
 ab8500-gpio              :                      :              : GPIO
Controller
diff --git a/Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
b/Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
new file mode 100644
index 0000000..c2c122e
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
@@ -0,0 +1,61 @@
+=== AB8500 Fuel Gauge Driver ===
+
+AB8500 is a mixed signal multimedia and power management
+device comprising: power and energy-management-module,
+wall-charger, usb-charger, audio codec, general purpose adc,
+tvout, clock management and sim card interface.
+
+Fuel-guage support is part of energy-management-module, the other
+components of this module are:
+main-charger, usb-combo-charger and Battery temperature monitoring.
+
+The properties below describes the node for fuel guage driver.
+
+Required Properties:
+- compatible = "stericsson,ab8500-fg"
+
+supplied-to:
+	This is a logical binding w.r.t power supply event change
+	across energy-management-module drivers where in the
+	runtime battery properties are shared along with uevent
+	notification.
+	ref: di->fg.external_power_changed =
+		ab8500_fg_external_power_changed;
+		ab8500_fg.c
+
+	Need for this property:
+		btemp, fg and charger updates power-supply properties
+		based on the events listed above.
+		Event handler invokes power supply change notifier
+		which in-turn invokes registered power supply class call-back
+		based on the 'supplied_to' string.
+		ref:
+		power_supply_changed_work(..) ./drivers/power/power_supply_core.c
+
+	example:
+	ab8500-fg {
+		/* Other enery management module */
+		supplied_to = "ab8500_chargalg", "ab8500_usb";
+		num_supplicants = <2>;
+	};
+
+thermister-interface:
+	'btemp' and 'batctrl' are the pins interfaced for battery temperature
+	measurement, btemp is used when NTC(negative temperature coefficient)
+	resister is interfaced external to battery and batctrl is used when
+	NTC resister is internal to battery.
+
+
+li-ion-9100-battery:
+	use this to add support for the 9100 Li-ION battery,
+	this adjust the bkup battery charger parameters
+	Note: this property is used for tablet version of snowball board.
+
+	example:
+	ab8500-fg {
+		thermister-internal-to-battery = <1>;
+		li_ion_9100_battery = <0>;
+	};
+Note:
+interrupts are defined and registered in the driver
+
diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 7d84f46..d69c087 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -352,6 +352,14 @@
 					vddadc-supply = <&ab8500_ldo_tvout_reg>;
 				};

+				ab8500-fg {
+					compatible = "stericsson,ab8500-fg";
+					supplied_to = "ab8500_chargalg", "ab8500_usb";
+					num_supplicants = <2>;
+					thermister_on_batctrl = <1>;
+					li_ion_9100  = <0>;
+				};
+
 				ab8500-usb {
 					compatible = "stericsson,ab8500-usb";
 					interrupts = < 90 0x4
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 71a7757..c413cfa 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1052,6 +1052,7 @@ static struct mfd_cell __devinitdata ab8500_bm_devs[] = {
 	},
 	{
 		.name = "ab8500-fg",
+		.of_compatible = "stericsson,ab8500-fg",
 		.num_resources = ARRAY_SIZE(ab8500_fg_resources),
 		.resources = ab8500_fg_resources,
 	},
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index ee58afb..ed73e11 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -34,7 +34,7 @@ obj-$(CONFIG_BATTERY_S3C_ADC)	+= s3c_adc_battery.o
 obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
 obj-$(CONFIG_BATTERY_JZ4740)	+= jz4740-battery.o
 obj-$(CONFIG_BATTERY_INTEL_MID)	+= intel_mid_battery.o
-obj-$(CONFIG_AB8500_BM)		+= ab8500_charger.o ab8500_btemp.o
ab8500_fg.o abx500_chargalg.o
+obj-$(CONFIG_AB8500_BM)		+= ab8500_charger.o ab8500_fg.o
ab8500_btemp.o abx500_chargalg.o
 obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
 obj-$(CONFIG_CHARGER_MAX8903)	+= max8903_charger.o
 obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
diff --git a/drivers/power/ab8500_bmdata.h b/drivers/power/ab8500_bmdata.h
new file mode 100644
index 0000000..748334a
--- /dev/null
+++ b/drivers/power/ab8500_bmdata.h
@@ -0,0 +1,442 @@
+/*
+ * These are the defined batteries that uses a NTC and ID resistor placed
+ * inside of the battery pack.
+ * Note that the res_to_temp table must be strictly sorted by falling
resistance
+ * values to work.
+ */
+static struct abx500_res_to_temp temp_tbl_A_thermister[] = {
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
+static struct abx500_res_to_temp temp_tbl_B_thermister[] = {
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
+static struct abx500_v_to_cap cap_tbl_A_thermister[] = {
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
+static struct abx500_v_to_cap cap_tbl_B_thermister[] = {
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
+static struct batres_vs_temp temp_to_batres_tbl_thermister[] = {
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
+static struct batres_vs_temp temp_to_batres_tbl_ext_thermister[] = {
+	{ 60, 300},
+	{ 30, 300},
+	{ 20, 300},
+	{ 10, 300},
+	{ 00, 300},
+	{-10, 300},
+	{-20, 300},
+};
+/* battery resistance table for LI ION 9100 battery */
+static struct batres_vs_temp temp_to_batres_tbl_9100[] = {
+	{ 60, 180},
+	{ 30, 180},
+	{ 20, 180},
+	{ 10, 180},
+	{ 00, 180},
+	{-10, 180},
+	{-20, 180},
+};
+
+static struct abx500_battery_type bat_type_thermister[] = {
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
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermister),
+	.batres_tbl = temp_to_batres_tbl_thermister,
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
+	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_A_thermister),
+	.r_to_t_tbl = temp_tbl_A_thermister,
+	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_A_thermister),
+	.v_to_cap_tbl = cap_tbl_A_thermister,
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermister),
+	.batres_tbl = temp_to_batres_tbl_thermister,
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
+	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_B_thermister),
+	.r_to_t_tbl = temp_tbl_B_thermister,
+	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_B_thermister),
+	.v_to_cap_tbl = cap_tbl_B_thermister,
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermister),
+	.batres_tbl = temp_to_batres_tbl_thermister,
+},
+};
+
+static struct abx500_battery_type bat_type_ext_thermister[] = {
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
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermister),
+	.batres_tbl = temp_to_batres_tbl_thermister,
+},
+/*
+ * These are the batteries that doesn't have an internal NTC resistor
to measure
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
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermister),
+	.batres_tbl = temp_to_batres_tbl_thermister,
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
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermister),
+	.batres_tbl = temp_to_batres_tbl_thermister,
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
+	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermister),
+	.batres_tbl = temp_to_batres_tbl_thermister,
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
+static struct abx500_bm_data ab8500_bm_data = {
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
+	.bat_type		= bat_type_thermister,
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
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index bf02225..4984dc8 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -25,12 +25,14 @@
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/abx500.h>
 #include <linux/slab.h>
+#include <linux/of.h>
 #include <linux/mfd/abx500/ab8500-bm.h>
 #include <linux/delay.h>
 #include <linux/mfd/abx500/ab8500-gpadc.h>
 #include <linux/mfd/abx500.h>
 #include <linux/time.h>
 #include <linux/completion.h>
+#include "ab8500_bmdata.h"

 #define MILLI_TO_MICRO			1000
 #define FG_LSB_IN_MA			1627
@@ -544,14 +546,14 @@ cc_err:
 		ret = abx500_set_register_interruptible(di->dev,
 			AB8500_GAS_GAUGE, AB8500_GASG_CC_NCOV_ACCU,
 			SEC_TO_SAMPLE(10));
-		if (ret)
+		if (ret < 0)
 			goto fail;

 		/* Start the CC */
 		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
 			AB8500_RTC_CC_CONF_REG,
 			(CC_DEEP_SLEEP_ENA | CC_PWR_UP_ENA));
-		if (ret)
+		if (ret < 0)
 			goto fail;
 	} else {
 		di->turn_off_fg = false;
@@ -2442,16 +2444,145 @@ static struct ab8500_fg_interrupts ab8500_fg_irq[] = {
 	{"CCEOC", ab8500_fg_cc_data_end_handler},
 };

+static int __devinit
+fg_of_probe(struct device *dev,
+		struct device_node *np,
+		struct abx500_bm_plat_data *bm_pdata)
+{
+	u8	val;
+	u32	pval;
+	int	i;
+	int	ext_thermister, lion_battery, ret = 0;
+	const char *bm_dev_name;
+	struct	abx500_fg_platform_data *fg = bm_pdata->fg;
+	struct	abx500_bm_data		   *bat;
+	struct	abx500_battery_type	   *btype;
+
+	ret = of_property_read_u32(np, "num_supplicants", &pval);
+	if (ret) {
+		dev_err(dev, "missing property num_supplicants\n");
+		ret = -EINVAL;
+		goto inval_pval;
+	}
+	fg->num_supplicants = pval;
+	fg->supplied_to =
+		devm_kzalloc(dev, fg->num_supplicants *
+			sizeof(const char *), GFP_KERNEL);
+	if (fg->supplied_to == NULL) {
+		dev_err(dev, "%s no mem for supplied_to\n", __func__);
+		ret = -ENOMEM;
+		goto inval_pval;
+	}
+	for (val = 0; val < fg->num_supplicants; ++val)
+		if (of_property_read_string_index
+			(np, "supplied_to", val, &bm_dev_name) == 0)
+			*(fg->supplied_to + val) = (char *)bm_dev_name;
+		else {
+			dev_err(dev, "insufficient number of supplied_to data found\n");
+			ret = -EINVAL;
+			goto free_dev_mem;
+		}
+	ret = of_property_read_u32(np, "thermister_on_batctrl", &pval);
+	if (ret) {
+		dev_err(dev, "missing property thermister_on_batctrl\n");
+		ret = -EINVAL;
+		goto free_dev_mem;
+	}
+	bm_pdata->battery = &ab8500_bm_data;
+	bat = bm_pdata->battery;
+	ext_thermister = 0;
+	if (pval == 0) {
+		bat->n_btypes = 4;
+		bat->bat_type = bat_type_ext_thermister;
+		bat->adc_therm = ABx500_ADC_THERM_BATTEMP;
+		ext_thermister = 1;
+	}
+	ret = of_property_read_u32(np, "li_ion_9100", &pval);
+	if (ret) {
+		dev_err(dev, "missing property li_ion_9100\n");
+		ret = -EINVAL;
+		goto free_dev_mem;
+	}
+	lion_battery = 0;
+	if (pval == 1) {
+		bat->no_maintenance = true;
+		bat->chg_unknown_bat = true;
+		bat->bat_type[BATTERY_UNKNOWN].charge_full_design = 2600;
+		bat->bat_type[BATTERY_UNKNOWN].termination_vol = 4150;
+		bat->bat_type[BATTERY_UNKNOWN].recharge_vol = 4130;
+		bat->bat_type[BATTERY_UNKNOWN].normal_cur_lvl = 520;
+		bat->bat_type[BATTERY_UNKNOWN].normal_vol_lvl = 4200;
+		lion_battery = 1;
+	}
+	/* select the battery resolution table */
+	for (i = 0; i < bat->n_btypes; ++i) {
+		btype = (bat->bat_type + i);
+		if (ext_thermister) {
+			btype->batres_tbl =
+				temp_to_batres_tbl_ext_thermister;
+		} else if (lion_battery) {
+			btype->batres_tbl =
+				temp_to_batres_tbl_9100;
+		} else {
+			btype->batres_tbl =
+				temp_to_batres_tbl_thermister;
+		}
+	}
+	return ret;
+free_dev_mem:
+	devm_kfree(dev, fg->supplied_to);
+inval_pval:
+	return ret;
+}
+
 static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 {
 	int i, irq;
 	int ret = 0;
 	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
 	struct ab8500_fg *di;

+	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
+	if (!di) {
+		dev_err(&pdev->dev, "%s no mem for ab8500_btemp\n", __func__);
+		ret = -ENOMEM;
+		goto err_no_mem;
+	}
+	if (np) {
+		if (!plat_data) {
+			plat_data =
+			devm_kzalloc(&pdev->dev, sizeof(*plat_data), GFP_KERNEL);
+			if (!plat_data) {
+				dev_err(&pdev->dev,
+					"%s no mem for plat_data\n", __func__);
+				ret = -ENOMEM;
+				goto free_device_info;
+			}
+			plat_data->fg = devm_kzalloc(&pdev->dev,
+					sizeof(*plat_data->fg), GFP_KERNEL);
+			if (!plat_data->fg) {
+				devm_kfree(&pdev->dev, plat_data);
+				dev_err(&pdev->dev,
+					"%s no mem for pdata->fg\n",
+					__func__);
+				ret = -ENOMEM;
+				goto free_device_info;
+			}
+		}
+		/* get battery specific platform data */
+		ret = fg_of_probe(&pdev->dev, np, plat_data);
+		if (ret) {
+			devm_kfree(&pdev->dev, plat_data->fg);
+			devm_kfree(&pdev->dev, plat_data);
+			goto free_device_info;
+		}
+	}
 	if (!plat_data) {
-		dev_err(&pdev->dev, "No platform data\n");
-		return -EINVAL;
+		dev_err(&pdev->dev,
+			"%s no fg platform data found\n", __func__);
+		ret = -EINVAL;
+		goto free_device_info;
 	}

 	di = kzalloc(sizeof(*di), GFP_KERNEL);
@@ -2606,11 +2737,17 @@ free_irq:
 free_inst_curr_wq:
 	destroy_workqueue(di->fg_wq);
 free_device_info:
-	kfree(di);
+	devm_kfree(&pdev->dev, di);
+err_no_mem:

 	return ret;
 }

+static const struct of_device_id ab8500_fg_match[] = {
+	{.compatible = "stericsson,ab8500-fg",},
+	{},
+};
+
 static struct platform_driver ab8500_fg_driver = {
 	.probe = ab8500_fg_probe,
 	.remove = __devexit_p(ab8500_fg_remove),
@@ -2619,6 +2756,7 @@ static struct platform_driver ab8500_fg_driver = {
 	.driver = {
 		.name = "ab8500-fg",
 		.owner = THIS_MODULE,
+		.of_match_table = ab8500_fg_match,
 	},
 };

diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 1318ca6..ac4f590 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -382,7 +382,7 @@ struct abx500_bm_data {
 	int gnd_lift_resistance;
 	const struct abx500_maxim_parameters *maxi;
 	const struct abx500_bm_capacity_levels *cap_levels;
-	const struct abx500_battery_type *bat_type;
+	struct abx500_battery_type *bat_type;
 	const struct abx500_bm_charger_parameters *chg_params;
 	const struct abx500_fg_parameters *fg_params;
 };
-- 
1.7.9.5
