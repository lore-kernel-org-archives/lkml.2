Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0LQAxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:53:08 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29783 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab0LQAuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67160031"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Matt Wagantall <mattw@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 12/22] msm: clock: Add list_rate debugfs nodes for locally-controlled clocks
Date: Thu, 16 Dec 2010 16:49:56 -0800
Message-Id: <1292547006-19741-13-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
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
---
 arch/arm/mach-msm/clock-7x30.c  |    1 +
 arch/arm/mach-msm/clock-8x60.c  |    1 +
 arch/arm/mach-msm/clock-debug.c |   31 +++++++++++++++++++++++++++++++
 arch/arm/mach-msm/clock-local.c |   11 +++++++++++
 arch/arm/mach-msm/clock-local.h |    1 +
 arch/arm/mach-msm/clock.h       |    1 +
 6 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/clock-7x30.c b/arch/arm/mach-msm/clock-7x30.c
index e13de24..9e73d8a 100644
--- a/arch/arm/mach-msm/clock-7x30.c
+++ b/arch/arm/mach-msm/clock-7x30.c
@@ -1156,6 +1156,7 @@ struct clk_ops soc_clk_ops_7x30 = {
 	.set_min_rate = local_clk_set_min_rate,
 	.set_max_rate = local_clk_set_max_rate,
 	.get_rate = local_clk_get_rate,
+	.list_rate = local_clk_list_rate,
 	.is_enabled = local_clk_is_enabled,
 	.round_rate = local_clk_round_rate,
 	.reset = pc_clk_reset,
diff --git a/arch/arm/mach-msm/clock-8x60.c b/arch/arm/mach-msm/clock-8x60.c
index 6972001..28017b7 100644
--- a/arch/arm/mach-msm/clock-8x60.c
+++ b/arch/arm/mach-msm/clock-8x60.c
@@ -1895,6 +1895,7 @@ struct clk_ops soc_clk_ops_8x60 = {
 	.set_min_rate = local_clk_set_min_rate,
 	.set_max_rate = local_clk_set_max_rate,
 	.get_rate = local_clk_get_rate,
+	.list_rate = local_clk_list_rate,
 	.is_enabled = local_clk_is_enabled,
 	.round_rate = local_clk_round_rate,
 	.reset = soc_clk_reset,
diff --git a/arch/arm/mach-msm/clock-debug.c b/arch/arm/mach-msm/clock-debug.c
index 73ef9cc..354bc1e 100644
--- a/arch/arm/mach-msm/clock-debug.c
+++ b/arch/arm/mach-msm/clock-debug.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
+#include <linux/seq_file.h>
 #include <linux/clk.h>
 #include "clock.h"
 
@@ -106,6 +107,32 @@ int __init clock_debug_init(void)
 	return 0;
 }
 
+static int list_rates_show(struct seq_file *m, void *unused)
+{
+	struct clk *clock = m->private;
+	int rate, i = 0;
+
+	if (clock->ops->list_rate == NULL)
+		return -EINVAL;
+
+	while ((rate = clock->ops->list_rate(clock->id, i++)) >= 0)
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
@@ -138,6 +165,10 @@ int __init clock_debug_add(struct clk *clock)
 				clock, &clock_measure_fops))
 		goto error;
 
+	if (!debugfs_create_file("list_rates", S_IRUGO, clk_dir,
+				clock, &list_rates_fops))
+		goto error;
+
 	return 0;
 error:
 	debugfs_remove_recursive(clk_dir);
diff --git a/arch/arm/mach-msm/clock-local.c b/arch/arm/mach-msm/clock-local.c
index 44e0778..f80efa6 100644
--- a/arch/arm/mach-msm/clock-local.c
+++ b/arch/arm/mach-msm/clock-local.c
@@ -682,3 +682,14 @@ bool local_clk_is_local(unsigned id)
 {
 	return true;
 }
+
+/* Return the nth supported frequency for a given clock. */
+int local_clk_list_rate(unsigned id, unsigned n)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+
+	if (!clk->freq_tbl || clk->freq_tbl->freq_hz == FREQ_END)
+		return -ENXIO;
+
+	return (clk->freq_tbl + n)->freq_hz;
+}
diff --git a/arch/arm/mach-msm/clock-local.h b/arch/arm/mach-msm/clock-local.h
index 3083369..cf97219 100644
--- a/arch/arm/mach-msm/clock-local.h
+++ b/arch/arm/mach-msm/clock-local.h
@@ -209,6 +209,7 @@ int local_clk_set_rate(unsigned id, unsigned rate);
 int local_clk_set_min_rate(unsigned id, unsigned rate);
 int local_clk_set_max_rate(unsigned id, unsigned rate);
 unsigned local_clk_get_rate(unsigned id);
+int local_clk_list_rate(unsigned id, unsigned n);
 unsigned local_clk_is_enabled(unsigned id);
 long local_clk_round_rate(unsigned id, unsigned rate);
 bool local_clk_is_local(unsigned id);
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index f09e01b..67f9d9e 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -41,6 +41,7 @@ struct clk_ops {
 	int (*set_max_rate)(unsigned id, unsigned rate);
 	int (*set_flags)(unsigned id, unsigned flags);
 	unsigned (*get_rate)(unsigned id);
+	int (*list_rate)(unsigned id, unsigned n);
 	int (*measure_rate)(unsigned id);
 	unsigned (*is_enabled)(unsigned id);
 	long (*round_rate)(unsigned id, unsigned rate);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

