Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767Ab1D2UPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:15:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6601 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1D2UPs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eMHq1o1JqvMY0oJatYCH3nm1TvwbuT1LxEtm5lrLQ0YGzMguY/iJGFvvF2VBQXkR3u
         ATONHMrJgsxO3MC+uLWw==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1104290158320.3005@ionos>
References: <1303512981-26234-1-git-send-email-vnagarnaik@google.com> <alpine.LFD.2.02.1104290158320.3005@ionos>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 29 Apr 2011 13:15:04 -0700
Message-ID: <BANLkTimJ-53iMWHhRS_GjJCdOec3csYb5Q@mail.gmail.com>
Subject: Re: [PATCH] trace: Add special x86 irq entry/exit tracepoints
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiaying Zhang <jiayingz@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 5:14 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 22 Apr 2011, Vaibhav Nagarnaik wrote:
>>  #include <asm/perf_event.h>
>>  #include <asm/x86_init.h>
>> @@ -857,7 +858,9 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
>>        */
>>       exit_idle();
>>       irq_enter();
>> +     trace_special_irq_entry(LOCAL_TIMER_VECTOR);
>
> Gah. trace_special_irq is the worst name you could come up with. It's
> tracing a vector which is nothing special and nothing x86 specific.
>
I will change it to trace_irq_vector_{entry|exit}.

>>  #include <asm/vsyscall.h>
>>  #include <asm/x86_init.h>
>> @@ -26,6 +27,8 @@
>>  volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
>>  #endif
>>
>> +static struct irqaction *irq0_action;
>> +
>
> Ouch! You need an extra pointer for that ? Moving the stupid irq0
> struct up a few lines would do the trick as well, right ?
>
Sure. I will update it.

>> --- a/include/trace/events/irq.h
>> +++ b/include/trace/events/irq.h
>> @@ -139,6 +139,74 @@ DEFINE_EVENT(softirq, softirq_raise,
>>       TP_ARGS(vec_nr)
>>  );
>>
>> +#ifdef CONFIG_X86
>> +#include <asm/irq_vectors.h>
>> +#define special_irq_name(sirq) { sirq, #sirq }
>> +#define show_special_irq_name(val)                                   \
>> +     __print_symbolic(val,                                           \
>> +                      special_irq_name(NMI_VECTOR),                  \
>> +                      special_irq_name(LOCAL_TIMER_VECTOR),          \
>> +                      special_irq_name(ERROR_APIC_VECTOR),           \
>> +                      special_irq_name(RESCHEDULE_VECTOR),           \
>> +                      special_irq_name(CALL_FUNCTION_VECTOR),        \
>> +                      special_irq_name(CALL_FUNCTION_SINGLE_VECTOR), \
>> +                      special_irq_name(THERMAL_APIC_VECTOR),         \
>> +                      special_irq_name(THRESHOLD_APIC_VECTOR),       \
>> +                      special_irq_name(REBOOT_VECTOR),               \
>> +                      special_irq_name(SPURIOUS_APIC_VECTOR),        \
>> +                      special_irq_name(IRQ_WORK_VECTOR),             \
>> +                      special_irq_name(X86_PLATFORM_IPI_VECTOR)      \
>> +                     )
>> +
>> +#define IS_INVALIDATE_TLB_VECTOR(__irq) (\
>> +             __irq >= INVALIDATE_TLB_VECTOR_START && \
>> +             __irq <= INVALIDATE_TLB_VECTOR_END)
>
> No way, really.
>
> Interrupt vectors are not x86 specific and they do no need any
> architecture specific handling at all.
>
> The symbolic printout is a nice to have extra, but it can be solved by
> providing an arch specific lookup table which does not require any of
> that #ifdef X86 mess. If the table does not exist, then you simply can
> print the vector number and be done with it.
>
I have changed that and now just include the asm/irq_vectors.h so other
architectures can provide the look up table definitions in their respective
files.

I have also updated the description to address the use case. We can know when
the system is moving between kernel and user spaces. How much time is being
spent for operations and how it affects the running processes.

> Thanks,
>
>        tglx
>


Vaibhav Nagarnaik
