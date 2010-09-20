Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab0ITSCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:02:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51131 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094Ab0ITSCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:02:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/2] PM / Wakeup: Introduce wakeup source objects and event statistics (v3)
Date: Mon, 20 Sep 2010 19:59:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <201009201957.40995.rjw@sisk.pl>
In-Reply-To: <201009201957.40995.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009201959.10070.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Wakeup: Introduce wakeup source objects and event statistics (v3)

Introduce struct wakeup_source for representing system wakeup sources
within the kernel and for collecting statistics related to them.
Make the recently introduced helper functions pm_wakeup_event(),
pm_stay_awake() and pm_relax() use struct wakeup_source objects
internally, so that wakeup statistics associated with wakeup devices
can be collected and reported in a consistent way (the definition of
pm_relax() is changed, which is harmless, because this function is
not called directly by anyone yet).  Introduce new wakeup-related
sysfs device attributes in /sys/devices/.../power for reporting the
device wakeup statistics.

Change the global wakeup events counters event_count and
events_in_progress into atomic variables, so that it is not necessary
to acquire a global spinlock in pm_wakeup_event(), pm_stay_awake()
and pm_relax(), which should allow us to avoid lock contention in
these functions on SMP systems with many wakeup devices.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Changes since v2:

* Use smp_mb__before_atomic_dec() instead of wmb() in
  wakeup_source_deactivate().

* Fix some copy-paste mistakes in sysfs-devices-power.

---
 Documentation/ABI/testing/sysfs-devices-power |   70 +++
 drivers/base/power/main.c                     |    4 
 drivers/base/power/power.h                    |    1 
 drivers/base/power/runtime.c                  |    2 
 drivers/base/power/sysfs.c                    |  121 +++++
 drivers/base/power/wakeup.c                   |  534 ++++++++++++++++++++++----
 include/linux/pm.h                            |   16 
 include/linux/pm_wakeup.h                     |  126 ++++--
 include/linux/suspend.h                       |    4 
 kernel/power/main.c                           |    8 
 10 files changed, 757 insertions(+), 129 deletions(-)

Index: linux-2.6/include/linux/pm_wakeup.h
===================================================================
--- linux-2.6.orig/include/linux/pm_wakeup.h
+++ linux-2.6/include/linux/pm_wakeup.h
@@ -2,6 +2,7 @@
  *  pm_wakeup.h - Power management wakeup interface
  *
  *  Copyright (C) 2008 Alan Stern
+ *  Copyright (C) 2010 Rafael J. Wysocki, Novell Inc.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -27,18 +28,39 @@
 
 #include <linux/types.h>
 
-#ifdef CONFIG_PM
-
-/* Changes to device_may_wakeup take effect on the next pm state change.
+/**
+ * struct wakeup_source - Representation of wakeup sources
  *
- * By default, most devices should leave wakeup disabled.  The exceptions
- * are devices that everyone expects to be wakeup sources: keyboards,
- * power buttons, possibly network interfaces, etc.
+ * @total_time: Total time this wakeup source has been active.
+ * @max_time: Maximum time this wakeup source has been continuously active.
+ * @last_time: Monotonic clock when the wakeup source's was activated last time.
+ * @event_count: Number of signaled wakeup events.
+ * @active_count: Number of times the wakeup sorce was activated.
+ * @relax_count: Number of times the wakeup sorce was deactivated.
+ * @hit_count: Number of times the wakeup sorce might abort system suspend.
+ * @active: Status of the wakeup source.
+ */
+struct wakeup_source {
+	char 			*name;
+	struct list_head	entry;
+	spinlock_t		lock;
+	struct timer_list	timer;
+	unsigned long		timer_expires;
+	ktime_t total_time;
+	ktime_t max_time;
+	ktime_t last_time;
+	unsigned long		event_count;
+	unsigned long		active_count;
+	unsigned long		relax_count;
+	unsigned long		hit_count;
+	unsigned int		active:1;
+};
+
+#ifdef CONFIG_PM_SLEEP
+
+/*
+ * Changes to device_may_wakeup take effect on the next pm state change.
  */
