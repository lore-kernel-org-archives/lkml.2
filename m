Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab0JLGfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 02:35:13 -0400
Received: from ifrit.dereferenced.org ([66.212.21.15]:35738 "EHLO
	ifrit.dereferenced.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab0JLGfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 02:35:11 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Oct 2010 02:35:11 EDT
Date: Tue, 12 Oct 2010 10:29:14 +0400 (MSD)
From: William Pitcock <nenolod@dereferenced.org>
To: linux-kernel@vger.kernel.org
Message-ID: <19061036.1641286864954363.JavaMail.root@ifrit.dereferenced.org>
In-Reply-To: <20101012062552.4D7F2CE142@carpathia.dereferenced.org>
Subject: Re: [PATCH] CFS: Add hierarchical tree-based penalty.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.202.104.35]
X-Mailer: Zimbra 6.0.0_BETA2_1547.UBUNTU8 (ZimbraWebClient - FF3.0 (Linux)/6.0.0_BETA2_1547.UBUNTU8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for the duplicate mails, the first two patches had a typo.

William

----- "William Pitcock" <nenolod@dereferenced.org> wrote:

> Inspired by the recent change to BFS by Con Kolivas, this patch
> causes
> vruntime to be penalized based on parent depth from their root task
> group.
> 
> I have, for the moment, decided to make it a default feature since
> the
> design of CFS ensures that broken applications depending on task
> enqueue
> behaviour behaving traditionally will continue to work.
> 
> My method for applying the penalty is different than that of BFS, it
> divides the vruntime by the number of parents the process has.
> 
> Signed-off-by: William Pitcock <nenolod@dereferenced.org>
> ---
>  include/linux/sched.h   |    2 ++
>  kernel/sched.c          |    4 ++++
>  kernel/sched_fair.c     |    7 +++++++
>  kernel/sched_features.h |   12 ++++++++++++
>  4 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 1e2a6db..49fca7c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1494,6 +1494,8 @@ struct task_struct {
>  		unsigned long memsw_bytes; /* uncharged mem+swap usage */
>  	} memcg_batch;
>  #endif
> +
> +	int parent_count;
>  };
>  
>  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> diff --git a/kernel/sched.c b/kernel/sched.c
> index dc85ceb..0e55350 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2621,6 +2621,10 @@ void wake_up_new_task(struct task_struct *p,
> unsigned long clone_flags)
>  #endif
>  
>  	rq = task_rq_lock(p, &flags);
> +
> +	if (!(clone_flags & CLONE_THREAD))
> +		p->parent_count++;
> +
>  	activate_task(rq, p, 0);
>  	trace_sched_wakeup_new(p, 1);
>  	check_preempt_curr(rq, p, WF_FORK);
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index db3f674..3059fe0 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -737,6 +737,13 @@ place_entity(struct cfs_rq *cfs_rq, struct
> sched_entity *se, int initial)
>  	if (initial && sched_feat(START_DEBIT))
>  		vruntime += sched_vslice(cfs_rq, se);
>  
> +	if (sched_feat(HIERARCHICAL_PENALTY)) {
> +		struct task_struct *tsk = task_of(se);
> +
> +		if (tsk->parent_count > 1)
> +			vruntime /= tsk->parent_count;
> +	}
> +
>  	/* sleeps up to a single latency don't count. */
>  	if (!initial) {
>  		unsigned long thresh = sysctl_sched_latency;
> diff --git a/kernel/sched_features.h b/kernel/sched_features.h
> index 83c66e8..cf17f97 100644
> --- a/kernel/sched_features.h
> +++ b/kernel/sched_features.h
> @@ -45,6 +45,18 @@ SCHED_FEAT(LAST_BUDDY, 1)
>  SCHED_FEAT(CACHE_HOT_BUDDY, 1)
>  
>  /*
> + * Hierarchical tree-based penalty: penalize service deficit by
> + * an order of magnitude for each parent process in the process
> + * tree.  This has the natural effect of forcing preference towards
> + * processes that are not fork()-hungry, like make(1), which helps
> + * to preserve good latency.
> + *
> + * This also has the side effect of providing in a limited way,
> + * per-user CPU entitlement partitioning.
> + */
> +SCHED_FEAT(HIERARCHICAL_PENALTY, 1)
> +
> +/*
>   * Use arch dependent cpu power functions
>   */
>  SCHED_FEAT(ARCH_POWER, 0)
> -- 
> 1.7.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
