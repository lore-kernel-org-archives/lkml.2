Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1HLKf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 06:35:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57870 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab1HLKfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 06:35:55 -0400
Date: Fri, 12 Aug 2011 12:34:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Will Deacon <will.deacon@arm.com>
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
Message-ID: <20110812103426.GA32262@elte.hu>
References: <alpine.DEB.2.00.1108101328440.22769@cl320.eecs.utk.edu>
 <20110810183306.GA32695@e102144-lin.cambridge.arm.com>
 <alpine.DEB.2.00.1108101452510.25186@cl320.eecs.utk.edu>
 <20110810220727.GA5270@e102144-lin.cambridge.arm.com>
 <20110811081525.GA3802@elte.hu>
 <20110811091658.GB25103@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110811091658.GB25103@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Will Deacon <will.deacon@arm.com> wrote:

> Hi Ingo,
> 
> Thanks for your input on this.
> 
> On Thu, Aug 11, 2011 at 09:15:25AM +0100, Ingo Molnar wrote:
> > 
> > * Will Deacon <will.deacon@arm.com> wrote:
> > 
> > > [...] From what I've seen of perf users on ARM, they start with the 
> > > ABI events, get some nonsensical results and then switch 
> > > exclusively to raw events from then on.
> > 
> > Could you give a specific example of such nonsensical output on ARM? 
> > Bugs should be fixed and yes i can that see if ARM produces 
> > nonsencial output then people won't use that nonsensical output 
> > (duh). Please fix or improve the nonsensical output.
> 
> Sure. On Cortex-A9 I see this:
> 
> 
> Performance counter stats for 'ls':
> 
>               2862 cache-references
>              20658 cache-misses              #  721.803 % of all cache refs

Well, you said 'instructions' in your mail:

>> Right, but as I say, `instructions' on one core might not be 
>> `instructions' on another core. Just removing the ABI types from 
>> ARM will at least stop people using them. [...]

So can we agree that cycles, instructions and branches are fine on 
ARM?

Even discounting hits/misses/references restrictions that you are 
running into, cache events are approximate on x86 too - most PMUs 
have random restrictions on what can be measured and what not - the 
cache access critical path gate count is not something you want to 
lengthen with much PMU complexity ...

>        0.019123136 seconds time elapsed
> 
> This is because we're actually reporting cache hits for 
> cache-references in an attempt to provide something remotely 
> similar. I agree that this is broken, which is why I'm leaning 
> towards a more liberal use of HW_OP_UNSUPPORTED.

If there's no 'references' event on that CPU then there's several 
solutions would could do.

Firstly, we could extend:

enum perf_hw_cache_op_result_id {
        PERF_COUNT_HW_CACHE_RESULT_ACCESS       = 0,
        PERF_COUNT_HW_CACHE_RESULT_MISS         = 1,

        PERF_COUNT_HW_CACHE_RESULT_MAX,         /* non-ABI */
};

with a third, RESULT_HIT variant, and the architecture could fill in 
whichever events it can count. User-space could then request all 
three and do the trivial arithmetics when one of them is missing as 
'not counted'.

Secondly, we could let the kernel do the arithmetics: when 'accesses' 
and 'misses' are requested, the kernel could start a 'hits' and 
'misses' event and do the addition internally. This couples the 
events though, in a way not visible to user-space, which might 
complicate things.

A third variant would be a variation of the second solution: to 
create a standalone 'compound' event by running two hw events (hits 
and misses), when user-space requests 'references'.

> > Btw., i have a pretty different experience from you: people will 
> > use most of the (default) generic events pretty happily because 
> > most developers have an adequate notion of 'cycles, branches, 
> > instructions' and they will *STOP* at the boundary of having to 
> > go into CPU microarchitecture specific details ...
> 
> Ok, perhaps my experience comes my sheltered life in the company of 
> micro-architecture nerds :) [...]

That's an excusable sin, happens to most folks who specialize in PMU 
fun - they just don't get the point of "dumbing down" all those 
nifty, totally exciting microarchitectural details ;-)

Many times 'as many details as possible' is my preference as well - i 
like 'perf stat -ddd' output a lot (after first getting a simplified 
overview run). So successive runs of:

  perf stat
  perf stat -d
  perf stat -dd
  perf stat -ddd

... tell the same fundamental story with increasing 'resolution' and 
detail of analysis.

That does not mean that my admittedly odd and occasionally extreme 
preferences as an expert are what should dictate the design though.

> [...] Although, I think that if the generic events were more 
> applicable to ARM I would be seeing what you see.
> 
> > People just use the tool defaults in most cases, only a select 
> > few will bother with model specific events. Life is short and 
> > learning CPU microarchitecture specific details is a long and 
> > difficult process that is not justified for most users/developers 
> > - not in small part because the juicy bits of how specific CPUs 
> > really work (and what raw events correspond to those details) are 
> > behind an NDA protected curtain, only accessible to a few 
> > privileged people ...
> > 
> > That is not what Linux interfaces are about in my opinion.
> 
> I completely agree with you on avoiding these interfaces in 
> general. However, the ARM event numbers aren't under NDA and even 
> if we could put them in the kernel, there's no way of communicating 
> that to the user because the events don't match up well with what 
> the ABI expects.

Well, can you see other problems beyond the hits/misses/references 
problem? I think we can solve that one.

> For example, an event that may be useful on A15 is:
> 
>   0x6d: Exclusive instruction speculatively executed - STREX pass
> 
>   (this could be used for investigating lock contention)
> 
> yet users are currently forced to use a raw event for this anyway.
> This is fine for the more esoteric events like
> 
>   0x40: Counts the number of Java bytecodes being decoded, including
>         speculative ones.
> 
> where only a select few will care about it.

