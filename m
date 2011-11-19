Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1KSOAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 09:00:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47356 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab1KSOA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 09:00:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [Update 2x][PATCH 1/7] PM / Domains: Make it possible to use per-device domain callbacks
Date: Sat, 19 Nov 2011 14:58:04 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kevin Hilman <khilman@ti.com>, jean.pihet@newoldbits.com
References: <201111070101.33960.rjw@sisk.pl> <201111140122.27328.rjw@sisk.pl> <201111191456.40453.rjw@sisk.pl>
In-Reply-To: <201111191456.40453.rjw@sisk.pl>
MIME-Version: 1.0
Message-Id: <201111191458.05050.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The current generic PM domains code requires that the same .stop(),
.start() and .active_wakeup() device callback routines be used for
all devices in the given domain, which is inflexible and may not
cover some specific use cases.  For this reason, make it possible to
use device specific .start()/.stop() and .active_wakeup() callback
routines by adding corresponding callback pointers to struct
generic_pm_domain_data.  Add a new helper routine,
pm_genpd_register_callbacks(), that can be used to populate
the new per-device callback pointers.

Modify the shmobile's power domains code to allow drivers to add
their own code to be run during the device stop and start operations
with the help of the new callback pointers.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c |   40 ++++++++-
 drivers/base/power/domain.c        |  152 +++++++++++++++++++++++++++----------
 include/linux/pm_domain.h          |   27 +++++-
 3 files changed, 175 insertions(+), 44 deletions(-)

Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -23,6 +23,12 @@ struct dev_power_governor {
 	bool (*power_down_ok)(struct dev_pm_domain *domain);
 };
 
