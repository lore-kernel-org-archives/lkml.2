Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab1KNA0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:26:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38040 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914Ab1KNA0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:26:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [update][PATCH 5/7] PM / Domains: Add device stop governor function (v4)
Date: Mon, 14 Nov 2011 01:27:05 +0100
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
Message-Id: <201111140127.05734.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add a function deciding whether or not devices should be stopped in
pm_genpd_runtime_suspend() depending on their PM QoS constraints
and stop/start timing values.  Make it possible to add information
used by this function to device objects.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c   |    4 +-
 drivers/base/power/Makefile          |    2 -
 drivers/base/power/domain.c          |   33 ++++++++++++++----
 drivers/base/power/domain_governor.c |   33 ++++++++++++++++++
 include/linux/pm_domain.h            |   63 ++++++++++++++++++++++++++++++-----
 5 files changed, 118 insertions(+), 17 deletions(-)

Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -21,6 +21,7 @@ enum gpd_status {
 
 struct dev_power_governor {
 	bool (*power_down_ok)(struct dev_pm_domain *domain);
+	bool (*stop_ok)(struct device *dev);
 };
 
 struct gpd_dev_ops {
@@ -72,9 +73,16 @@ struct gpd_link {
 	struct list_head slave_node;
 };
 
+struct gpd_timing_data {
+	s64 stop_latency_ns;
+	s64 start_latency_ns;
+	s64 break_even_ns;
+};
+
 struct generic_pm_domain_data {
 	struct pm_domain_data base;
 	struct gpd_dev_ops ops;
+	struct gpd_timing_data td;
 	bool need_restore;
 };
 
@@ -89,20 +97,48 @@ static inline struct generic_pm_domain_d
 }
 
 #ifdef CONFIG_PM_GENERIC_DOMAINS
-extern int pm_genpd_add_device(struct generic_pm_domain *genpd,
-			       struct device *dev);
+extern struct dev_power_governor simple_qos_governor;
+
+extern struct generic_pm_domain *dev_to_genpd(struct device *dev);
+extern int __pm_genpd_add_device(struct generic_pm_domain *genpd,
+				 struct device *dev,
+				 struct gpd_timing_data *td);
+
+static inline int pm_genpd_add_device(struct generic_pm_domain *genpd,
+				      struct device *dev)
+{
+	return __pm_genpd_add_device(genpd, dev, NULL);
+}
+
 extern int pm_genpd_remove_device(struct generic_pm_domain *genpd,
 				  struct device *dev);
 extern int pm_genpd_add_subdomain(struct generic_pm_domain *genpd,
 				  struct generic_pm_domain *new_subdomain);
 extern int pm_genpd_remove_subdomain(struct generic_pm_domain *genpd,
 				     struct generic_pm_domain *target);
-extern int pm_genpd_add_callbacks(struct device *dev, struct gpd_dev_ops *ops);
-extern int pm_genpd_remove_callbacks(struct device *dev);
+extern int pm_genpd_add_callbacks(struct device *dev,
+				  struct gpd_dev_ops *ops,
+				  struct gpd_timing_data *td);
+extern int __pm_genpd_remove_callbacks(struct device *dev, bool clear_td);
 extern void pm_genpd_init(struct generic_pm_domain *genpd,
 			  struct dev_power_governor *gov, bool is_off);
+
 extern int pm_genpd_poweron(struct generic_pm_domain *genpd);
+
+extern bool default_stop_ok(struct device *dev);
+
 #else
+
+static inline struct generic_pm_domain *dev_to_genpd(struct device *dev)
+{
+	return ERR_PTR(-ENOSYS);
+}
+static inline int __pm_genpd_add_device(struct generic_pm_domain *genpd,
+					struct device *dev,
+					struct gpd_timing_data *td)
+{
+	return -ENOSYS;
+}
 static inline int pm_genpd_add_device(struct generic_pm_domain *genpd,
 				      struct device *dev)
 {
@@ -124,22 +160,33 @@ static inline int pm_genpd_remove_subdom
 	return -ENOSYS;
 }
 static inline int pm_genpd_add_callbacks(struct device *dev,
-					 struct gpd_dev_ops *ops)
+					 struct gpd_dev_ops *ops,
+					 struct gpd_timing_data *td)
 {
 	return -ENOSYS;
 }
