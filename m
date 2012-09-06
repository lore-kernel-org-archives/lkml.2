Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab2IFQey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:34:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60459 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057Ab2IFQex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:34:53 -0400
X-AuditID: cbfee61b-b7f056d000002c30-a5-5048d0abfc52
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Minchan Kim <minchan@kernel.org>
Subject: Re: [RFC v2] memory-hotplug: remove MIGRATE_ISOLATE from
 free_area->free_list
Date: Thu, 06 Sep 2012 18:34:35 +0200
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>, Mel Gorman <mel@csn.ul.ie>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <1346900018-14759-1-git-send-email-minchan@kernel.org>
In-reply-to: <1346900018-14759-1-git-send-email-minchan@kernel.org>
MIME-version: 1.0
Message-id: <201209061834.35473.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQd3VFzwCDDau0rK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZt/c5F3wSrfhxcBZrA+NZwS5GTg4JAROJiw0zWCFsMYkL99az
	dTFycQgJTGeUmNnYzQzhLGWSOP23hwmkik3ASmJi+ypGEFtEQEXiz9N/QDYHh7BAhMTVG5Yg
	YRYBVYmf32ezg9iiAg4SnVMngA1lFnjNJPFn5nNmkISQgJPEs1UdLCA2p4CzxNfXE8Fm8goI
	SvyYfI8FwraU6G6eCjaIWUBLovnNJkYIW15i85q3zBMYBWYhaZmFpGwWkrIFjMyrGEVTC5IL
	ipPSc430ihNzi0vz0vWS83M3MYID8Jn0DsZVDRaHGAU4GJV4eH/muwcIsSaWFVfmHmKU4GBW
	EuGtr/YIEOJNSaysSi3Kjy8qzUktPsQozcGiJM7rdM4uQEggPbEkNTs1tSC1CCbLxMEp1cCY
	tUl5ue/Dj3apKS9uHov9+SvqnuvjeQbuCxqXKB3ZuTXn3jdJOTvtt0vTHtt8WJ2QL3RJ/4rk
	576jc3pZH2xdMKXj3FeWfymZysL/4rQs/OtLg+bzJ77T37eG1ctUbPHq7T59iiVBTfMn8xdP
	3uSfIbJ4+7xXC398ymbgLVL22P7mc2GEQLWfEktxRqKhFnNRcSIAGdq8TTwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 06 September 2012 04:53:38 Minchan Kim wrote:
> Normally, MIGRATE_ISOLATE type is used for memory-hotplug.
> But it's irony type because the pages isolated would exist
> as free page in free_area->free_list[MIGRATE_ISOLATE] so people
> can think of it as allocatable pages but it is *never* allocatable.
> It ends up confusing NR_FREE_PAGES vmstat so it would be
> totally not accurate so some of place which depend on such vmstat
> could reach wrong decision by the context.
> 
> There were already report about it.[1]
> [1] 702d1a6e, memory-hotplug: fix kswapd looping forever problem
> 
> Then, there was other report which is other problem.[2]
> [2] http://www.spinics.net/lists/linux-mm/msg41251.html
> 
> I believe it can make problems in future, too.
> So I hope removing such irony type by another design.
> 
> I hope this patch solves it and let's revert [1] and doesn't need [2].
> 
> * Changelog v1
>  * Fix from Michal's many suggestion
> 
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Wen Congyang <wency@cn.fujitsu.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
> It's very early version which show the concept so I still marked it with RFC.
> I just tested it with simple test and works.
> This patch is needed indepth review from memory-hotplug guys from fujitsu
> because I saw there are lots of patches recenlty they sent to about
> memory-hotplug change. Please take a look at this patch.

[...]

> @@ -948,8 +954,13 @@ static int move_freepages(struct zone *zone,
>  		}
>  
>  		order = page_order(page);
> -		list_move(&page->lru,
> -			  &zone->free_area[order].free_list[migratetype]);
> +		if (migratetype != MIGRATE_ISOLATE) {
> +			list_move(&page->lru,
> +				&zone->free_area[order].free_list[migratetype]);
> +		} else {
> +			list_del(&page->lru);
> +			isolate_free_page(page, order);
> +		}
>  		page += 1 << order;
>  		pages_moved += 1 << order;
>  	}

Shouldn't NR_FREE_PAGES counter be decreased somewhere above?

[ I can see that it is not modified in __free_pages_ok() and
  free_hot_cold_page() because page is still counted as non-free one but
  here situation is different AFAICS. ]

I tested the patch locally here with CONFIG_CMA=y and it causes some
major problems for CMA (multiple errors from dma_alloc_from_contiguous()
about memory ranges being busy and allocation failures).

[ I'm sorry that I don't know more details yet but the issue should be
  easily reproducible. ]

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
