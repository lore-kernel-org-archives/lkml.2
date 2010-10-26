Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab0JZC5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:57:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933075Ab0JZC4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:56:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 39/43] MN10300: Generic time support
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>
Date: Tue, 26 Oct 2010 03:56:30 +0100
Message-ID: <20101026025629.23512.74230.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

Implement generic time support for MN10300.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig                           |   22 ++++
 arch/mn10300/include/asm/timex.h               |   17 +++
 arch/mn10300/kernel/Makefile                   |    2 
 arch/mn10300/kernel/cevt-mn10300.c             |  131 ++++++++++++++++++++++++
 arch/mn10300/kernel/csrc-mn10300.c             |   35 ++++++
 arch/mn10300/kernel/internal.h                 |   13 ++
 arch/mn10300/kernel/irq.c                      |   32 ++----
 arch/mn10300/kernel/smp.c                      |   15 ++-
 arch/mn10300/kernel/time.c                     |   79 +++++++++++---
 arch/mn10300/unit-asb2303/include/unit/timex.h |   48 ++++-----
 arch/mn10300/unit-asb2305/include/unit/timex.h |   48 ++++-----
 arch/mn10300/unit-asb2364/include/unit/timex.h |   74 ++++++++++----
 12 files changed, 401 insertions(+), 115 deletions(-)
 create mode 100644 arch/mn10300/kernel/cevt-mn10300.c
 create mode 100644 arch/mn10300/kernel/csrc-mn10300.c


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 88901a2..129ca49 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -56,6 +56,27 @@ config GENERIC_FIND_NEXT_BIT
 config GENERIC_HWEIGHT
 	def_bool y
 
+config GENERIC_TIME
+	def_bool y
+
+config GENERIC_CLOCKEVENTS
+	def_bool y
+
+config GENERIC_CLOCKEVENTS_BUILD
+	def_bool y
+	depends on GENERIC_CLOCKEVENTS
+
+config GENERIC_CLOCKEVENTS_BROADCAST
+	bool
+
+config CEVT_MN10300
+       def_bool y
+       depends on GENERIC_CLOCKEVENTS
+
+config CSRC_MN10300
+       def_bool y
+       depends on GENERIC_TIME
+
 config GENERIC_BUG
 	def_bool y
 
@@ -246,6 +267,7 @@ config MN10300_USING_JTAG
 	  single-stepping, which are taken over completely by the JTAG unit.
 
 source "kernel/Kconfig.hz"
+source "kernel/time/Kconfig"
 
 config MN10300_RTC
 	bool "Using MN10300 RTC"
diff --git a/arch/mn10300/include/asm/timex.h b/arch/mn10300/include/asm/timex.h
index ce5719a..bd4e90d 100644
--- a/arch/mn10300/include/asm/timex.h
+++ b/arch/mn10300/include/asm/timex.h
@@ -18,15 +18,28 @@
 
 #define CLOCK_TICK_RATE MN10300_JCCLK /* Underlying HZ */
 
-extern cycles_t cacheflush_time;
-
 #ifdef __KERNEL__
 
+extern cycles_t cacheflush_time;
+
 static inline cycles_t get_cycles(void)
 {
 	return read_timestamp_counter();
 }
 
+extern int init_clockevents(void);
+extern int init_clocksource(void);
+
+static inline void setup_jiffies_interrupt(int irq,
+					   struct irqaction *action)
+{
+	u16 tmp;
+	setup_irq(irq, action);
+	set_intr_level(irq, NUM2GxICR_LEVEL(CONFIG_TIMER_IRQ_LEVEL));
+	GxICR(irq) |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
+	tmp = GxICR(irq);
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_TIMEX_H */
diff --git a/arch/mn10300/kernel/Makefile b/arch/mn10300/kernel/Makefile
index 5b41192..8f5f1e8 100644
--- a/arch/mn10300/kernel/Makefile
+++ b/arch/mn10300/kernel/Makefile
@@ -28,3 +28,5 @@ obj-$(CONFIG_MN10300_RTC) += rtc.o
 obj-$(CONFIG_PROFILE) += profile.o profile-low.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_KPROBES) += kprobes.o
