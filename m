Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1EVLx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 07:53:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38212 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1EVLxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 07:53:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BPBeYNvv5KRWLyzMpmd5HQu5E+nE1TSTFMVx3ta0F7tDiDfpVtnKBgsXoqbW/LqipO
         eSQTXDBRt7a3fqzuzdSlmdv4iqiZ1jR1hY6zy1ZLHcJaaRUHDwqBClmzq6B8OgYsPvLV
         ms4hdo9/ghGsliGvgsD2PJ+WI9L0pnelCuvHE=
MIME-Version: 1.0
In-Reply-To: <BANLkTimF2d93VVGKHDdFTn=V-1h9nWrs_w@mail.gmail.com>
References: <BANLkTimF2d93VVGKHDdFTn=V-1h9nWrs_w@mail.gmail.com>
Date: Sun, 22 May 2011 19:53:21 +0800
Message-ID: <BANLkTinZcna-34zETqhR0h0G9CYvAn+-0w@mail.gmail.com>
Subject: Re: [PATCH v0] sched: change how run-queue is selected for RT task
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 11:28 PM, Hillf Danton <dhillf@gmail.com> wrote:
> When selecting run-queue for a given RT task, we have to take a few
> factors, such as task priority and CPU cache affinity, into
> consideration. In this work, a simpler method is proposed, which is
> focusing on the relation between the current run-queue of the given
> task and the given run-queue.
>
> If the current run-queue of task is the given run-queue, the run-queue
> of task keeps unchanged, so the CPU cache affinities of both task and
> the current task of run-queue remain unchanged. Then there are at
> least two tasks competing one CPU, and in the worst case that both
> competitors are RT tasks the victim will be selected and processed by
> pusher later.
>
> On other hand, if the current run-queue of task is different from the
> given run-queue, task is simply delivered to its current run-queue,
> since pusher is always willing to do hard works.
>
> In summary, the burden of RT task is always processed first by the
> pusher of its current run-queue.
>

If only the run-queue of task is concerned, a simpler version is prepared,
in which the current run-queue of task is fine.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

 kernel/sched_rt.c |   27 ++-------------------------
 1 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 19ecb31..3e97a94 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -979,19 +979,9 @@ static int find_lowest_rq(struct task_struct *task);
 static int
 select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 {
-	struct task_struct *curr;
-	struct rq *rq;
-	int cpu;
-
 	if (sd_flag != SD_BALANCE_WAKE)
 		return smp_processor_id();

-	cpu = task_cpu(p);
-	rq = cpu_rq(cpu);
-
-	rcu_read_lock();
-	curr = ACCESS_ONCE(rq->curr); /* unlocked access */
-
 	/*
 	 * If the current task on @p's runqueue is an RT task, then
 	 * try to see if we can wake this RT task up on another
@@ -1009,23 +999,10 @@ select_task_rq_rt(struct task_struct *p, int
sd_flag, int flags)
 	 * For equal prio tasks, we just let the scheduler sort it out.
 	 *
 	 * Otherwise, just let it ride on the affined RQ and the
-	 * post-schedule router will push the preempted task away
-	 *
-	 * This test is optimistic, if we get it wrong the load-balancer
-	 * will have to sort it out.
+	 * post-schedule router will select and push the victim task away.
 	 */
-	if (curr && unlikely(rt_task(curr)) &&
-	    (curr->rt.nr_cpus_allowed < 2 ||
-	     curr->prio < p->prio) &&
-	    (p->rt.nr_cpus_allowed > 1)) {
-		int target = find_lowest_rq(p);
-
-		if (target != -1)
-			cpu = target;
-	}
-	rcu_read_unlock();

-	return cpu;
+	return task_cpu(p);
 }

 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
