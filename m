Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1DFM6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:58:19 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.181]:5174
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755871Ab1DFM6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:58:17 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cK936eKc8kzz1202hzz8275bh84d07hz32i2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.kpit.com;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "cbou@mail.ru" <cbou@mail.ru>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 6 Apr 2011 18:28:03 +0530
Subject: [PATCHv1 4/11] Power: Battery module of DA9052 PMIC driver
Thread-Topic: [PATCHv1 4/11] Power: Battery module of DA9052 PMIC driver
Thread-Index: Acv0WkPmi808dMXqRumZZ+Gu+9vULQ==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B4AC1AE@KCINPUNHJCMS01.kpit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p36CwV3V000827

Hi Mark,

Battery Driver for Dialog Semiconductor DA9052 PMICs.

Changes made since last submission:
. read and write operation moved to MFD

Some additional information of this patch:
. This patch is thoroughly tested with the battery Charging and Discharging setup.

Linux Kernel Version: 2.6.37

Signed-off-by: D. Chen <dchen@diasemi.com>
---

diff -Naur orig_linux-2.6.37/drivers/power/da9052-battery.c linux-2.6.37/drivers/power/da9052-battery.c
--- orig_linux-2.6.37/drivers/power/da9052-battery.c    1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/drivers/power/da9052-battery.c 2011-03-31 23:41:16.000000000 +0500
@@ -0,0 +1,666 @@
+/*
+ * da9052-battery.c  --  Batttery Driver for Dialog DA9052 PMICs
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+
+ * Author: Dajun Chen <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/uaccess.h>
+#include <linux/jiffies.h>
+#include <linux/power_supply.h>
+#include <linux/platform_device.h>
+#include <linux/freezer.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/bat.h>
+#include <linux/mfd/da9052/hwmon.h>
+
+static struct da9052_bat_hysteresis bat_hysteresis;
+static struct da9052_bat_event_registration event_status;
+static u16 array_hys_batvoltage[2];
+static u16 bat_volt_arr[3];
+static u8 hys_flag = 0;
+
+static s32 da9052_adc_read_ich(struct da9052 *da9052, u16 *data)
+{
+       uint ret = 0;
+       ret = da9052_reg_read(da9052, DA9052_ICHG_AV_REG);
+       if (ret < 0)
+               return ret;
+       *data = (u16)ret;
+       return ret;
+}
+
+static s32 da9052_adc_read_tbat(struct da9052 *da9052, u16 *data)
+{
+       uint ret = 0;
+       ret = da9052_reg_read(da9052, DA9052_TBAT_RES_REG);
+       if (ret < 0)
+               return ret;
+       *data = (u16)ret;
+       return ret;
+}
+
+s32 da9052_adc_read_vbat(struct da9052 *da9052, u16 *data)
+{
+       s32 ret;
+
+       ret = da9052_adc_manual_read(da9052, DA9052_ADC_VBAT);
+       if (ret == -EIO) {
+               *data = 0;
+               return ret;
+       } else {
+               *data = ret;
+               return 0;
+       }
+       return 0;
+}
+
+static u16 filter_sample(u16 *buffer)
+{
+       u8 count;
+       u16 tempvalue = 0;
+       u16 ret;
+
+       if (buffer == NULL)
+               return -EINVAL;
+
+       for (count = 0; count < DA9052_FILTER_SIZE; count++)
+               tempvalue = tempvalue + *(buffer + count);
+
+       ret = tempvalue/DA9052_FILTER_SIZE;
+       return ret;
+}
+
+static s32  da9052_bat_get_battery_temperature(struct da9052_charger_device
+       *chg_device, u16 *buffer)
+{
+
+       u8 count;
+       u16 filterqueue[DA9052_FILTER_SIZE];
+
+       for (count = 0; count < DA9052_FILTER_SIZE; count++)
+               if (da9052_adc_read_tbat(chg_device->da9052,
+                       &filterqueue[count]))
+                       return -EIO;
+
+       filterqueue[0] = filter_sample(filterqueue);
+
+       chg_device->bat_temp = filterqueue[0];
+       *buffer = chg_device->bat_temp;
+       return 0;
+}
+
+static s32  da9052_bat_get_chg_current(struct da9052_charger_device
+       *chg_device, u16 *buffer)
+{
+       if (chg_device->status == POWER_SUPPLY_STATUS_DISCHARGING)
+               return -EIO;
+
+       if (da9052_adc_read_ich(chg_device->da9052, buffer))
+               return -EIO;
+
+       chg_device->chg_current = ichg_reg_to_mA(*buffer);
+       *buffer = chg_device->chg_current;
+
+       return 0;
+}
+
+s32  da9052_bat_get_battery_voltage(struct da9052_charger_device *chg_device,
+ u16 *buffer)
+{
+       u8 count;
+       u16 filterqueue[DA9052_FILTER_SIZE];
+
+       for (count = 0; count < DA9052_FILTER_SIZE; count++)
+               if (da9052_adc_read_vbat(chg_device->da9052,
+                       &filterqueue[count]))
+                       return -EIO;
+
+       filterqueue[0] = filter_sample(filterqueue);
+
+       chg_device->bat_voltage = volt_reg_to_mV(filterqueue[0]);
+       *buffer = chg_device->bat_voltage;
+       return 0;
+}
+
+static void da9052_bat_status_update(struct da9052_charger_device
+       *chg_device)
+{
+       u16 current_value = 0;
+       u16 buffer = 0;
+       u8 regvalue = 0;
+       u8 old_status = chg_device->status;
+       uint ret = 0;
+
+       ret = da9052_reg_read(chg_device->da9052, DA9052_STATUS_A_REG);
+       if (ret < 0)
+               return;
+       regvalue = (u8)ret;
+
+       ret = da9052_reg_read(chg_device->da9052, DA9052_STATUS_B_REG);
+       if (ret < 0)
+               return;
+
+       if ((regvalue & DA9052_STATUSA_DCINSEL)
+                               && (regvalue & DA9052_STATUSA_DCINDET))
+               chg_device->charger_type = DA9052_WALL_CHARGER;
+       else if ((regvalue & DA9052_STATUSA_VBUSSEL)
+                               && (regvalue & DA9052_STATUSA_VBUSDET)) {
+               if (regvalue & DA9052_STATUSA_VDATDET)
+                       chg_device->charger_type = DA9052_USB_CHARGER;
+               else
+                               chg_device->charger_type = DA9052_USB_HUB;
+       } else {
+               chg_device->charger_type = DA9052_NOCHARGER;
+               chg_device->status = POWER_SUPPLY_STATUS_DISCHARGING;
+       }
+       if (chg_device->charger_type != DA9052_NOCHARGER) {
+               if ((ret & DA9052_STATUSB_CHGEND) != 0)  {
+                       if (da9052_bat_get_chg_current(chg_device,
+                                                       &current_value))
+                                       return;
+                       if (current_value >= chg_device->chg_end_current)
+                               chg_device->status =
+                                       POWER_SUPPLY_STATUS_CHARGING;
+                       else
+                               chg_device->status =
+                                       POWER_SUPPLY_STATUS_NOT_CHARGING;
+               }
+               else
+                       chg_device->status = POWER_SUPPLY_STATUS_CHARGING;
+
+               if (POWER_SUPPLY_STATUS_CHARGING == chg_device->status) {
+                       if (ret != DA9052_STATUSB_CHGPRE) {
+                               if (da9052_bat_get_battery_voltage(chg_device,
+                                                               &buffer))
+                                       return ;
+                               if (buffer > (chg_device->bat_target_voltage -
+                                       chg_device->charger_voltage_drop) &&
+                                       (chg_device->cal_capacity >= 99))
+                                       chg_device->status =
+                                               POWER_SUPPLY_STATUS_FULL;
+                       }
+               }
+       }
+
+       if (chg_device->illegal)
+               chg_device->health = POWER_SUPPLY_HEALTH_UNKNOWN;
+       else if (chg_device->cal_capacity < chg_device->bat_capacity_limit_low)
+               chg_device->health = POWER_SUPPLY_HEALTH_DEAD;
+       else
+               chg_device->health = POWER_SUPPLY_HEALTH_GOOD;
+
+       if (chg_device->status != old_status)
+               power_supply_changed(&chg_device->psy);
+       return;
+}
+
+static s32 da9052_bat_suspend_charging(struct da9052_charger_device *chg_device)
+{
+       uint ret = 0;
+
+       if ((chg_device->status == POWER_SUPPLY_STATUS_DISCHARGING) ||
+               (chg_device->status == POWER_SUPPLY_STATUS_NOT_CHARGING))
+               return 0;
+
+       ret = da9052_reg_read(chg_device->da9052, DA9052_INPUT_CONT_REG);
+       if (ret < 0)
+               return ret;
+
+       ret = (ret | DA9052_INPUT_CONT_DCIN_SUSP);
+       ret = (ret | DA9052_INPUT_CONT_VBUS_SUSP);
+
+       ret = da9052_reg_write(chg_device->da9052, DA9052_INPUT_CONT_REG, ret);
+
+       return ret;
+}
+
+u32 interpolated(u32 vbat_lower, u32  vbat_upper, u32  level_lower,
+       u32  level_upper, u32 bat_voltage)
+{
+       s32 temp;
+       temp = ((level_upper - level_lower) * 1000)/(vbat_upper - vbat_lower);
+       temp = level_lower + (((bat_voltage - vbat_lower) * temp)/1000);
+
+       return temp;
+}
+
+s32 capture_first_correct_vbat_sample(struct da9052_charger_device *chg_device,
+u16 *battery_voltage)
+{
+       static u8 count;
+       s32 ret = 0;
+       u32 temp_data = 0;
+
+       ret = da9052_bat_get_battery_voltage(chg_device,
+               &bat_volt_arr[count]);
+       if (ret)
+               return ret;
+       count++;
+
+       if (count < chg_device->vbat_first_valid_detect_iteration)
+               return -1;
+       for (count = 0; count <
+               (chg_device->vbat_first_valid_detect_iteration - 1);
+               count++) {
+                       temp_data = (bat_volt_arr[count] *
+                       (chg_device->hysteresis_window_size))/100;
+               bat_hysteresis.upper_limit = bat_volt_arr[count] + temp_data;
+               bat_hysteresis.lower_limit = bat_volt_arr[count] - temp_data;
+
+               if ((bat_volt_arr[count + 1] < bat_hysteresis.upper_limit) &&
+                       (bat_volt_arr[count + 1] >
+                       bat_hysteresis.lower_limit)) {
+                               *battery_voltage = (bat_volt_arr[count] +
+                               bat_volt_arr[count+1]) / 2;
+                               hys_flag = 1;
+                       return 0;
+               }
+       }
+
+       for (count = 0; count <
+               (chg_device->vbat_first_valid_detect_iteration - 1);
+                       count++)
+               bat_volt_arr[count] = bat_volt_arr[count + 1];
+
+       return -1;
+}
+
+s32 check_hystersis(struct da9052_charger_device *chg_device, u16 *bat_voltage)
+{
+       u8 ret = 0;
+       u32 offset = 0;
+
+       if (hys_flag == 0) {
+               ret = capture_first_correct_vbat_sample
+                       (chg_device, &array_hys_batvoltage[0]);
+               if (ret)
+                       return ret;
+       }
+
+       ret = da9052_bat_get_battery_voltage
+               (chg_device, &array_hys_batvoltage[1]);
+       if (ret)
+               return ret;
+       *bat_voltage = array_hys_batvoltage[1];
+
+       if ((bat_hysteresis.upper_limit < *bat_voltage) ||
+                       (bat_hysteresis.lower_limit > *bat_voltage)) {
+
+               bat_hysteresis.index++;
+               if (bat_hysteresis.index ==
+                       chg_device->hysteresis_no_of_reading) {
+                       bat_hysteresis.index = 0;
+                       offset = ((*bat_voltage) *
+                               chg_device->hysteresis_window_size)/
+                               100;
+                       bat_hysteresis.upper_limit = (*bat_voltage) + offset;
+                       bat_hysteresis.lower_limit = (*bat_voltage) - offset;
+               } else
+                       return -EIO;
+       } else {
+               bat_hysteresis.index = 0;
+               offset = ((*bat_voltage) *
+                       chg_device->hysteresis_window_size)/100;
+               bat_hysteresis.upper_limit = (*bat_voltage) + offset;
+               bat_hysteresis.lower_limit = (*bat_voltage) - offset;
+       }
+
+       *bat_voltage = ((chg_device->chg_hysteresis_const *
+               array_hys_batvoltage[0])/100) +
+               (((100 - chg_device->chg_hysteresis_const) *
+               array_hys_batvoltage[1])/100);
+
+       if ((chg_device->status == POWER_SUPPLY_STATUS_DISCHARGING) &&
+               (*bat_voltage > array_hys_batvoltage[0])) {
+                       *bat_voltage = array_hys_batvoltage[0];
+       }
+
+       array_hys_batvoltage[0] = *bat_voltage;
+       return 0;
+}
+
+u8 select_temperature(u8 temp_index, u16 bat_temperature)
+{
+       u16 temp_temperature = 0;
+       temp_temperature = (temperature_lookup_ref[temp_index] +
+                               temperature_lookup_ref[temp_index+1]) / 2;
+
+       if (bat_temperature >= temp_temperature) {
+               temp_index += 1;
+               return temp_index;
+       } else
+               return temp_index;
+}
+
+s32 da9052_bat_level_update(struct da9052_charger_device *chg_device)
+{
+       u16 bat_temperature;
+       u16 bat_voltage;
+       u32 vbat_lower, vbat_upper, level_upper, level_lower, level;
+       u8 access_index = 0;
+       u8 index = 0, ret;
+       u8 flag = 0;
+
+       ret = 0;
+       vbat_lower = 0;
+       vbat_upper = 0;
+       level_upper = 0;
+       level_lower = 0;
+
+       ret = check_hystersis(chg_device, &bat_voltage);
+       if (ret)
+               return ret;
+
+       ret = da9052_bat_get_battery_temperature(chg_device,
+               &bat_temperature);
+       if (ret)
+               return ret;
+
+       for (index = 0; index < (DA9052_NO_OF_LOOKUP_TABLE-1); index++) {
+               if (bat_temperature <= temperature_lookup_ref[0]) {
+                       access_index = 0;
+                       break;
+               } else if (bat_temperature >
+                       temperature_lookup_ref[DA9052_NO_OF_LOOKUP_TABLE]){
+                               access_index = DA9052_NO_OF_LOOKUP_TABLE - 1;
+                       break;
+               } else if ((bat_temperature >= temperature_lookup_ref[index]) &&
+                       (bat_temperature >= temperature_lookup_ref[index+1])) {
+                       access_index = select_temperature(index,
+                               bat_temperature);
+                       break;
+               }
+       }
+       if (bat_voltage >= vbat_vs_capacity_look_up[access_index][0][0]) {
+               chg_device->cal_capacity = 100;
+               return 0;
+       }
+       if (bat_voltage <= vbat_vs_capacity_look_up[access_index]
+               [DA9052_LOOK_UP_TABLE_SIZE-1][0]){
+                       chg_device->cal_capacity = 0;
+                       return 0;
+       }
+       flag = 0;
+
+       for (index = 0; index < (DA9052_LOOK_UP_TABLE_SIZE-1); index++) {
+               if ((bat_voltage <=
+               vbat_vs_capacity_look_up[access_index][index][0]) &&
+               (bat_voltage >=
+               vbat_vs_capacity_look_up[access_index][index+1][0])) {
+                       vbat_upper =
+                       vbat_vs_capacity_look_up[access_index][index][0];
+                       vbat_lower =
+                       vbat_vs_capacity_look_up[access_index][index+1][0];
+                       level_upper =
+                       vbat_vs_capacity_look_up[access_index][index][1];
+                       level_lower =
+                       vbat_vs_capacity_look_up[access_index][index+1][1];
+                       flag = 1;
+                       break;
+               }
+       }
+       if (!flag)
+               return -EIO;
+
+       level = interpolated(vbat_lower, vbat_upper, level_lower,
+               level_upper, bat_voltage);
+       chg_device->cal_capacity = level;
+       return 0;
+}
+
+static irqreturn_t da9052_tbat_irq(int irq, void *data)
+{
+       struct da9052_charger_device *chg_device =
+                                       (struct da9052_charger_device *)data;
+
+       chg_device->health = POWER_SUPPLY_HEALTH_OVERHEAT;
+
+       return IRQ_HANDLED;
+}
+
+static int da9052_bat_get_property(struct power_supply *psy,
+                               enum power_supply_property psp,
+                               union power_supply_propval *val)
+{
+       struct da9052_charger_device *chg_device =
+       container_of(psy, struct da9052_charger_device, psy);
+
+       if (chg_device->illegal &&  psp != POWER_SUPPLY_PROP_PRESENT)
+               return -ENODEV;
+
+       switch (psp) {
+       case POWER_SUPPLY_PROP_STATUS:
+               val->intval = chg_device->status;
+               break;
+       case POWER_SUPPLY_PROP_ONLINE:
+               val->intval =
+                       (chg_device->charger_type == DA9052_NOCHARGER) ? 0 : 1;
+               break;
+       case POWER_SUPPLY_PROP_PRESENT:
+               val->intval = chg_device->illegal;
+               break;
+       case POWER_SUPPLY_PROP_HEALTH:
+               val->intval = chg_device->health;
+               break;
+       case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+               val->intval = chg_device->bat_target_voltage * 1000;
+               break;
+       case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+               val->intval = chg_device->bat_volt_cutoff * 1000;
+               break;
+       case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+               val->intval = chg_device->bat_voltage * 1000;
+               break;
+       case POWER_SUPPLY_PROP_CURRENT_AVG:
+               val->intval = chg_device->chg_current * 1000;
+               break;
+       case POWER_SUPPLY_PROP_CAPACITY:
+               val->intval = chg_device->cal_capacity;
+               break;
+       case POWER_SUPPLY_PROP_TEMP:
+               val->intval = bat_temp_reg_to_C(chg_device->bat_temp);
+               break;
+       case POWER_SUPPLY_PROP_TECHNOLOGY:
+               val->intval = chg_device->technology;
+               break;
+       default:
+               return -EINVAL;
+       break;
+       }
+       return 0;
+}
+
+
+static u8 detect_illegal_battery(struct da9052_charger_device *chg_device)
+{
+       u16 buffer = 0;
+       s32  ret = 0;
+
+       ret = da9052_bat_get_battery_temperature(chg_device, &buffer);
+       if (ret)
+               return ret;
+
+       if (buffer > chg_device->bat_with_no_resistor)
+               chg_device->illegal = 1;
+       else
+               chg_device->illegal = 0;
+
+       if (chg_device->illegal)
+               da9052_bat_suspend_charging(chg_device);
+
+       return chg_device->illegal;
+}
+
+void da9052_update_bat_properties(struct da9052_charger_device *chg_device)
+{
+       da9052_bat_status_update(chg_device);
+       da9052_bat_level_update(chg_device);
+}
+
+static void da9052_bat_external_power_changed(struct power_supply *psy)
+{
+       struct da9052_charger_device *chg_device =
+       container_of(psy, struct da9052_charger_device, psy);
+
+       cancel_delayed_work(&chg_device->monitor_work);
+       queue_delayed_work(chg_device->monitor_wqueue,
+                               &chg_device->monitor_work, HZ/10);
+}
+
+static void da9052_bat_work(struct work_struct *work)
+{
+       struct da9052_charger_device *chg_device = container_of(work,
+               struct da9052_charger_device, monitor_work.work);
+       da9052_update_bat_properties(chg_device);
+       queue_delayed_work(chg_device->monitor_wqueue,
+                       &chg_device->monitor_work, HZ * 8);
+}
+
+static enum power_supply_property da9052_bat_props[] = {
+       POWER_SUPPLY_PROP_STATUS,
+       POWER_SUPPLY_PROP_ONLINE,
+       POWER_SUPPLY_PROP_PRESENT,
+       POWER_SUPPLY_PROP_HEALTH,
+       POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+       POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+       POWER_SUPPLY_PROP_VOLTAGE_AVG,
+       POWER_SUPPLY_PROP_CURRENT_AVG,
+       POWER_SUPPLY_PROP_CAPACITY,
+       POWER_SUPPLY_PROP_TEMP,
+       POWER_SUPPLY_PROP_TECHNOLOGY,
+};
+
+static s32 __devinit da9052_bat_probe(struct platform_device *pdev)
+{
+       struct da9052_charger_device *chg_device;
+       uint reg_data = 0;
+       int ret;
+
+       chg_device = kzalloc(sizeof(*chg_device), GFP_KERNEL);
+       if (!chg_device)
+               return -ENOMEM;
+
+       chg_device->da9052 = dev_get_drvdata(pdev->dev.parent);
+       chg_device->tbat_irq = platform_get_irq_byname(pdev,"TBAT");
+
+       platform_set_drvdata(pdev, chg_device);
+       chg_device->psy.name                    = DA9052_BAT_DEVICE_NAME;
+       chg_device->psy.type                    = POWER_SUPPLY_TYPE_BATTERY;
+       chg_device->psy.properties              = da9052_bat_props;
+       chg_device->psy.num_properties          = ARRAY_SIZE(da9052_bat_props);
+       chg_device->psy.get_property            = da9052_bat_get_property;
+       chg_device->psy.external_power_changed  =
+                                       da9052_bat_external_power_changed;
+       chg_device->psy.use_for_apm             = 1;
+       chg_device->charger_type                = DA9052_NOCHARGER;
+       chg_device->status                      = POWER_SUPPLY_STATUS_UNKNOWN;
+       chg_device->health                      = POWER_SUPPLY_HEALTH_UNKNOWN;
+       chg_device->technology                  = POWER_SUPPLY_TECHNOLOGY_LION;
+       chg_device->bat_with_no_resistor        = 62;
+       chg_device->bat_capacity_limit_low      = 4;
+       chg_device->bat_capacity_limit_high     = 70;
+       chg_device->bat_capacity_full           = 100;
+       chg_device->bat_volt_cutoff             = 2800;
+       chg_device->vbat_first_valid_detect_iteration = 3;
+       chg_device->hysteresis_window_size      = 1;
+       chg_device->chg_hysteresis_const        = 89;
+       chg_device->hysteresis_reading_interval = 1000;
+       chg_device->hysteresis_no_of_reading    = 10;
+
+       ret = da9052_reg_read(chg_device->da9052, DA9052_CHG_CONT_REG);
+       if (ret < 0)
+               goto err_charger_init;
+       chg_device->charger_voltage_drop = bat_drop_reg_to_mV(ret &&
+                                                       DA9052_CHG_CONT_TCTR);
+       chg_device->bat_target_voltage =
+                       bat_reg_to_mV(ret && DA9052_CHG_CONT_VCHG_BAT);
+
+       ret = da9052_reg_read(chg_device->da9052, DA9052_ICHG_END_REG);
+       if (ret < 0)
+               goto err_charger_init;
+       chg_device->chg_end_current = ichg_reg_to_mA(reg_data);
+
+       bat_hysteresis.upper_limit      = 0;
+       bat_hysteresis.lower_limit      = 0;
+       bat_hysteresis.hys_flag         = 0;
+       chg_device->illegal             = 0;
+       detect_illegal_battery(chg_device);
+
+       ret = da9052_request_irq(chg_device->da9052, chg_device->tbat_irq,
+                                       da9052_tbat_irq,"TBAT", chg_device);
+       if (ret != 0) {
+               dev_err(chg_device->da9052->dev,
+                       "Failed to register DA9052 TBAT irq, %d\n", ret);
+               goto err_charger_init;
+       }
+
+       ret = power_supply_register(&pdev->dev, &chg_device->psy);
+        if (ret)
+               goto err_charger_init;
+
+       INIT_DELAYED_WORK(&chg_device->monitor_work, da9052_bat_work);
+       chg_device->monitor_wqueue =
+                               create_singlethread_workqueue
+                                       (dev_name(&pdev->dev));
+       if (!chg_device->monitor_wqueue)
+               goto err_charger_init;
+       queue_delayed_work(chg_device->monitor_wqueue,
+               &chg_device->monitor_work, HZ * 1);
+       return 0;
+
+err_charger_init:
+       platform_set_drvdata(pdev, NULL);
+       kfree(chg_device);
+       return ret;
+}
+static int __devexit da9052_bat_remove(struct platform_device *dev)
+{
+       struct da9052_charger_device *chg_device = platform_get_drvdata(dev);
+
+       da9052_free_irq(chg_device->da9052, chg_device->tbat_irq, NULL);
+       cancel_rearming_delayed_workqueue(chg_device->monitor_wqueue,
+                                         &chg_device->monitor_work);
+       destroy_workqueue(chg_device->monitor_wqueue);
+       power_supply_unregister(&chg_device->psy);
+       return 0;
+}
+
+static struct platform_driver da9052_bat_driver = {
+       .driver.name    = "da9052-bat",
+       .driver.owner   = THIS_MODULE,
+       .probe          = da9052_bat_probe,
+       .remove         = __devexit_p(da9052_bat_remove),
+
+};
+
+static int __init da9052_bat_init(void)
+{
+       return platform_driver_register(&da9052_bat_driver);
+}
+
+static void __exit da9052_bat_exit(void)
+{
+       platform_driver_unregister(&da9052_bat_driver);
+}
+
+module_init(da9052_bat_init);
+module_exit(da9052_bat_exit);
+
+MODULE_DESCRIPTION("DA9052 BAT Device Driver");
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9052-tsi");
diff -Naur orig_linux-2.6.37/drivers/power/Kconfig linux-2.6.37/drivers/power/Kconfig
--- orig_linux-2.6.37/drivers/power/Kconfig     2011-01-05 05:50:19.000000000 +0500
+++ linux-2.6.37/drivers/power/Kconfig  2011-03-31 23:41:05.000000000 +0500
@@ -128,6 +128,13 @@
          Say Y here to enable support for batteries charger integrated into
          DA9030 PMIC.

+config BATTERY_DA9052
+       tristate "Dialog DA9052 Battery"
+       depends on PMIC_DA9052
+       help
+         Say Y here to enable support for batteries charger integrated into
+         DA9052 PMIC.
+
 config BATTERY_MAX17040
        tristate "Maxim MAX17040 Fuel Gauge"
        depends on I2C
diff -Naur orig_linux-2.6.37/drivers/power/Makefile linux-2.6.37/drivers/power/Makefile
--- orig_linux-2.6.37/drivers/power/Makefile    2011-01-05 05:50:19.000000000 +0500
+++ linux-2.6.37/drivers/power/Makefile 2011-03-31 23:40:59.000000000 +0500
@@ -24,6 +24,7 @@
 obj-$(CONFIG_BATTERY_BQ20Z75)  += bq20z75.o
 obj-$(CONFIG_BATTERY_BQ27x00)  += bq27x00_battery.o
 obj-$(CONFIG_BATTERY_DA9030)           += da9030_battery.o
+obj-$(CONFIG_BATTERY_DA9052)           += da9052-battery.o
 obj-$(CONFIG_BATTERY_MAX17040) += max17040_battery.o
 obj-$(CONFIG_BATTERY_Z2)               += z2_battery.o
 obj-$(CONFIG_BATTERY_S3C_ADC)  += s3c_adc_battery.o
diff -Naur orig_linux-2.6.37/include/linux/mfd/da9052/bat.h linux-2.6.37/include/linux/mfd/da9052/bat.h
--- orig_linux-2.6.37/include/linux/mfd/da9052/bat.h    1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/include/linux/mfd/da9052/bat.h 2011-03-31 23:40:39.000000000 +0500
@@ -0,0 +1,232 @@
+/*
+ * da9052 BAT module declarations.
+  *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __LINUX_MFD_DA9052_BAT_H
+#define __LINUX_MFD_DA9052_BAT_H
+
+#include <linux/power_supply.h>
+
+/* STATIC CONFIGURATION */
+#define DA9052_LOOK_UP_TABLE_SIZE              68
+#define DA9052_NO_OF_LOOKUP_TABLE              3
+#define DA9052_FILTER_SIZE                     4
+#define DA9052_NUMBER_OF_STORE_CURENT_READING  4
+
+static const u16 temperature_lookup_ref
+                       [DA9052_NO_OF_LOOKUP_TABLE] = {10, 25, 40};
+static u32 const vbat_vs_capacity_look_up[DA9052_NO_OF_LOOKUP_TABLE]
+                                       [DA9052_LOOK_UP_TABLE_SIZE][2] = {
+       /* For temperature 10 degree celisus*/
+       {
+       {4082, 100}, {4036, 98},
+       {4020, 96}, {4008, 95},
+       {3997, 93}, {3983, 91},
+       {3964, 90}, {3943, 88},
+       {3926, 87}, {3912, 85},
+       {3900, 84}, {3890, 82},
+       {3881, 80}, {3873, 79},
+       {3865, 77}, {3857, 76},
+       {3848, 74}, {3839, 73},
+       {3829, 71}, {3820, 70},
+       {3811, 68}, {3802, 67},
+       {3794, 65}, {3785, 64},
+       {3778, 62}, {3770, 61},
+       {3763, 59}, {3756, 58},
+       {3750, 56}, {3744, 55},
+       {3738, 53}, {3732, 52},
+       {3727, 50}, {3722, 49},
+       {3717, 47}, {3712, 46},
+       {3708, 44}, {3703, 43},
+       {3700, 41}, {3696, 40},
+       {3693, 38}, {3691, 37},
+       {3688, 35}, {3686, 34},
+       {3683, 32}, {3681, 31},
+       {3678, 29}, {3675, 28},
+       {3672, 26}, {3669, 25},
+       {3665, 23}, {3661, 22},
+       {3656, 21}, {3651, 19},
+       {3645, 18}, {3639, 16},
+       {3631, 15}, {3622, 13},
+       {3611, 12}, {3600, 10},
+       {3587, 9}, {3572, 7},
+       {3548, 6}, {3503, 5},
+       {3420, 3}, {3268, 2},
+       {2992, 1}, {2746, 0}
+       },
+       /* For temperature 25 degree celisus */
+       {
+       {4102, 100}, {4065, 98},
+       {4048, 96}, {4034, 95},
+       {4021, 93}, {4011, 92},
+       {4001, 90}, {3986, 88},
+       {3968, 87}, {3952, 85},
+       {3938, 84}, {3926, 82},
+       {3916, 81}, {3908, 79},
+       {3900, 77}, {3892, 76},
+       {3883, 74}, {3874, 73},
+       {3864, 71}, {3855, 70},
+       {3846, 68}, {3836, 67},
+       {3827, 65}, {3819, 64},
+       {3810, 62}, {3801, 61},
+       {3793, 59}, {3786, 58},
+       {3778, 56}, {3772, 55},
+       {3765, 53}, {3759, 52},
+       {3754, 50}, {3748, 49},
+       {3743, 47}, {3738, 46},
+       {3733, 44}, {3728, 43},
+       {3724, 41}, {3720, 40},
+       {3716, 38}, {3712, 37},
+       {3709, 35}, {3706, 34},
+       {3703, 33}, {3701, 31},
+       {3698, 30}, {3696, 28},
+       {3693, 27}, {3690, 25},
+       {3687, 24}, {3683, 22},
+       {3680, 21}, {3675, 19},
+       {3671, 18}, {3666, 17},
+       {3660, 15}, {3654, 14},
+       {3647, 12}, {3639, 11},
+       {3630, 9}, {3621, 8},
+       {3613, 6}, {3606, 5},
+       {3597, 4}, {3582, 2},
+       {3546, 1}, {2747, 0}
+       },
+       /* For temperature 40 degree celisus*/
+       {
+       {4114, 100}, {4081, 98},
+       {4065, 96}, {4050, 95},
+       {4036, 93}, {4024, 92},
+       {4013, 90}, {4002, 88},
+       {3990, 87}, {3976, 85},
+       {3962, 84}, {3950, 82},
+       {3939, 81}, {3930, 79},
+       {3921, 77}, {3912, 76},
+       {3902, 74}, {3893, 73},
+       {3883, 71}, {3874, 70},
+       {3865, 68}, {3856, 67},
+       {3847, 65}, {3838, 64},
+       {3829, 62}, {3820, 61},
+       {3812, 59}, {3803, 58},
+       {3795, 56}, {3787, 55},
+       {3780, 53}, {3773, 52},
+       {3767, 50}, {3761, 49},
+       {3756, 47}, {3751, 46},
+       {3746, 44}, {3741, 43},
+       {3736, 41}, {3732, 40},
+       {3728, 38}, {3724, 37},
+       {3720, 35}, {3716, 34},
+       {3713, 33}, {3710, 31},
+       {3707, 30}, {3704, 28},
+       {3701, 27}, {3698, 25},
+       {3695, 24}, {3691, 22},
+       {3686, 21}, {3681, 19},
+       {3676, 18}, {3671, 17},
+       {3666, 15}, {3661, 14},
+       {3655, 12}, {3648, 11},
+       {3640, 9}, {3632, 8},
+       {3622, 6}, {3616, 5},
+       {3611, 4}, {3604, 2},
+       {3594, 1}, {2747, 0}
+       }
+};
+
+enum charger_type_enum {
+       DA9052_NOCHARGER = 1,
+       DA9052_USB_HUB,
+       DA9052_USB_CHARGER,
+       DA9052_WALL_CHARGER
+};
+
+struct da9052_bat_event_registration {
+       u8      da9052_event_tbat:1;
+};
+
+struct da9052_bat_hysteresis {
+       u16     bat_volt_arr[3];
+       u16     array_hys_batvoltage[2];
+       u16     upper_limit;
+       u16     lower_limit;
+       u8      index;
+       u8      hys_flag;
+};
+
+struct da9052_charger_device {
+       struct da9052                   *da9052;
+       struct workqueue_struct         *monitor_wqueue;
+       struct delayed_work             monitor_work;
+       struct power_supply             psy;
+       //struct notifier_block                 nb;
+       int                             tbat_irq;
+       u8                              cal_capacity;
+       u8                              charger_type;
+       u8                              health;
+       u8                              status;
+       u8                              illegal;
+       u16                             technology;
+       u16                             chg_current;
+       u16                             bat_voltage;
+       u16                             bat_capacity_limit_low;
+       u16                             bat_capacity_full;
+       u16                             bat_capacity_limit_high;
+       u16                             bat_volt_cutoff;
+       u16                             bat_with_no_resistor;
+       u16                             bat_temp;
+       u8                              hys_flag;
+       u16                             charger_voltage_drop;
+       u16                             bat_target_voltage;
+       u16                             chg_end_current;
+       u16                             hysteresis_window_size;
+       u16                             chg_hysteresis_const;
+       u16                             hysteresis_reading_interval;
+       u16                             hysteresis_no_of_reading;
+       u16                             vbat_first_valid_detect_iteration;
+};
+
+static inline  u8 bat_temp_reg_to_C(u16 value) { return (55 - value); }
+static inline  u8 bat_mV_to_reg(u16 value) { return (((value-4100)/100)<<4); }
+static inline  u8 bat_drop_mV_to_reg(u16 value)
+               { return (((value-100)/100)<<6); }
+static inline  u16 bat_reg_to_mV(u8 value) { return ((value*100) + 4100); }
+static inline  u16 bat_drop_reg_to_mV(u8 value) { return ((value*100)+100); }
+static inline  u8 vch_thr_mV_to_reg(u16 value) { return ((value-3700)/100); }
+static inline  u8 precharge_mA_to_reg(u8 value) { return ((value/20)<<6); }
+static inline  u8 vddout_mon_mV_to_reg(u16 value)
+               { return (((value-2500)*128)/1000); }
+static inline  u16 vddout_reg_to_mV(u8 value)
+               { return ((value*1000)/128)+2500; }
+static inline  u16 volt_reg_to_mV(u16 value)
+               { return ((value*1000)/512)+2500; }
+static inline  u8 ichg_mA_to_reg(u16 value) { return (value/4); }
+static inline  u16 ichg_reg_to_mA(u8 value) { return ((value*3900)/1000); }
+
+#endif /* __LINUX_MFD_DA9052_BAT_H */


Regards,
Ashish


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
