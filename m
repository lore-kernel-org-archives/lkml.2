Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab1BGGIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 01:08:30 -0500
Received: from ozlabs.org ([203.10.76.45]:35558 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab1BGGI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 01:08:28 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [RFC,PATCH 1/3] Add a common struct clk
Message-Id: <1297058877.800158.458894385837.1.gpush@pororo>
In-Reply-To: <201102011711.31258.jeremy.kerr@canonical.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Russell King <linux@arm.linux.org.uk>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Mon, 07 Feb 2011 14:07:57 +0800
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
	unsigned int		prepare_count;
	spinlock_t		enable_lock;
	struct mutex		prepare_lock;
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

---
 drivers/clk/Kconfig  |    3 
 drivers/clk/Makefile |    1 
 drivers/clk/clk.c    |  134 +++++++++++++++++++++++++++++++
 drivers/clk/clkdev.c |    5 +
 include/linux/clk.h  |  184 ++++++++++++++++++++++++++++++++++++++++---
 5 files changed, 318 insertions(+), 9 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 4168c88..6e3ae54 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -2,3 +2,6 @@
 config CLKDEV_LOOKUP
 	bool
 	select HAVE_CLK
+
+config USE_COMMON_STRUCT_CLK
+	bool
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 07613fa..a1a06d3 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -1,2 +1,3 @@
 
 obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
+obj-$(CONFIG_USE_COMMON_STRUCT_CLK) += clk.o
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
new file mode 100644
index 0000000..12e0daf
--- /dev/null
+++ b/drivers/clk/clk.c
@@ -0,0 +1,134 @@
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
+
+int clk_prepare(struct clk *clk)
+{
+	int ret = 0;
+
+	if (!clk->ops->prepare)
+		return 0;
+
+	mutex_lock(&clk->prepare_lock);
+	if (clk->prepare_count == 0)
+		ret = clk->ops->prepare(clk);
+
+	if (!ret)
+		clk->prepare_count++;
+	mutex_unlock(&clk->prepare_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(clk_prepare);
+
+void clk_unprepare(struct clk *clk)
+{
+	if (!clk->ops->unprepare)
+		return;
+
+	mutex_lock(&clk->prepare_lock);
+	if (--clk->prepare_count == 0)
+		clk->ops->unprepare(clk);
+
+	mutex_unlock(&clk->prepare_lock);
+}
+EXPORT_SYMBOL_GPL(clk_unprepare);
+
+int clk_enable(struct clk *clk)
+{
+	int ret = 0;
+
+	if (!clk->ops->enable)
+		return 0;
+
+	spin_lock(&clk->enable_lock);
+	if (!clk->enable_count)
+		ret = clk->ops->enable(clk);
+
+	if (!ret)
+		clk->enable_count++;
+	spin_unlock(&clk->enable_lock);
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
+	spin_lock(&clk->enable_lock);
+
+	WARN_ON(!clk->enable_count);
+
+	if (!--clk->enable_count)
+		clk->ops->disable(clk);
+
+	spin_unlock(&clk->enable_lock);
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
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 0fc0a79..17619c7 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -84,12 +84,17 @@ struct clk *clk_get(struct device *dev, const char *con_id)
 }
 EXPORT_SYMBOL(clk_get);
 
+#ifndef CONFIG_USE_COMMON_STRUCT_CLK
+/* For the common struct clk case, clk_put is provided by clk.c */
+
 void clk_put(struct clk *clk)
 {
 	__clk_put(clk);
 }
 EXPORT_SYMBOL(clk_put);
 
+#endif
+
 void clkdev_add(struct clk_lookup *cl)
 {
 	mutex_lock(&clocks_mutex);
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 1d37f42..e081ca1 100644
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
@@ -11,18 +12,189 @@
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
+/* If we're using the common struct clk, we define the base clk object here */
+
+/**
+ * struct clk - hardware independent clock structure
+ * @ops:		implementation-specific ops for this clock
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
  */
+struct clk {
+	const struct clk_ops	*ops;
+	unsigned int		enable_count;
+	unsigned int		prepare_count;
+	spinlock_t		enable_lock;
+	struct mutex		prepare_lock;
+};
+
+/* static initialiser for non-atomic clocks */
+#define INIT_CLK(name, o) {						\
+	.ops		= &o,						\
+	.enable_count	= 0,						\
+	.prepare_count	= 0,						\
+	.enable_lock	= __SPIN_LOCK_UNLOCKED(name.enable_lock),	\
+	.prepare_lock	= __MUTEX_INITIALIZER(name.prepare_lock),	\
+}
 
+/**
+ * struct clk_ops -  Callback operations for clocks; these are to be provided
+ * by the clock implementation, and will be called by drivers through the clk_*
+ * API.
+ *
+ * @prepare:	Prepare the clock for enabling. This must not return until
+ *		the clock is fully prepared, and it's safe to call clk_enable.
+ *		This callback is intended to allow clock implementations to
+ *		do any initialisation that may block. Called with
+ *		clk->prepare_lock held.
+ *
+ * @unprepare:	Release the clock from its prepared state. This will typically
+ *		undo any work done in the @prepare callback. Called with
+ *		clk->prepare_lock held.
+ *
+ * @enable:	Enable the clock atomically. This must not return until the
+ *		clock is generating a valid clock signal, usable by consumer
+ *		devices. Called with clk->enable_lock held.
+ *
+ * @disable:	Disable the clock atomically. Called with clk->enable_lock held.
+ *
+ * @get:	Called by the core clock code when a device driver acquires a
+ *		clock via clk_get(). Optional.
+ *
+ * @put:	Called by the core clock code when a devices driver releases a
+ *		clock via clk_put(). Optional.
+ *
+ * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
+ * implementations to split any work between atomic (enable) and sleepable
+ * (prepare) contexts.  If a clock requires blocking code to be turned on, this
+ * should be done in clk_prepare. Switching that will not block should be done
+ * in clk_enable.
+ *
+ * Typically, drivers will call clk_prepare when a clock may be needed later
+ * (eg. when a device is opened), and clk_enable when the clock is actually
+ * required (eg. from an interrupt).
+ *
+ * For other callbacks, see the corresponding clk_* functions. Parameters and
+ * return values are passed directly from/to these API functions, or
+ * -ENOSYS (or zero, in the case of clk_get_rate) is returned if the callback
+ * is NULL, see kernel/clk.c for implementation details. All are optional.
+ */
+struct clk_ops {
+	int		(*prepare)(struct clk *);
+	void		(*unprepare)(struct clk *);
+	int		(*enable)(struct clk *);
+	void		(*disable)(struct clk *);
+	int		(*get)(struct clk *);
+	void		(*put)(struct clk *);
+	unsigned long	(*get_rate)(struct clk *);
+	long		(*round_rate)(struct clk *, unsigned long);
+	int		(*set_rate)(struct clk *, unsigned long);
+	int		(*set_parent)(struct clk *, struct clk *);
+	struct clk *	(*get_parent)(struct clk *);
+};
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
+ * clk_prepare - prepare clock for atomic enabling.
+ *
+ * @clk: The clock to prepare
+ *
+ * Do any blocking initialisation on @clk, allowing the clock to be later
+ * enabled atomically (via clk_enable). This function may sleep.
+ */
+int clk_prepare(struct clk *clk);
+
+/**
+ * clk_unprepare - release clock from prepared state
+ *
+ * @clk: The clock to release
+ *
+ * Do any (possbly blocking) cleanup on clk. This function may sleep.
+ */
+void clk_unprepare(struct clk *clk);
+
+/**
+ * clk_common_init - initialise a clock for driver usage
+ *
+ * @clk: The clock to initialise
+ *
+ * Used for runtime intialization of clocks; you don't need to call this
+ * if your clock has been (statically) initialized with INIT_CLK.
+ */
+static inline void clk_common_init(struct clk *clk)
+{
+	clk->enable_count = clk->prepare_count = 0;
+	spin_lock_init(&clk->enable_lock);
+	mutex_init(&clk->prepare_lock);
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
+/*
+ * For !CONFIG_USE_COMMON_STRUCT_CLK, we don't enforce any atomicity
+ * requirements for clk_enable/clk_disable, so the prepare and unprepare
+ * functions are no-ops
+ */
+int clk_prepare(struct clk *clk) { return 0; }
+void clk_unprepare(struct clk *clk) { }
+
+#endif /* !CONFIG_USE_COMMON_STRUCT_CLK */
+
 /**
  * clk_get - lookup and obtain a reference to a clock producer.
  * @dev: device for clock "consumer"
@@ -83,12 +255,6 @@ unsigned long clk_get_rate(struct clk *clk);
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