+obj-$(CONFIG_CSRC_MN10300) += csrc-mn10300.o
+obj-$(CONFIG_CEVT_MN10300) += cevt-mn10300.o
diff --git a/arch/mn10300/kernel/cevt-mn10300.c b/arch/mn10300/kernel/cevt-mn10300.c
new file mode 100644
index 0000000..d4cb535
--- /dev/null
+++ b/arch/mn10300/kernel/cevt-mn10300.c
@@ -0,0 +1,131 @@
+/* MN10300 clockevents
+ *
+ * Copyright (C) 2010 Red Hat, Inc. All Rights Reserved.
+ * Written by Mark Salter (msalter@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/percpu.h>
+#include <linux/smp.h>
+#include <asm/timex.h>
+#include "internal.h"
+
+#ifdef CONFIG_SMP
+#if (CONFIG_NR_CPUS > 2) && !defined(CONFIG_GEENERIC_CLOCKEVENTS_BROADCAST)
+#error "This doesn't scale well! Need per-core local timers."
+#endif
+#else /* CONFIG_SMP */
+#define stop_jiffies_counter1()
+#define reload_jiffies_counter1(x)
+#define TMJC1IRQ TMJCIRQ
+#endif
+
+
+static int next_event(unsigned long delta,
+		      struct clock_event_device *evt)
+{
+	unsigned int cpu = smp_processor_id();
+
+	if (cpu == 0) {
+		stop_jiffies_counter();
+		reload_jiffies_counter(delta - 1);
+	} else {
+		stop_jiffies_counter1();
+		reload_jiffies_counter1(delta - 1);
+	}
+	return 0;
+}
+
+static void set_clock_mode(enum clock_event_mode mode,
+			   struct clock_event_device *evt)
+{
+	/* Nothing to do ...  */
+}
+
+static DEFINE_PER_CPU(struct clock_event_device, mn10300_clockevent_device);
+static DEFINE_PER_CPU(struct irqaction, timer_irq);
+
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *cd;
+	unsigned int cpu = smp_processor_id();
+
+	if (cpu == 0)
+		stop_jiffies_counter();
+	else
+		stop_jiffies_counter1();
+
+	cd = &per_cpu(mn10300_clockevent_device, cpu);
+	cd->event_handler(cd);
+
+	return IRQ_HANDLED;
+}
+
+static void event_handler(struct clock_event_device *dev)
+{
+}
+
+int __init init_clockevents(void)
+{
+	struct clock_event_device *cd;
+	struct irqaction *iact;
+	unsigned int cpu = smp_processor_id();
+
+	cd = &per_cpu(mn10300_clockevent_device, cpu);
+
+	if (cpu == 0) {
+		stop_jiffies_counter();
+		cd->irq	= TMJCIRQ;
+	} else {
+		stop_jiffies_counter1();
+		cd->irq	= TMJC1IRQ;
+	}
+
+	cd->name		= "Timestamp";
+	cd->features		= CLOCK_EVT_FEAT_ONESHOT;
+
+	/* Calculate the min / max delta */
+	clockevent_set_clock(cd, MN10300_JCCLK);
+
+	cd->max_delta_ns	= clockevent_delta2ns(TMJCBR_MAX, cd);
+	cd->min_delta_ns	= clockevent_delta2ns(100, cd);
+
+	cd->rating		= 200;
+	cd->cpumask		= cpumask_of(smp_processor_id());
+	cd->set_mode		= set_clock_mode;
+	cd->event_handler	= event_handler;
+	cd->set_next_event	= next_event;
+
+	iact = &per_cpu(timer_irq, cpu);
+	iact->flags = IRQF_DISABLED | IRQF_SHARED | IRQF_TIMER;
+	iact->handler = timer_interrupt;
+
+	clockevents_register_device(cd);
+
+#if defined(CONFIG_SMP) && !defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)
+	/* setup timer irq affinity so it only runs on this cpu */
+	{
+		struct irq_desc *desc;
+		desc = irq_to_desc(cd->irq);
+		cpumask_copy(desc->affinity, cpumask_of(cpu));
+		iact->flags |= IRQF_NOBALANCING;
+	}
+#endif
+
+	if (cpu == 0) {
+		reload_jiffies_counter(MN10300_JC_PER_HZ - 1);
+		iact->name = "CPU0 Timer";
+	} else {
+		reload_jiffies_counter1(MN10300_JC_PER_HZ - 1);
+		iact->name = "CPU1 Timer";
+	}
+
+	setup_jiffies_interrupt(cd->irq, iact);
+
+	return 0;
+}
diff --git a/arch/mn10300/kernel/csrc-mn10300.c b/arch/mn10300/kernel/csrc-mn10300.c
new file mode 100644
index 0000000..ba2f0c4
--- /dev/null
+++ b/arch/mn10300/kernel/csrc-mn10300.c
@@ -0,0 +1,35 @@
+/* MN10300 clocksource
+ *
+ * Copyright (C) 2010 Red Hat, Inc. All Rights Reserved.
+ * Written by Mark Salter (msalter@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/clocksource.h>
+#include <linux/init.h>
+#include <asm/timex.h>
+#include "internal.h"
+
+static cycle_t mn10300_read(struct clocksource *cs)
+{
+	return read_timestamp_counter();
+}
+
+static struct clocksource clocksource_mn10300 = {
+	.name	= "TSC",
+	.rating	= 200,
+	.read	= mn10300_read,
+	.mask	= CLOCKSOURCE_MASK(32),
+	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+int __init init_clocksource(void)
+{
+	startup_timestamp_counter();
+	clocksource_set_clock(&clocksource_mn10300, MN10300_TSCCLK);
+	clocksource_register(&clocksource_mn10300);
+	return 0;
+}
diff --git a/arch/mn10300/kernel/internal.h b/arch/mn10300/kernel/internal.h
index 3b1f48b..6a064ab 100644
--- a/arch/mn10300/kernel/internal.h
+++ b/arch/mn10300/kernel/internal.h
@@ -9,6 +9,9 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+struct clocksource;
+struct clock_event_device;
+
 /*
  * kthread.S
  */
