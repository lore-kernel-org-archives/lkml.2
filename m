Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab1F3DdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 23:33:17 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40806 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab1F3DdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 23:33:10 -0400
Message-ID: <4E0BEE6F.3090802@linux.vnet.ibm.com>
Date: Thu, 30 Jun 2011 11:33:03 +0800
From: Cheng Xu <chengxu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH V2] sched: skip autogroup when looking for all rt sched
 groups
References: <BANLkTikKRnQb_T5x1BA=WopbBA_weLNFoQ@mail.gmail.com> <4E0321AD.2080308@linux.vnet.ibm.com> <BANLkTinacDgzZenwmG4==1gYfEaQg-YQ-g@mail.gmail.com> <BANLkTi=87P3RoTF_UEtamNfc_XGxQXE__Q@mail.gmail.com>
In-Reply-To: <BANLkTi=87P3RoTF_UEtamNfc_XGxQXE__Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2011 10:51 AM, Yong Zhang wrote:
> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [PATCH V2] sched: skip autogroup when looking for all rt sched groups
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
> V2: Based on Cheng Xu's idea which uses less code.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Cheng Xu <chengxu@linux.vnet.ibm.com>

The code looks fine, and works for me. 

Reviewed-by: Cheng Xu <chengxu@linux.vnet.ibm.com>

> ---
> 
> Attach it too in case webmail will mangle the patch.
> 
>  kernel/sched_autogroup.h |    1 +
>  kernel/sched_rt.c        |   22 +++++++++++++++++-----
>  2 files changed, 18 insertions(+), 5 deletions(-)
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
> index 10d0182..8c04cb2 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -185,11 +185,23 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
> 
>  typedef struct task_group *rt_rq_iter_t;
> 
> -#define for_each_rt_rq(rt_rq, iter, rq) \
> -	for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list); \
> -	     (&iter->list != &task_groups) && \
> -	     (rt_rq = iter->rt_rq[cpu_of(rq)]); \
> -	     iter = list_entry_rcu(iter->list.next, typeof(*iter), list))
> +static inline struct task_group *next_task_group(struct task_group *tg)
> +{
> +	do {
> +		tg = list_entry_rcu(tg->list.next,
> +			typeof(struct task_group), list);
> +	} while (&tg->list != &task_groups && task_group_is_autogroup(tg));
> +
> +	if (&tg->list == &task_groups)
> +		tg = NULL;
> +
> +	return tg;
> +}
> +
> +#define for_each_rt_rq(rt_rq, iter, rq)					\
> +	for (iter = container_of(&task_groups, typeof(*iter), list);	\
> +		(iter = next_task_group(iter)) &&			\
> +		(rt_rq = iter->rt_rq[cpu_of(rq)]);)
> 
>  static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
>  {

