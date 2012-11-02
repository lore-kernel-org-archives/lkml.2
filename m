Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761040Ab2KBJzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:55:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57385 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760420Ab2KBJzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:55:07 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50939867.1050205@jp.fujitsu.com>
Date: Fri, 02 Nov 2012 18:54:47 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, hannes@cmpxchg.org, mhocko@suse.cz,
        bsingharora@gmail.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] memcg: make mem_cgroup_reparent_charges non failing
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <1351657365-25055-7-git-send-email-tj@kernel.org>
In-Reply-To: <1351657365-25055-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/31 13:22), Tejun Heo wrote:
> From: Michal Hocko <mhocko@suse.cz>
> 
> Now that pre_destroy callbacks are called from the context where neither
> any task can attach the group nor any children group can be added there
> is no other way to fail from mem_cgroup_pre_destroy.
> mem_cgroup_pre_destroy doesn't have to take a reference to memcg's css
> because all css' are marked dead already.
> 
> tj: Remove now unused local variable @cgrp from
>      mem_cgroup_reparent_charges().
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Glauber Costa <glommer@parallels.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>

+1
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
>   mm/memcontrol.c | 19 ++++++-------------
>   1 file changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1033b2b..47c4680 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3740,14 +3740,11 @@ static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>    *
>    * Caller is responsible for holding css reference on the memcg.
>    */
> -static int mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
> +static void mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
>   {
> -	struct cgroup *cgrp = memcg->css.cgroup;
>   	int node, zid;
>   
>   	do {
> -		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
> -			return -EBUSY;
>   		/* This is for making all *used* pages to be on LRU. */
>   		lru_add_drain_all();
>   		drain_all_stock_sync(memcg);
> @@ -3773,8 +3770,6 @@ static int mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
>   		 * charge before adding to the LRU.
>   		 */
>   	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0);
> -
> -	return 0;
>   }
>   
>   /*
> @@ -3811,7 +3806,9 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
>   
>   	}
>   	lru_add_drain();
> -	return mem_cgroup_reparent_charges(memcg);
> +	mem_cgroup_reparent_charges(memcg);
> +
> +	return 0;
>   }
>   
>   static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
> @@ -5008,13 +5005,9 @@ free_out:
>   static int mem_cgroup_pre_destroy(struct cgroup *cont)
>   {
>   	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> -	int ret;
>   
> -	css_get(&memcg->css);
> -	ret = mem_cgroup_reparent_charges(memcg);
> -	css_put(&memcg->css);
> -
> -	return ret;
> +	mem_cgroup_reparent_charges(memcg);
> +	return 0;
>   }
>   
>   static void mem_cgroup_destroy(struct cgroup *cont)
> 


