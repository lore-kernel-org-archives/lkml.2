Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab2GIPKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 11:10:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab2GIPKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 11:10:32 -0400
Date: Mon, 9 Jul 2012 17:10:30 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 06/11] mm: memcg: move swapin charge functions above
 callsites
Message-ID: <20120709151029.GI4627@tiehlicka.suse.cz>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-7-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341449103-1986-7-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 05-07-12 02:44:58, Johannes Weiner wrote:
> Charging cache pages may require swapin in the shmem case.  Save the
> forward declaration and just move the swapin functions above the cache
> charging functions.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

OK
Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |   68 +++++++++++++++++++++++++-----------------------------
>  1 files changed, 32 insertions(+), 36 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3d56b4e..4a41b55 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2729,37 +2729,6 @@ int mem_cgroup_newpage_charge(struct page *page,
>  					MEM_CGROUP_CHARGE_TYPE_ANON);
>  }
>  
> -static void
> -__mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr,
> -					enum charge_type ctype);
> -
> -int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
> -				gfp_t gfp_mask)
> -{
> -	struct mem_cgroup *memcg = NULL;
> -	enum charge_type type = MEM_CGROUP_CHARGE_TYPE_CACHE;
> -	int ret;
> -
> -	if (mem_cgroup_disabled())
> -		return 0;
> -	if (PageCompound(page))
> -		return 0;
> -
> -	if (unlikely(!mm))
> -		mm = &init_mm;
> -	if (!page_is_file_cache(page))
> -		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
> -
> -	if (!PageSwapCache(page))
> -		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
> -	else { /* page is swapcache/shmem */
> -		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &memcg);
> -		if (!ret)
> -			__mem_cgroup_commit_charge_swapin(page, memcg, type);
> -	}
> -	return ret;
> -}
> -
>  /*
>   * While swap-in, try_charge -> commit or cancel, the page is locked.
>   * And when try_charge() successfully returns, one refcnt to memcg without
> @@ -2806,6 +2775,15 @@ int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
>  	return ret;
>  }
>  
> +void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg)
> +{
> +	if (mem_cgroup_disabled())
> +		return;
> +	if (!memcg)
> +		return;
> +	__mem_cgroup_cancel_charge(memcg, 1);
> +}
> +
>  static void
>  __mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *memcg,
>  					enum charge_type ctype)
> @@ -2843,13 +2821,31 @@ void mem_cgroup_commit_charge_swapin(struct page *page,
>  					  MEM_CGROUP_CHARGE_TYPE_ANON);
>  }
>  
> -void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *memcg)
> +int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
> +				gfp_t gfp_mask)
>  {
> +	struct mem_cgroup *memcg = NULL;
> +	enum charge_type type = MEM_CGROUP_CHARGE_TYPE_CACHE;
> +	int ret;
> +
>  	if (mem_cgroup_disabled())
> -		return;
> -	if (!memcg)
> -		return;
> -	__mem_cgroup_cancel_charge(memcg, 1);
> +		return 0;
> +	if (PageCompound(page))
> +		return 0;
> +
> +	if (unlikely(!mm))
> +		mm = &init_mm;
> +	if (!page_is_file_cache(page))
> +		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
> +
> +	if (!PageSwapCache(page))
> +		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
> +	else { /* page is swapcache/shmem */
> +		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &memcg);
> +		if (!ret)
> +			__mem_cgroup_commit_charge_swapin(page, memcg, type);
> +	}
> +	return ret;
>  }
>  
>  static void mem_cgroup_do_uncharge(struct mem_cgroup *memcg,
> -- 
> 1.7.7.6
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
