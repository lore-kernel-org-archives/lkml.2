Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905Ab1EWECf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 00:02:35 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62064 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1EWECc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 00:02:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J5t3Cu9pvSnO69xihGjBrDsMUqZIk413Rstg/3xHjI5v3a6iMlTyGBsprLUJl3Wejr
         iTLtukJs1sV9mHWMPrj9J3nJMSx9M3a2ItsCYyZ4r7EtZoZ+GeqOG2CMyKweBLJUorp+
         sHIaoUqk5TFu5bI3jeigRPdhcrB2lgDeZ7mdc=
MIME-Version: 1.0
In-Reply-To: <4DD6204D.5020109@jp.fujitsu.com>
References: <4DD61F80.1020505@jp.fujitsu.com>
	<4DD6204D.5020109@jp.fujitsu.com>
Date: Mon, 23 May 2011 13:02:31 +0900
Message-ID: <BANLkTinpX59NnwsJVQZNTgt_6X3DVK9WLg@mail.gmail.com>
Subject: Re: [PATCH 3/5] oom: oom-killer don't use proportion of system-ram internally
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> CAI Qian reported his kernel did hang-up if he ran fork intensive
> workload and then invoke oom-killer.
>
> The problem is, current oom calculation uses 0-1000 normalized value
> (The unit is a permillage of system-ram). Its low precision make
> a lot of same oom score. IOW, in his case, all processes have smaller
> oom score than 1 and internal calculation round it to 1.
>
> Thus oom-killer kill ineligible process. This regression is caused by
> commit a63d83f427 (oom: badness heuristic rewrite).
>
> The solution is, the internal calculation just use number of pages
> instead of permillage of system-ram. And convert it to permillage
> value at displaying time.
>
> This patch doesn't change any ABI (included  /proc/<pid>/oom_score_adj)
> even though current logic has a lot of my dislike thing.
>
> Reported-by: CAI Qian <caiqian@redhat.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  fs/proc/base.c      |   13 ++++++----
>  include/linux/oom.h |    7 +----
>  mm/oom_kill.c       |   60 +++++++++++++++++++++++++++++++++-----------------
>  3 files changed, 49 insertions(+), 31 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index dfa5327..d6b0424 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -476,14 +476,17 @@ static const struct file_operations proc_lstats_operations = {
>
>  static int proc_oom_score(struct task_struct *task, char *buffer)
>  {
> -       unsigned long points = 0;
> +       unsigned long points;
> +       unsigned long ratio = 0;
> +       unsigned long totalpages = totalram_pages + total_swap_pages + 1;
>
>        read_lock(&tasklist_lock);
> -       if (pid_alive(task))
> -               points = oom_badness(task, NULL, NULL,
> -                                       totalram_pages + total_swap_pages);
> +       if (pid_alive(task)) {
> +               points = oom_badness(task, NULL, NULL, totalpages);
> +               ratio = points * 1000 / totalpages;
> +       }
>        read_unlock(&tasklist_lock);
> -       return sprintf(buffer, "%lu\n", points);
> +       return sprintf(buffer, "%lu\n", ratio);
>  }
>
>  struct limit_names {
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index 5e3aa83..0f5b588 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -40,7 +40,8 @@ enum oom_constraint {
>        CONSTRAINT_MEMCG,
>  };
>
> -extern unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
> +/* The badness from the OOM killer */
> +extern unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>                        const nodemask_t *nodemask, unsigned long totalpages);
>  extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
>  extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
> @@ -62,10 +63,6 @@ static inline void oom_killer_enable(void)
>        oom_killer_disabled = false;
>  }
>
> -/* The badness from the OOM killer */
> -extern unsigned long badness(struct task_struct *p, struct mem_cgroup *mem,
> -                     const nodemask_t *nodemask, unsigned long uptime);
> -
>  extern struct task_struct *find_lock_task_mm(struct task_struct *p);
>
>  /* sysctls */
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index e6a6c6f..8bbc3df 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -132,10 +132,12 @@ static bool oom_unkillable_task(struct task_struct *p,
>  * predictable as possible.  The goal is to return the highest value for the
>  * task consuming the most memory to avoid subsequent oom failures.
>  */
> -unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
> +unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>                      const nodemask_t *nodemask, unsigned long totalpages)
>  {
> -       int points;
> +       unsigned long points;
> +       unsigned long score_adj = 0;
> +
>
>        if (oom_unkillable_task(p, mem, nodemask))
>                return 0;
> @@ -160,7 +162,7 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>         */
>        if (p->flags & PF_OOM_ORIGIN) {
>                task_unlock(p);
> -               return 1000;
> +               return ULONG_MAX;
>        }
>
>        /*
> @@ -176,33 +178,49 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>         */
>        points = get_mm_rss(p->mm) + p->mm->nr_ptes;
>        points += get_mm_counter(p->mm, MM_SWAPENTS);
> -
> -       points *= 1000;
> -       points /= totalpages;
>        task_unlock(p);
>
>        /*
>         * Root processes get 3% bonus, just like the __vm_enough_memory()
>         * implementation used by LSMs.
> +        *
> +        * XXX: Too large bonus, example, if the system have tera-bytes memory..
>         */

Nitpick. I have no opposition about adding this comment.
But strictly speaking, the comment isn't related to this patch.
No biggie and it's up to you.  :)

-- 
Kind regards,
Minchan Kim
