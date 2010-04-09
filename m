Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab0DIEOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 00:14:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab0DIEO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 00:14:27 -0400
Date: Fri, 9 Apr 2010 14:14:21 +1000
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 00/13] mm: preemptibility -v2
Message-ID: <20100409041421.GM5683@laptop>
References: <20100408191737.296180458@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408191737.296180458@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 09:17:37PM +0200, Peter Zijlstra wrote:
> Hi,
> 
> This (still incomplete) patch-set makes part of the mm a lot more preemptible.
> It converts i_mmap_lock and anon_vma->lock to mutexes.  On the way there it
> also makes mmu_gather preemptible.
> 
> The main motivation was making mm_take_all_locks() preemptible, since it
> appears people are nesting hundreds of spinlocks there.
> 
> The side-effects are that we can finally make mmu_gather preemptible, something
> which lots of people have wanted to do for a long time.

What's the straight-line performance impact of all this? And how about
concurrency, I wonder. mutexes of course are double the atomics, and
you've added a refcount which is two more again for those paths using
it.

Page faults are very important. We unfortunately have some databases
doing a significant amount of mmap/munmap activity too. I'd like to
see microbenchmark numbers for each of those (both anon and file backed
for page faults).

kbuild does quite a few pages faults, that would be an easy thing to
test. Not sure what reasonable kinds of cases exercise parallelism.


> What kind of performance tests would people have me run on this to satisfy
> their need for numbers? I've done a kernel build on x86_64 and if anything that
> was slightly faster with these patches, but it was well within the noise
> levels so it might be heat noise I'm looking at ;-)

Is it because you're reducing the number of TLB flushes, or what
(kbuild isn't multi threaded so on x86 TLB flushes should be really
fast anyway).

