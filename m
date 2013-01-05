Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3AERuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:50:24 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50231 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab3AERtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:49:23 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: [PATCH tip/core/rcu 01/14] rcu: Tag callback lists with corresponding grace-period number
Date: Sat,  5 Jan 2013 09:48:51 -0800
Message-Id: <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20130105174844.GA14172@linux.vnet.ibm.com>
References: <20130105174844.GA14172@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-7606-0000-0000-00000726CA7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, callbacks are advanced each time the corresponding CPU
notices a change in its leaf rcu_node structure's ->completed value
(this value counts grace-period completions).  This approach has worked
quite well, but with the advent of RCU_FAST_NO_HZ, we cannot count on
a given CPU seeing all the grace-period completions.  When a CPU misses
a grace-period completion that occurs while it is in dyntick-idle mode,
this will delay invocation of its callbacks.

In addition, acceleration of callbacks (when RCU realizes that a given
callback need only wait until the end of the next grace period, rather
than having to wait for a partial grace period followed by a full
grace period) must be carried out extremely carefully.  Insufficient
acceleration will result in unnecessarily long grace-period latencies,
while excessive acceleration will result in premature callback invocation.
Changes that involve this tradeoff are therefore among the most
nerve-wracking changes to RCU.

This commit therefore explicitly tags groups of callbacks with the
number of the grace period that they are waiting for.  This means that
callback-advancement and callback-acceleration functions are idempotent,
so that excessive acceleration will merely waste a few CPU cycles.  This
also allows a CPU to take full advantage of any grace periods that have
elapsed while it has been in dyntick-idle mode.  It should also enable
simulataneous simplifications to and optimizations of RCU_FAST_NO_HZ.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |  195 ++++++++++++++++++++++++++++++++++++++++++++++--------
 kernel/rcutree.h |    2 +
 2 files changed, 169 insertions(+), 28 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e441b77..ac6a75d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -305,17 +305,27 @@ cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
 }
 
 /*
- * Does the current CPU require a yet-as-unscheduled grace period?
+ * Does the current CPU require a not-yet-started grace period?
+ * The caller must have disabled interrupts to prevent races with
+ * normal callback registry.
  */
 static int
 cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	struct rcu_head **ntp;
+	int i;
 
