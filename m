Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992Ab0JGCYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 22:24:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57690 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759825Ab0JGCYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 22:24:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19/rb4QWjV/tQgLS4uggqdw/WwLwT5T+limxV9XLh
	1eDCnChG9RmtBT
Subject: Re: [PATCH 1/2] sched: normalize sleeper's vruntime during group
 change
From: Mike Galbraith <efault@gmx.de>
To: Dima Zavin <dima@android.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <1286405790-6987-1-git-send-email-dima@android.com>
References: <AANLkTimpzfCDHuVQkExLvQHaVY==SFJ2AUWO7tZkcK2T@mail.gmail.com>
	 <1286405790-6987-1-git-send-email-dima@android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 04:24:46 +0200
Message-Id: <1286418286.7422.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 15:56 -0700, Dima Zavin wrote:
> If you switch the cgroup of a sleeping thread, its vruntime does
> not get adjusted correctly for the difference between the
> min_vruntime values of the two groups.
> 
> The problem becomes most apparent when one has cgroups whose
> cpu shares differ greatly, say group A.shares=1024 and group B.shares=52.
> After some time, the vruntime of the group with the larger share (A)
> will be way ahead of the group with the small share (B). Currently,
> when a sleeping task is moved from group A to group B, it will retain its
> larger vruntime value and thus will be way ahead of all the other tasks
> in its new group. This will prevent this task from executing for an
> extended period of time.

Yeah, seems clear that normalization is a must.

Questionable is whether we should apply START_DEBIT.  That's part of a
different problem though (SCHED_PROCESS).

> This patch adds a new callback, prep_move_task, to struct sched_class
> to give sched_fair the opportunity to adjust the task's vruntime
> just before setting its new group. This allows us to properly normalize
> a sleeping task's vruntime when moving it between different cgroups.

Acked-by: Mike Galbraith <efault@gmx.de>

> Cc: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: Dima Zavin <dima@android.com>
> ---
>  include/linux/sched.h |    1 +
>  kernel/sched.c        |    5 +++++
>  kernel/sched_fair.c   |   14 +++++++++++++-
>  3 files changed, 19 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 1e2a6db..ba3494e 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1073,6 +1073,7 @@ struct sched_class {
>  
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  	void (*moved_group) (struct task_struct *p, int on_rq);
> +	void (*prep_move_group) (struct task_struct *p, int on_rq);
>  #endif
>  };
>  
> diff --git a/kernel/sched.c b/kernel/sched.c
> index dc85ceb..fe4bb20 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8297,6 +8297,11 @@ void sched_move_task(struct task_struct *tsk)
>  	if (unlikely(running))
>  		tsk->sched_class->put_prev_task(rq, tsk);
>  
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +	if (tsk->sched_class->prep_move_group)
> +		tsk->sched_class->prep_move_group(tsk, on_rq);
> +#endif
> +
>  	set_task_rq(tsk, task_cpu(tsk));
>  
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index db3f674..6ded59f 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3827,10 +3827,21 @@ static void set_curr_task_fair(struct rq *rq)
>  static void moved_group_fair(struct task_struct *p, int on_rq)
>  {
>  	struct cfs_rq *cfs_rq = task_cfs_rq(p);
> +	struct sched_entity *se = &p->se;
>  
>  	update_curr(cfs_rq);
>  	if (!on_rq)
> -		place_entity(cfs_rq, &p->se, 1);
> +		se->vruntime += cfs_rq->min_vruntime;
> +}
> +
> +static void prep_move_group_fair(struct task_struct *p, int on_rq)
> +{
> +	struct cfs_rq *cfs_rq = task_cfs_rq(p);
> +	struct sched_entity *se = &p->se;
> +
> +	/* normalize the runtime of a sleeping task before moving it */
> +	if (!on_rq)
> +		se->vruntime -= cfs_rq->min_vruntime;
>  }
>  #endif
>  
> @@ -3883,6 +3894,7 @@ static const struct sched_class fair_sched_class = {
>  
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  	.moved_group		= moved_group_fair,
> +	.prep_move_group	= prep_move_group_fair,
>  #endif
>  };
>  

