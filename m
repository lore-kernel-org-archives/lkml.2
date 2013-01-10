Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab3AJRef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:34:35 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:46769 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3AJRec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:34:32 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: [RFC][PATCH v7 1/2] trace,x86: add x86 irq vector tracepoints
Thread-Topic: [RFC][PATCH v7 1/2] trace,x86: add x86 irq vector tracepoints
Thread-Index: Ac3vWJDhcZSOSqKPQWGxjv6wi2DZAQ==
Date: Thu, 10 Jan 2013 17:33:33 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A3D281@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-01-10_08:2013-01-10,2013-01-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1301100142
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Purpose of this patch]

As Vaibhav explained in the thread below, tracepoints for irq vectors
are useful.

http://www.spinics.net/lists/mm-commits/msg85707.html

<snip>
The current interrupt traces from irq_handler_entry and irq_handler_exit
provide when an interrupt is handled.  They provide good data about when
the system has switched to kernel space and how it affects the currently
running processes.

There are some IRQ vectors which trigger the system into kernel space,
which are not handled in generic IRQ handlers.  Tracing such events gives
us the information about IRQ interaction with other system events.

The trace also tells where the system is spending its time.  We want to
know which cores are handling interrupts and how they are affecting other
processes in the system.  Also, the trace provides information about when
the cores are idle and which interrupts are changing that state.
<snip>

On the other hand, my usecase is tracing just local timer event and 
getting a value of instruction pointer.

I suggested to add an argument local timer event to get instruction pointer before.
But there is another way to get it with external module like systemtap.
So, I don't need to add any argument to irq vector tracepoints now.

[Patch Description]

Vaibhav's patch shared a trace point ,irq_vector_entry/irq_vector_exit, in all events.
But there is an above use case to trace specific irq_vector rather than tracing all events.
In this case, we are concerned about overhead due to unwanted events.

This patch adds following tracepoints instead of introducing irq_vector_entry/exit.
so that we can enable them independently.
   - local_timer_vector
   - reschedule_vector
   - call_function_vector
   - call_function_single_vector 
   - irq_work_entry_vector
   - error_apic_vector
   - thermal_apic_vector
   - threshold_apic_vector
   - spurious_apic_vector
   - x86_platform_ipi_vector

Also, it introduces a logic switching IDT at enabling/disabling time so that a time penalty 
makes a zero when tracepoints are disabled. Detailed explanations are as follows.
 - Create new irq handlers with tracepoints.
 - Create a new IDT, trace_idt_table, at boot time by adding a logic to   
   _set_gate(). It is just a copy of original idt table.
 - Registering the new handers for tracpoints to the new IDT by introducing 
   macros to alloc_intr_gate() called at regstering time of irq_vector handlers.
 - Switch IDT to new one at enabling TP time.
 - Restore to an original IDT at disabling TP time.
The new IDT is created only when CONFIG_TRACING is enabled to avoid being used for other purposes.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/include/asm/desc.h              |   31 ++++++-
 arch/x86/include/asm/entry_arch.h        |    5 +-
 arch/x86/include/asm/hw_irq.h            |   16 +++
 arch/x86/include/asm/trace/irq_vectors.h |  154 ++++++++++++++++++++++++++++++
 arch/x86/kernel/Makefile                 |    1 +
 arch/x86/kernel/apic/apic.c              |   94 ++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   14 +++
 arch/x86/kernel/cpu/mcheck/threshold.c   |   14 +++
 arch/x86/kernel/entry_32.S               |   12 ++-
 arch/x86/kernel/entry_64.S               |   27 ++++-
 arch/x86/kernel/head_64.S                |    6 +
 arch/x86/kernel/irq.c                    |   23 +++++
 arch/x86/kernel/irq_work.c               |   12 +++
 arch/x86/kernel/smp.c                    |   35 +++++++
 arch/x86/kernel/tracepoint.c             |   61 ++++++++++++
 include/xen/events.h                     |    3 +
 16 files changed, 498 insertions(+), 10 deletions(-)
 create mode 100644 arch/x86/include/asm/trace/irq_vectors.h
 create mode 100644 arch/x86/kernel/tracepoint.c

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 8bf1c06..55f2fe5 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -320,6 +320,17 @@ static inline void set_nmi_gate(int gate, void *addr)
 }
 #endif
 
