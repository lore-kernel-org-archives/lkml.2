Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0KIWxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:53:48 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60026 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab0KIWxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:53:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WRw9QsFMaXGe0+ErNI3kLGCMzST2LGzCrWEq+SsHMMi6PcXxSAnGPqgeCcbtR2HbMK
         uKcVjQkII0Om+a1kvlGUiliEdkonjyNug91WQQA+7e+Ut3ytrEl/BCt303LLQ625+BDD
         3zXxwTfv5JQs0aAskFjVIihc9g92MxZYA2mAA=
MIME-Version: 1.0
In-Reply-To: <1289294671-6865-2-git-send-email-gthelen@google.com>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
	<1289294671-6865-2-git-send-email-gthelen@google.com>
Date: Wed, 10 Nov 2010 07:53:46 +0900
Message-ID: <AANLkTi=LtVcLVj+U-RGRrc2J=JGSvfbQD3Y-Y6yKu5NS@mail.gmail.com>
Subject: Re: [PATCH 1/6] memcg: add mem_cgroup parameter to mem_cgroup_page_stat()
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 6:24 PM, Greg Thelen <gthelen@google.com> wrote:
> This new parameter can be used to query dirty memory usage
> from a given memcg rather than the current task's memcg.
>
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  include/linux/memcontrol.h |    6 ++++--
>  mm/memcontrol.c            |   37 +++++++++++++++++++++----------------
>  mm/page-writeback.c        |    2 +-
>  3 files changed, 26 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7a3d915..89a9278 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -157,7 +157,8 @@ static inline void mem_cgroup_dec_page_stat(struct page *page,
>  bool mem_cgroup_has_dirty_limit(void);
>  bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
>                           struct dirty_info *info);
> -long mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item);
> +long mem_cgroup_page_stat(struct mem_cgroup *mem,
> +                         enum mem_cgroup_nr_pages_item item);
>
>  unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
>                                                gfp_t gfp_mask);
> @@ -351,7 +352,8 @@ static inline bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
>        return false;
>  }
>
> -static inline long mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item)
> +static inline long mem_cgroup_page_stat(struct mem_cgroup *mem,
> +                                       enum mem_cgroup_nr_pages_item item)
>  {
>        return -ENOSYS;
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d8a06d6..1bff7cf 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1245,22 +1245,20 @@ bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
>        unsigned long available_mem;
>        struct mem_cgroup *memcg;
>        long value;
> +       bool valid = false;
>
>        if (mem_cgroup_disabled())
>                return false;
>
>        rcu_read_lock();
>        memcg = mem_cgroup_from_task(current);
> -       if (!__mem_cgroup_has_dirty_limit(memcg)) {
> -               rcu_read_unlock();
> -               return false;
> -       }
> +       if (!__mem_cgroup_has_dirty_limit(memcg))
> +               goto done;
>        __mem_cgroup_dirty_param(&dirty_param, memcg);
> -       rcu_read_unlock();
>
> -       value = mem_cgroup_page_stat(MEMCG_NR_DIRTYABLE_PAGES);
> +       value = mem_cgroup_page_stat(memcg, MEMCG_NR_DIRTYABLE_PAGES);
>        if (value < 0)
> -               return false;
> +               goto done;
>
>        available_mem = min((unsigned long)value, sys_available_mem);
>
> @@ -1280,17 +1278,21 @@ bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
>                        (dirty_param.dirty_background_ratio *
>                               available_mem) / 100;
>
> -       value = mem_cgroup_page_stat(MEMCG_NR_RECLAIM_PAGES);
> +       value = mem_cgroup_page_stat(memcg, MEMCG_NR_RECLAIM_PAGES);
>        if (value < 0)
> -               return false;
> +               goto done;
>        info->nr_reclaimable = value;
>
> -       value = mem_cgroup_page_stat(MEMCG_NR_WRITEBACK);
> +       value = mem_cgroup_page_stat(memcg, MEMCG_NR_WRITEBACK);
>        if (value < 0)
> -               return false;
> +               goto done;
>        info->nr_writeback = value;
>
> -       return true;
> +       valid = true;
> +
> +done:
> +       rcu_read_unlock();
> +       return valid;
>  }
>
>  static inline bool mem_cgroup_can_swap(struct mem_cgroup *memcg)
> @@ -1361,20 +1363,23 @@ memcg_hierarchical_free_pages(struct mem_cgroup *mem)
>
>  /*
>  * mem_cgroup_page_stat() - get memory cgroup file cache statistics
> - * @item:      memory statistic item exported to the kernel
> + * @mem:       optional memory cgroup to query.  If NULL, use current task's
> + *             cgroup.
> + * @item:      memory statistic item exported to the kernel
>  *
>  * Return the accounted statistic value or negative value if current task is
>  * root cgroup.
>  */
> -long mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item)
> +long mem_cgroup_page_stat(struct mem_cgroup *mem,
> +                         enum mem_cgroup_nr_pages_item item)
>  {
>        struct mem_cgroup *iter;
> -       struct mem_cgroup *mem;
>        long value;
>
>        get_online_cpus();
>        rcu_read_lock();
> -       mem = mem_cgroup_from_task(current);
> +       if (!mem)
> +               mem = mem_cgroup_from_task(current);
>        if (__mem_cgroup_has_dirty_limit(mem)) {
>                /*
>                 * If we're looking for dirtyable pages we need to evaluate
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index a477f59..dc3dbe3 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -135,7 +135,7 @@ static unsigned long dirty_writeback_pages(void)
>  {
>        unsigned long ret;
>
> -       ret = mem_cgroup_page_stat(MEMCG_NR_DIRTY_WRITEBACK_PAGES);
> +       ret = mem_cgroup_page_stat(NULL, MEMCG_NR_DIRTY_WRITEBACK_PAGES);
>        if ((long)ret < 0)
>                ret = global_page_state(NR_UNSTABLE_NFS) +
>                        global_page_state(NR_WRITEBACK);
> --
> 1.7.3.1
>

I didn't look at further patches so It might be changed.

Now all of caller of mem_cgroup_page_stat except only
dirty_writeback_pages hold rcu_read_lock.
And mem_cgroup_page_stat itself hold rcu_read_lock again.
Couldn't we remove duplicated rcu lock by adding rcu_read_lock in
dirty_writeback_pages for the consistency?


-- 
Kind regards,
Minchan Kim
