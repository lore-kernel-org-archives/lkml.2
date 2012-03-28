Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab2C1OHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:07:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767Ab2C1OHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:07:35 -0400
Date: Wed, 28 Mar 2012 16:07:33 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, akpm@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 09/10] memcg: move HugeTLB resource count to parent
 cgroup on memcg removal
Message-ID: <20120328140733.GI20949@tiehlicka.suse.cz>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1331919570-2264-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331919570-2264-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 16-03-12 23:09:29, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> This add support for memcg removal with HugeTLB resource usage.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  include/linux/hugetlb.h    |    6 ++++
>  include/linux/memcontrol.h |   15 +++++++++-
>  mm/hugetlb.c               |   41 ++++++++++++++++++++++++++
>  mm/memcontrol.c            |   68 +++++++++++++++++++++++++++++++++++++------
>  4 files changed, 119 insertions(+), 11 deletions(-)
> 
[...]
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8fd465d..685f0d5 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
[...]
> @@ -3285,10 +3287,57 @@ void mem_cgroup_hugetlb_uncharge_memcg(int idx, unsigned long nr_pages,
>  		res_counter_uncharge(&memcg->hugepage[idx], csize);
>  	return;
>  }
> -#else
> -static bool mem_cgroup_have_hugetlb_usage(struct mem_cgroup *memcg)
> +
> +int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
> +				   struct page *page)
>  {
> -	return 0;
> +	struct page_cgroup *pc;
> +	int csize,  ret = 0;
> +	struct res_counter *fail_res;
> +	struct cgroup *pcgrp = cgroup->parent;
> +	struct mem_cgroup *parent = mem_cgroup_from_cont(pcgrp);
> +	struct mem_cgroup *memcg  = mem_cgroup_from_cont(cgroup);
> +
> +	if (!get_page_unless_zero(page))
> +		goto out;
> +
> +	pc = lookup_page_cgroup(page);
> +	lock_page_cgroup(pc);
> +	if (!PageCgroupUsed(pc) || pc->mem_cgroup != memcg)
> +		goto err_out;
> +
> +	csize = PAGE_SIZE << compound_order(page);
> +	/*
> +	 * uncharge from child and charge the parent. If we have
> +	 * use_hierarchy set, we can never fail here. In-order to make
> +	 * sure we don't get -ENOMEM on parent charge, we first uncharge
> +	 * the child and then charge the parent.
> +	 */
> +	if (parent->use_hierarchy) {
> +		res_counter_uncharge(&memcg->hugepage[idx], csize);
> +		if (!mem_cgroup_is_root(parent))
> +			ret = res_counter_charge(&parent->hugepage[idx],
> +						 csize, &fail_res);

You can still race with other hugetlb charge which would make this fail.

> +	} else {
> +		if (!mem_cgroup_is_root(parent)) {
> +			ret = res_counter_charge(&parent->hugepage[idx],
> +						 csize, &fail_res);
> +			if (ret) {
> +				ret = -EBUSY;
> +				goto err_out;
> +			}
> +		}
> +		res_counter_uncharge(&memcg->hugepage[idx], csize);
> +	}
> +	/*
> +	 * caller should have done css_get
> +	 */
> +	pc->mem_cgroup = parent;
> +err_out:
> +	unlock_page_cgroup(pc);
> +	put_page(page);
> +out:
> +	return ret;
>  }
>  #endif /* CONFIG_MEM_RES_CTLR_HUGETLB */
[...]
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
