Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310Ab1ETH2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:28:43 -0400
Received: from ozlabs.org ([203.10.76.45]:51979 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934068Ab1ETH16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:27:58 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1/4] clk: Add a generic clock infrastructure
Message-Id: <1305876469.326305.518470530485.1.gpush@pororo>
In-Reply-To: <1305876469.325655.313573683829.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Fri, 20 May 2011 15:27:49 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

---
 drivers/clk/Kconfig  |    3 
 drivers/clk/Makefile |    1 
 drivers/clk/clk.c    |  229 +++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/clkdev.c |    7 +
 include/linux/clk.h  |  102 +++++++++++++++++--
 5 files changed, 332 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 4168c88..e611e34 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -2,3 +2,6 @@
 config CLKDEV_LOOKUP
 	bool
 	select HAVE_CLK
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
index 0000000..ad90a90
--- /dev/null
+++ b/drivers/clk/clk.c
@@ -0,0 +1,229 @@
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
+	struct clk_hw_ops	*ops;
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
+struct clk *clk_register(struct clk_hw_ops *ops, struct clk_hw *hw,
+		const char *name)
+{
+	struct clk *clk;
+
+	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
+	if (!clk)
+		return NULL;
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
index 1d37f42..93ff870 100644
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
@@ -11,17 +12,103 @@
 #ifndef __LINUX_CLK_H
 #define __LINUX_CLK_H
 
+#include <linux/err.h>
+#include <linux/spinlock.h>
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
+ */
+struct clk_hw_ops {
+	int		(*prepare)(struct clk_hw *);
+	void		(*unprepare)(struct clk_hw *);
+	int		(*enable)(struct clk_hw *);
+	void		(*disable)(struct clk_hw *);
+	unsigned long	(*recalc_rate)(struct clk_hw *);
+	long		(*round_rate)(struct clk_hw *, unsigned long);
+	struct clk *	(*get_parent)(struct clk_hw *);
+};
+
+/**
+ * clk_prepare - prepare clock for atomic enabling.
+ *
+ * @clk: The clock to prepare
+ *
+ * Do any possibly sleeping initialisation on @clk, allowing the clock to be
+ * later enabled atomically (via clk_enable). This function may sleep.
  */
+int clk_prepare(struct clk *clk);
 
+/**
+ * clk_unprepare - release clock from prepared state
+ *
+ * @clk: The clock to release
+ *
+ * Do any (possibly sleeping) cleanup on clk. This function may sleep.
+ */
+void clk_unprepare(struct clk *clk);
+
+#else /* !CONFIG_GENERIC_CLK */
 
 /*
- * struct clk - an machine class defined object / cookie.
+ * For !CONFIG_GENERIC_CLK, we don't enforce any atomicity
+ * requirements for clk_enable/clk_disable, so the prepare and unprepare
+ * functions are no-ops
  */
-struct clk;
+static inline int clk_prepare(struct clk *clk) { return 0; }
+static inline void clk_unprepare(struct clk *clk) { }
+
+#endif /* !CONFIG_GENERIC_CLK */
 
 /**
  * clk_get - lookup and obtain a reference to a clock producer.
@@ -67,6 +154,7 @@ void clk_disable(struct clk *clk);
 /**
  * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
  *		  This is only valid once the clock source has been enabled.
+ *		  Returns zero if the clock rate is unknown.
  * @clk: clock source
  */
 unsigned long clk_get_rate(struct clk *clk);
@@ -83,12 +171,6 @@ unsigned long clk_get_rate(struct clk *clk);
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
