Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab0KKWUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:20:15 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:43648 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756876Ab0KKWUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:20:13 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19vi8kq9mpvJyw7rbR/1mjt8x1/jAiWFeX4JBfbs8
	jgiEliJFuPUP2C
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <20101111202703.GA16282@redhat.com>
References: <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
	 <1287648715.9021.20.camel@marge.simson.net>
	 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
	 <20101021162924.GA3225@redhat.com>
	 <1288076838.11930.1.camel@marge.simson.net>
	 <1288078144.7478.9.camel@marge.simson.net>
	 <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
	 <1289489200.11397.21.camel@maggy.simson.net>
	 <20101111202703.GA16282@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 15:20:00 -0700
Message-ID: <1289514000.21413.204.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 21:27 +0100, Oleg Nesterov wrote:
> I didn't read this patch carefully (yet) but,
> 
> On 11/11, Mike Galbraith wrote:
> >
> > @@ -2569,6 +2576,7 @@ void sched_fork(struct task_struct *p, i
> >  	 * Silence PROVE_RCU.
> >  	 */
> >  	rcu_read_lock();
> > +	autogroup_fork(p);
> 
> Surely this doesn't need rcu.

No, it was just a convenient spot.

> But the real problem is that copy_process() can fail after that,
> and in this case we have the unbalanced kref_get().

Memory leak, will fix.

> > +++ linux-2.6.36.git/kernel/exit.c
> > @@ -174,6 +174,7 @@ repeat:
> >  	write_lock_irq(&tasklist_lock);
> >  	tracehook_finish_release_task(p);
> >  	__exit_signal(p);
> > +	sched_autogroup_exit(p);
> 
> This doesn't look right. Note that "p" can run/sleep after that
> (or in parallel), set_task_rq() can use the freed ->autogroup.

So avoiding refcounting rcu released task_group backfired.  Crud.

> Btw, I can't apply this patch...

It depends on the patch below from Peter, or manual fixup.

Subject: sched, cgroup: Fixup broken cgroup movement
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Oct 15 15:24:15 CEST 2010


Reported-by: Dima Zavin <dima@android.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |    8 ++++----
 kernel/sched_fair.c   |   25 +++++++++++++++++++------
 3 files changed, 24 insertions(+), 11 deletions(-)

Index: linux-2.6.36.git/kernel/sched.c
===================================================================
--- linux-2.6.36.git.orig/kernel/sched.c
+++ linux-2.6.36.git/kernel/sched.c
@@ -8297,12 +8297,12 @@ void sched_move_task(struct task_struct
 	if (unlikely(running))
 		tsk->sched_class->put_prev_task(rq, tsk);
 
-	set_task_rq(tsk, task_cpu(tsk));
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	if (tsk->sched_class->moved_group)
-		tsk->sched_class->moved_group(tsk, on_rq);
+	if (tsk->sched_class->task_move_group)
+		tsk->sched_class->task_move_group(tsk, on_rq);
+	else
 #endif
+		set_task_rq(tsk, task_cpu(tsk));
 
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
Index: linux-2.6.36.git/include/linux/sched.h
===================================================================
--- linux-2.6.36.git.orig/include/linux/sched.h
+++ linux-2.6.36.git/include/linux/sched.h
@@ -1072,7 +1072,7 @@ struct sched_class {
 					 struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	void (*moved_group) (struct task_struct *p, int on_rq);
+	void (*task_move_group) (struct task_struct *p, int on_rq);
 #endif
 };
 
Index: linux-2.6.36.git/kernel/sched_fair.c
===================================================================
--- linux-2.6.36.git.orig/kernel/sched_fair.c
+++ linux-2.6.36.git/kernel/sched_fair.c
@@ -3824,13 +3824,26 @@ static void set_curr_task_fair(struct rq
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void moved_group_fair(struct task_struct *p, int on_rq)
+static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-
-	update_curr(cfs_rq);
+	/*
+	 * If the task was not on the rq at the time of this cgroup movement
+	 * it must have been asleep, sleeping tasks keep their ->vruntime
+	 * absolute on their old rq until wakeup (needed for the fair sleeper
+	 * bonus in place_entity()).
+	 *
+	 * If it was on the rq, we've just 'preempted' it, which does convert
+	 * ->vruntime to a relative base.
+	 *
+	 * Make sure both cases convert their relative position when migrating
+	 * to another cgroup's rq. This does somewhat interfere with the
+	 * fair sleeper stuff for the first placement, but who cares.
+	 */
+	if (!on_rq)
+		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
+	set_task_rq(p, task_cpu(p));
 	if (!on_rq)
-		place_entity(cfs_rq, &p->se, 1);
+		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
 }
 #endif
 
@@ -3882,7 +3895,7 @@ static const struct sched_class fair_sch
 	.get_rr_interval	= get_rr_interval_fair,
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	.moved_group		= moved_group_fair,
+	.task_move_group	= task_move_group_fair,
 #endif
 };
 


