Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965087Ab2J3Rcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:32:47 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59887 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964953Ab2J3Rco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:44 -0400
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
Subject: [PATCH tip/core/rcu 06/14] rcu: Replace the old interface with the new one
Date: Tue, 30 Oct 2012 10:05:05 -0700
Message-Id: <1351616713-26930-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
 <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7182-0000-0000-000002FDE61E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch removed the old RCU debugfs interface and replaced it with
the new one.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |  148 ++++++++----------------------------------------
 1 files changed, 24 insertions(+), 124 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 8b24867..0e2ab64 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -148,53 +148,27 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
 
-static int show_rcudata(struct seq_file *m, void *unused)
-{
-	int cpu;
-	struct rcu_state *rsp;
-
-	for_each_rcu_flavor(rsp) {
-		seq_printf(m, "%s:\n", rsp->name);
-		for_each_possible_cpu(cpu)
-			print_one_rcu_data(m, per_cpu_ptr(rsp->rda, cpu));
-	}
-	return 0;
-}
-
-static int rcudata_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, show_rcudata, NULL);
-}
-
-static const struct file_operations rcudata_fops = {
-	.owner = THIS_MODULE,
-	.open = rcudata_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int new_show_rcudata(struct seq_file *m, void *v)
+static int show_rcudata(struct seq_file *m, void *v)
 {
 	print_one_rcu_data(m, (struct rcu_data *)v);
 	return 0;
 }
 
-static const struct seq_operations new_rcudate_op = {
+static const struct seq_operations rcudate_op = {
 	.start = r_start,
 	.next  = r_next,
 	.stop  = r_stop,
-	.show  = new_show_rcudata,
+	.show  = show_rcudata,
 };
 
-static int new_rcudata_open(struct inode *inode, struct file *file)
+static int rcudata_open(struct inode *inode, struct file *file)
 {
-	return r_open(inode, file, &new_rcudate_op);
+	return r_open(inode, file, &rcudate_op);
 }
 
-static const struct file_operations new_rcudata_fops = {
+static const struct file_operations rcudata_fops = {
 	.owner = THIS_MODULE,
-	.open = new_rcudata_open,
+	.open = rcudata_open,
 	.read = seq_read,
 	.llseek = no_llseek,
 	.release = seq_release,
@@ -234,40 +208,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
 
-static int show_rcudata_csv(struct seq_file *m, void *unused)
-{
-	int cpu;
-	struct rcu_state *rsp;
-
-	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pq\",");
-	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
-	seq_puts(m, "\"of\",\"qll\",\"ql\",\"qs\"");
-#ifdef CONFIG_RCU_BOOST
-	seq_puts(m, "\"kt\",\"ktl\"");
-#endif /* #ifdef CONFIG_RCU_BOOST */
-	seq_puts(m, ",\"b\",\"ci\",\"co\",\"ca\"\n");
-	for_each_rcu_flavor(rsp) {
-		seq_printf(m, "\"%s:\"\n", rsp->name);
-		for_each_possible_cpu(cpu)
-			print_one_rcu_data_csv(m, per_cpu_ptr(rsp->rda, cpu));
-	}
-	return 0;
-}
-
-static int rcudata_csv_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, show_rcudata_csv, NULL);
-}
-
-static const struct file_operations rcudata_csv_fops = {
-	.owner = THIS_MODULE,
-	.open = rcudata_csv_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int new_show_rcudata_csv(struct seq_file *m, void *v)
+static int show_rcudata_csv(struct seq_file *m, void *v)
 {
 	struct rcu_data *rdp = (struct rcu_data *)v;
 	if (cpumask_first(cpu_possible_mask) == rdp->cpu) {
@@ -284,21 +225,21 @@ static int new_show_rcudata_csv(struct seq_file *m, void *v)
 	return 0;
 }
 
-static const struct seq_operations new_rcudate_csv_op = {
+static const struct seq_operations rcudate_csv_op = {
 	.start = r_start,
 	.next  = r_next,
 	.stop  = r_stop,
-	.show  = new_show_rcudata_csv,
+	.show  = show_rcudata_csv,
 };
 
-static int new_rcudata_csv_open(struct inode *inode, struct file *file)
+static int rcudata_csv_open(struct inode *inode, struct file *file)
 {
-	return r_open(inode, file, &new_rcudate_csv_op);
+	return r_open(inode, file, &rcudate_csv_op);
 }
 
-static const struct file_operations new_rcudata_csv_fops = {
+static const struct file_operations rcudata_csv_fops = {
 	.owner = THIS_MODULE,
-	.open = new_rcudata_csv_open,
+	.open = rcudata_csv_open,
 	.read = seq_read,
 	.llseek = no_llseek,
 	.release = seq_release,
@@ -484,53 +425,27 @@ static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->n_rp_need_nothing);
 }
 
-static int show_rcu_pending(struct seq_file *m, void *unused)
-{
-	int cpu;
-	struct rcu_state *rsp;
-
-	for_each_rcu_flavor(rsp) {
-		seq_printf(m, "%s:\n", rsp->name);
-		for_each_possible_cpu(cpu)
-			print_one_rcu_pending(m, per_cpu_ptr(rsp->rda, cpu));
-	}
-	return 0;
-}
-
-static int rcu_pending_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, show_rcu_pending, NULL);
-}
-
-static const struct file_operations rcu_pending_fops = {
-	.owner = THIS_MODULE,
-	.open = rcu_pending_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int new_show_rcu_pending(struct seq_file *m, void *v)
+static int show_rcu_pending(struct seq_file *m, void *v)
 {
 	print_one_rcu_pending(m, (struct rcu_data *)v);
 	return 0;
 }
 
-static const struct seq_operations new_rcu_pending_op = {
+static const struct seq_operations rcu_pending_op = {
 	.start = r_start,
 	.next  = r_next,
 	.stop  = r_stop,
-	.show  = new_show_rcu_pending,
+	.show  = show_rcu_pending,
 };
 
-static int new_rcu_pending_open(struct inode *inode, struct file *file)
+static int rcu_pending_open(struct inode *inode, struct file *file)
 {
-	return r_open(inode, file, &new_rcu_pending_op);
+	return r_open(inode, file, &rcu_pending_op);
 }
 
-static const struct file_operations new_rcu_pending_fops = {
+static const struct file_operations rcu_pending_fops = {
 	.owner = THIS_MODULE,
-	.open = new_rcu_pending_open,
+	.open = rcu_pending_open,
 	.read = seq_read,
 	.llseek = no_llseek,
 	.release = seq_release,
@@ -577,17 +492,17 @@ static int __init rcutree_trace_init(void)
 			goto free_out;
 
 			retval = debugfs_create_file("rcudata", 0444,
-					rspdir, rsp, &new_rcudata_fops);
+					rspdir, rsp, &rcudata_fops);
 			if (!retval)
 				goto free_out;
 
 			retval = debugfs_create_file("rcudata.csv", 0444,
-					rspdir, rsp, &new_rcudata_csv_fops);
+					rspdir, rsp, &rcudata_csv_fops);
 			if (!retval)
 				goto free_out;
 
 			retval = debugfs_create_file("rcu_pending", 0444,
-					rspdir, rsp, &new_rcu_pending_fops);
+					rspdir, rsp, &rcu_pending_fops);
 			if (!retval)
 				goto free_out;
 	}
@@ -597,16 +512,6 @@ static int __init rcutree_trace_init(void)
 	if (!retval)
 		goto free_out;
 
-	retval = debugfs_create_file("rcudata", 0444, rcudir,
-						NULL, &rcudata_fops);
-	if (!retval)
-		goto free_out;
-
-	retval = debugfs_create_file("rcudata.csv", 0444, rcudir,
-						NULL, &rcudata_csv_fops);
-	if (!retval)
-		goto free_out;
-
 	if (rcu_boost_trace_create_file(rcudir))
 		goto free_out;
 
@@ -619,11 +524,6 @@ static int __init rcutree_trace_init(void)
 	if (!retval)
 		goto free_out;
 
-	retval = debugfs_create_file("rcu_pending", 0444, rcudir,
-						NULL, &rcu_pending_fops);
-	if (!retval)
-		goto free_out;
-
 	retval = debugfs_create_file("rcutorture", 0444, rcudir,
 						NULL, &rcutorture_fops);
 	if (!retval)
-- 
1.7.8

