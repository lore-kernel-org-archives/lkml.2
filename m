Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab0JRTTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:19:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:59418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab0JRTTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:19:44 -0400
Date: Mon, 18 Oct 2010 19:19:08 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, kyle@mcmartin.ca,
        ying.huang@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, kyle@mcmartin.ca,
        ying.huang@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1287036094.7768.291.camel@yhuang-dev>
References: <1287036094.7768.291.camel@yhuang-dev>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] irq_work: Add generic hardirq context callbacks
Message-ID: <tip-e360adbe29241a0194e10e20595360dd7b98a2b3@git.kernel.org>
Git-Commit-ID: e360adbe29241a0194e10e20595360dd7b98a2b3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:19:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e360adbe29241a0194e10e20595360dd7b98a2b3
Gitweb:     http://git.kernel.org/tip/e360adbe29241a0194e10e20595360dd7b98a2b3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 14 Oct 2010 14:01:34 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 19:58:50 +0200

irq_work: Add generic hardirq context callbacks

Provide a mechanism that allows running code in IRQ context. It is
most useful for NMI code that needs to interact with the rest of the
system -- like wakeup a task to drain buffers.

Perf currently has such a mechanism, so extract that and provide it as
a generic feature, independent of perf so that others may also
benefit.

The IRQ context callback is generated through self-IPIs where
possible, or on architectures like powerpc the decrementer (the
built-in timer facility) is set to generate an interrupt immediately.

Architectures that don't have anything like this get to do with a
callback from the timer tick. These architectures can call
irq_work_run() at the tail of any IRQ handlers that might enqueue such
work (like the perf IRQ handler) to avoid undue latencies in
processing the work.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
[ various fixes ]
Signed-off-by: Huang Ying <ying.huang@intel.com>
LKML-Reference: <1287036094.7768.291.camel@yhuang-dev>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/alpha/Kconfig                   |    1 +
 arch/alpha/include/asm/perf_event.h  |    5 -
 arch/alpha/kernel/time.c             |   30 +++---
 arch/arm/Kconfig                     |    1 +
 arch/arm/include/asm/perf_event.h    |   12 ---
 arch/arm/kernel/perf_event.c         |    8 +-
 arch/frv/Kconfig                     |    1 +
 arch/frv/lib/Makefile                |    2 +-
 arch/frv/lib/perf_event.c            |   19 ----
 arch/parisc/Kconfig                  |    1 +
 arch/parisc/include/asm/perf_event.h |    3 +-
 arch/powerpc/Kconfig                 |    1 +
 arch/powerpc/include/asm/paca.h      |    2 +-
 arch/powerpc/kernel/time.c           |   42 +++++-----
 arch/s390/Kconfig                    |    1 +
 arch/s390/include/asm/perf_event.h   |    3 +-
 arch/sh/Kconfig                      |    1 +
 arch/sh/include/asm/perf_event.h     |    7 --
 arch/sparc/Kconfig                   |    2 +
 arch/sparc/include/asm/perf_event.h  |    4 -
 arch/sparc/kernel/pcr.c              |    8 +-
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/entry_arch.h    |    4 +-
 arch/x86/include/asm/hardirq.h       |    2 +-
 arch/x86/include/asm/hw_irq.h        |    2 +-
 arch/x86/include/asm/irq_vectors.h   |    4 +-
 arch/x86/kernel/Makefile             |    1 +
 arch/x86/kernel/cpu/perf_event.c     |   19 ----
 arch/x86/kernel/entry_64.S           |    6 +-
 arch/x86/kernel/irq.c                |    8 +-
 arch/x86/kernel/irq_work.c           |   30 ++++++
 arch/x86/kernel/irqinit.c            |    6 +-
 include/linux/irq_work.h             |   20 ++++
 include/linux/perf_event.h           |   11 +--
 init/Kconfig                         |    8 ++
 kernel/Makefile                      |    2 +
 kernel/irq_work.c                    |  164 ++++++++++++++++++++++++++++++++++
 kernel/perf_event.c                  |  104 +--------------------
 kernel/timer.c                       |    7 +-
 39 files changed, 311 insertions(+), 242 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index b9647bb..d04ccd7 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -9,6 +9,7 @@ config ALPHA
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
 	help
