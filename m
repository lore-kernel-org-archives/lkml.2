Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab0JUOpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:45:20 -0400
Received: from canuck.infradead.org ([134.117.69.58]:50158 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0JUOpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:45:14 -0400
Subject: Re: [PATCH 4/6] Export ns irqtimes from IRQ_TIME_ACCOUNTING
 through /proc/stat
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <1287614941-32325-5-git-send-email-venki@google.com>
References: <1287614941-32325-1-git-send-email-venki@google.com>
	 <1287614941-32325-5-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Oct 2010 16:44:31 +0200
Message-ID: <1287672271.3488.139.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 15:49 -0700, Venkatesh Pallipadi wrote:

> +static int irqtime_account_hi_update(void)
> +{
> +	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
> +	unsigned long flags;
> +	u64 latest_ns;
> +	int ret = 0;
> +
> +	local_irq_save(flags);
> +	latest_ns = __get_cpu_var(cpu_hardirq_time);

I guess this_cpu_read() would again be an improvement.. same for the SI
version.

> +	if (cputime64_gt(nsecs_to_cputime64(latest_ns), cpustat->irq))
> +		ret = 1;
> +	local_irq_restore(flags);
> +	return ret;
> +}

> +#ifdef CONFIG_IRQ_TIME_ACCOUNTING
> +/*
> + * Account a tick to a process and cpustat
> + * @p: the process that the cpu time gets accounted to
> + * @user_tick: is the tick from userspace
> + * @rq: the pointer to rq
> + *
> + * Tick demultiplexing follows the order
> + * - pending hardirq update
> + * - user_time
> + * - pending softirq update
> + * - idle_time
> + * - system time
> + *   - check for guest_time
> + *   - else account as system_time
> + *
> + * Check for hardirq is done both for system and user time as there is
> + * no timer going off while we are on hardirq and hence we may never get an
> + * oppurtunity to update it solely in system time.

My mailer suggests you spell that as: opportunity :-)

> + * p->stime and friends are only updated on system time and not on irq
> + * softirq as those do not count in task exec_runtime any more.
> + */
> +static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
> +						struct rq *rq)
> +{
> +	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
> +	cputime64_t tmp = cputime_to_cputime64(cputime_one_jiffy);
> +	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
> +
> +	if (irqtime_account_hi_update()) {
> +		cpustat->irq = cputime64_add(cpustat->irq, tmp);
> +	} else if (user_tick) {
> +		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
> +	} else if (irqtime_account_si_update()) {
> +		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
> +	} else if (p == rq->idle) {
> +		account_idle_time(cputime_one_jiffy);
> +	} else if (p->flags & PF_VCPU) { /* System time or guest time */
> +		account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
> +	} else {
> +		__account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
> +					&cpustat->system);
> +	}
> +}

I'd do:

  - hardirq
  - softirq
  - user
  - system
     - guest
     - really system
  - idle

Since otherwise tiny slices of softirq would need to wait for a system
tick to happen before you fold them.

Also, it is possible that in a single tick multiple counters overflow
the jiffy boundary, so something like:

  if (irqtime_account_hi_update())
	cpustat->irq = ...

  if (irqtime_account_si_update())
	cpustate->softirq = ...

  if (user_tick) {
  } else if (...) {

  } else ...

would seem like the better approach.

>  /*
>   * Account for involuntary wait time.
>   * @steal: the cpu time spent in involuntary wait
> @@ -3594,6 +3685,11 @@ void account_process_tick(struct task_struct *p, int user_tick)
>  	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
>  	struct rq *rq = this_rq();
>  
> +	if (sched_clock_irqtime) {
> +		irqtime_account_process_tick(p, user_tick, rq);
> +		return;
> +	}
> +
>  	if (user_tick)
>  		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
>  	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))

mark_tsc_unstable() can disable sched_clock_irqtime at any time, the
accounting won't go funny due to that right?
