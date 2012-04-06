Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab2DFAbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:31:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13690 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab2DFAbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:31:21 -0400
X-AuditID: cbfee61a-b7c49ae0000061d4-25-4f7e3957d774
Message-id: <4F7E3956.5000107@samsung.com>
Date: Fri, 06 Apr 2012 09:31:18 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [RESEND PATCH v2 2/2] power_supply: Charger-Manager: provide function
 for in-kernel use
References: <4F72FF13.6030804@samsung.com>
In-reply-to: <4F72FF13.6030804@samsung.com>
X-Forwarded-Message-Id: <4F72FF13.6030804@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using cm_notify_event function, charger driver can report several
charger events
(e.g. battery full and external power in/out, etc) to Charger-Manager.
Charger-Manager can properly and immediately control chargers
by the reported event.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

v2
- Code clean according to comment of Rafael J. Wysocki
- Use Power management wakeup interface for waking up the system
  from sleep when event is happended
---
 Documentation/power/charger-manager.txt |   16 +++-
 drivers/power/charger-manager.c         |  163
+++++++++++++++++++++++++++++++
 include/linux/power/charger-manager.h   |   24 +++--
 3 files changed, 194 insertions(+), 9 deletions(-)

diff --git a/Documentation/power/charger-manager.txt
b/Documentation/power/charger-manager.txt
index 9b38633..b4f7f4b 100644
--- a/Documentation/power/charger-manager.txt
+++ b/Documentation/power/charger-manager.txt
@@ -50,6 +50,10 @@ Charger Manager supports the following:
 	restarts charging. This check is also performed while suspended by
 	setting wakeup time accordingly and using suspend_again.

+* Support for uevent-notify
+	With the charger-related events, the device sends
+	notification to users with UEVENT.
+
 2. Global Charger-Manager Data related with suspend_again
 ========================================================
 In order to setup Charger Manager with suspend-again feature
@@ -174,7 +178,17 @@ bool measure_battery_temp;
 	the value of measure_battery_temp.
 };

-5. Other Considerations
+5. Notify Charger-Manager of charger events: cm_notify_event()
+=========================================================
+If there is an charger event is required to notify
+Charger Manager, a charger device driver that triggers the event can call
+cm_notify_event(psy, type, msg) to notify the corresponding Charger
Manager.
+In the function, psy is the charger driver's power_supply pointer, which is
+associated with Charger-Manager. The parameter "type"
+is the same as irq's type (enum cm_event_types). The event message "msg" is
+optional and is effective only if the event type is "UNDESCRIBED" or
"OTHERS".
+
+6. Other Considerations
 =======================

 At the charger/battery-related events such as battery-pulled-out,
diff --git a/drivers/power/charger-manager.c
b/drivers/power/charger-manager.c
index f95b9eb..e0bf1b6 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -23,6 +23,16 @@
 #include <linux/power/charger-manager.h>
 #include <linux/regulator/consumer.h>

