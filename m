Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab1D0Psp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:48:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48417 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437Ab1D0Psm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:48:42 -0400
Date: Wed, 27 Apr 2011 17:48:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arun Sharma <arun@sharma-home.net>
Cc: Arun Sharma <asharma@fb.com>, Stephane Eranian <eranian@google.com>,
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
Message-ID: <20110427154805.GB23494@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110423201409.GA20072@elte.hu>
 <20110424061645.GA12013@radium.snc4.facebook.com>
 <20110427111141.GB28993@elte.hu>
 <BANLkTimz-KevvqmxxUPp73GEaAC5PTGWWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimz-KevvqmxxUPp73GEaAC5PTGWWw@mail.gmail.com>
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


* Arun Sharma <arun@sharma-home.net> wrote:

> On Wed, Apr 27, 2011 at 4:11 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > As for the first, 'overview' step, i'd like to use one or two numbers only, to
> > give people a general ballpark figure about how good the CPU is performing for
> > a given workload.
> >
> > Wouldnt UOPS_EXECUTED.CORE_ACTIVE_CYCLES,c=1,i=1 be in general a pretty good,
> > primary "stall" indicator? This is similar to the "cycles-uops_executed" value
> > in your script (UOPS_EXECUTED:PORT015:t=1 and UOPS_EXECUTED:PORT234_CORE
> > based): it counts cycles when there's no execution at all - not even
> > speculative one.
> 
> If we're going to pick one stall indicator, [...]

Well, one stall indicator for the 'general overview' stage, plus branch misses.

Other stages can also have all sorts of details, including various subsets of 
stall reasons. (and stalls of different units of the CPU)

We'll see how far it can be pushed.

> [...] why not pick cycles where no uops are retiring?
> 
> cycles_no_uops_retired = cycles - c["UOPS_RETIRED:ANY:c=1:t=1"]
>
> In the presence of C-states and some halted cycles, I found that I couldn't 
> measure it via UOPS_RETIRED:ANY:c=1:i=1 because it counts halted cycles too 
> and could be greater than (unhalted) cycles.

Agreed, good point.

You are right that it is more robust to pick 'the CPU was busy on our behalf' 
metric instead of a 'CPU is idle' metric, because that way 'HLT' as a special 
type of idling around does not have to be identified.

HLT is not an issue for the default 'perf stat' behavior (because it only 
measures task execution, never the idle thread or other tasks not involved with 
the workload), but for per CPU and system-wide (--all) it matters.

I'll flip it around.

> The other issue I had to deal with was UOPS_RETIRED > UOPS_EXECUTED 
> condition. I believe this is caused by what AMD calls sideband stack 
> optimizer and Intel calls dedicated stack manager (i.e. UOPS executed outside 
> the main pipeline). A recursive fibonacci(30) is a good test case for 
> reproducing this.

So the PORT015+234 sum is not precise? The definition seems to be rather firm:

  Counts number of Uops executed that where issued on port 2, 3, or 4.
  Counts number of Uops executed that where issued on port 0, 1, or 5.

Wouldnt that include all uops?

> > Is this the direction you'd like to see perf stat to move into? Any 
> > comments, suggestions?
> 
> Looks like a step in the right direction. Thanks.

Ok, great - will keep you updated. I doubt the defaults can ever beat truly 
expert use of PMU events: there will always be fine details that a generic 
approach will miss. But i'd be happy if we got 70% the way ...

Thanks,

	Ingo
