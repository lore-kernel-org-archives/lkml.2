Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2HOXow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 19:44:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55545 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2HOXoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 19:44:18 -0400
From: Mike Turquette <mturquette@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <shawn.guo@linaro.org>, <linus.walleij@linaro.org>,
        <rob.herring@calxeda.com>, <pdeschrijver@nvidia.com>,
        <pgaikwad@nvidia.com>, <viresh.kumar@linaro.org>, <rnayak@ti.com>,
        <paul@pwsan.com>, <broonie@opensource.wolfsonmicro.com>,
        <ccross@android.com>, <linux-arm-kernel@lists.infradead.org>,
        <myungjoo.ham@samsung.com>, <rajagopal.venkat@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 1/4] [RFC] clk: new locking scheme for reentrancy
Date: Wed, 15 Aug 2012 16:43:31 -0700
Message-ID: <1345074214-17531-2-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345074214-17531-1-git-send-email-mturquette@linaro.org>
References: <1345074214-17531-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The global prepare_lock mutex prevents concurrent operations in the clk
api.  This incurs a performance penalty when unrelated clock subtrees
are contending for the lock.

Additionally there are use cases which benefit from reentrancy into the
clk api.  A simple example is reparenting a mux clock with a call to
clk_set_rate.  Patch #4 in this series demonstrates this without the use
of internal helper functions.

A more complex example is performing dynamic frequency and voltage
scaling from clk_set_rate.  Patches #2 and #3 in this series demonstrate
this.

This commit affects users of the global prepare_lock mutex, namely
clk_prepare, clk_unprepare, clk_set_rate and clk_set_parent.

This patch introduces an enum inside of struct clk which tracks whether
the framework has LOCKED or UNLOCKED the clk.

Access to clk->state must be protected by the global prepare_lock mutex.
In the future maybe the global mutex can be dropped and all operations
will only use a global spinlock to protect access to the per-clk enums.
A general outline of the new locking scheme is as follows:

1) hold the global prepare_lock mutex
2) traverse the tree checking to make sure that any clk's needed are
UNLOCKED and not LOCKED
	a) if a clk in the subtree of affected clk's is LOCKED then
	   release the global lock, wait_for_completion and then try
	   again up to a maximum of WAIT_TRIES times
	b) After WAIT_TRIES times return -EBUSY
3) if all clk's are UNLOCKED then mark them as LOCKED
4) release the global prepare_lock mutex
5) do the real work
6) hold the global prepare_lock mutex
7) set all of the clocks previously marked as LOCKED to UNLOCKED
8) release the global prepare_lock mutex and return

The primary down-side to this approach is that the clk api's might
return -EBUSY due to lock contention.  This is only after having tried
several times.  Bailing out like this is necessary to prevent deadlocks.

The enum approach in this version of the patchset does not benefit from
lockdep checking the lock order (but neither did v1).  It is possible
for circular dependencies to pop up for the careless developer and
bailing out after a number of unsuccessful tries is the sanest strategy.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/clk.c            |  354 +++++++++++++++++++++++++++++++++++++-----
 include/linux/clk-private.h  |    1 +
 include/linux/clk-provider.h |    4 +-
 3 files changed, 318 insertions(+), 41 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 51a29d1..92bb516 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -17,6 +17,9 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/completion.h>
+
+#define WAIT_TRIES	5
 
 static DEFINE_SPINLOCK(enable_lock);
 static DEFINE_MUTEX(prepare_lock);
@@ -25,6 +28,8 @@ static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
 static LIST_HEAD(clk_notifier_list);
 
+static DECLARE_COMPLETION(clk_completion);
+
 /***        debugfs support        ***/
 
 #ifdef CONFIG_COMMON_CLK_DEBUG
@@ -372,23 +377,51 @@ struct clk *__clk_lookup(const char *name)
 
 /***        clk api        ***/
 
