Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2HUIHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:07:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33826 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab2HUIHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:07:01 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-07-50334193818d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5/5] charger-manager: Support limit of maximum possible
 duration for charging/discharging
Date: Tue, 21 Aug 2012 17:06:57 +0900
Message-id: <1345536417-25948-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jQd3JjsYBBs+28lpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MrrZv7AVvDSqaj19kamBs0+hi5OSQEDCRmHLtFzuELSZx4d56
	ti5GLg4hgemMEhdvPWKCcJYySRw49oMNpIpNQEti/4sbYLaIgJzE67V/wYqYBU4xSjy6eIIZ
	JCEskC0xc9ZFsCIWAVWJi3+usoDYvAKuEh9mtUCtU5BoXXaIfQIj9wJGhlWMoqkFyQXFSem5
	hnrFibnFpXnpesn5uZsYwV58JrWDcWWDxSFGAQ5GJR7eH4uMAoRYE8uKK3MPMUpwMCuJ8Fbr
	GwcI8aYkVlalFuXHF5XmpBYfYpTmYFES5+XvMwwQEkhPLEnNTk0tSC2CyTJxcEo1MC7hZOZ7
	emi7sXz2ycfzHm19xrVzUXvStX1GhaInFqT4dL5J45DY/YjljGjZ9I8K25QtfO768OoW3ZCT
	elE/UVm5x8rvb9Xa/BUdX35X7C5bznyYW+lq/VQelquZRuExNy5Oyrw1a6rYjTdPIkteN53K
	vjB9Xn/aRvnKi9sKpNcpdS/ISLnNJ6HEUpyRaKjFXFScCAByO7Rd3gEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch check maximum possible duration of charging/discharging.

