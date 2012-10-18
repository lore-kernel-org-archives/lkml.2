Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab2JRWRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:17:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64121 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2JRWQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:16:58 -0400
Date: Thu, 18 Oct 2012 15:16:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 3/6] memcg: Simplify mem_cgroup_force_empty_list error
 handling
Message-ID: <20121018221654.GP13370@google.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-4-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350480648-10905-4-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Oct 17, 2012 at 03:30:45PM +0200, Michal Hocko wrote:
> mem_cgroup_force_empty_list currently tries to remove all pages from
> the given LRU. To prevent from temoporary failures (EBUSY returned by
> mem_cgroup_move_parent) it uses a margin to the current LRU pages and
> returns the true if there are still some pages left on the list.
> 
> If we consider that mem_cgroup_move_parent fails only when we are racing
> with somebody else removing the page (resp. uncharging it) or when the
> page is migrated then it is obvious that all those failures are only
> temporal and so we can safely retry later.
> Let's get rid of the safety margin and make the loop really wait for the
> empty LRU. The caller should still make sure that all charges have been
> removed from the res_counter because mem_cgroup_replace_page_cache might
> add a page to the LRU after the check (it doesn't touch res_counter
> though).
> This catches most of the cases except for shmem which might call
> mem_cgroup_replace_page_cache with a page which is not charged and on
> the LRU yet but this was the case also without this patch. In order to
> fix this we need a guarantee that try_get_mem_cgroup_from_page falls
> back to the current mm's cgroup so it needs css_tryget to fail. This
> will be fixed up in a later patch because it nees a help from cgroup
> core.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

In the sense that "I looked at it and nothing seemed too scary".

 Reviewed-by: Tejun Heo <tj@kernel.org>

Some nitpicks below.

>  /*
> - * move charges to its parent.
> + * move charges to its parent or the root cgroup if the group
> + * has no parent (aka use_hierarchy==0).
> + * Although this might fail the failure is always temporary and it
> + * signals a race with a page removal/uncharge or migration. In the
> + * first case the page will vanish from the LRU on the next attempt
> + * and the call should be retried later.
>   */
> -

Maybe convert to proper /** function comment while at it?  I also
think it would be helpful to actually comment on each possible failure
case explaining why the failure condition is temporal.

>  /*
>   * Traverse a specified page_cgroup list and try to drop them all.  This doesn't
> - * reclaim the pages page themselves - it just removes the page_cgroups.
> - * Returns true if some page_cgroups were not freed, indicating that the caller
> - * must retry this operation.
> + * reclaim the pages page themselves - pages are moved to the parent (or root)
> + * group.
>   */

Ditto.

> -static bool mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
> +static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>  				int node, int zid, enum lru_list lru)
>  {
>  	struct mem_cgroup_per_zone *mz;
> -	unsigned long flags, loop;
> +	unsigned long flags;
>  	struct list_head *list;
>  	struct page *busy;
>  	struct zone *zone;
> @@ -3696,11 +3701,8 @@ static bool mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>  	mz = mem_cgroup_zoneinfo(memcg, node, zid);
>  	list = &mz->lruvec.lists[lru];
>  
> -	loop = mz->lru_size[lru];
> -	/* give some margin against EBUSY etc...*/
> -	loop += 256;
>  	busy = NULL;
> -	while (loop--) {
> +	do {
>  		struct page_cgroup *pc;
>  		struct page *page;
>  
> @@ -3726,8 +3728,7 @@ static bool mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>  			cond_resched();
>  		} else
>  			busy = NULL;
> -	}
> -	return !list_empty(list);
> +	} while (!list_empty(list));
>  }

Is there anything which can keep failing until migration to another
cgroup is complete?  I think there is, e.g., if mmap_sem is busy or
memcg is co-mounted with other controllers and another controller's
->attach() is blocking on something.

If so, busy-looping blindly probably isn't a good idea and we would
want at least msleep between retries (e.g. have two lists, throw
failed ones to the other and sleep shortly when switching the front
and back lists).

> +		/*
> +		 * This is a safety check because mem_cgroup_force_empty_list
> +		 * could have raced with mem_cgroup_replace_page_cache callers
> +		 * so the lru seemed empty but the page could have been added
> +		 * right after the check. RES_USAGE should be safe as we always
> +		 * charge before adding to the LRU.
> +		 */
> +	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0);

Maybe we want to trigger some warning if retry count gets too high?
At least for now?

Thanks.

-- 
tejun