@@ -30,3 +33,13 @@ extern void mn10300_low_ipi_handler(void);
  * time.c
  */
 extern irqreturn_t local_timer_interrupt(void);
+
+/*
+ * time.c
+ */
+#ifdef CONFIG_CEVT_MN10300
+extern void clockevent_set_clock(struct clock_event_device *, unsigned int);
+#endif
+#ifdef CONFIG_CSRC_MN10300
+extern void clocksource_set_clock(struct clocksource *, unsigned int);
+#endif
diff --git a/arch/mn10300/kernel/irq.c b/arch/mn10300/kernel/irq.c
index 80f1572..2f66a45 100644
--- a/arch/mn10300/kernel/irq.c
+++ b/arch/mn10300/kernel/irq.c
@@ -16,14 +16,6 @@
 #include <asm/setup.h>
 #include <asm/serial-regs.h>
 
-#ifdef CONFIG_SMP
-#undef  GxICR
-#define GxICR(X) CROSS_GxICR(X, irq_affinity_online[X])
-
-#undef  GxICR_u8
-#define GxICR_u8(X) CROSS_GxICR_u8(X, irq_affinity_online[X])
-#endif /* CONFIG_SMP */
-
 unsigned long __mn10300_irq_enabled_epsw[NR_CPUS] __cacheline_aligned_in_smp = {
 	[0 ... NR_CPUS - 1] = EPSW_IE | EPSW_IM_7
 };
@@ -92,9 +84,11 @@ static void mn10300_cpupic_mask_ack(unsigned int irq)
 		GxICR(irq) = (tmp & GxICR_LEVEL);
 		tmp2 = GxICR(irq);
 
-		irq_affinity_online[irq] = any_online_cpu(*irq_desc[irq].affinity);
-		GxICR(irq) = (tmp & (GxICR_LEVEL | GxICR_ENABLE)) | GxICR_DETECT;
-		tmp = GxICR(irq);
+		irq_affinity_online[irq] =
+			any_online_cpu(*irq_desc[irq].affinity);
+		CROSS_GxICR(irq, irq_affinity_online[irq]) =
+			(tmp & (GxICR_LEVEL | GxICR_ENABLE)) | GxICR_DETECT;
+		tmp = CROSS_GxICR(irq, irq_affinity_online[irq]);
 	}
 
 	arch_local_irq_restore(flags);
