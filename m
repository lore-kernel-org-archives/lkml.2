Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab1BWSGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:06:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab1BWSGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:06:39 -0500
Subject: Re: [RFC PATCH 0/3] Weight-balanced binary tree + KVM growable
 memory slots using wbtree
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        xiaoguangrong@cn.fujitsu.com
In-Reply-To: <4D6507C9.1000906@redhat.com>
References: <1298386481.5764.60.camel@x201>
	 <20110222183822.22026.62832.stgit@s20.home>  <4D6507C9.1000906@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 11:06:35 -0700
Message-ID: <1298484395.18387.28.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 15:12 +0200, Avi Kivity wrote:
> On 02/22/2011 08:54 PM, Alex Williamson wrote:
> > This series introduces a new weight-balanced binary tree (wbtree) for
> > general use.  It's largely leveraged from the rbtree, copying it's
> > rotate functions, while introducing different rebalance and erase
> > functions.  This tree is particularly useful for managing memory
> > ranges, where it's desirable to have the most likely targets (the
> > largest ranges) at the top of each subtree.
> >
> > Patches 2&  3 go on to convert the KVM memory slots to a growable
> > array and make use of wbtree for efficient managment.  Trying to
> > exercise the worst case for this data structure, I ran netperf
> > TCP_RR on an emulated rtl8139 NIC connected directly to the host
> > via a tap.  Both qemu-kvm and the netserver on the host were
> > pinned to optimal CPUs with taskset.  This series resulted in
> > a 3% improvement for this test.
> >
> 
> In this case, I think most of the faults (at least after the guest was 
> warmed up) missed the tree completely.  

Except for the mmio faults for the NIC, which will traverse the entire
depth of that branch of the tree for every access.

> In this case a weight balanced 
> tree is hardly optimal (it is optimized for hits), so I think you'll see 
> a bigger gain from the mmio fault optimization.  You'll probably see 
> most of the gain running mmu intensive tests with ept=0.

Right, the gain expected by this test is that we're only traversing 6-7
tree nodes until we don't find a match, versus the full 32 entries of
the original memslot array.  So it's effectively comparing worst case
scenarios for both data structures.

Hopefully the followup with kernbench run with ept=0 show that there's
also still a benefit in the data match scenario.  The existing array
ends up being nearly optimal for memory hits since it registers memory
from 1M - 3.5G in slot0 and 4G - 10.5G in slot1.  For the tree, we jump
straight to the bigger slot.  I'll run one more set of kernbench tests
with the original code, just reversing slots 0&1 to see if we take much
of a hit from the tree overhead.  Thanks,

Alex

