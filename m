Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908Ab1KBSn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:43:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18118 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab1KBShA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706964"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 09/34] msm: clock: Implement rate voting
Date: Wed,  2 Nov 2011 11:36:06 -0700
Message-Id: <1320258991-22325-10-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Some clocks have multiple consumers where each consumer requires
a minimum rate. Implement a sub driver to aggregate
clk_set_rate() calls from each consumer and call clk_set_rate()
on the parent clock when the minimum requested rate of all the
voters changes.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/Makefile      |    1 +
 arch/arm/mach-msm/clock-pcom.h  |    2 +-
 arch/arm/mach-msm/clock-voter.c |  187 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/clock-voter.h |   41 +++++++++
 arch/arm/mach-msm/clock.c       |   18 ++---
 arch/arm/mach-msm/clock.h       |    9 ++
 6 files changed, 245 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm/mach-msm/clock-voter.c
 create mode 100644 arch/arm/mach-msm/clock-voter.h

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 4285dfd..5318553 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -1,5 +1,6 @@
 obj-y += io.o idle.o timer.o
 obj-y += clock.o
+obj-y += clock-voter.o
 obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
diff --git a/arch/arm/mach-msm/clock-pcom.h b/arch/arm/mach-msm/clock-pcom.h
index 955c917..a5ac74d 100644
--- a/arch/arm/mach-msm/clock-pcom.h
+++ b/arch/arm/mach-msm/clock-pcom.h
@@ -145,7 +145,7 @@ static inline struct pcom_clk *to_pcom_clk(struct clk *clk)
 			.ops = &clk_ops_pcom, \
 			.flags = clk_flags, \
 			.dbg_name = #clk_id, \
-			.lock = __SPIN_LOCK_UNLOCKED(clk_name.c), \
+			CLK_INIT(clk_name.c), \
 		}, \
 	}
 
diff --git a/arch/arm/mach-msm/clock-voter.c b/arch/arm/mach-msm/clock-voter.c
new file mode 100644
index 0000000..6da4384
--- /dev/null
+++ b/arch/arm/mach-msm/clock-voter.c
@@ -0,0 +1,187 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include <linux/clk.h>
+
+#include "clock.h"
+#include "clock-voter.h"
+
+static DEFINE_SPINLOCK(voter_clk_lock);
+
+/* Aggregate the rate of clocks that are currently on. */
+static unsigned voter_clk_aggregate_rate(const struct clk *parent)
+{
+	struct clk *clk;
+	unsigned rate = 0;
+
+	list_for_each_entry(clk, &parent->children, siblings) {
+		struct clk_voter *v = to_clk_voter(clk);
+		if (v->enabled)
+			rate = max(v->rate, rate);
+	}
+	return rate;
+}
+
+static int voter_clk_set_rate(struct clk *clk, unsigned rate)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct clk *clkp;
+	struct clk_voter *clkh, *v = to_clk_voter(clk);
+	unsigned cur_rate, new_rate, other_rate = 0;
+
+	spin_lock_irqsave(&voter_clk_lock, flags);
+
+	if (v->enabled) {
+		struct clk *parent = v->parent;
+
+		/*
+		 * Get the aggregate rate without this clock's vote and update
+		 * if the new rate is different than the current rate
+		 */
+		list_for_each_entry(clkp, &parent->children, siblings) {
+			clkh = to_clk_voter(clkp);
+			if (clkh->enabled && clkh != v)
+				other_rate = max(clkh->rate, other_rate);
+		}
+
+		cur_rate = max(other_rate, v->rate);
+		new_rate = max(other_rate, rate);
+
+		if (new_rate != cur_rate) {
+			ret = clk_set_min_rate(parent, new_rate);
+			if (ret)
+				goto unlock;
+		}
+	}
+	v->rate = rate;
+unlock:
+	spin_unlock_irqrestore(&voter_clk_lock, flags);
+
+	return ret;
+}
+
+static int voter_clk_enable(struct clk *clk)
+{
+	int ret;
+	unsigned long flags;
+	unsigned cur_rate;
+	struct clk *parent;
+	struct clk_voter *v = to_clk_voter(clk);
+
+	spin_lock_irqsave(&voter_clk_lock, flags);
+	parent = v->parent;
+
+	/*
+	 * Increase the rate if this clock is voting for a higher rate
+	 * than the current rate.
+	 */
+	cur_rate = voter_clk_aggregate_rate(parent);
+	if (v->rate > cur_rate) {
+		ret = clk_set_min_rate(parent, v->rate);
+		if (ret)
+			goto out;
+	}
+	v->enabled = true;
+out:
+	spin_unlock_irqrestore(&voter_clk_lock, flags);
+
+	return ret;
+}
+
+static void voter_clk_disable(struct clk *clk)
+{
+	unsigned long flags;
+	struct clk *parent;
+	struct clk_voter *v = to_clk_voter(clk);
+	unsigned cur_rate, new_rate;
+
+	spin_lock_irqsave(&voter_clk_lock, flags);
+	parent = v->parent;
+
+	/*
+	 * Decrease the rate if this clock was the only one voting for
+	 * the highest rate.
+	 */
+	v->enabled = false;
+	new_rate = voter_clk_aggregate_rate(parent);
+	cur_rate = max(new_rate, v->rate);
+
+	if (new_rate < cur_rate)
+		clk_set_min_rate(parent, new_rate);
+
+	spin_unlock_irqrestore(&voter_clk_lock, flags);
+}
+
+static unsigned voter_clk_get_rate(struct clk *clk)
+{
+	unsigned rate;
+	unsigned long flags;
+	struct clk_voter *v = to_clk_voter(clk);
+
+	spin_lock_irqsave(&voter_clk_lock, flags);
+	rate = v->rate;
+	spin_unlock_irqrestore(&voter_clk_lock, flags);
+
+	return rate;
+}
+
+static unsigned voter_clk_is_enabled(struct clk *clk)
+{
+	struct clk_voter *v = to_clk_voter(clk);
+	return v->enabled;
+}
+
+static long voter_clk_round_rate(struct clk *clk, unsigned rate)
+{
+	struct clk_voter *v = to_clk_voter(clk);
+	return clk_round_rate(v->parent, rate);
+}
+
+static int voter_clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&voter_clk_lock, flags);
+	if (list_empty(&clk->siblings))
+		list_add(&clk->siblings, &parent->children);
+	spin_unlock_irqrestore(&voter_clk_lock, flags);
+
+	return 0;
+}
+
+static struct clk *voter_clk_get_parent(struct clk *clk)
+{
+	struct clk_voter *v = to_clk_voter(clk);
+	return v->parent;
+}
+
+static bool voter_clk_is_local(struct clk *clk)
+{
+	return true;
+}
+
+struct clk_ops clk_ops_voter = {
+	.enable = voter_clk_enable,
+	.disable = voter_clk_disable,
+	.set_rate = voter_clk_set_rate,
+	.set_min_rate = voter_clk_set_rate,
+	.get_rate = voter_clk_get_rate,
+	.is_enabled = voter_clk_is_enabled,
+	.round_rate = voter_clk_round_rate,
+	.set_parent = voter_clk_set_parent,
+	.get_parent = voter_clk_get_parent,
+	.is_local = voter_clk_is_local,
+};
diff --git a/arch/arm/mach-msm/clock-voter.h b/arch/arm/mach-msm/clock-voter.h
new file mode 100644
index 0000000..170ba67
--- /dev/null
+++ b/arch/arm/mach-msm/clock-voter.h
@@ -0,0 +1,41 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ARCH_ARM_MACH_MSM_CLOCK_VOTER_H
+#define __ARCH_ARM_MACH_MSM_CLOCK_VOTER_H
+
+struct clk_ops;
+extern struct clk_ops clk_ops_voter;
+
+struct clk_voter {
+	bool enabled;
+	unsigned rate;
+	struct clk *parent;
+	struct clk c;
+};
+
+static inline struct clk_voter *to_clk_voter(struct clk *clk)
+{
+	return container_of(clk, struct clk_voter, c);
+}
+
+#define DEFINE_CLK_VOTER(clk_name, _parent) \
+	struct clk_voter clk_name = { \
+		.parent = _parent, \
+		.c = { \
+			.dbg_name = #clk_name, \
+			.ops = &clk_ops_voter, \
+			CLK_INIT(clk_name.c), \
+		}, \
+	}
+
+#endif
diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 026bdc0..ad55eaa 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -154,12 +154,6 @@ int clk_set_flags(struct clk *clk, unsigned long flags)
 }
 EXPORT_SYMBOL(clk_set_flags);
 