@@ -128,8 +122,8 @@ static void mn10300_cpupic_unmask_clear(unsigned int irq)
 		tmp = GxICR(irq);
 
 		irq_affinity_online[irq] = any_online_cpu(*irq_desc[irq].affinity);
-		GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE | GxICR_DETECT;
-		tmp = GxICR(irq);
+		CROSS_GxICR(irq, irq_affinity_online[irq]) = (tmp & GxICR_LEVEL) | GxICR_ENABLE | GxICR_DETECT;
+		tmp = CROSS_GxICR(irq, irq_affinity_online[irq]);
 	}
 
 	arch_local_irq_restore(flags);
@@ -217,7 +211,7 @@ static struct irq_chip mn10300_cpu_pic_level = {
 	.unmask		= mn10300_cpupic_unmask_clear,
 #ifdef CONFIG_SMP
 	.set_affinity	= mn10300_cpupic_setaffinity,
-#endif /* CONFIG_SMP */
+#endif
 };
 
 /*
@@ -235,7 +229,7 @@ static struct irq_chip mn10300_cpu_pic_edge = {
 	.unmask		= mn10300_cpupic_unmask,
 #ifdef CONFIG_SMP
 	.set_affinity	= mn10300_cpupic_setaffinity,
-#endif /* CONFIG_SMP */
+#endif
 };
 
 /*
@@ -446,9 +440,9 @@ void migrate_irqs(void)
 		if (irq_affinity_online[irq] == self) {
 			u16 x, tmp;
 
-			x = CROSS_GxICR(irq, self);
-			CROSS_GxICR(irq, self) = x & GxICR_LEVEL;
-			tmp = CROSS_GxICR(irq, self);
+			x = GxICR(irq);
+			GxICR(irq) = x & GxICR_LEVEL;
+			tmp = GxICR(irq);
 
 			new = any_online_cpu(irq_desc[irq].affinity);
 			irq_affinity_online[irq] = new;
@@ -458,7 +452,7 @@ void migrate_irqs(void)
 			tmp = CROSS_GxICR(irq, new);
 
 			x &= GxICR_LEVEL | GxICR_ENABLE;
-			if (CROSS_GxICR(irq, self) & GxICR_REQUEST)
+			if (GxICR(irq) & GxICR_REQUEST) {
 				x |= GxICR_REQUEST | GxICR_DETECT;
 			CROSS_GxICR(irq, new) = x;
 			tmp = CROSS_GxICR(irq, new);
diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index b80234c..0dcd1c6 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -126,7 +126,6 @@ static struct irq_chip mn10300_ipi_type = {
 
 static irqreturn_t smp_reschedule_interrupt(int irq, void *dev_id);
 static irqreturn_t smp_call_function_interrupt(int irq, void *dev_id);
-static irqreturn_t smp_ipi_timer_interrupt(int irq, void *dev_id);
 
 static struct irqaction reschedule_ipi = {
 	.handler	= smp_reschedule_interrupt,
@@ -136,11 +135,15 @@ static struct irqaction call_function_ipi = {
 	.handler	= smp_call_function_interrupt,
 	.name		= "smp call function IPI"
 };
+
+#if !defined(CONFIG_GENERIC_CLOCKEVENTS) || defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)
+static irqreturn_t smp_ipi_timer_interrupt(int irq, void *dev_id);
 static struct irqaction local_timer_ipi = {
 	.handler	= smp_ipi_timer_interrupt,
 	.flags		= IRQF_DISABLED,
 	.name		= "smp local timer IPI"
 };
+#endif
 
 /**
  * init_ipi - Initialise the IPI mechanism
@@ -165,11 +168,14 @@ static void init_ipi(void)
 	mn10300_ipi_enable(CALL_FUNC_SINGLE_IPI);
 
 	/* set up the local timer IPI */
+#if !defined(CONFIG_GENERIC_CLOCKEVENTS) || \
+    defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)
 	set_irq_chip_and_handler(LOCAL_TIMER_IPI,
 				 &mn10300_ipi_type, handle_percpu_irq);
 	setup_irq(LOCAL_TIMER_IPI, &local_timer_ipi);
 	set_intr_level(LOCAL_TIMER_IPI, LOCAL_TIMER_GxICR_LV);
 	mn10300_ipi_enable(LOCAL_TIMER_IPI);
