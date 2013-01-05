Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3AERua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:50:30 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50223 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3AERtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:49:22 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/14] rcu: Push lock release to rcu_start_gp()'s callers
Date: Sat,  5 Jan 2013 09:49:01 -0800
Message-Id: <1357408144-15830-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130105174844.GA14172@linux.vnet.ibm.com>
 <1357408144-15830-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-7606-0000-0000-00000726CA78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

If CPUs are to give prior notice of needed grace periods, it will be
necessary to invoke rcu_start_gp() without dropping the root rcu_node
structure's ->lock.  This commit takes a second step in this direction
by moving the release of this lock to rcu_start_gp()'s callers.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   24 ++++++++++--------------
 kernel/rcutree_plugin.h |    5 ++---
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7207435..8ca18ec 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1525,16 +1525,14 @@ static int __noreturn rcu_gp_kthread(void *arg)
 /*
  * Start a new RCU grace period if warranted, re-initializing the hierarchy
  * in preparation for detecting the next grace period.  The caller must hold
- * the root node's ->lock, which is released before return.  Hard irqs must
- * be disabled.
+ * the root node's ->lock and hard irqs must be disabled.
  *
  * Note that it is legal for a dying CPU (which is marked as offline) to
  * invoke this function.  This can happen when the dying CPU reports its
  * quiescent state.
  */
 static void
-rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
-	__releases(rcu_get_root(rsp)->lock)
+rcu_start_gp(struct rcu_state *rsp)
 {
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
 	struct rcu_node *rnp = rcu_get_root(rsp);
@@ -1548,15 +1546,13 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	 */
 	rcu_advance_cbs(rsp, rnp, rdp);
 
-	if (!rsp->gp_kthread ||
-	    !cpu_needs_another_gp(rsp, rdp)) {
+	if (!rsp->gp_kthread || !cpu_needs_another_gp(rsp, rdp)) {
 		/*
 		 * Either we have not yet spawned the grace-period
 		 * task, this CPU does not need another grace period,
 		 * or a grace period is already in progress.
 		 * Either way, don't start a new grace period.
 		 */
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 	rsp->gp_flags = RCU_GP_FLAG_INIT;
@@ -1566,15 +1562,14 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 
 	/* Wake up rcu_gp_kthread() to start the grace period. */
 	wake_up(&rsp->gp_wq);
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
  * Report a full set of quiescent states to the specified rcu_state
  * data structure.  This involves cleaning up after the prior grace
  * period and letting rcu_start_gp() start up the next grace period
- * if one is needed.  Note that the caller must hold rnp->lock, as
- * required by rcu_start_gp(), which will release it.
+ * if one is needed.  Note that the caller must hold rnp->lock, which
+ * is released before return.
  */
 static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
@@ -2172,7 +2167,8 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 	local_irq_save(flags);
 	if (cpu_needs_another_gp(rsp, rdp)) {
 		raw_spin_lock(&rcu_get_root(rsp)->lock); /* irqs disabled. */
-		rcu_start_gp(rsp, flags);  /* releases above lock */
+		rcu_start_gp(rsp);
+		raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
 	} else {
 		local_irq_restore(flags);
 	}
@@ -2252,11 +2248,11 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 
 		/* Start a new grace period if one not already started. */
 		if (!rcu_gp_in_progress(rsp)) {
-			unsigned long nestflag;
 			struct rcu_node *rnp_root = rcu_get_root(rsp);
 
-			raw_spin_lock_irqsave(&rnp_root->lock, nestflag);
-			rcu_start_gp(rsp, nestflag);  /* rlses rnp_root->lock */
+			raw_spin_lock(&rnp_root->lock);
+			rcu_start_gp(rsp);
+			raw_spin_lock(&rnp_root->lock);
 		} else {
 			/* Give the grace period a kick. */
 			rdp->blimit = LONG_MAX;
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index d09acdf..736dd2c 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2213,7 +2213,6 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 	unsigned long c;
 	bool d;
 	unsigned long flags;
-	unsigned long flags1;
 	struct rcu_node *rnp = rdp->mynode;
 	struct rcu_node *rnp_root = rcu_get_root(rdp->rsp);
 
@@ -2275,8 +2274,8 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 						      c, rnp->level,
 						      rnp->grplo, rnp->grphi,
 						      "Startedroot");
-			local_save_flags(flags1);
-			rcu_start_gp(rdp->rsp, flags1); /* Rlses ->lock. */
+			rcu_start_gp(rdp->rsp);
+			raw_spin_unlock(&rnp->lock);
 		}
 
 		/* Clean up locking and irq state. */
-- 
1.7.8

