Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab2GEUoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:44:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30173 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2GEUoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:44:15 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=fbjypWlXDeUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=OLL_FvSJAAAA:8 a=1XWaLZrsAAAA:8 a=x30EXVXcAAAA:8 a=7iGzkhDdgw_1gmO4tRwA:9 a=PUjeQqilurYA:10 a=grkgvxmE4kYA:10 a=UTB_XpHje0EA:10 a=2F0HLYTCHDIA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1341521053.21574.22.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH]trace,x86: add x86 irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "vnagarnaik@google.com" <vnagarnaik@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Thu, 05 Jul 2012 16:44:13 -0400
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D401AA07@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AA07@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner is the unofficial (or is it now official?) maintainer of
interrupts. You need his Ack for this change.

-- Steve


On Tue, 2012-07-03 at 22:29 +0000, Seiji Aguchi wrote:
> As Vaibhav explained in the thread below, tracepoints for irq vectors
> is useful.
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
> Vaibhav's patch shared a trace point ,irq_vector_entry/irq_vector_exit, in all events.
> But there is an above use case to trace specific irq_vector rather than tracing all events.
> In this case, we are concerned about overhead due to unwanted events.
> 
> To reduce the overhead, this patch modifies Vaibhav's one to enable each event independently.
> 
>  Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> 
> ---
>  arch/x86/kernel/apic/apic.c              |    7 +
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |    3 +
>  arch/x86/kernel/cpu/mcheck/threshold.c   |    3 +
>  arch/x86/kernel/irq.c                    |    5 +
>  arch/x86/kernel/irq_work.c               |    3 +
>  arch/x86/kernel/nmi.c                    |    3 +
>  arch/x86/kernel/smp.c                    |    7 +
>  arch/x86/mm/tlb.c                        |    3 +
>  include/trace/events/irq_vectors.h       |  288 ++++++++++++++++++++++++++++++
>  9 files changed, 322 insertions(+), 0 deletions(-)
>  create mode 100644 include/trace/events/irq_vectors.h
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 39a222e..db219c9 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -34,6 +34,7 @@
>  #include <linux/dmi.h>
>  #include <linux/smp.h>
>  #include <linux/mm.h>
> +#include <trace/events/irq_vectors.h>
>  
>  #include <asm/irq_remapping.h>
>  #include <asm/perf_event.h>
> @@ -895,7 +896,9 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
>  	 */
>  	irq_enter();
>  	exit_idle();
> +	trace_local_timer_entry(LOCAL_TIMER_VECTOR);
>  	local_apic_timer_interrupt();
> +	trace_local_timer_exit(LOCAL_TIMER_VECTOR);
>  	irq_exit();
>  
>  	set_irq_regs(old_regs);
> @@ -1881,6 +1884,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
>  
>  	irq_enter();
>  	exit_idle();
> +	trace_spurious_apic_entry(SPURIOUS_APIC_VECTOR);
>  	/*
>  	 * Check if this really is a spurious interrupt and ACK it
>  	 * if it is a vectored one.  Just in case...
> @@ -1895,6 +1899,7 @@ void smp_spurious_interrupt(struct pt_regs *regs)
>  	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
>  	pr_info("spurious APIC interrupt on CPU#%d, "
>  		"should never happen.\n", smp_processor_id());
> +	trace_spurious_apic_exit(SPURIOUS_APIC_VECTOR);
>  	irq_exit();
>  }
>  
> @@ -1918,6 +1923,7 @@ void smp_error_interrupt(struct pt_regs *regs)
>  
>  	irq_enter();
>  	exit_idle();
> +	trace_error_apic_entry(ERROR_APIC_VECTOR);
>  	/* First tickle the hardware, only then report what went on. -- REW */
>  	v0 = apic_read(APIC_ESR);
>  	apic_write(APIC_ESR, 0);
> @@ -1938,6 +1944,7 @@ void smp_error_interrupt(struct pt_regs *regs)
>  
>  	apic_printk(APIC_DEBUG, KERN_CONT "\n");
>  
> +	trace_error_apic_exit(ERROR_APIC_VECTOR);
>  	irq_exit();
>  }
>  
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index 47a1870..79cc87a 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -23,6 +23,7 @@
>  #include <linux/init.h>
>  #include <linux/smp.h>
>  #include <linux/cpu.h>
> +#include <trace/events/irq_vectors.h>
>  
>  #include <asm/processor.h>
>  #include <asm/apic.h>
> @@ -382,8 +383,10 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
>  {
>  	irq_enter();
>  	exit_idle();
> +	trace_thermal_apic_entry(THERMAL_APIC_VECTOR);
>  	inc_irq_stat(irq_thermal_count);
>  	smp_thermal_vector();
> +	trace_thermal_apic_exit(THERMAL_APIC_VECTOR);
>  	irq_exit();
>  	/* Ack only at the end to avoid potential reentry */
>  	ack_APIC_irq();
> diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
> index aa578ca..45f33a3 100644
> --- a/arch/x86/kernel/cpu/mcheck/threshold.c
> +++ b/arch/x86/kernel/cpu/mcheck/threshold.c
> @@ -3,6 +3,7 @@
>   */
>  #include <linux/interrupt.h>
>  #include <linux/kernel.h>
> +#include <trace/events/irq_vectors.h>
>  
>  #include <asm/irq_vectors.h>
>  #include <asm/apic.h>
> @@ -21,8 +22,10 @@ asmlinkage void smp_threshold_interrupt(void)
>  {
>  	irq_enter();
>  	exit_idle();
> +	trace_threshold_apic_entry(THRESHOLD_APIC_VECTOR);
>  	inc_irq_stat(irq_threshold_count);
>  	mce_threshold_vector();
> +	trace_threshold_apic_exit(THRESHOLD_APIC_VECTOR);
>  	irq_exit();
>  	/* Ack only at the end to avoid potential reentry */
>  	ack_APIC_irq();
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 3dafc60..e6786a1 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -18,6 +18,9 @@
>  #include <asm/mce.h>
>  #include <asm/hw_irq.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/irq_vectors.h>
> +
>  atomic_t irq_err_count;
>  
>  /* Function pointer for generic interrupt vector handling */
> @@ -218,11 +221,13 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
>  
>  	exit_idle();
>  
> +	trace_x86_platform_ipi_entry(X86_PLATFORM_IPI_VECTOR);
>  	inc_irq_stat(x86_platform_ipis);
>  
>  	if (x86_platform_ipi_callback)
>  		x86_platform_ipi_callback();
>  
> +	trace_x86_platform_ipi_exit(X86_PLATFORM_IPI_VECTOR);
>  	irq_exit();
>  
>  	set_irq_regs(old_regs);
> diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
> index ca8f703..2cf7505 100644
> --- a/arch/x86/kernel/irq_work.c
> +++ b/arch/x86/kernel/irq_work.c
> @@ -8,13 +8,16 @@
>  #include <linux/irq_work.h>
>  #include <linux/hardirq.h>
>  #include <asm/apic.h>
> +#include <trace/events/irq_vectors.h>
>  
>  void smp_irq_work_interrupt(struct pt_regs *regs)
>  {
>  	irq_enter();
>  	ack_APIC_irq();
> +	trace_irq_work_entry(IRQ_WORK_VECTOR);
>  	inc_irq_stat(apic_irq_work_irqs);
>  	irq_work_run();
> +	trace_irq_work_exit(IRQ_WORK_VECTOR);
>  	irq_exit();
>  }
>  
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index a0b2f84..84e8102 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -28,6 +28,7 @@
>  #include <asm/mach_traps.h>
>  #include <asm/nmi.h>
>  #include <asm/x86_init.h>
> +#include <trace/events/irq_vectors.h>
>  
>  struct nmi_desc {
>  	spinlock_t lock;
> @@ -463,12 +464,14 @@ do_nmi(struct pt_regs *regs, long error_code)
>  	nmi_nesting_preprocess(regs);
>  
>  	nmi_enter();
> +	trace_nmi_entry(NMI_VECTOR);
>  
>  	inc_irq_stat(__nmi_count);
>  
>  	if (!ignore_nmis)
>  		default_do_nmi(regs);
>  
> +	trace_nmi_exit(NMI_VECTOR);
>  	nmi_exit();
>  
>  	/* On i386, may loop back to preprocess */
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 48d2b7d..5b2d6de 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -23,6 +23,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/cpu.h>
>  #include <linux/gfp.h>
> +#include <trace/events/irq_vectors.h>
>  
>  #include <asm/mtrr.h>
>  #include <asm/tlbflush.h>
> @@ -252,8 +253,10 @@ finish:
>  void smp_reschedule_interrupt(struct pt_regs *regs)
>  {
>  	ack_APIC_irq();
> +	trace_reschedule_entry(RESCHEDULE_VECTOR);
>  	inc_irq_stat(irq_resched_count);
>  	scheduler_ipi();
> +	trace_reschedule_exit(RESCHEDULE_VECTOR);
>  	/*
>  	 * KVM uses this interrupt to force a cpu out of guest mode
>  	 */
> @@ -263,8 +266,10 @@ void smp_call_function_interrupt(struct pt_regs *regs)
>  {
>  	ack_APIC_irq();
>  	irq_enter();
> +	trace_call_function_entry(CALL_FUNCTION_VECTOR);
>  	generic_smp_call_function_interrupt();
>  	inc_irq_stat(irq_call_count);
> +	trace_call_function_exit(CALL_FUNCTION_VECTOR);
>  	irq_exit();
>  }
>  
> @@ -272,8 +277,10 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
>  {
>  	ack_APIC_irq();
>  	irq_enter();
> +	trace_call_function_single_entry(CALL_FUNCTION_SINGLE_VECTOR);
>  	generic_smp_call_function_single_interrupt();
>  	inc_irq_stat(irq_call_count);
> +	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
>  	irq_exit();
>  }
>  
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index 5e57e11..8a66e91 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -5,6 +5,7 @@
>  #include <linux/smp.h>
>  #include <linux/interrupt.h>
>  #include <linux/module.h>
> +#include <trace/events/irq_vectors.h>
>  #include <linux/cpu.h>
>  
>  #include <asm/tlbflush.h>
> @@ -143,6 +144,7 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
>  	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
>  	f = &flush_state[sender];
>  
> +	trace_invalidate_tlb_entry(INVALIDATE_TLB_VECTOR_START + sender);
>  	if (!cpumask_test_cpu(cpu, to_cpumask(f->flush_cpumask)))
>  		goto out;
>  		/*
> @@ -169,6 +171,7 @@ out:
>  	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
>  	smp_mb__after_clear_bit();
>  	inc_irq_stat(irq_tlb_count);
> +	trace_invalidate_tlb_exit(INVALIDATE_TLB_VECTOR_START + sender);
>  }
>  
>  static void flush_tlb_others_ipi(const struct cpumask *cpumask,
> diff --git a/include/trace/events/irq_vectors.h b/include/trace/events/irq_vectors.h
> new file mode 100644
> index 0000000..4c1cb4e
> --- /dev/null
> +++ b/include/trace/events/irq_vectors.h
> @@ -0,0 +1,288 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM irq_vectors
> +
> +#if !defined(_TRACE_IRQ_VECTORS_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_IRQ_VECTORS_H
> +
> +#include <linux/tracepoint.h>
> +#include <asm/irq.h>
> +
> +DECLARE_EVENT_CLASS(irq_vector,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq),
> +
> +	TP_STRUCT__entry(
> +		__field(	int,	irq	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->irq = irq;
> +	),
> +
> +	TP_printk("irq=%d", __entry->irq)
> +);
> +
> +/*
> + * nmi_entry - called before enterring a nmi vector handler
> + */
> +DEFINE_EVENT(irq_vector, nmi_entry,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * nmi_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DEFINE_EVENT(irq_vector, nmi_exit,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * local_timer_entry - called before enterring a local timer interrupt
> + * vector handler
> + */
> +DEFINE_EVENT(irq_vector, local_timer_entry,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * local_timer_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DEFINE_EVENT(irq_vector, local_timer_exit,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * error_apic_entry - called before enterring an error apic vector handler
> + */
> +DEFINE_EVENT(irq_vector, error_apic_entry,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * error_apic_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DEFINE_EVENT(irq_vector, error_apic_exit,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * reschedule_entry - called before enterring a reschedule vector handler
> + */
> +DEFINE_EVENT(irq_vector, reschedule_entry,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * reschedule_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DEFINE_EVENT(irq_vector, reschedule_exit,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * call_function_entry - called before enterring a call function
> + *			 vector handler
> + */
> +DEFINE_EVENT(irq_vector, call_function_entry,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * call_function_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DEFINE_EVENT(irq_vector, call_function_exit,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * call_function_single_entry - called before enterring a call function
> + * single vector handler
> + */
> +DEFINE_EVENT(irq_vector, call_function_single_entry,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * call_function_single_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DEFINE_EVENT(irq_vector, call_function_single_exit,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * thermal_apic_entry - called before enterring a thermal apic vector handler
> + */
> +DEFINE_EVENT(irq_vector, thermal_apic_entry,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * thermal_apic_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DEFINE_EVENT(irq_vector, thermal_apic_exit,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * threshold_apic_entry - called before enterring a threshold apic
> + * vector handler
> + */
> +DEFINE_EVENT(irq_vector, threshold_apic_entry,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * threshold_apic_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DEFINE_EVENT(irq_vector, threshold_apic_exit,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * spurious_apic_entry - called before enterring a spurious apic vector handler
> + */
> +DEFINE_EVENT(irq_vector, spurious_apic_entry,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * spurious_apic_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DEFINE_EVENT(irq_vector, spurious_apic_exit,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * irq_work_entry - called before enterring an irq work vector handler
> + */
> +DEFINE_EVENT(irq_vector, irq_work_entry,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * irq_work_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DEFINE_EVENT(irq_vector, irq_work_exit,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * x86_platform_ipi_entry - called before enterring a x86 platform ipi
> + * vector handler
> + */
> +DEFINE_EVENT(irq_vector, x86_platform_ipi_entry,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * x86_platform_ipi_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DEFINE_EVENT(irq_vector, x86_platform_ipi_exit,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * invalidate_tlb_entry - called before enterring an invalidate tlb
> + * vector handler
> + */
> +DEFINE_EVENT(irq_vector, invalidate_tlb_entry,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +/*
> + * invalidate_tlb_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DEFINE_EVENT(irq_vector, invalidate_tlb_exit,
> +
> +	TP_PROTO(int irq),
> +
> +	TP_ARGS(irq)
> +);
> +
> +#endif /*  _TRACE_IRQ_VECTORS_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>


