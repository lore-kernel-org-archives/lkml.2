Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1HJWHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 18:07:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56043 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616Ab1HJWHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 18:07:45 -0400
Date: Wed, 10 Aug 2011 23:07:27 +0100
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sam wang <linux.swang@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch] perf: ARMv7 wrong "branches" generalized instruction
Message-ID: <20110810220727.GA5270@e102144-lin.cambridge.arm.com>
References: <alpine.DEB.2.00.1108101328440.22769@cl320.eecs.utk.edu>
 <20110810183306.GA32695@e102144-lin.cambridge.arm.com>
 <alpine.DEB.2.00.1108101452510.25186@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108101452510.25186@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 08:01:20PM +0100, Vince Weaver wrote:
> On Wed, 10 Aug 2011, Will Deacon wrote:
> 
> > > It turns out the branches event used (ARMV7_PERFCTR_PC_WRITE) only seems
> > > to count taken branches.
> >
> > It also counts exceptions and instructions that write to the PC.
> 
> are those more common than not-taken branches?  I'd think branch predictor 
> statistics will be a bit off if only taken instructions are measured.

They're almost certainly not as common in normal code. However, as I've
mentioned below, ARMV7_PERFCTR_PC_IMM_BRANCH only counts immediate branches
so I don't think this is so useful for general consumption.

> > > ARMV7_PERFCTR_PC_IMM_BRANCH seems to do a better job of counting both 
> > > taken and not-taken.  So I've attached a patch to change the definition
> > > for Cotex A9.
> >
> > Well, it also only considers immediate branches so whilst it might 
> > satisy your test, I think that overall it's a less meaningful number.
> 
> I guess there isn't more info available about which branches exactly are 
> counted by all the events?  I've gone through the trouble of writing such 
> tests to find out experimentally what various counters count for x86, it 
> would be sad to have to do it again for ARM.

The problem is, it's largely CPU specific. This has improved slightly with
newer cores and there is a PMUv2 document which describes common
architectural events and their reserved numbers, but it is still optional
for the CPU to implement these (notably, Cortex-A9 doesn't implement the
architected instruction counter).

Whilst your tests sound useful, to get any meaningful results out of ARM you
will need to either skip difficult tests or make them CPU specific and use the
raw encodings.

> > (b) start replacing our generalised events with HW_OP_UNSUPPORTED and force
> >     the user to use raw events. I agree this isn't very friendly, but it's
> >     better than giving them crazy results [for example, we currently report
> >     more cache misses than cache references on A9 iirc].
> > 
> > Personally, I'm favour of (b) and getting userspace to provide the user with
> > a CPU-specific event listing and then translate this to raw events using
> > something like libpfm.
> 
> I agree 100%, but it's an unpopular opinion on linux-kernel.  (Note that 
> I'm the one who contributed ARM Cortex A8/A9 support to both libpfm4 and 
> PAPI).

I can see why it's an unpopular idea if it's not necessary on your
architecture but for ARM it's really the only way forward without continuing
to introduce a mess of sparsely populated event tables every time a new CPU
crops up.

> Since the generalized events are there and ABI though, people are going to 
> use them.  That's why I've been writing tests that check them to see 
> exactly what they are measuring.

Right, but as I say, `instructions' on one core might not be `instructions'
on another core. Just removing the ABI types from ARM will at least stop
people using them. From what I've seen of perf users on ARM, they start with
the ABI events, get some nonsensical results and then switch exclusively to
raw events from then on.

> It's still an important issue to know what "branches" measures, just it 
> probably shouldn't be a kernel issue like it's become.

The TRM for the A9 will describe various events for counting branch-related
events. These may be specific to the pipeline and micro-architecture and
therefore you can't really tar them all with the same brush.

Will
