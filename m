Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab2GNARn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 20:17:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59830 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839Ab2GNARR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 20:17:17 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <shawn.guo@linaro.org>, <linus.walleij@linaro.org>,
        <rob.herring@calxeda.com>, <pdeschrijver@nvidia.com>,
        <pgaikwad@nvidia.com>, <viresh.kumar@linaro.org>, <rnayak@ti.com>,
        <paul@pwsan.com>, <broonie@opensource.wolfsonmicro.com>,
        <tglx@linutronix.de>, <ccross@android.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 1/2] [RFC] clk: reentrancy via per-clock locking
Date: Fri, 13 Jul 2012 17:16:40 -0700
Message-ID: <1342225001-22962-2-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342225001-22962-1-git-send-email-mturquette@linaro.org>
References: <1342225001-22962-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch, while incomplete, implements a per-clock locking scheme
intended to enable two specific use cases for the clock framework.  The
changelog is really long; it describes what the patch does, how I came
to this design, a few implementation notes for anyone that wants to try
these patches and some possible different ways to solve the problems.
Any advice or design ideas would be greatly appreciated.

TL;DR

This patch implements per-clock locking, which is horrible and I need
some new ideas.  Please help me mailing list peoples.

		The two use cases:

1) nested calls to the clock framework in clk_prepare/clk_unprepare

Use case #1 is mandatory for preparing clocks on i2c devices.  Calling
clk_prepare on these clocks results in an i2c transaction which will
result in clk_prepare being called for the i2c controller's clocks.
This results in a deadlock.

2) reentrant calls to the clock framework from the rate change notifier
handlers in clk_set_rate

Use case #2 is needed to perform dvfs transitions via clk_set_rate.  It
is common to scale voltage with frequency and it is also common for
voltage to be scaled by an off-chip device.  Similar to use case #1 this
may result in an i2c transaction that calls clk_prepare from within
clk_set_rate.  This results in a deadlock.

		The new locking scheme:

A per-clock locking scheme at first seems like a solution, so long as
reentrant calls do not need to operate on the same clock.  Lockdep uses
the same lock class key for every per-clock lock that was dynamically
initialized in __clk_init() via mutex_init().  To work around this I
stuffed both a struct mutex and a struct lock_class_key into struct clk
and cheated the initialization by directly calling __mutex_init.

@@ -41,6 +41,11 @@ struct clk {
        struct hlist_head       children;
        struct hlist_node       child_node;
        unsigned int            notifier_count;
+       struct mutex            lock;
+       struct lock_class_key   lock_key;
+       struct clk              *top;
+       int                     depth;
+       struct clk              **parent_chain;

...

@@ -1296,6 +1392,16 @@ int __clk_init(struct device *dev, struct clk *clk)
                                break;
                        }

+       /* XXX initialize per-clock mutex */
+       __mutex_init(&clk->lock, clk->name, &clk->lock_key);

Note that this also warns us if the struct clk is not statically
allocated (mine are, odds are that yours are not).  This is gross but it
does generate per-clock locks which lockdep is able to evaluate
independently.

However lock direction must be taken into account; clk_prepare locks
upwards and clk_set_rate locks downwards.  I was unsuccessful in finding
a way to make those operations lock in the same direction without
creating circular locking dependencies.

The circular lock dependency issue above issues led me to try
mutex_lock_nested.  One way to make lockdep happy was to use separate
lock subclasses for clk_prepare and clk_set_rate.  The synaptics
touchscreen guys faced similar issues:
https://lkml.org/lkml/2006/9/14/133

This prevented lockdep from warning about circular dependencies, but
with a nasty side effect: clk_prepare() and clk_set_rate() became
essentially unsynchronized.  This is completely analogous to the racy
mess we have today between clk_prepare and clk_enable (independent mutex
& spinlock, respectively), but now applies to clk_prepare and
clk_set_rate.

