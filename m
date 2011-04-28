Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab1D1Bcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 21:32:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab1D1Bcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 21:32:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@google.com>
Subject: Re: [Update][PATCH 7/9] PM / Runtime: Generic clock manipulation rountines for runtime PM (v3)
Date: Thu, 28 Apr 2011 03:33:13 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl> <201104280258.34694.rjw@sisk.pl> <201104280306.13262.rjw@sisk.pl>
In-Reply-To: <201104280306.13262.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104280333.13730.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 28, 2011, Rafael J. Wysocki wrote:
> On Thursday, April 28, 2011, Rafael J. Wysocki wrote:
> > On Thursday, April 28, 2011, Colin Cross wrote:
> > > On Wed, Apr 27, 2011 at 2:48 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
...
> > > > +               }
> > > > +
> > > > +               if (ce->clock_active) {
> > > I don't think clock_active is necessary, and the name is misleading.
> > 
> > It's not strictly necessary and "active" means "being used for runtime PM".
> > 
> > > Why not use if (ce->clk)?
> > 
> > Because _that_ would be confusing?
> 
> Moreover, if the first clk_get() fails, this avoids repeating it
> during every suspend/resume (because it most probably is going to fail too).

Still, I could use !IS_ERR() to get the same thing.

Below is updated patch with that change.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Runtime: Generic clock manipulation rountines for runtime PM (v4)

Many different platforms and subsystems may want to disable device
clocks during suspend and enable them during resume which is going to
be done in a very similar way in all those cases.  For this reason,
provide generic routines for the manipulation of device clocks during
suspend and resume.

Convert the ARM shmobile platform to using the new routines.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm_runtime.c |  140 ------------
 drivers/base/power/Makefile         |    1 
 drivers/base/power/clock_ops.c      |  420 ++++++++++++++++++++++++++++++++++++
 include/linux/pm_runtime.h          |   42 +++
 kernel/power/Kconfig                |    4 
 5 files changed, 476 insertions(+), 131 deletions(-)

Index: linux-2.6/drivers/base/power/clock_ops.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/base/power/clock_ops.c
@@ -0,0 +1,420 @@
+/*
+ * drivers/base/power/clock_ops.c - Generic clock manipulation PM callbacks
+ *
+ * Copyright (c) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.
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
+struct pm_runtime_clk_data {
+	struct list_head clock_list;
+	struct mutex lock;
+};
+
+struct pm_clock_entry {
+	struct list_head node;
+	char *con_id;
+	struct clk *clk;
+	unsigned int clock_enabled:1;
+};
+
+static struct pm_runtime_clk_data *__to_prd(struct device *dev)
+{
+	return dev ? dev->power.subsys_data : NULL;
+}
+
+/**
+ * pm_runtime_clk_add - Start using a device clock for runtime PM.
+ * @dev: Device whose clock is going to be used for runtime PM.
+ * @con_id: Connection ID of the clock.
+ *
+ * Add the clock represented by @con_id to the list of clocks used for
+ * the runtime PM of @dev.
+ */
+int pm_runtime_clk_add(struct device *dev, const char *con_id)
+{
+	struct pm_runtime_clk_data *prd = __to_prd(dev);
+	struct pm_clock_entry *ce;
+
+	if (!prd)
+		return -EINVAL;
+
+	ce = kzalloc(sizeof(*ce), GFP_KERNEL);
+	if (!ce) {
+		dev_err(dev, "Not enough memory for clock entry.\n");
+		return -ENOMEM;
+	}
+
+	if (con_id) {
+		ce->con_id = kstrdup(con_id, GFP_KERNEL);
+		if (!ce->con_id) {
+			dev_err(dev,
+				"Not enough memory for clock conection ID.\n");
+			kfree(ce);
+			return -ENOMEM;
+		}
+	}
+
+	mutex_lock(&prd->lock);
+	list_add_tail(&ce->node, &prd->clock_list);
+	mutex_unlock(&prd->lock);
+	return 0;
+}
+
+/**
+ * __pm_runtime_clk_remove - Destroy runtime PM clock entry.
+ * @ce: Runtime PM clock entry to destroy.
+ *
+ * This routine must be called under the mutex protecting the runtime PM list
+ * of clocks corresponding the the @ce's device.
+ */
+static void __pm_runtime_clk_remove(struct pm_clock_entry *ce)
+{
+	if (!ce)
+		return;
+
+	list_del(&ce->node);
+
+	if (ce->clk) {
+		if (ce->clock_enabled)
+			clk_disable(ce->clk);
+
+		if (!IS_ERR(ce->clk))
+			clk_put(ce->clk);
+	}
+
+	if (ce->con_id)
+		kfree(ce->con_id);
+
+	kfree(ce);
+}
+
+/**
+ * pm_runtime_clk_remove - Stop using a device clock for runtime PM.
+ * @dev: Device whose clock should not be used for runtime PM any more.
+ * @con_id: Connection ID of the clock.
+ *
+ * Remove the clock represented by @con_id from the list of clocks used for
+ * the runtime PM of @dev.
+ */
+void pm_runtime_clk_remove(struct device *dev, const char *con_id)
+{
+	struct pm_runtime_clk_data *prd = __to_prd(dev);
+	struct pm_clock_entry *ce;
+
+	if (!prd)
+		return;
+
+	mutex_lock(&prd->lock);
+
+	list_for_each_entry(ce, &prd->clock_list, node)
+		if (!con_id && !ce->con_id) {
+			__pm_runtime_clk_remove(ce);
+			break;
+		} else if (!con_id || !ce->con_id) {
+			continue;
+		} else if (!strcmp(con_id, ce->con_id)) {
+			__pm_runtime_clk_remove(ce);
+			break;
+		}
+
+	mutex_unlock(&prd->lock);
+}
+
+/**
+ * pm_runtime_clk_init - Initialize a device's list of runtime PM clocks.
+ * @dev: Device to initialize the list of runtime PM clocks for.
+ *
+ * Allocate a struct pm_runtime_clk_data object, initialize its lock member and
+ * make the @dev's power.subsys_data field point to it.
+ */
+int pm_runtime_clk_init(struct device *dev)
+{
+	struct pm_runtime_clk_data *prd;
+
+	prd = kzalloc(sizeof(*prd), GFP_KERNEL);
+	if (!prd) {
+		dev_err(dev, "Not enough memory fo runtime PM data.\n");
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&prd->clock_list);
+	mutex_init(&prd->lock);
+	dev->power.subsys_data = prd;
+	return 0;
+}
+
+/**
+ * pm_runtime_clk_destroy - Destroy a device's list of runtime PM clocks.
+ * @dev: Device to destroy the list of runtime PM clocks for.
+ *
+ * Clear the @dev's power.subsys_data field, remove the list of clock entries
+ * from the struct pm_runtime_clk_data object pointed to by it before and free
+ * that object.
+ */
+void pm_runtime_clk_destroy(struct device *dev)
+{
+	struct pm_runtime_clk_data *prd = __to_prd(dev);
+	struct pm_clock_entry *ce, *c;
+
+	if (!prd)
+		return;
+
+	dev->power.subsys_data = NULL;
+
+	mutex_lock(&prd->lock);
+
+	list_for_each_entry_safe_reverse(ce, c, &prd->clock_list, node)
+		__pm_runtime_clk_remove(ce);
+
+	mutex_unlock(&prd->lock);
+
+	kfree(prd);
+}
+
+/**
+ * pm_runtime_clk_acquire - Acquire a device clock.
+ * @dev: Device whose clock is to be acquired.
+ * @con_id: Connection ID of the clock.
+ */
+static void pm_runtime_clk_acquire(struct device *dev,
+				    struct pm_clock_entry *ce)
+{
+	ce->clk = clk_get(dev, ce->con_id);
+	if (!IS_ERR(ce->clk))
+		dev_dbg(dev, "Clock %s managed by runtime PM.\n", ce->con_id);
+}
+
+/**
+ * pm_runtime_clk_suspend - Disable clocks in a device's runtime PM clock list.
+ * @dev: Device to disable the clocks for.
+ */
+int pm_runtime_clk_suspend(struct device *dev)
+{
+	struct pm_runtime_clk_data *prd = __to_prd(dev);
+	struct pm_clock_entry *ce;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (!prd)
+		return 0;
+
+	mutex_lock(&prd->lock);
+
+	list_for_each_entry_reverse(ce, &prd->clock_list, node) {
+		if (!ce->clk) {
+			dev_err(dev, "Clock is not ready for runtime PM\n");
+			pm_runtime_clk_acquire(dev, ce);
+		}
+
+		if (!IS_ERR(ce->clk)) {
+			clk_disable(ce->clk);
+			ce->clock_enabled = false;
+		}
+	}
+
+	mutex_unlock(&prd->lock);
+
+	return 0;
+}
+
+/**
+ * pm_runtime_clk_resume - Enable clocks in a device's runtime PM clock list.
+ * @dev: Device to enable the clocks for.
+ */
+int pm_runtime_clk_resume(struct device *dev)
+{
+	struct pm_runtime_clk_data *prd = __to_prd(dev);
+	struct pm_clock_entry *ce;
+
+	dev_dbg(dev, "%s()\n", __func__);
+
+	if (!prd)
+		return 0;
+
+	mutex_lock(&prd->lock);
+
+	list_for_each_entry(ce, &prd->clock_list, node) {
+		if (!ce->clk)
+			pm_runtime_clk_acquire(dev, ce);
+
+		if (!IS_ERR(ce->clk)) {
+			clk_enable(ce->clk);
+			ce->clock_enabled = true;
+		}
+	}
+
+	mutex_unlock(&prd->lock);
+
+	return 0;
+}
+
+/**
+ * pm_runtime_clk_notify - Notify routine for device addition and removal.
+ * @nb: Notifier block object this function is a member of.
+ * @action: Operation being carried out by the caller.
+ * @data: Device the routine is being run for.
+ *
+ * For this function to work, @nb must be a member of an object of type
+ * struct pm_clk_notifier_block containing all of the requisite data.
+ * Specifically, the pwr_domain member of that object is copied to the device's
+ * pwr_domain field and its con_ids member is used to populate the device's list
+ * of runtime PM clocks, depending on @action.
+ *
+ * If the device's pwr_domain field is already populated with a value different
+ * from the one stored in the struct pm_clk_notifier_block object, the function
+ * does nothing.
+ */
+static int pm_runtime_clk_notify(struct notifier_block *nb,
+				 unsigned long action, void *data)
+{
+	struct pm_clk_notifier_block *clknb;
+	struct device *dev = data;
+	char *con_id;
+	int error;
+
+	dev_dbg(dev, "%s() %ld\n", __func__, action);
+
+	clknb = container_of(nb, struct pm_clk_notifier_block, nb);
+
+	switch (action) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		if (dev->pwr_domain)
+			break;
+
+		error = pm_runtime_clk_init(dev);
+		if (error)
+			break;
+
+		dev->pwr_domain = clknb->pwr_domain;
+		if (clknb->con_ids[0]) {
+			for (con_id = clknb->con_ids[0]; *con_id; con_id++)
+				pm_runtime_clk_add(dev, con_id);
+		} else {
+			pm_runtime_clk_add(dev, NULL);
+		}
+
+		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+		if (dev->pwr_domain != clknb->pwr_domain)
+			break;
+
+		dev->pwr_domain = NULL;
+		pm_runtime_clk_destroy(dev);
+		break;
+	}
+
+	return 0;
+}
+
+#else /* !CONFIG_PM_RUNTIME */
+
+/**
+ * enable_clock - Enable a device clock.
+ * @dev: Device whose clock is to be enabled.
+ * @con_id: Connection ID of the clock.
+ */
+static void enable_clock(struct device *dev, const char *con_id)
+{
+	struct clk *clk;
+
+	clk = clk_get(dev, con_id);
+	if (!IS_ERR(clk)) {
+		clk_enable(clk);
+		clk_put(clk);
+		dev_info(dev, "Runtime PM disabled, clock forced on.\n");
+	}
+}
+
+/**
+ * disable_clock - Disable a device clock.
+ * @dev: Device whose clock is to be disabled.
+ * @con_id: Connection ID of the clock.
+ */
+static void disable_clock(struct device *dev, const char *con_id)
+{
+	struct clk *clk;
+
+	clk = clk_get(dev, con_id);
+	if (!IS_ERR(clk)) {
+		clk_disable(clk);
+		clk_put(clk);
+		dev_info(dev, "Runtime PM disabled, clock forced off.\n");
+	}
+}
+
+/**
+ * pm_runtime_clk_notify - Notify routine for device addition and removal.
+ * @nb: Notifier block object this function is a member of.
+ * @action: Operation being carried out by the caller.
+ * @data: Device the routine is being run for.
+ *
+ * For this function to work, @nb must be a member of an object of type
+ * struct pm_clk_notifier_block containing all of the requisite data.
+ * Specifically, the con_ids member of that object is used to enable or disable
+ * the device's clocks, depending on @action.
+ */
+static int pm_runtime_clk_notify(struct notifier_block *nb,
+				 unsigned long action, void *data)
+{
+	struct pm_clk_notifier_block *clknb;
+	struct device *dev = data;
+
+	dev_dbg(dev, "%s() %ld\n", __func__, action);
+
+	clknb = container_of(nb, struct pm_clk_notifier_block, nb);
+
+	switch (action) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		if (clknb->con_ids[0]) {
+			for (con_id = clknb->con_ids[0]; *con_id; con_id++)
+				enable_clock(dev, con_id);
+		} else {
+			enable_clock(dev, NULL);
+		}
+		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+		if (clknb->con_ids[0]) {
+			for (con_id = clknb->con_ids[0]; *con_id; con_id++)
+				disable_clock(dev, con_id);
+		} else {
+			disable_clock(dev, NULL);
+		}
+		break;
+	}
+
+	return 0;
+}
+
+#endif /* !CONFIG_PM_RUNTIME */
+
+/**
+ * pm_runtime_clk_add_notifier - Add bus type notifier for runtime PM clocks.
+ * @bus: Bus type to add the notifier to.
+ * @clknb: Notifier to be added to the given bus type.
+ *
+ * The nb member of @clknb is not expected to be initialized and its
+ * notifier_call member will be replaced with pm_runtime_clk_notify().  However,
+ * the remaining members of @clknb should be populated prior to calling this
+ * routine.
+ */
+void pm_runtime_clk_add_notifier(struct bus_type *bus,
+				 struct pm_clk_notifier_block *clknb)
+{
+	if (!bus || !clknb)
+		return;
+
+	clknb->nb.notifier_call = pm_runtime_clk_notify;
+	bus_register_notifier(bus, &clknb->nb);
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
@@ -245,4 +245,46 @@ static inline void pm_runtime_dont_use_a
 	__pm_runtime_use_autosuspend(dev, false);
 }
 
