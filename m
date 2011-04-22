Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab1DVNTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 09:19:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53126 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab1DVNTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 09:19:08 -0400
Date: Fri, 22 Apr 2011 15:18:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
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
Message-ID: <20110422131846.GA20760@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <BANLkTinaZyHNV2Bm7CJFJ11WBCPGgsYijQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinaZyHNV2Bm7CJFJ11WBCPGgsYijQ@mail.gmail.com>
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


* Stephane Eranian <eranian@google.com> wrote:

> > Say i'm a developer and i have an app with such code:
> >
> > #define THOUSAND 1000
> >
> > static char array[THOUSAND][THOUSAND];
> >
> > int init_array(void)
> > {
> >        int i, j;
> >
> >        for (i = 0; i < THOUSAND; i++) {
> >                for (j = 0; j < THOUSAND; j++) {
> >                        array[j][i]++;
> >                }
> >        }
> >
> >        return 0;
> > }
> >
> > Pretty common stuff, right?
> >
> > Using the generalized cache events i can run:
> >
> >  $ perf stat --repeat 10 -e cycles:u -e instructions:u -e l1-dcache-loads:u -e l1-dcache-load-misses:u ./array
> >
> >  Performance counter stats for './array' (10 runs):
> >
> >         6,719,130 cycles:u                   ( +-   0.662% )
> >         5,084,792 instructions:u           #      0.757 IPC     ( +-   0.000% )
> >         1,037,032 l1-dcache-loads:u          ( +-   0.009% )
> >         1,003,604 l1-dcache-load-misses:u    ( +-   0.003% )
> >
> >        0.003802098  seconds time elapsed   ( +-  13.395% )
> >
> > I consider that this is 'bad', because for almost every dcache-load there's a
> > dcache-miss - a 99% L1 cache miss rate!
> >
> > Then i think a bit, notice something, apply this performance optimization:
>
> I don't think this example is really representative of the kind of problems 
> people face, it is just too small and obvious. [...]

Well, the overwhelming majority of performance problems are 'small and obvious' 
- once a tool roughly pinpoints their existence and location!

And you have not offered a counter example either so you have not really 
demonstrated what you consider a 'real' example and why you consider 
generalized cache events inadequate.

> [...] So I would not generalize on it.

To the contrary, it demonstrates the most fundamental concept of cache 
profiling: looking at the hits/misses ratios and identifying hotspots.

That concept can be applied pretty nicely to all sorts of applications.

Interestly, the exact hardware event doesnt even *matter* for most problems, as 
long as it *correlates* with the conceptual entity we want to measure.

So what we need are hardware events that correlate with:

 - loads done
 - stores done
 - load misses suffered
 - store misses suffered
 - branches done
 - branches missed
 - instructions executed

It is the *ratio* that matters in most cases: before-change versus 
after-change, hits versus misses, etc.

Yes, there will be imprecisions, CPU quirks, limitations and speculation 
effects - but as long as we keep our eyes on the ball, generalizations are 
useful for solving practical problems.

> If you are happy with generalized cache events then, as I said, I am fine 
> with it. But the API should ALWAYS allow users access to raw events when they 
> need finer grain analysis.

Well, that's a pretty far cry from calling it a 'myth' :-)

So my point is (outlined in detail in the common changelog) that we need sane 
generalized remote DRAM events *first* - before we think about exposing the 
'rest' of te offcore-PMU as raw events.

