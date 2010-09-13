Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0IMU4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:56:31 -0400
Received: from mail.openrapids.net ([64.15.138.104]:54779 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751018Ab0IMU4b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:56:31 -0400
Date: Mon, 13 Sep 2010 16:56:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
	nr_running
Message-ID: <20100913205628.GA21385@Krystal>
References: <20100911173732.551632040@efficios.com> <20100911174003.051303123@efficios.com> <20100912061452.GA3383@elte.hu> <1284276098.9111.24.camel@marge.simson.net> <20100912181626.GB32327@Krystal> <1284351183.7321.36.camel@marge.simson.net> <20100913064153.GB14728@elte.hu> <20100913201913.GC28294@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20100913201913.GC28294@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:54:58 up 233 days, 23:31,  3 users,  load average: 0.31, 0.13,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> * Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > On Sun, 2010-09-12 at 14:16 -0400, Mathieu Desnoyers wrote:
> > 
> > > > Or am I missing your point ?
> > > 
> > > Yes and no.  I'm pondering the parent, but by the same token, the 
> > > vfork child shouldn't be penalized either.
> > > 
> > > Does your latency go down drastically if you turn START_DEBIT off? 
> > > Seems like it should.  Perhaps START_DEBIT should not start a task 
> > > further right than rightmost.  I've done that before.
> > > 
> > > maximum latency: 19221.5 탎
> > > average latency: 5159.0 탎
> > > missed timer events: 0
> > > 
> > > maximum latency: 43901.0 탎
> > > average latency: 8430.1 탎
> > > missed timer events: 0
> > > 
> > > Turning it off here cut latency roughly in half (i've piddled vfork 
> > > though, but not completely).  Limiting child placement to no further 
> > > right than rightmost should help quite a bit.
> > 
> > Very interesting observation. Mathieu, mind testing Mike's suggestion 
> > with wakeup-latency.c?
> 
> Sure. this is with the smaller min_granularity:
> 
> With START_DEBIT:
> 
> maximum latency: 21111.1 탎
> average latency: 4188.2 탎
> missed timer events: 0
> 
> Without:
> 
> maximum latency: 6670.2 탎
> average latency: 1586.0 탎
> missed timer events: 0
> 
> So yes, as expected, it makes a huge difference. This is because SIGEV_THREAD
> creates a new thread each time the timer fires, and newly created tasks are put
> at the end of the runqueue with START_DEBIT.
> 
> However, removing START_DEBIT makes my Xorg feel less responsive (again, just my
> own impression). We might need a more suitable way to deal with forks than just
> putting the newly forked task at the end of the spread, but just putting it at
> the beginning of the spread does not seem to do well neither.
> 
> One idea: we could temporarily tweak the nice value of both the parent and the
> child after a fork to a lower nice value, but only apply this for their first
> slice after the fork. The goal behind this is that their respective vruntime
> will increment faster in the first slice after the fork, so a fork bomb
> (worse-case) will end up running with a very very low nice level. With this
> measure in place, START_DEBIT might not be needed. Thoughts ?

A small note: Steven made me realize that when I say "low nice level" here, I
actually mean "high nice values". Less is more when we talk about nice levels.

Thanks,

Mathieu

> 
> Thanks,
> 
> Mathieu
> 
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
