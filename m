Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161647Ab1FAMjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:39:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:53714 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab1FAMjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:39:19 -0400
Date: Wed, 1 Jun 2011 14:39:13 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        balbir@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] memcg: do not expose uninitialized mem_cgroup_per_node
 to world
Message-ID: <20110601123913.GC4266@tiehlicka.suse.cz>
References: <1306925044-2828-1-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306925044-2828-1-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 01-06-11 12:44:04, Igor Mammedov wrote:
> Freshly allocated 'mem_cgroup_per_node' list entries must be
> initialized before the rest of the kernel can see them. Otherwise
> zero initialized list fields can lead to race condition at
> mem_cgroup_force_empty_list:
>   pc = list_entry(list->prev, struct page_cgroup, lru);
> where 'pc' will be something like 0xfffffffc if list->prev is 0
> and cause page fault later when 'pc' is dereferenced.

Have you ever seen such a race? I do not see how this could happen.
mem_cgroup_force_empty_list is called only from
mem_cgroup_force_empty_write (aka echo whatever > group/force_empty)
or mem_cgroup_pre_destroy when the group is destroyed. 

The initialization code is, however, called before a group is
given for use AFICS.

I am not saying tha the change is bad, I like it, but I do not think it
is a fix for potential race condition.

> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bd9052a..ee7cb4c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4707,7 +4707,6 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
>  	if (!pn)
>  		return 1;
>  
> -	mem->info.nodeinfo[node] = pn;
>  	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>  		mz = &pn->zoneinfo[zone];
>  		for_each_lru(l)
> @@ -4716,6 +4715,7 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
>  		mz->on_tree = false;
>  		mz->mem = mem;
>  	}
> +	mem->info.nodeinfo[node] = pn;
>  	return 0;
>  }
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
