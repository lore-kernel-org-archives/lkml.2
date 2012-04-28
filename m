Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2D1IFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 04:05:13 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45034 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2D1IFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 04:05:00 -0400
Date: Sat, 28 Apr 2012 10:04:45 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
Message-ID: <20120428080443.GA2241@netboy.at.omicron.at>
References: <cover.1335510125.git.richardcochran@gmail.com>
 <4F9B228F.90903@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9B228F.90903@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 03:49:51PM -0700, John Stultz wrote:
> On 04/27/2012 01:12 AM, Richard Cochran wrote:
> >* Benefits
> >   - Fixes the buggy, inconsistent time reporting surrounding a leap
> >     second event.
> Just to clarify this, so we've got the right scope on the problem,
> you're trying to address the fact that the leap second is not
> actually applied until the tick after the leap second, correct?

That is one problem, yes.
 
> Where basically you can see small offsets like:

I can synchronize over the network to under 100 nanoseconds, so to me,
one second is a large offset.

> And you're proposing we fix this by changing the leap-second
> processing from only being done at tick-time  (which isn't exactly
> on the second boundary)to being calculated for each getnstimeofday,
> correct?

Yes. We prodive UTC time on demand whenever an application (or kernel
thread) asks for it.

> >   - Opens the possibility of offering a rational time source to user
> >     space. [ Trivial to offer clock_gettime(CLOCK_TAI) for example. ]
> 
> CLOCK_TAI is something I'd like to have.

Me, too.

> My only concern is how we
> manage it along with possible smeared-leap-seconds ala:
> http://googleblog.blogspot.com/2011/09/time-technology-and-leaping-seconds.html
> 
> ( I shudder at the idea of managing two separate frequency
> corrections for different time domains).

Are you planning to implement that? This approach is by no means
universally accepted.

In my view, what Google is doing is hack (albeit a sensible for
business applications). For test and measurement or scientific
applications, it does not make sense to introduce artifical frequency
errors in this way.

Another variant of this idea: http://www.cl.cam.ac.uk/~mgk25/time/utc-sls/

Here is a nice quote from that page:

   All other objections to UTC-SLS that I heard were not directed
   against its specific design choices, but against the (very well
   established) practice of using UTC at all in the applications that
   this proposal targets:

   * Some people argue that operating system interfaces, such as the
     POSIX "seconds since the epoch" scale used in time_t APIs, should
     be changed from being an encoding of UTC to being an encoding of
     the leap-second free TAI timescale.

   * Some people want to go even further and abandon UTC and leap
     seconds entirely, detach all civilian time zones from the
     rotation of Earth, and redefine them purely based on atomic time.

   While these people are usually happy to agree that UTC-SLS is a
   sensible engineering solution as long as UTC remains the main time
   basis of distributed computing, they argue that this is just a
   workaround that will be obsolete once their grand vision of giving
   up UTC entirely has become true, and that it is therefore just an
   unwelcome distraction from their ultimate goal.

Until the whole world agrees to this "work around" I think we should
stick to current standards. If and when this practice becomes
standardized (I'm not holding my breath), then we could simply drop
the internal difference between the kernel time scale and UTC, and
steer out the leap second synchronously with the rest of the world.

> >* Performance Impacts
> >** con
> >    - Small extra cost when reading the time (one integer addition plus
> >      one integer test).
> This may not be so small when it comes to folks who are very
> concerned about the clock_gettime hotpath.

If you would support the option to only insert leap seconds, then the
cost is one integer addition and one integer test.

Also, once we have a rational time interface (like CLOCK_TAI), then
time sensitive will want to use that instead anyhow.

> Further, the correction will be needed to be made in the vsyscall
> paths, which isn't done with your current patchset (causing userland
> to see different time values then what kernel space calculates).

Do you mean __current_kernel_time? What did I miss?

> One possible thing to consider? Since the TIME_OOP flag is only
> visible via the adjtimex() interface, maybe it alone should have the
> extra overhead of the conditional?

This would mean that you would have to do the conditional somehow
backwards in order to provide TAI time values. To me, the logical way
is to keep a continuous time scale, and then compute UTC from it.

> I'm not excited about the
> gettimeofday field returned by adjtimex not matching what
> gettimeofday actually provides for that single-tick interval, but
> maybe its a reasonable middle ground?

Not sure what you mean, but to me it is not acceptable to deliver
inconsistent time values to userspace!

> >** pro
> >    - Removes repetitive, periodic division (secs % 86400 == 0) the whole
> >      day long preceding a leap second.
> >    - Cost of maintaining leap second status goes to the user of the
> >      NTP adjtimex() interface, if any.
> Not sure I follow this last point. How are we pushing this
> maintenance to adjtimex() users?

Only adjtimex calls timekeeper_gettod_status, where the leap second is
calculated, outside of timekeeper.lock, on the NTP user space's kernel
time.

In current Linux, the modulus is done in update_wall_time and
logarithmic_accumulation, on kernel time.

> >* Todo
> >   - The function __current_kernel_time accesses the time variables
> >     without taking the lock. I can't figure that out.
> >
> There's a few cases where we want the current second value when we
> already hold the xtime_lock, or we might possibly hold the
> xtime_lock. Its an special internal interface for special users
> (update_vsyscall, for example).

What about kdb_summary?

Thanks,
Richard
