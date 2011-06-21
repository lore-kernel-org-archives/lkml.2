Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab1FUSpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:45:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1662 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab1FUSpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:45:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=D5yImJ97jJW48kp8x0IKasQ8C8Xbr443ofZj+WZV8GfQ5HDe1sc3baxkqRp2paWQT
	5IrZcVsbescZedkP5tpEQ==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiaying Zhang <jiayingz@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH v3] trace: Add x86 irq vector entry/exit tracepoints
Date: Tue, 21 Jun 2011 11:45:03 -0700
Message-Id: <1308681903-12840-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
References: <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiaying Zhang <jiayingz@google.com>

The current interrupt trace of irq_handler_entry and irq_handler_exit
give traces of when an interrupt is handled. They provide good data
about when the system is running in kernel space and how it affects the
currently running applications.

Apart from this, they are IRQ vectors which trigger the system into
kernel space. Tracing such events gives us the trace of where the system
is spending its time. We want to know which cores are handling
interrupts and how they are affecting other processes in the system.
Also, the trace provides information about when the cores are idle and
which interrupts are changing that state.

The following patch adds the event definition and trace instrumentation
for interrupt vectors. A lookup table is provided to print out readable
IRQ vector names. Apart from the IRQ vectors handled in the generic
kernel code, some x86 specific IRQ vectors are also traced. The lookup
table can be extended by adding other arch-specific IRQ vectors.

Changelog:
v2-v3
* Move the irq_vector_{entry|exit} tracepoints back under irq/ sub
  folder
* Trace the common IRQs in generic kernel code so that all archs can
  benefit.

v1-v2
* Move the irq_vector_{entry|exit} tracepoints under irq_vectors/ sub
  folder

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 arch/x86/kernel/apic/apic.c              |    4 ++
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +
 arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +
 arch/x86/kernel/irq.c                    |    4 ++
 arch/x86/kernel/time.c                   |   16 ++++--
 arch/x86/kernel/traps.c                  |    3 +
 arch/x86/mm/tlb.c                        |    2 +
 include/trace/events/irq.h               |   84 ++++++++++++++++++++++++++++++
 kernel/hrtimer.c                         |    6 ++
 kernel/irq_work.c                        |    4 ++
 kernel/sched.c                           |    4 ++
 kernel/smp.c                             |    5 ++
 kernel/time/tick-broadcast.c             |   16 +++++-
 kernel/time/tick-common.c                |    8 +++-
 kernel/time/tick-sched.c                 |    4 ++
 15 files changed, 155 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b9338b8..159851c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1792,6 +1792,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(TRACE_SPURIOUS_APIC_VECTOR);
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
 	 * if it is a vectored one.  Just in case...
@@ -1806,6 +1807,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	pr_info("spurious APIC interrupt on CPU#%d, "
 		"should never happen.\n", smp_processor_id());
+	trace_irq_vector_exit(TRACE_SPURIOUS_APIC_VECTOR);
 	irq_exit();
 }
 
@@ -1829,6 +1831,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(TRACE_ERROR_APIC_VECTOR);
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v0 = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
@@ -1849,6 +1852,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 
 	apic_printk(APIC_DEBUG, KERN_CONT "\n");
 
