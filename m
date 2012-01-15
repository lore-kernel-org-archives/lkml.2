Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750851Ab2AOFet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 00:34:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab2AOFes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 00:34:48 -0500
Date: Sat, 14 Jan 2012 21:34:25 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Hillf Danton <dhillf@gmail.com>
cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmscan: handle isolated pages with lru lock
 released
In-Reply-To: <CAJd=RBAH4+nFQ35JcHju6eSPfDcQpbkJjMX6GBaZFECVaL2swA@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1201142126510.1274@eggly.anvils>
References: <CAJd=RBANeF+TTTtn=F_Yx3N5KkVb5vFPY6FNYEjVntB1pPSLBA@mail.gmail.com> <CAJd=RBAH4+nFQ35JcHju6eSPfDcQpbkJjMX6GBaZFECVaL2swA@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jan 2012, Hillf Danton wrote:
> 
> When shrinking inactive lru list, isolated pages are queued on locally private
> list, so the lock-hold time could be reduced if pages are counted without lock
> protection. To achive that, firstly updating reclaim stat is delayed until the
> putback stage, which is pointed out by Hugh, after reacquiring the lru lock.
> 
> Secondly operations related to vm and zone stats, are now proteced with
> preemption disabled as they are per-cpu operation.
> 
> Thanks for comments and ideas received.
> 
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Thank you, I like this a lot: it undoes a little of the cleanup I just
did, but for much better reason than I had.  I'm running with it now.

Acked-by: Hugh Dickins <hughd@google.com>

> ---
> 
> --- a/mm/vmscan.c	Sat Jan 14 14:02:20 2012
> +++ b/mm/vmscan.c	Sat Jan 14 20:00:46 2012
> @@ -1414,7 +1414,6 @@ update_isolated_counts(struct mem_cgroup
>  		       unsigned long *nr_anon,
>  		       unsigned long *nr_file)
>  {
> -	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
>  	struct zone *zone = mz->zone;
>  	unsigned int count[NR_LRU_LISTS] = { 0, };
>  	unsigned long nr_active = 0;
> @@ -1435,6 +1434,7 @@ update_isolated_counts(struct mem_cgroup
>  		count[lru] += numpages;
>  	}
> 
> +	preempt_disable();
>  	__count_vm_events(PGDEACTIVATE, nr_active);
> 
>  	__mod_zone_page_state(zone, NR_ACTIVE_FILE,
> @@ -1449,8 +1449,9 @@ update_isolated_counts(struct mem_cgroup
>  	*nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
>  	*nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
> 
> -	reclaim_stat->recent_scanned[0] += *nr_anon;
> -	reclaim_stat->recent_scanned[1] += *nr_file;
> +	__mod_zone_page_state(zone, NR_ISOLATED_ANON, *nr_anon);
> +	__mod_zone_page_state(zone, NR_ISOLATED_FILE, *nr_file);
> +	preempt_enable();
>  }
> 
>  /*
> @@ -1512,6 +1513,7 @@ shrink_inactive_list(unsigned long nr_to
>  	unsigned long nr_writeback = 0;
>  	isolate_mode_t reclaim_mode = ISOLATE_INACTIVE;
>  	struct zone *zone = mz->zone;
> +	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
> 
>  	while (unlikely(too_many_isolated(zone, file, sc))) {
>  		congestion_wait(BLK_RW_ASYNC, HZ/10);
> @@ -1546,19 +1548,13 @@ shrink_inactive_list(unsigned long nr_to
>  			__count_zone_vm_events(PGSCAN_DIRECT, zone,
>  					       nr_scanned);
>  	}
> +	spin_unlock_irq(&zone->lru_lock);
> 
> -	if (nr_taken == 0) {
> -		spin_unlock_irq(&zone->lru_lock);
> +	if (nr_taken == 0)
>  		return 0;
> -	}
> 
>  	update_isolated_counts(mz, &page_list, &nr_anon, &nr_file);
> 
> -	__mod_zone_page_state(zone, NR_ISOLATED_ANON, nr_anon);
> -	__mod_zone_page_state(zone, NR_ISOLATED_FILE, nr_file);
> -
> -	spin_unlock_irq(&zone->lru_lock);
> -
>  	nr_reclaimed = shrink_page_list(&page_list, mz, sc, priority,
>  						&nr_dirty, &nr_writeback);
> 
> @@ -1570,6 +1566,9 @@ shrink_inactive_list(unsigned long nr_to
>  	}
> 
>  	spin_lock_irq(&zone->lru_lock);
> +
> +	reclaim_stat->recent_scanned[0] += nr_anon;
> +	reclaim_stat->recent_scanned[1] += nr_file;
> 
>  	if (current_is_kswapd())
>  		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
