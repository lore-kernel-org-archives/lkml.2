Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab1ASJoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:44:10 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47963 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1ASJoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:44:05 -0500
Subject: Re: Bug in scheduler when using rt_mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: samu.p.onkalo@nokia.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
In-Reply-To: <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
References: <1295275365.12840.13.camel@kolo>
	 <1295280032.30950.128.camel@laptop> <1295339012.11678.35.camel@kolo>
	 <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	 <1295357746.30950.681.camel@laptop>
	 <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 Jan 2011 10:44:36 +0100
Message-ID: <1295430276.30950.1414.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 10:38 +0800, Yong Zhang wrote:
> > Index: linux-2.6/kernel/sched_fair.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched_fair.c
> > +++ linux-2.6/kernel/sched_fair.c
> > @@ -4075,6 +4075,22 @@ static void prio_changed_fair(struct rq
> >  static void switched_to_fair(struct rq *rq, struct task_struct *p,
> >                             int running)
> >  {
> > +       struct sched_entity *se = &p->se;
> > +       struct cfs_rq *cfs_rq = cfs_rq_of(se);
> > +
> > +       if (se->on_rq && cfs_rq->curr != se)
> 
> (cfs_rq->curr != se) equals to (!running), no?

more or less, the idea is that we only call __{dequeue,enqueue}_entity()
when the task is actually in the tree and current is not.

> > +               __dequeue_entity(cfs_rq, se);
> > +
> > +       /*
> > +        * se->vruntime can be completely out there, there is no telling
> > +        * how long this task was !fair and on what CPU if any it became
> > +        * !fair. Therefore, reset it to a known, reasonable value.
> > +        */
> > +       se->vruntime = cfs_rq->min_vruntime;
> 
> But this is not fair for !SLEEP task.
> You know se->vruntime -= cfs_rq->min_vruntime for !SLEEP task,
> then after it go through sched_fair-->sched_rt-->sched_fair by some
> means, current cfs_rq->min_vruntime is added back.
> 
> But here se is putted before where it should be. Is this what we want?

well, its more or less screwy anyway, since we don't know for how long
the task was !fair and what cpu it came from etc..

But I guess you're right, we should at least pretend the whole
min_vruntime thing is the 0-lag point (its not) and preserve 'lag' like
we do for migrations... Something like the below.. except I've got a
massive head ache and I'm not at all sure I got the switched_from_fair()
bit right.

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -8108,6 +8108,8 @@ EXPORT_SYMBOL(__might_sleep);
 #ifdef CONFIG_MAGIC_SYSRQ
 static void normalize_task(struct rq *rq, struct task_struct *p)
 {
+	struct sched_class *prev_class = p->sched_class;
+	int old_prio = p->prio;
 	int on_rq;
 
 	on_rq = p->se.on_rq;
@@ -8118,6 +8120,8 @@ static void normalize_task(struct rq *rq
 		activate_task(rq, p, 0);
 		resched_task(rq->curr);
 	}
+
+	check_class_changed(rq, p, prev_class, old_prio, task_current(rq, p));
 }
 
 void normalize_rt_tasks(void)
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -4066,12 +4066,33 @@ static void prio_changed_fair(struct rq
 		check_preempt_curr(rq, p, 0);
 }
 
+static void
+switched_from_fair(struct rq *rq, struct task_struct *p, int running)
+{
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	if (!se->on_rq && p->state != TASK_RUNNING)
+		se->vruntime -= cfs_rq->min_vruntime;
+}
+
 /*
  * We switched to the sched_fair class.
  */
-static void switched_to_fair(struct rq *rq, struct task_struct *p,
-			     int running)
+static void
+switched_to_fair(struct rq *rq, struct task_struct *p, int running)
 {
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	if (se->on_rq && cfs_rq->curr != se)
+		__dequeue_entity(cfs_rq, se);
+
+	se->vruntimea += cfs_rq->min_vruntime;
+
+	if (se->on_rq && cfs_rq->curr != se)
+		__enqueue_entity(cfs_rq, se);
+
 	/*
 	 * We were most likely switched from sched_rt, so
 	 * kick off the schedule if running, otherwise just see
@@ -4163,6 +4184,7 @@ static const struct sched_class fair_sch
 	.task_fork		= task_fork_fair,
 
 	.prio_changed		= prio_changed_fair,
+	.switched_from		= switched_from_fair,
 	.switched_to		= switched_to_fair,
 
 	.get_rr_interval	= get_rr_interval_fair,

