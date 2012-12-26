Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2LZNqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 08:46:43 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13311 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2LZNqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 08:46:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 26 Dec 2012 05:43:31 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <mturquette@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 2/2] clk: Add debug entry to dump clock information
Date: Wed, 26 Dec 2012 19:16:23 +0530
Message-ID: <1356529583-19535-2-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1356529583-19535-1-git-send-email-pgaikwad@nvidia.com>
References: <1356529583-19535-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock information is dumped in JSON format which is easy
for machines to parse.

Each clock is represented as an object which has same name as
clock and following properties
	- enable_count
	- prepare_count
	- rate

Output is verified using online JSON editor.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 drivers/clk/clk.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index d79c088..1cd70ec 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -95,6 +95,76 @@ static const struct file_operations clk_summary_fops = {
 	.release	= single_release,
 };
 
+static void clk_dump_one(struct seq_file *s, struct clk *c, int level)
+{
+	if (!c)
+		return;
+
+	seq_printf(s, "\"%s\": { ", c->name);
+	seq_printf(s, "\"enable_count\": %d,", c->enable_count);
+	seq_printf(s, "\"prepare_count\": %d,", c->prepare_count);
+	seq_printf(s, "\"rate\": %lu", c->rate);
+}
+
+static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
+{
+	struct clk *child;
+	struct hlist_node *tmp;
+
+	if (!c)
+		return;
+
+	clk_dump_one(s, c, level);
+
+	hlist_for_each_entry(child, tmp, &c->children, child_node) {
+		seq_printf(s, ",");
+		clk_dump_subtree(s, child, level + 1);
+	}
+
+	seq_printf(s, "}");
+}
+
+static int clk_dump(struct seq_file *s, void *data)
+{
+	struct clk *c;
+	struct hlist_node *tmp;
+	bool first_node = true;
+
+	seq_printf(s, "{");
+
+	mutex_lock(&prepare_lock);
+
+	hlist_for_each_entry(c, tmp, &clk_root_list, child_node) {
+		if (!first_node)
+			seq_printf(s, ",");
+		first_node = false;
+		clk_dump_subtree(s, c, 0);
+	}
+
+	hlist_for_each_entry(c, tmp, &clk_orphan_list, child_node) {
+		seq_printf(s, ",");
+		clk_dump_subtree(s, c, 0);
+	}
+
+	mutex_unlock(&prepare_lock);
+
+	seq_printf(s, "}");
+	return 0;
+}
+
+
+static int clk_dump_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, clk_dump, inode->i_private);
+}
+
+static const struct file_operations clk_dump_fops = {
+	.open		= clk_dump_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /* caller must hold prepare_lock */
 static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
 {
@@ -240,6 +310,11 @@ static int __init clk_debug_init(void)
 	if (!d)
 		return -ENOMEM;
 
+	d = debugfs_create_file("clk_dump", S_IRUGO, rootdir, NULL,
+				&clk_dump_fops);
+	if (!d)
+		return -ENOMEM;
+
 	orphandir = debugfs_create_dir("orphans", rootdir);
 
 	if (!orphandir)
-- 
1.7.4.1

