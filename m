Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab1EaHgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:36:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58181 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754431Ab1EaHgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:36:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18LC1xNUo0Lj40FdU0PMhBDD5LxI+G9kHBIbXkxPa
	8ggo9GR4ubkK2X
Subject: Re: [PATCH] sched: fix rt_nr_migratory corruption raised in
 push_rt_task()
From: Mike Galbraith <efault@gmx.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTimfOsJ91_PJdB5-H02EGS0S5eJ5cA@mail.gmail.com>
References: <BANLkTimfOsJ91_PJdB5-H02EGS0S5eJ5cA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 09:36:37 +0200
Message-ID: <1306827397.7536.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 21:39 +0800, Hillf Danton wrote:
> When pushing, if a pushable task could not be pushed, it is dequeued with no
> updating the rt_nr_migratory element of RT run-queue, then rt_nr_migratory is
> corrupted, which is fixed by removing the dequeue operation.

Hm.  I think you're right that this dequeue_pushable_task() call can be
removed, at least I didn't see it's reason for existing.  I'd word it a
bit differently though, and not return 1 unless we really did push.

From: Hillf Danton <dhillf@gmail.com>

sched, rt: fix rq->rt.pushable_tasks bug in push_rt_task()

Do not call dequeue_pushable_task() when failing to push an eligible
task, as it remains pushable, merely not at this particular moment.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
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


