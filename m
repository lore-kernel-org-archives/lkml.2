Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1KXLsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 06:48:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:40913 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1KXLsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 06:48:03 -0500
Message-ID: <1322135263.2921.12.camel@twins>
Subject: Re: [patch 3/6] sched, nohz: sched group, domain aware nohz idle
 load balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com
Date: Thu, 24 Nov 2011 12:47:43 +0100
In-Reply-To: <20111118230553.995756330@sbsiddha-desk.sc.intel.com>
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
	 <20111118230553.995756330@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 15:03 -0800, Suresh Siddha wrote:
>  static inline int nohz_kick_needed(struct rq *rq, int cpu)
>  {
>         unsigned long now = jiffies;
>         struct sched_domain *sd;
>  
> +       if (unlikely(idle_cpu(cpu)))
> +               return 0;
> +
>         /*
>          * We were recently in tickless idle mode. At the first busy tick
>          * after returning from idle, we will update the busy stats.
> @@ -5120,36 +5047,43 @@ static inline int nohz_kick_needed(struc
>         if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
>                 clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
>  
> +               cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
> +               atomic_dec(&nohz.nr_cpus);
> +
>                 for_each_domain(cpu, sd)
>                         atomic_inc(&sd->groups->sgp->nr_busy_cpus);
>         }
>  
> +       /*
> +        * None are in tickless mode and hence no need for NOHZ idle load
> +        * balancing.
> +        */
> +       if (likely(!atomic_read(&nohz.nr_cpus)))
>                 return 0;
>  
> +       if (time_before(now, nohz.next_balance))
>                 return 0;
>  
> +       if (rq->nr_running >= 2)
> +               goto need_kick;
>  
> +       for_each_domain(cpu, sd) {
> +               struct sched_group *sg = sd->groups;
> +               struct sched_group_power *sgp = sg->sgp;
> +               int nr_busy = atomic_read(&sgp->nr_busy_cpus);
> +
> +               if (nr_busy > 1 && (nr_busy * SCHED_LOAD_SCALE > sgp->power))
> +                       goto need_kick;

This looks wrong, its basically always true for a box with HT.

sgp->power is a measure of how much compute power this group has, its
basic form is sg->weight * SCHED_POWER_SCALE and is reduced from there;
HT siblings get less since they're not as powerful as two actual cores
and we deduct time spend on RT-tasks and IRQs etc..

So how does comparing the load of non-nohz cpus to that make sense?

> +
> +               if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
> +                   && (cpumask_first_and(nohz.idle_cpus_mask,
> +                                         sched_domain_span(sd)) < cpu))
> +                       goto need_kick;
>         }
> +
>         return 0;
> +need_kick:
> +       return 1;
>  } 