> > diff --git a/array.c b/array.c
> > index 4758d9a..d3f7037 100644
> > --- a/array.c
> > +++ b/array.c
> > @@ -9,7 +9,7 @@ int init_array(void)
> >
> >        for (i = 0; i < THOUSAND; i++) {
> >                for (j = 0; j < THOUSAND; j++) {
> > -                       array[j][i]++;
> > +                       array[i][j]++;
> >                }
> >        }
> >
> > I re-run perf-stat:
> >
> >  $ perf stat --repeat 10 -e cycles:u -e instructions:u -e l1-dcache-loads:u -e l1-dcache-load-misses:u ./array
> >
> >  Performance counter stats for './array' (10 runs):
> >
> >         2,395,407 cycles:u                   ( +-   0.365% )
> >         5,084,788 instructions:u           #      2.123 IPC     ( +-   0.000% )
> >         1,035,731 l1-dcache-loads:u          ( +-   0.006% )
> >             3,955 l1-dcache-load-misses:u    ( +-   4.872% )
> >
> >  - I got absolute numbers in the right ballpark figure: i got a million loads as
> >   expected (the array has 1 million elements), and 1 million cache-misses in
> >   the 'bad' case.
> >
> >  - I did not care which specific Intel CPU model this was running on
> >
> >  - I did not care about *any* microarchitectural details - i only knew it's a
> >   reasonably modern CPU with caching
> >
> >  - I did not care how i could get access to L1 load and miss events. The events
> >   were named obviously and it just worked.
> >
> > So no, kernel driven generalization and sane tooling is not at all a 'myth'
> > today, really.
> >
> > So this is the general direction in which we want to move on. If you know about
> > problems with existing generalization definitions then lets *fix* them, not
> > pretend that generalizations and sane workflows are impossible ...
>
> Again, to fix them, you need to give us definitions for what you expect those 
> events to count. Otherwise we cannot make forward progress.

No, we do not 'need' to give exact definitions. This whole topic is more 
analogous to physics than to mathematics. See my description above about how 
ratios and high level structure matters more than absolute values and 
definitions.

Yes, if we can then 'loads' and 'stores' should correspond to the number of 
loads a program flow does, which you get if you look at the assembly code. 
'Instructions' should correspond to the number of instructions executed.

If the CPU cannot do it it's not a huge deal in practice - we will cope and 
hopefully it will all be fixed in future CPU versions.

That having said, most CPUs i have access to get the fundamentals right, so 
it's not like we have huge problems in practice. Key CPU statistics are 
available.

> Let me give just one simple example: cycles
>
> What your definition for the generic cycle event?
> 
> There are various flavors:
>   - count halted, unhalted cycles?

Again i think you are getting lost in too much detail.

For typical developers halted versus unhalted is mostly an uninteresting 
distinction, as people tend to just type 'perf record ./myapp', which is per 
workload profiling so it excludes idle time. So it would give the same result 
to them regardless of whether it's halted or unhalted cycles.

( This simple example already shows the idiocy of the hardware names, calling 
  cycles events "CPU_CLK_UNHALTED.REF". In most cases the developer does *not*
  care about those distinctions so the defaults should not be complicated with
  them. )

>   - impacted by frequency scaling?

The best default for developers is a frequency scaling invariant result - i.e. 
one that is not against a reference clock but against the real CPU clock.

( Even that one will not be completely invariant due to the frequency-scaling
  dependent cost of misses and bus ops, etc. )

But profiling against a reference frequency makes sense as well, especially for 
system-wide profiling - this is the hardware equivalent of the cpu-clock / 
elapsed time metric. We could implement the cpu-clock using reference cycles 
events for example.

> LLC-misses:
>   - what considered the LLC?

The last level cache is whichever cache sits before DRAM.

>   - does it include code, data or both?

Both if possible as they tend to be unified caches anyway.

>   - does it include demand, hw prefetch?

Do you mean for the LLC-prefetch events? What would be your suggestion, which 
is the most useful metric? Prefetches are not directly done by program logic so 
this is borderline. We wanted to include them for completeness - and the metric 
should probably include 'all activities that program flow has not caused 
directly and which may be sucking up system resources' - i.e. including hw 
prefetch.

>   - it is to local or remote dram?

The current definitions should include both.

Measuring remote DRAM accesss is of course useful - that is the original point 
of this thread. It should be done as an additional layer, basically local RAM 
is yet another cache level - but we can take other generalized approach as 
well, if they make more sense.

Thanks,

	Ingo
