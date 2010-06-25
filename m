Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab0FYSar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 14:30:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:57008 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab0FYSap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 14:30:45 -0400
Subject: [RFC][PATCH] irq_work -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       tglx <tglx@linutronix.de>, davem <davem@davemloft.net>,
       paulus <paulus@samba.org>
In-Reply-To: <1277361352.1875.838.camel@laptop>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Jun 2010 20:30:25 +0200
Message-ID: <1277490625.1875.986.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Utterly untested and you really need visit all the touched architectures
if you want to make it useful.

---
Subject: irq_work: generic hard-irq context callbacks

In order for other NMI context users that want to run things from
hard-IRQ context, extract the perf_event callback mechanism.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/alpha/include/asm/perf_event.h           |    9 -
 arch/frv/lib/perf_event.c                     |   19 ---
 arch/parisc/include/asm/perf_event.h          |    7 -
 arch/s390/include/asm/perf_event.h            |   10 -
 linux-2.6/arch/alpha/Kconfig                  |    1 
 linux-2.6/arch/arm/Kconfig                    |    1 
 linux-2.6/arch/arm/include/asm/perf_event.h   |   12 -
 linux-2.6/arch/arm/kernel/perf_event.c        |    4 
 linux-2.6/arch/frv/Kconfig                    |    1 
 linux-2.6/arch/parisc/Kconfig                 |    1 
 linux-2.6/arch/powerpc/Kconfig                |    1 
 linux-2.6/arch/powerpc/kernel/time.c          |   42 +++---
 linux-2.6/arch/s390/Kconfig                   |    1 
 linux-2.6/arch/sh/Kconfig                     |    1 
 linux-2.6/arch/sh/include/asm/perf_event.h    |    7 -
 linux-2.6/arch/sparc/Kconfig                  |    2 
 linux-2.6/arch/sparc/include/asm/perf_event.h |    4 
 linux-2.6/arch/sparc/kernel/pcr.c             |    8 -
 linux-2.6/arch/x86/Kconfig                    |    1 
 linux-2.6/arch/x86/include/asm/entry_arch.h   |    4 
 linux-2.6/arch/x86/include/asm/hw_irq.h       |    2 
 linux-2.6/arch/x86/kernel/Makefile            |    1 
 linux-2.6/arch/x86/kernel/cpu/perf_event.c    |   19 ---
 linux-2.6/arch/x86/kernel/entry_64.S          |    4 
 linux-2.6/arch/x86/kernel/irq_work.c          |   26 ++++
 linux-2.6/arch/x86/kernel/irqinit.c           |    4 
 linux-2.6/include/linux/irq_work.h            |   20 +++
 linux-2.6/include/linux/perf_event.h          |   11 -
 linux-2.6/init/Kconfig                        |    8 +
 linux-2.6/kernel/Makefile                     |    2 
 linux-2.6/kernel/irq_work.c                   |  157 ++++++++++++++++++++++++++
 linux-2.6/kernel/perf_event.c                 |  102 ----------------
 linux-2.6/kernel/timer.c                      |    4 
 33 files changed, 266 insertions(+), 230 deletions(-)

