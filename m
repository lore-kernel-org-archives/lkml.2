Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab0LHCI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:08:28 -0500
Received: from ozlabs.org ([203.10.76.45]:54358 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164Ab0LHCIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 21:08:25 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1/2] Add a common struct clk
Message-Id: <1291774094.270194.710085940392.1.gpush@pororo>
In-Reply-To: <1291774094.269634.503532219345.0.gpush@pororo>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Wed, 08 Dec 2010 10:08:14 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently have ~21 definitions of struct clk in the ARM architecture,
each defined on a per-platform basis. This makes it difficult to define
platform- (or architecture-) independent clock sources without making
assumptions about struct clk, and impossible to compile two
platforms with different struct clks into a single image.

This change is an effort to unify struct clk where possible, by defining
a common struct clk, containing a set of clock operations. Different
clock implementations can set their own operations, and have a standard
interface for generic code. The callback interface is exposed to the
kernel proper, while the clock implementations only need to be seen by
the platform internals.

This allows us to share clock code among platforms, and makes it
possible to dynamically create clock devices in platform-independent
code.

Platforms can enable the generic struct clock through
CONFIG_USE_COMMON_STRUCT_CLK. In this case, the clock infrastructure
consists of a common struct clk:

struct clk {
	const struct clk_ops	*ops;
	unsigned int		enable_count;
	int			flags;
	union {
		struct mutex	mutex;
		spinlock_t	spinlock;
	} lock;
};

And a set of clock operations (defined per type of clock):

struct clk_ops {
	int             (*enable)(struct clk *);
	void            (*disable)(struct clk *);
	unsigned long   (*get_rate)(struct clk *);
	[...]
};

To define a hardware-specific clock, machine code can "subclass" the
struct clock into a new struct (adding any device-specific data), and
provide a set of operations:

struct clk_foo {
	struct clk	clk;
	void __iomem	*some_register;
};

struct clk_ops clk_foo_ops = {
	.get_rate = clk_foo_get_rate,
};

The common clock definitions are based on a development patch from Ben
Herrenschmidt <benh@kernel.crashing.org>.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Acked-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>

---
 arch/Kconfig        |    3 
 include/linux/clk.h |  158 +++++++++++++++++++++++++++++++++++++++++---
 kernel/Makefile     |    1 
 kernel/clk.c        |  100 +++++++++++++++++++++++++++
 4 files changed, 253 insertions(+), 9 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8bf0fa6..212bd3c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -165,6 +165,9 @@ config HAVE_MIXED_BREAKPOINTS_REGS
 config HAVE_USER_RETURN_NOTIFIER
 	bool
 
+config USE_COMMON_STRUCT_CLK
+	bool
+
 config HAVE_PERF_EVENTS_NMI
 	bool
 	help
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 1d37f42..e09e40e 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -3,6 +3,7 @@
  *
  *  Copyright (C) 2004 ARM Limited.
  *  Written by Deep Blue Solutions Limited.
+ *  Copyright (c) 2010 Jeremy Kerr <jeremy.kerr@canonical.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -11,18 +12,163 @@
 #ifndef __LINUX_CLK_H
 #define __LINUX_CLK_H
 
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+
 struct device;
 
