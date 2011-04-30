Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256Ab1D3AxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:53:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45172 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1D3AxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:53:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RCmXb5grW5dV3yPJ/O7O17bRCBqepJhYHzrk3JvxnuwoHi48dkmbZGMkvCNSB+FnDI
         9lW+ZAR50UikGar0AKrg==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1104290215290.3005@ionos>
References: <1303513438-26519-1-git-send-email-vnagarnaik@google.com> <alpine.LFD.2.02.1104290215290.3005@ionos>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 29 Apr 2011 17:52:31 -0700
Message-ID: <BANLkTin5xgsqcro39eK_kCR9Fmk_Bq3YVw@mail.gmail.com>
Subject: Re: [PATCH 1/2] trace: Add trap entry/exit tracepoints
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

On Thu, Apr 28, 2011 at 5:33 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 22 Apr 2011, Vaibhav Nagarnaik wrote:
>>  #include <asm/uaccess.h>
>>  #include <asm/pgtable.h>
>>  #include <asm/system.h>
>> @@ -1330,8 +1332,10 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
>>       struct siginfo info;
>>
>>       fill_sigtrap_info(tsk, regs, error_code, si_code, &info);
>> +     trace_trap_entry(tsk->thread.trap_no);
>
> What the heck? How is that a trap? The code is sending SIGTRAP not
> entering a trap at all. What are you trying to measure ? The time it
> takes to send SIGTRAP? So how is that useful as an extra event?
>

It is not a trap. But it did get called from the do_debug trap handler. I have
moved these tracepoints to the do_debug function which is a better place for
them.

>>       /* Send us the fake SIGTRAP */
>>       force_sig_info(SIGTRAP, &info, tsk);
>> +     trace_trap_exit(tsk->thread.trap_no);
>>  }
>>
>>
>> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
>> index 4857ff6..d450349 100644
>> --- a/arch/x86/kernel/traps.c
>> +++ b/arch/x86/kernel/traps.c
>> @@ -33,6 +33,9 @@
>>  #include <linux/io.h>
>>  #include <trace/events/irq.h>
>>
>> +#define CREATE_TRACE_POINTS
>> +#include <trace/events/trap.h>
>> +
>>  #ifdef CONFIG_EISA
>>  #include <linux/ioport.h>
>>  #include <linux/eisa.h>
>> @@ -123,6 +126,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
>>  {
>>       struct task_struct *tsk = current;
>>
>> +     trace_trap_entry(trapnr);
>
> While the event of do_trap() itself might be interesting, it does not
> matter at all how long it takes to handle it. That code is really not
> so interesting.
>
I have updated the use case in the patch. We actually can find the instances
when the system moved between kernel and user spaces. The fact that we also
get timestamps is an added advantage.

>> @@ -286,7 +293,9 @@ do_general_protection(struct pt_regs *regs, long error_code)
>>               printk("\n");
>>       }
>>
>> +     trace_trap_entry(tsk->thread.trap_no);
>>       force_sig(SIGSEGV, tsk);
>> +     trace_trap_exit(tsk->thread.trap_no);
>
> We really do not care how long the force_sig() call takes. It's
> irrelevant. The only interesting thing here is that we ran into a GP
> trap.
>
I agree, but it does provide the task which caused this and another data point
where the system had to move to kernel space.

>> +
>> +dotraplinkage void __kprobes
>> +do_page_fault(struct pt_regs *regs, unsigned long error_code)
>> +{
>> +     trace_trap_entry(14);
>
> Yuck. Magic number 14 ? Why not 42 ?

Sorry for that. I thought that this patch would have lower resistance than the
next patch which converts the numbers to enum values. I have corrected it now
and am sending the enum patch first and use that as the base patch to use the
enum value (INTR_PAGE_FAULT) instead of magic number.

>
>> +     __do_page_fault(regs, error_code);
>> +     trace_trap_exit(14);
>> +}
>
> That page fault thing is the only interesting event in terms of
> runtime, but I have yet to see a proper rationale for the whole thing
> aside of that completly bogus changelog which tells what output I can
> produce, but not why the hell it is a good idea to add all that trace
> points.
>
I have updated the patch description. Hopefully it is better worded and
provides more context and support for the usefulness of it.

> Thanks,
>
>        tglx
>
>

Thanks for looking at the patches.

Vaibhav Nagarnaik
