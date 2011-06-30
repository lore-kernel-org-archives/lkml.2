Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1F3Vzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:55:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:52221 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1F3Vze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:55:34 -0400
Subject: Re: [PATCH v3 8/9] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <1309361388-30163-9-git-send-email-glommer@redhat.com>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
	 <1309361388-30163-9-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Jun 2011 23:54:28 +0200
Message-ID: <1309470868.12449.606.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 11:29 -0400, Glauber Costa wrote:

> @@ -2063,12 +2092,7 @@ static int irqtime_account_si_update(void)
>  
>  #define sched_clock_irqtime    (0)
>  
> -static void update_rq_clock_task(struct rq *rq, s64 delta)
> -{
> -       rq->clock_task += delta;
> -}
> -
> -#endif /* CONFIG_IRQ_TIME_ACCOUNTING */ 

That relies on the compiler realizing that irq_delta and steal will
never be used in the below function:

> static void update_rq_clock_task(struct rq *rq, s64 delta)
>  {
> +       s64 irq_delta = 0, steal = 0;
>  
> +#ifdef CONFIG_IRQ_TIME_ACCOUNTING
>         irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
>  
>         /*
> @@ -2023,12 +2034,30 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
>  
>         rq->prev_irq_time += irq_delta;
>         delta -= irq_delta;
> +#endif
> +#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> +       if (static_branch((&paravirt_steal_rq_enabled))) {
> +               int is_idle;
> +               u64 st;
> +
> +               is_idle = ((rq->curr != rq->idle) ||
> +                               irq_count() != HARDIRQ_OFFSET);
> +
> +               __touch_steal_time(is_idle, delta, &st);
> +
> +               steal = st * TICK_NSEC;
> +
> +               delta -= steal;
> +       }
> +#endif
> +
>         rq->clock_task += delta;
>  
> +       if ((irq_delta + steal) && sched_feat(NONTASK_POWER))
> +               sched_rt_avg_update(rq, irq_delta + steal);
>  }

And thus trim the last bit as if(0) and DCE. Did you verify that the
compiler does indeed do that for !PARAVIRT !IRQ_TIME_ACCOUNTING ?
