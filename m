Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612Ab1DPXqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 19:46:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55944 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760506Ab1DPXpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 19:45:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 7/9] PM / Runtime: Add generic clock manipulation rountines for runtime PM
Date: Sun, 17 Apr 2011 01:42:10 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl> <201104170135.19388.rjw@sisk.pl>
In-Reply-To: <201104170135.19388.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104170142.10723.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Many different platforms and subsystems may want to disable device
clocks during suspend and enable them during resume which is going to
be done in a very similar way in all those cases.  For this reason,
provide generic routines for the manipulation of device clocks during
suspend and resume.

Convert the ARM shmobile platform to using the new routines.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm_runtime.c |  139 +--------------------------
 drivers/base/power/Makefile         |    1 
 drivers/base/power/clock_ops.c      |  179 ++++++++++++++++++++++++++++++++++++
 include/linux/pm_runtime.h          |   27 +++++
 kernel/power/Kconfig                |    4 
 5 files changed, 216 insertions(+), 134 deletions(-)

Index: linux-2.6/drivers/base/power/clock_ops.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/base/power/clock_ops.c
@@ -0,0 +1,179 @@
+/*
+ * drivers/base/power/clock_ops.c - Generic clock manipulation PM callbacks
+ *
+ * Copyright (c) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Jinzai Solution Inc.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+
+#ifdef CONFIG_PM_RUNTIME
+
+struct pm_runtime_data {
+	struct clk *clk;
+	unsigned int clock_active:1;
+	unsigned int clock_enabled:1;
+};
+
+static struct pm_runtime_data *__to_prd(struct device *dev)
+{
+	return dev ? dev->power.subsys_data : NULL;
+}
+
+int pm_runtime_clock_add(struct device *dev)
+{
+	struct pm_runtime_data *prd;
+
+	prd = kzalloc(sizeof(*prd), GFP_KERNEL);
+	if (!prd) {
+		dev_err(dev, "unable to allocate memory for runtime PM\n");
+		return -ENOMEM;
+	}
+
+	dev->power.subsys_data = prd;
+	return 0;
+}
+
+void pm_runtime_clock_remove(struct device *dev)
+{
+	struct pm_runtime_data *prd = __to_prd(dev);
+
+	if (!prd)
+		return;
+
+	if (prd->clk) {
+		if (prd->clock_enabled)
+			clk_disable(prd->clk);
+
+		if (prd->clock_active)
+			clk_put(prd->clk);
+	}
+
+	kfree(prd);
+}
+
+static void pm_runtime_clock_init(struct device *dev,
+				  struct pm_runtime_data *prd)
+{
+	prd->clk = clk_get(dev, NULL);
+	if (!IS_ERR(prd->clk)) {
+		prd->clock_active = true;
+		dev_info(dev, "clock managed by runtime PM\n");
+	}
+}
+
+int pm_runtime_clock_suspend(struct device *dev)
+{
+	struct pm_runtime_data *prd = __to_prd(dev);
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (prd) {
+		if (!prd->clk) {
+			dev_err(dev, "clock is not ready for runtime PM\n");
+			pm_runtime_clock_init(dev, prd);
+		}
+
+		if (prd->clock_active) {
+			clk_disable(prd->clk);
+			prd->clock_enabled = false;
+		}
+	}
+
+	return 0;
+}
+
+int pm_runtime_clock_resume(struct device *dev)
+{
+	struct pm_runtime_data *prd = __to_prd(dev);
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (prd) {
+		if (!prd->clk)
+			pm_runtime_clock_init(dev, prd);
+
+		if (prd->clock_active) {
+			clk_enable(prd->clk);
+			prd->clock_enabled = true;
+		}
+	}
+
+	return 0;
+}
+
+static int pm_runtime_clock_notify(struct notifier_block *nb,
+				   unsigned long action, void *data)
+{
+	struct pm_domain_notifier_block *pdnb;
+	struct device *dev = data;
+
+	dev_dbg(dev, "%s() %ld\n", __func__, action);
+
+	pdnb = container_of(nb, struct pm_domain_notifier_block, nb);
+
+	switch (action) {
+	case BUS_NOTIFY_BIND_DRIVER:
+		dev->pwr_domain = pdnb->pwr_domain;
+		pm_runtime_clock_add(dev);
+		break;
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		dev->pwr_domain = NULL;
+		pm_runtime_clock_remove(dev);
+		break;
+	}
+
+	return 0;
+}
+
+#else /* !CONFIG_PM_RUNTIME */
+
+static int pm_runtime_clock_notify(struct notifier_block *nb,
+				   unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct clk *clk;
+
+	dev_dbg(dev, "%s() %ld\n", __func__, action);
+
+	switch (action) {
+	case BUS_NOTIFY_BIND_DRIVER:
+		clk = clk_get(dev, NULL);
+		if (!IS_ERR(clk)) {
+			clk_enable(clk);
+			clk_put(clk);
+			dev_info(dev, "runtime PM disabled, clock forced on\n");
+		}
+		break;
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		clk = clk_get(dev, NULL);
+		if (!IS_ERR(clk)) {
+			clk_disable(clk);
+			clk_put(clk);
+			dev_info(dev, "runtime PM disabled, clock forced off\n");
+		}
+		break;
+	}
+
+	return 0;
+}
+
+#endif /* !CONFIG_PM_RUNTIME */
+
+void pm_runtim_clock_add_notifier(struct bus_type *bus,
+				  struct pm_domain_notifier_block *pdnb)
+{
+	if (!bus || !pdnb)
+		return;
+
+	pdnb->nb.notifier_call = pm_runtime_clock_notify;
+	bus_register_notifier(bus, &pdnb->nb);
+}
Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -229,3 +229,7 @@ config PM_OPP
 	  representing individual voltage domains and provides SOC
 	  implementations a ready to use framework to manage OPPs.
 	  For more information, read <file:Documentation/power/opp.txt>