+#endif
 
 #ifdef CONFIG_MN10300_CACHE_ENABLED
 	/* set up the cache flush IPI */
@@ -505,6 +511,8 @@ void smp_nmi_call_function_interrupt(void)
 	}
 }
 
+#if !defined(CONFIG_GENERIC_CLOCKEVENTS) || \
+    defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)
 /**
  * smp_ipi_timer_interrupt - Local timer IPI handler
  * @irq: The interrupt number.
@@ -516,6 +524,7 @@ static irqreturn_t smp_ipi_timer_interrupt(int irq, void *dev_id)
 {
 	return local_timer_interrupt();
 }
+#endif
 
 void __init smp_init_cpus(void)
 {
@@ -620,7 +629,6 @@ void smp_prepare_cpu_init(void)
 int __init start_secondary(void *unused)
 {
 	smp_cpu_init();
-
 	smp_callin();
 	while (!cpu_isset(smp_processor_id(), smp_commenced_mask))
 		cpu_relax();
@@ -629,6 +637,9 @@ int __init start_secondary(void *unused)
 	preempt_disable();
 	smp_online();
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	init_clockevents();
+#endif
 	cpu_idle();
 	return 0;
 }
diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index 0cb9bdb..f860a34 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -17,6 +17,8 @@
 #include <linux/smp.h>
 #include <linux/profile.h>
 #include <linux/cnt32_to_63.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
 #include <asm/irq.h>
 #include <asm/div64.h>
 #include <asm/processor.h>
@@ -27,14 +29,6 @@
 static unsigned long mn10300_last_tsc;	/* time-stamp counter at last time
 					 * interrupt occurred */
 
-static irqreturn_t timer_interrupt(int irq, void *dev_id);
-
-static struct irqaction timer_irq = {
-	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_SHARED | IRQF_TIMER,
-	.name		= "timer",
-};
-
 static unsigned long sched_clock_multiplier;
 
 /*
@@ -54,7 +48,7 @@ unsigned long long sched_clock(void)
 
 	/* read the TSC value
 	 */
-	tsc = 0 - get_cycles(); /* get_cycles() counts down */
+	tsc = get_cycles();
 
 	/* expand to 64-bits.
 	 * - sched_clock() must be called once a minute or better or the
@@ -103,6 +97,7 @@ irqreturn_t local_timer_interrupt(void)
 	return IRQ_HANDLED;
 }
 
+#ifndef CONFIG_GENERIC_TIME
 /*
  * advance the kernel's time keeping clocks (xtime and jiffies)
  * - we use Timer 0 & 1 cascaded as a clock to nudge us the next time
@@ -116,11 +111,11 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	write_seqlock(&xtime_lock);
 
 	while (tsc = get_cycles(),
-	       elapse = mn10300_last_tsc - tsc, /* time elapsed since last
+	       elapse = tsc - mn10300_last_tsc, /* time elapsed since last
 						 * tick */
 	       elapse > MN10300_TSC_PER_HZ
 	       ) {
-		mn10300_last_tsc -= MN10300_TSC_PER_HZ;
+		mn10300_last_tsc += MN10300_TSC_PER_HZ;
 
 		/* advance the kernel's time tracking system */
 		do_timer(1);
@@ -135,6 +130,50 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	return ret;
 }
 
+static struct irqaction timer_irq = {
+	.handler	= timer_interrupt,
+	.flags		= IRQF_DISABLED | IRQF_SHARED | IRQF_TIMER,
+	.name		= "timer",
+};
+#endif /* CONFIG_GENERIC_TIME */
+
+#ifdef CONFIG_CSRC_MN10300
+void __init clocksource_set_clock(struct clocksource *cs, unsigned int clock)
+{
+	u64 temp;
+	u32 shift;
+
+	/* Find a shift value */
+	for (shift = 32; shift > 0; shift--) {
+		temp = (u64) NSEC_PER_SEC << shift;
+		do_div(temp, clock);
+		if ((temp >> 32) == 0)
+			break;
+	}
+	cs->shift = shift;
+	cs->mult = (u32) temp;
+}
+#endif
+
+#if CONFIG_CEVT_MN10300
+void __cpuinit clockevent_set_clock(struct clock_event_device *cd,
+				    unsigned int clock)
+{
+	u64 temp;
+	u32 shift;
+
+	/* Find a shift value */
+	for (shift = 32; shift > 0; shift--) {
+		temp = (u64) clock << shift;
+		do_div(temp, NSEC_PER_SEC);
+		if ((temp >> 32) == 0)
+			break;
+	}
+	cd->shift = shift;
+	cd->mult = (u32) temp;
+}
+#endif
+
 /*
  * initialise the various timers used by the main part of the kernel
  */
