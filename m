Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0IMHIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 03:08:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39217 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752522Ab0IMHIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 03:08:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19e244wIAFe79bIiE8XK3KAIzlLIL6QV7hAkM8WNE
	XOvgrUpSHuRbP6
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <20100913064153.GB14728@elte.hu>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <20100912061452.GA3383@elte.hu>
	 <1284276098.9111.24.camel@marge.simson.net>
	 <20100912181626.GB32327@Krystal>
	 <1284351183.7321.36.camel@marge.simson.net>
	 <20100913064153.GB14728@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 09:08:36 +0200
Message-Id: <1284361716.25120.19.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 08:41 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Sun, 2010-09-12 at 14:16 -0400, Mathieu Desnoyers wrote:
> 
> > > Or am I missing your point ?
> > 
> > Yes and no.  I'm pondering the parent, but by the same token, the 
> > vfork child shouldn't be penalized either.
> > 
> > Does your latency go down drastically if you turn START_DEBIT off? 
> > Seems like it should.  Perhaps START_DEBIT should not start a task 
> > further right than rightmost.  I've done that before.
> > 
> > maximum latency: 19221.5 µs
> > average latency: 5159.0 µs
> > missed timer events: 0
> > 
> > maximum latency: 43901.0 µs
> > average latency: 8430.1 µs
> > missed timer events: 0
> > 
> > Turning it off here cut latency roughly in half (i've piddled vfork 
> > though, but not completely).  Limiting child placement to no further 
> > right than rightmost should help quite a bit.
> 
> Very interesting observation. Mathieu, mind testing Mike's suggestion 
> with wakeup-latency.c?

I'm sure it will.  I think the problem is that light thread forks, the
child takes vruntime hit, so the parent's lag isn't _useful_.  It may
preempt, but the work it's trying to get done is delayed massively
unfairly.

btw, setting parent's lag to that of the child on parent wakeup for the
vfork case seems to work fine, kbuild no longer gets the advantage it
would vs static load if START_DEBIT were disabled.  That leaves what to
do with plain old fork/clone though.  Leaving START_DEBIT in place for
fork/clone vs a fair vfork load blows chunks, as does running a forky
load vs some static load without START_DEBIT.

Sticky wicket.  We need a better fork fairness gizmo.

	-Mike

