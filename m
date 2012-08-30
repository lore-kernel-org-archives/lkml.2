Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab2H3STe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:19:34 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58893 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab2H3ST3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:19:29 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/23] rcu: Move RCU grace-period cleanup into kthread
Date: Thu, 30 Aug 2012 11:18:18 -0700
Message-Id: <1346350718-30937-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-5806-0000-0000-000018FC3C17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

As a first step towards allowing grace-period cleanup to be preemptible,
this commit moves the RCU grace-period cleanup into the same kthread
that is now used to initialize grace periods.  This is needed to keep
scheduling latency down to a dull roar.

Reported-by: Mike Galbraith <mgalbraith@suse.de>
Reported-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |  112 ++++++++++++++++++++++++++++++------------------------
 1 files changed, 62 insertions(+), 50 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ef56aa3..9fad21c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1045,6 +1045,7 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 static int rcu_gp_kthread(void *arg)
 {
 	unsigned long flags;
+	unsigned long gp_duration;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 	struct rcu_state *rsp = arg;
@@ -1135,6 +1136,65 @@ static int rcu_gp_kthread(void *arg)
 		rsp->fqs_state = RCU_SIGNAL_INIT;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		put_online_cpus();
+
+		/* Handle grace-period end. */
+		rnp = rcu_get_root(rsp);
+		for (;;) {
+			wait_event_interruptible(rsp->gp_wq,
+						 !ACCESS_ONCE(rnp->qsmask) &&
+						 !rcu_preempt_blocked_readers_cgp(rnp));
+			if (!ACCESS_ONCE(rnp->qsmask) &&
+			    !rcu_preempt_blocked_readers_cgp(rnp))
+				break;
+			flush_signals(current);
+		}
+
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		gp_duration = jiffies - rsp->gp_start;
+		if (gp_duration > rsp->gp_max)
+			rsp->gp_max = gp_duration;
+
+		/*
+		 * We know the grace period is complete, but to everyone else
+		 * it appears to still be ongoing.  But it is also the case
+		 * that to everyone else it looks like there is nothing that
+		 * they can do to advance the grace period.  It is therefore
+		 * safe for us to drop the lock in order to mark the grace
+		 * period as completed in all of the rcu_node structures.
+		 *
+		 * But if this CPU needs another grace period, it will take
+		 * care of this while initializing the next grace period.
+		 * We use RCU_WAIT_TAIL instead of the usual RCU_DONE_TAIL
+		 * because the callbacks have not yet been advanced: Those
+		 * callbacks are waiting on the grace period that just now
+		 * completed.
+		 */
+		if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
+			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+
+			/*
+			 * Propagate new ->completed value to rcu_node
+			 * structures so that other CPUs don't have to
+			 * wait until the start of the next grace period
+			 * to process their callbacks.
+			 */
+			rcu_for_each_node_breadth_first(rsp, rnp) {
+				/* irqs already disabled. */
+				raw_spin_lock(&rnp->lock);
+				rnp->completed = rsp->gpnum;
+				/* irqs remain disabled. */
+				raw_spin_unlock(&rnp->lock);
+			}
+			rnp = rcu_get_root(rsp);
+			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+		}
+
+		rsp->completed = rsp->gpnum; /* Declare grace period done. */
+		trace_rcu_grace_period(rsp->name, rsp->completed, "end");
+		rsp->fqs_state = RCU_GP_IDLE;
+		if (cpu_needs_another_gp(rsp, rdp))
+			rsp->gp_flags = 1;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 	return 0;
 }
@@ -1182,57 +1242,9 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
 {
-	unsigned long gp_duration;
-	struct rcu_node *rnp = rcu_get_root(rsp);
-	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
-
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
-
-	/*
-	 * Ensure that all grace-period and pre-grace-period activity
-	 * is seen before the assignment to rsp->completed.
-	 */
-	smp_mb(); /* See above block comment. */
-	gp_duration = jiffies - rsp->gp_start;
-	if (gp_duration > rsp->gp_max)
-		rsp->gp_max = gp_duration;
-
-	/*
-	 * We know the grace period is complete, but to everyone else
-	 * it appears to still be ongoing.  But it is also the case
-	 * that to everyone else it looks like there is nothing that
-	 * they can do to advance the grace period.  It is therefore
-	 * safe for us to drop the lock in order to mark the grace
-	 * period as completed in all of the rcu_node structures.
-	 *
-	 * But if this CPU needs another grace period, it will take
-	 * care of this while initializing the next grace period.
-	 * We use RCU_WAIT_TAIL instead of the usual RCU_DONE_TAIL
-	 * because the callbacks have not yet been advanced: Those
-	 * callbacks are waiting on the grace period that just now
-	 * completed.
-	 */
-	if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
-		raw_spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
-
-		/*
-		 * Propagate new ->completed value to rcu_node structures
-		 * so that other CPUs don't have to wait until the start
-		 * of the next grace period to process their callbacks.
-		 */
-		rcu_for_each_node_breadth_first(rsp, rnp) {
-			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
-			rnp->completed = rsp->gpnum;
-			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
-		}
-		rnp = rcu_get_root(rsp);
-		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
-	}
-
-	rsp->completed = rsp->gpnum;  /* Declare the grace period complete. */
-	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
-	rsp->fqs_state = RCU_GP_IDLE;
-	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
+	raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
+	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
 }
 
 /*
-- 
1.7.8

