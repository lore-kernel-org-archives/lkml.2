Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab2FDUW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:22:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48846 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2FDUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:22:27 -0400
Message-ID: <4FCD18FD.5030307@gmail.com>
Date: Mon, 04 Jun 2012 16:22:21 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH v9] mm: compaction: handle incorrect MIGRATE_UNMOVABLE
 type pageblocks
References: <201206041543.56917.b.zolnierkie@samsung.com>
In-Reply-To: <201206041543.56917.b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Returns true if MIGRATE_UNMOVABLE pageblock can be successfully
> + * converted to MIGRATE_MOVABLE type, false otherwise.
> + */
> +static bool can_rescue_unmovable_pageblock(struct page *page, bool locked)
> +{
> +	unsigned long pfn, start_pfn, end_pfn;
> +	struct page *start_page, *end_page, *cursor_page;
> +
> +	pfn = page_to_pfn(page);
> +	start_pfn = pfn&  ~(pageblock_nr_pages - 1);
> +	end_pfn = start_pfn + pageblock_nr_pages - 1;
> +
> +	start_page = pfn_to_page(start_pfn);
> +	end_page = pfn_to_page(end_pfn);
> +
> +	for (cursor_page = start_page, pfn = start_pfn; cursor_page<= end_page;
> +		pfn++, cursor_page++) {
> +		struct zone *zone = page_zone(start_page);
> +		unsigned long flags;
> +
> +		if (!pfn_valid_within(pfn))
> +			continue;
> +
> +		/* Do not deal with pageblocks that overlap zones */
> +		if (page_zone(cursor_page) != zone)
> +			return false;
> +
> +		if (!locked)
> +			spin_lock_irqsave(&zone->lock, flags);
> +
> +		if (PageBuddy(cursor_page)) {
> +			int order = page_order(cursor_page);
>
> -/* Returns true if the page is within a block suitable for migration to */
> -static bool suitable_migration_target(struct page *page)
> +			pfn += (1<<  order) - 1;
> +			cursor_page += (1<<  order) - 1;
> +
> +			if (!locked)
> +				spin_unlock_irqrestore(&zone->lock, flags);
> +			continue;
> +		} else if (page_count(cursor_page) == 0 ||
> +			   PageLRU(cursor_page)) {
> +			if (!locked)
> +				spin_unlock_irqrestore(&zone->lock, flags);
> +			continue;
> +		}
> +
> +		if (!locked)
> +			spin_unlock_irqrestore(&zone->lock, flags);
> +
> +		return false;
> +	}
> +
> +	return true;
> +}

Minchan, are you interest this patch? If yes, can you please rewrite it? This one are
not fixed our pointed issue and can_rescue_unmovable_pageblock() still has plenty bugs.
We can't ack it.

