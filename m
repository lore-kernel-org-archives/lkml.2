Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2ASNoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 08:44:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab2ASNoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 08:44:00 -0500
Date: Thu, 19 Jan 2012 14:43:58 +0100
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH] memcg: remove PCG_CACHE page_cgroup flag
Message-ID: <20120119134358.GC13932@tiehlicka.suse.cz>
References: <20120119181711.8d697a6b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119181711.8d697a6b.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 19-01-12 18:17:11, KAMEZAWA Hiroyuki wrote:
> This patch is onto memcg-devel, can be applied to linux-next, too.

Just for record memcg-devel tree should _always_ be compatible with
linux-next. It just contains patches which are memcg related to be more
stable for memcg specific development.

> 
> ==
> From 529653c266b0682894d64e4797fcaf6a3c35db25 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 19 Jan 2012 17:09:41 +0900
> Subject: [PATCH] memcg: remove PCG_CACHE
> 
> We record 'the page is cache' by PCG_CACHE bit to page_cgroup.
> Here, "CACHE" means anonymous user pages (and SwapCache). This
> doesn't include shmem.

> Consdering callers, at charge/uncharge, the caller should know
> what  the page is and we don't need to record it by using 1bit
> per page.
> 
> This patch removes PCG_CACHE bit and make callers of
> mem_cgroup_charge_statistics() to specify what the page is.
> 
> Changelog since RFC.
>  - rebased onto memcg-devel
>  - rename 'file' to 'not_rss'

The name is confusing.

Other than that the patch looks reasonable. Minor comment bellow:

>  - some cleanup and added comment.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/page_cgroup.h |    8 +-----
>  mm/memcontrol.c             |   55 ++++++++++++++++++++++++++----------------
>  2 files changed, 35 insertions(+), 28 deletions(-)
> 
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index fb2dfc3..de7721d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[...]
> @@ -2908,9 +2915,15 @@ void mem_cgroup_uncharge_page(struct page *page)
>  
>  void mem_cgroup_uncharge_cache_page(struct page *page)
>  {
> +	int ctype;
> +
>  	VM_BUG_ON(page_mapped(page));
>  	VM_BUG_ON(page->mapping);
> -	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
> +	if (page_is_file_cache(page))
> +		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
> +	else
> +		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
> +	__mem_cgroup_uncharge_common(page, ctype);

OK, this makes sense but doesn't make any real difference now, so it is
more a clean up, right?

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
