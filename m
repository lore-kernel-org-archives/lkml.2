Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936293Ab0CONog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:44:36 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:53190 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab0CONoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:44:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Zijk2CSVd1VCEAfQu3PWF9CoJ8x29iGqGEfVnR0ZPHVZPeiSCtYVi47DDyfdrgKY7l
         Phw+LfTSM4xmao1Py/Sz5nx2au6D7pr+DitCX6XwYbmfaGxIBrx0K+27hC7DPamvvzXh
         aUc6DD9Ig+MBBb/AsTLpDYlAozDxrOJUkiTzs=
Subject: Re: [PATCH 07/11] Memory compaction core
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <1268412087-13536-8-git-send-email-mel@csn.ul.ie>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
	 <1268412087-13536-8-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 22:44:14 +0900
Message-ID: <1268660654.1889.25.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 16:41 +0000, Mel Gorman wrote:
> This patch is the core of a mechanism which compacts memory in a zone by
> relocating movable pages towards the end of the zone.
> 
> A single compaction run involves a migration scanner and a free scanner.
> Both scanners operate on pageblock-sized areas in the zone. The migration
> scanner starts at the bottom of the zone and searches for all movable pages
> within each area, isolating them onto a private list called migratelist.
> The free scanner starts at the top of the zone and searches for suitable
> areas and consumes the free pages within making them available for the
> migration scanner. The pages isolated for migration are then migrated to
> the newly isolated free pages.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

There is below some nitpicks. Otherwise looks good to me. 

..

< snip >

> +/* Update the number of anon and file isolated pages in the zone) */
                                                single parenthesis ^ 

> +void update_zone_isolated(struct zone *zone, struct compact_control *cc)
> +{
> +	struct page *page;
> +	unsigned int count[NR_LRU_LISTS] = { 0, };
> +
> +	list_for_each_entry(page, &cc->migratepages, lru) {
> +		int lru = page_lru_base_type(page);
> +		count[lru]++;
> +	}
> +
> +	cc->nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
> +	cc->nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
> +	__mod_zone_page_state(zone, NR_ISOLATED_ANON, cc->nr_anon);
> +	__mod_zone_page_state(zone, NR_ISOLATED_FILE, cc->nr_file);
> +}
> +

< snip >

> +static unsigned long isolate_migratepages(struct zone *zone,
> +					struct compact_control *cc)
> +{
> +	unsigned long low_pfn, end_pfn;
> +	struct list_head *migratelist;
> +
> +	low_pfn = cc->migrate_pfn;
> +	migratelist = &cc->migratepages;
> +
> +	/* Do not scan outside zone boundaries */
> +	if (low_pfn < zone->zone_start_pfn)
> +		low_pfn = zone->zone_start_pfn;
> +
> +	/* Setup to scan one block but not past where we are migrating to */
> +	end_pfn = ALIGN(low_pfn + pageblock_nr_pages, pageblock_nr_pages);
> +
> +	/* Do not cross the free scanner or scan within a memory hole */
> +	if (end_pfn > cc->free_pfn || !pfn_valid(low_pfn)) {
> +		cc->migrate_pfn = end_pfn;
> +		return 0;
> +	}
> +
> +	migrate_prep();
> +
> +	/* Time to isolate some pages for migration */
> +	spin_lock_irq(&zone->lru_lock);
> +	for (; low_pfn < end_pfn; low_pfn++) {
> +		struct page *page;
> +		if (!pfn_valid_within(low_pfn))
> +			continue;
> +
> +		/* Get the page and skip if free */
> +		page = pfn_to_page(low_pfn);
> +		if (PageBuddy(page)) {
> +			low_pfn += (1 << page_order(page)) - 1;
> +			continue;
> +		}
> +
> +		if (!PageLRU(page) || PageUnevictable(page))
> +			continue;

Do we need this checks?
It is done by __isolate_lru_page. 

Explicit check would make code readability good.
So if you mind it, I don't oppose it, either. 
But other caller of __isolate_lru_pages don't check it, either.

> +		/* Try isolate the page */
> +		if (__isolate_lru_page(page, ISOLATE_BOTH, 0) == 0) {
> +			del_page_from_lru_list(zone, page, page_lru(page));
> +			list_add(&page->lru, migratelist);
> +			mem_cgroup_del_lru(page);
> +			cc->nr_migratepages++;
> +		}
> +
> +		/* Avoid isolating too much */
> +		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
> +			break;
> +	}
> +
> +	update_zone_isolated(zone, cc);
> +
> +	spin_unlock_irq(&zone->lru_lock);
> +	cc->migrate_pfn = low_pfn;
> +
> +	return cc->nr_migratepages;
> +}
> +


-- 
Kind regards,
Minchan Kim


