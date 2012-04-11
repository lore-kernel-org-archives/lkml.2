Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab2DKLEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:04:44 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35588 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752594Ab2DKLEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:04:43 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/iKbssXSriSWOY4lthQzpixNGGaZmRIRe3lbWI0+
	gBlcbGaGXS48uz
Message-ID: <1334142276.5826.22.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org
Date: Wed, 11 Apr 2012 13:04:36 +0200
In-Reply-To: <20120323192335.GZ2450@linux.vnet.ibm.com>
References: <1331779343.14263.6.camel@marge.simpson.net>
	 <1331780831.14263.15.camel@marge.simpson.net>
	 <20120315175933.GB8705@sgi.com>
	 <1331882861.11010.13.camel@marge.simpson.net>
	 <1331885384.11010.15.camel@marge.simpson.net>
	 <1331887535.11010.18.camel@marge.simpson.net>
	 <20120316172850.GC31290@sgi.com>
	 <1332430533.11517.75.camel@marge.simpson.net>
	 <20120322202418.GA8569@sgi.com>
	 <1332478086.5721.17.camel@marge.simpson.net>
	 <20120323192335.GZ2450@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-23 at 12:23 -0700, Paul E. McKenney wrote:
> On Fri, Mar 23, 2012 at 05:48:06AM +0100, Mike Galbraith wrote:
> > On Thu, 2012-03-22 at 15:24 -0500, Dimitri Sivanich wrote: 
> > > On Thu, Mar 22, 2012 at 04:35:33PM +0100, Mike Galbraith wrote:

> > > > Care to try this?  There's likely a better way to defeat ->qsmask == 0
> > > > take/release all locks thingy, however, if Paul can safely bail in
> > > > force_qs_rnp() in tweakable latency for big boxen patch, I should be
> > > > able to safely (and shamelessly) steal that, and should someone hotplug
> > > > a CPU, and we race, do the same thing bail for small boxen.
> > > 
> > > Tested on a 48 cpu UV system with an interrupt latency test on isolated
> > > cpus and a moderate to heavy load on the rest of the system.
> > > 
> > > This patch appears to take care of all excessive (> 35 usec) RCU-based
> > > latency in the 3.0 kernel on this particular system for this particular
> > > setup.  Without the patch, I see many latencies on this system > 150 usec
> > > (and some > 200 usec).
> > 
> > Figures.  I bet Paul has a better idea though.  Too bad we can't whack
> > those extra barriers, that would likely wipe RCU from your radar.
> 
> Sorry for the silence -- was hit by the germs going around.  I do have
> some concerns about some of the code, but very much appreciate the two
> of you continuing on this in my absence!

Hi Paul (and Dimitri),

Just got back to this.  I changed the patch around to check for a
hotplug event in force_qs_rnp(), and should that happen, process any
freshly added CPUs immediately rather than tell the caller to restart
from scratch.  The rest of the delta is cosmetic, and there should be
zero performance change.

Does this change address any of your concerns? 

---
 kernel/rcutree.c |   71 +++++++++++++++++++++++++++++++++++++++++++++----------
 kernel/rcutree.h |   16 ++++++++++--
 2 files changed, 73 insertions(+), 14 deletions(-)