-static inline int pm_genpd_remove_callbacks(struct device *dev)
+static inline int __pm_genpd_remove_callbacks(struct device *dev, bool clear_td)
 {
 	return -ENOSYS;
 }
-static inline void pm_genpd_init(struct generic_pm_domain *genpd,
-				 struct dev_power_governor *gov, bool is_off) {}
+static inline void pm_genpd_init(struct generic_pm_domain *genpd, bool is_off)
+{
+}
 static inline int pm_genpd_poweron(struct generic_pm_domain *genpd)
 {
 	return -ENOSYS;
 }
+static inline bool default_stop_ok(struct device *dev)
+{
+	return false;
+}
 #endif
 
+static inline int pm_genpd_remove_callbacks(struct device *dev)
+{
+	return __pm_genpd_remove_callbacks(dev, true);
+}
+
 #ifdef CONFIG_PM_GENERIC_DOMAINS_RUNTIME
 extern void genpd_queue_power_off_work(struct generic_pm_domain *genpd);
 extern void pm_genpd_poweroff_unused(void);
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -38,7 +38,7 @@ static DEFINE_MUTEX(gpd_list_lock);
 
 #ifdef CONFIG_PM
 
-static struct generic_pm_domain *dev_to_genpd(struct device *dev)
+struct generic_pm_domain *dev_to_genpd(struct device *dev)
 {
 	if (IS_ERR_OR_NULL(dev->pm_domain))
 		return ERR_PTR(-EINVAL);
@@ -436,6 +436,7 @@ static void genpd_power_off_work_fn(stru
 static int pm_genpd_runtime_suspend(struct device *dev)
 {
 	struct generic_pm_domain *genpd;
+	bool (*stop_ok)(struct device *__dev);
 	int ret;
 
 	dev_dbg(dev, "%s()\n", __func__);
@@ -446,10 +447,17 @@ static int pm_genpd_runtime_suspend(stru
 
 	might_sleep_if(!genpd->dev_irq_safe);
 
+	stop_ok = genpd->gov ? genpd->gov->stop_ok : NULL;
+	if (stop_ok && !stop_ok(dev))
+		return -EBUSY;
+
 	ret = genpd_stop_dev(genpd, dev);
 	if (ret)
 		return ret;
 
+	pm_runtime_update_max_time_suspended(dev,
+				dev_gpd_data(dev)->td.start_latency_ns);
+
 	/*
 	 * If power.irq_safe is set, this routine will be run with interrupts
 	 * off, so it can't use mutexes.
@@ -1022,11 +1030,13 @@ static void pm_genpd_complete(struct dev
 #endif /* CONFIG_PM_SLEEP */
 
 /**
- * pm_genpd_add_device - Add a device to an I/O PM domain.
+ * __pm_genpd_add_device - Add a device to an I/O PM domain.
  * @genpd: PM domain to add the device to.
  * @dev: Device to be added.
+ * @td: Set of PM QoS timing parameters to attach to the device.
  */
-int pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev)
+int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
+			  struct gpd_timing_data *td)
 {
 	struct generic_pm_domain_data *gpd_data;
 	struct pm_domain_data *pdd;
@@ -1069,6 +1079,8 @@ int pm_genpd_add_device(struct generic_p
 	gpd_data->base.dev = dev;
 	gpd_data->need_restore = false;
 	list_add_tail(&gpd_data->base.list_node, &genpd->dev_list);
+	if (td)
+		gpd_data->td = *td;
 
  out:
 	genpd_release_lock(genpd);
@@ -1229,8 +1241,10 @@ int pm_genpd_remove_subdomain(struct gen
  * pm_genpd_add_callbacks - Add PM domain callbacks to a given device.
  * @dev: Device to add the callbacks to.
  * @ops: Set of callbacks to add.
+ * @td: Timing data to add to the device along with the callbacks (optional).
  */
-int pm_genpd_add_callbacks(struct device *dev, struct gpd_dev_ops *ops)
+int pm_genpd_add_callbacks(struct device *dev, struct gpd_dev_ops *ops,
+			   struct gpd_timing_data *td)
 {
 	struct pm_domain_data *pdd;
 	int ret = 0;
@@ -1246,6 +1260,8 @@ int pm_genpd_add_callbacks(struct device
 		struct generic_pm_domain_data *gpd_data = to_gpd_data(pdd);
 
 		gpd_data->ops = *ops;
+		if (td)
+			gpd_data->td = *td;
 	} else {
 		ret = -EINVAL;
 	}
@@ -1258,10 +1274,11 @@ int pm_genpd_add_callbacks(struct device
 EXPORT_SYMBOL_GPL(pm_genpd_add_callbacks);
 
 /**
- * pm_genpd_remove_callbacks - Remove PM domain callbacks from a given device.
+ * __pm_genpd_remove_callbacks - Remove PM domain callbacks from a given device.
  * @dev: Device to remove the callbacks from.
+ * @clear_td: If set, clear the device's timing data too.
  */
-int pm_genpd_remove_callbacks(struct device *dev)
+int __pm_genpd_remove_callbacks(struct device *dev, bool clear_td)
 {
 	struct pm_domain_data *pdd;
 	int ret = 0;
@@ -1277,6 +1294,8 @@ int pm_genpd_remove_callbacks(struct dev
 		struct generic_pm_domain_data *gpd_data = to_gpd_data(pdd);
 
 		gpd_data->ops = (struct gpd_dev_ops){ 0 };
+		if (clear_td)
+			gpd_data->td = (struct gpd_timing_data){ 0 };
 	} else {
 		ret = -EINVAL;
 	}
@@ -1286,7 +1305,7 @@ int pm_genpd_remove_callbacks(struct dev
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(pm_genpd_remove_callbacks);
+EXPORT_SYMBOL_GPL(__pm_genpd_remove_callbacks);
 
 /* Default device callbacks for generic PM domains. */
 
Index: linux/drivers/base/power/Makefile
===================================================================
--- linux.orig/drivers/base/power/Makefile
+++ linux/drivers/base/power/Makefile
@@ -3,7 +3,7 @@ obj-$(CONFIG_PM_SLEEP)	+= main.o wakeup.
 obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
 obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
 obj-$(CONFIG_PM_OPP)	+= opp.o
-obj-$(CONFIG_PM_GENERIC_DOMAINS)	+=  domain.o
+obj-$(CONFIG_PM_GENERIC_DOMAINS)	+=  domain.o domain_governor.o
 obj-$(CONFIG_HAVE_CLK)	+= clock_ops.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
Index: linux/drivers/base/power/domain_governor.c
===================================================================
--- /dev/null
+++ linux/drivers/base/power/domain_governor.c
@@ -0,0 +1,33 @@
+/*
+ * drivers/base/power/domain_governor.c - Governors for device PM domains.
+ *
+ * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/pm_domain.h>
+#include <linux/pm_qos.h>
+
+/**
+ * default_stop_ok - Default PM domain governor routine for stopping devices.
+ * @dev: Device to check.
+ */
+bool default_stop_ok(struct device *dev)
+{
+	struct gpd_timing_data *td = &dev_gpd_data(dev)->td;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (dev->power.max_time_suspended_ns < 0 || td->break_even_ns == 0)
+		return true;
+
+	return td->stop_latency_ns + td->start_latency_ns < td->break_even_ns
+		&& td->break_even_ns < dev->power.max_time_suspended_ns;
+}
+
+struct dev_power_governor simple_qos_governor = {
+	.stop_ok = default_stop_ok,
+};
Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -169,6 +169,7 @@ static bool sh7372_power_down_forbidden(
 
 struct dev_power_governor sh7372_always_on_gov = {
 	.power_down_ok = sh7372_power_down_forbidden,
+	.stop_ok = default_stop_ok,
 };
 
 static int sh7372_stop_dev(struct device *dev)
@@ -203,8 +204,9 @@ static int sh7372_start_dev(struct devic
 void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd)
 {
 	struct generic_pm_domain *genpd = &sh7372_pd->genpd;
+	struct dev_power_governor *gov = sh7372_pd->gov;
 
-	pm_genpd_init(genpd, sh7372_pd->gov, false);
+	pm_genpd_init(genpd, gov ? : &simple_qos_governor, false);
 	genpd->dev_ops.stop = sh7372_stop_dev;
 	genpd->dev_ops.start = sh7372_start_dev;
 	genpd->dev_ops.active_wakeup = pd_active_wakeup;