If whole charging duration exceed 'desc->charging_max_duration_ms',
cm stop charging to prevent overcharge/overheat. And if discharging
duration exceed, charger cable is attached, after full-batt,
cm start charging to maintain fully charged state for battery.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/power/charger-manager.c       |   81 ++++++++++++++++++++++++++++++++-
 include/linux/power/charger-manager.h |   15 ++++++
 2 files changed, 95 insertions(+), 1 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 805f79d..96dd879 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -324,6 +324,14 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 	if (enable) {
 		if (cm->emergency_stop)
 			return -EAGAIN;
+
+		/*
+		 * Save start time of charging to limit
+		 * maximum possible charging time.
+		 */
+		cm->charging_start_time = ktime_to_ms(ktime_get());
+		cm->charging_end_time = 0;
+
 		for (i = 0 ; i < desc->num_charger_regulators ; i++) {
 			if (desc->charger_regulators[i].externally_control)
 				continue;
@@ -337,6 +345,13 @@ static int try_charger_enable(struct charger_manager *cm, bool enable)
 			}
 		}
 	} else {
+		/*
+		 * Save end time of charging to maintain fully charged state
+		 * of battery after full-batt.
+		 */
+		cm->charging_start_time = 0;
+		cm->charging_end_time = ktime_to_ms(ktime_get());
+
 		for (i = 0 ; i < desc->num_charger_regulators ; i++) {
 			if (desc->charger_regulators[i].externally_control)
 				continue;
@@ -483,8 +498,55 @@ static void fullbatt_vchk(struct work_struct *work)
 
 	if (diff > desc->fullbatt_vchkdrop_uV) {
 		try_charger_restart(cm);
-		uevent_notify(cm, "Recharge");
+		uevent_notify(cm, "Recharging");
+	}
+}
+
+/**
+ * check_charging_duration - Monitor charging/discharging duration
+ * @cm: the Charger Manager representing the battery.
+ *
+ * If whole charging duration exceed 'charging_max_duration_ms',
+ * cm stop charging to prevent overcharge/overheat. If discharging
+ * duration exceed 'discharging _max_duration_ms', charger cable is
+ * attached, after full-batt, cm start charging to maintain fully
+ * charged state for battery.
+ */
+static int check_charging_duration(struct charger_manager *cm)
+{
+	struct charger_desc *desc = cm->desc;
+	u64 curr = ktime_to_ms(ktime_get());
+	u64 duration;
+	int ret = false;
+
+	if (!desc->charging_max_duration_ms
+		&& !desc->discharging_max_duration_ms)
+		return ret;
+
+	if (cm->charger_enabled) {
+		duration = curr - cm->charging_start_time;
+
+		if (duration > desc->charging_max_duration_ms) {
+			dev_info(cm->dev, "Charging duration exceed %lldms",
+				desc->charging_max_duration_ms);
+			uevent_notify(cm, "Discharging");
+			try_charger_enable(cm, false);
+			ret = true;
+		}
+	} else if (is_ext_pwr_online(cm) && !cm->charger_enabled) {
+		duration = curr - cm->charging_end_time;
+
+		if (duration > desc->charging_max_duration_ms
+				&& is_ext_pwr_online(cm)) {
+			dev_info(cm->dev, "DisCharging duration exceed %lldms",
+				desc->discharging_max_duration_ms);
+			uevent_notify(cm, "Recharing");
+			try_charger_enable(cm, true);
+			ret = true;
+		}
 	}
+
+	return ret;
 }
 
 /**
@@ -520,6 +582,13 @@ static bool _cm_monitor(struct charger_manager *cm)
 		}
 
 	/*
+	 * Check whole charging duration and discharing duration
+	 * after full-batt.
+	 */
+	} else if (!cm->emergency_stop && check_charging_duration(cm)) {
+		dev_dbg(cm->dev,
+			"Charging/Discharging duration is out of range");
+	/*
 	 * Check dropped voltage of battery. If battery voltage is more
 	 * dropped than fullbatt_vchkdrop_uV after fully charged state,
 	 * charger-manager have to recharge battery.
@@ -1369,6 +1438,16 @@ static int charger_manager_probe(struct platform_device *pdev)
 		goto err_chg_stat;
 	}
 
+	if (!desc->charging_max_duration_ms
+		|| !desc->discharging_max_duration_ms) {
+		dev_info(&pdev->dev, "Cannot limit charging duration"
+				" checking mechanism to prevent "
+				" overcharge/overheat and control"
+				" discharging duration");
+		desc->charging_max_duration_ms = 0;
+		desc->discharging_max_duration_ms = 0;
+	}
+
 	platform_set_drvdata(pdev, cm);
 
 	memcpy(&cm->charger_psy, &psy_default, sizeof(psy_default));
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index a5560f9..3cdc47a 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -181,6 +181,13 @@ struct charger_regulator {
  * @measure_battery_temp:
  *	true: measure battery temperature
  *	false: measure ambient temperature
+ * @charging_max_duration_ms: Maximum possible duration for charging
+ *	If whole charging duration exceed 'charging_max_duration_ms',
+ *	cm stop charging.
+ * @discharging_max_duration_ms:
+ *	Maximum possible duration for discharging with charger cable
+ *	after full-batt. If discharging duration exceed 'discharging
+ *	max_duration_ms', cm start charging.
  */
 struct charger_desc {
 	char *psy_name;
@@ -205,6 +212,9 @@ struct charger_desc {
 
 	int (*temperature_out_of_range)(int *mC);
 	bool measure_battery_temp;
+
+	u64 charging_max_duration_ms;
+	u64 discharging_max_duration_ms;
 };
 
 #define PSY_NAME_MAX	30
@@ -229,6 +239,8 @@ struct charger_desc {
  *	saved status of external power before entering suspend-to-RAM
  * @status_save_batt:
  *	saved status of battery before entering suspend-to-RAM
+ * @charging_start_time: saved start time of enabling charging
+ * @charging_end_time: saved end time of disabling charging
  */
 struct charger_manager {
 	struct list_head entry;
@@ -251,6 +263,9 @@ struct charger_manager {
 
 	bool status_save_ext_pwr_inserted;
 	bool status_save_batt;
+
+	u64 charging_start_time;
+	u64 charging_end_time;
 };
 
 #ifdef CONFIG_CHARGER_MANAGER
-- 
1.7.0.4

