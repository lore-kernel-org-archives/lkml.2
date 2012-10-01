Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2JAJti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:49:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51698 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2JAJtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:49:36 -0400
Date: Mon, 1 Oct 2012 10:49:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
Cc: francescolavra.fl@gmail.com, arnd@arndb.de, anton.vorontsov@linaro.org,
        linus.walleij@stericsson.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 1/4] mfd: ab8500: add devicetree support for fuelgauge
Message-ID: <20121001094929.GB6682@gmail.com>
References: <1349064513-31301-1-git-send-email-rajanikanth.hv@stericsson.com>
 <1349064513-31301-2-git-send-email-rajanikanth.hv@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1349064513-31301-2-git-send-email-rajanikanth.hv@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Oct 2012, Rajanikanth H.V wrote:

> From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
> 
> - This patch adds device tree support for fuelguage driver
> - optimize bm devices platform_data usage and of_probe(...)
>   Note: of_probe() routine for battery managed devices is made
>   common across all bm drivers.
> 
> Signed-off-by: Rajanikanth H.V <rajanikanth.hv@stericsson.com>
> ---
>  Documentation/devicetree/bindings/mfd/ab8500.txt   |    8 +-
>  .../devicetree/bindings/power_supply/ab8500/fg.txt |   86 +++
>  arch/arm/boot/dts/dbx5x0.dtsi                      |   22 +-
>  drivers/mfd/ab8500-core.c                          |    1 +
>  drivers/power/Makefile                             |    2 +-
>  drivers/power/ab8500_bmdata.c                      |  549 ++++++++++++++++++++
>  drivers/power/ab8500_btemp.c                       |    4 +-
>  drivers/power/ab8500_charger.c                     |    4 +-
>  drivers/power/ab8500_fg.c                          |   76 ++-
>  drivers/power/abx500_chargalg.c                    |    4 +-
>  include/linux/mfd/abx500.h                         |   37 +-
>  include/linux/mfd/abx500/ab8500-bm.h               |    7 +
>  12 files changed, 744 insertions(+), 56 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
>  create mode 100644 drivers/power/ab8500_bmdata.c
> 
> diff --git a/Documentation/devicetree/bindings/mfd/ab8500.txt b/Documentation/devicetree/bindings/mfd/ab8500.txt
> index ce83c8d..762dc11 100644
> --- a/Documentation/devicetree/bindings/mfd/ab8500.txt
> +++ b/Documentation/devicetree/bindings/mfd/ab8500.txt
> @@ -24,7 +24,13 @@ ab8500-bm                :                      :              : Battery Manager
>  ab8500-btemp             :                      :              : Battery Temperature
>  ab8500-charger           :                      :              : Battery Charger
>  ab8500-codec             :                      :              : Audio Codec
> -ab8500-fg                :                      :              : Fuel Gauge
> +ab8500-fg                : 			: vddadc       : Fuel Gauge
> +			 : NCONV_ACCU           :	       : Accumulate N Sample Conversion
> +			 : BATT_OVV		:	       : Battery Over Voltage
> +			 : LOW_BAT_F		:	       : LOW threshold battery voltage
> +			 : CC_INT_CALIB		:	       : Counter Counter Internal Calibration

I think you mean: Coulomb Counter.

> +			 : CCEOC		:	       : Coulomb Counter End of Conversion
> +			 :			:	       :

Random empty entry.

>  ab8500-gpadc             : HW_CONV_END          : vddadc       : Analogue to Digital Converter
>                             SW_CONV_END          :              :
>  ab8500-gpio              :                      :              : GPIO Controller
> diff --git a/Documentation/devicetree/bindings/power_supply/ab8500/fg.txt b/Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
> new file mode 100644
> index 0000000..caa33b0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_supply/ab8500/fg.txt
> @@ -0,0 +1,86 @@
> +=== AB8500 Fuel Gauge Driver ===
> +
> +AB8500 is a mixed signal multimedia and power management
> +device comprising: power and energy-management-module,
> +wall-charger, usb-charger, audio codec, general purpose adc,
> +tvout, clock management and sim card interface.
> +
> +Fuel-guage support is part of energy-management-module, the other

Spelling.

> +components of this module are:
> +main-charger, usb-combo-charger and Battery temperature monitoring.
> +
> +The properties below describes the node for fuel guage driver.

Spelling.

> +
> +Required Properties:
> +- compatible = "stericsson,ab8500-fg"
> +- interface-name:
> +	Name of the controller/driver which is part of energy-management-module
> +- supplied-to:

Still not sure about this property, or your justification for use.

> +	This property shall have dependent nodes which represent other
> +	energy-management-module.

Plural?

> +	This is a logical binding w.r.t power supply events

Proper English please, no slang.

> +	across energy-management-module drivers where-in, the

Ill placed comma?

> +	runtime battery properties are shared along with uevent
> +	notification.

Plural?

