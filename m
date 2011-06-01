Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab1FAAAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 20:00:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38938 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab1FAAAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 20:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZB9k58VSCfpM9Q72u/+eTgUvTbZyxGfqPaA1+l+pUXS3hgQZIBzI+J5Y0Hfr6X1KXo
         RnUxk0Yxc5xypUSHAwoQgWxtBGy3VAdvMjSu6JfbyzbnEuEOLDJsP+cSD1Mu06aVtk76
         ciELHeRx+QGQ9ISbHil5ua3b6it0Ms/cP8jkQ=
Date: Wed, 1 Jun 2011 02:00:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v2] trace: Add x86 irq vector entry/exit tracepoints
Message-ID: <20110531235957.GB5256@somewhere.redhat.com>
References: <1304107962-18576-1-git-send-email-vnagarnaik@google.com>
 <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 02:28:18PM -0700, Vaibhav Nagarnaik wrote:
> From: Jiaying Zhang <jiayingz@google.com>
> 
> The current interrupt trace of irq_handler_entry and irq_handler_exit
> give traces of when an interrupt is handled. They provide good data
> about when the system is running in kernel space and how it affects the
> currently running applications.
> 
> Apart from this, they are IRQ vectors which trigger the system into
> kernel space. Tracing such events gives us the trace of where the system
> is spending its time. We want to know which cores are handling
> interrupts and how they are affecting other processes in the system.
> Also, the trace provides information about when the cores are idle and
> which interrupts are changing that state.
> 
> The following patch adds the event definition and trace instrumentation
> for interrupt vectors. For x86, a lookup table is provided to print out
> readable IRQ vector names. The template can be used to provide interrupt
> vector lookup tables on other architectures.
> 
> With this patch, following interrupt vectors are logged by ftrace
> (when enabled):
> 
> Interrupt as in /proc/interrupts        Name as it appears in ftrace log
> NMI: Non-maskable interrupts           : NMI_VECTOR
> LOC: Local timer interrupts            : LOCAL_TIMER_VECTOR
> SPU: Spurious interrupts               : SPURIOUS_APIC_VECTOR
> PMI: Performance monitoring interrupts : <not added>
> IWI: IRQ work interrupts               : IRQ_WORK_VECTOR
> RES: Rescheduling interrupts           : RESCHEDULE_VECTOR
> CAL: Function call interrupts          : CALL_FUNCTION_VECTOR or
>                                          CALL_FUNCTION_SINGLE_VECTOR
> TLB: TLB shootdowns                    : INVALIDATE_TLB_VECTOR_START to
>                                          INVALIDATE_TLB_VECTOR_END
> TRM: Thermal event interrupts          : THERMAL_APIC_VECTOR
> THR: Threshold APIC interrupts         : THRESHOLD_APIC_VECTOR
> MCE: Machine check exceptions          : <not added>
> MCP: Machine check polls               : <not added>
> ERR:                                   : ERROR_APIC_VECTOR
> MIS:                                   : <not added>
> PLT: Platform interrupts               : X86_PLATFORM_IPI_VECTOR
> 
> $ sh ~/ftrace_test.sh
> tracing...
>   cpu0: overrun: 0
>   cpu1: overrun: 0
>   cpu2: overrun: 0
>   cpu3: overrun: 0
> IRQ ftrace record counts (ignoring numeric  irq=(0|1|4|5|7|9|10|24) )
>       2 irq=242 name=INVALIDATE_TLB_VECTOR_2
>       3 irq=252 name=CALL_FUNCTION_VECTOR
>       6 irq=241 name=INVALIDATE_TLB_VECTOR_1
>       6 irq=2 name=NMI_VECTOR
>      22 irq=240 name=INVALIDATE_TLB_VECTOR_0
>      40 irq=251 name=CALL_FUNCTION_SINGLE_VECTOR
>     587 irq=253 name=RESCHEDULE_VECTOR
>   15013 irq=239 name=LOCAL_TIMER_VECTOR
> /proc/interrupts stats difference
>       6 NMI (Non-maskable interrupts)
>   14945 LOC (Local timer interrupts)
>       6 PMI (Performance monitoring interrupts)
>     578 RES (Rescheduling interrupts)
>      42 CAL (Function call interrupts)
>      30 TLB (TLB shootdowns)
>       4 MCP (Machine check polls)
> 
> In above output:
> NMI (Non-maskable interrupts) == NMI_VECTOR (irq 2)
> LOC (Local timer interrupts) == LOCAL_TIMER_VECTOR (irq 239)
> RES (Rescheduling interrupts) == RESCHEDULE_VECTOR (irq=253)
> CAL (Function call interrupts) == CALL_FUNCTION_VECTOR (irq 252) +
>                                   CALL_FUNCTION_SINGLE_VECTOR (irq 251)
> TLB (TLB shootdowns) == INVALIDATE_TLB_VECTOR_0 (irq=240) +
>                         INVALIDATE_TLB_VECTOR_1 (irq=241) +
>                         INVALIDATE_TLB_VECTOR_2 (irq=242)
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
> Changelog:
> v1-v2
> * Move the irq_vector_{entry|exit} tracepoints under irq_vectors/ sub
>   folder
> * Rebased to 3.0.0
> 
>  arch/x86/include/asm/irq_vectors.h       |   50 ++++++++++++++++++++++++++
>  arch/x86/kernel/apic/apic.c              |    7 ++++
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |    3 ++
>  arch/x86/kernel/cpu/mcheck/threshold.c   |    3 ++
>  arch/x86/kernel/irq.c                    |    7 +++-
>  arch/x86/kernel/irq_work.c               |    3 ++
>  arch/x86/kernel/smp.c                    |    7 ++++
>  arch/x86/kernel/time.c                   |   16 +++++---
>  arch/x86/kernel/traps.c                  |    3 ++
>  arch/x86/mm/tlb.c                        |    3 ++
>  include/trace/events/irq_vectors.h       |   56 ++++++++++++++++++++++++++++++
>  11 files changed, 151 insertions(+), 7 deletions(-)
>  create mode 100644 include/trace/events/irq_vectors.h
> 
> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
> index 6e976ee..af06349 100644
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -182,4 +182,54 @@ static inline int invalid_vm86_irq(int irq)
>  # define NR_IRQS			NR_IRQS_LEGACY
>  #endif
>  
> +#define irq_vector_name(sirq) { sirq, #sirq }
> +#define invalidate_tlb_vector_name(i) { INVALIDATE_TLB_VECTOR_END-31+i, \
> +					"INVALIDATE_TLB_VECTOR" }

