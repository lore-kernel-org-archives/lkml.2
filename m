Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1IVWax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:30:53 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:44415 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754186Ab1IVWat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:30:49 -0400
From: Mike Turquette <mturquette@ti.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        paul@pwsan.com, grant.likely@secretlab.ca, sboyd@quiinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@ti.com>
Subject: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Date: Thu, 22 Sep 2011 15:26:56 -0700
Message-Id: <1316730422-20027-2-git-send-email-mturquette@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316730422-20027-1-git-send-email-mturquette@ti.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr@canonical.com>

We currently have ~21 definitions of struct clk in the ARM architecture,
each defined on a per-platform basis. This makes it difficult to define
platform- (or architecture-) independent clock sources without making
assumptions about struct clk, and impossible to compile two
platforms with different struct clks into a single image.

This change is an effort to unify struct clk where possible, by defining
a common struct clk, and a set of clock operations. Different clock
implementations can set their own operations, and have a standard
interface for generic code. The callback interface is exposed to the
kernel proper, while the clock implementations only need to be seen by
the platform internals.

The interface is split into two halves:

 * struct clk, which is the generic-device-driver interface. This
   provides a set of functions which drivers may use to request
   enable/disable, query or manipulate in a hardware-independent manner.

 * struct clk_hw and struct clk_hw_ops, which is the hardware-specific
   interface. Clock drivers implement the ops, which allow the core
   clock code to implement the generic 'struct clk' API.

This allows us to share clock code among platforms, and makes it
possible to dynamically create clock devices in platform-independent
code.

Platforms can enable the generic struct clock through
CONFIG_GENERIC_CLK. In this case, the clock infrastructure consists of a
common, opaque struct clk, and a set of clock operations (defined per
type of clock):

  struct clk_hw_ops {
  	int		(*prepare)(struct clk_hw *);
  	void		(*unprepare)(struct clk_hw *);
  	int		(*enable)(struct clk_hw *);
  	void		(*disable)(struct clk_hw *);
  	unsigned long	(*recalc_rate)(struct clk_hw *);
  	int		(*set_rate)(struct clk_hw *,
  					unsigned long, unsigned long *);
  	long		(*round_rate)(struct clk_hw *, unsigned long);
  	int		(*set_parent)(struct clk_hw *, struct clk *);
  	struct clk *	(*get_parent)(struct clk_hw *);
  };

Platform clock code can register a clock through clk_register, passing a
set of operations, and a pointer to hardware-specific data:

  struct clk_hw_foo {
  	struct clk_hw clk;
  	void __iomem *enable_reg;
  };

  #define to_clk_foo(c) offsetof(c, clk_hw_foo, clk)

  static int clk_foo_enable(struct clk_hw *clk)
  {
  	struct clk_foo *foo = to_clk_foo(clk);
  	raw_writeb(foo->enable_reg, 1);
  	return 0;
  }

  struct clk_hw_ops clk_foo_ops = {
  	.enable = clk_foo_enable,
  };

And in the platform initialisation code:

  struct clk_foo my_clk_foo;

  void init_clocks(void)
  {
  	my_clk_foo.enable_reg = ioremap(...);

  	clk_register(&clk_foo_ops, &my_clk_foo, NULL);
  }

Changes from Thomas Gleixner <tglx@linutronix.de>.

The common clock definitions are based on a development patch from Ben
Herrenschmidt <benh@kernel.crashing.org>.

TODO:

 * We don't keep any internal reference to the clock topology at present.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Mike Turquette <mturquette@ti.com>
---
Changes since v1:
Create a dummy clk_unregister and prototype/document it and clk_register
Constify struct clk_hw_ops
Remove spinlock.h header, include kernel.h
Use EOPNOTSUPP instead of ENOTSUPP
Add might_sleep to clk_prepare/clk_unprepare stubs
Properly init children hlist and child_node
Whitespace and typo fixes

 drivers/clk/Kconfig  |    3 +
 drivers/clk/Makefile |    1 +
 drivers/clk/clk.c    |  232 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/clkdev.c |    7 ++
 include/linux/clk.h  |  140 +++++++++++++++++++++++++++---
 5 files changed, 371 insertions(+), 12 deletions(-)
 create mode 100644 drivers/clk/clk.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 3530927..c53ed59 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -5,3 +5,6 @@ config CLKDEV_LOOKUP
 
 config HAVE_MACH_CLKDEV
 	bool
