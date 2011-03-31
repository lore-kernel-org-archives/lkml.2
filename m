Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab1CaXjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 19:39:15 -0400
Received: from sous-sol.org ([216.99.217.87]:38630 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751664Ab1CaXjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 19:39:13 -0400
Date: Thu, 31 Mar 2011 16:39:02 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Mike Travis <travis@sgi.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        iommu@lists.linux-foundation.org, Mike Habeck <habeck@sgi.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 3/4] Intel pci: Limit dmar_init_reserved_ranges
Message-ID: <20110331233902.GD18712@sequoia.sous-sol.org>
References: <20110329233602.272459647@gulag1.americas.sgi.com>
 <20110329233602.735667875@gulag1.americas.sgi.com>
 <4D94FC21.6040601@sgi.com>
 <20110331225316.GC18712@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331225316.GC18712@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Wright (chrisw@sous-sol.org) wrote:
> > Mike Travis wrote:
> > >	  Region 1: Memory at f8200000000 (64-bit, prefetchable) [size=256M]
> > >	  Region 3: Memory at 90000000 (64-bit, non-prefetchable) [size=32M]
> > >
> > >    So this 44bit MMIO address 0xf8200000000 ends up in the rbtree.  As DMA
> > >    maps get added and deleted from the rbtree we can end up getting a cached
> > >    entry to this 0xf8200000000 entry... this is what results in the code
> > >    handing out the invalid DMA map of 0xf81fffff000:
> > >
> > >	    [ 0xf8200000000-1 >> PAGE_SIZE << PAGE_SIZE ]
> > >
> > >    The IOVA code needs to better honor the "limit_pfn" when allocating
> > >    these maps.
> 
> This means we could get the MMIO address range (it's no longer reserved).
> It seems to me the DMA transaction would then become a peer to peer
> transaction if ACS is not enabled, which could show up as random register
> write in that GPUs 256M BAR (i.e. broken).
> 
> The iova allocation should not hand out an address bigger than the
> dma_mask.  What is the device's dma_mask?

Ah, looks like this is a bad interaction with the way the cached entry
is handled.  I think the iova lookup should skip down the the limit_pfn
rather than assume that rb_last's pfn_lo/hi is ok just because it's in
the tree.  Because you'll never hit the limit_pfn == 32bit_pfn case, it
just goes straight to rb_last in __get_cached_rbnode.
