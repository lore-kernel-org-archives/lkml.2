Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab1EWEcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 00:32:01 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40460 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1EWEb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 00:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hhfKeOcdRSxdZdDEwVe8m6OL6Gnr7qZp+fDtmN2MvNaQlyZkgB9C/2WReP6P7nuZ41
         veKqW7tWs3neXyb7WRZ+t6TUrvrlCfwF9twOI4LMpnE7ZnVAytET9Z0ViD7sypXD0yRu
         RZcKmDTuvLXcw8OlRlL3nekL9kRwd6G7l7cVQ=
MIME-Version: 1.0
In-Reply-To: <4DD6207E.1070300@jp.fujitsu.com>
References: <4DD61F80.1020505@jp.fujitsu.com>
	<4DD6207E.1070300@jp.fujitsu.com>
Date: Mon, 23 May 2011 13:31:57 +0900
Message-ID: <BANLkTinaHki1oA4O3+FsoPDtFTLfqwRadA@mail.gmail.com>
Subject: Re: [PATCH 4/5] oom: don't kill random process
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
> CAI Qian reported oom-killer killed all system daemons in his
> system at first if he ran fork bomb as root. The problem is,
> current logic give them bonus of 3% of system ram. Example,
> he has 16GB machine, then root processes have ~500MB oom
> immune. It bring us crazy bad result. _all_ processes have
> oom-score=1 and then, oom killer ignore process memory usage
> and kill random process. This regression is caused by commit
> a63d83f427 (oom: badness heuristic rewrite).
>
> This patch changes select_bad_process() slightly. If oom points == 1,
> it's a sign that the system have only root privileged processes or
> similar. Thus, select_bad_process() calculate oom badness without
> root bonus and select eligible process.
>
> Also, this patch move finding sacrifice child logic into
> select_bad_process(). It's necessary to implement adequate
> no root bonus recalculation. and it makes good side effect,
> current logic doesn't behave as the doc.
>
> Documentation/sysctl/vm.txt says
>
>    oom_kill_allocating_task
>
>    If this is set to non-zero, the OOM killer simply kills the task that
>    triggered the out-of-memory condition.  This avoids the expensive
>    tasklist scan.
>
> IOW, oom_kill_allocating_task shouldn't search sacrifice child.
> This patch also fixes this issue.
>
> Reported-by: CAI Qian <caiqian@redhat.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  fs/proc/base.c      |    2 +-
>  include/linux/oom.h |    3 +-
>  mm/oom_kill.c       |   89 ++++++++++++++++++++++++++++----------------------
>  3 files changed, 53 insertions(+), 41 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index d6b0424..b608b69 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -482,7 +482,7 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
>
>        read_lock(&tasklist_lock);
>        if (pid_alive(task)) {
> -               points = oom_badness(task, NULL, NULL, totalpages);
> +               points = oom_badness(task, NULL, NULL, totalpages, 1);
>                ratio = points * 1000 / totalpages;
>        }
>        read_unlock(&tasklist_lock);
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index 0f5b588..3dd3669 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -42,7 +42,8 @@ enum oom_constraint {
>
>  /* The badness from the OOM killer */
>  extern unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *mem,
> -                       const nodemask_t *nodemask, unsigned long totalpages);
> +                       const nodemask_t *nodemask, unsigned long totalpages,
> +                       int protect_root);
>  extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
>  extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 8bbc3df..7d280d4 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -133,7 +133,8 @@ static bool oom_unkillable_task(struct task_struct *p,
>  * task consuming the most memory to avoid subsequent oom failures.
>  */
>  unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *mem,
> -                     const nodemask_t *nodemask, unsigned long totalpages)
> +                        const nodemask_t *nodemask, unsigned long totalpages,
> +                        int protect_root)
>  {
>        unsigned long points;
>        unsigned long score_adj = 0;
> @@ -186,7 +187,7 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>         *
>         * XXX: Too large bonus, example, if the system have tera-bytes memory..
>         */
> -       if (has_capability_noaudit(p, CAP_SYS_ADMIN)) {
> +       if (protect_root && has_capability_noaudit(p, CAP_SYS_ADMIN)) {
>                if (points >= totalpages / 32)
>                        points -= totalpages / 32;
>                else
> @@ -298,8 +299,11 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
>  {
>        struct task_struct *g, *p;
>        struct task_struct *chosen = NULL;
> -       *ppoints = 0;
> +       int protect_root = 1;
> +       unsigned long chosen_points = 0;
> +       struct task_struct *child;
>
> + retry:
>        do_each_thread_reverse(g, p) {
>                unsigned long points;
>
> @@ -332,7 +336,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
>                         */
>                        if (p == current) {
>                                chosen = p;
> -                               *ppoints = ULONG_MAX;
> +                               chosen_points = ULONG_MAX;
>                        } else {
>                                /*
>                                 * If this task is not being ptraced on exit,
> @@ -345,13 +349,49 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
>                        }
>                }
>
> -               points = oom_badness(p, mem, nodemask, totalpages);
> -               if (points > *ppoints) {
> +               points = oom_badness(p, mem, nodemask, totalpages, protect_root);
> +               if (points > chosen_points) {
>                        chosen = p;
> -                       *ppoints = points;
> +                       chosen_points = points;
>                }
>        } while_each_thread(g, p);
>
> +       /*
> +        * chosen_point==1 may be a sign that root privilege bonus is too large
> +        * and we choose wrong task. Let's recalculate oom score without the
> +        * dubious bonus.
> +        */
> +       if (protect_root && (chosen_points == 1)) {
> +               protect_root = 0;
> +               goto retry;
> +       }

The idea is good to me.
But once we meet it, should we give up protecting root privileged processes?
How about decaying bonus point?

-- 
Kind regards,
Minchan Kim
