Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab1FINdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:33:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757891Ab1FINdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:33:32 -0400
Date: Thu, 9 Jun 2011 14:33:27 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v3 01/10] compaction: trivial clean up acct_isolated
Message-ID: <20110609133327.GT5247@suse.de>
References: <cover.1307455422.git.minchan.kim@gmail.com>
 <71a79768ff8ef356db09493dbb5d6c390e176e0d.1307455422.git.minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <71a79768ff8ef356db09493dbb5d6c390e176e0d.1307455422.git.minchan.kim@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 11:38:14PM +0900, Minchan Kim wrote:
> acct_isolated of compaction uses page_lru_base_type which returns only
> base type of LRU list so it never returns LRU_ACTIVE_ANON or LRU_ACTIVE_FILE.
> In addtion, cc->nr_[anon|file] is used in only acct_isolated so it doesn't have
> fields in conpact_control.
> This patch removes fields from compact_control and makes clear function of
> acct_issolated which counts the number of anon|file pages isolated.
> 
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/compaction.c |   18 +++++-------------
>  1 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 021a296..61eab88 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -35,10 +35,6 @@ struct compact_control {
>  	unsigned long migrate_pfn;	/* isolate_migratepages search base */
>  	bool sync;			/* Synchronous migration */
>  
> -	/* Account for isolated anon and file pages */
> -	unsigned long nr_anon;
> -	unsigned long nr_file;
> -
>  	unsigned int order;		/* order a direct compactor needs */
>  	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
>  	struct zone *zone;
> @@ -212,17 +208,13 @@ static void isolate_freepages(struct zone *zone,
>  static void acct_isolated(struct zone *zone, struct compact_control *cc)
>  {
>  	struct page *page;
> -	unsigned int count[NR_LRU_LISTS] = { 0, };
> +	unsigned int count[2] = { 0, };
>  
> -	list_for_each_entry(page, &cc->migratepages, lru) {
> -		int lru = page_lru_base_type(page);
> -		count[lru]++;
> -	}
> +	list_for_each_entry(page, &cc->migratepages, lru)
> +		count[!!page_is_file_cache(page)]++;
>  
> -	cc->nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
> -	cc->nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
> -	__mod_zone_page_state(zone, NR_ISOLATED_ANON, cc->nr_anon);
> -	__mod_zone_page_state(zone, NR_ISOLATED_FILE, cc->nr_file);
> +	__mod_zone_page_state(zone, NR_ISOLATED_ANON, count[0]);
> +	__mod_zone_page_state(zone, NR_ISOLATED_FILE, count[1]);

You are hard-coding assumptions about the value of LRU_INACTIVE_ANON
and LRU_INACTIVE_FILE here. I have no expectation that these will
change but who knows for sure? To be robust against unexpected
changes, count should still be NR_LRU_LISTS and you should use the
LRU_INACTIVE_ANON and LRU_INACTIVE_FILE values.

I agree that summing LRU_ACTIVE_* is silly.

-- 
Mel Gorman
SUSE Labs
