Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab0LQUzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:55:21 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33703 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab0LQUzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:55:09 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 18/20] rcu: reduce __call_rcu()-induced contention on rcu_node structures
Date: Fri, 17 Dec 2010 12:54:49 -0800
Message-Id: <1292619291-2468-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20101217205433.GA10199@linux.vnet.ibm.com>
References: <20101217205433.GA10199@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the current __call_rcu() function was written, the expedited
APIs did not exist.  The __call_rcu() implementation therefore went
to great lengths to detect the end of old grace periods and to start
new ones, all in the name of reducing grace-period latency.  Now the
expedited APIs do exist, and the usage of __call_rcu() has increased
considerably.  This commit therefore causes __call_rcu() to avoid
worrying about grace periods unless there are a large number of
RCU callbacks stacked up on the current CPU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   38 +++++++++++++++++++++-----------------
 1 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 01c8ad3..d0ddfea 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1435,22 +1435,11 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	 */
 	local_irq_save(flags);
 	rdp = this_cpu_ptr(rsp->rda);
-	rcu_process_gp_end(rsp, rdp);
-	check_for_new_grace_period(rsp, rdp);
 
 	/* Add the callback to our list. */
 	*rdp->nxttail[RCU_NEXT_TAIL] = head;
 	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
 
-	/* Start a new grace period if one not already started. */
-	if (!rcu_gp_in_progress(rsp)) {
-		unsigned long nestflag;
-		struct rcu_node *rnp_root = rcu_get_root(rsp);
-
-		raw_spin_lock_irqsave(&rnp_root->lock, nestflag);
-		rcu_start_gp(rsp, nestflag);  /* releases rnp_root->lock. */
-	}
-
 	/*
 	 * Force the grace period if too many callbacks or too long waiting.
 	 * Enforce hysteresis, and don't invoke force_quiescent_state()
@@ -1459,12 +1448,27 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	 * is the only one waiting for a grace period to complete.
 	 */
 	if (unlikely(++rdp->qlen > rdp->qlen_last_fqs_check + qhimark)) {
-		rdp->blimit = LONG_MAX;
-		if (rsp->n_force_qs == rdp->n_force_qs_snap &&
-		    *rdp->nxttail[RCU_DONE_TAIL] != head)
-			force_quiescent_state(rsp, 0);
-		rdp->n_force_qs_snap = rsp->n_force_qs;
-		rdp->qlen_last_fqs_check = rdp->qlen;
+
+		/* Are we ignoring a completed grace period? */
+		rcu_process_gp_end(rsp, rdp);
+		check_for_new_grace_period(rsp, rdp);
+
+		/* Start a new grace period if one not already started. */
+		if (!rcu_gp_in_progress(rsp)) {
+			unsigned long nestflag;
+			struct rcu_node *rnp_root = rcu_get_root(rsp);
+
+			raw_spin_lock_irqsave(&rnp_root->lock, nestflag);
+			rcu_start_gp(rsp, nestflag);  /* rlses rnp_root->lock */
+		} else {
+			/* Give the grace period a kick. */
+			rdp->blimit = LONG_MAX;
+			if (rsp->n_force_qs == rdp->n_force_qs_snap &&
+			    *rdp->nxttail[RCU_DONE_TAIL] != head)
+				force_quiescent_state(rsp, 0);
+			rdp->n_force_qs_snap = rsp->n_force_qs;
+			rdp->qlen_last_fqs_check = rdp->qlen;
+		}
 	} else if (ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies))
 		force_quiescent_state(rsp, 1);
 	local_irq_restore(flags);
-- 
1.7.3.2

