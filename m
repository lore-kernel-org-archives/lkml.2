Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab0LEQWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 11:22:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46367 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab0LEQWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 11:22:17 -0500
Date: Sun, 5 Dec 2010 16:21:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
Message-ID: <20101205162151.GH9138@n2100.arm.linux.org.uk>
References: <19697.8378.717761.236202@pilspetsen.it.uu.se> <19707.34405.791777.298955@pilspetsen.it.uu.se> <20101205131702.GE9138@n2100.arm.linux.org.uk> <20101205141921.GF9138@n2100.arm.linux.org.uk> <19707.47304.977978.297596@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19707.47304.977978.297596@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 05, 2010 at 05:07:36PM +0100, Mikael Pettersson wrote:
> I ran two tests on my iop32x machine:
> 
> 1. Made the above-mentioned assignment to rq->clock_task unconditional.
>    That cured the interactivity regressions.
> 
> 2. Restored the conditional assignment to rq->clock_task and disabled the
>    platform-specific sched_clock() so the kernel used the generic one.
>    That too cured the interactivity regressions.
> 
> I then repeated these tests on my ixp4xx machine, with the same results.
> 
> I'll try to come up with a fix for the ixp4xx and plat-iop 32-bit
> sched_clock()s.

I'm not sure that's the correct fix - it looks like sched_clock_cpu()
should already be preventing scheduler clock time going backwards.

Hmm. IOP32x seems to have a 32-bit timer clocked at 200MHz.  That means
it wraps once every 21s.  However, we have that converted to ns by an
unknown multiplier and shift.  It seems that those are chosen to
guarantee that we will cover only 4s without wrapping in the clocksource
conversion.  Maybe that's not sufficient?

Could you try looking into sched_clock_cpu(), sched_clock_local() and
sched_clock() to see whether anything odd stands out?
