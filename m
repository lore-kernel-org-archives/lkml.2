Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0FXDFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:05:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:9746 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab0FXDFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:05:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,471,1272870000"; 
   d="scan'208";a="810964568"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Huang Ying <ying.huang@intel.com>
Subject: [RFC 1/5] Make soft_irq NMI safe
Date: Thu, 24 Jun 2010 11:04:54 +0800
Message-Id: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NMI can be triggered even when IRQ is masked, so many kernel services
can not be used in NMI handler.  It is necessary for NMI handler to
trigger some operations in other contexts such as IRQ and process.  To
do this, this patch makes soft_irq mechanism usable for NMI handler.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/ia64/include/asm/hardirq.h     |    2 -
 arch/powerpc/include/asm/hardirq.h  |    2 -
 arch/powerpc/kernel/irq.c           |    2 -
 arch/s390/include/asm/hardirq.h     |    2 -
 arch/s390/kernel/irq.c              |    2 -
 arch/sh/kernel/irq.c                |    2 -
 arch/sparc/include/asm/hardirq_64.h |    2 -
 arch/sparc/kernel/irq_64.c          |    2 -
 arch/x86/include/asm/hardirq.h      |    7 ----
 arch/x86/kernel/irq_32.c            |    2 -
 arch/x86/kernel/irq_64.c            |    2 -
 block/blk-iopoll.c                  |    6 +--
 block/blk-softirq.c                 |    6 +--
 include/linux/interrupt.h           |   10 +----
 include/linux/irq_cpustat.h         |    2 -
 kernel/hrtimer.c                    |    4 +-
 kernel/softirq.c                    |   61 +++++++++++++++++-------------------
 kernel/time/tick-sched.c            |    6 +--
 net/core/dev.c                      |   14 ++++----
 19 files changed, 62 insertions(+), 74 deletions(-)

--- a/arch/ia64/include/asm/hardirq.h
+++ b/arch/ia64/include/asm/hardirq.h
@@ -18,7 +18,7 @@
 
 #define __ARCH_IRQ_STAT	1
 
-#define local_softirq_pending()		(local_cpu_data->softirq_pending)
+#define local_softirq_pending()		(&local_cpu_data->softirq_pending)
 
 extern void __iomem *ipi_base_addr;
 
--- a/arch/powerpc/include/asm/hardirq.h
+++ b/arch/powerpc/include/asm/hardirq.h
@@ -16,7 +16,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpust
 
 #define __ARCH_IRQ_STAT
 
