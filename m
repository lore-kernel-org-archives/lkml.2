Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1LLNmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 08:42:44 -0500
Received: from gir.skynet.ie ([193.1.99.77]:58957 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1LLNmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 08:42:39 -0500
Date: Mon, 12 Dec 2011 13:42:35 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 01/11] mm: page_alloc: handle MIGRATE_ISOLATE in
 free_pcppages_bulk()
Message-ID: <20111212134235.GB3277@csn.ul.ie>
References: <1321634598-16859-1-git-send-email-m.szyprowski@samsung.com>
 <1321634598-16859-2-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1321634598-16859-2-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 05:43:08PM +0100, Marek Szyprowski wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
> 
> If page is on PCP list while pageblock it belongs to gets isolated,
> the page's private still holds the old migrate type.  This means
> that free_pcppages_bulk() will put the page on a freelist of the
> old migrate type instead of MIGRATE_ISOLATE.
> 
> This commit changes that by explicitly checking whether page's
> pageblock's migrate type is MIGRATE_ISOLATE and if it is, overwrites
> page's private data.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  mm/page_alloc.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9dd443d..58d1a2e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -628,6 +628,18 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  			page = list_entry(list->prev, struct page, lru);
>  			/* must delete as __free_one_page list manipulates */
>  			list_del(&page->lru);
> +
> +			/*
> +			 * When page is isolated in set_migratetype_isolate()
> +			 * function it's page_private is not changed since the
> +			 * function has no way of knowing if it can touch it.
> +			 * This means that when a page is on PCP list, it's
> +			 * page_private no longer matches the desired migrate
> +			 * type.
> +			 */
> +			if (get_pageblock_migratetype(page) == MIGRATE_ISOLATE)
> +				set_page_private(page, MIGRATE_ISOLATE);
> +

How much of a problem is this in practice? It's adding overhead to the
free path for what should be a very rare case which is undesirable. I
know we are already calling get_pageblock_migrate() when freeing
pages but it should be unnecessary to call it again. I'd go as far
to say that it would be preferable to drain the per-CPU lists after
you set pageblocks MIGRATE_ISOLATE. The IPIs also have overhead but it
will be incurred for the rare rather than the common case.

-- 
Mel Gorman
SUSE Labs
