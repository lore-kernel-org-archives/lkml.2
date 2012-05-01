Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab2EAW2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 18:28:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59521 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab2EAW2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 18:28:48 -0400
MIME-Version: 1.0
In-Reply-To: <4F9A375D.7@jp.fujitsu.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A375D.7@jp.fujitsu.com>
Date: Tue, 1 May 2012 15:28:47 -0700
Message-ID: <CABCjUKBhNkGf2QHzONMod3HmHgS-HxB5hUxpfJFHUG-eBkYBRw@mail.gmail.com>
Subject: Re: [RFC][PATCH 9/9 v2] memcg: never return error at pre_destroy()
From: Suleiman Souhlal <suleiman@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/26 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> When force_empty() called by ->pre_destroy(), no memory reclaim happens
> and it doesn't take very long time which requires signal_pending() check.
> And if we return -EINTR from pre_destroy(), cgroup.c show warning.
>
> This patch removes signal check in force_empty(). By this, ->pre_destroy()
> returns success always.
>
> Note: check for 'cgroup is empty' remains for force_empty interface.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/hugetlb.c    |   10 +---------
>  mm/memcontrol.c |   14 +++++---------
>  2 files changed, 6 insertions(+), 18 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4dd6b39..770f1642 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1922,20 +1922,12 @@ int hugetlb_force_memcg_empty(struct cgroup *cgroup)
>        int ret = 0, idx = 0;
>
>        do {
> +               /* see memcontrol.c::mem_cgroup_force_empty() */
>                if (cgroup_task_count(cgroup)
>                        || !list_empty(&cgroup->children)) {
>                        ret = -EBUSY;
>                        goto out;
>                }
> -               /*
> -                * If the task doing the cgroup_rmdir got a signal
> -                * we don't really need to loop till the hugetlb resource
> -                * usage become zero.
> -                */
> -               if (signal_pending(current)) {
> -                       ret = -EINTR;
> -                       goto out;
> -               }
>                for_each_hstate(h) {
>                        spin_lock(&hugetlb_lock);
>                        list_for_each_entry(page, &h->hugepage_activelist, lru) {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2715223..ee350c5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3852,8 +3852,6 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>                pc = lookup_page_cgroup(page);
>
>                ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
> -               if (ret == -ENOMEM || ret == -EINTR)
> -                       break;
>
>                if (ret == -EBUSY || ret == -EINVAL) {
>                        /* found lock contention or "pc" is obsolete. */
> @@ -3863,7 +3861,7 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>                        busy = NULL;
>        }
>
> -       if (!ret && !list_empty(list))
> +       if (!loop)
>                return -EBUSY;
>        return ret;
>  }
> @@ -3893,11 +3891,12 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg, bool free_all)
>  move_account:
>        do {
>                ret = -EBUSY;
> +               /*
> +                * This never happens when this is called by ->pre_destroy().
> +                * But we need to take care of force_empty interface.
> +                */
>                if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
>                        goto out;

Are you sure this never happens when called by ->pre_destroy()?
Can't a task still get attached to the cgroup while ->pre_destroy() is running?

At least, I don't see anything in the cgroup code that prevents
someone from newly attaching a task at that point.
In fact, there is code that seems to handle the case when someone
attached to the cgroup after pre_destroy() has run: See the
cgroup_wakeup_rmdir_waiter() call in cgroup_attach_task().

-- Suleiman
