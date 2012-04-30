Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab2D3JAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:00:30 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:60731 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab2D3JA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:00:28 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "cgroups\@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Han Ying <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com
Subject: Re: [RFC][PATCH 4/7 v2] memcg: use res_counter_uncharge_until in move_parent
In-Reply-To: <4F9A34B2.8080103@jp.fujitsu.com>
References: <4F9A327A.6050409@jp.fujitsu.com> <4F9A34B2.8080103@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 30 Apr 2012 14:30:10 +0530
Message-ID: <87vckh8uhx.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12042922-9264-0000-0000-0000015C9FE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> By using res_counter_uncharge_until(), we can avoid 
> unnecessary charging.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

> ---
>  mm/memcontrol.c |   63 ++++++++++++++++++++++++++++++++++++------------------
>  1 files changed, 42 insertions(+), 21 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 613bb15..ed53d64 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2420,6 +2420,24 @@ static void __mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
>  }
>
>  /*
> + * Cancel chages in this cgroup....doesn't propagates to parent cgroup.
> + * This is useful when moving usage to parent cgroup.
> + */
> +static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
> +					unsigned int nr_pages)
> +{
> +	if (!mem_cgroup_is_root(memcg)) {
> +		unsigned long bytes = nr_pages * PAGE_SIZE;
> +
> +		res_counter_uncharge_until(&memcg->res,
> +					memcg->res.parent, bytes);
> +		if (do_swap_account)
> +			res_counter_uncharge_until(&memcg->memsw,
> +						memcg->memsw.parent, bytes);
> +	}
> +}
> +
> +/*
>   * A helper function to get mem_cgroup from ID. must be called under
>   * rcu_read_lock(). The caller must check css_is_removed() or some if
>   * it's concern. (dropping refcnt from swap can be called against removed
> @@ -2677,16 +2695,28 @@ static int mem_cgroup_move_parent(struct page *page,
>  	nr_pages = hpage_nr_pages(page);
>
>  	parent = mem_cgroup_from_cont(pcg);
> -	ret = __mem_cgroup_try_charge(NULL, gfp_mask, nr_pages, &parent, false);
> -	if (ret)
> -		goto put_back;
> +	if (!parent->use_hierarchy) {
> +		ret = __mem_cgroup_try_charge(NULL,
> +					gfp_mask, nr_pages, &parent, false);
> +		if (ret)
> +			goto put_back;
> +	}
>
>  	if (nr_pages > 1)
>  		flags = compound_lock_irqsave(page);
>
> -	ret = mem_cgroup_move_account(page, nr_pages, pc, child, parent, true);
> -	if (ret)
> -		__mem_cgroup_cancel_charge(parent, nr_pages);
> +	if (parent->use_hierarchy) {
> +		ret = mem_cgroup_move_account(page, nr_pages,
> +					pc, child, parent, false);
> +		if (!ret)
> +			__mem_cgroup_cancel_local_charge(child, nr_pages);
> +	} else {
> +		ret = mem_cgroup_move_account(page, nr_pages,
> +					pc, child, parent, true);
> +
> +		if (ret)
> +			__mem_cgroup_cancel_charge(parent, nr_pages);
> +	}
>

May be a comment around this ? I had to look closer to find why
there is a if (!ret) and if (ret) difference. 


>  	if (nr_pages > 1)
>  		compound_unlock_irqrestore(page, flags);
> @@ -3295,6 +3325,7 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
>  	struct cgroup *pcgrp = cgroup->parent;
>  	struct mem_cgroup *parent = mem_cgroup_from_cont(pcgrp);
>  	struct mem_cgroup *memcg  = mem_cgroup_from_cont(cgroup);
> +	struct res_counter *counter;
>
>  	if (!get_page_unless_zero(page))
>  		goto out;
> @@ -3305,28 +3336,18 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
>  		goto err_out;
>
>  	csize = PAGE_SIZE << compound_order(page);
> -	/*
> -	 * If we have use_hierarchy set we can never fail here. So instead of
> -	 * using res_counter_uncharge use the open-coded variant which just
> -	 * uncharge the child res_counter. The parent will retain the charge.
> -	 */
> -	if (parent->use_hierarchy) {
> -		unsigned long flags;
> -		struct res_counter *counter;
> -
> -		counter = &memcg->hugepage[idx];
> -		spin_lock_irqsave(&counter->lock, flags);
> -		res_counter_uncharge_locked(counter, csize);
> -		spin_unlock_irqrestore(&counter->lock, flags);
> -	} else {
> +	/* If parent->use_hierarchy == 0, we need to charge parent */
> +	if (!parent->use_hierarchy) {
>  		ret = res_counter_charge(&parent->hugepage[idx],
>  					 csize, &fail_res);
>  		if (ret) {
>  			ret = -EBUSY;
>  			goto err_out;
>  		}
> -		res_counter_uncharge(&memcg->hugepage[idx], csize);
>  	}
> +	counter = &memcg->hugepage[idx];
> +	res_counter_uncharge_until(counter, counter->parent, csize);
> +
>  	pc->mem_cgroup = parent;
>  err_out:
>  	unlock_page_cgroup(pc);

-aneesh

