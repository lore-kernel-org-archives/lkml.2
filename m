Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1E2Jvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 05:51:47 -0400
Received: from service87.mimecast.com ([94.185.240.25]:40630 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750915Ab1E2Jvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 05:51:45 -0400
Date: Sun, 29 May 2011 10:51:34 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
Message-ID: <20110529095134.GB9489@e102109-lin.cambridge.arm.com>
References: <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
 <1306405979.1200.63.camel@twins>
 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
 <1306409575.1200.71.camel@twins>
 <1306412511.1200.90.camel@twins>
 <20110526122623.GA11875@elte.hu>
 <20110526123137.GG24876@n2100.arm.linux.org.uk>
 <20110526125007.GA27083@elte.hu>
 <BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com>
 <20110527120629.GA32617@elte.hu>
MIME-Version: 1.0
In-Reply-To: <20110527120629.GA32617@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 May 2011 09:51:57.0038 (UTC) FILETIME=[0C25A8E0:01CC1DE6]
X-MC-Unique: 111052910514100401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 01:06:29PM +0100, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > How much time does that take on contemporary ARM hardware,
> > > typically (and worst-case)?
> >
> > On newer ARMv6 and ARMv7 hardware, we no longer flush the caches at
> > context switch as we got VIPT (or PIPT-like) caches.
> >
> > But modern ARM processors use something called ASID to tag the TLB
> > entries and we are limited to 256. The switch_mm() code checks for
> > whether we ran out of them to restart the counting. This ASID
> > roll-over event needs to be broadcast to the other CPUs and issuing
> > IPIs with the IRQs disabled isn't always safe. Of course, we could
> > briefly re-enable them at the ASID roll-over time but I'm not sure
> > what the expectations of the code calling switch_mm() are.
> 
> The expectations are to have irqs off (we are holding the runqueue
> lock if !__ARCH_WANT_INTERRUPTS_ON_CTXSW), so that's not workable i
> suspect.
> 
> But in theory we could drop the rq lock and restart the scheduler
> task-pick and balancing sequence when the ARM TLB tag rolls over. So
> instead of this fragile and assymetric method we'd have a
> straightforward retry-in-rare-cases method.

During switch_mm(), we check whether the task being scheduled in has an
old ASID and acquire a lock for a global ASID variable. If two CPUs do
the context switching at the same time, one of them would get stuck on
cpu_asid_lock. If on the other CPU we get an ASID roll-over, we have to
broadcast it to the other CPUs via IPI. But one of the other CPUs is
stuck on cpu_asid_lock with interrupts disabled and we get a deadlock.

An option could be to drop cpu_asid_lock and use some atomic operations
for the global ASID tracking variable but it needs some thinking. The
ASID tag requirements are that it should be unique across all the CPUs
in the system and two threads sharing the same mm must have the same
ASID (hence the IPI to the other CPUs).

Maybe Russell's idea to move the page table setting outside in some post
task-switch hook would be easier to implement.

-- 
Catalin

