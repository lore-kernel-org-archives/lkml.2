Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1BMJp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:45:56 -0500
Received: from smtp-out.google.com ([74.125.121.67]:58649 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab1BMJnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:19 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/21] ARM: tegra: clock: Convert global lock to a lock per clock
Date: Sun, 13 Feb 2011 01:40:22 -0800
Message-Id: <1297590033-15035-11-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Give each clock its own lock, and remove all lock traversals from
parent to child clocks to prevent AB-BA deadlocks.

This brings the locking in line with the common struct clk
patches and should make conversion simple.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/clock.c            |  370 ++++++++++++++++++++------------
 arch/arm/mach-tegra/clock.h            |   13 +-
 arch/arm/mach-tegra/include/mach/clk.h |    1 +
 arch/arm/mach-tegra/tegra2_clocks.c    |  119 ++++++++---
 4 files changed, 327 insertions(+), 176 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index a1193f9..34a1f8d 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -18,83 +18,116 @@
 
 #include <linux/kernel.h>
 #include <linux/clk.h>
-#include <linux/list.h>
+#include <linux/clkdev.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/list.h>
 #include <linux/module.h>
-#include <linux/debugfs.h>
-#include <linux/slab.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
-#include <linux/clkdev.h>
+#include <linux/slab.h>
+
+#include <mach/clk.h>
 
 #include "board.h"
 #include "clock.h"
 
+/*
+ * Locking:
+ *
+ * Each struct clk has a spinlock.
+ *
+ * To avoid AB-BA locking problems, locks must always be traversed from child
+ * clock to parent clock.  For example, when enabling a clock, the clock's lock
+ * is taken, and then clk_enable is called on the parent, which take's the
+ * parent clock's lock.  There is one exceptions to this ordering: When dumping
+ * the clock tree through debugfs.  In this case, clk_lock_all is called,
+ * which attemps to iterate through the entire list of clocks and take every
+ * clock lock.  If any call to spin_trylock fails, all locked clocks are
+ * unlocked, and the process is retried.  When all the locks are held,
+ * the only clock operation that can be called is clk_get_rate_all_locked.
+ *
+ * Within a single clock, no clock operation can call another clock operation
+ * on itself, except for clk_get_rate_locked.  Any clock operation can call
+ * any other clock operation on any of it's possible parents.
+ *
+ * An additional mutex, clock_list_lock, is used to protect the list of all
+ * clocks.
+ *
+ * The clock operations must lock internally to protect against
+ * read-modify-write on registers that are shared by multiple clocks
+ */
+static DEFINE_MUTEX(clock_list_lock);
 static LIST_HEAD(clocks);
 
-static DEFINE_SPINLOCK(clock_lock);
 struct clk *tegra_get_clock_by_name(const char *name)
 {
 	struct clk *c;
 	struct clk *ret = NULL;
-	unsigned long flags;
-	spin_lock_irqsave(&clock_lock, flags);
+	mutex_lock(&clock_list_lock);
 	list_for_each_entry(c, &clocks, node) {
 		if (strcmp(c->name, name) == 0) {
 			ret = c;
 			break;
 		}
 	}
-	spin_unlock_irqrestore(&clock_lock, flags);
+	mutex_unlock(&clock_list_lock);
 	return ret;
 }
 
-static void clk_recalculate_rate(struct clk *c)
+/* Must be called with c->spinlock held */
+static unsigned long clk_predict_rate_from_parent(struct clk *c, struct clk *p)
 {
 	u64 rate;
 
-	if (!c->parent)
-		return;
-
-	rate = c->parent->rate;
+	rate = clk_get_rate(p);
 
 	if (c->mul != 0 && c->div != 0) {
-		rate = rate * c->mul;
+		rate *= c->mul;
 		do_div(rate, c->div);
 	}
 
-	if (rate > c->max_rate)
-		pr_warn("clocks: Set clock %s to rate %llu, max is %lu\n",
-			c->name, rate, c->max_rate);
-
-	c->rate = rate;
+	return rate;
 }
 
-int clk_reparent(struct clk *c, struct clk *parent)
+/* Must be called with c->spinlock held */
+unsigned long clk_get_rate_locked(struct clk *c)
 {
-	c->parent = parent;
-	list_del(&c->sibling);
-	list_add_tail(&c->sibling, &parent->children);
-	return 0;
-}
+	unsigned long rate;
 
