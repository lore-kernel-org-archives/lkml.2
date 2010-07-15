Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab0GOEmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 00:42:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34746 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab0GOEmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 00:42:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 01/11] x86: Fix vtime/file timestamp inconsistencies
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1279162015.3372.61.camel@localhost>
References: <20100715101317.CB56.A69D9226@jp.fujitsu.com> <1279162015.3372.61.camel@localhost>
Message-Id: <20100715134058.B8F1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Jul 2010 13:41:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2010-07-15 at 10:51 +0900, KOSAKI Motohiro wrote:
> > > On Wed, 2010-07-14 at 11:40 +0900, KOSAKI Motohiro wrote:
> > > > Hi
> > > > 
> > > > > Due to vtime calling vgettimeofday(), its possible that an application
> > > > > could call  time();create("stuff",O_RDRW);  only to see the file's
> > > > > creation timestamp to be before the value returned by time.
> > > > 
> > > > Just dumb question.
> > > > 
> > > > Almost application are using gettimeofday() instead time(). It mean
> > > > your fix don't solve almost application.
> > > 
> > > Correct,  filesystem timestamps and gettimeofday can still seem
> > > inconsistently ordered. But that is expected.
> > > 
> > > Because of granularity differences (one interface is only tick
> > > resolution, the other is clocksource resolution), we can't interleave
> > > the two interfaces (time and gettimeofday, respectively) and expect to
> > > get ordered results.
> > 
> > hmmm...
> > Yes, times() vs gettimeofday() mekes no sense. nobody want this. but
> > I don't understand why we can ignore gettimeofday() vs file-tiemstamp.
> 
> 
> So, just to be clear, this discussion is really around the question of
> "Why don't filesystems use a clocksource-granular (ie: getnstimeofday())
> timestamps instead of tick-granular (ie current_kernel_time())
> timestamps."
> 
> However, this is *not* what the patch that started this thread was
> about. In the patch I'm simply fixing an inconsistency in the vtime
> interface, where it does not align with what the syscall-time interface
> provides. 
> 
> The issue was noticed via inconsistencies with filesystem timestamps,
> but the patch does not change anything to do with filesystem timestamp
> behavior.

Ah, I see. This patch is unrelated to filesystem timestamp. It fix inconsistency
vsyscall with syscall. 

I agree that it should be fixed. So yes, other parts of my mail is a bit offtopic.


> > > This is why the fix I'm proposing is important: Filesystem timestamps
> > > have always been tick granular, so when vtime() was made clocksource
> > > granular (by using vgettime internally) we broke the historic
> > > expectation that the time() interface could be interleaved with
> > > filesystem operations.
> > > 
> > > Side note: For full nanosecond resolution of the tick-granular
> > > timestamps, check out the clock_gettime(CLOCK_REALTIME_COARSE, ...)
> > > interface.
> > > 
> > > 
> > > > So, Why can't we fix vgettimeofday() vs create() inconsistency?
> > > > This is just question, I don't intend to disagree you.
> > > 
> > > The only way to make gettimeofday and create consistent is to use
> > > gettimeofday clocksource resolution timestamps for files. This however
> > > would potentially cause a large performance hit, since each every file
> > > timestamp would require a possibly expensive read of the clocksource.
> > 
> > Why clocksource() reading is so slow? the implementation of current
> > tsc clocksource ->read method is here.
> > 
> > 
> > 	static cycle_t read_tsc(struct clocksource *cs)
> > 	{
> > 	        cycle_t ret = (cycle_t)get_cycles();
> > 	
> > 	        return ret >= clocksource_tsc.cycle_last ?
> > 	                ret : clocksource_tsc.cycle_last;
> > 	}
> > 
> > It mean, the difference is almost only one rdtsc.
> 
> Sure, for hardware that can use the TSC clocksource, it is fairly cheap,
> however there are numerous systems that cannot use the TSC (or
> architectures that don't have a fast TSC like counter) and in those
> cases a read can take more then a microsecond.

I'm not timekeeping expert. but my first impression is, if clocksource->read
need more than a microsecond, it's really problematic. ->read of such clocksource
should always return 0 instead honestly reading h/w counter.

>
> Even with the TSC, the multiplication required to convert to nanoseconds
> adds extra overhead that isn't seen when using the pre-calculated
> tick-granular current_kernel_time() value.
> 
> It may not seem like much, but with filesystems each small delay adds
> up. 
> 
> I'm not a filesystems guy, and maybe there are some filesystems that
> really want very fine-grained timestamps. If so they can consider
> switching from using current_kernel_time() to getnstimeofday(). But due
> to the likely performance impact, its not something I'd suggest doing.

Again, I'm not against you. I only would like to hear what you propose. because
I'm not sure rough granularity time() vsyscall really makes userland happy.
because (again) as far as iknow, alomsot applications don't use time().

So, I worry about more big issue remained.




