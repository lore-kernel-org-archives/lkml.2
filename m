Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab0LOSYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 13:24:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:36318 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab0LOSYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 13:24:31 -0500
Subject: Re: [PATCH 1/2] sched: Fix the irqtime code to deal with u64 wraps
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <AANLkTin86W-W69fGpj+5LCP7L-KQfA_tn506o+RZ_UED@mail.gmail.com>
References: <1292013506.13513.78.camel@laptop>
	 <AANLkTi=vUvNET2peva7uzWbzk5eK5EsKUrEQQSwLkNwM@mail.gmail.com>
	 <1292242433.6803.199.camel@twins>
	 <AANLkTin86W-W69fGpj+5LCP7L-KQfA_tn506o+RZ_UED@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 15 Dec 2010 19:24:12 +0100
Message-ID: <1292437452.2708.45.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 10:16 -0800, Venkatesh Pallipadi wrote:
> Peter,
> 
> This looks like something that happened while splitting this into two
> patches. I needed a trivial change like below before I could apply
> these two patches on linus-git.
> 
> Thanks,
> Venki
> ---
> @@ -641,17 +641,18 @@ static void sched_irq_time_avg_update(struct rq
> *rq, u64 irq_time);
> 
>  inline void update_rq_clock(struct rq *rq)
>  {
> -	if (!rq->skip_clock_update) {
> -		int cpu = cpu_of(rq);
> -		u64 irq_time;
> +	int cpu = cpu_of(rq);
> +	u64 irq_time;
> 
> -		rq->clock = sched_clock_cpu(cpu);
> -		irq_time = irq_time_cpu(cpu);
> -		if (rq->clock - irq_time > rq->clock_task)
> -			rq->clock_task = rq->clock - irq_time;
> +	if (rq->skip_clock_update)
> +		return;
> 
> -		sched_irq_time_avg_update(rq, irq_time);
> -	}
> +	rq->clock = sched_clock_cpu(cpu);
> +	irq_time = irq_time_cpu(cpu);
> +	if (rq->clock - irq_time > rq->clock_task)
> +		rq->clock_task = rq->clock - irq_time;
> +
> +	sched_irq_time_avg_update(rq, irq_time);
>  }
> 
>  /*


That's due another patch in tip/sched/urgent