+struct gpd_dev_ops {
+	int (*start)(struct device *dev);
+	int (*stop)(struct device *dev);
+	bool (*active_wakeup)(struct device *dev);
+};
+
 struct generic_pm_domain {
 	struct dev_pm_domain domain;	/* PM domain operations */
 	struct list_head gpd_list_node;	/* Node in the global PM domains list */
@@ -45,9 +51,7 @@ struct generic_pm_domain {
 	bool dev_irq_safe;	/* Device callbacks are IRQ-safe */
 	int (*power_off)(struct generic_pm_domain *domain);
 	int (*power_on)(struct generic_pm_domain *domain);
-	int (*start_device)(struct device *dev);
-	int (*stop_device)(struct device *dev);
-	bool (*active_wakeup)(struct device *dev);
+	struct gpd_dev_ops dev_ops;
 };
 
 static inline struct generic_pm_domain *pd_to_genpd(struct dev_pm_domain *pd)
@@ -64,6 +68,7 @@ struct gpd_link {
 
 struct generic_pm_domain_data {
 	struct pm_domain_data base;
+	struct gpd_dev_ops ops;
 	bool need_restore;
 };
 
@@ -73,6 +78,11 @@ static inline struct generic_pm_domain_d
 }
 
 #ifdef CONFIG_PM_GENERIC_DOMAINS
+static inline struct generic_pm_domain_data *dev_gpd_data(struct device *dev)
+{
+	return to_gpd_data(dev->power.subsys_data->domain_data);
+}
+
 extern int pm_genpd_add_device(struct generic_pm_domain *genpd,
 			       struct device *dev);
 extern int pm_genpd_remove_device(struct generic_pm_domain *genpd,
@@ -81,6 +91,8 @@ extern int pm_genpd_add_subdomain(struct
 				  struct generic_pm_domain *new_subdomain);
 extern int pm_genpd_remove_subdomain(struct generic_pm_domain *genpd,
 				     struct generic_pm_domain *target);
+extern int pm_genpd_add_callbacks(struct device *dev, struct gpd_dev_ops *ops);
+extern int pm_genpd_remove_callbacks(struct device *dev);
 extern void pm_genpd_init(struct generic_pm_domain *genpd,
 			  struct dev_power_governor *gov, bool is_off);
 extern int pm_genpd_poweron(struct generic_pm_domain *genpd);
@@ -105,6 +117,15 @@ static inline int pm_genpd_remove_subdom
 {
 	return -ENOSYS;
 }
+static inline int pm_genpd_add_callbacks(struct device *dev,
+					 struct gpd_dev_ops *ops)
+{
+	return -ENOSYS;
+}
+static inline int pm_genpd_remove_callbacks(struct device *dev)
+{
+	return -ENOSYS;
+}
 static inline void pm_genpd_init(struct generic_pm_domain *genpd,
 				 struct dev_power_governor *gov, bool is_off) {}
 static inline int pm_genpd_poweron(struct generic_pm_domain *genpd)
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -15,6 +15,23 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 #include <linux/suspend.h>
+#include <linux/export.h>
+
+#define GENPD_DEV_CALLBACK(genpd, type, callback, dev)		\
+({								\
+	type (*__routine)(struct device *__d); 			\
+	type __ret = (type)0;					\
+								\
+	__routine = genpd->dev_ops.callback; 			\
+	if (__routine) {					\
+		__ret = __routine(dev); 			\
+	} else {						\
+		__routine = dev_gpd_data(dev)->ops.callback;	\
+		if (__routine) 					\
+			__ret = __routine(dev);			\
+	}							\
+	__ret;							\
+})
 
 static LIST_HEAD(gpd_list);
 static DEFINE_MUTEX(gpd_list_lock);
@@ -29,6 +46,16 @@ static struct generic_pm_domain *dev_to_
 	return pd_to_genpd(dev->pm_domain);
 }
 
+static int genpd_stop_dev(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, int, stop, dev);
+}
+
+static int genpd_start_dev(struct generic_pm_domain *genpd, struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, int, start, dev);
+}
+
 static bool genpd_sd_counter_dec(struct generic_pm_domain *genpd)
 {
 	bool ret = false;
@@ -199,13 +226,9 @@ static int __pm_genpd_save_device(struct
 	mutex_unlock(&genpd->lock);
 
 	if (drv && drv->pm && drv->pm->runtime_suspend) {
-		if (genpd->start_device)
-			genpd->start_device(dev);
-
+		genpd_start_dev(genpd, dev);
 		ret = drv->pm->runtime_suspend(dev);
-
-		if (genpd->stop_device)
-			genpd->stop_device(dev);
+		genpd_stop_dev(genpd, dev);
 	}
 
 	mutex_lock(&genpd->lock);
@@ -235,13 +258,9 @@ static void __pm_genpd_restore_device(st
 	mutex_unlock(&genpd->lock);
 
 	if (drv && drv->pm && drv->pm->runtime_resume) {
-		if (genpd->start_device)
-			genpd->start_device(dev);
-
+		genpd_start_dev(genpd, dev);
 		drv->pm->runtime_resume(dev);
-
-		if (genpd->stop_device)
-			genpd->stop_device(dev);
+		genpd_stop_dev(genpd, dev);
 	}
 
 	mutex_lock(&genpd->lock);
@@ -413,6 +432,7 @@ static void genpd_power_off_work_fn(stru
 static int pm_genpd_runtime_suspend(struct device *dev)
 {
 	struct generic_pm_domain *genpd;
+	int ret;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -422,11 +442,9 @@ static int pm_genpd_runtime_suspend(stru
 
 	might_sleep_if(!genpd->dev_irq_safe);
 
-	if (genpd->stop_device) {
-		int ret = genpd->stop_device(dev);
-		if (ret)
-			return ret;
-	}
+	ret = genpd_stop_dev(genpd, dev);
+	if (ret)
+		return ret;
 
 	/*
 	 * If power.irq_safe is set, this routine will be run with interrupts
@@ -502,8 +520,7 @@ static int pm_genpd_runtime_resume(struc
 	mutex_unlock(&genpd->lock);
 
  out:
-	if (genpd->start_device)
-		genpd->start_device(dev);
+	genpd_start_dev(genpd, dev);
 
 	return 0;
 }
@@ -534,6 +551,12 @@ static inline void genpd_power_off_work_
 
 #ifdef CONFIG_PM_SLEEP
 
+static bool genpd_dev_active_wakeup(struct generic_pm_domain *genpd,
+				    struct device *dev)
+{
+	return GENPD_DEV_CALLBACK(genpd, bool, active_wakeup, dev);
+}
+
 /**
  * pm_genpd_sync_poweroff - Synchronously power off a PM domain and its masters.
  * @genpd: PM domain to power off, if possible.
@@ -590,7 +613,7 @@ static bool resume_needed(struct device
 	if (!device_can_wakeup(dev))
 		return false;
 
-	active_wakeup = genpd->active_wakeup && genpd->active_wakeup(dev);
+	active_wakeup = genpd_dev_active_wakeup(genpd, dev);
 	return device_may_wakeup(dev) ? active_wakeup : !active_wakeup;
 }
 
@@ -646,7 +669,7 @@ static int pm_genpd_prepare(struct devic
 	/*
 	 * The PM domain must be in the GPD_STATE_ACTIVE state at this point,
 	 * so pm_genpd_poweron() will return immediately, but if the device
-	 * is suspended (e.g. it's been stopped by .stop_device()), we need
+	 * is suspended (e.g. it's been stopped by genpd_stop_dev()), we need
 	 * to make it operational.
 	 */
 	pm_runtime_resume(dev);
@@ -714,12 +737,10 @@ static int pm_genpd_suspend_noirq(struct
 	if (ret)
 		return ret;
 
-	if (dev->power.wakeup_path
-	    && genpd->active_wakeup && genpd->active_wakeup(dev))
+	if (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev))
 		return 0;
 
-	if (genpd->stop_device)
-		genpd->stop_device(dev);
+	genpd_stop_dev(genpd, dev);
 
 	/*
 	 * Since all of the "noirq" callbacks are executed sequentially, it is
@@ -761,8 +782,7 @@ static int pm_genpd_resume_noirq(struct
 	 */
 	pm_genpd_poweron(genpd);
 	genpd->suspended_count--;
-	if (genpd->start_device)
-		genpd->start_device(dev);
+	genpd_start_dev(genpd, dev);
 
 	return pm_generic_resume_noirq(dev);
 }
@@ -836,8 +856,7 @@ static int pm_genpd_freeze_noirq(struct
 	if (ret)
 		return ret;
 
-	if (genpd->stop_device)
-		genpd->stop_device(dev);
+	genpd_stop_dev(genpd, dev);
 
 	return 0;
 }
@@ -864,8 +883,7 @@ static int pm_genpd_thaw_noirq(struct de
 	if (genpd->suspend_power_off)
 		return 0;
 
-	if (genpd->start_device)
-		genpd->start_device(dev);
+	genpd_start_dev(genpd, dev);
 
 	return pm_generic_thaw_noirq(dev);
 }
@@ -938,12 +956,10 @@ static int pm_genpd_dev_poweroff_noirq(s
 	if (ret)
 		return ret;
 
-	if (dev->power.wakeup_path
-	    && genpd->active_wakeup && genpd->active_wakeup(dev))
+	if (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev))
 		return 0;
 
-	if (genpd->stop_device)
-		genpd->stop_device(dev);
+	genpd_stop_dev(genpd, dev);
 
 	/*
 	 * Since all of the "noirq" callbacks are executed sequentially, it is
@@ -993,8 +1009,7 @@ static int pm_genpd_restore_noirq(struct
 
 	pm_genpd_poweron(genpd);
 	genpd->suspended_count--;
-	if (genpd->start_device)
-		genpd->start_device(dev);
+	genpd_start_dev(genpd, dev);
 
 	return pm_generic_restore_noirq(dev);
 }
@@ -1280,6 +1295,69 @@ int pm_genpd_remove_subdomain(struct gen
 }
 
 /**
+ * pm_genpd_add_callbacks - Add PM domain callbacks to a given device.
+ * @dev: Device to add the callbacks to.
+ * @ops: Set of callbacks to add.
+ */
+int pm_genpd_add_callbacks(struct device *dev, struct gpd_dev_ops *ops)
+{
+	struct pm_domain_data *pdd;
+	int ret = 0;
+
+	if (!(dev && dev->power.subsys_data && ops))
+		return -EINVAL;
+
+	pm_runtime_disable(dev);
+	device_pm_lock();
+
+	pdd = dev->power.subsys_data->domain_data;
+	if (pdd) {
+		struct generic_pm_domain_data *gpd_data = to_gpd_data(pdd);
+
+		gpd_data->ops = *ops;
+	} else {
+		ret = -EINVAL;
+	}
+
+	device_pm_unlock();
+	pm_runtime_enable(dev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pm_genpd_add_callbacks);
+
+/**
+ * pm_genpd_remove_callbacks - Remove PM domain callbacks from a given device.
+ * @dev: Device to remove the callbacks from.
+ */
+int pm_genpd_remove_callbacks(struct device *dev)
+{
+	struct pm_domain_data *pdd;
+	int ret = 0;
+
+	if (!(dev && dev->power.subsys_data))
+		return -EINVAL;
+
+	pm_runtime_disable(dev);
+	device_pm_lock();
+
+	pdd = dev->power.subsys_data->domain_data;
+	if (pdd) {
+		struct generic_pm_domain_data *gpd_data = to_gpd_data(pdd);
+
+		gpd_data->ops = (struct gpd_dev_ops){ 0 };
+	} else {
+		ret = -EINVAL;
+	}
+
+	device_pm_unlock();
+	pm_runtime_enable(dev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pm_genpd_remove_callbacks);
+
+/**
  * pm_genpd_init - Initialize a generic I/O PM domain object.
  * @genpd: PM domain object to initialize.
  * @gov: PM domain governor to associate with the domain (may be NULL).
Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -156,7 +156,10 @@ static void sh7372_a4r_suspend(void)
 
 static bool pd_active_wakeup(struct device *dev)
 {
-	return true;
+	bool (*active_wakeup)(struct device *dev);
+
+	active_wakeup = dev_gpd_data(dev)->ops.active_wakeup;
+	return active_wakeup ? active_wakeup(dev) : true;
 }
 
 static bool sh7372_power_down_forbidden(struct dev_pm_domain *domain)
@@ -168,15 +171,44 @@ struct dev_power_governor sh7372_always_
 	.power_down_ok = sh7372_power_down_forbidden,
 };
 
+static int sh7372_stop_dev(struct device *dev)
+{
+	int (*stop)(struct device *dev);
+
+	stop = dev_gpd_data(dev)->ops.stop;
+	if (stop) {
+		int ret = stop(dev);
+		if (ret)
+			return ret;
+	}
+	return pm_clk_suspend(dev);
+}
+
+static int sh7372_start_dev(struct device *dev)
+{
+	int (*start)(struct device *dev);
+	int ret;
+
+	ret = pm_clk_resume(dev);
+	if (ret)
+		return ret;
+
+	start = dev_gpd_data(dev)->ops.start;
+	if (start)
+		ret = start(dev);
+
+	return ret;
+}
+
 void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd)
 {
 	struct generic_pm_domain *genpd = &sh7372_pd->genpd;
 
 	pm_genpd_init(genpd, sh7372_pd->gov, false);
-	genpd->stop_device = pm_clk_suspend;
-	genpd->start_device = pm_clk_resume;
+	genpd->dev_ops.stop = sh7372_stop_dev;
+	genpd->dev_ops.start = sh7372_start_dev;
+	genpd->dev_ops.active_wakeup = pd_active_wakeup;
 	genpd->dev_irq_safe = true;
-	genpd->active_wakeup = pd_active_wakeup;
 	genpd->power_off = pd_power_down;
 	genpd->power_on = pd_power_up;
 	__pd_power_up(sh7372_pd, false);
