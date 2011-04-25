Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab1DYTk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 15:40:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:4431 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab1DYTkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 15:40:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,266,1301900400"; 
   d="scan'208";a="633901440"
Date: Mon, 25 Apr 2011 12:40:02 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        arun@sharma-home.net, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110425194002.GA30576@tassilo.jf.intel.com>
References: <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110422203222.GA21219@elte.hu>
 <20110423000347.GC9328@tassilo.jf.intel.com>
 <1303545012.2298.44.camel@twins>
 <BANLkTi=pk7J1uqCQvJe+RrTPoi=K1Aa5QQ@mail.gmail.com>
 <1303564561.2298.62.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303564561.2298.62.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, but who cares? So your period isn't exactly what you specified,
> but the effective period will have an average and a fairly small stdev
> (assuming the initial period is much larger than the relatively few
> cycles it takes to arm the PEBS assist), therefore you still get a
> fairly uniform spread.

The skid is not uniform and not necessarily random unfortunately, 
and difficult to correct in a standard way.

> I don't much get the obsession with precision here, its all a statistics
> game anyway.

If you want to make your code faster it's often important to figure
out what exactly is slow.

One example of this we had recently in the kernel: 

function accesses three global objects. Scalability tanks when the test is 
run with more CPUs.  Now the hit is near the three memory accesses. Which one
is the one that is actually bouncing cache lines?

The CPU executes them all in parallel so it's hard to tell. It's
all in the out of order reordering window.

PEBS (e.g. the memory latency event) can give you some information about
which memory access is to blame with the right events, but it's not 
using the RIP.

The generic events won't help with that, because they're still RIP
based, which is not accurate.

> Similarly all this precision wanking isn't _that_ important, the big
> fish clearly stand out, its only when you start shaving off the last few
> cycles that all that really comes in handy, before that its mostly: ooh
> thinking is hard, lets go shopping.

I wish it was that easy.

In the example above it's about scaling or not scaling, which is
definitely not the last cycle, but more a life-and-death 
"is the workload feasible on this machine or not" question.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
