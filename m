Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab0DIIft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 04:35:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab0DIIfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 04:35:36 -0400
Subject: Re: [PATCH 00/13] mm: preemptibility -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20100409041421.GM5683@laptop>
References: <20100408191737.296180458@chello.nl>
	 <20100409041421.GM5683@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 10:35:31 +0200
Message-ID: <1270802131.20295.3270.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 14:14 +1000, Nick Piggin wrote:
> On Thu, Apr 08, 2010 at 09:17:37PM +0200, Peter Zijlstra wrote:
> > Hi,
> > 
> > This (still incomplete) patch-set makes part of the mm a lot more preemptible.
> > It converts i_mmap_lock and anon_vma->lock to mutexes.  On the way there it
> > also makes mmu_gather preemptible.
> > 
> > The main motivation was making mm_take_all_locks() preemptible, since it
> > appears people are nesting hundreds of spinlocks there.
> > 
> > The side-effects are that we can finally make mmu_gather preemptible, something
> > which lots of people have wanted to do for a long time.
> 
> What's the straight-line performance impact of all this? And how about
> concurrency, I wonder. mutexes of course are double the atomics, and
> you've added a refcount which is two more again for those paths using
> it.
> 
> Page faults are very important. We unfortunately have some databases
> doing a significant amount of mmap/munmap activity too. 

You think this would affect the mmap/munmap times in any significant
way? It seems to me those are relatively heavy ops to begin with.

> I'd like to
> see microbenchmark numbers for each of those (both anon and file backed
> for page faults).

OK, I'll dig out that fault test used in the whole mmap_sem/rwsem thread
a while back and modify it to also do file backed faults.

> kbuild does quite a few pages faults, that would be an easy thing to
> test. Not sure what reasonable kinds of cases exercise parallelism.
> 
> 
> > What kind of performance tests would people have me run on this to satisfy
> > their need for numbers? I've done a kernel build on x86_64 and if anything that
> > was slightly faster with these patches, but it was well within the noise
> > levels so it might be heat noise I'm looking at ;-)
> 
> Is it because you're reducing the number of TLB flushes, or what
> (kbuild isn't multi threaded so on x86 TLB flushes should be really
> fast anyway).

I'll try and get some perf stat runs to get some insight into this. But
the numbers were:

 time make O=defconfig -j48 bzImage (5x, cache hot)

without:  avg: 39.2018s +- 0.3407
with:     avg: 38.9886s +- 0.1814



