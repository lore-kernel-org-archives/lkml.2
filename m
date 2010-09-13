Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab0IMOoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:44:18 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:34604 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751434Ab0IMOoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:44:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18DPsJsNc4D7hn87+ih1vDEoncJXdtG1ifkg6lhpS
	RoZ3cPmZ2I7UlP
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Mike Galbraith <efault@gmx.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <20100913135621.GA13442@Krystal>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop>
	 <20100912203712.GD32327@Krystal> <1284382387.2275.265.camel@laptop>
	 <1284383758.2275.283.camel@laptop>  <20100913135621.GA13442@Krystal>
Content-Type: text/plain
Date: Mon, 13 Sep 2010 16:44:38 +0200
Message-Id: <1284389078.10436.40.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 09:56 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:

> > One option is to simply get rid of that stuff in check_preempt_tick()
> > and instead do a wakeup-preempt check on the leftmost task instead.
> > 
> > The code as it stands today does that delta_exec < min_gran check to
> > ensure current gets some runtime before doing that second preemption
> > check, which compares vruntime with a wall-time measure.
> > 
> > Making that gran more complex doesn't really buy us much because for a
> > system with different weights in the gran and slice lengths don't match
> > up anyway.
> 
> So I bet this last sentence is about the example of a system with many nice 19
> processes I told you about on IRC. Yes, this one is a bummer, as we would not
> like to count them as running threads at all.

Tick doesn't help much with nice 19, tick is much larger than slice, so
barring wakeup preemption, nice 19 tasks should _slam_ right when the
tick finally arrives.

> >  	/*
> > -	 * Ensure that a task that missed wakeup preemption by a
> > -	 * narrow margin doesn't have to wait for a full slice.
> > -	 * This also mitigates buddy induced latencies under load.
> > +	 * The current task ran long enough, ensure it doesn't get
> > +	 * re-elected due to buddy favours.
> >  	 */
> > -	if (!sched_feat(WAKEUP_PREEMPT))
> > -		return;
> > -
> > -	if (delta_exec < sysctl_sched_min_granularity)
> > -		return;
> 
> Well, the reason why this test is here seems to be that we don't want to trigger
> "resched_task" more often than needed...

Yeah.  Heavily niced tasks would usually be booted before we got this
far because of small slices, just making sure to not evict some first
class citizen _too_ soon while trying to reduce latency a bit.  If a
heavily niced task slips through, oh darn, but it did before too.

	-Mike

