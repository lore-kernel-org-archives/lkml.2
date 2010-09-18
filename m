Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab0IRTs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:48:28 -0400
Received: from kroah.org ([198.145.64.141]:51514 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab0IRTBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:52 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:58 2010
Message-Id: <20100918185958.366169734@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: [065/123] sched: Protect sched_rr_get_param() access to task->sched_class
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-protect-sched_rr_get_param-access-to-task-sched_class.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit dba091b9e3522b9d32fc9975e48d3b69633b45f0 upstream

sched_rr_get_param calls
task->sched_class->get_rr_interval(task) without protection
against a concurrent sched_setscheduler() call which modifies
task->sched_class.

Serialize the access with task_rq_lock(task) and hand the rq
pointer into get_rr_interval() as it's needed at least in the
sched_fair implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <alpine.LFD.2.00.0912090930120.3089@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sched.h   |    3 ++-
 kernel/sched.c          |    6 +++++-
 kernel/sched_fair.c     |    6 +-----
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |    2 +-
 5 files changed, 10 insertions(+), 9 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1114,7 +1114,8 @@ struct sched_class {
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
 
-	unsigned int (*get_rr_interval) (struct task_struct *task);
+	unsigned int (*get_rr_interval) (struct rq *rq,
+					 struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*moved_group) (struct task_struct *p);
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6946,6 +6946,8 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 {
 	struct task_struct *p;
 	unsigned int time_slice;
+	unsigned long flags;
+	struct rq *rq;
 	int retval;
 	struct timespec t;
 
@@ -6962,7 +6964,9 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 	if (retval)
 		goto out_unlock;
 
-	time_slice = p->sched_class->get_rr_interval(p);
+	rq = task_rq_lock(p, &flags);
+	time_slice = p->sched_class->get_rr_interval(rq, p);
+	task_rq_unlock(rq, &flags);
 
 	read_unlock(&tasklist_lock);
 	jiffies_to_timespec(time_slice, &t);
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2003,21 +2003,17 @@ static void moved_group_fair(struct task
 }
 #endif
 
-unsigned int get_rr_interval_fair(struct task_struct *task)
+unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task)
 {
 	struct sched_entity *se = &task->se;
-	unsigned long flags;
-	struct rq *rq;
 	unsigned int rr_interval = 0;
 
 	/*
 	 * Time slice is 0 for SCHED_OTHER tasks that are on an otherwise
 	 * idle runqueue:
 	 */
-	rq = task_rq_lock(task, &flags);
 	if (rq->cfs.load.weight)
 		rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
-	task_rq_unlock(rq, &flags);
 
 	return rr_interval;
 }
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -97,7 +97,7 @@ static void prio_changed_idle(struct rq
 		check_preempt_curr(rq, p, 0);
 }
 
-unsigned int get_rr_interval_idle(struct task_struct *task)
+unsigned int get_rr_interval_idle(struct rq *rq, struct task_struct *task)
 {
 	return 0;
 }
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1734,7 +1734,7 @@ static void set_curr_task_rt(struct rq *
 	dequeue_pushable_task(rq, p);
 }
 
-unsigned int get_rr_interval_rt(struct task_struct *task)
+unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
 {
 	/*
 	 * Time slice is 0 for SCHED_FIFO tasks


