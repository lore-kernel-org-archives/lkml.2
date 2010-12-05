Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab0LEOTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 09:19:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52185 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab0LEOTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 09:19:42 -0500
Date: Sun, 5 Dec 2010 14:19:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>, Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
Message-ID: <20101205141921.GF9138@n2100.arm.linux.org.uk>
References: <19697.8378.717761.236202@pilspetsen.it.uu.se> <19707.34405.791777.298955@pilspetsen.it.uu.se> <20101205131702.GE9138@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101205131702.GE9138@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 05, 2010 at 01:17:02PM +0000, Russell King - ARM Linux wrote:
> On Sun, Dec 05, 2010 at 01:32:37PM +0100, Mikael Pettersson wrote:
> > Mikael Pettersson writes:
> >  > The scenario is that I do a remote login to an ARM build server,
> >  > use screen to start a sub-shell, in that shell start a largish
> >  > compile job, detach from that screen, and from the original login
> >  > shell I occasionally monitor the compile job with top or ps or
> >  > by attaching to the screen.
> >  > 
> >  > With kernels 2.6.37-rc2 and -rc3 this causes the machine to become
> >  > very sluggish: top takes forever to start, once started it shows no
> >  > activity from the compile job (it's as if it's sleeping on a lock),
> >  > and ps also takes forever and shows no activity from the compile job.
> >  > 
> >  > Rebooting into 2.6.36 eliminates these issues.
> >  > 
> >  > I do pretty much the same thing (remote login -> screen -> compile job)
> >  > on other archs, but so far I've only seen the 2.6.37-rc misbehaviour
> >  > on ARM EABI, specifically on an IOP n2100. (I have access to other ARM
> >  > sub-archs, but haven't had time to test 2.6.37-rc on them yet.)
> >  > 
> >  > Has anyone else seen this? Any ideas about the cause?
> > 
> > (Re-followup since I just realised my previous followups were to Rafael's
> > regressions mailbot rather than the original thread.)
> > 
> > > The bug is still present in 2.6.37-rc4.  I'm currently trying to bisect it.
> > 
> > git bisect identified
> > 
> > [305e6835e05513406fa12820e40e4a8ecb63743c] sched: Do not account irq time to current task
> > 
> > as the cause of this regression.  Reverting it from 2.6.37-rc4 (requires some
> > hackery due to subsequent changes in the same area) restores sane behaviour.
> > 
> > The original patch submission talks about irq-heavy scenarios.  My case is the
> > exact opposite: UP, !PREEMPT, NO_HZ, very low irq rate, essentially 100% CPU
> > bound in userspace but expected to schedule quickly when needed (e.g. running
> > top or ps or just hitting CR in one shell while another runs a compile job).
> > 
> > I've reproduced the misbehaviour with 2.6.37-rc4 on ARM/mach-iop32x and
> > ARM/mach-ixp4xx, but ARM/mach-kirkwood does not misbehave, and other archs
> > (x86 SMP, SPARC64 UP and SMP, PowerPC32 UP, Alpha UP) also do not misbehave.
> > 
> > So it looks like an ARM-only issue, possibly depending on platform specifics.
> > 
> > One difference I noticed between my Kirkwood machine and my ixp4xx and iop32x
> > machines is that even though all have CONFIG_NO_HZ=y, the timer irq rate is
> > much higher on Kirkwood, even when the machine is idle.
> 
> The above patch you point out is fundamentally broken.
> 
> +               rq->clock = sched_clock_cpu(cpu);
> +               irq_time = irq_time_cpu(cpu);
> +               if (rq->clock - irq_time > rq->clock_task)
> +                       rq->clock_task = rq->clock - irq_time;
> 
> This means that we will only update rq->clock_task if it is smaller than
> rq->clock.  So, eventually over time, rq->clock_task becomes the maximum
> value that rq->clock can ever be.  Or in other words, the maximum value
> of sched_clock_cpu().
> 
> Once that has been reached, although rq->clock will wrap back to zero,
> rq->clock_task will not, and so (I think) task execution time accounting
> effectively stops dead.
> 
> I guess this hasn't been noticed on x86 as they have a 64-bit sched_clock,
> and so need to wait a long time for this to be noticed.  However, on ARM
> where we tend to have 32-bit counters feeding sched_clock(), this value
> will wrap far sooner.

I'm not so sure about this - certainly that if() statement looks very
suspicious above.  As irq_time_cpu() will always be zero, can you try
removing the conditional?

In any case, sched_clock_cpu() should be resilient against sched_clock()
wrapping.  However, your comments about it being iop32x and ixp4xx
(both of which are 32-bit-counter-to-ns based implementations) and
kirkwood being a 32-bit-extended-to-63-bit-counter-to-ns implementation
does make me wonder...
