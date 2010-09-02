Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab0IBOT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:19:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48486 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab0IBOT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AKMZuElQfdqRe0eAxd0LGWOovudoFFACDf0Ppi1uvsJ+AJ16KNzd83pe91FRTpQu/j
         1Yuw9oj6ja4FpQESQBU6M7XGQyFz2vnYc/isD2RGlW0kPctiA9yEWP4veDepXcyWUo+3
         ASRWk1ao6EQDg3YBJUHO+HhCLd4EtD915LbDs=
MIME-Version: 1.0
In-Reply-To: <20100902131855.GC10265@tiehlicka.suse.cz>
References: <20100822004232.GA11007@localhost>
	<20100823092246.GA25772@tiehlicka.suse.cz>
	<20100831141942.GA30353@localhost>
	<20100901121951.GC6663@tiehlicka.suse.cz>
	<20100901124138.GD6663@tiehlicka.suse.cz>
	<20100902144500.a0d05b08.kamezawa.hiroyu@jp.fujitsu.com>
	<20100902082829.GA10265@tiehlicka.suse.cz>
	<20100902180343.f4232c6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100902092454.GA17971@tiehlicka.suse.cz>
	<AANLkTi=cLzRGPCc3gCubtU7Ggws7yyAK5c7tp4iocv6u@mail.gmail.com>
	<20100902131855.GC10265@tiehlicka.suse.cz>
Date: Thu, 2 Sep 2010 23:19:18 +0900
Message-ID: <AANLkTikYt3Hu_XeNuwAa9KjzfWgpC8cNen6q657ZKmm-@mail.gmail.com>
Subject: Re: [PATCH] Make is_mem_section_removable more conformable with
 offlining code
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/2 Michal Hocko <mhocko@suse.cz>:
> What about this? Just compile tested.
>
> ---
> From a2aaeafbaeb5b195b699df25060128b9e547949c Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Fri, 20 Aug 2010 15:39:16 +0200
> Subject: [PATCH] Make is_mem_section_removable more conformable with offlining code
>
> Currently is_mem_section_removable checks whether each pageblock from
> the given pfn range is of MIGRATE_MOVABLE type or if it is free. If both
> are false then the range is considered non removable.
>
> On the other hand, offlining code (more specifically
> set_migratetype_isolate) doesn't care whether a page is free and instead
> it just checks the migrate type of the page and whether the page's zone
> is movable.
>
> This can lead into a situation when we can mark a node as not removable
> just because a pageblock is MIGRATE_RESERVE and it is not free but still
> movable.
>
> Let's make a common helper is_page_removable which unifies both tests
> at one place.
>
> Do not rely on any of MIGRATE_* types as all others than MIGRATE_MOVABLE
> may be tricky. MIGRATE_RESERVE can be anything that just happened to
> fallback to that allocation, MIGRATE_RECLAIMABLE can be unmovable
> because slab (or what ever) has this page currently in use. If we tried
> to remove those pages and the isolation failed then those blocks
> would get to the MIRAGTE_MOVABLE list and we will end up with the
> unmovable pages in the movable zone.
>
> Let's, instead, check just whether a pageblock contains free or LRU
> pages.
>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  include/linux/mmzone.h |   24 ++++++++++++++++++++++++
>  mm/memory_hotplug.c    |   19 +------------------
>  mm/page_alloc.c        |    5 +----
>  3 files changed, 26 insertions(+), 22 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 6e6e626..0bd941b 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -669,6 +669,30 @@ unsigned long __init node_memmap_size_bytes(int, unsigned long, unsigned long);
>  */
>  #define zone_idx(zone)         ((zone) - (zone)->zone_pgdat->node_zones)
>
> +#ifdef CONFIG_MEMORY_HOTREMOVE
> +/*
> + * A free or LRU pages block are removable
> + * Do not use MIGRATE_MOVABLE because it can be insufficient and
> + * other MIGRATE types are tricky.
> + */
> +static inline bool is_page_removable(struct page *page)
> +{
> +       int page_block = 1 << pageblock_order;
> +       for (page_block > 0) {

for ?

> +               if (PageBuddy(page)) {
> +                       page_block -= page_order(page);
> +               }else if (PageLRU(page))
> +                       page_block--;
> +               else
> +                       return false;
> +       }
> +
> +       return true;
> +}

Hmm. above for is intending to check all pages in the block ?
I'll look into details, tomorrow.

Thanks,
-Kame