> +	ref: di->fg.external_power_changed =
> +		ab8500_fg_external_power_changed;
> +		ab8500_fg.c
> +
> +	Need for this property:
> +		energy-management-module driver updates power-supply properties
> +		which are subset of events listed in 'enum power_supply_property',
> +		ref: power_supply.h file
> +		Event handler invokes power supply change notifier
> +		which in-turn invokes registered power supply class call-back
> +		based on the 'supplied-to' string.
> +		ref:
> +		power_supply_changed_work(..) ./drivers/power/power_supply_core.c
> +		di->fg_psy.external_power_changed
> +
> +	example:
> +	ab8500-fg {
> +		/* dependent energy management modules */
> +		supplied-to  = <&ab8500_chargalg &ab8500_usb>;
> +	};
> +
> +	ab8500_battery_info: ab8500_bat_type {
> +		battery-type = <2>;
> +		thermistor-on-batctrl = <1>;

You have this as a bool here, and ...
> +	};
> +
> +Other dependent node for fuel-gauge is:
> +	ab8500_battery_info: ab8500_bat_type {
> +	};
> +	This node will provide information on 'thermistor interface' and
> +	'battery technology type' used.
> +
> +Properties of this node are:
> +thermistor-on-batctrl:
> +	A boolean value indicating thermistor interface	to battery
> +
> +	Note:
> +	'btemp' and 'batctrl' are the pins interfaced for battery temperature
> +	measurement, 'btemp' signal is used when NTC(negative temperature
> +	coefficient) resister is interfaced external to battery whereas
> +	'batctrl' pin is used when NTC resister is internal to battery.
> +
> +	e.g:
> +	ab8500_battery_info: ab8500_bat_type {
> +		thermistor-on-batctrl;

... a standard property here. I suggest you drop the bool value.

> +	};
> +	indiactes: NTC resister is internal to battery, 'batctrl' is used
> +		for thermal measurement.
> +
> +	The absence of property 'thermal-on-batctrl' indicates
> +	NTC resister is external to battery and  'btemp' signal is used
> +	for thermal measurement.
> +
> +battery-type:
> +	This shall be the battery manufacturing technology type,
> +	allowed types are:
> +		"UNKNOWN" "NiMH" "LION" "LIPO" "LiFe" "NiCd" "LiMn"
> +	e.g:
> +	ab8500_battery_info: ab8500_bat_type {
> +		battery-name = "LION";
> +	}
> +
> diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
> index 748ba7a..bd22c56 100644
> --- a/arch/arm/boot/dts/dbx5x0.dtsi
> +++ b/arch/arm/boot/dts/dbx5x0.dtsi
> @@ -352,8 +352,28 @@
>  					vddadc-supply = <&ab8500_ldo_tvout_reg>;
>  				};
>  
> -				ab8500-usb {
> +				ab8500_battery_info: ab8500_bat_type {
> +					battery-name = "LION";

All new properties have to be documented.

Vendor specific properties should be prepended with the vendor name, so
either write a generic binding document for all to use or prefix with
'stericsson,".

> +					thermistor-on-batctrl;
> +				};
> +
> +				ab8500_chargalg: ab8500_chalg {
> +					compatible     = "stericsson,ab8500-chargalg";
> +					interface-name = "ab8500_chargalg";

Same with all of your new properties (I'll stop mentioning them now).

> +					battery-info   = <&ab8500_battery_info>;
> +					supplied-to    = <&ab8500_fuel_gauge>;

Weren't you going to reverse this logic to be more inline with how
the reset of Device Tree works?

> +				};
> +
> +				ab8500_fuel_gauge: ab8500_fg {
> +					compatible     = "stericsson,ab8500-fg";
> +					interface-name = "ab8500_fg";
> +					battery-info   = <&ab8500_battery_info>;
> +					supplied-to    = <&ab8500_chargalg &ab8500_usb>;

As above.

> +				};
> +
> +				ab8500_usb: ab8500_usb_if {

What does 'if' mean?

>  					compatible = "stericsson,ab8500-usb";
> +					interface-name = "ab8500_usb";

Why is this required?

>  					interrupts = < 90 0x4
>  						       96 0x4
>  						       14 0x4
> diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
> index 1667c77..6c3d7c2 100644
> --- a/drivers/mfd/ab8500-core.c
> +++ b/drivers/mfd/ab8500-core.c
> @@ -1051,6 +1051,7 @@ static struct mfd_cell __devinitdata ab8500_bm_devs[] = {
>  	},
>  	{
>  		.name = "ab8500-fg",
> +		.of_compatible = "stericsson,ab8500-fg",
>  		.num_resources = ARRAY_SIZE(ab8500_fg_resources),
>  		.resources = ab8500_fg_resources,
>  	},
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index ee58afb..2c58d4e 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -34,7 +34,7 @@ obj-$(CONFIG_BATTERY_S3C_ADC)	+= s3c_adc_battery.o
>  obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
>  obj-$(CONFIG_BATTERY_JZ4740)	+= jz4740-battery.o
>  obj-$(CONFIG_BATTERY_INTEL_MID)	+= intel_mid_battery.o
> -obj-$(CONFIG_AB8500_BM)		+= ab8500_charger.o ab8500_btemp.o ab8500_fg.o abx500_chargalg.o
> +obj-$(CONFIG_AB8500_BM)		+= ab8500_bmdata.o ab8500_charger.o ab8500_fg.o ab8500_btemp.o abx500_chargalg.o
>  obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
>  obj-$(CONFIG_CHARGER_MAX8903)	+= max8903_charger.o
>  obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
> diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
> new file mode 100644
> index 0000000..d0def3b
> --- /dev/null
> +++ b/drivers/power/ab8500_bmdata.c
> @@ -0,0 +1,549 @@
> +#include <linux/export.h>
> +#include <linux/power_supply.h>
> +#include <linux/of.h>
> +#include <linux/mfd/abx500.h>
> +#include <linux/mfd/abx500/ab8500.h>
> +#include <linux/mfd/abx500/ab8500-bm.h>
> +
> +/*
> + * These are the defined batteries that uses a NTC and ID resistor placed
> + * inside of the battery pack.
> + * Note that the res_to_temp table must be strictly sorted by falling resistance
> + * values to work.
> + */
> +static struct abx500_res_to_temp temp_tbl_A_thermistor[] = {
> +	{-5, 53407},
> +	{ 0, 48594},
> +	{ 5, 43804},
> +	{10, 39188},
> +	{15, 34870},
> +	{20, 30933},
> +	{25, 27422},
> +	{30, 24347},
> +	{35, 21694},
> +	{40, 19431},
> +	{45, 17517},
> +	{50, 15908},
> +	{55, 14561},
> +	{60, 13437},
> +	{65, 12500},
> +};
> +static struct abx500_res_to_temp temp_tbl_B_thermistor[] = {
> +	{-5, 165418},
> +	{ 0, 159024},
> +	{ 5, 151921},
> +	{10, 144300},
> +	{15, 136424},
> +	{20, 128565},
> +	{25, 120978},
> +	{30, 113875},
> +	{35, 107397},
> +	{40, 101629},
> +	{45,  96592},
> +	{50,  92253},
> +	{55,  88569},
> +	{60,  85461},
> +	{65,  82869},
> +};
> +static struct abx500_v_to_cap cap_tbl_A_thermistor[] = {
> +	{4171,	100},
> +	{4114,	 95},
> +	{4009,	 83},
> +	{3947,	 74},
> +	{3907,	 67},
> +	{3863,	 59},
> +	{3830,	 56},
> +	{3813,	 53},
> +	{3791,	 46},
> +	{3771,	 33},
> +	{3754,	 25},
> +	{3735,	 20},
> +	{3717,	 17},
> +	{3681,	 13},
> +	{3664,	  8},
> +	{3651,	  6},
> +	{3635,	  5},
> +	{3560,	  3},
> +	{3408,    1},
> +	{3247,	  0},
> +};
> +static struct abx500_v_to_cap cap_tbl_B_thermistor[] = {
> +	{4161,	100},
> +	{4124,	 98},
> +	{4044,	 90},
> +	{4003,	 85},
> +	{3966,	 80},
> +	{3933,	 75},
> +	{3888,	 67},
> +	{3849,	 60},
> +	{3813,	 55},
> +	{3787,	 47},
> +	{3772,	 30},
> +	{3751,	 25},
> +	{3718,	 20},
> +	{3681,	 16},
> +	{3660,	 14},
> +	{3589,	 10},
> +	{3546,	  7},
> +	{3495,	  4},
> +	{3404,	  2},
> +	{3250,	  0},
> +};
> +
> +static struct abx500_v_to_cap cap_tbl[] = {
> +	{4186,	100},
> +	{4163,	 99},
> +	{4114,	 95},
> +	{4068,	 90},
> +	{3990,	 80},
> +	{3926,	 70},
> +	{3898,	 65},
> +	{3866,	 60},
> +	{3833,	 55},
> +	{3812,	 50},
> +	{3787,	 40},
> +	{3768,	 30},
> +	{3747,	 25},
> +	{3730,	 20},
> +	{3705,	 15},
> +	{3699,	 14},
> +	{3684,	 12},
> +	{3672,	  9},
> +	{3657,	  7},
> +	{3638,	  6},
> +	{3556,	  4},
> +	{3424,	  2},
> +	{3317,	  1},
> +	{3094,	  0},
> +};
> +
> +/*
> + * Note that the res_to_temp table must be strictly sorted by falling
> + * resistance values to work.
> + */
> +static struct abx500_res_to_temp temp_tbl[] = {
> +	{-5, 214834},
> +	{ 0, 162943},
> +	{ 5, 124820},
> +	{10,  96520},
> +	{15,  75306},
> +	{20,  59254},
> +	{25,  47000},
> +	{30,  37566},
> +	{35,  30245},
> +	{40,  24520},
> +	{45,  20010},
> +	{50,  16432},
> +	{55,  13576},
> +	{60,  11280},
> +	{65,   9425},
> +};
> +
> +/*
> + * Note that the batres_vs_temp table must be strictly sorted by falling
> + * temperature values to work.
> + */
> +struct batres_vs_temp temp_to_batres_tbl_thermistor[] = {
> +	{ 40, 120},
> +	{ 30, 135},
> +	{ 20, 165},
> +	{ 10, 230},
> +	{ 00, 325},
> +	{-10, 445},
> +	{-20, 595},
> +};
> +
> +/*
> + * Note that the batres_vs_temp table must be strictly sorted by falling
> + * temperature values to work.
> + */
> +struct batres_vs_temp temp_to_batres_tbl_ext_thermistor[] = {
> +	{ 60, 300},
> +	{ 30, 300},
> +	{ 20, 300},
> +	{ 10, 300},
> +	{ 00, 300},
> +	{-10, 300},
> +	{-20, 300},
> +};
> +
> +/* battery resistance table for LI ION 9100 battery */
> +struct batres_vs_temp temp_to_batres_tbl_9100[] = {
> +	{ 60, 180},
> +	{ 30, 180},
> +	{ 20, 180},
> +	{ 10, 180},
> +	{ 00, 180},
> +	{-10, 180},
> +	{-20, 180},
> +};
> +
> +struct abx500_battery_type bat_type_thermistor[] = {
> +[BATTERY_UNKNOWN] = {
> +	/* First element always represent the UNKNOWN battery */
> +	.name = POWER_SUPPLY_TECHNOLOGY_UNKNOWN,
> +	.resis_high = 0,
> +	.resis_low = 0,
> +	.battery_resistance = 300,
> +	.charge_full_design = 612,
> +	.nominal_voltage = 3700,
> +	.termination_vol = 4050,
> +	.termination_curr = 200,
> +	.recharge_vol = 3990,
> +	.normal_cur_lvl = 400,
> +	.normal_vol_lvl = 4100,
> +	.maint_a_cur_lvl = 400,
> +	.maint_a_vol_lvl = 4050,
> +	.maint_a_chg_timer_h = 60,
> +	.maint_b_cur_lvl = 400,
> +	.maint_b_vol_lvl = 4000,
> +	.maint_b_chg_timer_h = 200,
> +	.low_high_cur_lvl = 300,
> +	.low_high_vol_lvl = 4000,
> +	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
> +	.r_to_t_tbl = temp_tbl,
> +	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
> +	.v_to_cap_tbl = cap_tbl,
> +	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
> +	.batres_tbl = temp_to_batres_tbl_thermistor,
> +},
> +{
> +	.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
> +	.resis_high = 53407,
> +	.resis_low = 12500,
> +	.battery_resistance = 300,
> +	.charge_full_design = 900,
> +	.nominal_voltage = 3600,
> +	.termination_vol = 4150,
> +	.termination_curr = 80,
> +	.recharge_vol = 4130,
> +	.normal_cur_lvl = 700,
> +	.normal_vol_lvl = 4200,
> +	.maint_a_cur_lvl = 600,
> +	.maint_a_vol_lvl = 4150,
> +	.maint_a_chg_timer_h = 60,
> +	.maint_b_cur_lvl = 600,
> +	.maint_b_vol_lvl = 4100,
> +	.maint_b_chg_timer_h = 200,
> +	.low_high_cur_lvl = 300,
> +	.low_high_vol_lvl = 4000,
> +	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_A_thermistor),
> +	.r_to_t_tbl = temp_tbl_A_thermistor,
> +	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_A_thermistor),
> +	.v_to_cap_tbl = cap_tbl_A_thermistor,
> +	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
> +	.batres_tbl = temp_to_batres_tbl_thermistor,
> +
> +},
> +{
> +	.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
> +	.resis_high = 165418,
> +	.resis_low = 82869,
> +	.battery_resistance = 300,
> +	.charge_full_design = 900,
> +	.nominal_voltage = 3600,
> +	.termination_vol = 4150,
> +	.termination_curr = 80,
> +	.recharge_vol = 4130,
> +	.normal_cur_lvl = 700,
> +	.normal_vol_lvl = 4200,
> +	.maint_a_cur_lvl = 600,
> +	.maint_a_vol_lvl = 4150,
> +	.maint_a_chg_timer_h = 60,
> +	.maint_b_cur_lvl = 600,
> +	.maint_b_vol_lvl = 4100,
> +	.maint_b_chg_timer_h = 200,
> +	.low_high_cur_lvl = 300,
> +	.low_high_vol_lvl = 4000,
> +	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl_B_thermistor),
> +	.r_to_t_tbl = temp_tbl_B_thermistor,
> +	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl_B_thermistor),
> +	.v_to_cap_tbl = cap_tbl_B_thermistor,
> +	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
> +	.batres_tbl = temp_to_batres_tbl_thermistor,
> +},
> +};
> +
> +struct abx500_battery_type bat_type_ext_thermistor[] = {
> +[BATTERY_UNKNOWN] = {
> +	/* First element always represent the UNKNOWN battery */
> +	.name = POWER_SUPPLY_TECHNOLOGY_UNKNOWN,
> +	.resis_high = 0,
> +	.resis_low = 0,
> +	.battery_resistance = 300,
> +	.charge_full_design = 612,
> +	.nominal_voltage = 3700,
> +	.termination_vol = 4050,
> +	.termination_curr = 200,
> +	.recharge_vol = 3990,
> +	.normal_cur_lvl = 400,
> +	.normal_vol_lvl = 4100,
> +	.maint_a_cur_lvl = 400,
> +	.maint_a_vol_lvl = 4050,
> +	.maint_a_chg_timer_h = 60,
> +	.maint_b_cur_lvl = 400,
> +	.maint_b_vol_lvl = 4000,
> +	.maint_b_chg_timer_h = 200,
> +	.low_high_cur_lvl = 300,
> +	.low_high_vol_lvl = 4000,
> +	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
> +	.r_to_t_tbl = temp_tbl,
> +	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
> +	.v_to_cap_tbl = cap_tbl,
> +	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
> +	.batres_tbl = temp_to_batres_tbl_thermistor,
> +},
> +/*
> + * These are the batteries that doesn't have an internal NTC resistor to measure
> + * its temperature. The temperature in this case is measure with a NTC placed
> + * near the battery but on the PCB.
> + */
> +{
> +	.name = POWER_SUPPLY_TECHNOLOGY_LIPO,
> +	.resis_high = 76000,
> +	.resis_low = 53000,
> +	.battery_resistance = 300,
> +	.charge_full_design = 900,
> +	.nominal_voltage = 3700,
> +	.termination_vol = 4150,
> +	.termination_curr = 100,
> +	.recharge_vol = 4130,
> +	.normal_cur_lvl = 700,
> +	.normal_vol_lvl = 4200,
> +	.maint_a_cur_lvl = 600,
> +	.maint_a_vol_lvl = 4150,
> +	.maint_a_chg_timer_h = 60,
> +	.maint_b_cur_lvl = 600,
> +	.maint_b_vol_lvl = 4100,
> +	.maint_b_chg_timer_h = 200,
> +	.low_high_cur_lvl = 300,
> +	.low_high_vol_lvl = 4000,
> +	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
> +	.r_to_t_tbl = temp_tbl,
> +	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
> +	.v_to_cap_tbl = cap_tbl,
> +	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
> +	.batres_tbl = temp_to_batres_tbl_thermistor,
> +},
> +{
> +	.name = POWER_SUPPLY_TECHNOLOGY_LION,
> +	.resis_high = 30000,
> +	.resis_low = 10000,
> +	.battery_resistance = 300,
> +	.charge_full_design = 950,
> +	.nominal_voltage = 3700,
> +	.termination_vol = 4150,
> +	.termination_curr = 100,
> +	.recharge_vol = 4130,
> +	.normal_cur_lvl = 700,
> +	.normal_vol_lvl = 4200,
> +	.maint_a_cur_lvl = 600,
> +	.maint_a_vol_lvl = 4150,
> +	.maint_a_chg_timer_h = 60,
> +	.maint_b_cur_lvl = 600,
> +	.maint_b_vol_lvl = 4100,
> +	.maint_b_chg_timer_h = 200,
> +	.low_high_cur_lvl = 300,
> +	.low_high_vol_lvl = 4000,
> +	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
> +	.r_to_t_tbl = temp_tbl,
> +	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
> +	.v_to_cap_tbl = cap_tbl,
> +	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
> +	.batres_tbl = temp_to_batres_tbl_thermistor,
> +},
> +{
> +	.name = POWER_SUPPLY_TECHNOLOGY_LION,
> +	.resis_high = 95000,
> +	.resis_low = 76001,
> +	.battery_resistance = 300,
> +	.charge_full_design = 950,
> +	.nominal_voltage = 3700,
> +	.termination_vol = 4150,
> +	.termination_curr = 100,
> +	.recharge_vol = 4130,
> +	.normal_cur_lvl = 700,
> +	.normal_vol_lvl = 4200,
> +	.maint_a_cur_lvl = 600,
> +	.maint_a_vol_lvl = 4150,
> +	.maint_a_chg_timer_h = 60,
> +	.maint_b_cur_lvl = 600,
> +	.maint_b_vol_lvl = 4100,
> +	.maint_b_chg_timer_h = 200,
> +	.low_high_cur_lvl = 300,
> +	.low_high_vol_lvl = 4000,
> +	.n_temp_tbl_elements = ARRAY_SIZE(temp_tbl),
> +	.r_to_t_tbl = temp_tbl,
> +	.n_v_cap_tbl_elements = ARRAY_SIZE(cap_tbl),
> +	.v_to_cap_tbl = cap_tbl,
> +	.n_batres_tbl_elements = ARRAY_SIZE(temp_to_batres_tbl_thermistor),
> +	.batres_tbl = temp_to_batres_tbl_thermistor,
> +},
> +};
> +
> +static const struct abx500_bm_capacity_levels cap_levels = {
> +	.critical	= 2,
> +	.low		= 10,
> +	.normal		= 70,
> +	.high		= 95,
> +	.full		= 100,
> +};
> +
> +static const struct abx500_fg_parameters fg = {
> +	.recovery_sleep_timer = 10,
> +	.recovery_total_time = 100,
> +	.init_timer = 1,
> +	.init_discard_time = 5,
> +	.init_total_time = 40,
> +	.high_curr_time = 60,
> +	.accu_charging = 30,
> +	.accu_high_curr = 30,
> +	.high_curr_threshold = 50,
> +	.lowbat_threshold = 3100,
> +	.battok_falling_th_sel0 = 2860,
> +	.battok_raising_th_sel1 = 2860,
> +	.user_cap_limit = 15,
> +	.maint_thres = 97,
> +};
> +
> +static const struct abx500_maxim_parameters maxi_params = {
> +	.ena_maxi = true,
> +	.chg_curr = 910,
> +	.wait_cycles = 10,
> +	.charger_curr_step = 100,
> +};
> +
> +static const struct abx500_bm_charger_parameters chg = {
> +	.usb_volt_max		= 5500,
> +	.usb_curr_max		= 1500,
> +	.ac_volt_max		= 7500,
> +	.ac_curr_max		= 1500,
> +};
> +
> +struct abx500_bm_data ab8500_bm_data = {
> +	.temp_under		= 3,
> +	.temp_low		= 8,
> +	.temp_high		= 43,
> +	.temp_over		= 48,
> +	.main_safety_tmr_h	= 4,
> +	.temp_interval_chg	= 20,
> +	.temp_interval_nochg	= 120,
> +	.usb_safety_tmr_h	= 4,
> +	.bkup_bat_v		= BUP_VCH_SEL_2P6V,
> +	.bkup_bat_i		= BUP_ICH_SEL_150UA,
> +	.no_maintenance		= false,
> +	.adc_therm		= ABx500_ADC_THERM_BATCTRL,
> +	.chg_unknown_bat	= false,
> +	.enable_overshoot	= false,
> +	.fg_res			= 100,
> +	.cap_levels		= &cap_levels,
> +	.bat_type		= bat_type_thermistor,
> +	.n_btypes		= 3,
> +	.batt_id		= 0,
> +	.interval_charging	= 5,
> +	.interval_not_charging	= 120,
> +	.temp_hysteresis	= 3,
> +	.gnd_lift_resistance	= 34,
> +	.maxi			= &maxi_params,
> +	.chg_params		= &chg,
> +	.fg_params		= &fg,
> +};
> +
> +int __devinit
> +bmdevs_of_probe(struct device *dev,
> +		struct device_node *np,
> +		struct abx500_bm_plat_data *pdata)
> +{
> +	int	i, ret = 0, thermistor = NTC_INTERNAL;
> +	const	__be32 *ph;
> +	const	char *bat_tech;
> +	struct	abx500_bm_data		 *bat;
> +	struct	abx500_battery_type	 *btype;
> +	struct  device_node		 *np_bat_supply;
> +	struct  abx500_bmdevs_plat_data  *plat_data = pdata->bmdev_pdata;

<nit> 

This spacing is uncharacteristic of Linux drivers. 

Usually, struct declarations come first.

</nit>

> +	/* get phandle to 'supplied-to' node */

I thought you were going to reverse this?

> +	ph = of_get_property(np, "supplied-to", &plat_data->num_supplicants);
> +	if (ph == NULL) {

if (!ph) {

> +		dev_err(dev, "no supplied_to property specified\n");
> +		return -EINVAL;
> +	}
> +	plat_data->num_supplicants /= sizeof(int);
> +	plat_data->supplied_to =
> +		devm_kzalloc(dev, plat_data->num_supplicants *
> +			sizeof(const char *), GFP_KERNEL);
> +	if (plat_data->supplied_to == NULL) {
> +		dev_err(dev, "%s no mem for supplied-to\n", __func__);
> +		return -ENOMEM;
> +	}
> +	for (i = 0; i < plat_data->num_supplicants; ++i) {
> +		np_bat_supply = of_find_node_by_phandle(be32_to_cpup(ph) + i);

Use: of_parse_phandle(np, "supplied-to", i) instead.

> +		if (np_bat_supply == NULL) {

if (!np_bat_supply) {

> +			dev_err(dev, "invalid supplied_to property\n");
> +			return -EINVAL;
> +		}
> +		ret = of_property_read_string(np_bat_supply, "interface-name",
> +				(const char **)(plat_data->supplied_to + i));
> +		if (ret < 0) {
> +			of_node_put(np_bat_supply);
> +			dev_err(dev, "supply/interface name not found\n");
> +			return ret;
> +		}
> +		dev_dbg(dev, "%s power supply interface_name:%s\n",
> +			__func__, *(plat_data->supplied_to + i));
> +	}

<remove>

> +	/* get phandle to 'battery-info' node */
> +	ph = of_get_property(np, "battery-info", NULL);
> +	if (ph == NULL) {
> +		dev_err(dev, "missing property battery-info\n");
> +		return -EINVAL;
> +	}
> +	np_bat_supply = of_find_node_by_phandle(be32_to_cpup(ph));

</remove>

... and replace with: np_bat_supply = of_parse_phandle(np, "battery-info", 0) instead.

> +	if (np_bat_supply == NULL) {

if (!np_bat_supply) {

I'll not mention this again.

> +		dev_err(dev, "invalid battery-info node\n");
> +		return -EINVAL;
> +	}
> +	if (of_property_read_bool(np_bat_supply,
> +			"thermistor-on-batctrl") == false){

Replace with: 
        if (of_get_property(np_bat_supply, "thermistor-on-batctr", NULL))
	        np_bat_supply =  true;

<remove>

> +		dev_warn(dev, "missing property thermistor-on-batctrl\n");
> +		thermistor = NTC_EXTERNAL;
> +	}

</remove>

> +	pdata->battery = &ab8500_bm_data;
> +	bat = pdata->battery;

Why not: bat = &ab8500_bm_data

Or just use ab8500_bm_data in its own right?

> +	if (thermistor == NTC_EXTERNAL) {
> +		bat->n_btypes  = 4;
> +		bat->bat_type  = bat_type_ext_thermistor;
> +		bat->adc_therm = ABx500_ADC_THERM_BATTEMP;
> +	}
> +	ret = of_property_read_string(np_bat_supply, "battery-name", &bat_tech);
> +	if (ret < 0) {
> +		dev_warn(dev, "missing property battery-name/type\n");
> +		bat_tech = "UNKNOWN";
> +	}
> +	of_node_put(np_bat_supply);
> +	if (strcmp(bat_tech, "LION") == 0) {
> +		bat->no_maintenance  = true;
> +		bat->chg_unknown_bat = true;
> +		bat->bat_type[BATTERY_UNKNOWN].charge_full_design = 2600;
> +		bat->bat_type[BATTERY_UNKNOWN].termination_vol    = 4150;
> +		bat->bat_type[BATTERY_UNKNOWN].recharge_vol	  = 4130;
> +		bat->bat_type[BATTERY_UNKNOWN].normal_cur_lvl	  = 520;
> +		bat->bat_type[BATTERY_UNKNOWN].normal_vol_lvl	  = 4200;
> +	}
> +	/* select the battery resolution table */
> +	for (i = 0; i < bat->n_btypes; ++i) {
> +		btype = (bat->bat_type + i);
> +		if (thermistor == NTC_EXTERNAL) {
> +			btype->batres_tbl =
> +				temp_to_batres_tbl_ext_thermistor;
> +		} else if (strcmp(bat_tech, "LION") == 0) {

Isn't strncmp safer, since you know the size of the comparison?

> +			btype->batres_tbl =
> +				temp_to_batres_tbl_9100;
> +		} else {
> +			btype->batres_tbl =
> +				temp_to_batres_tbl_thermistor;
> +		}
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(bmdevs_of_probe);

Why are you exporting?

> diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
> index bba3cca..8e427e7 100644
> --- a/drivers/power/ab8500_btemp.c
> +++ b/drivers/power/ab8500_btemp.c
> @@ -93,7 +93,7 @@ struct ab8500_btemp {
>  	struct ab8500 *parent;
>  	struct ab8500_gpadc *gpadc;
>  	struct ab8500_fg *fg;
> -	struct abx500_btemp_platform_data *pdata;
> +	struct abx500_bmdevs_plat_data *pdata;
>  	struct abx500_bm_data *bat;
>  	struct power_supply btemp_psy;
>  	struct ab8500_btemp_events events;
> @@ -982,7 +982,7 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
>  	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
>  
>  	/* get btemp specific platform data */
> -	di->pdata = plat_data->btemp;
> +	di->pdata = plat_data->bmdev_pdata;
>  	if (!di->pdata) {
>  		dev_err(di->dev, "no btemp platform data supplied\n");
>  		ret = -EINVAL;
> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
> index d4f0c98..5ff0d83 100644
> --- a/drivers/power/ab8500_charger.c
> +++ b/drivers/power/ab8500_charger.c
> @@ -220,7 +220,7 @@ struct ab8500_charger {
>  	bool autopower;
>  	struct ab8500 *parent;
>  	struct ab8500_gpadc *gpadc;
> -	struct abx500_charger_platform_data *pdata;
> +	struct abx500_bmdevs_plat_data *pdata;
>  	struct abx500_bm_data *bat;
>  	struct ab8500_charger_event_flags flags;
>  	struct ab8500_charger_usb_state usb_state;
> @@ -2555,7 +2555,7 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
>  	spin_lock_init(&di->usb_state.usb_lock);
>  
>  	/* get charger specific platform data */
> -	di->pdata = plat_data->charger;
> +	di->pdata = plat_data->bmdev_pdata;
>  	if (!di->pdata) {
>  		dev_err(di->dev, "no charger platform data supplied\n");
>  		ret = -EINVAL;
> diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
> index bf02225..96741b8 100644
> --- a/drivers/power/ab8500_fg.c
> +++ b/drivers/power/ab8500_fg.c
> @@ -22,15 +22,14 @@
>  #include <linux/platform_device.h>
>  #include <linux/power_supply.h>
>  #include <linux/kobject.h>
> -#include <linux/mfd/abx500/ab8500.h>
> -#include <linux/mfd/abx500.h>
>  #include <linux/slab.h>
> -#include <linux/mfd/abx500/ab8500-bm.h>
>  #include <linux/delay.h>
> -#include <linux/mfd/abx500/ab8500-gpadc.h>
> -#include <linux/mfd/abx500.h>
>  #include <linux/time.h>
>  #include <linux/completion.h>
> +#include <linux/mfd/abx500.h>
> +#include <linux/mfd/abx500/ab8500.h>
> +#include <linux/mfd/abx500/ab8500-bm.h>
> +#include <linux/mfd/abx500/ab8500-gpadc.h>
>  
>  #define MILLI_TO_MICRO			1000
>  #define FG_LSB_IN_MA			1627
> @@ -212,7 +211,7 @@ struct ab8500_fg {
>  	struct ab8500_fg_avg_cap avg_cap;
>  	struct ab8500 *parent;
>  	struct ab8500_gpadc *gpadc;
> -	struct abx500_fg_platform_data *pdata;
> +	struct abx500_bmdevs_plat_data *pdata;
>  	struct abx500_bm_data *bat;
>  	struct power_supply fg_psy;
>  	struct workqueue_struct *fg_wq;
> @@ -544,14 +543,14 @@ cc_err:
>  		ret = abx500_set_register_interruptible(di->dev,
>  			AB8500_GAS_GAUGE, AB8500_GASG_CC_NCOV_ACCU,
>  			SEC_TO_SAMPLE(10));
> -		if (ret)
> +		if (ret < 0)

I don't 'think' this change is required. abx500_set_register_interruptible
will only return !0 on error.

>  			goto fail;
>  
>  		/* Start the CC */
>  		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
>  			AB8500_RTC_CC_CONF_REG,
>  			(CC_DEEP_SLEEP_ENA | CC_PWR_UP_ENA));
> -		if (ret)
> +		if (ret < 0)
>  			goto fail;
>  	} else {
>  		di->turn_off_fg = false;
> @@ -2429,7 +2428,6 @@ static int __devexit ab8500_fg_remove(struct platform_device *pdev)
>  	flush_scheduled_work();
>  	power_supply_unregister(&di->fg_psy);
>  	platform_set_drvdata(pdev, NULL);
> -	kfree(di);
>  	return ret;
>  }
>  
> @@ -2446,18 +2444,47 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
>  {
>  	int i, irq;
>  	int ret = 0;
> -	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
> +	struct abx500_bm_plat_data *plat_data
> +				= pdev->dev.platform_data;
> +	struct device_node *np	= pdev->dev.of_node;
>  	struct ab8500_fg *di;
>  
> +	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
> +	if (!di) {
> +		dev_err(&pdev->dev, "%s no mem for ab8500_fg\n", __func__);
> +		return -ENOMEM;
> +	}
> +	if (np) {
> +		if (!plat_data) {

Change these around.

if (!plat_data) {
        if (np) {
                <snip>
        } else {
                <ERROR>
        }
}

> +			plat_data =
> +			devm_kzalloc(&pdev->dev, sizeof(*plat_data),
> +					GFP_KERNEL);
> +			if (!plat_data) {
> +				dev_err(&pdev->dev,
> +					"%s no mem for plat_data\n", __func__);
> +				return -ENOMEM;
> +			}
> +			plat_data->bmdev_pdata = devm_kzalloc(&pdev->dev,
> +				sizeof(*plat_data->bmdev_pdata), GFP_KERNEL);
> +			if (!plat_data->bmdev_pdata) {
> +				dev_err(&pdev->dev,
> +					"%s no mem for pdata->fg\n",
> +					__func__);
> +				return -ENOMEM;
> +			}
> +		}
> +		ret = bmdevs_of_probe(&pdev->dev, np, plat_data);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev, "failed to get platform data\n");
> +			return ret;
> +		}
> +	}

<remove>

>  	if (!plat_data) {
> -		dev_err(&pdev->dev, "No platform data\n");
> +		dev_err(&pdev->dev,
> +			"%s no fg platform data found\n", __func__);
>  		return -EINVAL;
>  	}
</remove>

> -	di = kzalloc(sizeof(*di), GFP_KERNEL);
> -	if (!di)
> -		return -ENOMEM;
> -
>  	mutex_init(&di->cc_lock);
>  
>  	/* get parent data */
> @@ -2466,19 +2493,17 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
>  	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
>  
>  	/* get fg specific platform data */
> -	di->pdata = plat_data->fg;
> +	di->pdata = plat_data->bmdev_pdata;
>  	if (!di->pdata) {
>  		dev_err(di->dev, "no fg platform data supplied\n");
> -		ret = -EINVAL;
> -		goto free_device_info;
> +		return -EINVAL;
>  	}
>  
>  	/* get battery specific platform data */
>  	di->bat = plat_data->battery;
>  	if (!di->bat) {
>  		dev_err(di->dev, "no battery platform data supplied\n");
> -		ret = -EINVAL;
> -		goto free_device_info;
> +		return -EINVAL;
>  	}
>  
>  	di->fg_psy.name = "ab8500_fg";
> @@ -2506,7 +2531,7 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
>  	di->fg_wq = create_singlethread_workqueue("ab8500_fg_wq");
>  	if (di->fg_wq == NULL) {
>  		dev_err(di->dev, "failed to create work queue\n");
> -		goto free_device_info;
> +		return -ENOMEM;
>  	}
>  
>  	/* Init work for running the fg algorithm instantly */
> @@ -2605,12 +2630,14 @@ free_irq:
>  	}
>  free_inst_curr_wq:
>  	destroy_workqueue(di->fg_wq);
> -free_device_info:
> -	kfree(di);
> -
>  	return ret;
>  }
>  
> +static const struct of_device_id ab8500_fg_match[] = {
> +	{.compatible = "stericsson,ab8500-fg",},

<nit>

Spaces:

{ .compatible = "stericsson,ab8500-fg", },

</nit>

> +	{},
> +};
> +
>  static struct platform_driver ab8500_fg_driver = {
>  	.probe = ab8500_fg_probe,
>  	.remove = __devexit_p(ab8500_fg_remove),
> @@ -2619,6 +2646,7 @@ static struct platform_driver ab8500_fg_driver = {
>  	.driver = {
>  		.name = "ab8500-fg",
>  		.owner = THIS_MODULE,
> +		.of_match_table = ab8500_fg_match,
>  	},
>  };
>  
> diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
> index 804b88c..ba548e4 100644
> --- a/drivers/power/abx500_chargalg.c
> +++ b/drivers/power/abx500_chargalg.c
> @@ -231,7 +231,7 @@ struct abx500_chargalg {
>  	struct abx500_chargalg_charger_info chg_info;
>  	struct abx500_chargalg_battery_data batt_data;
>  	struct abx500_chargalg_suspension_status susp_status;
> -	struct abx500_chargalg_platform_data *pdata;
> +	struct abx500_bmdevs_plat_data *pdata;
>  	struct abx500_bm_data *bat;
>  	struct power_supply chargalg_psy;
>  	struct ux500_charger *ac_chg;
> @@ -1814,7 +1814,7 @@ static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
>  	di->dev = &pdev->dev;
>  
>  	plat_data = pdev->dev.platform_data;
> -	di->pdata = plat_data->chargalg;
> +	di->pdata = plat_data->bmdev_pdata;
>  	di->bat = plat_data->battery;
>  
>  	/* chargalg supply */
> diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
> index 1318ca6..286f8ac 100644
> --- a/include/linux/mfd/abx500.h
> +++ b/include/linux/mfd/abx500.h
> @@ -382,39 +382,30 @@ struct abx500_bm_data {
>  	int gnd_lift_resistance;
>  	const struct abx500_maxim_parameters *maxi;
>  	const struct abx500_bm_capacity_levels *cap_levels;
> -	const struct abx500_battery_type *bat_type;
> +	struct abx500_battery_type *bat_type;
>  	const struct abx500_bm_charger_parameters *chg_params;
>  	const struct abx500_fg_parameters *fg_params;
>  };
>  
> -struct abx500_chargalg_platform_data {
> -	char **supplied_to;
> -	size_t num_supplicants;
> +struct abx500_bmdevs_plat_data {
> +	char	**supplied_to;
> +	size_t	num_supplicants;
> +	bool	autopower_cfg;
>  };
>  
> -struct abx500_charger_platform_data {
> -	char **supplied_to;
> -	size_t num_supplicants;
> -	bool autopower_cfg;
> -};
> -
> -struct abx500_btemp_platform_data {
> -	char **supplied_to;
> -	size_t num_supplicants;
> +struct abx500_bm_plat_data {
> +	struct abx500_bm_data *battery;
> +	struct abx500_bmdevs_plat_data *bmdev_pdata;
>  };
>  
> -struct abx500_fg_platform_data {
> -	char **supplied_to;
> -	size_t num_supplicants;
> +enum {
> +	NTC_EXTERNAL = 0,
> +	NTC_INTERNAL,
>  };
>  
> -struct abx500_bm_plat_data {
> -	struct abx500_bm_data *battery;
> -	struct abx500_charger_platform_data *charger;
> -	struct abx500_btemp_platform_data *btemp;
> -	struct abx500_fg_platform_data *fg;
> -	struct abx500_chargalg_platform_data *chargalg;
> -};
> +int bmdevs_of_probe(struct device *dev,
> +		struct device_node *np,
> +		struct abx500_bm_plat_data *pdata);
>  
>  int abx500_set_register_interruptible(struct device *dev, u8 bank, u8 reg,
>  	u8 value);
> diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
> index 44310c9..d15b7f1 100644
> --- a/include/linux/mfd/abx500/ab8500-bm.h
> +++ b/include/linux/mfd/abx500/ab8500-bm.h
> @@ -422,6 +422,13 @@ struct ab8500_chargalg_platform_data {
>  struct ab8500_btemp;
>  struct ab8500_gpadc;
>  struct ab8500_fg;
> +
> +extern struct abx500_bm_data ab8500_bm_data;
> +extern struct abx500_battery_type bat_type_ext_thermistor[];
> +extern struct batres_vs_temp temp_to_batres_tbl_ext_thermistor[];
> +extern struct batres_vs_temp temp_to_batres_tbl_9100[];
> +extern struct batres_vs_temp temp_to_batres_tbl_thermistor[];
> +
>  #ifdef CONFIG_AB8500_BM
>  void ab8500_fg_reinit(void);
>  void ab8500_charger_usb_state_changed(u8 bm_usb_state, u16 mA);
> -- 
> 1.7.9.5
> 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
