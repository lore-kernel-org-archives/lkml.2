Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0GNJoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:44:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57647 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab0GNJoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=rb0e71b1mPW8bU8Acq4P5RPws8ThQJeU+HY9p2kBieJE0/tqfTMb/Bx15g+i+mhJ6G
         gaRPHgjZDpmorV8obzWHt2247GSp+AZITGElahAztVuCwB9djvM63zRHGGNMwfxGakZg
         VKX3taohchz6+bZ+V6u0AKzQqpdVk0oWRoRYQ=
MIME-Version: 1.0
Date: Wed, 14 Jul 2010 10:44:10 +0100
Message-ID: <AANLkTilbY_V_0E2NtXwrhV8Rd4Efpy8p8FvrAigH6A00@mail.gmail.com>
Subject: [PATCHv2 4/11] Power:Battery module of DA9052 PMIC device driver 
	(RESEND)
From: Dajun Chen <dajun.chen@gmail.com>
To: cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Battery module of the device driver for DA9052 PMIC device from Dialog
Semiconductor.

Changes made since last submission:
. code has been reorganised as per the standard linux kernel driver framework
. removal of redundant printk and comments
. removal of test framework

Linux Kernel Version: 2.6.34

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -urpN linux-2.6.34/drivers/power/da9052_battery.c
linux-2.6.34_test/drivers/power/da9052_battery.c
--- linux-2.6.34/drivers/power/da9052_battery.c	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/drivers/power/da9052_battery.c	2010-07-13
17:49:01.000000000 +0500
@@ -0,0 +1,1377 @@
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
+#include <linux/power_supply.h>
+#include <linux/platform_device.h>
+#include <linux/freezer.h>
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/bat.h>
+#include <linux/mfd/da9052/adc.h>
+
+#define DRIVER_NAME "da9052-battery"
+
+static struct da9052_bat_device bat_info;
+static struct da9052_bat_status bat_status;
+static struct da9052_bat_hysteresis bat_hysteresis;
+static struct da9052_bat_event_registration event_status;
+static struct monitoring_state monitoring_status;
+struct power_supply_info battery_info;
+
+/* Populate it with the releavant values as per the battery used. */
+static struct da9052_bat_threshold thresholds;
+/* Populate it with the releavant values as per the battery used. */
+struct da9052_charger_device charger;
+
+static u16 bat_target_voltage;
+u8 tbat_event_occur;
+
+static int da9052_bat_get_property(struct power_supply *psy,
+					enum power_supply_property psp,
+					union power_supply_propval *val);
+
+
+static enum power_supply_property da902_bat_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_CURRENT_AVG,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_MANUFACTURER,
+};
+
+static int da9052_read(struct da9052 *da9052, u8 reg_address, u8 *reg_data)
+{
+	struct da9052_ssc_msg msg;
+	int ret;
+
+	msg.addr = reg_address;
+	msg.data = 0;
+
+	da9052_lock(da9052);
+	ret = da9052->read(da9052, &msg);
+	if (ret)
+		goto ssc_comm_err;
+	da9052_unlock(da9052);
+
+	*reg_data = msg.data;
+	return 0;
+ssc_comm_err:
+	da9052_unlock(da9052);
+	return ret;
+}
+
+static int da9052_write(struct da9052 *da9052, u8 reg_address, u8 reg_data)
+{
+	struct da9052_ssc_msg msg;
+	int ret;
+
+	msg.addr = reg_address;
+	msg.data = reg_data;
+
+	da9052_lock(da9052);
+	ret = da9052->write(da9052, &msg);
+	if (ret)
+		goto ssc_comm_err;
+	da9052_unlock(da9052);
+
+	return 0;
+ssc_comm_err:
+	da9052_unlock(da9052);
+	return ret;
+}
+
+static s32 da9052_read_ich(struct da9052 *da9052, u16 *data)
+{
+	s32 ret;
+	u8 reg_data;
+
+	ret = da9052_read(da9052, DA9052_ICHGAV_REG, &reg_data);
+	if (ret)
+		return ret;
+
+	*data = (u16)reg_data;
+	return 0;
+	return 0;
+}
+
+static s32 da9052_read_vbbat(struct da9052 *da9052, u16 *data)
+{
+	s32 ret;
+	u16 temp;
+
+	ret = da9052_adc_read(da9052, DA9052_ADC_VBBAT, &temp);
+	if (ret)
+		return ret;
+	else {
+		*data = temp;
+		return 0;
+	}
+}
+
+static s32 da9052_read_vbat(struct da9052 *da9052, u16 *data)
+{
+	s32 ret;
+	u16 temp;
+
+	ret = da9052_adc_read(da9052, DA9052_ADC_VBAT, &temp);
+	if (ret)
+		return ret;
+	else {
+		*data = temp;
+		return 0;
+	}
+}
+
+static s32 da9052_read_tjunc(struct da9052 *da9052, u16 *data)
+{
+	s32 ret;
+	u16 temp;
+
+	ret = da9052_adc_read(da9052, DA9052_TJUNCRES_REG, &temp);
+	if (ret)
+		return ret;
+	*data = temp;
+	temp = 0;
+
+	ret = da9052_adc_read(da9052, DA9052_TOFFSET_REG, &temp);
+	if (ret)
+		return ret;
+
+	*data -= temp;
+
+	return 0;
+}
+
+static s32 da9052_read_tbat(struct da9052 *da9052, u16 *data)
+{
+	s32 ret;
+	u8 reg_data;
+
+	ret = da9052_read(da9052, DA9052_TBATRES_REG, &reg_data);
+	if (ret)
+		return ret;
+
+	*data = (u16)reg_data;;
+	return 0;
+}
+
+static s32 da9052_read_vddout(struct da9052 *da9052, u16 *data)
+{
+	u8 reg_data;
+	s32 ret;
+
+	ret = da9052_read(da9052, DA9052_ADCCONT_REG, &reg_data);
+	if (ret)
+		return ret;
+
+	if (!(reg_data & DA9052_ADCCONT_AUTOVDDEN)) {
+		reg_data = (reg_data | DA9052_ADCCONT_AUTOVDDEN);
+
+		ret = da9052_write(da9052, DA9052_INPUTCONT_REG, reg_data);
+		if (ret)
+			return ret;
+		reg_data = 0x0;
+
+		ret = da9052_read(da9052, DA9052_ADCCONT_REG, &reg_data);
+		if (ret)
+			return ret;
+
+		if (reg_data & DA9052_ADCCONT_ADCMODE)
+			msleep(1);
+		else
+			msleep(10);
+
+		ret = da9052_read(da9052, DA9052_VDDRES_REG, &reg_data);
+		if (ret)
+			return ret;
+
+		*data = (u16)reg_data;
+
+		ret = da9052_read(da9052, DA9052_ADCCONT_REG, &reg_data);
+		if (ret)
+			return ret;
+
+		reg_data = reg_data & ~(DA9052_ADCCONT_AUTOVDDEN);
+		ret = da9052_write(da9052, DA9052_ADCCONT_REG, reg_data);
+		if (ret)
+			return ret;
+	} else {
+		ret = da9052_read(da9052, DA9052_VDDRES_REG, &reg_data);
+		if (ret)
+			return ret;
+
+		*data = (u16)reg_data;
+	}
+	return 0;
+}
+
+static s32 da9052_bat_get_chg_current(struct da9052 *da9052, u16 *buffer)
+{
+
+	if (bat_status.status == DA9052_DISCHARGING_WITHOUT_CHARGER)
+		return DA9052_BAT_NOT_CHARGING;
+
+	if (da9052_read_ich(da9052, buffer))
+		return DA9052_CHG_MEASUREMENT_FAIL;
+
+	bat_info.chg_current = ichg_reg_to_mA(*buffer);
+	*buffer = bat_info.chg_current;
+
+	return 0;
+}
+
+static u16 filter_sample(u16 *buffer)
+{
+	u8 count;
+	u16 tempvalue = 0;
+	u16 ret;
+
+	if (buffer == NULL)
+		return -EINVAL;
+
+	for (count = 0; count < FILTER_SIZE; count++)
+		tempvalue = tempvalue + *(buffer + count);
+
+	ret = tempvalue/FILTER_SIZE;
+	return ret;
+}
+
+static s32 da9052_bat_get_chg_junc_temperature(struct da9052 *da9052,
+						u16 *buffer)
+{
+	u8 count;
+	u16 filterqueue[FILTER_SIZE];
+
+	if (bat_status.status != DA9052_CHARGING)
+		return DA9052_BAT_NOT_CHARGING;
+
+	for (count = 0; count < FILTER_SIZE; count++) {
+		if (da9052_read_tjunc(da9052, &filterqueue[count]))
+			return DA9052_CHG_MEASUREMENT_FAIL;
+	}
+	filterqueue[0] = filter_sample(filterqueue);
+	bat_info.chg_junc_temp = (((1708 * filterqueue[0])/1000) - 106);
+	*buffer = bat_info.chg_junc_temp;
+	return 0;
+}
+
+static s32 da9052_bat_get_battery_voltage(struct da9052 *da9052, u16 *buffer)
+{
+	u8 count;
+	u16 filterqueue[FILTER_SIZE];
+	s32 ret;
+	for (count = 0; count < FILTER_SIZE; count++) {
+		ret = da9052_read_vbat(da9052, &filterqueue[count]);
+		if (ret)
+			return DA9052_CHG_MEASUREMENT_FAIL;
+	}
+	filterqueue[0] = filter_sample(filterqueue);
+	bat_info.bat_voltage = volt_reg_to_mV(filterqueue[0]);
+	*buffer = bat_info.bat_voltage;
+	return 0;
+}
+
+static s32 da9052_bat_get_backup_battery_voltage(struct da9052 *da9052,
+							u16 *buffer)
+{
+	u8 count;
+	u16 filterqueue[FILTER_SIZE];
+
+	for (count = 0; count < FILTER_SIZE; count++) {
+		if (da9052_read_vbbat(da9052, &filterqueue[count]))
+			return DA9052_CHG_MEASUREMENT_FAIL;
+	}
+	filterqueue[0] = filter_sample(filterqueue);
+	bat_info.backup_bat_voltage =
+				volt_reg_to_mV(filterqueue[0]);
+	*buffer = bat_info.backup_bat_voltage;
+
+	return 0;
+}
+
+static s32 capture_first_correct_vbat_sample(struct da9052 *da9052,
+						u16 *battery_voltage)
+{
+	static u8 count;
+	s32 ret = 0;
+	u32 temp_data = 0;
+
+	ret = da9052_bat_get_battery_voltage(da9052,
+					&bat_hysteresis.bat_volt_arr[count]);
+	if (ret)
+		return ret;
+
+	count++;
+
+	if (count < VBAT_FIRST_VALID_DETECT_ITERATION)
+		return -EINVAL;
+
+	for (count = 0; count < (VBAT_FIRST_VALID_DETECT_ITERATION - 1);
+		count++) {
+		temp_data = (bat_hysteresis.bat_volt_arr[count] *
+				HYSTERESIS_WINDOW_SIZE)/100;
+		bat_hysteresis.upper_limit = bat_hysteresis.bat_volt_arr[count]
+						+ temp_data;
+		bat_hysteresis.lower_limit = bat_hysteresis.bat_volt_arr[count]
+						- temp_data;
+
+		if ((bat_hysteresis.bat_volt_arr[count + 1] <
+			bat_hysteresis.upper_limit) &&
+			(bat_hysteresis.bat_volt_arr[count + 1] >
+				bat_hysteresis.lower_limit)){
+
+			*battery_voltage = (bat_hysteresis.bat_volt_arr[count] +
+					bat_hysteresis.bat_volt_arr[count+1])/2;
+			bat_hysteresis.hys_flag = 1;
+			return 0;
+		}
+	}
+
+	for (count = 0; count < (VBAT_FIRST_VALID_DETECT_ITERATION - 1);
+		count++)
+		bat_hysteresis.bat_volt_arr[count] =
+				bat_hysteresis.bat_volt_arr[count + 1];
+
+	return -EINVAL;
+}
+
+static u32 interpolated(u32 vbat_lower, u32  vbat_upper, u32  level_lower,
+			u32  level_upper, u32 bat_voltage)
+{
+	s32 temp;
+
+	temp = ((level_upper - level_lower) * 1000)/(vbat_upper - vbat_lower);
+	temp = level_lower + (((bat_voltage - vbat_lower) * temp)/1000);
+
+	return temp;
+}
+
+static u8 select_temperature(u8 temp_index, u16 bat_temperature)
+{
+	u16 temp_temperature = 0;
+	u16 ret;
+
+	temp_temperature = (temperature_lookup_ref[temp_index] +
+				temperature_lookup_ref[temp_index+1]) / 2;
+
+	if (bat_temperature >= temp_temperature) {
+		ret = temp_index+1;
+		return ret;
+	} else
+		return temp_index;
+}
+
+static s32 check_hystersis(struct da9052 *da9052, u16 *bat_voltage)
+{
+	u8 ret = 0;
+	u32 offset = 0;
+
+	if (bat_hysteresis.hys_flag == 0) {
+		ret =
+		capture_first_correct_vbat_sample(da9052,
+				&bat_hysteresis.array_hys_batvoltage[0]);
+		if (ret)
+			return ret;
+	}
+
+	ret = da9052_bat_get_battery_voltage(da9052,
+		&bat_hysteresis.array_hys_batvoltage[1]);
+
+	if (ret)
+		return ret;
+	*bat_voltage = bat_hysteresis.array_hys_batvoltage[1];
+
+	if ((bat_hysteresis.upper_limit < *bat_voltage) ||
+			(bat_hysteresis.lower_limit > *bat_voltage)) {
+
+		bat_hysteresis.index++;
+
+		if (bat_hysteresis.index == HYSTERESIS_NO_OF_READING) {
+			bat_hysteresis.index = 0;
+			offset = ((*bat_voltage) * HYSTERESIS_WINDOW_SIZE)/100;
+			bat_hysteresis.upper_limit = (*bat_voltage) + offset;
+			bat_hysteresis.lower_limit = (*bat_voltage) - offset;
+
+		} else
+			return CHG_HYSTERSIS_CHECK_FAILED;
+	} else {
+		bat_hysteresis.index = 0;
+		offset = ((*bat_voltage) * HYSTERESIS_WINDOW_SIZE)/100;
+		bat_hysteresis.upper_limit = (*bat_voltage) + offset;
+		bat_hysteresis.lower_limit = (*bat_voltage) - offset;
+	}
+	*bat_voltage = ((CHG_HYSTERESIS_CONST *
+			bat_hysteresis.array_hys_batvoltage[0])/100) +
+			(((100 - CHG_HYSTERESIS_CONST) *
+				bat_hysteresis.array_hys_batvoltage[1])/100);
+
+	if ((bat_status.status == DA9052_DISCHARGING_WITHOUT_CHARGER) &&
+		(*bat_voltage > bat_hysteresis.array_hys_batvoltage[0]))
+		*bat_voltage = bat_hysteresis.array_hys_batvoltage[0];
+
+	bat_hysteresis.array_hys_batvoltage[0] = *bat_voltage;
+
+	return 0;
+}
+
+static s32 da9052_bat_get_charger_vddout(struct da9052 *da9052, u16 *buffer)
+{
+	u8 count;
+	s32 ret;
+	u16 filterqueue[FILTER_SIZE];
+
+	if (bat_status.status != DA9052_CHARGING)
+		return DA9052_BAT_NOT_CHARGING;
+
+	for (count = 0; count < FILTER_SIZE; count++) {
+		ret = da9052_read_vddout(da9052, &filterqueue[count]);
+		if (ret)
+			return DA9052_CHG_MEASUREMENT_FAIL;
+	}
+	filterqueue[0] = filter_sample(filterqueue);
+	bat_info.vddout = vddout_reg_to_mV(filterqueue[0]);
+	*buffer = bat_info.vddout;
+
+	return 0;
+}
+
+void da9052_bat_vddlow_notifier(struct da9052_eh_nb *eh_data, u32 event)
+{
+	struct da9052_charger_device *charger =\
+		container_of(eh_data, struct da9052_charger_device,
+					vddlow_eh_data);
+	u16 buffer = 0;
+	s32 ret;
+
+	if (!monitoring_status.vddout_status) {
+		monitoring_status.vddout_status = 1;
+		ret = da9052_bat_get_charger_vddout(charger->da9052, &buffer);
+		monitoring_status.vddout_value = buffer;
+	}
+}
+
+void da9052_bat_tbat_notifier(struct da9052_eh_nb *eh_data, u32 event)
+{
+	if (!tbat_event_occur) {
+		bat_status.health = POWER_SUPPLY_HEALTH_OVERHEAT;
+		tbat_event_occur = 1;
+		monitoring_status.bat_temp_status = 1;
+		monitoring_status.bat_temp_value = bat_info.bat_temp;
+	}
+}
+
+static s32 da9052_bat_suspend_charging(struct da9052 *da9052)
+{
+
+	u8 reg_data;
+	u8 msg_data;
+	s32 ret;
+
+	if ((bat_status.status == DA9052_DISCHARGING_WITHOUT_CHARGER) ||
+		(bat_status.status == DA9052_DISCHARGING_WITH_CHARGER))
+		return 0;
+
+	ret = da9052_read(da9052, DA9052_INPUTCONT_REG, &reg_data);
+	if (ret)
+		return ret;
+
+	msg_data = (reg_data | DA9052_INPUTCONT_DCINSUSP);
+	msg_data = (msg_data | DA9052_INPUTCONT_VBUSSUSP);
+
+	ret = da9052_write(da9052, DA9052_INPUTCONT_REG, msg_data);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+static s32 da9052_bat_resume_charging(struct da9052 *da9052)
+{
+	u8 reg_data;
+	u8 msg_data;
+	s32 ret;
+
+	if (bat_status.illegalbattery)
+		return -EINVAL;
+
+	if ((bat_status.status == DA9052_CHARGING))
+		return 0;
+
+	ret = da9052_read(da9052, DA9052_INPUTCONT_REG, &reg_data);
+	if (ret)
+		return ret;
+
+	msg_data = (reg_data & ~(DA9052_INPUTCONT_DCINSUSP));
+	msg_data = (reg_data & ~(DA9052_INPUTCONT_VBUSSUSP));
+
+	ret = da9052_write(da9052, DA9052_INPUTCONT_REG, msg_data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+static s32  da9052_bat_get_battery_temperature(struct da9052 *da9052,
+						u16 *buffer)
+{
+	u8 count;
+	u16 filterqueue[FILTER_SIZE];
+	for (count = 0; count < FILTER_SIZE; count++) {
+		if (da9052_read_tbat(da9052, &filterqueue[count]))
+			return DA9052_CHG_MEASUREMENT_FAIL;
+	}
+	filterqueue[0] = filter_sample(filterqueue);
+	bat_info.bat_temp = filterqueue[0];
+	*buffer = bat_info.bat_temp;
+	return 0;
+}
+
+static s32 da9052_bat_register_event(struct da9052_charger_device *chg_device,
+					u8 event_type)
+{
+	s32 ret;
+	switch (event_type) {
+	case VDD_LOW_EVE:
+		if (!event_status.da9052_event_vddlow) {
+			chg_device->vddlow_eh_data.eve_type = event_type;
+			chg_device->vddlow_eh_data.call_back =
+				da9052_bat_vddlow_notifier;
+			ret = chg_device->da9052->register_event_notifier
+				(chg_device->da9052,
+					&chg_device->vddlow_eh_data);
+			if (ret)
+				return DA9052_IRQ_REGISTER_FAILED;
+			event_status.da9052_event_vddlow = 1;
+		}
+	break;
+	case TBAT_EVE:
+		if (!event_status.da9052_event_tbat) {
+			chg_device->tbat_eh_data.eve_type = event_type;
+			chg_device->tbat_eh_data.call_back =
+				da9052_bat_tbat_notifier;
+			ret = chg_device->da9052->register_event_notifier
+				(chg_device->da9052,
+					&chg_device->tbat_eh_data);
+			if (ret)
+				return DA9052_IRQ_REGISTER_FAILED;
+			event_status.da9052_event_tbat = 1;
+		}
+	break;
+	default:
+		return DA9052_BAT_INVALID_EVENT;
+	}
+
+	return 0;
+}
+
+static s32 da9052_bat_unregister_event(struct da9052_charger_device
*chg_device,
+					u8 event_type)
+{
+	s32 ret;
+	switch (event_type) {
+	case VDD_LOW_EVE:
+		if (event_status.da9052_event_vddlow) {
+			ret =
+				chg_device->da9052->unregister_event_notifier
+				(chg_device->da9052,
+					&chg_device->vddlow_eh_data);
+		if (ret)
+				return DA9052_IRQ_UNREGISTER_FAILED;
+			event_status.da9052_event_vddlow = 0;
+		}
+	break;
+	case TBAT_EVE:
+		if (event_status.da9052_event_tbat) {
+			ret =
+				chg_device->da9052->unregister_event_notifier
+				(chg_device->da9052, &chg_device->tbat_eh_data);
+			if (ret)
+				return DA9052_IRQ_UNREGISTER_FAILED;
+			event_status.da9052_event_tbat = 0;
+		}
+	break;
+	default:
+		return DA9052_BAT_INVALID_EVENT;
+	}
+
+	return 0;
+}
+#if (DA9052_ILLEGAL_BATTERY_DETECT)
+static s32 detect_illegal_battery(struct da9052 *da9052)
+{
+	u16 buffer = 0;
+	s32  ret = 0;
+
+	ret = da9052_bat_get_battery_temperature(da9052, &buffer);
+	if (ret)
+		return ret;
+
+	if (buffer > BAT_WITH_NO_RESISTOR)
+		bat_status.illegalbattery = 1;
+	else
+		bat_status.illegalbattery = 0;
+
+	if (bat_status.illegalbattery)
+		da9052_bat_suspend_charging(da9052);
+
+	return 0;
+}
+#endif
+
+static int da9052_bat_get_property(struct power_supply *psy,
+				enum power_supply_property psp,
+				union power_supply_propval *val)
+{
+	s32 ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		if (bat_status.status == DA9052_CHARGING)
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+
+		else if (bat_status.status ==
+			DA9052_DISCHARGING_WITH_CHARGER)
+			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+
+		else if (bat_status.status ==
+				DA9052_DISCHARGING_WITHOUT_CHARGER)
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+
+		else if (bat_status.status == DA9052_CHARGEEND)
+			val->intval = POWER_SUPPLY_STATUS_FULL;
+
+	break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		if (bat_status.charger_type == DA9052_NOCHARGER)
+			val->intval = 0;
+		else
+			val->intval = 1;
+	break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		if (bat_status.illegalbattery)
+			val->intval = 0;
+	else
+		val->intval = 1;
+	break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		if (bat_status.health != POWER_SUPPLY_HEALTH_OVERHEAT) {
+			if (bat_status.illegalbattery)
+				bat_status.health = POWER_SUPPLY_HEALTH_UNKNOWN;
+
+			else if (bat_status.cal_capacity <
+							BAT_CAPACITY_LIMIT_LOW)
+				bat_status.health = POWER_SUPPLY_HEALTH_DEAD;
+
+			else
+				bat_status.health = POWER_SUPPLY_HEALTH_GOOD;
+		}
+		val->intval = bat_status.health;
+	break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+		val->intval = (bat_target_voltage * 1000);
+	break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		val->intval = (BAT_VOLT_CUTOFF * 1000);
+	break;
+	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+		val->intval = (bat_info.bat_voltage * 1000);
+	break;
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+		val->intval = (bat_info.chg_current * 1000);
+	break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = bat_status.cal_capacity;
+	break;
+	case POWER_SUPPLY_PROP_CAPACITY_LEVEL:
+		if (bat_status.illegalbattery)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_UNKNOWN;
+
+		else if (bat_status.cal_capacity < BAT_CAPACITY_LIMIT_LOW)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_CRITICAL;
+
+		else if (bat_status.cal_capacity < BAT_CAPACITY_LIMIT_HIGH)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
+
+		else if (bat_status.cal_capacity == BAT_CAPACITY_FULL)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_FULL;
+
+		else if (bat_status.cal_capacity > BAT_CAPACITY_LIMIT_HIGH)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_HIGH;
+
+		else
+			val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+	break;
+	case POWER_SUPPLY_PROP_TEMP:
+		val->intval = bat_temp_reg_to_C(bat_info.bat_temp);
+	break;
+	case POWER_SUPPLY_PROP_MANUFACTURER:
+		val->strval = BAT_MANUFACTURER;
+	break;
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = BAT_TYPE;
+	break;
+	default:
+		ret = -EINVAL;
+	break;
+	}
+	return 0;
+}
+static void da9052_battery_setup_psy(struct da9052_charger_device *chg_device)
+{
+	battery_info.name = DRIVER_NAME;
+	battery_info.technology = BAT_TYPE;
+	battery_info.voltage_max_design =
+				(chg_device->bat_target_voltage*1000);
+	battery_info.voltage_min_design = (BAT_VOLT_CUTOFF*1000);
+	battery_info.energy_full_design = BAT_CAPACITY_FULL;
+	battery_info.energy_empty_design = BAT_CAPACITY_LIMIT_LOW;
+	battery_info.use_for_apm = 1;
+
+	chg_device->psy.name = DRIVER_NAME;
+	chg_device->psy.use_for_apm = 1;
+	chg_device->psy.type = POWER_SUPPLY_TYPE_BATTERY;
+	chg_device->psy.get_property = da9052_bat_get_property;
+
+	chg_device->psy.properties = da902_bat_props;
+	chg_device->psy.num_properties = ARRAY_SIZE(da902_bat_props);
+
+};
+
+static void da9052_charger_status_update(struct da9052_charger_device
+						*chg_device)
+{
+	u16 current_value = 0;
+	u8 regvalue = 0;
+	u8 reg_data;
+	s32 ret;
+
+	ret = da9052_read(chg_device->da9052, DA9052_STATUSA_REG, &regvalue);
+	if (ret)
+		return;
+
+	ret = da9052_read(chg_device->da9052, DA9052_STATUSB_REG, &reg_data);
+	if (ret)
+		return;
+
+	if ((regvalue & DA9052_STATUSA_DCINSEL)
+				&& (regvalue & DA9052_STATUSA_DCINDET)) {
+
+		if ((reg_data & DA9052_STATUSB_CHGEND) != 0)  {
+			if (da9052_bat_get_chg_current(chg_device->da9052,
+							&current_value))
+				return;
+
+			if (current_value >= chg_device->chg_end_current) {
+				bat_status.status = DA9052_CHARGING;
+				bat_status.charger_type = DA9052_WALL_CHARGER;
+			} else {
+				bat_status.charger_type = DA9052_WALL_CHARGER;
+				bat_status.status =
+					DA9052_DISCHARGING_WITH_CHARGER;
+			}
+		} else {
+			bat_status.status = DA9052_CHARGING;
+			bat_status.charger_type = DA9052_WALL_CHARGER;
+		}
+	} else if ((regvalue & DA9052_STATUSA_VBUSSEL)
+				&& (regvalue & DA9052_STATUSA_VBUSDET)) {
+
+		if (regvalue & DA9052_STATUSA_VDATDET)
+			bat_status.charger_type = DA9052_USB_CHARGER;
+		else
+			bat_status.charger_type = DA9052_USB_HUB;
+		if ((reg_data & DA9052_STATUSB_CHGEND) != 0) {
+			if (da9052_bat_get_chg_current(chg_device->da9052,
+							&current_value))
+				return;
+			if (current_value >= chg_device->chg_end_current)
+				bat_status.status = DA9052_CHARGING;
+			else
+				bat_status.status =
+					DA9052_DISCHARGING_WITH_CHARGER;
+		} else
+			bat_status.status = DA9052_CHARGING;
+	} else if (regvalue & DA9052_STATUSA_DCINDET) {
+		bat_status.charger_type = DA9052_WALL_CHARGER;
+		bat_status.status = DA9052_DISCHARGING_WITH_CHARGER;
+	} else if (regvalue & DA9052_STATUSA_VBUSDET) {
+		if (regvalue & DA9052_STATUSA_VDATDET) {
+			bat_status.charger_type = DA9052_USB_CHARGER;
+			bat_status.status = DA9052_DISCHARGING_WITH_CHARGER;
+		} else {
+			bat_status.charger_type = DA9052_USB_HUB;
+			bat_status.status = DA9052_DISCHARGING_WITH_CHARGER;
+		}
+	} else {
+		bat_status.charger_type = DA9052_NOCHARGER;
+		bat_status.status = DA9052_DISCHARGING_WITHOUT_CHARGER;
+	}
+	return;
+}
+
+static s32 monitor_current(struct da9052_charger_device *chg_device)
+{
+	static u8 flag1;
+	u8 count = 0;
+	u16 current_value = 0;
+	u16 tempvalue = 0;
+	u16 avg_value = 0;
+
+	if (da9052_bat_get_chg_current(chg_device->da9052, &current_value))
+		return DA9052_CHG_MEASUREMENT_FAIL;
+
+	if (flag1 == 0) {
+		for (count = 0; count < NUMBER_OF_STORE_CURENT_READING; count++)
+			bat_info.chg_current_raw[count] = 0;
+
+		tempvalue = (CURRENT_MONITORING_WINDOW*current_value)/100;
+		chg_device->threshold.ichg_av_thr_min = current_value-tempvalue;
+		chg_device->threshold.ichg_av_thr_max = current_value+tempvalue;
+		flag1 = 1;
+	}
+
+	for (count = (NUMBER_OF_STORE_CURENT_READING - 1); count > 0; count--)
+		bat_info.chg_current_raw[count] =
+				bat_info.chg_current_raw[count-1];
+	bat_info.chg_current_raw[0] = current_value;
+
+	for (count = 0; count < NUMBER_OF_STORE_CURENT_READING; count++) {
+		if (bat_info.chg_current_raw[count] == 0)
+			break;
+		avg_value = avg_value + bat_info.chg_current_raw[count];
+	}
+	if (count != 0)
+		avg_value = avg_value/count;
+	else
+		avg_value = current_value;
+
+	tempvalue = (CURRENT_MONITORING_WINDOW*avg_value)/100;
+
+	if (((current_value < chg_device->threshold.ichg_av_thr_min)
+		|| (current_value > chg_device->threshold.ichg_av_thr_max))) {
+
+		monitoring_status.current_status = 1;
+		monitoring_status.current_value = current_value;
+
+		chg_device->threshold.ichg_av_thr_min = avg_value - tempvalue;
+		chg_device->threshold.ichg_av_thr_max = avg_value + tempvalue;
+		return -(DA9052_CHG_MONITORING_FAIL);
+	} else {
+		monitoring_status.current_status = 0;
+		monitoring_status.current_value = current_value;
+	}
+	chg_device->threshold.ichg_av_thr_min = avg_value - tempvalue;
+	chg_device->threshold.ichg_av_thr_max = avg_value + tempvalue;
+
+	return 0;
+
+}
+
+static s32 monitor_junc_temperature(struct da9052_charger_device *chg_device)
+{
+	u16 buffer;
+	u8 ret = 0;
+
+	ret = da9052_bat_get_chg_junc_temperature(chg_device->da9052, &buffer);
+	if (ret)
+		return ret;
+
+	if (buffer > chg_device->threshold.tjunc_thr_limit) {
+		if (chg_device->sw_temp_cntr == 1)
+			da9052_bat_suspend_charging(chg_device->da9052);
+
+		monitoring_status.junc_temp_status = 1;
+		monitoring_status.junc_temp_value = buffer;
+
+		return DA9052_CHG_MONITORING_FAIL;
+	} else {
+		monitoring_status.junc_temp_status = 0;
+		monitoring_status.junc_temp_value = buffer;
+	}
+	return 0;
+}
+
+static s32 da9052_get_bat_level(struct da9052_charger_device *chg_device)
+{
+	u16 bat_temperature;
+	u16 bat_voltage;
+	u32 vbat_lower, vbat_upper, level_upper, level_lower, level;
+	u8 access_index = 0;
+	u8 index = 0, ret;
+	u8 flag = 0;
+
+	ret = 0;
+	vbat_lower = 0;
+	vbat_upper = 0;
+	level_upper = 0;
+	level_lower = 0;
+
+	ret = check_hystersis(chg_device->da9052, &bat_voltage);
+	if (ret)
+		return ret;
+
+	ret = da9052_bat_get_battery_temperature(chg_device->da9052,
+						&bat_temperature);
+	if (ret)
+		return ret;
+	for (index = 0; index < (NO_OF_LOOKUP_TABLE-1); index++) {
+		if (bat_temperature <= temperature_lookup_ref[0]) {
+			access_index = 0;
+			break;
+		} else if (bat_temperature >
+				temperature_lookup_ref[NO_OF_LOOKUP_TABLE]){
+			access_index = NO_OF_LOOKUP_TABLE - 1;
+			break;
+		} else if ((bat_temperature >= temperature_lookup_ref[index])
+		&& (bat_temperature >= temperature_lookup_ref[index+1])) {
+			access_index =
+				select_temperature(index, bat_temperature);
+			break;
+		}
+	}
+
+	if (bat_voltage >= vbat_vs_capacity_look_up[access_index][0][0]) {
+		bat_status.cal_capacity = 100;
+			return 0;
+	}
+	if (bat_voltage <=
+	vbat_vs_capacity_look_up[access_index][LOOK_UP_TABLE_SIZE-1][0]) {
+			bat_status.cal_capacity = 0;
+			return 0;
+	}
+
+	flag = 0;
+
+	for (index = 0; index < (LOOK_UP_TABLE_SIZE-1); index++) {
+		if ((bat_voltage <=
+			vbat_vs_capacity_look_up[access_index][index][0]) &&
+			(bat_voltage >=
+			vbat_vs_capacity_look_up[access_index][index+1][0])) {
+			vbat_upper =
+			vbat_vs_capacity_look_up[access_index][index][0];
+			vbat_lower =
+			vbat_vs_capacity_look_up[access_index][index+1][0];
+			level_upper =
+			vbat_vs_capacity_look_up[access_index][index][1];
+			level_lower =
+			vbat_vs_capacity_look_up[access_index][index+1][1];
+			flag = 1;
+			break;
+		}
+	}
+
+	if (!flag)
+		return DA9052_INVALID_VBAT_VALUE;
+
+	level = interpolated(vbat_lower, vbat_upper, level_lower,
+					level_upper, bat_voltage);
+	bat_status.cal_capacity = level;
+
+	return 0;
+}
+
+static s32 monitor_bat_temperature(struct da9052_charger_device *chg_device)
+{
+	u16 buffer;
+	u8 ret = 0;
+
+	ret = da9052_bat_get_battery_temperature(chg_device->da9052, &buffer);
+	if (ret)
+		return ret;
+
+	if (buffer > chg_device->threshold.tbat_thr_limit) {
+		if (chg_device->sw_temp_cntr == 1)
+			da9052_bat_suspend_charging(chg_device->da9052);
+
+		monitoring_status.bat_temp_status = 1;
+		monitoring_status.bat_temp_value = buffer;
+		return DA9052_CHG_MONITORING_FAIL;
+	} else {
+		monitoring_status.bat_temp_status = 0;
+		monitoring_status.bat_temp_value = buffer;
+	}
+
+	return 0;
+}
+
+static void da9052_monitoring_thread(struct work_struct *work)
+{
+	u8 mon_count = 0;
+	s32 ret = 0;
+	struct da9052_charger_device *chg_device;
+	chg_device = container_of(work, struct da9052_charger_device,
+					work.work);
+
+	if (bat_status.status == DA9052_CHARGING) {
+		if (mon_count == 0) {
+			ret = monitor_current(chg_device);
+			if (DA9052_CHG_MONITORING_FAIL == ret)
+				pr_debug("charging Current Monitoring\
+					failed, %d\n", mon_count);
+		} else if (mon_count == 1) {
+			ret = monitor_junc_temperature(chg_device);
+			if (DA9052_CHG_MONITORING_FAIL == ret)
+				pr_debug("Charger Junction Temperature\
+					Monitoring failed\n");
+		}
+	}
+
+	if (mon_count == 2) {
+		ret = da9052_get_bat_level(chg_device);
+		if (!ret) {
+			if (bat_status.cal_capacity < BAT_CAPACITY_LIMIT_LOW) {
+				monitoring_status.bat_level_status = 1;
+				monitoring_status.bat_level =
+						bat_status.cal_capacity;
+			} else {
+				monitoring_status.bat_level_status = 0;
+				monitoring_status.bat_level =
+					bat_status.cal_capacity;
+			}
+		} else
+			pr_debug("Battery Measurement Fails = %d\n", ret);
+	}
+
+	if (mon_count == 3) {
+		ret = monitor_bat_temperature(chg_device);
+		if (ret)
+			pr_debug("BAT Temperature Monitoring failed\n");
+	}
+
+	mon_count++;
+	if (mon_count == 4)
+		mon_count = 0;
+
+	schedule_delayed_work(&chg_device->work,
+				chg_device->monitoring_interval);
+}
+
+static s32 da9052_bat_configure_thresholds(
+				struct da9052_charger_device *chg_device,
+				struct da9052_bat_threshold thresholds)
+{
+	s32 ret;
+	u8 reg_data;
+
+	if ((VDDOUT_MON_LOWER > thresholds.vddout_mon) &&
+				(VDDOUT_MON_UPPER < thresholds.vddout_mon))
+		return DA9052_INVALID_VDDOUT_MON_VALUE;
+
+	reg_data = vddout_mon_mV_to_reg(thresholds.vddout_mon);
+	ret = da9052_write(chg_device->da9052, DA9052_VDDMON_REG, reg_data);
+	if (ret)
+		return ret;
+
+	reg_data = 0;
+
+	if (ICHG_THRESHOLD_UPPER < thresholds.ichg_thr)
+		return DA9052_INVALID_ICHG_THRESHOLD_VALUE;
+
+	reg_data = ichg_mA_to_reg(thresholds.ichg_thr);
+	ret = da9052_write(chg_device->da9052, DA9052_ICHGTHD_REG, reg_data);
+	if (ret)
+		return ret;
+	reg_data = 0;
+
+	if (TBAT_MAX_THRESHOLD_LIMIT < thresholds.tbat_thr_max)
+		return DA9052_INVALID_BAT_TEMP_HIGH;
+
+	reg_data = thresholds.tbat_thr_max;
+	ret = da9052_write(chg_device->da9052, DA9052_TBATHIGHP_REG, reg_data);
+	if (ret)
+		return ret;
+	reg_data = 0;
+
+	if (TBAT_MIN_THRESHOLD_LIMIT < thresholds.tbat_thr_min)
+		return DA9052_INVALID_BAT_TEMP_LOW;
+
+	reg_data = thresholds.tbat_thr_min;
+	ret = da9052_write(chg_device->da9052, DA9052_TBATLOW_REG, reg_data);
+	if (ret)
+		return ret;
+	reg_data = 0;
+
+	if (TBAT_HIGHNS_THRESHOLD_LIMIT < thresholds.tbat_thr_highns)
+		return DA9052_INVALID_BAT_TEMP_HIGHN;
+
+	reg_data = thresholds.tbat_thr_highns;
+	ret = da9052_write(chg_device->da9052, DA9052_TBATHIGHIN_REG,
+				reg_data);
+	if (ret)
+		return ret;
+	reg_data = 0;
+
+	chg_device->threshold = thresholds;
+
+	return 0;
+}
+
+static s32 da9052_bat_configure_charger(
+				struct da9052_charger_device *chg_device,
+				struct da9052_charger_device charger)
+{
+	s32 ret;
+	u8 reg_data;
+
+	ret = da9052_read(chg_device->da9052, DA9052_CHGBUCK_REG, &reg_data);
+	if (ret)
+		return ret;
+
+	reg_data = charger.charger_buck_lp ?
+				(reg_data | DA9052_CHGBUCK_CHGBUCKLP) :
+				 (reg_data & ~(DA9052_CHGBUCK_CHGBUCKLP));
+
+	reg_data = charger.usb_charger_det ?
+				(reg_data | DA9052_CHGBUCK_CHGUSBILIM) :
+				(reg_data & ~(DA9052_CHGBUCK_CHGUSBILIM));
+
+	reg_data = charger.auto_temp_cntr ?
+				(reg_data | DA9052_CHGBUCK_CHGTEMP) :
+				(reg_data & ~(DA9052_CHGBUCK_CHGTEMP));
+
+	ret = da9052_write(chg_device->da9052, DA9052_CHGBUCK_REG, reg_data);
+	if (ret)
+		return ret;
+
+	reg_data = 0x0;
+
+	if ((ISET_LOW > charger.dcin_current) &&
+				(charger.dcin_current > ISET_HIGH))
+		return DA9052_INVALID_DCIN_CURRENT_LIMIT_VALUE;
+
+	if ((ISET_LOW > charger.vbus_current) &&
+				(charger.vbus_current > ISET_HIGH))
+		return DA9052_INVALID_VBUS_CURRENT_LIMIT_VALUE;
+
+	if ((ISET_LOW > charger.usb_charger_current) &&
+				(charger.usb_charger_current > ISET_HIGH))
+		return DA9052_INVALID_USB_CHARGER_CURRENT_LIMIT_VALUE;
+
+	chg_device->dcin_current = charger.dcin_current;
+	chg_device->vbus_current = charger.vbus_current;
+	chg_device->usb_charger_current = charger.usb_charger_current;
+
+	if ((iset_mA_to_reg(charger.vbus_current) &&
+				iset_mA_to_reg(charger.dcin_current)) == 0)
+		return -EINVAL;
+
+	reg_data = iset_mA_to_reg(charger.vbus_current) |
+			(iset_mA_to_reg(charger.dcin_current) << 4);
+
+	ret = da9052_write(chg_device->da9052, DA9052_ISET_REG, reg_data);
+	if (ret)
+		return ret;
+
+	reg_data = 0x0;
+
+	ret = da9052_read(chg_device->da9052, DA9052_BATCHG_REG, &reg_data);
+	if (ret)
+		return ret;
+
+	if ((PRE_CHARGE_0MA != charger.precharging_current) &&
+			(PRE_CHARGE_20MA != charger.precharging_current) &&
+			(PRE_CHARGE_40MA != charger.precharging_current) &&
+			(PRE_CHARGE_60MA != charger.precharging_current)) {
+		return DA9052_INVALID_PRECHARGE_CURRENT_VALUE;
+	}
+
+	reg_data = (reg_data & ~(DA9052_BATCHG_ICHGPRE));
+	reg_data = (reg_data |
+			(precharge_mA_to_reg(charger.precharging_current)));
+
+	ret = da9052_write(chg_device->da9052, DA9052_BATCHG_REG, reg_data);
+	if (ret)
+		return ret;
+
+	reg_data = 0x0;
+
+	if (charger.charging_time > MAX_BAT_CHARGING_TIME)
+		return DA9052_INVALID_CHARGING_TIME;
+
+	if ((BAT_TARGET_VOLTAGE_LOWER_LIMIT > charger.bat_target_voltage) &&
+		(charger.bat_target_voltage > BAT_TARGET_VOLTAGE_UPPER_LIMIT))
+		return DA9052_INVALID_CHG_BAT_VOLTAGE;
+
+	if ((CHARGER_VOLTAGE_DROP_LOWER_LIMIT > charger.charger_voltage_drop) &&
+		(charger.charger_voltage_drop >
+				CHARGER_VOLTAGE_DROP_UPPER_LIMIT))
+		return DA9052_INVALID_CHG_VOLTAGE_DROP;
+
+	reg_data = (charger.charging_time/CHARGING_TIME_INTERVAL) |
+			bat_mV_to_reg(charger.bat_target_voltage) |
+			bat_drop_mV_to_reg(charger.charger_voltage_drop);
+
+	ret = da9052_write(chg_device->da9052, DA9052_CHGCONT_REG, reg_data);
+	if (ret)
+		return ret;
+
+	reg_data = 0x0;
+
+	if ((BAT_VOLTAGE_THRESHOLD_LOWER_LIMIT > charger.voltage_threshold) &&
+		(charger.voltage_threshold >
+					BAT_VOLTAGE_THRESHOLD_UPPER_LIMIT))
+		return DA9052_INVALID_CHG_VOLTAGE_THRESHOLD;
+
+	reg_data = vch_thr_mV_to_reg(charger.voltage_threshold);
+	reg_data |= (charger.ichg_low_cntr ? DA9052_INPUTCONT_ICHGLOW : 0);
+	reg_data |= (charger.timer_mode ? DA9052_INPUTCONT_TCTRMODE : 0);
+
+	ret = da9052_write(chg_device->da9052, DA9052_INPUTCONT_REG, reg_data);
+	if (ret)
+		return ret;
+
+	reg_data = 0x0;
+
+	reg_data = (charger.chg_end_current / 4);
+
+	ret = da9052_write(chg_device->da9052, DA9052_ICHGEND_REG, reg_data);
+	if (ret)
+		return ret;
+	reg_data = 0x0;
+
+	chg_device->sw_temp_cntr = charger.sw_temp_cntr;
+	chg_device->monitoring_interval =
+			msecs_to_jiffies(charger.monitoring_interval);
+
+	return 0;
+}
+
+static int da9052_battery_probe(struct platform_device *pdev)
+{
+	struct da9052_charger_device *chg_device;
+	u8 reg_data;
+	int ret;
+
+	chg_device = kzalloc(sizeof(*chg_device), GFP_KERNEL);
+	if (!chg_device)
+		return -ENOMEM;
+
+	chg_device->da9052 = dev_get_drvdata(pdev->dev.parent);
+	platform_set_drvdata(pdev, chg_device);
+
+	chg_device->monitoring_interval = msecs_to_jiffies(MONITORING_INTERVAL);
+	chg_device->sw_temp_cntr = SW_TEMP_CONTROL_EN;
+	chg_device->usb_charger_current = 0;
+
+	ret = da9052_read(chg_device->da9052, DA9052_CHGCONT_REG, &reg_data);
+	if (ret)
+		goto err_charger_init;
+
+	chg_device->charger_voltage_drop = bat_drop_reg_to_mV(reg_data &&
+							DA9052_CHGCONT_TCTR);
+	chg_device->bat_target_voltage =
+			bat_reg_to_mV(reg_data && DA9052_CHGCONT_VCHGBAT);
+	bat_target_voltage = chg_device->bat_target_voltage;
+
+	reg_data = 0;
+	ret = da9052_read(chg_device->da9052, DA9052_ICHGEND_REG, &reg_data);
+	if (ret)
+		goto err_charger_init;
+
+	chg_device->chg_end_current = ichg_reg_to_mA(reg_data);
+
+	chg_device->threshold.tbat_thr_limit = SW_BAT_TEMP_THRESHOLD;
+	chg_device->threshold.tjunc_thr_limit = SW_JUNC_TEMP_THRESHOLD;
+
+	sprintf(bat_info.manufacture, BAT_MANUFACTURER);
+	bat_status.illegalbattery = 0;
+
+	bat_hysteresis.upper_limit = 0;
+	bat_hysteresis.lower_limit = 0;
+	bat_hysteresis.hys_flag = 0;
+
+	bat_status.charger_type = DA9052_NOCHARGER;
+	bat_status.status = DA9052_CHARGING;
+	bat_status.charging_mode = DA9052_NONE;
+	tbat_event_occur = 0;
+#if (DA9052_ILLEGAL_BATTERY_DETECT)
+	detect_illegal_battery(chg_device->da9052);
+#endif
+
+	da9052_charger_status_update(chg_device);
+
+	da9052_battery_setup_psy(chg_device);
+
+	INIT_DELAYED_WORK(&chg_device->work, da9052_monitoring_thread);
+	schedule_delayed_work(&chg_device->work,
+		chg_device->monitoring_interval);
+
+	ret = da9052_bat_register_event(chg_device, VDD_LOW_EVE);
+	if (ret)
+		goto err_charger_init;
+	da9052_bat_register_event(chg_device, TBAT_EVE);
+	if (ret)
+		goto err_charger_init;
+
+	ret = da9052_bat_configure_thresholds(chg_device, thresholds);
+	if (ret)
+		goto err_charger_init;
+
+	ret = da9052_bat_configure_charger(chg_device, charger);
+	if (ret)
+		goto err_charger_init;
+
+	ret = power_supply_register(&pdev->dev, &chg_device->psy);
+	 if (ret)
+		goto err_charger_init;
+
+	return 0;
+err_charger_init:
+	platform_set_drvdata(pdev, NULL);
+	kfree(chg_device);
+	return ret;
+}
+
+static int da9052_battery_remove(struct platform_device *dev)
+{
+
+	struct da9052_charger_device *chg_device = platform_get_drvdata(dev);
+
+	cancel_delayed_work_sync(&chg_device->work);
+
+	da9052_bat_unregister_event(chg_device, VDD_LOW_EVE);
+	da9052_bat_unregister_event(chg_device, TBAT_EVE);
+
+	cancel_delayed_work_sync(&chg_device->work);
+
+	power_supply_unregister(&chg_device->psy);
+
+	kfree(chg_device);
+
+	return 0;
+}
+
+static struct platform_driver da9052_battery_driver = {
+	.driver	= {
+		.name	= "DRIVER_NAME",
+		.owner	= THIS_MODULE,
+	},
+	.probe = da9052_battery_probe,
+	.remove = da9052_battery_remove,
+};
+
+static int da9052_battery_init(void)
+{
+	return platform_driver_register(&da9052_battery_driver);
+}
+module_init(da9052_battery_init);
+
+static void da9052_battery_exit(void)
+{
+	platform_driver_unregister(&da9052_battery_driver);
+}
+module_exit(da9052_battery_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("Battery driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff -urpN linux-2.6.34/drivers/power/Kconfig
linux-2.6.34_test/drivers/power/Kconfig
--- linux-2.6.34/drivers/power/Kconfig	2010-05-17 02:17:36.000000000 +0500
+++ linux-2.6.34_test/drivers/power/Kconfig	2010-07-13 17:49:07.000000000 +0500
@@ -131,4 +131,10 @@ config CHARGER_PCF50633
 	help
 	 Say Y to include support for NXP PCF50633 Main Battery Charger.

+config BATTERY_DA9052
+	tristate "DA9052 battery driver"
+	depends on PMIC_DA9052
+	help
+	  Say Y here to enable support for batteries charger integrated into
+	  DA9052 PMIC.
 endif # POWER_SUPPLY
diff -urpN linux-2.6.34/drivers/power/Makefile
linux-2.6.34_test/drivers/power/Makefile
--- linux-2.6.34/drivers/power/Makefile	2010-05-17 02:17:36.000000000 +0500
+++ linux-2.6.34_test/drivers/power/Makefile	2010-07-13 17:49:13.000000000 +0500
@@ -32,3 +32,4 @@ obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00
 obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
 obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
 obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
+obj-$(CONFIG_BATTERY_DA9052)	+= da9052_battery.o
diff -urpN linux-2.6.34/include/linux/mfd/da9052/bat.h
linux-2.6.34_test/include/linux/mfd/da9052/bat.h
--- linux-2.6.34/include/linux/mfd/da9052/bat.h	1970-01-01
05:00:00.000000000 +0500
+++ linux-2.6.34_test/include/linux/mfd/da9052/bat.h	2010-07-13
17:50:04.000000000 +0500
@@ -0,0 +1,335 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * bat.h: BAT driver header file
+*/
+
+#ifndef _BAT_H
+#define _BAT_H
+
+#define DA9052_CHG_MEASUREMENT_FAIL			-154
+#define DA9052_INVALID_VDDOUT_MON_VALUE			-155
+#define DA9052_INVALID_ICHG_THRESHOLD_VALUE		-156
+#define DA9052_INVALID_BAT_TEMP_HIGH			-157
+#define DA9052_INVALID_BAT_TEMP_LOW			-158
+#define DA9052_INVALID_BAT_TEMP_HIGHN			-159
+#define DA9052_INVALID_PRECHARGE_CURRENT_VALUE		-160
+#define DA9052_INVALID_CHARGING_TIME			-161
+#define DA9052_INVALID_CHG_BAT_VOLTAGE			-162
+#define DA9052_INVALID_CHG_VOLTAGE_DROP			-163
+#define DA9052_INVALID_CHG_VOLTAGE_THRESHOLD		-164
+#define DA9052_INVALID_CHG_CURRENT_END_VALUE		-165
+#define DA9052_INVALID_DCIN_CURRENT_LIMIT_VALUE		-166
+#define DA9052_INVALID_VBUS_CURRENT_LIMIT_VALUE		-167
+#define DA9052_INVALID_USB_CHARGER_CURRENT_LIMIT_VALUE	-176
+#define DA9052_CHG_MONITORING_FAIL			-169
+#define CHG_HYSTERSIS_CHECK_FAILED			-177
+#define DA9052_IRQ_UNREGISTER_FAILED			-178
+#define DA9052_IRQ_REGISTER_FAILED			-179
+#define DA9052_BAT_INVALID_EVENT			-180
+#define DA9052_INVALID_VBAT_VALUE			-181
+#define DA9052_BAT_NOT_CHARGING				-183
+
+/* STATIC CONFIGURATION */
+#define SW_TEMP_CONTROL_EN			0
+#define MONITORING_INTERVAL			500
+#define SW_BAT_TEMP_THRESHOLD			60
+#define SW_JUNC_TEMP_THRESHOLD			120
+#define BAT_MANUFACTURER			"Samsung"
+#define BAT_TYPE				POWER_SUPPLY_TECHNOLOGY_LION
+#define LOOK_UP_TABLE_SIZE			68
+#define NO_OF_LOOKUP_TABLE			3
+#define HYSTERESIS_WINDOW_SIZE			1
+#define CURRENT_MONITORING_WINDOW		10
+#define BAT_WITH_NO_RESISTOR			62
+#define BAT_CAPACITY_LIMIT_LOW			4
+#define BAT_CAPACITY_FULL			100
+#define BAT_CAPACITY_LIMIT_HIGH			70
+#define CHG_HYSTERESIS_CONST			89
+#define HYSTERESIS_READING_INTERVAL		1000
+#define HYSTERESIS_NO_OF_READING		10
+#define FILTER_SIZE				4
+#define NUMBER_OF_STORE_CURENT_READING		4
+#define BAT_VOLT_CUTOFF				2800
+#define VBAT_FIRST_VALID_DETECT_ITERATION	3
+#define DA9052_ILLEGAL_BATTERY_DETECT		1
+#define DA9052_BAT_FILTER_HYS			0
+
+#define VDDOUT_MON_LOWER			2500
+#define VDDOUT_MON_UPPER			4500
+#define ICHG_THRESHOLD_UPPER			1000
+#define TBAT_MAX_THRESHOLD_LIMIT		255
+#define TBAT_MIN_THRESHOLD_LIMIT		255
+#define TBAT_HIGHNS_THRESHOLD_LIMIT		255
+#define ISET_LOW				70
+#define ISET_HIGH				1300
+#define MAX_BAT_CHARGING_TIME			450
+#define BAT_TARGET_VOLTAGE_LOWER_LIMIT		4100
+#define BAT_TARGET_VOLTAGE_UPPER_LIMIT		4400
+#define CHARGER_VOLTAGE_DROP_LOWER_LIMIT	100
+#define CHARGER_VOLTAGE_DROP_UPPER_LIMIT	400
+#define CHARGING_TIME_INTERVAL			30
+#define BAT_VOLTAGE_THRESHOLD_LOWER_LIMIT	3700
+#define BAT_VOLTAGE_THRESHOLD_UPPER_LIMIT	4400
+
+static const u16 temperature_lookup_ref[NO_OF_LOOKUP_TABLE] = {10, 25, 40};
+static u32 const vbat_vs_capacity_look_up[NO_OF_LOOKUP_TABLE]
+					[LOOK_UP_TABLE_SIZE][2] = {
+	/* For temperature 10 degree celisus*/
+	{
+		{4082, 100}, {4036, 98},
+		{4020, 96}, {4008, 95},
+		{3997, 93}, {3983, 91},
+		{3964, 90}, {3943, 88},
+		{3926, 87}, {3912, 85},
+		{3900, 84}, {3890, 82},
+		{3881, 80}, {3873, 79},
+		{3865, 77}, {3857, 76},
+		{3848, 74}, {3839, 73},
+		{3829, 71}, {3820, 70},
+		{3811, 68}, {3802, 67},
+		{3794, 65}, {3785, 64},
+		{3778, 62}, {3770, 61},
+		{3763, 59}, {3756, 58},
+		{3750, 56}, {3744, 55},
+		{3738, 53}, {3732, 52},
+		{3727, 50}, {3722, 49},
+		{3717, 47}, {3712, 46},
+		{3708, 44}, {3703, 43},
+		{3700, 41}, {3696, 40},
+		{3693, 38}, {3691, 37},
+		{3688, 35}, {3686, 34},
+		{3683, 32}, {3681, 31},
+		{3678, 29}, {3675, 28},
+		{3672, 26}, {3669, 25},
+		{3665, 23}, {3661, 22},
+		{3656, 21}, {3651, 19},
+		{3645, 18}, {3639, 16},
+		{3631, 15}, {3622, 13},
+		{3611, 12}, {3600, 10},
+		{3587, 9}, {3572, 7},
+		{3548, 6}, {3503, 5},
+		{3420, 3}, {3268, 2},
+		{2992, 1}, {2746, 0}
+	},
+	/* For temperature 25 degree celisus */
+	{
+		{4102, 100}, {4065, 98},
+		{4048, 96}, {4034, 95},
+		{4021, 93}, {4011, 92},
+		{4001, 90}, {3986, 88},
+		{3968, 87}, {3952, 85},
+		{3938, 84}, {3926, 82},
+		{3916, 81}, {3908, 79},
+		{3900, 77}, {3892, 76},
+		{3883, 74}, {3874, 73},
+		{3864, 71}, {3855, 70},
+		{3846, 68}, {3836, 67},
+		{3827, 65}, {3819, 64},
+		{3810, 62}, {3801, 61},
+		{3793, 59}, {3786, 58},
+		{3778, 56}, {3772, 55},
+		{3765, 53}, {3759, 52},
+		{3754, 50}, {3748, 49},
+		{3743, 47}, {3738, 46},
+		{3733, 44}, {3728, 43},
+		{3724, 41}, {3720, 40},
+		{3716, 38}, {3712, 37},
+		{3709, 35}, {3706, 34},
+		{3703, 33}, {3701, 31},
+		{3698, 30}, {3696, 28},
+		{3693, 27}, {3690, 25},
+		{3687, 24}, {3683, 22},
+		{3680, 21}, {3675, 19},
+		{3671, 18}, {3666, 17},
+		{3660, 15}, {3654, 14},
+		{3647, 12}, {3639, 11},
+		{3630, 9}, {3621, 8},
+		{3613, 6}, {3606, 5},
+		{3597, 4}, {3582, 2},
+		{3546, 1}, {2747, 0}
+	},
+	/* For temperature 40 degree celisus*/
+	{
+		{4114, 100}, {4081, 98},
+		{4065, 96}, {4050, 95},
+		{4036, 93}, {4024, 92},
+		{4013, 90}, {4002, 88},
+		{3990, 87}, {3976, 85},
+		{3962, 84}, {3950, 82},
+		{3939, 81}, {3930, 79},
+		{3921, 77}, {3912, 76},
+		{3902, 74}, {3893, 73},
+		{3883, 71}, {3874, 70},
+		{3865, 68}, {3856, 67},
+		{3847, 65}, {3838, 64},
+		{3829, 62}, {3820, 61},
+		{3812, 59}, {3803, 58},
+		{3795, 56}, {3787, 55},
+		{3780, 53}, {3773, 52},
+		{3767, 50}, {3761, 49},
+		{3756, 47}, {3751, 46},
+		{3746, 44}, {3741, 43},
+		{3736, 41}, {3732, 40},
+		{3728, 38}, {3724, 37},
+		{3720, 35}, {3716, 34},
+		{3713, 33}, {3710, 31},
+		{3707, 30}, {3704, 28},
+		{3701, 27}, {3698, 25},
+		{3695, 24}, {3691, 22},
+		{3686, 21}, {3681, 19},
+		{3676, 18}, {3671, 17},
+		{3666, 15}, {3661, 14},
+		{3655, 12}, {3648, 11},
+		{3640, 9}, {3632, 8},
+		{3622, 6}, {3616, 5},
+		{3611, 4}, {3604, 2},
+		{3594, 1}, {2747, 0}
+	}
+};
+
+enum charge_status_enum {
+	DA9052_NONE = 1,
+	DA9052_CHARGING,
+	DA9052_DISCHARGING_WITH_CHARGER,
+	DA9052_DISCHARGING_WITHOUT_CHARGER,
+	DA9052_PRECHARGING,
+	DA9052_LINEARCHARGING,
+	DA9052_CHARGEEND
+};
+
+enum charger_type_enum {
+	DA9052_NOCHARGER = 1,
+	DA9052_USB_HUB,
+	DA9052_USB_CHARGER,
+	DA9052_WALL_CHARGER
+};
+
+enum precharge_enum {
+	PRE_CHARGE_0MA = 0,
+	PRE_CHARGE_20MA = 20,
+	PRE_CHARGE_40MA = 40,
+	PRE_CHARGE_60MA = 60
+};
+
+struct da9052_bat_event_registration {
+	u8	da9052_event_vddlow:1;
+	u8	da9052_event_tbat:1;
+};
+
+struct da9052_bat_threshold {
+	u16		vddout_mon;
+	u16		ichg_thr;
+	u16		tbat_thr_min;
+	u16		tbat_thr_max;
+	u16		tbat_thr_highns;
+	u16		tbat_thr_limit;
+	u16		tjunc_thr_limit;
+	u16		ichg_av_thr_min;
+	u16		ichg_av_thr_max;
+};
+
+struct da9052_bat_hysteresis {
+	u16		bat_volt_arr[3];
+	u16		array_hys_batvoltage[2];
+	u16		upper_limit;
+	u16		lower_limit;
+	u8		index;
+	u8		hys_flag;
+};
+
+struct da9052_bat_status {
+	u8		cal_capacity;
+	u8		charging_mode;
+	u8		charger_type;
+	u8		health;
+	u8		status;
+	u8		illegalbattery;
+};
+
+struct monitoring_state {
+	u16		vddout_value;
+	u16		bat_temp_value;
+	u16		current_value;
+	u16		junc_temp_value;
+	u8		bat_level;
+	u8		vddout_status:1;
+	u8		bat_temp_status:1;
+	u8		junc_temp_status:1;
+	u8		current_status:1;
+	u8		bat_level_status:1;
+};
+
+struct da9052_bat_device {
+	char		manufacture[32];
+	u16		chg_current_raw[NUMBER_OF_STORE_CURENT_READING];
+	u16		chg_current;
+	u16		chg_junc_temp;
+	u16		bat_voltage;
+	u16		backup_bat_voltage;
+	u16		bat_temp;
+	u16		vddout;
+};
+
+struct da9052_charger_device {
+	struct da9052_bat_threshold	threshold;
+	struct da9052			*da9052;
+	struct delayed_work		work;
+	struct power_supply		psy;
+	struct da9052_eh_nb		vddlow_eh_data;
+	struct da9052_eh_nb		tbat_eh_data;
+	u16				monitoring_interval;
+	u8				hys_flag;
+	u16				charger_voltage_drop;
+	u16				bat_target_voltage;
+	u16				voltage_threshold;
+	u16				dcin_current;
+	u16				vbus_current;
+	u16				usb_charger_current;;
+	u16				chg_end_current;
+	u16				precharging_current;
+	u16				charging_time;
+	u8				timer_mode:1;
+	u8				charger_buck_lp:1;
+	u8				usb_charger_det:1;
+	u8				ichg_low_cntr:1;
+	u8				sw_temp_cntr:1;
+	u8				auto_temp_cntr:1;
+};
+
+static inline  u8 bat_temp_reg_to_C(u16 value) { return (55 - value); }
+static inline  u8 bat_mV_to_reg(u16 value) { return (((value-4100)/100)<<4); }
+static inline  u8 bat_drop_mV_to_reg(u16 value)
+		{ return (((value-100)/100)<<6); }
+static inline  u16 bat_reg_to_mV(u8 value) { return ((value*100) + 4100); }
+static inline  u16 bat_drop_reg_to_mV(u8 value) { return ((value*100)+100); }
+static inline  u8 vch_thr_mV_to_reg(u16 value) { return ((value-3700)/100); }
+static inline  u8 precharge_mA_to_reg(u8 value) { return ((value/20)<<6); }
+static inline  u8 vddout_mon_mV_to_reg(u16 value)
+		{ return (((value-2500)*128)/1000); }
+static inline  u16 vddout_reg_to_mV(u8 value)
+		{ return ((value*1000)/128)+2500; }
+static inline  u16 volt_reg_to_mV(u16 value)
+		{ return ((value*1000)/512)+2500; }
+
+static inline  u8 ichg_mA_to_reg(u16 value) { return (value/4); }
+
+static inline  u16 ichg_reg_to_mA(u8 value) { return ((value*3900)/1000); }
+
+static inline u8 iset_mA_to_reg(u16 iset_value)
+			{\
+			if ((70 <= iset_value) && (iset_value <= 120)) \
+				return (iset_value-70)/10; \
+			else if ((400 <= iset_value) && (iset_value <= 700)) \
+				return ((iset_value-400)/50)+6; \
+			else if ((900 <= iset_value) && (iset_value <= 1300)) \
+				return ((iset_value-900)/200)+13; else return 0;
+			}
+
+#endif
+
