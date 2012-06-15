Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab2FOPSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:18:21 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:41552 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2FOPSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:18:20 -0400
From: Greg Thelen <gthelen@google.com>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, yinghan@google.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 1/2] memcg: remove MEMCG_NR_FILE_MAPPED
References: <1339761611-29033-1-git-send-email-handai.szj@taobao.com>
Date: Fri, 15 Jun 2012 08:18:17 -0700
Message-ID: <xr937gv8vc1y.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15 2012, Sha Zhengju wrote:

> While doing memcg page stat accounting, there's no need to use MEMCG_NR_FILE_MAPPED
> as an intermediate, we can use MEM_CGROUP_STAT_FILE_MAPPED directly.
>
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
> ---
>  include/linux/memcontrol.h |   22 ++++++++++++++++------
>  mm/memcontrol.c            |   25 +------------------------
>  mm/rmap.c                  |    4 ++--
>  3 files changed, 19 insertions(+), 32 deletions(-)

I assume this patch is relative to v3.4.

> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index f94efd2..a337c2e 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -27,9 +27,19 @@ struct page_cgroup;
>  struct page;
>  struct mm_struct;
>  
> -/* Stats that can be updated by kernel. */
> -enum mem_cgroup_page_stat_item {
> -	MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
> +/*
> + * Statistics for memory cgroup.
> + */
> +enum mem_cgroup_stat_index {
> +	/*
> +	 * For MEM_CONTAINER_TYPE_ALL, usage = pagecache + rss.
> +	 */
> +	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
> +	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
> +	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
> +	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
> +	MEM_CGROUP_STAT_DATA, /* end of data requires synchronization */
> +	MEM_CGROUP_STAT_NSTATS,
>  };

This has unfortunate side effect of letting code outside of memcontrol.c
manipulate memcg internally managed statistics
(e.g. MEM_CGROUP_STAT_CACHE) with mem_cgroup_{dec,inc}_page_stat.  I
think that your change is fine.  The complexity and presumed performance
overhead of the extra layer of indirection was not worth it.

>  struct mem_cgroup_reclaim_cookie {
> @@ -170,17 +180,17 @@ static inline void mem_cgroup_end_update_page_stat(struct page *page,
>  }
>  
>  void mem_cgroup_update_page_stat(struct page *page,
> -				 enum mem_cgroup_page_stat_item idx,
> +				 enum mem_cgroup_stat_index idx,
>  				 int val);
>  
>  static inline void mem_cgroup_inc_page_stat(struct page *page,
> -					    enum mem_cgroup_page_stat_item idx)
> +					    enum mem_cgroup_stat_index idx)
>  {
>  	mem_cgroup_update_page_stat(page, idx, 1);
>  }
>  
>  static inline void mem_cgroup_dec_page_stat(struct page *page,
> -					    enum mem_cgroup_page_stat_item idx)
> +					    enum mem_cgroup_stat_index idx)
>  {
>  	mem_cgroup_update_page_stat(page, idx, -1);
>  }

You missed two more uses of enum mem_cgroup_page_stat_item in
memcontrol.h.

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a337c2e..08475b9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -390,12 +390,12 @@ static inline void mem_cgroup_end_update_page_stat(struct page *page,
 }
 
 static inline void mem_cgroup_inc_page_stat(struct page *page,
-					    enum mem_cgroup_page_stat_item idx)
+					    enum mem_cgroup_stat_index idx)
 {
 }
 
 static inline void mem_cgroup_dec_page_stat(struct page *page,
-					    enum mem_cgroup_page_stat_item idx)
+					    enum mem_cgroup_stat_index idx)
 {
 }