-void __clk_unprepare(struct clk *clk)
+static struct clk *__clk_unprepare_lock(struct clk *clk)
 {
+	struct clk *top;
+
 	if (!clk)
-		return;
+		return ERR_PTR(-ENOENT);
+
+	if (clk->state == LOCKED)
+		return ERR_PTR(-EBUSY);
 
 	if (WARN_ON(clk->prepare_count == 0))
-		return;
+		return ERR_PTR(-EPERM);
 
-	if (--clk->prepare_count > 0)
-		return;
+	if (clk->prepare_count > 1 || clk->flags & CLK_IS_ROOT) {
+		top = clk;
+		clk->state = LOCKED;
+		clk->prepare_count--;
+	} else {
+		top = __clk_unprepare_lock(clk->parent);
+		if (IS_ERR(top))
+			goto out;
 
-	WARN_ON(clk->enable_count > 0);
+		clk->state = LOCKED;
+		clk->prepare_count--;
+	}
 
+out:
+	return top;
+}
+
+void __clk_unprepare(struct clk *clk, struct clk *top)
+{
 	if (clk->ops->unprepare)
 		clk->ops->unprepare(clk->hw);
 
-	__clk_unprepare(clk->parent);
+	if (clk != top)
+		__clk_unprepare(clk->parent, top);
+}
+
+static void __clk_prepare_unlock(struct clk *clk, struct clk *top)
+{
+	clk->state = UNLOCKED;
+
+	if (clk != top)
+		__clk_prepare_unlock(clk->parent, top);
 }
 
 /**
@@ -404,35 +437,94 @@ void __clk_unprepare(struct clk *clk)
  */
 void clk_unprepare(struct clk *clk)
 {
+	struct clk *top = ERR_PTR(-EBUSY);
+	int tries = 0;
+
+	/*
+	 * walk the list of parents checking clk->state along the way.  If all
+	 * clk->state is UNLOCKED then continue.  If a clk->state is LOCKED then
+	 * bail out with -EBUSY.
+	 */
+	while (IS_ERR(top)) {
+		mutex_lock(&prepare_lock);
+		top = __clk_unprepare_lock(clk);
+		mutex_unlock(&prepare_lock);
+
+		if (IS_ERR(top)) {
+			pr_debug("%s: %s failed with %ld on attempt %d\n",
+					__func__, clk->name, PTR_ERR(top),
+					tries);
+			wait_for_completion(&clk_completion);
+			if (WAIT_TRIES == ++tries)
+				break;
+		} else
+			break;
+	}
+
+	if (WAIT_TRIES == tries) {
+		pr_warning("%s: failed to lock clocks; cyclical dependency?\n",
+				__func__);
+		return;
+	}
+
+	/* unprepare the list of clocks from clk to top */
+	__clk_unprepare(clk, top);
+
+	/* set clk->state from LOCKED to UNLOCKED and fire off completion */
 	mutex_lock(&prepare_lock);
-	__clk_unprepare(clk);
+	__clk_prepare_unlock(clk, top);
 	mutex_unlock(&prepare_lock);
+
+	complete(&clk_completion);
 }
 EXPORT_SYMBOL_GPL(clk_unprepare);
 
