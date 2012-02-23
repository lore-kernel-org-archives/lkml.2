Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2BWEpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 23:45:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:12870 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab2BWEpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 23:45:18 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-5b-4f45c45b3bec
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        rdunlap@xenotime.net, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com
Subject: [PATCH 1/2] power_supply: Charger-Manager: poll battery health in
 normal state
Date: Thu, 23 Feb 2012 13:44:59 +0900
Message-id: <1329972300-19335-2-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1329972300-19335-1-git-send-email-dg77.kim@samsung.com>
References: <1329972300-19335-1-git-send-email-dg77.kim@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Charger-Manager needs to check battery health in normal state
as well as suspend-to-RAM state.
When the battery is fully charged,
Charger-Manager needs to determine when the chargers restart charging.

This patch allows Charger-Manager to monitor battery health in normal state
and handle operation for chargers after battery is fully charged.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/power/charger-manager.txt |   25 ++++-
 drivers/power/charger-manager.c         |  230 +++++++++++++++++++++++++++++++
 include/linux/power/charger-manager.h   |   25 ++++
 3 files changed, 279 insertions(+), 1 deletions(-)

diff --git a/Documentation/power/charger-manager.txt b/Documentation/power/charger-manager.txt
index fdcca99..47f7fdc 100644
--- a/Documentation/power/charger-manager.txt
+++ b/Documentation/power/charger-manager.txt
@@ -44,6 +44,12 @@ Charger Manager supports the following:
 	Normally, the platform will need to resume and suspend some devices
 	that are used by Charger Manager.
 
+* Support for premature full-battery event handling
+	If the battery voltage drops by "fullbatt_vchkdrop_uV" after
+	"fullbatt_vchkdrop_ms" from the full-battery event, the framework
+	restarts charging. This check is also performed while suspended by
+	setting wakeup time accordingly and using suspend_again.
+
 2. Global Charger-Manager Data related with suspend_again
 ========================================================
 In order to setup Charger Manager with suspend-again feature
@@ -55,7 +61,7 @@ if there are multiple batteries. If there are multiple batteries, the
 multiple instances of Charger Manager share the same charger_global_desc
 and it will manage in-suspend monitoring for all instances of Charger Manager.
 
-The user needs to provide all the two entries properly in order to activate
+The user needs to provide all the three entries properly in order to activate
 in-suspend monitoring:
 
 struct charger_global_desc {
@@ -74,6 +80,11 @@ bool (*rtc_only_wakeup)(void);
 	same struct. If there is any other wakeup source triggered the
 	wakeup, it should return false. If the "rtc" is the only wakeup
 	reason, it should return true.
+
+bool assume_timer_stops_in_suspend;
+	: if true, Charger Manager assumes that
+	the timer (CM uses jiffies as timer) stops during suspend. Then, CM
+	assumes that the suspend-duration is same as the alarm length.
 };
 
 3. How to setup suspend_again
@@ -111,6 +122,16 @@ enum polling_modes polling_mode;
 	  CM_POLL_CHARGING_ONLY: poll this battery if and only if the
 				 battery is being charged.
 
+unsigned int fullbatt_vchkdrop_ms;
+unsigned int fullbatt_vchkdrop_uV;
+	: If both have non-zero values, Charger Manager will check the
+	battery voltage drop fullbatt_vchkdrop_ms after the battery is fully
+	charged. If the voltage drop is over fullbatt_vchkdrop_uV, Charger
+	Manager will try to recharge the battery by disabling and enabling
+	chargers. Recharge with voltage drop condition only (without delay
+	condition) is needed to be implemented with hardware interrupts from
+	fuel gauges or charger devices/chips.
+
 unsigned int fullbatt_uV;
 	: If specified with a non-zero value, Charger Manager assumes
 	that the battery is full (capacity = 100) if the battery is not being
@@ -122,6 +143,8 @@ unsigned int polling_interval_ms;
 	this battery every polling_interval_ms or more frequently.
 
 enum data_source battery_present;