+
+config PM_RUNTIME_CLK
+	def_bool y
+	depends on PM_RUNTIME && HAVE_CLK
Index: linux-2.6/drivers/base/power/Makefile
===================================================================
--- linux-2.6.orig/drivers/base/power/Makefile
+++ linux-2.6/drivers/base/power/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_PM_SLEEP)	+= main.o wakeup.
 obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
 obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
 obj-$(CONFIG_PM_OPP)	+= opp.o
+obj-$(CONFIG_HAVE_CLK)	+= clock_ops.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 ccflags-$(CONFIG_PM_VERBOSE)   += -DDEBUG
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- linux-2.6.orig/include/linux/pm_runtime.h
+++ linux-2.6/include/linux/pm_runtime.h
@@ -245,4 +245,31 @@ static inline void pm_runtime_dont_use_a
 	__pm_runtime_use_autosuspend(dev, false);
 }
 
+struct pm_domain_notifier_block {
+	struct notifier_block nb;
+	struct dev_power_domain *pwr_domain;
+};
+
+#ifdef CONFIG_PM_RUNTIME_CLK
+extern int pm_runtime_clock_add(struct device *dev);
+extern void pm_runtime_clock_remove(struct device *dev);
+extern int pm_runtime_clock_suspend(struct device *dev);
+extern int pm_runtime_clock_resume(struct device *dev);
+#else
+static inline pm_runtime_clock_add(struct device *dev) { return -EINVAL; }
+static inline pm_runtime_clock_remove(struct device *dev) {}
+#define pm_runtime_clock_suspend	NULL
+#define pm_runtime_clock_resume		NULL
+#endif
+
+#ifdef CONFIG_HAVE_CLK
+extern void pm_runtim_clock_add_notifier(struct bus_type *bus,
+					 struct pm_domain_notifier_block *pdnb);
+#else
+static inline void pm_runtim_clock_add_notifier(struct bus_type *bus,
+					 struct pm_domain_notifier_block *pdnb);
+{
+}
+#endif
+
 #endif
Index: linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm_runtime.c
+++ linux-2.6/arch/arm/mach-shmobile/pm_runtime.c
@@ -21,70 +21,6 @@
 #include <linux/slab.h>
 
 #ifdef CONFIG_PM_RUNTIME
