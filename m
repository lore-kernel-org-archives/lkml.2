Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab2IYQO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:14:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab2IYQOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:14:17 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 51/57] power: ab8500: Re-alignment with internal developement.
Date: Tue, 25 Sep 2012 10:12:48 -0600
Message-Id: <1348589574-25655-52-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>

A lot of developement happened internally since the first
mainlining of the battery managmenent driver.  Most of the
new code can be historically accounted for but some of it
can't.

This patch is a gathering of the code for which history was
lost but still relevant to the well being of the driver.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/power/ab8500_charger.c  |    2 +-
 drivers/power/abx500_chargalg.c |   66 +++++++++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 1290470..3a97012 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -720,7 +720,7 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 		di->is_aca_rid = 0;
 		break;
 	case USB_STAT_ACA_RID_C_HS_CHIRP:
-		case USB_STAT_ACA_RID_C_NM:
+	case USB_STAT_ACA_RID_C_NM:
 		di->max_usb_in_curr.usb_type_max = USB_CH_IP_CUR_LVL_1P5;
 		di->is_aca_rid = 1;
 		break;
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 1df238f..636d970 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -27,7 +27,7 @@
 #include <linux/notifier.h>
 
 /* Watchdog kick interval */
-#define CHG_WD_INTERVAL			(6 * HZ)
+#define CHG_WD_INTERVAL			(60 * HZ)
 
 /* End-of-charge criteria counter */
 #define EOC_COND_CNT			10
@@ -513,7 +513,7 @@ static int abx500_chargalg_kick_watchdog(struct abx500_chargalg *di)
 static int abx500_chargalg_ac_en(struct abx500_chargalg *di, int enable,
 	int vset, int iset)
 {
-	static int ab8500_chargalg_ex_ac_enable_toggle;
+	static int abx500_chargalg_ex_ac_enable_toggle;
 
 	if (!di->ac_chg || !di->ac_chg->ops.enable)
 		return -ENXIO;
@@ -529,10 +529,10 @@ static int abx500_chargalg_ac_en(struct abx500_chargalg *di, int enable,
 
 	/*enable external charger*/
 	if (enable && di->ac_chg->external &&
-		!ab8500_chargalg_ex_ac_enable_toggle) {
+		!abx500_chargalg_ex_ac_enable_toggle) {
 		blocking_notifier_call_chain(&charger_notifier_list,
 					0, di->dev);
-		ab8500_chargalg_ex_ac_enable_toggle++;
+		abx500_chargalg_ex_ac_enable_toggle++;
 	}
 
 	return di->ac_chg->ops.enable(di->ac_chg, enable, vset, iset);
@@ -899,6 +899,27 @@ static void handle_maxim_chg_curr(struct abx500_chargalg *di)
 	}
 }
 
+static void abx500_chargalg_check_safety_timer(struct abx500_chargalg *di)
+{
+	/*
+	 * The safety timer will not be started until the capacity reported
+	 * from the FG algorithm is 100%. Then we know that the amount of
+	 * charge that's gone into the battery is enough for the battery
+	 * to be full. If it has not reached end-of-charge before the safety
+	 * timer has expired then we know that the battery is overcharged
+	 * and charging will be stopped to protect the battery.
+	 */
+	if (di->batt_data.percent == 100 &&
+		!timer_pending(&di->safety_timer)) {
+		abx500_chargalg_start_safety_timer(di);
+		dev_dbg(di->dev, "start safety timer\n");
+	} else if (di->batt_data.percent != 100 &&
+		timer_pending(&di->safety_timer)) {
+		abx500_chargalg_stop_safety_timer(di);
+		dev_dbg(di->dev, "stop safety timer\n");
+	}
+}
+
 static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 {
 	struct power_supply *psy;
@@ -1125,6 +1146,10 @@ static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 			switch (ext->type) {
 			case POWER_SUPPLY_TYPE_BATTERY:
 				di->batt_data.volt = ret.intval / 1000;
+				if (di->batt_data.volt >= BATT_OVV_VALUE)
+					di->events.batt_ovv = true;
+				else
+					di->events.batt_ovv = false;
 				break;
 			case POWER_SUPPLY_TYPE_MAINS:
 				di->chg_info.ac_volt = ret.intval / 1000;
@@ -1214,7 +1239,6 @@ static int abx500_chargalg_get_ext_psy_data(struct device *dev, void *data)
 			}
 			break;
 		case POWER_SUPPLY_PROP_CAPACITY:
-			di->batt_data.percent = ret.intval;
 			if (!capacity_updated)
 				di->batt_data.percent = ret.intval;
 			break;
@@ -1465,12 +1489,12 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 			di->bat->bat_type[di->bat->batt_id].normal_vol_lvl,
 			di->bat->bat_type[di->bat->batt_id].normal_cur_lvl);
 		abx500_chargalg_state_to(di, STATE_NORMAL);
