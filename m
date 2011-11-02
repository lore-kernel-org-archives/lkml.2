Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab1KBNHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 09:07:44 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44547 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1KBNHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 09:07:42 -0400
Date: Wed, 2 Nov 2011 18:34:54 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venki Pallipadi <venki@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Idle balancer: cache align nohz structure to improve
 idle load balancing scalability
Message-ID: <20111102130453.GB6820@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1319060737.2604.38.camel@schen9-DESK>
 <m2wrc0xpbg.fsf@firstfloor.org>
 <CABeCy1a20npBt=4ee38zLH+6Fi7nfASd0dL3od6pOccV=LJDkA@mail.gmail.com>
 <4FF5AC937153B0459463C1A88EB478F20135D6ECB5@orsmsx505.amr.corp.intel.com>
 <1320191558.28097.44.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1320191558.28097.44.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11110213-6148-0000-0000-000000DFEE8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2011-11-01 16:52:38]:

> That is correct. So to minimize the global updates I did two things.

Another issue I am trying to solve with nohz balancer is stale-ness of
nohz.next_balance. As cpus enter/exit tickless state, nohz.next_balance
is not updated to reflect that. I have found that its a predominant source
of increased idle time with CFS bandwidth patches :

https://lkml.org/lkml/2011/9/26/162

While it may be costly to update nohz.next_balance during exit event,
I think we should update it upon entry. I am working on a patch to make
nohz.next_balance more precise. This requires tickless idle cpus to be tracked
in a global rb-tree (each tickless idle cpu is inserted in this tree,
indexed by its rq->next_balance). Having this rb-tree makes it easy to
precisely determine min(rq->next_balance) when a kick is deserved, which
I am hoping is good for both performance (on the dot wakeup) but also power 
(avoid unnecessary/early wakeup).

Draft patch is below. I was intending to post it soon along with some 
real-world benchmark numbers (based on matrix multiplication).

Any other suggestions to avoid this global rb-tree, but still keep
nohz.next_balance as precise as possible, would be welcome!

Not-yet-Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 Makefile                |    2 
 kernel/sched.c          |    9 ++
 kernel/sched_fair.c     |  185 +++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sched_idletask.c |    2 
 4 files changed, 179 insertions(+), 19 deletions(-)

