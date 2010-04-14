Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0DNALF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:11:05 -0400
Received: from smtp-out.google.com ([74.125.121.35]:57145 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab0DNALA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:11:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=V07GFHbEm0W6wrd+du7YPuzdCGRuVmZcQ44SxCkHcfuzTAmLXQYzpba3mXJwcLieD
	6E/Rias5dIddh/E/ckSxQ==
Subject: [PATCH 3/3] [kidled]: Introduce power capping priority and LB
	awareness.
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       linux-pm@lists.linux-foundation.org, arjan@infradead.org
From: Salman <sqazi@google.com>
Cc: csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
Date: Tue, 13 Apr 2010 17:08:56 -0700
Message-ID: <20100414000848.29004.91509.stgit@bumblebee1.mtv.corp.google.com>
In-Reply-To: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Salman Qazi <sqazi@google.com>

0) Power Capping Priority:

After we finish a lazy injection, we look at the task groups in the order
of increasing priority.  For each task group, we attempt to assign
as much vruntime as possible, to cover the time that was spent doing
the lazy injection.  Within each priority, we round-robin between the
task group between different invocations to make sure that we don't
consistently penalize the same one.

The priorities themselves are specified through the value
cpu.power_capping_priority in the parent CPU cgroup of the tasks.

1) Load balancer awareness

Idle cycle injector is an RT thread.  A consequence is that from the load
balancer's point of view, it is a particularly heavy thread.  While
we appreciate the ability to preempt any CFS threads, it is useful
to have a lesser weight: as a heavy weight makes an injected CPU
disproportionately less desirable than other CPUs.  We provide this
by faking the weight of the idle cycle injector to be equivalent to
a CFS thread of a user controllable nice value.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 Documentation/kidled.txt |   38 ++++++++++++++++++++++-
 include/linux/kidled.h   |    6 ++++
 kernel/kidled.c          |    2 +
 kernel/sched.c           |   75 +++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched_fair.c      |   77 +++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 192 insertions(+), 6 deletions(-)

diff --git a/Documentation/kidled.txt b/Documentation/kidled.txt
index 564aa00..400b97b 100644
--- a/Documentation/kidled.txt
+++ b/Documentation/kidled.txt
@@ -6,7 +6,7 @@ Overview:
 Provides a kernel interface for causing the CPUs to have some
 minimum percentage of the idle time.
 
-Interfaces:
+Basic Interfaces:
 
 Under /proc/sys/kernel/kidled/, we can find the following files:
 
@@ -51,3 +51,39 @@ tasks become runnable, they are more likely to fall in an interval when we
 aren't forcing the CPU idle.
 
 
+Power Capping Priority:
+
+The time taken up by the idle cycle injector normally affects all of the
+interactive processes in the same way.  Essentially, that length of time
+disappears from CF's decisions.
+
+However, this isn't always desirable.  Ideally, we want
+to be able to shield some tasks from the consequences of power capping, while
+letting other tasks take the brunt of the impact.  We accomplish this by
+stealing time from tasks, as if they were running while we were lazy
+injecting.  We do this in a user specified priority order.  The priorities
+are specified as power_capping_priority in the parent CPU cgroup of the tasks.
+The higher the priority, the better it is for the task.  The run delay
+introduced by power capping is first given to the lower priority task, but
+if they aren't able to absorb it (i.e. it exceeds the time that they would
+have available to run), then it is passed to the higher priorities.  In
+case of a tie, we round robin the order of the tasks for this penalty.
+
+Note that we reserve the power capping priority treatment for lazy injections
+only.  Eagerly injected cycles are distributed equally among all the
+tasks.  Since interactive tasks are unaffected by eager injection, this
+is fine.
+
+Pretending to be a CFS thread for the LB:
+
+The kidled is an RT thread so that it can preempt almost anything.
+As such, it would normally have the weight associated with an RT thread.
+However, this makes a CPU recieving an idle cycle injection,
+suddenly much much less desirable than other CPUs with just CFS tasks.
+To provide a way to remedy this, we allow the setting of a fake nice value
+for the kidled thread.  Normally these threads are nice -19.  But the value
+can be adjusted by the user with /proc/sys/kernel/kidled/lb_prio.  This is
+specified as a non-negative integer.  0 corresponds to nice -19 (default)
+and 39 corresponds to nice 20.
+
+
diff --git a/include/linux/kidled.h b/include/linux/kidled.h
index 05c4ae5..199915a 100644
--- a/include/linux/kidled.h
+++ b/include/linux/kidled.h
@@ -69,9 +69,15 @@ static inline int ici_in_eager_mode(void)
 
 int  kidled_running(void);
 struct task_struct *get_kidled_task(int cpu);
