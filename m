Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0IRTCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:46 -0400
Received: from kroah.org ([198.145.64.141]:51656 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab0IRTCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:05 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:00 2010
Message-Id: <20100918185959.926074938@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [083/123] sched: Add pre and post wakeup hooks
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-add-pre-and-post-wakeup-hooks.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit efbbd05a595343a413964ad85a2ad359b7b7efbd upstream

As will be apparent in the next patch, we need a pre wakeup hook
for sched_fair task migration, hence rename the post wakeup hook
and one pre wakeup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170518.114746117@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sched.h |    3 ++-
 kernel/sched.c        |   12 ++++++++----
 kernel/sched_rt.c     |    4 ++--
 3 files changed, 12 insertions(+), 7 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1093,7 +1093,8 @@ struct sched_class {
 			      enum cpu_idle_type idle);
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
-	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
+	void (*task_waking) (struct rq *this_rq, struct task_struct *task);
+	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
 
 	void (*set_cpus_allowed)(struct task_struct *p,
 				 const struct cpumask *newmask);
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2438,6 +2438,10 @@ static int try_to_wake_up(struct task_st
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 	p->state = TASK_WAKING;
+
+	if (p->sched_class->task_waking)
+		p->sched_class->task_waking(rq, p);
+
 	__task_rq_unlock(rq);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
@@ -2501,8 +2505,8 @@ out_running:
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
-	if (p->sched_class->task_wake_up)
-		p->sched_class->task_wake_up(rq, p);
+	if (p->sched_class->task_woken)
+		p->sched_class->task_woken(rq, p);
 
 	if (unlikely(rq->idle_stamp)) {
 		u64 delta = rq->clock - rq->idle_stamp;
@@ -2693,8 +2697,8 @@ void wake_up_new_task(struct task_struct
 	trace_sched_wakeup_new(rq, p, 1);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
-	if (p->sched_class->task_wake_up)
-		p->sched_class->task_wake_up(rq, p);
+	if (p->sched_class->task_woken)
+		p->sched_class->task_woken(rq, p);
 #endif
 	task_rq_unlock(rq, &flags);
 }
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1485,7 +1485,7 @@ static void post_schedule_rt(struct rq *
  * If we are not running and we are not going to reschedule soon, we should
  * try to push tasks away now
  */
-static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
+static void task_woken_rt(struct rq *rq, struct task_struct *p)
 {
 	if (!task_running(rq, p) &&
 	    !test_tsk_need_resched(rq->curr) &&
@@ -1766,7 +1766,7 @@ static const struct sched_class rt_sched
 	.rq_offline             = rq_offline_rt,
 	.pre_schedule		= pre_schedule_rt,
 	.post_schedule		= post_schedule_rt,
-	.task_wake_up		= task_wake_up_rt,
+	.task_woken		= task_woken_rt,
 	.switched_from		= switched_from_rt,
 #endif
 