+
+config GENERIC_CLK
+	bool
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 07613fa..570d5b9 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -1,2 +1,3 @@
 
 obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
+obj-$(CONFIG_GENERIC_CLK)	+= clk.o
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
new file mode 100644
index 0000000..1cd7315
--- /dev/null
+++ b/drivers/clk/clk.c
@@ -0,0 +1,232 @@
+/*
+ * Copyright (C) 2010-2011 Canonical Ltd <jeremy.kerr@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Standard functionality for the common clock API.
+ */
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+struct clk {
+	const char		*name;
+	const struct clk_hw_ops	*ops;
+	struct clk_hw		*hw;
+	unsigned int		enable_count;
+	unsigned int		prepare_count;
+	struct clk		*parent;
+	unsigned long		rate;
+};
+
+static DEFINE_SPINLOCK(enable_lock);
+static DEFINE_MUTEX(prepare_lock);
+
+static void __clk_unprepare(struct clk *clk)
+{
+	if (!clk)
+		return;
+
+	if (WARN_ON(clk->prepare_count == 0))
+		return;
+
+	if (--clk->prepare_count > 0)
+		return;
+
+	WARN_ON(clk->enable_count > 0);
+
+	if (clk->ops->unprepare)
+		clk->ops->unprepare(clk->hw);
+
+	__clk_unprepare(clk->parent);
+}
+
+void clk_unprepare(struct clk *clk)
+{
+	mutex_lock(&prepare_lock);
+	__clk_unprepare(clk);
+	mutex_unlock(&prepare_lock);
+}
+EXPORT_SYMBOL_GPL(clk_unprepare);
+
+static int __clk_prepare(struct clk *clk)
+{
+	int ret = 0;
+
+	if (!clk)
+		return 0;
+
+	if (clk->prepare_count == 0) {
+		ret = __clk_prepare(clk->parent);
+		if (ret)
+			return ret;
+
+		if (clk->ops->prepare) {
+			ret = clk->ops->prepare(clk->hw);
+			if (ret) {
+				__clk_unprepare(clk->parent);
+				return ret;
+			}
+		}
+	}
+
+	clk->prepare_count++;
+
+	return 0;
+}
+
+int clk_prepare(struct clk *clk)
+{
+	int ret;
+
+	mutex_lock(&prepare_lock);
+	ret = __clk_prepare(clk);
+	mutex_unlock(&prepare_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_prepare);
+
+static void __clk_disable(struct clk *clk)
+{
+	if (!clk)
+		return;
+
+	if (WARN_ON(clk->enable_count == 0))
+		return;
+
+	if (--clk->enable_count > 0)
+		return;
+
+	if (clk->ops->disable)
+		clk->ops->disable(clk->hw);
+	__clk_disable(clk->parent);
+}
+
+void clk_disable(struct clk *clk)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&enable_lock, flags);
+	__clk_disable(clk);
+	spin_unlock_irqrestore(&enable_lock, flags);
+}
+EXPORT_SYMBOL_GPL(clk_disable);
+
+static int __clk_enable(struct clk *clk)
+{
+	int ret;
+
+	if (!clk)
+		return 0;
+
+	if (WARN_ON(clk->prepare_count == 0))
+		return -ESHUTDOWN;
+
+
+	if (clk->enable_count == 0) {
+		ret = __clk_enable(clk->parent);
+		if (ret)
+			return ret;
+
+		if (clk->ops->enable) {
+			ret = clk->ops->enable(clk->hw);
+			if (ret) {
+				__clk_disable(clk->parent);
+				return ret;
+			}
+		}
+	}
+
+	clk->enable_count++;
+	return 0;
+}
+
+int clk_enable(struct clk *clk)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&enable_lock, flags);
+	ret = __clk_enable(clk);
+	spin_unlock_irqrestore(&enable_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_enable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	if (!clk)
+		return 0;
+	return clk->rate;
+}
+EXPORT_SYMBOL_GPL(clk_get_rate);
+
+long clk_round_rate(struct clk *clk, unsigned long rate)
+{
+	if (clk && clk->ops->round_rate)
+		return clk->ops->round_rate(clk->hw, rate);
+	return rate;
+}
+EXPORT_SYMBOL_GPL(clk_round_rate);
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	/* not yet implemented */
+	return -ENOSYS;
+}
+EXPORT_SYMBOL_GPL(clk_set_rate);
+
+struct clk *clk_get_parent(struct clk *clk)
+{
+	if (!clk)
+		return NULL;
+
+	return clk->parent;
+}
+EXPORT_SYMBOL_GPL(clk_get_parent);
+
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	/* not yet implemented */
+	return -ENOSYS;
+}
+EXPORT_SYMBOL_GPL(clk_set_parent);
+
+struct clk *clk_register(const struct clk_hw_ops *ops, struct clk_hw *hw,
+		const char *name)
+{
+	struct clk *clk;
+
+	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
+	if (!clk)
+		return NULL;
+
+	INIT_HLIST_HEAD(&clk->children);
+	INIT_HLIST_NODE(&clk->child_node);
+
+	clk->name = name;
+	clk->ops = ops;
+	clk->hw = hw;
+	hw->clk = clk;
+
+	/* Query the hardware for parent and initial rate */
+
+	if (clk->ops->get_parent)
+		/* We don't to lock against prepare/enable here, as
+		 * the clock is not yet accessible from anywhere */
+		clk->parent = clk->ops->get_parent(clk->hw);
+
+	if (clk->ops->recalc_rate)
+		clk->rate = clk->ops->recalc_rate(clk->hw);
+
+
+	return clk;
+}
+EXPORT_SYMBOL_GPL(clk_register);
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 6db161f..e2a9719 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -23,6 +23,13 @@
 static LIST_HEAD(clocks);
 static DEFINE_MUTEX(clocks_mutex);
 
