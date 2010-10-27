Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0J0Ft5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 01:49:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53661 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0J0Ftz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 01:49:55 -0400
Message-ID: <4CC7BD6D.2030104@kernel.org>
Date: Tue, 26 Oct 2010 22:49:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: early_node_mem()'s memory allocation policy
References: <4CC753AD.1090403@goop.org>
In-Reply-To: <4CC753AD.1090403@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2010 03:18 PM, Jeremy Fitzhardinge wrote:
>  We're seeing problems under Xen where large portions of the memory
> could be reserved (because they're not yet physically present, even
> though the appear in E820), and the 'start' and 'end' early_node_mem()
> is choosing is entirely within that reserved range.
> 
> Also, the code seems dubious because it adjusts start and end without
> regarding how much space it is trying to allocate:
> 
> 	/* extend the search scope */
> 	end = max_pfn_mapped << PAGE_SHIFT;
> 	if (end > (MAX_DMA32_PFN<<PAGE_SHIFT))
> 		start = MAX_DMA32_PFN<<PAGE_SHIFT;
> 	else
> 		start = MAX_DMA_PFN<<PAGE_SHIFT;
> 
> what if max_pfn_mapped is only a few pages larger than MAX_DMA32_PFN,
> and that is smaller than the size it is trying to allocate?
> 
> I tried just removing the start and end adjustments in early_node_mem()
> and the kernel booted fine under Xen, but it seemed to allocate at a
> very low address.  Should the for_each_active_range_index_in_nid() loop
> in find_memory_core_early() be iterating from high to low addresses?  If
> the allocation could be relied on to be top-down, then you wouldn't need
> to adjust start at all, and it would return the highest available memory
> in a natural way.

please check

[PATCH] x86, memblock: Fix early_node_mem with big reserved region.

Jeremy said Xen could reserve huge mem but still show as ram in e820.

early_node_mem could not find range because of start/end adjusting.

Let's use memblock_find_in_range instead ***_node. So get real top down in fallback path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 60f4985..7ffc9b7 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -178,11 +178,8 @@ static void * __init early_node_mem(int nodeid, unsigned long start,
 
 	/* extend the search scope */
 	end = max_pfn_mapped << PAGE_SHIFT;
-	if (end > (MAX_DMA32_PFN<<PAGE_SHIFT))
-		start = MAX_DMA32_PFN<<PAGE_SHIFT;
-	else
-		start = MAX_DMA_PFN<<PAGE_SHIFT;
-	mem = memblock_x86_find_in_range_node(nodeid, start, end, size, align);
+	start = MAX_DMA_PFN << PAGE_SHIFT;
+	mem = memblock_find_in_range(start, end, size, align);
 	if (mem != MEMBLOCK_ERROR)
 		return __va(mem);
 
