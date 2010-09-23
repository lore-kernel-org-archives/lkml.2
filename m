Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0IWAvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:51:24 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57247 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672Ab0IWAvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:51:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 7/8] rcu: Add tracing data to support queueing models
Date: Wed, 22 Sep 2010 17:50:52 -0700
Message-Id: <1285203053-22068-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100923005033.GA22006@linux.vnet.ibm.com>
References: <20100923005033.GA22006@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current tracing data is not sufficient to deduce the average time
that a callback spends waiting for a grace period to end.  Add three
per-CPU counters recording the number of callbacks invoked (ci), the
number of callbacks orphaned (co), and the number of callbacks adopted
(ca).  Given the existing callback queue length (ql), the average wait
time in absence of CPU hotplug operations is ql/ci.  The units of wait
time will be in terms of the duration over which ci was measured.

In the presence of CPU hotplug operations, there is room for argument,
but ql/(ci-co+ca) won't steer you too far wrong.

Also fixes a typo called out by Lucas De Marchi <lucas.de.marchi@gmail.com>.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |   13 ++++++++++++-
 kernel/rcutree.c            |    3 +++
 kernel/rcutree.h            |    3 +++
 kernel/rcutree_trace.c      |   10 +++++++---
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index efd8cc9..a851118 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -125,6 +125,17 @@ o	"b" is the batch limit for this CPU.  If more than this number
 	of RCU callbacks is ready to invoke, then the remainder will
 	be deferred.
 
+o	"ci" is the number of RCU callbacks that have been invoked for
+	this CPU.  Note that ci+ql is the number of callbacks that have
+	been registered in absence of CPU-hotplug activity.
+
+o	"co" is the number of RCU callbacks that have been orphaned due to
+	this CPU going offline.
+
+o	"ca" is the number of RCU callbacks that have been adopted due to
+	other CPUs going offline.  Note that ci+co-ca+ql is the number of
+	RCU callbacks registered on this CPU.
+
 There is also an rcu/rcudata.csv file with the same information in
 comma-separated-variable spreadsheet format.
 
@@ -180,7 +191,7 @@ o	"s" is the "signaled" state that drives force_quiescent_state()'s
 
 o	"jfq" is the number of jiffies remaining for this grace period
 	before force_quiescent_state() is invoked to help push things
-	along.  Note that CPUs in dyntick-idle mode thoughout the grace
+	along.  Note that CPUs in dyntick-idle mode throughout the grace
 	period will not report on their own, but rather must be check by
 	some other CPU via force_quiescent_state().
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 42140a8..e750735 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1004,6 +1004,7 @@ static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
 	rsp->orphan_qlen += rdp->qlen;
+	rdp->n_cbs_orphaned += rdp->qlen;
 	rdp->qlen = 0;
 	raw_spin_unlock(&rsp->onofflock);  /* irqs remain disabled. */
 }
@@ -1025,6 +1026,7 @@ static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 	*rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_list;
 	rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_tail;
 	rdp->qlen += rsp->orphan_qlen;
+	rdp->n_cbs_adopted += rsp->orphan_qlen;
 	rsp->orphan_cbs_list = NULL;
 	rsp->orphan_cbs_tail = &rsp->orphan_cbs_list;
 	rsp->orphan_qlen = 0;
@@ -1156,6 +1158,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Update count, and requeue any remaining callbacks. */
 	rdp->qlen -= count;
+	rdp->n_cbs_invoked += count;
 	if (list != NULL) {
 		*tail = rdp->nxtlist;
 		rdp->nxtlist = list;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 7918ba6..91d4170 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -202,6 +202,9 @@ struct rcu_data {
 	long		qlen;		/* # of queued callbacks */
 	long		qlen_last_fqs_check;
 					/* qlen at last check for QS forcing */
+	unsigned long	n_cbs_invoked;	/* count of RCU cbs invoked. */
+	unsigned long	n_cbs_orphaned;	/* RCU cbs sent to orphanage. */
+	unsigned long	n_cbs_adopted;	/* RCU cbs adopted from orphanage. */
 	unsigned long	n_force_qs_snap;
 					/* did other CPU force QS recently? */
 	long		blimit;		/* Upper limit on a processed batch */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 458e032..d15430b 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -64,7 +64,9 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, " ql=%ld b=%ld\n", rdp->qlen, rdp->blimit);
+	seq_printf(m, " ql=%ld b=%ld", rdp->qlen, rdp->blimit);
+	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
+		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
 
 #define PRINT_RCU_DATA(name, func, m) \
@@ -119,7 +121,9 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, ",%ld,%ld\n", rdp->qlen, rdp->blimit);
+	seq_printf(m, ",%ld,%ld", rdp->qlen, rdp->blimit);
+	seq_printf(m, ",%lu,%lu,%lu\n",
+		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
 
 static int show_rcudata_csv(struct seq_file *m, void *unused)
@@ -128,7 +132,7 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 #ifdef CONFIG_NO_HZ
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dn\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
-	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\"\n");
+	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\",\"ci\",\"co\",\"ca\"\n");
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	seq_puts(m, "\"rcu_preempt:\"\n");
 	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data_csv, m);
-- 
1.7.0.6

