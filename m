Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab1HOLTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 07:19:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59897 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736Ab1HOLTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 07:19:52 -0400
Date: Mon, 15 Aug 2011 12:18:50 +0100
From: Will Deacon <will.deacon@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sam wang <linux.swang@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] perf: ARMv7 wrong "branches" generalized instruction
Message-ID: <20110815111850.GA23077@e102144-lin.cambridge.arm.com>
References: <alpine.DEB.2.00.1108101328440.22769@cl320.eecs.utk.edu>
 <20110810183306.GA32695@e102144-lin.cambridge.arm.com>
 <alpine.DEB.2.00.1108101452510.25186@cl320.eecs.utk.edu>
 <20110810220727.GA5270@e102144-lin.cambridge.arm.com>
 <20110811081525.GA3802@elte.hu>
 <20110811091658.GB25103@e102144-lin.cambridge.arm.com>
 <20110812103426.GA32262@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812103426.GA32262@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Sorry the delayed response, I was away this weekend.

On Fri, Aug 12, 2011 at 11:34:26AM +0100, Ingo Molnar wrote:
> So can we agree that cycles, instructions and branches are fine on
> ARM?

Cycles are easy and should work everywhere. Instructions aren't portable
between CPUs, but we've established that's ok.

Branches are a bit more tricky since most of the time we can only count
taken branches. The set of branch events we have on ARM present the same
problem as the cache events in that you really need to combine them to get
something meaningful back. For example, A15 can count:

0x10 Mispredicted or not predicted branch speculatively executed
0x12 Predictable branch speculatively executed

0x76 Branch speculatively executed - Immediate branch
0x78 Branch speculatively executed - Procedure return
0x79 Branch speculatively executed - Indirect branch

So you can use 0x10/0x12 to get a handle on the misprediction rate.
The other events may be useful for establishing the distribution of branch
types [and you could add them all up to get a rough figure on the number of
branches].

A9 can do:

0x10 Mispredicted or not predicted branch speculatively executed
0x12 Predictable branch speculatively executed

0x0C Instruction architecturally executed, condition code check pass,
     software change of the PC
0x0D Instruction architecturally executed, immediate branch

0x6E Predictable function returns

Note that we can't count indirect branch instructions.

> If there's no 'references' event on that CPU then there's several
> solutions would could do.
> 
> Firstly, we could extend:
> 
> enum perf_hw_cache_op_result_id {
>         PERF_COUNT_HW_CACHE_RESULT_ACCESS       = 0,
>         PERF_COUNT_HW_CACHE_RESULT_MISS         = 1,
> 
>         PERF_COUNT_HW_CACHE_RESULT_MAX,         /* non-ABI */
> };
> 
> with a third, RESULT_HIT variant, and the architecture could fill in
> whichever events it can count. User-space could then request all
> three and do the trivial arithmetics when one of them is missing as
> 'not counted'.

If you're not opposed to extending the ABI events with (arguably redundant)
additional events, then I'm more than happy with this approach.

> Secondly, we could let the kernel do the arithmetics: when 'accesses'
> and 'misses' are requested, the kernel could start a 'hits' and
> 'misses' event and do the addition internally. This couples the
> events though, in a way not visible to user-space, which might
> complicate things.
> 
> A third variant would be a variation of the second solution: to
> create a standalone 'compound' event by running two hw events (hits
> and misses), when user-space requests 'references'.

The problem with these two solutions it that the compound event may not always
be as simple as a single addition. You may need a number of events to plug
into an arbitrary expression in order to achieve something that relates back
to the programmer's model.

> > > That is not what Linux interfaces are about in my opinion.
> >
> > I completely agree with you on avoiding these interfaces in
> > general. However, the ARM event numbers aren't under NDA and even
> > if we could put them in the kernel, there's no way of communicating
> > that to the user because the events don't match up well with what
> > the ABI expects.
> 
> Well, can you see other problems beyond the hits/misses/references
> problem? I think we can solve that one.

There's the branches issue I've highlighted above. We also can't normally
distinguish between read and write misses for caches and TLBs so we report
the combined total for each, meaning that they're always the same. Finally,
our L2 cache may be off-chip and so we have to plug it in as a separate PMU
rather than include it in the CPU cache map (this leads back to the entirely
separate discussion about how to interface the perf tool with multiple PMUs).

