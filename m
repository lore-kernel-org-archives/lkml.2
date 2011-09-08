Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab1IHIbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:31:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35603 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab1IHIba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:31:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Sep 2011 17:30:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ying Han <yinghan@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcg: close race between charge and putback
Message-Id: <20110908173042.4a6f8ac0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1315467622-9520-1-git-send-email-jweiner@redhat.com>
References: <1315467622-9520-1-git-send-email-jweiner@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Sep 2011 09:40:22 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> There is a potential race between a thread charging a page and another
> thread putting it back to the LRU list:
> 
> charge:                         putback:
> SetPageCgroupUsed               SetPageLRU
> PageLRU && add to memcg LRU     PageCgroupUsed && add to memcg LRU
> 

I assumed that all pages are charged before added to LRU.
(i.e. event happens in charge->lru_lock->putback order.)

But hmm, this assumption may be bad for maintainance.
Do you find a code which adds pages to LRU before charge ?

Hmm, if there are codes which recharge the page to other memcg,
it will cause bug and my assumption may be harmful.

> The order of setting one flag and checking the other is crucial,
> otherwise the charge may observe !PageLRU while the putback observes
> !PageCgroupUsed and the page is not linked to the memcg LRU at all.
> 
> Global memory pressure may fix this by trying to isolate and putback
> the page for reclaim, where that putback would link it to the memcg
> LRU again.  Without that, the memory cgroup is undeletable due to a
> charge whose physical page can not be found and moved out.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
>  mm/memcontrol.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d63dfb2..17708e1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -990,6 +990,16 @@ void mem_cgroup_add_lru_list(struct page *page, enum lru_list lru)
>  		return;
>  	pc = lookup_page_cgroup(page);
>  	VM_BUG_ON(PageCgroupAcctLRU(pc));
> +	/*
> +	 * putback:				charge:
> +	 * SetPageLRU				SetPageCgroupUsed
> +	 * smp_mb				smp_mb
> +	 * PageCgroupUsed && add to memcg LRU	PageLRU && add to memcg LRU
> +	 *
> +	 * Ensure that one of the two sides adds the page to the memcg
> +	 * LRU during a race.
> +	 */
> +	smp_mb();
>  	if (!PageCgroupUsed(pc))
>  		return;
>  	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
> @@ -1041,7 +1051,16 @@ static void mem_cgroup_lru_add_after_commit(struct page *page)
>  	unsigned long flags;
>  	struct zone *zone = page_zone(page);
>  	struct page_cgroup *pc = lookup_page_cgroup(page);
> -
> +	/*
> +	 * putback:				charge:
> +	 * SetPageLRU				SetPageCgroupUsed
> +	 * smp_mb				smp_mb
> +	 * PageCgroupUsed && add to memcg LRU	PageLRU && add to memcg LRU
> +	 *
> +	 * Ensure that one of the two sides adds the page to the memcg
> +	 * LRU during a race.
> +	 */
> +	smp_mb();
>  	/* taking care of that the page is added to LRU while we commit it */
>  	if (likely(!PageLRU(page)))
>  		return;
> -- 
> 1.7.6
> 
> 

