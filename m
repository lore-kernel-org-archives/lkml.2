Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356Ab2B1BPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:15:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50311 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965010Ab2B1BPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:15:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Feb 2012 10:13:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 16/21] mm: handle lruvec relocks in compaction
Message-Id: <20120228101348.fb38e5f2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120223135256.12988.24796.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
	<20120223135256.12988.24796.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 17:52:56 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Prepare for lru_lock splitting in memory compaction code.
> 
> * disable irqs in acct_isolated() for __mod_zone_page_state(),
>   lru_lock isn't required there.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  mm/compaction.c |   30 ++++++++++++++++--------------
>  1 files changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index a976b28..54340e4 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -224,8 +224,10 @@ static void acct_isolated(struct zone *zone, struct compact_control *cc)
>  	list_for_each_entry(page, &cc->migratepages, lru)
>  		count[!!page_is_file_cache(page)]++;
>  
> +	local_irq_disable();
>  	__mod_zone_page_state(zone, NR_ISOLATED_ANON, count[0]);
>  	__mod_zone_page_state(zone, NR_ISOLATED_FILE, count[1]);
> +	local_irq_enable();

Why we need to disable Irq here ??



>  }
>  
>  /* Similar to reclaim, but different enough that they don't share logic */
> @@ -262,7 +264,7 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
>  	unsigned long nr_scanned = 0, nr_isolated = 0;
>  	struct list_head *migratelist = &cc->migratepages;
>  	isolate_mode_t mode = ISOLATE_ACTIVE|ISOLATE_INACTIVE;
> -	struct lruvec *lruvec;
> +	struct lruvec *lruvec = NULL;
>  
>  	/* Do not scan outside zone boundaries */
>  	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
> @@ -294,25 +296,24 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
>  
>  	/* Time to isolate some pages for migration */
>  	cond_resched();
> -	spin_lock_irq(&zone->lru_lock);
>  	for (; low_pfn < end_pfn; low_pfn++) {
>  		struct page *page;
> -		bool locked = true;
>  
>  		/* give a chance to irqs before checking need_resched() */
>  		if (!((low_pfn+1) % SWAP_CLUSTER_MAX)) {
> -			spin_unlock_irq(&zone->lru_lock);
> -			locked = false;
> +			if (lruvec)
> +				unlock_lruvec_irq(lruvec);
> +			lruvec = NULL;
>  		}
> -		if (need_resched() || spin_is_contended(&zone->lru_lock)) {
> -			if (locked)
> -				spin_unlock_irq(&zone->lru_lock);
> +		if (need_resched() ||
> +		    (lruvec && spin_is_contended(&zone->lru_lock))) {
> +			if (lruvec)
> +				unlock_lruvec_irq(lruvec);
> +			lruvec = NULL;
>  			cond_resched();
> -			spin_lock_irq(&zone->lru_lock);
>  			if (fatal_signal_pending(current))
>  				break;
> -		} else if (!locked)
> -			spin_lock_irq(&zone->lru_lock);
> +		}
>  
>  		/*
>  		 * migrate_pfn does not necessarily start aligned to a
> @@ -359,7 +360,7 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
>  			continue;
>  		}
>  
> -		if (!PageLRU(page))
> +		if (!__lock_page_lruvec_irq(&lruvec, page))
>  			continue;

Could you add more comments onto __lock_page_lruvec_irq() ?

Thanks,
-Kame

