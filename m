Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2D0Vtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:49:53 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab2D0Vto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:49:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/2][RFC] PM / Domains: Cache device stop and domain power off governor results
Date: Fri, 27 Apr 2012 23:53:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        markgross@thegnar.org, Jean Pihet <j-pihet@ti.com>
References: <201204272346.44145.rjw@sisk.pl>
In-Reply-To: <201204272346.44145.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204272354.00006.rjw@sisk.pl>
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
 drivers/base/power/domain.c          |   61 +++++++++++++++++++++++++++++++++--
 drivers/base/power/domain_governor.c |   40 +++++++++++++++++++++-
 include/linux/pm_domain.h            |    6 +++
 3 files changed, 102 insertions(+), 5 deletions(-)

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
 
@@ -92,12 +95,15 @@ struct gpd_timing_data {
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
@@ -247,6 +248,39 @@ int pm_genpd_poweron(struct generic_pm_d
 
 #ifdef CONFIG_PM_RUNTIME
 
+static int genpd_dev_pm_qos_notifier(struct notifier_block *nb,
+				     unsigned long val, void *ptr)
+{
+	struct generic_pm_domain_data *gpd_data;
+	struct device *dev;
+	struct generic_pm_domain *genpd;
+
+	gpd_data = container_of(nb, struct generic_pm_domain_data, nb);
+	dev = gpd_data->base.dev;
+	do {
+		/*
+		 * Take the device power lock to prevent the possible race
+		 * condition in which the PM QoS constraint of the device is
+		 * changed twice in a row very quickly and default_stop_ok()
+		 * runs in parallel with the second change.
+		 */
+		spin_lock_irq(&dev->power.lock);
+		gpd_data->td.constraint_changed = true;
+		spin_unlock_irq(&dev->power.lock);
+
+		genpd = dev_to_genpd(dev);
+		if (!IS_ERR(genpd)) {
+			mutex_lock(&genpd->lock);
+			genpd->max_off_time_changed = true;
+			mutex_unlock(&genpd->lock);
+		}
+
+		dev = dev->parent;
+	} while (dev && !dev->power.ignore_children);
+
+	return NOTIFY_DONE;
+}
+
 /**
  * __pm_genpd_save_device - Save the pre-suspend state of a device.
  * @pdd: Domain data of the device to save the state of.
@@ -381,7 +415,9 @@ static int pm_genpd_poweroff(struct gene
 		return 0;
 	}
 
-	genpd->max_off_time_ns = -1;
+	if (genpd->max_off_time_changed)
+		genpd->max_off_time_ns = -1;
+
 	if (genpd->gov && genpd->gov->power_down_ok) {
 		if (!genpd->gov->power_down_ok(&genpd->domain))
 			return -EAGAIN;
@@ -483,6 +519,7 @@ static int pm_genpd_runtime_suspend(stru
 {
 	struct generic_pm_domain *genpd;
 	bool (*stop_ok)(struct device *__dev);
+	struct gpd_timing_data *td;
 	int ret;
 
 	dev_dbg(dev, "%s()\n", __func__);
@@ -496,7 +533,10 @@ static int pm_genpd_runtime_suspend(stru
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
@@ -601,6 +641,12 @@ void pm_genpd_poweroff_unused(void)
 
 #else
 
+static inline int genpd_dev_pm_qos_notifier(struct notifier_block *nb,
+					    unsigned long val, void *ptr)
+{
+	return NOTIFY_DONE;
+}
+
 static inline void genpd_power_off_work_fn(struct work_struct *work) {}
 
 #define pm_genpd_runtime_suspend	NULL
@@ -1232,6 +1278,10 @@ int __pm_genpd_add_device(struct generic
 	if (td)
 		gpd_data->td = *td;
 
+	gpd_data->td.constraint_changed = true;
+	gpd_data->nb.notifier_call = genpd_dev_pm_qos_notifier;
+	dev_pm_qos_add_notifier(dev, &gpd_data->nb);
+
  out:
 	genpd_release_lock(genpd);
 
@@ -1294,14 +1344,18 @@ int pm_genpd_remove_device(struct generi
 	}
 
 	list_for_each_entry(pdd, &genpd->dev_list, list_node) {
+		struct generic_pm_domain_data *gpd_data;
+
 		if (pdd->dev != dev)
 			continue;
 
+		gpd_data = to_gpd_data(pdd);
+		dev_pm_qos_remove_notifier(dev, &gpd_data->nb);
 		list_del_init(&pdd->list_node);
 		pdd->dev = NULL;
 		dev_pm_put_subsys_data(dev);
 		dev->pm_domain = NULL;
-		kfree(to_gpd_data(pdd));
+		kfree(gpd_data);
 
 		genpd->device_count--;
 
@@ -1678,6 +1732,7 @@ void pm_genpd_init(struct generic_pm_dom
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
@@ -46,11 +46,25 @@ static int dev_update_qos_constraint(str
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
+	td->constraint_changed = false;
+	td->cached_stop_ok = false;
+	constraint_ns = __dev_pm_qos_read_value(dev);
+
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
 	if (constraint_ns < 0)
 		return false;
 
@@ -69,11 +83,13 @@ bool default_stop_ok(struct device *dev)
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
@@ -90,6 +106,24 @@ static bool default_power_down_ok(struct
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
+		genpd->max_off_time_changed = false;
+		genpd->cached_power_down_ok = false;
+	} else {
+		return genpd->cached_power_down_ok;
+	}
+
 	off_on_time_ns = genpd->power_off_latency_ns +
 				genpd->power_on_latency_ns;
 	/*
@@ -165,6 +199,8 @@ static bool default_power_down_ok(struct
 			min_dev_off_time_ns = constraint_ns;
 	}
 
+	genpd->cached_power_down_ok = true;
+
 	/*
 	 * If the computed minimum device off time is negative, there are no
 	 * latency constraints, so the domain can spend arbitrary time in the

