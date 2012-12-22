Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2LVB55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:57:57 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:43419 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2LVB5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:57:54 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>,
        Donggeun Kim <dg77.kim@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 01/25] charger_manager: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:56:51 -0800
Message-Id: <1356141435-17340-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests and rewrite _setup_polling() so that
it uses mod_delayed_work() if the next polling interval is sooner than
currently scheduled.  queue_delayed_work() is used otherwise.

Only compile tested.  I noticed that two work items - setup_polling
and cm_monitor_work - schedule each other.  It's a very unusual
construct and I'm fairly sure it's racy.  You can't break such
circular dependency by calling cancel on each.  I strongly recommend
revising the mechanism.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Donggeun Kim <dg77.kim@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/power/charger-manager.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index adb3a4b..9fd9776 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -675,15 +675,21 @@ static void _setup_polling(struct work_struct *work)
 	WARN(cm_wq == NULL, "charger-manager: workqueue not initialized"
 			    ". try it later. %s\n", __func__);
 
+	/*
+	 * Use mod_delayed_work() iff the next polling interval should
+	 * occur before the currently scheduled one.  If @cm_monitor_work
+	 * isn't active, the end result is the same, so no need to worry
+	 * about stale @next_polling.
+	 */
 	_next_polling = jiffies + polling_jiffy;
 
-	if (!delayed_work_pending(&cm_monitor_work) ||
-	    (delayed_work_pending(&cm_monitor_work) &&
-	     time_after(next_polling, _next_polling))) {
-		next_polling = jiffies + polling_jiffy;
+	if (time_before(_next_polling, next_polling)) {
 		mod_delayed_work(cm_wq, &cm_monitor_work, polling_jiffy);
+		next_polling = _next_polling;
+	} else {
+		if (queue_delayed_work(cm_wq, &cm_monitor_work, polling_jiffy))
+			next_polling = _next_polling;
 	}
-
 out:
 	mutex_unlock(&cm_list_mtx);
 }
@@ -757,8 +763,7 @@ static void misc_event_handler(struct charger_manager *cm,
 	if (cm_suspended)
 		device_set_wakeup_capable(cm->dev, true);
 
-	if (!delayed_work_pending(&cm_monitor_work) &&
-	    is_polling_required(cm) && cm->desc->polling_interval_ms)
+	if (is_polling_required(cm) && cm->desc->polling_interval_ms)
 		schedule_work(&setup_polling);
 	uevent_notify(cm, default_event_names[type]);
 }
@@ -1176,8 +1181,7 @@ static int charger_extcon_notifier(struct notifier_block *self,
 	 * when charger cable is attached.
 	 */
 	if (cable->attached && is_polling_required(cable->cm)) {
-		if (work_pending(&setup_polling))
-			cancel_work_sync(&setup_polling);
+		cancel_work_sync(&setup_polling);
 		schedule_work(&setup_polling);
 	}
 
@@ -1667,10 +1671,8 @@ static int charger_manager_remove(struct platform_device *pdev)
 	list_del(&cm->entry);
 	mutex_unlock(&cm_list_mtx);
 
-	if (work_pending(&setup_polling))
-		cancel_work_sync(&setup_polling);
-	if (delayed_work_pending(&cm_monitor_work))
-		cancel_delayed_work_sync(&cm_monitor_work);
+	cancel_work_sync(&setup_polling);
+	cancel_delayed_work_sync(&cm_monitor_work);
 
 	for (i = 0 ; i < desc->num_charger_regulators ; i++) {
 		struct charger_regulator *charger
@@ -1739,8 +1741,7 @@ static int cm_suspend_prepare(struct device *dev)
 		cm_suspended = true;
 	}
 
-	if (delayed_work_pending(&cm->fullbatt_vchk_work))
-		cancel_delayed_work(&cm->fullbatt_vchk_work);
+	cancel_delayed_work(&cm->fullbatt_vchk_work);
 	cm->status_save_ext_pwr_inserted = is_ext_pwr_online(cm);
 	cm->status_save_batt = is_batt_present(cm);
 
-- 
1.8.0.2

