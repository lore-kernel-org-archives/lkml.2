Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792Ab1D2UQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:16:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6787 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933777Ab1D2UQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:16:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=dC7b0HonDevlrD2KeieZSKtTMrVoxqsgko1i/vslfVCIRHJ+UDZQvBFJqnpVU3+mk
	zqjSLotUx85EscNom98BQ==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiaying Zhang <jiayingz@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH] trace: Add x86 irq vector entry/exit tracepoints
Date: Fri, 29 Apr 2011 13:12:42 -0700
Message-Id: <1304107962-18576-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303774907-13099-1-git-send-email-vnagarnaik@google.com>
References: <1303774907-13099-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiaying Zhang <jiayingz@google.com>

The current interrupt trace of irq_handler_entry and irq_handler_exit
give traces of when an interrupt is handled. They provide good data
about when the system is running in kernel space and how it affects the
currently running applications.

Apart from these, they are IRQ vectors which trigger the system into
kernel space. Tracing such events gives us the trace of where the system
is spending its time. We want to know which cores are handling
interrupts and how they are affecting other processes in the system.
Also, the trace provides information about when the cores are idle and
which interrupts are changing the state.

The following patch adds the event definition and trace instrumentation
for interrupt vectors. For x86, a lookup table is provided to print out
readable IRQ vector names. The template can be used to provide interrupt
vector lookup tables on other architectures.

With this patch, following interrupt vectors are logged by ftrace
(when enabled):

Interrupt as in /proc/interrupts        Name as it appears in ftrace log
NMI: Non-maskable interrupts           : NMI_VECTOR
LOC: Local timer interrupts            : LOCAL_TIMER_VECTOR
SPU: Spurious interrupts               : SPURIOUS_APIC_VECTOR
PMI: Performance monitoring interrupts : <not added>
IWI: IRQ work interrupts               : IRQ_WORK_VECTOR
RES: Rescheduling interrupts           : RESCHEDULE_VECTOR
CAL: Function call interrupts          : CALL_FUNCTION_VECTOR or
                                         CALL_FUNCTION_SINGLE_VECTOR
TLB: TLB shootdowns                    : INVALIDATE_TLB_VECTOR_START to
                                         INVALIDATE_TLB_VECTOR_END
TRM: Thermal event interrupts          : THERMAL_APIC_VECTOR
THR: Threshold APIC interrupts         : THRESHOLD_APIC_VECTOR
MCE: Machine check exceptions          : <not added>
MCP: Machine check polls               : <not added>
ERR:                                   : ERROR_APIC_VECTOR
MIS:                                   : <not added>
PLT: Platform interrupts               : X86_PLATFORM_IPI_VECTOR

$ sh ~/ftrace_test.sh
tracing...
  cpu0: overrun: 0
  cpu1: overrun: 0
  cpu2: overrun: 0
  cpu3: overrun: 0
IRQ ftrace record counts (ignoring numeric  irq=(0|1|4|5|7|9|10|24) )
      2 irq=242 name=INVALIDATE_TLB_VECTOR_2
      3 irq=252 name=CALL_FUNCTION_VECTOR
      6 irq=241 name=INVALIDATE_TLB_VECTOR_1
      6 irq=2 name=NMI_VECTOR
     22 irq=240 name=INVALIDATE_TLB_VECTOR_0
     40 irq=251 name=CALL_FUNCTION_SINGLE_VECTOR
    587 irq=253 name=RESCHEDULE_VECTOR
  15013 irq=239 name=LOCAL_TIMER_VECTOR
/proc/interrupts stats difference
      6 NMI (Non-maskable interrupts)
  14945 LOC (Local timer interrupts)
      6 PMI (Performance monitoring interrupts)
    578 RES (Rescheduling interrupts)
     42 CAL (Function call interrupts)
     30 TLB (TLB shootdowns)
      4 MCP (Machine check polls)

In above output:
NMI (Non-maskable interrupts) == NMI_VECTOR (irq 2)
LOC (Local timer interrupts) == LOCAL_TIMER_VECTOR (irq 239)
RES (Rescheduling interrupts) == RESCHEDULE_VECTOR (irq=253)
CAL (Function call interrupts) == CALL_FUNCTION_VECTOR (irq 252) +
                                  CALL_FUNCTION_SINGLE_VECTOR (irq 251)
TLB (TLB shootdowns) == INVALIDATE_TLB_VECTOR_0 (irq=240) +
                        INVALIDATE_TLB_VECTOR_1 (irq=241) +
                        INVALIDATE_TLB_VECTOR_2 (irq=242)

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 arch/x86/include/asm/irq_vectors.h       |   50 ++++++++++++++++++++++++++++++
 arch/x86/kernel/apic/apic.c              |    7 ++++
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    3 ++
 arch/x86/kernel/cpu/mcheck/threshold.c   |    3 ++
 arch/x86/kernel/irq.c                    |    4 ++-
 arch/x86/kernel/irq_work.c               |    4 ++
 arch/x86/kernel/smp.c                    |    7 ++++
 arch/x86/kernel/time.c                   |   16 ++++++---
 arch/x86/kernel/traps.c                  |    3 ++
 arch/x86/mm/tlb.c                        |    3 ++
 include/trace/events/irq.h               |   45 +++++++++++++++++++++++++++
 11 files changed, 138 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 6e976ee..81b83ae 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -182,4 +182,54 @@ static inline int invalid_vm86_irq(int irq)
 # define NR_IRQS			NR_IRQS_LEGACY
 #endif
 