@@ -146,21 +185,25 @@ void __init time_init(void)
 	 */
 	TMPSCNT |= TMPSCNT_ENABLE;
 
+#ifdef CONFIG_GENERIC_TIME
+	init_clocksource();
+#else
 	startup_timestamp_counter();
+#endif
 
 	printk(KERN_INFO
 	       "timestamp counter I/O clock running at %lu.%02lu"
 	       " (calibrated against RTC)\n",
 	       MN10300_TSCCLK / 1000000, (MN10300_TSCCLK / 10000) % 100);
 
-	mn10300_last_tsc = TMTSCBC;
+	mn10300_last_tsc = read_timestamp_counter();
 
-	/* use timer 0 & 1 cascaded to tick at as close to HZ as possible */
-	setup_irq(TMJCIRQ, &timer_irq);
-
-	set_intr_level(TMJCIRQ, NUM2GxICR_LEVEL(CONFIG_TIMER_IRQ_LEVEL));
-
-	startup_jiffies_counter();
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	init_clockevents();
+#else
+	reload_jiffies_counter(MN10300_JC_PER_HZ - 1);
+	setup_jiffies_interrupt(TMJCIRQ, &timer_irq, CONFIG_TIMER_IRQ_LEVEL);
+#endif
 
 #ifdef CONFIG_MN10300_WD_TIMER
 	/* start the watchdog timer */
diff --git a/arch/mn10300/unit-asb2303/include/unit/timex.h b/arch/mn10300/unit-asb2303/include/unit/timex.h
index d1b8daf..cc18fe7 100644
--- a/arch/mn10300/unit-asb2303/include/unit/timex.h
+++ b/arch/mn10300/unit-asb2303/include/unit/timex.h
@@ -1,6 +1,6 @@
 /* ASB2303-specific timer specifications
  *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2007, 2010 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -24,10 +24,6 @@
  */
 
 #define	TMJCBR_MAX		0xffff
-#define	TMJCBC			TM01BC
-
-#define	TMJCMD			TM01MD
-#define	TMJCBR			TM01BR
 #define	TMJCIRQ			TM1IRQ
 #define	TMJCICR			TM1ICR
 
@@ -61,34 +57,32 @@
 #define MN10300_JC_PER_HZ	((MN10300_JCCLK + HZ / 2) / HZ)
 #define MN10300_TSC_PER_HZ	((MN10300_TSCCLK + HZ / 2) / HZ)
 
-static inline void startup_jiffies_counter(void)
+static inline void stop_jiffies_counter(void)
 {
-	u16 md, t16;
+	u16 tmp;
+	TM01MD = JC_TIMER_CLKSRC | TM1MD_SRC_TM0CASCADE << 8;
+	tmp = TM01MD;
+}
 
-	md = JC_TIMER_CLKSRC;
-	TMJCBR = MN10300_JC_PER_HZ - 1;
-	t16 = TMJCBR;
+static inline void reload_jiffies_counter(u32 cnt)
+{
+	u32 tmp;
 
-	TMJCMD =
-		md |
-		TM1MD_SRC_TM0CASCADE << 8 |
-		TM0MD_INIT_COUNTER |
-		TM1MD_INIT_COUNTER << 8;
+	TM01BR = cnt;
+	tmp = TM01BR;
 
-	TMJCMD =
-		md |
-		TM1MD_SRC_TM0CASCADE << 8 |
-		TM0MD_COUNT_ENABLE |
-		TM1MD_COUNT_ENABLE << 8;
+	TM01MD = JC_TIMER_CLKSRC |		\
+		 TM1MD_SRC_TM0CASCADE << 8 |	\
+		 TM0MD_INIT_COUNTER |		\
+		 TM1MD_INIT_COUNTER << 8;
 
-	t16 = TMJCMD;
 
-	TMJCICR |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
-	t16 = TMJCICR;
-}
+	TM01MD = JC_TIMER_CLKSRC |		\
+		 TM1MD_SRC_TM0CASCADE << 8 |	\
+		 TM0MD_COUNT_ENABLE |		\
+		 TM1MD_COUNT_ENABLE << 8;
 
