Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2H3SUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:20:43 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54605 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab2H3STz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:19:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/23] rcu: Move quiescent-state forcing into kthread
Date: Thu, 30 Aug 2012 11:18:24 -0700
Message-Id: <1346350718-30937-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-7606-0000-0000-00000333BA0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

As the first step towards allowing quiescent-state forcing to be
preemptible, this commit moves RCU quiescent-state forcing into the
same kthread that is now used to initialize and clean up after grace
periods.  This is yet another step towards keeping scheduling
latency down to a dull roar.

Reported-by: Mike Galbraith <mgalbraith@suse.de>
Reported-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |  198 ++++++++++++++++++-----------------------------
 kernel/rcutree.h        |    6 +-
 kernel/rcutree_plugin.h |    8 +-
 3 files changed, 82 insertions(+), 130 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c2c036f..79c2c28 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -72,7 +72,6 @@ static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
 	.orphan_nxttail = &sname##_state.orphan_nxtlist, \
 	.orphan_donetail = &sname##_state.orphan_donelist, \
 	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
-	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.fqslock), \
 	.name = #sname, \
 }
 
@@ -226,7 +225,8 @@ int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
 module_param(rcu_cpu_stall_suppress, int, 0644);
 module_param(rcu_cpu_stall_timeout, int, 0644);
 
-static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
+static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *));
+static void force_quiescent_state(struct rcu_state *rsp);
 static int rcu_pending(int cpu);
 
 /*
@@ -252,7 +252,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
  */
 void rcu_bh_force_quiescent_state(void)
 {
-	force_quiescent_state(&rcu_bh_state, 0);
+	force_quiescent_state(&rcu_bh_state);
 }
 EXPORT_SYMBOL_GPL(rcu_bh_force_quiescent_state);
 
@@ -286,7 +286,7 @@ EXPORT_SYMBOL_GPL(rcutorture_record_progress);
  */
 void rcu_sched_force_quiescent_state(void)
 {
-	force_quiescent_state(&rcu_sched_state, 0);
+	force_quiescent_state(&rcu_sched_state);
 }
 EXPORT_SYMBOL_GPL(rcu_sched_force_quiescent_state);
 
@@ -782,11 +782,11 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	else if (!trigger_all_cpu_backtrace())
 		dump_stack();
 
-	/* If so configured, complain about tasks blocking the grace period. */
+	/* Complain about tasks blocking the grace period. */
 
 	rcu_print_detail_task_stall(rsp);
 
-	force_quiescent_state(rsp, 0);  /* Kick them all. */
+	force_quiescent_state(rsp);  /* Kick them all. */
 }
 
 static void print_cpu_stall(struct rcu_state *rsp)
@@ -1049,7 +1049,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	rsp->gp_flags = 0;
+	rsp->gp_flags = 0; /* Clear all flags: New grace period. */
 
 	if (rcu_gp_in_progress(rsp)) {
 		/* Grace period already in progress, don't start another. */
@@ -1057,22 +1057,9 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		return 0;
 	}
 
-	if (rsp->fqs_active) {
-		/*
-		 * We need a grace period, but force_quiescent_state()
-		 * is running.  Tell it to start one on our behalf.
-		 */
-		rsp->fqs_need_gp = 1;
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		return 0;
-	}
-
 	/* Advance to a new grace period and initialize state. */
 	rsp->gpnum++;
 	trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
-	WARN_ON_ONCE(rsp->fqs_state == RCU_GP_INIT);
-	rsp->fqs_state = RCU_GP_INIT; /* Stop force_quiescent_state. */
-	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
@@ -1109,20 +1096,41 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		cond_resched();
 	}
 
-	rnp = rcu_get_root(rsp);
-	raw_spin_lock_irqsave(&rnp->lock, flags);
-	/* force_quiescent_state() now OK. */
-	rsp->fqs_state = RCU_SIGNAL_INIT;
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	put_online_cpus();
-
 	return 1;
 }
 
 /*
+ * Do one round of quiescent-state forcing.
+ */
+int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
+{
+	unsigned long flags;
+	int fqs_state = fqs_state_in;
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	rsp->n_force_qs++;
+	if (fqs_state == RCU_SAVE_DYNTICK) {
+		/* Collect dyntick-idle snapshots. */
+		force_qs_rnp(rsp, dyntick_save_progress_counter);
+		fqs_state = RCU_FORCE_QS;
+	} else {
+		/* Handle dyntick-idle and offline CPUs. */
+		force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
+	}
+	/* Clear flag to prevent immediate re-entry. */
+	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		rsp->gp_flags &= ~RCU_GP_FLAG_FQS;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	}
+	return fqs_state;
+}
+
+/*
  * Clean up after the old grace period.
  */
