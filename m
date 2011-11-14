Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1KNA1V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:27:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38030 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab1KNA0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:26:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [update][PATCH 4/7] PM / Runtime: Use device PM QoS constraints
Date: Mon, 14 Nov 2011 01:26:19 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kevin Hilman <khilman@ti.com>, jean.pihet@newoldbits.com
References: <201111070101.33960.rjw@sisk.pl> <201111140122.27328.rjw@sisk.pl>
In-Reply-To: <201111140122.27328.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111140126.19860.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the runtime PM core use device PM QoS constraints to check if
it is allowed to suspend a given device, so that an error code is
returned if the device's own PM QoS constraint is negative or one of
its children has already been suspended for too long.  If this is
not the case, the maximum estimated time the device is allowed to be
suspended, computed as the minimum of the device's PM QoS constraint
and the PM QoS constraints of its children (reduced by the difference
between the current time and their suspend times) is stored in a new
device's PM field power.max_time_suspended_ns that can be used by
the device's subsystem or PM domain to decide whether or not to put
the device into lower-power (and presumably higher-latency) states
later (if the constraint is 0, which means "no constraint", the
power.max_time_suspended_ns is set to -1).

Additionally, the time of execution of the subsystem-level
.runtime_suspend() callback for the device is recorded in the new
power.suspend_time field for later use by the device's subsystem or
PM domain along with power.max_time_suspended_ns (it also is used
by the core code when the device's parent is suspended).

Introduce a new helper function,
pm_runtime_update_max_time_suspended(), allowing subsystems and PM
domains (or device drivers) to update the power.max_time_suspended_ns
field, for example after changing the power state of a suspended
device.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/qos.c     |   24 ++++++++----
 drivers/base/power/runtime.c |   85 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm.h           |    2 +
 include/linux/pm_runtime.h   |    5 ++
 4 files changed, 108 insertions(+), 8 deletions(-)

Index: linux/include/linux/pm.h
===================================================================
--- linux.orig/include/linux/pm.h
+++ linux/include/linux/pm.h
@@ -482,6 +482,8 @@ struct dev_pm_info {
 	unsigned long		active_jiffies;
 	unsigned long		suspended_jiffies;
 	unsigned long		accounting_timestamp;
+	ktime_t			suspend_time;
+	s64			max_time_suspended_ns;
 #endif
 	struct pm_subsys_data	*subsys_data;  /* Owned by the subsystem. */
 	struct pm_qos_constraints *constraints;
Index: linux/drivers/base/power/runtime.c
===================================================================
--- linux.orig/drivers/base/power/runtime.c
+++ linux/drivers/base/power/runtime.c
@@ -279,6 +279,38 @@ static int rpm_callback(int (*cb)(struct
 	return retval != -EACCES ? retval : -EIO;
 }
 
+struct rpm_qos_data {
+	ktime_t time_now;
+	s64 constraint_ns;
+};
+
+/**
+ * rpm_update_qos_constraint - Update a given PM QoS constraint data.
+ * @dev: Device whose timing data to use.
+ * @data: PM QoS constraint data to update.
+ *
+ * Use the suspend timing data of @dev to update PM QoS constraint data pointed
+ * to by @data.
+ */
+static int rpm_update_qos_constraint(struct device *dev, void *data)
+{
+	struct rpm_qos_data *qos = data;
+	s64 delta_ns;
+
+	if (dev->power.max_time_suspended_ns < 0)
+		return 0;
+
+	delta_ns = dev->power.max_time_suspended_ns -
+		ktime_to_ns(ktime_sub(qos->time_now, dev->power.suspend_time));
+	if (delta_ns <= 0)
+		return -EBUSY;
+
+	if (qos->constraint_ns > delta_ns || qos->constraint_ns == 0)
+		qos->constraint_ns = delta_ns;
+
+	return 0;
+}
+
 /**
  * rpm_suspend - Carry out runtime suspend of given device.
  * @dev: Device to suspend.
@@ -305,6 +337,7 @@ static int rpm_suspend(struct device *de
 {
 	int (*callback)(struct device *);
 	struct device *parent = NULL;
+	struct rpm_qos_data qos;
 	int retval;
 
 	trace_rpm_suspend(dev, rpmflags);
@@ -400,6 +433,25 @@ static int rpm_suspend(struct device *de
 		goto out;
 	}
 
+	qos.constraint_ns = __dev_pm_qos_read_value(dev);
+	if (qos.constraint_ns < 0) {
+		/* Negative constraint means "never suspend". */
+		retval = -EPERM;
+		goto out;
+	}
+	qos.constraint_ns *= NSEC_PER_USEC;
+	qos.time_now = ktime_get();
+
+	if (!dev->power.ignore_children) {
+		retval = device_for_each_child(dev, &qos,
+					       rpm_update_qos_constraint);
+		if (retval)
+			goto out;
+	}
+
+	dev->power.suspend_time = qos.time_now;
+	dev->power.max_time_suspended_ns = qos.constraint_ns ? : -1;
+
 	__update_runtime_status(dev, RPM_SUSPENDING);
 
 	if (dev->pm_domain)
@@ -416,6 +468,8 @@ static int rpm_suspend(struct device *de
 	retval = rpm_callback(callback, dev);
 	if (retval) {
 		__update_runtime_status(dev, RPM_ACTIVE);
+		dev->power.suspend_time = ktime_set(0, 0);
+		dev->power.max_time_suspended_ns = -1;
 		dev->power.deferred_resume = false;
 		if (retval == -EAGAIN || retval == -EBUSY) {
 			dev->power.runtime_error = 0;
@@ -620,6 +674,9 @@ static int rpm_resume(struct device *dev
 	if (dev->power.no_callbacks)
 		goto no_callback;	/* Assume success. */
 
+	dev->power.suspend_time = ktime_set(0, 0);
+	dev->power.max_time_suspended_ns = -1;
+
 	__update_runtime_status(dev, RPM_RESUMING);
 
 	if (dev->pm_domain)
@@ -1279,6 +1336,9 @@ void pm_runtime_init(struct device *dev)
 	setup_timer(&dev->power.suspend_timer, pm_suspend_timer_fn,
 			(unsigned long)dev);
 
+	dev->power.suspend_time = ktime_set(0, 0);
+	dev->power.max_time_suspended_ns = -1;
+
 	init_waitqueue_head(&dev->power.wait_queue);
 }
 
@@ -1296,3 +1356,28 @@ void pm_runtime_remove(struct device *de
 	if (dev->power.irq_safe && dev->parent)
 		pm_runtime_put_sync(dev->parent);
 }
+
+/**
+ * pm_runtime_update_max_time_suspended - Update device's suspend time data.
+ * @dev: Device to handle.
+ * @delta_ns: Value to subtract from the device's max_time_suspended_ns field.
+ *
+ * Update the device's power.max_time_suspended_ns field by subtracting
+ * @delta_ns from it.  The resulting value of power.max_time_suspended_ns is
+ * never negative.
+ */
+void pm_runtime_update_max_time_suspended(struct device *dev, s64 delta_ns)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (delta_ns > 0 && dev->power.max_time_suspended_ns > 0) {
+		if (dev->power.max_time_suspended_ns > delta_ns)
+			dev->power.max_time_suspended_ns -= delta_ns;
+		else
+			dev->power.max_time_suspended_ns = 0;
+	}
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+}
Index: linux/include/linux/pm_runtime.h
===================================================================
--- linux.orig/include/linux/pm_runtime.h
+++ linux/include/linux/pm_runtime.h
@@ -45,6 +45,8 @@ extern void pm_runtime_irq_safe(struct d
 extern void __pm_runtime_use_autosuspend(struct device *dev, bool use);
 extern void pm_runtime_set_autosuspend_delay(struct device *dev, int delay);
 extern unsigned long pm_runtime_autosuspend_expiration(struct device *dev);
+extern void pm_runtime_update_max_time_suspended(struct device *dev,
+						 s64 delta_ns);
 
 static inline bool pm_children_suspended(struct device *dev)
 {
@@ -154,6 +156,9 @@ static inline void pm_runtime_set_autosu
 static inline unsigned long pm_runtime_autosuspend_expiration(
 				struct device *dev) { return 0; }
 
+static inline void pm_runtime_update_max_time_suspended(struct device *dev,
+							s64 delta_ns) {}
+
 #endif /* !CONFIG_PM_RUNTIME */
 
 static inline int pm_runtime_idle(struct device *dev)
Index: linux/drivers/base/power/qos.c
===================================================================
--- linux.orig/drivers/base/power/qos.c
+++ linux/drivers/base/power/qos.c
@@ -47,21 +47,29 @@ static DEFINE_MUTEX(dev_pm_qos_mtx);
 static BLOCKING_NOTIFIER_HEAD(dev_pm_notifiers);
 
 /**
- * dev_pm_qos_read_value - Get PM QoS constraint for a given device.
+ * __dev_pm_qos_read_value - Get PM QoS constraint for a given device.
+ * @dev: Device to get the PM QoS constraint value for.
+ *
+ * This routine must be called with dev->power.lock held.
+ */
+s32 __dev_pm_qos_read_value(struct device *dev)
+{
+	struct pm_qos_constraints *c = dev->power.constraints;
+
+	return c ? pm_qos_read_value(c) : 0;
+}
+
+/**
+ * dev_pm_qos_read_value - Get PM QoS constraint for a given device (locked).
  * @dev: Device to get the PM QoS constraint value for.
  */
 s32 dev_pm_qos_read_value(struct device *dev)
 {
-	struct pm_qos_constraints *c;
 	unsigned long flags;
-	s32 ret = 0;
+	s32 ret;
 
 	spin_lock_irqsave(&dev->power.lock, flags);
-
-	c = dev->power.constraints;
-	if (c)
-		ret = pm_qos_read_value(c);
-
+	ret = __dev_pm_qos_read_value(dev);
 	spin_unlock_irqrestore(&dev->power.lock, flags);
 
 	return ret;

