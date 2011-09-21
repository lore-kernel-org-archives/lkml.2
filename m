Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab1IUPZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:25:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1IUPY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:24:59 -0400
Date: Wed, 21 Sep 2011 17:24:58 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 10/11] mm: make per-memcg LRU lists exclusive
Message-ID: <20110921152458.GI8501@tiehlicka.suse.cz>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
 <1315825048-3437-11-git-send-email-jweiner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315825048-3437-11-git-send-email-jweiner@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 12-09-11 12:57:27, Johannes Weiner wrote:
> Now that all code that operated on global per-zone LRU lists is
> converted to operate on per-memory cgroup LRU lists instead, there is
> no reason to keep the double-LRU scheme around any longer.
> 
> The pc->lru member is removed and page->lru is linked directly to the
> per-memory cgroup LRU lists, which removes two pointers from a
> descriptor that exists for every page frame in the system.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Ying Han <yinghan@google.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

Minor comments/questions bellow.
> ---
>  include/linux/memcontrol.h  |   54 +++-----
>  include/linux/mm_inline.h   |   21 +--
>  include/linux/page_cgroup.h |    1 -
>  mm/memcontrol.c             |  319 ++++++++++++++++++++-----------------------
>  mm/page_cgroup.c            |    1 -
>  mm/swap.c                   |   23 ++-
>  mm/vmscan.c                 |   81 +++++-------
>  7 files changed, 228 insertions(+), 272 deletions(-)
> 
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 465001c..a7d14a5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[...]
> @@ -934,115 +954,123 @@ EXPORT_SYMBOL(mem_cgroup_count_vm_event);
>   * When moving account, the page is not on LRU. It's isolated.
>   */
>  
> -struct page *mem_cgroup_lru_to_page(struct zone *zone, struct mem_cgroup *mem,
> -				    enum lru_list lru)
> +/**
> + * mem_cgroup_lru_add_list - account for adding an lru page and return lruvec
> + * @zone: zone of the page
> + * @page: the page
> + * @lru: current lru
> + *
> + * This function accounts for @page being added to @lru, and returns
> + * the lruvec for the given @zone and the memcg @page is charged to.
> + *
> + * The callsite is then responsible for physically linking the page to
> + * the returned lruvec->lists[@lru].
> + */
> +struct lruvec *mem_cgroup_lru_add_list(struct zone *zone, struct page *page,
> +				       enum lru_list lru)

I know that names are alway tricky but what about mem_cgroup_acct_lru_add?
Analogously for mem_cgroup_lru_del_list, mem_cgroup_lru_del and
mem_cgroup_lru_move_lists.

[...]
> @@ -3615,11 +3593,11 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
>  static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>  				int node, int zid, enum lru_list lru)
>  {
> -	struct zone *zone;
>  	struct mem_cgroup_per_zone *mz;
> -	struct page_cgroup *pc, *busy;
>  	unsigned long flags, loop;
>  	struct list_head *list;
> +	struct page *busy;
> +	struct zone *zone;

Any specific reason to move zone declaration down here? Not that it
matters much. Just curious.

>  	int ret = 0;
>  
>  	zone = &NODE_DATA(node)->node_zones[zid];
> @@ -3639,16 +3618,16 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>  			spin_unlock_irqrestore(&zone->lru_lock, flags);
>  			break;
>  		}
> -		pc = list_entry(list->prev, struct page_cgroup, lru);
> -		if (busy == pc) {
> -			list_move(&pc->lru, list);
> +		page = list_entry(list->prev, struct page, lru);
> +		if (busy == page) {
> +			list_move(&page->lru, list);
>  			busy = NULL;
>  			spin_unlock_irqrestore(&zone->lru_lock, flags);
>  			continue;
>  		}
>  		spin_unlock_irqrestore(&zone->lru_lock, flags);
>  
> -		page = lookup_cgroup_page(pc);
> +		pc = lookup_page_cgroup(page);

lookup_page_cgroup might return NULL so we probably want BUG_ON(!pc)
here. We are not very consistent about checking the return value,
though.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