-	ntp = rdp->nxttail[RCU_DONE_TAIL +
-			   (ACCESS_ONCE(rsp->completed) != rdp->completed)];
-	return rdp->nxttail[RCU_DONE_TAIL] && ntp && *ntp &&
-	       !rcu_gp_in_progress(rsp);
+	if (rcu_gp_in_progress(rsp))
+		return 0;  /* No, a grace period is already in progress. */
+	if (!rdp->nxttail[RCU_NEXT_TAIL])
+		return 0;  /* No, this is a no-CBs (or offline) CPU. */
+	if (*rdp->nxttail[RCU_NEXT_READY_TAIL])
+		return 1;  /* Yes, this CPU has newly registered callbacks. */
+	for (i = RCU_WAIT_TAIL; i < RCU_NEXT_TAIL; i++)
+		if (rdp->nxttail[i - 1] != rdp->nxttail[i] &&
+		    ULONG_CMP_LT(ACCESS_ONCE(rsp->completed),
+				 rdp->nxtcompleted[i]))
+			return 1;  /* Yes, CBs for future grace period. */
+	return 0; /* No grace period needed. */
 }
 
 /*
@@ -1071,6 +1081,139 @@ static void init_callback_list(struct rcu_data *rdp)
 }
 
 /*
+ * Determine the value that ->completed will have at the end of the
+ * next subsequent grace period.  This is used to tag callbacks so that
+ * a CPU can invoke callbacks in a timely fashion even if that CPU has
+ * been dyntick-idle for an extended period with callbacks under the
+ * influence of RCU_FAST_NO_HZ.
+ *
+ * The caller must hold rnp->lock with interrupts disabled.
+ */
+static unsigned long rcu_cbs_completed(struct rcu_state *rsp,
+				       struct rcu_node *rnp)
+{
+	/*
+	 * If RCU is idle, we just wait for the next grace period.
+	 * But we can only be sure that RCU is idle if we are looking
+	 * at the root rcu_node structure -- otherwise, a new grace
+	 * period might have started, but just not yet gotten around
+	 * to initializing the current non-root rcu_node structure.
+	 */
+	if (rcu_get_root(rsp) == rnp && rnp->gpnum == rnp->completed)
+		return rnp->completed + 1;
+
+	/*
+	 * Otherwise, wait for a possible partial grace period and
+	 * then the subsequent full grace period.
+	 */
+	return rnp->completed + 2;
+}
+
+/*
+ * If there is room, assign a ->completed number to any callbacks on
+ * this CPU that have not already been assigned.  Also accelerate any
+ * callbacks that were previously assigned a ->completed number that has
+ * since proven to be too conservative, which can happen if callbacks get
+ * assigned a ->completed number while RCU is idle, but with reference to
+ * a non-root rcu_node structure.  This function is idempotent, so it does
+ * not hurt to call it repeatedly.
+ *
+ * The caller must hold rnp->lock with interrupts disabled.
+ */
+static void rcu_accelerate_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
+			       struct rcu_data *rdp)
+{
+	unsigned long c;
+	int i;
+
+	/* If the CPU has no callbacks, nothing to do. */
+	if (!rdp->nxttail[RCU_NEXT_TAIL] || !*rdp->nxttail[RCU_DONE_TAIL])
+		return;
+
+	/*
+	 * Starting from the sublist containing the callbacks most
+	 * recently assigned a ->completed number and working down, find the
+	 * first sublist that is not assignable to an upcoming grace period.
+	 * Such a sublist has something in it (first two tests) and has
+	 * a ->completed number assigned that will complete sooner than
+	 * the ->completed number for newly arrived callbacks (last test).
+	 *
+	 * The key point is that any later sublist can be assigned the
+	 * same ->completed number as the newly arrived callbacks, which
+	 * means that the callbacks in any of these later sublist can be
+	 * grouped into a single sublist, whether or not they have already
+	 * been assigned a ->completed number.
+	 */
+	c = rcu_cbs_completed(rsp, rnp);
+	for (i = RCU_NEXT_TAIL - 1; i > RCU_DONE_TAIL; i--)
+		if (rdp->nxttail[i] != rdp->nxttail[i - 1] &&
+		    !ULONG_CMP_GE(rdp->nxtcompleted[i], c))
+			break;
+
+	/*
+	 * If there are no sublist for unassigned callbacks, leave.
+	 * At the same time, advance "i" one sublist, so that "i" will
+	 * index into the sublist where all the remaining callbacks should
+	 * be grouped into.
+	 */
+	if (++i >= RCU_NEXT_TAIL)
+		return;
+
+	/*
+	 * Assign all subsequent callbacks' ->completed number to the next
+	 * full grace period and group them all in the sublist initially
+	 * indexed by "i".
+	 */
+	for (; i <= RCU_NEXT_TAIL; i++) {
+		rdp->nxttail[i] = rdp->nxttail[RCU_NEXT_TAIL];
+		rdp->nxtcompleted[i] = c;
+	}
+}
+
+/*
+ * Move any callbacks whose grace period has completed to the
+ * RCU_DONE_TAIL sublist, then compact the remaining sublists and
+ * assign ->completed numbers to any callbacks in the RCU_NEXT_TAIL
+ * sublist.  This function is idempotent, so it does not hurt to
+ * invoke it repeatedly.  As long as it is not invoked -too- often...
+ *
+ * The caller must hold rnp->lock with interrupts disabled.
+ */
+static void rcu_advance_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
+			    struct rcu_data *rdp)
+{
+	int i, j;
+
+	/* If the CPU has no callbacks, nothing to do. */
+	if (!rdp->nxttail[RCU_NEXT_TAIL] || !*rdp->nxttail[RCU_DONE_TAIL])
+		return;
+
+	/*
+	 * Find all callbacks whose ->completed numbers indicate that they
+	 * are ready to invoke, and put them into the RCU_DONE_TAIL sublist.
+	 */
+	for (i = RCU_WAIT_TAIL; i < RCU_NEXT_TAIL; i++) {
+		if (ULONG_CMP_LT(rnp->completed, rdp->nxtcompleted[i]))
+			break;
+		rdp->nxttail[RCU_DONE_TAIL] = rdp->nxttail[i];
+	}
+	/* Clean up any sublist tail pointers that were misordered above. */
+	for (j = RCU_WAIT_TAIL; j < i; j++)
+		rdp->nxttail[j] = rdp->nxttail[RCU_DONE_TAIL];
+
+	/* Copy down callbacks to fill in empty sublists. */
+	for (j = RCU_WAIT_TAIL; i < RCU_NEXT_TAIL; i++, j++) {
+		if (rdp->nxttail[j] == rdp->nxttail[RCU_NEXT_TAIL])
+			break;
+		rdp->nxttail[j] = rdp->nxttail[i];
+		rdp->nxtcompleted[j] = rdp->nxtcompleted[i];
+	}
+
+	/* Classify any remaining callbacks. */
+	rcu_accelerate_cbs(rsp, rnp, rdp);
+}
+
+/*
  * Advance this CPU's callbacks, but only if the current grace period
  * has ended.  This may be called only from the CPU to whom the rdp
  * belongs.  In addition, the corresponding leaf rcu_node structure's
@@ -1080,12 +1223,15 @@ static void
 __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
 {
 	/* Did another grace period end? */