Quick aside: one interesting observation here is that if we consider
only use case #2 (i.e. dvfs via reentrant calls to clk framework from
rate change notifier handlers) then the same result could have been
achieved without per-clock locks and instead a new global mutex (e.g.
DEFINE_MUTEX(topology_lock)).  Such a solution does NOT solve nested
calls to clk_prepare (use case #1).

		Some implementation notes:

Many functions in this patch have NOT been updated to use the per-clock
locks, notably clk_set_parent and the clock registration/initialization
path, as well as the debugfs stuff.  Races abound but my platform hasn't
been bitten by any of them in testing.

As mentioned above those with dynamically initialized clocks will get a
warning that the lock class key is not static data.  Since clk_put is
not implemented and we never get rid of clocks (or their locks) then
this is relatively safe to ignore.

		Alternative solutions:

For use case #1: Continue to use the single global clk mutex, but create
a separate clk_prepare_nested or provide a clk flag CLK_PREPARE_NESTED,
or something similar which applies to the i2c controller's struct clk.
Calling clk_prepare_nested or calling clk_prepare on a clk with the
CLK_PREPARE_NESTED flag results in mutex_lock_nested being used on the
global clk mutex.  This is not bomb-proof since there is still missing
context, such as, "I want to nest this call to clk_prepare(x) because it
is a direct dependency of clk_prepare(y)".

For use case #2: a separate api could be created solely for dvfs which
would avoid the reentrancy problem.  A naive example:

int dvfs_scale(struct device *dev, unsigned long rate)
{
	if (rate > old_rate)
		regulator_set_voltage(...);

	clk_set_rate(clk, rate);

	if (rate < old_rate)
		regulator_set_voltage(...);
}

By simply calling regulator_set_rate outside of clk_set_rate then the
reentrancy is avoided.

Not-signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/clk.c           |  202 +++++++++++++++++++++++++++++++------------
 include/linux/clk-private.h |    5 ++
 2 files changed, 154 insertions(+), 53 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index e80ca1b..5ca8049 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -34,6 +34,29 @@ static struct dentry *rootdir;
 static struct dentry *orphandir;
 static int inited = 0;
 
+/* tree locking helpers */
+static void clk_lock_subtree(struct clk *clk)
+{
+	struct clk *child;
+	struct hlist_node *tmp;
+
+	mutex_lock_nested(&clk->lock, 0);
+
+	hlist_for_each_entry(child, tmp, &clk->children, child_node)
+		clk_lock_subtree(child);
+}
+
+static void clk_unlock_subtree(struct clk *clk)
+{
+	struct clk *child;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry(child, tmp, &clk->children, child_node)
+		clk_unlock_subtree(child);
+
+	mutex_unlock(&clk->lock);
+}
+
 /* caller must hold prepare_lock */
 static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
 {
@@ -90,7 +113,7 @@ static int clk_debug_create_subtree(struct clk *clk, struct dentry *pdentry)
 {
 	struct clk *child;
 	struct hlist_node *tmp;
-	int ret = -EINVAL;;
+	int ret = -EINVAL;
 
 	if (!clk || !pdentry)
 		goto out;
@@ -126,7 +149,7 @@ static int clk_debug_register(struct clk *clk)
 	int ret = 0;
 
 	if (!inited)
-		goto out;
+		return ret;
 
 	parent = clk->parent;
 
@@ -145,9 +168,11 @@ static int clk_debug_register(struct clk *clk)
 		else
 			goto out;
 
+	clk_lock_subtree(clk);
 	ret = clk_debug_create_subtree(clk, pdentry);
 
 out:
+	clk_unlock_subtree(clk);
 	return ret;
 }
 
@@ -178,18 +203,20 @@ static int __init clk_debug_init(void)
 	if (!orphandir)
 		return -ENOMEM;
 
-	mutex_lock(&prepare_lock);
-
-	hlist_for_each_entry(clk, tmp, &clk_root_list, child_node)
+	hlist_for_each_entry(clk, tmp, &clk_root_list, child_node) {
+		/* FIXME clk_lock_subtree(clk);*/
 		clk_debug_create_subtree(clk, rootdir);
+		/* FIXME clk_unlock_subtree(clk); */
+	}
 
-	hlist_for_each_entry(clk, tmp, &clk_orphan_list, child_node)
+	hlist_for_each_entry(clk, tmp, &clk_orphan_list, child_node) {
+		/* FIXME clk_lock_subtree(clk);*/
 		clk_debug_create_subtree(clk, orphandir);
+		/* FIXME clk_unlock_subtree(clk);*/
+	}
 
 	inited = 1;
 
-	mutex_unlock(&prepare_lock);
-
 	return 0;
 }
 late_initcall(clk_debug_init);
@@ -233,16 +260,12 @@ static int clk_disable_unused(void)
 	struct clk *clk;
 	struct hlist_node *tmp;
 
-	mutex_lock(&prepare_lock);
-
 	hlist_for_each_entry(clk, tmp, &clk_root_list, child_node)
 		clk_disable_unused_subtree(clk);
 
 	hlist_for_each_entry(clk, tmp, &clk_orphan_list, child_node)
 		clk_disable_unused_subtree(clk);
 
-	mutex_unlock(&prepare_lock);
-
 	return 0;
 }
 late_initcall(clk_disable_unused);
@@ -370,6 +393,69 @@ struct clk *__clk_lookup(const char *name)
 	return NULL;
 }
 
