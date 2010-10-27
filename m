Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398Ab0J0Obg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:31:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57489 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193Ab0J0Obd (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 27 Oct 2010 10:31:33 -0400
Date: Wed, 27 Oct 2010 10:28:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: early_node_mem()'s memory allocation policy
Message-ID: <20101027142843.GA14634@dumpdata.com>
References: <4CC753AD.1090403@goop.org>
 <4CC7BD6D.2030104@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC7BD6D.2030104@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 10:49:33PM -0700, Yinghai Lu wrote:
> On 10/26/2010 03:18 PM, Jeremy Fitzhardinge wrote:
> >  We're seeing problems under Xen where large portions of the memory
> > could be reserved (because they're not yet physically present, even
> > though the appear in E820), and the 'start' and 'end' early_node_mem()
> > is choosing is entirely within that reserved range.
> > 
> > Also, the code seems dubious because it adjusts start and end without
> > regarding how much space it is trying to allocate:
> > 
> > 	/* extend the search scope */
> > 	end = max_pfn_mapped << PAGE_SHIFT;
> > 	if (end > (MAX_DMA32_PFN<<PAGE_SHIFT))
> > 		start = MAX_DMA32_PFN<<PAGE_SHIFT;
> > 	else
> > 		start = MAX_DMA_PFN<<PAGE_SHIFT;
> > 
> > what if max_pfn_mapped is only a few pages larger than MAX_DMA32_PFN,
> > and that is smaller than the size it is trying to allocate?
> > 
> > I tried just removing the start and end adjustments in early_node_mem()
> > and the kernel booted fine under Xen, but it seemed to allocate at a
> > very low address.  Should the for_each_active_range_index_in_nid() loop
> > in find_memory_core_early() be iterating from high to low addresses?  If
> > the allocation could be relied on to be top-down, then you wouldn't need
> > to adjust start at all, and it would return the highest available memory
> > in a natural way.
> 
> please check

It definitly gets us across that hump. Thanks.
> 
> [PATCH] x86, memblock: Fix early_node_mem with big reserved region.
> 
> Jeremy said Xen could reserve huge mem but still show as ram in e820.
> 
> early_node_mem could not find range because of start/end adjusting.
> 
> Let's use memblock_find_in_range instead ***_node. So get real top down in fallback path.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> 
> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> index 60f4985..7ffc9b7 100644
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -178,11 +178,8 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
>  
>  	/* extend the search scope */
>  	end = max_pfn_mapped << PAGE_SHIFT;
> -	if (end > (MAX_DMA32_PFN<<PAGE_SHIFT))
> -		start = MAX_DMA32_PFN<<PAGE_SHIFT;
> -	else
> -		start = MAX_DMA_PFN<<PAGE_SHIFT;
> -	mem = memblock_x86_find_in_range_node(nodeid, start, end, size, align);
> +	start = MAX_DMA_PFN << PAGE_SHIFT;
> +	mem = memblock_find_in_range(start, end, size, align);
>  	if (mem != MEMBLOCK_ERROR)
>  		return __va(mem);
>  