+	trace_irq_vector_exit(TRACE_ERROR_APIC_VECTOR);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 27c6251..424b818 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -398,8 +398,10 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 {
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(TRACE_THERMAL_APIC_VECTOR);
 	inc_irq_stat(irq_thermal_count);
 	smp_thermal_vector();
+	trace_irq_vector_exit(TRACE_THERMAL_APIC_VECTOR);
 	irq_exit();
 	/* Ack only at the end to avoid potential reentry */
 	ack_APIC_irq();
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index d746df2..f836a0e 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -21,8 +21,10 @@ asmlinkage void smp_threshold_interrupt(void)
 {
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(TRACE_THRESHOLD_APIC_VECTOR);
 	inc_irq_stat(irq_threshold_count);
 	mce_threshold_vector();
+	trace_irq_vector_exit(TRACE_THRESHOLD_APIC_VECTOR);
 	irq_exit();
 	/* Ack only at the end to avoid potential reentry */
 	ack_APIC_irq();
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 6c0802e..3b432c0 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -17,6 +17,8 @@
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
 
+#include <trace/events/irq.h>
+
 atomic_t irq_err_count;
 
 /* Function pointer for generic interrupt vector handling */
@@ -212,11 +214,13 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 
 	irq_enter();
 
+	trace_irq_vector_entry(TRACE_X86_PLATFORM_IPI_VECTOR);
 	inc_irq_stat(x86_platform_ipis);
 
 	if (x86_platform_ipi_callback)
 		x86_platform_ipi_callback();
 
+	trace_irq_vector_exit(TRACE_X86_PLATFORM_IPI_VECTOR);
 	irq_exit();
 
 	set_irq_regs(old_regs);
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 00cbb27..9179dca 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/mca.h>
+#include <trace/events/irq.h>
 
 #include <asm/vsyscall.h>
 #include <asm/x86_init.h>
@@ -51,6 +52,13 @@ unsigned long profile_pc(struct pt_regs *regs)
 }
 EXPORT_SYMBOL(profile_pc);
 
+static irqreturn_t timer_interrupt(int irq, void *dev_id);
+static struct irqaction irq0  = {
+	.handler = timer_interrupt,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
+	.name = "timer"
+};
+
 /*
  * Default timer interrupt handler for PIT/HPET
  */
@@ -59,7 +67,9 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	/* Keep nmi watchdog up to date */
 	inc_irq_stat(irq0_irqs);
 
+	trace_irq_handler_entry(irq, &irq0);
 	global_clock_event->event_handler(global_clock_event);
+	trace_irq_handler_exit(irq, &irq0, 1);
 
 	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */
 	if (MCA_bus)
@@ -68,12 +78,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static struct irqaction irq0  = {
-	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
-	.name = "timer"
-};
-
 void __init setup_default_timer_irq(void)
 {
 	setup_irq(0, &irq0);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b9b6716..481ffce 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -31,6 +31,7 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <trace/events/irq.h>
 
 #ifdef CONFIG_EISA
 #include <linux/ioport.h>
@@ -434,12 +435,14 @@ dotraplinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
+	trace_irq_vector_entry(TRACE_NMI_VECTOR);
 
 	inc_irq_stat(__nmi_count);
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
 
+	trace_irq_vector_exit(TRACE_NMI_VECTOR);
 	nmi_exit();
 }
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index d6c0418..f1a12bc 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -141,6 +141,7 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
 	f = &flush_state[sender];
 
+	trace_irq_vector_entry(TRACE_INVALIDATE_TLB_VECTOR);
 	if (!cpumask_test_cpu(cpu, to_cpumask(f->flush_cpumask)))
 		goto out;
 		/*
@@ -167,6 +168,7 @@ out:
 	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
 	smp_mb__after_clear_bit();
 	inc_irq_stat(irq_tlb_count);
+	trace_irq_vector_exit(TRACE_INVALIDATE_TLB_VECTOR);
 }
 
 static void flush_tlb_others_ipi(const struct cpumask *cpumask,
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 4fc1205..d2f3f1f 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -138,6 +138,90 @@ DEFINE_EVENT(softirq, softirq_raise,
 	TP_ARGS(vec_nr)
 );
 
+#if !defined(_TRACE_IRQ_VECTOR_ENUM)
+#define _TRACE_IRQ_VECTOR_ENUM
+enum {
+	TRACE_NMI_VECTOR,
+	TRACE_NOHZ_TIMER_VECTOR,
+	TRACE_HRTIMER_VECTOR,
+	TRACE_ONESHOT_TIMER_VECTOR,
+	TRACE_PERIODIC_TIMER_BROADCAST_VECTOR,
+	TRACE_PERIODIC_TIMER_VECTOR,
+	TRACE_ERROR_APIC_VECTOR,
+	TRACE_RESCHEDULE_VECTOR,
+	TRACE_CALL_FUNCTION_VECTOR,
+	TRACE_CALL_FUNCTION_SINGLE_VECTOR,
+	TRACE_THERMAL_APIC_VECTOR,
+	TRACE_THRESHOLD_APIC_VECTOR,
+	TRACE_REBOOT_VECTOR,
+	TRACE_SPURIOUS_APIC_VECTOR,
+	TRACE_IRQ_WORK_VECTOR,
+	TRACE_X86_PLATFORM_IPI_VECTOR,
+	TRACE_INVALIDATE_TLB_VECTOR,
+};
+#endif
+
+#define irq_vector_name(sirq) { sirq, #sirq }
+
+#define show_irq_vector_name(val)					\
+	__print_symbolic(val,						\
+			irq_vector_name(TRACE_NMI_VECTOR),		\
+			irq_vector_name(TRACE_NOHZ_TIMER_VECTOR),	\
+			irq_vector_name(TRACE_HRTIMER_VECTOR),		\
+			irq_vector_name(TRACE_ONESHOT_TIMER_VECTOR),	\
+			irq_vector_name(TRACE_PERIODIC_TIMER_BROADCAST_VECTOR),\
+			irq_vector_name(TRACE_PERIODIC_TIMER_VECTOR),	\
+			irq_vector_name(TRACE_ERROR_APIC_VECTOR),	\
+			irq_vector_name(TRACE_RESCHEDULE_VECTOR),	\
+			irq_vector_name(TRACE_CALL_FUNCTION_VECTOR),	\
+			irq_vector_name(TRACE_CALL_FUNCTION_SINGLE_VECTOR),\
+			irq_vector_name(TRACE_THERMAL_APIC_VECTOR),	\
+			irq_vector_name(TRACE_THRESHOLD_APIC_VECTOR),	\
+			irq_vector_name(TRACE_REBOOT_VECTOR),		\
+			irq_vector_name(TRACE_SPURIOUS_APIC_VECTOR),	\
+			irq_vector_name(TRACE_IRQ_WORK_VECTOR),		\
+			irq_vector_name(TRACE_X86_PLATFORM_IPI_VECTOR),	\
+			irq_vector_name(TRACE_INVALIDATE_TLB_VECTOR))
+
+
+DECLARE_EVENT_CLASS(irq_vector,
+
+	TP_PROTO(int irq),
+
+	TP_ARGS(irq),
+
+	TP_STRUCT__entry(
+		__field(	int,	irq	)
+	),
+
+	TP_fast_assign(
+		__entry->irq = irq;
+	),
+
+	TP_printk("name=%s", show_irq_vector_name(__entry->irq))
+);
+
+/*
+ * irq_vector_entry - called before enterring a interrupt vector handler
+ */
+DEFINE_EVENT(irq_vector, irq_vector_entry,
+
+	TP_PROTO(int irq),
+
+	TP_ARGS(irq)
+);
+
+/*
+ * irq_vector_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DEFINE_EVENT(irq_vector, irq_vector_exit,
+
+	TP_PROTO(int irq),
+
+	TP_ARGS(irq)
+);
+
 #endif /*  _TRACE_IRQ_H */
 
 /* This part must be outside protection */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index a9205e3..84a0c70 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -48,6 +48,7 @@
 
 #include <asm/uaccess.h>
 
+#include <trace/events/irq.h>
 #include <trace/events/timer.h>
 
 /*
@@ -1244,6 +1245,8 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	ktime_t expires_next, now, entry_time, delta;
 	int i, retries = 0;
 
+	trace_irq_vector_entry(TRACE_HRTIMER_VECTOR);
+
 	BUG_ON(!cpu_base->hres_active);
 	cpu_base->nr_events++;
 	dev->next_event.tv64 = KTIME_MAX;
@@ -1316,6 +1319,7 @@ retry:
 	if (expires_next.tv64 == KTIME_MAX ||
 	    !tick_program_event(expires_next, 0)) {
 		cpu_base->hang_detected = 0;
+		trace_irq_vector_exit(TRACE_HRTIMER_VECTOR);
 		return;
 	}
 
@@ -1355,6 +1359,8 @@ retry:
 	tick_program_event(expires_next, 1);
 	printk_once(KERN_WARNING "hrtimer: interrupt took %llu ns\n",
 		    ktime_to_ns(delta));
+
+	trace_irq_vector_exit(TRACE_HRTIMER_VECTOR);
 }
 
 /*
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index c58fa7d..8729262 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/irq_work.h>
 #include <linux/hardirq.h>
+#include <trace/events/irq.h>
 
 /*
  * An entry can be in one of four states:
@@ -125,6 +126,8 @@ void irq_work_run(void)
 	if (this_cpu_read(irq_work_list) == NULL)
 		return;
 
+	trace_irq_vector_entry(TRACE_IRQ_WORK_VECTOR);
+
 	BUG_ON(!in_irq());
 	BUG_ON(!irqs_disabled());
 
@@ -149,6 +152,7 @@ void irq_work_run(void)
 			      next_flags(NULL, IRQ_WORK_BUSY),
 			      NULL);
 	}
+	trace_irq_vector_exit(TRACE_IRQ_WORK_VECTOR);
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 3f2e502..3264754 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -80,6 +80,8 @@
 #include "workqueue_sched.h"
 #include "sched_autogroup.h"
 
+#include <trace/events/irq.h>
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
 
@@ -2565,7 +2567,9 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
+	trace_irq_vector_entry(TRACE_RESCHEDULE_VECTOR);
 	sched_ttwu_pending();
+	trace_irq_vector_exit(TRACE_RESCHEDULE_VECTOR);
 }
 
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
diff --git a/kernel/smp.c b/kernel/smp.c
index 73a1951..1a1ce22 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -12,6 +12,7 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <trace/events/irq.h>
 
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 static struct {
@@ -175,6 +176,7 @@ void generic_smp_call_function_interrupt(void)
 	struct call_function_data *data;
 	int cpu = smp_processor_id();
 
+	trace_irq_vector_entry(TRACE_CALL_FUNCTION_VECTOR);
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
 	 */
@@ -243,6 +245,7 @@ void generic_smp_call_function_interrupt(void)
 		csd_unlock(&data->csd);
 	}
 
