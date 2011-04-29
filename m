Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab1D2AOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 20:14:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:58911 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194Ab1D2AOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 20:14:36 -0400
Date: Fri, 29 Apr 2011 02:14:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH] trace: Add special x86 irq entry/exit tracepoints
In-Reply-To: <1303512981-26234-1-git-send-email-vnagarnaik@google.com>
Message-ID: <alpine.LFD.2.02.1104290158320.3005@ionos>
References: <1303512981-26234-1-git-send-email-vnagarnaik@google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011, Vaibhav Nagarnaik wrote:
>  #include <asm/perf_event.h>
>  #include <asm/x86_init.h>
> @@ -857,7 +858,9 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
>  	 */
>  	exit_idle();
>  	irq_enter();
> +	trace_special_irq_entry(LOCAL_TIMER_VECTOR);

Gah. trace_special_irq is the worst name you could come up with. It's
tracing a vector which is nothing special and nothing x86 specific.

>  #include <asm/vsyscall.h>
>  #include <asm/x86_init.h>
> @@ -26,6 +27,8 @@
>  volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
>  #endif
>  
> +static struct irqaction *irq0_action;
> +

Ouch! You need an extra pointer for that ? Moving the stupid irq0
struct up a few lines would do the trick as well, right ?

> --- a/include/trace/events/irq.h
> +++ b/include/trace/events/irq.h
> @@ -139,6 +139,74 @@ DEFINE_EVENT(softirq, softirq_raise,
>  	TP_ARGS(vec_nr)
>  );
>  
> +#ifdef CONFIG_X86
> +#include <asm/irq_vectors.h>
> +#define special_irq_name(sirq) { sirq, #sirq }
> +#define show_special_irq_name(val)					\
> +	__print_symbolic(val,						\
> +			 special_irq_name(NMI_VECTOR),			\
> +			 special_irq_name(LOCAL_TIMER_VECTOR),		\
> +			 special_irq_name(ERROR_APIC_VECTOR),		\
> +			 special_irq_name(RESCHEDULE_VECTOR),		\
> +			 special_irq_name(CALL_FUNCTION_VECTOR),	\
> +			 special_irq_name(CALL_FUNCTION_SINGLE_VECTOR),	\
> +			 special_irq_name(THERMAL_APIC_VECTOR),		\
> +			 special_irq_name(THRESHOLD_APIC_VECTOR),	\
> +			 special_irq_name(REBOOT_VECTOR),		\
> +			 special_irq_name(SPURIOUS_APIC_VECTOR),	\
> +			 special_irq_name(IRQ_WORK_VECTOR),		\
> +			 special_irq_name(X86_PLATFORM_IPI_VECTOR)	\
> +			)
> +
> +#define IS_INVALIDATE_TLB_VECTOR(__irq) (\
> +		__irq >= INVALIDATE_TLB_VECTOR_START && \
> +		__irq <= INVALIDATE_TLB_VECTOR_END)

No way, really.

Interrupt vectors are not x86 specific and they do no need any
architecture specific handling at all. 

The symbolic printout is a nice to have extra, but it can be solved by
providing an arch specific lookup table which does not require any of
that #ifdef X86 mess. If the table does not exist, then you simply can
print the vector number and be done with it.

Thanks,

	tglx