-#define BIT_ONCE 0
-#define BIT_ACTIVE 1
-#define BIT_CLK_ENABLED 2
-
-struct pm_runtime_data {
-	unsigned long flags;
-	struct clk *clk;
-};
-
-static struct pm_runtime_data *__to_prd(struct device *dev)
-{
-	return dev ? dev->power.subsys_data : NULL;
-}
-
-static void platform_pm_runtime_init(struct device *dev,
-				     struct pm_runtime_data *prd)
-{
-	if (prd && !test_and_set_bit(BIT_ONCE, &prd->flags)) {
-		prd->clk = clk_get(dev, NULL);
-		if (!IS_ERR(prd->clk)) {
-			set_bit(BIT_ACTIVE, &prd->flags);
-			dev_info(dev, "clocks managed by runtime pm\n");
-		}
-	}
-}
-
-static void platform_pm_runtime_bug(struct device *dev,
-				    struct pm_runtime_data *prd)
-{
-	if (prd && !test_and_set_bit(BIT_ONCE, &prd->flags))
-		dev_err(dev, "runtime pm suspend before resume\n");
-}
-
-static int default_platform_runtime_suspend(struct device *dev)
-{
-	struct pm_runtime_data *prd = __to_prd(dev);
-
-	dev_dbg(dev, "%s()\n", __func__);
-
-	platform_pm_runtime_bug(dev, prd);
-
-	if (prd && test_bit(BIT_ACTIVE, &prd->flags)) {
-		clk_disable(prd->clk);
-		clear_bit(BIT_CLK_ENABLED, &prd->flags);
-	}
-
-	return 0;
-}
-
-static int default_platform_runtime_resume(struct device *dev)
-{
-	struct pm_runtime_data *prd = __to_prd(dev);
-
-	dev_dbg(dev, "%s()\n", __func__);
-
-	platform_pm_runtime_init(dev, prd);
-
-	if (prd && test_bit(BIT_ACTIVE, &prd->flags)) {
-		clk_enable(prd->clk);
-		set_bit(BIT_CLK_ENABLED, &prd->flags);
-	}
-
-	return 0;
-}
 
 static int default_platform_runtime_idle(struct device *dev)
 {
@@ -95,86 +31,21 @@ static int default_platform_runtime_idle
 static struct dev_power_domain default_power_domain = {
 	.ops = {
 		USE_PLATFORM_PM_SLEEP_OPS,
-		.runtime_suspend = default_platform_runtime_suspend,
-		.runtime_resume = default_platform_runtime_resume,
+		.runtime_suspend = pm_runtime_clock_suspend,
+		.runtime_resume = pm_runtime_clock_resume,
 		.runtime_idle = default_platform_runtime_idle,
 	},
 };
 
-static int platform_bus_notify(struct notifier_block *nb,
-			       unsigned long action, void *data)
-{
-	struct device *dev = data;
-	struct pm_runtime_data *prd;
-
-	dev_dbg(dev, "platform_bus_notify() %ld !\n", action);
-
-	switch (action) {
-	case BUS_NOTIFY_BIND_DRIVER:
-		prd = kzalloc(sizeof(*prd), GFP_KERNEL);
-		if (prd) {
-			dev->power.subsys_data = prd;
-			dev->pwr_domain = &default_power_domain;
-		} else {
-			dev_err(dev, "unable to alloc memory for runtime pm\n");
-		}
-		break;
-	case BUS_NOTIFY_UNBOUND_DRIVER:
-		prd = __to_prd(dev);
-		if (prd) {
-			if (test_bit(BIT_CLK_ENABLED, &prd->flags))
-				clk_disable(prd->clk);
-
-			if (test_bit(BIT_ACTIVE, &prd->flags))
-				clk_put(prd->clk);
-		}
-		break;
-	}
-
-	return 0;
-}
-
-#else /* CONFIG_PM_RUNTIME */
-
-static int platform_bus_notify(struct notifier_block *nb,
-			       unsigned long action, void *data)
-{
-	struct device *dev = data;
-	struct clk *clk;
-
-	dev_dbg(dev, "platform_bus_notify() %ld !\n", action);
-
-	switch (action) {
-	case BUS_NOTIFY_BIND_DRIVER:
-		clk = clk_get(dev, NULL);
-		if (!IS_ERR(clk)) {
-			clk_enable(clk);
-			clk_put(clk);
-			dev_info(dev, "runtime pm disabled, clock forced on\n");
-		}
-		break;
-	case BUS_NOTIFY_UNBOUND_DRIVER:
-		clk = clk_get(dev, NULL);
-		if (!IS_ERR(clk)) {
-			clk_disable(clk);
-			clk_put(clk);
-			dev_info(dev, "runtime pm disabled, clock forced off\n");
-		}
-		break;
-	}
-
-	return 0;
-}
-
 #endif /* CONFIG_PM_RUNTIME */
 
-static struct notifier_block platform_bus_notifier = {
-	.notifier_call = platform_bus_notify
+static struct pm_domain_notifier_block platform_bus_notifier = {
+	.pwr_domain = &default_power_domain,
 };
 
 static int __init sh_pm_runtime_init(void)
 {
-	bus_register_notifier(&platform_bus_type, &platform_bus_notifier);
+	pm_runtim_clock_add_notifier(&platform_bus_type, &platform_bus_notifier);
 	return 0;
 }
 core_initcall(sh_pm_runtime_init);

