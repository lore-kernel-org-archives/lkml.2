Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0LHM42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 07:56:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48284 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab0LHM41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 07:56:27 -0500
Date: Wed, 8 Dec 2010 12:55:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Venkatesh Pallipadi <venki@google.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
Message-ID: <20101208125548.GA9777@n2100.arm.linux.org.uk>
References: <19697.8378.717761.236202@pilspetsen.it.uu.se> <19707.34405.791777.298955@pilspetsen.it.uu.se> <20101205131702.GE9138@n2100.arm.linux.org.uk> <20101205141921.GF9138@n2100.arm.linux.org.uk> <19707.47304.977978.297596@pilspetsen.it.uu.se> <20101205162151.GH9138@n2100.arm.linux.org.uk> <1291812015.28378.24.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291812015.28378.24.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 01:40:15PM +0100, Peter Zijlstra wrote:
> On Sun, 2010-12-05 at 16:21 +0000, Russell King - ARM Linux wrote:
> 
> > I'm not sure that's the correct fix - it looks like sched_clock_cpu()
> > should already be preventing scheduler clock time going backwards.
> > 
> > Hmm. IOP32x seems to have a 32-bit timer clocked at 200MHz.  That means
> > it wraps once every 21s.  However, we have that converted to ns by an
> > unknown multiplier and shift.  It seems that those are chosen to
> > guarantee that we will cover only 4s without wrapping in the clocksource
> > conversion.  Maybe that's not sufficient?
> > 
> > Could you try looking into sched_clock_cpu(), sched_clock_local() and
> > sched_clock() to see whether anything odd stands out?
> 
> # git grep HAVE_UNSTABLE_SCHED_CLOCK arch/arm | wc -l
> 0

Hmm, you're right.  In which case it's purely down to sched_clock()
only being able to cover 4s - which seems to be far too small a gap.

I'm not sure that the unstable sched clock stuff makes much sense to
be enabled - we don't have an unstable clock, we just don't have the
required number of bits for the scheduler to work correctly.

Nevertheless, this provides a good way to find this kind of wrap bug.
Even with cnt_32_to_63, we still don't get a 64-bit sched_clock(), so
this bug will still be there.  Even with a 64-bit clock, the bug will
still be there.  It's basically crap code.

Maybe it's better that on ARM, we just don't implement sched_clock()
at all?