-		abx500_chargalg_start_safety_timer(di);
 		abx500_chargalg_stop_maintenance_timer(di);
 		init_maxim_chg_curr(di);
 		di->charge_status = POWER_SUPPLY_STATUS_CHARGING;
 		di->eoc_cnt = 0;
 		di->maintenance_chg = false;
+		di->maint_state = MAINT_A;
 		power_supply_changed(&di->chargalg_psy);
 
 		break;
@@ -1478,17 +1502,14 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 	case STATE_NORMAL:
 		handle_maxim_chg_curr(di);
 		if (di->charge_status == POWER_SUPPLY_STATUS_FULL &&
-			di->maintenance_chg) {
-			if (di->bat->no_maintenance)
-				abx500_chargalg_state_to(di,
-					STATE_WAIT_FOR_RECHARGE_INIT);
-			else
-				abx500_chargalg_state_to(di,
-					STATE_MAINTENANCE_A_INIT);
-		}
+				di->maintenance_chg)
+			abx500_chargalg_state_to(di,
+				STATE_WAIT_FOR_RECHARGE_INIT);
+
+		/* Check whether we should start the safety timer or not */
+		abx500_chargalg_check_safety_timer(di);
 		break;
 
-	/* This state will be used when the maintenance state is disabled */
 	case STATE_WAIT_FOR_RECHARGE_INIT:
 		abx500_chargalg_hold_charging(di);
 		abx500_chargalg_state_to(di, STATE_WAIT_FOR_RECHARGE);
@@ -1531,13 +1552,15 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 			di->bat->bat_type[
 				di->bat->batt_id].maint_a_cur_lvl);
 		abx500_chargalg_state_to(di, STATE_MAINTENANCE_A);
+		di->maint_state = MAINT_B;
 		power_supply_changed(&di->chargalg_psy);
 		/* Intentional fallthrough*/
 
 	case STATE_MAINTENANCE_A:
 		if (di->events.maintenance_timer_expired) {
 			abx500_chargalg_stop_maintenance_timer(di);
-			abx500_chargalg_state_to(di, STATE_MAINTENANCE_B_INIT);
+			abx500_chargalg_state_to(di,
+					STATE_WAIT_FOR_RECHARGE_INIT);
 		}
 		break;
 
@@ -1603,7 +1626,8 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 	/* Start charging directly if the new state is a charge state */
 	if (di->charge_state == STATE_NORMAL_INIT ||
 			di->charge_state == STATE_MAINTENANCE_A_INIT ||
-			di->charge_state == STATE_MAINTENANCE_B_INIT)
+			di->charge_state == STATE_MAINTENANCE_B_INIT ||
+			di->charge_state == STATE_WAIT_FOR_RECHARGE_INIT)
 		queue_work(di->chargalg_wq, &di->chargalg_work);
 }
 
@@ -1824,7 +1848,7 @@ static struct attribute *abx500_chargalg_chg[] = {
 	NULL
 };
 
-static const struct sysfs_ops abx500_chargalg_sysfs_ops = {
+const struct sysfs_ops abx500_chargalg_sysfs_ops = {
 	.show = abx500_chargalg_sysfs_show,
 	.store = abx500_chargalg_sysfs_charger,
 };
@@ -2009,10 +2033,12 @@ static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
 		goto free_psy;
 	}
 
+	di->charge_status = POWER_SUPPLY_STATUS_DISCHARGING;
+	abx500_chargalg_state_to(di, STATE_HANDHELD);
+
 	/* Run the charging algorithm */
 	queue_delayed_work(di->chargalg_wq, &di->chargalg_periodic_work, 0);
 
-	dev_info(di->dev, "probe success\n");
 	return ret;
 
 free_psy:
@@ -2052,4 +2078,4 @@ module_exit(abx500_chargalg_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Johan Palsson, Karl Komierowski");
 MODULE_ALIAS("platform:abx500-chargalg");
-MODULE_DESCRIPTION("abx500 battery charging algorithm");
+MODULE_DESCRIPTION("abx500 battery temperatur driver");
-- 
1.7.5.4

