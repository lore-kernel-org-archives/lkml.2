Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab2LMPZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:25:37 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52525 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab2LMPWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:07 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/18] power: ab8500_bm: Recharge condition not optimal for battery
Date: Thu, 13 Dec 2012 15:21:30 +0000
Message-Id: <1355412102-14265-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

Today the battery recharge is determined with a voltage threshold. This
voltage threshold is only valid when the battery is relaxed. In charging
algorithm the voltage read is the loaded battery voltage and no
compensation is done to get the relaxed voltage. When maintenance
charging is not selected, this makes the recharging condition to almost
immediately activate when there is a discharge present on the battery.

Depending on which vendor the battery comes from this behavior can wear
out the battery much faster than normal.

The fuelgauge driver is responsible to monitor the actual battery
capacity and is able to estimate the remaining capacity. It is better to
use the remaining capacity as a limit to determine when battery should
be recharged.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_bmdata.c        |   18 +++--
 drivers/power/ab8500_fg.c            |  146 +++++++++++++++++++++++++++++++---
 drivers/power/abx500_chargalg.c      |   30 ++++---
 include/linux/mfd/abx500.h           |    6 +-
 include/linux/mfd/abx500/ab8500-bm.h |    2 +
 5 files changed, 168 insertions(+), 34 deletions(-)

diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
index 0bf5236..8c512e7 100644
--- a/drivers/power/ab8500_bmdata.c
+++ b/drivers/power/ab8500_bmdata.c
@@ -192,7 +192,7 @@ static struct abx500_battery_type bat_type_thermistor[] = {
 		.nominal_voltage = 3700,
 		.termination_vol = 4050,
 		.termination_curr = 200,
-		.recharge_vol = 3990,
+		.recharge_cap = 95,
 		.normal_cur_lvl = 400,
 		.normal_vol_lvl = 4100,
 		.maint_a_cur_lvl = 400,
@@ -219,7 +219,7 @@ static struct abx500_battery_type bat_type_thermistor[] = {
 		.nominal_voltage = 3600,
 		.termination_vol = 4150,
 		.termination_curr = 80,
-		.recharge_vol = 4130,
+		.recharge_cap = 95,
 		.normal_cur_lvl = 700,
 		.normal_vol_lvl = 4200,
 		.maint_a_cur_lvl = 600,
@@ -247,7 +247,7 @@ static struct abx500_battery_type bat_type_thermistor[] = {
 		.nominal_voltage = 3600,
 		.termination_vol = 4150,
 		.termination_curr = 80,
-		.recharge_vol = 4130,
+		.recharge_cap = 95,
 		.normal_cur_lvl = 700,
 		.normal_vol_lvl = 4200,
 		.maint_a_cur_lvl = 600,
@@ -278,7 +278,7 @@ static struct abx500_battery_type bat_type_ext_thermistor[] = {
 		.nominal_voltage = 3700,
 		.termination_vol = 4050,
 		.termination_curr = 200,
-		.recharge_vol = 3990,
+		.recharge_cap = 95,
 		.normal_cur_lvl = 400,
 		.normal_vol_lvl = 4100,
 		.maint_a_cur_lvl = 400,
@@ -310,7 +310,7 @@ static struct abx500_battery_type bat_type_ext_thermistor[] = {
 		.nominal_voltage = 3700,
 		.termination_vol = 4150,
 		.termination_curr = 100,
-		.recharge_vol = 4130,
+		.recharge_cap = 95,
 		.normal_cur_lvl = 700,
 		.normal_vol_lvl = 4200,
 		.maint_a_cur_lvl = 600,
@@ -337,7 +337,7 @@ static struct abx500_battery_type bat_type_ext_thermistor[] = {
 		.nominal_voltage = 3700,
 		.termination_vol = 4150,
 		.termination_curr = 100,
-		.recharge_vol = 4130,
+		.recharge_cap = 95,
 		.normal_cur_lvl = 700,
 		.normal_vol_lvl = 4200,
 		.maint_a_cur_lvl = 600,
@@ -364,7 +364,7 @@ static struct abx500_battery_type bat_type_ext_thermistor[] = {
 		.nominal_voltage = 3700,
 		.termination_vol = 4150,
 		.termination_curr = 100,
-		.recharge_vol = 4130,
+		.recharge_cap = 95,
 		.normal_cur_lvl = 700,
 		.normal_vol_lvl = 4200,
 		.maint_a_cur_lvl = 600,
@@ -405,6 +405,7 @@ static const struct abx500_fg_parameters fg = {
 	.lowbat_threshold = 3100,
 	.battok_falling_th_sel0 = 2860,
 	.battok_raising_th_sel1 = 2860,
+	.maint_thres = 95,
 	.user_cap_limit = 15,
 	.maint_thres = 97,
 };
@@ -435,6 +436,7 @@ struct abx500_bm_data ab8500_bm_data = {
 	.bkup_bat_v             = BUP_VCH_SEL_2P6V,
 	.bkup_bat_i             = BUP_ICH_SEL_150UA,
 	.no_maintenance         = false,
+	.capacity_scaling       = false,
 	.adc_therm              = ABx500_ADC_THERM_BATCTRL,
 	.chg_unknown_bat        = false,
 	.enable_overshoot       = false,
@@ -479,7 +481,7 @@ int __devinit ab8500_bm_of_probe(struct device *dev,
 		bm->chg_unknown_bat = true;
 		bm->bat_type[BATTERY_UNKNOWN].charge_full_design = 2600;
 		bm->bat_type[BATTERY_UNKNOWN].termination_vol    = 4150;
-		bm->bat_type[BATTERY_UNKNOWN].recharge_vol       = 4130;
+		bm->bat_type[BATTERY_UNKNOWN].recharge_cap       = 95;
 		bm->bat_type[BATTERY_UNKNOWN].normal_cur_lvl     = 520;
 		bm->bat_type[BATTERY_UNKNOWN].normal_vol_lvl     = 4200;
 	}
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index d974acd..41eace3 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -113,6 +113,13 @@ struct ab8500_fg_avg_cap {
 	int sum;
 };
 
+struct ab8500_fg_cap_scaling {
+	bool enable;
+	int cap_to_scale[2];
+	int disable_cap_level;
+	int scaled_cap;
+};
+
 struct ab8500_fg_battery_capacity {
 	int max_mah_design;
 	int max_mah;
@@ -123,6 +130,7 @@ struct ab8500_fg_battery_capacity {
 	int prev_percent;
 	int prev_level;
 	int user_mah;
+	struct ab8500_fg_cap_scaling cap_scale;
 };
 
 struct ab8500_fg_flags {
@@ -1167,6 +1175,99 @@ static int ab8500_fg_capacity_level(struct ab8500_fg *di)
 }
 
 /**
+ * ab8500_fg_calculate_scaled_capacity() - Capacity scaling
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * Calculates the capacity to be shown to upper layers. Scales the capacity
+ * to have 100% as a reference from the actual capacity upon removal of charger
+ * when charging is in maintenance mode.
+ */
+static int ab8500_fg_calculate_scaled_capacity(struct ab8500_fg *di)
+{
+	struct ab8500_fg_cap_scaling *cs = &di->bat_cap.cap_scale;
+	int capacity = di->bat_cap.prev_percent;
+
+	if (!cs->enable)
+		return capacity;
+
+	/*
+	 * As long as we are in fully charge mode scale the capacity
+	 * to show 100%.
+	 */
+	if (di->flags.fully_charged) {
+		cs->cap_to_scale[0] = 100;
+		cs->cap_to_scale[1] =
+			max(capacity, di->bm->fg_params->maint_thres);
+		dev_dbg(di->dev, "Scale cap with %d/%d\n",
+			 cs->cap_to_scale[0], cs->cap_to_scale[1]);
+	}
+
+	/* Calculates the scaled capacity. */
+	if ((cs->cap_to_scale[0] != cs->cap_to_scale[1])
+					&& (cs->cap_to_scale[1] > 0))
+		capacity = min(100,
+				 DIV_ROUND_CLOSEST(di->bat_cap.prev_percent *
+						 cs->cap_to_scale[0],
+						 cs->cap_to_scale[1]));
+
+	if (di->flags.charging) {
+		if (capacity < cs->disable_cap_level) {
+			cs->disable_cap_level = capacity;
+			dev_dbg(di->dev, "Cap to stop scale lowered %d%%\n",
+				cs->disable_cap_level);
+		} else if (!di->flags.fully_charged) {
+			if (di->bat_cap.prev_percent >=
+			    cs->disable_cap_level) {
+				dev_dbg(di->dev, "Disabling scaled capacity\n");
+				cs->enable = false;
+				capacity = di->bat_cap.prev_percent;
+			} else {
+				dev_dbg(di->dev,
+					"Waiting in cap to level %d%%\n",
+					cs->disable_cap_level);
+				capacity = cs->disable_cap_level;
+			}
+		}
+	}
+
+	return capacity;
+}
+
+/**
+ * ab8500_fg_update_cap_scalers() - Capacity scaling
+ * @di:		pointer to the ab8500_fg structure
+ *
+ * To be called when state change from charge<->discharge to update
+ * the capacity scalers.
+ */
+static void ab8500_fg_update_cap_scalers(struct ab8500_fg *di)
+{
+	struct ab8500_fg_cap_scaling *cs = &di->bat_cap.cap_scale;
+
+	if (!cs->enable)
+		return;
+	if (di->flags.charging) {
+		di->bat_cap.cap_scale.disable_cap_level =
+			di->bat_cap.cap_scale.scaled_cap;
+		dev_dbg(di->dev, "Cap to stop scale at charge %d%%\n",
+				di->bat_cap.cap_scale.disable_cap_level);
+	} else {
+		if (cs->scaled_cap != 100) {
+			cs->cap_to_scale[0] = cs->scaled_cap;
+			cs->cap_to_scale[1] = di->bat_cap.prev_percent;
+		} else {
+			cs->cap_to_scale[0] = 100;
+			cs->cap_to_scale[1] =
+				max(di->bat_cap.prev_percent,
+				    di->bm->fg_params->maint_thres);
+		}
+
+		dev_dbg(di->dev, "Cap to scale at discharge %d/%d\n",
+				cs->cap_to_scale[0], cs->cap_to_scale[1]);
+	}
+}
+
+/**
  * ab8500_fg_check_capacity_limits() - Check if capacity has changed
  * @di:		pointer to the ab8500_fg structure
  * @init:	capacity is allowed to go up in init mode
@@ -1214,16 +1315,24 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 	} else if (di->flags.fully_charged) {
 		/*
 		 * We report 100% if algorithm reported fully charged
-		 * unless capacity drops too much
+		 * and show 100% during maintenance charging (scaling).
 		 */
 		if (di->flags.force_full) {
 			di->bat_cap.prev_percent = di->bat_cap.permille / 10;
 			di->bat_cap.prev_mah = di->bat_cap.mah;
-		} else if (!di->flags.force_full &&
-			di->bat_cap.prev_percent !=
-			(di->bat_cap.permille) / 10 &&
-			(di->bat_cap.permille / 10) <
-			di->bm->fg_params->maint_thres) {
+
+			changed = true;
+
+			if (!di->bat_cap.cap_scale.enable &&
+						di->bm->capacity_scaling) {
+				di->bat_cap.cap_scale.enable = true;
+				di->bat_cap.cap_scale.cap_to_scale[0] = 100;
+				di->bat_cap.cap_scale.cap_to_scale[1] =
+						di->bat_cap.prev_percent;
+				di->bat_cap.cap_scale.disable_cap_level = 100;
+			}
+		} else if ( di->bat_cap.prev_percent !=
+			(di->bat_cap.permille) / 10) {
 			dev_dbg(di->dev,
 				"battery reported full "
 				"but capacity dropping: %d\n",
@@ -1272,6 +1381,14 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 	}
 
 	if (changed) {
+		if (di->bm->capacity_scaling) {
+			di->bat_cap.cap_scale.scaled_cap =
+				ab8500_fg_calculate_scaled_capacity(di);
+
+			dev_info(di->dev, "capacity=%d (%d)\n",
+				di->bat_cap.prev_percent,
+				di->bat_cap.cap_scale.scaled_cap);
+		}
 		power_supply_changed(&di->fg_psy);
 		if (di->flags.fully_charged && di->flags.force_full) {
 			dev_dbg(di->dev, "Battery full, notifying.\n");
@@ -1337,7 +1454,7 @@ static void ab8500_fg_algorithm_charging(struct ab8500_fg *di)
 		 * Read the FG and calculate the new capacity
 		 */
 		mutex_lock(&di->cc_lock);
-		if (!di->flags.conv_done) {
+		if (!di->flags.conv_done && !di->flags.force_full) {
 			/* Wasn't the CC IRQ that got us here */
 			mutex_unlock(&di->cc_lock);
 			dev_dbg(di->dev, "%s CC conv not done\n",
@@ -2027,7 +2144,9 @@ static int ab8500_fg_get_property(struct power_supply *psy,
 			val->intval = di->bat_cap.prev_mah;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		if (di->flags.batt_unknown && !di->bm->chg_unknown_bat &&
+		if (di->bm->capacity_scaling)
+			val->intval = di->bat_cap.cap_scale.scaled_cap;
+		else if (di->flags.batt_unknown && !di->bm->chg_unknown_bat &&
 				di->flags.batt_id_received)
 			val->intval = 100;
 		else
@@ -2091,6 +2210,8 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 						break;
 					di->flags.charging = false;
 					di->flags.fully_charged = false;
+					if (di->bm->capacity_scaling)
+						ab8500_fg_update_cap_scalers(di);
 					queue_work(di->fg_wq, &di->fg_work);
 					break;
 				case POWER_SUPPLY_STATUS_FULL:
@@ -2103,10 +2224,13 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 					queue_work(di->fg_wq, &di->fg_work);
 					break;
 				case POWER_SUPPLY_STATUS_CHARGING:
-					if (di->flags.charging)
+					if (di->flags.charging &&
+						!di->flags.fully_charged)
 						break;
 					di->flags.charging = true;
 					di->flags.fully_charged = false;
+					if (di->bm->capacity_scaling)
+						ab8500_fg_update_cap_scalers(di);
 					queue_work(di->fg_wq, &di->fg_work);
 					break;
 				};
@@ -2146,8 +2270,8 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 		case POWER_SUPPLY_PROP_TEMP:
 			switch (ext->type) {
 			case POWER_SUPPLY_TYPE_BATTERY:
-			    if (di->flags.batt_id_received)
-				di->bat_temp = ret.intval;
+				if (di->flags.batt_id_received)
+					di->bat_temp = ret.intval;
 				break;
 			default:
 				break;
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index a8acfe5..4f01e48 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -33,9 +33,6 @@
 /* End-of-charge criteria counter */
 #define EOC_COND_CNT			10
 
-/* Recharge criteria counter */
-#define RCH_COND_CNT			3
-
 #define to_abx500_chargalg_device_info(x) container_of((x), \
 	struct abx500_chargalg, chargalg_psy);
 
@@ -196,7 +193,6 @@ enum maxim_ret {
  * @dev:		pointer to the structure device
  * @charge_status:	battery operating status
  * @eoc_cnt:		counter used to determine end-of_charge
- * @rch_cnt:		counter used to determine start of recharge
  * @maintenance_chg:	indicate if maintenance charge is active
  * @t_hyst_norm		temperature hysteresis when the temperature has been
  *			over or under normal limits
@@ -223,7 +219,6 @@ struct abx500_chargalg {
 	struct device *dev;
 	int charge_status;
 	int eoc_cnt;
-	int rch_cnt;
 	bool maintenance_chg;
 	int t_hyst_norm;
 	int t_hyst_lowhigh;
@@ -858,6 +853,7 @@ static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 	union power_supply_propval ret;
 	int i, j;
 	bool psy_found = false;
+	bool capacity_updated = false;
 
 	psy = (struct power_supply *)data;
 	ext = dev_get_drvdata(dev);
@@ -870,6 +866,16 @@ static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 	if (!psy_found)
 		return 0;
 
+	/*
+	 *  If external is not registering 'POWER_SUPPLY_PROP_CAPACITY' to its
+	 * property because of handling that sysfs entry on its own, this is
+	 * the place to get the battery capacity.
+	 */
+	if (!ext->get_property(ext, POWER_SUPPLY_PROP_CAPACITY, &ret)) {
+		di->batt_data.percent = ret.intval;
+		capacity_updated = true;
+	}
+
 	/* Go through all properties for the psy */
 	for (j = 0; j < ext->num_properties; j++) {
 		enum power_supply_property prop;
@@ -1154,7 +1160,8 @@ static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 			}
 			break;
 		case POWER_SUPPLY_PROP_CAPACITY:
-			di->batt_data.percent = ret.intval;
+			if (!capacity_updated)
+				di->batt_data.percent = ret.intval;
 			break;
 		default:
 			break;
@@ -1424,16 +1431,13 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 	case STATE_WAIT_FOR_RECHARGE_INIT:
 		abx500_chargalg_hold_charging(di);
 		abx500_chargalg_state_to(di, STATE_WAIT_FOR_RECHARGE);
-		di->rch_cnt = RCH_COND_CNT;
 		/* Intentional fallthrough */
 
 	case STATE_WAIT_FOR_RECHARGE:
-		if (di->batt_data.volt <=
-			di->bm->bat_type[di->bm->batt_id].recharge_vol) {
-			if (di->rch_cnt-- == 0)
-				abx500_chargalg_state_to(di, STATE_NORMAL_INIT);
-		} else
-			di->rch_cnt = RCH_COND_CNT;
+		if (di->batt_data.percent <=
+		    di->bm->bat_type[di->bm->batt_id].
+		    recharge_cap)
+			abx500_chargalg_state_to(di, STATE_NORMAL_INIT);
 		break;
 
 	case STATE_MAINTENANCE_A_INIT:
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 4906b18..0e6e90b 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -131,7 +131,7 @@ struct abx500_maxim_parameters {
  * @nominal_voltage:		Nominal voltage of the battery in mV
  * @termination_vol:		max voltage upto which battery can be charged
  * @termination_curr		battery charging termination current in mA
- * @recharge_vol		battery voltage limit that will trigger a new
+ * @recharge_cap		battery capacity limit that will trigger a new
  *				full charging cycle in the case where maintenan-
  *				-ce charging has been disabled
  * @normal_cur_lvl:		charger current in normal state in mA
@@ -160,7 +160,7 @@ struct abx500_battery_type {
 	int nominal_voltage;
 	int termination_vol;
 	int termination_curr;
-	int recharge_vol;
+	int recharge_cap;
 	int normal_cur_lvl;
 	int normal_vol_lvl;
 	int maint_a_cur_lvl;
@@ -224,6 +224,7 @@ struct abx500_bm_charger_parameters {
  * @bkup_bat_v		voltage which we charge the backup battery with
  * @bkup_bat_i		current which we charge the backup battery with
  * @no_maintenance	indicates that maintenance charging is disabled
+ * @capacity_scaling    indicates whether capacity scaling is to be used
  * @abx500_adc_therm	placement of thermistor, batctrl or battemp adc
  * @chg_unknown_bat	flag to enable charging of unknown batteries
  * @enable_overshoot	flag to enable VBAT overshoot control
@@ -254,6 +255,7 @@ struct abx500_bm_data {
 	int bkup_bat_v;
 	int bkup_bat_i;
 	bool no_maintenance;
+	bool capacity_scaling;
 	bool chg_unknown_bat;
 	bool enable_overshoot;
 	bool auto_trig;
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index 6c6a02e..fac684a 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -355,6 +355,7 @@ struct ab8500_bm_charger_parameters {
  * @bkup_bat_v		voltage which we charge the backup battery with
  * @bkup_bat_i		current which we charge the backup battery with
  * @no_maintenance	indicates that maintenance charging is disabled
+ * @capacity_scaling    indicates whether capacity scaling is to be used
  * @adc_therm		placement of thermistor, batctrl or battemp adc
  * @chg_unknown_bat	flag to enable charging of unknown batteries
  * @enable_overshoot	flag to enable VBAT overshoot control
@@ -383,6 +384,7 @@ struct ab8500_bm_data {
 	int bkup_bat_v;
 	int bkup_bat_i;
 	bool no_maintenance;
+	bool capacity_scaling;
 	bool chg_unknown_bat;
 	bool enable_overshoot;
 	enum abx500_adc_therm adc_therm;
-- 
1.7.9.5

