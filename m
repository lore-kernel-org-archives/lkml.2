Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2E3NkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 09:40:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab2E3NkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 09:40:03 -0400
Date: Wed, 30 May 2012 06:39:43 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-kr61f02y9brwzkh6x53pdptm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Move nr_cpus_allowed out of '
 struct sched_rt_entity'
Git-Commit-ID: 29baa7478ba47d746e3625c91d3b2afbf46b4312
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 06:39:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29baa7478ba47d746e3625c91d3b2afbf46b4312
Gitweb:     http://git.kernel.org/tip/29baa7478ba47d746e3625c91d3b2afbf46b4312
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 23 Apr 2012 12:11:21 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 30 May 2012 14:02:25 +0200

sched: Move nr_cpus_allowed out of 'struct sched_rt_entity'

Since nr_cpus_allowed is used outside of sched/rt.c and wants to be
used outside of there more, move it to a more natural site.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-kr61f02y9brwzkh6x53pdptm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/blackfin/kernel/process.c |    2 +-
 include/linux/init_task.h      |    2 +-
 include/linux/sched.h          |    2 +-
 kernel/sched/core.c            |    2 +-
 kernel/sched/fair.c            |    2 +-
 kernel/sched/rt.c              |   36 +++++++++++++++++++++---------------
 6 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 2e3994b..62bcea7 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -173,7 +173,7 @@ asmlinkage int bfin_clone(struct pt_regs *regs)
 	unsigned long newsp;
 
 #ifdef __ARCH_SYNC_CORE_DCACHE
-	if (current->rt.nr_cpus_allowed == num_possible_cpus())
+	if (current->nr_cpus_allowed == num_possible_cpus())
 		set_cpus_allowed_ptr(current, cpumask_of(smp_processor_id()));
 #endif
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index e4baff5..9e65eff 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -149,6 +149,7 @@ extern struct cred init_cred;
 	.normal_prio	= MAX_PRIO-20,					\
 	.policy		= SCHED_NORMAL,					\
 	.cpus_allowed	= CPU_MASK_ALL,					\
