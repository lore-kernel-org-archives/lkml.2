Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab1ARNfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 08:35:17 -0500
Received: from canuck.infradead.org ([134.117.69.58]:45516 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1ARNfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 08:35:15 -0500
Subject: Re: Bug in scheduler when using rt_mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: samu.p.onkalo@nokia.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
In-Reply-To: <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
References: <1295275365.12840.13.camel@kolo>
	 <1295280032.30950.128.camel@laptop> <1295339012.11678.35.camel@kolo>
	 <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 18 Jan 2011 14:35:46 +0100
Message-ID: <1295357746.30950.681.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 16:59 +0800, Yong Zhang wrote:
> On Tue, Jan 18, 2011 at 4:23 PM, Onkalo Samu <samu.p.onkalo@nokia.com> wrote:
> > On Mon, 2011-01-17 at 17:00 +0100, ext Peter Zijlstra wrote:
> >> On Mon, 2011-01-17 at 16:42 +0200, Onkalo Samu wrote:
> >> >
> >> > Failure case:
> >> > - user process locks rt_mutex
> >> > - and goes to sleep (wait_for_completion etc.)
> >> > - user process is dequeued to sleep state
> >> > -> vruntime is not updated in dequeue_entity
> >> >
> >>
> >> Does the below (completely untested) patch help?
> >
> > Unfortunately no.
> 
> It couldn't work because place_entity() will not place it
> backwards.

Ah indeed, I was somehow assuming it was way left, but that is not at
all true, something like the below then..

---
Subject: sched: Fix switch_to_fair()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Jan 17 17:03:27 CET 2011

When a task is placed back into fair_sched_class, we must update its
placement, since we don't know how long its been gone, hence its
vruntime is stale and cannot be trusted.

There is also a case where it was moved from fair_sched_class when it
was in a blocked state and moved back while it is running, this causes
an imbalance between DEQUEUE_SLEEP/DEQUEUE_WAKEUP for the fair class
and leaves vruntime way out there (due to the min_vruntime
adjustment).

Also update sysrq-n to call the ->switch_{to,from} methods.

Reported-by: Onkalo Samu <samu.p.onkalo@nokia.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |    4 ++++
 kernel/sched_fair.c |   16 ++++++++++++++++
 2 files changed, 20 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -8106,6 +8106,8 @@ EXPORT_SYMBOL(__might_sleep);
 #ifdef CONFIG_MAGIC_SYSRQ
 static void normalize_task(struct rq *rq, struct task_struct *p)
 {
+	struct sched_class *prev_class = p->sched_class;
+	int old_prio = p->prio;
 	int on_rq;
 
 	on_rq = p->se.on_rq;
@@ -8116,6 +8118,8 @@ static void normalize_task(struct rq *rq
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
@@ -4075,6 +4075,22 @@ static void prio_changed_fair(struct rq
 static void switched_to_fair(struct rq *rq, struct task_struct *p,
 			     int running)
 {
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	if (se->on_rq && cfs_rq->curr != se)
+		__dequeue_entity(cfs_rq, se);
+
+	/*
+	 * se->vruntime can be completely out there, there is no telling
+	 * how long this task was !fair and on what CPU if any it became
+	 * !fair. Therefore, reset it to a known, reasonable value.
+	 */
+	se->vruntime = cfs_rq->min_vruntime;
+
+	if (se->on_rq && cfs_rq->curr != se)
+		__enqueue_entity(cfs_rq, se);
+
 	/*
 	 * We were most likely switched from sched_rt, so
 	 * kick off the schedule if running, otherwise just see

