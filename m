Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab1EKP7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:59:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:54154 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab1EKP7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:59:05 -0400
Subject: Re: [PATCH] sched: rt_rq runtime leakage bug fix
From: Peter Zijlstra <peterz@infradead.org>
To: Cheng Xu <chengxu@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mckenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4DCA3C0C.3080901@linux.vnet.ibm.com>
References: <4DCA3C0C.3080901@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 11:21:51 +0200
Message-ID: <1305105711.2914.205.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 15:34 +0800, Cheng Xu wrote:
> This patch is to fix bug report https://lkml.org/lkml/2011/4/26/13

This really doesn't tell me anything, please restate the relevant
information.

> Function __disable_runtime() reports leakage of rt_rq runtime. The
> root cause is __disable_runtime() assumes it iterates through all the
> existing rt_rq's while walking rq->leaf_rt_rq_list, which actually
> contains only runnable rt_rq's. This problem also applies to
> __enable_runtime() and print_rt_stats().

Teach your mailer to wrap at 78 characters for changelogs.

> The patch is based on above analysis, appears to fix the problem, but is only lightly tested.
> 
> 
> Signed-off-by: Cheng Xu <chengxu@linux.vnet.ibm.com>
> Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 

Don't leave whitespace between the tags and the tripple-dash. Also, I'm
suspecting you're missing a Reported-by: paulmck tag.

> ---
>  kernel/sched_rt.c |   31 ++++++++++++++++++++++++-------
>  1 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index e7cebdc..7f478ff 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -183,6 +183,13 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
>  	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
>  }
>  
> +#define rt_rq_of_rq_decls(name) struct task_group *name
> +
> +#define list_for_rt_rq_of_rq(iterator, rq) \
> +	list_for_each_entry_rcu(iterator, &task_groups, list)
> +
> +#define rt_rq_of_rq_deref(iterator, rq) (iterator->rt_rq[cpu_of(rq)])
> +
>  static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
>  {
>  	list_add_rcu(&rt_rq->leaf_rt_rq_list,
> @@ -288,6 +295,13 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
>  	return ktime_to_ns(def_rt_bandwidth.rt_period);
>  }
>  
> +#define rt_rq_of_rq_decls(name) struct rt_rq *name
> +
> +#define list_for_rt_rq_of_rq(iterator, rq) \
> +	for (iterator = &rq->rt; iterator; iterator = NULL)
> +
> +#define rt_rq_of_rq_deref(iterator, rq) (iterator)
> +
>  static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
>  {
>  }

So I see why you did that, I just don't much like it.. esp the decls
macros, C has typedef to deal with that problem, also you can get rid of
the deref macros (now if we were allowed C99 we could avoid the whole
iter thing and declare a for-scope variable).

How about something like:

typedef struct task_group *rt_rq_iter_t;

#define for_each_rt_rq(rt_rq, iter, rq)                                     \
	for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list),  \
	     rt_rq = iter->rt_rq[cpu_of(rq)]; &iter->list != &task_groups;  \
	     iter = list_entry_rcu(iter->list.next, typeof(*iter), list),   \
	     rt_rq = iter->rt_rq[cpu_of(rq)])

	    
which is then used like:

	rt_rq_iter_t iter;
	struct rt_rq *rt_rq;

	for_each_rt_rq(rt_rq, iter, rq) {
		/* do something with rt_rq */
	}


