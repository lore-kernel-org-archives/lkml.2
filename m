Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1H2PAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:00:37 -0400
Received: from relay2.sgi.com ([192.48.179.30]:49424 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753579Ab1H2PAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:00:36 -0400
Date: Mon, 29 Aug 2011 10:04:44 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Reduce clock calibration time during slave cpu
	startup
Message-ID: <20110829150444.GA6116@sgi.com>
References: <20110727135730.GA17717@sgi.com> <20110826165634.398b0d2e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826165634.398b0d2e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 04:56:34PM -0700, Andrew Morton wrote:
> On Wed, 27 Jul 2011 08:57:31 -0500
> Jack Steiner <steiner@sgi.com> wrote:
> 
> > Reduce the startup time for slave cpus.
> > 
> > This patch adds hooks for an arch-specific function for clock calibration.
> > These hooks are used on x86. They assume all cores in a physical socket
> > run at the same core speed. If a newly started cpu has the same phys_proc_id
> > as a core already active, use the already-calculated value of loops_per_jiffy.
> > 
> > This patch reduces the time required to start slave cpus on a 4096 cpu
> > system from:
> > 	465 sec  OLD
> > 	 62 sec NEW
> 
> Eight minutes is just stupid.

Agree. I'd like to reduce that. It currently takes about 65 minutes to
boot a 4096p system with a reasonable sized IO config (a big part
of the boot time is IO dependent). Reducing by 8 min is a good improvement
but we still have more to do. Calibration is one of larger contributors
to boot times.


> 
> 100ms/cpu is just stupid too.  What's the CPU doing?  Spinning around
> counting ticks?  That's parallelizable.

The time is spent in the clock calibration code. It unfortunately takes a while
to calibrate to a high degree of accuracy.

Ingo was concerned that trying to calibrate in parallel would introduce error.

	Running calibration in parallel is pretty stupid: cores/threads might
	impact each other and there might be a lot of avoidable noise in the
	results.

	Thanks, Ingo



> 
> > This reduces boot time on a 4096p system by almost 7 minutes.  Nice...
> > 
> > 
> > Signed-off-by: Jack Steiner <steiner@sgi.com>
> > 
> > 
> > ---
> > Note: patch assumes that all multi-core x86 processor sockets have the same
> > clock frequency for all cores. AFAIK, this is true & will continue
> > to be true for a long time. Have I overlooked anything???
> 
> Well, Andi thinks this may become untrue relatively soon.  Then what do
> we do?

I posted a V3 version of the patch that eliminates this assumption. The new version
skip recalibration of cores within a socket only if the delay loop uses the TSC
and for CONSTANT_TSC for the cores within the socket.

So far, I have not received any feedback. The patch is at:

	http://marc.info/?l=linux-kernel&m=131309367414891&w=2

I'll resend again.


> 
> >  /*
> > + * Check if another cpu is in the same socket and has already been calibrated.
> > + * If found, use the previous value. This assumes all cores in the same physical
> > + * socket have the same core frequency.
> > + */
> > +unsigned long __cpuinit calibrate_delay_is_known(void)
> > +{
> > +	int i, cpu = smp_processor_id();
> > +
> > +	for_each_online_cpu(i)
> > +		if (cpu_data(i).phys_proc_id == cpu_data(cpu).phys_proc_id)
> 
> This will always match when `i' reaches `cpu'.  Or is this cpu not
> online at this time?

Correct - not online.


> 
> > +			return cpu_data(i).loops_per_jiffy;
> > +	return 0;
> > +}
> > +
> > +/*
> >   * Activate a secondary processor.
> >   */
> >  notrace static void __cpuinit start_secondary(void *unused)
> > Index: linux/init/calibrate.c
> > ===================================================================
> > --- linux.orig/init/calibrate.c	2011-07-26 08:01:15.571979739 -0500
> > +++ linux/init/calibrate.c	2011-07-27 08:39:35.691983745 -0500
> > @@ -243,6 +243,20 @@ recalibrate:
> >  	return lpj;
> >  }
> >  
> > +/*
> > + * Check if cpu calibration delay is already known. For example,
> > + * some processors with multi-core sockets may have all sockets
> > + * use the same core frequency. It is not necessary to calibrate
> > + * each core.
> > + *
> > + * Architectures should override this function if a faster calibration
> > + * method is available.
> > + */
> > +unsigned long __attribute__((weak)) __cpuinit calibrate_delay_is_known(void)
> 
> __weak
> 
> > +{
> > +	return 0;
> > +}
> > +
> >  void __cpuinit calibrate_delay(void)
> >  {
> >  	unsigned long lpj;
> > @@ -257,6 +271,8 @@ void __cpuinit calibrate_delay(void)
> >  		lpj = lpj_fine;
> >  		pr_info("Calibrating delay loop (skipped), "
> >  			"value calculated using timer frequency.. ");
> > +	} else if ((lpj = calibrate_delay_is_known())) {
> > +		;
> >  	} else if ((lpj = calibrate_delay_direct()) != 0) {
> >  		if (!printed)
> >  			pr_info("Calibrating delay using timer "
