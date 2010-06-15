Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab0FOJ71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 05:59:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48917 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab0FOJ70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 05:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J+SMdSYpiRijwMe+/nsVWEJM/CT2AyX1SMRooYNHFTHNRhlWu4zTVn5paef74dnnJ5
         i3ERn2DbdVXywHwyC5TGSzV2HutXkkC2SF9GBfJxN8ptzUG6vUiYCtbqlk5lEQR5nrbc
         t/EBKdebWh86sYUuxx9sz2jNOCUzGyRs16DbA=
MIME-Version: 1.0
In-Reply-To: <20100615152450.f82c1f8c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100615152450.f82c1f8c.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 15 Jun 2010 18:59:25 +0900
Message-ID: <AANLkTinEEYWULLICKqBr4yX7GL01E4cq0jQSfuN8J6Jq@mail.gmail.com>
Subject: Re: [PATCH] use find_lock_task_mm in memory cgroups oom
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kame.

On Tue, Jun 15, 2010 at 3:24 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> based on  oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
> tested on mm-of-the-moment snapshot 2010-06-11-16-40.
>
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> When the OOM killer scans task, it check a task is under memcg or
> not when it's called via memcg's context.
>
> But, as Oleg pointed out, a thread group leader may have NULL ->mm
> and task_in_mem_cgroup() may do wrong decision. We have to use
> find_lock_task_mm() in memcg as generic OOM-Killer does.
>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

I have a trivial comment below.

> ---
>  include/linux/oom.h |    2 ++
>  mm/memcontrol.c     |   10 +++++++---
>  mm/oom_kill.c       |    8 ++++++--
>  3 files changed, 15 insertions(+), 5 deletions(-)
>
> Index: mmotm-2.6.35-0611/include/linux/oom.h
> ===================================================================
> --- mmotm-2.6.35-0611.orig/include/linux/oom.h
> +++ mmotm-2.6.35-0611/include/linux/oom.h
> @@ -45,6 +45,8 @@ static inline void oom_killer_enable(voi
>        oom_killer_disabled = false;
>  }
>
> +extern struct task_struct *find_lock_task_mm(struct task_struct *p);
> +
>  /* sysctls */
>  extern int sysctl_oom_dump_tasks;
>  extern int sysctl_oom_kill_allocating_task;
> Index: mmotm-2.6.35-0611/mm/memcontrol.c
> ===================================================================
> --- mmotm-2.6.35-0611.orig/mm/memcontrol.c
> +++ mmotm-2.6.35-0611/mm/memcontrol.c
> @@ -47,6 +47,7 @@
>  #include <linux/mm_inline.h>
>  #include <linux/page_cgroup.h>
>  #include <linux/cpu.h>
> +#include <linux/oom.h>
>  #include "internal.h"
>
>  #include <asm/uaccess.h>
> @@ -838,10 +839,13 @@ int task_in_mem_cgroup(struct task_struc
>  {
>        int ret;
>        struct mem_cgroup *curr = NULL;
> +       struct task_struct *p;
>
> -       task_lock(task);
> -       curr = try_get_mem_cgroup_from_mm(task->mm);
> -       task_unlock(task);
> +       p = find_lock_task_mm(task);
> +       if (!p)
> +               return 0;
> +       curr = try_get_mem_cgroup_from_mm(p->mm);
> +       task_unlock(p);
>        if (!curr)
>                return 0;
>        /*
> Index: mmotm-2.6.35-0611/mm/oom_kill.c
> ===================================================================
> --- mmotm-2.6.35-0611.orig/mm/oom_kill.c
> +++ mmotm-2.6.35-0611/mm/oom_kill.c
> @@ -81,13 +81,17 @@ static bool has_intersects_mems_allowed(
>  }
>  #endif /* CONFIG_NUMA */
>
> -/*
> +/**
> + * find_lock_task_mm - Checking a process which a task belongs to has valid mm
> + * and return a locked task which has a valid pointer to mm.
> + *

This comment should have been another patch.
BTW, below comment uses "subthread" word.
Personally it's easy to understand function's goal to me. :)

How about following as?
Checking a process which has any subthread with vaild mm
....


> + * @p: the task of a process to be checked.
>  * The process p may have detached its own ->mm while exiting or through
>  * use_mm(), but one or more of its subthreads may still have a valid
>  * pointer.  Return p, or any of its subthreads with a valid ->mm, with
>  * task_lock() held.
>  */
> -static struct task_struct *find_lock_task_mm(struct task_struct *p)
> +struct task_struct *find_lock_task_mm(struct task_struct *p)
>  {
>        struct task_struct *t = p;
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim
