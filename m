Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab0GHLNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:13:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0GHLNw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:13:52 -0400
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Will Deacon <will.deacon@arm.com>, paulus <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1277998793.1917.212.camel@laptop>
References: <20100624142804.431553874@chello.nl>
	 <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com>
	 <1277464589.32034.276.camel@twins>
	 <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com>
	 <1277477401.32034.670.camel@twins> <1277994970.1917.184.camel@laptop>
	 <1277996555.1917.205.camel@laptop>
	 <20100701153112.GA13511@console-pimps.org>
	 <1277998793.1917.212.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 13:13:42 +0200
Message-ID: <1278587622.1900.79.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 17:39 +0200, Peter Zijlstra wrote:
> 
> Ah, for sampling for sure, simply group a software perf event and a
> hardware perf event together and use PERF_SAMPLE_READ. 

So the idea is to sample using a software event (periodic timer of
sorts, maybe randomize it) and weight its samples by the hardware event
deltas.

Suppose you have a workload consisting of two main parts:

  my_important_work()
  {
     load_my_data();
     compute_me_silly();
  }

Now, lets assume that both these functions take the same time to
complete for each part of work. In that case a periodic timer generate
samples that are about 50/50 distributed between these two functions.

Now, let us further assume that load_my_data() is so slow because its
missing all the caches and compute_me_silly() is slow because its
defeating the branch predictor.

So what we want to end up with, is that when we sample for cache-misses
we get load_my_data() as the predominant function, not a nice 50/50
relation. Idem for branch misses and compute_me_silly().

By weighting the samples by the hw counter delta we get this, if we
assume that the sampling frequency is not a harmonic of the runtime of
these functions, then statistics will dtrt.

It basically generates a massive skid on the sample, but as long as most
of the samples end up hitting the right function we're good. For a
periodic workload like: 
  while (lots) { my_important_work() }
that is even true for period > function_runtime with the exception of
that harmonic thing. For less neat workloads like:
  while (lots) { my_important_work(); other_random_things(); }
This doesn't need to work unless period < function_runtime.

Clearly we cannot attribute anything to the actual instruction hit due
to the massive skid, but we can (possibly) say something about the
function based on these statistical rules.