-static inline void shutdown_jiffies_counter(void)
-{
+	tmp = TM01MD;
 }
 
 #endif /* !__ASSEMBLY__ */
@@ -148,7 +142,7 @@ typedef unsigned long cycles_t;
 
 static inline cycles_t read_timestamp_counter(void)
 {
-	return (cycles_t)TMTSCBC;
+	return (cycles_t)~TMTSCBC;
 }
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/mn10300/unit-asb2305/include/unit/timex.h b/arch/mn10300/unit-asb2305/include/unit/timex.h
index cd8bc14..758af30 100644
--- a/arch/mn10300/unit-asb2305/include/unit/timex.h
+++ b/arch/mn10300/unit-asb2305/include/unit/timex.h
@@ -1,6 +1,6 @@
 /* ASB2305-specific timer specifications
  *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2007, 2010 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -24,10 +24,6 @@
  */
 
 #define	TMJCBR_MAX		0xffff
-#define	TMJCBC			TM01BC
-
-#define	TMJCMD			TM01MD
-#define	TMJCBR			TM01BR
 #define	TMJCIRQ			TM1IRQ
 #define	TMJCICR			TM1ICR
 
@@ -61,34 +57,32 @@
 #define MN10300_JC_PER_HZ	((MN10300_JCCLK + HZ / 2) / HZ)
 #define MN10300_TSC_PER_HZ	((MN10300_TSCCLK + HZ / 2) / HZ)
 
-static inline void startup_jiffies_counter(void)
+static inline void stop_jiffies_counter(void)
 {
-	u16 md, t16;
+	u16 tmp;
+	TM01MD = JC_TIMER_CLKSRC | TM1MD_SRC_TM0CASCADE << 8;
+	tmp = TM01MD;
+}
 
-	md = JC_TIMER_CLKSRC;
-	TMJCBR = MN10300_JC_PER_HZ - 1;
-	t16 = TMJCBR;
+static inline void reload_jiffies_counter(u32 cnt)
+{
+	u32 tmp;
 
-	TMJCMD =
-		md |
-		TM1MD_SRC_TM0CASCADE << 8 |
-		TM0MD_INIT_COUNTER |
-		TM1MD_INIT_COUNTER << 8;
+	TM01BR = cnt;
+	tmp = TM01BR;
 
-	TMJCMD =
-		md |
-		TM1MD_SRC_TM0CASCADE << 8 |
-		TM0MD_COUNT_ENABLE |
-		TM1MD_COUNT_ENABLE << 8;
+	TM01MD = JC_TIMER_CLKSRC |		\
+		 TM1MD_SRC_TM0CASCADE << 8 |	\
+		 TM0MD_INIT_COUNTER |		\
+		 TM1MD_INIT_COUNTER << 8;
 
-	t16 = TMJCMD;
 
-	TMJCICR |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
-	t16 = TMJCICR;
-}
+	TM01MD = JC_TIMER_CLKSRC |		\
+		 TM1MD_SRC_TM0CASCADE << 8 |	\
+		 TM0MD_COUNT_ENABLE |		\
+		 TM1MD_COUNT_ENABLE << 8;
 
-static inline void shutdown_jiffies_counter(void)
-{
+	tmp = TM01MD;
 }
 
 #endif /* !__ASSEMBLY__ */
