Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab1FWLVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:21:35 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49951 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339Ab1FWLVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:21:33 -0400
Message-ID: <4E0321AD.2080308@linux.vnet.ibm.com>
Date: Thu, 23 Jun 2011 19:21:17 +0800
From: Cheng Xu <chengxu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: skip autogroup when looking for all rt sched groups
References: <BANLkTikKRnQb_T5x1BA=WopbBA_weLNFoQ@mail.gmail.com>
In-Reply-To: <BANLkTikKRnQb_T5x1BA=WopbBA_weLNFoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 01:22 PM, Yong Zhang wrote:
> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [PATCH] sched: skip autogroup when looking for all rt sched groups
> 
> Since [commit ec514c48: sched: Fix rt_rq runtime leakage bug],
> 'cat /proc/sched_debug' will print data of root_task_group.rt_rq
> multi times, this is due to autogroup has no its own rt group,
> instead rt group of autogroup is linked to root_task_group.
> 
> So skip it when we are looking for all rt sched groups, and it
> will also save some noop operation against root_task_group when
> __disable_runtime()/__enable_runtime().
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mike Galbraith <efault@gmx.de>
> ---
> 
> Since webmail may mangle the patch, attach it too.
> 
>  kernel/sched_autogroup.h |    1 +
>  kernel/sched_rt.c        |   29 ++++++++++++++++++++++++-----
>  2 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched_autogroup.h b/kernel/sched_autogroup.h
> index 0557705..c2f0e72 100644
> --- a/kernel/sched_autogroup.h
> +++ b/kernel/sched_autogroup.h
> @@ -13,6 +13,7 @@ struct autogroup {
>  	int			nice;
>  };
> 
> +static inline bool task_group_is_autogroup(struct task_group *tg);
>  static inline struct task_group *
>  autogroup_task_group(struct task_struct *p, struct task_group *tg);
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 10d0182..8edf487 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -185,11 +185,30 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
> 
>  typedef struct task_group *rt_rq_iter_t;
> 
> -#define for_each_rt_rq(rt_rq, iter, rq) \
> -	for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list); \
> -	     (&iter->list != &task_groups) && \
> -	     (rt_rq = iter->rt_rq[cpu_of(rq)]); \
> -	     iter = list_entry_rcu(iter->list.next, typeof(*iter), list))
> +/* autogroup is not related to rt group, skip it */
> +#define find_first_valid_task_group(iter)				\
> +	({								\
> +		list_for_each_entry_rcu(iter, &task_groups, list)	\
> +			if (!task_group_is_autogroup(iter))		\
> +				break;					\
> +		iter;							\
> +	})
> +
> +#define find_next_valid_task_group(iter)				\
> +	({								\
> +		do {							\
> +			iter = list_entry_rcu(iter->list.next,		\
> +					typeof(*iter),	list);		\
> +		} while (&iter->list != &task_groups &&			\
> +			task_group_is_autogroup(iter));			\
> +		iter;							\
> +	})
> +
> +#define for_each_rt_rq(rt_rq, iter, rq)					\
> +	for (find_first_valid_task_group(iter);				\
> +	     (&iter->list != &task_groups) &&				\
> +	     (rt_rq = iter->rt_rq[cpu_of(rq)]);				\
> +	     find_next_valid_task_group(iter))
> 
>  static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
>  {

This looks like it works, but seems we might be able to do that with less code... 

static inline struct task_group *next_task_group(struct task_group *tg)
{
	do {
		tg = list_entry_rcu(tg->list.next,
		                    typeof(struct task_group), list);
	} while ((&tg->list != &task_groups) && (task_group_is_autogroup(tg)));
	if (&tg->list == &task_groups)
		tg = NULL;
	return tg;
}

#define for_each_rt_rq(rt_rq, iter, rq) \
	for (iter = container_of(&task_groups, typeof(*iter), list); \
	     (iter = next_task_group(iter)) && \
	     (rt_rq = iter->rt_rq[cpu_of(rq)]);)


Thanks,
Cheng