We could certainly extend the number of generic events. What are 
'exclusive instructions' on ARM - ones that do atomic operations?

With any generalization, there will be a somewhat fuzzy boundary 
between events that are best kept raw and events that are worth 
generalizing. So the fact that you can find esoteric sounding but 
useful events that probably only apply to ARM does not invalidate the 
general idea of abstracting out cross-CPU concepts.

I personally would rather err on the side of generalizing too many 
than too few events:

- If a given event cannot be expressed on a CPU model then that's not 
  a big problem: it literally does not exist on that CPU and nothing
  we can do will create it out of thin air. It will remain obscure 
  and we can live with that.

- But if a useful event is only accessible via the raw ABI, and it 
  turns out to be present on other CPUs as well and tools would like 
  to make use of it, then it would be actively harmful if tools used 
  the raw ABI. If generalized it can be used more widely.


> > So what you and Vince are suggesting, to dumb down the kernel 
> > parts of perf and force users into raw or microarchitecture 
> > specific events actually *reduces* the user-base very 
> > significantly - while in practice even just cycles, instructions 
> > and branches level analysis handles 99% of the everyday 
> > performance analysis needs ...
> 
> No. I don't think that the kernel part should be dumbed down, nor 
> do I think that the user should have to play with hex numbers. I 
> just think that we should allow a way to communicate named 
> CPU-specific events to the user. We have userspace libraries that 
> do this, but if you want to avoid the OProfile mess then we could 
> look at putting this into the kernel (although I worry that these 
> tables will become large).

Size is not an issue.


> > We saw how the "push CPU specific events to users and tooling" 
> > concept didn't work with oprofile - why do we have to re-discuss 
> > this part of failed Linux history again and again?
> > 
> > The approach Vince and you are suggesting is literally 
> > sacrificing 99% of utility for 1% of the users - a not very smart 
> > approach. I don't mind accomodating the needs of 1% of 
> > power-users (at all), but:
> > 
> >    *NOT AT THE EXPENSE OF THE COMMON CASE*.
> > 
> > doh.
> 
> So let's leave the common-case as a `best effort' attempt to match 
> the ABI events to whatever we have on the running CPU and come up 
> with a way to augment the set of named events provided by perf.

Correct - as long as 'best effort' is still statistically equivalent 
to the real, 'ideal' event.

For the specific cache hits/misses/references example you cited i 
think we need to do better than what we have currently: clearly we 
don't want 'references' to be a smaller integer value than 'misses'.

> > > Right, but as I say, `instructions' on one core might not be 
> > > `instructions' on another core. Just removing the ABI types 
> > > from ARM will at least stop people using them. [...]
> > 
> > What are you talking about? Sure ARM Cortex 9 will execute 
> > instructions of a user-space application just as much as do other 
> > ARM CPUs. Sure as it executes that app it will execute 
> > instructions, you can single-step through it and thus you can 
> > count how many instructions it has executed, right?
> 
> On A9:
> 
> instructions (0x68):
> 	Instructions coming out of the core renaming stage
> 
> 	Counts the number of instructions going through the Register Renaming
> 	stage. This number is an approximate number of the total number of
> 	instructions speculatively executed, and even more approximate of
> 	the total number of instructions architecturally executed. The
> 	approximation depends mainly on the branch misprediction rate.
> 
> On A8:
> 
> instructions (0x08):
> 	Instruction architecturally executed
> 
> The problem being that the A9 PMU event really doesn't tie back to 
> the programmer's model. It's an approximation though, so it's 
> alright provided you don't try to compare it between CPUs.

ok - i think this is an example where the definition is statistically 
equivalent - i.e. 'good enough'.

Cross-CPU comparisons are never obvious in any case: compilers 
generate different code on different CPUs and different systems tend 
to have different user-space.

99% of the comparisons are done in the same system, just with 
different versions of the software running on it.


> > If you think about it that is a pretty unambiguous definition: 
> > each ARM core will execute user-space applications and the same 
> > (compatible) assembly routine results in the same end result, in 
> > the same number of visible assembly instructions, right?
> 
> Yes, from the programmer's model it's the same, but the event 
> counts might not correlate so well with that. [...]

Right.

> [...] Sometimes you may need to have two event counters and sum the 
> total, for example (the earlier cache-references should be hits + 
> misses).

Yes - and i think the cache event artifacts are well beyond the 
'statistically equivalent' noise and we need to fix that imprecision.

> > In practice most people will use the default event: cycles for 
> > perf stat/top and the default 'perf stat' output.
> 
> We have a dedicated cycle counter, so no issues there.

Good - this makes 90% of the users happy already ;-)

> > We've also had numerous cases where kernel developers went way 
> > beyond those metrics and apprecitated that tooling would provide 
> > good approximations for all those events regardless of what CPU 
> > type the workload was running on (and sometimes even documented 
> > this in the changelog).
> > 
> > So having generic events is not some fancy, unused property, but 
> > a pretty important measurement aspect of perf.
> 
> Ok, but how can we expose the rest of the CPU events without using 
> raw events?

I think Corey sent a patch some time ago (a year ago?) that allowed 
CPU specific events to be defined by the kernel. I think it would be 
useful - i think we've generalized most of the core stuff that's 
worth generalizing so we can start populating the more esoteric 
tables as well.

These events could be used via some self-explanatory syntax, such as:

	-e cpu::instr_strex

or so - and would map to 0x6d on A9. Hm?

Thanks,

	Ingo