-static void propagate_rate(struct clk *c)
-{
-	struct clk *clkp;
+	if (c->parent)
+		rate = clk_predict_rate_from_parent(c, c->parent);
+	else
+		rate = c->rate;
 
-	list_for_each_entry(clkp, &c->children, sibling) {
-		clk_recalculate_rate(clkp);
-		propagate_rate(clkp);
-	}
+	return rate;
 }
 
-void clk_init(struct clk *c)
+unsigned long clk_get_rate(struct clk *c)
 {
 	unsigned long flags;
+	unsigned long rate;
 
-	spin_lock_irqsave(&clock_lock, flags);
+	spin_lock_irqsave(&c->spinlock, flags);
+
+	rate = clk_get_rate_locked(c);
+
+	spin_unlock_irqrestore(&c->spinlock, flags);
+
+	return rate;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+int clk_reparent(struct clk *c, struct clk *parent)
+{
+	c->parent = parent;
+	return 0;
+}
 
-	INIT_LIST_HEAD(&c->children);
-	INIT_LIST_HEAD(&c->sibling);
+void clk_init(struct clk *c)
+{
+	spin_lock_init(&c->spinlock);
 
 	if (c->ops && c->ops->init)
 		c->ops->init(c);
@@ -108,33 +141,31 @@ void clk_init(struct clk *c)
 			c->state = ON;
 	}
 
-	clk_recalculate_rate(c);
-
+	mutex_lock(&clock_list_lock);
 	list_add(&c->node, &clocks);
-
-	if (c->parent)
-		list_add_tail(&c->sibling, &c->parent->children);
-
-	spin_unlock_irqrestore(&clock_lock, flags);
+	mutex_unlock(&clock_list_lock);
 }
 
-int clk_enable_locked(struct clk *c)
+int clk_enable(struct clk *c)
 {
-	int ret;
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&c->spinlock, flags);
 
 	if (c->refcnt == 0) {
 		if (c->parent) {
-			ret = clk_enable_locked(c->parent);
+			ret = clk_enable(c->parent);
 			if (ret)
-				return ret;
+				goto out;
 		}
 
 		if (c->ops && c->ops->enable) {
 			ret = c->ops->enable(c);
 			if (ret) {
 				if (c->parent)
-					clk_disable_locked(c->parent);
-				return ret;
+					clk_disable(c->parent);
+				goto out;
 			}
 			c->state = ON;
 #ifdef CONFIG_DEBUG_FS
@@ -143,27 +174,21 @@ int clk_enable_locked(struct clk *c)
 		}
 	}
 	c->refcnt++;
-
-	return 0;
+out:
+	spin_unlock_irqrestore(&c->spinlock, flags);
+	return ret;
 }
+EXPORT_SYMBOL(clk_enable);
 
-int clk_enable(struct clk *c)
+void clk_disable(struct clk *c)
 {
-	int ret;
 	unsigned long flags;
 
-	spin_lock_irqsave(&clock_lock, flags);
-	ret = clk_enable_locked(c);
-	spin_unlock_irqrestore(&clock_lock, flags);
-
-	return ret;
-}
-EXPORT_SYMBOL(clk_enable);
+	spin_lock_irqsave(&c->spinlock, flags);
 
-void clk_disable_locked(struct clk *c)
-{
 	if (c->refcnt == 0) {
 		WARN(1, "Attempting to disable clock %s with refcnt 0", c->name);
+		spin_unlock_irqrestore(&c->spinlock, flags);
 		return;
 	}
 	if (c->refcnt == 1) {
@@ -171,49 +196,39 @@ void clk_disable_locked(struct clk *c)
 			c->ops->disable(c);
 
 		if (c->parent)
-			clk_disable_locked(c->parent);
+			clk_disable(c->parent);
 
 		c->state = OFF;
 	}
 	c->refcnt--;
-}
 
-void clk_disable(struct clk *c)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&clock_lock, flags);
-	clk_disable_locked(c);
-	spin_unlock_irqrestore(&clock_lock, flags);
+	spin_unlock_irqrestore(&c->spinlock, flags);
 }
 EXPORT_SYMBOL(clk_disable);
 