+static const char * const default_event_names[] = {
+	[CM_EVENT_UNKNOWN] = "Unknown",
+	[CM_EVENT_BATT_FULL] = "Battery Full",
+	[CM_EVENT_BATT_IN] = "Battery Inserted",
+	[CM_EVENT_BATT_OUT] = "Battery Pulled Out",
+	[CM_EVENT_EXT_PWR_IN_OUT] = "External Power Attach/Detach",
+	[CM_EVENT_CHG_START_STOP] = "Charging Start/Stop",
+	[CM_EVENT_OTHERS] = "Other battery events"
+};
+
 /*
  * Regard CM_JIFFIES_SMALL jiffies is small enough to ignore for
  * delayed works so that we can run delayed works with CM_JIFFIES_SMALL
@@ -528,6 +538,69 @@ static void cm_monitor_poller(struct work_struct *work)
 	schedule_work(&setup_polling);
 }

+/**
+ * fullbatt_handler - Event handler for CM_EVENT_BATT_FULL
+ * @cm: the Charger Manager representing the battery.
+ */
+static void fullbatt_handler(struct charger_manager *cm)
+{
+	struct charger_desc *desc = cm->desc;
+
+	if (!desc->fullbatt_vchkdrop_uV || !desc->fullbatt_vchkdrop_ms)
+		goto out;
+
+	if (cm_suspended)
+		device_set_wakeup_capable(cm->dev, true);
+
+	if (delayed_work_pending(&cm->fullbatt_vchk_work))
+		cancel_delayed_work(&cm->fullbatt_vchk_work);
+	queue_delayed_work(cm_wq, &cm->fullbatt_vchk_work,
+			   msecs_to_jiffies(desc->fullbatt_vchkdrop_ms));
+	cm->fullbatt_vchk_jiffies_at = jiffies + msecs_to_jiffies(
+				       desc->fullbatt_vchkdrop_ms);
+
+	if (cm->fullbatt_vchk_jiffies_at == 0)
+		cm->fullbatt_vchk_jiffies_at = 1;
+
+out:
+	dev_info(cm->dev, "EVENT_HANDLE: Battery Fully Charged.\n");
+	uevent_notify(cm, default_event_names[CM_EVENT_BATT_FULL]);
+}
+
+/**
+ * battout_handler - Event handler for CM_EVENT_BATT_OUT
+ * @cm: the Charger Manager representing the battery.
+ */
+static void battout_handler(struct charger_manager *cm)
+{
+	if (cm_suspended)
+		device_set_wakeup_capable(cm->dev, true);
+
+	if (!is_batt_present(cm)) {
+		dev_emerg(cm->dev, "Battery Pulled Out!\n");
+		uevent_notify(cm, default_event_names[CM_EVENT_BATT_OUT]);
+	} else {
+		uevent_notify(cm, "Battery Reinserted?");
+	}
+}
+
+/**
+ * misc_event_handler - Handler for other evnets
+ * @cm: the Charger Manager representing the battery.
+ * @type: the Charger Manager representing the battery.
+ */
+static void misc_event_handler(struct charger_manager *cm,
+			enum cm_event_types type)
+{
+	if (cm_suspended)
+		device_set_wakeup_capable(cm->dev, true);
+
+	if (!delayed_work_pending(&cm_monitor_work) &&
+	    is_polling_required(cm) && cm->desc->polling_interval_ms)
+		schedule_work(&setup_polling);
+	uevent_notify(cm, default_event_names[type]);
+}
+
 static int charger_get_property(struct power_supply *psy,
 		enum power_supply_property psp,
 		union power_supply_propval *val)
@@ -1114,6 +1187,13 @@ static int charger_manager_probe(struct
platform_device *pdev)
 	list_add(&cm->entry, &cm_list);
 	mutex_unlock(&cm_list_mtx);

+	/*
+	 * Charger-manager is capable of waking up the systme from sleep
+	 * when event is happend through cm_notify_event()
+	 */
+	device_init_wakeup(&pdev->dev, true);
+	device_set_wakeup_capable(&pdev->dev, false);
+
 	schedule_work(&setup_polling);

 	return 0;
@@ -1173,6 +1253,18 @@ static const struct platform_device_id
charger_manager_id[] = {
 };
 MODULE_DEVICE_TABLE(platform, charger_manager_id);

+static int cm_suspend_noirq(struct device *dev)
+{
+	int ret = 0;
+
+	if (device_may_wakeup(dev)) {
+		device_set_wakeup_capable(dev, false);
+		ret = -EAGAIN;
+	}
+
+	return ret;
+}
+
 static int cm_suspend_prepare(struct device *dev)
 {
 	struct platform_device *pdev = container_of(dev, struct platform_device,
@@ -1258,11 +1350,13 @@ static void cm_suspend_complete(struct device *dev)
 		queue_delayed_work(cm_wq, &cm->fullbatt_vchk_work,
 				   msecs_to_jiffies(delay));
 	}
+	device_set_wakeup_capable(cm->dev, false);
 	uevent_notify(cm, NULL);
 }

 static const struct dev_pm_ops charger_manager_pm = {
 	.prepare	= cm_suspend_prepare,
+	.suspend_noirq	= cm_suspend_noirq,
 	.complete	= cm_suspend_complete,
 };

