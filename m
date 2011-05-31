Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab1EaNhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:37:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35857 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab1EaNhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:37:37 -0400
Message-ID: <4DE4EF1B.80805@monstr.eu>
Date: Tue, 31 May 2011 15:37:31 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
References: <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>	 <1306405979.1200.63.camel@twins>	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>	 <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>	 <20110526122623.GA11875@elte.hu>	 <20110526123137.GG24876@n2100.arm.linux.org.uk>	 <20110526125007.GA27083@elte.hu>	 <BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com>	 <20110527120629.GA32617@elte.hu>	 <20110527205240.GT24876@n2100.arm.linux.org.uk>	 <1306588381.2497.481.camel@laptop>  <4DE4CC33.7090404@petalogix.com> <1306848137.2353.91.camel@twins>
In-Reply-To: <1306848137.2353.91.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2011-05-31 at 13:08 +0200, Michal Simek wrote:
>> please correct me if I am wrong but this is workaround just for ARM.
>> I am not aware that we need to do anything with caches. I enabled that options
>> after our discussion (http://lkml.org/lkml/2009/12/3/204) because of problems 
>> with lockdep. I will look if I can remove that option but it will be necessary 
>> to do some changes in code. switch_to should be called with irq OFF right?
> 
> Hmm, so the problem was that interrupts got enabled on microblaze (or
> lockdep thought they were), so we need to figure out why that is so
> instead of ensuring that it is so.
> 
> /me goes poke about in the microblaze code..
> 
> So on fork() the child ip gets set to ret_from_fork(), then when we wake
> the child we'll eventually schedule to it. So we get a context switch
> like X -> child.
> 
> Then X calls schedule()->context_switch()->switch_to() which will
> continue at ret_from_fork()->schedule_tail()->finish_task_switch()->
> finish_lock_switch()->spin_acquire(&rq->lock.depmap..)
> 
> Now the lockdep report says that at that point interrupts were enabled,
> and I can't quite see how that would happen, we go into switch_to() with
> interrupts disabled (assuming !__ARCH_WANT_INTERRUPTS_ON_CTXSW), so the
> whole ret_from_fork()->... path should run with interrupts disabled as
> well.
> 
> I can't find where it would have enabled IRQs. Maybe the current
> microblaze code doesn't suffer this, or I simply missed it in the
> entry.S magic -- its not like I can actually read microblaze asm well.
> 
> Does it still explode like back then, if so, can you see where it
> enables IRQs?

I briefly looked at it and it probably come from copy_thread function (process.c 
- line: childregs->msr |= MSR_IE;)
When context switch happen, childregs->msr value is loaded to MSR (machine 
status register) which caused that IE is enabled ( entry.S:~977 lwi	r12, r11, 
CC_MSR; 	mts	rmsr, r12)

NOTE: MSR stores flags for IE, i/d-cache ON/OFF, virtual memory/user mode etc.

This is no problem if context switch is done with irq on. But maybe there is 
another place which is causing some problems.

Where exactly should be IRQ reenable after context switch?

I would like to also check some things.
1. When schedule should be called from arch specific code?
Currently we are calling schedule after syscall/exception/interrupt happen.
Is there any place where schedule should/shouldn't be called?

2. For syscall and exception handling - interrupt is ON but it is only masked.
When schedule is called from that any code has to enable IRQ if generic code 
doesn't do that. Not sure if it does.

Michal




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
