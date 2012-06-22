Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab2FVPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:25:29 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:40983 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762394Ab2FVPZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:25:15 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 16/22] rcu: Use for_each_rcu_flavor() in TREE_RCU tracing
Date: Fri, 22 Jun 2012 08:17:15 -0700
Message-Id: <1340378241-6458-16-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622151655.GA6249@linux.vnet.ibm.com>
 <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-7408-0000-0000-0000061D45AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit applies the new for_each_rcu_flavor() macro to the
kernel/rcutree_trace.c file.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |  116 ++++++++++++++++++------------------------------
 1 files changed, 43 insertions(+), 73 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 057408b..a16ddbd 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -46,24 +46,15 @@
 #define RCU_TREE_NONCORE
 #include "rcutree.h"
 
-static void print_rcubarrier(struct seq_file *m, struct rcu_state *rsp)
-{
-	seq_printf(m, "%c bcc: %d nbd: %lu\n",
-		   rsp->rcu_barrier_in_progress ? 'B' : '.',
-		   atomic_read(&rsp->barrier_cpu_count),
-		   rsp->n_barrier_done);
-}
-
 static int show_rcubarrier(struct seq_file *m, void *unused)
 {
-#ifdef CONFIG_TREE_PREEMPT_RCU
-	seq_puts(m, "rcu_preempt: ");
-	print_rcubarrier(m, &rcu_preempt_state);
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-	seq_puts(m, "rcu_sched: ");
-	print_rcubarrier(m, &rcu_sched_state);
-	seq_puts(m, "rcu_bh: ");
-	print_rcubarrier(m, &rcu_bh_state);
+	struct rcu_state *rsp;
+
+	for_each_rcu_flavor(rsp)
+		seq_printf(m, "%s: %c bcc: %d nbd: %lu\n",
+			   rsp->name, rsp->rcu_barrier_in_progress ? 'B' : '.',
+			   atomic_read(&rsp->barrier_cpu_count),
+			   rsp->n_barrier_done);
 	return 0;
 }
 
@@ -129,24 +120,16 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
 
-#define PRINT_RCU_DATA(name, func, m) \
-	do { \
-		int _p_r_d_i; \
-		\
-		for_each_possible_cpu(_p_r_d_i) \
-			func(m, &per_cpu(name, _p_r_d_i)); \
-	} while (0)
-
 static int show_rcudata(struct seq_file *m, void *unused)
 {
-#ifdef CONFIG_TREE_PREEMPT_RCU
-	seq_puts(m, "rcu_preempt:\n");
-	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data, m);
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-	seq_puts(m, "rcu_sched:\n");
-	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data, m);
-	seq_puts(m, "rcu_bh:\n");
-	PRINT_RCU_DATA(rcu_bh_data, print_one_rcu_data, m);
+	int cpu;
+	struct rcu_state *rsp;
+
+	for_each_rcu_flavor(rsp) {
+		seq_printf(m, "%s:\n", rsp->name);
+		for_each_possible_cpu(cpu)
+			print_one_rcu_data(m, per_cpu_ptr(rsp->rda, cpu));
+	}
 	return 0;
 }
 
@@ -200,6 +183,9 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 
 static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
+	int cpu;
+	struct rcu_state *rsp;
+
 	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
 	seq_puts(m, "\"of\",\"qll\",\"ql\",\"qs\"");
@@ -207,14 +193,11 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 	seq_puts(m, "\"kt\",\"ktl\"");
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	seq_puts(m, ",\"b\",\"ci\",\"co\",\"ca\"\n");
-#ifdef CONFIG_TREE_PREEMPT_RCU
-	seq_puts(m, "\"rcu_preempt:\"\n");
-	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data_csv, m);
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-	seq_puts(m, "\"rcu_sched:\"\n");
-	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data_csv, m);
-	seq_puts(m, "\"rcu_bh:\"\n");
-	PRINT_RCU_DATA(rcu_bh_data, print_one_rcu_data_csv, m);
+	for_each_rcu_flavor(rsp) {
+		seq_printf(m, "\"%s:\"\n", rsp->name);
+		for_each_possible_cpu(cpu)
+			print_one_rcu_data_csv(m, per_cpu_ptr(rsp->rda, cpu));
+	}
 	return 0;
 }
 
@@ -304,9 +287,9 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 	struct rcu_node *rnp;
 
 	gpnum = rsp->gpnum;
-	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x "
+	seq_printf(m, "%s: c=%lu g=%lu s=%d jfq=%ld j=%x "
 		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld/%ld\n",
-		   rsp->completed, gpnum, rsp->fqs_state,
+		   rsp->name, rsp->completed, gpnum, rsp->fqs_state,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff),
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
@@ -329,14 +312,10 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 
 static int show_rcuhier(struct seq_file *m, void *unused)
 {
-#ifdef CONFIG_TREE_PREEMPT_RCU
-	seq_puts(m, "rcu_preempt:\n");
-	print_one_rcu_state(m, &rcu_preempt_state);
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-	seq_puts(m, "rcu_sched:\n");
-	print_one_rcu_state(m, &rcu_sched_state);
-	seq_puts(m, "rcu_bh:\n");
-	print_one_rcu_state(m, &rcu_bh_state);
+	struct rcu_state *rsp;
+
+	for_each_rcu_flavor(rsp)
+		print_one_rcu_state(m, rsp);
 	return 0;
 }
 
@@ -377,11 +356,10 @@ static void show_one_rcugp(struct seq_file *m, struct rcu_state *rsp)
 
 static int show_rcugp(struct seq_file *m, void *unused)
 {
-#ifdef CONFIG_TREE_PREEMPT_RCU
-	show_one_rcugp(m, &rcu_preempt_state);
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-	show_one_rcugp(m, &rcu_sched_state);
-	show_one_rcugp(m, &rcu_bh_state);
+	struct rcu_state *rsp;
+
+	for_each_rcu_flavor(rsp)
+		show_one_rcugp(m, rsp);
 	return 0;
 }
 
@@ -416,28 +394,20 @@ static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->n_rp_need_nothing);
 }
 
-static void print_rcu_pendings(struct seq_file *m, struct rcu_state *rsp)
+static int show_rcu_pending(struct seq_file *m, void *unused)
 {
 	int cpu;
 	struct rcu_data *rdp;
-
-	for_each_possible_cpu(cpu) {
-		rdp = per_cpu_ptr(rsp->rda, cpu);
-		if (rdp->beenonline)
-			print_one_rcu_pending(m, rdp);
+	struct rcu_state *rsp;
+
+	for_each_rcu_flavor(rsp) {
+		seq_printf(m, "%s:\n", rsp->name);
+		for_each_possible_cpu(cpu) {
+			rdp = per_cpu_ptr(rsp->rda, cpu);
+			if (rdp->beenonline)
+				print_one_rcu_pending(m, rdp);
+		}
 	}
-}
-
-static int show_rcu_pending(struct seq_file *m, void *unused)
-{
-#ifdef CONFIG_TREE_PREEMPT_RCU
-	seq_puts(m, "rcu_preempt:\n");
-	print_rcu_pendings(m, &rcu_preempt_state);
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-	seq_puts(m, "rcu_sched:\n");
-	print_rcu_pendings(m, &rcu_sched_state);
-	seq_puts(m, "rcu_bh:\n");
-	print_rcu_pendings(m, &rcu_bh_state);
 	return 0;
 }
 
-- 
1.7.8

