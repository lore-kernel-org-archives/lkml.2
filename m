Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab2HUIHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:07:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33826 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2HUIGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:06:44 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-e8-5033418e560c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 4/5] charger-manager: Check fully charged state of battery
 periodically
Date: Tue, 21 Aug 2012 17:06:52 +0900
Message-id: <1345536412-25914-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJMWRmVeSWpSXmKPExsVy+t9jQd0+R+MAg8kdIhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj9vc57AV3HCou9jcxNjDuMe5i5OCQEDCRaPkm3sXICWSKSVy4
	t56ti5GLQ0hgOqPEqYYTjBDOUiaJa+3T2ECq2AS0JPa/uAFmiwjISbxe+5cJpIhZ4BSjxKOL
	J5hBpgoLREr8elMBUsMioCpxvucbC0iYV8BVYu5kDohlChKtyw6xT2DkXsDIsIpRNLUguaA4
	KT3XUK84Mbe4NC9dLzk/dxMj2H/PpHYwrmywOMQowMGoxMP7Y5FRgBBrYllxZe4hRgkOZiUR
	3mp94wAh3pTEyqrUovz4otKc1OJDjNIcLErivPx9hgFCAumJJanZqakFqUUwWSYOTqkGRlfx
	trTiY8fCtQwDNsVJ5PvfvVQfkZjhxuMzU/CRT3lc0aGanTdW8BdNU3Mr3Vhr0yEz/8ETP/Wi
	sjt3i3JrZ0w3fnf4V9KhQqnuc9kHzj169Eduu4bnN6vVNanHZKpZ2RSWtPUsDasMFVDTdPM/
	EDDLea7ZHjllh7dFE7bFHdn5+XzTi6OiSizFGYmGWsxFxYkAgss8ENsBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch check periodically fully charged state of battery to protect
overcharge and overheat. If battery is fully charged, stop charging
and check droped voltage with 'fullbatt_vchkdrop_ms' period. When voltage
of battery is more droped than 'fullbatt_vchkdrop_uV' voltage,
charger-manager will restart charging for battery.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/charger-manager.c       |  161 ++++++++++++++++++++++++---------
 include/linux/power/charger-manager.h |    8 ++-
 2 files changed, 123 insertions(+), 46 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 33cc3f6..805f79d 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -228,6 +228,58 @@ static bool is_charging(struct charger_manager *cm)
 }
 
 /**
+ * is_full_charged - Returns true if the battery is fully charged.
+ * @cm: the Charger Manager representing the battery.
+ */
+static bool is_full_charged(struct charger_manager *cm)
+{
+	struct charger_desc *desc = cm->desc;
+	union power_supply_propval val;
+	int ret = 0;
+	int uV;
+
+	/* If there is no battery, it cannot be charged */
+	if (!is_batt_present(cm)) {
+		val.intval = 0;
+		goto out;
+	}
+
+	if (cm->fuel_gauge && desc->fullbatt_full_capacity > 0) {
+		/* Not full if capacity of fuel gauge isn't full */
+		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
+				POWER_SUPPLY_PROP_CHARGE_FULL, &val);
+		if (!ret && val.intval > desc->fullbatt_full_capacity) {
+			val.intval = 1;
+			goto out;
+		}
+	}
+
+	/* Full, if it's over the fullbatt voltage */
+	if (desc->fullbatt_uV > 0) {
+		ret = get_batt_uV(cm, &uV);
+		if (!ret && uV >= desc->fullbatt_uV) {
+			val.intval = 1;
+			goto out;
+		}
+	}
+
+	/* Full, if the capacity is more than fullbatt_soc */
+	if (cm->fuel_gauge && desc->fullbatt_soc > 0) {
+		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
+				POWER_SUPPLY_PROP_CAPACITY, &val);
+		if (!ret && val.intval >= desc->fullbatt_soc) {
+			val.intval = 1;
+			goto out;
+		}
+	}
+
+	val.intval = 0;
+
+out:
+	return val.intval ? true : false;
+}
+
+/**
  * is_polling_required - Return true if need to continue polling for this CM.
  * @cm: the Charger Manager representing the battery.
  */
@@ -427,7 +479,7 @@ static void fullbatt_vchk(struct work_struct *work)
 	diff = desc->fullbatt_uV;
 	diff -= batt_uV;
 
