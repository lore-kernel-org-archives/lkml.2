Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2JAMak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:30:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab2JAMai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:30:38 -0400
Date: Mon, 1 Oct 2012 14:30:36 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 11/13] memcg: allow a memcg with kmem charges to be
 destructed.
Message-ID: <20121001123036.GI8622@dhcp22.suse.cz>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-12-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347977050-29476-12-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18-09-12 18:04:08, Glauber Costa wrote:
> Because the ultimate goal of the kmem tracking in memcg is to track slab
> pages as well, we can't guarantee that we'll always be able to point a
> page to a particular process, and migrate the charges along with it -
> since in the common case, a page will contain data belonging to multiple
> processes.
> 
> Because of that, when we destroy a memcg, we only make sure the
> destruction will succeed by discounting the kmem charges from the user
> charges when we try to empty the cgroup.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Suleiman Souhlal <suleiman@google.com>

Looks good.
Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index aada601..b05ecac 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -631,6 +631,11 @@ static void disarm_kmem_keys(struct mem_cgroup *memcg)
>  {
>  	if (memcg_kmem_is_accounted(memcg))
>  		static_key_slow_dec(&memcg_kmem_enabled_key);
> +	/*
> +	 * This check can't live in kmem destruction function,
> +	 * since the charges will outlive the cgroup
> +	 */
> +	WARN_ON(res_counter_read_u64(&memcg->kmem, RES_USAGE) != 0);
>  }
>  #else
>  static void disarm_kmem_keys(struct mem_cgroup *memcg)
> @@ -3933,6 +3938,7 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg, bool free_all)
>  	int node, zid, shrink;
>  	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
>  	struct cgroup *cgrp = memcg->css.cgroup;
> +	u64 usage;
>  
>  	css_get(&memcg->css);
>  
> @@ -3966,8 +3972,17 @@ move_account:
>  		mem_cgroup_end_move(memcg);
>  		memcg_oom_recover(memcg);
>  		cond_resched();
> +		/*
> +		 * Kernel memory may not necessarily be trackable to a specific
> +		 * process. So they are not migrated, and therefore we can't
> +		 * expect their value to drop to 0 here.
> +		 *
> +		 * having res filled up with kmem only is enough
> +		 */
> +		usage = res_counter_read_u64(&memcg->res, RES_USAGE) -
> +			res_counter_read_u64(&memcg->kmem, RES_USAGE);
>  	/* "ret" should also be checked to ensure all lists are empty. */
> -	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0 || ret);
> +	} while (usage > 0 || ret);
>  out:
>  	css_put(&memcg->css);
>  	return ret;
> -- 
> 1.7.11.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
