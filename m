Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab2CNAYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:24:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:54422 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2CNAYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:24:19 -0400
Date: Tue, 13 Mar 2012 17:24:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sivanich@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
Message-ID: <20120314002414.GA21561@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031400-7282-0000-0000-000007569B1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following builds, but is only very lightly tested.  Probably full
of bug, especially when exercising CPU hotplug.

							Thanx, Paul

------------------------------------------------------------------------

The current grace-period initialization initializes all leaf rcu_node
structures, even those corresponding to CPUs that have never been online.
This is harmless in many configurations, but results in 200-microsecond
latency spikes for kernels built with NR_CPUS=4096.

This commit therefore keeps track of the largest-numbered CPU that has
ever been online, and limits grace-period initialization to rcu_node
structures corresponding to that CPU and to smaller-numbered CPUs.

Reported-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c3b05ef..5688443 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -91,6 +91,8 @@ DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
 static struct rcu_state *rcu_state;
 
+int rcu_max_cpu __read_mostly;	/* Largest # CPU that has ever been online. */
+
 /*
  * The rcu_scheduler_active variable transitions from zero to one just
  * before the first task is spawned.  So when this variable is zero, RCU
@@ -1129,8 +1131,9 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
 {
 	unsigned long gp_duration;
-	struct rcu_node *rnp = rcu_get_root(rsp);
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
+	struct rcu_node *rnp;
+	struct rcu_node *rnp_root = rcu_get_root(rsp);
 
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 
@@ -1159,26 +1162,28 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	 * completed.
 	 */
 	if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
-		raw_spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
 
 		/*
 		 * Propagate new ->completed value to rcu_node structures
 		 * so that other CPUs don't have to wait until the start
 		 * of the next grace period to process their callbacks.
+		 * We must hold the root rcu_node structure's ->lock
+		 * across rcu_for_each_node_breadth_first() in order to
+		 * synchronize with CPUs coming online for the first time.
 		 */
 		rcu_for_each_node_breadth_first(rsp, rnp) {
+			raw_spin_unlock(&rnp_root->lock); /* remain disabled. */
 			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
 			rnp->completed = rsp->gpnum;
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			raw_spin_lock(&rnp_root->lock); /* already disabled. */
 		}
-		rnp = rcu_get_root(rsp);
-		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
 	}
 
 	rsp->completed = rsp->gpnum;  /* Declare the grace period complete. */
 	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
 	rsp->fqs_state = RCU_GP_IDLE;
-	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
+	rcu_start_gp(rsp, flags);  /* releases root node's ->lock. */
 }
 
 /*
@@ -2440,6 +2445,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	unsigned long mask;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp = rcu_get_root(rsp);
+	struct rcu_node *rnp_init;
 
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
@@ -2462,6 +2468,16 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	/* Exclude any attempts to start a new GP on large systems. */
 	raw_spin_lock(&rsp->onofflock);		/* irqs already disabled. */
 
+	/* Initialize any rcu_node structures that will see their first use. */
+	raw_spin_lock(&rnp->lock);		/* irqs already disabled. */
+	for (rnp_init = per_cpu_ptr(rsp->rda, rcu_max_cpu)->mynode + 1;
+	     rnp_init <= rdp->mynode;
+	     rnp_init++) {
+		rnp_init->gpnum = rsp->gpnum;
+		rnp_init->completed = rsp->completed;
+	}
+	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
+
 	/* Add CPU to rcu_node bitmasks. */
 	rnp = rdp->mynode;
 	mask = rdp->grpmask;
@@ -2495,6 +2511,8 @@ static void __cpuinit rcu_prepare_cpu(int cpu)
 	rcu_init_percpu_data(cpu, &rcu_sched_state, 0);
 	rcu_init_percpu_data(cpu, &rcu_bh_state, 0);
 	rcu_preempt_init_percpu_data(cpu);
+	if (cpu > rcu_max_cpu)
+		rcu_max_cpu = cpu;
 }
 
 /*
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 1e49c56..1dc74e0 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -192,11 +192,13 @@ struct rcu_node {
 
 /*
  * Do a full breadth-first scan of the rcu_node structures for the
- * specified rcu_state structure.
+ * specified rcu_state structure.  The caller must hold either the
+ * ->onofflock or the root rcu_node structure's ->lock.
  */
+extern int rcu_max_cpu;
 #define rcu_for_each_node_breadth_first(rsp, rnp) \
 	for ((rnp) = &(rsp)->node[0]; \
-	     (rnp) < &(rsp)->node[NUM_RCU_NODES]; (rnp)++)
+	     (rnp) < per_cpu_ptr((rsp)->rda, rcu_max_cpu)->mynode; (rnp)++)
 
 /*
  * Do a breadth-first scan of the non-leaf rcu_node structures for the

