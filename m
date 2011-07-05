Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1GEJMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 05:12:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:32997 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab1GEJMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 05:12:02 -0400
Subject: Re: [PATCH v5 7/9] KVM-GST: KVM Steal time accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>,
        Venkatesh Pallipadi <venki@google.com>
In-Reply-To: <1309793548-16714-8-git-send-email-glommer@redhat.com>
References: <1309793548-16714-1-git-send-email-glommer@redhat.com>
	 <1309793548-16714-8-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Jul 2011 11:11:39 +0200
Message-ID: <1309857099.3282.46.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 11:32 -0400, Glauber Costa wrote:
> This patch accounts steal time time in account_process_tick.
> If one or more tick is considered stolen in the current
> accounting cycle, user/system accounting is skipped. Idle is fine,
> since the hypervisor does not report steal time if the guest
> is halted.
> 
> Accounting steal time from the core scheduler give us the
> advantage of direct acess to the runqueue data. In a later
> opportunity, it can be used to tweak cpu power and make
> the scheduler aware of the time it lost.
> 
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Acked-by: Peter Zijlstra <peterz@infradead.org>

Venki, can you have a look at that irqtime_account_process_tick(), I
think adding the steal time up front like this is fine, because it
suffers from the same 'problem' as both irqtime thingies.

> CC: Avi Kivity <avi@redhat.com>
> CC: Anthony Liguori <aliguori@us.ibm.com>
> CC: Eric B Munson <emunson@mgebm.net>
> ---
>  kernel/sched.c |   41 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 41 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3f2e502..aa6c030 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -75,6 +75,7 @@
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
>  #include <asm/mutex.h>
> +#include <asm/paravirt.h>
>  
>  #include "sched_cpupri.h"
>  #include "workqueue_sched.h"
> @@ -528,6 +529,9 @@ struct rq {
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>  	u64 prev_irq_time;
>  #endif
> +#ifdef CONFIG_PARAVIRT
> +	u64 prev_steal_time;
> +#endif
>  
>  	/* calc_load related fields */
>  	unsigned long calc_load_update;
> @@ -1953,6 +1957,18 @@ void account_system_vtime(struct task_struct *curr)
>  }
>  EXPORT_SYMBOL_GPL(account_system_vtime);
>  
> +#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
> +
> +#ifdef CONFIG_PARAVIRT
> +static inline u64 steal_ticks(u64 steal)
> +{
> +	if (unlikely(steal > NSEC_PER_SEC))
> +		return div_u64(steal, TICK_NSEC);
> +
> +	return __iter_div_u64_rem(steal, TICK_NSEC, &steal);
> +}
> +#endif
> +
>  static void update_rq_clock_task(struct rq *rq, s64 delta)
>  {
>  	s64 irq_delta;
> @@ -3845,6 +3861,25 @@ void account_idle_time(cputime_t cputime)
>  		cpustat->idle = cputime64_add(cpustat->idle, cputime64);
>  }
>  
> +static __always_inline bool steal_account_process_tick(void)
> +{
> +#ifdef CONFIG_PARAVIRT
> +	if (static_branch(&paravirt_steal_enabled)) {
> +		u64 steal, st = 0;
> +
> +		steal = paravirt_steal_clock(smp_processor_id());
> +		steal -= this_rq()->prev_steal_time;
> +
> +		st = steal_ticks(steal);
> +		this_rq()->prev_steal_time += st * TICK_NSEC;
> +
> +		account_steal_time(st);
> +		return st;
> +	}
> +#endif
> +	return false;
> +}
> +
>  #ifndef CONFIG_VIRT_CPU_ACCOUNTING
>  
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
> @@ -3876,6 +3911,9 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
>  	cputime64_t tmp = cputime_to_cputime64(cputime_one_jiffy);
>  	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
>  
> +	if (steal_account_process_tick())
> +		return;
> +
>  	if (irqtime_account_hi_update()) {
>  		cpustat->irq = cputime64_add(cpustat->irq, tmp);
>  	} else if (irqtime_account_si_update()) {
> @@ -3929,6 +3967,9 @@ void account_process_tick(struct task_struct *p, int user_tick)
>  		return;
>  	}
>  
> +	if (steal_account_process_tick())
> +		return;
> +
>  	if (user_tick)
>  		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
>  	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))