+/* For USE_COMMON_STRUCT_CLK, these are provided in clk.c, but not exported
+ * through other headers; we don't want them used anywhere but here. */
+#ifdef CONFIG_USE_COMMON_STRUCT_CLK
+extern int __clk_get(struct clk *clk);
+extern void __clk_put(struct clk *clk);
+#endif
+
 /*
  * Find the correct struct clk for the device and connection ID.
  * We do slightly fuzzy matching here:
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 1d37f42..d6ae10b 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -3,6 +3,7 @@
  *
  *  Copyright (C) 2004 ARM Limited.
  *  Written by Deep Blue Solutions Limited.
+ *  Copyright (c) 2010-2011 Jeremy Kerr <jeremy.kerr@canonical.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -11,17 +12,137 @@
 #ifndef __LINUX_CLK_H
 #define __LINUX_CLK_H
 
+#include <linux/kernel.h>
+#include <linux/errno.h>
+
 struct device;
 
-/*
- * The base API.
+struct clk;
+
+#ifdef CONFIG_GENERIC_CLK
+
+struct clk_hw {
+	struct clk *clk;
+};
+
+/**
+ * struct clk_hw_ops -  Callback operations for hardware clocks; these are to
+ * be provided by the clock implementation, and will be called by drivers
+ * through the clk_* API.
+ *
+ * @prepare:	Prepare the clock for enabling. This must not return until
+ *		the clock is fully prepared, and it's safe to call clk_enable.
+ *		This callback is intended to allow clock implementations to
+ *		do any initialisation that may sleep. Called with
+ *		prepare_lock held.
+ *
+ * @unprepare:	Release the clock from its prepared state. This will typically
+ *		undo any work done in the @prepare callback. Called with
+ *		prepare_lock held.
+ *
+ * @enable:	Enable the clock atomically. This must not return until the
+ *		clock is generating a valid clock signal, usable by consumer
+ *		devices. Called with enable_lock held. This function must not
+ *		sleep.
+ *
+ * @disable:	Disable the clock atomically. Called with enable_lock held.
+ *		This function must not sleep.
+ *
+ * @recalc_rate	Recalculate the rate of this clock, by quering hardware
+ *		and/or the clock's parent. Called with the global clock mutex
+ *		held. Optional, but recommended - if this op is not set,
+ *		clk_get_rate will return 0.
+ *
+ * @get_parent	Query the parent of this clock; for clocks with multiple
+ *		possible parents, query the hardware for the current
+ *		parent. Currently only called when the clock is first
+ *		registered.
+ *
+ * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
+ * implementations to split any work between atomic (enable) and sleepable
+ * (prepare) contexts.  If a clock requires sleeping code to be turned on, this
+ * should be done in clk_prepare. Switching that will not sleep should be done
+ * in clk_enable.
+ *
+ * Typically, drivers will call clk_prepare when a clock may be needed later
+ * (eg. when a device is opened), and clk_enable when the clock is actually
+ * required (eg. from an interrupt). Note that clk_prepare *must* have been
+ * called before clk_enable.
  */
