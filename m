Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2GKNsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:48:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab2GKNsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:48:01 -0400
Date: Wed, 11 Jul 2012 15:47:57 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] mm/memcg: calculate max hierarchy limit number
 instead of min
Message-ID: <20120711134757.GC4820@tiehlicka.suse.cz>
References: <a>
 <1342013081-4096-1-git-send-email-liwp.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342013081-4096-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-07-12 21:24:41, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Since hierachical_memory_limit shows "of bytes of memory limit with
> regard to hierarchy under which the memory cgroup is", the count should
> calculate max hierarchy limit when use_hierarchy in order to show hierarchy
> subtree limit. hierachical_memsw_limit is the same case.

No the patch is wrong. The hierarchical limit says when we start
reclaiming in the hierarchy and that one is triggered on smallest limit
up the way to the hierarchy root.

What are you trying to accomplish here?

> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> ---
>  mm/memcontrol.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 69a7d45..6392c0a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3929,10 +3929,10 @@ static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
>  		unsigned long long *mem_limit, unsigned long long *memsw_limit)
>  {
>  	struct cgroup *cgroup;
> -	unsigned long long min_limit, min_memsw_limit, tmp;
> +	unsigned long long max_limit, max_memsw_limit, tmp;
>  
> -	min_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
> -	min_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
> +	max_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
> +	max_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
>  	cgroup = memcg->css.cgroup;
>  	if (!memcg->use_hierarchy)
>  		goto out;
> @@ -3943,13 +3943,13 @@ static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
>  		if (!memcg->use_hierarchy)
>  			break;
>  		tmp = res_counter_read_u64(&memcg->res, RES_LIMIT);
> -		min_limit = min(min_limit, tmp);
> +		max_limit = max(max_limit, tmp);
>  		tmp = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
> -		min_memsw_limit = min(min_memsw_limit, tmp);
> +		max_memsw_limit = max(max_memsw_limit, tmp);
>  	}
>  out:
> -	*mem_limit = min_limit;
> -	*memsw_limit = min_memsw_limit;
> +	*mem_limit = max_limit;
> +	*memsw_limit = max_memsw_limit;
>  }
>  
>  static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
> -- 
> 1.7.5.4
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
