Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab3AHXkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:40:05 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53788 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab3AHXkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:40:02 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Chanho Min <chanho0207@gmail.com>, Chanho Min <chanho.min@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 73/77] sched/rt: Fix task stack corruption under __ARCH_WANT_INTERRUPTS_ON_CTXSW
Date: Tue, 8 Jan 2013 18:35:52 -0500
Message-ID: <1357688156-25387-74-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanho Min <chanho0207@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cb297a3e433dbdcf7ad81e0564e7b804c941ff0d upstream.

This issue happens under the following conditions:

 1. preemption is off
 2. __ARCH_WANT_INTERRUPTS_ON_CTXSW is defined
 3. RT scheduling class
 4. SMP system

Sequence is as follows:

 1.suppose current task is A. start schedule()
 2.task A is enqueued pushable task at the entry of schedule()
   __schedule
    prev = rq->curr;
    ...
    put_prev_task
     put_prev_task_rt
      enqueue_pushable_task
 4.pick the task B as next task.
   next = pick_next_task(rq);
 3.rq->curr set to task B and context_switch is started.
   rq->curr = next;
 4.At the entry of context_swtich, release this cpu's rq->lock.
   context_switch
    prepare_task_switch
     prepare_lock_switch
      raw_spin_unlock_irq(&rq->lock);
 5.Shortly after rq->lock is released, interrupt is occurred and start IRQ context
 6.try_to_wake_up() which called by ISR acquires rq->lock
    try_to_wake_up
     ttwu_remote
      rq = __task_rq_lock(p)
      ttwu_do_wakeup(rq, p, wake_flags);
        task_woken_rt
 7.push_rt_task picks the task A which is enqueued before.
   task_woken_rt
    push_rt_tasks(rq)
     next_task = pick_next_pushable_task(rq)
 8.At find_lock_lowest_rq(), If double_lock_balance() returns 0,
   lowest_rq can be the remote rq.
  (But,If preemption is on, double_lock_balance always return 1 and it
   does't happen.)
   push_rt_task
    find_lock_lowest_rq
     if (double_lock_balance(rq, lowest_rq))..
 9.find_lock_lowest_rq return the available rq. task A is migrated to
   the remote cpu/rq.
   push_rt_task
    ...
    deactivate_task(rq, next_task, 0);
    set_task_cpu(next_task, lowest_rq->cpu);
    activate_task(lowest_rq, next_task, 0);
 10. But, task A is on irq context at this cpu.
     So, task A is scheduled by two cpus at the same time until restore from IRQ.
     Task A's stack is corrupted.

To fix it, don't migrate an RT task if it's still running.

Signed-off-by: Chanho Min <chanho.min@lge.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/CAOAMb1BHA=5fm7KTewYyke6u-8DP0iUuJMpgQw54vNeXFsGpoQ@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
[PG: in 2.6.34, sched/rt.c is just sched_rt.c]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched_rt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index fd8c1a3..abd5cba 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1315,6 +1315,11 @@ static int push_rt_task(struct rq *rq)
 	if (!next_task)
 		return 0;
 
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	if (unlikely(task_running(rq, next_task)))
+		return 0;
+#endif
+
  retry:
 	if (unlikely(next_task == rq->curr)) {
 		WARN_ON(1);
-- 
1.7.12.1

