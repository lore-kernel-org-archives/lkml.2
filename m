Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030201Ab2K3L6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:58:04 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33263 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab2K3L6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:58:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, cbou@mail.ru,
        dwmw2@infradead.org, rajanikanth.hv@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/12] ab8500_bm: Rename battery management platform data to something more logical
Date: Fri, 30 Nov 2012 11:57:28 +0000
Message-Id: <1354276654-590-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
References: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform specific battery management configuration data structure
is currently called 'bat' short for 'battery'; however, it contains
information for all components of the battery management group, rather
than information pertaining to the battery itself - there are other
structures for that. So, in keeping with its structure namesake
'abx500_bm_data', we rename it to 'bm' here. Using similar logic,
we're also renaming 'bmdevs_of_probe' to the more device specific
'ab8500_bm_of_probe'.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_bmdata.c   |    6 +--
 drivers/power/ab8500_btemp.c    |   60 ++++++++++-----------
 drivers/power/ab8500_charger.c  |   24 ++++-----
 drivers/power/ab8500_fg.c       |   96 ++++++++++++++++-----------------
 drivers/power/abx500_chargalg.c |  112 +++++++++++++++++++--------------------
 include/linux/mfd/abx500.h      |    6 +--
 6 files changed, 152 insertions(+), 152 deletions(-)

diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
index df5a590..c2fb2c5 100644
--- a/drivers/power/ab8500_bmdata.c
+++ b/drivers/power/ab8500_bmdata.c
@@ -452,9 +452,9 @@ struct abx500_bm_data ab8500_bm_data = {
 	.fg_params              = &fg,
 };
 
