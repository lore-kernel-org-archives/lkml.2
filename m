Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab1KRJ3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:29:11 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:2256 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab1KRJ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:29:07 -0500
X-SpamScore: 4
X-BigFish: VPS4(zzc8kzz1202hzz8275bhz32i2a8h668h839h93fh62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH 04/11] Power: DA9052 Battery driver v4
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "cbou@mail.ru" <cbou@mail.ru>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 14:54:09 +0530
Message-ID: <1321608249.10344.25.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for DA9052 battery charger. This driver depends on DA9052 MFD core dirver
for definitions and methods.

Tested on Samsung SMDK6410 board with DA9052-BC and DA9053-BA evaluation boards.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
Changes since v3
- Included power_supply.h file
- Corrected the definition of DA9052_BAT_THRESHOLD macro
- Changed definition of charger_type_enum
- Added API da9052_battery_read_end_current
- Added API da9052_battery_check_status
- Changed the way of handling the interrupts in da9052_bat_irq
Changes since v2
- Correct code styling for inline functions
- Remove averaging algorithm
- Set use_for_apm thru board specific parameter
---
 drivers/power/Kconfig          |    7 +
 drivers/power/Makefile         |    1 +
 drivers/power/da9052-battery.c |  611 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 619 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/da9052-battery.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 9f88641..9696502 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -150,6 +150,13 @@ config BATTERY_DA9030
 	  Say Y here to enable support for batteries charger integrated into
 	  DA9030 PMIC.
 
+config BATTERY_DA9052
+	tristate "Dialog DA9052 Battery"
+	depends on PMIC_DA9052
+	help
+	  Say Y here to enable support for batteries charger integrated into
+	  DA9052 PMIC.
+
 config BATTERY_MAX17040
 	tristate "Maxim MAX17040 Fuel Gauge"
 	depends on I2C
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index b4af13d..c570e20 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_BATTERY_WM97XX)	+= wm97xx_battery.o
 obj-$(CONFIG_BATTERY_BQ20Z75)	+= bq20z75.o
 obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
 obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
+obj-$(CONFIG_BATTERY_DA9052)	+= da9052-battery.o
 obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
 obj-$(CONFIG_BATTERY_MAX17042)	+= max17042_battery.o
 obj-$(CONFIG_BATTERY_Z2)	+= z2_battery.o
diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
new file mode 100644
index 0000000..d9096df
--- /dev/null
+++ b/drivers/power/da9052-battery.c
@@ -0,0 +1,611 @@
+/*
+ * Batttery Driver for Dialog DA9052 PMICs
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/freezer.h>
+#include <linux/fs.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/uaccess.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/pdata.h>
+#include <linux/mfd/da9052/reg.h>
+
+/* STATIC CONFIGURATION */
+#define DA9052_BAT_CUTOFF_VOLT		2800
+#define DA9052_BAT_THRESHOLD		62000
+#define DA9052_BAT_CAPACITY_LIMIT_LOW	4
+#define DA9052_AVERAGE_SIZE		4
+#define DA9052_LOOK_UP_TABLE_SIZE	68
+#define DA9052_NO_OF_LOOKUP_TABLE	3
+
+enum charger_type_enum {
+	DA9052_NOCHARGER = 1,
+	DA9052_CHARGER,
+};
+
+static const u16 temperature_lookup_ref[3] = {10, 25, 40};
+static u32 const vbat_vs_capacity_look_up[3][68][2] = {
+	/* For temperature 10 degree celisus*/
+	{
+	{4082, 100}, {4036, 98},
+	{4020, 96}, {4008, 95},
+	{3997, 93}, {3983, 91},
+	{3964, 90}, {3943, 88},
+	{3926, 87}, {3912, 85},
+	{3900, 84}, {3890, 82},
+	{3881, 80}, {3873, 79},
+	{3865, 77}, {3857, 76},
+	{3848, 74}, {3839, 73},
+	{3829, 71}, {3820, 70},
+	{3811, 68}, {3802, 67},
+	{3794, 65}, {3785, 64},
+	{3778, 62}, {3770, 61},
+	{3763, 59}, {3756, 58},
+	{3750, 56}, {3744, 55},
+	{3738, 53}, {3732, 52},
+	{3727, 50}, {3722, 49},
+	{3717, 47}, {3712, 46},
+	{3708, 44}, {3703, 43},
+	{3700, 41}, {3696, 40},
+	{3693, 38}, {3691, 37},
+	{3688, 35}, {3686, 34},
+	{3683, 32}, {3681, 31},
+	{3678, 29}, {3675, 28},
+	{3672, 26}, {3669, 25},
+	{3665, 23}, {3661, 22},
+	{3656, 21}, {3651, 19},
+	{3645, 18}, {3639, 16},
+	{3631, 15}, {3622, 13},
+	{3611, 12}, {3600, 10},
+	{3587, 9}, {3572, 7},
+	{3548, 6}, {3503, 5},
+	{3420, 3}, {3268, 2},
+	{2992, 1}, {2746, 0}
+	},
+	/* For temperature 25 degree celisus */
+	{
+	{4102, 100}, {4065, 98},
+	{4048, 96}, {4034, 95},
+	{4021, 93}, {4011, 92},
+	{4001, 90}, {3986, 88},
+	{3968, 87}, {3952, 85},
+	{3938, 84}, {3926, 82},
+	{3916, 81}, {3908, 79},
+	{3900, 77}, {3892, 76},
+	{3883, 74}, {3874, 73},
+	{3864, 71}, {3855, 70},
+	{3846, 68}, {3836, 67},
+	{3827, 65}, {3819, 64},
+	{3810, 62}, {3801, 61},
+	{3793, 59}, {3786, 58},
+	{3778, 56}, {3772, 55},
+	{3765, 53}, {3759, 52},
+	{3754, 50}, {3748, 49},
+	{3743, 47}, {3738, 46},
+	{3733, 44}, {3728, 43},
+	{3724, 41}, {3720, 40},
+	{3716, 38}, {3712, 37},
+	{3709, 35}, {3706, 34},
+	{3703, 33}, {3701, 31},
+	{3698, 30}, {3696, 28},
+	{3693, 27}, {3690, 25},
+	{3687, 24}, {3683, 22},
+	{3680, 21}, {3675, 19},
+	{3671, 18}, {3666, 17},
+	{3660, 15}, {3654, 14},
+	{3647, 12}, {3639, 11},
+	{3630, 9}, {3621, 8},
+	{3613, 6}, {3606, 5},
+	{3597, 4}, {3582, 2},
+	{3546, 1}, {2747, 0}
+	},
+	/* For temperature 40 degree celisus*/
+	{
+	{4114, 100}, {4081, 98},
+	{4065, 96}, {4050, 95},
+	{4036, 93}, {4024, 92},
+	{4013, 90}, {4002, 88},
+	{3990, 87}, {3976, 85},
+	{3962, 84}, {3950, 82},
+	{3939, 81}, {3930, 79},
+	{3921, 77}, {3912, 76},
+	{3902, 74}, {3893, 73},
+	{3883, 71}, {3874, 70},
+	{3865, 68}, {3856, 67},
+	{3847, 65}, {3838, 64},
+	{3829, 62}, {3820, 61},
+	{3812, 59}, {3803, 58},
+	{3795, 56}, {3787, 55},
+	{3780, 53}, {3773, 52},
+	{3767, 50}, {3761, 49},
+	{3756, 47}, {3751, 46},
+	{3746, 44}, {3741, 43},
+	{3736, 41}, {3732, 40},
+	{3728, 38}, {3724, 37},
+	{3720, 35}, {3716, 34},
+	{3713, 33}, {3710, 31},
+	{3707, 30}, {3704, 28},
+	{3701, 27}, {3698, 25},
+	{3695, 24}, {3691, 22},
+	{3686, 21}, {3681, 19},
+	{3676, 18}, {3671, 17},
+	{3666, 15}, {3661, 14},
+	{3655, 12}, {3648, 11},
+	{3640, 9}, {3632, 8},
+	{3622, 6}, {3616, 5},
+	{3611, 4}, {3604, 2},
+	{3594, 1}, {2747, 0}
+	}
+};
+
+struct da9052_battery {
+	struct da9052 *da9052;
+	struct power_supply psy;
+	int charger_type;
+	int status;
+	int health;
+};
+
+static inline int volt_reg_to_mV(int value)
+{
+	return ((value * 1000) / 512) + 2500;
+}
+
+static inline int ichg_reg_to_mA(int value)
+{
+	return (value * 3900) / 1000;
+}
+
+static int da9052_battery_read_end_current(struct da9052_battery *battery,
+					    int *current_mA)
+{
+	int ret;
+
+	if (battery->status == POWER_SUPPLY_STATUS_DISCHARGING)
+		return -EINVAL;
+
+	ret = da9052_reg_read(battery->da9052, DA9052_ICHG_END_REG);
+	if (ret < 0)
+		return ret;
+
+	*current_mA = ichg_reg_to_mA(ret & DA9052_ICHGEND_ICHGEND);
+
+	return 0;
+}
+
+static int da9052_battery_read_current(struct da9052_battery *battery,
+					int *current_mA)
+{
+	int ret;
+
+	if (battery->status == POWER_SUPPLY_STATUS_DISCHARGING)
+		return -EINVAL;
+
+	ret = da9052_reg_read(battery->da9052, DA9052_ICHG_AV_REG);
+	if (ret < 0)
+		return ret;
+
+	*current_mA = ichg_reg_to_mA(ret & DA9052_ICHGAV_ICHGAV);
+
+	return 0;
+}
+
+static int da9052_battery_check_status(struct da9052_battery *battery,
+					int *status)
+{
+	uint8_t v[2] = {0, 0};
+	uint8_t bat_status, chg_end;
+	int ret, chg_current, chg_end_current;
+
+	ret = da9052_group_read(battery->da9052, DA9052_STATUS_A_REG, 2, v);
+	if (ret < 0)
+		return ret;
+
+	bat_status = v[0];
+	chg_end = v[1];
+
+	/* Preference to WALL(DCIN) charger unit */
+	if (((bat_status & DA9052_STATUSA_DCINSEL) &&
+	     (bat_status & DA9052_STATUSA_DCINDET))
+	    ||
+	    ((bat_status & DA9052_STATUSA_VBUSSEL) &&
+	     (bat_status & DA9052_STATUSA_VBUSDET))
+	   ) {
+		battery->charger_type = DA9052_CHARGER;
+
+		/* If charging end flag is set and Charging current is greater
+		 * than charging end limit then battery is charging
+		*/
+		if ((chg_end & DA9052_STATUSB_CHGEND) != 0) {
+			ret = da9052_battery_read_current(battery,
+							  &chg_current);
+			if (ret < 0)
+				return ret;
+			ret = da9052_battery_read_end_current(battery,
+							      &chg_end_current);
+			if (ret < 0)
+				return ret;
+
+			if (chg_current >= chg_end_current)
+				battery->status = POWER_SUPPLY_STATUS_CHARGING;
+			else
+				battery->status =
+					POWER_SUPPLY_STATUS_NOT_CHARGING;
+		}
+		/* If Charging end flag is cleared then battery is charging */
+		else
+			battery->status = POWER_SUPPLY_STATUS_CHARGING;
+	} else if (bat_status & DA9052_STATUSA_DCINDET ||
+		  bat_status & DA9052_STATUSA_VBUSDET) {
+			battery->charger_type = DA9052_CHARGER;
+			battery->status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+	} else {
+		battery->charger_type = DA9052_NOCHARGER;
+		battery->status = POWER_SUPPLY_STATUS_DISCHARGING;
+	}
+
+	if (status != NULL)
+		*status = battery->status;
+	return 0;
+}
+
+static int da9052_battery_read_volt(struct da9052_battery *battery,
+				     int *volt_mV)
+{
+	int voltage;
+
+	voltage = da9052_adc_manual_read(battery->da9052,
+					 DA9052_ADC_MAN_MUXSEL_VBAT);
+	if (voltage < 0)
+		return voltage;
+
+	*volt_mV = volt_reg_to_mV(voltage);
+
+	return 0;
+}
+
+static int da9052_battery_check_presence(struct da9052_battery *battery,
+					  int *illegal)
+{
+	int bat_temp;
+
+	bat_temp = da9052_adc_temperature_read(battery->da9052);
+	if (bat_temp < 0)
+		return bat_temp;
+
+	if (bat_temp > DA9052_BAT_THRESHOLD)
+		*illegal = 1;
+	else
+		*illegal = 0;
+
+	return 0;
+}
+
+static int interpolated(int vbat_lower, int  vbat_upper, int level_lower,
+			 int level_upper, int bat_voltage)
+{
+	int temp;
+
+	temp = ((level_upper - level_lower) * 1000) / (vbat_upper - vbat_lower);
+	temp = level_lower + (((bat_voltage - vbat_lower) * temp) / 1000);
+
+	return temp;
+}
+
+unsigned char select_temperature(unsigned char temp_index, int bat_temperature)
+{
+	int temp_temperature;
+
+	temp_temperature = (temperature_lookup_ref[temp_index] +
+			    temperature_lookup_ref[temp_index + 1]) / 2;
+
+	if (bat_temperature >= temp_temperature) {
+		temp_index += 1;
+		return temp_index;
+	} else
+		return temp_index;
+}
+
+static int da9052_battery_read_capacity(struct da9052_battery *battery,
+					 int *capacity)
+{
+	int bat_temperature, bat_voltage;
+	int vbat_lower, vbat_upper, level_upper, level_lower;
+	int ret, flag, index, access_index = 0;
+
+	ret = da9052_battery_read_volt(battery, &bat_voltage);
+	if (ret < 0)
+		return ret;
+
+	bat_temperature = da9052_adc_temperature_read(battery->da9052);
+	if (bat_temperature < 0)
+		return bat_temperature;
+
+	for (index = 0; index < (DA9052_NO_OF_LOOKUP_TABLE - 1); index++) {
+		if (bat_temperature <= temperature_lookup_ref[0]) {
+			access_index = 0;
+			break;
+		} else if (bat_temperature >
+			   temperature_lookup_ref[DA9052_NO_OF_LOOKUP_TABLE]) {
+				access_index = DA9052_NO_OF_LOOKUP_TABLE - 1;
+			break;
+		} else if ((bat_temperature >= temperature_lookup_ref[index]) &&
+			   (bat_temperature >= temperature_lookup_ref[index + 1]
+			    )) {
+				access_index = select_temperature(index,
+					       bat_temperature);
+			break;
+		}
+	}
+	if (bat_voltage >= vbat_vs_capacity_look_up[access_index][0][0]) {
+		*capacity = 100;
+		return 0;
+	}
+	if (bat_voltage <= vbat_vs_capacity_look_up[access_index]
+		[DA9052_LOOK_UP_TABLE_SIZE - 1][0]) {
+			*capacity = 0;
+			return 0;
+	}
+	flag = 0;
+
+	for (index = 0; index < (DA9052_LOOK_UP_TABLE_SIZE-1); index++) {
+		if ((bat_voltage <=
+		     vbat_vs_capacity_look_up[access_index][index][0]) &&
+		    (bat_voltage >=
+		     vbat_vs_capacity_look_up[access_index][index + 1][0])) {
+			vbat_upper =
+			vbat_vs_capacity_look_up[access_index][index][0];
+			vbat_lower =
+			vbat_vs_capacity_look_up[access_index][index + 1][0];
+			level_upper =
+			vbat_vs_capacity_look_up[access_index][index][1];
+			level_lower =
+			vbat_vs_capacity_look_up[access_index][index + 1][1];
+			flag = 1;
+			break;
+		}
+	}
+	if (!flag)
+		return -EIO;
+
+	*capacity = interpolated(vbat_lower, vbat_upper, level_lower,
+				 level_upper, bat_voltage);
+
+	return 0;
+}
+
+static int da9052_battery_check_health(struct da9052_battery *battery,
+					int *health)
+{
+	int ret, bat_illegal, capacity;
+
+	ret = da9052_battery_check_presence(battery, &bat_illegal);
+	if (ret < 0)
+		return ret;
+
+	if (bat_illegal) {
+		battery->health = POWER_SUPPLY_HEALTH_UNKNOWN;
+		return 0;
+	}
+
+	if (battery->health != POWER_SUPPLY_HEALTH_OVERHEAT) {
+		ret = da9052_battery_read_capacity(battery, &capacity);
+		if (ret < 0)
+			return ret;
+		if (capacity < DA9052_BAT_CAPACITY_LIMIT_LOW)
+			battery->health = POWER_SUPPLY_HEALTH_DEAD;
+		else
+			battery->health = POWER_SUPPLY_HEALTH_GOOD;
+	}
+
+	*health = battery->health;
+
+	return 0;
+}
+
+static irqreturn_t da9052_bat_irq(int irq, void *data)
+{
+	struct da9052_battery *battery = (struct da9052_battery *)data;
+
+	irq -= battery->da9052->irq_base;
+
+	if (irq == DA9052_IRQ_CHGEND)
+		battery->status = POWER_SUPPLY_STATUS_FULL;
+	else
+		da9052_battery_check_status(battery, NULL);
+
+	if (irq == DA9052_IRQ_CHGEND || irq == DA9052_IRQ_DCIN ||
+	    irq == DA9052_IRQ_VBUS || irq == DA9052_IRQ_TBAT) {
+		power_supply_changed(&battery->psy);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int da9052_bat_get_property(struct power_supply *psy,
+				    enum power_supply_property psp,
+				    union power_supply_propval *val)
+{
+	int ret, illegal;
+	struct da9052_battery *battery = container_of(psy,
+						struct da9052_battery, psy);
+
+	ret = da9052_battery_check_presence(battery, &illegal);
+	if (ret < 0)
+		return ret;
+
+	if (illegal && psp != POWER_SUPPLY_PROP_PRESENT)
+		return -ENODEV;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		ret = da9052_battery_check_status(battery, &val->intval);
+		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval =
+			(battery->charger_type == DA9052_NOCHARGER) ? 0 : 1;
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		ret = da9052_battery_check_presence(battery, &val->intval);
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		ret = da9052_battery_check_health(battery, &val->intval);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		val->intval = DA9052_BAT_CUTOFF_VOLT * 1000;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+		ret = da9052_battery_read_volt(battery, &val->intval);
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+		ret = da9052_battery_read_current(battery, &val->intval);
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		ret = da9052_battery_read_capacity(battery, &val->intval);
+		break;
+	case POWER_SUPPLY_PROP_TEMP:
+		val->intval = da9052_adc_temperature_read(battery->da9052);
+		ret = val->intval;
+		break;
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return ret;
+}
+
+static enum power_supply_property da9052_bat_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_CURRENT_AVG,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+};
+
+static struct power_supply template_battery = {
+	.name		= "da9052-bat",
+	.type		= POWER_SUPPLY_TYPE_BATTERY,
+	.properties	= da9052_bat_props,
+	.num_properties	= ARRAY_SIZE(da9052_bat_props),
+	.get_property	= da9052_bat_get_property,
+};
+
+static const char *da9052_bat_irqs[] = {
+	"BATT TEMP",
+	"DCIN DET",
+	"DCIN REM",
+	"VBUS DET",
+	"VBUS REM",
+	"CHG END",
+};
+
+static s32 __devinit da9052_bat_probe(struct platform_device *pdev)
+{
+	struct da9052_pdata *pdata;
+	struct da9052_battery *battery;
+	int ret, irq, i;
+
+	battery = kzalloc(sizeof(struct da9052_battery), GFP_KERNEL);
+	if (!battery)
+		return -ENOMEM;
+
+	battery->da9052 = dev_get_drvdata(pdev->dev.parent);
+	pdata = battery->da9052->dev->platform_data;
+
+	battery->psy		= template_battery;
+	if (pdata != NULL && pdata->use_for_apm)
+		battery->psy.use_for_apm = pdata->use_for_apm;
+	battery->charger_type	= DA9052_NOCHARGER;
+	battery->status		= POWER_SUPPLY_STATUS_UNKNOWN;
+	battery->health		= POWER_SUPPLY_HEALTH_UNKNOWN;
+
+	for (i = 0; i < ARRAY_SIZE(da9052_bat_irqs); i++) {
+		irq = platform_get_irq_byname(pdev, da9052_bat_irqs[i]);
+		ret = request_threaded_irq(battery->da9052->irq_base + irq,
+					   NULL, da9052_bat_irq,
+					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					   da9052_bat_irqs[i], battery);
+		if (ret != 0) {
+			dev_err(battery->da9052->dev,
+				"DA9052 failed to request %s IRQ %d: %d\n",
+				da9052_bat_irqs[i], irq, ret);
+			goto err;
+		}
+	}
+
+	ret = power_supply_register(&pdev->dev, &battery->psy);
+	 if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	for (; i >= 0; i--) {
+		irq = platform_get_irq_byname(pdev, da9052_bat_irqs[i]);
+		free_irq(irq, battery);
+	}
+	kfree(battery);
+	return ret;
+}
+static int __devexit da9052_bat_remove(struct platform_device *pdev)
+{
+	int i, irq;
+	struct da9052_battery *battery = platform_get_drvdata(pdev);
+
+	for (i = 0; i < ARRAY_SIZE(da9052_bat_irqs); i++) {
+		irq = platform_get_irq_byname(pdev, da9052_bat_irqs[i]);
+		free_irq(irq, battery);
+	}
+	power_supply_unregister(&battery->psy);
+
+	return 0;
+}
+
+static struct platform_driver da9052_bat_driver = {
+	.probe = da9052_bat_probe,
+	.remove = __devexit_p(da9052_bat_remove),
+	.driver = {
+		.name = "da9052-bat",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init da9052_bat_init(void)
+{
+	return platform_driver_register(&da9052_bat_driver);
+}
+module_init(da9052_bat_init);
+
+static void __exit da9052_bat_exit(void)
+{
+	platform_driver_unregister(&da9052_bat_driver);
+}
+module_exit(da9052_bat_exit);
+
+MODULE_DESCRIPTION("DA9052 BAT Device Driver");
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:da9052-bat");
-- 
1.7.1


