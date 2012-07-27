Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2G0Rjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 13:39:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:51888 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2G0Rjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 13:39:44 -0400
Message-ID: <5012D25B.3040302@linutronix.de>
Date: Fri, 27 Jul 2012 19:39:39 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH] uprobes: don't enable/disable signle step if the user
 did it
References: <1343316043-13475-1-git-send-email-bigeasy@linutronix.de> <20120726173126.GA5787@redhat.com>
In-Reply-To: <20120726173126.GA5787@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 07:31 PM, Oleg Nesterov wrote:
> Well. I agree, this needs changes. To begin with, uprobe should avoid
> user_enable_single_step() which does access_process_vm(). And I suspect
> uprobes have the problems with TIF_FORCED_TF logic.

Why? Shouldn't wee keep the trap flag if the instruction on which we
placed the uprobe activates it?

>
> But I am not sure about this patch...
>
> On 07/26, Sebastian Andrzej Siewior wrote:
>>
>> @@ -1528,7 +1528,10 @@ static void handle_swbp(struct pt_regs *regs)
>>
>>   	utask->state = UTASK_SSTEP;
>>   	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
>> -		user_enable_single_step(current);
>> +		if (test_tsk_thread_flag(current, TIF_SINGLESTEP))
>> +			uprobe->flags |= UPROBE_USER_SSTEP;
>> +		else
>> +			user_enable_single_step(current);
>
> This is x86 specific, TIF_SINGLESTEP is not defined on every arch.

It is not defined on every arch but I wouldn't say it is 86 specific.
 From the architectures which have user_enable_single_step() defined I
see

  avr32	TIF_SINGLE_STEP
  m68k	TIF_DELAYED_TRACE
  s390	TIF_SINGLE_STEP

which means those three could rename their flag so things are
consistent. The remaining architectures are

  alpha
  cris
  h8300
  score

and they don't set a flag and it seems they change the register
directly.

>
>> @@ -1569,7 +1572,10 @@ static void handle_singlestep(struct uprobe_task *utask, struct pt_regs *regs)
>>   	put_uprobe(uprobe);
>>   	utask->active_uprobe = NULL;
>>   	utask->state = UTASK_RUNNING;
>> -	user_disable_single_step(current);
>> +	if (uprobe->flags&  UPROBE_USER_SSTEP)
>> +		uprobe->flags&= ~UPROBE_USER_SSTEP;
>> +	else
>> +		user_disable_single_step(current);
>
> This is not enough (and I am not sure this is portable).
>
> If SINGLESTEP was set, we should send SIGTRAP here. With this patch
> we return with X86_EFLAGS_TF set, gdb will be notified only after the
> next insn. And if we notify gdb, there is no need to keep X86_EFLAGS_TF.

Sending SIGTRAP is, yes.

> I'm afraid this needs more thinking and new arch-dependant helpers.
>
> Oleg.
>

Sebastian
