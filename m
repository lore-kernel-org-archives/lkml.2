Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab2K1XwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:52:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab2K1XwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:52:23 -0500
Date: Wed, 28 Nov 2012 15:52:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, David Rientjes <rientjes@google.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFT PATCH v2 4/5] mm: provide more accurate estimation of
 pages occupied by memmap
Message-Id: <20121128155221.df369ce4.akpm@linux-foundation.org>
In-Reply-To: <1353510586-6393-1-git-send-email-jiang.liu@huawei.com>
References: <20121120111942.c9596d3f.akpm@linux-foundation.org>
	<1353510586-6393-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2012 23:09:46 +0800
Jiang Liu <liuj97@gmail.com> wrote:

> Subject: Re: [RFT PATCH v2 4/5] mm: provide more accurate estimation of pages occupied by memmap

How are people to test this?  "does it boot"?

> If SPARSEMEM is enabled, it won't build page structures for
> non-existing pages (holes) within a zone, so provide a more accurate
> estimation of pages occupied by memmap if there are bigger holes within
> the zone.
> 
> And pages for highmem zones' memmap will be allocated from lowmem, so
> charge nr_kernel_pages for that.
> 
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4442,6 +4442,26 @@ void __init set_pageblock_order(void)
>  
>  #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
>  
> +static unsigned long calc_memmap_size(unsigned long spanned_pages,
> +				      unsigned long present_pages)
> +{
> +	unsigned long pages = spanned_pages;
> +
> +	/*
> +	 * Provide a more accurate estimation if there are holes within
> +	 * the zone and SPARSEMEM is in use. If there are holes within the
> +	 * zone, each populated memory region may cost us one or two extra
> +	 * memmap pages due to alignment because memmap pages for each
> +	 * populated regions may not naturally algined on page boundary.
> +	 * So the (present_pages >> 4) heuristic is a tradeoff for that.
> +	 */
> +	if (spanned_pages > present_pages + (present_pages >> 4) &&
> +	    IS_ENABLED(CONFIG_SPARSEMEM))
> +		pages = present_pages;
> +
> +	return PAGE_ALIGN(pages * sizeof(struct page)) >> PAGE_SHIFT;
> +}
> +

I spose we should do this, although it makes no difference as the
compiler will inline calc_memmap_size() into its caller:

--- a/mm/page_alloc.c~mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix
+++ a/mm/page_alloc.c
@@ -4526,8 +4526,8 @@ void __init set_pageblock_order(void)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 
-static unsigned long calc_memmap_size(unsigned long spanned_pages,
-				      unsigned long present_pages)
+static unsigned long __paginginit calc_memmap_size(unsigned long spanned_pages,
+						   unsigned long present_pages)
 {
 	unsigned long pages = spanned_pages;
 

