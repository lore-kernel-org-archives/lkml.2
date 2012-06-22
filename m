Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab2FVP0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:26:34 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53471 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196Ab2FVP0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:26:24 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 20/22] rcu: Move RCU grace-period cleanup into kthread
Date: Fri, 22 Jun 2012 08:17:19 -0700
Message-Id: <1340378241-6458-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622151655.GA6249@linux.vnet.ibm.com>
 <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-1780-0000-0000-000006B6BCD4
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000282; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000003; SDB=6.00150292; UDB=6.00034140; UTC=2012-06-22
 15:26:21
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
index e5b4532..4a3f6b0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1035,6 +1035,7 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 static int rcu_gp_kthread(void *arg)
 {
 	unsigned long flags;
+	unsigned long gp_duration;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 	struct rcu_state *rsp = arg;
@@ -1125,6 +1126,65 @@ static int rcu_gp_kthread(void *arg)
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
@@ -1172,57 +1232,9 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
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

