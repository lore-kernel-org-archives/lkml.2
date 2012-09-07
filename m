Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2IGFWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 01:22:14 -0400
Received: from mail1.windriver.com ([147.11.146.13]:37499 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab2IGFWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 01:22:13 -0400
Message-ID: <50498474.4000900@windriver.com>
Date: Fri, 7 Sep 2012 13:21:56 +0800
From: wyang1 <Wei.Yang@windriver.com>
Reply-To: <Wei.Yang@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH] x86, 32-bit: Fix invalid stack address while in softirq
References: <1346031133-12756-1-git-send-email-Wei.Yang@windriver.com>	 <20120904102439.GS8285@erda.amd.com> <5047FCBD.9000205@windriver.com>	 <20120906100434.GX8285@erda.amd.com>	 <1346937282.1680.15.camel@gandalf.local.home>	 <20120906150246.GZ8285@erda.amd.com>	 <1346944482.1680.28.camel@gandalf.local.home>	 <20120906153407.GA8285@erda.amd.com> <20120906153647.GB8285@erda.amd.com> <1346946887.1680.31.camel@gandalf.local.home>
In-Reply-To: <1346946887.1680.31.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.190]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 11:54 PM, Steven Rostedt wrote:
> On Thu, 2012-09-06 at 17:36 +0200, Robert Richter wrote:
>
>> I meant:
>>
>> unsigned long kernel_stack_pointer(struct pt_regs *regs)
>> {
>> 	unsigned long context = (unsigned long)regs&  ~(THREAD_SIZE - 1);
>> 	unsigned long sp = (unsigned long)&regs->sp;
>> 	struct thread_info *tinfo;
>>
>> 	if (context == (sp&  ~(THREAD_SIZE - 1)))
>> 		return sp;
>> 	
>> 	tinfo = (struct thread_info *)context;
>> 	if (tinfo->previous_esp)
>> 		return tinfo->previous_esp;
>>
>> 	return (unsigned long)regs;
>> }
>>
>> -Robert
>>
>>> Maybe this is even better.
>>>
>>>
Stevent & Robert,

Actually, we also can revert the following commit:

commit 7b6c6c77732ca1d2498eda7eabb64f9648896e96
Author: Masami Hiramatsu <mhiramat@redhat.com>
Date:   Mon May 11 17:03:00 2009 -0400

     x86, 32-bit: fix kernel_trap_sp()

     Use &regs->sp instead of regs for getting the top of stack in 
kernel mode.
     (on x86-64, regs->sp always points the top of stack)


I meant:

static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
{
     #ifdef CONFIG_X86_32
        return (unsigned long)regs;
     #else
        return regs->sp;
     #endif
}


What do you think of it?

Thanks
Wei

> Yeah, this is probably the safest.
>
> Thanks,
>
> -- Steve
>
>
>

