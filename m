Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1IGGbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:31:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37603 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755551Ab1IGGUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:39 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 47/55] rcu: Move propagation of ->completed from rcu_start_gp() to rcu_report_qs_rsp()
Date: Tue,  6 Sep 2011 11:00:41 -0700
Message-Id: <1315332049-2604-47-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
x-cbid: 11090706-6078-0000-0000-000000711758
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible for the CPU that noted the end of the prior grace period
to not need a new one, and therefore to decide to propagate ->completed
throughout the rcu_node tree without starting another grace period.
However, in so doing, it releases the root rcu_node structure's lock,
which can allow some other CPU to start another grace period.  The first
CPU will be propagating ->completed in parallel with the second CPU
initializing the rcu_node tree for the new grace period.  In theory
this is harmless, but in practice we need to keep things simple.

This commit therefore moves the propagation of ->completed to
rcu_report_qs_rsp(), and refrains from marking the old grace period
as having been completed until it has finished doing this.  This
prevents anyone from starting a new grace period concurrently with
marking the old grace period as having been completed.

Of course, the optimization where a CPU needing a new grace period
doesn't bother marking the old one completed is still in effect:
In that case, the marking happens implicitly as part of initializing
the new grace period.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   71 ++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ab37c19..f0a9432 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -842,28 +842,24 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	if (!rcu_scheduler_fully_active ||
-	    !cpu_needs_another_gp(rsp, rdp) ||
-	    rsp->fqs_active) {
-		if (rcu_scheduler_fully_active &&
-		    cpu_needs_another_gp(rsp, rdp))
-			rsp->fqs_need_gp = 1;
-		if (rnp->completed == rsp->completed) {
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-			return;
-		}
-		raw_spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
+	    !cpu_needs_another_gp(rsp, rdp)) {
+		/*
+		 * Either the scheduler hasn't yet spawned the first
+		 * non-idle task or this CPU does not need another
+		 * grace period.  Either way, don't start a new grace
+		 * period.
+		 */
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
 
+	if (rsp->fqs_active) {
 		/*
-		 * Propagate new ->completed value to rcu_node structures
-		 * so that other CPUs don't have to wait until the start
-		 * of the next grace period to process their callbacks.
+		 * This CPU needs a grace period, but force_quiescent_state()
+		 * is running.  Tell it to start one on this CPU's behalf.
 		 */
-		rcu_for_each_node_breadth_first(rsp, rnp) {
-			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
-			rnp->completed = rsp->completed;
-			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
-		}
-		local_irq_restore(flags);
+		rsp->fqs_need_gp = 1;
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 
@@ -947,6 +943,8 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
 {
 	unsigned long gp_duration;
+	struct rcu_node *rnp = rcu_get_root(rsp);
+	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 
@@ -958,7 +956,40 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	gp_duration = jiffies - rsp->gp_start;
 	if (gp_duration > rsp->gp_max)
 		rsp->gp_max = gp_duration;
-	rsp->completed = rsp->gpnum;
+
+	/*
+	 * We know the grace period is complete, but to everyone else
+	 * it appears to still be ongoing.  But it is also the case
+	 * that to everyone else it looks like there is nothing that
+	 * they can do to advance the grace period.  It is therefore
+	 * safe for us to drop the lock in order to mark the grace
+	 * period as completed in all of the rcu_node structures.
+	 *
+	 * But if this CPU needs another grace period, it will take
+	 * care of this while initializing the next grace period.
+	 * We use RCU_WAIT_TAIL instead of the usual RCU_DONE_TAIL
+	 * because the callbacks have not yet been advanced: Those
+	 * callbacks are waiting on the grace period that just now
+	 * completed.
+	 */
+	if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
+		raw_spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
+
+		/*
+		 * Propagate new ->completed value to rcu_node structures
+		 * so that other CPUs don't have to wait until the start
+		 * of the next grace period to process their callbacks.
+		 */
+		rcu_for_each_node_breadth_first(rsp, rnp) {
+			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+			rnp->completed = rsp->gpnum;
+			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+		}
+		rnp = rcu_get_root(rsp);
+		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+	}
+
+	rsp->completed = rsp->gpnum;  /* Declare the grace period complete. */
 	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
 	rsp->signaled = RCU_GP_IDLE;
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
-- 
1.7.3.2