-int __clk_prepare(struct clk *clk)
+static struct clk *__clk_prepare_lock(struct clk *clk)
 {
-	int ret = 0;
+	struct clk *top;
 
 	if (!clk)
-		return 0;
+		return ERR_PTR(-ENOENT);
+
+	if (clk->state == LOCKED)
+		return ERR_PTR(-EBUSY);
 
-	if (clk->prepare_count == 0) {
-		ret = __clk_prepare(clk->parent);
+	if (clk->prepare_count > 0 || clk->flags & CLK_IS_ROOT) {
+		top = clk;
+		clk->state = LOCKED;
+		clk->prepare_count++;
+	} else {
+		top = __clk_prepare_lock(clk->parent);
+		if (IS_ERR(top))
+			goto out;
+
+		clk->state = LOCKED;
+		clk->prepare_count++;
+	}
+
+out:
+	return top;
+}
+
+int __clk_prepare(struct clk *clk, struct clk *top)
+{
+	int ret = 0;
+
+	if (clk != top) {
+		ret = __clk_prepare(clk->parent, top);
 		if (ret)
 			return ret;
 
 		if (clk->ops->prepare) {
 			ret = clk->ops->prepare(clk->hw);
 			if (ret) {
-				__clk_unprepare(clk->parent);
+				/* this is safe since clk != top */
+				__clk_unprepare(clk->parent, top);
 				return ret;
 			}
 		}
 	}
 
-	clk->prepare_count++;
-
 	return 0;
 }
 
@@ -450,13 +542,42 @@ int __clk_prepare(struct clk *clk)
  */
 int clk_prepare(struct clk *clk)
 {
-	int ret;
+	struct clk *top = ERR_PTR(-EBUSY);
+	int tries = 0;
+
+	while(IS_ERR(top)) {
+		mutex_lock(&prepare_lock);
+		top = __clk_prepare_lock(clk);
+		mutex_unlock(&prepare_lock);
+
+		if (IS_ERR(top)) {
+			pr_debug("%s: %s failed with %ld on attempt %d\n",
+					__func__, clk->name, PTR_ERR(top),
+					tries);
+			wait_for_completion(&clk_completion);
+			if (WAIT_TRIES == ++tries)
+				break;
+		} else
+			break;
+	}
+
+	if (WAIT_TRIES == tries) {
+		pr_err("%s: failed to lock clocks; cyclical dependency?\n",
+				__func__);
+		return -EBUSY;
+	}
 
+	/* unprepare the list of clocks from clk to top */
+	__clk_prepare(clk, top);
+
+	/* set clk->state from LOCKED to UNLOCKED and fire off completion */
 	mutex_lock(&prepare_lock);
-	ret = __clk_prepare(clk);
+	__clk_prepare_unlock(clk, top);
 	mutex_unlock(&prepare_lock);
 
-	return ret;
+	complete(&clk_completion);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(clk_prepare);
 
@@ -730,12 +851,12 @@ static int __clk_speculate_rates(struct clk *clk, unsigned long parent_rate)
 	if (clk->notifier_count)
 		ret = __clk_notify(clk, PRE_RATE_CHANGE, clk->rate, new_rate);
 
-	if (ret == NOTIFY_BAD)
+	if (ret & NOTIFY_STOP_MASK)
 		goto out;
 
 	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
 		ret = __clk_speculate_rates(child, new_rate);
-		if (ret == NOTIFY_BAD)
+		if (ret & NOTIFY_STOP_MASK)
 			break;
 	}
 
@@ -759,15 +880,89 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate)
 	}
 }
 