-static inline void device_init_wakeup(struct device *dev, bool val)
-{
-	dev->power.can_wakeup = dev->power.should_wakeup = val;
-}
 
 static inline void device_set_wakeup_capable(struct device *dev, bool capable)
 {
@@ -50,23 +72,32 @@ static inline bool device_can_wakeup(str
 	return dev->power.can_wakeup;
 }
 
-static inline void device_set_wakeup_enable(struct device *dev, bool enable)
-{
-	dev->power.should_wakeup = enable;
-}
+
 
 static inline bool device_may_wakeup(struct device *dev)
 {
-	return dev->power.can_wakeup && dev->power.should_wakeup;
+	return dev->power.can_wakeup && !!dev->power.wakeup;
 }
 
-#else /* !CONFIG_PM */
+/* drivers/base/power/wakeup.c */
+extern struct wakeup_source *wakeup_source_create(const char *name);
+extern void wakeup_source_destroy(struct wakeup_source *ws);
+extern void wakeup_source_add(struct wakeup_source *ws);
+extern void wakeup_source_remove(struct wakeup_source *ws);
+extern struct wakeup_source *wakeup_source_register(const char *name);
+extern void wakeup_source_unregister(struct wakeup_source *ws);
+extern int device_wakeup_enable(struct device *dev);
+extern int device_wakeup_disable(struct device *dev);
+extern int device_init_wakeup(struct device *dev, bool val);
+extern int device_set_wakeup_enable(struct device *dev, bool enable);
+extern void __pm_stay_awake(struct wakeup_source *ws);
+extern void pm_stay_awake(struct device *dev);
+extern void __pm_relax(struct wakeup_source *ws);
+extern void pm_relax(struct device *dev);
+extern void __pm_wakeup_event(struct wakeup_source *ws, unsigned int msec);
+extern void pm_wakeup_event(struct device *dev, unsigned int msec);
 
-/* For some reason the following routines work even without CONFIG_PM */
-static inline void device_init_wakeup(struct device *dev, bool val)
-{
-	dev->power.can_wakeup = val;
-}
+#else /* !CONFIG_PM_SLEEP */
 
 static inline void device_set_wakeup_capable(struct device *dev, bool capable)
 {
@@ -78,15 +109,60 @@ static inline bool device_can_wakeup(str
 	return dev->power.can_wakeup;
 }
 
-static inline void device_set_wakeup_enable(struct device *dev, bool enable)
+static inline bool device_may_wakeup(struct device *dev)
 {
+	return false;
 }
 
-static inline bool device_may_wakeup(struct device *dev)
+static inline struct wakeup_source *wakeup_source_create(const char *name)
 {
-	return false;
+	return NULL;
 }
 
-#endif /* !CONFIG_PM */
+static inline void wakeup_source_destroy(struct wakeup_source *ws) {}
+
+static inline void wakeup_source_add(struct wakeup_source *ws) {}
+
+static inline void wakeup_source_remove(struct wakeup_source *ws) {}
+
+static inline struct wakeup_source *wakeup_source_register(const char *name)
+{
+	return NULL;
+}
+
+static inline void wakeup_source_unregister(struct wakeup_source *ws) {}
+
+static inline int device_wakeup_enable(struct device *dev)
+{
+	return -EINVAL;
+}
+
+static inline int device_wakeup_disable(struct device *dev) {}
+
+static inline int device_init_wakeup(struct device *dev, bool val)
+{
+	dev->power.can_wakeup = val;
+	return val ? -EINVAL : 0;
+}
+
+
+static inline int device_set_wakeup_enable(struct device *dev, bool enable)
+{
+	return -EINVAL;
+}
+
+static inline void __pm_stay_awake(struct wakeup_source *ws) {}
+
+static inline void pm_stay_awake(struct device *dev) {}
+
+static inline void __pm_relax(struct wakeup_source *ws) {}
+
+static inline void pm_relax(struct device *dev) {}
+
+static inline void __pm_wakeup_event(struct wakeup_source *ws, unsigned int msec) {}
+
+static inline void pm_wakeup_event(struct device *dev, unsigned int msec) {}
+
+#endif /* !CONFIG_PM_SLEEP */
 
 #endif /* _LINUX_PM_WAKEUP_H */
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -448,23 +448,24 @@ enum rpm_request {
 	RPM_REQ_RESUME,
 };
 
+struct wakeup_source;
+
 struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned int		can_wakeup:1;
-	unsigned int		should_wakeup:1;
 	unsigned		async_suspend:1;
 	enum dpm_state		status;		/* Owned by the PM core */
+	spinlock_t		lock;
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;
 	struct completion	completion;
-	unsigned long		wakeup_count;
+	struct wakeup_source	*wakeup;
 #endif
 #ifdef CONFIG_PM_RUNTIME
 	struct timer_list	suspend_timer;
 	unsigned long		timer_expires;
 	struct work_struct	work;
 	wait_queue_head_t	wait_queue;
-	spinlock_t		lock;
 	atomic_t		usage_count;
 	atomic_t		child_count;
 	unsigned int		disable_depth:3;
@@ -559,11 +560,6 @@ extern void __suspend_report_result(cons
 	} while (0)
 
 extern void device_pm_wait_for_dev(struct device *sub, struct device *dev);
-
-/* drivers/base/power/wakeup.c */
-extern void pm_wakeup_event(struct device *dev, unsigned int msec);
-extern void pm_stay_awake(struct device *dev);
-extern void pm_relax(void);
 #else /* !CONFIG_PM_SLEEP */
 
 #define device_pm_lock() do {} while (0)
@@ -577,10 +573,6 @@ static inline int dpm_suspend_start(pm_m
 #define suspend_report_result(fn, ret)		do {} while (0)
 
 static inline void device_pm_wait_for_dev(struct device *a, struct device *b) {}
-
-static inline void pm_wakeup_event(struct device *dev, unsigned int msec) {}
-static inline void pm_stay_awake(struct device *dev) {}
-static inline void pm_relax(void) {}
 #endif /* !CONFIG_PM_SLEEP */
 
 /* How to reorder dpm_list after device_move() */
Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/base/power/wakeup.c
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -11,7 +11,10 @@
 #include <linux/sched.h>
 #include <linux/capability.h>
 #include <linux/suspend.h>
-#include <linux/pm.h>
+
+#include "power.h"
+
+#define TIMEOUT		100
 
 /*
  * If set, the suspend/hibernate code will abort transitions to a sleep state
@@ -20,18 +23,244 @@
 bool events_check_enabled;
 
 /* The counter of registered wakeup events. */
-static unsigned long event_count;
+static atomic_t event_count = ATOMIC_INIT(0);
 /* A preserved old value of event_count. */
-static unsigned long saved_event_count;
+static unsigned int saved_count;
 /* The counter of wakeup events being processed. */
-static unsigned long events_in_progress;
+static atomic_t events_in_progress = ATOMIC_INIT(0);
 
 static DEFINE_SPINLOCK(events_lock);
 
 static void pm_wakeup_timer_fn(unsigned long data);
 
-static DEFINE_TIMER(events_timer, pm_wakeup_timer_fn, 0, 0);
-static unsigned long events_timer_expires;
+static LIST_HEAD(wakeup_sources);
+
+/**
+ * wakeup_source_create - Create a struct wakeup_source object.
+ * @name: Name of the new wakeup source.
+ */
+struct wakeup_source *wakeup_source_create(const char *name)
+{
+	struct wakeup_source *ws;
+
+	ws = kzalloc(sizeof(*ws), GFP_KERNEL);
+	if (!ws)
+		return NULL;
+
+	spin_lock_init(&ws->lock);
+	if (name)
+		ws->name = kstrdup(name, GFP_KERNEL);
+
+	return ws;
+}
+EXPORT_SYMBOL_GPL(wakeup_source_create);
+
+/**
+ * wakeup_source_destroy - Destroy a struct wakeup_source object.
+ * @ws: Wakeup source to destroy.
+ */
+void wakeup_source_destroy(struct wakeup_source *ws)
+{
+	if (!ws)
+		return;
+
+	spin_lock_irq(&ws->lock);
+	while (ws->active) {
+		spin_unlock_irq(&ws->lock);
+
+		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
+
+		spin_lock_irq(&ws->lock);
+	}
+	spin_unlock_irq(&ws->lock);
+
+	kfree(ws->name);
+	kfree(ws);
+}
+EXPORT_SYMBOL_GPL(wakeup_source_destroy);
+
+/**
+ * wakeup_source_add - Add given object to the list of wakeup sources.
+ * @ws: Wakeup source object to add to the list.
+ */
+void wakeup_source_add(struct wakeup_source *ws)
+{
+	if (WARN_ON(!ws))
+		return;
+
+	setup_timer(&ws->timer, pm_wakeup_timer_fn, (unsigned long)ws);
+	ws->active = false;
+
+	spin_lock_irq(&events_lock);
+	list_add_rcu(&ws->entry, &wakeup_sources);
+	spin_unlock_irq(&events_lock);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(wakeup_source_add);
+
+/**
+ * wakeup_source_remove - Remove given object from the wakeup sources list.
+ * @ws: Wakeup source object to remove from the list.
+ */
+void wakeup_source_remove(struct wakeup_source *ws)
+{
+	if (WARN_ON(!ws))
+		return;
+
+	spin_lock_irq(&events_lock);
+	list_del_rcu(&ws->entry);
+	spin_unlock_irq(&events_lock);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(wakeup_source_remove);
+
+/**
+ * wakeup_source_register - Create wakeup source and add it to the list.
+ * @name: Name of the wakeup source to register.
+ */
+struct wakeup_source *wakeup_source_register(const char *name)
+{
+	struct wakeup_source *ws;
+
+	ws = wakeup_source_create(name);
+	if (ws)
+		wakeup_source_add(ws);
+
+	return ws;
+}
+EXPORT_SYMBOL_GPL(wakeup_source_register);
+
+/**
+ * wakeup_source_unregister - Remove wakeup source from the list and remove it.
+ * @ws: Wakeup source object to unregister.
+ */
+void wakeup_source_unregister(struct wakeup_source *ws)
+{
+	wakeup_source_remove(ws);
+	wakeup_source_destroy(ws);
+}
+EXPORT_SYMBOL_GPL(wakeup_source_unregister);
+
+/**
+ * device_wakeup_attach - Attach a wakeup source object to a device object.
+ * @dev: Device to handle.
+ * @ws: Wakeup source object to attach to @dev.
+ *
+ * This causes @dev to be treated as a wakeup device.
+ */
+static int device_wakeup_attach(struct device *dev, struct wakeup_source *ws)
+{
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.wakeup) {
+		spin_unlock_irq(&dev->power.lock);
+		return -EEXIST;
+	}
+	dev->power.wakeup = ws;
+	spin_unlock_irq(&dev->power.lock);
+	return 0;
+}
+
+/**
+ * device_wakeup_enable - Enable given device to be a wakeup source.
+ * @dev: Device to handle.
+ *
+ * Create a wakeup source object, register it and attach it to @dev.
+ */
+int device_wakeup_enable(struct device *dev)
+{
+	struct wakeup_source *ws;
+	int ret;
+
+	if (!dev || !dev->power.can_wakeup)
+		return -EINVAL;
+
+	ws = wakeup_source_register(dev_name(dev));
+	if (!ws)
+		return -ENOMEM;
+
+	ret = device_wakeup_attach(dev, ws);
+	if (ret)
+		wakeup_source_unregister(ws);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(device_wakeup_enable);
+
+/**
+ * device_wakeup_detach - Detach a device's wakeup source object from it.
+ * @dev: Device to detach the wakeup source object from.
+ *
+ * After it returns, @dev will not be treated as a wakeup device any more.
+ */
+static struct wakeup_source *device_wakeup_detach(struct device *dev)
+{
+	struct wakeup_source *ws;
+
+	spin_lock_irq(&dev->power.lock);
+	ws = dev->power.wakeup;
+	dev->power.wakeup = NULL;
+	spin_unlock_irq(&dev->power.lock);
+	return ws;
+}
+
+/**
+ * device_wakeup_disable - Do not regard a device as a wakeup source any more.
+ * @dev: Device to handle.
+ *
+ * Detach the @dev's wakeup source object from it, unregister this wakeup source
+ * object and destroy it.
+ */
+int device_wakeup_disable(struct device *dev)
+{
+	struct wakeup_source *ws;
+
+	if (!dev || !dev->power.can_wakeup)
+		return -EINVAL;
+
+	ws = device_wakeup_detach(dev);
+	if (ws)
+		wakeup_source_unregister(ws);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(device_wakeup_disable);
+
+/**
+ * device_init_wakeup - Device wakeup initialization.
+ * @dev: Device to handle.
+ * @enable: Whether or not to enable @dev as a wakeup device.
+ *
+ * By default, most devices should leave wakeup disabled.  The exceptions are
+ * devices that everyone expects to be wakeup sources: keyboards, power buttons,
+ * possibly network interfaces, etc.
+ */
+int device_init_wakeup(struct device *dev, bool enable)
+{
+	int ret = 0;
+
+	if (enable) {
+		device_set_wakeup_capable(dev, true);
+		ret = device_wakeup_enable(dev);
+	} else {
+		device_set_wakeup_capable(dev, false);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(device_init_wakeup);
+
+/**
+ * device_set_wakeup_enable - Enable or disable a device to wake up the system.
+ * @dev: Device to handle.
+ */
+int device_set_wakeup_enable(struct device *dev, bool enable)
+{
+	if (!dev || !dev->power.can_wakeup)
+		return -EINVAL;
+
+	return enable ? device_wakeup_enable(dev) : device_wakeup_disable(dev);
+}
+EXPORT_SYMBOL_GPL(device_set_wakeup_enable);
 
 /*
  * The functions below use the observation that each wakeup event starts a
@@ -55,118 +284,259 @@ static unsigned long events_timer_expire
  * knowledge, however, may not be available to it, so it can simply specify time
  * to wait before the system can be suspended and pass it as the second
  * argument of pm_wakeup_event().
+ *
+ * It is valid to call pm_relax() after pm_wakeup_event(), in which case the
+ * "no suspend" period will be ended either by the pm_relax(), or by the timer
+ * function executed when the timer expires, whichever comes first.
  */
 
 /**
+ * wakup_source_activate - Mark given wakeup source as active.
+ * @ws: Wakeup source to handle.
+ *
+ * Update the @ws' statistics and, if @ws has just been activated, notify the PM
+ * core of the event by incrementing the counter of of wakeup events being
+ * processed.
+ */
+static void wakeup_source_activate(struct wakeup_source *ws)
+{
+	ws->active = true;
+	ws->active_count++;
+	ws->timer_expires = jiffies;
+	ws->last_time = ktime_get();
+
+	atomic_inc(&events_in_progress);
+}
+
+/**
+ * __pm_stay_awake - Notify the PM core of a wakeup event.
+ * @ws: Wakeup source object associated with the source of the event.
+ *
+ * It is safe to call this function from interrupt context.
+ */
+void __pm_stay_awake(struct wakeup_source *ws)
+{
+	unsigned long flags;
+
+	if (!ws)
+		return;
+
+	spin_lock_irqsave(&ws->lock, flags);
+	ws->event_count++;
+	if (!ws->active)
+		wakeup_source_activate(ws);
+	spin_unlock_irqrestore(&ws->lock, flags);
+}
+EXPORT_SYMBOL_GPL(__pm_stay_awake);
+
+/**
  * pm_stay_awake - Notify the PM core that a wakeup event is being processed.
  * @dev: Device the wakeup event is related to.
  *
- * Notify the PM core of a wakeup event (signaled by @dev) by incrementing the
- * counter of wakeup events being processed.  If @dev is not NULL, the counter
- * of wakeup events related to @dev is incremented too.
+ * Notify the PM core of a wakeup event (signaled by @dev) by calling
+ * __pm_stay_awake for the @dev's wakeup source object.
  *
  * Call this function after detecting of a wakeup event if pm_relax() is going
  * to be called directly after processing the event (and possibly passing it to
  * user space for further processing).
- *
- * It is safe to call this function from interrupt context.
  */
 void pm_stay_awake(struct device *dev)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&events_lock, flags);
-	if (dev)
-		dev->power.wakeup_count++;
+	if (!dev)
+		return;
 
-	events_in_progress++;
-	spin_unlock_irqrestore(&events_lock, flags);
+	spin_lock_irqsave(&dev->power.lock, flags);
+	__pm_stay_awake(dev->power.wakeup);
+	spin_unlock_irqrestore(&dev->power.lock, flags);
 }
+EXPORT_SYMBOL_GPL(pm_stay_awake);
 
 /**
- * pm_relax - Notify the PM core that processing of a wakeup event has ended.
+ * wakup_source_deactivate - Mark given wakeup source as inactive.
+ * @ws: Wakeup source to handle.
  *
- * Notify the PM core that a wakeup event has been processed by decrementing
- * the counter of wakeup events being processed and incrementing the counter
- * of registered wakeup events.
+ * Update the @ws' statistics and notify the PM core that the wakeup source has
+ * become inactive by decrementing the counter of wakeup events being processed
+ * and incrementing the counter of registered wakeup events.
+ */
+static void wakeup_source_deactivate(struct wakeup_source *ws)
+{
+	ktime_t duration;
+	ktime_t now;
+
+	ws->relax_count++;
+	/*
+	 * __pm_relax() may be called directly or from a timer function.
+	 * If it is called directly right after the timer function has been
+	 * started, but before the timer function calls __pm_relax(), it is
+	 * possible that __pm_stay_awake() will be called in the meantime and
+	 * will set ws->active.  Then, ws->active may be cleared immediately
+	 * by the __pm_relax() called from the timer function, but in such a
+	 * case ws->relax_count will be different from ws->active_count.
+	 */
+	if (ws->relax_count != ws->active_count) {
+		ws->relax_count--;
+		return;
+	}
+
+	ws->active = false;
+
+	now = ktime_get();
+	duration = ktime_sub(now, ws->last_time);
+	ws->total_time = ktime_add(ws->total_time, duration);
+	if (ktime_to_ns(duration) > ktime_to_ns(ws->max_time))
+		ws->max_time = duration;
+
+	del_timer(&ws->timer);
+
+	/*
+	 * event_count has to be incremented before events_in_progress is
+	 * modified, so that the callers of pm_check_wakeup_events() and
+	 * pm_save_wakeup_count() don't see the old value of event_count and
+	 * events_in_progress equal to zero at the same time.
+	 */
+	atomic_inc(&event_count);
+	smp_mb__before_atomic_dec();
+	atomic_dec(&events_in_progress);
+}
+
+/**
+ * __pm_relax - Notify the PM core that processing of a wakeup event has ended.
+ * @ws: Wakeup source object associated with the source of the event.
  *
  * Call this function for wakeup events whose processing started with calling
- * pm_stay_awake().
+ * __pm_stay_awake().
  *
  * It is safe to call it from interrupt context.
  */
-void pm_relax(void)
+void __pm_relax(struct wakeup_source *ws)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&events_lock, flags);
-	if (events_in_progress) {
-		events_in_progress--;
-		event_count++;
-	}
-	spin_unlock_irqrestore(&events_lock, flags);
+	if (!ws)
+		return;
+
+	spin_lock_irqsave(&ws->lock, flags);
+	if (ws->active)
+		wakeup_source_deactivate(ws);
+	spin_unlock_irqrestore(&ws->lock, flags);
 }
+EXPORT_SYMBOL_GPL(__pm_relax);
+
+/**
+ * pm_relax - Notify the PM core that processing of a wakeup event has ended.
+ * @dev: Device that signaled the event.
+ *
+ * Execute __pm_relax() for the @dev's wakeup source object.
+ */
+void pm_relax(struct device *dev)
+{
+	unsigned long flags;
+
+	if (!dev)
+		return;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+	__pm_relax(dev->power.wakeup);
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_relax);
 
 /**
  * pm_wakeup_timer_fn - Delayed finalization of a wakeup event.
+ * @data: Address of the wakeup source object associated with the event source.
  *
- * Decrease the counter of wakeup events being processed after it was increased
- * by pm_wakeup_event().
+ * Call __pm_relax() for the wakeup source whose address is stored in @data.
  */
 static void pm_wakeup_timer_fn(unsigned long data)
 {
+	__pm_relax((struct wakeup_source *)data);
+}
+
+/**
+ * __pm_wakeup_event - Notify the PM core of a wakeup event.
+ * @ws: Wakeup source object associated with the event source.
+ * @msec: Anticipated event processing time (in milliseconds).
+ *
+ * Notify the PM core of a wakeup event whose source is @ws that will take
+ * approximately @msec milliseconds to be processed by the kernel.  If @ws is
+ * not active, activate it.  If @msec is nonzero, set up the @ws' timer to
+ * execute pm_wakeup_timer_fn() in future.
+ *
+ * It is safe to call this function from interrupt context.
+ */
+void __pm_wakeup_event(struct wakeup_source *ws, unsigned int msec)
+{
 	unsigned long flags;
+	unsigned long expires;
 
-	spin_lock_irqsave(&events_lock, flags);
-	if (events_timer_expires
-	    && time_before_eq(events_timer_expires, jiffies)) {
-		events_in_progress--;
-		events_timer_expires = 0;
+	if (!ws)
+		return;
+
+	spin_lock_irqsave(&ws->lock, flags);
+
+	ws->event_count++;
+	if (!ws->active)
+		wakeup_source_activate(ws);
+
+	if (!msec) {
+		wakeup_source_deactivate(ws);
+		goto unlock;
 	}
-	spin_unlock_irqrestore(&events_lock, flags);
+
+	expires = jiffies + msecs_to_jiffies(msec);
+	if (!expires)
+		expires = 1;
+
+	if (time_after(expires, ws->timer_expires)) {
+		mod_timer(&ws->timer, expires);
+		ws->timer_expires = expires;
+	}
+
+ unlock:
+	spin_unlock_irqrestore(&ws->lock, flags);
 }
+EXPORT_SYMBOL_GPL(__pm_wakeup_event);
+
 
 /**
  * pm_wakeup_event - Notify the PM core of a wakeup event.
  * @dev: Device the wakeup event is related to.
  * @msec: Anticipated event processing time (in milliseconds).
  *
- * Notify the PM core of a wakeup event (signaled by @dev) that will take
- * approximately @msec milliseconds to be processed by the kernel.  Increment
- * the counter of registered wakeup events and (if @msec is nonzero) set up
- * the wakeup events timer to execute pm_wakeup_timer_fn() in future (if the
- * timer has not been set up already, increment the counter of wakeup events
- * being processed).  If @dev is not NULL, the counter of wakeup events related
- * to @dev is incremented too.
- *
- * It is safe to call this function from interrupt context.
+ * Call __pm_wakeup_event() for the @dev's wakeup source object.
  */
 void pm_wakeup_event(struct device *dev, unsigned int msec)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&events_lock, flags);
-	event_count++;
-	if (dev)
-		dev->power.wakeup_count++;
-
-	if (msec) {
-		unsigned long expires;
-
-		expires = jiffies + msecs_to_jiffies(msec);
-		if (!expires)
-			expires = 1;
-
-		if (!events_timer_expires
-		    || time_after(expires, events_timer_expires)) {
-			if (!events_timer_expires)
-				events_in_progress++;
-
-			mod_timer(&events_timer, expires);
-			events_timer_expires = expires;
-		}
+	if (!dev)
+		return;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+	__pm_wakeup_event(dev->power.wakeup, msec);
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
+EXPORT_SYMBOL_GPL(pm_wakeup_event);
+
+/**
+ * pm_wakeup_update_hit_counts - Update hit counts of all active wakeup sources.
+ */
+static void pm_wakeup_update_hit_counts(void)
+{
+	unsigned long flags;
+	struct wakeup_source *ws;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ws, &wakeup_sources, entry) {
+		spin_lock_irqsave(&ws->lock, flags);
+		if (ws->active)
+			ws->hit_count++;
+		spin_unlock_irqrestore(&ws->lock, flags);
 	}
-	spin_unlock_irqrestore(&events_lock, flags);
+	rcu_read_unlock();
 }
 
 /**
@@ -184,10 +554,13 @@ bool pm_check_wakeup_events(void)
 
 	spin_lock_irqsave(&events_lock, flags);
 	if (events_check_enabled) {
-		ret = (event_count == saved_event_count) && !events_in_progress;
+		ret = ((unsigned int)atomic_read(&event_count) == saved_count)
+			&& !atomic_read(&events_in_progress);
 		events_check_enabled = ret;
 	}
 	spin_unlock_irqrestore(&events_lock, flags);
+	if (!ret)
+		pm_wakeup_update_hit_counts();
 	return ret;
 }
 
@@ -202,24 +575,20 @@ bool pm_check_wakeup_events(void)
  * drop down to zero has been interrupted by a signal (and the current number
  * of wakeup events being processed is still nonzero).  Otherwise return true.
  */
-bool pm_get_wakeup_count(unsigned long *count)
+bool pm_get_wakeup_count(unsigned int *count)
 {
 	bool ret;
 
-	spin_lock_irq(&events_lock);
 	if (capable(CAP_SYS_ADMIN))
 		events_check_enabled = false;
 
-	while (events_in_progress && !signal_pending(current)) {
-		spin_unlock_irq(&events_lock);
-
-		schedule_timeout_interruptible(msecs_to_jiffies(100));
-
-		spin_lock_irq(&events_lock);
+	while (atomic_read(&events_in_progress) && !signal_pending(current)) {
+		pm_wakeup_update_hit_counts();
+		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
 	}
-	*count = event_count;
-	ret = !events_in_progress;
-	spin_unlock_irq(&events_lock);
+
+	ret = !atomic_read(&events_in_progress);
+	*count = atomic_read(&event_count);
 	return ret;
 }
 
@@ -232,16 +601,19 @@ bool pm_get_wakeup_count(unsigned long *
  * old number of registered wakeup events to be used by pm_check_wakeup_events()
  * and return true.  Otherwise return false.
  */
-bool pm_save_wakeup_count(unsigned long count)
+bool pm_save_wakeup_count(unsigned int count)
 {
 	bool ret = false;
 
 	spin_lock_irq(&events_lock);
-	if (count == event_count && !events_in_progress) {
-		saved_event_count = count;
+	if (count == (unsigned int)atomic_read(&event_count)
+	    && !atomic_read(&events_in_progress)) {
+		saved_count = count;
 		events_check_enabled = true;
 		ret = true;
 	}
 	spin_unlock_irq(&events_lock);
+	if (!ret)
+		pm_wakeup_update_hit_counts();
 	return ret;
 }
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -60,7 +60,8 @@ void device_pm_init(struct device *dev)
 	dev->power.status = DPM_ON;
 	init_completion(&dev->power.completion);
 	complete_all(&dev->power.completion);
-	dev->power.wakeup_count = 0;
+	dev->power.wakeup = NULL;
+	spin_lock_init(&dev->power.lock);
 	pm_runtime_init(dev);
 }
 
@@ -120,6 +121,7 @@ void device_pm_remove(struct device *dev
 	mutex_lock(&dpm_list_mtx);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
+	device_wakeup_disable(dev);
 	pm_runtime_remove(dev);
 }
 
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -34,6 +34,7 @@ extern void device_pm_move_last(struct d
 
 static inline void device_pm_init(struct device *dev)
 {
+	spin_lock_init(&dev->power.lock);
 	pm_runtime_init(dev);
 }
 
Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -1099,8 +1099,6 @@ EXPORT_SYMBOL_GPL(pm_runtime_allow);
  */
 void pm_runtime_init(struct device *dev)
 {
-	spin_lock_init(&dev->power.lock);
-
 	dev->power.runtime_status = RPM_SUSPENDED;
 	dev->power.idle_notification = false;
 
Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -302,8 +302,8 @@ extern int unregister_pm_notifier(struct
 extern bool events_check_enabled;
 
 extern bool pm_check_wakeup_events(void);
-extern bool pm_get_wakeup_count(unsigned long *count);
-extern bool pm_save_wakeup_count(unsigned long count);
+extern bool pm_get_wakeup_count(unsigned int *count);
+extern bool pm_save_wakeup_count(unsigned int count);
 #else /* !CONFIG_PM_SLEEP */
 
 static inline int register_pm_notifier(struct notifier_block *nb)
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -237,18 +237,18 @@ static ssize_t wakeup_count_show(struct 
 				struct kobj_attribute *attr,
 				char *buf)
 {
-	unsigned long val;
+	unsigned int val;
 
-	return pm_get_wakeup_count(&val) ? sprintf(buf, "%lu\n", val) : -EINTR;
+	return pm_get_wakeup_count(&val) ? sprintf(buf, "%u\n", val) : -EINTR;
 }
 
 static ssize_t wakeup_count_store(struct kobject *kobj,
 				struct kobj_attribute *attr,
 				const char *buf, size_t n)
 {
-	unsigned long val;
+	unsigned int val;
 
-	if (sscanf(buf, "%lu", &val) == 1) {
+	if (sscanf(buf, "%u", &val) == 1) {
 		if (pm_save_wakeup_count(val))
 			return n;
 	}
Index: linux-2.6/drivers/base/power/sysfs.c
===================================================================
--- linux-2.6.orig/drivers/base/power/sysfs.c
+++ linux-2.6/drivers/base/power/sysfs.c
@@ -210,11 +210,122 @@ static DEVICE_ATTR(wakeup, 0644, wake_sh
 static ssize_t wakeup_count_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%lu\n", dev->power.wakeup_count);
+	unsigned long count = 0;
+	bool enabled = false;
+
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.wakeup) {
+		count = dev->power.wakeup->event_count;
+		enabled = true;
+	}
+	spin_unlock_irq(&dev->power.lock);
+	return enabled ? sprintf(buf, "%lu\n", count) : sprintf(buf, "\n");
 }
 
 static DEVICE_ATTR(wakeup_count, 0444, wakeup_count_show, NULL);
-#endif
+
+static ssize_t wakeup_active_count_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	unsigned long count = 0;
+	bool enabled = false;
+
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.wakeup) {
+		count = dev->power.wakeup->active_count;
+		enabled = true;
+	}
+	spin_unlock_irq(&dev->power.lock);
+	return enabled ? sprintf(buf, "%lu\n", count) : sprintf(buf, "\n");
+}
+
+static DEVICE_ATTR(wakeup_active_count, 0444, wakeup_active_count_show, NULL);
+
+static ssize_t wakeup_hit_count_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	unsigned long count = 0;
+	bool enabled = false;
+
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.wakeup) {
+		count = dev->power.wakeup->hit_count;
+		enabled = true;
+	}
+	spin_unlock_irq(&dev->power.lock);
+	return enabled ? sprintf(buf, "%lu\n", count) : sprintf(buf, "\n");
+}
+
+static DEVICE_ATTR(wakeup_hit_count, 0444, wakeup_hit_count_show, NULL);
+
+static ssize_t wakeup_active_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	unsigned int active = 0;
+	bool enabled = false;
+
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.wakeup) {
+		active = dev->power.wakeup->active;
+		enabled = true;
+	}
+	spin_unlock_irq(&dev->power.lock);
+	return enabled ? sprintf(buf, "%u\n", active) : sprintf(buf, "\n");
+}
+
+static DEVICE_ATTR(wakeup_active, 0444, wakeup_active_show, NULL);
+
+static ssize_t wakeup_total_time_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	s64 msec = 0;
+	bool enabled = false;
+
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.wakeup) {
+		msec = ktime_to_ms(dev->power.wakeup->total_time);
+		enabled = true;
+	}
+	spin_unlock_irq(&dev->power.lock);
+	return enabled ? sprintf(buf, "%lld\n", msec) : sprintf(buf, "\n");
+}
+
+static DEVICE_ATTR(wakeup_total_time_ms, 0444, wakeup_total_time_show, NULL);
+
+static ssize_t wakeup_max_time_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	s64 msec = 0;
+	bool enabled = false;
+
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.wakeup) {
+		msec = ktime_to_ms(dev->power.wakeup->max_time);
+		enabled = true;
+	}
+	spin_unlock_irq(&dev->power.lock);
+	return enabled ? sprintf(buf, "%lld\n", msec) : sprintf(buf, "\n");
+}
+
+static DEVICE_ATTR(wakeup_max_time_ms, 0444, wakeup_max_time_show, NULL);
+
+static ssize_t wakeup_last_time_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	s64 msec = 0;
+	bool enabled = false;
+
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.wakeup) {
+		msec = ktime_to_ms(dev->power.wakeup->last_time);
+		enabled = true;
+	}
+	spin_unlock_irq(&dev->power.lock);
+	return enabled ? sprintf(buf, "%lld\n", msec) : sprintf(buf, "\n");
+}
+
+static DEVICE_ATTR(wakeup_last_time_ms, 0444, wakeup_last_time_show, NULL);
+#endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_PM_ADVANCED_DEBUG
 #ifdef CONFIG_PM_RUNTIME
