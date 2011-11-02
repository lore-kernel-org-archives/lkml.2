Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab1KBUbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:31:15 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:32825 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab1KBUbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:12 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 02/28] rcu: ->signaled better named ->fqs_state
Date: Wed,  2 Nov 2011 13:30:23 -0700
Message-Id: <1320265849-5744-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-7182-0000-0000-0000001E3399
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ->signaled field was named before complications in the form of
dyntick-idle mode and offlined CPUs.  These complications have required
that force_quiescent_state() be implemented as a state machine, instead
of simply unconditionally sending reschedule IPIs.  Therefore, this
commit renames ->signaled to ->fqs_state to catch up with the new
force_quiescent_state() reality.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c       |   16 ++++++++--------
 kernel/rcutree.h       |    4 ++--
 kernel/rcutree_trace.c |    2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e234eb9..cb7c46e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -69,7 +69,7 @@ static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 		NUM_RCU_LVL_3, \
 		NUM_RCU_LVL_4, /* == MAX_RCU_LVLS */ \
 	}, \
-	.signaled = RCU_GP_IDLE, \
+	.fqs_state = RCU_GP_IDLE, \
 	.gpnum = -300, \
 	.completed = -300, \
 	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname##_state.onofflock), \
@@ -866,8 +866,8 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	/* Advance to a new grace period and initialize state. */
 	rsp->gpnum++;
 	trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
-	WARN_ON_ONCE(rsp->signaled == RCU_GP_INIT);
-	rsp->signaled = RCU_GP_INIT; /* Hold off force_quiescent_state. */
+	WARN_ON_ONCE(rsp->fqs_state == RCU_GP_INIT);
+	rsp->fqs_state = RCU_GP_INIT; /* Hold off force_quiescent_state. */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
 
@@ -877,7 +877,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
 		rnp->completed = rsp->completed;
-		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
+		rsp->fqs_state = RCU_SIGNAL_INIT; /* force_quiescent_state OK */
 		rcu_start_gp_per_cpu(rsp, rnp, rdp);
 		rcu_preempt_boost_start_gp(rnp);
 		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
@@ -927,7 +927,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock(&rnp->lock);		/* irqs already disabled. */
-	rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
+	rsp->fqs_state = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
@@ -991,7 +991,7 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 
 	rsp->completed = rsp->gpnum;  /* Declare the grace period complete. */
 	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
-	rsp->signaled = RCU_GP_IDLE;
+	rsp->fqs_state = RCU_GP_IDLE;
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
 }
 
@@ -1457,7 +1457,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		goto unlock_fqs_ret;  /* no GP in progress, time updated. */
 	}
 	rsp->fqs_active = 1;
-	switch (rsp->signaled) {
+	switch (rsp->fqs_state) {
 	case RCU_GP_IDLE:
 	case RCU_GP_INIT:
 
@@ -1473,7 +1473,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		force_qs_rnp(rsp, dyntick_save_progress_counter);
 		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
 		if (rcu_gp_in_progress(rsp))
-			rsp->signaled = RCU_FORCE_QS;
+			rsp->fqs_state = RCU_FORCE_QS;
 		break;
 
 	case RCU_FORCE_QS:
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 849ce9e..517f2f8 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -302,7 +302,7 @@ struct rcu_data {
 	struct rcu_state *rsp;
 };
 
-/* Values for signaled field in struct rcu_state. */
+/* Values for fqs_state field in struct rcu_state. */
 #define RCU_GP_IDLE		0	/* No grace period in progress. */
 #define RCU_GP_INIT		1	/* Grace period being initialized. */
 #define RCU_SAVE_DYNTICK	2	/* Need to scan dyntick state. */
@@ -361,7 +361,7 @@ struct rcu_state {
 
 	/* The following fields are guarded by the root rcu_node's lock. */
 
-	u8	signaled ____cacheline_internodealigned_in_smp;
+	u8	fqs_state ____cacheline_internodealigned_in_smp;
 						/* Force QS state. */
 	u8	fqs_active;			/* force_quiescent_state() */
 						/*  is running. */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 9feffa4..59c7bee 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -278,7 +278,7 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 	gpnum = rsp->gpnum;
 	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x "
 		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
-		   rsp->completed, gpnum, rsp->signaled,
+		   rsp->completed, gpnum, rsp->fqs_state,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff),
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
-- 
1.7.3.2