+static int clk_test_lock_subtree(struct clk *clk)
+{
+	struct clk *child;
+	struct hlist_node *tmp;
+	int ret = 0;
+
+	if (clk->state != UNLOCKED)
+		return -EBUSY;
+
+	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
+		ret = clk_test_lock_subtree(child);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int clk_test_lock_additional_subtree(struct clk *clk, struct clk *avoid)
+{
+	struct clk *child;
+	struct hlist_node *tmp;
+	int ret = 0;
+
+	if (clk == avoid)
+		return 0;
+
+	if (clk->state != UNLOCKED)
+		return -EBUSY;
+
+	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
+		ret = clk_test_lock_additional_subtree(child, avoid);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void clk_lock_subtree(struct clk *clk)
+{
+	struct clk *child;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
+		clk->state = LOCKED;
+	}
+}
+
+static void clk_lock_additional_subtree(struct clk *clk, struct clk *avoid)
+{
+	struct clk *child;
+	struct hlist_node *tmp;
+
+	if (clk == avoid)
+		return;
+
+	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
+		clk->state = LOCKED;
+		clk_lock_additional_subtree(child, avoid);
+	}
+}
+
+static void clk_unlock_subtree(struct clk *clk)
+{
+	struct clk *child;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
+		clk->state = UNLOCKED;
+	}
+}
+
 /*
- * calculate the new rates returning the topmost clock that has to be
- * changed.
+ * calculate the new rates returning the topmost clock that has to be changed.
+ * Caller must set clk->state to LOCKED for clk and all of its children
  */
 static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 {
 	struct clk *top = clk;
 	unsigned long best_parent_rate = 0;
 	unsigned long new_rate;
+	int ret = 0;
 
 	/* sanity */
 	if (IS_ERR_OR_NULL(clk))
@@ -794,6 +989,19 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 	}
 
 	if (!clk->ops->round_rate) {
+		/* set parent and all additional children as LOCKED */
+		mutex_lock(&prepare_lock);
+		ret = clk_test_lock_additional_subtree(clk->parent, clk);
+		if (!ret)
+			clk_lock_additional_subtree(clk->parent, clk);
+		mutex_unlock(&prepare_lock);
+
+		if (ret == -EBUSY) {
+			pr_err("%s: %s: failed with EBUSY\n", __func__, clk->name);
+			/* FIXME the right thing to do? */
+			return NULL;
+		}
+
 		top = clk_calc_new_rates(clk->parent, rate);
 		new_rate = clk->parent->new_rate;
 
@@ -803,6 +1011,18 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 	new_rate = clk->ops->round_rate(clk->hw, rate, &best_parent_rate);
 
 	if (best_parent_rate != clk->parent->rate) {
+		mutex_lock(&prepare_lock);
+		ret = clk_test_lock_additional_subtree(clk->parent, clk);
+		if (!ret)
+			clk_lock_additional_subtree(clk->parent, clk);
+		mutex_unlock(&prepare_lock);
+
+		if (ret == -EBUSY) {
+			pr_err("%s: %s: failed with EBUSY\n", __func__, clk->name);
+			/* FIXME the right thing to do? */
+			return NULL;
+		}
+
 		top = clk_calc_new_rates(clk->parent, best_parent_rate);
 
 		goto out;
@@ -830,8 +1050,11 @@ static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long even
 
 	if (clk->notifier_count) {
 		ret = __clk_notify(clk, event, clk->rate, clk->new_rate);
-		if (ret == NOTIFY_BAD)
+		if (ret & NOTIFY_STOP_MASK)
 			fail_clk = clk;
+		if (notifier_to_errno(ret) == -EBUSY)
+			WARN(1, "%s: %s: possible cyclical dependency?\n",
+					__func__, clk->name);
 	}
 
 	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
@@ -897,11 +1120,35 @@ static void clk_change_rate(struct clk *clk)
  */
 int clk_set_rate(struct clk *clk, unsigned long rate)
 {
-	struct clk *top, *fail_clk;
-	int ret = 0;
+	struct clk *top = clk, *fail_clk;
+	int ret = -EBUSY, i = 0, tries = 0;
+
+	if (!clk)
+		return 0;
 
 	/* prevent racing with updates to the clock topology */
-	mutex_lock(&prepare_lock);
+	while (ret) {
+		mutex_lock(&prepare_lock);
+		ret = clk_test_lock_subtree(clk);
+		if (!ret)
+			clk_lock_subtree(clk);
+		mutex_unlock(&prepare_lock);
+
+		if (ret) {
+			pr_debug("%s: %s failed with %d on attempt %d\n",
+					__func__, clk->name, ret, tries);
+			wait_for_completion(&clk_completion);
+			if (WAIT_TRIES == ++tries)
+				break;
+		} else
+			break;
+	}
+
+	if (i == WAIT_TRIES) {
+		pr_err("%s: failed to lock clocks; cyclical dependency?\n",
+				__func__);
+		return ret;
+	}
 
 	/* bail early if nothing to do */
 	if (rate == clk->rate)
@@ -932,12 +1179,13 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	/* change the rates */
 	clk_change_rate(top);
 
-	mutex_unlock(&prepare_lock);
-
-	return 0;
 out:
+	mutex_lock(&prepare_lock);
+	clk_unlock_subtree(top);
 	mutex_unlock(&prepare_lock);
 
+	complete(&clk_completion);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_set_rate);
@@ -1095,12 +1343,12 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 
 	/* migrate prepare and enable */
 	if (clk->prepare_count)
-		__clk_prepare(parent);
+		clk_prepare(parent);
 
 	/* FIXME replace with clk_is_enabled(clk) someday */
 	spin_lock_irqsave(&enable_lock, flags);
 	if (clk->enable_count)
-		__clk_enable(parent);
+		clk_enable(parent);
 	spin_unlock_irqrestore(&enable_lock, flags);
 
 	/* change clock input source */
@@ -1109,11 +1357,11 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 	/* clean up old prepare and enable */
 	spin_lock_irqsave(&enable_lock, flags);
 	if (clk->enable_count)
-		__clk_disable(old_parent);
+		clk_disable(old_parent);
 	spin_unlock_irqrestore(&enable_lock, flags);
 
 	if (clk->prepare_count)
-		__clk_unprepare(old_parent);
+		clk_unprepare(old_parent);
 
 out:
 	return ret;
@@ -1133,7 +1381,7 @@ out:
  */
 int clk_set_parent(struct clk *clk, struct clk *parent)
 {
-	int ret = 0;
+	int ret = 0, i = 0, tries = 0;
 
 	if (!clk || !clk->ops)
 		return -EINVAL;
@@ -1141,19 +1389,42 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	if (!clk->ops->set_parent)
 		return -ENOSYS;
 
-	/* prevent racing with updates to the clock topology */
-	mutex_lock(&prepare_lock);
-
 	if (clk->parent == parent)
 		goto out;
 
+	/* prevent racing with updates to the clock topology */
+	while (ret) {
+		mutex_lock(&prepare_lock);
+		ret = clk_test_lock_subtree(clk);
+		if (!ret)
+			clk_lock_subtree(clk);
+		mutex_unlock(&prepare_lock);
+
+		if (ret) {
+			pr_debug("%s: %s failed with %d on attempt %d\n",
+					__func__, clk->name, ret, tries);
+			wait_for_completion(&clk_completion);
+			if (WAIT_TRIES == ++tries)
+				break;
+		} else
+			break;
+	}
+
+	if (i == WAIT_TRIES) {
+		pr_err("%s: failed to lock clocks; cyclical dependency?\n",
+				__func__);
+		return ret;
+	}
+
 	/* propagate PRE_RATE_CHANGE notifications */
 	if (clk->notifier_count)
 		ret = __clk_speculate_rates(clk, parent->rate);
 
 	/* abort if a driver objects */
-	if (ret == NOTIFY_STOP)
+	if (ret & NOTIFY_STOP_MASK) {
+		ret = notifier_to_errno(ret);
 		goto out;
+	}
 
 	/* only re-parent if the clock is not in use */
 	if ((clk->flags & CLK_SET_PARENT_GATE) && clk->prepare_count)
@@ -1171,6 +1442,8 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	__clk_reparent(clk, parent);
 
 out:
+	mutex_lock(&prepare_lock);
+	clk_unlock_subtree(clk);
 	mutex_unlock(&prepare_lock);
 
 	return ret;
@@ -1307,6 +1580,9 @@ int __clk_init(struct device *dev, struct clk *clk)
 	if (clk->ops->init)
 		clk->ops->init(clk->hw);
 
+	/* everything looks good, mark this clock's state as ready */
+	clk->state = UNLOCKED;
+
 	clk_debug_register(clk);
 
 out:
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 9c7f580..751ad6c 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -41,6 +41,7 @@ struct clk {
 	struct hlist_head	children;
 	struct hlist_node	child_node;
 	unsigned int		notifier_count;
+	enum {UNLOCKED, LOCKED}	state;
 #ifdef CONFIG_COMMON_CLK_DEBUG
 	struct dentry		*dentry;
 #endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 77335fa..b3eb074 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -344,8 +344,8 @@ struct clk *__clk_lookup(const char *name);
 /*
  * FIXME clock api without lock protection
  */
-int __clk_prepare(struct clk *clk);
-void __clk_unprepare(struct clk *clk);
+int __clk_prepare(struct clk *clk, struct clk *top);
+void __clk_unprepare(struct clk *clk, struct clk *top);
 void __clk_reparent(struct clk *clk, struct clk *new_parent);
 unsigned long __clk_round_rate(struct clk *clk, unsigned long rate);
 
-- 
1.7.9.5