-#define local_softirq_pending()	__get_cpu_var(irq_stat).__softirq_pending
+#define local_softirq_pending()	(&__get_cpu_var(irq_stat).__softirq_pending)
 
 static inline void ack_bad_irq(unsigned int irq)
 {
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -505,7 +505,7 @@ void do_softirq(void)
 
 	local_irq_save(flags);
 
-	if (local_softirq_pending())
+	if (*local_softirq_pending())
 		do_softirq_onstack();
 
 	local_irq_restore(flags);
--- a/arch/s390/include/asm/hardirq.h
+++ b/arch/s390/include/asm/hardirq.h
@@ -18,7 +18,7 @@
 #include <linux/interrupt.h>
 #include <asm/lowcore.h>
 
-#define local_softirq_pending() (S390_lowcore.softirq_pending)
+#define local_softirq_pending() (&S390_lowcore.softirq_pending)
 
 #define __ARCH_IRQ_STAT
 #define __ARCH_HAS_DO_SOFTIRQ
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -70,7 +70,7 @@ asmlinkage void do_softirq(void)
 
 	local_irq_save(flags);
 
-	if (local_softirq_pending()) {
+	if (*local_softirq_pending()) {
 		/* Get current stack pointer. */
 		asm volatile("la %0,0(15)" : "=a" (old));
 		/* Check against async. stack address range. */
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -212,7 +212,7 @@ asmlinkage void do_softirq(void)
 
 	local_irq_save(flags);
 
-	if (local_softirq_pending()) {
+	if (*local_softirq_pending()) {
 		curctx = current_thread_info();
 		irqctx = softirq_ctx[smp_processor_id()];
 		irqctx->tinfo.task = curctx->task;
--- a/arch/sparc/include/asm/hardirq_64.h
+++ b/arch/sparc/include/asm/hardirq_64.h
@@ -10,7 +10,7 @@
 
 #define __ARCH_IRQ_STAT
 #define local_softirq_pending() \
-	(local_cpu_data().__softirq_pending)
+	(&local_cpu_data().__softirq_pending)
 
 void ack_bad_irq(unsigned int irq);
 
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -770,7 +770,7 @@ void do_softirq(void)
 
 	local_irq_save(flags);
 
-	if (local_softirq_pending()) {
+	if (*local_softirq_pending()) {
 		void *orig_sp, *sp = softirq_stack[smp_processor_id()];
 
 		sp += THREAD_SIZE - 192 - STACK_BIAS;
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -37,12 +37,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpust
 
 #define inc_irq_stat(member)	percpu_inc(irq_stat.member)
 
-#define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
-
-#define __ARCH_SET_SOFTIRQ_PENDING
-
-#define set_softirq_pending(x)	percpu_write(irq_stat.__softirq_pending, (x))
-#define or_softirq_pending(x)	percpu_or(irq_stat.__softirq_pending, (x))
+#define local_softirq_pending()	(&__get_cpu_var(irq_stat.__softirq_pending))
 
 extern void ack_bad_irq(unsigned int irq);
 
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -168,7 +168,7 @@ asmlinkage void do_softirq(void)
 
 	local_irq_save(flags);
 
-	if (local_softirq_pending()) {
+	if (*local_softirq_pending()) {
 		curctx = current_thread_info();
 		irqctx = __get_cpu_var(softirq_ctx);
 		irqctx->tinfo.task = curctx->task;
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -74,7 +74,7 @@ asmlinkage void do_softirq(void)
 		return;
 
 	local_irq_save(flags);
-	pending = local_softirq_pending();
+	pending = *local_softirq_pending();
 	/* Switch to interrupt stack */
 	if (pending) {
 		call_softirq();
--- a/block/blk-iopoll.c
+++ b/block/blk-iopoll.c
@@ -36,7 +36,7 @@ void blk_iopoll_sched(struct blk_iopoll
 
 	local_irq_save(flags);
 	list_add_tail(&iop->list, &__get_cpu_var(blk_cpu_iopoll));
-	__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
+	__raise_softirq_preempt_off(BLOCK_IOPOLL_SOFTIRQ);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(blk_iopoll_sched);
@@ -132,7 +132,7 @@ static void blk_iopoll_softirq(struct so
 	}
 
 	if (rearm)
-		__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
+		__raise_softirq_preempt_off(BLOCK_IOPOLL_SOFTIRQ);
 
 	local_irq_enable();
 }
@@ -202,7 +202,7 @@ static int __cpuinit blk_iopoll_cpu_noti
 		local_irq_disable();
 		list_splice_init(&per_cpu(blk_cpu_iopoll, cpu),
 				 &__get_cpu_var(blk_cpu_iopoll));
-		__raise_softirq_irqoff(BLOCK_IOPOLL_SOFTIRQ);
+		__raise_softirq_preempt_off(BLOCK_IOPOLL_SOFTIRQ);
 		local_irq_enable();
 	}
 
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -47,7 +47,7 @@ static void trigger_softirq(void *data)
 	list_add_tail(&rq->csd.list, list);
 
 	if (list->next == &rq->csd.list)
-		raise_softirq_irqoff(BLOCK_SOFTIRQ);
+		raise_softirq_preempt_off(BLOCK_SOFTIRQ);
 
 	local_irq_restore(flags);
 }
@@ -90,7 +90,7 @@ static int __cpuinit blk_cpu_notify(stru
 		local_irq_disable();
 		list_splice_init(&per_cpu(blk_cpu_done, cpu),
 				 &__get_cpu_var(blk_cpu_done));
-		raise_softirq_irqoff(BLOCK_SOFTIRQ);
+		raise_softirq_preempt_off(BLOCK_SOFTIRQ);
 		local_irq_enable();
 	}
 
@@ -134,7 +134,7 @@ do_local:
 		 * hasn't run yet.
 		 */
 		if (list->next == &req->csd.list)
-			raise_softirq_irqoff(BLOCK_SOFTIRQ);
+			raise_softirq_preempt_off(BLOCK_SOFTIRQ);
 	} else if (raise_blk_irq(ccpu, req))
 		goto do_local;
 
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -347,11 +347,6 @@ static inline int disable_irq_wake(unsig
 }
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
-#ifndef __ARCH_SET_SOFTIRQ_PENDING
-#define set_softirq_pending(x) (local_softirq_pending() = (x))
-#define or_softirq_pending(x)  (local_softirq_pending() |= (x))
-#endif
-
 /* Some architectures might implement lazy enabling/disabling of
  * interrupts. In some cases, such as stop_machine, we might want
  * to ensure that after a local_irq_disable(), interrupts have
@@ -402,8 +397,9 @@ asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
 extern void open_softirq(int nr, void (*action)(struct softirq_action *));
 extern void softirq_init(void);
-#define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
-extern void raise_softirq_irqoff(unsigned int nr);
+#define __raise_softirq_preempt_off(nr)					\
+	do { set_bit(nr, (unsigned long *)local_softirq_pending()); } while (0)
+extern void raise_softirq_preempt_off(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
 extern void wakeup_softirqd(void);
 
--- a/include/linux/irq_cpustat.h
+++ b/include/linux/irq_cpustat.h
@@ -23,7 +23,7 @@ extern irq_cpustat_t irq_stat[];		/* def
 
   /* arch independent irq_stat fields */
 #define local_softirq_pending() \
-	__IRQ_STAT(smp_processor_id(), __softirq_pending)
+	(&__IRQ_STAT(smp_processor_id(), __softirq_pending))
 
   /* arch dependent irq_stat fields */
 #define nmi_count(cpu)		__IRQ_STAT((cpu), __nmi_count)	/* i386 */
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -695,10 +695,10 @@ static inline int hrtimer_enqueue_reprog
 	if (base->cpu_base->hres_active && hrtimer_reprogram(timer, base)) {
 		if (wakeup) {
 			raw_spin_unlock(&base->cpu_base->lock);
-			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+			raise_softirq_preempt_off(HRTIMER_SOFTIRQ);
 			raw_spin_lock(&base->cpu_base->lock);
 		} else
-			__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+			__raise_softirq_preempt_off(HRTIMER_SOFTIRQ);
 
 		return 1;
 	}
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -155,7 +155,7 @@ static inline void _local_bh_enable_ip(u
  	 */
  	sub_preempt_count(SOFTIRQ_OFFSET - 1);
 
-	if (unlikely(!in_interrupt() && local_softirq_pending()))
+	if (unlikely(!in_interrupt() && *local_softirq_pending()))
 		do_softirq();
 
 	dec_preempt_count();
@@ -191,22 +191,22 @@ EXPORT_SYMBOL(local_bh_enable_ip);
 asmlinkage void __do_softirq(void)
 {
 	struct softirq_action *h;
-	__u32 pending;
+	__u32 pending, *ppending;
 	int max_restart = MAX_SOFTIRQ_RESTART;
 	int cpu;
 
-	pending = local_softirq_pending();
+	ppending = local_softirq_pending();
 	account_system_vtime(current);
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0));
 	lockdep_softirq_enter();
 
 	cpu = smp_processor_id();
-restart:
-	/* Reset the pending bitmask before enabling irqs */
-	set_softirq_pending(0);
 
 	local_irq_enable();
+restart:
+	/* Reset the pending bitmask before enabling irqs */
+	pending = xchg(ppending, 0);
 
 	h = softirq_vec;
 
@@ -233,13 +233,12 @@ restart:
 		pending >>= 1;
 	} while (pending);
 
-	local_irq_disable();
-
-	pending = local_softirq_pending();
-	if (pending && --max_restart)
+	if (*ppending && --max_restart)
 		goto restart;
 
-	if (pending)
+	local_irq_disable();
+
+	if (*ppending)
 		wakeup_softirqd();
 
 	lockdep_softirq_exit();
@@ -260,7 +259,7 @@ asmlinkage void do_softirq(void)
 
 	local_irq_save(flags);
 
-	pending = local_softirq_pending();
+	pending = *local_softirq_pending();
 
 	if (pending)
 		__do_softirq();
@@ -299,7 +298,7 @@ void irq_exit(void)
 	account_system_vtime(current);
 	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
-	if (!in_interrupt() && local_softirq_pending())
+	if (!in_interrupt() && *local_softirq_pending())
 		invoke_softirq();
 
 	rcu_irq_exit();
@@ -312,11 +311,11 @@ void irq_exit(void)
 }
 
 /*
- * This function must run with irqs disabled!
+ * This function must run with preempt disabled!
  */
-inline void raise_softirq_irqoff(unsigned int nr)
+inline void raise_softirq_preempt_off(unsigned int nr)
 {
-	__raise_softirq_irqoff(nr);
+	__raise_softirq_preempt_off(nr);
 
 	/*
 	 * If we're in an interrupt or softirq, we're done
@@ -333,11 +332,9 @@ inline void raise_softirq_irqoff(unsigne
 
 void raise_softirq(unsigned int nr)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	raise_softirq_irqoff(nr);
-	local_irq_restore(flags);
+	preempt_disable();
+	raise_softirq_preempt_off(nr);
+	preempt_enable();
 }
 
 void open_softirq(int nr, void (*action)(struct softirq_action *))
@@ -365,7 +362,7 @@ void __tasklet_schedule(struct tasklet_s
 	t->next = NULL;
 	*__get_cpu_var(tasklet_vec).tail = t;
 	__get_cpu_var(tasklet_vec).tail = &(t->next);
-	raise_softirq_irqoff(TASKLET_SOFTIRQ);
+	raise_softirq_preempt_off(TASKLET_SOFTIRQ);
 	local_irq_restore(flags);
 }
 
@@ -379,7 +376,7 @@ void __tasklet_hi_schedule(struct taskle
 	t->next = NULL;
 	*__get_cpu_var(tasklet_hi_vec).tail = t;
 	__get_cpu_var(tasklet_hi_vec).tail = &(t->next);
-	raise_softirq_irqoff(HI_SOFTIRQ);
+	raise_softirq_preempt_off(HI_SOFTIRQ);
 	local_irq_restore(flags);
 }
 
@@ -391,7 +388,7 @@ void __tasklet_hi_schedule_first(struct
 
 	t->next = __get_cpu_var(tasklet_hi_vec).head;
 	__get_cpu_var(tasklet_hi_vec).head = t;
-	__raise_softirq_irqoff(HI_SOFTIRQ);
+	__raise_softirq_preempt_off(HI_SOFTIRQ);
 }
 
 EXPORT_SYMBOL(__tasklet_hi_schedule_first);
@@ -426,7 +423,7 @@ static void tasklet_action(struct softir
 		t->next = NULL;
 		*__get_cpu_var(tasklet_vec).tail = t;
 		__get_cpu_var(tasklet_vec).tail = &(t->next);
-		__raise_softirq_irqoff(TASKLET_SOFTIRQ);
+		__raise_softirq_preempt_off(TASKLET_SOFTIRQ);
 		local_irq_enable();
 	}
 }
@@ -461,7 +458,7 @@ static void tasklet_hi_action(struct sof
 		t->next = NULL;
 		*__get_cpu_var(tasklet_hi_vec).tail = t;
 		__get_cpu_var(tasklet_hi_vec).tail = &(t->next);
-		__raise_softirq_irqoff(HI_SOFTIRQ);
+		__raise_softirq_preempt_off(HI_SOFTIRQ);
 		local_irq_enable();
 	}
 }
@@ -561,7 +558,7 @@ static void __local_trigger(struct call_
 
 	/* Trigger the softirq only if the list was previously empty.  */
 	if (head->next == &cp->list)
-		raise_softirq_irqoff(softirq);
+		raise_softirq_preempt_off(softirq);
 }
 
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
@@ -659,7 +656,7 @@ static int __cpuinit remote_softirq_cpu_
 
 			local_head = &__get_cpu_var(softirq_work_list[i]);
 			list_splice_init(head, local_head);
-			raise_softirq_irqoff(i);
+			raise_softirq_preempt_off(i);
 		}
 		local_irq_enable();
 	}
@@ -698,7 +695,7 @@ static int run_ksoftirqd(void * __bind_c
 
 	while (!kthread_should_stop()) {
 		preempt_disable();
-		if (!local_softirq_pending()) {
+		if (!*local_softirq_pending()) {
 			preempt_enable_no_resched();
 			schedule();
 			preempt_disable();
@@ -706,7 +703,7 @@ static int run_ksoftirqd(void * __bind_c
 
 		__set_current_state(TASK_RUNNING);
 
-		while (local_softirq_pending()) {
+		while (*local_softirq_pending()) {
 			/* Preempt disable stops cpu going offline.
 			   If already offline, we'll be on wrong CPU:
 			   don't process */
@@ -781,7 +778,7 @@ static void takeover_tasklets(unsigned i
 		per_cpu(tasklet_vec, cpu).head = NULL;
 		per_cpu(tasklet_vec, cpu).tail = &per_cpu(tasklet_vec, cpu).head;
 	}
-	raise_softirq_irqoff(TASKLET_SOFTIRQ);
+	raise_softirq_preempt_off(TASKLET_SOFTIRQ);
 
 	if (&per_cpu(tasklet_hi_vec, cpu).head != per_cpu(tasklet_hi_vec, cpu).tail) {
 		*__get_cpu_var(tasklet_hi_vec).tail = per_cpu(tasklet_hi_vec, cpu).head;
@@ -789,7 +786,7 @@ static void takeover_tasklets(unsigned i
 		per_cpu(tasklet_hi_vec, cpu).head = NULL;
 		per_cpu(tasklet_hi_vec, cpu).tail = &per_cpu(tasklet_hi_vec, cpu).head;
 	}
-	raise_softirq_irqoff(HI_SOFTIRQ);
+	raise_softirq_preempt_off(HI_SOFTIRQ);
 
 	local_irq_enable();
 }
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -304,12 +304,12 @@ void tick_nohz_stop_sched_tick(int inidl
 	if (need_resched())
 		goto end;
 
-	if (unlikely(local_softirq_pending() && cpu_online(cpu))) {
+	if (unlikely(*local_softirq_pending() && cpu_online(cpu))) {
 		static int ratelimit;
 
 		if (ratelimit < 10) {
 			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-			       (unsigned int) local_softirq_pending());
+			       (unsigned int) *local_softirq_pending());
 			ratelimit++;
 		}
 		goto end;
@@ -453,7 +453,7 @@ void tick_nohz_stop_sched_tick(int inidl
 		tick_do_update_jiffies64(ktime_get());
 		cpumask_clear_cpu(cpu, nohz_cpu_mask);
 	}
-	raise_softirq_irqoff(TIMER_SOFTIRQ);
+	raise_softirq_preempt_off(TIMER_SOFTIRQ);
 out:
 	ts->next_jiffies = next_jiffies;
 	ts->last_jiffies = last_jiffies;
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1564,7 +1564,7 @@ static inline void __netif_reschedule(st
 	q->next_sched = NULL;
 	*sd->output_queue_tailp = q;
 	sd->output_queue_tailp = &q->next_sched;
-	raise_softirq_irqoff(NET_TX_SOFTIRQ);
+	raise_softirq_preempt_off(NET_TX_SOFTIRQ);
 	local_irq_restore(flags);
 }
 
@@ -1585,7 +1585,7 @@ void dev_kfree_skb_irq(struct sk_buff *s
 		sd = &__get_cpu_var(softnet_data);
 		skb->next = sd->completion_queue;
 		sd->completion_queue = skb;
-		raise_softirq_irqoff(NET_TX_SOFTIRQ);
+		raise_softirq_preempt_off(NET_TX_SOFTIRQ);
 		local_irq_restore(flags);
 	}
 }
@@ -2218,7 +2218,7 @@ static inline void ____napi_schedule(str
 				     struct napi_struct *napi)
 {
 	list_add_tail(&napi->poll_list, &sd->poll_list);
-	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
+	__raise_softirq_preempt_off(NET_RX_SOFTIRQ);
 }
 
 #ifdef CONFIG_RPS
@@ -2397,7 +2397,7 @@ static int rps_ipi_queued(struct softnet
 		sd->rps_ipi_next = mysd->rps_ipi_list;
 		mysd->rps_ipi_list = sd;
 
-		__raise_softirq_irqoff(NET_RX_SOFTIRQ);
+		__raise_softirq_preempt_off(NET_RX_SOFTIRQ);
 		return 1;
 	}
 #endif /* CONFIG_RPS */
@@ -2506,7 +2506,7 @@ int netif_rx_ni(struct sk_buff *skb)
 
 	preempt_disable();
 	err = netif_rx(skb);
-	if (local_softirq_pending())
+	if (*local_softirq_pending())
 		do_softirq();
 	preempt_enable();
 
@@ -3532,7 +3532,7 @@ out:
 
 softnet_break:
 	sd->time_squeeze++;
-	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
+	__raise_softirq_preempt_off(NET_RX_SOFTIRQ);
 	goto out;
 }
 
@@ -5670,7 +5670,7 @@ static int dev_cpu_callback(struct notif
 		oldsd->output_queue_tailp = &oldsd->output_queue;
 	}
 
-	raise_softirq_irqoff(NET_TX_SOFTIRQ);
+	raise_softirq_preempt_off(NET_TX_SOFTIRQ);
 	local_irq_enable();
 
 	/* Process offline CPU's input_pkt_queue */
