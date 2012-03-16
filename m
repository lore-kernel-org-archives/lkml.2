Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727Ab2CPH1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 03:27:47 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50754 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757159Ab2CPH1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 03:27:46 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18NNk17WiEN4vhHpf+NMTcD3H15BeLJhrVvN22cX8
	rODzOD8LTqWgwo
Message-ID: <1331882861.11010.13.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
From: Mike Galbraith <efault@gmx.de>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Fri, 16 Mar 2012 08:27:41 +0100
In-Reply-To: <20120315175933.GB8705@sgi.com>
References: <20120314002414.GA21561@linux.vnet.ibm.com>
	 <1331717099.5752.15.camel@marge.simpson.net>
	 <1331728841.7465.7.camel@marge.simpson.net>
	 <20120314130801.GA11722@sgi.com> <20120314151717.GA2435@linux.vnet.ibm.com>
	 <20120314165657.GA19117@linux.vnet.ibm.com>
	 <1331779343.14263.6.camel@marge.simpson.net>
	 <1331780831.14263.15.camel@marge.simpson.net>
	 <20120315175933.GB8705@sgi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 12:59 -0500, Dimitri Sivanich wrote: 
> On Thu, Mar 15, 2012 at 04:07:11AM +0100, Mike Galbraith wrote:
> > On Thu, 2012-03-15 at 03:42 +0100, Mike Galbraith wrote: 
> > > On Wed, 2012-03-14 at 09:56 -0700, Paul E. McKenney wrote:
> > > 
> > > > Does the following work better?  It does pass my fake-big-system tests
> > > > (more testing in the works).
> > > 
> > > Yup, tip booted fine.  Thanks!  I'll test, see if it gets upset.
> > 
> > Wedged into 3.0 enterprise booted fine too, is now running rcutorture.
> > I'll add hotplug after it runs explosion free for a while.  Any
> > suggestions for giving both virgin and 3.0 a thorough trouncing?
> 
> Mike,
> 
> Could I try your 3.0 enterprise patch?

Sure, v3 below.  Boots on my little boxen.

caveat: looks to me like it should be equivalent, but what I know about
RCUs gizzard will cover the bottom of a thimble.. maybe. 

rcu: Limit GP initialization to CPUs that have been online

The current grace-period initialization initializes all leaf rcu_node
structures, even those corresponding to CPUs that have never been online.
This is harmless in many configurations, but results in 200-microsecond
latency spikes for kernels built with NR_CPUS=4096.

This commit therefore keeps track of the largest-numbered CPU that has
ever been online, and limits grace-period initialization to rcu_node
structures corresponding to that CPU and to smaller-numbered CPUs.

Reported-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Mike Galbraith <mgalbraith@suse.de>

---
 kernel/rcutree.c |   24 +++++++++++++++++++++++-
 kernel/rcutree.h |   16 ++++++++++++++--
 2 files changed, 37 insertions(+), 3 deletions(-)

--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -84,6 +84,8 @@ DEFINE_PER_CPU(struct rcu_data, rcu_bh_d
 
 static struct rcu_state *rcu_state;
 
+int rcu_max_cpu __read_mostly;	/* Largest # CPU that has ever been online. */
+
 /*
  * The rcu_scheduler_active variable transitions from zero to one just
  * before the first task is spawned.  So when this variable is zero, RCU
@@ -935,7 +937,7 @@ static void rcu_report_qs_rsp(struct rcu
 		rsp->gp_max = gp_duration;
 	rsp->completed = rsp->gpnum;
 	rsp->signaled = RCU_GP_IDLE;
-	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
+	rcu_start_gp(rsp, flags);  /* releases root node's ->lock. */
 }
 
 /*
@@ -1862,6 +1864,7 @@ rcu_init_percpu_data(int cpu, struct rcu
 	unsigned long mask;
 	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp = rcu_get_root(rsp);
+	struct rcu_node *rnp_init;
 
 	/* Set up local state, ensuring consistent view of global state. */
 	raw_spin_lock_irqsave(&rnp->lock, flags);
@@ -1882,6 +1885,20 @@ rcu_init_percpu_data(int cpu, struct rcu
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
@@ -1907,6 +1924,11 @@ static void __cpuinit rcu_prepare_cpu(in
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



