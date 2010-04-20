Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab0DTVrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:47:12 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47180 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab0DTVpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:45:11 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 16/23] rcu: v2: reduce the number of spurious RCU_SOFTIRQ invocations
Date: Tue, 20 Apr 2010 14:44:48 -0700
Message-Id: <1271799895-21028-16-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100420214431.GA20777@linux.vnet.ibm.com>
References: <20100420214431.GA20777@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan noted that up to 10% of the RCU_SOFTIRQ are spurious, and
traced this down to the fact that the current grace-period machinery
will uselessly raise RCU_SOFTIRQ when a given CPU needs to go through
a quiescent state, but has not yet done so.  In this situation, there
might well be nothing that RCU_SOFTIRQ can do, and the overhead can be
worth worrying about in the ksoftirqd case.  This patch therefore avoids
raising RCU_SOFTIRQ in this situation.

Changes since v1 (http://lkml.org/lkml/2010/3/30/122 from Lai Jiangshan):

o	Omit the rcu_qs_pending() prechecks, as they aren't that
	much less expensive than the quiescent-state checks.

o	Merge with the set_need_resched() patch that reduces IPIs.

o	Add the new n_rp_report_qs field to the rcu_pending tracing output.

o	Update the tracing documentation accordingly.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |   35 +++++++++++++++++++----------------
 kernel/rcutree.c            |   11 ++++++-----
 kernel/rcutree.h            |    1 +
 kernel/rcutree_trace.c      |    4 +++-
 4 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 8608fd8..efd8cc9 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -256,23 +256,23 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 The output of "cat rcu/rcu_pending" looks as follows:
 
 rcu_sched:
-  0 np=255892 qsp=53936 cbr=0 cng=14417 gpc=10033 gps=24320 nf=6445 nn=146741
-  1 np=261224 qsp=54638 cbr=0 cng=25723 gpc=16310 gps=2849 nf=5912 nn=155792
-  2 np=237496 qsp=49664 cbr=0 cng=2762 gpc=45478 gps=1762 nf=1201 nn=136629
-  3 np=236249 qsp=48766 cbr=0 cng=286 gpc=48049 gps=1218 nf=207 nn=137723
-  4 np=221310 qsp=46850 cbr=0 cng=26 gpc=43161 gps=4634 nf=3529 nn=123110
-  5 np=237332 qsp=48449 cbr=0 cng=54 gpc=47920 gps=3252 nf=201 nn=137456
-  6 np=219995 qsp=46718 cbr=0 cng=50 gpc=42098 gps=6093 nf=4202 nn=120834
-  7 np=249893 qsp=49390 cbr=0 cng=72 gpc=38400 gps=17102 nf=41 nn=144888
+  0 np=255892 qsp=53936 rpq=85 cbr=0 cng=14417 gpc=10033 gps=24320 nf=6445 nn=146741
+  1 np=261224 qsp=54638 rpq=33 cbr=0 cng=25723 gpc=16310 gps=2849 nf=5912 nn=155792
+  2 np=237496 qsp=49664 rpq=23 cbr=0 cng=2762 gpc=45478 gps=1762 nf=1201 nn=136629
+  3 np=236249 qsp=48766 rpq=98 cbr=0 cng=286 gpc=48049 gps=1218 nf=207 nn=137723
+  4 np=221310 qsp=46850 rpq=7 cbr=0 cng=26 gpc=43161 gps=4634 nf=3529 nn=123110
+  5 np=237332 qsp=48449 rpq=9 cbr=0 cng=54 gpc=47920 gps=3252 nf=201 nn=137456
+  6 np=219995 qsp=46718 rpq=12 cbr=0 cng=50 gpc=42098 gps=6093 nf=4202 nn=120834
+  7 np=249893 qsp=49390 rpq=42 cbr=0 cng=72 gpc=38400 gps=17102 nf=41 nn=144888
 rcu_bh:
-  0 np=146741 qsp=1419 cbr=0 cng=6 gpc=0 gps=0 nf=2 nn=145314
-  1 np=155792 qsp=12597 cbr=0 cng=0 gpc=4 gps=8 nf=3 nn=143180
-  2 np=136629 qsp=18680 cbr=0 cng=0 gpc=7 gps=6 nf=0 nn=117936
-  3 np=137723 qsp=2843 cbr=0 cng=0 gpc=10 gps=7 nf=0 nn=134863
-  4 np=123110 qsp=12433 cbr=0 cng=0 gpc=4 gps=2 nf=0 nn=110671
-  5 np=137456 qsp=4210 cbr=0 cng=0 gpc=6 gps=5 nf=0 nn=133235
-  6 np=120834 qsp=9902 cbr=0 cng=0 gpc=6 gps=3 nf=2 nn=110921
-  7 np=144888 qsp=26336 cbr=0 cng=0 gpc=8 gps=2 nf=0 nn=118542
+  0 np=146741 qsp=1419 rpq=6 cbr=0 cng=6 gpc=0 gps=0 nf=2 nn=145314
+  1 np=155792 qsp=12597 rpq=3 cbr=0 cng=0 gpc=4 gps=8 nf=3 nn=143180
+  2 np=136629 qsp=18680 rpq=1 cbr=0 cng=0 gpc=7 gps=6 nf=0 nn=117936
+  3 np=137723 qsp=2843 rpq=0 cbr=0 cng=0 gpc=10 gps=7 nf=0 nn=134863
+  4 np=123110 qsp=12433 rpq=0 cbr=0 cng=0 gpc=4 gps=2 nf=0 nn=110671
+  5 np=137456 qsp=4210 rpq=1 cbr=0 cng=0 gpc=6 gps=5 nf=0 nn=133235
+  6 np=120834 qsp=9902 rpq=2 cbr=0 cng=0 gpc=6 gps=3 nf=2 nn=110921
+  7 np=144888 qsp=26336 rpq=0 cbr=0 cng=0 gpc=8 gps=2 nf=0 nn=118542
 
 As always, this is once again split into "rcu_sched" and "rcu_bh"
 portions, with CONFIG_TREE_PREEMPT_RCU kernels having an additional
@@ -284,6 +284,9 @@ o	"np" is the number of times that __rcu_pending() has been invoked
 o	"qsp" is the number of times that the RCU was waiting for a
 	quiescent state from this CPU.
 
+o	"rpq" is the number of times that the CPU had passed through
+	a quiescent state, but not yet reported it to RCU.
+
 o	"cbr" is the number of times that this CPU had RCU callbacks
 	that had passed through a grace period, and were thus ready
 	to be invoked.
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c60fd74..ba69969 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1161,8 +1161,6 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
-	if (!rcu_pending(cpu))
-		return; /* if nothing for RCU to do. */
 	if (user ||
 	    (idle_cpu(cpu) && rcu_scheduler_active &&
 	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
@@ -1194,7 +1192,8 @@ void rcu_check_callbacks(int cpu, int user)
 		rcu_bh_qs(cpu);
 	}
 	rcu_preempt_check_callbacks(cpu);
-	raise_softirq(RCU_SOFTIRQ);
+	if (rcu_pending(cpu))
+		raise_softirq(RCU_SOFTIRQ);
 }
 
 #ifdef CONFIG_SMP
@@ -1534,18 +1533,20 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	check_cpu_stall(rsp, rdp);
 
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
-	if (rdp->qs_pending) {
+	if (rdp->qs_pending && !rdp->passed_quiesc) {
 
 		/*
 		 * If force_quiescent_state() coming soon and this CPU
 		 * needs a quiescent state, and this is either RCU-sched
 		 * or RCU-bh, force a local reschedule.
 		 */
+		rdp->n_rp_qs_pending++;
 		if (!rdp->preemptable &&
 		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
 				 jiffies))
 			set_need_resched();
-		rdp->n_rp_qs_pending++;
+	} else if (rdp->qs_pending && rdp->passed_quiesc) {
+		rdp->n_rp_report_qs++;
 		return 1;
 	}
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 11f1711..14c040b 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -223,6 +223,7 @@ struct rcu_data {
 	/* 5) __rcu_pending() statistics. */
 	unsigned long n_rcu_pending;	/* rcu_pending() calls since boot. */
 	unsigned long n_rp_qs_pending;
+	unsigned long n_rp_report_qs;
 	unsigned long n_rp_cb_ready;
 	unsigned long n_rp_cpu_needs_gp;
 	unsigned long n_rp_gp_completed;
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index d45db2e..36c95b4 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -241,11 +241,13 @@ static const struct file_operations rcugp_fops = {
 static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
 {
 	seq_printf(m, "%3d%cnp=%ld "
-		   "qsp=%ld cbr=%ld cng=%ld gpc=%ld gps=%ld nf=%ld nn=%ld\n",
+		   "qsp=%ld rpq=%ld cbr=%ld cng=%ld "
+		   "gpc=%ld gps=%ld nf=%ld nn=%ld\n",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
 		   rdp->n_rcu_pending,
 		   rdp->n_rp_qs_pending,
+		   rdp->n_rp_report_qs,
 		   rdp->n_rp_cb_ready,
 		   rdp->n_rp_cpu_needs_gp,
 		   rdp->n_rp_gp_completed,
-- 
1.7.0

