Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0FXDFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:05:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:31949 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab0FXDFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:05:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,471,1272870000"; 
   d="scan'208";a="810964586"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Huang Ying <ying.huang@intel.com>
Subject: [RFC 5/5] Use NMI return notifier in perf pending
Date: Thu, 24 Jun 2010 11:04:58 +0800
Message-Id: <1277348698-17311-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use general NMI return notifier mechanism to replace the self
interrupt used in perf pending.

Known issue: don't know how to deal with SPARC architecture.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/alpha/include/asm/perf_event.h  |    1 
 arch/arm/include/asm/perf_event.h    |   12 -----
 arch/parisc/include/asm/perf_event.h |    1 
 arch/powerpc/kernel/time.c           |    5 --
 arch/s390/include/asm/perf_event.h   |    3 -
 arch/sh/include/asm/perf_event.h     |    5 --
 arch/sparc/include/asm/perf_event.h  |    2 
 arch/x86/include/asm/entry_arch.h    |    4 -
 arch/x86/include/asm/hardirq.h       |    1 
 arch/x86/include/asm/irq_vectors.h   |    5 --
 arch/x86/kernel/cpu/perf_event.c     |   19 --------
 arch/x86/kernel/entry_64.S           |    5 --
 arch/x86/kernel/irq.c                |    5 --
 arch/x86/kernel/irqinit.c            |    6 --
 include/linux/perf_event.h           |   11 ----
 kernel/perf_event.c                  |   81 +++++------------------------------
 kernel/timer.c                       |    2 
 17 files changed, 15 insertions(+), 153 deletions(-)

--- a/arch/alpha/include/asm/perf_event.h
+++ b/arch/alpha/include/asm/perf_event.h
@@ -2,7 +2,6 @@
 #define __ASM_ALPHA_PERF_EVENT_H
 
 /* Alpha only supports software events through this interface. */
-static inline void set_perf_event_pending(void) { }
 
 #define PERF_EVENT_INDEX_OFFSET 0
 
--- a/arch/arm/include/asm/perf_event.h
+++ b/arch/arm/include/asm/perf_event.h
@@ -12,18 +12,6 @@
 #ifndef __ARM_PERF_EVENT_H__
 #define __ARM_PERF_EVENT_H__
 
-/*
- * NOP: on *most* (read: all supported) ARM platforms, the performance
- * counter interrupts are regular interrupts and not an NMI. This
- * means that when we receive the interrupt we can call
- * perf_event_do_pending() that handles all of the work with
- * interrupts enabled.
- */
-static inline void
-set_perf_event_pending(void)
-{
-}
-
 /* ARM performance counters start from 1 (in the cp15 accesses) so use the
  * same indexes here for consistency. */
 #define PERF_EVENT_INDEX_OFFSET 1
--- a/arch/parisc/include/asm/perf_event.h
+++ b/arch/parisc/include/asm/perf_event.h
@@ -2,6 +2,5 @@
 #define __ASM_PARISC_PERF_EVENT_H
 
 /* parisc only supports software events through this interface. */