-	if (rdp->completed != rnp->completed) {
+	if (rdp->completed == rnp->completed) {
+
+		/* No, so just accelerate recent callbacks. */
+		rcu_accelerate_cbs(rsp, rnp, rdp);
 
-		/* Advance callbacks.  No harm if list empty. */
-		rdp->nxttail[RCU_DONE_TAIL] = rdp->nxttail[RCU_WAIT_TAIL];
-		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_READY_TAIL];
-		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	} else {
+
+		/* Advance callbacks. */
+		rcu_advance_cbs(rsp, rnp, rdp);
 
 		/* Remember that we saw this grace-period completion. */
 		rdp->completed = rnp->completed;
@@ -1392,17 +1538,10 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	/*
 	 * Because there is no grace period in progress right now,
 	 * any callbacks we have up to this point will be satisfied
-	 * by the next grace period.  So promote all callbacks to be
-	 * handled after the end of the next grace period.  If the
-	 * CPU is not yet aware of the end of the previous grace period,
-	 * we need to allow for the callback advancement that will
-	 * occur when it does become aware.  Deadlock prevents us from
-	 * making it aware at this point: We cannot acquire a leaf
-	 * rcu_node ->lock while holding the root rcu_node ->lock.
+	 * by the next grace period.  So this is a good place to
+	 * assign a grace period number to recently posted callbacks.
 	 */
-	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-	if (rdp->completed == rsp->completed)
-		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	rcu_accelerate_cbs(rsp, rnp, rdp);
 
 	rsp->gp_flags = RCU_GP_FLAG_INIT;
 	raw_spin_unlock(&rnp->lock); /* Interrupts remain disabled. */
@@ -1527,7 +1666,7 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 		 * This GP can't end until cpu checks in, so all of our
 		 * callbacks can be processed during the next GP.
 		 */
-		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+		rcu_accelerate_cbs(rsp, rnp, rdp);
 
 		rcu_report_qs_rnp(mask, rsp, rnp, flags); /* rlses rnp->lock */
 	}
@@ -1779,7 +1918,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	long bl, count, count_lazy;
 	int i;
 
-	/* If no callbacks are ready, just return.*/
+	/* If no callbacks are ready, just return. */
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
 		trace_rcu_batch_start(rsp->name, rdp->qlen_lazy, rdp->qlen, 0);
 		trace_rcu_batch_end(rsp->name, 0, !!ACCESS_ONCE(rdp->nxtlist),
@@ -2008,19 +2147,19 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 
 	WARN_ON_ONCE(rdp->beenonline == 0);
 
-	/*
-	 * Advance callbacks in response to end of earlier grace
-	 * period that some other CPU ended.
-	 */
+	/* Handle the end of a grace period that some other CPU ended.  */
 	rcu_process_gp_end(rsp, rdp);
 
 	/* Update RCU state based on any recent quiescent states. */
 	rcu_check_quiescent_state(rsp, rdp);
 
 	/* Does this CPU require a not-yet-started grace period? */
+	local_irq_save(flags);
 	if (cpu_needs_another_gp(rsp, rdp)) {
-		raw_spin_lock_irqsave(&rcu_get_root(rsp)->lock, flags);
+		raw_spin_lock(&rcu_get_root(rsp)->lock); /* irqs disabled. */
 		rcu_start_gp(rsp, flags);  /* releases above lock */
+	} else {
+		local_irq_restore(flags);
 	}
 
 	/* If there are callbacks ready, invoke them. */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4b69291..c9f362e 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -282,6 +282,8 @@ struct rcu_data {
 	 */
 	struct rcu_head *nxtlist;
 	struct rcu_head **nxttail[RCU_NEXT_SIZE];
+	unsigned long	nxtcompleted[RCU_NEXT_SIZE];
+					/* grace periods for sublists. */
 	long		qlen_lazy;	/* # of lazy queued callbacks */
 	long		qlen;		/* # of queued callbacks, incl lazy */
 	long		qlen_last_fqs_check;
-- 
1.7.8

