Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab2HAOet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:34:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab2HAOes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:34:48 -0400
Date: Wed, 1 Aug 2012 16:31:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Roland McGrath <roland@hack.frob.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, ananth@in.ibm.com,
        a.p.zijlstra@chello.nl, mingo@redhat.com, srikar@linux.vnet.ibm.com
Subject: Re: Q: user_enable_single_step() && update_debugctlmsr()
Message-ID: <20120801143132.GA7550@redhat.com>
References: <1343735548-18101-2-git-send-email-bigeasy@linutronix.de> <20120731175108.GC14576@redhat.com> <50183273.9070304@linutronix.de> <20120801122616.GA32705@redhat.com> <20120801130118.GA2386@redhat.com> <50192FF5.1060208@linutronix.de> <20120801134652.GA4707@redhat.com> <50193528.3070503@linutronix.de> <20120801140121.GA5333@redhat.com> <50193B5C.90404@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50193B5C.90404@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Sebastian Andrzej Siewior wrote:
>
> On 08/01/2012 04:01 PM, Oleg Nesterov wrote:
>> On 08/01, Sebastian Andrzej Siewior wrote:
>>>
>>> On 08/01/2012 03:46 PM, Oleg Nesterov wrote:
>>>
>>>>>> But, worse, isn't it wrong? Suppose that debugger switches to
>>>>>> another TIF_SINGLESTEP&&    !TIF_BLOCKSTEP task, in this case
>>>>>> we "leak" DEBUGCTLMSR_BTF, no?
>>>>>
>>>>> __switch_to_xtra() should notice the difference in the TIF_BLOCKSTEP
>>>>> flag and disable it.
>>>>
>>>> And how it can notice the difference if there is no difference?
>>>>
>>>> (unless, of course debugger is TIF_BLOCKSTEP'ed).
>>>
>>> Yes. enable_step() sets DEBUGCTLMSR_BTF along with TIF_BLOCKSTEP.
>>> kprobes checks the same flag before touching DEBUGCTLMSR_BTF.
>>
>> It seems that you replied to the wrong email or I am confused ;)
>
> No I think I replied to the correct one :)
> enable_step() is the only place for ptrace/debugger which is touching
> DEBUGCTLMSR_BTF. It always sets DEBUGCTLMSR_BTF and TIF_BLOCKSTEP in
> sync so why should they both end up different? And once
> __switch_to_extra() notices that TIF_BLOCKSTEP from the previous task
> is different from the next task is different, then the CPU flag has
> to be changed.

OK, I was confuse by "kprobes" above.

And I think you missed my point. I'll try again.

We have the GDB process and the (stopped) tracee T. And we have
another task X which have TIF_SINGLESTEP but not TIF_BLOCKSTEP.
To simplify, suppose that X is already TASK_RUNNING but not on rq.

GDB does ptrace(PTRACE_SINGLEBLOCK, T). This sets X->TIF_BLOCKSTEP.
Now suppose that GDB is preempted right after it does
update_debugctlmsr(), and the scheduler choses X as the next task.

Both GDB and X do not have TIF_BLOCKSTEP, so __switch_to_extra()
does not update DEBUGCTLMSR_BTF.

X returns to the user-mode with TIF_SINGLESTEP and TIF_BLOCKSTEP,
the latter is wrong.

No?

Oleg.

