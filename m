Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab2CTDiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 23:38:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39231 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285Ab2CTDih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 23:38:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6654"; a="171631242"
From: Saravana Kannan <skannan@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/2] clk: Move init fields from clk to clk_hw
Date: Mon, 19 Mar 2012 20:38:26 -0700
Message-Id: <1332214706-675-2-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1332214706-675-1-git-send-email-skannan@codeaurora.org>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
 <1332214706-675-1-git-send-email-skannan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has a couple of advantages:
* Completely hides struct clk from many clock platform drivers and static
  clock initialization code.
* Simplifies the generic clk_register() function and allows adding optional
  fields in the future without modifying the function signature.
* Allows for simpler static initialization of clocks on all platforms by
  removing the need for forward delcarations.
* Halves the number of symbols added for each static clock initialization.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Richard Zhao <richard.zhao@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Deepak Saxena <dsaxena@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/clk/clk-divider.c    |   12 ++-
 drivers/clk/clk-fixed-rate.c |   12 ++-
 drivers/clk/clk-gate.c       |   12 ++-
 drivers/clk/clk-mux.c        |    9 ++-
 drivers/clk/clk.c            |  170 +++++++++++++++++++++---------------------
 include/linux/clk-private.h  |    5 -
 include/linux/clk-provider.h |    9 ++-
 7 files changed, 118 insertions(+), 111 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index d5ac6a7..68b69ed 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -184,11 +184,13 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
 			goto out;
 	}
 
-	clk = clk_register(dev, name,
-			&clk_divider_ops, &div->hw,
-			div->parent,
-			(parent_name ? 1 : 0),
-			flags);
+	div->hw.name = name;
+	div->hw.ops = &clk_divider_ops;
+	div->hw.flags = flags;
+	div->hw.parent_names = div->parent;
+	div->hw.num_parents = (parent_name ? 1 : 0);
+
+	clk = clk_register(dev, &div->hw);
 	if (clk)
 		return clk;
 
diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index 6423ae9..42a0156 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -73,11 +73,13 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 		strncpy(parent_names[0], parent_name, len);
 	}
 
-	return clk_register(dev, name,
-			&clk_fixed_rate_ops, &fixed->hw,
-			parent_names,
-			(parent_name ? 1 : 0),
-			flags);
+	fixed->hw.name = name;
+	fixed->hw.ops = &clk_fixed_rate_ops;
+	fixed->hw.flags = flags;
+	fixed->hw.parent_names = parent_names;
+	fixed->hw.num_parents = (parent_name ? 1 : 0);
+
+	return clk_register(dev, &fixed->hw);
 fail_str:
 	kfree(parent_names);
 fail_ptr:
diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index b5902e2..cb515c7 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -135,11 +135,13 @@ struct clk *clk_register_gate(struct device *dev, const char *name,
 			goto out;
 	}
 
-	clk = clk_register(dev, name,
-			&clk_gate_ops, &gate->hw,
-			gate->parent,
-			(parent_name ? 1 : 0),
-			flags);
+	gate->hw.name = name;
+	gate->hw.ops = &clk_gate_ops;
+	gate->hw.flags = flags;
+	gate->hw.parent_names = gate->parent;
+	gate->hw.num_parents = (parent_name ? 1 : 0);
+
+	clk = clk_register(dev, &gate->hw);
 	if (clk)
 		return clk;
 out:
diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index c71ad1f..1c88230 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -111,6 +111,11 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 	mux->flags = clk_mux_flags;
 	mux->lock = lock;
 
-	return clk_register(dev, name, &clk_mux_ops, &mux->hw,
-			parent_names, num_parents, flags);
+	mux->hw.name = name;
+	mux->hw.ops = &clk_mux_ops;
+	mux->hw.flags = flags;
+	mux->hw.parent_names = parent_names;
+	mux->hw.num_parents = num_parents;
+
+	return clk_register(dev, &mux->hw);
 }
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 9cf6f59..c448809 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/clk-private.h>
+#include <linux/clk-provider.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -44,7 +45,7 @@ static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
 		goto out;
 	}
 
-	d = debugfs_create_dir(clk->name, pdentry);
+	d = debugfs_create_dir(clk->hw->name, pdentry);
 	if (!d)
 		goto out;
 
