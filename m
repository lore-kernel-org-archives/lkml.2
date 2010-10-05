Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab0JEG5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 02:57:03 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46133 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab0JEG5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 02:57:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 5 Oct 2010 15:51:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 03/10] memcg: create extensible page stat update
 routines
Message-Id: <20101005155142.847b1529.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1286175485-30643-4-git-send-email-gthelen@google.com>
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
	<1286175485-30643-4-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  3 Oct 2010 23:57:58 -0700
Greg Thelen <gthelen@google.com> wrote:

> Replace usage of the mem_cgroup_update_file_mapped() memcg
> statistic update routine with two new routines:
> * mem_cgroup_inc_page_stat()
> * mem_cgroup_dec_page_stat()
> 
> As before, only the file_mapped statistic is managed.  However,
> these more general interfaces allow for new statistics to be
> more easily added.  New statistics are added with memcg dirty
> page accounting.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: Andrea Righi <arighi@develer.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

a nitpick. see below.

> ---
>  include/linux/memcontrol.h |   31 ++++++++++++++++++++++++++++---
>  mm/memcontrol.c            |   17 ++++++++---------
>  mm/rmap.c                  |    4 ++--
>  3 files changed, 38 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 159a076..7c7bec4 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -25,6 +25,11 @@ struct page_cgroup;
>  struct page;
>  struct mm_struct;
>  
> +/* Stats that can be updated by kernel. */
> +enum mem_cgroup_write_page_stat_item {
> +	MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
> +};
> +
>  extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
>  					struct list_head *dst,
>  					unsigned long *scanned, int order,
> @@ -121,7 +126,22 @@ static inline bool mem_cgroup_disabled(void)
>  	return false;
>  }
>  
> -void mem_cgroup_update_file_mapped(struct page *page, int val);
> +void mem_cgroup_update_page_stat(struct page *page,
> +				 enum mem_cgroup_write_page_stat_item idx,
> +				 int val);
> +
> +static inline void mem_cgroup_inc_page_stat(struct page *page,
> +				enum mem_cgroup_write_page_stat_item idx)
> +{
> +	mem_cgroup_update_page_stat(page, idx, 1);
> +}
> +
> +static inline void mem_cgroup_dec_page_stat(struct page *page,
> +				enum mem_cgroup_write_page_stat_item idx)
> +{
> +	mem_cgroup_update_page_stat(page, idx, -1);
> +}
> +
>  unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
>  						gfp_t gfp_mask);
>  u64 mem_cgroup_get_limit(struct mem_cgroup *mem);
> @@ -293,8 +313,13 @@ mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>  {
>  }
>  
> -static inline void mem_cgroup_update_file_mapped(struct page *page,
> -							int val)
> +static inline void mem_cgroup_inc_page_stat(struct page *page,
> +				enum mem_cgroup_write_page_stat_item idx)
> +{
> +}
> +
> +static inline void mem_cgroup_dec_page_stat(struct page *page,
> +				enum mem_cgroup_write_page_stat_item idx)
>  {
>  }
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 512cb12..f4259f4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1592,7 +1592,9 @@ bool mem_cgroup_handle_oom(struct mem_cgroup *mem, gfp_t mask)
>   * possibility of race condition. If there is, we take a lock.
>   */
>  
> -static void mem_cgroup_update_file_stat(struct page *page, int idx, int val)
> +void mem_cgroup_update_page_stat(struct page *page,
> +				 enum mem_cgroup_write_page_stat_item idx,
> +				 int val)
>  {
>  	struct mem_cgroup *mem;
>  	struct page_cgroup *pc = lookup_page_cgroup(page);
> @@ -1615,30 +1617,27 @@ static void mem_cgroup_update_file_stat(struct page *page, int idx, int val)
>  			goto out;
>  	}
>  
> -	this_cpu_add(mem->stat->count[idx], val);
> -
>  	switch (idx) {
> -	case MEM_CGROUP_STAT_FILE_MAPPED:
> +	case MEMCG_NR_FILE_MAPPED:
>  		if (val > 0)
>  			SetPageCgroupFileMapped(pc);
>  		else if (!page_mapped(page))
>  			ClearPageCgroupFileMapped(pc);
> +		idx = MEM_CGROUP_STAT_FILE_MAPPED;
>  		break;
>  	default:
>  		BUG();
>  	}
>  
> +	this_cpu_add(mem->stat->count[idx], val);
> +

Why you move this_cpu_add() placement ?
(This placement is ok but I just wonder..)

Thanks,
-Kame

