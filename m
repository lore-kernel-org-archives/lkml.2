Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934354Ab1ETH2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:28:44 -0400
Received: from ozlabs.org ([203.10.76.45]:60444 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933995Ab1ETH16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:27:58 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2/4] clk: Implement clk_set_rate
Message-Id: <1305876469.326620.351525457111.2.gpush@pororo>
In-Reply-To: <1305876469.325655.313573683829.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Fri, 20 May 2011 15:27:49 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implemenent clk_set_rate by adding a set_rate callback to clk_hw_ops,
and core code to handle propagation of rate changes up and down the
clock tree.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 drivers/clk/clk.c   |   74 ++++++++++++++++++++++++++++++++++++++++----
 include/linux/clk.h |   12 +++++++
 2 files changed, 80 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ad90a90..3a4d70e 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -21,6 +21,8 @@ struct clk {
 	unsigned int		enable_count;
 	unsigned int		prepare_count;
 	struct clk		*parent;
+	struct hlist_head	children;
+	struct hlist_node	child_node;
 	unsigned long		rate;
 };
 
@@ -176,10 +178,61 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
 }
 EXPORT_SYMBOL_GPL(clk_round_rate);
 
+/*
+ * clk_recalc_rates - Given a clock (with a recently updated clk->rate),
+ *	notify its children that the rate may need to be recalculated, using
+ *	ops->recalc_rate().
+ */
+static void clk_recalc_rates(struct clk *clk)
+{
+	struct hlist_node *tmp;
+	struct clk *child;
+
+	if (clk->ops->recalc_rate)
+		clk->rate = clk->ops->recalc_rate(clk->hw);
+
+	hlist_for_each_entry(child, tmp, &clk->children, child_node)
+		clk_recalc_rates(child);
+}
+
 int clk_set_rate(struct clk *clk, unsigned long rate)
 {
-	/* not yet implemented */
-	return -ENOSYS;
+	unsigned long parent_rate, new_rate;
+	int ret;
+
+	if (!clk->ops->set_rate)
+		return -ENOSYS;
+
+	new_rate = rate;
+
+	/* prevent racing with updates to the clock topology */
+	mutex_lock(&prepare_lock);
+
+propagate:
+	ret = clk->ops->set_rate(clk->hw, new_rate, &parent_rate);
+
+	if (ret < 0)
+		return ret;
+
+	/* ops->set_rate may require the parent's rate to change (to
+	 * parent_rate), we need to propagate the set_rate call to the
+	 * parent.
+	 */
+	if (ret == CLK_SET_RATE_PROPAGATE) {
+		new_rate = parent_rate;
+		clk = clk->parent;
+		goto propagate;
+	}
+
+	/* If successful (including propagation to the parent clock(s)),
+	 * recalculate the rates of the clock, including children.  We'll be
+	 * calling this on the 'parent-most' clock that we propagated to.
+	 */
+	clk_recalc_rates(clk);
+
+	mutex_unlock(&prepare_lock);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(clk_set_rate);
 
@@ -213,16 +266,25 @@ struct clk *clk_register(struct clk_hw_ops *ops, struct clk_hw *hw,
 	clk->hw = hw;
 	hw->clk = clk;
 
-	/* Query the hardware for parent and initial rate */
+	/* Query the hardware for parent and initial rate. We may alter
+	 * the clock topology, making this clock available from the parent's
+	 * children list. So, we need to protect against concurrent
+	 * accesses through set_rate
+	 */
+	mutex_lock(&prepare_lock);
 
-	if (clk->ops->get_parent)
-		/* We don't to lock against prepare/enable here, as
-		 * the clock is not yet accessible from anywhere */
+	if (clk->ops->get_parent) {
 		clk->parent = clk->ops->get_parent(clk->hw);
+		if (clk->parent)
+			hlist_add_head(&clk->child_node,
+					&clk->parent->children);
+	}
 
 	if (clk->ops->recalc_rate)
 		clk->rate = clk->ops->recalc_rate(clk->hw);
 
+	mutex_unlock(&prepare_lock);
+
 
 	return clk;
 }
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 93ff870..e0969d2 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -58,6 +58,12 @@ struct clk_hw {
  *		parent. Currently only called when the clock is first
  *		registered.
  *
+ * @set_rate	Change the rate of this clock. If this callback returns
+ *		CLK_SET_RATE_PROPAGATE, the rate change will be propagated to
+ *		the parent clock (which may propagate again). The requested
+ *		rate of the parent is passed back from the callback in the
+ *		second 'unsigned long *' argument.
+ *
  * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
  * implementations to split any work between atomic (enable) and sleepable
  * (prepare) contexts.  If a clock requires sleeping code to be turned on, this
@@ -76,9 +82,15 @@ struct clk_hw_ops {
 	void		(*disable)(struct clk_hw *);
 	unsigned long	(*recalc_rate)(struct clk_hw *);
 	long		(*round_rate)(struct clk_hw *, unsigned long);
+	int		(*set_rate)(struct clk_hw *,
+					unsigned long, unsigned long *);
 	struct clk *	(*get_parent)(struct clk_hw *);
 };
 
+enum {
+	CLK_SET_RATE_PROPAGATE = 1,
+};
+
 /**
  * clk_prepare - prepare clock for atomic enabling.
  *
