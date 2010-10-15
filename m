Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0JONuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:50:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:52415 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab0JONuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:50:22 -0400
Subject: Re: [PATCH 1/2] sched: normalize sleeper's vruntime during group
 change
From: Peter Zijlstra <peterz@infradead.org>
To: Dima Zavin <dima@android.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <AANLkTimpzfCDHuVQkExLvQHaVY==SFJ2AUWO7tZkcK2T@mail.gmail.com>
References: <1285742774-5013-1-git-send-email-dima@android.com>
	 <1285843669.2144.2.camel@laptop>
	 <AANLkTikVQist_VnCcpZzU78t0TVuocwOcDPG4POVzSdv@mail.gmail.com>
	 <1285934368.2144.60.camel@laptop>
	 <AANLkTimpzfCDHuVQkExLvQHaVY==SFJ2AUWO7tZkcK2T@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 15:50:04 +0200
Message-ID: <1287150604.29097.1513.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 12:18 -0700, Dima Zavin wrote:
> >> > Please explain this stuff..
> >>
> >> The situation today is quite bad for sleeping tasks. Currently, when
> >> you move a sleeping thread between cgroups, the thread can retain its
> >> old vruntime value if the old group was far ahead of the new group
> >> since it essentially does a max(se->vruntime, new_vruntime) in
> >> place_entity. This can prevent the task from running for a very long
> >> time. That is what this patch was trying to address. It normalizes the
> >> sleeper thread's vruntime before moving it to the new group.
> >>
> >>
> >
> > Hrm,.. ok, I tend to not use this cgroup gunk more that I absolutely
> > have to, so I'll take your word for it.
> >
> > But doesn't normal cross-cpu task migration already solve this problem?
> > Therefore wouldn't it be possible to adapt/extend that code to also deal
> > with this particular issue?
> 
> It does, but from what I can tell it does so lazily for sleeping
> tasks, i.e. the logic is in try_to_wake_up(). The cgroup attach moves
> the task immediately, so when we attempt to wake it up it will already
> be too late for the wake_up code to do the right thing since the task
> has the new cpu_rq assigned from sched_move_task(). The wakeup logic
> will not have the old group info.

Wouldn't something like the below work as expected?

---
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

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -8388,12 +8388,12 @@ void sched_move_task(struct task_struct 
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
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1073,7 +1073,7 @@ struct sched_class {
 					 struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	void (*moved_group) (struct task_struct *p, int on_rq);
+	void (*task_move_group) (struct task_struct *p, int on_rq);
 #endif
 };
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -3831,13 +3831,26 @@ static void set_curr_task_fair(struct rq
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
 
@@ -3889,7 +3902,7 @@ static const struct sched_class fair_sch
 	.get_rr_interval	= get_rr_interval_fair,
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	.moved_group		= moved_group_fair,
+	.task_move_group	= task_move_group_fair,
 #endif
 };
 

