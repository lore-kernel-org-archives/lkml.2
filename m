Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab0LQAv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:51:57 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29788 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab0LQAuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67160038"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 16/22] msm: clock: Implement rate voting
Date: Thu, 16 Dec 2010 16:50:00 -0800
Message-Id: <1292547006-19741-17-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some clocks have multiple consumers where each consumer requires
a minimum rate. Implement a sub driver to aggregate
clk_set_rate() calls from each consumer and call clk_set_rate()
on the parent clock when the minimum requested rate of all the
voters changes.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Makefile      |    2 +-
 arch/arm/mach-msm/clock-voter.c |  202 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/clock-voter.h |   52 ++++++++++
 arch/arm/mach-msm/clock.h       |    3 +
 4 files changed, 258 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-msm/clock-voter.c
 create mode 100644 arch/arm/mach-msm/clock-voter.h

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index fb44992..56651b4 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -1,5 +1,5 @@
 obj-y += io.o idle.o timer.o
-obj-y += clock.o
+obj-y += clock.o clock-voter.o
 obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 obj-$(CONFIG_ARCH_MSM7X30) += clock-local.o
 obj-$(CONFIG_ARCH_MSM8X60) += clock-local.o
diff --git a/arch/arm/mach-msm/clock-voter.c b/arch/arm/mach-msm/clock-voter.c
new file mode 100644
index 0000000..a0f94f8
--- /dev/null
+++ b/arch/arm/mach-msm/clock-voter.c
@@ -0,0 +1,202 @@
+/*
+ * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/spinlock.h>
+#include <linux/clk.h>
+
+#include "clock.h"
+#include "clock-voter.h"
+
+struct clk_voter {
+	unsigned count;
+	unsigned rate;
+	struct hlist_node voter_list;
+	struct clk *aggregator_clk;
+};
+
+static struct clk_voter voter_clocks[V_NR_CLKS];
+
+static DEFINE_SPINLOCK(voter_clk_lock);
+
+/* Aggregate the rate of clocks that are currently on. */
+static unsigned voter_clk_aggregate_rate(const struct clk *parent)
+{
+	struct hlist_node *pos;
+	struct clk_voter *clkh;
+	unsigned rate = 0;
+
+	hlist_for_each_entry(clkh, pos, &parent->voters, voter_list)
+		if (clkh->count)
+			rate = max(clkh->rate, rate);
+	return rate;
+}
+
+static int voter_clk_set_rate(unsigned id, unsigned rate)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct hlist_node *pos;
+	struct clk_voter *clkh;
+	struct clk_voter *clk = &voter_clocks[id];
+	unsigned other_rate = 0;
+	unsigned cur_rate, new_rate;
+
+	spin_lock_irqsave(&voter_clk_lock, flags);
+
+	if (clk->count) {
+		struct clk *parent = clk->aggregator_clk;
+
+		/*
+		 * Get the aggregate rate without this clock's vote and update
+		 * if the new rate is different than the current rate
+		 */
+		hlist_for_each_entry(clkh, pos, &parent->voters, voter_list)
+			if (clkh->count && clkh != clk)
+				other_rate = max(clkh->rate, other_rate);
+
+		cur_rate = max(other_rate, clk->rate);
+		new_rate = max(other_rate, rate);
+
+		if (new_rate != cur_rate) {
+			ret = clk_set_min_rate(parent, new_rate);
+			if (ret)
+				goto unlock;
+		}
+	}
+	clk->rate = rate;
+unlock:
+	spin_unlock_irqrestore(&voter_clk_lock, flags);
+
+	return ret;
+}
+
+static int voter_clk_enable(unsigned id)
+{
+	int ret = 0;
+	unsigned long flags;
+	unsigned cur_rate;
+	struct clk_voter *clk = &voter_clocks[id];
+
+	spin_lock_irqsave(&voter_clk_lock, flags);
+	if (clk->count == 0) {
+		struct clk *parent = clk->aggregator_clk;
+
+		/*
+		 * Increase the rate if this clock is voting for a higher rate
+		 * than the current rate.
+		 */
+		cur_rate = voter_clk_aggregate_rate(parent);
+		if (clk->rate > cur_rate) {
+			ret = clk_set_min_rate(parent, clk->rate);
+			if (ret)
+				goto out;
+		}
+		ret = clk_enable(parent);
+		if (ret)
+			goto out;
+	}
+	clk->count++;
+out:
+	spin_unlock_irqrestore(&voter_clk_lock, flags);
+
+	return ret;
+}
+
+static void voter_clk_disable(unsigned id)
+{
+	unsigned long flags;
+	struct clk_voter *clk = &voter_clocks[id];
+	unsigned cur_rate, new_rate;
+
+	spin_lock_irqsave(&voter_clk_lock, flags);
+	if (WARN_ON(clk->count == 0))
+		goto out;
+	clk->count--;
+	if (clk->count == 0) {
+		struct clk *parent = clk->aggregator_clk;
+
+		/*
+		 * Decrease the rate if this clock was the only one voting for
+		 * the highest rate.
+		 */
+		new_rate = voter_clk_aggregate_rate(parent);
+		cur_rate = max(new_rate, clk->rate);
+
+		if (new_rate < cur_rate)
+			clk_set_min_rate(parent, new_rate);
+
+		clk_disable(clk->aggregator_clk);
+	}
+out:
+	spin_unlock_irqrestore(&voter_clk_lock, flags);
+}
+
+static unsigned voter_clk_get_rate(unsigned id)
+{
+	unsigned rate;
+	unsigned long flags;
+	struct clk_voter *clk = &voter_clocks[id];
+
+	spin_lock_irqsave(&voter_clk_lock, flags);
+	rate = clk->rate;
+	spin_unlock_irqrestore(&voter_clk_lock, flags);
+
+	return rate;
+}
+
+static unsigned voter_clk_is_enabled(unsigned id)
+{
+	struct clk_voter *clk = &voter_clocks[id];
+	return clk->count;
+}
+
+static long voter_clk_round_rate(unsigned id, unsigned rate)
+{
+	struct clk_voter *clk = &voter_clocks[id];
+	return clk_round_rate(clk->aggregator_clk, rate);
+}
+
+static int voter_clk_set_parent(unsigned id, struct clk *parent)
+{
+	unsigned long flags;
+	struct clk_voter *clk = &voter_clocks[id];
+
+	spin_lock_irqsave(&voter_clk_lock, flags);
+	clk->aggregator_clk = parent;
+	hlist_add_head(&clk->voter_list, &parent->voters);
+	spin_unlock_irqrestore(&voter_clk_lock, flags);
+
+	return 0;
+}
+
+static bool voter_clk_is_local(unsigned id)
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
+	.is_local = voter_clk_is_local,
+};
diff --git a/arch/arm/mach-msm/clock-voter.h b/arch/arm/mach-msm/clock-voter.h
new file mode 100644
index 0000000..84bc0b3
--- /dev/null
+++ b/arch/arm/mach-msm/clock-voter.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef __ARCH_ARM_MACH_MSM_CLOCK_VOTER_H
+#define __ARCH_ARM_MACH_MSM_CLOCK_VOTER_H
+
+enum {
+	V_EBI_ACPU,
+	V_EBI_DSI,
+	V_EBI_DTV,
+	V_EBI_KGSL,
+	V_EBI_LCDC,
+	V_EBI_MDDI,
+	V_EBI_MDP,
+	V_EBI_PM,
+	V_EBI_TV,
+	V_EBI_USB,
+	V_EBI_VCD,
+	V_EBI_VFE,
+
+	V_NR_CLKS
+};
+
+struct clk_ops;
+extern struct clk_ops clk_ops_voter;
+
+#define CLK_VOTER(clk_name, clk_id, agg_name, clk_dev, clk_flags) {	\
+	.name = clk_name, \
+	.id = V_##clk_id, \
+	.flags = clk_flags | CLKFLAG_HANDLE, \
+	.dev = clk_dev, \
+	.aggregator = agg_name, \
+	.dbg_name = clk_name, \
+	.ops = &clk_ops_voter, \
+	}
+
+#endif
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 1a9fb72..9278c03 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -25,6 +25,7 @@
 #define CLKFLAG_NOINVERT		0x00000002
 #define CLKFLAG_NONEST			0x00000004
 #define CLKFLAG_NORESET			0x00000008
+#define CLKFLAG_HANDLE			0x00000010
 
 #define CLK_FIRST_AVAILABLE_FLAG	0x00000100
 #define CLKFLAG_AUTO_OFF		0x00000200
@@ -58,6 +59,8 @@ struct clk {
 	const char *dbg_name;
 	struct list_head list;
 	struct device *dev;
+	struct hlist_head voters;
+	const char *aggregator;
 };
 
 #define OFF CLKFLAG_AUTO_OFF
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

