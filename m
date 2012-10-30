Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084Ab2J3Rgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:36:52 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34309 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965003Ab2J3RcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:16 -0400
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
Subject: [PATCH tip/core/rcu 07/14] rcu: Remove the interface "rcudata.csv"
Date: Tue, 30 Oct 2012 10:05:06 -0700
Message-Id: <1351616713-26930-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
 <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7408-0000-0000-000009C5C67D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch removes the interface "rcudata.csv" since it is apparently
not used.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |   76 ------------------------------------------------
 1 files changed, 0 insertions(+), 76 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 0e2ab64..bcc4865 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -174,77 +174,6 @@ static const struct file_operations rcudata_fops = {
 	.release = seq_release,
 };
 
-static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
-{
-	if (!rdp->beenonline)
-		return;
-	seq_printf(m, "%d,%s,%lu,%lu,%d,%d",
-		   rdp->cpu,
-		   cpu_is_offline(rdp->cpu) ? "\"N\"" : "\"Y\"",
-		   rdp->completed, rdp->gpnum,
-		   rdp->passed_quiesce, rdp->qs_pending);
-	seq_printf(m, ",%d,%llx,%d,%lu",
-		   atomic_read(&rdp->dynticks->dynticks),
-		   rdp->dynticks->dynticks_nesting,
-		   rdp->dynticks->dynticks_nmi_nesting,
-		   rdp->dynticks_fqs);
-	seq_printf(m, ",%lu", rdp->offline_fqs);
-	seq_printf(m, ",%ld,%ld,\"%c%c%c%c\"", rdp->qlen_lazy, rdp->qlen,
-		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
-			rdp->nxttail[RCU_NEXT_TAIL]],
-		   ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
-			rdp->nxttail[RCU_NEXT_READY_TAIL]],
-		   ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
-			rdp->nxttail[RCU_WAIT_TAIL]],
-		   ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]]);
-#ifdef CONFIG_RCU_BOOST
-	seq_printf(m, ",%d,\"%c\"",
-		   per_cpu(rcu_cpu_has_work, rdp->cpu),
-		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
-					  rdp->cpu)));
-#endif /* #ifdef CONFIG_RCU_BOOST */
-	seq_printf(m, ",%ld", rdp->blimit);
-	seq_printf(m, ",%lu,%lu,%lu\n",
-		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
-}
-
-static int show_rcudata_csv(struct seq_file *m, void *v)
-{
-	struct rcu_data *rdp = (struct rcu_data *)v;
-	if (cpumask_first(cpu_possible_mask) == rdp->cpu) {
-		seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pq\",");
-		seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
-		seq_puts(m, "\"of\",\"qll\",\"ql\",\"qs\"");
-#ifdef CONFIG_RCU_BOOST
-		seq_puts(m, "\"kt\",\"ktl\"");
-#endif /* #ifdef CONFIG_RCU_BOOST */
-		seq_puts(m, ",\"b\",\"ci\",\"co\",\"ca\"\n");
-	}
-
-	print_one_rcu_data_csv(m, rdp);
-	return 0;
-}
-
-static const struct seq_operations rcudate_csv_op = {
-	.start = r_start,
-	.next  = r_next,
-	.stop  = r_stop,
-	.show  = show_rcudata_csv,
-};
-
-static int rcudata_csv_open(struct inode *inode, struct file *file)
-{
-	return r_open(inode, file, &rcudate_csv_op);
-}
-
-static const struct file_operations rcudata_csv_fops = {
-	.owner = THIS_MODULE,
-	.open = rcudata_csv_open,
-	.read = seq_read,
-	.llseek = no_llseek,
-	.release = seq_release,
-};
-
 #ifdef CONFIG_RCU_BOOST
 
 static void print_one_rcu_node_boost(struct seq_file *m, struct rcu_node *rnp)
@@ -496,11 +425,6 @@ static int __init rcutree_trace_init(void)
 			if (!retval)
 				goto free_out;
 
-			retval = debugfs_create_file("rcudata.csv", 0444,
-					rspdir, rsp, &rcudata_csv_fops);
-			if (!retval)
-				goto free_out;
-
 			retval = debugfs_create_file("rcu_pending", 0444,
 					rspdir, rsp, &rcu_pending_fops);
 			if (!retval)
-- 
1.7.8