+struct clk *__clk_lock_unprepare(struct clk *clk)
+{
+	struct clk *top = NULL;
+
+	if (!clk)
+		return NULL;
+
+	mutex_lock_nested(&clk->lock, 1);
+
+	if (clk->prepare_count > 1)
+		top = clk;
+	else {
+		top = __clk_lock_unprepare(clk->parent);
+		if (!top)
+			top = clk;
+	}
+
+	return top;
+}
+
+struct clk *__clk_lock_prepare(struct clk *clk)
+{
+	struct clk *top = NULL;
+
+	if (!clk)
+		return NULL;
+
+	mutex_lock_nested(&clk->lock, 1);
+
+	if (!clk->prepare_count) {
+		top = __clk_lock_prepare(clk->parent);
+		if (!top)
+			top = clk;
+	} else
+		top = clk;
+
+	return top;
+}
+
+void __clk_unlock_top(struct clk *clk, struct clk *top)
+{
+	if (clk != top)
+		__clk_unlock_top(clk->parent, top);
+
+	mutex_unlock(&clk->lock);
+}
+
+static inline int __clk_unlock_parent_chain(struct clk *clk, struct clk *top)
+{
+	struct clk *tmp;
+
+	tmp = clk;
+
+	while (tmp) {
+		mutex_unlock(&tmp->lock);
+		if (tmp == top)
+			break;
+		tmp = tmp->parent;
+	}
+
+	return 0;
+}
+
 /***        clk api        ***/
 
 void __clk_unprepare(struct clk *clk)
@@ -404,9 +490,16 @@ void __clk_unprepare(struct clk *clk)
  */
 void clk_unprepare(struct clk *clk)
 {
-	mutex_lock(&prepare_lock);
+	struct clk *top;
+
+	/* find the top-most clock we locked */
+	top = __clk_lock_unprepare(clk);
+
+	/* unprepare the clocks */
 	__clk_unprepare(clk);
-	mutex_unlock(&prepare_lock);
+
+	/* release the per-clock locks */
+	__clk_unlock_parent_chain(clk, top);
 }
 EXPORT_SYMBOL_GPL(clk_unprepare);
 
@@ -420,20 +513,21 @@ int __clk_prepare(struct clk *clk)
 	if (clk->prepare_count == 0) {
 		ret = __clk_prepare(clk->parent);
 		if (ret)
-			return ret;
+			goto out;
 
 		if (clk->ops->prepare) {
 			ret = clk->ops->prepare(clk->hw);
 			if (ret) {
 				__clk_unprepare(clk->parent);
-				return ret;
+				goto out;
 			}
 		}
 	}
 
 	clk->prepare_count++;
 
-	return 0;
+out:
+	return ret;
 }
 
 /**
@@ -450,11 +544,22 @@ int __clk_prepare(struct clk *clk)
  */
 int clk_prepare(struct clk *clk)
 {
+	struct clk *top;
 	int ret;
 
-	mutex_lock(&prepare_lock);
+	/* find the top-most clock we locked */
+	top = __clk_lock_prepare(clk);
+
+	if (!top) {
+		pr_err("%s: %s: could not be found!\n", __func__, clk->name);
+		return -EINVAL;
+	}
+
+	/* prepare the clocks */
 	ret = __clk_prepare(clk);
-	mutex_unlock(&prepare_lock);
+
+	/* release the per-clock locks */
+	__clk_unlock_parent_chain(clk, top);
 
 	return ret;
 }
@@ -565,9 +670,7 @@ unsigned long clk_get_rate(struct clk *clk)
 {
 	unsigned long rate;
 
-	mutex_lock(&prepare_lock);
 	rate = __clk_get_rate(clk);
-	mutex_unlock(&prepare_lock);
 
 	return rate;
 }
@@ -612,9 +715,7 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
 {
 	unsigned long ret;
 
-	mutex_lock(&prepare_lock);
 	ret = __clk_round_rate(clk, rate);
-	mutex_unlock(&prepare_lock);
 
 	return ret;
 }
@@ -900,23 +1001,23 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	struct clk *top, *fail_clk;
 	int ret = 0;
 
-	/* prevent racing with updates to the clock topology */
-	mutex_lock(&prepare_lock);
-
 	/* bail early if nothing to do */
 	if (rate == clk->rate)
-		goto out;
+		goto err_out;
 
 	if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
 		ret = -EBUSY;
-		goto out;
+		goto err_out;
 	}
 
+	/* lock from the top-most possible clock */
+	clk_lock_subtree(clk->top);
+
 	/* calculate new rates and get the topmost changed clock */
 	top = clk_calc_new_rates(clk, rate);
 	if (!top) {
 		ret = -EINVAL;
-		goto out;
+		goto err_lock;
 	}
 
 	/* notify that we are about to change rates */