+#define irq_vector_name(sirq) { sirq, #sirq }
+#define invalidate_tlb_vector_name(i) { INVALIDATE_TLB_VECTOR_END-31+i, \
+					"INVALIDATE_TLB_VECTOR" }
+
+#define irq_vector_name_table						\
+			 irq_vector_name(NMI_VECTOR),			\
+			 irq_vector_name(LOCAL_TIMER_VECTOR),		\
+			 irq_vector_name(ERROR_APIC_VECTOR),		\
+			 irq_vector_name(RESCHEDULE_VECTOR),		\
+			 irq_vector_name(CALL_FUNCTION_VECTOR),		\
+			 irq_vector_name(CALL_FUNCTION_SINGLE_VECTOR),	\
+			 irq_vector_name(THERMAL_APIC_VECTOR),		\
+			 irq_vector_name(THRESHOLD_APIC_VECTOR),	\
+			 irq_vector_name(REBOOT_VECTOR),		\
+			 irq_vector_name(SPURIOUS_APIC_VECTOR),		\
+			 irq_vector_name(IRQ_WORK_VECTOR),		\
+			 irq_vector_name(X86_PLATFORM_IPI_VECTOR),	\
+			 invalidate_tlb_vector_name(0),			\
+			 invalidate_tlb_vector_name(1),			\
+			 invalidate_tlb_vector_name(2),			\
+			 invalidate_tlb_vector_name(3),			\
+			 invalidate_tlb_vector_name(4),			\
+			 invalidate_tlb_vector_name(5),			\
+			 invalidate_tlb_vector_name(6),			\
+			 invalidate_tlb_vector_name(7),			\
+			 invalidate_tlb_vector_name(8),			\
+			 invalidate_tlb_vector_name(9),			\
+			 invalidate_tlb_vector_name(10),		\
+			 invalidate_tlb_vector_name(11),		\
+			 invalidate_tlb_vector_name(12),		\
+			 invalidate_tlb_vector_name(13),		\
+			 invalidate_tlb_vector_name(14),		\
+			 invalidate_tlb_vector_name(15),		\
+			 invalidate_tlb_vector_name(16),		\
+			 invalidate_tlb_vector_name(17),		\
+			 invalidate_tlb_vector_name(18),		\
+			 invalidate_tlb_vector_name(19),		\
+			 invalidate_tlb_vector_name(20),		\
+			 invalidate_tlb_vector_name(21),		\
+			 invalidate_tlb_vector_name(22),		\
+			 invalidate_tlb_vector_name(23),		\
+			 invalidate_tlb_vector_name(24),		\
+			 invalidate_tlb_vector_name(25),		\
+			 invalidate_tlb_vector_name(26),		\
+			 invalidate_tlb_vector_name(27),		\
+			 invalidate_tlb_vector_name(28),		\
+			 invalidate_tlb_vector_name(29),		\
+			 invalidate_tlb_vector_name(30),		\
+			 invalidate_tlb_vector_name(31)
+
 #endif /* _ASM_X86_IRQ_VECTORS_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index fabf01e..473bcab 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -33,6 +33,7 @@
 #include <linux/dmi.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <trace/events/irq.h>
 
 #include <asm/perf_event.h>
 #include <asm/x86_init.h>
@@ -857,7 +858,9 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 	 */
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(LOCAL_TIMER_VECTOR);
 	local_apic_timer_interrupt();
+	trace_irq_vector_exit(LOCAL_TIMER_VECTOR);
 	irq_exit();
 
 	set_irq_regs(old_regs);
@@ -1790,6 +1793,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(SPURIOUS_APIC_VECTOR);
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
 	 * if it is a vectored one.  Just in case...
@@ -1804,6 +1808,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	pr_info("spurious APIC interrupt on CPU#%d, "
 		"should never happen.\n", smp_processor_id());
+	trace_irq_vector_exit(SPURIOUS_APIC_VECTOR);
 	irq_exit();
 }
 
@@ -1816,6 +1821,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(ERROR_APIC_VECTOR);
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
@@ -1836,6 +1842,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 	 */
 	pr_debug("APIC error on CPU%d: %02x(%02x)\n",
 		smp_processor_id(), v , v1);
