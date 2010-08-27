Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0H0Pni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:43:38 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60713 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751792Ab0H0Png (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:43:36 -0400
Date: Fri, 27 Aug 2010 11:43:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
Message-ID: <20100827154334.GE14926@Krystal>
References: <20100826180908.648103531@efficios.com> <1282849045.1975.1587.camel@laptop> <20100826234910.GB4194@Krystal> <1282894960.1975.1666.camel@laptop> <1282897192.7185.28.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282897192.7185.28.camel@marge.simson.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:31:16 up 216 days, 18:08,  4 users,  load average: 0.16, 0.08,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith (efault@gmx.de) wrote:
> On Fri, 2010-08-27 at 09:42 +0200, Peter Zijlstra wrote:
> > On Thu, 2010-08-26 at 19:49 -0400, Mathieu Desnoyers wrote:
> > > AFAIK, I don't think we would end up starving the system in any possible way.
> > 
> > Correct, it does maintain fairness.
> > 
> > > So far I cannot see a situation where selecting the next buddy would _not_ make
> > > sense in any kind of input-driven wakeups (interactive, timer, disk, network,
> > > etc). But maybe it's just a lack of imagination on my part. 
> > 
> > The risk is that you end up with always using next-buddy, and we tried
> > that a while back and that didn't work well for some, Mike might
> > remember.
> 
> I turned it off because it was ripping spread apart badly, and last
> buddy did a better job of improving scalability without it.

Maybe with the dyn min_vruntime feature proposed in this patchset we should
reconsider this. Spread being ripped apart is exactly what it addresses.

> 
> > Also, when you use timers things like time-outs you really couldn't care
> > less if its handled sooner rather than later.

Maybe we could have a timer delay threshold under which we consider the wakeup
to be "short" or "long". e.g. a timer firing every ms is very likely to need its
wakups to proceed quickly, but if the timer fires every hours, we could not care
less.

> > 
> > Disk is usually so slow you really don't want to consider it
> > interactive, but then sometimes you might,.. its a really hard problem.
> 
> (very hard)
> 
> > The only clear situation is the direct input, that's a direct link
> > between the user and our wakeup chain and the user is always important.
> 
> Yeah, directly linked wakeups using next could be a good thing, but the
> trouble with using any linkage to the user is that you have to pass it
> on to reap benefit.. so when do you disconnect?

What we do here is that we pass it on across wakeups, but not across wakups of
new threads (so it's not passed across forks). However, AFAIU, this only
generates a bias that will select the wakeup target as next buddy IIF it is
within a certain range from the leftmost entity. The disconnect is done (setting
se.interactive to 0) on a per-thread basis when they go to sleep.

I've seen some version of Peter's patches which were decrementing a counter as
the token is passed across a wakeup, but I did not find it necessary so far.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
