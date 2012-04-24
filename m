Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab2DXVr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:47:57 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35020 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757782Ab2DXVrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:47:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 3/3] PM / Runtime: Remove device fields related to suspend time
Date: Tue, 24 Apr 2012 23:51:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        markgross@thegnar.org, Jean Pihet <j-pihet@ti.com>
References: <201204242349.26288.rjw@sisk.pl>
In-Reply-To: <201204242349.26288.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204242351.35172.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After the previous changes in default_stop_ok() and
default_power_down_ok() for PM domains, there are two fields in
struct dev_pm_info that aren't necessary any more,  suspend_time
and max_time_suspended_ns.

Remove those fields along with all of the code that accesses them,
which simplifies the runtime PM framework quite a bit.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c  |   13 -----
 drivers/base/power/runtime.c |  105 -------------------------------------------
 include/linux/pm.h           |    2 
 include/linux/pm_runtime.h   |    3 -
 4 files changed, 123 deletions(-)

Index: linux/drivers/base/power/runtime.c
===================================================================
--- linux.orig/drivers/base/power/runtime.c
+++ linux/drivers/base/power/runtime.c
@@ -282,47 +282,6 @@ static int rpm_callback(int (*cb)(struct
 	return retval != -EACCES ? retval : -EIO;
 }
 
-struct rpm_qos_data {
-	ktime_t time_now;
-	s64 constraint_ns;
-};
-
-/**
- * rpm_update_qos_constraint - Update a given PM QoS constraint data.
- * @dev: Device whose timing data to use.
- * @data: PM QoS constraint data to update.
- *
- * Use the suspend timing data of @dev to update PM QoS constraint data pointed
- * to by @data.
- */
-static int rpm_update_qos_constraint(struct device *dev, void *data)
-{
-	struct rpm_qos_data *qos = data;
-	unsigned long flags;
-	s64 delta_ns;
-	int ret = 0;
-
-	spin_lock_irqsave(&dev->power.lock, flags);
-
-	if (dev->power.max_time_suspended_ns < 0)
-		goto out;
-
-	delta_ns = dev->power.max_time_suspended_ns -
-		ktime_to_ns(ktime_sub(qos->time_now, dev->power.suspend_time));
-	if (delta_ns <= 0) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	if (qos->constraint_ns > delta_ns || qos->constraint_ns == 0)
-		qos->constraint_ns = delta_ns;
-
- out:
-	spin_unlock_irqrestore(&dev->power.lock, flags);
-
-	return ret;
-}
-
 /**
  * rpm_suspend - Carry out runtime suspend of given device.
  * @dev: Device to suspend.
@@ -349,7 +308,6 @@ static int rpm_suspend(struct device *de
 {
 	int (*callback)(struct device *);
 	struct device *parent = NULL;
-	struct rpm_qos_data qos;
 	int retval;
 
 	trace_rpm_suspend(dev, rpmflags);
@@ -445,38 +403,8 @@ static int rpm_suspend(struct device *de
 		goto out;
 	}
 
-	qos.constraint_ns = __dev_pm_qos_read_value(dev);
-	if (qos.constraint_ns < 0) {
-		/* Negative constraint means "never suspend". */
-		retval = -EPERM;
-		goto out;
-	}
-	qos.constraint_ns *= NSEC_PER_USEC;
-	qos.time_now = ktime_get();
-
 	__update_runtime_status(dev, RPM_SUSPENDING);
 
-	if (!dev->power.ignore_children) {
-		if (dev->power.irq_safe)
-			spin_unlock(&dev->power.lock);
-		else
-			spin_unlock_irq(&dev->power.lock);
-
-		retval = device_for_each_child(dev, &qos,
-					       rpm_update_qos_constraint);
-
-		if (dev->power.irq_safe)
-			spin_lock(&dev->power.lock);
-		else
-			spin_lock_irq(&dev->power.lock);
-
-		if (retval)
-			goto fail;
-	}
-
-	dev->power.suspend_time = qos.time_now;
-	dev->power.max_time_suspended_ns = qos.constraint_ns ? : -1;
-
 	if (dev->pm_domain)
 		callback = dev->pm_domain->ops.runtime_suspend;
 	else if (dev->type && dev->type->pm)
