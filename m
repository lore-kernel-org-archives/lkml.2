Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab2BCOEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:04:33 -0500
Received: from gir.skynet.ie ([193.1.99.77]:60258 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab2BCOEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:04:32 -0500
Date: Fri, 3 Feb 2012 14:04:28 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Clark <rob.clark@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH 11/15] mm: trigger page reclaim in alloc_contig_range()
 to stabilize watermarks
Message-ID: <20120203140428.GG5796@csn.ul.ie>
References: <1328271538-14502-1-git-send-email-m.szyprowski@samsung.com>
 <1328271538-14502-12-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1328271538-14502-12-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 01:18:54PM +0100, Marek Szyprowski wrote:
> alloc_contig_range() performs memory allocation so it also should keep
> track on keeping the correct level of memory watermarks. This commit adds
> a call to *_slowpath style reclaim to grab enough pages to make sure that
> the final collection of contiguous pages from freelists will not starve
> the system.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Michal Nazarewicz <mina86@mina86.com>
> Tested-by: Rob Clark <rob.clark@linaro.org>
> Tested-by: Ohad Ben-Cohen <ohad@wizery.com>
> Tested-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

I still do not intend to ack this patch and any damage is confined to
CMA but I have a few comments anyway.

> ---
>  mm/page_alloc.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 47 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 983ccba..371a79f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5632,6 +5632,46 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
>  	return ret > 0 ? 0 : ret;
>  }
>  
> +/*
> + * Trigger memory pressure bump to reclaim some pages in order to be able to
> + * allocate 'count' pages in single page units. Does similar work as
> + *__alloc_pages_slowpath() function.
> + */
> +static int __reclaim_pages(struct zone *zone, gfp_t gfp_mask, int count)
> +{
> +	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
> +	struct zonelist *zonelist = node_zonelist(0, gfp_mask);
> +	int did_some_progress = 0;
> +	int order = 1;
> +	unsigned long watermark;
> +
> +	/*
> +	 * Increase level of watermarks to force kswapd do his job
> +	 * to stabilize at new watermark level.
> +	 */
> +	min_free_kbytes += count * PAGE_SIZE / 1024;

There is a risk of overflow here although it is incredibly
small. Still, a potentially nicer way of doing this was

count << (PAGE_SHIFT - 10)

> +	setup_per_zone_wmarks();
> +

Nothing prevents two or more processes updating the wmarks at the same
time which is racy and unpredictable. Today it is not much of a problem
but CMA makes this path hotter than it was and you may see weirdness
if two processes are updating zonelists at the same time. Swap-over-NFS
actually starts with a patch that serialises setup_per_zone_wmarks()

You also potentially have a BIG problem here if this happens

min_free_kbytes = 32768
Process a: min_free_kbytes  += 65536
Process a: start direct reclaim
echo 16374 > /proc/sys/vm/min_free_kbytes
Process a: exit direct_reclaim
Process a: min_free_kbytes -= 65536

min_free_kbytes now wraps negative and the machine hangs.

The damage is confined to CMA though so I am not going to lose sleep
over it but you might want to consider at least preventing parallel
updates to min_free_kbytes from proc.

-- 
Mel Gorman
SUSE Labs