Index: linux-2.6/include/linux/irq_work.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/irq_work.h
@@ -0,0 +1,20 @@
+#ifndef _LINUX_IRQ_WORK_H
+#define _LINUX_IRQ_WORK_H
+
+struct irq_work {
+	struct irq_work *next;
+	void (*func)(struct irq_work *);
+};
+
+static inline
+void init_irq_work(struct irq_work *entry, void (*func)(struct irq_work *))
+{
+	entry->next = NULL;
+	entry->func = func;
+}
+
+int irq_work_queue(struct irq_work *entry);
+void irq_work_run(void);
+void irq_work_sync(struct irq_work *entry);
+
+#endif /* _LINUX_IRQ_WORK_H */
Index: linux-2.6/kernel/irq_work.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/irq_work.c
@@ -0,0 +1,157 @@
+/*
+ * Copyright (C) 2010 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *
+ * Provides a framework for enqueueing and running callbacks from hardirq
+ * context. The enqueueing is NMI-safe.
+ */
+
+#include <linux/irq_work.h>
+#include <linux/hardirq.h>
+
+/*
+ * An entry can be in one of four states:
+ *
+ * free	     NULL, 0 -> {claimed}       : free to be used
+ * claimed   NULL, 3 -> {pending}       : claimed to be enqueued
+ * pending   next, 3 -> {busy}          : queued, pending callback
+ * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
+ *
+ * We use the lower two bits of the next pointer to keep PENDING and BUSY
+ * flags.
+ */
+
+#define IRQ_WORK_PENDING	1UL
+#define IRQ_WORK_BUSY		2UL
+#define IRQ_WORK_FLAGS		3UL
+
+static inline bool irq_work_is_set(struct irq_work *entry, int flags)
+{
+	return (unsigned long)entry->next & flags;
+}
+
+static inline struct irq_work *irq_work_next(struct irq_work *entry)
+{
+	unsigned long next = (unsigned long)entry->next;
+	next &= ~IRQ_WORK_FLAGS;
+	return (struct irq_work *)next;
+}
+
+static inline struct irq_work *next_flags(struct irq_work *entry, int flags)
+{
+	unsigned long next = (unsigned long)entry;
+	next |= flags;
+	return (struct irq_work *)next;
+}
+
+static DEFINE_PER_CPU(struct irq_work *, irq_work_list);
+
+/*
+ * Claim the entry so that no one else will poke at it.
+ */
+static bool irq_work_claim(struct irq_work *entry)
+{
+	unsigned long flags;
+
+	do {
+		flags = (unsigned long)entry->next;
+		if (flags & IRQ_WORK_PENDING)
+			return false;
+	} while (cmpxchg(&entry->next, flags, flags | IRQ_WORK_FLAGS) != flags);
+
+	return true;
+}
+
+
+void __weak arch_irq_work_raise(void)
+{
+	/*
+	 * Lame architectures will get the timer tick callback
+	 */
+}
+
+/*
+ * Queue the entry and raise the IPI if needed.
+ */
+static void __irq_work_queue(struct irq_work *entry)
+{
+	struct irq_work **head;
+
+	head = &get_cpu_var(irq_work_list);
+
+	do {
+		/*
+		 * Can assign non-atomic because we keep the flags set.
+		 */
+		entry->next = next_flags(*head, IRQ_WORK_FLAGS);
+	} while (cmpxchg(head, entry->next, entry) != entry->next);
+
+	/*
+	 * The list was empty, raise self-interrupt to start processing.
+	 */
+	if (!irq_work_next(entry))
+		arch_irq_work_raise();
+
+	put_cpu_var(irq_work_list);
+}
+
+/*
+ * Enqueue the irq_work @entry, returns true on success, failure when the
+ * @entry was already enqueued by someone else.
+ *
+ * Can be re-enqueued while the callback is still in progress.
+ */
+bool irq_work_queue(struct irq_work *entry)
+{
+	if (!irq_work_claim(entry)) {
+		/*
+		 * Already enqueued, can't do!
+		 */
+		return false;
+	}
+
+	__irq_work_queue(entry);
+	return true;
+}
+
+/*
+ * Run the irq_work entries on this cpu. Requires to be ran from hardirq
+ * context with local IRQs disabled.
+ */
+void irq_work_run(void)
+{
+	struct irq_work *list;
+
+	BUG_ON(!in_irq());
+	BUG_ON(!irqs_disabled());
+
+	list = xchg(&__get_cpu_var(irq_work_list), NULL);
+	while (list != NULL) {
+		struct irq_work *entry = list;
+
+		list = irq_work_next(list);
+
+		/*
+		 * Clear the PENDING bit, after this point the @entry
+		 * can be re-used.
+		 */
+		entry->next = next_flags(NULL, IRQ_WORK_BUSY);
+		entry->func(entry);
+		/*
+		 * Clear the BUSY bit and return to the free state if
+		 * no-one else claimed it meanwhile.
+		 */
+		cmpxchg(&entry->next, next_flags(NULL, IRQ_WORK_BUSY), NULL);
+	}
+}
+
+/*
+ * Synchronize against the irq_work @entry, ensures the entry is not
+ * currently in use.
+ */
+void irq_work_sync(struct irq_work *entry)
+{
+	WARN_ON_ONCE(irqs_disabled());
+
+	while (irq_work_is_set(entry, IRQ_WORK_BUSY))
+		cpu_relax();
+}
Index: linux-2.6/arch/alpha/Kconfig
===================================================================
--- linux-2.6.orig/arch/alpha/Kconfig
+++ linux-2.6/arch/alpha/Kconfig
@@ -9,6 +9,7 @@ config ALPHA
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
 	help
