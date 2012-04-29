Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab2D2BK6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 21:10:58 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43739 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab2D2BKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 21:10:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 3/3][RFC] PM / Domains: Cache device stop and domain power off governor results, v2
Date: Sun, 29 Apr 2012 03:14:30 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        markgross@thegnar.org, Jean Pihet <j-pihet@ti.com>
References: <201204272346.44145.rjw@sisk.pl> <201204290308.52416.rjw@sisk.pl>
In-Reply-To: <201204290308.52416.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204290314.31190.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The results of the default device stop and domain power off governor
functions for generic PM domains, default_stop_ok() and
default_power_down_ok(), depend only on the timing data of devices,
which are static, and on their PM QoS constraints.  Thus, in theory,
these functions only need to carry out their computations, which may
be time consuming in general, when it is known that the PM QoS
constraint of at least one of the devices in question has changed.

Use the PM QoS notifiers of devices to implement that.  First,
introduce new fields, constraint_changed and max_off_time_changed,
into struct gpd_timing_data and struct generic_pm_domain,
respectively, and register a PM QoS notifier function when adding
a device into a domain that will set those fields to 'true' whenever
the device's PM QoS constraint is modified.  Second, make
default_stop_ok() and default_power_down_ok() use those fields to
decide whether or not to carry out their computations from scratch.

The device and PM domain hierarchies are taken into account in that
and the expense is that the changes of PM QoS constraints of
suspended devices will not be taken into account immediately, which
isn't guaranteed anyway in general.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c          |  127 ++++++++++++++++++++++++++++++-----
 drivers/base/power/domain_governor.c |   43 +++++++++++
 include/linux/pm_domain.h            |    7 +
 3 files changed, 158 insertions(+), 19 deletions(-)

Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -14,6 +14,7 @@
 #include <linux/pm.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/notifier.h>
 
 enum gpd_status {
 	GPD_STATE_ACTIVE = 0,	/* PM domain is active */
@@ -71,6 +72,8 @@ struct generic_pm_domain {
 	s64 power_on_latency_ns;
 	struct gpd_dev_ops dev_ops;
 	s64 max_off_time_ns;	/* Maximum allowed "suspended" time. */
+	bool max_off_time_changed;
+	bool cached_power_down_ok;
 	struct device_node *of_node; /* Node in device tree */
 };
 
@@ -92,12 +95,16 @@ struct gpd_timing_data {
 	s64 save_state_latency_ns;
 	s64 restore_state_latency_ns;
 	s64 effective_constraint_ns;
+	bool constraint_changed;
+	bool cached_stop_ok;
 };
 
 struct generic_pm_domain_data {
 	struct pm_domain_data base;
 	struct gpd_dev_ops ops;
 	struct gpd_timing_data td;
+	struct notifier_block nb;
+	struct mutex lock;
 	bool need_restore;
 	bool always_on;
 };
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -11,6 +11,7 @@
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_domain.h>
+#include <linux/pm_qos.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/sched.h>
@@ -38,11 +39,13 @@
 	ktime_t __start = ktime_get();						\
 	type __retval = GENPD_DEV_CALLBACK(genpd, type, callback, dev);		\
 	s64 __elapsed = ktime_to_ns(ktime_sub(ktime_get(), __start));		\
-	struct generic_pm_domain_data *__gpd_data = dev_gpd_data(dev);		\
-	if (__elapsed > __gpd_data->td.field) {					\
-		__gpd_data->td.field = __elapsed;				\
+	struct gpd_timing_data *__td = &dev_gpd_data(dev)->td;			\
+	if (!__retval && __elapsed > __td->field) {				\
+		__td->field = __elapsed;					\
 		dev_warn(dev, name " latency exceeded, new value %lld ns\n",	\
 			__elapsed);						\
+		genpd->max_off_time_changed = true;				\
+		__td->constraint_changed = true;				\
 	}									\
 	__retval;								\
 })
