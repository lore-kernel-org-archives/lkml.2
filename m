Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab2BGBHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 20:07:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40204 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578Ab2BGBGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 20:06:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 7/8] PM / Sleep: Add "prevent autosleep time" statistics to wakeup sources
Date: Tue, 7 Feb 2012 02:06:45 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>,
        Greg KH <greg@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201202070200.55505.rjw@sisk.pl>
In-Reply-To: <201202070200.55505.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202070206.45639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Android uses one wakelock statistics that is only necessary for
opportunistic sleep.  Namely, the prevent_suspend_time field
accumulates the total time the given wakelock has been locked
while "automatic suspend" was enabled.  Add an analogous field,
prevent_sleep_time, to wakeup sources and make it behave in a similar
way.

---
 drivers/base/power/wakeup.c |   61 +++++++++++++++++++++++++++++++++++++++++---
 include/linux/pm_wakeup.h   |    4 ++
 include/linux/suspend.h     |    1 
 kernel/power/autosleep.c    |    2 +
 4 files changed, 64 insertions(+), 4 deletions(-)

Index: linux/include/linux/pm_wakeup.h
===================================================================
--- linux.orig/include/linux/pm_wakeup.h
+++ linux/include/linux/pm_wakeup.h
@@ -34,6 +34,7 @@
  * @total_time: Total time this wakeup source has been active.
  * @max_time: Maximum time this wakeup source has been continuously active.
  * @last_time: Monotonic clock when the wakeup source's was touched last time.
+ * @prevent_sleep_time: Total time this source has been preventing autosleep.
  * @event_count: Number of signaled wakeup events.
  * @active_count: Number of times the wakeup sorce was activated.
  * @relax_count: Number of times the wakeup sorce was deactivated.