-/*
- * The base API.
+#ifdef CONFIG_USE_COMMON_STRUCT_CLK
+
+#define CLK_ATOMIC	0x1
+
+/* If we're using the common struct clk, we define the base clk object here */
+
+/**
+ * struct clk - hardware independent clock structure
+ * @clk_ops:		implementation-specific ops for this clock
+ * @enable_count:	count of clk_enable() calls active on this clock
+ * @flags:		platform-independent flags
+ * @lock:		lock for enable/disable or other HW-specific ops
+ *
+ * The base clock object, used by drivers for hardware-independent manipulation
+ * of clock lines. This will be 'subclassed' by device-specific implementations,
+ * which add device-specific data to struct clk. For example:
+ *
+ *  struct clk_foo {
+ *      struct clk;
+ *      [device specific fields]
+ *  };
+ *
+ * The clock driver code will manage the device-specific data, and pass
+ * clk_foo.clk to the common clock code. The clock driver will be called
+ * through the @ops callbacks.
+ *
+ * The @lock member provides either a spinlock or a mutex to protect (at least)
+ * @enable_count. The type of lock used will depend on @flags; if CLK_ATOMIC is
+ * set, then the core clock code will use a spinlock, otherwise a mutex. This
+ * lock will be acquired during clk_enable and clk_disable, so for atomic
+ * clocks, these ops callbacks must not sleep.
+ *
+ * The choice of atomic or non-atomic clock depends on how the clock is enabled.
+ * Typically, you'll want to use a non-atomic clock. For clocks that need to be
+ * enabled/disabled in interrupt context, use CLK_ATOMIC. Note that atomic
+ * clocks with parents will typically cascade enable/disable operations to
+ * their parent, so the parent of an atomic clock *must* be atomic too.
+ */
+struct clk {
+	const struct clk_ops	*ops;
+	unsigned int		enable_count;
+	int			flags;
+	union {
+		struct mutex	mutex;
+		spinlock_t	spinlock;
+	} lock;
+};
+
+/* static initialiser for non-atomic clocks */
+#define INIT_CLK(name, o) {						\
+	.ops		= &o,						\
+	.enable_count	= 0,						\
+	.flags		= 0,						\
+	.lock.mutex	= __MUTEX_INITIALIZER(name.lock.mutex),		\
+}
+
+/* static initialiser for atomic clocks */
+#define INIT_CLK_ATOMIC(name, o) {					\
+	.ops		= &o,						\
+	.enable_count	= 0,						\
+	.flags		= CLK_ATOMIC,					\
+	.lock.spinlock	= __SPIN_LOCK_UNLOCKED(name.lock.spinlock),	\
+}
+
+/**
+ * clk_ops: Callback operations for clocks; these are to be provided by the
+ * clock implementation, and will be called by drivers through the clk_* API.
+ *
+ * @enable:	Enable the clock. This must not return until the clock is
+ *		generating a valid clock signal, usable by consumer devices.
+ *		Called with clk->lock held.
+ *
+ * @disable:	Disable the clock. Called with clk->lock held.
+ *
+ * @get	/ @put:	Called by the core clock code to notify the driver about
+ *		refounts as clk is passed to drivers. Optional.
+ *
+ * For other callbacks, see the corresponding clk_* functions. Parameters and
+ * return values are passed directly from/to these API functions directly, or
+ * -ENOSYS is returned if the callback is NULL, see kernel/clk.c for
+ * implementation details. All are optional.
  */
+struct clk_ops {
+       int		(*enable)(struct clk *);
+       void		(*disable)(struct clk *);
+       int		(*get)(struct clk *);
+       void		(*put)(struct clk *);
+       unsigned long	(*get_rate)(struct clk *);
+       long		(*round_rate)(struct clk *, unsigned long);
+       int		(*set_rate)(struct clk *, unsigned long);
+       int		(*set_parent)(struct clk *, struct clk *);
+       struct clk *	(*get_parent)(struct clk *);
+};
 
