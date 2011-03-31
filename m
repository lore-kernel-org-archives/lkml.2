Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520Ab1CaX5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 19:57:10 -0400
Received: from sous-sol.org ([216.99.217.87]:58735 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751664Ab1CaX5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 19:57:08 -0400
Date: Thu, 31 Mar 2011 16:56:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Mike Habeck <habeck@sgi.com>
Cc: Mike Travis <travis@sgi.com>, Chris Wright <chrisw@sous-sol.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Intel pci: Limit dmar_init_reserved_ranges
Message-ID: <20110331235657.GG18712@sequoia.sous-sol.org>
References: <20110329233602.272459647@gulag1.americas.sgi.com>
 <20110329233602.735667875@gulag1.americas.sgi.com>
 <4D94FC21.6040601@sgi.com>
 <20110331225316.GC18712@sequoia.sous-sol.org>
 <4D950D52.8080100@sgi.com>
 <4D951109.1040707@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D951109.1040707@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Habeck (habeck@sgi.com) wrote:
> On 03/31/2011 06:25 PM, Mike Travis wrote:
> >I'll probably need help from our Hardware PCI Engineer to help explain
> >this further, though here's a pointer to an earlier email thread:
> >
> >http://marc.info/?l=linux-kernel&m=129259816925973&w=2
> >
> >I'll also dig out the specs you're asking for.
> >
> >Thanks,
> >Mike
> >
> >Chris Wright wrote:
> >>* Mike Travis (travis@sgi.com) wrote:
> >>>Chris - did you have any comment on this patch?
> >>
> >>It doesn't actually look right to me. It means that particular range
> >>is no longer reserved. But perhaps I've misunderstood something.
> >>
> >>>Mike Travis wrote:
> >>>>dmar_init_reserved_ranges() reserves the card's MMIO ranges to
> >>>>prevent handing out a DMA map that would overlap with the MMIO range.
> >>>>The problem while the Nvidia GPU has 64bit BARs, it's capable of
> >>>>receiving > 40bit PIOs, but can't generate > 40bit DMAs.
> >>
> >>I don't undertand what you mean here.
> 
> What Mike is getting at is there is no reason to reserve the MMIO
> range if it's greater than the dma_mask, given the MMIO range is
> outside of what the IOVA code will ever hand back to the IOMMU
> code.  In this case the nVidia card has a 64bit BAR and is assigned
> the MMIO range [0xf8200000000 - 0xf820fffffff].  But the Nvidia
> card can only generate a 40bit DMA (thus has a 40bit dma_mask). If
> the IOVA code honors the limit_pfn (i.e., dma_mask) passed in it
> will never hand back a >40bit address back to the IOMMU code. Thus
> there is no reason to reserve the cards MMIO range if it is greater
> than the dma_mask. (And that is what the patch is doing).

The reserved ranges are for all devices.  Another device with a 64bit
dma_mask could get that region if it's not properly reserved.  The
driver would then program that device to dma to an address to is an
alias to a MMIO region.  The memory transaction travels up towards
root...and sees the MMIO range in some bridge and would go straight down
to the GPU.

> More below,,,
> 
> >>
> >>>>So when the iommu code reserves these MMIO ranges a > 40bit
> >>>>entry ends up getting in the rbtree. On a UV test system with
> >>>>the Nvidia cards, the BARs are:
> >>>>
> >>>>0001:36:00.0 VGA compatible controller: nVidia Corporation
> >>>>GT200GL Region 0: Memory at 92000000 (32-bit, non-prefetchable)
> >>>>[size=16M]
> >>>>Region 1: Memory at f8200000000 (64-bit, prefetchable) [size=256M]
> >>>>Region 3: Memory at 90000000 (64-bit, non-prefetchable) [size=32M]
> >>>>
> >>>>So this 44bit MMIO address 0xf8200000000 ends up in the rbtree. As DMA
> >>>>maps get added and deleted from the rbtree we can end up getting a cached
> >>>>entry to this 0xf8200000000 entry... this is what results in the code
> >>>>handing out the invalid DMA map of 0xf81fffff000:
> >>>>
> >>>>[ 0xf8200000000-1 >> PAGE_SIZE << PAGE_SIZE ]
> >>>>
> >>>>The IOVA code needs to better honor the "limit_pfn" when allocating
> >>>>these maps.
> >>
> >>This means we could get the MMIO address range (it's no longer reserved).
> 
> Not true, the MMIO address is greater than the dma_mask (i.e., the
> limit_pfn passed into alloc_iova()) thus the IOVA code will never
> hand back that address range given it's greater than the dma_mask).

Well, as you guys are seeing, the iova allocation code is making the
assumption that if the range is in the tree, it's valid.  And it is
handing out an address that's too large.

> >>It seems to me the DMA transaction would then become a peer to peer
> >>transaction if ACS is not enabled, which could show up as random register
> >>write in that GPUs 256M BAR (i.e. broken).
> >>
> >>The iova allocation should not hand out an address bigger than the
> >>dma_mask. What is the device's dma_mask?
> 
> Agree.  But there is a bug.  The IOVA doesn't validate the limit_pfn
> if it uses the cached entry.  One could argue that it should validate
> the limit_pfn, but then again a entry outside the limit_pfn should
> have never got into the rbtree...  (it got in due to the IOMMU's
> dmar_init_reserved_ranges() adding it).

Yeah, I think it needs to be in the global reserved list.  But perhaps
not copied into the domain specific iova.  Or simply skipped on iova
allocation (don't just assume rb_last is <= dma_mask).

thanks,
-chris