@@ -56,7 +57,7 @@ static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
 		goto err_out;
 
 	d = debugfs_create_x32("clk_flags", S_IRUGO, clk->dentry,
-			(u32 *)&clk->flags);
+			(u32 *)&clk->hw->flags);
 	if (!d)
 		goto err_out;
 
@@ -134,7 +135,7 @@ static int clk_debug_register(struct clk *clk)
 	 * safe to add this clk to debugfs
 	 */
 	if (!parent)
-		if (clk->flags & CLK_IS_ROOT)
+		if (clk->hw->flags & CLK_IS_ROOT)
 			pdentry = rootdir;
 		else
 			pdentry = orphandir;
@@ -215,11 +216,11 @@ static void clk_disable_unused_subtree(struct clk *clk)
 	if (clk->enable_count)
 		goto unlock_out;
 
-	if (clk->flags & CLK_IGNORE_UNUSED)
+	if (clk->hw->flags & CLK_IGNORE_UNUSED)
 		goto unlock_out;
 
-	if (__clk_is_enabled(clk) && clk->ops->disable)
-		clk->ops->disable(clk->hw);
+	if (__clk_is_enabled(clk) && clk->hw->ops->disable)
+		clk->hw->ops->disable(clk->hw);
 
 unlock_out:
 	spin_unlock_irqrestore(&enable_lock, flags);
@@ -254,7 +255,7 @@ static inline int clk_disable_unused(struct clk *clk) { return 0; }
 
 inline const char *__clk_get_name(struct clk *clk)
 {
-	return !clk ? NULL : clk->name;
+	return !clk ? NULL : clk->hw->name;
 }
 
 inline struct clk_hw *__clk_get_hw(struct clk *clk)
@@ -264,7 +265,7 @@ inline struct clk_hw *__clk_get_hw(struct clk *clk)
 
 inline u8 __clk_get_num_parents(struct clk *clk)
 {
-	return !clk ? -EINVAL : clk->num_parents;
+	return !clk ? -EINVAL : clk->hw->num_parents;
 }
 
 inline struct clk *__clk_get_parent(struct clk *clk)
@@ -293,7 +294,7 @@ unsigned long __clk_get_rate(struct clk *clk)
 
 	ret = clk->rate;
 
-	if (clk->flags & CLK_IS_ROOT)
+	if (clk->hw->flags & CLK_IS_ROOT)
 		goto out;
 
 	if (!clk->parent)
@@ -305,7 +306,7 @@ out:
 
 inline unsigned long __clk_get_flags(struct clk *clk)
 {
-	return !clk ? -EINVAL : clk->flags;
+	return !clk ? -EINVAL : clk->hw->flags;
 }
 
 int __clk_is_enabled(struct clk *clk)
@@ -319,12 +320,12 @@ int __clk_is_enabled(struct clk *clk)
 	 * .is_enabled is only mandatory for clocks that gate
 	 * fall back to software usage counter if .is_enabled is missing
 	 */
-	if (!clk->ops->is_enabled) {
+	if (!clk->hw->ops->is_enabled) {
 		ret = clk->enable_count ? 1 : 0;
 		goto out;
 	}
 
-	ret = clk->ops->is_enabled(clk->hw);
+	ret = clk->hw->ops->is_enabled(clk->hw);
 out:
 	return ret;
 }
@@ -335,7 +336,7 @@ static struct clk *__clk_lookup_subtree(const char *name, struct clk *clk)
 	struct clk *ret;
 	struct hlist_node *tmp;
 
-	if (!strcmp(clk->name, name))
+	if (!strcmp(clk->hw->name, name))
 		return clk;
 
 	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
@@ -388,8 +389,8 @@ void __clk_unprepare(struct clk *clk)
 
 	WARN_ON(clk->enable_count > 0);
 
-	if (clk->ops->unprepare)
-		clk->ops->unprepare(clk->hw);
+	if (clk->hw->ops->unprepare)
+		clk->hw->ops->unprepare(clk->hw);
 
 	__clk_unprepare(clk->parent);
 }
@@ -425,8 +426,8 @@ int __clk_prepare(struct clk *clk)
 		if (ret)
 			return ret;
 
