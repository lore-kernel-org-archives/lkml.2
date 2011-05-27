Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1E0MGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:06:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46841 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab1E0MGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:06:44 -0400
Date: Fri, 27 May 2011 14:06:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
Message-ID: <20110527120629.GA32617@elte.hu>
References: <1306358128.21578.107.camel@twins>
 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
 <1306405979.1200.63.camel@twins>
 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
 <1306409575.1200.71.camel@twins>
 <1306412511.1200.90.camel@twins>
 <20110526122623.GA11875@elte.hu>
 <20110526123137.GG24876@n2100.arm.linux.org.uk>
 <20110526125007.GA27083@elte.hu>
 <BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> > How much time does that take on contemporary ARM hardware, 
> > typically (and worst-case)?
> 
> On newer ARMv6 and ARMv7 hardware, we no longer flush the caches at 
> context switch as we got VIPT (or PIPT-like) caches.
> 
> But modern ARM processors use something called ASID to tag the TLB 
> entries and we are limited to 256. The switch_mm() code checks for 
> whether we ran out of them to restart the counting. This ASID 
> roll-over event needs to be broadcast to the other CPUs and issuing 
> IPIs with the IRQs disabled isn't always safe. Of course, we could 
> briefly re-enable them at the ASID roll-over time but I'm not sure 
> what the expectations of the code calling switch_mm() are.

The expectations are to have irqs off (we are holding the runqueue 
lock if !__ARCH_WANT_INTERRUPTS_ON_CTXSW), so that's not workable i 
suspect.

But in theory we could drop the rq lock and restart the scheduler 
task-pick and balancing sequence when the ARM TLB tag rolls over. So 
instead of this fragile and assymetric method we'd have a 
straightforward retry-in-rare-cases method.

That means some modifications to switch_mm() but should be solvable.

That would make ARM special only in so far that it's one of the few 
architectures that signal 'retry task pickup' via switch_mm() - it 
would use the stock scheduler otherwise and we could remove 
__ARCH_WANT_INTERRUPTS_ON_CTXSW and perhaps even 
__ARCH_WANT_UNLOCKED_CTXSW altogether.

I'd suggest doing this once modern ARM chips get so widespread that 
you can realistically induce a ~700 usecs irqs-off delays on old, 
virtual-cache ARM chips. Old chips would likely use old kernels 
anyway, right?

Thanks,

	Ingo
