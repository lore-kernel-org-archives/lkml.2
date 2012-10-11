Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab2JKVIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:08:11 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58870 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758876Ab2JKVIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:08:06 -0400
Date: Thu, 11 Oct 2012 13:21:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RCU NOHZ, tsc, and clock_gettime
Message-ID: <20121011202103.GB2476@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5077157A.7060401@redhat.com>
 <50772350.1070903@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50772350.1070903@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101121-7408-0000-0000-00000946F2DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 12:51:44PM -0700, John Stultz wrote:
> On 10/11/2012 11:52 AM, Prarit Bhargava wrote:
> >I've been tracking an odd bug that may involve the RCU NOHZ code and
> >just want to know if you have any ideas on debugging and/or what might be
> >wrong.  Note the bug happens on *BOTH* upstream and the current RHEL6 tree.
> >The data in this email is from running on RHEL6 because that's what I happen
> >to be running ATM.  The result, however, is _identical_ to that of linux.git
> >latest.
> >
> >The attached program compares userspace TSC reads to the time returned from
> >the REALTIME_CLOCK[1].  The test does the following
> >
> >read tsc1
> >get REALTIME_CLOCK value
> >read tsc2
> >
> >and then does a comparison between the tsc read and the REALTIME_CLOCK value
> >to see if they are in sync with each other.
> >
> >[I'm leaving out the guts of the analysis here.  It is sufficient to show
> >examples of "good" data and "bad" data IMO.]
> >
> >On a good run, we see little variance in between the values:
> >
> >     0   144       0.1
> >     1   138       1.8
> >     2   147      -2.9
> [snip]
> >    29   144      -0.6
> >n: 30, slope: 0.50 (1.99 GHz), dev: 1.1 ns, max: 2.9 ns
> >
> >
> >On a bad run, there is a lot of variance between the values:
> >
> >     0   144    -346.0
> >     1   138    1410.8
> >     2   138    -806.9
> >     3   141    4006.6
> >     4   147   -3996.1
> [snip]
> >    29   141     -50.3
> >n: 30, slope: 0.50 (1.99 GHz), dev: 1231.4 ns, max: 4006.6 ns
> 
> 
> Do you see the same noisy variance when instead of doing:
>     rdtsc()
>     clock_gettime()
>     rdtsc()
> 
> you do:
>     clock_gettime()
>     clock_gettime()
> 
> And calculate the delta of the timestamp results?
> 
> Also does this behavior change if you select different clocksources
> on the system?
> 
> >It was noted by the bug reporter that specifying "nohz=off" resolved the
> >problem.  I tested with "nohz=off" and AFAICT it fixes the issue.  I started
> >out debugging by assuming that delays in the c-state transitions were not being
> >properly accounted for in the timing calculations.
> >
> >I ran a baseline test on an unmodified kernel (with no extra boot options) and
> >confirmed that powertop shows the CPUs entering deep c-states while the test was
> >running for 300 runs.
> >
> >I then instrumented the PM QoS and the power management code (specifically
> >cpuidle).  I put in a large # of printk's to monitor the CPU transitions, and
> >monitored the power states via powertop in order to verify that the system was
> >behaving correctly wrt PM QoS.
> >
> >If you modify the tstsc script to run 300 times with this modified kernel, and
> >run powertop in the middle of the script, you will see that the processors do
> >NOT enter deep c-states.  **This means that PM QoS is doing its job correctly**.
> 
> So its not clear here,  do you see the same noisier latencies when
> using PM QoS to limit deep c-states?
> 
> Finally, how many cpus are on the machine you see this with?  Does
> the effect go away with maxcpus=1?

Also, what is the value of NR_CPUS?  And exactly which kernel.org kernel
are you using?

The effect of removing the two functions you noted (on 3.6 and earlier)
is to prevent RCU from checking for dyntick-idle CPUs, likely incurring
a cache miss for each CPU with interrupts disabled.  If you have a lot
of CPUs (or even if NR_CPUS is large and you have a smaller number of
CPUs), this can result in user-space-visible delays.

							Thanx, Paul

> It looks like the TSC clocksource is being used, just because the
> latencies are so low, but Is the same clocksource being used in all
> of these cases?
> 
> One possibility is that if the cpu we're doing our timekeeping
> accumulation on is different then the one running the test, we might
> go into deeper idle for longer periods of time. Then when we
> accumulate time, we have more then a single tick to accumulate and
> that might require holding the timekeeper/xtime lock for longer
> times.
> 
> And the max 2.9ns variance seems particularly low, given that we do
> call update_vsyscall every so often, and that should block
> clock_gettime() callers while we update the vsyscall data.  Could it
> be that the test is too short to see the locking effect, so you're
> just getting lucky, and that adding nohz is jostling the regularity
> of the execution so you then see the lock wait times?  If you
> increase the samples and sample loops by 1000 does that change the
> behavior?
> 
> thanks
> -john