Index: linux-2.6/arch/alpha/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/perf_event.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef __ASM_ALPHA_PERF_EVENT_H
-#define __ASM_ALPHA_PERF_EVENT_H
-
-/* Alpha only supports software events through this interface. */
-static inline void set_perf_event_pending(void) { }
-
-#define PERF_EVENT_INDEX_OFFSET 0
-
-#endif /* __ASM_ALPHA_PERF_EVENT_H */
Index: linux-2.6/arch/arm/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/Kconfig
+++ linux-2.6/arch/arm/Kconfig
@@ -22,6 +22,7 @@ config ARM
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	help
Index: linux-2.6/arch/arm/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/perf_event.h
+++ linux-2.6/arch/arm/include/asm/perf_event.h
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
Index: linux-2.6/arch/frv/Kconfig
===================================================================
--- linux-2.6.orig/arch/frv/Kconfig
+++ linux-2.6/arch/frv/Kconfig
@@ -7,6 +7,7 @@ config FRV
 	default y
 	select HAVE_IDE
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 
 config ZONE_DMA
Index: linux-2.6/arch/frv/lib/perf_event.c
===================================================================
--- linux-2.6.orig/arch/frv/lib/perf_event.c
+++ /dev/null
@@ -1,19 +0,0 @@
-/* Performance event handling
- *
- * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#include <linux/perf_event.h>
-
-/*
- * mark the performance event as pending
- */
-void set_perf_event_pending(void)
-{
-}
Index: linux-2.6/arch/parisc/Kconfig
===================================================================
--- linux-2.6.orig/arch/parisc/Kconfig
+++ linux-2.6/arch/parisc/Kconfig
@@ -16,6 +16,7 @@ config PARISC
 	select RTC_DRV_GENERIC
 	select INIT_ALL_POSSIBLE
 	select BUG
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
 	help
Index: linux-2.6/arch/parisc/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/perf_event.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef __ASM_PARISC_PERF_EVENT_H
-#define __ASM_PARISC_PERF_EVENT_H
-
-/* parisc only supports software events through this interface. */
-static inline void set_perf_event_pending(void) { }
-
-#endif /* __ASM_PARISC_PERF_EVENT_H */
Index: linux-2.6/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/Kconfig
+++ linux-2.6/arch/powerpc/Kconfig
@@ -139,6 +139,7 @@ config PPC
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS if PPC64
 	select GENERIC_ATOMIC64 if PPC32
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
 
Index: linux-2.6/arch/powerpc/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/time.c
+++ linux-2.6/arch/powerpc/kernel/time.c
@@ -53,7 +53,7 @@
 #include <linux/posix-timers.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
-#include <linux/perf_event.h>
+#include <linux/irq_work.h>
 #include <asm/trace.h>
 
 #include <asm/io.h>
@@ -532,60 +532,60 @@ void __init iSeries_time_init_early(void
 }
 #endif /* CONFIG_PPC_ISERIES */
 
-#ifdef CONFIG_PERF_EVENTS
+#ifdef CONFIG_IRQ_WORK
 
 /*
  * 64-bit uses a byte in the PACA, 32-bit uses a per-cpu variable...
  */
 #ifdef CONFIG_PPC64
-static inline unsigned long test_perf_event_pending(void)
+static inline unsigned long test_irq_work_pending(void)
 {
 	unsigned long x;
 
 	asm volatile("lbz %0,%1(13)"
 		: "=r" (x)
-		: "i" (offsetof(struct paca_struct, perf_event_pending)));
+		: "i" (offsetof(struct paca_struct, irq_work_pending)));
 	return x;
 }
 
