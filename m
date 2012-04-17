Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2DQVZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:25:11 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57544 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286Ab2DQVZJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:25:09 -0400
MIME-Version: 1.0
In-Reply-To: <4F72EE86.9030005@jp.fujitsu.com>
References: <4F72EB84.7080000@jp.fujitsu.com>
	<4F72EE86.9030005@jp.fujitsu.com>
Date: Tue, 17 Apr 2012 14:25:07 -0700
Message-ID: <CALWz4iy-TM_vHCmgZ4e+DEx6WqLJD6QRYut75L4Qz681pOgvkw@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/6] memcg: add PageCgroupReset()
From: Ying Han <yinghan@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 3:57 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>  A commit "memcg: simplify LRU handling by new rule" removes PCG_ACCT_LRU.
>  and the bug introduced by it was fixed by "memcg: fix GPF when cgroup removal
>  races with last exit"
>
> This was for reducing flags on pc->flags....Now, we have 3bits of flags.
> but this patch adds a new flag, I'm sorry. (Considering alignment of
> kmalloc(), we'll able to have 5 bits..)
>
> This patch adds PCG_RESET which is similar to PCG_ACCT_LRU.



This is set
> when mem_cgroup_add_lru_list() finds we cannot trust the pc's mem_cgroup.

Do we still need the new flag? I assume some of the upcoming patches
will provide the guarantee of pc->mem_cgroup.

--Ying
>
> The reason why this patch adds a (renamed) flag again is for merging
> pc->flags and pc->mem_cgroup. Assume pc's mem_cgroup is encoded as
>
>        mem_cgroup = pc->flags & ~0x7
>
> Updating multiple bits of pc->flags without talking lock_page_cgroup()
> is very dangerous. And mem_cgroup_add_lru_list() updates pc->mem_cgroup
> without taking lock. Then I add RESET bit. After this, pc_to_mem_cgroup()
> is written as
>
>        if (PageCgroupReset(pc))
>                return root_mem_cgroup;
>        return pc->mem_cgroup;
>
> This update of Reset bit can be done in atomic by set_bit(). And
> cleared when USED bit is set.
>
> Considering kmalloc()'s alignment, having 4bits of flags will be ok....
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/page_cgroup.h |   15 ++++++++-------
>  mm/memcontrol.c             |    5 +++--
>  2 files changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index 2707809..3f3b4ff 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -8,6 +8,7 @@ enum {
>        PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
>        PCG_USED, /* this object is in use. */
>        PCG_MIGRATION, /* under page migration */
> +       PCG_RESET,     /* have been reset to root_mem_cgroup */
>        __NR_PCG_FLAGS,
>  };
>
> @@ -70,6 +71,9 @@ SETPCGFLAG(Migration, MIGRATION)
>  CLEARPCGFLAG(Migration, MIGRATION)
>  TESTPCGFLAG(Migration, MIGRATION)
>
> +TESTPCGFLAG(Reset, RESET)
> +SETPCGFLAG(Reset, RESET)
> +
>  static inline void lock_page_cgroup(struct page_cgroup *pc)
>  {
>        /*
> @@ -84,16 +88,13 @@ static inline void unlock_page_cgroup(struct page_cgroup *pc)
>        bit_spin_unlock(PCG_LOCK, &pc->flags);
>  }
>
> +extern struct mem_cgroup*  root_mem_cgroup;
>
>  static inline struct mem_cgroup* pc_to_mem_cgroup(struct page_cgroup *pc)
>  {
> -       return pc->mem_cgroup;
> -}
> -
> -static inline void
> -pc_set_mem_cgroup(struct page_cgroup *pc, struct mem_cgroup *memcg)
> -{
> -       pc->mem_cgroup = memcg;
> +       if (likely(!PageCgroupReset(pc)))
> +               return pc->mem_cgroup;
> +       return root_mem_cgroup;
>  }
>
>  static inline void
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d366b60..622fd2e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1080,7 +1080,8 @@ struct lruvec *mem_cgroup_lru_add_list(struct zone *zone, struct page *page,
>         * of pc's mem_cgroup safe.
>         */
>        if (!PageCgroupUsed(pc) && memcg != root_mem_cgroup) {
> -               pc_set_mem_cgroup(pc, root_mem_cgroup);
> +               /* this reset bit is cleared when the page is charged */
> +               SetPageCgroupReset(pc);
>                memcg = root_mem_cgroup;
>        }
>
> @@ -2626,7 +2627,7 @@ static int mem_cgroup_move_account(struct page *page,
>                __mem_cgroup_cancel_charge(from, nr_pages);
>
>        /* caller should have done css_get */
> -       pc_set_mem_cgroup(pc, to);
> +       pc_set_mem_cgroup_and_flags(pc, to, BIT(PCG_USED) | BIT(PCG_LOCK));
>        mem_cgroup_charge_statistics(to, anon, nr_pages);
>        /*
>         * We charges against "to" which may not have any tasks. Then, "to"
> --
> 1.7.4.1
>
>
