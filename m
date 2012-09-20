Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab2ITSwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:52:47 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40355 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab2ITStW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:49:22 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/23] rcu: Prevent force_quiescent_state() memory contention
Date: Thu, 20 Sep 2012 11:48:09 -0700
Message-Id: <1348166900-18716-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120920184751.GA18657@linux.vnet.ibm.com>
 <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
x-cbid: 12092018-1976-0000-0000-00001191520E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Large systems running RCU_FAST_NO_HZ kernels see extreme memory
contention on the rcu_state structure's ->fqslock field.  This
can be avoided by disabling RCU_FAST_NO_HZ, either at compile time
or at boot time (via the nohz kernel boot parameter), but large
systems will no doubt become sensitive to energy consumption.
This commit therefore uses a combining-tree approach to spread the
memory contention across new cache lines in the leaf rcu_node structures.
This can be thought of as a tournament lock that has only a try-lock
acquisition primitive.

The effect on small systems is minimal, because such systems have
an rcu_node "tree" consisting of a single node.  In addition, this
functionality is not used on fastpaths.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c |   47 +++++++++++++++++++++++++++++++++++++----------
 kernel/rcutree.h |    1 +
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b353d32..5edbdf8 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -61,6 +61,7 @@
 /* Data structures. */
 
 static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
+static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 
 #define RCU_STATE_INITIALIZER(sname, cr) { \
 	.level = { &sname##_state.node[0] }, \
@@ -1805,16 +1806,35 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 static void force_quiescent_state(struct rcu_state *rsp)
 {
 	unsigned long flags;
-	struct rcu_node *rnp = rcu_get_root(rsp);
+	bool ret;
+	struct rcu_node *rnp;
+	struct rcu_node *rnp_old = NULL;
+
+	/* Funnel through hierarchy to reduce memory contention. */
+	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
+	for (; rnp != NULL; rnp = rnp->parent) {
+		ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
+		      !raw_spin_trylock(&rnp->fqslock);
+		if (rnp_old != NULL)
+			raw_spin_unlock(&rnp_old->fqslock);
+		if (ret) {
+			rsp->n_force_qs_lh++;
+			return;
+		}
+		rnp_old = rnp;
+	}
+	/* rnp_old == rcu_get_root(rsp), rnp == NULL. */
 
-	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS)
+	/* Reached the root of the rcu_node tree, acquire lock. */
+	raw_spin_lock_irqsave(&rnp_old->lock, flags);
+	raw_spin_unlock(&rnp_old->fqslock);
+	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
+		rsp->n_force_qs_lh++;
+		raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 		return;  /* Someone beat us to it. */
-	if (!raw_spin_trylock_irqsave(&rnp->lock, flags)) {
-		rsp->n_force_qs_lh++; /* Inexact, can lose counts.  Tough! */
-		return;
 	}
 	rsp->gp_flags |= RCU_GP_FLAG_FQS;
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
 }
 
@@ -2702,10 +2722,14 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 static void __init rcu_init_one(struct rcu_state *rsp,
 		struct rcu_data __percpu *rda)
 {
-	static char *buf[] = { "rcu_node_level_0",
-			       "rcu_node_level_1",
-			       "rcu_node_level_2",
-			       "rcu_node_level_3" };  /* Match MAX_RCU_LVLS */
+	static char *buf[] = { "rcu_node_0",
+			       "rcu_node_1",
+			       "rcu_node_2",
+			       "rcu_node_3" };  /* Match MAX_RCU_LVLS */
+	static char *fqs[] = { "rcu_node_fqs_0",
+			       "rcu_node_fqs_1",
+			       "rcu_node_fqs_2",
+			       "rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
 	int cpustride = 1;
 	int i;
 	int j;
@@ -2730,6 +2754,9 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 			raw_spin_lock_init(&rnp->lock);
 			lockdep_set_class_and_name(&rnp->lock,
 						   &rcu_node_class[i], buf[i]);
+			raw_spin_lock_init(&rnp->fqslock);
+			lockdep_set_class_and_name(&rnp->fqslock,
+						   &rcu_fqs_class[i], fqs[i]);
 			rnp->gpnum = 0;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 7fb93ce..8f0293c 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -202,6 +202,7 @@ struct rcu_node {
 				/*  per-CPU kthreads as needed. */
 	unsigned int node_kthread_status;
 				/* State of node_kthread_task for tracing. */
+	raw_spinlock_t fqslock ____cacheline_internodealigned_in_smp;
 } ____cacheline_internodealigned_in_smp;
 
 /*
-- 
1.7.8

