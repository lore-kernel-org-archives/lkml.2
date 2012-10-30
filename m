Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965139Ab2J3Rd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:33:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56311 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958Ab2J3Rcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:45 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/14] rcu: Remove old debugfs interfaces and also RCU flavor name
Date: Tue, 30 Oct 2012 10:05:12 -0700
Message-Id: <1351616713-26930-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
 <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-9360-0000-0000-00000C370009
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This commit removes the old debugfs interfaces, so that the new
directory-per-RCU-flavor versions remain.  Because the RCU flavor is
given by the directory name, there is no need to print it out, so remove
the name from the printout.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |  190 +++++++++++-------------------------------------
 1 files changed, 44 insertions(+), 146 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index db46464..c6f9cb3 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -76,32 +76,7 @@ static void r_stop(struct seq_file *m, void *v)
 {
 }
 
-static int show_rcubarrier(struct seq_file *m, void *unused)
-{
-	struct rcu_state *rsp;
-
-	for_each_rcu_flavor(rsp)
-		seq_printf(m, "%s: bcc: %d nbd: %lu\n",
-			   rsp->name,
-			   atomic_read(&rsp->barrier_cpu_count),
-			   rsp->n_barrier_done);
-	return 0;
-}
-
-static int rcubarrier_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, show_rcubarrier, NULL);
-}
-
-static const struct file_operations rcubarrier_fops = {
-	.owner = THIS_MODULE,
-	.open = rcubarrier_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int new_show_rcubarrier(struct seq_file *m, void *v)
+static int show_rcubarrier(struct seq_file *m, void *v)
 {
 	struct rcu_state *rsp = (struct rcu_state *)m->private;
 	seq_printf(m, "bcc: %d nbd: %lu\n",
@@ -110,14 +85,14 @@ static int new_show_rcubarrier(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int new_rcubarrier_open(struct inode *inode, struct file *file)
+static int rcubarrier_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, new_show_rcubarrier, inode->i_private);
+	return single_open(file, show_rcubarrier, inode->i_private);
 }
 
-static const struct file_operations new_rcubarrier_fops = {
+static const struct file_operations rcubarrier_fops = {
 	.owner = THIS_MODULE,
-	.open = new_rcubarrier_open,
+	.open = rcubarrier_open,
 	.read = seq_read,
 	.llseek = no_llseek,
 	.release = seq_release,
@@ -243,23 +218,7 @@ static const struct file_operations rcu_node_boost_fops = {
 	.release = single_release,
 };
 
-/*
- * Create the rcuboost debugfs entry.  Standard error return.
- */
-static int rcu_boost_trace_create_file(struct dentry *rcudir)
-{
-	return !debugfs_create_file("rcuboost", 0444, rcudir, NULL,
-				    &rcu_node_boost_fops);
-}
-
-#else /* #ifdef CONFIG_RCU_BOOST */
-
-static int rcu_boost_trace_create_file(struct dentry *rcudir)
-{
-	return 0;  /* There cannot be an error if we didn't create it! */
-}
-
-#endif /* #else #ifdef CONFIG_RCU_BOOST */
+#endif /* #ifdef CONFIG_RCU_BOOST */
 
 static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 {
@@ -268,8 +227,8 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 	struct rcu_node *rnp;
 
 	gpnum = rsp->gpnum;
-	seq_printf(m, "%s: c=%lu g=%lu s=%d jfq=%ld j=%x ",
-		   rsp->name, rsp->completed, gpnum, rsp->fqs_state,
+	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x ",
+		   rsp->completed, gpnum, rsp->fqs_state,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff));
 	seq_printf(m, "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld/%ld\n",
@@ -291,44 +250,22 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 	seq_puts(m, "\n");
 }
 
-static int show_rcuhier(struct seq_file *m, void *unused)
+static int show_rcuhier(struct seq_file *m, void *v)
 {
-	struct rcu_state *rsp;
-
-	for_each_rcu_flavor(rsp)
-		print_one_rcu_state(m, rsp);
+	struct rcu_state *rsp = (struct rcu_state *)m->private;
+	print_one_rcu_state(m, rsp);
 	return 0;
 }
 
 static int rcuhier_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, show_rcuhier, NULL);
+	return single_open(file, show_rcuhier, inode->i_private);
 }
 
 static const struct file_operations rcuhier_fops = {
 	.owner = THIS_MODULE,
 	.open = rcuhier_open,
 	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int new_show_rcuhier(struct seq_file *m, void *v)
-{
-	struct rcu_state *rsp = (struct rcu_state *)m->private;
-	print_one_rcu_state(m, rsp);
-	return 0;
-}
-
-static int new_rcuhier_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, new_show_rcuhier, inode->i_private);
-}
-
-static const struct file_operations new_rcuhier_fops = {
-	.owner = THIS_MODULE,
-	.open = new_rcuhier_open,
-	.read = seq_read,
 	.llseek = no_llseek,
 	.release = seq_release,
 };
@@ -351,48 +288,26 @@ static void show_one_rcugp(struct seq_file *m, struct rcu_state *rsp)
 		gpage = jiffies - rsp->gp_start;
 	gpmax = rsp->gp_max;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	seq_printf(m, "%s: completed=%lu  gpnum=%lu  age=%ld  max=%ld\n",
-		   rsp->name, completed, gpnum, gpage, gpmax);
+	seq_printf(m, "completed=%lu  gpnum=%lu  age=%ld  max=%ld\n",
+		   completed, gpnum, gpage, gpmax);
 }
 
