Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab1DYRiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:38:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39086 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758691Ab1DYRiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:38:23 -0400
Date: Mon, 25 Apr 2011 19:37:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arun Sharma <asharma@fb.com>
Cc: arun@sharma-home.net, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] perf events: Add stalled cycles generic event -
 PERF_COUNT_HW_STALLED_CYCLES
Message-ID: <20110425173751.GA28239@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110423201409.GA20072@elte.hu>
 <20110424061645.GA12013@radium.snc4.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110424061645.GA12013@radium.snc4.facebook.com>
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


* Arun Sharma <asharma@fb.com> wrote:

> On Sat, Apr 23, 2011 at 10:14:09PM +0200, Ingo Molnar wrote:
> > 
> > The new PERF_COUNT_HW_STALLED_CYCLES event tries to approximate
> > cycles the CPU does nothing useful, because it is stalled on a
> > cache-miss or some other condition.
> 
> Conceptually looks fine. I'd prefer a more precise name such as: 
> PERF_COUNT_EXECUTION_STALLED_CYCLES (to differentiate from frontend or 
> retirement stalls).

Ok.

Your script:

> # ./analyze.py
> Percent idle: 27%
>         Retirement Stalls: 82%
>         Backend Stalls: 0%
>         Frontend Stalls: 62%
>         Instruction Starvation: 62%
>         icache stalls: 0%
> 
> does give me a signal about where to look. The script below is
> a quick and dirty hack. I haven't really validated it with 
> many workloads. I'm posting it here anyway hoping that it'd
> result in better kernel support for these types of analyses.

Is pretty useful IMO.

The frontend/backend characterisation is pretty generic - most modern CPUs 
share that and have similar events.

So we could try to generalize these and get most of the statistics your script 
outputs.

> Even if we cover this with various generic PERF_COUNT_*STALL events,
> we'll still have a need for other events:
> 
> * Things that give info about instruction mixes.
> 
>   Ratio of {loads, stores, floating point, branches, conditional branches}
>   to total instructions.

We have this at least partially covered, but yeah, we stopped short of covering 
all instruction types so complete ratios cannot be built yet.

> * Activity related to micro architecture specific caches
> 
>   People using -funroll-loops may have a significant performance opportunity.
>   But it's hard to spot bottlenecks in the instruction decoder.
> 
> * Monitoring traffic on Hypertransport/QPI links

Cross-node accesses ought to be covered by Peter's RFC patch. In terms of 
isolating cross-CPU cache accesses i suspect we could do that too if it really 
matters to analysis in practice.

Basically the way to go about it are the testcases you wrote - they demonstrate 
the utility of a given type of event - and that justifies generalization as 
well.

> Like you observe, most people will not look at these events, so
> focusing on getting the common events right makes sense. But I
> still like access to all events (either via a mapping file or
> a library such as libpfm4). Hiding them in "perf list" sounds
> like a reasonable way of keeping complexity out.

Yes. We have access to raw events for relatively obscure (or too CPU dependent) 
events - but what we do not want to do is to extend that space without adding 
*any* generic event in essence. If something like offcore or uncore PMU support 
is useful enough to be in the kernel, then it should also be useful enough to 
gain generic events.

> PS: branch-misses:pp was spot on for the example above.

heh :-)

Thanks,

	Ingo