@@ -211,6 +214,7 @@ int __pm_genpd_poweron(struct generic_pm
 		elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
 		if (elapsed_ns > genpd->power_on_latency_ns) {
 			genpd->power_on_latency_ns = elapsed_ns;
+			genpd->max_off_time_changed = true;
 			if (genpd->name)
 				pr_warning("%s: Power-on latency exceeded, "
 					"new value %lld ns\n", genpd->name,
@@ -247,6 +251,53 @@ int pm_genpd_poweron(struct generic_pm_d
 
 #ifdef CONFIG_PM_RUNTIME
 
+static int genpd_dev_pm_qos_notifier(struct notifier_block *nb,
+				     unsigned long val, void *ptr)
+{
+	struct generic_pm_domain_data *gpd_data;
+	struct device *dev;
+
+	gpd_data = container_of(nb, struct generic_pm_domain_data, nb);
+
+	mutex_lock(&gpd_data->lock);
+	dev = gpd_data->base.dev;
+	if (!dev) {
+		mutex_unlock(&gpd_data->lock);
+		return NOTIFY_DONE;
+	}
+	mutex_unlock(&gpd_data->lock);
+
+	for (;;) {
+		struct generic_pm_domain *genpd;
+		struct pm_domain_data *pdd;
+
+		spin_lock_irq(&dev->power.lock);
+
+		pdd = dev->power.subsys_data ?
+				dev->power.subsys_data->domain_data : NULL;
+		if (pdd) {
+			to_gpd_data(pdd)->td.constraint_changed = true;
+			genpd = dev_to_genpd(dev);
+		} else {
+			genpd = ERR_PTR(-ENODATA);
+		}
+
+		spin_unlock_irq(&dev->power.lock);
+
+		if (!IS_ERR(genpd)) {
+			mutex_lock(&genpd->lock);
+			genpd->max_off_time_changed = true;
+			mutex_unlock(&genpd->lock);
+		}
+
+		dev = dev->parent;
+		if (!dev || dev->power.ignore_children)
+			break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 /**
  * __pm_genpd_save_device - Save the pre-suspend state of a device.
  * @pdd: Domain data of the device to save the state of.
@@ -381,7 +432,9 @@ static int pm_genpd_poweroff(struct gene
 		return 0;
 	}
 
-	genpd->max_off_time_ns = -1;
+	if (genpd->max_off_time_changed)
+		genpd->max_off_time_ns = -1;
+
 	if (genpd->gov && genpd->gov->power_down_ok) {
 		if (!genpd->gov->power_down_ok(&genpd->domain))
 			return -EAGAIN;
@@ -436,6 +489,7 @@ static int pm_genpd_poweroff(struct gene
 		elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
 		if (elapsed_ns > genpd->power_off_latency_ns) {
 			genpd->power_off_latency_ns = elapsed_ns;
+			genpd->max_off_time_changed = true;
 			if (genpd->name)
 				pr_warning("%s: Power-off latency exceeded, "
 					"new value %lld ns\n", genpd->name,
@@ -483,6 +537,7 @@ static int pm_genpd_runtime_suspend(stru
 {
 	struct generic_pm_domain *genpd;
 	bool (*stop_ok)(struct device *__dev);
+	struct gpd_timing_data *td;
 	int ret;
 
 	dev_dbg(dev, "%s()\n", __func__);
@@ -496,7 +551,10 @@ static int pm_genpd_runtime_suspend(stru
 	if (dev_gpd_data(dev)->always_on)
 		return -EBUSY;
 
-	dev_gpd_data(dev)->td.effective_constraint_ns = -1;
+	td = &dev_gpd_data(dev)->td;
+	if (td->constraint_changed)
+		td->effective_constraint_ns = -1;
+
 	stop_ok = genpd->gov ? genpd->gov->stop_ok : NULL;
 	if (stop_ok && !stop_ok(dev))
 		return -EBUSY;
@@ -601,6 +659,12 @@ void pm_genpd_poweroff_unused(void)
 
 #else
 
+static inline int genpd_dev_pm_qos_notifier(struct notifier_block *nb,
+					    unsigned long val, void *ptr)
+{
+	return NOTIFY_DONE;
+}
+
 static inline void genpd_power_off_work_fn(struct work_struct *work) {}
 
 #define pm_genpd_runtime_suspend	NULL
@@ -1197,6 +1261,14 @@ int __pm_genpd_add_device(struct generic
 	if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(dev))
 		return -EINVAL;
 
+	gpd_data = kzalloc(sizeof(*gpd_data), GFP_KERNEL);
+	if (!gpd_data)
+		return -ENOMEM;
+
+	mutex_init(&gpd_data->lock);
+	gpd_data->nb.notifier_call = genpd_dev_pm_qos_notifier;
+	dev_pm_qos_add_notifier(dev, &gpd_data->nb);
+
 	genpd_acquire_lock(genpd);
 
 	if (genpd->status == GPD_STATE_POWER_OFF) {
@@ -1215,26 +1287,34 @@ int __pm_genpd_add_device(struct generic
 			goto out;
 		}
 
-	gpd_data = kzalloc(sizeof(*gpd_data), GFP_KERNEL);
-	if (!gpd_data) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	genpd->device_count++;
+	genpd->max_off_time_changed = true;
 
-	dev->pm_domain = &genpd->domain;
 	dev_pm_get_subsys_data(dev);
+
+	mutex_lock(&gpd_data->lock);
+	spin_lock_irq(&dev->power.lock);
+	dev->pm_domain = &genpd->domain;
 	dev->power.subsys_data->domain_data = &gpd_data->base;
 	gpd_data->base.dev = dev;
-	gpd_data->need_restore = false;
 	list_add_tail(&gpd_data->base.list_node, &genpd->dev_list);
+	gpd_data->need_restore = false;
 	if (td)
 		gpd_data->td = *td;
 
+	gpd_data->td.constraint_changed = true;
+	spin_unlock_irq(&dev->power.lock);
+	mutex_unlock(&gpd_data->lock);
+
+	genpd_release_lock(genpd);
+
+	return 0;
+
  out:
 	genpd_release_lock(genpd);
 
+	dev_pm_qos_remove_notifier(dev, &gpd_data->nb);
+	kfree(gpd_data);
 	return ret;
 }
 
@@ -1278,6 +1358,7 @@ int __pm_genpd_of_add_device(struct devi
 int pm_genpd_remove_device(struct generic_pm_domain *genpd,
 			   struct device *dev)
 {
+	struct generic_pm_domain_data *gpd_data;
 	struct pm_domain_data *pdd;
 	int ret = 0;
 
@@ -1295,14 +1376,27 @@ int pm_genpd_remove_device(struct generi
 		goto out;
 	}
 
+	genpd->device_count--;
+	genpd->max_off_time_changed = true;
+
+	spin_lock_irq(&dev->power.lock);
 	dev->pm_domain = NULL;
 	pdd = dev->power.subsys_data->domain_data;
 	list_del_init(&pdd->list_node);
 	dev->power.subsys_data->domain_data = NULL;
-	dev_pm_put_subsys_data(dev);
-	kfree(to_gpd_data(pdd));
+	spin_unlock_irq(&dev->power.lock);
 
-	genpd->device_count--;
+	gpd_data = to_gpd_data(pdd);
+	mutex_lock(&gpd_data->lock);
+	pdd->dev = NULL;
+	mutex_unlock(&gpd_data->lock);
+
+	genpd_release_lock(genpd);
+
+	dev_pm_qos_remove_notifier(dev, &gpd_data->nb);
+	kfree(gpd_data);
+	dev_pm_put_subsys_data(dev);
+	return 0;
 
  out:
 	genpd_release_lock(genpd);
@@ -1673,6 +1767,7 @@ void pm_genpd_init(struct generic_pm_dom
 	genpd->resume_count = 0;
 	genpd->device_count = 0;
 	genpd->max_off_time_ns = -1;
+	genpd->max_off_time_changed = true;
 	genpd->domain.ops.runtime_suspend = pm_genpd_runtime_suspend;
 	genpd->domain.ops.runtime_resume = pm_genpd_runtime_resume;
 	genpd->domain.ops.runtime_idle = pm_generic_runtime_idle;
Index: linux/drivers/base/power/domain_governor.c
===================================================================
--- linux.orig/drivers/base/power/domain_governor.c
+++ linux/drivers/base/power/domain_governor.c
@@ -46,18 +46,33 @@ static int dev_update_qos_constraint(str
 bool default_stop_ok(struct device *dev)
 {
 	struct gpd_timing_data *td = &dev_gpd_data(dev)->td;
+	unsigned long flags;
 	s64 constraint_ns;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
-	constraint_ns = dev_pm_qos_read_value(dev);
+	spin_lock_irqsave(&dev->power.lock, flags);
+
+	if (!td->constraint_changed) {
+		bool ret = td->cached_stop_ok;
+
+		spin_unlock_irqrestore(&dev->power.lock, flags);
+		return ret;
+	}
+	//td->constraint_changed = false;
+	td->cached_stop_ok = false;
+	constraint_ns = __dev_pm_qos_read_value(dev);
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
 	if (constraint_ns < 0)
 		return false;
 
 	constraint_ns *= NSEC_PER_USEC;
 	/*
 	 * We can walk the children without any additional locking, because
-	 * they all have been suspended at this point.
+	 * they all have been suspended at this point and their
+	 * effective_constraint_ns fields won't be modified in parallel with us.
 	 */
 	if (!dev->power.ignore_children)
 		device_for_each_child(dev, &constraint_ns,
@@ -69,11 +84,13 @@ bool default_stop_ok(struct device *dev)
 			return false;
 	}
 	td->effective_constraint_ns = constraint_ns;
+	td->cached_stop_ok = constraint_ns > td->stop_latency_ns ||
+				constraint_ns == 0;
 	/*
 	 * The children have been suspended already, so we don't need to take
 	 * their stop latencies into account here.
 	 */
-	return constraint_ns > td->stop_latency_ns || constraint_ns == 0;
+	return td->cached_stop_ok;
 }
 
 /**
@@ -90,6 +107,24 @@ static bool default_power_down_ok(struct
 	s64 min_dev_off_time_ns;
 	s64 off_on_time_ns;
 
+	if (genpd->max_off_time_changed) {
+		struct gpd_link *link;
+
+		/*
+		 * We have to invalidate the cached results for the masters, so
+		 * use the observation that default_power_down_ok() is not
+		 * going to be called for any master until this instance
+		 * returns.
+		 */
+		list_for_each_entry(link, &genpd->slave_links, slave_node)
+			link->master->max_off_time_changed = true;
+
+		//genpd->max_off_time_changed = false;
+		genpd->cached_power_down_ok = false;
+	} else {
+		return genpd->cached_power_down_ok;
+	}
+
 	off_on_time_ns = genpd->power_off_latency_ns +
 				genpd->power_on_latency_ns;
 	/*
@@ -165,6 +200,8 @@ static bool default_power_down_ok(struct
 			min_dev_off_time_ns = constraint_ns;
 	}
 
+	genpd->cached_power_down_ok = true;
+
 	/*
 	 * If the computed minimum device off time is negative, there are no
 	 * latency constraints, so the domain can spend arbitrary time in the
