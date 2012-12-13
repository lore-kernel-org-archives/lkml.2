Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2LMDuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 22:50:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1130 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2LMDuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 22:50:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 12 Dec 2012 19:50:05 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <mturquette@linaro.org>, <swarren@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH] clk: debug clock tree
Date: Thu, 13 Dec 2012 09:19:46 +0530
Message-ID: <1355370586-6600-1-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds debug file "clock_tree" in /sys/kernel/debug/clk dir.
It helps to view all the clock registered in tree format.

For example:
   clock                        enable_cnt  prepare_cnt  rate
---------------------------------------------------------------------
 i2s0_sync                      0           0            24000000
 spdif_in_sync                  0           0            24000000
    spdif_mux                   0           0            24000000
       spdif                    0           0            24000000
          spdif_doubler         0           0            48000000
             spdif_div          0           0            48000000
                spdif_2x        0           0            48000000
 clk_32k                        2           2            32768
    blink_override              1           1            32768
       blink                    1           1            32768
 clk_m                          2           2            12000000
    clk_out_3_mux               0           0            12000000
       clk_out_3                0           0            12000000
    pll_ref                     3           3            12000000
       pll_e_mux                0           0            12000000
          pll_e                 0           0            100000000
             cml0               0           0            100000000
             cml1               0           0            100000000
             pciex              0           0            100000000
       pll_d2                   0           0            1000000
          pll_d2_out0           0           0            500000
       pll_d                    0           0            1000000
          pll_d_out0            0           0            500000
             dsib_mux           0           0            500000
                dsib            0           0            500000
             dsia               0           0            500000

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 drivers/clk/clk.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 56e4495e..7daf201 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -34,6 +34,59 @@ static struct dentry *rootdir;
 static struct dentry *orphandir;
 static int inited = 0;
 
+static void clk_tree_show_one(struct seq_file *s, struct clk *c, int level)
+{
+	if (!c)
+		return;
+
+	seq_printf(s, "%*s%-*s %-11d %-12d %-10lu",
+		   level * 3 + 1, "",
+		   30 - level * 3, c->name,
+		   c->enable_count, c->prepare_count, c->rate);
+	seq_printf(s, "\n");
+}
+
+static void clk_tree_show_subtree(struct seq_file *s, struct clk *c, int level)
+{
+	struct clk *child;
+	struct hlist_node *tmp;
+
+	if (!c)
+		return;
+
+	clk_tree_show_one(s, c, level);
+
+	hlist_for_each_entry(child, tmp, &c->children, child_node)
+		clk_tree_show_subtree(s, child, level + 1);
+}
+
+static int clk_tree_show(struct seq_file *s, void *data)
+{
+	struct clk *c;
+	struct hlist_node *tmp;
+
+	seq_printf(s, "   clock                        enable_cnt  prepare_cnt  rate\n");
+	seq_printf(s, "---------------------------------------------------------------------\n");
+
+	hlist_for_each_entry(c, tmp, &clk_root_list, child_node)
+		clk_tree_show_subtree(s, c, 0);
+
+	return 0;
+}
+
+
+static int clk_tree_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, clk_tree_show, inode->i_private);
+}
+
+static const struct file_operations clk_tree_fops = {
+	.open		= clk_tree_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /* caller must hold prepare_lock */
 static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
 {
@@ -167,12 +220,18 @@ static int __init clk_debug_init(void)
 {
 	struct clk *clk;
 	struct hlist_node *tmp;
+	struct dentry *d;
 
 	rootdir = debugfs_create_dir("clk", NULL);
 
 	if (!rootdir)
 		return -ENOMEM;
 
+	d = debugfs_create_file("clock_tree", S_IRUGO, rootdir, NULL,
+				&clk_tree_fops);
+	if (!d)
+		return -ENOMEM;
+
 	orphandir = debugfs_create_dir("orphans", rootdir);
 
 	if (!orphandir)
-- 
1.7.4.1