+struct pm_clk_notifier_block {
+	struct notifier_block nb;
+	struct dev_power_domain *pwr_domain;
+	char *con_ids[];
+};
+
+#ifdef CONFIG_PM_RUNTIME_CLK
+extern int pm_runtime_clk_init(struct device *dev);
+extern void pm_runtime_clk_destroy(struct device *dev);
+extern int pm_runtime_clk_add(struct device *dev, const char *con_id);
+extern void pm_runtime_clk_remove(struct device *dev, const char *con_id);
+extern int pm_runtime_clk_suspend(struct device *dev);
+extern int pm_runtime_clk_resume(struct device *dev);
+#else
+static inline int pm_runtime_clk_init(struct device *dev)
+{
+	return -EINVAL;
+}
+static inline void pm_runtime_clk_destroy(struct device *dev)
+{
+}
+static inline int pm_runtime_clk_add(struct device *dev, const char *con_id)
+{
+	return -EINVAL;
+}
+static inline void pm_runtime_clk_remove(struct device *dev, const char *con_id)
+{
+}
+#define pm_runtime_clock_suspend	NULL
+#define pm_runtime_clock_resume		NULL
+#endif
+
+#ifdef CONFIG_HAVE_CLK
+extern void pm_runtime_clk_add_notifier(struct bus_type *bus,
+					struct pm_clk_notifier_block *clknb);
+#else
+static inline void pm_runtime_clk_add_notifier(struct bus_type *bus,
+					struct pm_clk_notifier_block *clknb)
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
@@ -94,87 +30,29 @@ static int default_platform_runtime_idle
 
 static struct dev_power_domain default_power_domain = {
 	.ops = {
-		.runtime_suspend = default_platform_runtime_suspend,
-		.runtime_resume = default_platform_runtime_resume,
+		.runtime_suspend = pm_runtime_clk_suspend,
+		.runtime_resume = pm_runtime_clk_resume,
 		.runtime_idle = default_platform_runtime_idle,
 		USE_PLATFORM_PM_SLEEP_OPS
 	},
 };
 
-static int platform_bus_notify(struct notifier_block *nb,
-			       unsigned long action, void *data)
-{
-	struct device *dev = data;
-	struct pm_runtime_data *prd;
+#define DEFAULT_PWR_DOMAIN_PTR	(&default_power_domain)
 
-	dev_dbg(dev, "platform_bus_notify() %ld !\n", action);
+#else
 
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
+#define DEFAULT_PWR_DOMAIN_PTR	NULL
 
 #endif /* CONFIG_PM_RUNTIME */
 
-static struct notifier_block platform_bus_notifier = {
-	.notifier_call = platform_bus_notify
+static struct pm_clk_notifier_block platform_bus_notifier = {
+	.pwr_domain = DEFAULT_PWR_DOMAIN_PTR,
+	.con_ids = { NULL, },
 };
 
 static int __init sh_pm_runtime_init(void)
 {
-	bus_register_notifier(&platform_bus_type, &platform_bus_notifier);
+	pm_runtime_clk_add_notifier(&platform_bus_type, &platform_bus_notifier);
 	return 0;
 }
 core_initcall(sh_pm_runtime_init);