diff --git a/arch/alpha/include/asm/perf_event.h b/arch/alpha/include/asm/perf_event.h
index 4157cd3..fe792ca 100644
--- a/arch/alpha/include/asm/perf_event.h
+++ b/arch/alpha/include/asm/perf_event.h
@@ -1,11 +1,6 @@
 #ifndef __ASM_ALPHA_PERF_EVENT_H
 #define __ASM_ALPHA_PERF_EVENT_H
 
-/* Alpha only supports software events through this interface. */
-extern void set_perf_event_pending(void);
-
-#define PERF_EVENT_INDEX_OFFSET 0
-
 #ifdef CONFIG_PERF_EVENTS
 extern void init_hw_perf_events(void);
 #else
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 396af17..0f1d849 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -41,7 +41,7 @@
 #include <linux/init.h>
 #include <linux/bcd.h>
 #include <linux/profile.h>
-#include <linux/perf_event.h>
+#include <linux/irq_work.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -83,25 +83,25 @@ static struct {
 
 unsigned long est_cycle_freq;
 
-#ifdef CONFIG_PERF_EVENTS
+#ifdef CONFIG_IRQ_WORK
 
-DEFINE_PER_CPU(u8, perf_event_pending);
+DEFINE_PER_CPU(u8, irq_work_pending);
 
-#define set_perf_event_pending_flag()  __get_cpu_var(perf_event_pending) = 1
-#define test_perf_event_pending()      __get_cpu_var(perf_event_pending)
-#define clear_perf_event_pending()     __get_cpu_var(perf_event_pending) = 0
+#define set_irq_work_pending_flag()  __get_cpu_var(irq_work_pending) = 1
+#define test_irq_work_pending()      __get_cpu_var(irq_work_pending)
+#define clear_irq_work_pending()     __get_cpu_var(irq_work_pending) = 0
 
-void set_perf_event_pending(void)
+void set_irq_work_pending(void)
 {
-	set_perf_event_pending_flag();
+	set_irq_work_pending_flag();
 }
 
-#else  /* CONFIG_PERF_EVENTS */
+#else  /* CONFIG_IRQ_WORK */
 
-#define test_perf_event_pending()      0
-#define clear_perf_event_pending()
+#define test_irq_work_pending()      0
+#define clear_irq_work_pending()
 
-#endif /* CONFIG_PERF_EVENTS */
+#endif /* CONFIG_IRQ_WORK */
 
 
 static inline __u32 rpcc(void)
@@ -191,9 +191,9 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 
 	write_sequnlock(&xtime_lock);
 
-	if (test_perf_event_pending()) {
-		clear_perf_event_pending();
-		perf_event_do_pending();
+	if (test_irq_work_pending()) {
+		clear_irq_work_pending();
+		irq_work_run();
 	}
 
 #ifndef CONFIG_SMP
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 88c97bc..7c0dfcc 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -23,6 +23,7 @@ config ARM
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_REGS_AND_STACK_ACCESS_API
diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
index b5799a3..c4aa4e8 100644
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
- * interrupts disabled.
- */
-static inline void
-set_perf_event_pending(void)
-{
-}
-
 /* ARM performance counters start from 1 (in the cp15 accesses) so use the
  * same indexes here for consistency. */
 #define PERF_EVENT_INDEX_OFFSET 1
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 6cc6521..49643b1 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -1092,7 +1092,7 @@ armv6pmu_handle_irq(int irq_num,
 	 * platforms that can have the PMU interrupts raised as an NMI, this
 	 * will not work.
 	 */
-	perf_event_do_pending();
+	irq_work_run();
 
 	return IRQ_HANDLED;
 }
@@ -2068,7 +2068,7 @@ static irqreturn_t armv7pmu_handle_irq(int irq_num, void *dev)
 	 * platforms that can have the PMU interrupts raised as an NMI, this
 	 * will not work.
 	 */
-	perf_event_do_pending();
+	irq_work_run();
 
 	return IRQ_HANDLED;
 }
