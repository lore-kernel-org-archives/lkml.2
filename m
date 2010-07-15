Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab0GOCrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:47:00 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:46533 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab0GOCq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:46:59 -0400
Subject: Re: [PATCH 01/11] x86: Fix vtime/file timestamp inconsistencies
From: john stultz <johnstul@us.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20100715101317.CB56.A69D9226@jp.fujitsu.com>
References: <20100714113527.EA8A.A69D9226@jp.fujitsu.com>
	 <1279124344.1831.13.camel@work-vm>
	 <20100715101317.CB56.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 14 Jul 2010 19:46:55 -0700
Message-ID: <1279162015.3372.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 10:51 +0900, KOSAKI Motohiro wrote:
> > On Wed, 2010-07-14 at 11:40 +0900, KOSAKI Motohiro wrote:
> > > Hi
> > > 
> > > > Due to vtime calling vgettimeofday(), its possible that an application
> > > > could call  time();create("stuff",O_RDRW);  only to see the file's
> > > > creation timestamp to be before the value returned by time.
> > > 
> > > Just dumb question.
> > > 
> > > Almost application are using gettimeofday() instead time(). It mean
> > > your fix don't solve almost application.
> > 
> > Correct,  filesystem timestamps and gettimeofday can still seem
> > inconsistently ordered. But that is expected.
> > 
> > Because of granularity differences (one interface is only tick
> > resolution, the other is clocksource resolution), we can't interleave
> > the two interfaces (time and gettimeofday, respectively) and expect to
> > get ordered results.
> 
> hmmm...
> Yes, times() vs gettimeofday() mekes no sense. nobody want this. but
> I don't understand why we can ignore gettimeofday() vs file-tiemstamp.


So, just to be clear, this discussion is really around the question of
"Why don't filesystems use a clocksource-granular (ie: getnstimeofday())
timestamps instead of tick-granular (ie current_kernel_time())
timestamps."

However, this is *not* what the patch that started this thread was
about. In the patch I'm simply fixing an inconsistency in the vtime
interface, where it does not align with what the syscall-time interface
provides. 

The issue was noticed via inconsistencies with filesystem timestamps,
but the patch does not change anything to do with filesystem timestamp
behavior.


> > This is why the fix I'm proposing is important: Filesystem timestamps
> > have always been tick granular, so when vtime() was made clocksource
> > granular (by using vgettime internally) we broke the historic
> > expectation that the time() interface could be interleaved with
> > filesystem operations.
> > 
> > Side note: For full nanosecond resolution of the tick-granular
> > timestamps, check out the clock_gettime(CLOCK_REALTIME_COARSE, ...)
> > interface.
> > 
> > 
> > > So, Why can't we fix vgettimeofday() vs create() inconsistency?
> > > This is just question, I don't intend to disagree you.
> > 
> > The only way to make gettimeofday and create consistent is to use
> > gettimeofday clocksource resolution timestamps for files. This however
> > would potentially cause a large performance hit, since each every file
> > timestamp would require a possibly expensive read of the clocksource.
> 
> Why clocksource() reading is so slow? the implementation of current
> tsc clocksource ->read method is here.
> 
> 
> 	static cycle_t read_tsc(struct clocksource *cs)
> 	{
> 	        cycle_t ret = (cycle_t)get_cycles();
> 	
> 	        return ret >= clocksource_tsc.cycle_last ?
> 	                ret : clocksource_tsc.cycle_last;
> 	}
> 
> It mean, the difference is almost only one rdtsc.

Sure, for hardware that can use the TSC clocksource, it is fairly cheap,
however there are numerous systems that cannot use the TSC (or
architectures that don't have a fast TSC like counter) and in those
cases a read can take more then a microsecond.

Even with the TSC, the multiplication required to convert to nanoseconds
adds extra overhead that isn't seen when using the pre-calculated
tick-granular current_kernel_time() value.

It may not seem like much, but with filesystems each small delay adds
up. 

I'm not a filesystems guy, and maybe there are some filesystems that
really want very fine-grained timestamps. If so they can consider
switching from using current_kernel_time() to getnstimeofday(). But due
to the likely performance impact, its not something I'd suggest doing.

thanks
-john


