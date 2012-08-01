Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2HASqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 14:46:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:52696 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2HASqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 14:46:52 -0400
Message-ID: <50197994.4090800@linutronix.de>
Date: Wed, 01 Aug 2012 20:46:44 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Roland McGrath <roland@hack.frob.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, ananth@in.ibm.com,
        a.p.zijlstra@chello.nl, mingo@redhat.com, srikar@linux.vnet.ibm.com
Subject: Re: Q: user_enable_single_step() && update_debugctlmsr()
References: <20120801130118.GA2386@redhat.com> <50192FF5.1060208@linutronix.de> <20120801134652.GA4707@redhat.com> <50193528.3070503@linutronix.de> <20120801140121.GA5333@redhat.com> <50193B5C.90404@linutronix.de> <20120801143132.GA7550@redhat.com> <5019427B.1070002@linutronix.de> <20120801150119.GA8845@redhat.com> <50194750.2050601@linutronix.de> <20120801151442.GA9697@redhat.com>
In-Reply-To: <20120801151442.GA9697@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 05:14 PM, Oleg Nesterov wrote:
> On 08/01, Sebastian Andrzej Siewior wrote:
>>
>> On 08/01/2012 05:01 PM, Oleg Nesterov wrote:
>>> On 08/01, Sebastian Andrzej Siewior wrote:
>>>> So a patch like
>>>> --- a/arch/x86/kernel/step.c
>>>> +++ b/arch/x86/kernel/step.c
>>>> @@ -173,8 +173,8 @@ static void enable_step(struct task_struct *child,
>>>> bool block)
>>>>                   unsigned long debugctl = get_debugctlmsr();
>>>>
>>>>                   debugctl |= DEBUGCTLMSR_BTF;
>>>> -               update_debugctlmsr(debugctl);
>>>>                   set_tsk_thread_flag(child, TIF_BLOCKSTEP);
>>>> +               update_debugctlmsr(debugctl);
>>>>           } else if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
>>>>                   unsigned long debugctl = get_debugctlmsr();
>>>>
>>>> should fix the race
>>>
>>> No, I don't think it can fix something ;) or make any difference.
>>
>> Why? You _first_ set the task flag
>
> Yes, and this task is "child".
>
>> followed by the CPU register. Now
>> switch_to() would see the bit set and act.
>
> child sleeps and doesn't participate in switch_to(). Debugger and another
> (unrelated) task do.

This is confusing.

In order to allow the debugger to ptrace()->enable_blockstep() the
child has to be stopped/traced. We switch X86_EFLAGS_TF in child's regs
and enable DEBUGCTLMSR_BTF for the debugger which is wrong. If we quit
to userspace then the CPU on which the debugger runs has
DEBUGCTLMSR_BTF. If the tracee task runs on the same then nothing 
happens, the bit remains set.
If the tracee happens to run on a different CPU then switch_to() will
enable the DEBUGCTLMSR_BTF bit for the debugger's CPU and switch_to() 
will enable it also on the other CPU.
I added a few printks in the source and I see output that
__switch_to_xtra() enables the bit as well as in enable_single() for
debugger's CPU. I didn't find where the single step is disabled for the
tracee. I haven't notice this in __switch_to_xtra() nor or in
disable_single_step().

> Oleg.
>

Sebastian