-	dev_dbg(cm->dev, "VBATT dropped %duV after full-batt.\n", diff);
+	dev_info(cm->dev, "VBATT dropped %duV after full-batt.\n", diff);
 
 	if (diff > desc->fullbatt_vchkdrop_uV) {
 		try_charger_restart(cm);
@@ -450,10 +502,14 @@ static bool _cm_monitor(struct charger_manager *cm)
 	dev_dbg(cm->dev, "monitoring (%2.2d.%3.3dC)\n",
 		cm->last_temp_mC / 1000, cm->last_temp_mC % 1000);
 
-	/* It has been stopped or charging already */
-	if (!!temp == !!cm->emergency_stop)
+	/* It has been stopped already */
+	if (temp && cm->emergency_stop)
 		return false;
 
+	/*
+	 * Check temperature whether overheat or cold.
+	 * If temperature is out of range normal state, stop charging.
+	 */
 	if (temp) {
 		cm->emergency_stop = temp;
 		if (!try_charger_enable(cm, false)) {
@@ -462,10 +518,34 @@ static bool _cm_monitor(struct charger_manager *cm)
 			else
 				uevent_notify(cm, "COLD");
 		}
+
+	/*
+	 * Check dropped voltage of battery. If battery voltage is more
+	 * dropped than fullbatt_vchkdrop_uV after fully charged state,
+	 * charger-manager have to recharge battery.
+	 */
+	} else if (!cm->emergency_stop
+			&& is_ext_pwr_online(cm) && !cm->charger_enabled) {
+		fullbatt_vchk(&cm->fullbatt_vchk_work.work);
+
+	/*
+	 * Check whether fully charged state to protect overcharge
+	 * if charger-manager is charging for battery.
+	 */
+	} else if (!cm->emergency_stop
+			&& is_full_charged(cm) && cm->charger_enabled) {
+		dev_info(cm->dev, "EVENT_HANDLE: Battery Fully Charged.\n");
+		uevent_notify(cm, default_event_names[CM_EVENT_BATT_FULL]);
+
+		try_charger_enable(cm, false);
+
+		fullbatt_vchk(&cm->fullbatt_vchk_work.work);
 	} else {
 		cm->emergency_stop = 0;
-		if (!try_charger_enable(cm, true))
-			uevent_notify(cm, "CHARGING");
+		if (is_ext_pwr_online(cm)) {
+			if (!try_charger_enable(cm, true))
+				uevent_notify(cm, "CHARGING");
+		}
 	}
 
 	return true;
@@ -728,47 +808,10 @@ static int charger_get_property(struct power_supply *psy,
 			val->intval = 0;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
-		if (cm->fuel_gauge) {
-			if (cm->fuel_gauge->get_property(cm->fuel_gauge,
-			    POWER_SUPPLY_PROP_CHARGE_FULL, val) == 0)
-				break;
-		}
-
-		if (is_ext_pwr_online(cm)) {
-			/* Not full if it's charging. */
-			if (is_charging(cm)) {
-				val->intval = 0;
-				break;
-			}
-			/*
-			 * Full if it's powered but not charging andi
-			 * not forced stop by emergency
-			 */
-			if (!cm->emergency_stop) {
-				val->intval = 1;
-				break;
-			}
-		}
-
-		/* Full if it's over the fullbatt voltage */
-		ret = get_batt_uV(cm, &uV);
-		if (!ret && desc->fullbatt_uV > 0 && uV >= desc->fullbatt_uV &&
-		    !is_charging(cm)) {
+		if (is_full_charged(cm))
 			val->intval = 1;
-			break;
-		}
-
-		/* Full if the cap is 100 */
-		if (cm->fuel_gauge) {
-			ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
-					POWER_SUPPLY_PROP_CAPACITY, val);
-			if (!ret && val->intval >= 100 && !is_charging(cm)) {
-				val->intval = 1;
-				break;
-			}
-		}
-
-		val->intval = 0;
+		else
+			val->intval = 0;
 		ret = 0;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_NOW:
@@ -1058,7 +1101,26 @@ static int charger_extcon_notifier(struct notifier_block *self,
 	struct charger_cable *cable =
 		container_of(self, struct charger_cable, nb);
 
+	/*
+	 * The newly state of charger cable.
+	 * If cable is attached, cable->attached is true.
+	 */
 	cable->attached = event;
+
+	/*
+	 * Setup monitoring to check battery state
+	 * when charger cable is attached.
+	 */
+	if (cable->attached && is_polling_required(cable->cm)) {
+		if (work_pending(&setup_polling))
+			cancel_work_sync(&setup_polling);
+		schedule_work(&setup_polling);
+	}
+
+	/*
+	 * Setup work for controlling charger(regulator)
+	 * according to charger cable.
+	 */
 	schedule_work(&cable->wq);
 
 	return NOTIFY_DONE;
@@ -1241,6 +1303,15 @@ static int charger_manager_probe(struct platform_device *pdev)
 		desc->fullbatt_vchkdrop_ms = 0;
 		desc->fullbatt_vchkdrop_uV = 0;
 	}
+	if (desc->fullbatt_soc == 0) {
+		dev_info(&pdev->dev, "Ignoring full-battery soc(state of"
+					" charge) threshold as it is not"
+					" supplied.");
+	}
+	if (desc->fullbatt_full_capacity == 0) {
+		dev_info(&pdev->dev, "Ignoring full-battery full capacity"
+					" threshold as it is not supplied.");
+	}
 
 	if (!desc->charger_regulators || desc->num_charger_regulators < 1) {
 		ret = -EINVAL;
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index afeff17..a5560f9 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -159,7 +159,11 @@ struct charger_regulator {
  *	If it has dropped more than fullbatt_vchkdrop_uV after
  *	fullbatt_vchkdrop_ms, CM will restart charging.
  * @fullbatt_uV: voltage in microvolt
- *	If it is not being charged and VBATT >= fullbatt_uV,
+ *	If VBATT >= fullbatt_uV, it is assumed to be full.
+ * @fullbatt_soc: state of Charge in %
+ *	If state of Charge >= fullbatt_soc, it is assumed to be full.
+ * @fullbatt_full_capacity: full capacity measure
+ *	If full capacity of battery >= fullbatt_full_capacity,
  *	it is assumed to be full.
  * @polling_interval_ms: interval in millisecond at which
  *	charger manager will monitor battery health
@@ -187,6 +191,8 @@ struct charger_desc {
 	unsigned int fullbatt_vchkdrop_ms;
 	unsigned int fullbatt_vchkdrop_uV;
 	unsigned int fullbatt_uV;
+	unsigned int fullbatt_soc;
+	unsigned int fullbatt_full_capacity;
 
 	enum data_source battery_present;
 
-- 
1.7.0.4

