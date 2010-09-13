Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab0IMEMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 00:12:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:44496 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750744Ab0IMEMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 00:12:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX197YZNQQgF7uXKpMf5dfClEgb8LOp0TLIRdeCQ8f6
	J67Rq0Gy7bkXWu
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Mike Galbraith <efault@gmx.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <20100912181626.GB32327@Krystal>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <20100912061452.GA3383@elte.hu>
	 <1284276098.9111.24.camel@marge.simson.net>
	 <20100912181626.GB32327@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 06:13:03 +0200
Message-Id: <1284351183.7321.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-12 at 14:16 -0400, Mathieu Desnoyers wrote:
> * Mike Galbraith (efault@gmx.de) wrote:
> > On Sun, 2010-09-12 at 08:14 +0200, Ingo Molnar wrote:
> > > * Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > > 
> > > > (on a uniprocessor 2.0 GHz Pentium M)
> > > > 
> > > > * Without the patch:
> > > > 
> > > >  - wakeup-latency with SIGEV_THREAD in parallel with youtube video and
> > > >    make -j10
> > > > 
> > > > maximum latency: 50107.8 µs
> > > > average latency: 6609.2 µs
> > > > missed timer events: 0
> > > 
> > > I tried your patches on a similar UP system, using wakeup-latency.c. I 
> > > also measured the vanilla upstream kernel (cced86a) with the default 
> > > granularity settings, and also vanilla with a sched_min_granularity/3 
> > > tune (patch attached below for that).
> > > 
> > > I got the following results (make -j10 kbuild load, average of 3 runs):
> > > 
> > >  vanilla: 
> > > 
> > >   maximum latency: 38278.9 µs
> > >   average latency:  7730.1 µs
> > > 
> > >  mathieu-dyn:
> > > 
> > >   maximum latency: 28698.8 µs
> > >   average latency:  7757.1 µs
> > > 
> > >  peterz-min_gran/3:
> > > 
> > >   maximum latency: 22702.1 µs
> > >   average latency:  6684.8 µs
> > 
> > One thing that springs to mind with make is that it does vfork, so kinda
> > sorta continues running in drag, so shouldn't get credit for sleeping,
> > as that introduces bogus spread.  Post vfork parent notification time
> > adjustment may suffice, think I'll try that.
> 
> Hrm, I might be misunderstanding what you are saying here, but when a new
> process/thread is forked and woken up, we fall in the "initial" case of
> place_entity, so we increase the vruntime of a whole slice rather than getting
> credit for sleeping.
> 
> Or am I missing your point ?

Yes and no.  I'm pondering the parent, but by the same token, the vfork
child shouldn't be penalized either.

Does your latency go down drastically if you turn START_DEBIT off?
Seems like it should.  Perhaps START_DEBIT should not start a task
further right than rightmost.  I've done that before.

maximum latency: 19221.5 µs
average latency: 5159.0 µs
missed timer events: 0

maximum latency: 43901.0 µs
average latency: 8430.1 µs
missed timer events: 0

Turning it off here cut latency roughly in half (i've piddled vfork
though, but not completely).  Limiting child placement to no further
right than rightmost should help quite a bit.

	-Mike

