Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab0GOBvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 21:51:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38014 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125Ab0GOBvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 21:51:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 01/11] x86: Fix vtime/file timestamp inconsistencies
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1279124344.1831.13.camel@work-vm>
References: <20100714113527.EA8A.A69D9226@jp.fujitsu.com> <1279124344.1831.13.camel@work-vm>
Message-Id: <20100715101317.CB56.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Jul 2010 10:51:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2010-07-14 at 11:40 +0900, KOSAKI Motohiro wrote:
> > Hi
> > 
> > > Due to vtime calling vgettimeofday(), its possible that an application
> > > could call  time();create("stuff",O_RDRW);  only to see the file's
> > > creation timestamp to be before the value returned by time.
> > 
> > Just dumb question.
> > 
> > Almost application are using gettimeofday() instead time(). It mean
> > your fix don't solve almost application.
> 
> Correct,  filesystem timestamps and gettimeofday can still seem
> inconsistently ordered. But that is expected.
> 
> Because of granularity differences (one interface is only tick
> resolution, the other is clocksource resolution), we can't interleave
> the two interfaces (time and gettimeofday, respectively) and expect to
> get ordered results.

hmmm...
Yes, times() vs gettimeofday() mekes no sense. nobody want this. but
I don't understand why we can ignore gettimeofday() vs file-tiemstamp.


> This is why the fix I'm proposing is important: Filesystem timestamps
> have always been tick granular, so when vtime() was made clocksource
> granular (by using vgettime internally) we broke the historic
> expectation that the time() interface could be interleaved with
> filesystem operations.
> 
> Side note: For full nanosecond resolution of the tick-granular
> timestamps, check out the clock_gettime(CLOCK_REALTIME_COARSE, ...)
> interface.
> 
> 
> > So, Why can't we fix vgettimeofday() vs create() inconsistency?
> > This is just question, I don't intend to disagree you.
> 
> The only way to make gettimeofday and create consistent is to use
> gettimeofday clocksource resolution timestamps for files. This however
> would potentially cause a large performance hit, since each every file
> timestamp would require a possibly expensive read of the clocksource.

Why clocksource() reading is so slow? the implementation of current
tsc clocksource ->read method is here.


	static cycle_t read_tsc(struct clocksource *cs)
	{
	        cycle_t ret = (cycle_t)get_cycles();
	
	        return ret >= clocksource_tsc.cycle_last ?
	                ret : clocksource_tsc.cycle_last;
	}

It mean, the difference is almost only one rdtsc.
And, now we have RELATIME. then crazy atime frequently updating issue
has been solved.

Can you please elaborate your worry? I think I haven't get which case
you worry.

Thanks.