+	: CM_ASSUME_ALWAYS_TRUE: assume that the battery exists.
+	CM_ASSUME_ALWAYS_FALSE: assume that the battery does not exists.
 	CM_FUEL_GAUGE: get battery presence information from fuel gauge.
 	CM_CHARGER_STAT: get battery presence from chargers.
 
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 88fd971..9ecde4c 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -57,6 +57,12 @@ static bool cm_suspended;
 static bool cm_rtc_set;
 static unsigned long cm_suspend_duration_ms;
 
+/* About normal (not suspended) monitoring */
+static unsigned long polling_jiffy = ULONG_MAX; /* ULONG_MAX: no polling */
+static unsigned long next_polling; /* Next appointed polling time */
+static struct workqueue_struct *cm_wq; /* init at driver add */
+static struct delayed_work cm_monitor_work; /* init at driver add */
+
 /* Global charger-manager description */
 static struct charger_global_desc *g_desc; /* init with setup_charger_manager */
 
@@ -71,6 +77,12 @@ static bool is_batt_present(struct charger_manager *cm)
 	int i, ret;
 
 	switch (cm->desc->battery_present) {
+	case CM_ASSUME_ALWAYS_TRUE:
+		present = true;
+		break;
+	case CM_ASSUME_ALWAYS_FALSE:
+		present = false;
+		break;
 	case CM_FUEL_GAUGE:
 		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
 				POWER_SUPPLY_PROP_PRESENT, &val);
@@ -282,6 +294,26 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 }
 
 /**
+ * try_charger_restart - Restart charging.
+ * @cm: the Charger Manager representing the battery.
+ *
+ * Restart charging by turning off and on the charger.
+ */
+static int try_charger_restart(struct charger_manager *cm)
+{
+	int err;
+
+	if (cm->emergency_stop)
+		return -EAGAIN;
+
+	err = try_charger_enable(cm, false);
+	if (err)
+		return err;
+
+	return try_charger_enable(cm, true);
+}
+
+/**
  * uevent_notify - Let users know something has changed.
  * @cm: the Charger Manager representing the battery.
  * @event: the event string.
@@ -339,6 +371,47 @@ static void uevent_notify(struct charger_manager *cm, const char *event)
 }
 
 /**
+ * fullbatt_vchk - Check voltage drop some times after "FULL" event.
+ * @work: the work_struct appointing the function
+ *
+ * If a user has designated "fullbatt_vchkdrop_ms/uV" values with
+ * charger_desc, Charger Manager checks voltage drop after the battery
+ * "FULL" event. It checks whether the voltage has dropped more than
+ * fullbatt_vchkdrop_uV by calling this function after fullbatt_vchkrop_ms.
+ */
+static void fullbatt_vchk(struct work_struct *work)
+{
+	struct delayed_work *dwork =
+		container_of(work, struct delayed_work, work);
+	struct charger_manager *cm = container_of(dwork,
+			struct charger_manager, fullbatt_vchk_work);
+	struct charger_desc *desc = cm->desc;
+	int batt_uV, err, diff;
+
+	/* remove the appointment for fullbatt_vchk */
+	cm->fullbatt_vchk_jiffies_at = 0;
+
+	if (!desc->fullbatt_vchkdrop_uV || !desc->fullbatt_vchkdrop_ms)
+		return;
+
+	err = get_batt_uV(cm, &batt_uV);
+	if (err) {
+		dev_err(cm->dev, "%s: get_batt_uV error(%d).\n", __func__, err);
+		return;
+	}
+
+	diff = cm->fullbatt_vchk_uV;
+	diff -= batt_uV;
+
+	dev_dbg(cm->dev, "VBATT dropped %duV after full-batt.\n", diff);
+
+	if (diff > desc->fullbatt_vchkdrop_uV) {
+		try_charger_restart(cm);
+		uevent_notify(cm, "Recharge");
+	}
+}
+
+/**
  * _cm_monitor - Monitor the temperature and return true for exceptions.
  * @cm: the Charger Manager representing the battery.
  *
@@ -395,6 +468,68 @@ static bool cm_monitor(void)
 	return stop;
 }
 
+/**
+ * _setup_polling - Setup the next instance of polling.
+ * @work: work_struct of the function _setup_polling.
+ */
+static void _setup_polling(struct work_struct *work)
+{
+	unsigned long min = ULONG_MAX;
+	struct charger_manager *cm;
+	bool keep_polling = false;
+	unsigned long _next_polling;
+
+	mutex_lock(&cm_list_mtx);
+
+	list_for_each_entry(cm, &cm_list, entry) {
+		if (is_polling_required(cm) && cm->desc->polling_interval_ms) {
+			keep_polling = true;
+
+			if (min > cm->desc->polling_interval_ms)
+				min = cm->desc->polling_interval_ms;
+		}
+	}
+
+	polling_jiffy = msecs_to_jiffies(min);
+	if (polling_jiffy <= CM_JIFFIES_SMALL)
+		polling_jiffy = CM_JIFFIES_SMALL + 1;
+
+	if (!keep_polling)
+		polling_jiffy = ULONG_MAX;
+	if (polling_jiffy == ULONG_MAX)
+		goto out;
+
+	WARN(cm_wq == NULL, "charger-manager: workqueue not initialized"
+			    ". try it later. %s\n", __func__);
+
+	_next_polling = jiffies + polling_jiffy;
+
+	if (!delayed_work_pending(&cm_monitor_work) ||
+	    (delayed_work_pending(&cm_monitor_work) &&
+	     time_after(next_polling, _next_polling))) {
+		cancel_delayed_work(&cm_monitor_work);
+		next_polling = jiffies + polling_jiffy;
+		queue_delayed_work(cm_wq, &cm_monitor_work, polling_jiffy);
+	}
+
+out:
+	mutex_unlock(&cm_list_mtx);
+}
+static DECLARE_WORK(setup_polling, _setup_polling);
+
+/**
+ * cm_monitor_poller - The Monitor / Poller.
+ * @work: work_struct of the function cm_monitor_poller
+ *
+ * During non-suspended state, cm_monitor_poller is used to poll and monitor
+ * the batteries.
+ */
+static void cm_monitor_poller(struct work_struct *work)
+{
+	cm_monitor();
+	schedule_work(&setup_polling);
+}
+
 static int charger_get_property(struct power_supply *psy,
 		enum power_supply_property psp,
 		union power_supply_propval *val)
