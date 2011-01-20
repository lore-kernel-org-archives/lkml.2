Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1ATBMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 20:12:54 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51164 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1ATBMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 20:12:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 20 Jan 2011 10:06:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch rfc] memcg: correctly order reading PCG_USED and
 pc->mem_cgroup
Message-Id: <20110120100654.a90d9cc6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110119120319.GA2232@cmpxchg.org>
References: <20110119120319.GA2232@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jan 2011 13:03:19 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> The placement of the read-side barrier is confused: the writer first
> sets pc->mem_cgroup, then PCG_USED.  The read-side barrier has to be
> between testing PCG_USED and reading pc->mem_cgroup.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c |   27 +++++++++------------------
>  1 files changed, 9 insertions(+), 18 deletions(-)
> 
> I am a bit dumbfounded as to why this has never had any impact.  I see
> two scenarios where charging can race with LRU operations:
> 
> One is shmem pages on swapoff.  They are on the LRU when charged as
> page cache, which could race with isolation/putback.  This seems
> sufficiently rare.
> 
> The other case is a swap cache page being charged while somebody else
> had it isolated.  mem_cgroup_lru_del_before_commit_swapcache() would
> see the page isolated and skip it.  The commit then has to race with
> putback, which could see PCG_USED but not pc->mem_cgroup, and crash
> with a NULL pointer dereference.  This does sound a bit more likely.
> 
> Any idea?  Am I missing something?
> 

I think troubles happen only when PCG_USED bit was found but pc->mem_cgroup
is NULL. Hmm.

  set pc->mem_cgroup
  write_barrier
  set USED bit.

  read_barrier
  check USED bit
  access pc->mem_cgroup

So, is there a case which only USED bit can be seen ?
Anyway, your patch is right.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5b562b3..db76ef7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -836,13 +836,12 @@ void mem_cgroup_rotate_lru_list(struct page *page, enum lru_list lru)
>  		return;
>  
>  	pc = lookup_page_cgroup(page);
> -	/*
> -	 * Used bit is set without atomic ops but after smp_wmb().
> -	 * For making pc->mem_cgroup visible, insert smp_rmb() here.
> -	 */
> -	smp_rmb();
>  	/* unused or root page is not rotated. */
> -	if (!PageCgroupUsed(pc) || mem_cgroup_is_root(pc->mem_cgroup))
> +	if (!PageCgroupUsed(pc))
> +		return;
> +	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
> +	smp_rmb();
> +	if (mem_cgroup_is_root(pc->mem_cgroup))
>  		return;
>  	mz = page_cgroup_zoneinfo(pc);
>  	list_move(&pc->lru, &mz->lists[lru]);
> @@ -857,14 +856,10 @@ void mem_cgroup_add_lru_list(struct page *page, enum lru_list lru)
>  		return;
>  	pc = lookup_page_cgroup(page);
>  	VM_BUG_ON(PageCgroupAcctLRU(pc));
> -	/*
> -	 * Used bit is set without atomic ops but after smp_wmb().
> -	 * For making pc->mem_cgroup visible, insert smp_rmb() here.
> -	 */
> -	smp_rmb();
>  	if (!PageCgroupUsed(pc))
>  		return;
> -
> +	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
> +	smp_rmb();
>  	mz = page_cgroup_zoneinfo(pc);
>  	/* huge page split is done under lru_lock. so, we have no races. */
>  	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
> @@ -1031,14 +1026,10 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
>  		return NULL;
>  
>  	pc = lookup_page_cgroup(page);
> -	/*
> -	 * Used bit is set without atomic ops but after smp_wmb().
> -	 * For making pc->mem_cgroup visible, insert smp_rmb() here.
> -	 */
> -	smp_rmb();
>  	if (!PageCgroupUsed(pc))
>  		return NULL;
> -
> +	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
> +	smp_rmb();
>  	mz = page_cgroup_zoneinfo(pc);
>  	if (!mz)
>  		return NULL;
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