@@ -1295,6 +1389,75 @@ static void __exit charger_manager_cleanup(void)
 }
 module_exit(charger_manager_cleanup);

+/**
+ * find_power_supply - find the associated power_supply of charger
+ * @cm: the Charger Manager representing the battery
+ * @psy: pointer to instance of charger's power_supply
+ */
+static bool find_power_supply(struct charger_manager *cm,
+			struct power_supply *psy)
+{
+	int i;
+	bool found = false;
+
+	for (i = 0; cm->charger_stat[i]; i++) {
+		if (psy == cm->charger_stat[i]) {
+			found = true;
+			break;
+		}
+	}
+
+	return found;
+}
+
+/**
+ * cm_notify_event - charger driver notify Charger Manager of charger event
+ * @psy: pointer to instance of charger's power_supply
+ * @type: type of charger event
+ * @msg: optional message passed to uevent_notify fuction
+ */
+void cm_notify_event(struct power_supply *psy, enum cm_event_types type,
+		     char *msg)
+{
+	struct charger_manager *cm;
+	bool found_power_supply = false;
+
+	if (psy == NULL)
+		return;
+
+	mutex_lock(&cm_list_mtx);
+	list_for_each_entry(cm, &cm_list, entry) {
+		found_power_supply = find_power_supply(cm, psy);
+		if (found_power_supply)
+			break;
+	}
+	mutex_unlock(&cm_list_mtx);
+
+	if (!found_power_supply)
+		return;
+
+	switch (type) {
+	case CM_EVENT_BATT_FULL:
+		fullbatt_handler(cm);
+		break;
+	case CM_EVENT_BATT_OUT:
+		battout_handler(cm);
+		break;
+	case CM_EVENT_BATT_IN:
+	case CM_EVENT_EXT_PWR_IN_OUT ... CM_EVENT_CHG_START_STOP:
+		misc_event_handler(cm, type);
+		break;
+	case CM_EVENT_UNKNOWN:
+	case CM_EVENT_OTHERS:
+		uevent_notify(cm, msg ? msg : default_event_names[type]);
+		break;
+	default:
+		dev_err(cm->dev, "%s type not specified.\n", __func__);
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(cm_notify_event);
+
 MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
 MODULE_DESCRIPTION("Charger Manager");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/power/charger-manager.h
b/include/linux/power/charger-manager.h
index baa299a..27c954b 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -31,6 +31,16 @@ enum polling_modes {
 	CM_POLL_CHARGING_ONLY,
 };

+enum cm_event_types {
+	CM_EVENT_UNKNOWN = 0,
+	CM_EVENT_BATT_FULL,
+	CM_EVENT_BATT_IN,
+	CM_EVENT_BATT_OUT,
+	CM_EVENT_EXT_PWR_IN_OUT,
+	CM_EVENT_CHG_START_STOP,
+	CM_EVENT_OTHERS,
+};
+
 /**
  * struct charger_global_desc
  * @rtc_name: the name of RTC used to wake up the system from suspend.
@@ -159,14 +169,12 @@ struct charger_manager {
 #ifdef CONFIG_CHARGER_MANAGER
 extern int setup_charger_manager(struct charger_global_desc *gd);
 extern bool cm_suspend_again(void);
+extern void cm_notify_event(struct power_supply *psy,
+				enum cm_event_types type, char *msg);
 #else
-static void __maybe_unused setup_charger_manager(struct
charger_global_desc *gd)
-{ }
-
-static bool __maybe_unused cm_suspend_again(void)
-{
-	return false;
-}
+static inline int setup_charger_manager(struct charger_global_desc *gd)
{ return 0; }
+static inline bool cm_suspend_again(void) { return false; }
+static inline void cm_notify_event(struct power_supply *psy,
+				enum cm_event_types type, char *msg) { }
 #endif
-
 #endif /* _CHARGER_MANAGER_H */
-- 
1.7.0.4
