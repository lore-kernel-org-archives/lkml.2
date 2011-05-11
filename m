Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab1EKVva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:51:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51605 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815Ab1EKVv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:51:29 -0400
Date: Wed, 11 May 2011 23:51:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
Message-ID: <20110511215111.GA16355@elte.hu>
References: <1304713252.25414.2532.camel@gandalf.stny.rr.com>
 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
 <20110507065803.GA23414@elte.hu>
 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
 <20110507144402.GC2859@elte.hu>
 <1304788829.11129.57.camel@frodo>
 <20110507190033.GA11465@elte.hu>
 <1304996847.2969.151.camel@frodo>
 <20110510084158.GC27426@elte.hu>
 <1305032797.2943.34.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305032797.2943.34.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> [root@bxf perf]# ~/bin/perf record -a -e 'syscalls:*'
> 
>   Error: sys_perf_event_open() syscall returned with 24 (Too many open files).  /bin/dmesg may provide additional information.
> 
>   Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

Yeah, this is a known bug, have you seen Peter's patch that addresses this?

People who run into this bug will go the way of least resistence: not fix it 
and use ftrace. This is sadly how 'splitting a small pond into two' tends to 
work out in practice: both halves stink a little bit more than they would if 
they were kept together ;-)

This is why lttng as a separate project within the kernel was and is a bad idea 
IMO.

I think this further strengthens the idea that we should join stuff and not 
keep it split!

> > I really meant it when i told you that perf events were the natural next 
> > step after ftrace, in the evolution of Linux tracing/instrumentation.
> 
> I know you meant that, but I don't see nor feel it myself. [...]

My position is very simple: right now we have two tracing tools while for many 
years we (including you!) always worked hard to have unified infrastructure.

For years ftrace was maintained and pushed upstream optimistically on the 
assumption that we are reasonable people who can agree on technical solutions 
objectively.

My technical point, at its core, is even simpler:

 - If the ftrace UI/API/ABI design is better then perf can be migrated to it 
   and we can use the ftrace APIs to do more tooling goodness.
   Everyone will be happy.

 - If the perf UI/API/ABI design is better then ftrace can be migrated to it
   and we can use the perf APIs to do more tooling goodness.
   Everyone will be happy.

 - If we do neither we will have continued tooling badness, tooling pain and
   kernel-churn-without-a-clear-purpose. I will be sad.

Call me an egoist but i do not like being sad, i'd like to see one of the 
options implemented where everyone is happy! :-)

So we could really have a dedicated tracing tool that can do what ftrace and 
perf trace can do and much more. I fully expect that it would have an ftrace 
work-alike workflow.

What we do not want is the current nightmare-ish design and schizm that we have 
two different tracers and two different APIs trying to do the same thing 
really. And that's been going on for two and a half years and counting and i do 
not see much progress there so i'm getting worried about it ...

> [...] Maybe I'm mistaken but I don't have the belief that I can just jump on 
> faith into perf and abandon all the work of current ftrace. But I'm happy to 
> help unify the kernel infrastructure. That is the important part.

Well, nobody suggests any extreme of immediately 'throwing away everything', 
especially as there's no clear replacement, why would we want to do that?

But at least having a very specific *idea* how to bring the two tracing tools 
together quickly, and doing the first steps towards that, after a painful 
period of 2.5 years, looks pretty essential to me.

I'd like to see the tracing pond grow, not fragment. Shrinking it by 10% to 90% 
in the first step would still be much better if it can then have the focus and 
clarity to grow to 300% or more - opposed to splitting it into two 50% parts 
and see both halves rot in their own unique ways! :-)

> > Why not use the correctly designed tracing approach and enhance it, and 
> > merge all the remaining useful bits of ftrace into it?
> 
> The problem we have is that we disagree on what a correctly designed tracing 
> approach is. Tracing is one of those things that everyone has a different 
> idea of what is important. As you stated, you do not care about 4 bytes in an 
> event. If you have 4 million events that is 4 million bytes. A typical event 
> size could be 20 bytes, that 4 bytes is 1/5th of the event that is wasted 
> space.

Well, look at the context:

 - In the context of useful tools like PowerTop, which is driving *tons* of 
   useful new code upstream, 4 bytes is very little cost. It strongly filters 
   events to not be too intrusive to the system to begin with.

 - In the context of perf record/report, which easily receives millions of
   events, 4 bytes is still not measurable overhead.

 - In the context of tracing workflows where you generate hundreds of millions
   of events in a short timespan and store the stream as-is as gigabytes of
   data, 4 bytes is probably measurable overhead.

So yes, there are definitely contexts/niches where 4 bytes are probably 
measurable, but if weighted against the regression of *PowerTop* the cost is 
negligible and it's not even a question which way we want to lean.

Also note that regardless of how tracing will look like in two years time, the 
no regressions policy will always have *way* higher priority than any 
micro-cost concerns.

Note that we are in fact are happy that applications use us, we are *happy* 
that they do indeed *break* if we didnt continue to do the goodness that we are 
doing today.

Consider the alternative: if we did things that no app and no developer is 
interested in. It would just not matter to anyone. We could break it freely, 
nobody would give a damn.

So i really prefer the 'apps are using us' situation we are in today, and not 
breaking them is a *small* price to pay and it is a very small loss of the near 
infinite degrees of development freedom we still enjoy in the kernel.

Also note that IMO there is no long-term technical problem really: i agree with 
you that we can eventually get rid of the 4 bytes bkl field as well, if all 
affected apps migrate to libperf.so in an orderly fashion.

Thanks,

	Ingo
