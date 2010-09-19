Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0ISLbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 07:31:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:46343 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0ISLbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 07:31:41 -0400
Subject: Re: [PATCH 5/6] sched: Remove irq time from available CPU power
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>
In-Reply-To: <1284688596-6731-6-git-send-email-venki@google.com>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	 <1284688596-6731-6-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 19 Sep 2010 13:31:33 +0200
Message-ID: <1284895893.2275.627.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 18:56 -0700, Venkatesh Pallipadi wrote:
> +++ b/kernel/sched.c
> @@ -2025,6 +2025,18 @@ static u64 unaccount_irq_delta(u64 delta, int cpu, u64 *saved_irq_time)
>  #define unaccount_irq_delta_rt(delta, cpu, class_rq)            \
>                 unaccount_irq_delta(delta, cpu, &(class_rq)->saved_irq_time)
>  
> +static void sched_irq_power_update_fair(int cpu, struct cfs_rq *cfs_rq,
> +                       struct rq* rq)
> +{
> +       if (!sched_clock_irqtime)
> +               return;
> +
> +       if (likely(rq->total_irq_time > cfs_rq->saved_irq_time)) {
> +               sched_rt_avg_update(rq,
> +                               rq->total_irq_time - cfs_rq->saved_irq_time);
> +       }
> +}
> +
>  #else
>  
>  #define update_irq_time(cpu, crq)              do { } while (0)
> @@ -2042,6 +2054,8 @@ static u64 unaccount_irq_delta_rt(u64 delta_exec, int cpu, struct rt_rq *rt_rq)
>         return delta_exec;
>  }
>  
> +#define sched_irq_power_update_fair(cpu, crq, rq)      do { } while (0)
> +
>  #endif
>  
>  #include "sched_idletask.c"
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index a64fdaf..937fded 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -526,6 +526,9 @@ static void update_curr(struct cfs_rq *cfs_rq)
>         if (unlikely(!curr))
>                 return;
>  
> +       if (sched_feat(NONIRQ_POWER) && entity_is_task(curr))
> +               sched_irq_power_update_fair(cpu, cfs_rq, rq_of(cfs_rq));
> +
>         /*
>          * Get the amount of time the current task was running
>          * since the last time we changed load (this cannot 

This all looks very confusing to me,.. How about we simply fold the
delta between rq->clock and rq->clock_task into sched_rt_avg_update()
and be done with it?
