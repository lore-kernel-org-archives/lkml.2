Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1HKIQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:16:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab1HKIQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:16:42 -0400
Date: Thu, 11 Aug 2011 10:15:25 +0200
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
Message-ID: <20110811081525.GA3802@elte.hu>
References: <alpine.DEB.2.00.1108101328440.22769@cl320.eecs.utk.edu>
 <20110810183306.GA32695@e102144-lin.cambridge.arm.com>
 <alpine.DEB.2.00.1108101452510.25186@cl320.eecs.utk.edu>
 <20110810220727.GA5270@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810220727.GA5270@e102144-lin.cambridge.arm.com>
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

> [...] From what I've seen of perf users on ARM, they start with the 
> ABI events, get some nonsensical results and then switch 
> exclusively to raw events from then on.

Could you give a specific example of such nonsensical output on ARM? 
Bugs should be fixed and yes i can that see if ARM produces 
nonsencial output then people won't use that nonsensical output 
(duh). Please fix or improve the nonsensical output.

Btw., i have a pretty different experience from you: people will use 
most of the (default) generic events pretty happily because most 
developers have an adequate notion of 'cycles, branches, 
instructions' and they will *STOP* at the boundary of having to go 
into CPU microarchitecture specific details ...

People just use the tool defaults in most cases, only a select few 
will bother with model specific events. Life is short and learning 
CPU microarchitecture specific details is a long and difficult 
process that is not justified for most users/developers - not in 
small part because the juicy bits of how specific CPUs really work 
(and what raw events correspond to those details) are behind an NDA 
protected curtain, only accessible to a few privileged people ...

That is not what Linux interfaces are about in my opinion.

So what you and Vince are suggesting, to dumb down the kernel parts 
of perf and force users into raw or microarchitecture specific events 
actually *reduces* the user-base very significantly - while in 
practice even just cycles, instructions and branches level analysis 
handles 99% of the everyday performance analysis needs ...

We saw how the "push CPU specific events to users and tooling" 
concept didn't work with oprofile - why do we have to re-discuss this 
part of failed Linux history again and again?

The approach Vince and you are suggesting is literally sacrificing 
99% of utility for 1% of the users - a not very smart approach. I 
don't mind accomodating the needs of 1% of power-users (at all), but:

   *NOT AT THE EXPENSE OF THE COMMON CASE*.

doh.

> > I agree 100%, but it's an unpopular opinion on linux-kernel.  
> > (Note that I'm the one who contributed ARM Cortex A8/A9 support 
> > to both libpfm4 and PAPI).
>
> I can see why it's an unpopular idea if it's not necessary on your 
> architecture but for ARM it's really the only way forward without 
> continuing to introduce a mess of sparsely populated event tables 
> every time a new CPU crops up.

Generic events are not about lkml popularity ... it's about 
usability.

And why would it have to be implemented in a messy way? We have a 
number of CPU specific tables (and quirks) on x86 as well - that's 
the job of pretty much any kernel driver, to abstract things away in 
a per CPU, often per device (and sometimes even per card variant 
type) manner.

We literally have more than 7 million lines of drivers/* code that 
provides generic abstractions - not just a few thousand lines of raw 
PCI operations space where user-space can write magic values to ...

Similarly, for perf events we don't do a raw binary ABI mess for 
really good reasons: tools and users do not think in CPU and model 
specific hexa numbers, they operate in higher level concepts.

That is a basic quality of implementation property.

It's the *job* of the kernel to abstract things away, we don't shy 
away from that ...

> > Since the generalized events are there and ABI though, people are 
> > going to use them.  That's why I've been writing tests that check 
> > them to see exactly what they are measuring.
> 
> Right, but as I say, `instructions' on one core might not be 
> `instructions' on another core. Just removing the ABI types from 
> ARM will at least stop people using them. [...]

What are you talking about? Sure ARM Cortex 9 will execute 
instructions of a user-space application just as much as do other ARM 
CPUs. Sure as it executes that app it will execute instructions, you 
can single-step through it and thus you can count how many 
instructions it has executed, right?

> > It's still an important issue to know what "branches" measures, 
> > just it probably shouldn't be a kernel issue like it's become.
> 
> The TRM for the A9 will describe various events for counting 
> branch-related events. These may be specific to the pipeline and 
> micro-architecture and therefore you can't really tar them all with 
> the same brush.

The best generic event is the one that the coder/user of a user-space 
app sees the CPU executing instructions/branches/etc.

If the PMU cannot give that then the (statistically) next best 
approximation should be provided.

If you think about it that is a pretty unambiguous definition: each 
ARM core will execute user-space applications and the same 
(compatible) assembly routine results in the same end result, in the 
same number of visible assembly instructions, right?

In practice most people will use the default event: cycles for perf 
stat/top and the default 'perf stat' output.

We've also had numerous cases where kernel developers went way beyond 
those metrics and apprecitated that tooling would provide good 
approximations for all those events regardless of what CPU type the 
workload was running on (and sometimes even documented this in the 
changelog).

So having generic events is not some fancy, unused property, but a 
pretty important measurement aspect of perf.

Thanks,

	Ingo