IIRC, Thomas suggested in the v1 to turn arch tracepoints into core ones when they
stand for generic (ie: shared by all archs) event meaning.

I don't know where the discussion went after that, but that still seems to
me an important direction. Tracing irqs by their vector number should be reserved
for pure arch meanings. Sharing common tracepoints for generic events amongst archs makes life
easier for tools. Bonus when the tracepoint can be placed in the generic code.


> +#define irq_vector_name_table						\
> +			irq_vector_name(NMI_VECTOR),			\
> +			irq_vector_name(LOCAL_TIMER_VECTOR),		\

This should be a tracepoint in the generic timer interrupt handler(s).

> +			irq_vector_name(ERROR_APIC_VECTOR),		\
> +			irq_vector_name(RESCHEDULE_VECTOR),		\

Although each archs have their own implementations of rescheduling interrupt,
it's a common event amongst arch. Better have a common tracepoint for that
and not a different vector number between them.

> +			irq_vector_name(CALL_FUNCTION_VECTOR),		\
> +			irq_vector_name(CALL_FUNCTION_SINGLE_VECTOR),	\

Both should be tracepoints in kernel/smp.c: generic_smp_call_function_*_interrupt()

> +			irq_vector_name(THERMAL_APIC_VECTOR),		\
> +			irq_vector_name(THRESHOLD_APIC_VECTOR),		\
> +			irq_vector_name(REBOOT_VECTOR),			\

Reboot seems to be generic as well.

> +			irq_vector_name(SPURIOUS_APIC_VECTOR),		\
> +			irq_vector_name(IRQ_WORK_VECTOR),		\

Should be in the irq work generic code.
