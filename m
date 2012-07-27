Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2G0SHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:07:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab2G0SHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:07:24 -0400
Date: Fri, 27 Jul 2012 20:04:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH] uprobes: don't enable/disable signle step if the user
	did it
Message-ID: <20120727180423.GA21022@redhat.com>
References: <1343316043-13475-1-git-send-email-bigeasy@linutronix.de> <20120726173126.GA5787@redhat.com> <5012D25B.3040302@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5012D25B.3040302@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27, Sebastian Andrzej Siewior wrote:
>
> On 07/26/2012 07:31 PM, Oleg Nesterov wrote:
>> Well. I agree, this needs changes. To begin with, uprobe should avoid
>> user_enable_single_step() which does access_process_vm(). And I suspect
>> uprobes have the problems with TIF_FORCED_TF logic.
>
> Why? Shouldn't wee keep the trap flag if the instruction on which we
> placed the uprobe activates it?

Yes. But user_enable_single_step() is not the right interface.

>> But I am not sure about this patch...
>>
>> On 07/26, Sebastian Andrzej Siewior wrote:
>>>
>>> @@ -1528,7 +1528,10 @@ static void handle_swbp(struct pt_regs *regs)
>>>
>>>   	utask->state = UTASK_SSTEP;
>>>   	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
>>> -		user_enable_single_step(current);
>>> +		if (test_tsk_thread_flag(current, TIF_SINGLESTEP))
>>> +			uprobe->flags |= UPROBE_USER_SSTEP;
>>> +		else
>>> +			user_enable_single_step(current);
>>
>> This is x86 specific, TIF_SINGLESTEP is not defined on every arch.
>
> It is not defined on every arch but I wouldn't say it is 86 specific.
> From the architectures which have user_enable_single_step() defined I
> see

But we do not need TIF_SINGLESTEP. At all. Again, this is ptrace thing
connected to user_enable_single_step().

Sebastian, I am sorry for being terse, I'll write another email later.

Oleg.