@@ -616,6 +751,20 @@ static bool cm_setup_timer(void)
 	mutex_lock(&cm_list_mtx);
 
 	list_for_each_entry(cm, &cm_list, entry) {
+		unsigned int fbchk_ms = 0;
+
+		/* fullbatt_vchk is required. setup timer for that */
+		if (cm->fullbatt_vchk_jiffies_at) {
+			fbchk_ms = jiffies_to_msecs(cm->fullbatt_vchk_jiffies_at
+						    - jiffies);
+			if (cm->fullbatt_vchk_jiffies_at <= jiffies ||
+				msecs_to_jiffies(fbchk_ms) < CM_JIFFIES_SMALL) {
+				fullbatt_vchk(&cm->fullbatt_vchk_work.work);
+				fbchk_ms = 0;
+			}
+		}
+		CM_MIN_VALID(wakeup_ms, fbchk_ms);
+
 		/* Skip if polling is not required for this CM */
 		if (!is_polling_required(cm) && !cm->emergency_stop)
 			continue;
@@ -675,6 +824,27 @@ static bool cm_setup_timer(void)
 	return false;
 }
 
+static bool _cm_fbchk_in_suspend(struct charger_manager *cm)
+{
+	unsigned long jiffy_now = jiffies;
+
+	if (!cm->fullbatt_vchk_jiffies_at)
+		return false;
+
+	if (g_desc && g_desc->assume_timer_stops_in_suspend)
+		jiffy_now += msecs_to_jiffies(cm_suspend_duration_ms);
+
+	/* Execute now if it's going to be executed not too long after */
+	jiffy_now += CM_JIFFIES_SMALL;
+
+	if (time_after_eq(jiffy_now, cm->fullbatt_vchk_jiffies_at)) {
+		fullbatt_vchk(&cm->fullbatt_vchk_work.work);
+		return true;
+	}
+
+	return false;
+}
+
 /**
  * cm_suspend_again - Determine whether suspend again or not
  *
@@ -696,6 +866,8 @@ bool cm_suspend_again(void)
 	ret = true;
 	mutex_lock(&cm_list_mtx);
 	list_for_each_entry(cm, &cm_list, entry) {
+		_cm_fbchk_in_suspend(cm);
+
 		if (cm->status_save_ext_pwr_inserted != is_ext_pwr_online(cm) ||
 		    cm->status_save_batt != is_batt_present(cm))
 			ret = false;
@@ -797,6 +969,21 @@ static int charger_manager_probe(struct platform_device *pdev)
 	memcpy(cm->desc, desc, sizeof(struct charger_desc));
 	cm->last_temp_mC = INT_MIN; /* denotes "unmeasured, yet" */
 
