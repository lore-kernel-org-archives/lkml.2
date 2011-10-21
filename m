Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1JUXJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 19:09:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54898 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab1JUXJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 19:09:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 1/2] PM / Domains: Add device stop governor function (v2)
Date: Sat, 22 Oct 2011 01:10:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201110220109.52991.rjw@sisk.pl>
In-Reply-To: <201110220109.52991.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110220110.36832.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add a function deciding whether or not devices should be
stopped in pm_genpd_runtime_suspend() depending on their
PM QoS values.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c   |    4 ++-
 drivers/base/power/Makefile          |    2 -
 drivers/base/power/domain.c          |   29 ++++++++++++++++++----
 drivers/base/power/domain_governor.c |   40 +++++++++++++++++++++++++++++++
 include/linux/pm_domain.h            |   45 +++++++++++++++++++++++++++++++----
 5 files changed, 109 insertions(+), 11 deletions(-)

Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -21,6 +21,7 @@ enum gpd_status {
 
 struct dev_power_governor {
 	bool (*power_down_ok)(struct dev_pm_domain *domain);
+	bool (*stop_ok)(struct device *dev);
 };
 
 struct generic_pm_domain {
@@ -62,8 +63,13 @@ struct gpd_link {
 	struct list_head slave_node;
 };
 
+struct gpd_gov_dev_data {
+	s64 break_even_ns;
+};
+
 struct generic_pm_domain_data {
 	struct pm_domain_data base;
+	struct gpd_gov_dev_data *gov_data;
 	bool need_restore;
 };
 
@@ -73,8 +79,19 @@ static inline struct generic_pm_domain_d
 }
 
 #ifdef CONFIG_PM_GENERIC_DOMAINS
-extern int pm_genpd_add_device(struct generic_pm_domain *genpd,
-			       struct device *dev);
+extern struct dev_power_governor simple_qos_governor;
+
+extern struct generic_pm_domain *dev_to_genpd(struct device *dev);
+extern int __pm_genpd_add_device(struct generic_pm_domain *genpd,
+				 struct device *dev,
+				 struct gpd_gov_dev_data *gov_data);
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
@@ -83,8 +100,23 @@ extern int pm_genpd_remove_subdomain(str
 				     struct generic_pm_domain *target);
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
+					struct gpd_gov_dev_data *gov_data)
+{
+	return -ENOSYS;
+}
 static inline int pm_genpd_add_device(struct generic_pm_domain *genpd,
 				      struct device *dev)
 {
@@ -105,12 +137,17 @@ static inline int pm_genpd_remove_subdom
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
 
 #ifdef CONFIG_PM_GENERIC_DOMAINS_RUNTIME
Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -21,7 +21,7 @@ static DEFINE_MUTEX(gpd_list_lock);
 
 #ifdef CONFIG_PM
 
-static struct generic_pm_domain *dev_to_genpd(struct device *dev)
+struct generic_pm_domain *dev_to_genpd(struct device *dev)
 {
 	if (IS_ERR_OR_NULL(dev->pm_domain))
 		return ERR_PTR(-EINVAL);
@@ -403,6 +403,22 @@ static void genpd_power_off_work_fn(stru
 }
 
 /**
+ * genpd_stop_dev - Stop a given device if that's beneficial.
+ * @genpd: PM domain the device belongs to.
+ * @dev: Device to stop.
+ */
+static int genpd_stop_dev(struct generic_pm_domain *genpd, struct device *dev)
+{
+	bool (*stop_ok)(struct device *dev);
+
+	stop_ok = genpd->gov ? genpd->gov->stop_ok : NULL;
+	if (stop_ok && !stop_ok(dev))
+		return -EBUSY;
+
+	return genpd->stop_device(dev);
+}
+
+/**
  * pm_genpd_runtime_suspend - Suspend a device belonging to I/O PM domain.
  * @dev: Device to suspend.
  *
@@ -423,7 +439,7 @@ static int pm_genpd_runtime_suspend(stru
 	might_sleep_if(!genpd->dev_irq_safe);
 
 	if (genpd->stop_device) {
-		int ret = genpd->stop_device(dev);
+		int ret = genpd_stop_dev(genpd, dev);
 		if (ret)
 			return ret;
 	}
@@ -495,7 +511,7 @@ static int pm_genpd_runtime_resume(struc
 		mutex_lock(&genpd->lock);
 	}
 	finish_wait(&genpd->status_wait_queue, &wait);
-	__pm_genpd_restore_device(dev->power.subsys_data->domain_data, genpd);
+	__pm_genpd_restore_device(dev_to_psd(dev)->domain_data, genpd);
 	genpd->resume_count--;
 	genpd_set_active(genpd);
 	wake_up_all(&genpd->status_wait_queue);
@@ -1076,11 +1092,13 @@ static void pm_genpd_complete(struct dev
 #endif /* CONFIG_PM_SLEEP */
 
 /**
- * pm_genpd_add_device - Add a device to an I/O PM domain.
+ * __pm_genpd_add_device - Add a device to an I/O PM domain.
  * @genpd: PM domain to add the device to.
  * @dev: Device to be added.
+ * @gov_data: Set of PM QoS parameters to attach to the device.
  */
-int pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev)
+int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
+			  struct gpd_gov_dev_data *gov_data)
 {
 	struct generic_pm_domain_data *gpd_data;
 	struct pm_domain_data *pdd;
@@ -1123,6 +1141,7 @@ int pm_genpd_add_device(struct generic_p
 	gpd_data->base.dev = dev;
 	gpd_data->need_restore = false;
 	list_add_tail(&gpd_data->base.list_node, &genpd->dev_list);
+	gpd_data->gov_data = gov_data;
 
  out:
 	genpd_release_lock(genpd);
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
@@ -0,0 +1,40 @@
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
+bool default_stop_ok(struct device *dev)
+{
+	struct gpd_gov_dev_data *gov_data;
+	s64 constraint_ns;
+	s32 constraint;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	gov_data = to_gpd_data(dev_to_psd(dev)->domain_data)->gov_data;
+	if (!gov_data)
+		return true;
+
+	constraint = dev_pm_qos_read_value(dev);
+	if (constraint < 0)
+		return false;
+	else if (constraint == 0) /* 0 means "don't care" */
+		return true;
+
+	constraint_ns = constraint;
+	constraint_ns *= NSEC_PER_USEC;
+
+	return constraint_ns > gov_data->break_even_ns;
+}
+
+struct dev_power_governor simple_qos_governor = {
+	.stop_ok = default_stop_ok,
+};
Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -161,13 +161,15 @@ static bool sh7372_power_down_forbidden(
 
 struct dev_power_governor sh7372_always_on_gov = {
 	.power_down_ok = sh7372_power_down_forbidden,
+	.stop_ok = default_stop_ok,
 };
 
 void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd)
 {
 	struct generic_pm_domain *genpd = &sh7372_pd->genpd;
+	struct dev_power_governor *gov = sh7372_pd->gov;
 
-	pm_genpd_init(genpd, sh7372_pd->gov, false);
+	pm_genpd_init(genpd, gov ? : &simple_qos_governor, false);
 	genpd->stop_device = pm_clk_suspend;
 	genpd->start_device = pm_clk_resume;
 	genpd->dev_irq_safe = true;