Index: current/Makefile
===================================================================
--- current.orig/Makefile
+++ current/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 1
-SUBLEVEL = 0
+SUBLEVEL = 0-myp
 EXTRAVERSION =
 NAME = "Divemaster Edition"
 
Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -602,6 +602,7 @@ struct rq {
 #ifdef CONFIG_NO_HZ
 	u64 nohz_stamp;
 	unsigned char nohz_balance_kick;
+	struct rb_node nohz_node;
 #endif
 	int skip_clock_update;
 
@@ -1409,6 +1410,8 @@ static inline bool got_nohz_idle_kick(vo
 	return idle_cpu(smp_processor_id()) && this_rq()->nohz_balance_kick;
 }
 
+static void reset_first_second_pick_cpu(int cpu);
+
 #else /* CONFIG_NO_HZ */
 
 static inline bool got_nohz_idle_kick(void)
@@ -1416,6 +1419,8 @@ static inline bool got_nohz_idle_kick(vo
 	return false;
 }
 
+static inline void reset_first_second_pick_cpu(int cpu) { }
+
 #endif /* CONFIG_NO_HZ */
 
 static u64 sched_avg_period(void)
@@ -8299,6 +8304,7 @@ void __init sched_init(void)
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
 		rq->nohz_balance_kick = 0;
+		rb_init_node(&rq->nohz_node);
 #endif
 #endif
 		init_rq_hrtick(rq);
@@ -8344,10 +8350,13 @@ void __init sched_init(void)
 	zalloc_cpumask_var(&sched_domains_tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz.stale_idle_cpus_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
 	atomic_set(&nohz.load_balancer, nr_cpu_ids);
 	atomic_set(&nohz.first_pick_cpu, nr_cpu_ids);
 	atomic_set(&nohz.second_pick_cpu, nr_cpu_ids);
+	nohz.rq_next_balance = RB_ROOT;
+	spin_lock_init(&nohz.next_balance_lock);
 #endif
 	/* May be allocated at isolcpus cmdline parse time */
 	if (cpu_isolated_map == NULL)
Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -4285,7 +4285,11 @@ static struct {
 	atomic_t second_pick_cpu;
 	cpumask_var_t idle_cpus_mask;
 	cpumask_var_t grp_idle_mask;
+	cpumask_var_t stale_idle_cpus_mask;
 	unsigned long next_balance;     /* in jiffy units */
+	struct rb_root rq_next_balance;
+	struct rb_node *rb_leftmost;
+	spinlock_t next_balance_lock;
 } nohz ____cacheline_aligned;
 
 int get_nohz_load_balancer(void)
@@ -4427,8 +4431,12 @@ static void nohz_balancer_kick(int cpu)
 
 	ilb_cpu = get_nohz_load_balancer();
 
-	if (ilb_cpu >= nr_cpu_ids) {
-		ilb_cpu = cpumask_first(nohz.idle_cpus_mask);
+	/*
+	 * ilb_cpu itself can be attempting to kick another idle cpu. Pick
+	 * another idle cpu in that case.
+	 */
+	if (ilb_cpu >= nr_cpu_ids || ilb_cpu == cpu) {
+		ilb_cpu = cpumask_any_but(nohz.idle_cpus_mask, cpu);
 		if (ilb_cpu >= nr_cpu_ids)
 			return;
 	}
@@ -4449,6 +4457,122 @@ static void nohz_balancer_kick(int cpu)
 }
 
 /*
+ * Lazy dequeue of no-longer-tickless-idle cpu from rb-tree.
+ *
+ * This is done lazily, as otherwise taking a spinlock (nohz.next_balance_lock)
+ * to do immediate update of rb-tree can slowdown transition out of tickless
+ * state (and thus may hurt scheduling latencies for a task waking on a tickless
+ * idle cpu).
+ */
+static void __dequeue_nohz_idle_cpu(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu), *entry;
+
+	WARN_ON(RB_EMPTY_NODE(&rq->nohz_node));
+
+	if (nohz.rb_leftmost == &rq->nohz_node) {
+		struct rb_node *next_node;
+
+		next_node = rb_next(&rq->nohz_node);
+		nohz.rb_leftmost = next_node;
+		if (next_node) {
+			entry = rb_entry(next_node, struct rq, nohz_node);
+
+			nohz.next_balance = entry->next_balance;
+		}
+	}
+
+	rb_erase(&rq->nohz_node, &nohz.rq_next_balance);
+	RB_CLEAR_NODE(&rq->nohz_node);
+}
+
+static void __enqueue_nohz_idle_cpu(int cpu)
+{
+	struct rb_node **link = &nohz.rq_next_balance.rb_node;
+	struct rb_node *parent = NULL;
+	struct rq *entry;
+	struct rq *rq = cpu_rq(cpu);
+	int leftmost = 1;
+
+	/*
+	 * Find the right place in the rbtree:
+	 */
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct rq, nohz_node);
+		/*
+		 * We dont care about collisions. Nodes with
+		 * the same key stay together.
+		 */
+		if (time_before(rq->next_balance, entry->next_balance)) {
+			link = &parent->rb_left;
+		} else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	/*
+	 * Maintain a cache of leftmost tree entries (it is frequently
+	 * used):
+	 */
+	if (leftmost) {
+		nohz.rb_leftmost = &rq->nohz_node;
+		nohz.next_balance = rq->next_balance;
+	}
+
+	rb_link_node(&rq->nohz_node, parent, link);
+	rb_insert_color(&rq->nohz_node, &nohz.rq_next_balance);
+}
+
+static void __clear_stale_nohz_idle_cpus(void)
+{
+	int stale_idle_cpu;
+
+	for_each_cpu(stale_idle_cpu, nohz.stale_idle_cpus_mask) {
+		__dequeue_nohz_idle_cpu(stale_idle_cpu);
+		cpumask_clear_cpu(stale_idle_cpu, nohz.stale_idle_cpus_mask);
+	}
+}
+
+/*
+ * Remove no-longer-tickless-idle cpus from rb-tree.
+ */
+static void clear_stale_nohz_idle_cpus(void)
+{
+	spin_lock(&nohz.next_balance_lock);
+	__clear_stale_nohz_idle_cpus();
+	spin_unlock(&nohz.next_balance_lock);
+}
+
+/*
+ * Enqueue a idle cpu going tickless in a rb-tree, indexed by its
+ * rq->next_balance value.
+ */
+static void enqueue_nohz_idle_cpu(int cpu)
+{
+	spin_lock(&nohz.next_balance_lock);
+	if (cpumask_test_cpu(cpu, nohz.stale_idle_cpus_mask)) {
+		__dequeue_nohz_idle_cpu(cpu);
+		cpumask_clear_cpu(cpu, nohz.stale_idle_cpus_mask);
+	}
+	__enqueue_nohz_idle_cpu(cpu);
+	spin_unlock(&nohz.next_balance_lock);
+}
+
+/*
+ * Dequeue and enqueue a tickless idle cpu indexed at its new rq->next_balance
+ * value.
+ */
+static void re_enqueue_nohz_idle_cpu(int cpu)
+{
+	spin_lock(&nohz.next_balance_lock);
+	__dequeue_nohz_idle_cpu(cpu);
+	__enqueue_nohz_idle_cpu(cpu);
+	spin_unlock(&nohz.next_balance_lock);
+}
+
+/*
  * This routine will try to nominate the ilb (idle load balancing)
  * owner among the cpus whose ticks are stopped. ilb owner will do the idle
  * load balancing on behalf of all those cpus.
@@ -4481,12 +4605,9 @@ void select_nohz_load_balancer(int stop_
 			return;
 		}
 
-		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
+		enqueue_nohz_idle_cpu(cpu);
 
-		if (atomic_read(&nohz.first_pick_cpu) == cpu)
-			atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
-		if (atomic_read(&nohz.second_pick_cpu) == cpu)
-			atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
+		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
 
 		if (atomic_read(&nohz.load_balancer) >= nr_cpu_ids) {
 			int new_ilb;
@@ -4512,6 +4633,7 @@ void select_nohz_load_balancer(int stop_
 		if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
 			return;
 
+		cpumask_set_cpu(cpu, nohz.stale_idle_cpus_mask);
 		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
 
 		if (atomic_read(&nohz.load_balancer) == cpu)
@@ -4622,10 +4744,20 @@ static void nohz_idle_balance(int this_c
 	struct rq *this_rq = cpu_rq(this_cpu);
 	struct rq *rq;
 	int balance_cpu;
+	unsigned long old_next_balance;
 
-	if (idle != CPU_IDLE || !this_rq->nohz_balance_kick)
+	if (!this_rq->nohz_balance_kick)
 		return;
 
+	/* Wakeup another idle cpu to do idle load balance if we got busy */
+	if (!idle_cpu(this_cpu)) {
+		nohz_balancer_kick(this_cpu);
+		goto out;
+	}
+
+	/* Remove no-longer-tickless-idle cpus from rb-tree */
+	clear_stale_nohz_idle_cpus();
+
 	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
 		if (balance_cpu == this_cpu)
 			continue;
