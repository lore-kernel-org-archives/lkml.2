Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1H3WVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:21:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49750 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab1H3WVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:21:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 4/5] PM / Domains: Add device stop governor function
Date: Wed, 31 Aug 2011 00:21:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        jean.pihet@newoldbits.com
References: <201108310017.03103.rjw@sisk.pl>
In-Reply-To: <201108310017.03103.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108310021.59324.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add a function deciding whether or not devices should be
stopped in pm_genpd_runtime_suspend() depending on their
PM QoS values.

---
 arch/arm/mach-shmobile/pm-sh7372.c   |    2 -
 drivers/base/power/Makefile          |    2 -
 drivers/base/power/domain.c          |   35 ++++++++++++++++++-----
 drivers/base/power/domain_governor.c |   40 ++++++++++++++++++++++++++
 include/linux/pm_domain.h            |   52 ++++++++++++++++++++++++++++++-----
 5 files changed, 115 insertions(+), 16 deletions(-)

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
 
@@ -73,18 +79,47 @@ static inline struct generic_pm_domain_d
 }
 
 #ifdef CONFIG_PM_GENERIC_DOMAINS
-extern int pm_genpd_add_device(struct generic_pm_domain *genpd,
-			       struct device *dev);
+extern struct dev_power_governor default_qos_governor;
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
 				  struct generic_pm_domain *new_subdomain);
 extern int pm_genpd_remove_subdomain(struct generic_pm_domain *genpd,
 				     struct generic_pm_domain *target);
-extern void pm_genpd_init(struct generic_pm_domain *genpd,
-			  struct dev_power_governor *gov, bool is_off);
+extern void __pm_genpd_init(struct generic_pm_domain *genpd,
+			    struct dev_power_governor *gov, bool is_off);
+
+static inline void pm_genpd_init(struct generic_pm_domain *genpd, bool is_off)
+{
+	__pm_genpd_init(genpd, &default_qos_governor, is_off);
+}
+
 extern int pm_genpd_poweron(struct generic_pm_domain *genpd);
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
@@ -105,8 +140,13 @@ static inline int pm_genpd_remove_subdom
 {
 	return -ENOSYS;
 }
-static inline void pm_genpd_init(struct generic_pm_domain *genpd,
-				 struct dev_power_governor *gov, bool is_off) {}
+static inline void __pm_genpd_init(struct generic_pm_domain *genpd,
+				   struct dev_power_governor *gov, bool is_off)
+{
+}
+static inline void pm_genpd_init(struct generic_pm_domain *genpd, bool is_off)
+{
+}
 static inline int pm_genpd_poweron(struct generic_pm_domain *genpd)
 {
 	return -ENOSYS;
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
@@ -1280,13 +1299,13 @@ int pm_genpd_remove_subdomain(struct gen
 }
 
 /**
- * pm_genpd_init - Initialize a generic I/O PM domain object.
+ * __pm_genpd_init - Initialize a generic I/O PM domain object.
  * @genpd: PM domain object to initialize.
  * @gov: PM domain governor to associate with the domain (may be NULL).
  * @is_off: Initial value of the domain's power_is_off field.
  */
-void pm_genpd_init(struct generic_pm_domain *genpd,
-		   struct dev_power_governor *gov, bool is_off)
+void __pm_genpd_init(struct generic_pm_domain *genpd,
+		     struct dev_power_governor *gov, bool is_off)
 {
 	if (IS_ERR_OR_NULL(genpd))
 		return;
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
+static bool default_stop_ok(struct device *dev)
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
+struct dev_power_governor default_qos_governor = {
+	.stop_ok = default_stop_ok,
+};
Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -100,7 +100,7 @@ void sh7372_init_pm_domain(struct sh7372
 {
 	struct generic_pm_domain *genpd = &sh7372_pd->genpd;
 
-	pm_genpd_init(genpd, NULL, false);
+	pm_genpd_init(genpd, false);
 	genpd->stop_device = pm_clk_suspend;
 	genpd->start_device = pm_clk_resume;
 	genpd->dev_irq_safe = true;