-static inline void set_perf_event_pending_flag(void)
+static inline void set_irq_work_pending_flag(void)
 {
 	asm volatile("stb %0,%1(13)" : :
 		"r" (1),
-		"i" (offsetof(struct paca_struct, perf_event_pending)));
+		"i" (offsetof(struct paca_struct, irq_work_pending)));
 }
 
-static inline void clear_perf_event_pending(void)
+static inline void clear_irq_work_pending(void)
 {
 	asm volatile("stb %0,%1(13)" : :
 		"r" (0),
-		"i" (offsetof(struct paca_struct, perf_event_pending)));
+		"i" (offsetof(struct paca_struct, irq_work_pending)));
 }
 
 #else /* 32-bit */
 
-DEFINE_PER_CPU(u8, perf_event_pending);
+DEFINE_PER_CPU(u8, irq_work_pending);
 
-#define set_perf_event_pending_flag()	__get_cpu_var(perf_event_pending) = 1
-#define test_perf_event_pending()	__get_cpu_var(perf_event_pending)
-#define clear_perf_event_pending()	__get_cpu_var(perf_event_pending) = 0
+#define set_irq_work_pending_flag()	__get_cpu_var(irq_work_pending) = 1
+#define test_irq_work_pending()		__get_cpu_var(irq_work_pending)
+#define clear_irq_work_pending()	__get_cpu_var(irq_work_pending) = 0
 
 #endif /* 32 vs 64 bit */
 
-void set_perf_event_pending(void)
+void set_irq_work_pending(void)
 {
 	preempt_disable();
-	set_perf_event_pending_flag();
+	set_irq_work_pending_flag();
 	set_dec(1);
 	preempt_enable();
 }
 
-#else  /* CONFIG_PERF_EVENTS */
+#else  /* CONFIG_IRQ_WORK */
 
-#define test_perf_event_pending()	0
-#define clear_perf_event_pending()
+#define test_irq_work_pending()	0
+#define clear_irq_work_pending()
 
