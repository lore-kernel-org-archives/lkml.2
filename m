Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab1CASUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 13:20:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab1CASUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 13:20:37 -0500
Subject: Re: [RFC PATCH 0/3] Weight-balanced binary tree + KVM growable
 memory slots using wbtree
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        xiaoguangrong@cn.fujitsu.com
In-Reply-To: <4D6D0ADF.1050107@redhat.com>
References: <1298386481.5764.60.camel@x201>
	 <20110222183822.22026.62832.stgit@s20.home>  <4D6507C9.1000906@redhat.com>
	 <1298484395.18387.28.camel@x201> <1298489332.18387.56.camel@x201>
	 <4D662DBF.2020706@redhat.com> <1298568944.6140.21.camel@x201>
	 <4D6A1F55.7080804@redhat.com> <1298934271.4177.19.camel@x201>
	 <4D6D0ADF.1050107@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 11:20:32 -0700
Message-ID: <1299003632.4177.66.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 17:03 +0200, Avi Kivity wrote:
> On 03/01/2011 01:04 AM, Alex Williamson wrote:
> > >  >
> > >  >  The original problem that brought this on was scaling.  The re-ordered
> > >  >  array still has O(N) scaling while the tree should have ~O(logN) (note
> > >  >  that it currently doesn't because it needs a compaction algorithm added
> > >  >  after insert and remove).  So yes, it's hard to beat the results of a
> > >  >  test that hammers on the first couple entries of a sorted array, but I
> > >  >  think the tree has better than current performance and more predictable
> > >  >  when scaled performance.
> > >
> > >  Scaling doesn't matter, only actual performance.  Even a guest with 512
> > >  slots would still hammer only on the first few slots, since these will
> > >  contain the bulk of memory.
> >
> > It seems like we need a good mixed workload benchmark.  So far we've
> > only tested worst case, with a pure emulated I/O test, and best case,
> > with a pure memory test.  Ordering an array only helps the latter, and
> > only barely beats the tree, so I suspect overall performance would be
> > better with a tree.
> 
> But if we cache the missed-all-memslots result in the spte, we eliminate 
> the worst case, and are left with just the best case.

There's potentially a lot of entries between best case and worst case.

> > >  >  If we knew when we were searching for which type of data, it would
> > >  >  perhaps be nice if we could use a sorted array for guest memory (since
> > >  >  it's nicely bounded into a small number of large chunks), and a tree for
> > >  >  mmio (where we expect the scaling to be a factor).  Thanks,
> > >
> > >  We have three types of memory:
> > >
> > >  - RAM - a few large slots
> > >  - mapped mmio (for device assignment) - possible many small slots
> > >  - non-mapped mmio (for emulated devices) - no slots
> > >
> > >  The first two are handled in exactly the same way - they're just memory
> > >  slots.  We expect a lot more hits into the RAM slots, since they're much
> > >  bigger.  But by far the majority of faults will be for the third
> > >  category - mapped memory will be hit once per page, then handled by
> > >  hardware until Linux memory management does something about the page,
> > >  which should hopefully be rare (with device assignment, rare == never,
> > >  since those pages are pinned).
> > >
> > >  Therefore our optimization priorities should be
> > >  - complete miss into the slot list
> >
> > The tree is obviously the most time and space efficient for this and the
> > netperf results show a pretty clear win here.  I think it's really only
> > a question of whether we'd be ok with slow, cache thrashing, searches
> > here if we could effectively cache the result for next time as you've
> > suggested.
> 
> Yes.
> 
> > Even then, it seems like steady state performance would be
> > prone to unusual slowdowns (ex. have to flush sptes on every add, what's
> > the regeneration time to replace all those slow lookups?).
> 
> Those sptes would be flushed very rarely (never in normal operation).  
> When we add a slot, yes we drop those sptes, but also a few million 
> other sptes, so it's lost in the noise (regeneration time is just the 
> slot lookup itself).
> 
> > >  - hit into the RAM slots
> >
> > It's really just the indirection of the tree and slightly larger element
> > size that gives the sorted array an edge here.
> >
> > >  - hit into the other slots (trailing far behind)
> >
> > Obviously an array sucks at this.
> >
> > >  Of course worst-case performance matters.  For example, we might (not
> > >  sure) be searching the list with the mmu spinlock held.
> > >
> > >  I think we still have a bit to go before we can justify the new data
> > >  structure.
> >
> > Suggestions for a mixed workload benchmark?  What else would you like to
> > see?  Thanks,
> 
> The problem here is that all workloads will cache all memslots very 
> quickly into sptes and all lookups will be misses.  There are two cases 
> where we have lookups that hit the memslots structure: ept=0, and host 
> swap.  Neither are things we want to optimize too heavily.

Which seems to suggest that:

     A. making those misses fast = win
     B. making those misses fast + caching misses = win++
     C. we don't care if the sorted array is subtly faster for ept=0

Sound right?  So is the question whether cached misses alone gets us 99%
of the improvement since hits are already getting cached in sptes for
cases we care about?  Xiao, it sounded like you might have already
started the caching misses approach.  I'd be interested to incorporate
and test if you have anything working.  Thanks,

Alex


