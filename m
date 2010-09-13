Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0IMOQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:16:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39897 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0IMOQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:16:48 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100913135621.GA13442@Krystal>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop>
	 <20100912203712.GD32327@Krystal> <1284382387.2275.265.camel@laptop>
	 <1284383758.2275.283.camel@laptop>  <20100913135621.GA13442@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 16:16:38 +0200
Message-ID: <1284387398.2275.311.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 09:56 -0400, Mathieu Desnoyers wrote:
> 
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

Of course we would. But the same is true for -5 and 5 threads together.

> >  static void
> >  check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> >  {
> > -     unsigned long ideal_runtime, delta_exec;
> > +     unsigned long slice = sched_slice(cfs_rq, curr);
> 
> So you still compute the sched_slice(), based on sched_period(), based on
> sysctl_sched_min_granularity *= nr_running when there are more than nr_latency
> running threads.

What's wrong with that? I keep asking you, you keep not giving an
answer. Stop focussing on nr_latency, its an by produce not a
fundamental entity.

 period := max(latency, min_gran * nr_running)

See, no nr_latency -- the one and only purpose of nr_latency is avoiding
that multiplication when possible.


> > -     if (delta_exec < sysctl_sched_min_granularity)
> > -             return;
> 
> Well, the reason why this test is here seems to be that we don't want to trigger
> "resched_task" more often than needed, and here it's defined by the granularity.

Right, but its wrong for the weighted case. Letting a light task run
that long will make its latency suck.

> I don't quite see with what you are replacing this, other than "let's set the
> resched flag all the time to save a 32-bit division". I figure out it's more
> expensive the call the scheduler than to do a 32-bit div.

The more divs we put it, the more expensive it all becomes.


