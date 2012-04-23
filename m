Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2DWKNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:13:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49742 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab2DWKNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:13:00 -0400
Message-ID: <1335175949.28150.109.camel@twins>
Subject: Re: [PATCH 03/16] sched: SCHED_DEADLINE data structures.
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Mon, 23 Apr 2012 12:12:29 +0200
In-Reply-To: <4F952721.9030302@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	   <1333696481-3433-4-git-send-email-juri.lelli@gmail.com>
	  <1335172098.28150.99.camel@twins> <4F95253F.4090005@gmail.com>
	 <1335174564.28150.107.camel@twins> <4F952721.9030302@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 11:55 +0200, Juri Lelli wrote:
> On 04/23/2012 11:49 AM, Peter Zijlstra wrote:
> > On Mon, 2012-04-23 at 11:47 +0200, Juri Lelli wrote:
> >> On 04/23/2012 11:08 AM, Peter Zijlstra wrote:
> >>> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> >>>> +struct sched_dl_entity {
> >>>> +       struct rb_node  rb_node;
> >>>> +       int nr_cpus_allowed;
> >>>
> >>> I think it would be all-round best to move
> >>> sched_rt_entity::nr_cpus_allowed out next to cpus_allowed.
> >>
> >> You mean unify them: a single nr_cpus_allowed after
> >> task_struct::cpus_allowed, right?
> >
> > Yes, no point in keeping that one value twice and in fact there's a
> > usage of p->rt.nr_cpus_allowed in sched/fair.c so its past time its
> > moved out of that rt specific thing.
> 
> Sure. Since this is a small change, probably not strictly related to
> this patchset, may I wait to see the change in mainline?

Ok..


---
Subject: sched: Move nr_cpus_allowed out of sched_rt_entity
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Apr 23 12:11:21 CEST 2012

Since nr_cpus_allowed is used outside of sched/rt.c and wants to be
used outside of there more, move it to a more natural site.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-gba0fya9qv86mo5m1cjf7f0v@git.kernel.org
---
 arch/blackfin/kernel/process.c |    2 +-
 include/linux/init_task.h      |    2 +-
 include/linux/sched.h          |    2 +-
 kernel/sched/core.c            |    2 +-
 kernel/sched/fair.c            |    2 +-
 kernel/sched/rt.c              |   36 +++++++++++++++++++++---------------
 6 files changed, 26 insertions(+), 20 deletions(-)

--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -171,7 +171,7 @@ asmlinkage int bfin_clone(struct pt_regs
 	unsigned long newsp;
 
 #ifdef __ARCH_SYNC_CORE_DCACHE
-	if (current->rt.nr_cpus_allowed == num_possible_cpus())
+	if (current->nr_cpus_allowed == num_possible_cpus())
 		set_cpus_allowed_ptr(current, cpumask_of(smp_processor_id()));
 #endif
 
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
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1234,7 +1234,6 @@ struct sched_rt_entity {
 	struct list_head run_list;
 	unsigned long timeout;
 	unsigned int time_slice;
-	int nr_cpus_allowed;
 
 	struct sched_rt_entity *back;
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -1299,6 +1298,7 @@ struct task_struct {
 #endif
 
 	unsigned int policy;
+	int nr_cpus_allowed;
 	cpumask_t cpus_allowed;
 
 #ifdef CONFIG_PREEMPT_RCU
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4957,7 +4957,7 @@ void do_set_cpus_allowed(struct task_str
 		p->sched_class->set_cpus_allowed(p, new_mask);
 
 	cpumask_copy(&p->cpus_allowed, new_mask);
-	p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
+	p->nr_cpus_allowed = cpumask_weight(new_mask);
 }
 
 /*
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2703,7 +2703,7 @@ select_task_rq_fair(struct task_struct *
 	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
-	if (p->rt.nr_cpus_allowed == 1)
+	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -274,13 +274,16 @@ static void update_rt_migration(struct r
 
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
@@ -288,13 +291,16 @@ static void inc_rt_migration(struct sche
 
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
@@ -1161,7 +1167,7 @@ enqueue_task_rt(struct rq *rq, struct ta
 
 	enqueue_rt_entity(rt_se, flags & ENQUEUE_HEAD);
 
-	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
+	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 
 	inc_nr_running(rq);
@@ -1225,7 +1231,7 @@ select_task_rq_rt(struct task_struct *p,
 
 	cpu = task_cpu(p);
 
-	if (p->rt.nr_cpus_allowed == 1)
+	if (p->nr_cpus_allowed == 1)
 		goto out;
 
 	/* For anything but wake ups, just return the task_cpu */
@@ -1260,9 +1266,9 @@ select_task_rq_rt(struct task_struct *p,
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
@@ -1276,10 +1282,10 @@ select_task_rq_rt(struct task_struct *p,
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	if (rq->curr->rt.nr_cpus_allowed == 1)
+	if (rq->curr->nr_cpus_allowed == 1)
 		return;
 
-	if (p->rt.nr_cpus_allowed != 1
+	if (p->nr_cpus_allowed != 1
 	    && cpupri_find(&rq->rd->cpupri, p, NULL))
 		return;
 
@@ -1395,7 +1401,7 @@ static void put_prev_task_rt(struct rq *
 	 * The previous task needs to be made eligible for pushing
 	 * if it is still active
 	 */
-	if (on_rt_rq(&p->rt) && p->rt.nr_cpus_allowed > 1)
+	if (on_rt_rq(&p->rt) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 }
 
@@ -1408,7 +1414,7 @@ static int pick_rt_task(struct rq *rq, s
 {
 	if (!task_running(rq, p) &&
 	    (cpu < 0 || cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) &&
-	    (p->rt.nr_cpus_allowed > 1))
+	    (p->nr_cpus_allowed > 1))
 		return 1;
 	return 0;
 }
@@ -1464,7 +1470,7 @@ static int find_lowest_rq(struct task_st
 	if (unlikely(!lowest_mask))
 		return -1;
 
-	if (task->rt.nr_cpus_allowed == 1)
+	if (task->nr_cpus_allowed == 1)
 		return -1; /* No other targets possible */
 
 	if (!cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask))
@@ -1586,7 +1592,7 @@ static struct task_struct *pick_next_pus
 
 	BUG_ON(rq->cpu != task_cpu(p));
 	BUG_ON(task_current(rq, p));
-	BUG_ON(p->rt.nr_cpus_allowed <= 1);
+	BUG_ON(p->nr_cpus_allowed <= 1);
 
 	BUG_ON(!p->on_rq);
 	BUG_ON(!rt_task(p));
@@ -1793,9 +1799,9 @@ static void task_woken_rt(struct rq *rq,
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
@@ -1817,7 +1823,7 @@ static void set_cpus_allowed_rt(struct t
 	 * Only update if the process changes its state from whether it
 	 * can migrate or not.
 	 */
-	if ((p->rt.nr_cpus_allowed > 1) == (weight > 1))
+	if ((p->nr_cpus_allowed > 1) == (weight > 1))
 		return;
 
 	rq = task_rq(p);