@@ -148,7 +142,7 @@ typedef unsigned long cycles_t;
 
 static inline cycles_t read_timestamp_counter(void)
 {
-	return (cycles_t)TMTSCBC;
+	return (cycles_t)~TMTSCBC;
 }
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/mn10300/unit-asb2364/include/unit/timex.h b/arch/mn10300/unit-asb2364/include/unit/timex.h
index b5223f7..ddb7ed0 100644
--- a/arch/mn10300/unit-asb2364/include/unit/timex.h
+++ b/arch/mn10300/unit-asb2364/include/unit/timex.h
@@ -1,6 +1,6 @@
 /* timex.h: MN2WS0038 architecture timer specifications
  *
- * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2002, 2010 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
  * This program is free software; you can redistribute it and/or
@@ -24,12 +24,7 @@
  */
 
 #define	TMJCBR_MAX		0xffffff	/* 24bit */
-#define	TMJCBC			TMTBC
-
-#define	TMJCMD			TMTMD
-#define	TMJCBR			TMTBR
 #define	TMJCIRQ			TMTIRQ
-#define	TMJCICR			TMTICR
 
 #ifndef __ASSEMBLY__
 
@@ -50,25 +45,63 @@
 # error MTM tick timer interval value is overflow.
 #endif
 
+static inline void stop_jiffies_counter(void)
+{
+	u16 tmp;
+	TMTMD = 0;
+	tmp = TMTMD;
+}
 
-static inline void startup_jiffies_counter(void)
+static inline void reload_jiffies_counter(u32 cnt)
 {
-	u32 sync;
+	u32 tmp;
+
+	TMTBR = cnt;
+	tmp = TMTBR;
 
-	TMJCBR = MN10300_JC_PER_HZ - 1;
-	sync = TMJCBR;
+	TMTMD = TMTMD_TMTLDE;
+	TMTMD = TMTMD_TMTCNE;
+	tmp = TMTMD;
+}
 
-	TMJCMD = TMTMD_TMTLDE;
-	TMJCMD = TMTMD_TMTCNE;
-	sync = TMJCMD;
+#if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_CLOCKEVENTS) && \
+    !defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)
+/*
+ * If we aren't using broadcasting, each core needs its own event timer.
+ * Since CPU0 uses the tick timer which is 24-bits, we use timer 4 & 5
+ * cascaded to 32-bits for CPU1 (but only really use 24-bits to match
+ * CPU0).
+ */
 
-	TMJCICR |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
-	sync = TMJCICR;
+#define	TMJC1IRQ		TM5IRQ
+
+static inline void stop_jiffies_counter1(void)
+{
+	u8 tmp;
+	TM4MD = 0;
+	TM5MD = 0;
+	tmp = TM4MD;
+	tmp = TM5MD;
 }
 
-static inline void shutdown_jiffies_counter(void)
+static inline void reload_jiffies_counter1(u32 cnt)
 {
+	u32 tmp;
+
+	TM45BR = cnt;
+	tmp = TM45BR;
+
+	TM4MD = TM4MD_INIT_COUNTER;
+	tmp = TM4MD;
+
+	TM5MD = TM5MD_SRC_TM4CASCADE | TM5MD_INIT_COUNTER;
+	TM5MD = TM5MD_SRC_TM4CASCADE | TM5MD_COUNT_ENABLE;
+	tmp = TM5MD;
+
+	TM4MD = TM4MD_COUNT_ENABLE;
+	tmp = TM4MD;
 }
+#endif /* CONFIG_SMP&GENERIC_CLOCKEVENTS&!GENERIC_CLOCKEVENTS_BROADCAST */
 
 #endif /* !__ASSEMBLY__ */
 
@@ -76,15 +109,16 @@ static inline void shutdown_jiffies_counter(void)
 /*
  * timestamp counter specifications
  */
-
 #define	TMTSCBR_MAX	0xffffffff
+
+#ifndef __ASSEMBLY__
+
+/* Use 32-bit timestamp counter */
 #define	TMTSCMD		TMSMD
 #define	TMTSCBR		TMSBR
 #define	TMTSCBC		TMSBC
 #define	TMTSCICR	TMSICR
 
-#ifndef __ASSEMBLY__
-
 static inline void startup_timestamp_counter(void)
 {
 	u32 sync;
@@ -117,7 +151,7 @@ typedef unsigned long cycles_t;
 
 static inline cycles_t read_timestamp_counter(void)
 {
-	return (cycles_t)TMTSCBC;
+	return (cycles_t)~TMTSCBC;
 }
 
 #endif /* !__ASSEMBLY__ */

