Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab1LND73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 22:59:29 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:53066 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756661Ab1LND6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 22:58:46 -0500
From: Mike Turquette <mturquette@linaro.org>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        paul@pwsan.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, mturquette@linaro.org, mturquette@ti.com,
        andrew@lunn.ch
Subject: [PATCH v4 4/6] clk: introduce rate change notifiers
Date: Tue, 13 Dec 2011 19:53:56 -0800
Message-Id: <1323834838-2206-5-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323834838-2206-1-git-send-email-mturquette@linaro.org>
References: <1323834838-2206-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many devices support dynamic clk frequency changes, but often need to
handle these clk frequency changes with care.  Examples of these devices
range from processors such as CPUs and GPUs to IO controllers such as
DDR controllers or MMC/SD card controllers and fixed-function hardware
such as video decoding logic.

To accomodate these needs this patch introduces clk rate change
notifiers to the common clk framework.  Drivers may subscribe to a
specific clk and recieve asynchronous notifications before a clk's rate
changes, after a clk's rate has been changed and also if the rate change
operation was aborted.

This patch is heavily based on Paul Walmsley's OMAP clk notifier
patches, of which several version have been posted over time:
http://article.gmane.org/gmane.linux.ports.arm.omap/18374
http://article.gmane.org/gmane.linux.ports.arm.omap/15200

There are subtle differences in this implementation, such as use of SRCU
notifers instead of blocking, and the use of a new .speculate_rate
function pointer (similar .recalc_rate) for predicting rate changes down
the sub-tree of clks.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>
---
 drivers/clk/clk.c   |  296 +++++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/clk.h |   64 +++++++++++
 2 files changed, 340 insertions(+), 20 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8cadadd..f86cb98 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -15,11 +15,13 @@
 #include <linux/spinlock.h>
 #include <linux/err.h>
 #include <linux/list.h>
+#include <linux/slab.h>
 
 static DEFINE_SPINLOCK(enable_lock);
 static DEFINE_MUTEX(prepare_lock);
 
 static HLIST_HEAD(clk_root_list);
+static LIST_HEAD(clk_notifier_list);
 
 /***        clk API        ***/
 
