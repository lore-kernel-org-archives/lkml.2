Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab0GHLUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:20:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43609 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab0GHLUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:20:00 -0400
Date: Thu, 8 Jul 2010 13:19:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matt Fleming <matt@console-pimps.org>, Will Deacon <will.deacon@arm.com>,
       paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
Message-ID: <20100708111936.GA5926@elte.hu>
References: <20100624142804.431553874@chello.nl>
 <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com>
 <1277464589.32034.276.camel@twins>
 <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com>
 <1277477401.32034.670.camel@twins>
 <1277994970.1917.184.camel@laptop>
 <1277996555.1917.205.camel@laptop>
 <20100701153112.GA13511@console-pimps.org>
 <1277998793.1917.212.camel@laptop>
 <1278587622.1900.79.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278587622.1900.79.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4124]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-07-01 at 17:39 +0200, Peter Zijlstra wrote:
> > 
> > Ah, for sampling for sure, simply group a software perf event and a
> > hardware perf event together and use PERF_SAMPLE_READ. 
> 
> So the idea is to sample using a software event (periodic timer of sorts, 
> maybe randomize it) and weight its samples by the hardware event deltas.
> 
> Suppose you have a workload consisting of two main parts:
> 
>   my_important_work()
>   {
>      load_my_data();
>      compute_me_silly();
>   }
> 
> Now, lets assume that both these functions take the same time to complete 
> for each part of work. In that case a periodic timer generate samples that 
> are about 50/50 distributed between these two functions.
> 
> Now, let us further assume that load_my_data() is so slow because its 
> missing all the caches and compute_me_silly() is slow because its defeating 
> the branch predictor.
> 
> So what we want to end up with, is that when we sample for cache-misses we 
> get load_my_data() as the predominant function, not a nice 50/50 relation. 
> Idem for branch misses and compute_me_silly().
> 
> By weighting the samples by the hw counter delta we get this, if we assume 
> that the sampling frequency is not a harmonic of the runtime of these 
> functions, then statistics will dtrt.

Yes.

And if the platform code implements this then the tooling side already takes 
care of it - even if the CPU itself cannot geneate interrupts based on say 
cachemisses or branches (but can measure them via counts).

The only situation where statistics will not do the right thing is when the 
likelyhood of the sample tick significantly correlates with the likelyhood of 
the workload itself executing. Timer-dominated workloads would be an example.

Real hrtimers are sufficiently tick-less to solve most of these artifacts in 
practice.

	Ingo
