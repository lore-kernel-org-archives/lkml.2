Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab1FACPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 22:15:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33059 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933096Ab1FACPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 22:15:02 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/tT5ssHm/tSwRf+GGpqn2Qrg9awQeqMevwmuKXtB
	uDHh8Uek1oidoo
Subject: [PATCH] sched, rt: fix rq->rt.pushable_tasks bug in push_rt_task()
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1306854480.11899.29.camel@gandalf.stny.rr.com>
References: <BANLkTimfOsJ91_PJdB5-H02EGS0S5eJ5cA@mail.gmail.com>
	 <1306827397.7536.10.camel@marge.simson.net>
	 <BANLkTi=YXK7pCJqei6oz4dzLzHgJC_m=2g@mail.gmail.com>
	 <1306854480.11899.29.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 04:14:53 +0200
Message-ID: <1306894493.4791.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 11:08 -0400, Steven Rostedt wrote:
> On Tue, 2011-05-31 at 21:56 +0800, Hillf Danton wrote:
> > On Tue, May 31, 2011 at 3:36 PM, Mike Galbraith <efault@gmx.de> wrote:
> > > On Mon, 2011-05-30 at 21:39 +0800, Hillf Danton wrote:
> > >> When pushing, if a pushable task could not be pushed, it is dequeued with no
> > >> updating the rt_nr_migratory element of RT run-queue, then rt_nr_migratory is
> > >> corrupted, which is fixed by removing the dequeue operation.
> > >
> > > Hm.  I think you're right that this dequeue_pushable_task() call can be
> > > removed, at least I didn't see it's reason for existing.  I'd word it a
> > > bit differently though, and not return 1 unless we really did push.
> > >
> > 
> > Hi Mike
> > 
> > Your message shows what is called professional work, but something lost,
> > 
> > > From: Hillf Danton <dhillf@gmail.com>
> > >
> > > sched, rt: fix rq->rt.pushable_tasks bug in push_rt_task()
> > >
> > > Do not call dequeue_pushable_task() when failing to push an eligible
> > > task, as it remains pushable, merely not at this particular moment.
> > >
> > > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > 
> 
> Yeah, Mike, can you remail this adding your SOB too. You can keep
> Hillf's SOB as well, since both of you made changes.

From: Hillf Danton <dhillf@gmail.com>
AuthorDate: Mon, 30 May 2011 21:39:50 +0800

sched, rt: fix rq->rt.pushable_tasks bug in push_rt_task()

Do not call dequeue_pushable_task() when failing to push an eligible
task, as it remains pushable until either it's cpumask says otherwise,
or is selected.  It is merely not pushable at this particular moment.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 kernel/sched_rt.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6.40.git/kernel/sched_rt.c
===================================================================
--- linux-2.6.40.git.orig/kernel/sched_rt.c
+++ linux-2.6.40.git/kernel/sched_rt.c
@@ -1378,6 +1378,7 @@ static int push_rt_task(struct rq *rq)
 {
 	struct task_struct *next_task;
 	struct rq *lowest_rq;
+	int ret = 0;
 
 	if (!rq->rt.overloaded)
 		return 0;
@@ -1410,7 +1411,7 @@ retry:
 	if (!lowest_rq) {
 		struct task_struct *task;
 		/*
-		 * find lock_lowest_rq releases rq->lock
+		 * find_lock_lowest_rq releases rq->lock
 		 * so it is possible that next_task has migrated.
 		 *
 		 * We need to make sure that the task is still on the same
@@ -1420,12 +1421,11 @@ retry:
 		task = pick_next_pushable_task(rq);
 		if (task_cpu(next_task) == rq->cpu && task == next_task) {
 			/*
-			 * If we get here, the task hasn't moved at all, but
-			 * it has failed to push.  We will not try again,
-			 * since the other cpus will pull from us when they
-			 * are ready.
+			 * The task hasn't migrated, and is still the next
+			 * eligible task, but we failed to find a run-queue
+			 * to push it to.  Do not retry in this case, since
+			 * other cpus will pull from us when ready.
 			 */
-			dequeue_pushable_task(rq, next_task);
 			goto out;
 		}
 
@@ -1444,6 +1444,7 @@ retry:
 	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, lowest_rq->cpu);
 	activate_task(lowest_rq, next_task, 0);
+	ret = 1;
 
 	resched_task(lowest_rq->curr);
 
@@ -1452,7 +1453,7 @@ retry:
 out:
 	put_task_struct(next_task);
 
-	return 1;
+	return ret;
 }
 
 static void push_rt_tasks(struct rq *rq)