-/* EBI1 is the only shared clock that several clients want to vote on as of
- * this commit. If this changes in the future, then it might be better to
- * make clk_min_rate handle the voting or make ebi1_clk_set_min_rate more
- * generic to support different clocks.
- */
-static struct clk *ebi1_clk;
 static struct clk_lookup *msm_clocks;
 static unsigned msm_num_clocks;
 
@@ -167,13 +161,13 @@ void __init msm_clock_init(struct clk_lookup *clock_tbl, size_t num_clocks)
 {
 	unsigned n;
 
-	clkdev_add_table(clock_tbl, num_clocks);
-
-	for (n = 0; n < num_clocks; n++)
-		spin_lock_init(&clock_tbl[n].clk->lock);
+	for (n = 0; n < num_clocks; n++) {
+		struct clk *clk = clock_tbl[n].clk;
+		struct clk *parent = clk_get_parent(clk);
+		clk_set_parent(clk, parent);
+	}
 
-	ebi1_clk = clk_get(NULL, "ebi1_clk");
-	BUG_ON(ebi1_clk == NULL);
+	clkdev_add_table(clock_tbl, num_clocks);
 
 	msm_clocks = clock_tbl;
 	msm_num_clocks = num_clocks;
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 6a7cbca..6aecd95 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -55,9 +55,18 @@ struct clk {
 	uint32_t flags;
 	struct clk_ops *ops;
 	const char *dbg_name;
+
+	struct list_head children;
+	struct list_head siblings;
+
 	spinlock_t lock;
 };
 
+#define CLK_INIT(name) \
+	.lock = __SPIN_LOCK_UNLOCKED((name).lock), \
+	.children = LIST_HEAD_INIT((name).children), \
+	.siblings = LIST_HEAD_INIT((name).siblings)
+
 #define OFF CLKFLAG_AUTO_OFF
 #define CLK_MIN CLKFLAG_MIN
 #define CLK_MAX CLKFLAG_MAX
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

