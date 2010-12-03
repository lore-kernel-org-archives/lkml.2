Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab0LCA3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:29:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50178 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758038Ab0LCA3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:29:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/3] PM / Wakeup: Replace pm_check_wakeup_events() with pm_wakeup_pending()
Date: Fri, 3 Dec 2010 01:22:23 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201012030118.30603.rjw@sisk.pl>
In-Reply-To: <201012030118.30603.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012030122.23415.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

To avoid confusion with the meaning and return value of
pm_check_wakeup_events() replace it with pm_wakeup_pending() that
will work the other way around (ie. return true when system-wide
power transition should be aborted).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c   |    2 +-
 drivers/base/power/wakeup.c |   20 ++++++++++----------
 include/linux/suspend.h     |    4 ++--
 kernel/power/hibernate.c    |    4 ++--
 kernel/power/process.c      |    2 +-
 kernel/power/suspend.c      |    2 +-
 6 files changed, 17 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/base/power/wakeup.c
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -542,26 +542,26 @@ static void pm_wakeup_update_hit_counts(
 }
 
 /**
- * pm_check_wakeup_events - Check for new wakeup events.
+ * pm_wakeup_pending - Check if power transition in progress should be aborted.
  *
  * Compare the current number of registered wakeup events with its preserved
- * value from the past to check if new wakeup events have been registered since
- * the old value was stored.  Check if the current number of wakeup events being
- * processed is zero.
+ * value from the past and return true if new wakeup events have been registered
+ * since the old value was stored.  Also return true if the current number of
+ * wakeup events being processed is different from zero.
  */
-bool pm_check_wakeup_events(void)
+bool pm_wakeup_pending(void)
 {
 	unsigned long flags;
-	bool ret = true;
+	bool ret = false;
 
 	spin_lock_irqsave(&events_lock, flags);
 	if (events_check_enabled) {
-		ret = ((unsigned int)atomic_read(&event_count) == saved_count)
-			&& !atomic_read(&events_in_progress);
-		events_check_enabled = ret;
+		ret = ((unsigned int)atomic_read(&event_count) != saved_count)
+			|| atomic_read(&events_in_progress);
+		events_check_enabled = !ret;
 	}
 	spin_unlock_irqrestore(&events_lock, flags);
-	if (!ret)
+	if (ret)
 		pm_wakeup_update_hit_counts();
 	return ret;
 }
Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -301,7 +301,7 @@ extern int unregister_pm_notifier(struct
 /* drivers/base/power/wakeup.c */
 extern bool events_check_enabled;
 
-extern bool pm_check_wakeup_events(void);
+extern bool pm_wakeup_pending(void);
 extern bool pm_get_wakeup_count(unsigned int *count);
 extern bool pm_save_wakeup_count(unsigned int count);
 #else /* !CONFIG_PM_SLEEP */
@@ -318,7 +318,7 @@ static inline int unregister_pm_notifier
 
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
 
-static inline bool pm_check_wakeup_events(void) { return true; }
+static inline bool pm_wakeup_pending(void) { return false; }
 #endif /* !CONFIG_PM_SLEEP */
 
 extern struct mutex pm_mutex;
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -1056,7 +1056,7 @@ static int dpm_prepare(pm_message_t stat
 		if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
 			pm_wakeup_event(dev, 0);
 
-		if (!pm_check_wakeup_events()) {
+		if (pm_wakeup_pending()) {
 			pm_runtime_put_sync(dev);
 			error = -EBUSY;
 		} else {
Index: linux-2.6/kernel/power/hibernate.c
===================================================================
--- linux-2.6.orig/kernel/power/hibernate.c
+++ linux-2.6/kernel/power/hibernate.c
@@ -278,7 +278,7 @@ static int create_image(int platform_mod
 		goto Enable_irqs;
 	}
 
-	if (hibernation_test(TEST_CORE) || !pm_check_wakeup_events())
+	if (hibernation_test(TEST_CORE) || pm_wakeup_pending())
 		goto Power_up;
 
 	in_suspend = 1;
@@ -516,7 +516,7 @@ int hibernation_platform_enter(void)
 
 	local_irq_disable();
 	sysdev_suspend(PMSG_HIBERNATE);
-	if (!pm_check_wakeup_events()) {
+	if (pm_wakeup_pending()) {
 		error = -EAGAIN;
 		goto Power_up;
 	}
Index: linux-2.6/kernel/power/process.c
===================================================================
--- linux-2.6.orig/kernel/power/process.c
+++ linux-2.6/kernel/power/process.c
@@ -85,7 +85,7 @@ static int try_to_freeze_tasks(bool sig_
 		if (!todo || time_after(jiffies, end_time))
 			break;
 
-		if (!pm_check_wakeup_events()) {
+		if (pm_wakeup_pending()) {
 			wakeup = true;
 			break;
 		}
Index: linux-2.6/kernel/power/suspend.c
===================================================================
--- linux-2.6.orig/kernel/power/suspend.c
+++ linux-2.6/kernel/power/suspend.c
@@ -172,7 +172,7 @@ static int suspend_enter(suspend_state_t
 
 	error = sysdev_suspend(PMSG_SUSPEND);
 	if (!error) {
-		if (!suspend_test(TEST_CORE) && pm_check_wakeup_events()) {
+		if (!(suspend_test(TEST_CORE) || pm_wakeup_pending())) {
 			error = suspend_ops->enter(state);
 			events_check_enabled = false;
 		}

