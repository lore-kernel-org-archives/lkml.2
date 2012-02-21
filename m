Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab2BUXf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 18:35:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35786 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab2BUXfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 18:35:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 3/7] PM / Sleep: Change wakeup source statistics to follow Android
Date: Wed, 22 Feb 2012 00:34:22 +0100
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
Message-Id: <201202220034.22590.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Wakeup statistics used by Android are slightly different from what we
have in wakeup sources at the moment and there aren't any known
users of those statistics other than Android, so modify them to make
it easier for Android to switch to wakeup sources.

This removes the struct wakeup_source's hit_cout field, which is very
rough and therefore not very useful, and adds two new fields,
wakeup_count and expire_count.  The first one tracks how many times
the wakeup source is activated with events_check_enabled set (which
roughly corresponds to the situations when a system power transition
to a sleep state is in progress and would be aborted by this wakeup
source if it were the only active one at that time) and the second
one is the number of times the wakeup source has been activated with
a timeout that expired.

Additionally, the last_time field is now updated when the wakeup
source is deactivated too (previously it was only updated during
the wakeup source's activation), which seems to be what Android does
with the analogous counter for wakelocks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/ABI/testing/sysfs-devices-power |   24 ++++++---
 drivers/base/power/sysfs.c                    |   30 ++++++++++--
 drivers/base/power/wakeup.c                   |   64 +++++++++++---------------
 include/linux/pm_wakeup.h                     |   11 ++--
 4 files changed, 77 insertions(+), 52 deletions(-)

Index: linux/include/linux/pm_wakeup.h
===================================================================
--- linux.orig/include/linux/pm_wakeup.h
+++ linux/include/linux/pm_wakeup.h
@@ -33,12 +33,14 @@
  *
  * @total_time: Total time this wakeup source has been active.
  * @max_time: Maximum time this wakeup source has been continuously active.
- * @last_time: Monotonic clock when the wakeup source's was activated last time.
+ * @last_time: Monotonic clock when the wakeup source's was touched last time.
  * @event_count: Number of signaled wakeup events.
  * @active_count: Number of times the wakeup sorce was activated.
  * @relax_count: Number of times the wakeup sorce was deactivated.
- * @hit_count: Number of times the wakeup sorce might abort system suspend.
+ * @expire_count: Number of times the wakeup source's timeout has expired.
+ * @wakeup_count: Number of times the wakeup source might abort suspend.
  * @active: Status of the wakeup source.
+ * @has_timeout: The wakeup source has been activated with a timeout.
  */
 struct wakeup_source {
 	const char 		*name;
@@ -52,8 +54,9 @@ struct wakeup_source {
 	unsigned long		event_count;
 	unsigned long		active_count;
 	unsigned long		relax_count;
-	unsigned long		hit_count;
-	unsigned int		active:1;
+	unsigned long		expire_count;
+	unsigned long		wakeup_count;
+	bool			active:1;
 };
 
 #ifdef CONFIG_PM_SLEEP
Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -21,7 +21,7 @@
  * If set, the suspend/hibernate code will abort transitions to a sleep state
  * if wakeup events are registered during or immediately before the transition.
  */
-bool events_check_enabled;
+bool events_check_enabled __read_mostly;
 
 /*
  * Combined counters of registered wakeup events and wakeup events in progress.
@@ -383,6 +383,21 @@ static void wakeup_source_activate(struc
 }
 
 /**
+ * wakeup_source_report_event - Report wakeup event using the given source.
+ * @ws: Wakeup source to report the event for.
+ */
+static void wakeup_source_report_event(struct wakeup_source *ws)
+{
+	ws->event_count++;
+	/* This is racy, but the counter is approximate anyway. */
+	if (events_check_enabled)
+		ws->wakeup_count++;
+
+	if (!ws->active)
+		wakeup_source_activate(ws);
+}
+
+/**
  * __pm_stay_awake - Notify the PM core of a wakeup event.
  * @ws: Wakeup source object associated with the source of the event.
  *
@@ -397,10 +412,7 @@ void __pm_stay_awake(struct wakeup_sourc
 
 	spin_lock_irqsave(&ws->lock, flags);
 
-	ws->event_count++;
-	if (!ws->active)
-		wakeup_source_activate(ws);
-
+	wakeup_source_report_event(ws);
 	del_timer(&ws->timer);
 	ws->timer_expires = 0;
 
@@ -469,6 +481,7 @@ static void wakeup_source_deactivate(str
 	if (ktime_to_ns(duration) > ktime_to_ns(ws->max_time))
 		ws->max_time = duration;
 
+	ws->last_time = now;
 	del_timer(&ws->timer);
 	ws->timer_expires = 0;
 
@@ -541,8 +554,10 @@ static void pm_wakeup_timer_fn(unsigned
 	spin_lock_irqsave(&ws->lock, flags);
 
 	if (ws->active && ws->timer_expires
-	    && time_after_eq(jiffies, ws->timer_expires))
+	    && time_after_eq(jiffies, ws->timer_expires)) {
 		wakeup_source_deactivate(ws);
+		ws->expire_count++;
+	}
 
 	spin_unlock_irqrestore(&ws->lock, flags);
 }
@@ -569,9 +584,7 @@ void __pm_wakeup_event(struct wakeup_sou
 
 	spin_lock_irqsave(&ws->lock, flags);
 
-	ws->event_count++;
-	if (!ws->active)
-		wakeup_source_activate(ws);
+	wakeup_source_report_event(ws);
 
 	if (!msec) {
 		wakeup_source_deactivate(ws);
@@ -614,24 +627,6 @@ void pm_wakeup_event(struct device *dev,
 EXPORT_SYMBOL_GPL(pm_wakeup_event);
 
 /**
- * pm_wakeup_update_hit_counts - Update hit counts of all active wakeup sources.
- */
-static void pm_wakeup_update_hit_counts(void)
-{
-	unsigned long flags;
-	struct wakeup_source *ws;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(ws, &wakeup_sources, entry) {
-		spin_lock_irqsave(&ws->lock, flags);
-		if (ws->active)
-			ws->hit_count++;
-		spin_unlock_irqrestore(&ws->lock, flags);
-	}
-	rcu_read_unlock();
-}
-
-/**
  * pm_wakeup_pending - Check if power transition in progress should be aborted.
  *
  * Compare the current number of registered wakeup events with its preserved
@@ -653,8 +648,6 @@ bool pm_wakeup_pending(void)
 		events_check_enabled = !ret;
 	}
 	spin_unlock_irqrestore(&events_lock, flags);
-	if (ret)
-		pm_wakeup_update_hit_counts();
 	return ret;
 }
 
@@ -680,7 +673,6 @@ bool pm_get_wakeup_count(unsigned int *c
 		split_counters(&cnt, &inpr);
 		if (inpr == 0 || signal_pending(current))
 			break;
-		pm_wakeup_update_hit_counts();
 
 		schedule();
 	}
@@ -713,8 +705,6 @@ bool pm_save_wakeup_count(unsigned int c
 		events_check_enabled = true;
 	}
 	spin_unlock_irq(&events_lock);
-	if (!events_check_enabled)
-		pm_wakeup_update_hit_counts();
 	return events_check_enabled;
 }
 
@@ -749,9 +739,10 @@ static int print_wakeup_source_stats(str
 		active_time = ktime_set(0, 0);
 	}
 
-	ret = seq_printf(m, "%-12s\t%lu\t\t%lu\t\t%lu\t\t"
+	ret = seq_printf(m, "%-12s\t%lu\t\t%lu\t\t%lu\t\t%lu\t\t"
 			"%lld\t\t%lld\t\t%lld\t\t%lld\n",
-			ws->name, active_count, ws->event_count, ws->hit_count,
+			ws->name, active_count, ws->event_count,
+			ws->wakeup_count, ws->expire_count,
 			ktime_to_ms(active_time), ktime_to_ms(total_time),
 			ktime_to_ms(max_time), ktime_to_ms(ws->last_time));
 
@@ -768,8 +759,9 @@ static int wakeup_sources_stats_show(str
 {
 	struct wakeup_source *ws;
 
-	seq_puts(m, "name\t\tactive_count\tevent_count\thit_count\t"
-		"active_since\ttotal_time\tmax_time\tlast_change\n");
+	seq_puts(m, "name\t\tactive_count\tevent_count\twakeup_count\t"
+		"expire_count\tactive_since\ttotal_time\tmax_time\t"
+		"last_change\n");
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(ws, &wakeup_sources, entry)
Index: linux/drivers/base/power/sysfs.c
===================================================================
--- linux.orig/drivers/base/power/sysfs.c
+++ linux/drivers/base/power/sysfs.c
@@ -288,22 +288,41 @@ static ssize_t wakeup_active_count_show(
 
 static DEVICE_ATTR(wakeup_active_count, 0444, wakeup_active_count_show, NULL);
 
-static ssize_t wakeup_hit_count_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
+static ssize_t wakeup_abort_count_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	unsigned long count = 0;
+	bool enabled = false;
+
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.wakeup) {
+		count = dev->power.wakeup->wakeup_count;
+		enabled = true;
+	}
+	spin_unlock_irq(&dev->power.lock);
+	return enabled ? sprintf(buf, "%lu\n", count) : sprintf(buf, "\n");
+}
+
+static DEVICE_ATTR(wakeup_abort_count, 0444, wakeup_abort_count_show, NULL);
+
+static ssize_t wakeup_expire_count_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
 {
 	unsigned long count = 0;
 	bool enabled = false;
 
 	spin_lock_irq(&dev->power.lock);
 	if (dev->power.wakeup) {
-		count = dev->power.wakeup->hit_count;
+		count = dev->power.wakeup->expire_count;
 		enabled = true;
 	}
 	spin_unlock_irq(&dev->power.lock);
 	return enabled ? sprintf(buf, "%lu\n", count) : sprintf(buf, "\n");
 }
 
-static DEVICE_ATTR(wakeup_hit_count, 0444, wakeup_hit_count_show, NULL);
+static DEVICE_ATTR(wakeup_expire_count, 0444, wakeup_expire_count_show, NULL);
 
 static ssize_t wakeup_active_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -460,7 +479,8 @@ static struct attribute *wakeup_attrs[]
 	&dev_attr_wakeup.attr,
 	&dev_attr_wakeup_count.attr,
 	&dev_attr_wakeup_active_count.attr,
-	&dev_attr_wakeup_hit_count.attr,
+	&dev_attr_wakeup_abort_count.attr,
+	&dev_attr_wakeup_expire_count.attr,
 	&dev_attr_wakeup_active.attr,
 	&dev_attr_wakeup_total_time_ms.attr,
 	&dev_attr_wakeup_max_time_ms.attr,
Index: linux/Documentation/ABI/testing/sysfs-devices-power
===================================================================
--- linux.orig/Documentation/ABI/testing/sysfs-devices-power
+++ linux/Documentation/ABI/testing/sysfs-devices-power
@@ -96,16 +96,26 @@ Description:
 		is read-only.  If the device is not enabled to wake up the
 		system from sleep states, this attribute is not present.
 
-What:		/sys/devices/.../power/wakeup_hit_count
-Date:		September 2010
+What:		/sys/devices/.../power/wakeup_abort_count
+Date:		February 2012
 Contact:	Rafael J. Wysocki <rjw@sisk.pl>
 Description:
-		The /sys/devices/.../wakeup_hit_count attribute contains the
+		The /sys/devices/.../wakeup_abort_count attribute contains the
 		number of times the processing of a wakeup event associated with
-		the device might prevent the system from entering a sleep state.
-		This attribute is read-only.  If the device is not enabled to
-		wake up the system from sleep states, this attribute is not
-		present.
+		the device might have aborted system transition into a sleep
+		state in progress.  This attribute is read-only.  If the device
+		is not enabled to wake up the system from sleep states, this
+		attribute is not present.
+
+What:		/sys/devices/.../power/wakeup_expire_count
+Date:		February 2012
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/devices/.../wakeup_expire_count attribute contains the
+		number of times a wakeup event associated with the device has
+		been reported with a timeout that expired.  This attribute is
+		read-only.  If the device is not enabled to wake up the system
+		from sleep states, this attribute is not present.
 
 What:		/sys/devices/.../power/wakeup_active
 Date:		September 2010

