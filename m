Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2HBNIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:08:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab2HBNI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:08:28 -0400
Date: Thu, 2 Aug 2012 15:05:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Roland McGrath <roland@hack.frob.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, ananth@in.ibm.com,
        a.p.zijlstra@chello.nl, mingo@redhat.com, srikar@linux.vnet.ibm.com
Subject: Re: Q: user_enable_single_step() && update_debugctlmsr()
Message-ID: <20120802130509.GA1465@redhat.com>
References: <20120801134652.GA4707@redhat.com> <50193528.3070503@linutronix.de> <20120801140121.GA5333@redhat.com> <50193B5C.90404@linutronix.de> <20120801143132.GA7550@redhat.com> <5019427B.1070002@linutronix.de> <20120801150119.GA8845@redhat.com> <50194750.2050601@linutronix.de> <20120801151442.GA9697@redhat.com> <50197994.4090800@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50197994.4090800@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Sebastian Andrzej Siewior wrote:
>
> On 08/01/2012 05:14 PM, Oleg Nesterov wrote:
>> On 08/01, Sebastian Andrzej Siewior wrote:
>>>
>>> On 08/01/2012 05:01 PM, Oleg Nesterov wrote:
>>>> On 08/01, Sebastian Andrzej Siewior wrote:
>>>>> So a patch like
>>>>> --- a/arch/x86/kernel/step.c
>>>>> +++ b/arch/x86/kernel/step.c
>>>>> @@ -173,8 +173,8 @@ static void enable_step(struct task_struct *child,
>>>>> bool block)
>>>>>                   unsigned long debugctl = get_debugctlmsr();
>>>>>
>>>>>                   debugctl |= DEBUGCTLMSR_BTF;
>>>>> -               update_debugctlmsr(debugctl);
>>>>>                   set_tsk_thread_flag(child, TIF_BLOCKSTEP);
>>>>> +               update_debugctlmsr(debugctl);
>>>>>           } else if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
>>>>>                   unsigned long debugctl = get_debugctlmsr();
>>>>>
>>>>> should fix the race
>>>>
>>>> No, I don't think it can fix something ;) or make any difference.
>>>
>>> Why? You _first_ set the task flag
>>
>> Yes, and this task is "child".
>>
>>> followed by the CPU register. Now
>>> switch_to() would see the bit set and act.
>>
>> child sleeps and doesn't participate in switch_to(). Debugger and another
>> (unrelated) task do.
>
> This is confusing.

Yes, I guess you misread http://marc.info/?l=linux-kernel&m=134383196411020

> In order to allow the debugger to ptrace()->enable_blockstep() the
> child has to be stopped/traced.

Yes,

> We switch X86_EFLAGS_TF in child's regs

Yes,

> and enable DEBUGCTLMSR_BTF for the debugger which is wrong.

Yes, DEBUGCTLMSR_BTF is "global" (ok, per-cpu)

> If we quit
> to userspace then the CPU on which the debugger runs has
> DEBUGCTLMSR_BTF.

Yes, this doesn't look right too, but I meant another race.

I have no idea what DEBUGCTLMSR_BTF means without X86_EFLAGS_TF
though. And if gdb itself is TIF_SINGLESTEP'ed, it won't return
to userspace without report/schedule.

But, yes sure! this doesn't look right and this is the source of
other problems, and this is why I started this thread.

> If the tracee task runs

In the scenario I tried to describe above, the tracee does _not_ run.

gdb switches to _another_ X86_EFLAGS_TF task before the tracee is resumed.

>From the link above,

	We have the GDB process and the (stopped) tracee T. And we have
	another task X
        ^^^^^^^^^^^^^^

Oleg.

