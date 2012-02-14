Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2BNHWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:22:44 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52843 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab2BNHWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:22:43 -0500
MIME-Version: 1.0
In-Reply-To: <20120214121424.91a1832b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120214120414.025625c2.kamezawa.hiroyu@jp.fujitsu.com> <20120214121424.91a1832b.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Mon, 13 Feb 2012 23:22:22 -0800
Message-ID: <CAHH2K0a45xCTFz5qD-M_wX4DqsyfOZeL_G2JSs5NdHp1ZLHT_g@mail.gmail.com>
Subject: Re: [PATCH 4/6 v4] memcg: use new logic for page stat accounting
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 7:14 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From ad2905362ef58a44d96a325193ab384739418050 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 2 Feb 2012 11:49:59 +0900
> Subject: [PATCH 4/6] memcg: use new logic for page stat accounting.
>
> Now, page-stat-per-memcg is recorded into per page_cgroup flag by
> duplicating page's status into the flag. The reason is that memcg
> has a feature to move a page from a group to another group and we
> have race between "move" and "page stat accounting",
>
> Under current logic, assume CPU-A and CPU-B. CPU-A does "move"
> and CPU-B does "page stat accounting".
>
> When CPU-A goes 1st,
>
>            CPU-A                           CPU-B
>                                    update "struct page" info.
>    move_lock_mem_cgroup(memcg)
>    see flags

pc->flags?

>    copy page stat to new group
>    overwrite pc->mem_cgroup.
>    move_unlock_mem_cgroup(memcg)
>                                    move_lock_mem_cgroup(mem)
>                                    set pc->flags
>                                    update page stat accounting
>                                    move_unlock_mem_cgroup(mem)
>
> stat accounting is guarded by move_lock_mem_cgroup() and "move"
> logic (CPU-A) doesn't see changes in "struct page" information.
>
> But it's costly to have the same information both in 'struct page' and
> 'struct page_cgroup'. And, there is a potential problem.
>
> For example, assume we have PG_dirty accounting in memcg.
> PG_..is a flag for struct page.
> PCG_ is a flag for struct page_cgroup.
> (This is just an example. The same problem can be found in any
>  kind of page stat accounting.)
>
>          CPU-A                               CPU-B
>      TestSet PG_dirty
>      (delay)                        TestClear PG_dirty_

PG_dirty

>                                     if (TestClear(PCG_dirty))
>                                          memcg->nr_dirty--
>      if (TestSet(PCG_dirty))
>          memcg->nr_dirty++
>

> @@ -141,6 +141,31 @@ static inline bool mem_cgroup_disabled(void)
>        return false;
>  }
>
> +void __mem_cgroup_begin_update_page_stat(struct page *page,
> +                                       bool *lock, unsigned long *flags);
> +
> +static inline void mem_cgroup_begin_update_page_stat(struct page *page,
> +                                       bool *lock, unsigned long *flags)
> +{
> +       if (mem_cgroup_disabled())
> +               return;
> +       rcu_read_lock();
> +       *lock = false;

This seems like a strange place to set *lock=false.  I think it's
clearer if __mem_cgroup_begin_update_page_stat() is the only routine
that sets or clears *lock.  But I do see that in patch 6/6 'memcg: fix
performance of mem_cgroup_begin_update_page_stat()' this position is
required.

> +       return __mem_cgroup_begin_update_page_stat(page, lock, flags);
> +}

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ecf8856..30afea5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1877,32 +1877,54 @@ bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask)
>  * If there is, we take a lock.
>  */
>
> +void __mem_cgroup_begin_update_page_stat(struct page *page,
> +                               bool *lock, unsigned long *flags)
> +{
> +       struct mem_cgroup *memcg;
> +       struct page_cgroup *pc;
> +
> +       pc = lookup_page_cgroup(page);
> +again:
> +       memcg = pc->mem_cgroup;
> +       if (unlikely(!memcg || !PageCgroupUsed(pc)))
> +               return;
> +       if (!mem_cgroup_stealed(memcg))
> +               return;
> +
> +       move_lock_mem_cgroup(memcg, flags);
> +       if (memcg != pc->mem_cgroup || !PageCgroupUsed(pc)) {
> +               move_unlock_mem_cgroup(memcg, flags);
> +               goto again;
> +       }
> +       *lock = true;
> +}
> +
> +void __mem_cgroup_end_update_page_stat(struct page *page,
> +                               bool *lock, unsigned long *flags)

'lock' looks like an unused parameter.  If so, then remove it.

> +{
> +       struct page_cgroup *pc = lookup_page_cgroup(page);
> +
> +       /*
> +        * It's guaranteed that pc->mem_cgroup never changes while
> +        * lock is held

Please continue comment describing what provides this guarantee.  I
assume it is because rcu_read_lock() is held by
mem_cgroup_begin_update_page_stat().  Maybe it's best to to just make
small reference to the locking protocol description in
mem_cgroup_start_move().

> +        */
> +       move_unlock_mem_cgroup(pc->mem_cgroup, flags);
> +}
> +
> +

I think it would be useful to add a small comment here declaring that
all callers of this routine must be in a
mem_cgroup_begin_update_page_stat(), mem_cgroup_end_update_page_stat()
critical section to keep pc->mem_cgroup stable.

>  void mem_cgroup_update_page_stat(struct page *page,
>                                 enum mem_cgroup_page_stat_item idx, int val)
>  {
