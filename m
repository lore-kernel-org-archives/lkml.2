Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2HCRm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:42:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab2HCRm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:42:56 -0400
Date: Fri, 3 Aug 2012 19:38:30 +0200
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
Message-ID: <20120803173830.GA22687@redhat.com>
References: <20120803162954.GA19806@redhat.com> <501BFF95.8040202@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501BFF95.8040202@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Sebastian Andrzej Siewior wrote:
>
> On 08/03/2012 06:29 PM, Oleg Nesterov wrote:
>> diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
>> index afa60db..636402e 100644
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
>
> wouldn't preempt_disable() be enough?

preempt_disable() can't help if interrupt handler changes
other bits in between?

Oleg.