-int __devinit bmdevs_of_probe(struct device *dev,
-			      struct device_node *np,
-			      struct abx500_bm_data **battery)
+int __devinit ab8500_bm_of_probe(struct device *dev,
+				 struct device_node *np,
+				 struct abx500_bm_data **battery)
 {
 	struct batres_vs_temp *tmp_batres_tbl;
 	struct device_node *np_bat_supply;
diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 5d1bf0b..33ed0fc 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -78,7 +78,7 @@ struct ab8500_btemp_ranges {
  * @parent:		Pointer to the struct ab8500
  * @gpadc:		Pointer to the struct gpadc
  * @fg:			Pointer to the struct fg
- * @bat:		Pointer to the abx500_bm platform data
+ * @bm:           	Platform specific battery management information
  * @btemp_psy:		Structure for BTEMP specific battery properties
  * @events:		Structure for information about events triggered
  * @btemp_ranges:	Battery temperature range structure
@@ -95,7 +95,7 @@ struct ab8500_btemp {
 	struct ab8500 *parent;
 	struct ab8500_gpadc *gpadc;
 	struct ab8500_fg *fg;
-	struct abx500_bm_data *bat;
+	struct abx500_bm_data *bm;
 	struct power_supply btemp_psy;
 	struct ab8500_btemp_events events;
 	struct ab8500_btemp_ranges btemp_ranges;
@@ -149,13 +149,13 @@ static int ab8500_btemp_batctrl_volt_to_res(struct ab8500_btemp *di,
 		return (450000 * (v_batctrl)) / (1800 - v_batctrl);
 	}
 
-	if (di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL) {
+	if (di->bm->adc_therm == ABx500_ADC_THERM_BATCTRL) {
 		/*
 		 * If the battery has internal NTC, we use the current
 		 * source to calculate the resistance, 7uA or 20uA
 		 */
 		rbs = (v_batctrl * 1000
-		       - di->bat->gnd_lift_resistance * inst_curr)
+		       - di->bm->gnd_lift_resistance * inst_curr)
 		      / di->curr_source;
 	} else {
 		/*
@@ -211,7 +211,7 @@ static int ab8500_btemp_curr_source_enable(struct ab8500_btemp *di,
 		return 0;
 
 	/* Only do this for batteries with internal NTC */
-	if (di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL && enable) {
+	if (di->bm->adc_therm == ABx500_ADC_THERM_BATCTRL && enable) {
 		if (di->curr_source == BTEMP_BATCTRL_CURR_SRC_7UA)
 			curr = BAT_CTRL_7U_ENA;
 		else
@@ -243,7 +243,7 @@ static int ab8500_btemp_curr_source_enable(struct ab8500_btemp *di,
 				__func__);
 			goto disable_curr_source;
 		}
-	} else if (di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL && !enable) {
+	} else if (di->bm->adc_therm == ABx500_ADC_THERM_BATCTRL && !enable) {
 		dev_dbg(di->dev, "Disable BATCTRL curr source\n");
 
 		/* Write 0 to the curr bits */
@@ -459,9 +459,9 @@ static int ab8500_btemp_measure_temp(struct ab8500_btemp *di)
 	int rbat, rntc, vntc;
 	u8 id;
 
-	id = di->bat->batt_id;
+	id = di->bm->batt_id;
 
-	if (di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL &&
+	if (di->bm->adc_therm == ABx500_ADC_THERM_BATCTRL &&
 			id != BATTERY_UNKNOWN) {
 
 		rbat = ab8500_btemp_get_batctrl_res(di);
@@ -476,8 +476,8 @@ static int ab8500_btemp_measure_temp(struct ab8500_btemp *di)
 		}
 
 		temp = ab8500_btemp_res_to_temp(di,
-			di->bat->bat_type[id].r_to_t_tbl,
-			di->bat->bat_type[id].n_temp_tbl_elements, rbat);
+			di->bm->bat_type[id].r_to_t_tbl,
+			di->bm->bat_type[id].n_temp_tbl_elements, rbat);
 	} else {
 		vntc = ab8500_gpadc_convert(di->gpadc, BTEMP_BALL);
 		if (vntc < 0) {
@@ -493,8 +493,8 @@ static int ab8500_btemp_measure_temp(struct ab8500_btemp *di)
 		rntc = 230000 * vntc / (VTVOUT_V - vntc);
 
 		temp = ab8500_btemp_res_to_temp(di,
-			di->bat->bat_type[id].r_to_t_tbl,
-			di->bat->bat_type[id].n_temp_tbl_elements, rntc);
+			di->bm->bat_type[id].r_to_t_tbl,
+			di->bm->bat_type[id].n_temp_tbl_elements, rntc);
 		prev = temp;
 	}
 	dev_dbg(di->dev, "Battery temperature is %d\n", temp);
@@ -515,7 +515,7 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
 	u8 i;
 
 	di->curr_source = BTEMP_BATCTRL_CURR_SRC_7UA;
-	di->bat->batt_id = BATTERY_UNKNOWN;
+	di->bm->batt_id = BATTERY_UNKNOWN;
 
 	res =  ab8500_btemp_get_batctrl_res(di);
 	if (res < 0) {
@@ -524,23 +524,23 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
 	}
 
 	/* BATTERY_UNKNOWN is defined on position 0, skip it! */
-	for (i = BATTERY_UNKNOWN + 1; i < di->bat->n_btypes; i++) {
-		if ((res <= di->bat->bat_type[i].resis_high) &&
-			(res >= di->bat->bat_type[i].resis_low)) {
+	for (i = BATTERY_UNKNOWN + 1; i < di->bm->n_btypes; i++) {
+		if ((res <= di->bm->bat_type[i].resis_high) &&
+			(res >= di->bm->bat_type[i].resis_low)) {
 			dev_dbg(di->dev, "Battery detected on %s"
 				" low %d < res %d < high: %d"
 				" index: %d\n",
-				di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL ?
+				di->bm->adc_therm == ABx500_ADC_THERM_BATCTRL ?
 				"BATCTRL" : "BATTEMP",
-				di->bat->bat_type[i].resis_low, res,
-				di->bat->bat_type[i].resis_high, i);
+				di->bm->bat_type[i].resis_low, res,
+				di->bm->bat_type[i].resis_high, i);
 
-			di->bat->batt_id = i;
+			di->bm->batt_id = i;
 			break;
 		}
 	}
 
-	if (di->bat->batt_id == BATTERY_UNKNOWN) {
+	if (di->bm->batt_id == BATTERY_UNKNOWN) {
 		dev_warn(di->dev, "Battery identified as unknown"
 			", resistance %d Ohm\n", res);
 		return -ENXIO;
@@ -550,13 +550,13 @@ static int ab8500_btemp_id(struct ab8500_btemp *di)
 	 * We only have to change current source if the
 	 * detected type is Type 1, else we use the 7uA source
 	 */
-	if (di->bat->adc_therm == ABx500_ADC_THERM_BATCTRL &&
-			di->bat->batt_id == 1) {
+	if (di->bm->adc_therm == ABx500_ADC_THERM_BATCTRL &&
+			di->bm->batt_id == 1) {
 		dev_dbg(di->dev, "Set BATCTRL current source to 20uA\n");
 		di->curr_source = BTEMP_BATCTRL_CURR_SRC_20UA;
 	}
 
-	return di->bat->batt_id;
+	return di->bm->batt_id;
 }
 
 /**
@@ -586,9 +586,9 @@ static void ab8500_btemp_periodic_work(struct work_struct *work)
 	}
 
 	if (di->events.ac_conn || di->events.usb_conn)
-		interval = di->bat->temp_interval_chg;
+		interval = di->bm->temp_interval_chg;
 	else
-		interval = di->bat->temp_interval_nochg;
+		interval = di->bm->temp_interval_nochg;
 
 	/* Schedule a new measurement */
 	queue_delayed_work(di->btemp_wq,
@@ -815,7 +815,7 @@ static int ab8500_btemp_get_property(struct power_supply *psy,
 			val->intval = 1;
 		break;
 	case POWER_SUPPLY_PROP_TECHNOLOGY:
-		val->intval = di->bat->bat_type[di->bat->batt_id].name;
+		val->intval = di->bm->bat_type[di->bm->batt_id].name;
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
 		val->intval = ab8500_btemp_get_temp(di);
@@ -985,10 +985,10 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s no mem for ab8500_btemp\n", __func__);
 		return -ENOMEM;
 	}
-	di->bat = pdev->mfd_cell->platform_data;
-	if (!di->bat) {
+	di->bm = pdev->mfd_cell->platform_data;
+	if (!di->bm) {
 		if (np) {
-			ret = bmdevs_of_probe(&pdev->dev, np, &di->bat);
+			ret = ab8500_bm_of_probe(&pdev->dev, np, &di->bm);
 			if (ret) {
 				dev_err(&pdev->dev,
 					"failed to get battery information\n");
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index d27dd7f..21dc842 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -189,7 +189,7 @@ struct ab8500_charger_usb_state {
  * @autopower_cfg	platform specific power config support for "pwron after pwrloss"
  * @parent:		Pointer to the struct ab8500
  * @gpadc:		Pointer to the struct gpadc
- * @bat:		Pointer to the abx500_bm platform data
+ * @bm:           	Platform specific battery management information
  * @flags:		Structure for information about events triggered
  * @usb_state:		Structure for usb stack information
  * @ac_chg:		AC charger power supply
@@ -226,7 +226,7 @@ struct ab8500_charger {
 	bool autopower_cfg;
 	struct ab8500 *parent;
 	struct ab8500_gpadc *gpadc;
-	struct abx500_bm_data *bat;
+	struct abx500_bm_data *bm;
 	struct ab8500_charger_event_flags flags;
 	struct ab8500_charger_usb_state usb_state;
 	struct ux500_charger ac_chg;
@@ -1034,7 +1034,7 @@ static int ab8500_charger_set_vbus_in_curr(struct ab8500_charger *di,
 	int min_value;
 
 	/* We should always use to lowest current limit */
-	min_value = min(di->bat->chg_params->usb_curr_max, ich_in);
+	min_value = min(di->bm->chg_params->usb_curr_max, ich_in);
 
 	switch (min_value) {
 	case 100:
@@ -1176,7 +1176,7 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
 		volt_index = ab8500_voltage_to_regval(vset);
 		curr_index = ab8500_current_to_regval(iset);
 		input_curr_index = ab8500_current_to_regval(
-			di->bat->chg_params->ac_curr_max);
+			di->bm->chg_params->ac_curr_max);
 		if (volt_index < 0 || curr_index < 0 || input_curr_index < 0) {
 			dev_err(di->dev,
 				"Charger voltage or current too high, "
@@ -1193,7 +1193,7 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
 		}
 		/* MainChInputCurr: current that can be drawn from the charger*/
 		ret = ab8500_charger_set_main_in_curr(di,
-			di->bat->chg_params->ac_curr_max);
+			di->bm->chg_params->ac_curr_max);
 		if (ret) {
 			dev_err(di->dev, "%s Failed to set MainChInputCurr\n",
 				__func__);
@@ -1209,7 +1209,7 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
 		}
 
 		/* Check if VBAT overshoot control should be enabled */
-		if (!di->bat->enable_overshoot)
+		if (!di->bm->enable_overshoot)
 			overshoot = MAIN_CH_NO_OVERSHOOT_ENA_N;
 
 		/* Enable Main Charger */
@@ -1376,7 +1376,7 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
 			return ret;
 		}
 		/* Check if VBAT overshoot control should be enabled */
-		if (!di->bat->enable_overshoot)
+		if (!di->bm->enable_overshoot)
 			overshoot = USB_CHG_NO_OVERSHOOT_ENA_N;
 
 		/* Enable USB Charger */
@@ -2454,8 +2454,8 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 	ret = abx500_set_register_interruptible(di->dev,
 		AB8500_RTC,
 		AB8500_RTC_BACKUP_CHG_REG,
-		di->bat->bkup_bat_v |
-		di->bat->bkup_bat_i);
+		di->bm->bkup_bat_v |
+		di->bm->bkup_bat_i);
 	if (ret) {
 		dev_err(di->dev, "failed to setup backup battery charging\n");
 		goto out;
@@ -2644,10 +2644,10 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s no mem for ab8500_charger\n", __func__);
 		return -ENOMEM;
 	}
-	di->bat = pdev->mfd_cell->platform_data;
-	if (!di->bat) {
+	di->bm = pdev->mfd_cell->platform_data;
+	if (!di->bm) {
 		if (np) {
-			ret = bmdevs_of_probe(&pdev->dev, np, &di->bat);
+			ret = ab8500_bm_of_probe(&pdev->dev, np, &di->bm);
 			if (ret) {
 				dev_err(&pdev->dev,
 					"failed to get battery information\n");
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 5a9f58d..4cf2313 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -173,7 +173,7 @@ struct inst_curr_result_list {
  * @avg_cap:		Average capacity filter
  * @parent:		Pointer to the struct ab8500
  * @gpadc:		Pointer to the struct gpadc
- * @bat:		Pointer to the abx500_bm platform data
+ * @bm:           	Platform specific battery management information
  * @fg_psy:		Structure that holds the FG specific battery properties
  * @fg_wq:		Work queue for running the FG algorithm
  * @fg_periodic_work:	Work to run the FG algorithm periodically
@@ -212,7 +212,7 @@ struct ab8500_fg {
 	struct ab8500_fg_avg_cap avg_cap;
 	struct ab8500 *parent;
 	struct ab8500_gpadc *gpadc;
-	struct abx500_bm_data *bat;
+	struct abx500_bm_data *bm;
 	struct power_supply fg_psy;
 	struct workqueue_struct *fg_wq;
 	struct delayed_work fg_periodic_work;
@@ -355,7 +355,7 @@ static int ab8500_fg_is_low_curr(struct ab8500_fg *di, int curr)
 	/*
 	 * We want to know if we're in low current mode
 	 */
-	if (curr > -di->bat->fg_params->high_curr_threshold)
+	if (curr > -di->bm->fg_params->high_curr_threshold)
 		return true;
 	else
 		return false;
@@ -648,7 +648,7 @@ int ab8500_fg_inst_curr_finalize(struct ab8500_fg *di, int *res)
 	 * 112.9nAh assumes 10mOhm, but fg_res is in 0.1mOhm
 	 */
 	val = (val * QLSB_NANO_AMP_HOURS_X10 * 36 * 4) /
-		(1000 * di->bat->fg_res);
+		(1000 * di->bm->fg_res);
 
 	if (di->turn_off_fg) {
 		dev_dbg(di->dev, "%s Disable FG\n", __func__);
@@ -751,7 +751,7 @@ static void ab8500_fg_acc_cur_work(struct work_struct *work)
 	 * 112.9nAh assumes 10mOhm, but fg_res is in 0.1mOhm
 	 */
 	di->accu_charge = (val * QLSB_NANO_AMP_HOURS_X10) /
-		(100 * di->bat->fg_res);
+		(100 * di->bm->fg_res);
 
 	/*
 	 * Convert to unit value in mA
@@ -763,7 +763,7 @@ static void ab8500_fg_acc_cur_work(struct work_struct *work)
 	 * 112.9nAh assumes 10mOhm, but fg_res is in 0.1mOhm
 	 */
 	di->avg_curr = (val * QLSB_NANO_AMP_HOURS_X10 * 36) /
-		(1000 * di->bat->fg_res * (di->fg_samples / 4));
+		(1000 * di->bm->fg_res * (di->fg_samples / 4));
 
 	di->flags.conv_done = true;
 
@@ -815,8 +815,8 @@ static int ab8500_fg_volt_to_capacity(struct ab8500_fg *di, int voltage)
 	struct abx500_v_to_cap *tbl;
 	int cap = 0;
 
-	tbl = di->bat->bat_type[di->bat->batt_id].v_to_cap_tbl,
-	tbl_size = di->bat->bat_type[di->bat->batt_id].n_v_cap_tbl_elements;
+	tbl = di->bm->bat_type[di->bm->batt_id].v_to_cap_tbl,
+	tbl_size = di->bm->bat_type[di->bm->batt_id].n_v_cap_tbl_elements;
 
 	for (i = 0; i < tbl_size; ++i) {
 		if (voltage > tbl[i].voltage)
@@ -867,8 +867,8 @@ static int ab8500_fg_battery_resistance(struct ab8500_fg *di)
 	struct batres_vs_temp *tbl;
 	int resist = 0;
 
-	tbl = di->bat->bat_type[di->bat->batt_id].batres_tbl;
-	tbl_size = di->bat->bat_type[di->bat->batt_id].n_batres_tbl_elements;
+	tbl = di->bm->bat_type[di->bm->batt_id].batres_tbl;
+	tbl_size = di->bm->bat_type[di->bm->batt_id].n_batres_tbl_elements;
 
 	for (i = 0; i < tbl_size; ++i) {
 		if (di->bat_temp / 10 > tbl[i].temp)
@@ -889,11 +889,11 @@ static int ab8500_fg_battery_resistance(struct ab8500_fg *di)
 
 	dev_dbg(di->dev, "%s Temp: %d battery internal resistance: %d"
 	    " fg resistance %d, total: %d (mOhm)\n",
-		__func__, di->bat_temp, resist, di->bat->fg_res / 10,
-		(di->bat->fg_res / 10) + resist);
+		__func__, di->bat_temp, resist, di->bm->fg_res / 10,
+		(di->bm->fg_res / 10) + resist);
 
 	/* fg_res variable is in 0.1mOhm */
-	resist += di->bat->fg_res / 10;
+	resist += di->bm->fg_res / 10;
 
 	return resist;
 }
@@ -1111,14 +1111,14 @@ static int ab8500_fg_capacity_level(struct ab8500_fg *di)
 
 	percent = di->bat_cap.permille / 10;
 
-	if (percent <= di->bat->cap_levels->critical ||
+	if (percent <= di->bm->cap_levels->critical ||
 		di->flags.low_bat)
 		ret = POWER_SUPPLY_CAPACITY_LEVEL_CRITICAL;
-	else if (percent <= di->bat->cap_levels->low)
+	else if (percent <= di->bm->cap_levels->low)
 		ret = POWER_SUPPLY_CAPACITY_LEVEL_LOW;
-	else if (percent <= di->bat->cap_levels->normal)
+	else if (percent <= di->bm->cap_levels->normal)
 		ret = POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
-	else if (percent <= di->bat->cap_levels->high)
+	else if (percent <= di->bm->cap_levels->high)
 		ret = POWER_SUPPLY_CAPACITY_LEVEL_HIGH;
 	else
 		ret = POWER_SUPPLY_CAPACITY_LEVEL_FULL;
@@ -1183,7 +1183,7 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 			di->bat_cap.prev_percent !=
 			(di->bat_cap.permille) / 10 &&
 			(di->bat_cap.permille / 10) <
-			di->bat->fg_params->maint_thres) {
+			di->bm->fg_params->maint_thres) {
 			dev_dbg(di->dev,
 				"battery reported full "
 				"but capacity dropping: %d\n",
@@ -1285,7 +1285,7 @@ static void ab8500_fg_algorithm_charging(struct ab8500_fg *di)
 	switch (di->charge_state) {
 	case AB8500_FG_CHARGE_INIT:
 		di->fg_samples = SEC_TO_SAMPLE(
-			di->bat->fg_params->accu_charging);
+			di->bm->fg_params->accu_charging);
 
 		ab8500_fg_coulomb_counter(di, true);
 		ab8500_fg_charge_state_to(di, AB8500_FG_CHARGE_READOUT);
@@ -1347,8 +1347,8 @@ static bool check_sysfs_capacity(struct ab8500_fg *di)
 	cap_permille = ab8500_fg_convert_mah_to_permille(di,
 		di->bat_cap.user_mah);
 
-	lower = di->bat_cap.permille - di->bat->fg_params->user_cap_limit * 10;
-	upper = di->bat_cap.permille + di->bat->fg_params->user_cap_limit * 10;
+	lower = di->bat_cap.permille - di->bm->fg_params->user_cap_limit * 10;
+	upper = di->bat_cap.permille + di->bm->fg_params->user_cap_limit * 10;
 
 	if (lower < 0)
 		lower = 0;
@@ -1388,7 +1388,7 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
 	case AB8500_FG_DISCHARGE_INIT:
 		/* We use the FG IRQ to work on */
 		di->init_cnt = 0;
-		di->fg_samples = SEC_TO_SAMPLE(di->bat->fg_params->init_timer);
+		di->fg_samples = SEC_TO_SAMPLE(di->bm->fg_params->init_timer);
 		ab8500_fg_coulomb_counter(di, true);
 		ab8500_fg_discharge_state_to(di,
 			AB8500_FG_DISCHARGE_INITMEASURING);
@@ -1401,17 +1401,17 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
 		 * samples to get an initial capacity.
 		 * Then go to READOUT
 		 */
-		sleep_time = di->bat->fg_params->init_timer;
+		sleep_time = di->bm->fg_params->init_timer;
 
 		/* Discard the first [x] seconds */
-		if (di->init_cnt > di->bat->fg_params->init_discard_time) {
+		if (di->init_cnt > di->bm->fg_params->init_discard_time) {
 			ab8500_fg_calc_cap_discharge_voltage(di, true);
 
 			ab8500_fg_check_capacity_limits(di, true);
 		}
 
 		di->init_cnt += sleep_time;
-		if (di->init_cnt > di->bat->fg_params->init_total_time)
+		if (di->init_cnt > di->bm->fg_params->init_total_time)
 			ab8500_fg_discharge_state_to(di,
 				AB8500_FG_DISCHARGE_READOUT_INIT);
 
@@ -1426,7 +1426,7 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
 		/* Intentional fallthrough */
 
 	case AB8500_FG_DISCHARGE_RECOVERY:
-		sleep_time = di->bat->fg_params->recovery_sleep_timer;
+		sleep_time = di->bm->fg_params->recovery_sleep_timer;
 
 		/*
 		 * We should check the power consumption
@@ -1438,9 +1438,9 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
 
 		if (ab8500_fg_is_low_curr(di, di->inst_curr)) {
 			if (di->recovery_cnt >
-				di->bat->fg_params->recovery_total_time) {
+				di->bm->fg_params->recovery_total_time) {
 				di->fg_samples = SEC_TO_SAMPLE(
-					di->bat->fg_params->accu_high_curr);
+					di->bm->fg_params->accu_high_curr);
 				ab8500_fg_coulomb_counter(di, true);
 				ab8500_fg_discharge_state_to(di,
 					AB8500_FG_DISCHARGE_READOUT);
@@ -1453,7 +1453,7 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
 			di->recovery_cnt += sleep_time;
 		} else {
 			di->fg_samples = SEC_TO_SAMPLE(
-				di->bat->fg_params->accu_high_curr);
+				di->bm->fg_params->accu_high_curr);
 			ab8500_fg_coulomb_counter(di, true);
 			ab8500_fg_discharge_state_to(di,
 				AB8500_FG_DISCHARGE_READOUT);
@@ -1462,7 +1462,7 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
 
 	case AB8500_FG_DISCHARGE_READOUT_INIT:
 		di->fg_samples = SEC_TO_SAMPLE(
-			di->bat->fg_params->accu_high_curr);
+			di->bm->fg_params->accu_high_curr);
 		ab8500_fg_coulomb_counter(di, true);
 		ab8500_fg_discharge_state_to(di,
 				AB8500_FG_DISCHARGE_READOUT);
@@ -1509,9 +1509,9 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
 			}
 
 			di->high_curr_cnt +=
-				di->bat->fg_params->accu_high_curr;
+				di->bm->fg_params->accu_high_curr;
 			if (di->high_curr_cnt >
-				di->bat->fg_params->high_curr_time)
+				di->bm->fg_params->high_curr_time)
 				di->recovery_needed = true;
 
 			ab8500_fg_calc_cap_discharge_fg(di);
@@ -1528,7 +1528,7 @@ static void ab8500_fg_algorithm_discharging(struct ab8500_fg *di)
 		ab8500_fg_calc_cap_discharge_voltage(di, true);
 
 		di->fg_samples = SEC_TO_SAMPLE(
-			di->bat->fg_params->accu_high_curr);
+			di->bm->fg_params->accu_high_curr);
 		ab8500_fg_coulomb_counter(di, true);
 		ab8500_fg_discharge_state_to(di,
 				AB8500_FG_DISCHARGE_READOUT);
@@ -1721,7 +1721,7 @@ static void ab8500_fg_low_bat_work(struct work_struct *work)
 	vbat = ab8500_fg_bat_voltage(di);
 
 	/* Check if LOW_BAT still fulfilled */
-	if (vbat < di->bat->fg_params->lowbat_threshold) {
+	if (vbat < di->bm->fg_params->lowbat_threshold) {
 		di->flags.low_bat = true;
 		dev_warn(di->dev, "Battery voltage still LOW\n");
 
@@ -1779,8 +1779,8 @@ static int ab8500_fg_battok_init_hw_register(struct ab8500_fg *di)
 	int ret;
 	int new_val;
 
-	sel0 = di->bat->fg_params->battok_falling_th_sel0;
-	sel1 = di->bat->fg_params->battok_raising_th_sel1;
+	sel0 = di->bm->fg_params->battok_falling_th_sel0;
+	sel1 = di->bm->fg_params->battok_raising_th_sel1;
 
 	cbp_sel0 = ab8500_fg_battok_calc(di, sel0);
 	cbp_sel1 = ab8500_fg_battok_calc(di, sel1);
@@ -1963,7 +1963,7 @@ static int ab8500_fg_get_property(struct power_supply *psy,
 				di->bat_cap.max_mah);
 		break;
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
-		if (di->flags.batt_unknown && !di->bat->chg_unknown_bat &&
+		if (di->flags.batt_unknown && !di->bm->chg_unknown_bat &&
 				di->flags.batt_id_received)
 			val->intval = ab8500_fg_convert_mah_to_uwh(di,
 					di->bat_cap.max_mah);
@@ -1978,21 +1978,21 @@ static int ab8500_fg_get_property(struct power_supply *psy,
 		val->intval = di->bat_cap.max_mah;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_NOW:
-		if (di->flags.batt_unknown && !di->bat->chg_unknown_bat &&
+		if (di->flags.batt_unknown && !di->bm->chg_unknown_bat &&
 				di->flags.batt_id_received)
 			val->intval = di->bat_cap.max_mah;
 		else
 			val->intval = di->bat_cap.prev_mah;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		if (di->flags.batt_unknown && !di->bat->chg_unknown_bat &&
+		if (di->flags.batt_unknown && !di->bm->chg_unknown_bat &&
 				di->flags.batt_id_received)
 			val->intval = 100;
 		else
 			val->intval = di->bat_cap.prev_percent;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY_LEVEL:
-		if (di->flags.batt_unknown && !di->bat->chg_unknown_bat &&
+		if (di->flags.batt_unknown && !di->bm->chg_unknown_bat &&
 				di->flags.batt_id_received)
 			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_UNKNOWN;
 		else
@@ -2078,7 +2078,7 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 				if (!di->flags.batt_id_received) {
 					const struct abx500_battery_type *b;
 
-					b = &(di->bat->bat_type[di->bat->batt_id]);
+					b = &(di->bm->bat_type[di->bm->batt_id]);
 
 					di->flags.batt_id_received = true;
 
@@ -2155,7 +2155,7 @@ static int ab8500_fg_init_hw_registers(struct ab8500_fg *di)
 		AB8500_SYS_CTRL2_BLOCK,
 		AB8500_LOW_BAT_REG,
 		ab8500_volt_to_regval(
-			di->bat->fg_params->lowbat_threshold) << 1 |
+			di->bm->fg_params->lowbat_threshold) << 1 |
 		LOW_BAT_ENABLE);
 	if (ret) {
 		dev_err(di->dev, "%s write failed\n", __func__);
@@ -2457,10 +2457,10 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s no mem for ab8500_fg\n", __func__);
 		return -ENOMEM;
 	}
-	di->bat = pdev->mfd_cell->platform_data;
-	if (!di->bat) {
+	di->bm = pdev->mfd_cell->platform_data;
+	if (!di->bm) {
 		if (np) {
-			ret = bmdevs_of_probe(&pdev->dev, np, &di->bat);
+			ret = ab8500_bm_of_probe(&pdev->dev, np, &di->bm);
 			if (ret) {
 				dev_err(&pdev->dev,
 					"failed to get battery information\n");
@@ -2491,11 +2491,11 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 	di->fg_psy.external_power_changed = ab8500_fg_external_power_changed;
 
 	di->bat_cap.max_mah_design = MILLI_TO_MICRO *
-		di->bat->bat_type[di->bat->batt_id].charge_full_design;
+		di->bm->bat_type[di->bm->batt_id].charge_full_design;
 
 	di->bat_cap.max_mah = di->bat_cap.max_mah_design;
 
-	di->vbat_nom = di->bat->bat_type[di->bat->batt_id].nominal_voltage;
+	di->vbat_nom = di->bm->bat_type[di->bm->batt_id].nominal_voltage;
 
 	di->init_capacity = true;
 
@@ -2549,7 +2549,7 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 		goto free_inst_curr_wq;
 	}
 
-	di->fg_samples = SEC_TO_SAMPLE(di->bat->fg_params->init_timer);
+	di->fg_samples = SEC_TO_SAMPLE(di->bm->fg_params->init_timer);
 	ab8500_fg_coulomb_counter(di, true);
 
 	/* Initialize completion used to notify completion of inst current */
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index dcdc439..ea2e2eb 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -207,7 +207,7 @@ enum maxim_ret {
  * @chg_info:		information about connected charger types
  * @batt_data:		data of the battery
  * @susp_status:	current charger suspension status
- * @bat:		pointer to the abx500_bm platform data
+ * @bm:           	Platform specific battery management information
  * @chargalg_psy:	structure that holds the battery properties exposed by
  *			the charging algorithm
  * @events:		structure for information about events triggered
@@ -232,7 +232,7 @@ struct abx500_chargalg {
 	struct abx500_chargalg_charger_info chg_info;
 	struct abx500_chargalg_battery_data batt_data;
 	struct abx500_chargalg_suspension_status susp_status;
-	struct abx500_bm_data *bat;
+	struct abx500_bm_data *bm;
 	struct power_supply chargalg_psy;
 	struct ux500_charger *ac_chg;
 	struct ux500_charger *usb_chg;
@@ -367,13 +367,13 @@ static void abx500_chargalg_start_safety_timer(struct abx500_chargalg *di)
 	case AC_CHG:
 		timer_expiration =
 		round_jiffies(jiffies +
-			(di->bat->main_safety_tmr_h * 3600 * HZ));
+			(di->bm->main_safety_tmr_h * 3600 * HZ));
 		break;
 
 	case USB_CHG:
 		timer_expiration =
 		round_jiffies(jiffies +
-			(di->bat->usb_safety_tmr_h * 3600 * HZ));
+			(di->bm->usb_safety_tmr_h * 3600 * HZ));
 		break;
 
 	default:
@@ -638,32 +638,32 @@ static void abx500_chargalg_start_charging(struct abx500_chargalg *di,
  */
 static void abx500_chargalg_check_temp(struct abx500_chargalg *di)
 {
-	if (di->batt_data.temp > (di->bat->temp_low + di->t_hyst_norm) &&
-		di->batt_data.temp < (di->bat->temp_high - di->t_hyst_norm)) {
+	if (di->batt_data.temp > (di->bm->temp_low + di->t_hyst_norm) &&
+		di->batt_data.temp < (di->bm->temp_high - di->t_hyst_norm)) {
 		/* Temp OK! */
 		di->events.btemp_underover = false;
 		di->events.btemp_lowhigh = false;
 		di->t_hyst_norm = 0;
 		di->t_hyst_lowhigh = 0;
 	} else {
-		if (((di->batt_data.temp >= di->bat->temp_high) &&
+		if (((di->batt_data.temp >= di->bm->temp_high) &&
 			(di->batt_data.temp <
-				(di->bat->temp_over - di->t_hyst_lowhigh))) ||
+				(di->bm->temp_over - di->t_hyst_lowhigh))) ||
 			((di->batt_data.temp >
-				(di->bat->temp_under + di->t_hyst_lowhigh)) &&
-			(di->batt_data.temp <= di->bat->temp_low))) {
+				(di->bm->temp_under + di->t_hyst_lowhigh)) &&
+			(di->batt_data.temp <= di->bm->temp_low))) {
 			/* TEMP minor!!!!! */
 			di->events.btemp_underover = false;
 			di->events.btemp_lowhigh = true;
-			di->t_hyst_norm = di->bat->temp_hysteresis;
+			di->t_hyst_norm = di->bm->temp_hysteresis;
 			di->t_hyst_lowhigh = 0;
-		} else if (di->batt_data.temp <= di->bat->temp_under ||
-			di->batt_data.temp >= di->bat->temp_over) {
+		} else if (di->batt_data.temp <= di->bm->temp_under ||
+			di->batt_data.temp >= di->bm->temp_over) {
 			/* TEMP major!!!!! */
 			di->events.btemp_underover = true;
 			di->events.btemp_lowhigh = false;
 			di->t_hyst_norm = 0;
-			di->t_hyst_lowhigh = di->bat->temp_hysteresis;
+			di->t_hyst_lowhigh = di->bm->temp_hysteresis;
 		} else {
 		/* Within hysteresis */
 		dev_dbg(di->dev, "Within hysteresis limit temp: %d "
@@ -682,12 +682,12 @@ static void abx500_chargalg_check_temp(struct abx500_chargalg *di)
  */
 static void abx500_chargalg_check_charger_voltage(struct abx500_chargalg *di)
 {
-	if (di->chg_info.usb_volt > di->bat->chg_params->usb_volt_max)
+	if (di->chg_info.usb_volt > di->bm->chg_params->usb_volt_max)
 		di->chg_info.usb_chg_ok = false;
 	else
 		di->chg_info.usb_chg_ok = true;
 
-	if (di->chg_info.ac_volt > di->bat->chg_params->ac_volt_max)
+	if (di->chg_info.ac_volt > di->bm->chg_params->ac_volt_max)
 		di->chg_info.ac_chg_ok = false;
 	else
 		di->chg_info.ac_chg_ok = true;
@@ -707,10 +707,10 @@ static void abx500_chargalg_end_of_charge(struct abx500_chargalg *di)
 	if (di->charge_status == POWER_SUPPLY_STATUS_CHARGING &&
 		di->charge_state == STATE_NORMAL &&
 		!di->maintenance_chg && (di->batt_data.volt >=
-		di->bat->bat_type[di->bat->batt_id].termination_vol ||
+		di->bm->bat_type[di->bm->batt_id].termination_vol ||
 		di->events.usb_cv_active || di->events.ac_cv_active) &&
 		di->batt_data.avg_curr <
-		di->bat->bat_type[di->bat->batt_id].termination_curr &&
+		di->bm->bat_type[di->bm->batt_id].termination_curr &&
 		di->batt_data.avg_curr > 0) {
 		if (++di->eoc_cnt >= EOC_COND_CNT) {
 			di->eoc_cnt = 0;
@@ -733,12 +733,12 @@ static void abx500_chargalg_end_of_charge(struct abx500_chargalg *di)
 static void init_maxim_chg_curr(struct abx500_chargalg *di)
 {
 	di->ccm.original_iset =
-		di->bat->bat_type[di->bat->batt_id].normal_cur_lvl;
+		di->bm->bat_type[di->bm->batt_id].normal_cur_lvl;
 	di->ccm.current_iset =
-		di->bat->bat_type[di->bat->batt_id].normal_cur_lvl;
-	di->ccm.test_delta_i = di->bat->maxi->charger_curr_step;
-	di->ccm.max_current = di->bat->maxi->chg_curr;
-	di->ccm.condition_cnt = di->bat->maxi->wait_cycles;
+		di->bm->bat_type[di->bm->batt_id].normal_cur_lvl;
+	di->ccm.test_delta_i = di->bm->maxi->charger_curr_step;
+	di->ccm.max_current = di->bm->maxi->chg_curr;
+	di->ccm.condition_cnt = di->bm->maxi->wait_cycles;
 	di->ccm.level = 0;
 }
 
@@ -755,7 +755,7 @@ static enum maxim_ret abx500_chargalg_chg_curr_maxim(struct abx500_chargalg *di)
 {
 	int delta_i;
 
-	if (!di->bat->maxi->ena_maxi)
+	if (!di->bm->maxi->ena_maxi)
 		return MAXIM_RET_NOACTION;
 
 	delta_i = di->ccm.original_iset - di->batt_data.inst_curr;
@@ -766,7 +766,7 @@ static enum maxim_ret abx500_chargalg_chg_curr_maxim(struct abx500_chargalg *di)
 		if (di->ccm.wait_cnt == 0) {
 			dev_dbg(di->dev, "lowering current\n");
 			di->ccm.wait_cnt++;
-			di->ccm.condition_cnt = di->bat->maxi->wait_cycles;
+			di->ccm.condition_cnt = di->bm->maxi->wait_cycles;
 			di->ccm.max_current =
 				di->ccm.current_iset - di->ccm.test_delta_i;
 			di->ccm.current_iset = di->ccm.max_current;
@@ -791,7 +791,7 @@ static enum maxim_ret abx500_chargalg_chg_curr_maxim(struct abx500_chargalg *di)
 		if (di->ccm.current_iset == di->ccm.original_iset)
 			return MAXIM_RET_NOACTION;
 
-		di->ccm.condition_cnt = di->bat->maxi->wait_cycles;
+		di->ccm.condition_cnt = di->bm->maxi->wait_cycles;
 		di->ccm.current_iset = di->ccm.original_iset;
 		di->ccm.level = 0;
 
@@ -803,7 +803,7 @@ static enum maxim_ret abx500_chargalg_chg_curr_maxim(struct abx500_chargalg *di)
 		di->ccm.max_current) {
 		if (di->ccm.condition_cnt-- == 0) {
 			/* Increse the iset with cco.test_delta_i */
-			di->ccm.condition_cnt = di->bat->maxi->wait_cycles;
+			di->ccm.condition_cnt = di->bm->maxi->wait_cycles;
 			di->ccm.current_iset += di->ccm.test_delta_i;
 			di->ccm.level++;
 			dev_dbg(di->dev, " Maximization needed, increase"
@@ -818,7 +818,7 @@ static enum maxim_ret abx500_chargalg_chg_curr_maxim(struct abx500_chargalg *di)
 			return MAXIM_RET_NOACTION;
 		}
 	}  else {
-		di->ccm.condition_cnt = di->bat->maxi->wait_cycles;
+		di->ccm.condition_cnt = di->bm->maxi->wait_cycles;
 		return MAXIM_RET_NOACTION;
 	}
 }
@@ -838,7 +838,7 @@ static void handle_maxim_chg_curr(struct abx500_chargalg *di)
 		break;
 	case MAXIM_RET_IBAT_TOO_HIGH:
 		result = abx500_chargalg_update_chg_curr(di,
-			di->bat->bat_type[di->bat->batt_id].normal_cur_lvl);
+			di->bm->bat_type[di->bm->batt_id].normal_cur_lvl);
 		if (result)
 			dev_err(di->dev, "failed to set chg curr\n");
 		break;
@@ -1210,7 +1210,7 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 	 * this way
 	 */
 	if (!charger_status ||
-		(di->events.batt_unknown && !di->bat->chg_unknown_bat)) {
+		(di->events.batt_unknown && !di->bm->chg_unknown_bat)) {
 		if (di->charge_state != STATE_HANDHELD) {
 			di->events.safety_timer_expired = false;
 			abx500_chargalg_state_to(di, STATE_HANDHELD_INIT);
@@ -1394,8 +1394,8 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 
 	case STATE_NORMAL_INIT:
 		abx500_chargalg_start_charging(di,
-			di->bat->bat_type[di->bat->batt_id].normal_vol_lvl,
-			di->bat->bat_type[di->bat->batt_id].normal_cur_lvl);
+			di->bm->bat_type[di->bm->batt_id].normal_vol_lvl,
+			di->bm->bat_type[di->bm->batt_id].normal_cur_lvl);
 		abx500_chargalg_state_to(di, STATE_NORMAL);
 		abx500_chargalg_start_safety_timer(di);
 		abx500_chargalg_stop_maintenance_timer(di);
@@ -1411,7 +1411,7 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 		handle_maxim_chg_curr(di);
 		if (di->charge_status == POWER_SUPPLY_STATUS_FULL &&
 			di->maintenance_chg) {
-			if (di->bat->no_maintenance)
+			if (di->bm->no_maintenance)
 				abx500_chargalg_state_to(di,
 					STATE_WAIT_FOR_RECHARGE_INIT);
 			else
@@ -1429,7 +1429,7 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 
 	case STATE_WAIT_FOR_RECHARGE:
 		if (di->batt_data.volt <=
-			di->bat->bat_type[di->bat->batt_id].recharge_vol) {
+			di->bm->bat_type[di->bm->batt_id].recharge_vol) {
 			if (di->rch_cnt-- == 0)
 				abx500_chargalg_state_to(di, STATE_NORMAL_INIT);
 		} else
@@ -1439,13 +1439,13 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 	case STATE_MAINTENANCE_A_INIT:
 		abx500_chargalg_stop_safety_timer(di);
 		abx500_chargalg_start_maintenance_timer(di,
-			di->bat->bat_type[
-				di->bat->batt_id].maint_a_chg_timer_h);
+			di->bm->bat_type[
+				di->bm->batt_id].maint_a_chg_timer_h);
 		abx500_chargalg_start_charging(di,
-			di->bat->bat_type[
-				di->bat->batt_id].maint_a_vol_lvl,
-			di->bat->bat_type[
-				di->bat->batt_id].maint_a_cur_lvl);
+			di->bm->bat_type[
+				di->bm->batt_id].maint_a_vol_lvl,
+			di->bm->bat_type[
+				di->bm->batt_id].maint_a_cur_lvl);
 		abx500_chargalg_state_to(di, STATE_MAINTENANCE_A);
 		power_supply_changed(&di->chargalg_psy);
 		/* Intentional fallthrough*/
@@ -1459,13 +1459,13 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 
 	case STATE_MAINTENANCE_B_INIT:
 		abx500_chargalg_start_maintenance_timer(di,
-			di->bat->bat_type[
-				di->bat->batt_id].maint_b_chg_timer_h);
+			di->bm->bat_type[
+				di->bm->batt_id].maint_b_chg_timer_h);
 		abx500_chargalg_start_charging(di,
-			di->bat->bat_type[
-				di->bat->batt_id].maint_b_vol_lvl,
-			di->bat->bat_type[
-				di->bat->batt_id].maint_b_cur_lvl);
+			di->bm->bat_type[
+				di->bm->batt_id].maint_b_vol_lvl,
+			di->bm->bat_type[
+				di->bm->batt_id].maint_b_cur_lvl);
 		abx500_chargalg_state_to(di, STATE_MAINTENANCE_B);
 		power_supply_changed(&di->chargalg_psy);
 		/* Intentional fallthrough*/
@@ -1479,10 +1479,10 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 
 	case STATE_TEMP_LOWHIGH_INIT:
 		abx500_chargalg_start_charging(di,
-			di->bat->bat_type[
-				di->bat->batt_id].low_high_vol_lvl,
-			di->bat->bat_type[
-				di->bat->batt_id].low_high_cur_lvl);
+			di->bm->bat_type[
+				di->bm->batt_id].low_high_vol_lvl,
+			di->bm->bat_type[
+				di->bm->batt_id].low_high_cur_lvl);
 		abx500_chargalg_stop_maintenance_timer(di);
 		di->charge_status = POWER_SUPPLY_STATUS_CHARGING;
 		abx500_chargalg_state_to(di, STATE_TEMP_LOWHIGH);
@@ -1543,11 +1543,11 @@ static void abx500_chargalg_periodic_work(struct work_struct *work)
 	if (di->chg_info.conn_chg)
 		queue_delayed_work(di->chargalg_wq,
 			&di->chargalg_periodic_work,
-			di->bat->interval_charging * HZ);
+			di->bm->interval_charging * HZ);
 	else
 		queue_delayed_work(di->chargalg_wq,
 			&di->chargalg_periodic_work,
-			di->bat->interval_not_charging * HZ);
+			di->bm->interval_not_charging * HZ);
 }
 
 /**
@@ -1614,7 +1614,7 @@ static int abx500_chargalg_get_property(struct power_supply *psy,
 		if (di->events.batt_ovv) {
 			val->intval = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
 		} else if (di->events.btemp_underover) {
-			if (di->batt_data.temp <= di->bat->temp_under)
+			if (di->batt_data.temp <= di->bm->temp_under)
 				val->intval = POWER_SUPPLY_HEALTH_COLD;
 			else
 				val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
@@ -1814,10 +1814,10 @@ static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s no mem for ab8500_chargalg\n", __func__);
 		return -ENOMEM;
 	}
-	di->bat = pdev->mfd_cell->platform_data;
-	if (!di->bat) {
+	di->bm = pdev->mfd_cell->platform_data;
+	if (!di->bm) {
 		if (np) {
-			ret = bmdevs_of_probe(&pdev->dev, np, &di->bat);
+			ret = ab8500_bm_of_probe(&pdev->dev, np, &di->bm);
 			if (ret) {
 				dev_err(&pdev->dev,
 					"failed to get battery information\n");
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 3f054ed..e10662a 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -290,9 +290,9 @@ enum {
 	NTC_INTERNAL,
 };
 
-int bmdevs_of_probe(struct device *dev,
-		struct device_node *np,
-		struct abx500_bm_data **battery);
+int ab8500_bm_of_probe(struct device *dev,
+		       struct device_node *np,
+		       struct abx500_bm_data **battery);
 
 int abx500_set_register_interruptible(struct device *dev, u8 bank, u8 reg,
 	u8 value);
-- 
1.7.9.5