+#ifdef CONFIG_TRACING
+extern gate_desc trace_idt_table[];
+static inline void trace_set_intr_gate(unsigned int gate, void *addr)
+{
+	gate_desc s;
+
+	pack_gate(&s, GATE_INTERRUPT, (unsigned long)addr, 0, 0, __KERNEL_CS);
+	write_idt_entry(trace_idt_table, gate, &s);
+}
+#endif
+
 static inline void _set_gate(int gate, unsigned type, void *addr,
 			     unsigned dpl, unsigned ist, unsigned seg)
 {
@@ -331,6 +342,9 @@ static inline void _set_gate(int gate, unsigned type, void *addr,
 	 * setup time
 	 */
 	write_idt_entry(idt_table, gate, &s);
+#ifdef CONFIG_TRACING
+	write_idt_entry(trace_idt_table, gate, &s);
+#endif
 }
 
 /*
@@ -360,12 +374,25 @@ static inline void alloc_system_vector(int vector)
 	}
 }
 
-static inline void alloc_intr_gate(unsigned int n, void *addr)
+#ifdef CONFIG_TRACING
+static inline void __trace_alloc_intr_gate(unsigned int n, void *addr)
+{
+	trace_set_intr_gate(n, addr);
+}
+#else
+#define __trace_alloc_intr_gate(n, addr)
+#endif
+
+static inline void __alloc_intr_gate(unsigned int n, void *addr)
 {
-	alloc_system_vector(n);
 	set_intr_gate(n, addr);
 }
 
+#define alloc_intr_gate(n, addr) 		\
+	alloc_system_vector(n);			\
+	__alloc_intr_gate(n, addr);		\
+	__trace_alloc_intr_gate(n, trace_##addr);
+
 /*
  * This routine sets up an interrupt gate at directory privilege level 3.
  */
diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 40afa00..0bb99d8 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -13,8 +13,9 @@
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
 BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
-BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
-BUILD_INTERRUPT(reboot_interrupt,REBOOT_VECTOR)
+BUILD_INTERRUPT3(irq_move_cleanup_interrupt, IRQ_MOVE_CLEANUP_VECTOR,
+		 smp_irq_move_cleanup_interrupt)
+BUILD_INTERRUPT3(reboot_interrupt, REBOOT_VECTOR, smp_reboot_interrupt)
 #endif
 
 BUILD_INTERRUPT(x86_platform_ipi, X86_PLATFORM_IPI_VECTOR)
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index eb92a6e..2e297d8 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -76,6 +76,22 @@ extern void threshold_interrupt(void);
 extern void call_function_interrupt(void);
 extern void call_function_single_interrupt(void);
 
+#ifdef CONFIG_TRACING
+/* Interrupt handlers registered during init_IRQ */
+extern void trace_apic_timer_interrupt(void);
+extern void trace_x86_platform_ipi(void);
+extern void trace_error_interrupt(void);
+extern void trace_irq_work_interrupt(void);
+extern void trace_spurious_interrupt(void);
+extern void trace_thermal_interrupt(void);
+extern void trace_reschedule_interrupt(void);
+extern void trace_threshold_interrupt(void);
+extern void trace_call_function_interrupt(void);
+extern void trace_call_function_single_interrupt(void);
+#define trace_irq_move_cleanup_interrupt  irq_move_cleanup_interrupt
+#define trace_reboot_interrupt  reboot_interrupt
+#endif /* CONFIG_TRACING */
+
 /* IOAPIC */
 #define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))
 extern unsigned long io_apic_irqs;
diff --git a/arch/x86/include/asm/trace/irq_vectors.h b/arch/x86/include/asm/trace/irq_vectors.h
new file mode 100644
index 0000000..9bcb27b
--- /dev/null
+++ b/arch/x86/include/asm/trace/irq_vectors.h
@@ -0,0 +1,154 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM irq_vectors
+
+#if !defined(_TRACE_IRQ_VECTORS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IRQ_VECTORS_H
+
+#include <linux/tracepoint.h>
+
+extern void trace_irq_vector_regfunc(void);
+extern void trace_irq_vector_unregfunc(void);
+
+#define DECLARE_IRQ_VECTOR_EVENT(name)				\
+TRACE_EVENT_FN(name,						\
+	TP_PROTO(int vector),					\
+								\
+	TP_ARGS(vector),					\
+								\
+	TP_STRUCT__entry(					\
+		__field(	int,	vector	)		\
+	),							\
+								\
+	TP_fast_assign(						\
+		__entry->vector = vector;			\
+	),							\
+								\
+	TP_printk("vector=%d", __entry->vector),		\
+	trace_irq_vector_regfunc, trace_irq_vector_unregfunc	\
+);
+
+/*
+ * local_timer_entry - called before entering a local timer interrupt
+ * vector handler
+ */
+DECLARE_IRQ_VECTOR_EVENT(local_timer_entry)
+
+/*
+ * local_timer_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DECLARE_IRQ_VECTOR_EVENT(local_timer_exit)
+
+/*
+ * reschedule_entry - called before entering a reschedule vector handler
+ */
+DECLARE_IRQ_VECTOR_EVENT(reschedule_entry)
+
+/*
+ * reschedule_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DECLARE_IRQ_VECTOR_EVENT(reschedule_exit)
+
+/*
+ * spurious_apic_entry - called before entering a spurious apic vector handler
+ */
+DECLARE_IRQ_VECTOR_EVENT(spurious_apic_entry)
+
+/*
+ * spurious_apic_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DECLARE_IRQ_VECTOR_EVENT(spurious_apic_exit)
+
+/*
+ * error_apic_entry - called before entering an error apic vector handler
+ */
+DECLARE_IRQ_VECTOR_EVENT(error_apic_entry)
+
+/*
+ * error_apic_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DECLARE_IRQ_VECTOR_EVENT(error_apic_exit)
+
+/*
+ * x86_platform_ipi_entry - called before entering a x86 platform ipi interrupt
+ * vector handler
+ */
+DECLARE_IRQ_VECTOR_EVENT(x86_platform_ipi_entry)
+
+/*
+ * x86_platform_ipi_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DECLARE_IRQ_VECTOR_EVENT(x86_platform_ipi_exit)
+
+/*
+ * irq_work_entry - called before entering a irq work interrupt
+ * vector handler
+ */
+DECLARE_IRQ_VECTOR_EVENT(irq_work_entry)
+
+/*
+ * irq_work_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DECLARE_IRQ_VECTOR_EVENT(irq_work_exit)
+
+/*
+ * call_function_entry - called before entering a call function interrupt
+ * vector handler
+ */
+DECLARE_IRQ_VECTOR_EVENT(call_function_entry)
+
+/*
+ * call_function_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DECLARE_IRQ_VECTOR_EVENT(call_function_exit)
+
+/*
+ * call_function_single_entry - called before entering a call function
+ * single interrupt vector handler
+ */
+DECLARE_IRQ_VECTOR_EVENT(call_function_single_entry)
+
+/*
+ * call_function_single_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DECLARE_IRQ_VECTOR_EVENT(call_function_single_exit)
+
+/*
+ * threshold_apic_entry - called before entering a threshold apic interrupt
+ * vector handler
+ */
+DECLARE_IRQ_VECTOR_EVENT(threshold_apic_entry)
+
+/*
+ * threshold_apic_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DECLARE_IRQ_VECTOR_EVENT(threshold_apic_exit)
+
+/*
+ * thermal_apic_entry - called before entering a thermal apic interrupt
+ * vector handler
+ */
+DECLARE_IRQ_VECTOR_EVENT(thermal_apic_entry)
+
+/*
+ * thrmal_apic_exit - called immediately after the interrupt vector
+ * handler returns
+ */
+DECLARE_IRQ_VECTOR_EVENT(thermal_apic_exit)
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../arch/x86/include/asm/trace
+#define TRACE_INCLUDE_FILE irq_vectors
+#endif /*  _TRACE_IRQ_VECTORS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 34e923a..24e2080 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_OF)			+= devicetree.o
 obj-$(CONFIG_UPROBES)			+= uprobes.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
+obj-$(CONFIG_TRACING)			+= tracepoint.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b994cc8..89f3f4d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -55,6 +55,9 @@
 #include <asm/tsc.h>
 #include <asm/hypervisor.h>
 
+#define CREATE_TRACE_POINTS
+#include <asm/trace/irq_vectors.h>
+
 unsigned int num_processors;
 
 unsigned disabled_cpus __cpuinitdata;
@@ -934,6 +937,30 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
+void __irq_entry smp_trace_apic_timer_interrupt(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	/*
+	 * NOTE! We'd better ACK the irq immediately,
+	 * because timer handling can be slow.
+	 */
+	ack_APIC_irq();
+	/*
+	 * update_process_times() expects us to have done irq_enter().
+	 * Besides, if we don't timer interrupts ignore the global
+	 * interrupt lock, which is the WrongThing (tm) to do.
+	 */
+	irq_enter();
+	exit_idle();
+	trace_local_timer_entry(LOCAL_TIMER_VECTOR);
+	local_apic_timer_interrupt();
+	trace_local_timer_exit(LOCAL_TIMER_VECTOR);
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
+
 int setup_profiling_timer(unsigned int multiplier)
 {
 	return -EINVAL;
@@ -1931,6 +1958,31 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
+void smp_trace_spurious_interrupt(struct pt_regs *regs)
+{
+	u32 v;
+
+	irq_enter();
+	exit_idle();
+	trace_spurious_apic_entry(SPURIOUS_APIC_VECTOR);
+	/*
+	 * Check if this really is a spurious interrupt and ACK it
+	 * if it is a vectored one.  Just in case...
+	 * Spurious interrupts should not be ACKed.
+	 */
+	v = apic_read(APIC_ISR + ((SPURIOUS_APIC_VECTOR & ~0x1f) >> 1));
+	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
+		ack_APIC_irq();
+
+	inc_irq_stat(irq_spurious_count);
+
+	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
+	pr_info("spurious APIC interrupt on CPU#%d, "
+		"should never happen.\n", smp_processor_id());
+	trace_spurious_apic_exit(SPURIOUS_APIC_VECTOR);
+	irq_exit();
+}
+
 /*
  * This interrupt should never happen with our APIC/SMP architecture
  */
@@ -1974,6 +2026,48 @@ void smp_error_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
+void smp_trace_error_interrupt(struct pt_regs *regs)
+{
+	u32 v0, v1;
+	u32 i = 0;
+	static const char * const error_interrupt_reason[] = {
+		"Send CS error",		/* APIC Error Bit 0 */
+		"Receive CS error",		/* APIC Error Bit 1 */
+		"Send accept error",		/* APIC Error Bit 2 */
+		"Receive accept error",		/* APIC Error Bit 3 */
+		"Redirectable IPI",		/* APIC Error Bit 4 */
+		"Send illegal vector",		/* APIC Error Bit 5 */
+		"Received illegal vector",	/* APIC Error Bit 6 */
+		"Illegal register address",	/* APIC Error Bit 7 */
+	};
+
+	irq_enter();
+	exit_idle();
+	trace_error_apic_entry(ERROR_APIC_VECTOR);
+	/* First tickle the hardware, only then report what went on. -- REW */
+	v0 = apic_read(APIC_ESR);
+	apic_write(APIC_ESR, 0);
+	v1 = apic_read(APIC_ESR);
+	ack_APIC_irq();
+	atomic_inc(&irq_err_count);
+
+	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x(%02x)",
+		    smp_processor_id(), v0 , v1);
+
+	v1 = v1 & 0xff;
+	while (v1) {
+		if (v1 & 0x1)
+			apic_printk(APIC_DEBUG, KERN_CONT " : %s", error_interrupt_reason[i]);
+		i++;
+		v1 >>= 1;
+	}
+
+	apic_printk(APIC_DEBUG, KERN_CONT "\n");
+
+	trace_error_apic_exit(ERROR_APIC_VECTOR);
+	irq_exit();
+}
+
 /**
  * connect_bsp_APIC - attach the APIC to the interrupt system
  */
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 47a1870..e7aa7fc 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -29,6 +29,7 @@
 #include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
+#include <asm/trace/irq_vectors.h>
 
 /* How long to wait between reporting thermal events */
 #define CHECK_INTERVAL		(300 * HZ)
@@ -389,6 +390,19 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 }
 
+asmlinkage void smp_trace_thermal_interrupt(struct pt_regs *regs)
+{
+	irq_enter();
+	exit_idle();
+	trace_thermal_apic_entry(THERMAL_APIC_VECTOR);
+	inc_irq_stat(irq_thermal_count);
+	smp_thermal_vector();
+	trace_thermal_apic_exit(THERMAL_APIC_VECTOR);
+	irq_exit();
+	/* Ack only at the end to avoid potential reentry */
+	ack_APIC_irq();
+}
+
 /* Thermal monitoring depends on APIC, ACPI and clock modulation */
 static int intel_thermal_supported(struct cpuinfo_x86 *c)
 {
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index aa578ca..0cbef99 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -8,6 +8,7 @@
 #include <asm/apic.h>
 #include <asm/idle.h>
 #include <asm/mce.h>
+#include <asm/trace/irq_vectors.h>
 
 static void default_threshold_interrupt(void)
 {
@@ -27,3 +28,16 @@ asmlinkage void smp_threshold_interrupt(void)
 	/* Ack only at the end to avoid potential reentry */
 	ack_APIC_irq();
 }
+
+asmlinkage void smp_trace_threshold_interrupt(void)
+{
+	irq_enter();
+	exit_idle();
+	trace_threshold_apic_entry(THRESHOLD_APIC_VECTOR);
+	inc_irq_stat(irq_threshold_count);
+	mce_threshold_vector();
+	trace_threshold_apic_exit(THRESHOLD_APIC_VECTOR);
+	irq_exit();
+	/* Ack only at the end to avoid potential reentry */
+	ack_APIC_irq();
+}
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index ff84d54..bb52af6 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -846,7 +846,17 @@ ENTRY(name)				\
 	CFI_ENDPROC;			\
 ENDPROC(name)
 
-#define BUILD_INTERRUPT(name, nr)	BUILD_INTERRUPT3(name, nr, smp_##name)
+
+#ifdef CONFIG_TRACING
+#define TRACE_BUILD_INTERRUPT(name, nr)		\
+	BUILD_INTERRUPT3(trace_##name, nr, smp_trace_##name)
+#else
+#define TRACE_BUILD_INTERRUPT(name, nr)
+#endif
+
+#define BUILD_INTERRUPT(name, nr) \
+	BUILD_INTERRUPT3(name, nr, smp_##name); \
+	TRACE_BUILD_INTERRUPT(name, nr)
 
 /* The include is where all of the SMP etc. interrupts come from */
 #include <asm/entry_arch.h>
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 07a7a04..34279ad 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1146,7 +1146,7 @@ END(common_interrupt)
 /*
  * APIC interrupts.
  */
-.macro apicinterrupt num sym do_sym
+.macro apicinterrupt3 num sym do_sym
 ENTRY(\sym)
 	INTR_FRAME
 	ASM_CLAC
@@ -1158,15 +1158,32 @@ ENTRY(\sym)
 END(\sym)
 .endm
 
+#ifdef CONFIG_TRACING
+#define trace(sym) trace_##sym
+#define smp_trace(sym) smp_trace_##sym
+
+.macro trace_apicinterrupt num sym
+apicinterrupt3 \num trace(\sym) smp_trace(\sym)
+.endm
+#else
+.macro trace_apicinterrupt num sym do_sym
+.endm
+#endif
+
+.macro apicinterrupt num sym do_sym
+apicinterrupt3 \num \sym \do_sym
+trace_apicinterrupt \num \sym
+.endm
+
 #ifdef CONFIG_SMP
-apicinterrupt IRQ_MOVE_CLEANUP_VECTOR \
+apicinterrupt3 IRQ_MOVE_CLEANUP_VECTOR \
 	irq_move_cleanup_interrupt smp_irq_move_cleanup_interrupt
-apicinterrupt REBOOT_VECTOR \
+apicinterrupt3 REBOOT_VECTOR \
 	reboot_interrupt smp_reboot_interrupt
 #endif
 
 #ifdef CONFIG_X86_UV
-apicinterrupt UV_BAU_MESSAGE \
+apicinterrupt3 UV_BAU_MESSAGE \
 	uv_bau_message_intr1 uv_bau_message_interrupt
 #endif
 apicinterrupt LOCAL_TIMER_VECTOR \
@@ -1454,7 +1471,7 @@ ENTRY(xen_failsafe_callback)
 	CFI_ENDPROC
 END(xen_failsafe_callback)
 
-apicinterrupt XEN_HVM_EVTCHN_CALLBACK \
+apicinterrupt3 XEN_HVM_EVTCHN_CALLBACK \
 	xen_hvm_callback_vector xen_evtchn_do_upcall
 
 #endif /* CONFIG_XEN */
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 980053c..054213b 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -471,6 +471,12 @@ ENTRY(idt_table)
 ENTRY(nmi_idt_table)
 	.skip IDT_ENTRIES * 16
 
+#ifdef CONFIG_TRACING
+	.align L1_CACHE_BYTES
+ENTRY(trace_idt_table)
+	.skip IDT_ENTRIES * 16
+#endif
+
 	__PAGE_ALIGNED_BSS
 	.align PAGE_SIZE
 ENTRY(empty_zero_page)
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index e4595f1..216bec1 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -17,6 +17,7 @@
 #include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
+#include <asm/trace/irq_vectors.h>
 
 atomic_t irq_err_count;
 
@@ -228,6 +229,28 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
+void smp_trace_x86_platform_ipi(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	ack_APIC_irq();
+
+	irq_enter();
+
+	exit_idle();
+
+	trace_x86_platform_ipi_entry(X86_PLATFORM_IPI_VECTOR);
+	inc_irq_stat(x86_platform_ipis);
+
+	if (x86_platform_ipi_callback)
+		x86_platform_ipi_callback();
+
+	trace_x86_platform_ipi_exit(X86_PLATFORM_IPI_VECTOR);
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
+
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index ca8f703..09e6262 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -8,6 +8,7 @@
 #include <linux/irq_work.h>
 #include <linux/hardirq.h>
 #include <asm/apic.h>
+#include <asm/trace/irq_vectors.h>
 
 void smp_irq_work_interrupt(struct pt_regs *regs)
 {
@@ -18,6 +19,17 @@ void smp_irq_work_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
+void smp_trace_irq_work_interrupt(struct pt_regs *regs)
+{
+	irq_enter();
+	ack_APIC_irq();
+	trace_irq_work_entry(IRQ_WORK_VECTOR);
+	inc_irq_stat(apic_irq_work_irqs);
+	irq_work_run();
+	trace_irq_work_exit(IRQ_WORK_VECTOR);
+	irq_exit();
+}
+
 void arch_irq_work_raise(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 48d2b7d..aad58af 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -30,6 +30,7 @@
 #include <asm/proto.h>
 #include <asm/apic.h>
 #include <asm/nmi.h>
+#include <asm/trace/irq_vectors.h>
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
  *
@@ -259,6 +260,18 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 	 */
 }
 
+void smp_trace_reschedule_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+	trace_reschedule_entry(RESCHEDULE_VECTOR);
+	inc_irq_stat(irq_resched_count);
+	scheduler_ipi();
+	trace_reschedule_exit(RESCHEDULE_VECTOR);
+	/*
+	 * KVM uses this interrupt to force a cpu out of guest mode
+	 */
+}
+
 void smp_call_function_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
@@ -268,6 +281,17 @@ void smp_call_function_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
+void smp_trace_call_function_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+	irq_enter();
+	trace_call_function_entry(CALL_FUNCTION_VECTOR);
+	generic_smp_call_function_interrupt();
+	inc_irq_stat(irq_call_count);
+	trace_call_function_exit(CALL_FUNCTION_VECTOR);
+	irq_exit();
+}
+
 void smp_call_function_single_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
@@ -277,6 +301,17 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
+void smp_trace_call_function_single_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+	irq_enter();
+	trace_call_function_single_entry(CALL_FUNCTION_SINGLE_VECTOR);
+	generic_smp_call_function_single_interrupt();
+	inc_irq_stat(irq_call_count);
+	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
+	irq_exit();
+}
+
 static int __init nonmi_ipi_setup(char *str)
 {
 	smp_no_nmi_ipi = true;
diff --git a/arch/x86/kernel/tracepoint.c b/arch/x86/kernel/tracepoint.c
new file mode 100644
index 0000000..bd5642a
--- /dev/null
+++ b/arch/x86/kernel/tracepoint.c
@@ -0,0 +1,61 @@
+/*
+ * Code for supporting irq vector tracepoints.
+ *
+ * Copyright (C) 2013 Seiji Aguchi <seiji.aguchi@hds.com>
+ *
+ */
+#include <asm/hw_irq.h>
+#include <asm/desc.h>
+
+static struct desc_ptr trace_idt_descr = { NR_VECTORS * 16 - 1,
+				    (unsigned long) trace_idt_table };
+
+#ifndef CONFIG_X86_64
+gate_desc trace_idt_table[NR_VECTORS] __page_aligned_data
+					= { { { { 0, 0 } } }, };
+#endif
+
+static struct desc_ptr orig_idt_descr[NR_CPUS];
+static int trace_irq_vector_refcount;
+
+static void switch_to_trace_idt(void *arg)
+{
+	store_idt(&orig_idt_descr[smp_processor_id()]);
+	load_idt(&trace_idt_descr);
+
+	return;
+}
+
+static void restore_original_idt(void *arg)
+{
+	if (orig_idt_descr[smp_processor_id()].address) {
+		load_idt(&orig_idt_descr[smp_processor_id()]);
+		memset(&orig_idt_descr[smp_processor_id()], 0,
+		       sizeof(struct desc_ptr));
+	}
+
+	return;
+}
+
+void trace_irq_vector_regfunc(void)
+{
+	if (!trace_irq_vector_refcount) {
+		smp_call_function(switch_to_trace_idt, NULL, 0);
+		local_irq_disable();
+		switch_to_trace_idt(NULL);
+		local_irq_enable();
+	}
+	trace_irq_vector_refcount++;
+}
+
+void trace_irq_vector_unregfunc(void)
+{
+	trace_irq_vector_refcount--;
+	if (!trace_irq_vector_refcount) {
+		smp_call_function(restore_original_idt, NULL, 0);
+		local_irq_disable();
+		restore_original_idt(NULL);
+		local_irq_enable();
+	}
+}
+
diff --git a/include/xen/events.h b/include/xen/events.h
index c6bfe01..9216d07 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -76,6 +76,9 @@ unsigned irq_from_evtchn(unsigned int evtchn);
 
 /* Xen HVM evtchn vector callback */
 void xen_hvm_callback_vector(void);
+#ifdef CONFIG_TRACING
+#define trace_xen_hvm_callback_vector xen_hvm_callback_vector
+#endif
 extern int xen_have_vector_callback;
 int xen_set_callback_via(uint64_t via);
 void xen_evtchn_do_upcall(struct pt_regs *regs);
-- 1.7.1