--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -84,6 +84,8 @@ DEFINE_PER_CPU(struct rcu_data, rcu_bh_d
 
 static struct rcu_state *rcu_state;
 
+int rcu_max_cpu __read_mostly;	/* Largest # CPU that has ever been online. */
+
 /*
  * The rcu_scheduler_active variable transitions from zero to one just
  * before the first task is spawned.  So when this variable is zero, RCU
@@ -827,25 +829,33 @@ rcu_start_gp(struct rcu_state *rsp, unsi
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	if (!cpu_needs_another_gp(rsp, rdp) || rsp->fqs_active) {
+		struct rcu_node *rnp_root = rnp;
+
 		if (cpu_needs_another_gp(rsp, rdp))
 			rsp->fqs_need_gp = 1;
 		if (rnp->completed == rsp->completed) {
-			raw_spin_unlock_irqrestore(&rnp->lock, flags);
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
+			if (rnp == rnp_root) {
+				rnp->completed = rsp->completed;
+				continue;
+			}
 			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
 			rnp->completed = rsp->completed;
 			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		}
-		local_irq_restore(flags);
+		raw_spin_unlock_irqrestore(&rnp_root->lock, flags);
 		return;
 	}
 
@@ -935,7 +945,7 @@ static void rcu_report_qs_rsp(struct rcu
 		rsp->gp_max = gp_duration;
 	rsp->completed = rsp->gpnum;
 	rsp->signaled = RCU_GP_IDLE;
-	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
+	rcu_start_gp(rsp, flags);  /* releases root node's ->lock. */
 }
 
 /*
@@ -1313,13 +1323,18 @@ void rcu_check_callbacks(int cpu, int us
 static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 {
 	unsigned long bit;
-	int cpu;
+	int cpu, max_cpu = rcu_max_cpu, next = 0;
 	unsigned long flags;
 	unsigned long mask;
 	struct rcu_node *rnp;
 
+cpus_hotplugged:
 	rcu_for_each_leaf_node(rsp, rnp) {
-		mask = 0;
+		if (rnp->grplo > max_cpu)
+			break;
+		if(rnp->grphi < next)
+			continue;
+
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		if (!rcu_gp_in_progress(rsp)) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
@@ -1330,14 +1345,16 @@ static void force_qs_rnp(struct rcu_stat
 			continue;
 		}
 		cpu = rnp->grplo;
-		bit = 1;
-		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
+		if (unlikely(cpu < next))
+			cpu = next;
+		for (bit = 1, mask = 0; cpu <= rnp->grphi; cpu++, bit <<= 1) {
+			if (cpu > max_cpu)
+				break;
 			if ((rnp->qsmask & bit) != 0 &&
 			    f(per_cpu_ptr(rsp->rda, cpu)))
 				mask |= bit;
 		}
 		if (mask != 0) {
-
 			/* rcu_report_qs_rnp() releases rnp->lock. */
 			rcu_report_qs_rnp(mask, rsp, rnp, flags);
 			continue;
@@ -1345,10 +1362,20 @@ static void force_qs_rnp(struct rcu_stat
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 	rnp = rcu_get_root(rsp);
-	if (rnp->qsmask == 0) {
-		raw_spin_lock_irqsave(&rnp->lock, flags);
-		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+
+	/* Handle unlikely intervening hotplug event. */
+	next = ++max_cpu;
+	max_cpu = rcu_get_max_cpu();
+	if (unlikely(next <= max_cpu)) {
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		goto cpus_hotplugged;
 	}
+
+	if (rnp->qsmask == 0)
+		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
+	else
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -1862,6 +1889,7 @@ rcu_init_percpu_data(int cpu, struct rcu
 	unsigned long mask;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp = rcu_get_root(rsp);
+	struct rcu_node *rnp_init;
 
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
@@ -1882,6 +1910,20 @@ rcu_init_percpu_data(int cpu, struct rcu
 	/* Exclude any attempts to start a new GP on large systems. */
 	raw_spin_lock(&rsp->onofflock);		/* irqs already disabled. */
 
+	/*
+	 * Initialize any rcu_node structures that will see their first use.
+	 * Note that rcu_max_cpu cannot change out from under us because the
+	 * hotplug locks are held.
+	 */
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
@@ -1907,6 +1949,11 @@ static void __cpuinit rcu_prepare_cpu(in
 	rcu_init_percpu_data(cpu, &rcu_sched_state, 0);
 	rcu_init_percpu_data(cpu, &rcu_bh_state, 0);
 	rcu_preempt_init_percpu_data(cpu);
+	if (cpu > rcu_max_cpu) {
+		smp_mb(); /* Initialization before rcu_max_cpu assignment. */
+		rcu_max_cpu = cpu;
+		smp_mb(); /* rcu_max_cpu assignment before later uses. */
+	}
 }
 
 /*
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -191,11 +191,23 @@ struct rcu_node {
 
 /*
  * Do a full breadth-first scan of the rcu_node structures for the
- * specified rcu_state structure.
+ * specified rcu_state structure.  The caller must hold either the
+ * ->onofflock or the root rcu_node structure's ->lock.
  */
+extern int rcu_max_cpu;
+static inline int rcu_get_max_cpu(void)
+{
+	int ret;
+
+	smp_mb();  /* Pairs with barriers in rcu_prepare_cpu(). */
+	ret = rcu_max_cpu;
+	smp_mb();  /* Pairs with barriers in rcu_prepare_cpu(). */
+	return ret;
+}
 #define rcu_for_each_node_breadth_first(rsp, rnp) \
 	for ((rnp) = &(rsp)->node[0]; \
-	     (rnp) < &(rsp)->node[NUM_RCU_NODES]; (rnp)++)
+	     (rnp) <= per_cpu_ptr((rsp)->rda, rcu_get_max_cpu())->mynode; \
+	     (rnp)++)
 
 /*
  * Do a breadth-first scan of the non-leaf rcu_node structures for the