> > For example, an event that may be useful on A15 is:
> >
> >   0x6d: Exclusive instruction speculatively executed - STREX pass
> >
> >   (this could be used for investigating lock contention)
> >
> > yet users are currently forced to use a raw event for this anyway.
> > This is fine for the more esoteric events like
> >
> >   0x40: Counts the number of Java bytecodes being decoded, including
> >         speculative ones.
> >
> > where only a select few will care about it.
> 
> We could certainly extend the number of generic events. What are
> 'exclusive instructions' on ARM - ones that do atomic operations?

Yes, they're used for atomic sections of code where you don't want another
CPU to modify a variable on which you're operating and tend to be used for
the cmpxchg part of spinlocks. Multi-core CPUs have events to report back
the STREX_PASS and STREX_FAIL (somebody stomped on my variable so I have to
repeat the `transaction') so you can get an indication of lock contention.

> With any generalization, there will be a somewhat fuzzy boundary
> between events that are best kept raw and events that are worth
> generalizing. So the fact that you can find esoteric sounding but
> useful events that probably only apply to ARM does not invalidate the
> general idea of abstracting out cross-CPU concepts.

Ok, but I think that for some events on some CPUs it may be better to say
OP_UNSUPPORTED rather than mislead the user if the approximation is too poor
(c.f. cache references from earlier on).

> I personally would rather err on the side of generalizing too many
> than too few events:
> 
> - If a given event cannot be expressed on a CPU model then that's not
>   a big problem: it literally does not exist on that CPU and nothing
>   we can do will create it out of thin air. It will remain obscure
>   and we can live with that.

Agreed.

> - But if a useful event is only accessible via the raw ABI, and it
>   turns out to be present on other CPUs as well and tools would like
>   to make use of it, then it would be actively harmful if tools used
>   the raw ABI. If generalized it can be used more widely.

Sure and that way it becomes a named event which gets rid of the horrible
hex.

> > > So what you and Vince are suggesting, to dumb down the kernel
> > > parts of perf and force users into raw or microarchitecture
> > > specific events actually *reduces* the user-base very
> > > significantly - while in practice even just cycles, instructions
> > > and branches level analysis handles 99% of the everyday
> > > performance analysis needs ...
> >
> > No. I don't think that the kernel part should be dumbed down, nor
> > do I think that the user should have to play with hex numbers. I
> > just think that we should allow a way to communicate named
> > CPU-specific events to the user. We have userspace libraries that
> > do this, but if you want to avoid the OProfile mess then we could
> > look at putting this into the kernel (although I worry that these
> > tables will become large).
> 
> Size is not an issue.

Ok, I just don't want this to get viewed in the same light as the OMAP clock
data that Linus objected to.

> > So let's leave the common-case as a `best effort' attempt to match
> > the ABI events to whatever we have on the running CPU and come up
> > with a way to augment the set of named events provided by perf.
> 
> Correct - as long as 'best effort' is still statistically equivalent
> to the real, 'ideal' event.
> 
> For the specific cache hits/misses/references example you cited i
> think we need to do better than what we have currently: clearly we
> don't want 'references' to be a smaller integer value than 'misses'.

If you're happy to add the new ABI event, I'll update the ARM backend.

> > > We've also had numerous cases where kernel developers went way
> > > beyond those metrics and apprecitated that tooling would provide
> > > good approximations for all those events regardless of what CPU
> > > type the workload was running on (and sometimes even documented
> > > this in the changelog).
> > >
> > > So having generic events is not some fancy, unused property, but
> > > a pretty important measurement aspect of perf.
> >
> > Ok, but how can we expose the rest of the CPU events without using
> > raw events?
> 
> I think Corey sent a patch some time ago (a year ago?) that allowed
> CPU specific events to be defined by the kernel. I think it would be
> useful - i think we've generalized most of the core stuff that's
> worth generalizing so we can start populating the more esoteric
> tables as well.
> 
> These events could be used via some self-explanatory syntax, such as:
> 
>         -e cpu::instr_strex
> 
> or so - and would map to 0x6d on A9. Hm?

cpu::instr_strex_pass => 0x63
cpu::instr_strex_fail => 0x64

I would *really* like to see this in perf as I think it opens up a whole set
of useful events that are currently not being used as much as they could be.
Furthermore, the cpu:: qualification can tie back to a PMU instance, so our
L2 problems can be fixed with:

l2cc::evictions

for example (actually, I already have some hacks in place for this but it's
all at the hex level so that would look like rn:1 - event 0x1 on PMU 0xn).

I would also like to see this sort of syntax for software events, where you
can drill down into something like PERF_COUNT_SW_EMULATION_FAULTS to see
actually which groups of instructions are being emulated:

emulation_faults::fp

to count floating point emulation, for example.

Cheers,

Will
