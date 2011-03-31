Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab1CaXZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 19:25:11 -0400
Received: from relay3.sgi.com ([192.48.152.1]:45510 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751664Ab1CaXZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 19:25:09 -0400
Message-ID: <4D950D52.8080100@sgi.com>
Date: Thu, 31 Mar 2011 16:25:06 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Mike Habeck <habeck@sgi.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Intel pci: Limit dmar_init_reserved_ranges
References: <20110329233602.272459647@gulag1.americas.sgi.com> <20110329233602.735667875@gulag1.americas.sgi.com> <4D94FC21.6040601@sgi.com> <20110331225316.GC18712@sequoia.sous-sol.org>
In-Reply-To: <20110331225316.GC18712@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll probably need help from our Hardware PCI Engineer to help explain
this further, though here's a pointer to an earlier email thread:

http://marc.info/?l=linux-kernel&m=129259816925973&w=2

I'll also dig out the specs you're asking for.

Thanks,
Mike

Chris Wright wrote:
> * Mike Travis (travis@sgi.com) wrote:
>> Chris - did you have any comment on this patch?
> 
> It doesn't actually look right to me.  It means that particular range
> is no longer reserved.  But perhaps I've misunderstood something.
> 
>> Mike Travis wrote:
>>>    dmar_init_reserved_ranges() reserves the card's MMIO ranges to
>>>    prevent handing out a DMA map that would overlap with the MMIO range.
>>>    The problem while the Nvidia GPU has 64bit BARs, it's capable of
>>>    receiving > 40bit PIOs, but can't generate > 40bit DMAs.
> 
> I don't undertand what you mean here.
> 
>>>    So when the iommu code reserves these MMIO ranges a > 40bit
>>>    entry ends up getting in the rbtree.  On a UV test system with
>>>    the Nvidia cards, the BARs are:
>>>
>>>      0001:36:00.0 VGA compatible controller: nVidia Corporation
>>> GT200GL 	  Region 0: Memory at 92000000 (32-bit, non-prefetchable)
>>> [size=16M]
>>> 	  Region 1: Memory at f8200000000 (64-bit, prefetchable) [size=256M]
>>> 	  Region 3: Memory at 90000000 (64-bit, non-prefetchable) [size=32M]
>>>
>>>    So this 44bit MMIO address 0xf8200000000 ends up in the rbtree.  As DMA
>>>    maps get added and deleted from the rbtree we can end up getting a cached
>>>    entry to this 0xf8200000000 entry... this is what results in the code
>>>    handing out the invalid DMA map of 0xf81fffff000:
>>>
>>> 	    [ 0xf8200000000-1 >> PAGE_SIZE << PAGE_SIZE ]
>>>
>>>    The IOVA code needs to better honor the "limit_pfn" when allocating
>>>    these maps.
> 
> This means we could get the MMIO address range (it's no longer reserved).
> It seems to me the DMA transaction would then become a peer to peer
> transaction if ACS is not enabled, which could show up as random register
> write in that GPUs 256M BAR (i.e. broken).
> 
> The iova allocation should not hand out an address bigger than the
> dma_mask.  What is the device's dma_mask?
> 
> thanks,
> -chris
