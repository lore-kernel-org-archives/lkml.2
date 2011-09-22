Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1IVWb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:31:57 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:40891 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336Ab1IVWaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:30:52 -0400
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
Subject: [PATCH v2 2/7] clk: Implement clk_set_rate
Date: Thu, 22 Sep 2011 15:26:57 -0700
Message-Id: <1316730422-20027-3-git-send-email-mturquette@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316730422-20027-1-git-send-email-mturquette@ti.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr@canonical.com>

Implement clk_set_rate by adding a set_rate callback to clk_hw_ops.
Rates are propagated down the clock tree and recalculated.  Also adds a
flag for signaling that parents must change rates to achieve the desired
frequency (upstream propagation).

TODO:
Upstream propagation is not yet implemented.
Device pre-change and post-change notifications are not implemented, but
are marked up as FIXME comments.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Mike Turquette <mturquette@ti.com>
---
Changes since v1:
Remove upstream propagation (for now)
Rename CLK_SET_RATE_PROPAGATE to CLK_PARENT_RATE_CHANGE

 drivers/clk/clk.c   |   71 ++++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/clk.h |   12 ++++++++
 2 files changed, 77 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 1cd7315..86636c2 100644
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
 
@@ -176,10 +178,57 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
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
+	/* FIXME add post-rate change notification here */
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
+	int ret = 0;
+
+	if (!clk->ops->set_rate)
+		return -ENOSYS;
+
+	new_rate = rate;
+
+	/* prevent racing with updates to the clock topology */
+	mutex_lock(&prepare_lock);
+
+	/* FIXME add pre-rate change notification here */
+
+	ret = clk->ops->set_rate(clk->hw, new_rate, &parent_rate);
+
+	/* FIXME ignores CLK_PARENT_RATE_CHANGE */
+	if (ret < 0)
+		/* FIXME add rate change abort notification here */
+		goto out;
+
+	/*
+	 * If successful recalculate the rates of the clock, including
+	 * children.
+	 */
+	clk_recalc_rates(clk);
+
+out:
+	mutex_unlock(&prepare_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_set_rate);
 
@@ -216,16 +265,26 @@ struct clk *clk_register(const struct clk_hw_ops *ops, struct clk_hw *hw,
 	clk->hw = hw;
 	hw->clk = clk;
 
-	/* Query the hardware for parent and initial rate */
+	/*
+	 * Query the hardware for parent and initial rate. We may alter
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
index d6ae10b..0d2cd5e 100644
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
+	CLK_PARENT_RATE_CHANGE = 1,
+};
+
 /**
  * clk_prepare - prepare clock for atomic enabling.
  *
-- 
1.7.4.1

