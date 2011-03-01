Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab1CATr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:47:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171Ab1CATr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:47:56 -0500
Date: Tue, 1 Mar 2011 16:47:03 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, xiaoguangrong@cn.fujitsu.com
Subject: Re: [RFC PATCH 0/3] Weight-balanced binary tree + KVM growable
 memory slots using wbtree
Message-ID: <20110301194703.GA7736@amt.cnet>
References: <1298386481.5764.60.camel@x201>
 <20110222183822.22026.62832.stgit@s20.home>
 <4D6507C9.1000906@redhat.com>
 <1298484395.18387.28.camel@x201>
 <1298489332.18387.56.camel@x201>
 <4D662DBF.2020706@redhat.com>
 <1298568944.6140.21.camel@x201>
 <4D6A1F55.7080804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6A1F55.7080804@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 11:54:29AM +0200, Avi Kivity wrote:
> On 02/24/2011 07:35 PM, Alex Williamson wrote:
> >On Thu, 2011-02-24 at 12:06 +0200, Avi Kivity wrote:
> >>  On 02/23/2011 09:28 PM, Alex Williamson wrote:
> >>  >  I had forgotten about<1M mem, so actually the slot configuration was:
> >>  >
> >>  >  0:<1M
> >>  >  1: 1M - 3.5G
> >>  >  2: 4G+
> >>  >
> >>  >  I stacked the deck in favor of the static array (0: 4G+, 1: 1M-3.5G, 2:
> >>  >  <1M), and got these kernbench results:
> >>  >
> >>  >               base (stdev)    reorder (stdev)   wbtree (stdev)
> >>  >  --------+-----------------+----------------+----------------+
> >>  >  Elapsed |  42.809 (0.19)  |  42.160 (0.22) |  42.305 (0.23) |
> >>  >  User    | 115.709 (0.22)  | 114.358 (0.40) | 114.720 (0.31) |
> >>  >  System  |  41.605 (0.14)  |  40.741 (0.22) |  40.924 (0.20) |
> >>  >  %cpu    |   366.9 (1.45)  |   367.4 (1.17) |   367.6 (1.51) |
> >>  >  context |  7272.3 (68.6)  |  7248.1 (89.7) |  7249.5 (97.8) |
> >>  >  sleeps  | 14826.2 (110.6) | 14780.7 (86.9) | 14798.5 (63.0) |
> >>  >
> >>  >  So, wbtree is only slightly behind reordering, and the standard
> >>  >  deviation suggests the runs are mostly within the noise of each other.
> >>  >  Thanks,
> >>
> >>  Doesn't this indicate we should use reordering, instead of a new data
> >>  structure?
> >
> >The original problem that brought this on was scaling.  The re-ordered
> >array still has O(N) scaling while the tree should have ~O(logN) (note
> >that it currently doesn't because it needs a compaction algorithm added
> >after insert and remove).  So yes, it's hard to beat the results of a
> >test that hammers on the first couple entries of a sorted array, but I
> >think the tree has better than current performance and more predictable
> >when scaled performance.
> 
> Scaling doesn't matter, only actual performance.  Even a guest with
> 512 slots would still hammer only on the first few slots, since
> these will contain the bulk of memory.
> 
> >If we knew when we were searching for which type of data, it would
> >perhaps be nice if we could use a sorted array for guest memory (since
> >it's nicely bounded into a small number of large chunks), and a tree for
> >mmio (where we expect the scaling to be a factor).  Thanks,
> 
> We have three types of memory:
> 
> - RAM - a few large slots
> - mapped mmio (for device assignment) - possible many small slots
> - non-mapped mmio (for emulated devices) - no slots
>
> The first two are handled in exactly the same way - they're just
> memory slots.  We expect a lot more hits into the RAM slots, since
> they're much bigger.  But by far the majority of faults will be for
> the third category - mapped memory will be hit once per page, then
> handled by hardware until Linux memory management does something
> about the page, which should hopefully be rare (with device
> assignment, rare == never, since those pages are pinned).
> 
> Therefore our optimization priorities should be
> - complete miss into the slot list
> - hit into the RAM slots
> - hit into the other slots (trailing far behind)

Whatever ordering considered optimal in one workload can be suboptimal
in another. The binary search reduces the number of slots inspected
in the average case. Using slot size as weight favours probability.

> Of course worst-case performance matters.  For example, we might
> (not sure) be searching the list with the mmu spinlock held.
> 
> I think we still have a bit to go before we can justify the new data
> structure.

Intensive IDE disk IO on guest with lots of assigned network devices, 3%
improvement on netperf with rtl8139, 1% improvement on kernbench?

Fail to see justification for not using it.

