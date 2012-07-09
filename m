Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2GIPcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 11:32:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab2GIPc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 11:32:28 -0400
Date: Mon, 9 Jul 2012 17:32:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 10/11] mm: memcg: only check swap cache pages for
 repeated charging
Message-ID: <20120709153226.GM4627@tiehlicka.suse.cz>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-11-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341449103-1986-11-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 05-07-12 02:45:02, Johannes Weiner wrote:
> Only anon and shmem pages in the swap cache are attempted to be
> charged multiple times, from every swap pte fault or from
> shmem_unuse().  No other pages require checking PageCgroupUsed().
> 
> Charging pages in the swap cache is also serialized by the page lock,
> and since both the try_charge and commit_charge are called under the
> same page lock section, the PageCgroupUsed() check might as well
> happen before the counter charging, let alone reclaim.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a8bf86a..d3701cd 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2471,11 +2471,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
>  	bool anon;
>  
>  	lock_page_cgroup(pc);
> -	if (unlikely(PageCgroupUsed(pc))) {
> -		unlock_page_cgroup(pc);
> -		__mem_cgroup_cancel_charge(memcg, nr_pages);
> -		return;
> -	}
> +	VM_BUG_ON(PageCgroupUsed(pc));
>  	/*
>  	 * we don't need page_cgroup_lock about tail pages, becase they are not
>  	 * accessed by any other context at this point.
> @@ -2740,8 +2736,19 @@ static int __mem_cgroup_try_charge_swapin(struct mm_struct *mm,
>  					  struct mem_cgroup **memcgp)
>  {
>  	struct mem_cgroup *memcg;
> +	struct page_cgroup *pc;
>  	int ret;
>  
> +	pc = lookup_page_cgroup(page);
> +	/*
> +	 * Every swap fault against a single page tries to charge the
> +	 * page, bail as early as possible.  shmem_unuse() encounters
> +	 * already charged pages, too.  The USED bit is protected by
> +	 * the page lock, which serializes swap cache removal, which
> +	 * in turn serializes uncharging.
> +	 */
> +	if (PageCgroupUsed(pc))
> +		return 0;
>  	if (!do_swap_account)
>  		goto charge_cur_mm;
>  	/*
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
