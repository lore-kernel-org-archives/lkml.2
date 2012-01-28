Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab2A1MGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 07:06:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56518 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab2A1MGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 07:06:38 -0500
Date: Sat, 28 Jan 2012 04:06:06 -0800
From: tip-bot for Chanho Min <chanho0207@gmail.com>
Message-ID: <tip-cb297a3e433dbdcf7ad81e0564e7b804c941ff0d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, chanho.min@lge.com, chanho0207@gmail.com,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, chanho0207@gmail.com,
        chanho.min@lge.com, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <CAOAMb1BHA=5fm7KTewYyke6u-8DP0iUuJMpgQw54vNeXFsGpoQ@mail.gmail.com>
References: <CAOAMb1BHA=5fm7KTewYyke6u-8DP0iUuJMpgQw54vNeXFsGpoQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt:
  Fix task stack corruption under __ARCH_WANT_INTERRUPTS_ON_CTXSW
Git-Commit-ID: cb297a3e433dbdcf7ad81e0564e7b804c941ff0d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Jan 2012 04:06:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb297a3e433dbdcf7ad81e0564e7b804c941ff0d
Gitweb:     http://git.kernel.org/tip/cb297a3e433dbdcf7ad81e0564e7b804c941ff0d
Author:     Chanho Min <chanho0207@gmail.com>
AuthorDate: Thu, 5 Jan 2012 20:00:19 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 27 Jan 2012 12:49:41 +0100

sched/rt: Fix task stack corruption under __ARCH_WANT_INTERRUPTS_ON_CTXSW

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
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/CAOAMb1BHA=5fm7KTewYyke6u-8DP0iUuJMpgQw54vNeXFsGpoQ@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/rt.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 3640ebb..f42ae7f 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1587,6 +1587,11 @@ static int push_rt_task(struct rq *rq)
 	if (!next_task)
 		return 0;
 
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+       if (unlikely(task_running(rq, next_task)))
+               return 0;
+#endif
+
 retry:
 	if (unlikely(next_task == rq->curr)) {
 		WARN_ON(1);
