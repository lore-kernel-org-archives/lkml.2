Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab1AULIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 06:08:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:55454 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab1AULIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 06:08:20 -0500
Subject: Re: Bug in scheduler when using rt_mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>, samu.p.onkalo@nokia.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1295518047.8027.104.camel@marge.simson.net>
References: <1295275365.12840.13.camel@kolo>
	 <1295280032.30950.128.camel@laptop> <1295339012.11678.35.camel@kolo>
	 <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	 <1295357746.30950.681.camel@laptop>
	 <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	 <1295430276.30950.1414.camel@laptop> <1295433498.30950.1482.camel@laptop>
	 <1295436632.30950.1542.camel@laptop> <1295441881.11678.41.camel@kolo>
	 <1295442799.11678.43.camel@kolo> <1295443822.28776.23.camel@laptop>
	 <AANLkTinQ4sczEwZYCk1_tLmeJyjyXj4TVoSZbjg+KiRq@mail.gmail.com>
	 <1295499568.8027.30.camel@marge.simson.net>
	 <AANLkTikEwgMzco2fHT668Mg3fC-T3EBMUgQQqW-Ojj-Y@mail.gmail.com>
	 <1295503938.8027.59.camel@marge.simson.net>
	 <AANLkTi=7YyA-e8HAq+C_prK2EaZKcaTfzDJvmO3e3W=B@mail.gmail.com>
	 <1295512625.8027.88.camel@marge.simson.net>
	 <AANLkTi=WhLy=4MNdm-HaOUOmbKXsNSJojnzqRTYp6qop@mail.gmail.com>
	 <1295518047.8027.104.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 21 Jan 2011 12:08:56 +0100
Message-ID: <1295608136.28776.266.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 11:07 +0100, Mike Galbraith wrote:
> On Thu, 2011-01-20 at 17:07 +0800, Yong Zhang wrote:
> > On Thu, Jan 20, 2011 at 4:37 PM, Mike Galbraith <efault@gmx.de> wrote:
> > > On Thu, 2011-01-20 at 15:06 +0800, Yong Zhang wrote:
> > >> On Thu, Jan 20, 2011 at 2:12 PM, Mike Galbraith <efault@gmx.de> wrote:
> > >> > If the task returns as a sleeper, place entity() will be called when it
> > >> > is awakened, so it's sleep credit will be clipped as usual.  So vruntime
> > >> > can be much less than min_vruntime at class exit time, and it doesn't
> > >> > matter, clipping on wakeup after re-entry takes care of it.. if that's
> > >> > what you were thinking about.
> > >>
> > >> For a sleep task which stay in sched_fair before it's waked:
> > >> try_to_wake_up()
> > >>   ttwu_activate()
> > >>     activate_task()
> > >>       enqueue_task_fair()
> > >>         enqueue_entity()
> > >>           place_entity()        <== clip vruntime
> > >>
> > >> For a sleep task which promote to sched_rt when it's sleep:
> > >> rt_mutex_setprio()
> > >>   check_class_changed()
> > >>     switch_from_fair()       <== vruntime -= min_vruntime
> > >>       try_to_wake_up()
> > >>         ...run then stay on rq
> > >>         rt_mutex_setprio()
> > >>           enqueue_task_fair()     <==vruntime += min_vruntime
> > >>
> > >> The difference is that in the second case, place_entity() is not
> > >> called, but wrt sched_fair, the task is a WAKEUP task.
> > >> Then we place this task in sched_fair before where it should be.
> > >
> > > D'oh.  You're right, he needs to be clipped before he leaves.
> > 
> > Exactly we should clip it when it comes back, because it still could
> > sleep for some time after it leaves ;)
> 
> That's ok, we don't and aren't supposed to care what happens while he's
> gone.  But we do have to make sure that vruntime is sane either when he
> leaves, or when he comes back.  Seems to me the easiest is clip when he
> leaves to cover him having slept a long time before leaving, then coming
> back on us as a runner.  If he comes back as a sleeper, he'll be clipped
> again anyway, so all is well.
>
> sched_fork() should probably zero child's vruntime too, so non-fair
> children can't enter fair_class with some bogus lag they never had.

Something like so?

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2624,6 +2624,8 @@ void sched_fork(struct task_struct *p, i
 
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
+	else
+		p->se.vruntime = 0;
 
 	if (p->sched_class->task_fork)
 		p->sched_class->task_fork(p);
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -4086,8 +4086,14 @@ static void switched_from_fair(struct rq
 	 * have normalized the vruntime, if it was !on_rq, then only when
 	 * the task is sleeping will it still have non-normalized vruntime.
 	 */
-	if (!se->on_rq && p->state != TASK_RUNNING)
+	if (!se->on_rq && p->state != TASK_RUNNING) {
+		/*
+		 * Fix up our vruntime so that the current sleep doesn't
+		 * cause 'unlimited' sleep bonus.
+		 */
+		place_entity(cfs_rq, se, 0);
 		se->vruntime -= cfs_rq->min_vruntime;
+	}
 }
 
 /*

