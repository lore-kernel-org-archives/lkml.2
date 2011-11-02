Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767Ab1KBSls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:41:48 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18109 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933357Ab1KBShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706995"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Matt Wagantall <mattw@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [RFC PATCH 20/34] msm: clock: Add list_rate debugfs nodes for locally-controlled clocks
Date: Wed,  2 Nov 2011 11:36:17 -0700
Message-Id: <1320258991-22325-21-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Wagantall <mattw@codeaurora.org>

Add debugfs nodes to list all of the supported rates for rate-settable
locally-controlled clocks. This allows a clock's supported rates to
be queried from userspace, and allows more comprehensive userspace
clock tests to be developed.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-7x30.c  |    1 +
 arch/arm/mach-msm/clock-8x60.c  |    1 +
 arch/arm/mach-msm/clock-debug.c |   30 ++++++++++++++++++++++++++++++
 arch/arm/mach-msm/clock-local.c |   11 +++++++++++
 arch/arm/mach-msm/clock.h       |    1 +
 5 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/clock-7x30.c b/arch/arm/mach-msm/clock-7x30.c
index 306a64f..5b796e8 100644
--- a/arch/arm/mach-msm/clock-7x30.c
+++ b/arch/arm/mach-msm/clock-7x30.c
@@ -2763,6 +2763,7 @@ static struct clk_ops soc_clk_ops_7x30 = {
 	.set_min_rate = rcg_clk_set_min_rate,
 	.set_max_rate = rcg_clk_set_max_rate,
 	.get_rate = rcg_clk_get_rate,
+	.list_rate = rcg_clk_list_rate,
 	.is_enabled = rcg_clk_is_enabled,
 	.round_rate = rcg_clk_round_rate,
 	.reset = msm7x30_clk_reset,
diff --git a/arch/arm/mach-msm/clock-8x60.c b/arch/arm/mach-msm/clock-8x60.c
index 6fdf4de..170797a 100644
--- a/arch/arm/mach-msm/clock-8x60.c
+++ b/arch/arm/mach-msm/clock-8x60.c
@@ -462,6 +462,7 @@ static struct clk_ops soc_clk_ops_8x60 = {
 	.set_min_rate = rcg_clk_set_min_rate,
 	.set_max_rate = rcg_clk_set_max_rate,
 	.get_rate = rcg_clk_get_rate,
+	.list_rate = rcg_clk_list_rate,
 	.is_enabled = rcg_clk_is_enabled,
 	.round_rate = rcg_clk_round_rate,
 	.reset = soc_clk_reset,
diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
index 472a735..78b7b6c 100644
--- a/arch/arm/mach-msm/clock-debug.c
+++ b/arch/arm/mach-msm/clock-debug.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
+#include <linux/seq_file.h>
 #include <linux/clk.h>
 #include "clock.h"
 
@@ -101,6 +102,29 @@ int __init clock_debug_init(void)
 	return 0;
 }
 
+static int list_rates_show(struct seq_file *m, void *unused)
+{
+	struct clk *clock = m->private;
+	int rate, i = 0;
+
+	while ((rate = clock->ops->list_rate(clock, i++)) >= 0)
+		seq_printf(m, "%d\n", rate);
+
+	return 0;
+}
+
+static int list_rates_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, list_rates_show, inode->i_private);
+}
+
+static const struct file_operations list_rates_fops = {
+	.open		= list_rates_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 int __init clock_debug_add(struct clk *clock)
 {
 	char temp[50], *ptr;
@@ -128,6 +152,12 @@ int __init clock_debug_add(struct clk *clock)
 	if (!debugfs_create_file("is_local", S_IRUGO, clk_dir, clock,
 				&clock_local_fops))
 		goto error;
+
+	if (clock->ops->list_rate)
+		if (!debugfs_create_file("list_rates",
+				S_IRUGO, clk_dir, clock, &list_rates_fops))
+			goto error;
+
 	return 0;
 error:
 	debugfs_remove_recursive(clk_dir);
diff --git a/arch/arm/mach-msm/clock-local.c b/arch/arm/mach-msm/clock-local.c
index 3ee318d..c79895c 100644
--- a/arch/arm/mach-msm/clock-local.c
+++ b/arch/arm/mach-msm/clock-local.c
@@ -701,6 +701,17 @@ bool local_clk_is_local(struct clk *clk)
 	return true;
 }
 
+/* Return the nth supported frequency for a given clock. */
+int rcg_clk_list_rate(struct clk *c, unsigned n)
+{
+	struct rcg_clk *clk = to_rcg_clk(c);
+
+	if (!clk->freq_tbl || clk->freq_tbl->freq_hz == FREQ_END)
+		return -ENXIO;
+
+	return (clk->freq_tbl + n)->freq_hz;
+}
+
 struct clk *rcg_clk_get_parent(struct clk *clk)
 {
 	return to_rcg_clk(clk)->current_freq->src_clk;
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index 8ae86ce..26b52f2 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -42,6 +42,7 @@ struct clk_ops {
 	int (*set_max_rate)(struct clk *clk, unsigned rate);
 	int (*set_flags)(struct clk *clk, unsigned flags);
 	unsigned (*get_rate)(struct clk *clk);
+	int (*list_rate)(struct clk *clk, unsigned n);
 	unsigned (*is_enabled)(struct clk *clk);
 	long (*round_rate)(struct clk *clk, unsigned rate);
 	int (*set_parent)(struct clk *clk, struct clk *parent);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

