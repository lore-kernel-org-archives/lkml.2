Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2CIQaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 11:30:52 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45478 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab2CIQav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 11:30:51 -0500
MIME-Version: 1.0
In-Reply-To: <20120309092845.GA10281@elte.hu>
References: <20120309074202.GA28609@www.outflux.net>
	<20120309092845.GA10281@elte.hu>
Date: Fri, 9 Mar 2012 08:30:49 -0800
X-Google-Sender-Auth: pEMg8xVIW2IjifZ0sPWaZwtwQEE
Message-ID: <CAGXu5j+SgWMjwNQd8w8DPSQmBVHDow=_osp57OVp4X2VU5Fe5w@mail.gmail.com>
Subject: Re: [PATCH] x86: use enum instead of literals for trap values
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 1:28 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> The traps are referred to by their numbers and it can be difficult to
>> understand them while reading the code without context. This patch adds
>> enumeration of the trap numbers and replaces the numbers with the correct
>> enum for x86.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>> ---
>> I've updated Aditya Kali's earlier patch:
>> https://lkml.org/lkml/2011/4/22/328
>> ---
>>  arch/x86/include/asm/traps.h |   25 +++++++++
>>  arch/x86/kernel/irqinit.c    |    2 +-
>>  arch/x86/kernel/traps.c      |  117 ++++++++++++++++++++++--------------------
>>  3 files changed, 88 insertions(+), 56 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
>> index 0012d09..768afb2 100644
>> --- a/arch/x86/include/asm/traps.h
>> +++ b/arch/x86/include/asm/traps.h
>> @@ -89,4 +89,29 @@ asmlinkage void smp_thermal_interrupt(void);
>>  asmlinkage void mce_threshold_interrupt(void);
>>  #endif
>>
>> +/* Interrupts/Exceptions */
>> +enum {
>> +     INTR_DIV_BY_ZERO = 0,   /*  0 */
>> +     INTR_DEBUG,             /*  1 */
>> +     INTR_NMI,               /*  2 */
>> +     INTR_BREAKPOINT,        /*  3 */
>> +     INTR_OVERFLOW,          /*  4 */
>> +     INTR_BOUNDS_CHECK,      /*  5 */
>> +     INTR_INVALID_OP,        /*  6 */
>> +     INTR_NO_DEV,            /*  7 */
>> +     INTR_DBL_FAULT,         /*  8 */
>> +     INTR_SEG_OVERRUN,       /*  9 */
>> +     INTR_INVALID_TSS,       /* 10 */
>> +     INTR_NO_SEG,            /* 11 */
>> +     INTR_STACK_FAULT,       /* 12 */
>> +     INTR_GPF,               /* 13 */
>> +     INTR_PAGE_FAULT,        /* 14 */
>> +     INTR_SPURIOUS,          /* 15 */
>> +     INTR_COPROCESSOR,       /* 16 */
>> +     INTR_ALIGNMENT,         /* 17 */
>> +     INTR_MCE,               /* 18 */
>> +     INTR_SIMD_COPROCESSOR,  /* 19 */
>> +     INTR_IRET = 32,         /* 32 */
>> +};
>
>> @@ -453,14 +458,15 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>>  /*
>>   * Note that we play around with the 'TS' bit in an attempt to get
>>   * the correct behaviour even in the presence of the asynchronous
>> - * IRQ13 behaviour
>> + * INTR_GPF behaviour
>>   */
>
>> @@ -529,8 +535,9 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
>>               info.si_code = FPE_FLTRES;
>>       } else {
>>               /*
>> -              * If we're using IRQ 13, or supposedly even some trap 16
>> -              * implementations, it's possible we get a spurious trap...
>> +              * If we're using INTR_GPF, or supposedly even some trap
>> +              * INTR_COPROCESSOR implementations, it's possible we get a
>> +              * spurious trap...
>
> There's confusion in this patch between legacy IRQ #13 [vector
> 0x20 + 13 ] and #GPF general protection fault [vector 13] - they
> are not the same.
>
> Furthermore, the INTR_ naming is not ideal either for (most of)
> these entries: for example we don't think of a page fault as an
> asynchronous interrupt entity - we think of it as a more or less
> synchronous fault/exception.
>
> Thus a X86_*_FAULT_VEC naming pattern might be better:
>
>        X86_PAGE_FAULT_VEC
>        X86_DOUBLE_FAULT_VEC
>
> (With X86_*_EXCEPTION_VEC applied where appropriate.)

Oh, hrm, my v2 missed this bit about EXCEPTION. What should I use as
the canonical source for "FAULT" vs "EXCEPTION" for this enum?

> I don't disagree with the general principle of the cleanup
> otherwise, the numeric literals are often ambiguous and
> confusing - as the trap 13 - irq 13 mixup above shows.

Right, and leaves me a bit confused too. :)

-Kees

-- 
Kees Cook
ChromeOS Security
