Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0IMLWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 07:22:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52173 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab0IMLWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 07:22:19 -0400
Date: Mon, 13 Sep 2010 13:22:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
Message-ID: <20100913112204.GA3011@elte.hu>
References: <20100911173732.551632040@efficios.com>
 <20100911174003.051303123@efficios.com>
 <1284231470.2251.52.camel@laptop>
 <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
 <1284237380.2251.56.camel@laptop>
 <AANLkTi=a91QX-FLURFWNsjbCS1bDLr6GqSpC4_uzm3ta@mail.gmail.com>
 <1284282392.2251.81.camel@laptop>
 <1284352547.7321.51.camel@marge.simson.net>
 <1284367295.2275.31.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284367295.2275.31.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0067]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2010-09-13 at 06:35 +0200, Mike Galbraith wrote:
> > On Sun, 2010-09-12 at 11:06 +0200, Peter Zijlstra wrote:
> > > On Sat, 2010-09-11 at 13:48 -0700, Linus Torvalds wrote:
> > 
> > > > And I don't like how you dismissed the measured latency improvement.
> > > > And yes, I do think latency matters. A _lot_.
> > > 
> > > OK, we'll make it better and sacrifice some throughput, can do, no
> > > problem.
> > 
> > I'm not seeing high wakeup latencies, even under hefty load.  
> > Mathieu's testcase is bad, but apparently solely due to START_DEBIT 
> > placement. That's kind of a sticky wicket.  I've shot it in the 
> > heart before, but regretted doing so when I looked at kbuild vs 
> > static load fairness.
> 
> Yeah, without it you can starve the already running task on massive 
> forks.
> 
> Still, I'm not quite sure why people really care about fork() on time 
> sensitive paths, its a very expensive thing to do, pre-fork() and wake 
> when you need it, is what I would say.

Right. So what happens in practice is that some desktop apps tend to be 
fork happy and it doesnt show up on low load so why not? The kernel 
forks plenty fast:

  aldebaran:~/l> ./lat_proc fork
  Process fork+exit: 165.9254 microseconds

So even a full-blown fork() is a drop in the ocean of desktop bloat. 
Firefox takes 100-300 msecs CPU time to process a single tab click ... 
it's insane.

fork() is also a very convenient and robust prgramming facility: COW 
gives us immutable data inheritance - match that thread programmers ...

Plus it's not just fork()s but also pthread_create() obviously - which 
is even faster.

So yes, it happens all the time, and if we create some bad latency of 
10-20 msecs under load (or more), it gets noticed - especially if it's 
some cumulative fork() chain of processing.

And no, we cannot rely on pre-forking - and we dont even _want_ to, 
fork() and pthread_create() is a perfectly valid facility. In the 
scheduler we have to handle fork()/pthread_create() smoothly.

Thanks,

	Ingo
