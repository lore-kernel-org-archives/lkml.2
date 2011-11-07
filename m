Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1KGAKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 19:10:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53716 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706Ab1KGAIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 19:08:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/7] PM / Domains: Make it possible to use per-device .active_wakeup()
Date: Mon, 7 Nov 2011 01:06:52 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Kevin Hilman <khilman@ti.com>, jean.pihet@newoldbits.com
References: <201111070101.33960.rjw@sisk.pl>
In-Reply-To: <201111070101.33960.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111070106.52411.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The current generic PM domains code requires that the same
.active_wakeup() device callback routine be used for all devices in
the given domain, which is inflexible and may not cover some specific
use cases.  For this reason, make it possible to use device specific
.active_wakeup() callback routines by adding a corresponding callback
pointer to struct generic_pm_domain_data.  To reduce code duplication
use struct gpd_dev_ops to represent PM domain device callbacks as
well as device-specific ones and add a macro for defining routines
that will execute those callbacks.

Modify the shmobile's power domains code to allow drivers to use
their own .active_wakeup() callback routines.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c |   11 ++++---
 drivers/base/power/domain.c        |   54 ++++++++++++++++++-------------------
 include/linux/pm_domain.h          |   15 ++++------
 3 files changed, 41 insertions(+), 39 deletions(-)

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
@@ -62,11 +66,6 @@ struct gpd_link {
 	struct list_head slave_node;
 };
 
-struct gpd_dev_ops {
-	int (*start)(struct device *dev);
-	int (*stop)(struct device *dev);
-};
-
 struct generic_pm_domain_data {
 	struct pm_domain_data base;
 	struct gpd_dev_ops ops;
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -16,6 +16,22 @@
 #include <linux/sched.h>
 #include <linux/suspend.h>
 
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
+
 static LIST_HEAD(gpd_list);
 static DEFINE_MUTEX(gpd_list_lock);
 
@@ -31,32 +47,12 @@ static struct generic_pm_domain *dev_to_
 
 static int genpd_stop_dev(struct generic_pm_domain *genpd, struct device *dev)
 {
-	int (*stop)(struct device *dev);
-
-	stop = genpd->stop_device;
-	if (stop)
-		return stop(dev);
-
-	stop = dev_gpd_data(dev)->ops.stop;
-	if (stop)
-		return stop(dev);
-
-	return 0;
+	return GENPD_DEV_CALLBACK(genpd, int, stop, dev);
 }
 
 static int genpd_start_dev(struct generic_pm_domain *genpd, struct device *dev)
 {
-	int (*start)(struct device *dev);
-
-	start = genpd->start_device;
-	if (start)
-		return start(dev);
-
-	start = dev_gpd_data(dev)->ops.start;
-	if (start)
-		return start(dev);
-
-	return 0;
+	return GENPD_DEV_CALLBACK(genpd, int, start, dev);
 }
 
 static bool genpd_sd_counter_dec(struct generic_pm_domain *genpd)
@@ -554,6 +550,12 @@ static inline void genpd_power_off_work_
 
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
@@ -610,7 +612,7 @@ static bool resume_needed(struct device
 	if (!device_can_wakeup(dev))
 		return false;
 
-	active_wakeup = genpd->active_wakeup && genpd->active_wakeup(dev);
+	active_wakeup = genpd_dev_active_wakeup(genpd, dev);
 	return device_may_wakeup(dev) ? active_wakeup : !active_wakeup;
 }
 
@@ -734,8 +736,7 @@ static int pm_genpd_suspend_noirq(struct
 	if (ret)
 		return ret;
 
-	if (dev->power.wakeup_path
-	    && genpd->active_wakeup && genpd->active_wakeup(dev))
+	if (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev))
 		return 0;
 
 	genpd_stop_dev(genpd, dev);
@@ -954,8 +955,7 @@ static int pm_genpd_dev_poweroff_noirq(s
 	if (ret)
 		return ret;
 
-	if (dev->power.wakeup_path
-	    && genpd->active_wakeup && genpd->active_wakeup(dev))
+	if (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev))
 		return 0;
 
 	genpd_stop_dev(genpd, dev);
Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -151,7 +151,10 @@ static void sh7372_a4r_suspend(void)
 
 static bool pd_active_wakeup(struct device *dev)
 {
-	return true;
+	bool (*active_wakeup)(struct device *dev);
+
+	active_wakeup = dev_gpd_data(dev)->ops.active_wakeup;
+	return active_wakeup ? active_wakeup(dev) : true;
 }
 
 static bool sh7372_power_down_forbidden(struct dev_pm_domain *domain)
@@ -197,10 +200,10 @@ void sh7372_init_pm_domain(struct sh7372
 	struct generic_pm_domain *genpd = &sh7372_pd->genpd;
 
 	pm_genpd_init(genpd, sh7372_pd->gov, false);
-	genpd->stop_device = sh7372_stop_dev;
-	genpd->start_device = sh7372_start_dev;
+	genpd->dev_ops.stop = sh7372_stop_dev;
+	genpd->dev_ops.start = sh7372_start_dev;
+	genpd->dev_ops.active_wakeup = pd_active_wakeup;
 	genpd->dev_irq_safe = true;
-	genpd->active_wakeup = pd_active_wakeup;
 	genpd->power_off = pd_power_down;
 	genpd->power_on = pd_power_up;
 	genpd->power_on(&sh7372_pd->genpd);