@@ -4636,8 +4768,8 @@ static void nohz_idle_balance(int this_c
 		 * balancing owner will pick it up.
 		 */
 		if (need_resched()) {
-			this_rq->nohz_balance_kick = 0;
-			break;
+			nohz_balancer_kick(this_cpu);
+			goto out;
 		}
 
 		raw_spin_lock_irq(&this_rq->lock);
@@ -4645,13 +4777,15 @@ static void nohz_idle_balance(int this_c
 		update_cpu_load(this_rq);
 		raw_spin_unlock_irq(&this_rq->lock);
 
-		rebalance_domains(balance_cpu, CPU_IDLE);
-
 		rq = cpu_rq(balance_cpu);
-		if (time_after(this_rq->next_balance, rq->next_balance))
-			this_rq->next_balance = rq->next_balance;
+		old_next_balance = rq->next_balance;
+		if (time_after_eq(jiffies, old_next_balance)) {
+			rebalance_domains(balance_cpu, CPU_IDLE);
+			if (rq->next_balance != old_next_balance)
+				re_enqueue_nohz_idle_cpu(balance_cpu);
+		}
 	}
-	nohz.next_balance = this_rq->next_balance;
+out:
 	this_rq->nohz_balance_kick = 0;
 }
 
@@ -4700,9 +4834,24 @@ static inline int nohz_kick_needed(struc
 	}
 	return 0;
 }
-#else
+
+/*
+ * Reset first_pick_cpu or second_pick_cpu identifier in case
+ * corresponding cpu is going idle.
+ */
+static void reset_first_second_pick_cpu(int cpu)
+{
+	if (atomic_read(&nohz.first_pick_cpu) == cpu)
+		atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
+	if (atomic_read(&nohz.second_pick_cpu) == cpu)
+		atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
+}
+
+#else	/* CONFIG_NO_HZ */
+
 static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
-#endif
+
+#endif	/* CONFIG_NO_HZ */
 
 /*
  * run_rebalance_domains is triggered when needed from the scheduler tick.
@@ -4740,7 +4889,7 @@ static inline void trigger_load_balance(
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
 #ifdef CONFIG_NO_HZ
-	else if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
 		nohz_balancer_kick(cpu);
 #endif
 }
Index: current/kernel/sched_idletask.c
===================================================================
--- current.orig/kernel/sched_idletask.c
+++ current/kernel/sched_idletask.c
@@ -24,6 +24,8 @@ static struct task_struct *pick_next_tas
 {
 	schedstat_inc(rq, sched_goidle);
 	calc_load_account_idle(rq);
+	reset_first_second_pick_cpu(cpu_of(rq));
+
 	return rq->idle;
 }
 

