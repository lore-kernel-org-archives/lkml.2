Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab2HGPTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:19:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2HGPTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:19:01 -0400
Date: Tue, 7 Aug 2012 17:15:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace: fix
	set_task_blockstep()->update_debugctlmsr() logic
Message-ID: <20120807151531.GC13476@redhat.com>
References: <20120803162954.GA19806@redhat.com> <5020E2E4.3090104@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5020E2E4.3090104@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Today I noticed by accident that starting from Aug 4 (at least)
all my emails went to nowhere. I am resending some of them...

On 08/07, Sebastian Andrzej Siewior wrote:
>
> On 08/03/2012 06:29 PM, Oleg Nesterov wrote:
>> --- a/arch/x86/kernel/step.c
>> +++ b/arch/x86/kernel/step.c
>> @@ -166,12 +166,18 @@ static void set_task_blockstep(struct task_struct *task, bool on)
>>   	else
>>   		clear_tsk_thread_flag(task, TIF_BLOCKSTEP);
>>
>> +	if (task != current)
>> +		return;
>> +
>> +	/* ensure irq/preemption can't change debugctl in between */
>> +	local_irq_disable();
>>   	debugctl = get_debugctlmsr();
>>   	if (on)
>>   		debugctl |= DEBUGCTLMSR_BTF;
>>   	else
>>   		debugctl&= ~DEBUGCTLMSR_BTF;
>>   	update_debugctlmsr(debugctl);
>> +	local_irq_enable();
>>   }
>
> I would say that you can remove this chunk. For task != current we
> leave.

It turns out, original code is even more buggy than I thought.

Ironically, "task != current" case is more difficult and so far
I do not see how we can handle this case correctly. I'll return
to this a bit later, currently I am working on other patches.

> For uprobes we never set the bit, we only need it cleared.

Yes, at least at first step, and probably we will never need more.

> We get here
> via int 3 and do_debug() already clears TIF_BLOCKSTEP

No, we get here via do_int3(), TIF_BLOCKSTEP is not cleared,

> because the
> CPU clears the bit in CPU.

I am not sure. The manual says:

	 If the BTF flag is set when the processor generates a debug
	 exception, the processor clears the BTF flag along with the
	 TF flag.

but I am not sure "debug exception" also means "breakpoint exception".



do_debug() does clear TIF_BLOCKSTEP, and "The processor cleared BTF"
is true in this case. But it is called after single-step.

Oleg.

