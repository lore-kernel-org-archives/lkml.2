Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab2JRSlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 14:41:50 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:36519 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2JRSls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 14:41:48 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Borislav Petkov <bp@alien8.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: RE: [RFC][PATCH v5]trace,x86: add x86 irq vector tracepoints
Thread-Topic: [RFC][PATCH v5]trace,x86: add x86 irq vector tracepoints
Thread-Index: Ac2n1PstsBuNZ4qeTLCH+v993BU1BAFiwlVw
Date: Thu, 18 Oct 2012 18:40:42 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41387876E@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-18_02:2012-10-18,2012-10-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1210180220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comment?

Seiji

> -----Original Message-----
> From: Seiji Aguchi
> Sent: Thursday, October 11, 2012 1:25 PM
> To: 'H. Peter Anvin'; 'Steven Rostedt'
> Cc: 'Thomas Gleixner (tglx@linutronix.de)'; 'linux-kernel@vger.kernel.org'; ''mingo@elte.hu' (mingo@elte.hu)'; 'x86@kernel.org'; 'dle-
> develop@lists.sourceforge.net'; Satoru Moriya; 'Borislav Petkov'
> Subject: [RFC][PATCH v5]trace,x86: add x86 irq vector tracepoints
> 
> Change log
> 
>  v4 -> v5
>  - Rebased to 3.6.0
> 
>  - Introduce a logic switching IDT at enabling/disabling TP time
>    so that a time penalty makes a zero when tracepoints are disabled.
>    This IDT is created only when CONFIG_TRACEPOINTS is enabled.
> 
>  - Remove arch_irq_vector_entry/exit and add followings again
>    so that we can add each tracepoint in a generic way.
>    - error_apic_vector
>    - thermal_apic_vector
>    - threshold_apic_vector
>    - spurious_apic_vector
>    - x86_platform_ipi_vector
> 
>  - Drop nmi tracepoints to begin with apic interrupts and discuss a logic switching
>    IDT first.
> 
>  - Move irq_vectors.h in the directory of arch/x86/include/asm/trace because
>    I'm not sure if a logic switching IDT is sharable with other architectures.
> 
>  v3 -> v4
>  - Add a latency measurement of each tracepoint
>  - Rebased to 3.6-rc6
> 
>  v2 -> v3
>  - Remove an invalidate_tlb_vector event because it was replaced by a call function vector
>    in a following commit.
>    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=52aec3308db85f4e9f5c8b9f5dc4fbd0138c6fa4
> 
>  v1 -> v2
>  - Modify variable name from irq to vector.
>  - Merge arch-specific tracepoints below to an arch_irq_vector_entry/exit.
>    - error_apic_vector
>    - thermal_apic_vector
>    - threshold_apic_vector
>    - spurious_apic_vector
>    - x86_platform_ipi_vector
> 
> [Purpose of this patch]
> 
> As Vaibhav explained in the thread below, tracepoints for irq vectors are useful.
> 
> http://www.spinics.net/lists/mm-commits/msg85707.html
> 
> <snip>
> The current interrupt traces from irq_handler_entry and irq_handler_exit provide when an interrupt is handled.  They provide good
> data about when the system has switched to kernel space and how it affects the currently running processes.
> 
> There are some IRQ vectors which trigger the system into kernel space, which are not handled in generic IRQ handlers.  Tracing such
> events gives us the information about IRQ interaction with other system events.
> 
> The trace also tells where the system is spending its time.  We want to know which cores are handling interrupts and how they are
> affecting other processes in the system.  Also, the trace provides information about when the cores are idle and which interrupts are
> changing that state.
> <snip>
> 
> On the other hand, my usecase is tracing just local timer event and getting a value of instruction pointer.
> 
>   I suggested to add an argument local timer event to get instruction pointer before.
>   But there is another way to get it with external module like systemtap.
>   So, I don't need to add any argument to irq vector tracepoints now.
> 
> [Patch Description]
> 
> Vaibhav's patch shared a trace point ,irq_vector_entry/irq_vector_exit, in all events.
> But there is an above use case to trace specific irq_vector rather than tracing all events.
> In this case, we are concerned about overhead due to unwanted events.
> 
> This patch adds following tracepoints instead of introducing irq_vector_entry/exit.
> so that we can enable them independently.
>    - local_timer_vector
>    - reschedule_vector
>    - call_function_vector
>    - call_function_single_vector
>    - irq_work_entry_vector
>    - error_apic_vector
>    - thermal_apic_vector
>    - threshold_apic_vector
>    - spurious_apic_vector
>    - x86_platform_ipi_vector
> 
> Also, it introduces a logic switching IDT at enabling/disabling time so that a time penalty makes a complete zero when tracepoints are
> disabled. Detailed explanations are as follows.
>  - Create new irq handlers inserted tracepoints by using macros.
>  - Create a new IDT, trace_idt_table, at boot time by duplicating original IDT, idt table, and
>    registering the new handers for tracpoints.
>  - Switch IDT to new one at enabling TP time.
>  - Restore to an original IDT at disabling TP time.
> The new IDT is created only when CONFIG_TRACEPOINTS is enabled to avoid being used for other purposes.
> 
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  arch/x86/include/asm/desc.h              |   27 +++++
>  arch/x86/include/asm/entry_arch.h        |   32 +++++
>  arch/x86/include/asm/hw_irq.h            |   14 +++
>  arch/x86/include/asm/trace/irq_vectors.h |  153 ++++++++++++++++++++++++
>  arch/x86/kernel/Makefile                 |    1 +
>  arch/x86/kernel/apic/apic.c              |  186 +++++++++++++++++-------------
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   26 +++--
>  arch/x86/kernel/cpu/mcheck/threshold.c   |   27 +++--
>  arch/x86/kernel/entry_64.S               |   33 ++++++
>  arch/x86/kernel/head_64.S                |    6 +
>  arch/x86/kernel/irq.c                    |   44 ++++---
>  arch/x86/kernel/irq_work.c               |   22 +++-
>  arch/x86/kernel/irqinit.c                |    2 +
>  arch/x86/kernel/smp.c                    |   68 ++++++++----
>  arch/x86/kernel/tracepoint.c             |  102 ++++++++++++++++
>  15 files changed, 600 insertions(+), 143 deletions(-)  create mode 100644 arch/x86/include/asm/trace/irq_vectors.h
>  create mode 100644 arch/x86/kernel/tracepoint.c
> 
> diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h index 8bf1c06..52becf4 100644
> --- a/arch/x86/include/asm/desc.h
> +++ b/arch/x86/include/asm/desc.h
> @@ -345,6 +345,33 @@ static inline void set_intr_gate(unsigned int n, void *addr)
>  	_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS);  }
> 
> +#ifdef CONFIG_TRACEPOINTS
> +extern gate_desc trace_idt_table[];
> +extern void trace_idt_table_init(void); static inline void
> +_trace_set_gate(int gate, unsigned type, void *addr,
> +				   unsigned dpl, unsigned ist, unsigned seg) {
> +	gate_desc s;
> +
> +	pack_gate(&s, type, (unsigned long)addr, dpl, ist, seg);
> +	/*
> +	 * does not need to be atomic because it is only done once at
> +	 * setup time
> +	 */
> +	write_idt_entry(trace_idt_table, gate, &s); }
> +
> +static inline void trace_set_intr_gate(unsigned int n, void *addr) {
> +	BUG_ON((unsigned)n > 0xFF);
> +	_trace_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS); } #else
> +static inline void trace_idt_table_init(void) { } #endif
> +
>  extern int first_system_vector;
>  /* used_vectors is BITMAP for irq is not managed by percpu vector_irq */  extern unsigned long used_vectors[]; diff --git
> a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
> index 40afa00..8ef3900 100644
> --- a/arch/x86/include/asm/entry_arch.h
> +++ b/arch/x86/include/asm/entry_arch.h
> @@ -45,3 +45,35 @@ BUILD_INTERRUPT(threshold_interrupt,THRESHOLD_APIC_VECTOR)
>  #endif
> 
>  #endif
> +
> +#ifdef CONFIG_TRACEPOINTS
> +#ifdef CONFIG_SMP
> +BUILD_INTERRUPT(trace_reschedule_interrupt, RESCHEDULE_VECTOR)
> +BUILD_INTERRUPT(trace_call_function_interrupt, CALL_FUNCTION_VECTOR)
> +BUILD_INTERRUPT(trace_call_function_single_interrupt,
> +		CALL_FUNCTION_SINGLE_VECTOR)
> +#endif
> +
> +BUILD_INTERRUPT(trace_x86_platform_ipi, X86_PLATFORM_IPI_VECTOR)
> +
> +#ifdef CONFIG_X86_LOCAL_APIC
> +
> +BUILD_INTERRUPT(trace_apic_timer_interrupt, LOCAL_TIMER_VECTOR)
> +BUILD_INTERRUPT(trace_error_interrupt, ERROR_APIC_VECTOR)
> +BUILD_INTERRUPT(trace_spurious_interrupt, SPURIOUS_APIC_VECTOR)
> +
> +#ifdef CONFIG_IRQ_WORK
> +BUILD_INTERRUPT(trace_irq_work_interrupt, IRQ_WORK_VECTOR) #endif
> +
> +#ifdef CONFIG_X86_THERMAL_VECTOR
> +BUILD_INTERRUPT(trace_thermal_interrupt, THERMAL_APIC_VECTOR) #endif
> +
> +#ifdef CONFIG_X86_MCE_THRESHOLD
> +BUILD_INTERRUPT(trace_threshold_interrupt, THRESHOLD_APIC_VECTOR)
> +#endif
> +
> +#endif
> +
> +#endif /* CONFIG_TRACEPOINTS */
> diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h index eb92a6e..4472a78 100644
> --- a/arch/x86/include/asm/hw_irq.h
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -76,6 +76,20 @@ extern void threshold_interrupt(void);  extern void call_function_interrupt(void);  extern void
> call_function_single_interrupt(void);
> 
> +#ifdef CONFIG_TRACEPOINTS
> +/* Interrupt handlers registered during init_IRQ */ extern void
> +trace_apic_timer_interrupt(void);
> +extern void trace_x86_platform_ipi(void); extern void
> +trace_error_interrupt(void); extern void
> +trace_irq_work_interrupt(void); extern void
> +trace_spurious_interrupt(void); extern void
> +trace_thermal_interrupt(void); extern void
> +trace_reschedule_interrupt(void);
> +extern void trace_threshold_interrupt(void); extern void
> +trace_call_function_interrupt(void);
> +extern void trace_call_function_single_interrupt(void);
> +#endif /* CONFIG_TRACEPOINTS */
> +
>  /* IOAPIC */
>  #define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))  extern unsigned long io_apic_irqs; diff --git
> a/arch/x86/include/asm/trace/irq_vectors.h b/arch/x86/include/asm/trace/irq_vectors.h
> new file mode 100644
> index 0000000..47858f1
> --- /dev/null
> +++ b/arch/x86/include/asm/trace/irq_vectors.h
> @@ -0,0 +1,153 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM irq_vectors
> +
> +#if !defined(_TRACE_IRQ_VECTORS_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_IRQ_VECTORS_H
> +
> +#include <linux/tracepoint.h>
> +
> +extern void trace_irq_vector_regfunc(void); extern void
> +trace_irq_vector_unregfunc(void);
> +
> +#define DECLARE_IRQ_VECTOR_EVENT(name)				\
> +TRACE_EVENT_FN(name,						\
> +	TP_PROTO(int vector),					\
> +								\
> +	TP_ARGS(vector),					\
> +								\
> +	TP_STRUCT__entry(					\
> +		__field(	int,	vector	)		\
> +	),							\
> +								\
> +	TP_fast_assign(						\
> +		__entry->vector = vector;			\
> +	),							\
> +								\
> +	TP_printk("vector=%d", __entry->vector),		\
> +	trace_irq_vector_regfunc, trace_irq_vector_unregfunc	\
> +);
> +
> +/*
> + * local_timer_entry - called before enterring a local timer interrupt
> + * vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(local_timer_entry)
> +
> +/*
> + * local_timer_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(local_timer_exit)
> +
> +/*
> + * reschedule_entry - called before enterring a reschedule vector
> +handler  */
> +DECLARE_IRQ_VECTOR_EVENT(reschedule_entry)
> +
> +/*
> + * reschedule_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(reschedule_exit)
> +
> +/*
> + * spurious_apic_entry - called before enterring a spurious apic vector
> +handler  */
> +DECLARE_IRQ_VECTOR_EVENT(spurious_apic_entry)
> +
> +/*
> + * spurious_apic_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(spurious_apic_exit)
> +
> +/*
> + * error_apic_entry - called before enterring an error apic vector
> +handler  */
> +DECLARE_IRQ_VECTOR_EVENT(error_apic_entry)
> +
> +/*
> + * error_apic_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(error_apic_exit)
> +
> +/*
> + * x86_platform_ipi_entry - called before enterring a x86 platform ipi
> +interrupt
> + * vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(x86_platform_ipi_entry)
> +
> +/*
> + * x86_platform_ipi_exit - called immediately after the interrupt
> +vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(x86_platform_ipi_exit)
> +
> +/*
> + * irq_work_entry - called before enterring a irq work interrupt
> + * vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(irq_work_entry)
> +
> +/*
> + * irq_work_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(irq_work_exit)
> +
> +/*
> + * call_function_entry - called before enterring a call function
> +interrupt
> + * vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(call_function_entry)
> +
> +/*
> + * call_function_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(call_function_exit)
> +
> +/*
> + * call_function_single_entry - called before enterring a call function
> + * single interrupt vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(call_function_single_entry)
> +
> +/*
> + * call_function_single_exit - called immediately after the interrupt
> +vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(call_function_single_exit)
> +
> +/*
> + * threshold_apic_entry - called before enterring a threshold apic
> +interrupt
> + * vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(threshold_apic_entry)
> +
> +/*
> + * threshold_apic_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(threshold_apic_exit)
> +
> +/*
> + * thermal_apic_entry - called before enterring a thermal apic
> +interrupt
> + * vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(thermal_apic_entry)
> +
> +/*
> + * thrmal_apic_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(thermal_apic_exit)
> +
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH ../../arch/x86/include/asm/trace #define
> +TRACE_INCLUDE_FILE irq_vectors #endif /*  _TRACE_IRQ_VECTORS_H */
> +
> +/* This part must be outside protection */ #include
> +<trace/define_trace.h>
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile index 91ce48f..fe4635d 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -100,6 +100,7 @@ obj-$(CONFIG_OF)			+= devicetree.o
>  obj-$(CONFIG_UPROBES)			+= uprobes.o
> 
>  obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
> +obj-$(CONFIG_TRACEPOINTS)		+= tracepoint.o
> 
>  ###
>  # 64 bit specific files
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c index b17416e..abbee29 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -55,6 +55,9 @@
>  #include <asm/tsc.h>
>  #include <asm/hypervisor.h>
> 
> +#define CREATE_TRACE_POINTS
> +#include <asm/trace/irq_vectors.h>
> +
>  unsigned int num_processors;
> 
>  unsigned disabled_cpus __cpuinitdata;
> @@ -879,27 +882,34 @@ static void local_apic_timer_interrupt(void)
>   * [ if a single-CPU system runs an SMP kernel then we call the local
>   *   interrupt as well. Thus we cannot inline the local irq ... ]
>   */
> -void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs) -{
> -	struct pt_regs *old_regs = set_irq_regs(regs);
> -
> -	/*
> -	 * NOTE! We'd better ACK the irq immediately,
> -	 * because timer handling can be slow.
> -	 */
> -	ack_APIC_irq();
> -	/*
> -	 * update_process_times() expects us to have done irq_enter().
> -	 * Besides, if we don't timer interrupts ignore the global
> -	 * interrupt lock, which is the WrongThing (tm) to do.
> -	 */
> -	irq_enter();
> -	exit_idle();
> -	local_apic_timer_interrupt();
> -	irq_exit();
> -
> -	set_irq_regs(old_regs);
> -}
> +#define SMP_APIC_TIMER_INTERRUPT(trace, trace_enter, trace_exit)	\
> +void __irq_entry smp_##trace##apic_timer_interrupt(struct pt_regs *regs)\
> +{									\
> +	struct pt_regs *old_regs = set_irq_regs(regs);			\
> +									\
> +	/*								\
> +	 * NOTE! We'd better ACK the irq immediately,			\
> +	 * because timer handling can be slow.				\
> +	 */								\
> +	ack_APIC_irq();							\
> +	/*								\
> +	 * update_process_times() expects us to have done irq_enter().	\
> +	 * Besides, if we don't timer interrupts ignore the global	\
> +	 * interrupt lock, which is the WrongThing (tm) to do.		\
> +	 */								\
> +	irq_enter();							\
> +	exit_idle();							\
> +	trace_enter;							\
> +	local_apic_timer_interrupt();					\
> +	trace_exit;							\
> +	irq_exit();							\
> +									\
> +	set_irq_regs(old_regs);						\
> +}
> +
> +SMP_APIC_TIMER_INTERRUPT(,,)
> +SMP_APIC_TIMER_INTERRUPT(trace_, trace_local_timer_entry(LOCAL_TIMER_VECTOR),
> +			 trace_local_timer_exit(LOCAL_TIMER_VECTOR))
> 
>  int setup_profiling_timer(unsigned int multiplier)  { @@ -1875,71 +1885,91 @@ int __init APIC_init_uniprocessor(void)
>  /*
>   * This interrupt should _never_ happen with our APIC/SMP architecture
>   */
> -void smp_spurious_interrupt(struct pt_regs *regs) -{
> -	u32 v;
> -
> -	irq_enter();
> -	exit_idle();
> -	/*
> -	 * Check if this really is a spurious interrupt and ACK it
> -	 * if it is a vectored one.  Just in case...
> -	 * Spurious interrupts should not be ACKed.
> -	 */
> -	v = apic_read(APIC_ISR + ((SPURIOUS_APIC_VECTOR & ~0x1f) >> 1));
> -	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
> -		ack_APIC_irq();
> -
> -	inc_irq_stat(irq_spurious_count);
> -
> -	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
> -	pr_info("spurious APIC interrupt on CPU#%d, "
> -		"should never happen.\n", smp_processor_id());
> -	irq_exit();
> -}
> +#define SMP_SPURIOUS_INTERRUPT(trace, trace_enter, trace_exit)		\
> +void smp_##trace##spurious_interrupt(struct pt_regs *regs)		\
> +{									\
> +	u32 v;								\
> +									\
> +	irq_enter();							\
> +	exit_idle();							\
> +	trace_enter;							\
> +	/*								\
> +	 * Check if this really is a spurious interrupt and ACK it	\
> +	 * if it is a vectored one.  Just in case...			\
> +	 * Spurious interrupts should not be ACKed.			\
> +	 */								\
> +	v = apic_read(APIC_ISR + ((SPURIOUS_APIC_VECTOR & ~0x1f) >> 1));\
> +	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))			\
> +		ack_APIC_irq();						\
> +									\
> +	inc_irq_stat(irq_spurious_count);				\
> +									\
> +	/* see sw-dev-man vol 3, chapter 7.4.13.5 */			\
> +	pr_info("spurious APIC interrupt on CPU#%d, "			\
> +		"should never happen.\n", smp_processor_id());		\
> +	trace_exit;							\
> +	irq_exit();							\
> +}
> +
> +SMP_SPURIOUS_INTERRUPT(,,)
> +SMP_SPURIOUS_INTERRUPT(trace_, trace_spurious_apic_entry(SPURIOUS_APIC_VECTOR),
> +		       trace_spurious_apic_exit(SPURIOUS_APIC_VECTOR))
> 
>  /*
>   * This interrupt should never happen with our APIC/SMP architecture
>   */
> -void smp_error_interrupt(struct pt_regs *regs) -{
> -	u32 v0, v1;
> -	u32 i = 0;
> -	static const char * const error_interrupt_reason[] = {
> -		"Send CS error",		/* APIC Error Bit 0 */
> -		"Receive CS error",		/* APIC Error Bit 1 */
> -		"Send accept error",		/* APIC Error Bit 2 */
> -		"Receive accept error",		/* APIC Error Bit 3 */
> -		"Redirectable IPI",		/* APIC Error Bit 4 */
> -		"Send illegal vector",		/* APIC Error Bit 5 */
> -		"Received illegal vector",	/* APIC Error Bit 6 */
> -		"Illegal register address",	/* APIC Error Bit 7 */
> -	};
> -
> -	irq_enter();
> -	exit_idle();
> -	/* First tickle the hardware, only then report what went on. -- REW */
> -	v0 = apic_read(APIC_ESR);
> -	apic_write(APIC_ESR, 0);
> -	v1 = apic_read(APIC_ESR);
> -	ack_APIC_irq();
> -	atomic_inc(&irq_err_count);
> -
> -	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x(%02x)",
> -		    smp_processor_id(), v0 , v1);
> -
> -	v1 = v1 & 0xff;
> -	while (v1) {
> -		if (v1 & 0x1)
> -			apic_printk(APIC_DEBUG, KERN_CONT " : %s", error_interrupt_reason[i]);
> -		i++;
> -		v1 >>= 1;
> -	}
> -
> -	apic_printk(APIC_DEBUG, KERN_CONT "\n");
> -
> -	irq_exit();
> -}
> +#define SMP_ERROR_INTERRUPT(trace, trace_enter, trace_exit)		\
> +void smp_##trace##error_interrupt(struct pt_regs *regs)		\
> +{									\
> +	u32 v0, v1;							\
> +	u32 i = 0;							\
> +	static const char * const error_interrupt_reason[] = {		\
> +		"Send CS error",		/* APIC Error Bit 0 */	\
> +		"Receive CS error",		/* APIC Error Bit 1 */	\
> +		"Send accept error",		/* APIC Error Bit 2 */	\
> +		"Receive accept error",		/* APIC Error Bit 3 */	\
> +		"Redirectable IPI",		/* APIC Error Bit 4 */	\
> +		"Send illegal vector",		/* APIC Error Bit 5 */	\
> +		"Received illegal vector",	/* APIC Error Bit 6 */	\
> +		"Illegal register address",	/* APIC Error Bit 7 */	\
> +	};								\
> +									\
> +	irq_enter();							\
> +	exit_idle();							\
> +	trace_enter;							\
> +	/*								\
> +	 * First tickle the hardware, only then report what went on.	\
> +	 * -- REW							\
> +	 */								\
> +	v0 = apic_read(APIC_ESR);					\
> +	apic_write(APIC_ESR, 0);					\
> +	v1 = apic_read(APIC_ESR);					\
> +	ack_APIC_irq();							\
> +	atomic_inc(&irq_err_count);					\
> +									\
> +	apic_printk(APIC_DEBUG,						\
> +		    KERN_DEBUG "APIC error on CPU%d: %02x(%02x)",	\
> +		    smp_processor_id(), v0 , v1);			\
> +									\
> +	v1 = v1 & 0xff;							\
> +	while (v1) {							\
> +		if (v1 & 0x1)						\
> +			apic_printk(APIC_DEBUG, KERN_CONT " : %s",	\
> +				    error_interrupt_reason[i]);		\
> +		i++;							\
> +		v1 >>= 1;						\
> +	}								\
> +									\
> +	apic_printk(APIC_DEBUG, KERN_CONT "\n");			\
> +									\
> +	trace_exit;							\
> +	irq_exit();							\
> +}
> +
> +
> +SMP_ERROR_INTERRUPT(,,)
> +SMP_ERROR_INTERRUPT(trace_, trace_error_apic_entry(ERROR_APIC_VECTOR),
> +		    trace_error_apic_exit(ERROR_APIC_VECTOR))
> 
>  /**
>   * connect_bsp_APIC - attach the APIC to the interrupt system diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index 47a1870..a1c86ab 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -23,6 +23,7 @@
>  #include <linux/init.h>
>  #include <linux/smp.h>
>  #include <linux/cpu.h>
> +#include <asm/trace/irq_vectors.h>
> 
>  #include <asm/processor.h>
>  #include <asm/apic.h>
> @@ -378,17 +379,24 @@ static void unexpected_thermal_interrupt(void)
> 
>  static void (*smp_thermal_vector)(void) = unexpected_thermal_interrupt;
> 
> -asmlinkage void smp_thermal_interrupt(struct pt_regs *regs) -{
> -	irq_enter();
> -	exit_idle();
> -	inc_irq_stat(irq_thermal_count);
> -	smp_thermal_vector();
> -	irq_exit();
> -	/* Ack only at the end to avoid potential reentry */
> -	ack_APIC_irq();
> +#define SMP_THERMAL_INTERRUPT(trace, trace_enter, trace_exit)		\
> +asmlinkage void smp_##trace##thermal_interrupt(struct pt_regs *regs)	\
> +{									\
> +	irq_enter();							\
> +	exit_idle();							\
> +	trace_enter;							\
> +	inc_irq_stat(irq_thermal_count);				\
> +	smp_thermal_vector();						\
> +	trace_exit;							\
> +	irq_exit();							\
> +	/* Ack only at the end to avoid potential reentry */		\
> +	ack_APIC_irq();							\
>  }
> 
> +SMP_THERMAL_INTERRUPT(,,)
> +SMP_THERMAL_INTERRUPT(trace_, trace_thermal_apic_entry(THERMAL_APIC_VECTOR),
> +		      trace_thermal_apic_exit(THERMAL_APIC_VECTOR))
> +
>  /* Thermal monitoring depends on APIC, ACPI and clock modulation */  static int intel_thermal_supported(struct cpuinfo_x86 *c)
> { diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
> index aa578ca..b7a95c5 100644
> --- a/arch/x86/kernel/cpu/mcheck/threshold.c
> +++ b/arch/x86/kernel/cpu/mcheck/threshold.c
> @@ -4,6 +4,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/kernel.h>
> 
> +#include <asm/trace/irq_vectors.h>
>  #include <asm/irq_vectors.h>
>  #include <asm/apic.h>
>  #include <asm/idle.h>
> @@ -17,13 +18,21 @@ static void default_threshold_interrupt(void)
> 
>  void (*mce_threshold_vector)(void) = default_threshold_interrupt;
> 
> -asmlinkage void smp_threshold_interrupt(void) -{
> -	irq_enter();
> -	exit_idle();
> -	inc_irq_stat(irq_threshold_count);
> -	mce_threshold_vector();
> -	irq_exit();
> -	/* Ack only at the end to avoid potential reentry */
> -	ack_APIC_irq();
> +#define SMP_THRESHOLD_INTERRUPT(trace, trace_enter, trace_exit)	\
> +asmlinkage void smp_##trace##threshold_interrupt(void)			\
> +{									\
> +	irq_enter();							\
> +	exit_idle();							\
> +	trace_enter;							\
> +	inc_irq_stat(irq_threshold_count);				\
> +	mce_threshold_vector();						\
> +	trace_exit;							\
> +	irq_exit();							\
> +	/* Ack only at the end to avoid potential reentry */		\
> +	ack_APIC_irq();							\
>  }
> +
> +SMP_THRESHOLD_INTERRUPT(,,)
> +SMP_THRESHOLD_INTERRUPT(trace_,
> +			trace_threshold_apic_entry(THRESHOLD_APIC_VECTOR),
> +			trace_threshold_apic_exit(THRESHOLD_APIC_VECTOR))
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S index cdc790c..20faa26 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1187,6 +1187,39 @@ apicinterrupt IRQ_WORK_VECTOR \
>  	irq_work_interrupt smp_irq_work_interrupt  #endif
> 
> +#ifdef CONFIG_TRACEPOINTS
> +
> +apicinterrupt LOCAL_TIMER_VECTOR \
> +	trace_apic_timer_interrupt smp_trace_apic_timer_interrupt
> +apicinterrupt X86_PLATFORM_IPI_VECTOR \
> +	trace_x86_platform_ipi smp_trace_x86_platform_ipi
> +
> +apicinterrupt THRESHOLD_APIC_VECTOR \
> +	trace_threshold_interrupt smp_trace_threshold_interrupt apicinterrupt
> +THERMAL_APIC_VECTOR \
> +	trace_thermal_interrupt smp_trace_thermal_interrupt
> +
> +#ifdef CONFIG_SMP
> +apicinterrupt CALL_FUNCTION_SINGLE_VECTOR \
> +	trace_call_function_single_interrupt \
> +	smp_trace_call_function_single_interrupt
> +apicinterrupt CALL_FUNCTION_VECTOR \
> +	trace_call_function_interrupt smp_trace_call_function_interrupt
> +apicinterrupt RESCHEDULE_VECTOR \
> +	trace_reschedule_interrupt smp_trace_reschedule_interrupt #endif
> +
> +apicinterrupt ERROR_APIC_VECTOR \
> +	trace_error_interrupt smp_trace_error_interrupt apicinterrupt
> +SPURIOUS_APIC_VECTOR \
> +	trace_spurious_interrupt smp_trace_spurious_interrupt
> +
> +#ifdef CONFIG_IRQ_WORK
> +apicinterrupt IRQ_WORK_VECTOR \
> +	trace_irq_work_interrupt smp_trace_irq_work_interrupt #endif #endif /*
> +CONFIG_TRACEPOINTS */
> +
>  /*
>   * Exception entry points.
>   */
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S index 94bf9cc..cc32708 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -455,6 +455,12 @@ ENTRY(idt_table)
>  ENTRY(nmi_idt_table)
>  	.skip IDT_ENTRIES * 16
> 
> +#ifdef CONFIG_TRACEPOINTS
> +	.align L1_CACHE_BYTES
> +ENTRY(trace_idt_table)
> +	.skip IDT_ENTRIES * 16
> +#endif
> +
>  	__PAGE_ALIGNED_BSS
>  	.align PAGE_SIZE
>  ENTRY(empty_zero_page)
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c index e4595f1..9fd70ad 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -18,6 +18,8 @@
>  #include <asm/mce.h>
>  #include <asm/hw_irq.h>
> 
> +#include <asm/trace/irq_vectors.h>
> +
>  atomic_t irq_err_count;
> 
>  /* Function pointer for generic interrupt vector handling */ @@ -208,26 +210,32 @@ unsigned int __irq_entry do_IRQ(struct pt_regs
> *regs)
>  /*
>   * Handler for X86_PLATFORM_IPI_VECTOR.
>   */
> -void smp_x86_platform_ipi(struct pt_regs *regs) -{
> -	struct pt_regs *old_regs = set_irq_regs(regs);
> -
> -	ack_APIC_irq();
> -
> -	irq_enter();
> -
> -	exit_idle();
> -
> -	inc_irq_stat(x86_platform_ipis);
> -
> -	if (x86_platform_ipi_callback)
> -		x86_platform_ipi_callback();
> -
> -	irq_exit();
> -
> -	set_irq_regs(old_regs);
> +#define SMP_X86_PLATFORM_IPI(trace, trace_enter, trace_exit)		\
> +void smp_##trace##x86_platform_ipi(struct pt_regs *regs)		\
> +{									\
> +	struct pt_regs *old_regs = set_irq_regs(regs);			\
> +									\
> +	ack_APIC_irq();							\
> +									\
> +	irq_enter();							\
> +									\
> +	exit_idle();							\
> +	trace_enter;							\
> +	inc_irq_stat(x86_platform_ipis);				\
> +									\
> +	if (x86_platform_ipi_callback)					\
> +		x86_platform_ipi_callback();				\
> +	trace_exit;							\
> +	irq_exit();							\
> +									\
> +	set_irq_regs(old_regs);						\
>  }
> 
> +SMP_X86_PLATFORM_IPI(,,)
> +SMP_X86_PLATFORM_IPI(trace_,
> +		     trace_x86_platform_ipi_entry(X86_PLATFORM_IPI_VECTOR),
> +		     trace_x86_platform_ipi_exit(X86_PLATFORM_IPI_VECTOR))
> +
>  EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
> 
>  #ifdef CONFIG_HOTPLUG_CPU
> diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c index ca8f703..a669b94 100644
> --- a/arch/x86/kernel/irq_work.c
> +++ b/arch/x86/kernel/irq_work.c
> @@ -8,16 +8,24 @@
>  #include <linux/irq_work.h>
>  #include <linux/hardirq.h>
>  #include <asm/apic.h>
> +#include <asm/trace/irq_vectors.h>
> 
> -void smp_irq_work_interrupt(struct pt_regs *regs) -{
> -	irq_enter();
> -	ack_APIC_irq();
> -	inc_irq_stat(apic_irq_work_irqs);
> -	irq_work_run();
> -	irq_exit();
> +#define SMP_IRQ_WORK_INTERRUPT(trace, trace_enter, trace_exit)		\
> +void smp_##trace##irq_work_interrupt(struct pt_regs *regs)		\
> +{									\
> +	irq_enter();							\
> +	ack_APIC_irq();							\
> +	trace_enter;							\
> +	inc_irq_stat(apic_irq_work_irqs);				\
> +	irq_work_run();							\
> +	trace_exit;							\
> +	irq_exit();							\
>  }
> 
> +SMP_IRQ_WORK_INTERRUPT(,,)
> +SMP_IRQ_WORK_INTERRUPT(trace_, trace_irq_work_entry(IRQ_WORK_VECTOR),
> +		       trace_irq_work_exit(IRQ_WORK_VECTOR))
> +
>  void arch_irq_work_raise(void)
>  {
>  #ifdef CONFIG_X86_LOCAL_APIC
> diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c index 6e03b0d..cf76128 100644
> --- a/arch/x86/kernel/irqinit.c
> +++ b/arch/x86/kernel/irqinit.c
> @@ -251,4 +251,6 @@ void __init native_init_IRQ(void)
> 
>  	irq_ctx_init(smp_processor_id());
>  #endif
> +
> +	trace_idt_table_init();
>  }
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c index 48d2b7d..d8e1a2c 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -23,6 +23,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/cpu.h>
>  #include <linux/gfp.h>
> +#include <asm/trace/irq_vectors.h>
> 
>  #include <asm/mtrr.h>
>  #include <asm/tlbflush.h>
> @@ -249,34 +250,57 @@ finish:
>  /*
>   * Reschedule call back.
>   */
> -void smp_reschedule_interrupt(struct pt_regs *regs) -{
> -	ack_APIC_irq();
> -	inc_irq_stat(irq_resched_count);
> -	scheduler_ipi();
> -	/*
> -	 * KVM uses this interrupt to force a cpu out of guest mode
> -	 */
> +#define SMP_RESCHEDULE_INTERRUPT(trace, trace_enter, trace_exit)	\
> +void smp_##trace##reschedule_interrupt(struct pt_regs *regs)		\
> +{									\
> +	ack_APIC_irq();							\
> +	trace_enter;							\
> +	inc_irq_stat(irq_resched_count);				\
> +	scheduler_ipi();						\
> +	trace_exit;							\
> +	/*								\
> +	 * KVM uses this interrupt to force a cpu out of guest mode	\
> +	 */								\
>  }
> 
> -void smp_call_function_interrupt(struct pt_regs *regs) -{
> -	ack_APIC_irq();
> -	irq_enter();
> -	generic_smp_call_function_interrupt();
> -	inc_irq_stat(irq_call_count);
> -	irq_exit();
> +SMP_RESCHEDULE_INTERRUPT(,,)
> +SMP_RESCHEDULE_INTERRUPT(trace_, trace_reschedule_entry(RESCHEDULE_VECTOR),
> +			 trace_reschedule_exit(RESCHEDULE_VECTOR))
> +
> +#define SMP_CALL_FUNCTION_INTERRUPT(trace, trace_enter, trace_exit)	\
> +void smp_##trace##call_function_interrupt(struct pt_regs *regs)	\
> +{									\
> +	ack_APIC_irq();							\
> +	irq_enter();							\
> +	trace_enter;							\
> +	generic_smp_call_function_interrupt();				\
> +	inc_irq_stat(irq_call_count);					\
> +	trace_exit;							\
> +	irq_exit();							\
>  }
> 
> -void smp_call_function_single_interrupt(struct pt_regs *regs) -{
> -	ack_APIC_irq();
> -	irq_enter();
> -	generic_smp_call_function_single_interrupt();
> -	inc_irq_stat(irq_call_count);
> -	irq_exit();
> +SMP_CALL_FUNCTION_INTERRUPT(,,)
> +SMP_CALL_FUNCTION_INTERRUPT(trace_,
> +			    trace_call_function_entry(CALL_FUNCTION_VECTOR),
> +			    trace_call_function_exit(CALL_FUNCTION_VECTOR))
> +
> +#define SMP_CALL_FUNCTION_SINGLE_INTERRUPT(trace, trace_enter, trace_exit)\
> +void smp_##trace##call_function_single_interrupt(struct pt_regs *regs)	\
> +{									\
> +	ack_APIC_irq();							\
> +	irq_enter();							\
> +	trace_enter;							\
> +	generic_smp_call_function_single_interrupt();			\
> +	inc_irq_stat(irq_call_count);					\
> +	trace_exit;							\
> +	irq_exit();							\
>  }
> 
> +SMP_CALL_FUNCTION_SINGLE_INTERRUPT(,,)
> +SMP_CALL_FUNCTION_SINGLE_INTERRUPT(trace_,
> +		trace_call_function_single_entry(CALL_FUNCTION_SINGLE_VECTOR),
> +		trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR))
> +
>  static int __init nonmi_ipi_setup(char *str)  {
>  	smp_no_nmi_ipi = true;
> diff --git a/arch/x86/kernel/tracepoint.c b/arch/x86/kernel/tracepoint.c new file mode 100644 index 0000000..d7c96ba
> --- /dev/null
> +++ b/arch/x86/kernel/tracepoint.c
> @@ -0,0 +1,102 @@
> +/*
> + * Code for supporting irq vector tracepoints.
> + *
> + * Copyright (C) 2012 Seiji Aguchi <seiji.aguchi@hds.com>
> + *
> + */
> +#include <asm/hw_irq.h>
> +#include <asm/desc.h>
> +
> +static struct desc_ptr trace_idt_descr = { NR_VECTORS * 16 - 1,
> +				    (unsigned long) trace_idt_table };
> +
> +#ifndef CONFIG_X86_64
> +gate_desc trace_idt_table[NR_VECTORS] __page_aligned_data
> +					= { { { { 0, 0 } } }, };
> +#endif
> +
> +void __init trace_idt_table_init(void)
> +{
> +	memcpy(&trace_idt_table, &idt_table, IDT_ENTRIES * 16);
> +	/*
> +	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
> +	 * IPI, driven by wakeup.
> +	 */
> +	trace_set_intr_gate(RESCHEDULE_VECTOR, trace_reschedule_interrupt);
> +
> +	/* IPI for generic function call */
> +	trace_set_intr_gate(CALL_FUNCTION_VECTOR,
> +			    trace_call_function_interrupt);
> +
> +	/* IPI for generic single function call */
> +	trace_set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
> +			    trace_call_function_single_interrupt);
> +
> +#ifdef CONFIG_X86_THERMAL_VECTOR
> +	trace_set_intr_gate(THERMAL_APIC_VECTOR, trace_thermal_interrupt);
> +#endif #ifdef CONFIG_X86_MCE_THRESHOLD
> +	trace_set_intr_gate(THRESHOLD_APIC_VECTOR, trace_threshold_interrupt);
> +#endif
> +
> +#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
> +	/* self generated IPI for local APIC timer */
> +	trace_set_intr_gate(LOCAL_TIMER_VECTOR, trace_apic_timer_interrupt);
> +
> +	/* IPI for X86 platform specific use */
> +	trace_set_intr_gate(X86_PLATFORM_IPI_VECTOR, trace_x86_platform_ipi);
> +
> +	/* IPI vectors for APIC spurious and error interrupts */
> +	trace_set_intr_gate(SPURIOUS_APIC_VECTOR, trace_spurious_interrupt);
> +	trace_set_intr_gate(ERROR_APIC_VECTOR, trace_error_interrupt);
> +
> +	/* IRQ work interrupts: */
> +# ifdef CONFIG_IRQ_WORK
> +	trace_set_intr_gate(IRQ_WORK_VECTOR, trace_irq_work_interrupt); #
> +endif # endif }
> +
> +static struct desc_ptr orig_idt_descr[NR_CPUS]; static int
> +trace_irq_vector_refcount;
> +
> +static void switch_trace_idt(void *arg) {
> +	store_idt(&orig_idt_descr[smp_processor_id()]);
> +	load_idt(&trace_idt_descr);
> +
> +	return;
> +}
> +
> +static void restore_original_idt(void *arg) {
> +	if (orig_idt_descr[smp_processor_id()].address) {
> +		load_idt(&orig_idt_descr[smp_processor_id()]);
> +		memset(&orig_idt_descr[smp_processor_id()], 0,
> +		       sizeof(struct desc_ptr));
> +	}
> +
> +	return;
> +}
> +
> +void trace_irq_vector_regfunc(void)
> +{
> +	if (!trace_irq_vector_refcount) {
> +		smp_call_function(switch_trace_idt, NULL, 0);
> +		local_irq_disable();
> +		switch_trace_idt(NULL);
> +		local_irq_enable();
> +	}
> +	trace_irq_vector_refcount++;
> +}
> +
> +void trace_irq_vector_unregfunc(void)
> +{
> +	trace_irq_vector_refcount--;
> +	if (!trace_irq_vector_refcount) {
> +		smp_call_function(restore_original_idt, NULL, 0);
> +		local_irq_disable();
> +		restore_original_idt(NULL);
> +		local_irq_enable();
> +	}
> +}
> -- 1.7.1
