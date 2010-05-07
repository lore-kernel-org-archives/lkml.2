Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab0EGGGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 02:06:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:39650 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab0EGGGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 02:06:23 -0400
Subject: Re: [PATCH/RFC] mutex: Fix optimistic spinning vs. BKL
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tony Breeds <tonyb@au1.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100507053023.GF8069@nowhere>
References: <1272429513.24542.83.camel@pasglop>
	 <201004281406.04080.arnd@arndb.de> <1272494121.24542.113.camel@pasglop>
	 <20100507042010.GR12389@ozlabs.org>  <20100507053023.GF8069@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 16:01:56 +1000
Message-ID: <1273212116.4861.61.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 07:30 +0200, Frederic Weisbecker wrote:
> 
> 
> I like the safeguard against the bkl, it looks indeed like something
> we should have in .34
> 
> But I really don't like the timeout.

And I hate not having it :-)

> This is going to make the things even worse if we have another cause
> of deadlock by hiding the worst part of the consequences without
> actually solving the problem.

Yes and no. There's two reasons why the timeout is good. One is the
safeguard part and it's arguable whether it helps hiding bugs or not,
but there are very real cases where I believe we should get out and go
to sleep as well that aren't bugs.

IE. If the mutex owner is running for a long time and nobody is
contending on your CPU, you're simply not going to hit the
need_resched() test. That means you will spin, which means you will suck
a lot more power as well, not counting the potentially bad effect on
rebalance, load average etc...

There's also the fact that 2 CPUs or more trying to obtain it at once
may all go into spinning, which can lead to interesting results in term
of power consumption (and cpu_relax doesn't help that much).

I really don't think it's a good idea to turns mutex into potential
multi-jiffies spinning things like that.

> And since the induced latency or deadlock won't be easily visible
> anymore, we'll miss there is a problem. So we are going to spin for
> two jiffies and only someone doing specific latency measurements will
> notice, if he's lucky enough to meet the bug.

Well, the thing is that it may not be a bug.

The thing is that the actual livelock with the BKL should really only
happen with the BKL since that's the only thing we have that allows for
AB->BA semantics. Anything else should hopefully be caught by lockdep.

So I don't think there's that much to fear about hidden bugs.

But I -also- don't see the point of spinning potentially for a very long
time instead of going to sleep and saving power. The adaptive spinning
goal is to have an opportunistic optimization based on the idea that the
mutex is likely to be held for a very short period of time by its owner
and nobody's waiting for it yet. Ending up doing multi-jiffies spins
just doesn't fit in that picture. In fact, I was tempted to make the
timeout a lot shorter but decided against calling into clock sources
etc... and instead kept it simple with jiffies.

> Moreover that adds some unnessary (small) overhead in this path.

Uh ? So ? This is the contended path where we are .. spinning :-) The
overhead of reading jiffies and comparing here is simply never going to
show on any measurement I bet you :-)

> May be can we have it as a debugging option, something that would
> be part of lockdep, which would require CONFIG_DEBUG_MUTEX to
> support mutex adaptive spinning.

No, what I would potentially add as part of lockdep however is a way to
instrument how often we get out of the spin via the timeout. That might
be a useful information to figure out some of those runaway code path,
but they may well happen for very legit reasons and aren't a bug per-se.

> A debugging option that could just dump the held locks and the
> current one if we spin for an excessive timeslice.

Ben.


