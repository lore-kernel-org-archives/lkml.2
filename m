Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab2INGNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:13:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48939 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2INGNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:13:40 -0400
Date: Thu, 13 Sep 2012 23:13:13 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-g9p2a1w81xxbrze25v9zpzbf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        catalin.marinas@arm.com, a.p.zijlstra@chello.nl, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, catalin.marinas@arm.com, tglx@linutronix.de,
        oleg@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW
Git-Commit-ID: f3e947867478af9a12b9956bcd000ac7613a8a95
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:13:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3e947867478af9a12b9956bcd000ac7613a8a95
Gitweb:     http://git.kernel.org/tip/f3e947867478af9a12b9956bcd000ac7613a8a95
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 12 Sep 2012 11:22:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 16:52:04 +0200

sched: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW

Now that the last architecture to use this has stopped doing so (ARM,
thanks Catalin!) we can remove this complexity from the scheduler
core.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Link: http://lkml.kernel.org/n/tip-g9p2a1w81xxbrze25v9zpzbf@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/scheduler/sched-arch.txt |   10 --------
 include/linux/sched.h                  |    5 ----
 kernel/fork.c                          |    4 ---
 kernel/sched/core.c                    |   40 +-------------------------------
 kernel/sched/rt.c                      |    5 ----
 kernel/sched/sched.h                   |    6 ----
 6 files changed, 1 insertions(+), 69 deletions(-)

diff --git a/Documentation/scheduler/sched-arch.txt b/Documentation/scheduler/sched-arch.txt
index 28aa107..b1b8587 100644
--- a/Documentation/scheduler/sched-arch.txt
+++ b/Documentation/scheduler/sched-arch.txt
@@ -17,16 +17,6 @@ you must `#define __ARCH_WANT_UNLOCKED_CTXSW` in a header file
 Unlocked context switches introduce only a very minor performance
 penalty to the core scheduler implementation in the CONFIG_SMP case.
 
-2. Interrupt status
-By default, the switch_to arch function is called with interrupts
-disabled. Interrupts may be enabled over the call if it is likely to
-introduce a significant interrupt latency by adding the line
-`#define __ARCH_WANT_INTERRUPTS_ON_CTXSW` in the same place as for
-unlocked context switches. This define also implies
-`__ARCH_WANT_UNLOCKED_CTXSW`. See arch/arm/include/asm/system.h for an
-example.
-
-
 CPU idle
 ========
 Your cpu_idle routines need to obey the following rules:
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f3eebc1..60e5e38 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -678,11 +678,6 @@ struct signal_struct {
 					 * (notably. ptrace) */
 };
 
-/* Context switch must be unlocked if interrupts are to be enabled */
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-# define __ARCH_WANT_UNLOCKED_CTXSW
-#endif
-
 /*
  * Bits in flags field of signal_struct.
  */
diff --git a/kernel/fork.c b/kernel/fork.c
index 2c8857e..743d48f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1280,11 +1280,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #endif
 #ifdef CONFIG_TRACE_IRQFLAGS
 	p->irq_events = 0;
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	p->hardirqs_enabled = 1;
-#else
 	p->hardirqs_enabled = 0;
-#endif
 	p->hardirq_enable_ip = 0;
 	p->hardirq_enable_event = 0;
 	p->hardirq_disable_ip = _THIS_IP_;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c46a011..8b51b2d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1361,25 +1361,6 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
 		smp_send_reschedule(cpu);
 }
 
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-static int ttwu_activate_remote(struct task_struct *p, int wake_flags)
-{
-	struct rq *rq;
-	int ret = 0;
-
-	rq = __task_rq_lock(p);
-	if (p->on_cpu) {
-		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
-		ttwu_do_wakeup(rq, p, wake_flags);
-		ret = 1;
-	}
-	__task_rq_unlock(rq);
-
-	return ret;
-
-}
-#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
-
 bool cpus_share_cache(int this_cpu, int that_cpu)
 {
 	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
@@ -1440,21 +1421,8 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	 * If the owning (remote) cpu is still in the middle of schedule() with
 	 * this task as prev, wait until its done referencing the task.
 	 */
-	while (p->on_cpu) {
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-		/*
-		 * In case the architecture enables interrupts in
-		 * context_switch(), we cannot busy wait, since that
-		 * would lead to deadlocks when an interrupt hits and
-		 * tries to wake up @prev. So bail and do a complete
-		 * remote wakeup.
-		 */
-		if (ttwu_activate_remote(p, wake_flags))
-			goto stat;
-#else
+	while (p->on_cpu)
 		cpu_relax();
-#endif
-	}
 	/*
 	 * Pairs with the smp_wmb() in finish_lock_switch().
 	 */
@@ -1798,13 +1766,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	prev_state = prev->state;
 	account_switch_vtime(prev);
 	finish_arch_switch(prev);
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	local_irq_disable();
-#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	perf_event_task_sched_in(prev, current);
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	local_irq_enable();
-#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
 	finish_arch_post_lock_switch();
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e0b7ba9..418feb0 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1632,11 +1632,6 @@ static int push_rt_task(struct rq *rq)
 	if (!next_task)
 		return 0;
 
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-       if (unlikely(task_running(rq, next_task)))
-               return 0;
-#endif
-
 retry:
 	if (unlikely(next_task == rq->curr)) {
 		WARN_ON(1);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0987169..7a7db09 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -737,11 +737,7 @@ static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 	 */
 	next->on_cpu = 1;
 #endif
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	raw_spin_unlock_irq(&rq->lock);
-#else
 	raw_spin_unlock(&rq->lock);
-#endif
 }
 
 static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
@@ -755,9 +751,7 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 	smp_wmb();
 	prev->on_cpu = 0;
 #endif
-#ifndef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 	local_irq_enable();
-#endif
 }
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
