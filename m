Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab2DQVSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:18:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48326 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2DQVR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:17:59 -0400
MIME-Version: 1.0
In-Reply-To: <4F72ED25.60307@jp.fujitsu.com>
References: <4F72EB84.7080000@jp.fujitsu.com>
	<4F72ED25.60307@jp.fujitsu.com>
Date: Tue, 17 Apr 2012 14:17:57 -0700
Message-ID: <CALWz4izNDGdGYmkJzHCRFspCk9QwoZtvRWpKmn=0YZRaVrcVAA@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/6] memcg: add pc_set_mem_cgroup_and_flags()
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

On Wed, Mar 28, 2012 at 3:51 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Consolidate a code for setting pc->mem_cgroup and USED bit which requires smp_wmb().
> And remove a macro PCGF_NOCOPY_AT_SPLIT which isn't helpful to read code, now.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/page_cgroup.h |   18 ++++++++++++++++++
>  mm/memcontrol.c             |   18 ++++--------------
>  2 files changed, 22 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index 92768cb..2707809 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -1,6 +1,8 @@
>  #ifndef __LINUX_PAGE_CGROUP_H
>  #define __LINUX_PAGE_CGROUP_H
>
> +#include <linux/smp.h>
> +
>  enum {
>        /* flags for mem_cgroup */
>        PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
> @@ -94,6 +96,22 @@ pc_set_mem_cgroup(struct page_cgroup *pc, struct mem_cgroup *memcg)
>        pc->mem_cgroup = memcg;
>  }
>
> +static inline void
> +pc_set_mem_cgroup_and_flags(struct page_cgroup *pc, struct mem_cgroup *memcg,
> +                       unsigned long flags)
> +{
> +       pc->mem_cgroup = memcg;
> +       /*
> +        * We access a page_cgroup asynchronously without lock_page_cgroup().
> +        * Especially when a page_cgroup is taken from a page, pc's mem_cgroup
> +        * is accessed after testing USED bit. To make pc's mem_cgroup visible
> +        * before USED bit, we need memory barrier here.
> +        * See mem_cgroup_add_lru_list(), etc.
> +        */
> +       smp_wmb();
> +       pc->flags = flags;
> +}
> +
>  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
>  struct page_cgroup;
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8077460..d366b60 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2511,16 +2511,7 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
>                }
>        }
>
> -       pc_set_mem_cgroup(pc, memcg);
> -       /*
> -        * We access a page_cgroup asynchronously without lock_page_cgroup().
> -        * Especially when a page_cgroup is taken from a page, pc's mem_cgroup
> -        * is accessed after testing USED bit. To make pc's mem_cgroup visible
> -        * before USED bit, we need memory barrier here.
> -        * See mem_cgroup_add_lru_list(), etc.
> -        */
> -       smp_wmb();
> -       SetPageCgroupUsed(pc);

I might be confused. We removed this SetPageCgroupUsed() but not
adding it back elsewhere ?

--Ying

> +       pc_set_mem_cgroup_and_flags(pc, memcg, BIT(PCG_USED) | BIT(PCG_LOCK));
>
>        if (lrucare) {
>                if (was_on_lru) {
> @@ -2549,7 +2540,6 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
>
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>
> -#define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MIGRATION))
>  /*
>  * Because tail pages are not marked as "used", set it. We're under
>  * zone->lru_lock, 'splitting on pmd' and compound_lock.
> @@ -2565,11 +2555,11 @@ void mem_cgroup_split_huge_fixup(struct page *head)
>
>        if (mem_cgroup_disabled())
>                return;
> +       if (!PageCgroupUsed(head_pc))
> +               return;
>        for (i = 1; i < HPAGE_PMD_NR; i++) {
>                pc = head_pc + i;
> -               pc_set_mem_cgroup(pc, memcg);
> -               smp_wmb();/* see __commit_charge() */
> -               pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
> +               pc_set_mem_cgroup_and_flags(pc, memcg, BIT(PCG_USED));
>        }
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> --
> 1.7.4.1
>
>