-static int rcu_gp_cleanup(struct rcu_state *rsp)
+static void rcu_gp_cleanup(struct rcu_state *rsp)
 {
 	unsigned long flags;
 	unsigned long gp_duration;
@@ -1176,7 +1184,6 @@ static int rcu_gp_cleanup(struct rcu_state *rsp)
 	if (cpu_needs_another_gp(rsp, rdp))
 		rsp->gp_flags = 1;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	return 1;
 }
 
 /*
@@ -1184,6 +1191,8 @@ static int rcu_gp_cleanup(struct rcu_state *rsp)
  */
 static int rcu_gp_kthread(void *arg)
 {
+	int fqs_state;
+	int ret;
 	struct rcu_state *rsp = arg;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
@@ -1191,25 +1200,43 @@ static int rcu_gp_kthread(void *arg)
 
 		/* Handle grace-period start. */
 		for (;;) {
-			wait_event_interruptible(rsp->gp_wq, rsp->gp_flags);
-			if (rsp->gp_flags && rcu_gp_init(rsp))
+			wait_event_interruptible(rsp->gp_wq,
+						 rsp->gp_flags &
+						 RCU_GP_FLAG_INIT);
+			if ((rsp->gp_flags & RCU_GP_FLAG_INIT) &&
+			    rcu_gp_init(rsp))
 				break;
 			cond_resched();
 			flush_signals(current);
 		}
 
-		/* Handle grace-period end. */
+		/* Handle quiescent-state forcing. */
+		fqs_state = RCU_SAVE_DYNTICK;
 		for (;;) {
-			wait_event_interruptible(rsp->gp_wq,
-						 !ACCESS_ONCE(rnp->qsmask) &&
-						 !rcu_preempt_blocked_readers_cgp(rnp));
+			rsp->jiffies_force_qs = jiffies +
+						RCU_JIFFIES_TILL_FORCE_QS;
+			ret = wait_event_interruptible_timeout(rsp->gp_wq,
+					(rsp->gp_flags & RCU_GP_FLAG_FQS) ||
+					(!ACCESS_ONCE(rnp->qsmask) &&
+					 !rcu_preempt_blocked_readers_cgp(rnp)),
+					RCU_JIFFIES_TILL_FORCE_QS);
+			/* If grace period done, leave loop. */
 			if (!ACCESS_ONCE(rnp->qsmask) &&
-			    !rcu_preempt_blocked_readers_cgp(rnp) &&
-			    rcu_gp_cleanup(rsp))
+			    !rcu_preempt_blocked_readers_cgp(rnp))
 				break;
-			cond_resched();
-			flush_signals(current);
+			/* If time for quiescent-state forcing, do it. */
+			if (ret == 0 || (rsp->gp_flags & RCU_GP_FLAG_FQS)) {
+				fqs_state = rcu_gp_fqs(rsp, fqs_state);
+				cond_resched();
+			} else {
+				/* Deal with stray signal. */
+				cond_resched();
+				flush_signals(current);
+			}
 		}
+
+		/* Handle grace-period end. */
+		rcu_gp_cleanup(rsp);
 	}
 	return 0;
 }
@@ -1793,72 +1820,20 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
  * Force quiescent states on reluctant CPUs, and also detect which
  * CPUs are in dyntick-idle mode.
  */
-static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
+static void force_quiescent_state(struct rcu_state *rsp)
 {
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
-	trace_rcu_utilization("Start fqs");
-	if (!rcu_gp_in_progress(rsp)) {
-		trace_rcu_utilization("End fqs");
-		return;  /* No grace period in progress, nothing to force. */
-	}
-	if (!raw_spin_trylock_irqsave(&rsp->fqslock, flags)) {
+	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS)
+		return;  /* Someone beat us to it. */
+	if (!raw_spin_trylock_irqsave(&rnp->lock, flags)) {
 		rsp->n_force_qs_lh++; /* Inexact, can lose counts.  Tough! */
-		trace_rcu_utilization("End fqs");
-		return;	/* Someone else is already on the job. */
-	}
-	if (relaxed && ULONG_CMP_GE(rsp->jiffies_force_qs, jiffies))
-		goto unlock_fqs_ret; /* no emergency and done recently. */
-	rsp->n_force_qs++;
-	raw_spin_lock(&rnp->lock);  /* irqs already disabled */
-	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
-	if(!rcu_gp_in_progress(rsp)) {
-		rsp->n_force_qs_ngp++;
-		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		goto unlock_fqs_ret;  /* no GP in progress, time updated. */
-	}
-	rsp->fqs_active = 1;
-	switch (rsp->fqs_state) {
-	case RCU_GP_IDLE:
-	case RCU_GP_INIT:
-
-		break; /* grace period idle or initializing, ignore. */
-
-	case RCU_SAVE_DYNTICK:
-
-		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
-
-		/* Record dyntick-idle state. */
-		force_qs_rnp(rsp, dyntick_save_progress_counter);
-		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
-		if (rcu_gp_in_progress(rsp))
-			rsp->fqs_state = RCU_FORCE_QS;
-		break;
-
-	case RCU_FORCE_QS:
-
-		/* Check dyntick-idle state, send IPI to laggarts. */
-		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
-
-		/* Leave state in case more forcing is required. */
-
-		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
-		break;
-	}
-	rsp->fqs_active = 0;
-	if (rsp->fqs_need_gp) {
-		raw_spin_unlock(&rsp->fqslock); /* irqs remain disabled */
-		rsp->fqs_need_gp = 0;
-		rcu_start_gp(rsp, flags); /* releases rnp->lock */
-		trace_rcu_utilization("End fqs");
 		return;
 	}
-	raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
-unlock_fqs_ret:
-	raw_spin_unlock_irqrestore(&rsp->fqslock, flags);
-	trace_rcu_utilization("End fqs");
+	rsp->gp_flags |= RCU_GP_FLAG_FQS;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
 }
 
 /*
@@ -1875,13 +1850,6 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 	WARN_ON_ONCE(rdp->beenonline == 0);
 
 	/*
-	 * If an RCU GP has gone long enough, go check for dyntick
-	 * idle CPUs and, if needed, send resched IPIs.
-	 */
-	if (ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies))
-		force_quiescent_state(rsp, 1);
-
-	/*
 	 * Advance callbacks in response to end of earlier grace
 	 * period that some other CPU ended.
 	 */
