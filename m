Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2LZNqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 08:46:35 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1552 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab2LZNqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 08:46:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 26 Dec 2012 05:46:33 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <mturquette@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 1/2] clk: Add debug clk summary
Date: Wed, 26 Dec 2012 19:16:22 +0530
Message-ID: <1356529583-19535-1-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds debug file "clk_summary" in /sys/kernel/debug/clk dir.
It helps to view all the clock registered in human-readable format.

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
 drivers/clk/clk.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 56e4495e..d79c088 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -34,6 +34,67 @@ static struct dentry *rootdir;
 static struct dentry *orphandir;
 static int inited = 0;
 
+static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
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
+static void clk_summary_show_subtree(struct seq_file *s, struct clk *c,
+				     int level)
+{
+	struct clk *child;
+	struct hlist_node *tmp;
+
+	if (!c)
+		return;
+
+	clk_summary_show_one(s, c, level);
+
+	hlist_for_each_entry(child, tmp, &c->children, child_node)
+		clk_summary_show_subtree(s, child, level + 1);
+}
+
+static int clk_summary_show(struct seq_file *s, void *data)
+{
+	struct clk *c;
+	struct hlist_node *tmp;
+
+	seq_printf(s, "   clock                        enable_cnt  prepare_cnt  rate\n");
+	seq_printf(s, "---------------------------------------------------------------------\n");
+
+	mutex_lock(&prepare_lock);
+
+	hlist_for_each_entry(c, tmp, &clk_root_list, child_node)
+		clk_summary_show_subtree(s, c, 0);
+
+	hlist_for_each_entry(c, tmp, &clk_orphan_list, child_node)
+		clk_summary_show_subtree(s, c, 0);
+
+	mutex_unlock(&prepare_lock);
+
+	return 0;
+}
+
+
+static int clk_summary_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, clk_summary_show, inode->i_private);
+}
+
+static const struct file_operations clk_summary_fops = {
+	.open		= clk_summary_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /* caller must hold prepare_lock */
 static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
 {
@@ -167,12 +228,18 @@ static int __init clk_debug_init(void)
 {
 	struct clk *clk;
 	struct hlist_node *tmp;
+	struct dentry *d;
 
 	rootdir = debugfs_create_dir("clk", NULL);
 
 	if (!rootdir)
 		return -ENOMEM;
 
+	d = debugfs_create_file("clk_summary", S_IRUGO, rootdir, NULL,
+				&clk_summary_fops);
+	if (!d)
+		return -ENOMEM;
+
 	orphandir = debugfs_create_dir("orphans", rootdir);
 
 	if (!orphandir)
-- 
1.7.4.1

