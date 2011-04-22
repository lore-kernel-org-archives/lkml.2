Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1DVUbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 16:31:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51121 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418Ab1DVUas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 16:30:48 -0400
Date: Fri, 22 Apr 2011 22:30:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: arun@sharma-home.net
Cc: Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110422203022.GA20573@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422165007.GA18401@vps.sharma-home.net>
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


* arun@sharma-home.net <arun@sharma-home.net> wrote:

> On Fri, Apr 22, 2011 at 12:52:11PM +0200, Ingo Molnar wrote:
> > 
> > Using the generalized cache events i can run:
> > 
> >  $ perf stat --repeat 10 -e cycles:u -e instructions:u -e l1-dcache-loads:u -e l1-dcache-load-misses:u ./array
> > 
> >  Performance counter stats for './array' (10 runs):
> > 
> >          6,719,130 cycles:u                   ( +-   0.662% )
> >          5,084,792 instructions:u           #      0.757 IPC     ( +-   0.000% )
> >          1,037,032 l1-dcache-loads:u          ( +-   0.009% )
> >          1,003,604 l1-dcache-load-misses:u    ( +-   0.003% )
> > 
> >         0.003802098  seconds time elapsed   ( +-  13.395% )
> > 
> > I consider that this is 'bad', because for almost every dcache-load there's a 
> > dcache-miss - a 99% L1 cache miss rate!
> 
> One could argue that all you need is cycles and instructions. [...]

Yes, and note that with instructions events we even have skid-less PEBS 
profiling so seeing the precise .

> [...] If there is an expensive load, you'll see that the load instruction 
> takes many cycles and you can infer that it's a cache miss.
> 
> Questions app developers typically ask me:
> 
> * If I fix all my top 5 L3 misses how much faster will my app go?

This has come up: we could add a 'stalled/idle-cycles' generic event - i.e. 
cycles spent without performing useful work in the pipelines. (Resource-stall 
events on Intel CPUs.)

Then you would profile L3 misses (there's a generic event for that), plus 
stalls, and the answer to your question would be the percentage of hits you get 
in the stalled-cycles profile, multiplied by the stalled-cycles/cycles ratio.

> * Am I bottlenecked on memory bandwidth?

This would be a variant of the measurement above: say the top 90% of L3 misses 
profile-correlated with stalled-cycles, relative to total-cycles. If you get 
'90% of L3 misses cause a 1% wall-time slowdown' then you are not memory 
bottlenecked. If the answer is '35% slowdown' then you are memory bottlenecked.

> * I have 4 L3 misses every 1000 instructions and 15 branch mispredicts per
>   1000 instructions. Which one should I focus on?

AFAICS this would be another variant of stalled-cycles measurements: you create 
a stalled-cycles profile and check whether the top hits are branches or memory 
loads.

> It's hard to answer some of these without access to all events.

I'm curious, how would you measure these properties - do you have some 
different events in mind?

> While your approach of having generic events for commonly used counters might 
> be useful for some use cases, I don't see why exposing all vendor defined 
> events is harmful.
> 
> A clear statement on the last point would be helpful.

Well, the thing is, i think users are helped most if we add useful, highlevel 
PMU features added and not just an opaque raw event pass-through engine. The 
problem with lowlevel raw ABIs is that the tool space fragments into a zillion 
small hacks and there's no good concentration of know-how. I'd like the art of 
performance measurement to be generalized out, as well as it can be.

We had this discussion in the big perf-counters flamewars 2+ years ago, where 
one side wanted raw events, while we wanted intelligent kernel-side 
abstractions and generalizations. I think the abstraction and generalization 
angle worked out very well in practice - but we are having this discussion 
again and again :-)

As i stated it in my prior mails, i'm not against raw events as a rare 
exception channel - that increases utility. I'm against what was attempted 
here: an extension to raw events as the *primary* channel for DRAM measurement 
features. That is just sloppy and *reduces* utility.

I'm very simple-minded: when i see reduced utility i become sad :)

Thanks,

	Ingo
