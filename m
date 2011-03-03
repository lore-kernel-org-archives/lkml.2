Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab1CCGk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:40:58 -0500
Received: from ozlabs.org ([203.10.76.45]:42114 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144Ab1CCGkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:40:41 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1/2] Add a common struct clk
Message-Id: <1299134429.101167.227629761799.1.gpush@pororo>
In-Reply-To: <1299134429.100626.661279191478.0.gpush@pororo>
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
Date: Thu, 03 Mar 2011 14:40:29 +0800
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
 drivers/clk/clk.c    |  132 ++++++++++++++++++++++++++++++++++
 drivers/clk/clkdev.c |    7 +
 include/linux/clk.h  |  164 ++++++++++++++++++++++++++++++++++++++++---
 5 files changed, 298 insertions(+), 9 deletions(-)

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
index 0000000..0bc9c6f
--- /dev/null
+++ b/drivers/clk/clk.c
@@ -0,0 +1,132 @@
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
+	mutex_lock(&clk->prepare_lock);
+	if (clk->prepare_count == 0 && clk->ops->prepare)
+		ret = clk->ops->prepare(clk);
+
+	if (!ret)
+		clk->prepare_count++;
+	mutex_unlock(&clk->prepare_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_prepare);
+
+void clk_unprepare(struct clk *clk)
+{
+	mutex_lock(&clk->prepare_lock);
+
+	WARN_ON(clk->prepare_count == 0);
+
+	if (--clk->prepare_count == 0 && clk->ops->unprepare) {
+		WARN_ON(clk->enable_count != 0);
+		clk->ops->unprepare(clk);
+	}
+
+	mutex_unlock(&clk->prepare_lock);
+}
+EXPORT_SYMBOL_GPL(clk_unprepare);
+
+int clk_enable(struct clk *clk)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	WARN_ON(clk->prepare_count == 0);
+
+	spin_lock_irqsave(&clk->enable_lock, flags);
+	if (clk->enable_count == 0 && clk->ops->enable)
+		ret = clk->ops->enable(clk);
+
+	if (!ret)
+		clk->enable_count++;
+	spin_unlock_irqrestore(&clk->enable_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&clk->enable_lock, flags);
+
+	WARN_ON(clk->enable_count == 0);
+
+	if (!--clk->enable_count == 0 && clk->ops->disable)
+		clk->ops->disable(clk);
+
+	spin_unlock_irqrestore(&clk->enable_lock, flags);
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
+	might_sleep();
+
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
+
+int __clk_get(struct clk *clk)
+{
+	if (clk->ops->get)
+		return clk->ops->get(clk);
+	return 1;
+}
+
+void __clk_put(struct clk *clk)
+{
+	if (clk->ops->put)
+		clk->ops->put(clk);
+}
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 0fc0a79..a7999d2 100644
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
index 1d37f42..7b406bd 100644
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
@@ -11,18 +12,168 @@
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
+ * @enable_lock:	lock for atomic enable
+ * @prepare_count:	count of clk_prepare() calls active on this clock
+ * @prepare_lock:	lock for sleepable prepare
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
+ * The @enable_lock and @prepare_lock members are used to serialise accesses
+ * to the ops->enable and ops->prepare functions (and the corresponding
+ * ops->disable and ops->unprepare functions).
  */
+struct clk {
+	const struct clk_ops	*ops;
+	unsigned int		enable_count;
+	unsigned int		prepare_count;
+	spinlock_t		enable_lock;
+	struct mutex		prepare_lock;
+};
 
+/* static initialiser for clocks. */
+#define INIT_CLK(name, o) {						\
+	.ops		= &o,						\
+	.enable_lock	= __SPIN_LOCK_UNLOCKED(name.enable_lock),	\
+	.prepare_lock	= __MUTEX_INITIALIZER(name.prepare_lock),	\
+}
+
+/**
+ * struct clk_ops -  Callback operations for clocks; these are to be provided
+ * by the clock implementation, and will be called by drivers through the clk_*
+ * API.
+ *
+ * @prepare:	Prepare the clock for enabling. This must not return until
+ *		the clock is fully prepared, and it's safe to call clk_enable.
+ *		This callback is intended to allow clock implementations to
+ *		do any initialisation that may sleep. Called with
+ *		clk->prepare_lock held.
+ *
+ * @unprepare:	Release the clock from its prepared state. This will typically
+ *		undo any work done in the @prepare callback. Called with
+ *		clk->prepare_lock held.
+ *
+ * @enable:	Enable the clock atomically. This must not return until the
+ *		clock is generating a valid clock signal, usable by consumer
+ *		devices. Called with clk->enable_lock held. This function
+ *		must not sleep.
+ *
+ * @disable:	Disable the clock atomically. Called with clk->enable_lock held.
+ *		This function must not sleep.
+ *
+ * @get:	Called by the core clock code when a device driver acquires a
+ *		clock via clk_get(). Optional.
+ *
+ * @put:	Called by the core clock code when a devices driver releases a
+ *		clock via clk_put(). Optional.
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
+ *
+ * For other callbacks, see the corresponding clk_* functions. Parameters and
+ * return values are passed directly from/to these API functions, or
+ * -ENOSYS (or zero, in the case of clk_get_rate) is returned if the callback
+ * is NULL, see drivers/clk/clk.c for implementation details. All are optional.
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
+static inline int clk_prepare(struct clk *clk) { return 0; }
+static inline void clk_unprepare(struct clk *clk) { }
+
+#endif /* !CONFIG_USE_COMMON_STRUCT_CLK */
+
 /**
  * clk_get - lookup and obtain a reference to a clock producer.
  * @dev: device for clock "consumer"
@@ -67,6 +218,7 @@ void clk_disable(struct clk *clk);
 /**
  * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
  *		  This is only valid once the clock source has been enabled.
+ *		  Returns zero if the clock rate is unknown.
  * @clk: clock source
  */
 unsigned long clk_get_rate(struct clk *clk);
@@ -83,12 +235,6 @@ unsigned long clk_get_rate(struct clk *clk);
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