-		if (clk->ops->prepare) {
-			ret = clk->ops->prepare(clk->hw);
+		if (clk->hw->ops->prepare) {
+			ret = clk->hw->ops->prepare(clk->hw);
 			if (ret) {
 				__clk_unprepare(clk->parent);
 				return ret;
@@ -474,8 +475,8 @@ static void __clk_disable(struct clk *clk)
 	if (--clk->enable_count > 0)
 		return;
 
-	if (clk->ops->disable)
-		clk->ops->disable(clk->hw);
+	if (clk->hw->ops->disable)
+		clk->hw->ops->disable(clk->hw);
 
 	__clk_disable(clk->parent);
 }
@@ -518,8 +519,8 @@ static int __clk_enable(struct clk *clk)
 		if (ret)
 			return ret;
 
-		if (clk->ops->enable) {
-			ret = clk->ops->enable(clk->hw);
+		if (clk->hw->ops->enable) {
+			ret = clk->hw->ops->enable(clk->hw);
 			if (ret) {
 				__clk_disable(clk->parent);
 				return ret;
@@ -589,13 +590,13 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
 	if (!clk)
 		return -EINVAL;
 
-	if (!clk->ops->round_rate)
+	if (!clk->hw->ops->round_rate)
 		return clk->rate;
 
-	if (clk->flags & CLK_SET_RATE_PARENT)
-		return clk->ops->round_rate(clk->hw, rate, &unused);
+	if (clk->hw->flags & CLK_SET_RATE_PARENT)
+		return clk->hw->ops->round_rate(clk->hw, rate, &unused);
 	else
-		return clk->ops->round_rate(clk->hw, rate, NULL);
+		return clk->hw->ops->round_rate(clk->hw, rate, NULL);
 }
 
 /**
@@ -681,8 +682,8 @@ static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
 	if (clk->parent)
 		parent_rate = clk->parent->rate;
 
-	if (clk->ops->recalc_rate)
-		clk->rate = clk->ops->recalc_rate(clk->hw, parent_rate);
+	if (clk->hw->ops->recalc_rate)
+		clk->rate = clk->hw->ops->recalc_rate(clk->hw, parent_rate);
 	else
 		clk->rate = parent_rate;
 
@@ -720,8 +721,8 @@ static int __clk_speculate_rates(struct clk *clk, unsigned long parent_rate)
 	unsigned long new_rate;
 	int ret = NOTIFY_DONE;
 
-	if (clk->ops->recalc_rate)
-		new_rate = clk->ops->recalc_rate(clk->hw, parent_rate);
+	if (clk->hw->ops->recalc_rate)
+		new_rate = clk->hw->ops->recalc_rate(clk->hw, parent_rate);
 	else
 		new_rate = parent_rate;
 
@@ -750,8 +751,8 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate)
 	clk->new_rate = new_rate;
 
 	hlist_for_each_entry(child, tmp, &clk->children, child_node) {
-		if (child->ops->recalc_rate)
-			child->new_rate = child->ops->recalc_rate(child->hw, new_rate);
+		if (child->hw->ops->recalc_rate)
+			child->new_rate = child->hw->ops->recalc_rate(child->hw, new_rate);
 		else
 			child->new_rate = new_rate;
 		clk_calc_subtree(child, child->new_rate);
@@ -767,23 +768,24 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 	struct clk *top = clk;
 	unsigned long best_parent_rate = clk->parent->rate;
 	unsigned long new_rate;
+	unsigned long flags = clk->hw->flags;
 
-	if (!clk->ops->round_rate && !(clk->flags & CLK_SET_RATE_PARENT)) {
+	if (!clk->hw->ops->round_rate && !(flags & CLK_SET_RATE_PARENT)) {
 		clk->new_rate = clk->rate;
 		return NULL;
 	}
 
-	if (!clk->ops->round_rate && (clk->flags & CLK_SET_RATE_PARENT)) {
+	if (!clk->hw->ops->round_rate && (flags & CLK_SET_RATE_PARENT)) {
 		top = clk_calc_new_rates(clk->parent, rate);
 		new_rate = clk->new_rate = clk->parent->new_rate;
 
 		goto out;
 	}
 
-	if (clk->flags & CLK_SET_RATE_PARENT)
-		new_rate = clk->ops->round_rate(clk->hw, rate, &best_parent_rate);
+	if (flags & CLK_SET_RATE_PARENT)
+		new_rate = clk->hw->ops->round_rate(clk->hw, rate, &best_parent_rate);
 	else
-		new_rate = clk->ops->round_rate(clk->hw, rate, NULL);
+		new_rate = clk->hw->ops->round_rate(clk->hw, rate, NULL);
 
 	if (best_parent_rate != clk->parent->rate) {
 		top = clk_calc_new_rates(clk->parent, best_parent_rate);
@@ -838,11 +840,11 @@ static void clk_change_rate(struct clk *clk)
 
 	old_rate = clk->rate;
 
-	if (clk->ops->set_rate)
-		clk->ops->set_rate(clk->hw, clk->new_rate);
+	if (clk->hw->ops->set_rate)
+		clk->hw->ops->set_rate(clk->hw, clk->new_rate);
 
-	if (clk->ops->recalc_rate)
-		clk->rate = clk->ops->recalc_rate(clk->hw,
+	if (clk->hw->ops->recalc_rate)
+		clk->rate = clk->hw->ops->recalc_rate(clk->hw,
 				clk->parent->rate);
 	else
 		clk->rate = clk->parent->rate;
@@ -917,7 +919,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	fail_clk = clk_propagate_rate_change(top, PRE_RATE_CHANGE);
 	if (fail_clk) {
 		pr_warn("%s: failed to set %s rate\n", __func__,
-				fail_clk->name);
+				fail_clk->hw->name);
 		clk_propagate_rate_change(top, ABORT_RATE_CHANGE);
 		ret = -EBUSY;
 		goto out;
@@ -970,18 +972,19 @@ static struct clk *__clk_init_parent(struct clk *clk)
 
 	/* handle the trivial cases */
 
-	if (!clk->num_parents)
+	if (!clk->hw->num_parents)
 		goto out;
 
-	if (clk->num_parents == 1) {
+	if (clk->hw->num_parents == 1) {
 		if (IS_ERR_OR_NULL(clk->parent))
-			ret = clk->parent = __clk_lookup(clk->parent_names[0]);
+			ret = clk->parent =
+				__clk_lookup(clk->hw->parent_names[0]);
 		ret = clk->parent;
 		goto out;
 	}
 
-	if (!clk->ops->get_parent) {
-		WARN(!clk->ops->get_parent,
+	if (!clk->hw->ops->get_parent) {
+		WARN(!clk->hw->ops->get_parent,
 			"%s: multi-parent clocks must implement .get_parent\n",
 			__func__);
 		goto out;
@@ -993,18 +996,18 @@ static struct clk *__clk_init_parent(struct clk *clk)
 	 * clk->parent here; that is done by the calling function
 	 */
 
-	index = clk->ops->get_parent(clk->hw);
+	index = clk->hw->ops->get_parent(clk->hw);
 
 	if (!clk->parents)
 		clk->parents =
-			kmalloc((sizeof(struct clk*) * clk->num_parents),
+			kmalloc((sizeof(struct clk*) * clk->hw->num_parents),
 					GFP_KERNEL);
 
 	if (!clk->parents)
-		ret = __clk_lookup(clk->parent_names[index]);
+		ret = __clk_lookup(clk->hw->parent_names[index]);
 	else if (!clk->parents[index])
 		ret = clk->parents[index] =
-			__clk_lookup(clk->parent_names[index]);
+			__clk_lookup(clk->hw->parent_names[index]);
 	else
 		ret = clk->parents[index];
 
@@ -1039,12 +1042,12 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
 		new_parent_d = orphandir;
 
 	d = debugfs_rename(clk->dentry->d_parent, clk->dentry,
-			new_parent_d, clk->name);
+			new_parent_d, clk->hw->name);
 	if (d)
 		clk->dentry = d;
 	else
 		pr_debug("%s: failed to rename debugfs entry for %s\n",
-				__func__, clk->name);
+				__func__, clk->hw->name);
 out:
 #endif
 
@@ -1063,7 +1066,7 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 	old_parent = clk->parent;
 
 	/* find index of new parent clock using cached parent ptrs */
-	for (i = 0; i < clk->num_parents; i++)
+	for (i = 0; i < clk->hw->num_parents; i++)
 		if (clk->parents[i] == parent)
 			break;
 
@@ -1071,16 +1074,17 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 	 * find index of new parent clock using string name comparison
 	 * also try to cache the parent to avoid future calls to __clk_lookup
 	 */
-	if (i == clk->num_parents)
-		for (i = 0; i < clk->num_parents; i++)
-			if (!strcmp(clk->parent_names[i], parent->name)) {
-				clk->parents[i] = __clk_lookup(parent->name);
+	if (i == clk->hw->num_parents)
+		for (i = 0; i < clk->hw->num_parents; i++)
+			if (!strcmp(clk->hw->parent_names[i],
+						parent->hw->name)) {
+				clk->parents[i] = __clk_lookup(parent->hw->name);
 				break;
 			}
 
-	if (i == clk->num_parents) {
+	if (i == clk->hw->num_parents) {
 		pr_debug("%s: clock %s is not a possible parent of clock %s\n",
-				__func__, parent->name, clk->name);
+				__func__, parent->hw->name, clk->hw->name);
 		goto out;
 	}
 
@@ -1095,7 +1099,7 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent)
 	spin_unlock_irqrestore(&enable_lock, flags);
 
 	/* change clock input source */
-	ret = clk->ops->set_parent(clk->hw, i);
+	ret = clk->hw->ops->set_parent(clk->hw, i);
 
 	/* clean up old prepare and enable */
 	spin_lock_irqsave(&enable_lock, flags);
@@ -1126,10 +1130,10 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 {
 	int ret = 0;
 
-	if (!clk || !clk->ops)
+	if (!clk || !clk->hw->ops)
 		return -EINVAL;
 
-	if (!clk->ops->set_parent)
+	if (!clk->hw->ops->set_parent)
 		return -ENOSYS;
 
 	/* prevent racing with updates to the clock topology */
@@ -1147,7 +1151,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 		goto out;
 
 	/* only re-parent if the clock is not in use */
-	if ((clk->flags & CLK_SET_PARENT_GATE) && clk->prepare_count)
+	if ((clk->hw->flags & CLK_SET_PARENT_GATE) && clk->prepare_count)
 		ret = -EBUSY;
 	else
 		ret = __clk_set_parent(clk, parent);
@@ -1207,14 +1211,14 @@ void __clk_init(struct device *dev, struct clk *clk)
 	mutex_lock(&prepare_lock);
 
 	/* check to see if a clock with this name is already registered */
-	if (__clk_lookup(clk->name))
+	if (__clk_lookup(clk->hw->name))
 		goto out;
 
 	/* throw a WARN if any entries in parent_names are NULL */
-	for (i = 0; i < clk->num_parents; i++)
-		WARN(!clk->parent_names[i],
+	for (i = 0; i < clk->hw->num_parents; i++)
+		WARN(!clk->hw->parent_names[i],
 				"%s: invalid NULL in %s's .parent_names\n",
-				__func__, clk->name);
+				__func__, clk->hw->name);
 
 	/*
 	 * Allocate an array of struct clk *'s to avoid unnecessary string
@@ -1226,8 +1230,8 @@ void __clk_init(struct device *dev, struct clk *clk)
 	 * If clk->parents is not NULL we skip this entire block.  This allows
 	 * for clock drivers to statically initialize clk->parents.
 	 */
-	if (clk->num_parents && !clk->parents) {
-		clk->parents = kmalloc((sizeof(struct clk*) * clk->num_parents),
+	if (clk->hw->num_parents && !clk->parents) {
+		clk->parents = kmalloc((sizeof(struct clk*) * clk->hw->num_parents),
 				GFP_KERNEL);
 		/*
 		 * __clk_lookup returns NULL for parents that have not been
@@ -1236,9 +1240,9 @@ void __clk_init(struct device *dev, struct clk *clk)
 		 * missing parents later on.
 		 */
 		if (clk->parents)
-			for (i = 0; i < clk->num_parents; i++)
+			for (i = 0; i < clk->hw->num_parents; i++)
 				clk->parents[i] =
-					__clk_lookup(clk->parent_names[i]);
+					__clk_lookup(clk->hw->parent_names[i]);
 	}
 
 	clk->parent = __clk_init_parent(clk);
@@ -1256,7 +1260,7 @@ void __clk_init(struct device *dev, struct clk *clk)
 	if (clk->parent)
 		hlist_add_head(&clk->child_node,
 				&clk->parent->children);
-	else if (clk->flags & CLK_IS_ROOT)
+	else if (clk->hw->flags & CLK_IS_ROOT)
 		hlist_add_head(&clk->child_node, &clk_root_list);
 	else
 		hlist_add_head(&clk->child_node, &clk_orphan_list);
@@ -1267,8 +1271,8 @@ void __clk_init(struct device *dev, struct clk *clk)
 	 * parent's rate.  If a clock doesn't have a parent (or is orphaned)
 	 * then rate is set to zero.
 	 */
-	if (clk->ops->recalc_rate)
-		clk->rate = clk->ops->recalc_rate(clk->hw,
+	if (clk->hw->ops->recalc_rate)
+		clk->rate = clk->hw->ops->recalc_rate(clk->hw,
 				__clk_get_rate(clk->parent));
 	else if (clk->parent)
 		clk->rate = clk->parent->rate;
@@ -1280,8 +1284,9 @@ void __clk_init(struct device *dev, struct clk *clk)
 	 * this clock
 	 */
 	hlist_for_each_entry_safe(orphan, tmp, tmp2, &clk_orphan_list, child_node)
-		for (i = 0; i < orphan->num_parents; i++)
-			if (!strcmp(clk->name, orphan->parent_names[i])) {
+		for (i = 0; i < orphan->hw->num_parents; i++)
+			if (!strcmp(clk->hw->name,
+						orphan->hw->parent_names[i])) {
 				__clk_reparent(orphan, clk);
 				break;
 			}
@@ -1294,8 +1299,8 @@ void __clk_init(struct device *dev, struct clk *clk)
 	 * Please consider other ways of solving initialization problems before
 	 * using this callback, as it's use is discouraged.
 	 */
-	if (clk->ops->init)
-		clk->ops->init(clk->hw);
+	if (clk->hw->ops->init)
+		clk->hw->ops->init(clk->hw);
 
 	clk_debug_register(clk);
 
@@ -1320,9 +1325,7 @@ out:
  * cannot be dereferenced by driver code but may be used in conjuction with the
  * rest of the clock API.
  */
-struct clk *clk_register(struct device *dev, const char *name,
-		const struct clk_ops *ops, struct clk_hw *hw,
-		char **parent_names, u8 num_parents, unsigned long flags)
+struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 {
 	struct clk *clk;
 
@@ -1330,12 +1333,7 @@ struct clk *clk_register(struct device *dev, const char *name,
 	if (!clk)
 		return NULL;
 
-	clk->name = name;
-	clk->ops = ops;
 	clk->hw = hw;
-	clk->flags = flags;
-	clk->parent_names = parent_names;
-	clk->num_parents = num_parents;
 	hw->clk = clk;
 
 	__clk_init(dev, clk);
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 5e4312b..f70860d 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -26,16 +26,11 @@
 #ifdef CONFIG_COMMON_CLK
 
 struct clk {
-	const char		*name;
-	const struct clk_ops	*ops;
 	struct clk_hw		*hw;
 	struct clk		*parent;
-	char			**parent_names;
 	struct clk		**parents;
-	u8			num_parents;
 	unsigned long		rate;
 	unsigned long		new_rate;
-	unsigned long		flags;
 	unsigned int		enable_count;
 	unsigned int		prepare_count;
 	struct hlist_head	children;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 5508897..f032e49 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -26,6 +26,11 @@
  */
 struct clk_hw {
 	struct clk *clk;
+	const char		*name;
+	const struct clk_ops	*ops;
+	char			**parent_names;
+	u8			num_parents;
+	unsigned long		flags;
 };
 
 /*
@@ -272,9 +277,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
  * cannot be dereferenced by driver code but may be used in conjuction with the
  * rest of the clock API.
  */
-struct clk *clk_register(struct device *dev, const char *name,
-		const struct clk_ops *ops, struct clk_hw *hw,
-		char **parent_names, u8 num_parents, unsigned long flags);
+struct clk *clk_register(struct device *dev, struct clk_hw *hw);
 
 /* helper functions */
 const char *__clk_get_name(struct clk *clk);
-- 
1.7.8.3