@@ -288,6 +399,12 @@ static struct attribute * power_attrs[] 
 	&dev_attr_wakeup.attr,
 #ifdef CONFIG_PM_SLEEP
 	&dev_attr_wakeup_count.attr,
+	&dev_attr_wakeup_active_count.attr,
+	&dev_attr_wakeup_hit_count.attr,
+	&dev_attr_wakeup_active.attr,
+	&dev_attr_wakeup_total_time_ms.attr,
+	&dev_attr_wakeup_max_time_ms.attr,
+	&dev_attr_wakeup_last_time_ms.attr,
 #endif
 #ifdef CONFIG_PM_ADVANCED_DEBUG
 	&dev_attr_async.attr,
Index: linux-2.6/Documentation/ABI/testing/sysfs-devices-power
===================================================================
--- linux-2.6.orig/Documentation/ABI/testing/sysfs-devices-power
+++ linux-2.6/Documentation/ABI/testing/sysfs-devices-power
@@ -77,3 +77,73 @@ Description:
 		devices this attribute is set to "enabled" by bus type code or
 		device drivers and in that cases it should be safe to leave the
 		default value.
+
+What:		/sys/devices/.../power/wakeup_count
+Date:		September 2010
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/devices/.../wakeup_count attribute contains the number
+		of signaled wakeup events associated with the device.  This
+		attribute is read-only.  If the device is not enabled to wake up
+		the system from sleep states, this attribute is empty.
+
+What:		/sys/devices/.../power/wakeup_active_count
+Date:		September 2010
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/devices/.../wakeup_active_count attribute contains the
+		number of times the processing of wakeup events associated with
+		the device was completed (at the kernel level).  This attribute
+		is read-only.  If the device is not enabled to wake up the
+		system from sleep states, this attribute is empty.
+
+What:		/sys/devices/.../power/wakeup_hit_count
+Date:		September 2010
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/devices/.../wakeup_hit_count attribute contains the
+		number of times the processing of a wakeup event associated with
+		the device might prevent the system from entering a sleep state.
+		This attribute is read-only.  If the device is not enabled to
+		wake up the system from sleep states, this attribute is empty.
+
+What:		/sys/devices/.../power/wakeup_active
+Date:		September 2010
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/devices/.../wakeup_active attribute contains either 1,
+		or 0, depending on whether or not a wakeup event associated with
+		the device is being processed (1).  This attribute is read-only.
+		If the device is not enabled to wake up the system from sleep
+		states, this attribute is empty.
+
+What:		/sys/devices/.../power/wakeup_total_time_ms
+Date:		September 2010
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/devices/.../wakeup_total_time_ms attribute contains
+		the total time of processing wakeup events associated with the
+		device, in milliseconds.  This attribute is read-only.  If the
+		device is not enabled to wake up the system from sleep states,
+		this attribute is empty.
+
+What:		/sys/devices/.../power/wakeup_max_time_ms
+Date:		September 2010
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/devices/.../wakeup_max_time_ms attribute contains
+		the maximum time of processing a single wakeup event associated
+		with the device, in milliseconds.  This attribute is read-only.
+		If the device is not enabled to wake up the system from sleep
+		states, this attribute is empty.
+
+What:		/sys/devices/.../power/wakeup_last_time_ms
+Date:		September 2010
+Contact:	Rafael J. Wysocki <rjw@sisk.pl>
+Description:
+		The /sys/devices/.../wakeup_last_time_ms attribute contains
+		the value of the monotonic clock corresponding to the time of
+		signaling the last wakeup event associated with the device, in
+		milliseconds.  This attribute is read-only.  If the device is
+		not enabled to wake up the system from sleep states, this
+		attribute is empty.
