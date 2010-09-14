Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab0INC1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 22:27:16 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49611 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752295Ab0INC1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 22:27:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+uWnUxFICuWiBmPJN+fzQ5NIJigl2Dl6tFJCamIN
	KcKpxHCtgGyCYe
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1284393215.2275.383.camel@laptop>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop>
	 <20100912203712.GD32327@Krystal>  <1284382387.2275.265.camel@laptop>
	 <1284383758.2275.283.camel@laptop>
	 <1284386179.10436.6.camel@marge.simson.net>
	 <1284393215.2275.383.camel@laptop>
Content-Type: text/plain
Date: Tue, 14 Sep 2010 04:27:39 +0200
Message-Id: <1284431259.7386.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 17:53 +0200, Peter Zijlstra wrote:
> On Mon, 2010-09-13 at 15:56 +0200, Mike Galbraith wrote:
> > > One option is to simply get rid of that stuff in check_preempt_tick()
> > > and instead do a wakeup-preempt check on the leftmost task instead.
> > 
> > That's what I wanted to boil it down to instead of putting the extra
> > preempt check in, but it kills the longish slices of low load.  IIRC,
> > when I tried that, it demolished throughput. 
> 
> Hrm.. yes it would..
> 
> So the reason for all this:
> 
>         /*
>          * Ensure that a task that missed wakeup preemption by a
>          * narrow margin doesn't have to wait for a full slice.
>          * This also mitigates buddy induced latencies under load.
>          */
> 
> Is to avoid tasks getting too far ahead in virtual time due to buddies,
> right?

Yeah, that was the thought anyway.

> Would something like the below work? Don't actually use delta_exec to
> filter, but use wakeup_gran + min_gran on virtual time, (much like Steve
> suggested) and then verify using __sched_gran().
> 
> Or have I now totally confused myself backwards?
> 
>  - delta_exec is walltime, and should thus we compared against a
>    weighted unit like slice,
>  - delta is a vruntime unit, and is thus weight free, hence we can use
>    granularity/unweighted units.

I don't think it really matters.  Distance is weighted when using slice
as the measure.

	-Mike

