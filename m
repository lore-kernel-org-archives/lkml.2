Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2LRDCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 22:02:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30782 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2LRDCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 22:02:08 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=GLRmZoJD3R4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=vw99MyFtH44A:10 a=VwQbUJbxAAAA:8 a=OLL_FvSJAAAA:8 a=x30EXVXcAAAA:8 a=5Zo96OWjAAAA:8 a=prPTQNYRwlErbEp_Ht8A:9 a=PUjeQqilurYA:10 a=grkgvxmE4kYA:10 a=2F0HLYTCHDIA:10 a=h-jcIxwTa-YA:10 a=BVmAJrJB01qYKUzs:21 a=jKByb56QSi8pRbTY:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355799724.17101.428.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH v6]trace,x86: add x86 irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Date: Mon, 17 Dec 2012 22:02:04 -0500
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A23300@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A23300@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 01:34 +0000, Seiji Aguchi wrote:
> Change log 
> 
>  v5 -> v6
>  - Rebased to 3.7
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
> As Vaibhav explained in the thread below, tracepoints for irq vectors
> are useful.
> 
> http://www.spinics.net/lists/mm-commits/msg85707.html
> 
> <snip>
> The current interrupt traces from irq_handler_entry and irq_handler_exit
> provide when an interrupt is handled.  They provide good data about when
> the system has switched to kernel space and how it affects the currently
> running processes.
> 
> There are some IRQ vectors which trigger the system into kernel space,
> which are not handled in generic IRQ handlers.  Tracing such events gives
> us the information about IRQ interaction with other system events.
> 
> The trace also tells where the system is spending its time.  We want to
> know which cores are handling interrupts and how they are affecting other
> processes in the system.  Also, the trace provides information about when
> the cores are idle and which interrupts are changing that state.
> <snip>
> 
> On the other hand, my usecase is tracing just local timer event and 
> getting a value of instruction pointer.
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
> Also, it introduces a logic switching IDT at enabling/disabling time so that a time penalty makes 
> a complete zero when tracepoints are disabled. Detailed explanations are as follows.
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
>  13 files changed, 345 insertions(+), 143 deletions(-)
> 
> diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
> index 8bf1c06..52becf4 100644
> --- a/arch/x86/include/asm/desc.h
> +++ b/arch/x86/include/asm/desc.h
> @@ -345,6 +345,33 @@ static inline void set_intr_gate(unsigned int n, void *addr)
>  	_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS);
>  }
>  
> +#ifdef CONFIG_TRACEPOINTS
> +extern gate_desc trace_idt_table[];
> +extern void trace_idt_table_init(void);
> +static inline void _trace_set_gate(int gate, unsigned type, void *addr,
> +				   unsigned dpl, unsigned ist, unsigned seg)
> +{
> +	gate_desc s;
> +
> +	pack_gate(&s, type, (unsigned long)addr, dpl, ist, seg);
> +	/*
> +	 * does not need to be atomic because it is only done once at
> +	 * setup time
> +	 */
> +	write_idt_entry(trace_idt_table, gate, &s);
> +}
> +
> +static inline void trace_set_intr_gate(unsigned int n, void *addr)
> +{
> +	BUG_ON((unsigned)n > 0xFF);
> +	_trace_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS);
> +}
> +#else
> +static inline void trace_idt_table_init(void)
> +{
> +}
> +#endif
> +
>  extern int first_system_vector;
>  /* used_vectors is BITMAP for irq is not managed by percpu vector_irq */
>  extern unsigned long used_vectors[];
> diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
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
> +BUILD_INTERRUPT(trace_irq_work_interrupt, IRQ_WORK_VECTOR)
> +#endif
> +
> +#ifdef CONFIG_X86_THERMAL_VECTOR
> +BUILD_INTERRUPT(trace_thermal_interrupt, THERMAL_APIC_VECTOR)
> +#endif
> +
> +#ifdef CONFIG_X86_MCE_THRESHOLD
> +BUILD_INTERRUPT(trace_threshold_interrupt, THRESHOLD_APIC_VECTOR)
> +#endif
> +
> +#endif

