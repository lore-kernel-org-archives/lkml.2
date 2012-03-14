Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030741Ab2CNJZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 05:25:10 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57377 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030703Ab2CNJZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 05:25:05 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19F7qEMcNpF2ru55YGH8SIfkkoKJCbmQqniTb6bj1
	X9DiXVjMA0ELq9
Message-ID: <1331717099.5752.15.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: sivanich@sgi.com, linux-kernel@vger.kernel.org
Date: Wed, 14 Mar 2012 10:24:59 +0100
In-Reply-To: <20120314002414.GA21561@linux.vnet.ibm.com>
References: <20120314002414.GA21561@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 17:24 -0700, Paul E. McKenney wrote: 
> The following builds, but is only very lightly tested.  Probably full
> of bug, especially when exercising CPU hotplug.

You didn't say RFT, but...

To beat on this in a rotund 3.0 kernel, the equivalent patch would be
the below?  My box may well answer that before you can.. hope not ;-) 

---
 kernel/rcutree.c |   31 ++++++++++++++++++++++++++-----
 kernel/rcutree.h |    6 ++++--
 2 files changed, 30 insertions(+), 7 deletions(-)

--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -84,6 +84,8 @@ DEFINE_PER_CPU(struct rcu_data, rcu_bh_d
 
 static struct rcu_state *rcu_state;
 
+int rcu_max_cpu __read_mostly;	/* Largest # CPU that has ever been online. */
+
 /*
  * The rcu_scheduler_active variable transitions from zero to one just
  * before the first task is spawned.  So when this variable is zero, RCU
@@ -827,25 +829,31 @@ rcu_start_gp(struct rcu_state *rsp, unsi
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	if (!cpu_needs_another_gp(rsp, rdp) || rsp->fqs_active) {
+		struct rcu_node *rnp_root = rnp;
+
 		if (cpu_needs_another_gp(rsp, rdp))
 			rsp->fqs_need_gp = 1;
-		if (rnp->completed == rsp->completed) {
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		if (rnp_root->completed == rsp->completed) {
+			raw_spin_unlock_irqrestore(&rnp_root->lock, flags);
 			return;
 		}
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
 			rnp->completed = rsp->completed;
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			raw_spin_lock(&rnp_root->lock); /* already disabled. */
 		}
-		local_irq_restore(flags);
+		raw_spin_unlock_irqrestore(&rnp_root->lock, flags);
 		return;
 	}
 
@@ -935,7 +943,7 @@ static void rcu_report_qs_rsp(struct rcu
 		rsp->gp_max = gp_duration;
 	rsp->completed = rsp->gpnum;
 	rsp->signaled = RCU_GP_IDLE;
-	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
+	rcu_start_gp(rsp, flags);  /* releases root node's ->lock. */
 }
 
 /*
@@ -1862,6 +1870,7 @@ rcu_init_percpu_data(int cpu, struct rcu
 	unsigned long mask;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp = rcu_get_root(rsp);
+	struct rcu_node *rnp_init;
 
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
@@ -1882,6 +1891,16 @@ rcu_init_percpu_data(int cpu, struct rcu
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
@@ -1907,6 +1926,8 @@ static void __cpuinit rcu_prepare_cpu(in
 	rcu_init_percpu_data(cpu, &rcu_sched_state, 0);
 	rcu_init_percpu_data(cpu, &rcu_bh_state, 0);
 	rcu_preempt_init_percpu_data(cpu);
+	if (cpu > rcu_max_cpu)
+		rcu_max_cpu = cpu;
 }
 
 /*
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -191,11 +191,13 @@ struct rcu_node {
 
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