+	/*
+	 * The following two do not need to be errors.
+	 * Users may intentionally ignore those two features.
+	 */
+	if (desc->fullbatt_uV == 0) {
+		dev_info(&pdev->dev, "Ignoring full-battery voltage threshold"
+					" as it is not supplied.");
+	}
+	if (!desc->fullbatt_vchkdrop_ms || !desc->fullbatt_vchkdrop_uV) {
+		dev_info(&pdev->dev, "Disabling full-battery voltage drop "
+				"checking mechanism as it is not supplied.");
+		desc->fullbatt_vchkdrop_ms = 0;
+		desc->fullbatt_vchkdrop_uV = 0;
+	}
+
 	if (!desc->charger_regulators || desc->num_charger_regulators < 1) {
 		ret = -EINVAL;
 		dev_err(&pdev->dev, "charger_regulators undefined.\n");
@@ -905,6 +1092,8 @@ static int charger_manager_probe(struct platform_device *pdev)
 		cm->charger_psy.num_properties++;
 	}
 
+	INIT_DELAYED_WORK(&cm->fullbatt_vchk_work, fullbatt_vchk);
+
 	ret = power_supply_register(NULL, &cm->charger_psy);
 	if (ret) {
 		dev_err(&pdev->dev, "Cannot register charger-manager with"
@@ -930,6 +1119,8 @@ static int charger_manager_probe(struct platform_device *pdev)
 	list_add(&cm->entry, &cm_list);
 	mutex_unlock(&cm_list_mtx);
 
+	schedule_work(&setup_polling);
+
 	return 0;
 
 err_chg_enable:
@@ -961,10 +1152,14 @@ static int __devexit charger_manager_remove(struct platform_device *pdev)
 	list_del(&cm->entry);
 	mutex_unlock(&cm_list_mtx);
 
+	schedule_work(&setup_polling);
+
 	if (desc->charger_regulators)
 		regulator_bulk_free(desc->num_charger_regulators,
 					desc->charger_regulators);
 
+	try_charger_enable(cm, false);
+
 	power_supply_unregister(&cm->charger_psy);
 	kfree(cm->charger_psy.properties);
 	kfree(cm->charger_stat);
@@ -1007,6 +1202,7 @@ static int cm_suspend_prepare(struct device *dev)
 		cm_suspended = true;
 	}
 
+	cancel_delayed_work(&cm->fullbatt_vchk_work);
 	cm->status_save_ext_pwr_inserted = is_ext_pwr_online(cm);
 	cm->status_save_batt = is_batt_present(cm);
 
@@ -1036,6 +1232,34 @@ static void cm_suspend_complete(struct device *dev)
 		cm_rtc_set = false;
 	}
 
+	/* Re-enqueue delayed work (fullbatt_vchk_work) */
+	if (cm->fullbatt_vchk_jiffies_at) {
+		unsigned long delay = 0;
+		unsigned long now = jiffies;
+
+		if (time_after_eq(now + CM_JIFFIES_SMALL,
+				  cm->fullbatt_vchk_jiffies_at)) {
+			delay = (unsigned long)((long)(now + CM_JIFFIES_SMALL)
+				- (long)(cm->fullbatt_vchk_jiffies_at));
+			delay = jiffies_to_msecs(delay);
+		} else {
+			delay = 0;
+		}
+
+		/*
+		 * Account for cm_suspend_duration_ms if
+		 * assume_timer_stops_in_suspend is active
+		 */
+		if (g_desc && g_desc->assume_timer_stops_in_suspend) {
+			if (delay > cm_suspend_duration_ms)
+				delay -= cm_suspend_duration_ms;
+			else
+				delay = 0;
+		}
+
+		queue_delayed_work(cm_wq, &cm->fullbatt_vchk_work,
+				   msecs_to_jiffies(delay));
+	}
 	uevent_notify(cm, NULL);
 }
 
