Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2ATIps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 03:45:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab2ATIpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 03:45:47 -0500
Date: Fri, 20 Jan 2012 09:45:45 +0100
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH v3] memcg: remove PCG_CACHE page_cgroup flag
Message-ID: <20120120084545.GC9655@tiehlicka.suse.cz>
References: <20120119181711.8d697a6b.kamezawa.hiroyu@jp.fujitsu.com>
 <20120120122658.1b14b512.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120122658.1b14b512.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 20-01-12 12:26:58, KAMEZAWA Hiroyuki wrote:
> I think this version is much simplified.
> 
> ==
> From 5700a4fe9c581e1ebaa021ba6119dc8d921b024f Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 19 Jan 2012 17:09:41 +0900
> Subject: [PATCH v3] memcg: remove PCG_CACHE
> 
> We record 'the page is cache' by PCG_CACHE bit to page_cgroup.
> Here, "CACHE" means anonymous user pages (and SwapCache). This
> doesn't include shmem.
> 
> Consdering callers, at charge/uncharge, the caller should know
> what  the page is and we don't need to record it by using 1bit
> per page.
> 
> This patch removes PCG_CACHE bit and make callers of
> mem_cgroup_charge_statistics() to specify what the page is.
> 
> Changelog since v2
>  - removed 'not_rss', added 'anon'
>  - changed a meaning of arguments to mem_cgroup_charge_statisitcs()
>  - removed a patch to mem_cgroup_uncharge_cache
>  - simplified comment.
> 
> Changelog since RFC.
>  - rebased onto memcg-devel
>  - rename 'file' to 'not_rss'
>  - some cleanup and added comment.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/page_cgroup.h |    8 +------
>  mm/memcontrol.c             |   48 +++++++++++++++++++++++-------------------
>  2 files changed, 27 insertions(+), 29 deletions(-)
> 
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ff24520..f000c82 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -672,15 +672,19 @@ static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
>  }
>  
>  static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
> -					 bool file, int nr_pages)
> +					 bool rss, int nr_pages)

Can we make this anon as well?
>  {
>  	preempt_disable();
>  
> -	if (file)
> -		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_CACHE],
> +	/*
> +	 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
> +	 * counted as CACHE even if it's on ANON LRU.
> +	 */
> +	if (rss)
> +		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_RSS],
>  				nr_pages);
>  	else
> -		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_RSS],
> +		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_CACHE],
>  				nr_pages);
>  
>  	/* pagein of a big page is an event. So, ignore page size */
[...]

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