@@ -1981,12 +1949,11 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 			rdp->blimit = LONG_MAX;
 			if (rsp->n_force_qs == rdp->n_force_qs_snap &&
 			    *rdp->nxttail[RCU_DONE_TAIL] != head)
-				force_quiescent_state(rsp, 0);
+				force_quiescent_state(rsp);
 			rdp->n_force_qs_snap = rsp->n_force_qs;
 			rdp->qlen_last_fqs_check = rdp->qlen;
 		}
-	} else if (ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies))
-		force_quiescent_state(rsp, 1);
+	}
 }
 
 static void
@@ -2267,17 +2234,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
 	if (rcu_scheduler_fully_active &&
 	    rdp->qs_pending && !rdp->passed_quiesce) {
-
-		/*
-		 * If force_quiescent_state() coming soon and this CPU
-		 * needs a quiescent state, and this is either RCU-sched
-		 * or RCU-bh, force a local reschedule.
-		 */
 		rdp->n_rp_qs_pending++;
-		if (!rdp->preemptible &&
-		    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs) - 1,
-				 jiffies))
-			set_need_resched();
 	} else if (rdp->qs_pending && rdp->passed_quiesce) {
 		rdp->n_rp_report_qs++;
 		return 1;
@@ -2307,13 +2264,6 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 		return 1;
 	}
 
-	/* Has an RCU GP gone long enough to send resched IPIs &c? */
-	if (rcu_gp_in_progress(rsp) &&
-	    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies)) {
-		rdp->n_rp_need_fqs++;
-		return 1;
-	}
-
 	/* nothing to do */
 	rdp->n_rp_need_nothing++;
 	return 0;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 5d92b80..1f26b1f 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -413,8 +413,6 @@ struct rcu_state {
 	struct completion barrier_completion;	/* Wake at barrier end. */
 	unsigned long n_barrier_done;		/* ++ at start and end of */
 						/*  _rcu_barrier(). */
-	raw_spinlock_t fqslock;			/* Only one task forcing */
-						/*  quiescent states. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
 	unsigned long n_force_qs;		/* Number of calls to */
@@ -433,6 +431,10 @@ struct rcu_state {
 	struct list_head flavors;		/* List of RCU flavors. */
 };
 
+/* Values for rcu_state structure's gp_flags field. */
+#define RCU_GP_FLAG_INIT 0x1	/* Need grace-period initialization. */
+#define RCU_GP_FLAG_FQS  0x2	/* Need grace-period quiescent-state forcing. */
+
 extern struct list_head rcu_struct_flavors;
 #define for_each_rcu_flavor(rsp) \
 	list_for_each_entry((rsp), &rcu_struct_flavors, flavors)
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index bac8cc1..befb0b2 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -119,7 +119,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
  */
 void rcu_force_quiescent_state(void)
 {
-	force_quiescent_state(&rcu_preempt_state, 0);
+	force_quiescent_state(&rcu_preempt_state);
 }
 EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
 
@@ -2076,16 +2076,16 @@ static void rcu_prepare_for_idle(int cpu)
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	if (per_cpu(rcu_preempt_data, cpu).nxtlist) {
 		rcu_preempt_qs(cpu);
-		force_quiescent_state(&rcu_preempt_state, 0);
+		force_quiescent_state(&rcu_preempt_state);
 	}
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 	if (per_cpu(rcu_sched_data, cpu).nxtlist) {
 		rcu_sched_qs(cpu);
-		force_quiescent_state(&rcu_sched_state, 0);
+		force_quiescent_state(&rcu_sched_state);
 	}
 	if (per_cpu(rcu_bh_data, cpu).nxtlist) {
 		rcu_bh_qs(cpu);
-		force_quiescent_state(&rcu_bh_state, 0);
+		force_quiescent_state(&rcu_bh_state);
 	}
 
 	/*
-- 
1.7.8

