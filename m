Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2GIUL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:11:58 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65281 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab2GIULz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:11:55 -0400
Date: Mon, 9 Jul 2012 13:11:16 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 03/11] mm: shmem: do not try to uncharge known swapcache
 pages
In-Reply-To: <1341449103-1986-4-git-send-email-hannes@cmpxchg.org>
Message-ID: <alpine.LSU.2.00.1207091256540.1842@eggly.anvils>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-4-git-send-email-hannes@cmpxchg.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2012, Johannes Weiner wrote:
> Once charged, swapcache pages can only be uncharged after they are
> removed from swapcache again.
> 
> Do not try to uncharge pages that are known to be in the swapcache, to
> allow future patches to remove checks for that in the uncharge code.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/shmem.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ee1c5a2..d12b705 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -302,8 +302,6 @@ static int shmem_add_to_page_cache(struct page *page,
>  		if (!expected)
>  			radix_tree_preload_end();
>  	}
> -	if (error)
> -		mem_cgroup_uncharge_cache_page(page);
>  	return error;
>  }
>  
> @@ -1184,11 +1182,14 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
>  		__set_page_locked(page);
>  		error = mem_cgroup_cache_charge(page, current->mm,
>  						gfp & GFP_RECLAIM_MASK);
> -		if (!error)
> -			error = shmem_add_to_page_cache(page, mapping, index,
> -						gfp, NULL);
>  		if (error)
>  			goto decused;
> +		error = shmem_add_to_page_cache(page, mapping, index,
> +						gfp, NULL);
> +		if (error) {
> +			mem_cgroup_uncharge_cache_page(page);
> +			goto decused;
> +		}
>  		lru_cache_add_anon(page);
>  
>  		spin_lock(&info->lock);
> -- 

I wanted to try this series out on mmotm before replying, and that
took a while; but the problems (some experimental RCU stuff, since
reverted; and Michal's wait_on_page_writeback in vmscan.c, I'll have
to investigate that later) were in mmotm rather than your series:
seems to be running fine under load now.

I've not reviewed, but definitely approve avoiding the temporary
extra charge in migration, and your other simplifications.

And I do approve this change, but selfishly withhold my Ack because
it's a subset of small shmem.c changes I was already lining up to
post, hoping still to sneak into 3.5.  We have a real bug in there
(charging to wrong memcg), and this cleanup comes along with that.
I'll post my version in an hour or two.

Hugh
