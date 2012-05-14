Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab2ENUOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:14:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58200 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab2ENUOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:14:43 -0400
Date: Mon, 14 May 2012 13:14:38 -0700
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] memcg: move charges to root cgroup if
 use_hierarchy=0.
Message-ID: <20120514201438.GI2366@google.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
 <4FACE0A2.30608@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FACE0A2.30608@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 06:49:22PM +0900, KAMEZAWA Hiroyuki wrote:
> @@ -3351,9 +3339,8 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
>  	struct page_cgroup *pc;
>  	int csize,  ret = 0;
>  	struct res_counter *fail_res;
> -	struct cgroup *pcgrp = cgroup->parent;
> -	struct mem_cgroup *parent = mem_cgroup_from_cont(pcgrp);
>  	struct mem_cgroup *memcg  = mem_cgroup_from_cont(cgroup);
> +	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
>  	struct res_counter *counter;
>  
>  	if (!get_page_unless_zero(page))
> @@ -3366,13 +3353,11 @@ int mem_cgroup_move_hugetlb_parent(int idx, struct cgroup *cgroup,
>  
>  	csize = PAGE_SIZE << compound_order(page);
>  	/* If parent->use_hierarchy == 0, we need to charge parent */
> -	if (!parent->use_hierarchy) {
> -		ret = res_counter_charge(&parent->hugepage[idx],
> -					 csize, &fail_res);
> -		if (ret) {
> -			ret = -EBUSY;
> -			goto err_out;
> -		}
> +	if (!parent) {
> +		parent = root_mem_cgroup;
> +		/* root has no limit */
> +		res_counter_charge_nofail(&parent->hugepage[idx],
> +				 csize, &fail_res);
>  	}
>  	counter = &memcg->hugepage[idx];
>  	res_counter_uncharge_until(counter, counter->parent, csize);

This function can simply return 0 now, so no point in having int
return.  Make it return void?

Also, follow-up patches to cleanup -ENOMEM failure handling in the
callers would be nice.

Thanks.

-- 
tejun