@@ -926,18 +1027,20 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 				fail_clk->name);
 		clk_propagate_rate_change(top, ABORT_RATE_CHANGE);
 		ret = -EBUSY;
-		goto out;
+		clk_unlock_subtree(clk->top);
+		return ret;
 	}
 
 	/* change the rates */
 	clk_change_rate(top);
 
-	mutex_unlock(&prepare_lock);
+	clk_unlock_subtree(clk->top);
 
 	return 0;
-out:
-	mutex_unlock(&prepare_lock);
 
+err_lock:
+	clk_unlock_subtree(clk->top);
+err_out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_set_rate);
@@ -952,9 +1055,7 @@ struct clk *clk_get_parent(struct clk *clk)
 {
 	struct clk *parent;
 
-	mutex_lock(&prepare_lock);
 	parent = __clk_get_parent(clk);
-	mutex_unlock(&prepare_lock);
 
 	return parent;
 }
@@ -1064,10 +1165,11 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 	struct clk *old_parent;
 	unsigned long flags;
 	int ret = -EINVAL;
-	u8 i;
+	u8 i = 0;
 
 	old_parent = clk->parent;
 
+	pr_err("%s: OMG CLK_SET_PARENT OMG\n", __func__);
 	if (!clk->parents)
 		clk->parents = kzalloc((sizeof(struct clk*) * clk->num_parents),
 								GFP_KERNEL);
@@ -1135,15 +1237,13 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 {
 	int ret = 0;
 
+	pr_err("%s: %s\n", __func__, clk->name);
 	if (!clk || !clk->ops)
 		return -EINVAL;
 
 	if (!clk->ops->set_parent)
 		return -ENOSYS;
 
-	/* prevent racing with updates to the clock topology */
-	mutex_lock(&prepare_lock);
-
 	if (clk->parent == parent)
 		goto out;
 
@@ -1171,8 +1271,6 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	__clk_reparent(clk, parent);
 
 out:
-	mutex_unlock(&prepare_lock);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_set_parent);
@@ -1194,8 +1292,6 @@ int __clk_init(struct device *dev, struct clk *clk)
 	if (!clk)
 		return -EINVAL;
 
-	mutex_lock(&prepare_lock);
-
 	/* check to see if a clock with this name is already registered */
 	if (__clk_lookup(clk->name)) {
 		pr_debug("%s: clk %s already initialized\n",
@@ -1296,6 +1392,16 @@ int __clk_init(struct device *dev, struct clk *clk)
 				break;
 			}
 
+	/* XXX initialize per-clock mutex */
+	__mutex_init(&clk->lock, clk->name, &clk->lock_key);
+
+	/*
+	 * calculate the top-most clock that might change when setting this
+	 * clock's rate
+	 */
+	/* FIXME assume CLK_SET_RATE_PARENT is never set */
+	clk->top = clk;
+
 	/*
 	 * optional platform-specific magic
 	 *
@@ -1310,8 +1416,6 @@ int __clk_init(struct device *dev, struct clk *clk)
 	clk_debug_register(clk);
 
 out:
-	mutex_unlock(&prepare_lock);
-
 	return ret;
 }
 
@@ -1476,8 +1580,6 @@ int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
 	if (!clk || !nb)
 		return -EINVAL;
 
-	mutex_lock(&prepare_lock);
-
 	/* search the list of notifiers for this clk */
 	list_for_each_entry(cn, &clk_notifier_list, node)
 		if (cn->clk == clk)
@@ -1500,8 +1602,6 @@ int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
 	clk->notifier_count++;
 
 out:
-	mutex_unlock(&prepare_lock);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_notifier_register);
@@ -1525,8 +1625,6 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 	if (!clk || !nb)
 		return -EINVAL;
 
-	mutex_lock(&prepare_lock);
-
 	list_for_each_entry(cn, &clk_notifier_list, node)
 		if (cn->clk == clk)
 			break;
@@ -1546,8 +1644,6 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 		ret = -ENOENT;
 	}
 
-	mutex_unlock(&prepare_lock);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_notifier_unregister);
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 9c7f580..edcf07a 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -41,6 +41,11 @@ struct clk {
 	struct hlist_head	children;
 	struct hlist_node	child_node;
 	unsigned int		notifier_count;
+	struct mutex		lock;
+	struct lock_class_key	lock_key;
+	struct clk		*top;
+	int			depth;
+	struct clk		**parent_chain;
 #ifdef CONFIG_COMMON_CLK_DEBUG
 	struct dentry		*dentry;
 #endif
-- 
1.7.9.5

