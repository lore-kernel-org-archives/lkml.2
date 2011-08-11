Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1HKJRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 05:17:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60573 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753612Ab1HKJRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 05:17:22 -0400
Date: Thu, 11 Aug 2011 10:16:58 +0100
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
Message-ID: <20110811091658.GB25103@e102144-lin.cambridge.arm.com>
References: <alpine.DEB.2.00.1108101328440.22769@cl320.eecs.utk.edu>
 <20110810183306.GA32695@e102144-lin.cambridge.arm.com>
 <alpine.DEB.2.00.1108101452510.25186@cl320.eecs.utk.edu>
 <20110810220727.GA5270@e102144-lin.cambridge.arm.com>
 <20110811081525.GA3802@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110811081525.GA3802@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Thanks for your input on this.

On Thu, Aug 11, 2011 at 09:15:25AM +0100, Ingo Molnar wrote:
> 
> * Will Deacon <will.deacon@arm.com> wrote:
> 
> > [...] From what I've seen of perf users on ARM, they start with the 
> > ABI events, get some nonsensical results and then switch 
> > exclusively to raw events from then on.
> 
> Could you give a specific example of such nonsensical output on ARM? 
> Bugs should be fixed and yes i can that see if ARM produces 
> nonsencial output then people won't use that nonsensical output 
> (duh). Please fix or improve the nonsensical output.

Sure. On Cortex-A9 I see this:


Performance counter stats for 'ls':

              2862 cache-references
             20658 cache-misses              #  721.803 % of all cache refs

       0.019123136 seconds time elapsed


This is because we're actually reporting cache hits for cache-references
in an attempt to provide something remotely similar. I agree that this is
broken, which is why I'm leaning towards a more liberal use of
HW_OP_UNSUPPORTED.

> Btw., i have a pretty different experience from you: people will use 
> most of the (default) generic events pretty happily because most 
> developers have an adequate notion of 'cycles, branches, 
> instructions' and they will *STOP* at the boundary of having to go 
> into CPU microarchitecture specific details ...

Ok, perhaps my experience comes my sheltered life in the company of
micro-architecture nerds :) Although, I think that if the generic events
were more applicable to ARM I would be seeing what you see.

> People just use the tool defaults in most cases, only a select few 
> will bother with model specific events. Life is short and learning 
> CPU microarchitecture specific details is a long and difficult 
> process that is not justified for most users/developers - not in 
> small part because the juicy bits of how specific CPUs really work 
> (and what raw events correspond to those details) are behind an NDA 
> protected curtain, only accessible to a few privileged people ...
> 
> That is not what Linux interfaces are about in my opinion.

I completely agree with you on avoiding these interfaces in general.
However, the ARM event numbers aren't under NDA and even if we could put
them in the kernel, there's no way of communicating that to the user because
the events don't match up well with what the ABI expects.

For example, an event that may be useful on A15 is:

  0x6d: Exclusive instruction speculatively executed - STREX pass

  (this could be used for investigating lock contention)

yet users are currently forced to use a raw event for this anyway.
This is fine for the more esoteric events like

  0x40: Counts the number of Java bytecodes being decoded, including
        speculative ones.

where only a select few will care about it.

> So what you and Vince are suggesting, to dumb down the kernel parts 
> of perf and force users into raw or microarchitecture specific events 
> actually *reduces* the user-base very significantly - while in 
> practice even just cycles, instructions and branches level analysis 
> handles 99% of the everyday performance analysis needs ...

No. I don't think that the kernel part should be dumbed down, nor do I think
that the user should have to play with hex numbers. I just think that we
should allow a way to communicate named CPU-specific events to the user. We
have userspace libraries that do this, but if you want to avoid the OProfile
mess then we could look at putting this into the kernel (although I worry
that these tables will become large).

> We saw how the "push CPU specific events to users and tooling" 
> concept didn't work with oprofile - why do we have to re-discuss this 
> part of failed Linux history again and again?
> 
> The approach Vince and you are suggesting is literally sacrificing 
> 99% of utility for 1% of the users - a not very smart approach. I 
> don't mind accomodating the needs of 1% of power-users (at all), but:
> 
>    *NOT AT THE EXPENSE OF THE COMMON CASE*.
> 
> doh.

So let's leave the common-case as a `best effort' attempt to match the ABI
events to whatever we have on the running CPU and come up with a way to
augment the set of named events provided by perf.

> > 
> > Right, but as I say, `instructions' on one core might not be 
> > `instructions' on another core. Just removing the ABI types from 
> > ARM will at least stop people using them. [...]
> 
> What are you talking about? Sure ARM Cortex 9 will execute 
> instructions of a user-space application just as much as do other ARM 
> CPUs. Sure as it executes that app it will execute instructions, you 
> can single-step through it and thus you can count how many 
> instructions it has executed, right?

On A9:

instructions (0x68):
	Instructions coming out of the core renaming stage

	Counts the number of instructions going through the Register Renaming
	stage. This number is an approximate number of the total number of
	instructions speculatively executed, and even more approximate of
	the total number of instructions architecturally executed. The
	approximation depends mainly on the branch misprediction rate.

On A8:

instructions (0x08):
	Instruction architecturally executed


The problem being that the A9 PMU event really doesn't tie back to the
programmer's model. It's an approximation though, so it's alright provided
you don't try to compare it between CPUs.

> If you think about it that is a pretty unambiguous definition: each 
> ARM core will execute user-space applications and the same 
> (compatible) assembly routine results in the same end result, in the 
> same number of visible assembly instructions, right?

Yes, from the programmer's model it's the same, but the event counts might
not correlate so well with that. Sometimes you may need to have two event
counters and sum the total, for example (the earlier cache-references should
be hits + misses).

> In practice most people will use the default event: cycles for perf 
> stat/top and the default 'perf stat' output.

We have a dedicated cycle counter, so no issues there.

> We've also had numerous cases where kernel developers went way beyond 
> those metrics and apprecitated that tooling would provide good 
> approximations for all those events regardless of what CPU type the 
> workload was running on (and sometimes even documented this in the 
> changelog).
> 
> So having generic events is not some fancy, unused property, but a 
> pretty important measurement aspect of perf.

Ok, but how can we expose the rest of the CPU events without using raw
events?

Cheers,

Will
