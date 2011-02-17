Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1BQP46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:56:58 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51659 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1BQP44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:56:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 18 Feb 2011 00:50:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Barrett <damentz@liquorix.net>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 1/4] deactivate invalidated pages
Message-Id: <20110218005020.d202acd2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <5677f3262774f4ddc24044065b7cbd6443ac5e16.1297940291.git.minchan.kim@gmail.com>
References: <cover.1297940291.git.minchan.kim@gmail.com>
	<5677f3262774f4ddc24044065b7cbd6443ac5e16.1297940291.git.minchan.kim@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011 00:08:19 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Recently, there are reported problem about thrashing.
> (http://marc.info/?l=rsync&m=128885034930933&w=2)
> It happens by backup workloads(ex, nightly rsync).
> That's because the workload makes just use-once pages
> and touches pages twice. It promotes the page into
> active list so that it results in working set page eviction.
> 
> Some app developer want to support POSIX_FADV_NOREUSE.
> But other OSes don't support it, either.
> (http://marc.info/?l=linux-mm&m=128928979512086&w=2)
> 
> By other approach, app developers use POSIX_FADV_DONTNEED.
> But it has a problem. If kernel meets page is writing
> during invalidate_mapping_pages, it can't work.
> It makes for application programmer to use it since they always 
> have to sync data before calling fadivse(..POSIX_FADV_DONTNEED) to 
> make sure the pages could be discardable. At last, they can't use
> deferred write of kernel so that they could see performance loss.
> (http://insights.oetiker.ch/linux/fadvise.html)
> 
> In fact, invalidation is very big hint to reclaimer.
> It means we don't use the page any more. So let's move
> the writing page into inactive list's head if we can't truncate 
> it right now.
> 
> Why I move page to head of lru on this patch, Dirty/Writeback page 
> would be flushed sooner or later. It can prevent writeout of pageout 
> which is less effective than flusher's writeout.
> 
> Originally, I reused lru_demote of Peter with some change so added
> his Signed-off-by.
> 
> Reported-by: Ben Gamari <bgamari.foss@gmail.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>


Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

One question is ....it seems there is no flush() code for percpu pagevec
in this patch. Is it safe against cpu hot plug ?

And from memory hot unplug point of view, I'm grad if pagevec for this
is flushed at the same time as when we clear other per-cpu lru pagevecs.
(And compaction will be affected by the page_count() magic by pagevec
 which is flushed only when FADVISE is called.)

Could you add add-on patches for flushing and hooks ?

Thanks,
-Kame



> ---
> Changelog since v4:
>  - Change function comments - suggested by Johannes
>  - Change function name - suggested by Johannes
>  - Drop only dirty/writeback pages to deactive pagevec - suggested by Johannes
>  - Add acked-by
> 
> Changelog since v3:
>  - Change function comments - suggested by Johannes
>  - Change function name - suggested by Johannes
>  - add only dirty/writeback pages to deactive pagevec
> 
> Changelog since v2:
>  - mapped page leaves alone - suggested by Mel
>  - pass part related PG_reclaim in next patch.
> 
> Changelog since v1:
>  - modify description
>  - correct typo
>  - add some comment
> 
>  include/linux/swap.h |    1 +
>  mm/swap.c            |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/truncate.c        |   17 ++++++++---
>  3 files changed, 91 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 4d55932..c335055 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -215,6 +215,7 @@ extern void mark_page_accessed(struct page *);
>  extern void lru_add_drain(void);
>  extern int lru_add_drain_all(void);
>  extern void rotate_reclaimable_page(struct page *page);
> +extern void deactivate_page(struct page *page);
>  extern void swap_setup(void);
>  
>  extern void add_page_to_unevictable_list(struct page *page);
> diff --git a/mm/swap.c b/mm/swap.c
> index c02f936..4aea806 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -39,6 +39,7 @@ int page_cluster;
>  
>  static DEFINE_PER_CPU(struct pagevec[NR_LRU_LISTS], lru_add_pvecs);
>  static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
> +static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
>  
>  /*
>   * This path almost never happens for VM activity - pages are normally
> @@ -347,6 +348,60 @@ void add_page_to_unevictable_list(struct page *page)
>  }
>  
>  /*
> + * If the page can not be invalidated, it is moved to the
> + * inactive list to speed up its reclaim.  It is moved to the
> + * head of the list, rather than the tail, to give the flusher
> + * threads some time to write it out, as this is much more
> + * effective than the single-page writeout from reclaim.
> + */
> +static void lru_deactivate(struct page *page, struct zone *zone)
> +{
> +	int lru, file;
> +
> +	if (!PageLRU(page) || !PageActive(page))
> +		return;
> +
> +	/* Some processes are using the page */
> +	if (page_mapped(page))
> +		return;
> +
> +	file = page_is_file_cache(page);
> +	lru = page_lru_base_type(page);
> +	del_page_from_lru_list(zone, page, lru + LRU_ACTIVE);
> +	ClearPageActive(page);
> +	ClearPageReferenced(page);
> +	add_page_to_lru_list(zone, page, lru);
> +	__count_vm_event(PGDEACTIVATE);
> +
> +	update_page_reclaim_stat(zone, page, file, 0);
> +}
> +
> +static void ____pagevec_lru_deactivate(struct pagevec *pvec)
> +{
> +	int i;
> +	struct zone *zone = NULL;
> +
> +	for (i = 0; i < pagevec_count(pvec); i++) {
> +		struct page *page = pvec->pages[i];
> +		struct zone *pagezone = page_zone(page);
> +
> +		if (pagezone != zone) {
> +			if (zone)
> +				spin_unlock_irq(&zone->lru_lock);
> +			zone = pagezone;
> +			spin_lock_irq(&zone->lru_lock);
> +		}
> +		lru_deactivate(page, zone);
> +	}
> +	if (zone)
> +		spin_unlock_irq(&zone->lru_lock);
> +
> +	release_pages(pvec->pages, pvec->nr, pvec->cold);
> +	pagevec_reinit(pvec);
> +}
> +
> +
> +/*
>   * Drain pages out of the cpu's pagevecs.
>   * Either "cpu" is the current CPU, and preemption has already been
>   * disabled; or "cpu" is being hot-unplugged, and is already dead.
> @@ -372,6 +427,29 @@ static void drain_cpu_pagevecs(int cpu)
>  		pagevec_move_tail(pvec);
>  		local_irq_restore(flags);
>  	}
> +
> +	pvec = &per_cpu(lru_deactivate_pvecs, cpu);
> +	if (pagevec_count(pvec))
> +		____pagevec_lru_deactivate(pvec);
> +}
> +
> +/**
> + * deactivate_page - forcefully deactivate a page
> + * @page: page to deactivate
> + *
> + * This function hints the VM that @page is a good reclaim candidate,
> + * for example if its invalidation fails due to the page being dirty
> + * or under writeback.
> + */
> +void deactivate_page(struct page *page)
> +{
> +	if (likely(get_page_unless_zero(page))) {
> +		struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
> +
> +		if (!pagevec_add(pvec, page))
> +			____pagevec_lru_deactivate(pvec);
> +		put_cpu_var(lru_deactivate_pvecs);
> +	}
>  }
>  
>  void lru_add_drain(void)
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 4d415b3..9ec7bc5 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -328,11 +328,12 @@ EXPORT_SYMBOL(truncate_inode_pages);
>   * pagetables.
>   */
>  unsigned long invalidate_mapping_pages(struct address_space *mapping,
> -				       pgoff_t start, pgoff_t end)
> +		pgoff_t start, pgoff_t end)
>  {
>  	struct pagevec pvec;
>  	pgoff_t next = start;
> -	unsigned long ret = 0;
> +	unsigned long ret;
> +	unsigned long count = 0;
>  	int i;
>  
>  	pagevec_init(&pvec, 0);
> @@ -359,8 +360,14 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
>  			if (lock_failed)
>  				continue;
>  
> -			ret += invalidate_inode_page(page);
> -
> +			ret = invalidate_inode_page(page);
> +			/*
> +			 * Invalidation is a hint that the page is no longer
> +			 * of interest and try to speed up its reclaim.
> +			 */
> +			if (!ret)
> +				deactivate_page(page);
> +			count += ret;
>  			unlock_page(page);
>  			if (next > end)
>  				break;
> @@ -369,7 +376,7 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
>  		mem_cgroup_uncharge_end();
>  		cond_resched();
>  	}
> -	return ret;
> +	return count;
>  }
>  EXPORT_SYMBOL(invalidate_mapping_pages);
>  
> -- 
> 1.7.1
> 
> 

