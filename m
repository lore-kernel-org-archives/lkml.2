Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab2KQSU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 13:20:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47087 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2KQSU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 13:20:26 -0500
Message-ID: <50A7D524.2060809@gmail.com>
Date: Sat, 17 Nov 2012 19:19:16 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mel Gorman <mel@csn.ul.ie>, Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Linaro-mm-sig] [PATCH] mm: skip watermarks check for already
 isolated blocks in split_free_page()
References: <1352357944-14830-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1352357944-14830-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/08/2012 07:59 AM, Marek Szyprowski wrote:
> Since commit 2139cbe627b8 ("cma: fix counting of isolated pages") free
> pages in isolated pageblocks are not accounted to NR_FREE_PAGES counters,
> so watermarks check is not required if one operates on a free page in
> isolated pageblock.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  mm/page_alloc.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index fd154fe..43ab09f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1394,10 +1394,12 @@ int capture_free_page(struct page *page, int alloc_order, int migratetype)
>  	zone = page_zone(page);
>  	order = page_order(page);
>  
> -	/* Obey watermarks as if the page was being allocated */
> -	watermark = low_wmark_pages(zone) + (1 << order);
> -	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
> -		return 0;
> +	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE) {

get_pageblock_migratetype(page) is also called later on in this function
and assigned to the mt variable: maybe the assignment should be moved
before (or inside) the above line?

--
Francesco
