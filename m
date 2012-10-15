Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2JOO51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:57:27 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40153 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2JOO50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:57:26 -0400
Date: Mon, 15 Oct 2012 07:56:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: RCU NOHZ, tsc, and clock_gettime
Message-ID: <20121015145611.GA11024@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5077157A.7060401@redhat.com>
 <50772350.1070903@us.ibm.com>
 <20121011202103.GB2476@linux.vnet.ibm.com>
 <507839FC.3060204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507839FC.3060204@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101514-7282-0000-0000-00000DF1ADA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 11:40:44AM -0400, Prarit Bhargava wrote:
> On 10/11/2012 04:21 PM, Paul E. McKenney wrote:
> > On Thu, Oct 11, 2012 at 12:51:44PM -0700, John Stultz wrote:

[ . . . ]

> >> One possibility is that if the cpu we're doing our timekeeping
> >> accumulation on is different then the one running the test, we might
> >> go into deeper idle for longer periods of time. Then when we
> >> accumulate time, we have more then a single tick to accumulate and
> >> that might require holding the timekeeper/xtime lock for longer
> >> times.
> >>
> >> And the max 2.9ns variance seems particularly low, given that we do
> >> call update_vsyscall every so often, and that should block
> >> clock_gettime() callers while we update the vsyscall data.  Could it
> >> be that the test is too short to see the locking effect, so you're
> >> just getting lucky, and that adding nohz is jostling the regularity
> >> of the execution so you then see the lock wait times?  If you
> >> increase the samples and sample loops by 1000 does that change the
> >> behavior?
> 
> That's a possiblity, although I suspect that this has more to do with not
> executing the RCU NOHZ code given that we don't see a problem with the
> clock_gettime() vs clock_gettime() test.  I wonder if not executing the RCU NOHZ
> code somehow introduces a "regularity" with execution that results in the CPU
> always being in C0/polling when the test is run?

I don't know about regularity being caused by omitting those RCU
functions, but omitting them when CONFIG_NO_HZ=y can certainly result
in system hangs due to grace periods never completing.  It is also
not at all clear to me how RCU knows that your userspace code is using
clock_gettime() instead of the rdtsc instruction.

But it looks like you were collecting only 30 samples at 10 samples
per second.  It also looks like you are seeing deviations of a few
microseconds, which could easily be caused by any number of causes,
including scheduling-clock interrupts, device interrupts, any number
of IPIs, and who knows what all else.  Furthermore, it is quite likely
that your usleep() system calls are correlated with the scheduler-clock
interrupt, which would pretty much destroy any statistical significance
that your tests might otherwise have.

So for the time being, I have to assume that if you ran a test that
had a good chance of hitting a random sample of interrupts, then you
would see interrupt overhead on all of your tests.

							Thanx, Paul