-static int show_rcugp(struct seq_file *m, void *unused)
+static int show_rcugp(struct seq_file *m, void *v)
 {
-	struct rcu_state *rsp;
-
-	for_each_rcu_flavor(rsp)
-		show_one_rcugp(m, rsp);
+	struct rcu_state *rsp = (struct rcu_state *)m->private;
+	show_one_rcugp(m, rsp);
 	return 0;
 }
 
 static int rcugp_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, show_rcugp, NULL);
+	return single_open(file, show_rcugp, inode->i_private);
 }
 
 static const struct file_operations rcugp_fops = {
 	.owner = THIS_MODULE,
 	.open = rcugp_open,
 	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int new_show_rcugp(struct seq_file *m, void *v)
-{
-	struct rcu_state *rsp = (struct rcu_state *)m->private;
-	show_one_rcugp(m, rsp);
-	return 0;
-}
-
-static int new_rcugp_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, new_show_rcugp, inode->i_private);
-}
-
-static const struct file_operations new_rcugp_fops = {
-	.owner = THIS_MODULE,
-	.open = new_rcugp_open,
-	.read = seq_read,
 	.llseek = no_llseek,
 	.release = seq_release,
 };
@@ -482,57 +397,40 @@ static int __init rcutree_trace_init(void)
 		if (!rspdir)
 			goto free_out;
 
-			retval = debugfs_create_file("rcudata", 0444,
-					rspdir, rsp, &rcudata_fops);
-			if (!retval)
-				goto free_out;
+		retval = debugfs_create_file("rcudata", 0444,
+				rspdir, rsp, &rcudata_fops);
+		if (!retval)
+			goto free_out;
 
-			retval = debugfs_create_file("rcu_pending", 0444,
-					rspdir, rsp, &rcu_pending_fops);
-			if (!retval)
-				goto free_out;
+		retval = debugfs_create_file("rcu_pending", 0444,
+				rspdir, rsp, &rcu_pending_fops);
+		if (!retval)
+			goto free_out;
 
-			retval = debugfs_create_file("rcubarrier", 0444,
-					rspdir, rsp, &new_rcubarrier_fops);
-			if (!retval)
-				goto free_out;
+		retval = debugfs_create_file("rcubarrier", 0444,
+				rspdir, rsp, &rcubarrier_fops);
+		if (!retval)
+			goto free_out;
 
 #ifdef CONFIG_RCU_BOOST
-			if (rsp == &rcu_preempt_state) {
-				retval = debugfs_create_file("rcuboost", 0444,
-					rspdir, NULL, &rcu_node_boost_fops);
-				if (!retval)
-					goto free_out;
-			}
-#endif
-
-			retval = debugfs_create_file("rcugp", 0444,
-					rspdir, rsp, &new_rcugp_fops);
+		if (rsp == &rcu_preempt_state) {
+			retval = debugfs_create_file("rcuboost", 0444,
+				rspdir, NULL, &rcu_node_boost_fops);
 			if (!retval)
 				goto free_out;
+		}
+#endif
 
-			retval = debugfs_create_file("rcuhier", 0444,
-					rspdir, rsp, &new_rcuhier_fops);
-			if (!retval)
-				goto free_out;
-	}
-
-	retval = debugfs_create_file("rcubarrier", 0444, rcudir,
-						NULL, &rcubarrier_fops);
-	if (!retval)
-		goto free_out;
-
-	if (rcu_boost_trace_create_file(rcudir))
-		goto free_out;
-
-	retval = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
-	if (!retval)
-		goto free_out;
+		retval = debugfs_create_file("rcugp", 0444,
+				rspdir, rsp, &rcugp_fops);
+		if (!retval)
+			goto free_out;
 
-	retval = debugfs_create_file("rcuhier", 0444, rcudir,
-						NULL, &rcuhier_fops);
-	if (!retval)
-		goto free_out;
+		retval = debugfs_create_file("rcuhier", 0444,
+				rspdir, rsp, &rcuhier_fops);
+		if (!retval)
+			goto free_out;
+	}
 
 	retval = debugfs_create_file("rcutorture", 0444, rcudir,
 						NULL, &rcutorture_fops);
-- 
1.7.8