+	trace_irq_vector_exit(ERROR_APIC_VECTOR);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 6f8c5e9..e2d5afb 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <trace/events/irq.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -402,8 +403,10 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 {
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(THERMAL_APIC_VECTOR);
 	inc_irq_stat(irq_thermal_count);
 	smp_thermal_vector();
+	trace_irq_vector_exit(THERMAL_APIC_VECTOR);
 	irq_exit();
 	/* Ack only at the end to avoid potential reentry */
 	ack_APIC_irq();
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index d746df2..0a3655d 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -3,6 +3,7 @@
  */
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <trace/events/irq.h>
 
 #include <asm/irq_vectors.h>
 #include <asm/apic.h>
@@ -21,8 +22,10 @@ asmlinkage void smp_threshold_interrupt(void)
 {
 	exit_idle();
 	irq_enter();
+	trace_irq_vector_entry(THRESHOLD_APIC_VECTOR);
 	inc_irq_stat(irq_threshold_count);
 	mce_threshold_vector();
+	trace_irq_vector_exit(THRESHOLD_APIC_VECTOR);
 	irq_exit();
 	/* Ack only at the end to avoid potential reentry */
 	ack_APIC_irq();
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 1cb0b9f..2b53049 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -8,6 +8,7 @@
 #include <linux/seq_file.h>
 #include <linux/smp.h>
 #include <linux/ftrace.h>
+#include <trace/events/irq.h>
 #include <linux/delay.h>
 
 #include <asm/apic.h>
@@ -211,12 +212,13 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 	exit_idle();
 
 	irq_enter();
-
+	trace_irq_vector_entry(X86_PLATFORM_IPI_VECTOR);
 	inc_irq_stat(x86_platform_ipis);
 
 	if (x86_platform_ipi_callback)
 		x86_platform_ipi_callback();
 
+	trace_irq_vector_exit(X86_PLATFORM_IPI_VECTOR);
 	irq_exit();
 
 	set_irq_regs(old_regs);
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index ca8f703..a07e9f8 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -8,13 +8,17 @@
 #include <linux/irq_work.h>
 #include <linux/hardirq.h>
 #include <asm/apic.h>
+#include <asm/irq_vectors.h>
+#include <trace/events/irq.h>
 
 void smp_irq_work_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
 	ack_APIC_irq();
+	trace_irq_vector_entry(IRQ_WORK_VECTOR);
 	inc_irq_stat(apic_irq_work_irqs);
 	irq_work_run();
+	trace_irq_vector_exit(IRQ_WORK_VECTOR);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 513deac..b5c193f 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/gfp.h>
+#include <trace/events/irq.h>
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
@@ -201,7 +202,9 @@ static void native_stop_other_cpus(int wait)
 void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
+	trace_irq_vector_entry(RESCHEDULE_VECTOR);
 	inc_irq_stat(irq_resched_count);
+	trace_irq_vector_exit(RESCHEDULE_VECTOR);
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
@@ -211,8 +214,10 @@ void smp_call_function_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	irq_enter();
+	trace_irq_vector_entry(CALL_FUNCTION_VECTOR);
 	generic_smp_call_function_interrupt();
 	inc_irq_stat(irq_call_count);
+	trace_irq_vector_exit(CALL_FUNCTION_VECTOR);
 	irq_exit();
 }
 
@@ -220,8 +225,10 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	irq_enter();
+	trace_irq_vector_entry(CALL_FUNCTION_SINGLE_VECTOR);
 	generic_smp_call_function_single_interrupt();
 	inc_irq_stat(irq_call_count);
+	trace_irq_vector_exit(CALL_FUNCTION_SINGLE_VECTOR);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 25a28a2..5195302 100644
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
 
+	trace_irq_handler_entry(0, &irq0);
 	global_clock_event->event_handler(global_clock_event);
+	trace_irq_handler_exit(0, &irq0, 1);
 
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
index b9b6716..fbfc162 100644
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
+	trace_irq_vector_entry(NMI_VECTOR);
 
 	inc_irq_stat(__nmi_count);
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
 
+	trace_irq_vector_exit(NMI_VECTOR);
 	nmi_exit();
 }
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index d6c0418..b45ad76 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -5,6 +5,7 @@
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <trace/events/irq.h>
 #include <linux/cpu.h>
 
 #include <asm/tlbflush.h>
@@ -141,6 +142,7 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
 	f = &flush_state[sender];
 
+	trace_irq_vector_entry(INVALIDATE_TLB_VECTOR_START + sender);
 	if (!cpumask_test_cpu(cpu, to_cpumask(f->flush_cpumask)))
 		goto out;
 		/*
@@ -167,6 +169,7 @@ out:
 	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
 	smp_mb__after_clear_bit();
 	inc_irq_stat(irq_tlb_count);
+	trace_irq_vector_exit(INVALIDATE_TLB_VECTOR_START + sender);
 }
 
 static void flush_tlb_others_ipi(const struct cpumask *cpumask,
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 4b4c7d9..b70383e 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -139,6 +139,51 @@ DEFINE_EVENT(softirq, softirq_raise,
 	TP_ARGS(vec_nr)
 );
 
+#include <asm/irq_vectors.h>
+
+#ifndef irq_vector_name_table
+#define irq_vector_name_table { -1, NULL }
+#endif
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
+	TP_printk("irq=%d name=%s", __entry->irq,
+		__print_symbolic(__entry->irq, irq_vector_name_table))
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
-- 
1.7.3.1

