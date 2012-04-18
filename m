Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab2DRFaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 01:30:14 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64793 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2DRFaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 01:30:12 -0400
Date: Wed, 18 Apr 2012 13:20:57 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: RFC [patch] sched,cgroup_sched: convince RT_GROUP_SCHED throttle
 to work
Message-ID: <20120418052057.GA19328@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1333444106.9072.4.camel@marge.simpson.net>
 <1333444788.9072.9.camel@marge.simpson.net>
 <1333789124.12677.15.camel@marge.simpson.net>
 <1333792489.12677.58.camel@marge.simpson.net>
 <1334048925.7524.21.camel@marge.simpson.net>
 <1334401847.2528.65.camel@twins>
 <1334461061.5751.15.camel@marge.simpson.net>
 <1334461470.5751.21.camel@marge.simpson.net>
 <1334465495.7802.6.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1334465495.7802.6.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 06:51:35AM +0200, Mike Galbraith wrote:
> Like so seems to work.  I personally like 2 lines better, but whatever
> solves dinky but deadly problem works for me.
> 
> ---
>  kernel/sched/core.c  |    7 ++++++-
>  kernel/sched/rt.c    |    9 +++++++++
>  kernel/sched/sched.h |    3 +++
>  3 files changed, 18 insertions(+), 1 deletion(-)
> 
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5875,6 +5875,11 @@ cpu_attach_domain(struct sched_domain *s
>  			sd->child = NULL;
>  	}
>  
> +	if (sd)
> +		cpumask_clear_cpu(cpu, cpu_isolated_map);
> +	else
> +		cpumask_set_cpu(cpu, cpu_isolated_map);
> +

Do we allow this?
Seems sched_domain_debug() will bite !sd.

Thanks,
Yong

>  	sched_domain_debug(sd, cpu);
>  
>  	rq_attach_root(rq, rd);
> @@ -5886,7 +5891,7 @@ cpu_attach_domain(struct sched_domain *s
>  }
>  
>  /* cpus with isolated domains */
> -static cpumask_var_t cpu_isolated_map;
> +cpumask_var_t cpu_isolated_map;
>  
>  /* Setup the mask of cpus configured for isolated domains */
>  static int __init isolated_cpu_setup(char *str)
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -922,6 +922,9 @@ static void update_curr_rt(struct rq *rq
>  	if (!rt_bandwidth_enabled())
>  		return;
>  
> +	if (cpumask_test_cpu(cpu_of(rq), cpu_isolated_map))
> +		return;
> +
>  	for_each_sched_rt_entity(rt_se) {
>  		rt_rq = rt_rq_of_se(rt_se);
>  
> @@ -1014,6 +1017,9 @@ static inline void dec_rt_prio(struct rt
>  static void
>  inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>  {
> +	if (cpumask_test_cpu(rq_of_rt_rq(rt_rq)->cpu, cpu_isolated_map))
> +		return;
> +
>  	if (rt_se_boosted(rt_se))
>  		rt_rq->rt_nr_boosted++;
>  
> @@ -1035,6 +1041,9 @@ dec_rt_group(struct sched_rt_entity *rt_
>  static void
>  inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>  {
> +	if (cpumask_test_cpu(rq_of_rt_rq(rt_rq)->cpu, cpu_isolated_map))
> +		return;
> +
>  	start_rt_bandwidth(&def_rt_bandwidth);
>  }
>  
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -73,6 +73,9 @@ struct rt_bandwidth {
>  
>  extern struct mutex sched_domains_mutex;
>  
> +/* cpus with isolated domains */
> +extern cpumask_var_t cpu_isolated_map;
> +
>  #ifdef CONFIG_CGROUP_SCHED
>  
>  #include <linux/cgroup.h>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
