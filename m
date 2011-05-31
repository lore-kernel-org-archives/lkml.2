Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab1EaNWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:22:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:40756 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1EaNWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:22:32 -0400
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: michal.simek@petalogix.com
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Michal Simek <monstr@monstr.eu>
In-Reply-To: <4DE4CC33.7090404@petalogix.com>
References: <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
	 <1306405979.1200.63.camel@twins>
	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
	 <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>
	 <20110526122623.GA11875@elte.hu>
	 <20110526123137.GG24876@n2100.arm.linux.org.uk>
	 <20110526125007.GA27083@elte.hu>
	 <BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com>
	 <20110527120629.GA32617@elte.hu>
	 <20110527205240.GT24876@n2100.arm.linux.org.uk>
	 <1306588381.2497.481.camel@laptop>  <4DE4CC33.7090404@petalogix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 31 May 2011 15:22:17 +0200
Message-ID: <1306848137.2353.91.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 13:08 +0200, Michal Simek wrote:
> 
> please correct me if I am wrong but this is workaround just for ARM.
> I am not aware that we need to do anything with caches. I enabled that options
> after our discussion (http://lkml.org/lkml/2009/12/3/204) because of problems 
> with lockdep. I will look if I can remove that option but it will be necessary 
> to do some changes in code. switch_to should be called with irq OFF right?

Hmm, so the problem was that interrupts got enabled on microblaze (or
lockdep thought they were), so we need to figure out why that is so
instead of ensuring that it is so.

/me goes poke about in the microblaze code..

So on fork() the child ip gets set to ret_from_fork(), then when we wake
the child we'll eventually schedule to it. So we get a context switch
like X -> child.

Then X calls schedule()->context_switch()->switch_to() which will
continue at ret_from_fork()->schedule_tail()->finish_task_switch()->
finish_lock_switch()->spin_acquire(&rq->lock.depmap..)

Now the lockdep report says that at that point interrupts were enabled,
and I can't quite see how that would happen, we go into switch_to() with
interrupts disabled (assuming !__ARCH_WANT_INTERRUPTS_ON_CTXSW), so the
whole ret_from_fork()->... path should run with interrupts disabled as
well.

I can't find where it would have enabled IRQs. Maybe the current
microblaze code doesn't suffer this, or I simply missed it in the
entry.S magic -- its not like I can actually read microblaze asm well.

Does it still explode like back then, if so, can you see where it
enables IRQs?