+	trace_irq_vector_exit(TRACE_CALL_FUNCTION_VECTOR);
 }
 
 /*
@@ -255,6 +258,7 @@ void generic_smp_call_function_single_interrupt(void)
 	unsigned int data_flags;
 	LIST_HEAD(list);
 
+	trace_irq_vector_entry(TRACE_CALL_FUNCTION_SINGLE_VECTOR);
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
 	 */
@@ -285,6 +289,7 @@ void generic_smp_call_function_single_interrupt(void)
 		if (data_flags & CSD_FLAG_LOCK)
 			csd_unlock(data);
 	}
+	trace_irq_vector_exit(TRACE_CALL_FUNCTION_SINGLE_VECTOR);
 }
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_data, csd_data);
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index c7218d1..ee98acb 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>
 
 #include "tick-internal.h"
+#include <trace/events/irq.h>
 
 /*
  * Broadcast support for broken x86 hardware, where the local apic
@@ -176,13 +177,17 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 {
 	ktime_t next;
 
+	trace_irq_vector_entry(TRACE_PERIODIC_TIMER_BROADCAST_VECTOR);
+
 	tick_do_periodic_broadcast();
 
 	/*
 	 * The device is in periodic mode. No reprogramming necessary:
 	 */
-	if (dev->mode == CLOCK_EVT_MODE_PERIODIC)
+	if (dev->mode == CLOCK_EVT_MODE_PERIODIC) {
+		trace_irq_vector_exit(TRACE_PERIODIC_TIMER_BROADCAST_VECTOR);
 		return;
+	}
 
 	/*
 	 * Setup the next period for devices, which do not have
@@ -194,10 +199,13 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 	for (next = dev->next_event; ;) {
 		next = ktime_add(next, tick_period);
 
-		if (!clockevents_program_event(dev, next, ktime_get()))
+		if (!clockevents_program_event(dev, next, ktime_get())) {
+			trace_irq_vector_exit(TRACE_PERIODIC_TIMER_BROADCAST_VECTOR);
 			return;
+		}
 		tick_do_periodic_broadcast();
 	}
+	trace_irq_vector_exit(TRACE_PERIODIC_TIMER_BROADCAST_VECTOR);
 }
 
 /*
@@ -404,6 +412,8 @@ static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 	ktime_t now, next_event;
 	int cpu;
 
+	trace_irq_vector_entry(TRACE_ONESHOT_TIMER_VECTOR);
+
 	raw_spin_lock(&tick_broadcast_lock);
 again:
 	dev->next_event.tv64 = KTIME_MAX;
@@ -443,6 +453,8 @@ again:
 			goto again;
 	}
 	raw_spin_unlock(&tick_broadcast_lock);
+
+	trace_irq_vector_exit(TRACE_ONESHOT_TIMER_VECTOR);
 }
 
 /*
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 119528d..c8cf32d 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <trace/events/irq.h>
 
 #include <asm/irq_regs.h>
 
@@ -84,6 +85,8 @@ void tick_handle_periodic(struct clock_event_device *dev)
 	int cpu = smp_processor_id();
 	ktime_t next;
 
+	trace_irq_vector_entry(TRACE_PERIODIC_TIMER_VECTOR);
+
 	tick_periodic(cpu);
 
 	if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
@@ -94,8 +97,10 @@ void tick_handle_periodic(struct clock_event_device *dev)
 	 */
 	next = ktime_add(dev->next_event, tick_period);
 	for (;;) {
-		if (!clockevents_program_event(dev, next, ktime_get()))
+		if (!clockevents_program_event(dev, next, ktime_get())) {
+			trace_irq_vector_exit(TRACE_PERIODIC_TIMER_VECTOR);
 			return;
+		}
 		/*
 		 * Have to be careful here. If we're in oneshot mode,
 		 * before we call tick_periodic() in a loop, we need
@@ -109,6 +114,7 @@ void tick_handle_periodic(struct clock_event_device *dev)
 			tick_periodic(cpu);
 		next = ktime_add(next, tick_period);
 	}
+	trace_irq_vector_exit(TRACE_PERIODIC_TIMER_VECTOR);
 }
 
 /*
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d5097c4..b3f0070 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -20,6 +20,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <trace/events/irq.h>
 
 #include <asm/irq_regs.h>
 
@@ -568,6 +569,8 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	int cpu = smp_processor_id();
 	ktime_t now = ktime_get();
 
+	trace_irq_vector_entry(TRACE_NOHZ_TIMER_VECTOR);
+
 	dev->next_event.tv64 = KTIME_MAX;
 
 	/*
@@ -604,6 +607,7 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 		now = ktime_get();
 		tick_do_update_jiffies64(now);
 	}
+	trace_irq_vector_exit(TRACE_NOHZ_TIMER_VECTOR);
 }
 
 /**
-- 
1.7.3.1