+	.nr_cpus_allowed= NR_CPUS,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
 	.se		= {						\
@@ -157,7 +158,6 @@ extern struct cred init_cred;
 	.rt		= {						\
 		.run_list	= LIST_HEAD_INIT(tsk.rt.run_list),	\
 		.time_slice	= RR_TIMESLICE,				\
-		.nr_cpus_allowed = NR_CPUS,				\
 	},								\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
 	INIT_PUSHABLE_TASKS(tsk)					\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d61e597..0f50e78 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1188,7 +1188,6 @@ struct sched_rt_entity {
 	struct list_head run_list;
 	unsigned long timeout;
 	unsigned int time_slice;
-	int nr_cpus_allowed;
 
 	struct sched_rt_entity *back;
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -1253,6 +1252,7 @@ struct task_struct {
 #endif
 
 	unsigned int policy;
+	int nr_cpus_allowed;
 	cpumask_t cpus_allowed;
 
 #ifdef CONFIG_PREEMPT_RCU
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3a69374..70cc36a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5015,7 +5015,7 @@ void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 		p->sched_class->set_cpus_allowed(p, new_mask);
 
 	cpumask_copy(&p->cpus_allowed, new_mask);
-	p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
+	p->nr_cpus_allowed = cpumask_weight(new_mask);
 }
 
 /*
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2b449a7..b2a2d23 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2703,7 +2703,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
-	if (p->rt.nr_cpus_allowed == 1)
+	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index c5565c3..295da73 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -274,13 +274,16 @@ static void update_rt_migration(struct rt_rq *rt_rq)
 
 static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
+	struct task_struct *p;
+
 	if (!rt_entity_is_task(rt_se))
 		return;
 
+	p = rt_task_of(rt_se);
 	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
 
 	rt_rq->rt_nr_total++;
-	if (rt_se->nr_cpus_allowed > 1)
+	if (p->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory++;
 
 	update_rt_migration(rt_rq);
@@ -288,13 +291,16 @@ static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 
 static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
+	struct task_struct *p;
+
 	if (!rt_entity_is_task(rt_se))
 		return;
 
+	p = rt_task_of(rt_se);
 	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
 
 	rt_rq->rt_nr_total--;
-	if (rt_se->nr_cpus_allowed > 1)
+	if (p->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory--;
 
 	update_rt_migration(rt_rq);
@@ -1161,7 +1167,7 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 
 	enqueue_rt_entity(rt_se, flags & ENQUEUE_HEAD);
 
-	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
+	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 
 	inc_nr_running(rq);
@@ -1225,7 +1231,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 
 	cpu = task_cpu(p);
 
-	if (p->rt.nr_cpus_allowed == 1)
+	if (p->nr_cpus_allowed == 1)
 		goto out;
 
 	/* For anything but wake ups, just return the task_cpu */
@@ -1260,9 +1266,9 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	 * will have to sort it out.
 	 */
 	if (curr && unlikely(rt_task(curr)) &&
-	    (curr->rt.nr_cpus_allowed < 2 ||
+	    (curr->nr_cpus_allowed < 2 ||
 	     curr->prio <= p->prio) &&
-	    (p->rt.nr_cpus_allowed > 1)) {
+	    (p->nr_cpus_allowed > 1)) {
 		int target = find_lowest_rq(p);
 
 		if (target != -1)
@@ -1276,10 +1282,10 @@ out:
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	if (rq->curr->rt.nr_cpus_allowed == 1)
+	if (rq->curr->nr_cpus_allowed == 1)
 		return;
 
-	if (p->rt.nr_cpus_allowed != 1
+	if (p->nr_cpus_allowed != 1
 	    && cpupri_find(&rq->rd->cpupri, p, NULL))
 		return;
 
@@ -1395,7 +1401,7 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 	 * The previous task needs to be made eligible for pushing
 	 * if it is still active
 	 */
-	if (on_rt_rq(&p->rt) && p->rt.nr_cpus_allowed > 1)
+	if (on_rt_rq(&p->rt) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 }
 
@@ -1408,7 +1414,7 @@ static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
 	    (cpu < 0 || cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) &&
-	    (p->rt.nr_cpus_allowed > 1))
+	    (p->nr_cpus_allowed > 1))
 		return 1;
 	return 0;
 }
@@ -1464,7 +1470,7 @@ static int find_lowest_rq(struct task_struct *task)
 	if (unlikely(!lowest_mask))
 		return -1;
 
-	if (task->rt.nr_cpus_allowed == 1)
+	if (task->nr_cpus_allowed == 1)
 		return -1; /* No other targets possible */
 
 	if (!cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask))
@@ -1586,7 +1592,7 @@ static struct task_struct *pick_next_pushable_task(struct rq *rq)
 
 	BUG_ON(rq->cpu != task_cpu(p));
 	BUG_ON(task_current(rq, p));
-	BUG_ON(p->rt.nr_cpus_allowed <= 1);
+	BUG_ON(p->nr_cpus_allowed <= 1);
 
 	BUG_ON(!p->on_rq);
 	BUG_ON(!rt_task(p));
@@ -1793,9 +1799,9 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
 	    has_pushable_tasks(rq) &&
-	    p->rt.nr_cpus_allowed > 1 &&
+	    p->nr_cpus_allowed > 1 &&
 	    rt_task(rq->curr) &&
-	    (rq->curr->rt.nr_cpus_allowed < 2 ||
+	    (rq->curr->nr_cpus_allowed < 2 ||
 	     rq->curr->prio <= p->prio))
 		push_rt_tasks(rq);
 }
@@ -1817,7 +1823,7 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 	 * Only update if the process changes its state from whether it
 	 * can migrate or not.
 	 */
-	if ((p->rt.nr_cpus_allowed > 1) == (weight > 1))
+	if ((p->nr_cpus_allowed > 1) == (weight > 1))
 		return;
 
 	rq = task_rq(p);
