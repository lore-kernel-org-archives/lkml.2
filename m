Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab0IRTOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:14:00 -0400
Received: from kroah.org ([198.145.64.141]:51696 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947Ab0IRTCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:09 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:00 2010
Message-Id: <20100918190000.430345814@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: [089/123] sched: Extend enqueue_task to allow head queueing
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-extend-enqueue_task-to-allow-head-queueing.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit ea87bb7853168434f4a82426dd1ea8421f9e604d upstream

The ability of enqueueing a task to the head of a SCHED_FIFO priority
list is required to fix some violations of POSIX scheduling policy.

Extend the related functions with a "head" argument.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Carsten Emde <cbe@osadl.org>
Tested-by: Mathias Weber <mathias.weber.mw1@roche.com>
LKML-Reference: <20100120171629.734886007@linutronix.de>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sched.h |    3 ++-
 kernel/sched.c        |   13 +++++++------
 kernel/sched_fair.c   |    3 ++-
 kernel/sched_rt.c     |    3 ++-
 4 files changed, 13 insertions(+), 9 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1071,7 +1071,8 @@ struct sched_domain;
 struct sched_class {
 	const struct sched_class *next;
 
-	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
+	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup,
+			      bool head);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
 
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1903,13 +1903,14 @@ static void update_avg(u64 *avg, u64 sam
 	*avg += diff >> 3;
 }
 
-static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
+static void
+enqueue_task(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 {
 	if (wakeup)
 		p->se.start_runtime = p->se.sum_exec_runtime;
 
 	sched_info_queued(p);
-	p->sched_class->enqueue_task(rq, p, wakeup);
+	p->sched_class->enqueue_task(rq, p, wakeup, head);
 	p->se.on_rq = 1;
 }
 
@@ -1985,7 +1986,7 @@ static void activate_task(struct rq *rq,
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 
-	enqueue_task(rq, p, wakeup);
+	enqueue_task(rq, p, wakeup, false);
 	inc_nr_running(rq);
 }
 
@@ -6183,7 +6184,7 @@ void rt_mutex_setprio(struct task_struct
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		enqueue_task(rq, p, 0);
+		enqueue_task(rq, p, 0, false);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
@@ -6227,7 +6228,7 @@ void set_user_nice(struct task_struct *p
 	delta = p->prio - old_prio;
 
 	if (on_rq) {
-		enqueue_task(rq, p, 0);
+		enqueue_task(rq, p, 0, false);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -10180,7 +10181,7 @@ void sched_move_task(struct task_struct
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
 	if (on_rq)
-		enqueue_task(rq, tsk, 0);
+		enqueue_task(rq, tsk, 0, false);
 
 	task_rq_unlock(rq, &flags);
 }
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1031,7 +1031,8 @@ static inline void hrtick_update(struct
  * increased. Here we update the fair scheduling stats and
  * then put the task into the rbtree:
  */
-static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
+static void
+enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -878,7 +878,8 @@ static void dequeue_rt_entity(struct sch
 /*
  * Adding/removing a task to/from a priority array:
  */
-static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
+static void
+enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
 


