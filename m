Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1GBK0B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 06:26:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48373 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab1GBKZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 06:25:59 -0400
Subject: Re: [PATCH v4 8/9] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>, Jeff Law <law@redhat.com>
In-Reply-To: <1309555369-16867-9-git-send-email-glommer@redhat.com>
References: <1309555369-16867-1-git-send-email-glommer@redhat.com>
	 <1309555369-16867-9-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 02 Jul 2011 12:24:51 +0200
Message-ID: <1309602291.10073.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 17:22 -0400, Glauber Costa wrote:
> @@ -1971,8 +1974,14 @@ static inline u64 steal_ticks(u64 steal)
>  
>  static void update_rq_clock_task(struct rq *rq, s64 delta)
>  {
> -       s64 irq_delta;
> -
> +/*
> + * In theory, the compile should just see 0 here, and optimize out the call
> + * to sched_rt_avg_update. But I don't trust it...
> + */
> +#if defined(CONFIG_IRQ_TIME_ACCOUNTING) || defined(CONFIG_PARAVIRT_TIME_ACCOUNTING)
> +       s64 steal = 0, irq_delta = 0;
> +#endif

So I wanted to ask a GCC person (Hi Jeff) about this.

> +#ifdef CONFIG_IRQ_TIME_ACCOUNTING
>         irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
>  
>         /*
> @@ -1995,12 +2004,35 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
>  
>         rq->prev_irq_time += irq_delta;
>         delta -= irq_delta;
> +#endif
> +#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> +       if (static_branch((&paravirt_steal_rq_enabled))) {
> +               u64 st;
> +
> +               steal = paravirt_steal_clock(cpu_of(rq));
> +               steal -= rq->prev_steal_time_rq;
> +
> +               if (unlikely(steal > delta))
> +                       steal = delta;
> +
> +               st = steal_ticks(steal);
> +               steal = st * TICK_NSEC;
> +
> +               rq->prev_steal_time_rq += steal;
> +
> +               delta -= steal;
> +       }
> +#endif
> +
>         rq->clock_task += delta;
>  
> -       if (irq_delta && sched_feat(NONIRQ_POWER))
> -               sched_rt_avg_update(rq, irq_delta);
> +#if defined(CONFIG_IRQ_TIME_ACCOUNTING) || defined(CONFIG_PARAVIRT_TIME_ACCOUNTING)
> +       if ((irq_delta + steal) && sched_feat(NONTASK_POWER))
> +               sched_rt_avg_update(rq, irq_delta + steal);
> +#endif
>  } 

In case of !CONFIG_IRQ_TIME_ACCOUNTING && !
CONFIG_PARAVIRT_TIME_ACCOUNTING, irq_delta and steal will both always be
0.

The function will basically look like:

static void update_rq_clock_task(struct rq *rq, s64 delta)
{
	s64 irq_delta = 0, steal = 0;

	rq->clock_task += delta;

	if ((irq_delta + steal) && sched_feat(NONTASK_POWER))
		sched_rt_avg_update(rq, irq_delta + steal);
}

And we want it to emit the equivalent of:

static void update_rq_clock_task(struct rq *rq, s64 delta)
{
	rq->clock_task += delta;
}

Now Glauber is properly paranoid and doesn't trust his compiler (this is
very hot code in the kernel so any extra code emitted here is sad) and
chose the heavy handed CPP solution.

Now without checking a all relevant gcc versions on all relevant
architectures (see you in a few weeks etc..) can we actually rely on gcc
doing such relatively simple things correct, or should we stick with CPP
just to make sure?