-int clk_set_parent_locked(struct clk *c, struct clk *parent)
+int clk_set_parent(struct clk *c, struct clk *parent)
 {
 	int ret;
+	unsigned long flags;
+	unsigned long new_rate;
+	unsigned long old_rate;
 
-	if (!c->ops || !c->ops->set_parent)
-		return -ENOSYS;
-
-	ret = c->ops->set_parent(c, parent);
-
-	if (ret)
-		return ret;
+	spin_lock_irqsave(&c->spinlock, flags);
 
-	clk_recalculate_rate(c);
+	if (!c->ops || !c->ops->set_parent) {
+		ret = -ENOSYS;
+		goto out;
+	}
 
-	propagate_rate(c);
+	new_rate = clk_predict_rate_from_parent(c, parent);
+	old_rate = clk_get_rate_locked(c);
 
-	return 0;
-}
+	ret = c->ops->set_parent(c, parent);
+	if (ret)
+		goto out;
 
-int clk_set_parent(struct clk *c, struct clk *parent)
-{
-	int ret;
-	unsigned long flags;
-	spin_lock_irqsave(&clock_lock, flags);
-	ret = clk_set_parent_locked(c, parent);
-	spin_unlock_irqrestore(&clock_lock, flags);
+out:
+	spin_unlock_irqrestore(&c->spinlock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(clk_set_parent);
@@ -224,64 +239,78 @@ struct clk *clk_get_parent(struct clk *c)
 }
 EXPORT_SYMBOL(clk_get_parent);
 
-int clk_set_rate_locked(struct clk *c, unsigned long rate)
+int clk_set_rate(struct clk *c, unsigned long rate)
 {
-	int ret;
+	int ret = 0;
+	unsigned long flags;
+	unsigned long old_rate;
+
+	spin_lock_irqsave(&c->spinlock, flags);
+
+	if (!c->ops || !c->ops->set_rate) {
+		ret = -ENOSYS;
+		goto out;
+	}
+
+	old_rate = clk_get_rate_locked(c);
 
 	if (rate > c->max_rate)
 		rate = c->max_rate;
 
-	if (!c->ops || !c->ops->set_rate)
-		return -ENOSYS;
-
 	ret = c->ops->set_rate(c, rate);
-
 	if (ret)
-		return ret;
-
-	clk_recalculate_rate(c);
-
-	propagate_rate(c);
-
-	return 0;
-}
-
-int clk_set_rate(struct clk *c, unsigned long rate)
-{
-	int ret = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&clock_lock, flags);
-	ret = clk_set_rate_locked(c, rate);
-	spin_unlock_irqrestore(&clock_lock, flags);
+		goto out;
 
+out:
+	spin_unlock_irqrestore(&c->spinlock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(clk_set_rate);
 
-unsigned long clk_get_rate(struct clk *c)
+/* Must be called with clocks lock and all indvidual clock locks held */
+unsigned long clk_get_rate_all_locked(struct clk *c)
 {
-	unsigned long flags;
-	unsigned long ret;
-
-	spin_lock_irqsave(&clock_lock, flags);
+	u64 rate;
+	int mul = 1;
+	int div = 1;
+	struct clk *p = c;
+
+	while (p) {
+		c = p;
+		if (c->mul != 0 && c->div != 0) {
+			mul *= c->mul;
+			div *= c->div;
+		}
+		p = c->parent;
+	}
 
-	ret = c->rate;
+	rate = c->rate;
+	rate *= mul;
+	do_div(rate, div);
 
-	spin_unlock_irqrestore(&clock_lock, flags);
-	return ret;
+	return rate;
 }
-EXPORT_SYMBOL(clk_get_rate);
 
 long clk_round_rate(struct clk *c, unsigned long rate)
 {
-	if (!c->ops || !c->ops->round_rate)
-		return -ENOSYS;
+	unsigned long flags;
+	long ret;
+
+	spin_lock_irqsave(&c->spinlock, flags);
+
+	if (!c->ops || !c->ops->round_rate) {
+		ret = -ENOSYS;
+		goto out;
+	}
 
 	if (rate > c->max_rate)
 		rate = c->max_rate;
 
-	return c->ops->round_rate(c, rate);
+	ret = c->ops->round_rate(c, rate);
+
+out:
+	spin_unlock_irqrestore(&c->spinlock, flags);
+	return ret;
 }
 EXPORT_SYMBOL(clk_round_rate);
 
@@ -374,9 +403,10 @@ int __init tegra_disable_boot_clocks(void)
 
 	struct clk *c;
 
-	spin_lock_irqsave(&clock_lock, flags);
+	mutex_lock(&clock_list_lock);
 
 	list_for_each_entry(c, &clocks, node) {
+		spin_lock_irqsave(&c->spinlock, flags);
 		if (c->refcnt == 0 && c->state == ON &&
 				c->ops && c->ops->disable) {
 			pr_warning("Disabling clock %s left on by bootloader\n",
@@ -384,23 +414,85 @@ int __init tegra_disable_boot_clocks(void)
 			c->ops->disable(c);
 			c->state = OFF;
 		}
+		spin_unlock_irqrestore(&c->spinlock, flags);
 	}
 
-	spin_unlock_irqrestore(&clock_lock, flags);
-
+	mutex_unlock(&clock_list_lock);
 	return 0;
 }
 late_initcall(tegra_disable_boot_clocks);
 #endif
 
 #ifdef CONFIG_DEBUG_FS
+
+static int __clk_lock_all_spinlocks(void)
+{
+	struct clk *c;
+
+	list_for_each_entry(c, &clocks, node)
+		if (!spin_trylock(&c->spinlock))
+			goto unlock_spinlocks;
+
+	return 0;
+
+unlock_spinlocks:
+	list_for_each_entry_continue_reverse(c, &clocks, node)
+		spin_unlock(&c->spinlock);
+
+	return -EAGAIN;
+}
+
+static void __clk_unlock_all_spinlocks(void)
+{
+	struct clk *c;
+
+	list_for_each_entry_reverse(c, &clocks, node)
+		spin_unlock(&c->spinlock);
+}
+
+/*
+ * This function retries until it can take all locks, and may take
+ * an arbitrarily long time to complete.
+ * Must be called with irqs enabled, returns with irqs disabled
+ * Must be called with clock_list_lock held
+ */
+static void clk_lock_all(void)
+{
+	int ret;
+retry:
+	local_irq_disable();
+
+	ret = __clk_lock_all_spinlocks();
+	if (ret)
+		goto failed_spinlocks;
+
+	/* All locks taken successfully, return */
+	return;
+
+failed_spinlocks:
+	local_irq_enable();
+	yield();
+	goto retry;
+}
+
+/*
+ * Unlocks all clocks after a clk_lock_all
+ * Must be called with irqs disabled, returns with irqs enabled
+ * Must be called with clock_list_lock held
+ */
+static void clk_unlock_all(void)
+{
+	__clk_unlock_all_spinlocks();
+
+	local_irq_enable();
+}
+
 static struct dentry *clk_debugfs_root;
 
 
 static void clock_tree_show_one(struct seq_file *s, struct clk *c, int level)
 {
 	struct clk *child;
-	struct clk *safe;
 	const char *state = "uninit";
 	char div[8] = {0};
 
@@ -431,8 +523,12 @@ static void clock_tree_show_one(struct seq_file *s, struct clk *c, int level)
 		c->rate > c->max_rate ? '!' : ' ',
 		!c->set ? '*' : ' ',
 		30 - level * 3, c->name,
-		state, c->refcnt, div, c->rate);
-	list_for_each_entry_safe(child, safe, &c->children, sibling) {
+		state, c->refcnt, div, clk_get_rate_all_locked(c));
+
+	list_for_each_entry(child, &clocks, node) {
+		if (child->parent != c)
+			continue;
+
 		clock_tree_show_one(s, child, level + 1);
 	}
 }
@@ -440,14 +536,20 @@ static void clock_tree_show_one(struct seq_file *s, struct clk *c, int level)
 static int clock_tree_show(struct seq_file *s, void *data)
 {
 	struct clk *c;
-	unsigned long flags;
 	seq_printf(s, "   clock                          state  ref div      rate\n");
 	seq_printf(s, "--------------------------------------------------------------\n");
-	spin_lock_irqsave(&clock_lock, flags);
+
+	mutex_lock(&clock_list_lock);
+
+	clk_lock_all();
+
 	list_for_each_entry(c, &clocks, node)
 		if (c->parent == NULL)
 			clock_tree_show_one(s, c, 0);
-	spin_unlock_irqrestore(&clock_lock, flags);
+
+	clk_unlock_all();
+
+	mutex_unlock(&clock_list_lock);
 	return 0;
 }
 
diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index 20f0ce6..dd5c029 100644
--- a/arch/arm/mach-tegra/clock.h
+++ b/arch/arm/mach-tegra/clock.h
@@ -20,8 +20,9 @@
 #ifndef __MACH_TEGRA_CLOCK_H
 #define __MACH_TEGRA_CLOCK_H
 
-#include <linux/list.h>
 #include <linux/clkdev.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
 
 #define DIV_BUS			(1 << 0)
 #define DIV_U71			(1 << 1)
@@ -75,8 +76,6 @@ enum clk_state {
 struct clk {
 	/* node for master clocks list */
 	struct list_head	node;		/* node for list of all clocks */
-	struct list_head	children;	/* list of children */
-	struct list_head	sibling;	/* node for children */
 	struct clk_lookup	lookup;
 
 #ifdef CONFIG_DEBUG_FS
@@ -122,8 +121,9 @@ struct clk {
 			struct clk			*backup;
 		} cpu;
 	} u;
-};
 
+	spinlock_t spinlock;
+};
 
 struct clk_duplicate {
 	const char *name;
@@ -143,11 +143,8 @@ void tegra2_periph_reset_assert(struct clk *c);
 void clk_init(struct clk *clk);
 struct clk *tegra_get_clock_by_name(const char *name);
 unsigned long clk_measure_input_freq(void);
-void clk_disable_locked(struct clk *c);
-int clk_enable_locked(struct clk *c);
-int clk_set_parent_locked(struct clk *c, struct clk *parent);
-int clk_set_rate_locked(struct clk *c, unsigned long rate);
 int clk_reparent(struct clk *c, struct clk *parent);
 void tegra_clk_init_from_table(struct tegra_clk_init_table *table);
+unsigned long clk_get_rate_locked(struct clk *c);
 
 #endif
diff --git a/arch/arm/mach-tegra/include/mach/clk.h b/arch/arm/mach-tegra/include/mach/clk.h
index 6338652..fa7f9ca 100644
--- a/arch/arm/mach-tegra/include/mach/clk.h
+++ b/arch/arm/mach-tegra/include/mach/clk.h
@@ -25,4 +25,5 @@ struct clk;
 void tegra_periph_reset_deassert(struct clk *c);
 void tegra_periph_reset_assert(struct clk *c);
 
+unsigned long clk_get_rate_all_locked(struct clk *c);
 #endif
diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index f03c712..ab013b1 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -23,8 +23,8 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/io.h>
-#include <linux/hrtimer.h>
 #include <linux/clkdev.h>
+#include <linux/clk.h>
 
 #include <mach/iomap.h>
 #include <mach/suspend.h>
@@ -147,6 +147,13 @@
 static void __iomem *reg_clk_base = IO_ADDRESS(TEGRA_CLK_RESET_BASE);
 static void __iomem *reg_pmc_base = IO_ADDRESS(TEGRA_PMC_BASE);
 
+/*
+ * Some clocks share a register with other clocks.  Any clock op that
+ * non-atomically modifies a register used by another clock must lock
+ * clock_register_lock first.
+ */
+static DEFINE_SPINLOCK(clock_register_lock);
+
 #define clk_writel(value, reg) \
 	__raw_writel(value, (u32)reg_clk_base + (reg))
 #define clk_readl(reg) \
@@ -330,12 +337,12 @@ static int tegra2_super_clk_set_parent(struct clk *c, struct clk *p)
 			val |= sel->value << shift;
 
 			if (c->refcnt)
-				clk_enable_locked(p);
+				clk_enable(p);
 
 			clk_writel(val, c->reg);
 
 			if (c->refcnt && c->parent)
-				clk_disable_locked(c->parent);
+				clk_disable(c->parent);
 
 			clk_reparent(c, p);
 			return 0;
@@ -378,22 +385,22 @@ static void tegra2_cpu_clk_disable(struct clk *c)
 static int tegra2_cpu_clk_set_rate(struct clk *c, unsigned long rate)
 {
 	int ret;
-	ret = clk_set_parent_locked(c->parent, c->u.cpu.backup);
+	ret = clk_set_parent(c->parent, c->u.cpu.backup);
 	if (ret) {
 		pr_err("Failed to switch cpu to clock %s\n", c->u.cpu.backup->name);
 		return ret;
 	}
 
-	if (rate == c->u.cpu.backup->rate)
+	if (rate == clk_get_rate(c->u.cpu.backup))
 		goto out;
 
-	ret = clk_set_rate_locked(c->u.cpu.main, rate);
+	ret = clk_set_rate(c->u.cpu.main, rate);
 	if (ret) {
 		pr_err("Failed to change cpu pll to %lu\n", rate);
 		return ret;
 	}
 
-	ret = clk_set_parent_locked(c->parent, c->u.cpu.main);
+	ret = clk_set_parent(c->parent, c->u.cpu.main);
 	if (ret) {
 		pr_err("Failed to switch cpu to clock %s\n", c->u.cpu.main->name);
 		return ret;
@@ -421,24 +428,45 @@ static void tegra2_bus_clk_init(struct clk *c)
 
 static int tegra2_bus_clk_enable(struct clk *c)
 {
-	u32 val = clk_readl(c->reg);
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clock_register_lock, flags);
+
+	val = clk_readl(c->reg);
 	val &= ~(BUS_CLK_DISABLE << c->reg_shift);
 	clk_writel(val, c->reg);
+
+	spin_unlock_irqrestore(&clock_register_lock, flags);
+
 	return 0;
 }
 
 static void tegra2_bus_clk_disable(struct clk *c)
 {
-	u32 val = clk_readl(c->reg);
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clock_register_lock, flags);
+
+	val = clk_readl(c->reg);
 	val |= BUS_CLK_DISABLE << c->reg_shift;
 	clk_writel(val, c->reg);
+
+	spin_unlock_irqrestore(&clock_register_lock, flags);
 }
 
 static int tegra2_bus_clk_set_rate(struct clk *c, unsigned long rate)
 {
-	u32 val = clk_readl(c->reg);
-	unsigned long parent_rate = c->parent->rate;
+	u32 val;
+	unsigned long parent_rate = clk_get_rate(c->parent);
+	unsigned long flags;
+	int ret = -EINVAL;
 	int i;
+
+	spin_lock_irqsave(&clock_register_lock, flags);
+
+	val = clk_readl(c->reg);
 	for (i = 1; i <= 4; i++) {
 		if (rate == parent_rate / i) {
 			val &= ~(BUS_CLK_DIV_MASK << c->reg_shift);
@@ -446,10 +474,14 @@ static int tegra2_bus_clk_set_rate(struct clk *c, unsigned long rate)
 			clk_writel(val, c->reg);
 			c->div = i;
 			c->mul = 1;
-			return 0;
+			ret = 0;
+			break;
 		}
 	}
-	return -EINVAL;
+
+	spin_unlock_irqrestore(&clock_register_lock, flags);
+
+	return ret;
 }
 
 static struct clk_ops tegra_bus_ops = {
@@ -511,14 +543,15 @@ static void tegra2_blink_clk_disable(struct clk *c)
 
 static int tegra2_blink_clk_set_rate(struct clk *c, unsigned long rate)
 {
-	if (rate >= c->parent->rate) {
+	unsigned long parent_rate = clk_get_rate(c->parent);
+	if (rate >= parent_rate) {
 		c->div = 1;
 		pmc_writel(0, c->reg);
 	} else {
 		unsigned int on_off;
 		u32 val;
 
-		on_off = DIV_ROUND_UP(c->parent->rate / 8, rate);
+		on_off = DIV_ROUND_UP(parent_rate / 8, rate);
 		c->div = on_off * 8;
 
 		val = (on_off & PMC_BLINK_TIMER_DATA_ON_MASK) <<
@@ -604,7 +637,7 @@ static int tegra2_pll_clk_set_rate(struct clk *c, unsigned long rate)
 
 	pr_debug("%s: %s %lu\n", __func__, c->name, rate);
 
-	input_rate = c->parent->rate;
+	input_rate = clk_get_rate(c->parent);
 	for (sel = c->u.pll.freq_table; sel->input_rate != 0; sel++) {
 		if (sel->input_rate == input_rate && sel->output_rate == rate) {
 			c->mul = sel->n;
@@ -717,9 +750,11 @@ static int tegra2_pll_div_clk_enable(struct clk *c)
 {
 	u32 val;
 	u32 new_val;
+	unsigned long flags;
 
 	pr_debug("%s: %s\n", __func__, c->name);
 	if (c->flags & DIV_U71) {
+		spin_lock_irqsave(&clock_register_lock, flags);
 		val = clk_readl(c->reg);
 		new_val = val >> c->reg_shift;
 		new_val &= 0xFFFF;
@@ -729,12 +764,15 @@ static int tegra2_pll_div_clk_enable(struct clk *c)
 		val &= ~(0xFFFF << c->reg_shift);
 		val |= new_val << c->reg_shift;
 		clk_writel(val, c->reg);
+		spin_unlock_irqrestore(&clock_register_lock, flags);
 		return 0;
 	} else if (c->flags & DIV_2) {
 		BUG_ON(!(c->flags & PLLD));
+		spin_lock_irqsave(&clock_register_lock, flags);
 		val = clk_readl(c->reg);
 		val &= ~PLLD_MISC_DIV_RST;
 		clk_writel(val, c->reg);
+		spin_unlock_irqrestore(&clock_register_lock, flags);
 		return 0;
 	}
 	return -EINVAL;
@@ -744,9 +782,11 @@ static void tegra2_pll_div_clk_disable(struct clk *c)
 {
 	u32 val;
 	u32 new_val;
+	unsigned long flags;
 
 	pr_debug("%s: %s\n", __func__, c->name);
 	if (c->flags & DIV_U71) {
+		spin_lock_irqsave(&clock_register_lock, flags);
 		val = clk_readl(c->reg);
 		new_val = val >> c->reg_shift;
 		new_val &= 0xFFFF;
@@ -756,11 +796,14 @@ static void tegra2_pll_div_clk_disable(struct clk *c)
 		val &= ~(0xFFFF << c->reg_shift);
 		val |= new_val << c->reg_shift;
 		clk_writel(val, c->reg);
+		spin_unlock_irqrestore(&clock_register_lock, flags);
 	} else if (c->flags & DIV_2) {
 		BUG_ON(!(c->flags & PLLD));
+		spin_lock_irqsave(&clock_register_lock, flags);
 		val = clk_readl(c->reg);
 		val |= PLLD_MISC_DIV_RST;
 		clk_writel(val, c->reg);
+		spin_unlock_irqrestore(&clock_register_lock, flags);
 	}
 }
 
@@ -769,10 +812,14 @@ static int tegra2_pll_div_clk_set_rate(struct clk *c, unsigned long rate)
 	u32 val;
 	u32 new_val;
 	int divider_u71;
+	unsigned long parent_rate = clk_get_rate(c->parent);
+	unsigned long flags;
+
 	pr_debug("%s: %s %lu\n", __func__, c->name, rate);
 	if (c->flags & DIV_U71) {
-		divider_u71 = clk_div71_get_divider(c->parent->rate, rate);
+		divider_u71 = clk_div71_get_divider(parent_rate, rate);
 		if (divider_u71 >= 0) {
+			spin_lock_irqsave(&clock_register_lock, flags);
 			val = clk_readl(c->reg);
 			new_val = val >> c->reg_shift;
 			new_val &= 0xFFFF;
@@ -786,10 +833,11 @@ static int tegra2_pll_div_clk_set_rate(struct clk *c, unsigned long rate)
 			clk_writel(val, c->reg);
 			c->div = divider_u71 + 2;
 			c->mul = 2;
+			spin_unlock_irqrestore(&clock_register_lock, flags);
 			return 0;
 		}
 	} else if (c->flags & DIV_2) {
-		if (c->parent->rate == rate * 2)
+		if (parent_rate == rate * 2)
 			return 0;
 	}
 	return -EINVAL;
@@ -798,15 +846,16 @@ static int tegra2_pll_div_clk_set_rate(struct clk *c, unsigned long rate)
 static long tegra2_pll_div_clk_round_rate(struct clk *c, unsigned long rate)
 {
 	int divider;
+	unsigned long parent_rate = clk_get_rate(c->parent);
 	pr_debug("%s: %s %lu\n", __func__, c->name, rate);
 
 	if (c->flags & DIV_U71) {
-		divider = clk_div71_get_divider(c->parent->rate, rate);
+		divider = clk_div71_get_divider(parent_rate, rate);
 		if (divider < 0)
 			return divider;
-		return c->parent->rate * 2 / (divider + 2);
+		return parent_rate * 2 / (divider + 2);
 	} else if (c->flags & DIV_2) {
-		return c->parent->rate / 2;
+		return parent_rate / 2;
 	}
 	return -EINVAL;
 }
@@ -912,12 +961,12 @@ static int tegra2_periph_clk_set_parent(struct clk *c, struct clk *p)
 			val |= (sel->value) << PERIPH_CLK_SOURCE_SHIFT;
 
 			if (c->refcnt)
-				clk_enable_locked(p);
+				clk_enable(p);
 
 			clk_writel(val, c->reg);
 
 			if (c->refcnt && c->parent)
-				clk_disable_locked(c->parent);
+				clk_disable(c->parent);
 
 			clk_reparent(c, p);
 			return 0;
@@ -931,9 +980,10 @@ static int tegra2_periph_clk_set_rate(struct clk *c, unsigned long rate)
 {
 	u32 val;
 	int divider;
-	pr_debug("%s: %lu\n", __func__, rate);
+	unsigned long parent_rate = clk_get_rate(c->parent);
+
 	if (c->flags & DIV_U71) {
-		divider = clk_div71_get_divider(c->parent->rate, rate);
+		divider = clk_div71_get_divider(parent_rate, rate);
 		if (divider >= 0) {
 			val = clk_readl(c->reg);
 			val &= ~PERIPH_CLK_SOURCE_DIVU71_MASK;
@@ -944,7 +994,7 @@ static int tegra2_periph_clk_set_rate(struct clk *c, unsigned long rate)
 			return 0;
 		}
 	} else if (c->flags & DIV_U16) {
-		divider = clk_div16_get_divider(c->parent->rate, rate);
+		divider = clk_div16_get_divider(parent_rate, rate);
 		if (divider >= 0) {
 			val = clk_readl(c->reg);
 			val &= ~PERIPH_CLK_SOURCE_DIVU16_MASK;
@@ -954,7 +1004,7 @@ static int tegra2_periph_clk_set_rate(struct clk *c, unsigned long rate)
 			c->mul = 1;
 			return 0;
 		}
-	} else if (c->parent->rate <= rate) {
+	} else if (parent_rate <= rate) {
 		c->div = 1;
 		c->mul = 1;
 		return 0;
@@ -966,19 +1016,20 @@ static long tegra2_periph_clk_round_rate(struct clk *c,
 	unsigned long rate)
 {
 	int divider;
+	unsigned long parent_rate = clk_get_rate(c->parent);
 	pr_debug("%s: %s %lu\n", __func__, c->name, rate);
 
 	if (c->flags & DIV_U71) {
-		divider = clk_div71_get_divider(c->parent->rate, rate);
+		divider = clk_div71_get_divider(parent_rate, rate);
 		if (divider < 0)
 			return divider;
 
-		return c->parent->rate * 2 / (divider + 2);
+		return parent_rate * 2 / (divider + 2);
 	} else if (c->flags & DIV_U16) {
-		divider = clk_div16_get_divider(c->parent->rate, rate);
+		divider = clk_div16_get_divider(parent_rate, rate);
 		if (divider < 0)
 			return divider;
-		return c->parent->rate / (divider + 1);
+		return parent_rate / (divider + 1);
 	}
 	return -EINVAL;
 }
@@ -1006,7 +1057,7 @@ static void tegra2_clk_double_init(struct clk *c)
 
 static int tegra2_clk_double_set_rate(struct clk *c, unsigned long rate)
 {
-	if (rate != 2 * c->parent->rate)
+	if (rate != 2 * clk_get_rate(c->parent))
 		return -EINVAL;
 	c->mul = 2;
 	c->div = 1;
@@ -1057,12 +1108,12 @@ static int tegra2_audio_sync_clk_set_parent(struct clk *c, struct clk *p)
 			val |= sel->value;
 
 			if (c->refcnt)
-				clk_enable_locked(p);
+				clk_enable(p);
 
 			clk_writel(val, c->reg);
 
 			if (c->refcnt && c->parent)
-				clk_disable_locked(c->parent);
+				clk_disable(c->parent);
 
 			clk_reparent(c, p);
 			return 0;
-- 
1.7.3.1

