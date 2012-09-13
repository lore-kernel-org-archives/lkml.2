Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab2IMIUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:20:50 -0400
Received: from [205.233.59.134] ([205.233.59.134]:53366 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab2IMIUl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:20:41 -0400
Message-ID: <1347524318.15764.99.camel@twins>
Subject: Re: [RFC] sched: nohz_idle_balance
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        mingo@redhat.com, Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Date: Thu, 13 Sep 2012 10:18:38 +0200
In-Reply-To: <1347509486-8688-1-git-send-email-vincent.guittot@linaro.org>
References: <1347509486-8688-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 06:11 +0200, Vincent Guittot wrote:
> On tickless system, one CPU runs load balance for all idle CPUs.
> The cpu_load of this CPU is updated before starting the load balance
> of each other idle CPUs. We should instead update the cpu_load of the balance_cpu.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1ca4fe4..9ae3a5b 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4794,14 +4794,15 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
>  		if (need_resched())
>  			break;
>  
> -		raw_spin_lock_irq(&this_rq->lock);
> -		update_rq_clock(this_rq);
> -		update_idle_cpu_load(this_rq);
> -		raw_spin_unlock_irq(&this_rq->lock);
> +		rq = cpu_rq(balance_cpu);
> +
> +		raw_spin_lock_irq(&rq->lock);
> +		update_rq_clock(rq);
> +		update_idle_cpu_load(rq);
> +		raw_spin_unlock_irq(&rq->lock);

D'0h good spotting..

>  		rebalance_domains(balance_cpu, CPU_IDLE);
>  
> -		rq = cpu_rq(balance_cpu);
>  		if (time_after(this_rq->next_balance, rq->next_balance))
>  			this_rq->next_balance = rq->next_balance;
>  	}