@@ -2436,7 +2436,7 @@ xscale1pmu_handle_irq(int irq_num, void *dev)
 			armpmu->disable(hwc, idx);
 	}
 
-	perf_event_do_pending();
+	irq_work_run();
 
 	/*
 	 * Re-enable the PMU.
@@ -2763,7 +2763,7 @@ xscale2pmu_handle_irq(int irq_num, void *dev)
 			armpmu->disable(hwc, idx);
 	}
 
-	perf_event_do_pending();
+	irq_work_run();
 
 	/*
 	 * Re-enable the PMU.
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 16399bd..0f2417d 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -7,6 +7,7 @@ config FRV
 	default y
 	select HAVE_IDE
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 
 config ZONE_DMA
diff --git a/arch/frv/lib/Makefile b/arch/frv/lib/Makefile
index f470975..4ff2fb1 100644
--- a/arch/frv/lib/Makefile
+++ b/arch/frv/lib/Makefile
@@ -5,4 +5,4 @@
 lib-y := \
 	__ashldi3.o __lshrdi3.o __muldi3.o __ashrdi3.o __negdi2.o __ucmpdi2.o \
 	checksum.o memcpy.o memset.o atomic-ops.o atomic64-ops.o \
-	outsl_ns.o outsl_sw.o insl_ns.o insl_sw.o cache.o perf_event.o
+	outsl_ns.o outsl_sw.o insl_ns.o insl_sw.o cache.o
diff --git a/arch/frv/lib/perf_event.c b/arch/frv/lib/perf_event.c
deleted file mode 100644
index 9ac5acf..0000000
--- a/arch/frv/lib/perf_event.c
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
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 907417d..79a04a9 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -16,6 +16,7 @@ config PARISC
 	select RTC_DRV_GENERIC
 	select INIT_ALL_POSSIBLE
 	select BUG
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select GENERIC_ATOMIC64 if !64BIT
 	help
diff --git a/arch/parisc/include/asm/perf_event.h b/arch/parisc/include/asm/perf_event.h
index cc14642..1e0fd8b 100644
--- a/arch/parisc/include/asm/perf_event.h
+++ b/arch/parisc/include/asm/perf_event.h
@@ -1,7 +1,6 @@
 #ifndef __ASM_PARISC_PERF_EVENT_H
 #define __ASM_PARISC_PERF_EVENT_H
 
-/* parisc only supports software events through this interface. */
-static inline void set_perf_event_pending(void) { }
+/* Empty, just to avoid compiling error */
 
 #endif /* __ASM_PARISC_PERF_EVENT_H */
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 631e5a0..4b1e521 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -138,6 +138,7 @@ config PPC
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS if PPC64
 	select GENERIC_ATOMIC64 if PPC32
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index 1ff6662..9b287fd 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -129,7 +129,7 @@ struct paca_struct {
 	u8 soft_enabled;		/* irq soft-enable flag */
 	u8 hard_enabled;		/* set if irqs are enabled in MSR */
 	u8 io_sync;			/* writel() needs spin_unlock sync */
-	u8 perf_event_pending;		/* PM interrupt while soft-disabled */
+	u8 irq_work_pending;		/* IRQ_WORK interrupt while soft-disable */
 
 	/* Stuff for accurate time accounting */
 	u64 user_time;			/* accumulated usermode TB ticks */
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 8533b3b..54888eb 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -53,7 +53,7 @@
 #include <linux/posix-timers.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
-#include <linux/perf_event.h>
+#include <linux/irq_work.h>
 #include <asm/trace.h>
 
 #include <asm/io.h>
@@ -493,60 +493,60 @@ void __init iSeries_time_init_early(void)
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
@@ -587,9 +587,9 @@ void timer_interrupt(struct pt_regs * regs)
 
 	calculate_steal_time();
 
-	if (test_perf_event_pending()) {
-		clear_perf_event_pending();
-		perf_event_do_pending();
+	if (test_irq_work_pending()) {
+		clear_irq_work_pending();
+		irq_work_run();
 	}
 
 #ifdef CONFIG_PPC_ISERIES
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index f0777a4..958f0da 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -95,6 +95,7 @@ config S390
 	select HAVE_KVM if 64BIT
 	select HAVE_ARCH_TRACEHOOK
 	select INIT_ALL_POSSIBLE
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
diff --git a/arch/s390/include/asm/perf_event.h b/arch/s390/include/asm/perf_event.h
index 3840cbe..a75f168 100644
--- a/arch/s390/include/asm/perf_event.h
+++ b/arch/s390/include/asm/perf_event.h
@@ -4,7 +4,6 @@
  * Copyright 2009 Martin Schwidefsky, IBM Corporation.
  */
 
-static inline void set_perf_event_pending(void) {}
-static inline void clear_perf_event_pending(void) {}
+/* Empty, just to avoid compiling error */
 
 #define PERF_EVENT_INDEX_OFFSET 0
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 35b6c3f..35b6879 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -16,6 +16,7 @@ config SUPERH
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_KERNEL_GZIP
diff --git a/arch/sh/include/asm/perf_event.h b/arch/sh/include/asm/perf_event.h
index 3d0c9f3..14308be 100644
--- a/arch/sh/include/asm/perf_event.h
+++ b/arch/sh/include/asm/perf_event.h
@@ -26,11 +26,4 @@ extern int register_sh_pmu(struct sh_pmu *);
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
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 9212cd4..3e9d314 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -26,6 +26,7 @@ config SPARC
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select RTC_CLASS
 	select RTC_DRV_M48T59
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_DMA_ATTRS
@@ -54,6 +55,7 @@ config SPARC64
 	select RTC_DRV_BQ4802
 	select RTC_DRV_SUN4V
 	select RTC_DRV_STARFIRE
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 
diff --git a/arch/sparc/include/asm/perf_event.h b/arch/sparc/include/asm/perf_event.h
index 727af70..6e8bfa1 100644
--- a/arch/sparc/include/asm/perf_event.h
+++ b/arch/sparc/include/asm/perf_event.h
@@ -1,10 +1,6 @@
 #ifndef __ASM_SPARC_PERF_EVENT_H
 #define __ASM_SPARC_PERF_EVENT_H
 
-extern void set_perf_event_pending(void);
-
-#define	PERF_EVENT_INDEX_OFFSET	0
-
 #ifdef CONFIG_PERF_EVENTS
 #include <asm/ptrace.h>
 
diff --git a/arch/sparc/kernel/pcr.c b/arch/sparc/kernel/pcr.c
index c4a6a50..b87873c 100644
--- a/arch/sparc/kernel/pcr.c
+++ b/arch/sparc/kernel/pcr.c
@@ -7,7 +7,7 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 
-#include <linux/perf_event.h>
+#include <linux/irq_work.h>
 #include <linux/ftrace.h>
 
 #include <asm/pil.h>
@@ -43,14 +43,14 @@ void __irq_entry deferred_pcr_work_irq(int irq, struct pt_regs *regs)
 
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
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9815221..fd227d6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -25,6 +25,7 @@ config X86
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_PERF_EVENTS if (!M386 && !M486)
+	select HAVE_IRQ_WORK
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 8e8ec66..b8e96a1 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -49,8 +49,8 @@ BUILD_INTERRUPT(apic_timer_interrupt,LOCAL_TIMER_VECTOR)
 BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
 BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
 
-#ifdef CONFIG_PERF_EVENTS
-BUILD_INTERRUPT(perf_pending_interrupt, LOCAL_PENDING_VECTOR)
+#ifdef CONFIG_IRQ_WORK
+BUILD_INTERRUPT(irq_work_interrupt, IRQ_WORK_VECTOR)
 #endif
 
 #ifdef CONFIG_X86_THERMAL_VECTOR
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index aeab29a..55e4de6 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -14,7 +14,7 @@ typedef struct {
 #endif
 	unsigned int x86_platform_ipis;	/* arch dependent */
 	unsigned int apic_perf_irqs;
-	unsigned int apic_pending_irqs;
+	unsigned int apic_irq_work_irqs;
 #ifdef CONFIG_SMP
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 46c0fe0..3a54a1c 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -29,7 +29,7 @@
 extern void apic_timer_interrupt(void);
 extern void x86_platform_ipi(void);
 extern void error_interrupt(void);
-extern void perf_pending_interrupt(void);
+extern void irq_work_interrupt(void);
 
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index e2ca300..6af0894 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -114,9 +114,9 @@
 #define X86_PLATFORM_IPI_VECTOR		0xed
 
 /*
- * Performance monitoring pending work vector:
+ * IRQ work vector:
  */
-#define LOCAL_PENDING_VECTOR		0xec
+#define IRQ_WORK_VECTOR			0xec
 
 #define UV_BAU_MESSAGE			0xea
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9d3f485..7490bf8 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -35,6 +35,7 @@ obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
 obj-y			+= setup.o x86_init.o i8259.o irqinit.o jump_label.o
+obj-$(CONFIG_IRQ_WORK)  += irq_work.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e2513f2..fe73c18 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1196,25 +1196,6 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
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
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 17be5ec..c375c79 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1023,9 +1023,9 @@ apicinterrupt ERROR_APIC_VECTOR \
 apicinterrupt SPURIOUS_APIC_VECTOR \
 	spurious_interrupt smp_spurious_interrupt
 
-#ifdef CONFIG_PERF_EVENTS
-apicinterrupt LOCAL_PENDING_VECTOR \
-	perf_pending_interrupt smp_perf_pending_interrupt
+#ifdef CONFIG_IRQ_WORK
+apicinterrupt IRQ_WORK_VECTOR \
+	irq_work_interrupt smp_irq_work_interrupt
 #endif
 
 /*
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 91fd0c7..44edb03 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -67,10 +67,10 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
 	seq_printf(p, "  Performance monitoring interrupts\n");
-	seq_printf(p, "%*s: ", prec, "PND");
+	seq_printf(p, "%*s: ", prec, "IWI");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->apic_pending_irqs);
-	seq_printf(p, "  Performance pending work\n");
+		seq_printf(p, "%10u ", irq_stats(j)->apic_irq_work_irqs);
+	seq_printf(p, "  IRQ work interrupts\n");
 #endif
 	if (x86_platform_ipi_callback) {
 		seq_printf(p, "%*s: ", prec, "PLT");
@@ -185,7 +185,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->apic_timer_irqs;
 	sum += irq_stats(cpu)->irq_spurious_count;
 	sum += irq_stats(cpu)->apic_perf_irqs;
-	sum += irq_stats(cpu)->apic_pending_irqs;
+	sum += irq_stats(cpu)->apic_irq_work_irqs;
 #endif
 	if (x86_platform_ipi_callback)
 		sum += irq_stats(cpu)->x86_platform_ipis;
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
new file mode 100644
index 0000000..ca8f703
--- /dev/null
+++ b/arch/x86/kernel/irq_work.c
@@ -0,0 +1,30 @@
+/*
+ * x86 specific code for irq_work
+ *
+ * Copyright (C) 2010 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/irq_work.h>
+#include <linux/hardirq.h>
+#include <asm/apic.h>
+
+void smp_irq_work_interrupt(struct pt_regs *regs)
+{
+	irq_enter();
+	ack_APIC_irq();
+	inc_irq_stat(apic_irq_work_irqs);
+	irq_work_run();
+	irq_exit();
+}
+
+void arch_irq_work_raise(void)
+{
+#ifdef CONFIG_X86_LOCAL_APIC
+	if (!cpu_has_apic)
+		return;
+
+	apic->send_IPI_self(IRQ_WORK_VECTOR);
+	apic_wait_icr_idle();
+#endif
+}
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 990ae7c..713969b 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -224,9 +224,9 @@ static void __init apic_intr_init(void)
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 
-	/* Performance monitoring interrupts: */
-# ifdef CONFIG_PERF_EVENTS
-	alloc_intr_gate(LOCAL_PENDING_VECTOR, perf_pending_interrupt);
+	/* IRQ work interrupts: */
+# ifdef CONFIG_IRQ_WORK
+	alloc_intr_gate(IRQ_WORK_VECTOR, irq_work_interrupt);
 # endif
 
 #endif
diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
new file mode 100644
index 0000000..4fa09d4
--- /dev/null
+++ b/include/linux/irq_work.h
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
+bool irq_work_queue(struct irq_work *entry);
+void irq_work_run(void);
+void irq_work_sync(struct irq_work *entry);
+
+#endif /* _LINUX_IRQ_WORK_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index a9227e9..2ebfc9a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -486,6 +486,7 @@ struct perf_guest_info_callbacks {
 #include <linux/workqueue.h>
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
+#include <linux/irq_work.h>
 #include <asm/atomic.h>
 #include <asm/local.h>
 
@@ -672,11 +673,6 @@ struct perf_buffer {
 	void				*data_pages[0];
 };
 
-struct perf_pending_entry {
-	struct perf_pending_entry *next;
-	void (*func)(struct perf_pending_entry *);
-};
-
 struct perf_sample_data;
 
 typedef void (*perf_overflow_handler_t)(struct perf_event *, int,
@@ -784,7 +780,7 @@ struct perf_event {
 	int				pending_wakeup;
 	int				pending_kill;
 	int				pending_disable;
-	struct perf_pending_entry	pending;
+	struct irq_work			pending;
 
 	atomic_t			event_limit;
 
@@ -898,8 +894,6 @@ extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
 extern void perf_event_delayed_put(struct task_struct *task);
-extern void set_perf_event_pending(void);
-extern void perf_event_do_pending(void);
 extern void perf_event_print_debug(void);
 extern void perf_pmu_disable(struct pmu *pmu);
 extern void perf_pmu_enable(struct pmu *pmu);
@@ -1078,7 +1072,6 @@ static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
 static inline void perf_event_delayed_put(struct task_struct *task)	{ }
-static inline void perf_event_do_pending(void)				{ }
 static inline void perf_event_print_debug(void)				{ }
 static inline int perf_event_task_disable(void)				{ return -EINVAL; }
 static inline int perf_event_task_enable(void)				{ return -EINVAL; }
diff --git a/init/Kconfig b/init/Kconfig
index 2de5b1c..1ef0b43 100644
--- a/init/Kconfig
+++ b/init/Kconfig
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
@@ -987,6 +994,7 @@ config PERF_EVENTS
 	default y if (PROFILING || PERF_COUNTERS)
 	depends on HAVE_PERF_EVENTS
 	select ANON_INODES
+	select IRQ_WORK
 	help
 	  Enable kernel support for various performance events provided
 	  by software and hardware.
diff --git a/kernel/Makefile b/kernel/Makefile
index d52b473..4d9bf5f 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -23,6 +23,7 @@ CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
 CFLAGS_REMOVE_perf_event.o = -pg
+CFLAGS_REMOVE_irq_work.o = -pg
 endif
 
 obj-$(CONFIG_FREEZER) += freezer.o
@@ -100,6 +101,7 @@ obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
+obj-$(CONFIG_IRQ_WORK) += irq_work.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
new file mode 100644
index 0000000..f16763f
--- /dev/null
+++ b/kernel/irq_work.c
@@ -0,0 +1,164 @@
+/*
+ * Copyright (C) 2010 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *
+ * Provides a framework for enqueueing and running callbacks from hardirq
+ * context. The enqueueing is NMI-safe.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
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
+	struct irq_work *next, *nflags;
+
+	do {
+		next = entry->next;
+		if ((unsigned long)next & IRQ_WORK_PENDING)
+			return false;
+		nflags = next_flags(next, IRQ_WORK_FLAGS);
+	} while (cmpxchg(&entry->next, next, nflags) != next);
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
+	struct irq_work **head, *next;
+
+	head = &get_cpu_var(irq_work_list);
+
+	do {
+		next = *head;
+		/* Can assign non-atomic because we keep the flags set. */
+		entry->next = next_flags(next, IRQ_WORK_FLAGS);
+	} while (cmpxchg(head, next, entry) != next);
+
+	/* The list was empty, raise self-interrupt to start processing. */
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
+EXPORT_SYMBOL_GPL(irq_work_queue);
+
+/*
+ * Run the irq_work entries on this cpu. Requires to be ran from hardirq
+ * context with local IRQs disabled.
+ */
+void irq_work_run(void)
+{
+	struct irq_work *list, **head;
+
+	head = &__get_cpu_var(irq_work_list);
+	if (*head == NULL)
+		return;
+
+	BUG_ON(!in_irq());
+	BUG_ON(!irqs_disabled());
+
+	list = xchg(head, NULL);
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
+EXPORT_SYMBOL_GPL(irq_work_run);
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
+EXPORT_SYMBOL_GPL(irq_work_sync);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 634f86a..99b9700 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2206,12 +2206,11 @@ static void free_event_rcu(struct rcu_head *head)
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
@@ -3162,16 +3161,7 @@ void perf_event_wakeup(struct perf_event *event)
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
-static void perf_pending_event(struct perf_pending_entry *entry)
+static void perf_pending_event(struct irq_work *entry)
 {
 	struct perf_event *event = container_of(entry,
 			struct perf_event, pending);
@@ -3187,89 +3177,6 @@ static void perf_pending_event(struct perf_pending_entry *entry)
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
  * We assume there is only KVM supporting the callbacks.
  * Later on, we might change it to a list if there is
@@ -3319,8 +3226,7 @@ static void perf_output_wakeup(struct perf_output_handle *handle)
 
 	if (handle->nmi) {
 		handle->event->pending_wakeup = 1;
-		perf_pending_queue(&handle->event->pending,
-				   perf_pending_event);
+		irq_work_queue(&handle->event->pending);
 	} else
 		perf_event_wakeup(handle->event);
 }
@@ -4356,8 +4262,7 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 		event->pending_kill = POLL_HUP;
 		if (nmi) {
 			event->pending_disable = 1;
-			perf_pending_queue(&event->pending,
-					   perf_pending_event);
+			irq_work_queue(&event->pending);
 		} else
 			perf_event_disable(event);
 	}
@@ -5374,6 +5279,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
 	init_waitqueue_head(&event->waitq);
+	init_irq_work(&event->pending, perf_pending_event);
 
 	mutex_init(&event->mmap_mutex);
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 97bf05b..68a9ae7 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -37,7 +37,7 @@
 #include <linux/delay.h>
 #include <linux/tick.h>
 #include <linux/kallsyms.h>
-#include <linux/perf_event.h>
+#include <linux/irq_work.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 
@@ -1279,7 +1279,10 @@ void update_process_times(int user_tick)
 	run_local_timers();
 	rcu_check_callbacks(cpu, user_tick);
 	printk_tick();
-	perf_event_do_pending();
+#ifdef CONFIG_IRQ_WORK
+	if (in_irq())
+		irq_work_run();
+#endif
 	scheduler_tick();
 	run_posix_cpu_timers(p);
 }