@@ -1057,12 +1281,18 @@ static struct platform_driver charger_manager_driver = {
 
 static int __init charger_manager_init(void)
 {
+	cm_wq = create_freezable_workqueue("charger_manager");
+	INIT_DELAYED_WORK(&cm_monitor_work, cm_monitor_poller);
+
 	return platform_driver_register(&charger_manager_driver);
 }
 late_initcall(charger_manager_init);
 
 static void __exit charger_manager_cleanup(void)
 {
+	destroy_workqueue(cm_wq);
+	cm_wq = NULL;
+
 	platform_driver_unregister(&charger_manager_driver);
 }
 module_exit(charger_manager_cleanup);
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 4f75e53..78b9865 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -18,6 +18,8 @@
 #include <linux/power_supply.h>
 
 enum data_source {
+	CM_ASSUME_ALWAYS_TRUE,
+	CM_ASSUME_ALWAYS_FALSE,
 	CM_FUEL_GAUGE,
 	CM_CHARGER_STAT,
 };
@@ -38,11 +40,18 @@ enum polling_modes {
  *	rtc_only_wakeup() returning false.
  *	If the RTC given to CM is the only wakeup reason,
  *	rtc_only_wakeup should return true.
+ * @assume_timer_stops_in_suspend:
+ *	Assume that the jiffy timer stops in suspend-to-RAM.
+ *	When enabled, CM does not rely on jiffies value in
+ *	suspend_again and assumes that jiffies value does not
+ *	change during suspend.
  */
 struct charger_global_desc {
 	char *rtc_name;
 
 	bool (*rtc_only_wakeup)(void);
+
+	bool assume_timer_stops_in_suspend;
 };
 
 /**
@@ -50,6 +59,11 @@ struct charger_global_desc {
  * @psy_name: the name of power-supply-class for charger manager
  * @polling_mode:
  *	Determine which polling mode will be used
+ * @fullbatt_vchkdrop_ms:
+ * @fullbatt_vchkdrop_uV:
+ *	Check voltage drop after the battery is fully charged.
+ *	If it has dropped more than fullbatt_vchkdrop_uV after
+ *	fullbatt_vchkdrop_ms, CM will restart charging.
  * @fullbatt_uV: voltage in microvolt
  *	If it is not being charged and VBATT >= fullbatt_uV,
  *	it is assumed to be full.
@@ -76,6 +90,8 @@ struct charger_desc {
 	enum polling_modes polling_mode;
 	unsigned int polling_interval_ms;
 
+	unsigned int fullbatt_vchkdrop_ms;
+	unsigned int fullbatt_vchkdrop_uV;
 	unsigned int fullbatt_uV;
 
 	enum data_source battery_present;
@@ -101,6 +117,11 @@ struct charger_desc {
  * @fuel_gauge: power_supply for fuel gauge
  * @charger_stat: array of power_supply for chargers
  * @charger_enabled: the state of charger
+ * @fullbatt_vchk_jiffies_at:
+ *	jiffies at the time full battery check will occur.
+ * @fullbatt_vchk_uV: voltage in microvolt
+ *	criteria for full battery
+ * @fullbatt_vchk_work: work queue for full battery check
  * @emergency_stop:
  *	When setting true, stop charging
  * @last_temp_mC: the measured temperature in milli-Celsius
@@ -121,6 +142,10 @@ struct charger_manager {
 
 	bool charger_enabled;
 
+	unsigned long fullbatt_vchk_jiffies_at;
+	unsigned int fullbatt_vchk_uV;
+	struct delayed_work fullbatt_vchk_work;
+
 	int emergency_stop;
 	int last_temp_mC;
 
-- 
1.7.4.1