+static inline void __clk_lock(struct clk *clk)
+{
+	if (clk->flags & CLK_ATOMIC)
+		spin_lock(&clk->lock.spinlock);
+	else
+		mutex_lock(&clk->lock.mutex);
+}
+
+static inline void __clk_unlock(struct clk *clk)
+{
+	if (clk->flags & CLK_ATOMIC)
+		spin_unlock(&clk->lock.spinlock);
+	else
+		mutex_unlock(&clk->lock.mutex);
+}
+
+/**
+ * __clk_get - update clock-specific refcounter
+ *
+ * @clk: The clock to refcount
+ *
+ * Before a clock is returned from clk_get, this function should be called
+ * to update any clock-specific refcounting.
+ *
+ * Returns non-zero on success, zero on failure.
+ *
+ * Drivers should not need this function; it is only needed by the
+ * arch-specific clk_get() implementations.
+ */
+int __clk_get(struct clk *clk);
+
+/**
+ * clk_common_init - initialise a clock for driver usage
+ *
+ * Used for runtime intialization of clocks; you don't need to call this
+ * if your clock has been (statically) initialized with INIT_CLK.
+ */
+static inline void clk_common_init(struct clk *clk)
+{
+	clk->enable_count = 0;
+	if (clk->flags & CLK_ATOMIC)
+		spin_lock_init(&clk->lock.spinlock);
+	else
+		mutex_init(&clk->lock.mutex);
+}
+
+#else /* !CONFIG_USE_COMMON_STRUCT_CLK */
 
 /*
- * struct clk - an machine class defined object / cookie.
+ * Global clock object, actual structure is declared per-machine
  */
 struct clk;
 
+static inline void clk_common_init(struct clk *clk) { }
+
+#endif /* !CONFIG_USE_COMMON_STRUCT_CLK */
+
 /**
  * clk_get - lookup and obtain a reference to a clock producer.
  * @dev: device for clock "consumer"
@@ -83,12 +229,6 @@ unsigned long clk_get_rate(struct clk *clk);
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
diff --git a/kernel/Makefile b/kernel/Makefile
index 0b5ff08..01383a0 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
+obj-$(CONFIG_USE_COMMON_STRUCT_CLK) += clk.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/clk.c b/kernel/clk.c
new file mode 100644
index 0000000..1545e69
--- /dev/null
+++ b/kernel/clk.c
@@ -0,0 +1,100 @@
+/*
+ * Copyright (C) 2010 Canonical Ltd <jeremy.kerr@canonical.com>
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
+
+int clk_enable(struct clk *clk)
+{
+	int ret = 0;
+
+	if (!clk->ops->enable)
+		return 0;
+
+	__clk_lock(clk);
+	if (!clk->enable_count)
+		ret = clk->ops->enable(clk);
+
+	if (!ret)
+		clk->enable_count++;
+	__clk_unlock(clk);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+	if (!clk->ops->disable)
+		return;
+
+	__clk_lock(clk);
+
+	if (!--clk->enable_count)
+		clk->ops->disable(clk);
+
+	__clk_unlock(clk);
+}
+EXPORT_SYMBOL_GPL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	if (clk->ops->get_rate)
+		return clk->ops->get_rate(clk);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(clk_get_rate);
+
+int __clk_get(struct clk *clk)
+{
+	if (clk->ops->get)
+		return clk->ops->get(clk);
+	return 1;
+}
+EXPORT_SYMBOL_GPL(__clk_get);
+
+void clk_put(struct clk *clk)
+{
+	if (clk->ops->put)
+		clk->ops->put(clk);
+}
+EXPORT_SYMBOL_GPL(clk_put);
+
+long clk_round_rate(struct clk *clk, unsigned long rate)
+{
+	if (clk->ops->round_rate)
+		return clk->ops->round_rate(clk, rate);
+	return -ENOSYS;
+}
+EXPORT_SYMBOL_GPL(clk_round_rate);
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	if (clk->ops->set_rate)
+		return clk->ops->set_rate(clk, rate);
+	return -ENOSYS;
+}
+EXPORT_SYMBOL_GPL(clk_set_rate);
+
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	if (clk->ops->set_parent)
+		return clk->ops->set_parent(clk, parent);
+	return -ENOSYS;
+}
+EXPORT_SYMBOL_GPL(clk_set_parent);
+
+struct clk *clk_get_parent(struct clk *clk)
+{
+	if (clk->ops->get_parent)
+		return clk->ops->get_parent(clk);
+	return ERR_PTR(-ENOSYS);
+}
+EXPORT_SYMBOL_GPL(clk_get_parent);
