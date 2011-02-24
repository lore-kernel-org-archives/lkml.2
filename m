Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1BXKEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 05:04:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299Ab1BXKEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 05:04:43 -0500
Message-ID: <4D662D34.7040104@redhat.com>
Date: Thu, 24 Feb 2011 12:04:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        xiaoguangrong@cn.fujitsu.com
Subject: Re: [RFC PATCH 0/3] Weight-balanced binary tree + KVM growable memory
 slots using wbtree
References: <1298386481.5764.60.camel@x201>	 <20110222183822.22026.62832.stgit@s20.home>  <4D6507C9.1000906@redhat.com> <1298484395.18387.28.camel@x201>
In-Reply-To: <1298484395.18387.28.camel@x201>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 08:06 PM, Alex Williamson wrote:
> On Wed, 2011-02-23 at 15:12 +0200, Avi Kivity wrote:
> >  On 02/22/2011 08:54 PM, Alex Williamson wrote:
> >  >  This series introduces a new weight-balanced binary tree (wbtree) for
> >  >  general use.  It's largely leveraged from the rbtree, copying it's
> >  >  rotate functions, while introducing different rebalance and erase
> >  >  functions.  This tree is particularly useful for managing memory
> >  >  ranges, where it's desirable to have the most likely targets (the
> >  >  largest ranges) at the top of each subtree.
> >  >
> >  >  Patches 2&   3 go on to convert the KVM memory slots to a growable
> >  >  array and make use of wbtree for efficient managment.  Trying to
> >  >  exercise the worst case for this data structure, I ran netperf
> >  >  TCP_RR on an emulated rtl8139 NIC connected directly to the host
> >  >  via a tap.  Both qemu-kvm and the netserver on the host were
> >  >  pinned to optimal CPUs with taskset.  This series resulted in
> >  >  a 3% improvement for this test.
> >  >
> >
> >  In this case, I think most of the faults (at least after the guest was
> >  warmed up) missed the tree completely.
>
> Except for the mmio faults for the NIC, which will traverse the entire
> depth of that branch of the tree for every access.

That is exactly what I meant: most of the faults cause the search to 
fail.  What we want here is to cache the success/fail result of the 
search so we don't do it in the first place.

> >  In this case a weight balanced
> >  tree is hardly optimal (it is optimized for hits), so I think you'll see
> >  a bigger gain from the mmio fault optimization.  You'll probably see
> >  most of the gain running mmu intensive tests with ept=0.
>
> Right, the gain expected by this test is that we're only traversing 6-7
> tree nodes until we don't find a match, versus the full 32 entries of
> the original memslot array.  So it's effectively comparing worst case
> scenarios for both data structures.

If we optimized the linear list we'd sort it by size, descending, and 
limit it by the number of instantiated slots, which I think would beat 
the tree.

-- 
error compiling committee.c: too many arguments to function

