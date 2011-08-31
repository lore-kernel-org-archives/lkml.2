Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab1HaRUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 13:20:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:49829 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab1HaRUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 13:20:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=fx9H4ptvmQj4eMu5JpjUN5SmPmxQecq/BjR4Cn2IDxo324o5bYjxJGAKC9XGbTES/
	eTLR0kMadBznRhUBl4u3w==
MIME-Version: 1.0
In-Reply-To: <20110831090850.GA27345@redhat.com>
References: <20110831090850.GA27345@redhat.com>
Date: Wed, 31 Aug 2011 10:19:57 -0700
Message-ID: <CALWz4iwyQ=tLnjx5=KH5kjgJbcjfNVyxS97V0KzXZUenrLAcnA@mail.gmail.com>
Subject: Re: [patch] memcg: skip scanning active lists based on individual size
From: Ying Han <yinghan@google.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 2:08 AM, Johannes Weiner <jweiner@redhat.com> wrote:
> Reclaim decides to skip scanning an active list when the corresponding
> inactive list is above a certain size in comparison to leave the
> assumed working set alone while there are still enough reclaim
> candidates around.
>
> The memcg implementation of comparing those lists instead reports
> whether the whole memcg is low on the requested type of inactive
> pages, considering all nodes and zones.
>
> This can lead to an oversized active list not being scanned because of
> the state of the other lists in the memcg, as well as an active list
> being scanned while its corresponding inactive list has enough pages.
>
> Not only is this wrong, it's also a scalability hazard, because the
> global memory state over all nodes and zones has to be gathered for
> each memcg and zone scanned.
>
> Make these calculations purely based on the size of the two LRU lists
> that are actually affected by the outcome of the decision.
>
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Balbir Singh <bsingharora@gmail.com>
> ---
>  include/linux/memcontrol.h |   10 +++++---
>  mm/memcontrol.c            |   51 ++++++++++++++-----------------------------
>  mm/vmscan.c                |    4 +-
>  3 files changed, 25 insertions(+), 40 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 343bd76..cbb45ce 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -105,8 +105,10 @@ extern void mem_cgroup_end_migration(struct mem_cgroup *mem,
>  /*
>  * For memory reclaim.
>  */
> -int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
> -int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
> +int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
> +                                   struct zone *zone);
> +int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg,
> +                                   struct zone *zone);
>  int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
>  unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
>                                        int nid, int zid, unsigned int lrumask);
> @@ -292,13 +294,13 @@ static inline bool mem_cgroup_disabled(void)
>  }
>
>  static inline int
> -mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg)
> +mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
>  {
>        return 1;
>  }
>
>  static inline int
> -mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg)
> +mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg, struct zone *zone)
>  {
>        return 1;
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3508777..d63dfb2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1101,15 +1101,19 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
>        return ret;
>  }
>
> -static int calc_inactive_ratio(struct mem_cgroup *memcg, unsigned long *present_pages)
> +int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
>  {
> -       unsigned long active;
> +       unsigned long inactive_ratio;
> +       int nid = zone_to_nid(zone);
> +       int zid = zone_idx(zone);
>        unsigned long inactive;
> +       unsigned long active;
>        unsigned long gb;
> -       unsigned long inactive_ratio;
>
> -       inactive = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_INACTIVE_ANON));
> -       active = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_ACTIVE_ANON));
> +       inactive = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
> +                                               BIT(LRU_INACTIVE_ANON));
> +       active = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
> +                                             BIT(LRU_ACTIVE_ANON));
>
>        gb = (inactive + active) >> (30 - PAGE_SHIFT);
>        if (gb)
> @@ -1117,39 +1121,20 @@ static int calc_inactive_ratio(struct mem_cgroup *memcg, unsigned long *present_
>        else
>                inactive_ratio = 1;
>
> -       if (present_pages) {
> -               present_pages[0] = inactive;
> -               present_pages[1] = active;
> -       }
> -
> -       return inactive_ratio;
> +       return inactive * inactive_ratio < active;
>  }
>
> -int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg)
> -{
> -       unsigned long active;
> -       unsigned long inactive;
> -       unsigned long present_pages[2];
> -       unsigned long inactive_ratio;
> -
> -       inactive_ratio = calc_inactive_ratio(memcg, present_pages);
> -
> -       inactive = present_pages[0];
> -       active = present_pages[1];
> -
> -       if (inactive * inactive_ratio < active)
> -               return 1;
> -
> -       return 0;
> -}
> -
> -int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg)
> +int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg, struct zone *zone)
>  {
>        unsigned long active;
>        unsigned long inactive;
> +       int zid = zone_idx(zone);
> +       int nid = zone_to_nid(zone);
>
> -       inactive = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_INACTIVE_FILE));
> -       active = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_ACTIVE_FILE));
> +       inactive = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
> +                                               BIT(LRU_INACTIVE_FILE));
> +       active = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
> +                                             BIT(LRU_ACTIVE_FILE));
>
>        return (active > inactive);
>  }
> @@ -4188,8 +4173,6 @@ static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
>        }
>
>  #ifdef CONFIG_DEBUG_VM
> -       cb->fill(cb, "inactive_ratio", calc_inactive_ratio(mem_cont, NULL));
> -
>        {
>                int nid, zid;
>                struct mem_cgroup_per_zone *mz;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6588746..a023778 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1699,7 +1699,7 @@ static int inactive_anon_is_low(struct zone *zone, struct scan_control *sc)
>        if (scanning_global_lru(sc))
>                low = inactive_anon_is_low_global(zone);
>        else
> -               low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup);
> +               low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup, zone);
>        return low;
>  }
>  #else
> @@ -1742,7 +1742,7 @@ static int inactive_file_is_low(struct zone *zone, struct scan_control *sc)
>        if (scanning_global_lru(sc))
>                low = inactive_file_is_low_global(zone);
>        else
> -               low = mem_cgroup_inactive_file_is_low(sc->mem_cgroup);
> +               low = mem_cgroup_inactive_file_is_low(sc->mem_cgroup, zone);
>        return low;
>  }
>
> --
> 1.7.6
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>

Reviewed-by: Ying Han <yinghan@google.com>

--Ying
