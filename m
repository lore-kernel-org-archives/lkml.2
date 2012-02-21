Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab2BUXfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 18:35:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35816 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab2BUXfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 18:35:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 6/7] PM / Sleep: Add "prevent autosleep time" statistics to wakeup sources
Date: Wed, 22 Feb 2012 00:36:27 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <201202070200.55505.rjw@sisk.pl> <201202220031.46219.rjw@sisk.pl>
In-Reply-To: <201202220031.46219.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202220036.27375.rjw@sisk.pl>
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

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/ABI/testing/sysfs-devices-power |   11 ++++
 drivers/base/power/sysfs.c                    |   24 ++++++++++
 drivers/base/power/wakeup.c                   |   61 ++++++++++++++++++++++++--
 include/linux/pm_wakeup.h                     |    4 +
 include/linux/suspend.h                       |    1 
 kernel/power/autosleep.c                      |    2 
 6 files changed, 99 insertions(+), 4 deletions(-)

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
@@ -51,12 +52,15 @@ struct wakeup_source {
 	ktime_t total_time;
 	ktime_t max_time;
 	ktime_t last_time;
+	ktime_t start_prevent_time;
+	ktime_t prevent_sleep_time;
 	unsigned long		event_count;
 	unsigned long		active_count;
 	unsigned long		relax_count;
 	unsigned long		expire_count;
 	unsigned long		wakeup_count;
 	bool			active:1;
+	bool			autosleep_enabled:1;
 };
 
 #ifdef CONFIG_PM_SLEEP
Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -377,6 +377,8 @@ static void wakeup_source_activate(struc
 	ws->active = true;
 	ws->active_count++;
 	ws->last_time = ktime_get();
+	if (ws->autosleep_enabled)
+		ws->start_prevent_time = ws->last_time;
 
 	/* Increment the counter of events in progress. */
 	atomic_inc(&combined_event_count);
@@ -444,6 +446,17 @@ void pm_stay_awake(struct device *dev)
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
@@ -485,6 +498,9 @@ static void wakeup_source_deactivate(str
 	del_timer(&ws->timer);
 	ws->timer_expires = 0;
 
+	if (ws->autosleep_enabled)
+		update_prevent_sleep_time(ws, now);
+
 	/*
 	 * Increment the counter of registered wakeup events and decrement the
 	 * couter of wakeup events in progress simultaneously.
@@ -714,6 +730,34 @@ bool pm_save_wakeup_count(unsigned int c
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
@@ -729,28 +773,37 @@ static int print_wakeup_source_stats(str
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
 
@@ -767,7 +820,7 @@ static int wakeup_sources_stats_show(str
 
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
@@ -358,6 +358,7 @@ extern bool events_check_enabled;
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
@@ -73,8 +73,10 @@ int pm_autosleep_set_state(suspend_state
 	mutex_lock(&autosleep_lock);
 	if (state == PM_SUSPEND_ON && autosleep_state != PM_SUSPEND_ON) {
 		autosleep_state = PM_SUSPEND_ON;
+		pm_wakep_autosleep_enabled(false);
 	} else if (state > PM_SUSPEND_ON) {
 		autosleep_state = state;
+		pm_wakep_autosleep_enabled(true);
 		queue_up_suspend_work();
 	}
 	mutex_unlock(&autosleep_lock);
Index: linux/drivers/base/power/sysfs.c
===================================================================
--- linux.orig/drivers/base/power/sysfs.c
+++ linux/drivers/base/power/sysfs.c
@@ -391,6 +391,27 @@ static ssize_t wakeup_last_time_show(str
 }
 
 static DEVICE_ATTR(wakeup_last_time_ms, 0444, wakeup_last_time_show, NULL);
+
+#ifdef CONFIG_PM_AUTOSLEEP
+static ssize_t wakeup_prevent_sleep_time_show(struct device *dev,
+					      struct device_attribute *attr,
+					      char *buf)
+{
+	s64 msec = 0;
+	bool enabled = false;
+
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.wakeup) {
+		msec = ktime_to_ms(dev->power.wakeup->prevent_sleep_time);
+		enabled = true;
+	}
+	spin_unlock_irq(&dev->power.lock);
+	return enabled ? sprintf(buf, "%lld\n", msec) : sprintf(buf, "\n");
+}
+
+static DEVICE_ATTR(wakeup_prevent_sleep_time_ms, 0444,
+		   wakeup_prevent_sleep_time_show, NULL);
+#endif /* CONFIG_PM_AUTOSLEEP */
 #endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_PM_ADVANCED_DEBUG
@@ -485,6 +506,9 @@ static struct attribute *wakeup_attrs[]
 	&dev_attr_wakeup_total_time_ms.attr,
 	&dev_attr_wakeup_max_time_ms.attr,
 	&dev_attr_wakeup_last_time_ms.attr,
+#ifdef CONFIG_PM_AUTOSLEEP
+	&dev_attr_wakeup_prevent_sleep_time_ms.attr,
+#endif
 #endif
 	NULL,
 };
Index: linux/Documentation/ABI/testing/sysfs-devices-power
===================================================================
--- linux.orig/Documentation/ABI/testing/sysfs-devices-power
+++ linux/Documentation/ABI/testing/sysfs-devices-power
@@ -158,6 +158,17 @@ Description:
 		not enabled to wake up the system from sleep states, this
 		attribute is not present.
 
+What:		/sys/devices/.../power/wakeup_prevent_sleep_time_ms
+Date:		February 2012
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/devices/.../wakeup_prevent_sleep_time_ms attribute
+		contains the total time the device has been preventing
+		opportunistic transitions to sleep states from occuring.
+		This attribute is read-only.  If the device is not enabled to
+		wake up the system from sleep states, this attribute is not
+		present.
+
 What:		/sys/devices/.../power/autosuspend_delay_ms
 Date:		September 2010
 Contact:	Alan Stern <stern@rowland.harvard.edu>

