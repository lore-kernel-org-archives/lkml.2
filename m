Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2DWHvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:51:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20756 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab2DWHu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:50:59 -0400
Date: Mon, 23 Apr 2012 09:50:53 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: linux-next: manual merge of the akpm tree with the dma-mapping tree
In-reply-to: <20120423164953.1095c9ccbf81a33641947cd3@canb.auug.org.au>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
Message-id: <056601cd2125$cf4737b0$6dd5a710$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Ac0hHhnZ3T5oO35HQNidQItXDy7foAABb4yA
References: <20120423164953.1095c9ccbf81a33641947cd3@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Monday, April 23, 2012 8:50 AM Stephen Rothwell wrote:

> Today's linux-next merge of the scsi-post-merge tree got a conflict in
> mm/page_alloc.c between commit ac77c4123661 ("mm: trigger page reclaim in
> alloc_contig_range() to stabilise watermarks") from the dma-mapping tree
> and commit "mm: add extra free kbytes tunable" from the akpm tree.
> 
> Just context changes.  I fixed it up (I think - see below) and can carry
> the fixes as necessary.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc mm/page_alloc.c
> index 0e1c6f5,decfbf0..0000000
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@@ -5032,9 -4988,17 +5044,10 @@@ static void setup_per_zone_lowmem_reser
>   	calculate_totalreserve_pages();
>   }
> 
>  -/**
>  - * setup_per_zone_wmarks - called when min_free_kbytes changes
>  - * or when memory is hot-{added|removed}
>  - *
>  - * Ensures that the watermark[min,low,high] values for each zone are set
>  - * correctly with respect to min_free_kbytes.
>  - */
>  -void setup_per_zone_wmarks(void)
>  +static void __setup_per_zone_wmarks(void)
>   {
>   	unsigned long pages_min = min_free_kbytes >> (PAGE_SHIFT - 10);
> + 	unsigned long pages_low = extra_free_kbytes >> (PAGE_SHIFT - 10);
>   	unsigned long lowmem_pages = 0;
>   	struct zone *zone;
>   	unsigned long flags;
> @@@ -5074,16 -5041,13 +5090,18 @@@
>   			 * If it's a lowmem zone, reserve a number of pages
>   			 * proportionate to the zone's size.
>   			 */
> - 			zone->watermark[WMARK_MIN] = tmp;
> + 			zone->watermark[WMARK_MIN] = min;
>   		}
> 
> - 		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + (tmp >> 2);
> - 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
> + 		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) +
> + 					low + (min >> 2);
> + 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) +
> + 					low + (min >> 1);
>  +
>  +		zone->watermark[WMARK_MIN] += cma_wmark_pages(zone);
>  +		zone->watermark[WMARK_LOW] += cma_wmark_pages(zone);
>  +		zone->watermark[WMARK_HIGH] += cma_wmark_pages(zone);
>  +
>   		setup_zone_migrate_reserve(zone);
>   		spin_unlock_irqrestore(&zone->lock, flags);
>   	}

The fix looks fine, thanks for merging those patches.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



