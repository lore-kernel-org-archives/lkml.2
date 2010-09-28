Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663Ab0I1GH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 02:07:27 -0400
Received: from smtp-out.google.com ([74.125.121.35]:45550 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab0I1GHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 02:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=jBBBClEYhafplywv/3vOAnAL970AkY9G5uQero1rCjjcrlFyC6zxtbMqSXZ/EKew9f
         rMqR6qHYcFAW/lv2v4mQ==
MIME-Version: 1.0
Date: Mon, 27 Sep 2010 23:07:21 -0700
Message-ID: <AANLkTinmQOYQAOPkQsZNhJBJtCss3ZtHN_a6h4fpamtz@mail.gmail.com>
Subject: broken behavior in cfs when moving threads between cgroups
From: Dima Zavin <dmitriyz@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Arve and I have observed some broken behavior with CFS + cgroups and were hoping
someone offers some advice on fixing the problem(s). Please correct me
if my understanding
of how this stuff fits together is incorrect.

We see an issue that if you switch the cgroup of a sleeping thread,
its vruntime does not get adjusted correctly for the difference between
the min_vruntime values of the two groups. (Issue #1).

Then, there's an issue regarding how vruntime of a runnable thread
gets normalized when it is removed from a group. The group's min_vruntime
is subtracted from the thread's vruntime AFTER min_vruntime has
been re-calculated. (Issue #2)

Below is a more detailed description of what we are experiencing, and
potential fixes.

We have roughly the following scenario:

We have two cgroups A and C. CPU time allocated as follows:
A/cpu.shares == 1024
C/cpu.shares == 52

We generally refer to group A as "foreground" and C as "background".
There are many tasks in the system, two of which are X and Y.
Task X is in group A (foreground group)
Task Y is in group C (background group)

X has finished executing and went into a sleeping state. A.min_vruntime
is ahead of C.min_vruntime, and hence task X is ahead of task Y.

Issue #1:
A controlling entity moves task X, while it's in the sleeping state,
from group A to group C. Since the task was sleeping, it's vruntime
was not normalized and thus still had the A.min_vruntime added in.
During task's migration from group A to group C, the value is never
adjusted for the difference between the two groups.  In sched_move_task(),
on_rq and running are both false, so the task is not dequeued and the old
value still remains. So, we call moved_group_fair() which calls place_entity(),
which takes the max of se->vruntime and C.min_vruntime + slice/whatever. Since
the 'se' is coming from group A, it's vruntime is way ahead of
C.min_vruntime and
thus se.vruntime ends up being way ahead of the other tasks in group
C. This will prevent X from getting much CPU time until the other
tasks catch up or
block.

Issue #2:
Some time after the situation in issue #1, we now have tasks X and Y in group C.
Relatively speaking, Y.vruntime << X.vruntime still.
At some point, X and Y both became runnable, and got placed on the cfs_rq, but
there is no cfs_rq->curr task yet.  Y is the cfs_rq->rb_leftmost and thus
C.min_vruntime == Y.vruntime. We now decide to move task Y from group
C to group A.
We again call sched_move_task(). This time, we end up calling
dequeue_task() since
on_rq is true, which calls dequeue_task_fair(). This ends up calling
dequeue_entity(),
which takes task Y out of the rb_tree, and calculates the new C.min_vruntime.
Since the only task left on the runqueue is X, with its really high
vruntime due to issue #1, now C.min_vruntime = X.vruntime. This new (large)
C.min_vruntime is subtracted from Y.vruntime, and thus Y.vruntime
becomes a (often large) negative value. When it is enqueued onto the new group,
it will appear to be way behind the other threads in the new group and
will get a huge
boost in CPU time.

I'm not really sure how to fix #1 cleanly, since we don't have enough
information (i.e. we don't know the previous group) inside
moved_group_fair() to adjust the value. It has to be adjusted in
sched_move_task(), but I don't see the right interface to do that. I
included a hacky patch further down that accesses the sched_fair internals
directly, which I know is wrong but illustrates what I think needs to be done.

Here's the hacky attempt for addressing #1. What's the right way to do this?

--- snip ---

diff --git a/kernel/sched.c b/kernel/sched.c
index 4c460a9..d51833b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8097,11 +8097,20 @@ void sched_move_task(struct task_struct *tsk)

        if (on_rq)
                dequeue_task(rq, tsk, 0);
+       else if (!running) {
+               tsk->se.vruntime -= cfs_rq_of(&tsk->se)->min_vruntime;
+               if (tsk->se.vruntime < 0)
+                       tsk->se.vruntime = 0;
+       }
+
        if (unlikely(running))
                tsk->sched_class->put_prev_task(rq, tsk);

        set_task_rq(tsk, task_cpu(tsk));

+       if (!on_rq && !running)
+               tsk->se.vruntime += cfs_rq_of(&tsk->se)->min_vruntime;
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
        if (tsk->sched_class->moved_group)
                tsk->sched_class->moved_group(tsk, on_rq);

--- snip ---

This should fix #2. If this makes sense, I'll send a real patch.

---- snip ----

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a878b53..a7be83c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -802,6 +802,8 @@ static void clear_buddies(struct cfs_rq *cfs_rq,
struct sched_entity *se)
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
+       u64 min_vruntime;
+
        /*
         * Update run-time statistics of the 'current'.
         */
@@ -826,6 +828,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct
sched_entity *se, int flags)
        if (se != cfs_rq->curr)
                __dequeue_entity(cfs_rq, se);
        account_entity_dequeue(cfs_rq, se);
+
+       min_vruntime = cfs_rq->min_vruntime;
        update_min_vruntime(cfs_rq);

        /*
@@ -834,7 +838,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct
sched_entity *se, int flags)
         * movement in our normalized position.
         */
        if (!(flags & DEQUEUE_SLEEP))
-               se->vruntime -= cfs_rq->min_vruntime;
+               se->vruntime -= min_vruntime;
 }


Thank you very much in advance for your help.

--Dima
