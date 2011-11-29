Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1K2MsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:48:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:42476 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1K2MsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:48:18 -0500
Message-ID: <1322570881.2921.230.camel@twins>
Subject: Re: [RFC PATCH 0/6] ARM: Remove the __ARCH_WANT_INTERRUPTS_ON_CTXSW
 definition
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Date: Tue, 29 Nov 2011 13:48:01 +0100
In-Reply-To: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
References: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 12:22 +0000, Catalin Marinas wrote:
> Hi,
> 
> This set of patches removes the use of __ARCH_WANT_INTERRUPTS_ON_CTXSW
> on ARM.
> 
> As a background, the ARM architecture versions consist of two main sets
> with regards to the MMU switching needs:
> 
> 1. ARMv5 and earlier have VIVT caches and they require a full cache and
>    TLB flush at every context switch.
> 2. ARMv6 and later have VIPT caches and the TLBs are tagged with an ASID
>    (application specific ID). The number of ASIDs is limited to 256 and
>    the allocation algorithm requires IPIs when all the ASIDs have been
>    used.
> 
> Both cases above require interrupts enabled during context switch for
> latency reasons (1) or deadlock avoidance (2).
> 
> The first patch in the series introduces a new scheduler hook invoked
> after the rq->lock is released and interrupts enabled. The subsequent
> two patches change the ARM context switching code (for processors in
> category 2 above) to use a reserved TTBR value instead of a reserved
> ASID. The 4th patch removes the __ARCH_WANT_INTERRUPTS_ON_CTXSW
> definition for ASID-capable processors by deferring the new ASID
> allocation to the post-lock switch hook.
> 
> The last patch also removes __ARCH_WANT_INTERRUPTS_ON_CTXSW for ARMv5
> and earlier processors. It defers the cpu_switch_mm call to the
> post-lock switch hook. Since this is only running on UP systems and the
> preemption is disabled during context switching, it assumes that the old
> mm is still valid until the post-lock switch hook.

Yeah, see how there's a if (mm) mmdrop(mm) after that.

> The series has been tested on Cortex-A9 (vexpress) and ARM926
> (versatile). Comments are welcome.

Yay!!! Although there's a tiny merge conflict between your tree and tip,
we moved kernel/sched.c around, you'll find it in kernel/sched/core.c
after you merge up.

---
Subject: sched: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Nov 29 13:44:40 CET 2011

Now that the last user is dead, remove support for
__ARCH_WANT_INTERRUPTS_ON_CTXSW.

Much-thanks-to: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/fork.c        |    4 ----
 kernel/sched/core.c  |   40 +---------------------------------------
 kernel/sched/sched.h |    6 ------
 3 files changed, 1 insertion(+), 49 deletions(-)

Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -1191,11 +1191,7 @@ static struct task_struct *copy_process(
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
Index: linux-2.6/kernel/sched/core.c
===================================================================
--- linux-2.6.orig/kernel/sched/core.c
+++ linux-2.6/kernel/sched/core.c
@@ -1460,25 +1460,6 @@ static void ttwu_queue_remote(struct tas
 	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
 		smp_send_reschedule(cpu);
 }
-
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
 #endif /* CONFIG_SMP */
 
 static int ttwu_share_cache(int this_cpu, int cpu)
@@ -1559,21 +1540,8 @@ try_to_wake_up(struct task_struct *p, un
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
@@ -1916,13 +1884,7 @@ static void finish_task_switch(struct rq
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	local_irq_disable();
-#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	perf_event_task_sched_in(prev, current);
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-	local_irq_enable();
-#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
 
 	fire_sched_in_preempt_notifiers(current);
Index: linux-2.6/kernel/sched/sched.h
===================================================================
--- linux-2.6.orig/kernel/sched/sched.h
+++ linux-2.6/kernel/sched/sched.h
@@ -685,11 +685,7 @@ static inline void prepare_lock_switch(s
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
@@ -703,9 +699,7 @@ static inline void finish_lock_switch(st
 	smp_wmb();
 	prev->on_cpu = 0;
 #endif
-#ifndef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 	local_irq_enable();
-#endif
 }
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 

