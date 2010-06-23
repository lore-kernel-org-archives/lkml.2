Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0FWKFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:05:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62821 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab0FWKEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:51 -0400
Message-ID: <4C21DC37.9040503@cn.fujitsu.com>
Date: Wed, 23 Jun 2010 18:04:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] rcu: simplify the usage of percpu data
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the "rda[NR_CPUS]" array and remove RCU_INIT_FLAVOR()

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 rcutree.c        |   42 +++++++++++++++---------------------------
 rcutree.h        |    2 +-
 rcutree_plugin.h |    4 ++--
 3 files changed, 18 insertions(+), 30 deletions(-)
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d5bc439..651b09d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -712,7 +712,7 @@ static void
 rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
 {
-	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
+	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, smp_processor_id());
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	if (!cpu_needs_another_gp(rsp, rdp) || rsp->fqs_active) {
@@ -960,7 +960,7 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
 {
 	int i;
-	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
+	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, smp_processor_id());
 
 	if (rdp->nxtlist == NULL)
 		return;  /* irqs disabled, so comparison is stable. */
@@ -984,7 +984,7 @@ static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 	struct rcu_data *rdp;
 
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
-	rdp = rsp->rda[smp_processor_id()];
+	rdp = per_cpu_ptr(rsp->rda, smp_processor_id());
 	if (rsp->orphan_cbs_list == NULL) {
 		raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 		return;
@@ -1007,7 +1007,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	unsigned long flags;
 	unsigned long mask;
 	int need_report = 0;
-	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp;
 
 	/* Exclude any attempts to start a new grace period. */
@@ -1226,7 +1226,8 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 		cpu = rnp->grplo;
 		bit = 1;
 		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
-			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
+			if ((rnp->qsmask & bit) != 0 &&
+			    f(per_cpu_ptr(rsp->rda, cpu)))
 				mask |= bit;
 		}
 		if (mask != 0) {
@@ -1402,7 +1403,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	 * a quiescent state betweentimes.
 	 */
 	local_irq_save(flags);
-	rdp = rsp->rda[smp_processor_id()];
+	rdp = per_cpu_ptr(rsp->rda, smp_processor_id());
 	rcu_process_gp_end(rsp, rdp);
 	check_for_new_grace_period(rsp, rdp);
 
@@ -1701,7 +1702,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
 	int i;
-	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Set up local state, ensuring consistent view of global state. */
@@ -1729,7 +1730,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 {
 	unsigned long flags;
 	unsigned long mask;
-	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Set up local state, ensuring consistent view of global state. */
@@ -1865,7 +1866,8 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 /*
  * Helper function for rcu_init() that initializes one rcu_state structure.
  */
-static void __init rcu_init_one(struct rcu_state *rsp)
+static void __init rcu_init_one(struct rcu_state *rsp,
+		struct rcu_data __percpu *rda)
 {
 	static char *buf[] = { "rcu_node_level_0",
 			       "rcu_node_level_1",
@@ -1918,37 +1920,23 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 		}
 	}
 
+	rsp->rda = rda;
 	rnp = rsp->level[NUM_RCU_LVLS - 1];
 	for_each_possible_cpu(i) {
 		while (i > rnp->grphi)
 			rnp++;
-		rsp->rda[i]->mynode = rnp;
+		per_cpu_ptr(rsp->rda, i)->mynode = rnp;
 		rcu_boot_init_percpu_data(i, rsp);
 	}
 }
 
-/*
- * Helper macro for __rcu_init() and __rcu_init_preempt().  To be used
- * nowhere else!  Assigns leaf node pointers into each CPU's rcu_data
- * structure.
- */
-#define RCU_INIT_FLAVOR(rsp, rcu_data) \
-do { \
-	int i; \
-	\
-	for_each_possible_cpu(i) { \
-		(rsp)->rda[i] = &per_cpu(rcu_data, i); \
-	} \
-	rcu_init_one(rsp); \
-} while (0)
-
 void __init rcu_init(void)
 {
 	int cpu;
 
 	rcu_bootup_announce();
-	RCU_INIT_FLAVOR(&rcu_sched_state, rcu_sched_data);
-	RCU_INIT_FLAVOR(&rcu_bh_state, rcu_bh_data);
+	rcu_init_one(&rcu_sched_state, percpu_variable_ptr(rcu_sched_data));
+	rcu_init_one(&rcu_bh_state, percpu_variable_ptr(rcu_bh_data));
 	__rcu_init_preempt();
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 14c040b..5ce197e 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -283,7 +283,7 @@ struct rcu_state {
 	struct rcu_node *level[NUM_RCU_LVLS];	/* Hierarchy levels. */
 	u32 levelcnt[MAX_RCU_LVLS + 1];		/* # nodes in each level. */
 	u8 levelspread[NUM_RCU_LVLS];		/* kids/node in each level. */
-	struct rcu_data *rda[NR_CPUS];		/* array of rdp pointers. */
+	struct rcu_data __percpu *rda;		/* pointer of percu rcu_data. */
 
 	/* The following fields are guarded by the root rcu_node's lock. */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 0e4f420..63a2a40 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -154,7 +154,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
-		rdp = rcu_preempt_state.rda[cpu];
+		rdp = per_cpu_ptr(rcu_preempt_state.rda, cpu);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
@@ -771,7 +771,7 @@ static void rcu_preempt_send_cbs_to_orphanage(void)
  */
 static void __init __rcu_init_preempt(void)
 {
-	RCU_INIT_FLAVOR(&rcu_preempt_state, rcu_preempt_data);
+	rcu_init_one(&rcu_preempt_state, percpu_variable_ptr(rcu_preempt_data));
 }
 
 /*

