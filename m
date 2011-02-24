Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1BXRf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:35:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab1BXRfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:35:51 -0500
Subject: Re: [RFC PATCH 0/3] Weight-balanced binary tree + KVM growable
 memory slots using wbtree
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        xiaoguangrong@cn.fujitsu.com
In-Reply-To: <4D662DBF.2020706@redhat.com>
References: <1298386481.5764.60.camel@x201>
	 <20110222183822.22026.62832.stgit@s20.home>  <4D6507C9.1000906@redhat.com>
	 <1298484395.18387.28.camel@x201> <1298489332.18387.56.camel@x201>
	 <4D662DBF.2020706@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 10:35:44 -0700
Message-ID: <1298568944.6140.21.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 12:06 +0200, Avi Kivity wrote:
> On 02/23/2011 09:28 PM, Alex Williamson wrote:
> > I had forgotten about<1M mem, so actually the slot configuration was:
> >
> > 0:<1M
> > 1: 1M - 3.5G
> > 2: 4G+
> >
> > I stacked the deck in favor of the static array (0: 4G+, 1: 1M-3.5G, 2:
> > <1M), and got these kernbench results:
> >
> >              base (stdev)    reorder (stdev)   wbtree (stdev)
> > --------+-----------------+----------------+----------------+
> > Elapsed |  42.809 (0.19)  |  42.160 (0.22) |  42.305 (0.23) |
> > User    | 115.709 (0.22)  | 114.358 (0.40) | 114.720 (0.31) |
> > System  |  41.605 (0.14)  |  40.741 (0.22) |  40.924 (0.20) |
> > %cpu    |   366.9 (1.45)  |   367.4 (1.17) |   367.6 (1.51) |
> > context |  7272.3 (68.6)  |  7248.1 (89.7) |  7249.5 (97.8) |
> > sleeps  | 14826.2 (110.6) | 14780.7 (86.9) | 14798.5 (63.0) |
> >
> > So, wbtree is only slightly behind reordering, and the standard
> > deviation suggests the runs are mostly within the noise of each other.
> > Thanks,
> 
> Doesn't this indicate we should use reordering, instead of a new data 
> structure?

The original problem that brought this on was scaling.  The re-ordered
array still has O(N) scaling while the tree should have ~O(logN) (note
that it currently doesn't because it needs a compaction algorithm added
after insert and remove).  So yes, it's hard to beat the results of a
test that hammers on the first couple entries of a sorted array, but I
think the tree has better than current performance and more predictable
when scaled performance.

If we knew when we were searching for which type of data, it would
perhaps be nice if we could use a sorted array for guest memory (since
it's nicely bounded into a small number of large chunks), and a tree for
mmio (where we expect the scaling to be a factor).  Thanks,

Alex