Um, you could save all the above duplication if you just did:

in arch/x86/kernel/entry_32.S

#ifdef CONFIG_TRACING
#define BUILD_TRACE_INTERRUPT(name, nr) \
	BUILD_INTERRUPT3(trace_##name, nr, smp_trace_##name)
#else
#define BUILD_TRACE_INTERRUPT(name, nr)
#endif

#define BUILD_INTERRUPT(name, nr) \
	BUILD_INTERRUPT3(name, nr, smp_##name) \
	BUILD_TRACE_INTERRUPT(name, nr)

#include <asm/entry_arch.h>


> +
> +#endif /* CONFIG_TRACEPOINTS */
> diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
> index eb92a6e..4472a78 100644
> --- a/arch/x86/include/asm/hw_irq.h
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -76,6 +76,20 @@ extern void threshold_interrupt(void);
>  extern void call_function_interrupt(void);
>  extern void call_function_single_interrupt(void);
>  
> +#ifdef CONFIG_TRACEPOINTS
> +/* Interrupt handlers registered during init_IRQ */
> +extern void trace_apic_timer_interrupt(void);
> +extern void trace_x86_platform_ipi(void);
> +extern void trace_error_interrupt(void);
> +extern void trace_irq_work_interrupt(void);
> +extern void trace_spurious_interrupt(void);
> +extern void trace_thermal_interrupt(void);
> +extern void trace_reschedule_interrupt(void);
> +extern void trace_threshold_interrupt(void);
> +extern void trace_call_function_interrupt(void);
> +extern void trace_call_function_single_interrupt(void);
> +#endif /* CONFIG_TRACEPOINTS */
> +
>  /* IOAPIC */
>  #define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))
>  extern unsigned long io_apic_irqs;
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 34e923a..33504ea 100644
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
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index b994cc8..20c4b1f 100644
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
> @@ -912,27 +915,34 @@ static void local_apic_timer_interrupt(void)
>   * [ if a single-CPU system runs an SMP kernel then we call the local
>   *   interrupt as well. Thus we cannot inline the local irq ... ]
>   */
> -void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
> -{
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


These macros are just plan ugly as all hell. What about using static
inlines and something like:

static inline void entering_irq(void)
{
	irq_enter();
	exit_idle();
}

static inline void exiting_irq(void)
{
	irq_exit();
}

-- Just duplicate the two apic timer interrupts because it has the
needed ack first.


Then the rest could be:

static inline void __smp_spurious_interrupt(struct pt_regs *regs)
{
	u32 v;


	/*
	 * Check if this really is a spurious interrupt and ACK it
	 * if it is a vectored one.  Just in case...
	 * Spurious interrupts should not be ACKed.
	 */
	v = apic_read(APIC_ISR + ((SPURIOUS_APIC_VECTOR & ~0x1f) >> 1));
	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
		ack_APIC_irq();

	inc_irq_stat(irq_spurious_count);

	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
	pr_info("spurious APIC interrupt on CPU#%d, "
		"should never happen.\n", smp_processor_id());

}

void smp_spurious_interrupt(struct pt_regs *regs)
{
	entering_irq();
	__smp_spurious_interrupt(regs);
	exiting_irq();
}

void smp_trace_spurious_interrupt(struct pt_regs *regs)
{
	entering_irq();
	trace_spurious_apic_enter(SPURIOUS_APIC_VECTOR);
	__smp_spurious_interrupt(regs);
	trace_spurious_apic_exit(SPURIOUS_APIC_VECTOR);
	exiting_irq();
}

This is so much more readable (and maintainable) than using those ugly
macros.

-- Steve

>  
>  int setup_profiling_timer(unsigned int multiplier)
>  {
> @@ -1908,71 +1918,91 @@ int __init APIC_init_uniprocessor(void)
>  /*
>   * This interrupt should _never_ happen with our APIC/SMP architecture
>   */
> -void smp_spurious_interrupt(struct pt_regs *regs)
> -{
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
> -void smp_error_interrupt(struct pt_regs *regs)
> -{
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