@@ -529,8 +457,6 @@ static int rpm_suspend(struct device *de
 
  fail:
 	__update_runtime_status(dev, RPM_ACTIVE);
-	dev->power.suspend_time = ktime_set(0, 0);
-	dev->power.max_time_suspended_ns = -1;
 	dev->power.deferred_resume = false;
 	wake_up_all(&dev->power.wait_queue);
 
@@ -704,9 +630,6 @@ static int rpm_resume(struct device *dev
 	if (dev->power.no_callbacks)
 		goto no_callback;	/* Assume success. */
 
-	dev->power.suspend_time = ktime_set(0, 0);
-	dev->power.max_time_suspended_ns = -1;
-
 	__update_runtime_status(dev, RPM_RESUMING);
 
 	if (dev->pm_domain)
@@ -1369,9 +1292,6 @@ void pm_runtime_init(struct device *dev)
 	setup_timer(&dev->power.suspend_timer, pm_suspend_timer_fn,
 			(unsigned long)dev);
 
-	dev->power.suspend_time = ktime_set(0, 0);
-	dev->power.max_time_suspended_ns = -1;
-
 	init_waitqueue_head(&dev->power.wait_queue);
 }
 
@@ -1389,28 +1309,3 @@ void pm_runtime_remove(struct device *de
 	if (dev->power.irq_safe && dev->parent)
 		pm_runtime_put_sync(dev->parent);
 }
-
-/**
- * pm_runtime_update_max_time_suspended - Update device's suspend time data.
- * @dev: Device to handle.
- * @delta_ns: Value to subtract from the device's max_time_suspended_ns field.
- *
- * Update the device's power.max_time_suspended_ns field by subtracting
- * @delta_ns from it.  The resulting value of power.max_time_suspended_ns is
- * never negative.
- */
-void pm_runtime_update_max_time_suspended(struct device *dev, s64 delta_ns)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->power.lock, flags);
-
-	if (delta_ns > 0 && dev->power.max_time_suspended_ns > 0) {
-		if (dev->power.max_time_suspended_ns > delta_ns)
-			dev->power.max_time_suspended_ns -= delta_ns;
-		else
-			dev->power.max_time_suspended_ns = 0;
-	}
-
-	spin_unlock_irqrestore(&dev->power.lock, flags);
-}
Index: linux/include/linux/pm.h
===================================================================
--- linux.orig/include/linux/pm.h
+++ linux/include/linux/pm.h
@@ -544,8 +544,6 @@ struct dev_pm_info {
 	unsigned long		active_jiffies;
 	unsigned long		suspended_jiffies;
 	unsigned long		accounting_timestamp;
-	ktime_t			suspend_time;
-	s64			max_time_suspended_ns;
 	struct dev_pm_qos_request *pq_req;
 #endif
 	struct pm_subsys_data	*subsys_data;  /* Owned by the subsystem. */
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -444,16 +444,6 @@ static int pm_genpd_poweroff(struct gene
 
 	genpd->status = GPD_STATE_POWER_OFF;
 
-	/* Update PM QoS information for devices in the domain. */
-	list_for_each_entry_reverse(pdd, &genpd->dev_list, list_node) {
-		struct gpd_timing_data *td = &to_gpd_data(pdd)->td;
-
-		pm_runtime_update_max_time_suspended(pdd->dev,
-					td->start_latency_ns +
-					td->restore_state_latency_ns +
-					genpd->power_on_latency_ns);
-	}
-
 	list_for_each_entry(link, &genpd->slave_links, slave_node) {
 		genpd_sd_counter_dec(link->master);
 		genpd_queue_power_off_work(link->master);
@@ -513,9 +503,6 @@ static int pm_genpd_runtime_suspend(stru
 	if (ret)
 		return ret;
 
-	pm_runtime_update_max_time_suspended(dev,
-				dev_gpd_data(dev)->td.start_latency_ns);
-
 	/*
 	 * If power.irq_safe is set, this routine will be run with interrupts
 	 * off, so it can't use mutexes.
Index: linux/include/linux/pm_runtime.h
===================================================================
--- linux.orig/include/linux/pm_runtime.h
+++ linux/include/linux/pm_runtime.h
@@ -150,9 +150,6 @@ static inline void pm_runtime_set_autosu
 static inline unsigned long pm_runtime_autosuspend_expiration(
 				struct device *dev) { return 0; }
 
-static inline void pm_runtime_update_max_time_suspended(struct device *dev,
-							s64 delta_ns) {}
-
 #endif /* !CONFIG_PM_RUNTIME */
 
 static inline int pm_runtime_idle(struct device *dev)

