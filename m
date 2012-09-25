Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab2IYQZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:25:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503Ab2IYQNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:23 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 11/57] power: Recharge condition not optimal for battery
Date: Tue, 25 Sep 2012 10:12:08 -0600
Message-Id: <1348589574-25655-12-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
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

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c       |  157 +++++++++++++++++++++++++++++++++++----
 drivers/power/abx500_chargalg.c |   59 +++++++++++----
 include/linux/mfd/abx500.h      |    6 +-
 3 files changed, 191 insertions(+), 31 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 0db17c7..7af616c 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -112,6 +112,13 @@ struct ab8500_fg_avg_cap {
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
@@ -122,6 +129,7 @@ struct ab8500_fg_battery_capacity {
 	int prev_percent;
 	int prev_level;
 	int user_mah;
+	struct ab8500_fg_cap_scaling cap_scale;
 };
 
 struct ab8500_fg_flags {
@@ -928,10 +936,11 @@ static int ab8500_fg_battery_resistance(struct ab8500_fg *di)
 		resist = tbl[tbl_size - 1].resist;
 	}
 
-	dev_dbg(di->dev, "%s Temp: %d battery internal resistance: %d"
-	    " fg resistance %d, total: %d (mOhm)\n",
-		__func__, di->bat_temp, resist, di->bat->fg_res / 10,
-		(di->bat->fg_res / 10) + resist);
+	dev_dbg(di->dev, "%s Temp: %d battery internal resistance: %d",
+					__func__, di->bat_temp, resist);
+	dev_dbg(di->dev, " fg resistance %d, total: %d (mOhm)\n",
+					di->bat->fg_res / 10,
+					(di->bat->fg_res / 10) + resist);
 
 	/* fg_res variable is in 0.1mOhm */
 	resist += di->bat->fg_res / 10;
@@ -1168,6 +1177,99 @@ static int ab8500_fg_capacity_level(struct ab8500_fg *di)
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
+			max(capacity, di->bat->fg_params->maint_thres);
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
+				    di->bat->fg_params->maint_thres);
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
@@ -1215,16 +1317,24 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
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
-			di->bat->fg_params->maint_thres) {
+
+			changed = true;
+
+			if (!di->bat_cap.cap_scale.enable &&
+						di->bat->capacity_scaling) {
+				di->bat_cap.cap_scale.enable = true;
+				di->bat_cap.cap_scale.cap_to_scale[0] = 100;
+				di->bat_cap.cap_scale.cap_to_scale[1] =
+						di->bat_cap.prev_percent;
+				di->bat_cap.cap_scale.disable_cap_level = 100;
+			}
+		} else if (di->bat_cap.prev_percent !=
+			(di->bat_cap.permille) / 10) {
 			dev_dbg(di->dev,
 				"battery reported full "
 				"but capacity dropping: %d\n",
@@ -1273,6 +1383,14 @@ static void ab8500_fg_check_capacity_limits(struct ab8500_fg *di, bool init)
 	}
 
 	if (changed) {
+		if (di->bat->capacity_scaling) {
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
@@ -1338,7 +1456,7 @@ static void ab8500_fg_algorithm_charging(struct ab8500_fg *di)
 		 * Read the FG and calculate the new capacity
 		 */
 		mutex_lock(&di->cc_lock);
-		if (!di->flags.conv_done) {
+		if (!di->flags.conv_done && !di->flags.force_full) {
 			/* Wasn't the CC IRQ that got us here */
 			mutex_unlock(&di->cc_lock);
 			dev_dbg(di->dev, "%s CC conv not done\n",
@@ -2028,7 +2146,9 @@ static int ab8500_fg_get_property(struct power_supply *psy,
 			val->intval = di->bat_cap.prev_mah;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		if (di->flags.batt_unknown && !di->bat->chg_unknown_bat &&
+		if (di->bat->capacity_scaling)
+			val->intval = di->bat_cap.cap_scale.scaled_cap;
+		else if (di->flags.batt_unknown && !di->bat->chg_unknown_bat &&
 				di->flags.batt_id_received)
 			val->intval = 100;
 		else
@@ -2092,6 +2212,9 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 						break;
 					di->flags.charging = false;
 					di->flags.fully_charged = false;
+					if (di->bat->capacity_scaling)
+						ab8500_fg_update_cap_scalers
+									(di);
 					queue_work(di->fg_wq, &di->fg_work);
 					break;
 				case POWER_SUPPLY_STATUS_FULL:
@@ -2104,10 +2227,14 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 					queue_work(di->fg_wq, &di->fg_work);
 					break;
 				case POWER_SUPPLY_STATUS_CHARGING:
-					if (di->flags.charging)
+					if (di->flags.charging &&
+						!di->flags.fully_charged)
 						break;
 					di->flags.charging = true;
 					di->flags.fully_charged = false;
+					if (di->bat->capacity_scaling)
+						ab8500_fg_update_cap_scalers
+									(di);
 					queue_work(di->fg_wq, &di->fg_work);
 					break;
 				};
@@ -2147,8 +2274,8 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
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
index 032b27d..ca87cb2 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -31,9 +31,6 @@
 /* End-of-charge criteria counter */
 #define EOC_COND_CNT			10
 
-/* Recharge criteria counter */
-#define RCH_COND_CNT			3
-
 #define to_abx500_chargalg_device_info(x) container_of((x), \
 	struct abx500_chargalg, chargalg_psy);
 
@@ -189,13 +186,18 @@ enum maxim_ret {
 	MAXIM_RET_IBAT_TOO_HIGH,
 };
 
+enum maintenance_state {
+	MAINT_A,
+	MAINT_B,
+};
+
 /**
  * struct abx500_chargalg - abx500 Charging algorithm device information
  * @dev:		pointer to the structure device
  * @charge_status:	battery operating status
  * @eoc_cnt:		counter used to determine end-of_charge
- * @rch_cnt:		counter used to determine start of recharge
  * @maintenance_chg:	indicate if maintenance charge is active
+ * @maint_state:	indicate what maintenance state we should go to next
  * @t_hyst_norm		temperature hysteresis when the temperature has been
  *			over or under normal limits
  * @t_hyst_lowhigh	temperature hysteresis when the temperature has been
@@ -223,8 +225,8 @@ struct abx500_chargalg {
 	struct ab8500 *parent;
 	int charge_status;
 	int eoc_cnt;
-	int rch_cnt;
 	bool maintenance_chg;
+	enum maintenance_state maint_state;
 	int t_hyst_norm;
 	int t_hyst_lowhigh;
 	enum abx500_chargalg_states charge_state;
@@ -859,6 +861,7 @@ static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 	union power_supply_propval ret;
 	int i, j;
 	bool psy_found = false;
+	bool capacity_updated = false;
 
 	psy = (struct power_supply *)data;
 	ext = dev_get_drvdata(dev);
@@ -871,6 +874,16 @@ static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 	if (!psy_found)
 		return 0;
 
+	/*
+	 * If external is not registering 'POWER_SUPPLY_PROP_CAPACITY' to its
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
@@ -1156,6 +1169,8 @@ static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 			break;
 		case POWER_SUPPLY_PROP_CAPACITY:
 			di->batt_data.percent = ret.intval;
+			if (!capacity_updated)
+				di->batt_data.percent = ret.intval;
 			break;
 		default:
 			break;
@@ -1425,16 +1440,32 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 	case STATE_WAIT_FOR_RECHARGE_INIT:
 		abx500_chargalg_hold_charging(di);
 		abx500_chargalg_state_to(di, STATE_WAIT_FOR_RECHARGE);
-		di->rch_cnt = RCH_COND_CNT;
 		/* Intentional fallthrough */
 
 	case STATE_WAIT_FOR_RECHARGE:
-		if (di->batt_data.volt <=
-			di->bat->bat_type[di->bat->batt_id].recharge_vol) {
-			if (di->rch_cnt-- == 0)
+		if (di->bat->no_maintenance) {
+			if (di->batt_data.percent <=
+				di->bat->bat_type[di->bat->batt_id].
+				recharge_cap)
 				abx500_chargalg_state_to(di, STATE_NORMAL_INIT);
-		} else
-			di->rch_cnt = RCH_COND_CNT;
+		} else {
+			/* Maintenance A */
+			if (di->maint_state == MAINT_A &&
+					di->batt_data.volt <
+					di->bat->bat_type[di->bat->batt_id].
+					maint_a_vol_lvl) {
+				abx500_chargalg_state_to(di,
+						STATE_MAINTENANCE_A_INIT);
+			}
+			/* Maintenance B */
+			else if (di->maint_state == MAINT_B &&
+					di->batt_data.volt <
+					di->bat->bat_type[di->bat->batt_id].
+					maint_b_vol_lvl)  {
+				abx500_chargalg_state_to(di,
+						STATE_MAINTENANCE_B_INIT);
+			}
+		}
 		break;
 
 	case STATE_MAINTENANCE_A_INIT:
@@ -1718,7 +1749,7 @@ static struct kobj_type abx500_chargalg_ktype = {
 
 /**
  * abx500_chargalg_sysfs_exit() - de-init of sysfs entry
- * @di:                pointer to the struct abx500_chargalg
+ * @di:		       pointer to the struct abx500_chargalg
  *
  * This function removes the entry in sysfs.
  */
@@ -1729,7 +1760,7 @@ static void abx500_chargalg_sysfs_exit(struct abx500_chargalg *di)
 
 /**
  * abx500_chargalg_sysfs_init() - init of sysfs entry
- * @di:                pointer to the struct abx500_chargalg
+ * @di:		       pointer to the struct abx500_chargalg
  *
  * This function adds an entry in sysfs.
  * Returns error code in case of failure else 0(on success)
@@ -1780,7 +1811,7 @@ static int abx500_chargalg_suspend(struct platform_device *pdev,
 }
 #else
 #define abx500_chargalg_suspend      NULL
-#define abx500_chargalg_resume       NULL
+#define abx500_chargalg_resume	     NULL
 #endif
 
 static int __devexit abx500_chargalg_remove(struct platform_device *pdev)
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 1318ca6..4d44a10 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -246,7 +246,7 @@ struct abx500_maxim_parameters {
  * @nominal_voltage:		Nominal voltage of the battery in mV
  * @termination_vol:		max voltage upto which battery can be charged
  * @termination_curr		battery charging termination current in mA
- * @recharge_vol		battery voltage limit that will trigger a new
+ * @recharge_cap		battery capacity limit that will trigger a new
  *				full charging cycle in the case where maintenan-
  *				-ce charging has been disabled
  * @normal_cur_lvl:		charger current in normal state in mA
@@ -275,7 +275,7 @@ struct abx500_battery_type {
 	int nominal_voltage;
 	int termination_vol;
 	int termination_curr;
-	int recharge_vol;
+	int recharge_cap;
 	int normal_cur_lvl;
 	int normal_vol_lvl;
 	int maint_a_cur_lvl;
@@ -339,6 +339,7 @@ struct abx500_bm_charger_parameters {
  * @bkup_bat_v		voltage which we charge the backup battery with
  * @bkup_bat_i		current which we charge the backup battery with
  * @no_maintenance	indicates that maintenance charging is disabled
+ * @capacity_scaling	indicates whether capacity scaling is to be used
  * @abx500_adc_therm	placement of thermistor, batctrl or battemp adc
  * @chg_unknown_bat	flag to enable charging of unknown batteries
  * @enable_overshoot	flag to enable VBAT overshoot control
@@ -369,6 +370,7 @@ struct abx500_bm_data {
 	int bkup_bat_v;
 	int bkup_bat_i;
 	bool no_maintenance;
+	bool capacity_scaling;
 	bool chg_unknown_bat;
 	bool enable_overshoot;
 	bool auto_trig;
-- 
1.7.5.4