-#endif /* CONFIG_PERF_EVENTS */
+#endif /* CONFIG_IRQ_WORK */
 
 /*
  * For iSeries shared processors, we have to let the hypervisor
@@ -635,9 +635,9 @@ void timer_interrupt(struct pt_regs * re
 
 	calculate_steal_time();
 
-	if (test_perf_event_pending()) {
-		clear_perf_event_pending();
-		perf_event_do_pending();
+	if (test_irq_work_pending()) {
+		clear_irq_work_pending();
+		irq_work_run();
 	}
 
 #ifdef CONFIG_PPC_ISERIES
Index: linux-2.6/arch/s390/Kconfig
===================================================================
--- linux-2.6.orig/arch/s390/Kconfig
+++ linux-2.6/arch/s390/Kconfig
@@ -98,6 +98,7 @@ config S390
 	select HAVE_KVM if 64BIT
 	select HAVE_ARCH_TRACEHOOK
 	select INIT_ALL_POSSIBLE
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
Index: linux-2.6/arch/s390/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/perf_event.h
+++ /dev/null
@@ -1,10 +0,0 @@
-/*
- * Performance event support - s390 specific definitions.
- *
- * Copyright 2009 Martin Schwidefsky, IBM Corporation.
- */
-
-static inline void set_perf_event_pending(void) {}
-static inline void clear_perf_event_pending(void) {}
-
-#define PERF_EVENT_INDEX_OFFSET 0
Index: linux-2.6/arch/sh/Kconfig
===================================================================
--- linux-2.6.orig/arch/sh/Kconfig
+++ linux-2.6/arch/sh/Kconfig
@@ -16,6 +16,7 @@ config SUPERH
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_KERNEL_GZIP
Index: linux-2.6/arch/sh/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/perf_event.h
+++ linux-2.6/arch/sh/include/asm/perf_event.h
@@ -26,11 +26,4 @@ extern int register_sh_pmu(struct sh_pmu
 extern int reserve_pmc_hardware(void);
 extern void release_pmc_hardware(void);
 
-static inline void set_perf_event_pending(void)
-{
-	/* Nothing to see here, move along. */
-}
-
-#define PERF_EVENT_INDEX_OFFSET	0
-
 #endif /* __ASM_SH_PERF_EVENT_H */
Index: linux-2.6/arch/sparc/Kconfig
===================================================================
--- linux-2.6.orig/arch/sparc/Kconfig
+++ linux-2.6/arch/sparc/Kconfig
@@ -25,6 +25,7 @@ config SPARC
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select RTC_CLASS
 	select RTC_DRV_M48T59
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_DMA_ATTRS
@@ -52,6 +53,7 @@ config SPARC64
 	select RTC_DRV_BQ4802
 	select RTC_DRV_SUN4V
 	select RTC_DRV_STARFIRE
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 
Index: linux-2.6/arch/sparc/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/perf_event.h
+++ linux-2.6/arch/sparc/include/asm/perf_event.h
@@ -1,10 +1,6 @@
 #ifndef __ASM_SPARC_PERF_EVENT_H
 #define __ASM_SPARC_PERF_EVENT_H
 
-extern void set_perf_event_pending(void);
-
-#define	PERF_EVENT_INDEX_OFFSET	0
-
 #ifdef CONFIG_PERF_EVENTS
 #include <asm/ptrace.h>
 
Index: linux-2.6/arch/sparc/kernel/pcr.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/pcr.c
+++ linux-2.6/arch/sparc/kernel/pcr.c
@@ -7,7 +7,7 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 
-#include <linux/perf_event.h>
+#include <linux/irq_work.h>
 #include <linux/ftrace.h>
 
 #include <asm/pil.h>
@@ -43,14 +43,14 @@ void __irq_entry deferred_pcr_work_irq(i
 
 	old_regs = set_irq_regs(regs);
 	irq_enter();
-#ifdef CONFIG_PERF_EVENTS
-	perf_event_do_pending();
+#ifdef CONFIG_IRQ_WORK
+	irq_work_run();
 #endif
 	irq_exit();
 	set_irq_regs(old_regs);
 }
 
-void set_perf_event_pending(void)
+void arch_irq_work_raise(void)
 {
 	set_softint(1 << PIL_DEFERRED_PCR_WORK);
 }
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -55,6 +55,7 @@ config X86
 	select HAVE_HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select PERF_EVENTS
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS_NMI
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
Index: linux-2.6/arch/x86/include/asm/entry_arch.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/entry_arch.h
+++ linux-2.6/arch/x86/include/asm/entry_arch.h
@@ -49,8 +49,8 @@ BUILD_INTERRUPT(apic_timer_interrupt,LOC
 BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
 BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
 
-#ifdef CONFIG_PERF_EVENTS
-BUILD_INTERRUPT(perf_pending_interrupt, LOCAL_PENDING_VECTOR)
+#ifdef CONFIG_IRQ_WORK
+BUILD_INTERRUPT(irq_work_interrupt,LOCAL_PENDING_VECTOR)
 #endif
 
 #ifdef CONFIG_X86_THERMAL_VECTOR
Index: linux-2.6/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hw_irq.h
+++ linux-2.6/arch/x86/include/asm/hw_irq.h
@@ -29,7 +29,7 @@
 extern void apic_timer_interrupt(void);
 extern void x86_platform_ipi(void);
 extern void error_interrupt(void);
-extern void perf_pending_interrupt(void);
+extern void irq_work_interrupt(void);
 
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -33,6 +33,7 @@ obj-y			:= process_$(BITS).o signal.o en
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
 obj-y			+= setup.o x86_init.o i8259.o irqinit.o
+obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1170,25 +1170,6 @@ static int x86_pmu_handle_irq(struct pt_
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
Index: linux-2.6/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/entry_64.S
+++ linux-2.6/arch/x86/kernel/entry_64.S
@@ -1023,9 +1023,9 @@ apicinterrupt ERROR_APIC_VECTOR \
 apicinterrupt SPURIOUS_APIC_VECTOR \
 	spurious_interrupt smp_spurious_interrupt
 
-#ifdef CONFIG_PERF_EVENTS
+#ifdef CONFIG_IRQ_WORK
 apicinterrupt LOCAL_PENDING_VECTOR \
-	perf_pending_interrupt smp_perf_pending_interrupt
+	irq_work_interrupt smp_irq_work_interrupt
 #endif
 
 /*
Index: linux-2.6/arch/x86/kernel/irq_work.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/kernel/irq_work.c
@@ -0,0 +1,26 @@
+
+#include <linux/irq_work.h>
+#include <linux/hardirq.h>
+#include <asm/apic.h>
+
+void smp_perf_pending_interrupt(struct pt_regs *regs)
+{
+	irq_enter();
+	ack_APIC_irq();
+	inc_irq_stat(apic_pending_irqs);
+	irq_work_run();
+	irq_exit();
+}
+
+void arch_irq_work_raise(void)
+{
+#ifdef CONFIG_X86_LOCAL_APIC
+	if (!cpu_as_apic)
+		return;
+
+	apic->send_IPI_self(LOCAL_PENDING_VECTOR);
+	apic_wait_icr_idle();
+#endif
+}
+
+
Index: linux-2.6/arch/x86/kernel/irqinit.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irqinit.c
+++ linux-2.6/arch/x86/kernel/irqinit.c
@@ -225,8 +225,8 @@ static void __init apic_intr_init(void)
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 
 	/* Performance monitoring interrupts: */
-# ifdef CONFIG_PERF_EVENTS
-	alloc_intr_gate(LOCAL_PENDING_VECTOR, perf_pending_interrupt);
+# ifdef CONFIG_IRQ_WORK
+	alloc_intr_gate(LOCAL_PENDING_VECTOR, irq_work_interrupt);
 # endif
 
 #endif
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -486,6 +486,7 @@ struct perf_guest_info_callbacks {
 #include <linux/workqueue.h>
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
+#include <linux/irq_work.h>
 #include <asm/atomic.h>
 #include <asm/local.h>
 
@@ -629,11 +630,6 @@ struct perf_buffer {
 	void				*data_pages[0];
 };
 
-struct perf_pending_entry {
-	struct perf_pending_entry *next;
-	void (*func)(struct perf_pending_entry *);
-};
-
 struct perf_sample_data;
 
 typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
@@ -741,7 +737,7 @@ struct perf_event {
 	int				pending_wakeup;
 	int				pending_kill;
 	int				pending_disable;
-	struct perf_pending_entry	pending;
+	struct irq_work			pending;
 
 	atomic_t			event_limit;
 
@@ -853,8 +849,6 @@ extern void perf_event_task_tick(struct 
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
-extern void set_perf_event_pending(void);
-extern void perf_event_do_pending(void);
 extern void perf_event_print_debug(void);
 extern void __perf_disable(void);
 extern bool __perf_enable(void);
@@ -1028,7 +1022,6 @@ perf_event_task_tick(struct task_struct 
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
-static inline void perf_event_do_pending(void)				{ }
 static inline void perf_event_print_debug(void)				{ }
 static inline void perf_disable(void)					{ }
 static inline void perf_enable(void)					{ }
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -21,6 +21,13 @@ config CONSTRUCTORS
 	depends on !UML
 	default y
 
+config HAVE_IRQ_WORK
+	bool
+
+config IRQ_WORK
+	bool
+	depends on HAVE_IRQ_WORK
+
 menu "General setup"
 
 config EXPERIMENTAL
@@ -983,6 +990,7 @@ config PERF_EVENTS
 	default y if (PROFILING || PERF_COUNTERS)
 	depends on HAVE_PERF_EVENTS
 	select ANON_INODES
+	select IRQ_WORK
 	help
 	  Enable kernel support for various performance events provided
 	  by software and hardware.
Index: linux-2.6/kernel/Makefile
===================================================================
--- linux-2.6.orig/kernel/Makefile
+++ linux-2.6/kernel/Makefile
@@ -23,6 +23,7 @@ CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
 CFLAGS_REMOVE_perf_event.o = -pg
+CFLAGS_REMOVE_irq_work.o = -pg
 endif
 
 obj-$(CONFIG_FREEZER) += freezer.o
@@ -101,6 +102,7 @@ obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_SLOW_WORK) += slow-work.o
 obj-$(CONFIG_SLOW_WORK_DEBUG) += slow-work-debugfs.o
+obj-$(CONFIG_IRQ_WORK) += irq_work.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1880,12 +1880,11 @@ static void free_event_rcu(struct rcu_he
 	kfree(event);
 }
 
-static void perf_pending_sync(struct perf_event *event);
 static void perf_buffer_put(struct perf_buffer *buffer);
 
 static void free_event(struct perf_event *event)
 {
-	perf_pending_sync(event);
+	irq_work_sync(&event->pending);
 
 	if (!event->parent) {
 		atomic_dec(&nr_events);
@@ -2829,15 +2828,6 @@ void perf_event_wakeup(struct perf_event
 	}
 }
 
-/*
- * Pending wakeups
- *
- * Handle the case where we need to wakeup up from NMI (or rq->lock) context.
- *
- * The NMI bit means we cannot possibly take locks. Therefore, maintain a
- * single linked list and use cmpxchg() to add entries lockless.
- */
-
 static void perf_pending_event(struct perf_pending_entry *entry)
 {
 	struct perf_event *event = container_of(entry,
@@ -2854,89 +2844,6 @@ static void perf_pending_event(struct pe
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
-{
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
-}
-
-static inline int perf_not_pending(struct perf_event *event)
-{
-	/*
-	 * If we flush on whatever cpu we run, there is a chance we don't
-	 * need to wait.
-	 */
-	get_cpu();
-	__perf_pending_run();
-	put_cpu();
-
-	/*
-	 * Ensure we see the proper queue state before going to sleep
-	 * so that we do not miss the wakeup. -- see perf_pending_handle()
-	 */
-	smp_rmb();
-	return event->pending.next == NULL;
-}
-
-static void perf_pending_sync(struct perf_event *event)
-{
-	wait_event(event->waitq, perf_not_pending(event));
-}
-
-void perf_event_do_pending(void)
-{
-	__perf_pending_run();
-}
-
 /*
  * Callchain support -- arch specific
  */
@@ -2996,8 +2903,7 @@ static void perf_output_wakeup(struct pe
 
 	if (handle->nmi) {
 		handle->event->pending_wakeup = 1;
-		perf_pending_queue(&handle->event->pending,
-				   perf_pending_event);
+		irq_work_queue(&handle->event->pending);
 	} else
 		perf_event_wakeup(handle->event);
 }
@@ -3988,8 +3894,7 @@ static int __perf_event_overflow(struct 
 		event->pending_kill = POLL_HUP;
 		if (nmi) {
 			event->pending_disable = 1;
-			perf_pending_queue(&event->pending,
-					   perf_pending_event);
+			irq_work_queue(&event->pending);
 		} else
 			perf_event_disable(event);
 	}
@@ -4841,6 +4746,7 @@ perf_event_alloc(struct perf_event_attr 
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
 	init_waitqueue_head(&event->waitq);
+	irq_work_init(&event->pending, perf_pending_event);
 
 	mutex_init(&event->mmap_mutex);
 
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -37,7 +37,7 @@
 #include <linux/delay.h>
 #include <linux/tick.h>
 #include <linux/kallsyms.h>
-#include <linux/perf_event.h>
+#include <linux/irq_work.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 
@@ -1260,7 +1260,7 @@ void update_process_times(int user_tick)
 	run_local_timers();
 	rcu_check_callbacks(cpu, user_tick);
 	printk_tick();
-	perf_event_do_pending();
+	irq_work_run();
 	scheduler_tick();
 	run_posix_cpu_timers(p);
 }
Index: linux-2.6/arch/arm/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/perf_event.c
+++ linux-2.6/arch/arm/kernel/perf_event.c
@@ -1045,7 +1045,7 @@ armv6pmu_handle_irq(int irq_num,
 	 * platforms that can have the PMU interrupts raised as a PMI, this
 	 * will not work.
 	 */
-	perf_event_do_pending();
+	irq_work_run();
 
 	return IRQ_HANDLED;
 }
@@ -2021,7 +2021,7 @@ static irqreturn_t armv7pmu_handle_irq(i
 	 * platforms that can have the PMU interrupts raised as a PMI, this
 	 * will not work.
 	 */
-	perf_event_do_pending();
+	irq_work_run();
 
 	return IRQ_HANDLED;
 }