+struct clk_hw_ops {
+	int		(*prepare)(struct clk_hw *);
+	void		(*unprepare)(struct clk_hw *);
+	int		(*enable)(struct clk_hw *);
+	void		(*disable)(struct clk_hw *);
+	unsigned long	(*recalc_rate)(struct clk_hw *);
+	long		(*round_rate)(struct clk_hw *, unsigned long);
+	struct clk *	(*get_parent)(struct clk_hw *);
+};
 
+/**
+ * clk_prepare - prepare clock for atomic enabling.
+ *
+ * @clk: The clock to prepare
+ *
+ * Do any possibly sleeping initialisation on @clk, allowing the clock to be
+ * later enabled atomically (via clk_enable). This function may sleep.
+ */
+int clk_prepare(struct clk *clk);
+
+/**
+ * clk_unprepare - release clock from prepared state
+ *
+ * @clk: The clock to release
+ *
+ * Do any (possibly sleeping) cleanup on clk. This function may sleep.
+ */
+void clk_unprepare(struct clk *clk);
+
+/**
+ * clk_register - register and initialize a new clock
+ *
+ * @ops: ops for the new clock
+ * @hw: struct clk_hw to be passed to the ops of the new clock
+ * @name: name to use for the new clock
+ *
+ * Register a new clock with the clk subsystem.  Returns either a
+ * struct clk for the new clock or a NULL pointer.
+ */
+struct clk *clk_register(const struct clk_hw_ops *ops, struct clk_hw *hw,
+			 const char *name);
+
+/**
+ * clk_unregister - remove a clock
+ *
+ * @clk: clock to unregister
+ *
+ * Remove a clock from the clk subsystem.  This is currently not
+ * implemented but is provided to allow unregistration code to be
+ * written in drivers ready for use when an implementation is
+ * provided.
+ */
+static inline int clk_unregister(struct clk *clk)
+{
+	return -EOPNOTSUPP;
+}
+
+#else /* !CONFIG_GENERIC_CLK */
 
 /*
- * struct clk - an machine class defined object / cookie.
+ * For !CONFIG_GENERIC_CLK, we don't enforce any atomicity
+ * requirements for clk_enable/clk_disable, so the prepare and unprepare
+ * functions are no-ops
  */
-struct clk;
+static inline int clk_prepare(struct clk *clk) {
+	might_sleep();
+	return 0;
+}
+
+static inline void clk_unprepare(struct clk *clk) {
+	might_sleep();
+}
+
+#endif /* !CONFIG_GENERIC_CLK */
 
 /**
  * clk_get - lookup and obtain a reference to a clock producer.
@@ -67,6 +188,7 @@ void clk_disable(struct clk *clk);
 /**
  * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
  *		  This is only valid once the clock source has been enabled.
+ *		  Returns zero if the clock rate is unknown.
  * @clk: clock source
  */
 unsigned long clk_get_rate(struct clk *clk);
@@ -83,12 +205,6 @@ unsigned long clk_get_rate(struct clk *clk);
  */
 void clk_put(struct clk *clk);
 
-
-/*
- * The remaining APIs are optional for machine class support.
- */
-
-
 /**
  * clk_round_rate - adjust a rate to the exact rate a clock can provide
  * @clk: clock source
@@ -97,7 +213,7 @@ void clk_put(struct clk *clk);
  * Returns rounded clock rate in Hz, or negative errno.
  */
 long clk_round_rate(struct clk *clk, unsigned long rate);
- 
+
 /**
  * clk_set_rate - set the clock rate for a clock source
  * @clk: clock source
@@ -106,7 +222,7 @@ long clk_round_rate(struct clk *clk, unsigned long rate);
  * Returns success (0) or negative errno.
  */
 int clk_set_rate(struct clk *clk, unsigned long rate);
- 
+
 /**
  * clk_set_parent - set the parent clock source for this clock
  * @clk: clock source
-- 
1.7.4.1