+int  get_ici_lb_prio(void);
 int  is_ici_thread(struct task_struct *p);
 void kidled_interrupt_enter(void);
 void set_cpu_idle_ratio(int cpu, long idle_time, long busy_time);
 void get_cpu_idle_ratio(int cpu, long *idle_time, long *busy_time);
 extern int should_eager_inject(void);
+void power_capping_reshuffle_runqueue(long injected, long period);
+extern int should_eager_inject(void);
+
+#define MAX_POWER_CAPPING_PRIORITY	(48)
+
 #endif
diff --git a/kernel/kidled.c b/kernel/kidled.c
index 4e7aff3..5cd6911 100644
--- a/kernel/kidled.c
+++ b/kernel/kidled.c
@@ -218,6 +218,8 @@ static void lazy_inject(long nsecs, long interval)
 	}
 	__get_cpu_var(still_lazy_injecting) = 0;
 	hrtimer_cancel(&halt_timer);
+
+	power_capping_reshuffle_runqueue(nsecs, interval);
 }
 
 static DEFINE_PER_CPU(int, still_monitoring);
diff --git a/kernel/sched.c b/kernel/sched.c
index 486cab2..f2e89cd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -260,6 +260,8 @@ struct task_group {
 	unsigned long shares;
 #ifdef CONFIG_IDLE_CYCLE_INJECTOR
 	int power_interactive;
+	int power_capping_priority;
+	struct list_head pcp_queue_list[NR_CPUS];
 #endif
 #endif
 
@@ -552,6 +554,9 @@ struct rq {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
 	struct list_head leaf_cfs_rq_list;
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+	struct list_head pwrcap_prio_queue[MAX_POWER_CAPPING_PRIORITY];
+#endif
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
 	struct list_head leaf_rt_rq_list;
@@ -1867,8 +1872,20 @@ static void dec_nr_running(struct rq *rq)
 static void set_load_weight(struct task_struct *p)
 {
 	if (task_has_rt_policy(p)) {
-		p->se.load.weight = prio_to_weight[0] * 2;
-		p->se.load.inv_weight = prio_to_wmult[0] >> 1;
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+		if (!is_ici_thread(p)) {
+#endif
+			p->se.load.weight = prio_to_weight[0] * 2;
+			p->se.load.inv_weight = prio_to_wmult[0] >> 1;
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+		} else {
+			int lb_prio = get_ici_lb_prio();
+			p->se.load.weight =
+				prio_to_weight[lb_prio];
+			p->se.load.inv_weight =
+				prio_to_wmult[lb_prio];
+		}
+#endif
 		return;
 	}
 
@@ -9599,7 +9616,12 @@ void __init sched_init(void)
 #ifdef CONFIG_GROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&init_task_group.children);
-
+#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+	for_each_possible_cpu(i)
+		INIT_LIST_HEAD(&init_task_group.pcp_queue_list[i]);
+#endif
+#endif
 #ifdef CONFIG_USER_SCHED
 	INIT_LIST_HEAD(&root_task_group.children);
 	init_task_group.parent = &root_task_group;
@@ -9627,6 +9649,10 @@ void __init sched_init(void)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.shares = init_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+		for (j = 0; j < MAX_POWER_CAPPING_PRIORITY; j++)
+			INIT_LIST_HEAD(&rq->pwrcap_prio_queue[j]);
+#endif
 #ifdef CONFIG_CGROUP_SCHED
 		/*
 		 * How much cpu bandwidth does init_task_group get?
@@ -10110,6 +10136,11 @@ struct task_group *sched_create_group(struct task_group *parent)
 
 	WARN_ON(!parent); /* root should already exist */
 
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+	for_each_possible_cpu(i)
+		INIT_LIST_HEAD(&tg->pcp_queue_list[i]);
+#endif
+
 	tg->parent = parent;
 	INIT_LIST_HEAD(&tg->children);
 	list_add_rcu(&tg->siblings, &parent->children);
@@ -10676,6 +10707,39 @@ static int cpu_power_interactive_write_u64(struct cgroup *cgrp,
 	tg->power_interactive = interactive;
 	return 0;
 }
+
+static u64 cpu_power_capping_priority_read_u64(struct cgroup *cgrp,
+						struct cftype *cft)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	return (u64) tg->power_capping_priority;
+}
+
+static int cpu_power_capping_priority_write_u64(struct cgroup *cgrp,
+						struct cftype *cftype,
+						u64 priority)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	int i;
+
+	if (priority >= MAX_POWER_CAPPING_PRIORITY)
+		return -EINVAL;
+
+	tg->power_capping_priority = priority;
+
+	for_each_online_cpu(i) {
+		struct rq *rq = cpu_rq(i);
+
+		raw_spin_lock_irq(&rq->lock);
+		if (!list_empty(&tg->pcp_queue_list[i])) {
+			list_move_tail(&tg->pcp_queue_list[i],
+					&rq->pwrcap_prio_queue[priority]);
+		}
+		raw_spin_unlock_irq(&rq->lock);
+	}
+
+	return 0;
+}
 #endif /* CONFIG_IDLE_CYCLE_INJECTOR */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
@@ -10712,6 +10776,11 @@ static struct cftype cpu_files[] = {
 	},
 #ifdef CONFIG_IDLE_CYCLE_INJECTOR
 	{
+		.name = "power_capping_priority",
+		.read_u64 = cpu_power_capping_priority_read_u64,
+		.write_u64 = cpu_power_capping_priority_write_u64,
+	},
+	{
 		.name = "power_interactive",
 		.read_u64 = cpu_power_interactive_read_u64,
 		.write_u64 = cpu_power_interactive_write_u64,
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8fe7ee8..715a3ae 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -625,8 +625,23 @@ static void
 account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	update_load_add(&cfs_rq->load, se->load.weight);
-	if (!parent_entity(se))
+	if (!parent_entity(se)) {
+
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+		struct task_group *tg = NULL;
+
+		if (group_cfs_rq(se))
+			tg = group_cfs_rq(se)->tg;
+		if (tg && tg->parent) {
+			int cpu = cpu_of(rq_of(cfs_rq));
+			int pcp_prio = tg->power_capping_priority;
+			list_add_tail(&tg->pcp_queue_list[cpu],
+				 &rq_of(cfs_rq)->pwrcap_prio_queue[pcp_prio]);
+		}
+#endif
+
 		inc_cpu_load(rq_of(cfs_rq), se->load.weight);
+	}
 	if (entity_is_task(se)) {
 		add_cfs_task_weight(cfs_rq, se->load.weight);
 		list_add(&se->group_node, &cfs_rq->tasks);
@@ -639,8 +654,19 @@ static void
 account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	update_load_sub(&cfs_rq->load, se->load.weight);
-	if (!parent_entity(se))
+	if (!parent_entity(se)) {
+
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+		struct task_group *tg = NULL;
+
+		if (group_cfs_rq(se))
+			tg = group_cfs_rq(se)->tg;
+		if (tg && tg->parent)
+			list_del_init(&tg->pcp_queue_list[cfs_rq->rq->cpu]);
+#endif
+
 		dec_cpu_load(rq_of(cfs_rq), se->load.weight);
+	}
 	if (entity_is_task(se)) {
 		add_cfs_task_weight(cfs_rq, -se->load.weight);
 		list_del_init(&se->group_node);
@@ -988,6 +1014,53 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 		check_preempt_tick(cfs_rq, curr);
 }
 
+#ifdef CONFIG_IDLE_CYCLE_INJECTOR
+/* reshuffle run queue order base on power capping priority */
+void power_capping_reshuffle_runqueue(long injected, long ici_period)
+{
+	int i;
+	int cpu = smp_processor_id();
+	struct rq *rq = this_rq_lock();
+	struct task_group *tg;
+	struct task_group *next;
+
+	for (i = 0; i < MAX_POWER_CAPPING_PRIORITY; i++) {
+		struct list_head tmp_list;
+		INIT_LIST_HEAD(&tmp_list);
+		list_for_each_entry_safe(tg, next, &rq->pwrcap_prio_queue[i],
+					pcp_queue_list[cpu]) {
+			struct sched_entity *se;
+			struct cfs_rq *cfs_rq;
+			long slice, charge;
+
+			se = tg->se[cpu];
+			cfs_rq = se->cfs_rq;
+
+			slice = sched_slice(cfs_rq, se) * ici_period /
+				__sched_period(cfs_rq->nr_running);
+			charge = min(slice, injected);
+
+			__dequeue_entity(cfs_rq, se);
+			se->vruntime += calc_delta_fair(charge, se);
+			__enqueue_entity(cfs_rq, se);
+
+			injected -= charge;
+			list_del(&tg->pcp_queue_list[cpu]);
+			list_add_tail(&tg->pcp_queue_list[cpu], &tmp_list);
+			if (injected <= 0) {
+				list_splice(&tmp_list,
+					rq->pwrcap_prio_queue[i].prev);
+				goto done;
+			}
+		}
+		list_splice(&tmp_list, &rq->pwrcap_prio_queue[i]);
+	}
+done:
+	raw_spin_unlock_irq(&rq->lock);
+	return;
+}
+#endif
+
 /**************************************************
  * CFS operations on tasks:
  */

