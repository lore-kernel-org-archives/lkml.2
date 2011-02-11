Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab1BKTEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 14:04:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:56324 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab1BKTEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 14:04:41 -0500
Subject: Re: [PATCH v3 5/6] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Venkatesh Pallipadi <venki@google.com>
In-Reply-To: <1297448364-14051-6-git-send-email-glommer@redhat.com>
References: <1297448364-14051-1-git-send-email-glommer@redhat.com>
	 <1297448364-14051-6-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 20:05:45 +0100
Message-ID: <1297451145.5226.88.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 13:19 -0500, Glauber Costa wrote:

>  static void update_rq_clock_task(struct rq *rq, s64 delta)
>  {
> +	s64 irq_delta = 0, steal = 0;
>  
> +#ifdef CONFIG_IRQ_TIME_ACCOUNTING
>  	irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
>  
>  	/*
> @@ -1926,20 +1932,24 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
>  
>  	rq->prev_irq_time += irq_delta;
>  	delta -= irq_delta;
> +#endif
> +#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
>  
> +	steal = steal_time_clock(cpu_of(rq)) - rq->prev_steal_time;
>  
> +	if (steal > delta)
> +		steal = delta;
> +
> +	rq->prev_steal_time += steal;
> +
> +	delta -= steal;
> +#endif
>  
>  	rq->clock_task += delta;
>  
> +	if ((irq_delta + steal) && sched_feat(NONTASK_POWER))
> +		sched_rt_avg_update(rq, irq_delta + steal);
> +}

I think we should make both these conditional, like:

#ifdef CONFIG_IRQ_TIME_ACCOUNTING
  if (sched_clock_irqtime) {
    /* ... magic ... */
  }
#endif

#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
  if (sched_paravirt_time) {
    /* ... magic ... */
  }
#endif


Once the jump-label stuff gets a bit better we could use the if
(static_branch()) magic to avoid pretty much all cost.