-static inline void set_perf_event_pending(void) { }
 
 #endif /* __ASM_PARISC_PERF_EVENT_H */
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -635,11 +635,6 @@ void timer_interrupt(struct pt_regs * re
 
 	calculate_steal_time();
 
-	if (test_perf_event_pending()) {
-		clear_perf_event_pending();
-		perf_event_do_pending();
-	}
-
 #ifdef CONFIG_PPC_ISERIES
 	if (firmware_has_feature(FW_FEATURE_ISERIES))
 		get_lppaca()->int_dword.fields.decr_int = 0;
--- a/arch/s390/include/asm/perf_event.h
+++ b/arch/s390/include/asm/perf_event.h
@@ -4,7 +4,4 @@
  * Copyright 2009 Martin Schwidefsky, IBM Corporation.
  */
 
-static inline void set_perf_event_pending(void) {}
-static inline void clear_perf_event_pending(void) {}
-
 #define PERF_EVENT_INDEX_OFFSET 0
--- a/arch/sh/include/asm/perf_event.h
+++ b/arch/sh/include/asm/perf_event.h
@@ -26,11 +26,6 @@ extern int register_sh_pmu(struct sh_pmu
 extern int reserve_pmc_hardware(void);
 extern void release_pmc_hardware(void);
 
-static inline void set_perf_event_pending(void)
-{
-	/* Nothing to see here, move along. */
-}
-
 #define PERF_EVENT_INDEX_OFFSET	0
 
 #endif /* __ASM_SH_PERF_EVENT_H */
--- a/arch/sparc/include/asm/perf_event.h
+++ b/arch/sparc/include/asm/perf_event.h
@@ -1,8 +1,6 @@
 #ifndef __ASM_SPARC_PERF_EVENT_H
 #define __ASM_SPARC_PERF_EVENT_H
 
-extern void set_perf_event_pending(void);
-
 #define	PERF_EVENT_INDEX_OFFSET	0
 
 #ifdef CONFIG_PERF_EVENTS
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -49,10 +49,6 @@ BUILD_INTERRUPT(apic_timer_interrupt,LOC
 BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
 BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
 
-#ifdef CONFIG_PERF_EVENTS
-BUILD_INTERRUPT(perf_pending_interrupt, LOCAL_PENDING_VECTOR)
-#endif
-
 #ifdef CONFIG_X86_THERMAL_VECTOR
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -15,7 +15,6 @@ typedef struct {
 #endif
 	unsigned int x86_platform_ipis;	/* arch dependent */
 	unsigned int apic_perf_irqs;
-	unsigned int apic_pending_irqs;
 #ifdef CONFIG_SMP
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -113,11 +113,6 @@
  */
 #define X86_PLATFORM_IPI_VECTOR		0xed
 
-/*
- * Performance monitoring pending work vector:
- */
-#define LOCAL_PENDING_VECTOR		0xec
-
 #define UV_BAU_MESSAGE			0xea
 
 /*
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1160,25 +1160,6 @@ static int x86_pmu_handle_irq(struct pt_
 	return handled;
 }
 
-void smp_perf_pending_interrupt(struct pt_regs *regs)
-{
-	irq_enter();
-	ack_APIC_irq();
-	inc_irq_stat(apic_pending_irqs);
-	perf_event_do_pending();
-	irq_exit();
-}
-
-void set_perf_event_pending(void)
-{
-#ifdef CONFIG_X86_LOCAL_APIC
-	if (!x86_pmu.apic || !x86_pmu_initialized())
-		return;
-
-	apic->send_IPI_self(LOCAL_PENDING_VECTOR);
-#endif
-}
-
 void perf_events_lapic_init(void)
 {
 	if (!x86_pmu.apic || !x86_pmu_initialized())
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1023,11 +1023,6 @@ apicinterrupt ERROR_APIC_VECTOR \
 apicinterrupt SPURIOUS_APIC_VECTOR \
 	spurious_interrupt smp_spurious_interrupt
 
-#ifdef CONFIG_PERF_EVENTS
-apicinterrupt LOCAL_PENDING_VECTOR \
-	perf_pending_interrupt smp_perf_pending_interrupt
-#endif
-
 /*
  * Exception entry points.
  */
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -73,10 +73,6 @@ static int show_other_interrupts(struct
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
 	seq_printf(p, "  Performance monitoring interrupts\n");
-	seq_printf(p, "%*s: ", prec, "PND");
-	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->apic_pending_irqs);
-	seq_printf(p, "  Performance pending work\n");
 #endif
 	if (x86_platform_ipi_callback) {
 		seq_printf(p, "%*s: ", prec, "PLT");
@@ -192,7 +188,6 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->irq_spurious_count;
 	sum += irq_stats(cpu)->apic_nmi_return_notifier_irqs;
 	sum += irq_stats(cpu)->apic_perf_irqs;
-	sum += irq_stats(cpu)->apic_pending_irqs;
 #endif
 	if (x86_platform_ipi_callback)
 		sum += irq_stats(cpu)->x86_platform_ipis;
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -223,12 +223,6 @@ static void __init apic_intr_init(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
-
-	/* Performance monitoring interrupts: */
-# ifdef CONFIG_PERF_EVENTS
-	alloc_intr_gate(LOCAL_PENDING_VECTOR, perf_pending_interrupt);
-# endif
-
 #endif
 }
 
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -484,6 +484,7 @@ struct perf_guest_info_callbacks {
 #include <linux/workqueue.h>
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
+#include <linux/nmi.h>
 #include <asm/atomic.h>
 #include <asm/local.h>
 
@@ -608,11 +609,6 @@ struct perf_mmap_data {
 	void				*data_pages[0];
 };
 
-struct perf_pending_entry {
-	struct perf_pending_entry *next;
-	void (*func)(struct perf_pending_entry *);
-};
-
 struct perf_sample_data;
 
 typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
@@ -719,7 +715,7 @@ struct perf_event {
 	int				pending_wakeup;
 	int				pending_kill;
 	int				pending_disable;
-	struct perf_pending_entry	pending;
+	struct nmi_return_notifier	pending;
 
 	atomic_t			event_limit;
 
@@ -831,8 +827,6 @@ extern void perf_event_task_tick(struct
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
-extern void set_perf_event_pending(void);
-extern void perf_event_do_pending(void);
 extern void perf_event_print_debug(void);
 extern void __perf_disable(void);
 extern bool __perf_enable(void);
@@ -1031,7 +1025,6 @@ perf_event_task_tick(struct task_struct
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
-static inline void perf_event_do_pending(void)				{ }
 static inline void perf_event_print_debug(void)				{ }
 static inline void perf_disable(void)					{ }
 static inline void perf_enable(void)					{ }
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2829,15 +2829,17 @@ void perf_event_wakeup(struct perf_event
  *
  * Handle the case where we need to wakeup up from NMI (or rq->lock) context.
  *
- * The NMI bit means we cannot possibly take locks. Therefore, maintain a
- * single linked list and use cmpxchg() to add entries lockless.
+ * The NMI bit means we cannot possibly take locks. Therefore, use
+ * nmi_return_notifier.
  */
 
-static void perf_pending_event(struct perf_pending_entry *entry)
+static void perf_pending_event(struct nmi_return_notifier *nrn)
 {
-	struct perf_event *event = container_of(entry,
+	struct perf_event *event = container_of(nrn,
 			struct perf_event, pending);
 
+	nrn->data = NULL;
+
 	if (event->pending_disable) {
 		event->pending_disable = 0;
 		__perf_event_disable(event);
@@ -2849,59 +2851,12 @@ static void perf_pending_event(struct pe
 	}
 }
 
-#define PENDING_TAIL ((struct perf_pending_entry *)-1UL)
-
-static DEFINE_PER_CPU(struct perf_pending_entry *, perf_pending_head) = {
-	PENDING_TAIL,
-};
-
-static void perf_pending_queue(struct perf_pending_entry *entry,
-			       void (*func)(struct perf_pending_entry *))
+static void perf_pending_queue(struct nmi_return_notifier *nrn,
+			       void (*func)(struct nmi_return_notifier *))
 {
-	struct perf_pending_entry **head;
-
-	if (cmpxchg(&entry->next, NULL, PENDING_TAIL) != NULL)
-		return;
-
-	entry->func = func;
-
-	head = &get_cpu_var(perf_pending_head);
-
-	do {
-		entry->next = *head;
-	} while (cmpxchg(head, entry->next, entry) != entry->next);
-
-	set_perf_event_pending();
-
-	put_cpu_var(perf_pending_head);
-}
-
-static int __perf_pending_run(void)
-{
-	struct perf_pending_entry *list;
-	int nr = 0;
-
-	list = xchg(&__get_cpu_var(perf_pending_head), PENDING_TAIL);
-	while (list != PENDING_TAIL) {
-		void (*func)(struct perf_pending_entry *);
-		struct perf_pending_entry *entry = list;
-
-		list = list->next;
-
-		func = entry->func;
-		entry->next = NULL;
-		/*
-		 * Ensure we observe the unqueue before we issue the wakeup,
-		 * so that we won't be waiting forever.
-		 * -- see perf_not_pending().
-		 */
-		smp_wmb();
-
-		func(entry);
-		nr++;
-	}
-
-	return nr;
+	nrn->on_nmi_return = func;
+	nrn->data = nrn;
+	nmi_return_notifier_schedule(nrn);
 }
 
 static inline int perf_not_pending(struct perf_event *event)
@@ -2911,15 +2866,10 @@ static inline int perf_not_pending(struc
 	 * need to wait.
 	 */
 	get_cpu();
-	__perf_pending_run();
+	fire_nmi_return_notifiers();
 	put_cpu();
 
-	/*
-	 * Ensure we see the proper queue state before going to sleep
-	 * so that we do not miss the wakeup. -- see perf_pending_handle()
-	 */
-	smp_rmb();
-	return event->pending.next == NULL;
+	return event->pending.data == NULL;
 }
 
 static void perf_pending_sync(struct perf_event *event)
@@ -2927,11 +2877,6 @@ static void perf_pending_sync(struct per
 	wait_event(event->waitq, perf_not_pending(event));
 }
 
-void perf_event_do_pending(void)
-{
-	__perf_pending_run();
-}
-
 /*
  * Callchain support -- arch specific
  */
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -37,7 +37,6 @@
 #include <linux/delay.h>
 #include <linux/tick.h>
 #include <linux/kallsyms.h>
-#include <linux/perf_event.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 
@@ -1264,7 +1263,6 @@ void update_process_times(int user_tick)
 	run_local_timers();
 	rcu_check_callbacks(cpu, user_tick);
 	printk_tick();
-	perf_event_do_pending();
 	scheduler_tick();
 	run_posix_cpu_timers(p);
 }