@@ -51,6 +52,8 @@ struct wakeup_source {
 	ktime_t total_time;
 	ktime_t max_time;
 	ktime_t last_time;
+	ktime_t start_prevent_time;
+	ktime_t prevent_sleep_time;
 	unsigned long		event_count;
 	unsigned long		active_count;
 	unsigned long		relax_count;
@@ -58,6 +61,7 @@ struct wakeup_source {
 	unsigned long		wakeup_count;
 	bool			active:1;
 	bool			has_timeout:1;
+	bool			autosleep_enabled:1;
 };
 
 #ifdef CONFIG_PM_SLEEP
Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -351,6 +351,8 @@ static void wakeup_source_activate(struc
 	ws->active_count++;
 	ws->timer_expires = jiffies;
 	ws->last_time = ktime_get();
+	if (ws->autosleep_enabled)
+		ws->start_prevent_time = ws->last_time;
 
 	/* Increment the counter of events in progress. */
 	atomic_inc(&combined_event_count);
@@ -407,6 +409,17 @@ void pm_stay_awake(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(pm_stay_awake);
 
+#ifdef CONFIG_PM_AUTOSLEEP
+static void update_prevent_sleep_time(struct wakeup_source *ws, ktime_t now)
+{
+	ktime_t delta = ktime_sub(now, ws->start_prevent_time);
+	ws->prevent_sleep_time = ktime_add(ws->prevent_sleep_time, delta);
+}
+#else
+static inline void update_prevent_sleep_time(struct wakeup_source *ws,
+					     ktime_t now) {}
+#endif
+
 /**
  * wakup_source_deactivate - Mark given wakeup source as inactive.
  * @ws: Wakeup source to handle.
@@ -451,6 +464,9 @@ static void wakeup_source_deactivate(str
 	ws->has_timeout = false;
 	del_timer(&ws->timer);
 
+	if (ws->autosleep_enabled)
+		update_prevent_sleep_time(ws, now);
+
 	/*
 	 * Increment the counter of registered wakeup events and decrement the
 	 * couter of wakeup events in progress simultaneously.
@@ -670,6 +686,34 @@ bool pm_save_wakeup_count(unsigned int c
 	return events_check_enabled;
 }
 
+#ifdef CONFIG_PM_AUTOSLEEP
+/**
+ * pm_wakep_autosleep_enabled - Modify autosleep_enabled for all wakeup sources.
+ * @enabled: Whether to set or to clear the autosleep_enabled flags.
+ */
+void pm_wakep_autosleep_enabled(bool set)
+{
+	struct wakeup_source *ws;
+	ktime_t now = ktime_get();
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ws, &wakeup_sources, entry) {
+		spin_lock_irq(&ws->lock);
+		if (ws->autosleep_enabled != set) {
+			ws->autosleep_enabled = set;
+			if (ws->active) {
+				if (set)
+					ws->start_prevent_time = now;
+				else
+					update_prevent_sleep_time(ws, now);
+			}
+		}
+		spin_unlock_irq(&ws->lock);
+	}
+	rcu_read_unlock();
+}
+#endif /* CONFIG_PM_AUTOSLEEP */
+
 static struct dentry *wakeup_sources_stats_dentry;
 
 /**
@@ -685,28 +729,37 @@ static int print_wakeup_source_stats(str
 	ktime_t max_time;
 	unsigned long active_count;
 	ktime_t active_time;
+	ktime_t prevent_sleep_time;
 	int ret;
 
 	spin_lock_irqsave(&ws->lock, flags);
 
 	total_time = ws->total_time;
 	max_time = ws->max_time;
+	prevent_sleep_time = ws->prevent_sleep_time;
 	active_count = ws->active_count;
 	if (ws->active) {
-		active_time = ktime_sub(ktime_get(), ws->last_time);
+		ktime_t now = ktime_get();
+
+		active_time = ktime_sub(now, ws->last_time);
 		total_time = ktime_add(total_time, active_time);
 		if (active_time.tv64 > max_time.tv64)
 			max_time = active_time;
+
+		if (ws->autosleep_enabled)
+			prevent_sleep_time = ktime_add(prevent_sleep_time,
+				ktime_sub(now, ws->start_prevent_time));
 	} else {
 		active_time = ktime_set(0, 0);
 	}
 
 	ret = seq_printf(m, "%-12s\t%lu\t\t%lu\t\t%lu\t\t%lu\t\t"
-			"%lld\t\t%lld\t\t%lld\t\t%lld\n",
+			"%lld\t\t%lld\t\t%lld\t\t%lld\t\t%lld\n",
 			ws->name, active_count, ws->event_count,
 			ws->wakeup_count, ws->expire_count,
 			ktime_to_ms(active_time), ktime_to_ms(total_time),
-			ktime_to_ms(max_time), ktime_to_ms(ws->last_time));
+			ktime_to_ms(max_time), ktime_to_ms(ws->last_time),
+			ktime_to_ms(prevent_sleep_time));
 
 	spin_unlock_irqrestore(&ws->lock, flags);
 
@@ -723,7 +776,7 @@ static int wakeup_sources_stats_show(str
 
 	seq_puts(m, "name\t\tactive_count\tevent_count\twakeup_count\t"
 		"expire_count\tactive_since\ttotal_time\tmax_time\t"
-		"last_change\n");
+		"last_change\tprevent_suspend_time\n");
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(ws, &wakeup_sources, entry)
Index: linux/include/linux/suspend.h
===================================================================
--- linux.orig/include/linux/suspend.h
+++ linux/include/linux/suspend.h
@@ -374,6 +374,7 @@ extern bool events_check_enabled;
 extern bool pm_wakeup_pending(void);
 extern bool pm_get_wakeup_count(unsigned int *count, bool block);
 extern bool pm_save_wakeup_count(unsigned int count);
+extern void pm_wakep_autosleep_enabled(bool set);
 
 static inline void lock_system_sleep(void)
 {
Index: linux/kernel/power/autosleep.c
===================================================================
--- linux.orig/kernel/power/autosleep.c
+++ linux/kernel/power/autosleep.c
@@ -78,11 +78,13 @@ int pm_autosleep_set_state(suspend_state
 	if (state == PM_SUSPEND_ON && autosleep_state != PM_SUSPEND_ON) {
 		autosleep_state = PM_SUSPEND_ON;
 		__pm_relax(autosleep_ws);
+		pm_wakep_autosleep_enabled(false);
 		mutex_unlock(&autosleep_lock);
 		wait_for_completion(&suspend_completion);
 	} else if (state > PM_SUSPEND_ON) {
 		autosleep_state = state;
 		__pm_relax(autosleep_ws);
+		pm_wakep_autosleep_enabled(true);
 		queue_up_suspend_work();
 		mutex_unlock(&autosleep_lock);
 	}

