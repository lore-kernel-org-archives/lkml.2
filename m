Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1EaOIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:08:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42065 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1EaOIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:08:54 -0400
Message-ID: <4DE4F66D.9040101@monstr.eu>
Date: Tue, 31 May 2011 16:08:45 +0200
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
References: <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>	 <1306405979.1200.63.camel@twins>	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>	 <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>	 <20110526122623.GA11875@elte.hu>	 <20110526123137.GG24876@n2100.arm.linux.org.uk>	 <20110526125007.GA27083@elte.hu>	 <BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com>	 <20110527120629.GA32617@elte.hu>	 <20110527205240.GT24876@n2100.arm.linux.org.uk>	 <1306588381.2497.481.camel@laptop>  <4DE4CC33.7090404@petalogix.com>	 <1306848137.2353.91.camel@twins>  <4DE4EF1B.80805@monstr.eu> <1306849951.2353.108.camel@twins>
In-Reply-To: <1306849951.2353.108.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2011-05-31 at 15:37 +0200, Michal Simek wrote:
> 
>> I briefly looked at it and it probably come from copy_thread function (process.c 
>> - line: childregs->msr |= MSR_IE;)
>> When context switch happen, childregs->msr value is loaded to MSR (machine 
>> status register) which caused that IE is enabled ( entry.S:~977 lwi	r12, r11, 
>> CC_MSR; 	mts	rmsr, r12)
>>
>> NOTE: MSR stores flags for IE, i/d-cache ON/OFF, virtual memory/user mode etc.
>>
>> This is no problem if context switch is done with irq on. But maybe there is 
>> another place which is causing some problems.
> 
> Ahh, no wonder I didn't find that ;-)

:-)

> 
>> Where exactly should be IRQ reenable after context switch?
> 
> the tail end of finish_lock_switch(), where it does:
> raw_spin_unlock_irq(&rq->lock).

ok - I see.

> 
>> I would like to also check some things.
>> 1. When schedule should be called from arch specific code?
>> Currently we are calling schedule after syscall/exception/interrupt happen.
>> Is there any place where schedule should/shouldn't be called?
> 
> It should be called on the return to userspace path when
> TIF_NEED_RESCHED is set. 

Yes, we do that. (PTO + PT_MODE stores if return is to kernel or user space)

It should not be called from non-preemptible
> contexts like non-zero preempt_count or IRQ-disabled.

Is this even when the return is to userspace?

PREEMPT is not well tested feature but maybe it is right time to do so.
There is only small part of code (ifdef CONFIG_PREEMPT) when irq happen and 
there is return to the kernel. Is this correct?

> 
> [ with the exception of CONFIG_PREEMPT which calls preempt_schedule()
> which checks both those things ]

This is called only when IRQ happen right? We call preempt_schedule_irq because 
irq are off and IRQ is ON by rtid below IRQ_return label.


> 
>> 2. For syscall and exception handling - interrupt is ON but it is only masked.
> 
> I'm having trouble understanding: on but masked.

Interrupt can't happen because some masking bits are setup. If you call 
irgs_disabled() or others you will get that IRQ is ON but can't happen.

> 
>> When schedule is called from that any code has to enable IRQ if generic code 
>> doesn't do that. Not sure if it does.
> 
> generic code isn't supposed to call schedule() with IRQs disabled (and
> doesn't afaik)

OK. Which means I have to disable IRQ before schedule is called. Is that correct?

Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