@@ -248,31 +250,128 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
 EXPORT_SYMBOL_GPL(clk_round_rate);
 
 /**
+ * __clk_notify - call clk notifier chain
+ * @clk: struct clk * that is changing rate
+ * @msg: clk notifier type (see include/linux/clk.h)
+ * @old_rate: old clk rate
+ * @new_rate: new clk rate
+ *
+ * Triggers a notifier call chain on the clk rate-change notification
+ * for 'clk'.  Passes a pointer to the struct clk and the previous
+ * and current rates to the notifier callback.  Intended to be called by
+ * internal clock code only.  Returns NOTIFY_DONE from the last driver
+ * called if all went well, or NOTIFY_STOP or NOTIFY_BAD immediately if
+ * a driver returns that.
+ */
+static int __clk_notify(struct clk *clk, unsigned long msg,
+		unsigned long old_rate, unsigned long new_rate)
+{
+	struct clk_notifier *cn;
+	struct clk_notifier_data cnd;
+	int ret = NOTIFY_DONE;
+
+	cnd.clk = clk;
+	cnd.old_rate = old_rate;
+	cnd.new_rate = new_rate;
+
+	list_for_each_entry(cn, &clk_notifier_list, node) {
+		if (cn->clk == clk) {
+			ret = srcu_notifier_call_chain(&cn->notifier_head, msg,
+					&cnd);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/**
  * __clk_recalc_rates
  * @clk: first clk in the subtree
+ * @msg: notification type (see include/linux/clk.h)
  *
  * Walks the subtree of clks starting with clk and recalculates rates as it
  * goes.  Note that if a clk does not implement the recalc_rate operation then
  * propagation of that subtree stops and all of that clks children will not
- * have their rates updated.  Caller must hold prepare_lock.
+ * have their rates updated.
+ *
+ * clk_recalc_rates also propagates the POST_RATE_CHANGE notification,
+ * if necessary.
+ *
+ * Caller must hold prepare_lock.
+ */
+static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
+{
+	unsigned long old_rate;
+	struct hlist_node *tmp;
+	struct clk *child;
+
+	old_rate = clk->rate;
+
+	if (clk->ops->recalc_rate)
+		clk->rate = clk->ops->recalc_rate(clk);
+
+	/* ignore return value for POST_RATE_CHANGE & ABORT_RATE_CHANGE */
+	if (clk->notifier_count)
+		__clk_notify(clk, msg, old_rate, clk->rate);
+
+	hlist_for_each_entry(child, tmp, &clk->children, child_node)
+		__clk_recalc_rates(child, msg);
+}
+
+/**
+ * __clk_speculate_rates
+ * @clk: first clk in the subtree
+ * @parent_rate: the "future" rate of clk's parent
+ *
+ * Walks the subtree of clks starting with clk, speculating rates as it
+ * goes and firing off PRE_RATE_CHANGE notifications as necessary.  Note
+ * that if a clk does not implement the speculate_rate operation then
+ * propagation of that subtree stops and all of that clks children will
+ * not have their rates speculated.
+ *
+ * Unlike clk_recalc_rates, clk_speculate_rates exists only for sending
+ * pre-rate change notifications and returns early if no clks in the
+ * subtree have subscribed to the notifications.
+ *
+ * It is not required to have a .speculate_rate callback, but without it
+ * a driver can never recieve a PRE_RATE_CHANGE notifier.  clks that
+ * only have a .recalc_rate callback still allow drivers to listen for
+ * POST_RATE_CHANGE notifications even in the absence of
+ * .speculate_rate.
+ *
+ * Caller must hold prepare_lock.
  */
-static void __clk_recalc_rates(struct clk *clk)
+static int __clk_speculate_rates(struct clk *clk, unsigned long parent_rate)
 {
 	struct hlist_node *tmp;
 	struct clk *child;
+	unsigned long new_rate;
+	int ret = NOTIFY_DONE;
 
-	if (!clk->ops->recalc_rate) {
-		pr_debug("%s: no .recalc_rate for clk %s\n",
+	if (!clk->ops->speculate_rate) {
+		pr_debug("%s: no .speculate_rate for clk %s\n",
 				__func__, clk->name);
-		return;
+		goto out;
 	}
 
-	clk->rate = clk->ops->recalc_rate(clk);
+	new_rate = clk->ops->speculate_rate(clk, parent_rate);
 
-	/* FIXME add post-rate change notification here */
+	/* abort the rate change if a driver returns NOTIFY_BAD */
+	if (clk->notifier_count)
+		ret = __clk_notify(clk, PRE_RATE_CHANGE, clk->rate, new_rate);
 
-	hlist_for_each_entry(child, tmp, &clk->children, child_node)
-		__clk_recalc_rates(child);
+	if (ret == NOTIFY_BAD)
+		goto out;
+
+	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
+		ret = __clk_speculate_rates(child, new_rate);
+		if (ret == NOTIFY_BAD)
+			break;
+	}
+
+out:
+	return ret;
 }
 
 /**
@@ -286,11 +385,16 @@ static void __clk_recalc_rates(struct clk *clk)
  *
  * To prevent this consider setting the CLK_GATE_SET_RATE flag on any
  * clk where you also set the CLK_PARENT_SET_RATE flag
+ *
+ * PRE_RATE_CHANGE notifications are supposed to stack as a rate change
+ * request propagates up the clk tree.  This reflects the different
+ * rates that a downstream clk might experience if left enabled while
+ * upstream parents change their rates.
  */
 struct clk *__clk_set_rate(struct clk *clk, unsigned long rate)
 {
 	struct clk *fail_clk = NULL;
-	int ret = 0;
+	int ret = NOTIFY_DONE;
 	unsigned long old_rate = clk->rate;
 	unsigned long new_rate;
 	unsigned long parent_old_rate;
@@ -307,14 +411,25 @@ struct clk *__clk_set_rate(struct clk *clk, unsigned long rate)
 
 	new_rate = clk->ops->round_rate(clk, rate, &parent_new_rate);
 
-	/* FIXME propagate pre-rate change notification here */
-	/* XXX note that pre-rate change notifications will stack */
+	/* NOTE: pre-rate change notifications will stack */
+	if (clk->notifier_count)
+		ret = __clk_notify(clk, PRE_RATE_CHANGE, clk->rate, new_rate);
+
+	if (ret == NOTIFY_BAD)
+		return clk;
+
+	/* speculate rate changes down the tree */
+	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
+		ret = __clk_speculate_rates(child, new_rate);
+		if (ret == NOTIFY_BAD)
+			return clk;
+	}
 
 	/* change the rate of this clk */
 	if (clk->ops->set_rate)
 		ret = clk->ops->set_rate(clk, new_rate);
 
-	if (ret)
+	if (ret == NOTIFY_BAD)
 		return clk;
 
 	/*
@@ -336,6 +451,19 @@ struct clk *__clk_set_rate(struct clk *clk, unsigned long rate)
 			pr_warn("%s: failed to set parent %s rate to %lu\n",
 					__func__, fail_clk->name,
 					parent_new_rate);
+
+			/*
+			 * Send PRE_RATE_CHANGE notifiers down the tree
+			 * again, since we're rolling back the rate
+			 * changes due to the abort.
+			 *
+			 * Ignore any NOTIFY_BAD's since this *is* the
+			 * exception handler.
+			 *
+			 * NOTE: pre-rate change notifications will stack
+			 */
+			__clk_speculate_rates(clk, clk->parent->rate);
+
 			clk->ops->set_rate(clk, old_rate);
 		}
 		return fail_clk;
@@ -350,8 +478,7 @@ struct clk *__clk_set_rate(struct clk *clk, unsigned long rate)
 	 * and post-rate change notifiers down the clk tree from this
 	 * point.
 	 */
-	/* FIXME propagate post-rate change notifier starting with this clk */
-	__clk_recalc_rates(clk);
+	__clk_recalc_rates(clk, POST_RATE_CHANGE);
 
 	return NULL;
 }
@@ -412,9 +539,10 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	if (fail_clk) {
 		pr_warn("%s: failed to set %s rate\n", __func__,
 				fail_clk->name);
-		/* FIXME propagate rate change abort notification here */
+		__clk_recalc_rates(clk, ABORT_RATE_CHANGE);
 		ret = -EIO;
 	}
+
 out:
 	mutex_unlock(&prepare_lock);
 
@@ -485,7 +613,13 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	if (clk->parent == parent)
 		goto out;
 
-	/* FIXME add pre-rate change notification here */
+	/* propagate PRE_RATE_CHANGE notifications */
+	if (clk->notifier_count)
+		ret = __clk_speculate_rates(clk, parent->rate);
+
+	/* abort if a driver objects */
+	if (ret == NOTIFY_STOP)
+		goto out;
 
 	/* only re-parent if the clock is not in use */
 	if ((clk->flags & CLK_GATE_SET_PARENT) && clk->prepare_count)
@@ -493,10 +627,16 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	else
 		ret = clk->ops->set_parent(clk, parent);
 
-	if (ret < 0)
-		/* FIXME add rate change abort notification here */
+	/* propagate ABORT_RATE_CHANGE if .set_parent failed */
+	if (ret) {
+		__clk_recalc_rates(clk, ABORT_RATE_CHANGE);
 		goto out;
+	}
 
+	/*
+	 * FIXME prepare_count, enable_count & notifier_count should
+	 * migrate which switching parents
+	 */
 	/* update tree topology */
 	__clk_reparent(clk, parent);
 
@@ -504,7 +644,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	 * If successful recalculate the rates of the clock, including
 	 * children.
 	 */
-	__clk_recalc_rates(clk);
+	__clk_recalc_rates(clk, POST_RATE_CHANGE);
 
 out:
 	mutex_unlock(&prepare_lock);
@@ -562,3 +702,119 @@ void clk_init(struct device *dev, struct clk *clk)
 	return;
 }
 EXPORT_SYMBOL_GPL(clk_init);
+
+/***        clk rate change notifiers        ***/
+
+/**
+ * clk_notifier_register - add a clk rate change notifier
+ * @clk: struct clk * to watch
+ * @nb: struct notifier_block * with callback info
+ *
+ * Request notification when clk's rate changes.  This uses an SRCU
+ * notifier because we want it to block and notifier unregistrations are
+ * uncommon.  The callbacks associated with the notifier must not
+ * re-enter into the clk framework by calling any top-level clk APIs;
+ * this will cause a nested prepare_lock mutex.
+ *
+ * Pre-change notifier callbacks will be passed the current, pre-change
+ * rate of the clk via struct clk_notifier_data.old_rate.  The new,
+ * post-change rate of the clk is passed via struct
+ * clk_notifier.new_rate.
+ *
+ * Post-change notifiers will pass the now-current, post-change rate of
+ * the clk in both struct clk_notifier_data.old_rate and struct
+ * clk_notifier_data.new_rate.
+ *
+ * Abort-change notifiers are effectively the opposite of pre-change
+ * notifiers: the original pre-change clk rate is passed in via struct
+ * clk_notifier_data.new_rate and the failed post-change rate is passed
+ * in via struct clk_notifier_data.old_rate.
+ *
+ * clk_notifier_register() must be called from non-atomic context.
+ * Returns -EINVAL if called with null arguments, -ENOMEM upon
+ * allocation failure; otherwise, passes along the return value of
+ * srcu_notifier_chain_register().
+ */
+int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
+{
+	struct clk_notifier *cn;
+	int ret = -ENOMEM;
+
+	if (!clk || !nb)
+		return -EINVAL;
+
+	mutex_lock(&prepare_lock);
+
+	/* search the list of notifiers for this clk */
+	list_for_each_entry(cn, &clk_notifier_list, node)
+		if (cn->clk == clk)
+			break;
+
+	/* if clk wasn't in the notifier list, allocate new clk_notifier */
+	if (cn->clk != clk) {
+		cn = kzalloc(sizeof(struct clk_notifier), GFP_KERNEL);
+		if (!cn)
+			goto out;
+
+		cn->clk = clk;
+		srcu_init_notifier_head(&cn->notifier_head);
+
+		list_add(&cn->node, &clk_notifier_list);
+	}
+
+	ret = srcu_notifier_chain_register(&cn->notifier_head, nb);
+
+	clk->notifier_count++;
+
+out:
+	mutex_unlock(&prepare_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_notifier_register);
+
+/**
+ * clk_notifier_unregister - remove a clk rate change notifier
+ * @clk: struct clk *
+ * @nb: struct notifier_block * with callback info
+ *
+ * Request no further notification for changes to 'clk' and frees memory
+ * allocated in clk_notifier_register.
+ *
+ * Returns -EINVAL if called with null arguments; otherwise, passes
+ * along the return value of srcu_notifier_chain_unregister().
+ */
+int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
+{
+	struct clk_notifier *cn = NULL;
+	int ret = -EINVAL;
+
+	if (!clk || !nb)
+		return -EINVAL;
+
+	mutex_lock(&prepare_lock);
+
+	list_for_each_entry(cn, &clk_notifier_list, node)
+		if (cn->clk == clk)
+			break;
+
+	if (cn->clk == clk) {
+		ret = srcu_notifier_chain_unregister(&cn->notifier_head, nb);
+
+		clk->notifier_count--;
+
+		/* XXX the notifier code should handle this better */
+		if (!cn->notifier_head.head) {
+			srcu_cleanup_notifier_head(&cn->notifier_head);
+			kfree(cn);
+		}
+
+	} else {
+		ret = -ENOENT;
+	}
+
+	mutex_unlock(&prepare_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_notifier_unregister);
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 9cb8d72..63a72f2 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -14,6 +14,7 @@
 #define __LINUX_CLK_H
 
 #include <linux/kernel.h>
+#include <linux/notifier.h>
 #include <linux/errno.h>
 
 struct device;
@@ -44,6 +45,7 @@ struct clk {
 	unsigned int		prepare_count;
 	struct hlist_head	children;
 	struct hlist_node	child_node;
+	unsigned int		notifier_count;
 };
 
 /**
@@ -120,6 +122,8 @@ struct clk_hw_ops {
 	int		(*enable)(struct clk *clk);
 	void		(*disable)(struct clk *clk);
 	unsigned long	(*recalc_rate)(struct clk *clk);
+	unsigned long	(*speculate_rate)(struct clk *clk,
+					unsigned long parent_rate);
 	long		(*round_rate)(struct clk *clk, unsigned long,
 					unsigned long *);
 	int		(*set_parent)(struct clk *clk, struct clk *);
@@ -144,6 +148,66 @@ int __clk_prepare(struct clk *clk);
 void __clk_unprepare(struct clk *clk);
 void __clk_reparent(struct clk *clk, struct clk *new_parent);
 
+/**
+ * DOC: clk notifier callback types
+ *
+ * PRE_RATE_CHANGE - called immediately before the clk rate is changed,
+ *     to indicate that the rate change will proceed.  Drivers must
+ *     immediately terminate any operations that will be affected by the
+ *     rate change.  Callbacks may either return NOTIFY_DONE or
+ *     NOTIFY_STOP.
+ *
+ * ABORT_RATE_CHANGE: called if the rate change failed for some reason
+ *     after PRE_RATE_CHANGE.  In this case, all registered notifiers on
+ *     the clk will be called with ABORT_RATE_CHANGE. Callbacks must
+ *     always return NOTIFY_DONE.
+ *
+ * POST_RATE_CHANGE - called after the clk rate change has successfully
+ *     completed.  Callbacks must always return NOTIFY_DONE.
+ *
+ */
+#define PRE_RATE_CHANGE			BIT(0)
+#define POST_RATE_CHANGE		BIT(1)
+#define ABORT_RATE_CHANGE		BIT(2)
+
+/**
+ * struct clk_notifier - associate a clk with a notifier
+ * @clk: struct clk * to associate the notifier with
+ * @notifier_head: a blocking_notifier_head for this clk
+ * @node: linked list pointers
+ *
+ * A list of struct clk_notifier is maintained by the notifier code.
+ * An entry is created whenever code registers the first notifier on a
+ * particular @clk.  Future notifiers on that @clk are added to the
+ * @notifier_head.
+ */
+struct clk_notifier {
+	struct clk			*clk;
+	struct srcu_notifier_head	notifier_head;
+	struct list_head		node;
+};
+
+/**
+ * struct clk_notifier_data - rate data to pass to the notifier callback
+ * @clk: struct clk * being changed
+ * @old_rate: previous rate of this clk
+ * @new_rate: new rate of this clk
+ *
+ * For a pre-notifier, old_rate is the clk's rate before this rate
+ * change, and new_rate is what the rate will be in the future.  For a
+ * post-notifier, old_rate and new_rate are both set to the clk's
+ * current rate (this was done to optimize the implementation).
+ */
+struct clk_notifier_data {
+	struct clk		*clk;
+	unsigned long		old_rate;
+	unsigned long		new_rate;
+};
+
+int clk_notifier_register(struct clk *clk, struct notifier_block *nb);
+
+int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
+
 #endif /* !CONFIG_GENERIC_CLK */
 
 /**
-- 
1.7.5.4

