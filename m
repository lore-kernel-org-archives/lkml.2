Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0LDOI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 09:08:27 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44482 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab0LDOI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 09:08:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=M6drs6Wvw6Xd6xEdd/aKKT6VVtBG2AOhJp1MOvBcXv2Icr0WE8UQ++tMHNUUp1v2/w
         gOqxq/jJxfqownjxC8GJT1Qd5W5/f69WLow7nDAb2m1bz4OYEarhZOiYl0K7JmndKkQH
         NYc7Pl37AglfjlZgmQHZV+0KTqXjC/YMA91v8=
Date: Sat, 4 Dec 2010 22:08:16 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Bjoern B. Brandenburg" <bbb.lst@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andrea Bastoni <bastoni@sprg.uniroma2.it>,
        "James H. Anderson" <anderson@cs.unc.edu>,
        linux-kernel@vger.kernel.org
Subject: Re: Scheduler bug related to rq->skip_clock_update?
Message-ID: <20101204140816.GC2295@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu>
 <1290359641.4816.69.camel@maggy.simson.net>
 <alpine.LNX.2.00.1011212327250.8927@jupiter-cs.cs.unc.edu>
 <1290442781.16393.22.camel@maggy.simson.net>
 <alpine.LNX.2.00.1011221310430.8927@jupiter-cs.cs.unc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1011221310430.8927@jupiter-cs.cs.unc.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 01:14:47PM -0500, Bjoern B. Brandenburg wrote:
> On Mon, 22 Nov 2010, Mike Galbraith wrote:
> 
> > On Sun, 2010-11-21 at 23:29 -0500, Bjoern B. Brandenburg wrote:
> > > On Sun, 21 Nov 2010, Mike Galbraith wrote:
> > >
> > > > On Sat, 2010-11-20 at 23:22 -0500, Bjoern B. Brandenburg wrote:
> > > >
> > > > > I was under the impression that, as an invariant, tasks should not have
> > > > > TIF_NEED_RESCHED set after they've blocked. In this case, the idle load
> > > > > balancer should not mark the task that's on its way out with
> > > > > set_tsk_need_resched().
> > > >
> > > > Nice find.
> > > >
> > > > > In any case, check_preempt_curr() seems to assume that a resuming task cannot
> > > > > have TIF_NEED_RESCHED already set. Setting skip_clock_update on a remote CPU
> > > > > that hasn't even been notified via IPI seems wrong.
> > > >
> > > > Yes. Does the below fix it up for you?
> > >
> > > The patch definitely changes the behavior, but it doesn't seem to solve (all
> > > of) the root cause(s). The failsafe kicks in and clears the flag the next
> > > time that update_rq_clock() is called, but there can still be a significant
> > > delay between setting and clearing the flag. Right after boot, I'm now seeing
> > > values that go up to ~21ms.
> >
> > A pull isn't the only vulnerability.  Since idle_balance() drops
> > rq->lock, so another cpu can wake to this rq.
> >
> > > Please let me know if there is something else that I should test.
> >
> > Sched: clear_tsk_need_resched() after NEWIDLE balancing
> >
> > idle_balance() drops/retakes rq->lock, leaving the previous task
> > vulnerable to set_tsk_need_resched() from another CPU.  Clear it
> > after NEWIDLE balancing to maintain the invariant that descheduled
> > tasks are NOT marked for resched.
> >
> > This also confuses the skip_clock_update logic, which assumes that
> > the next call to update_rq_clock() will come nearly ĩmmediately after
> > being set.  Make the optimization more robust by clearing before we
> > balance and in update_rq_clock().
> 
> Unfortunately that doesn't seem to do it yet.
> 
> After running five 'find /' instances to completion on the ARM platform,
> I'm still seeing delays close to 10ms.

Because skip_clock_recent_max/skip_clock_max is based on nanosecond,
so the delay should be 10us, right?

> 
>     bbb@district10:~$ egrep 'cpu#|skip' /proc/sched_debug
>     cpu#0
>       .skip_clock_count              : 89606
>       .skip_clock_recent_max         : 9817250
>       .skip_clock_max                : 21992375
>     cpu#1
>       .skip_clock_count              : 81978
>       .skip_clock_recent_max         : 9582500
>       .skip_clock_max                : 17201750
>     cpu#2
>       .skip_clock_count              : 74565
>       .skip_clock_recent_max         : 9678000
>       .skip_clock_max                : 9879250
>     cpu#3
>       .skip_clock_count              : 81685
>       .skip_clock_recent_max         : 9300125
>       .skip_clock_max                : 14115750
> 
> On the x86_64 host, I've changed to HZ=100 and am now also seeing delays
> close to 10ms after 'make clean && make -j8 bzImage'.

ditto.

> 
>     bbb@koruna:~$ egrep 'cpu#|skip' /proc/sched_debug
>     cpu#0, 2493.476 MHz
>       .skip_clock_count              : 29703
>       .skip_clock_recent_max         : 9999858
>       .skip_clock_max                : 40645942
>     cpu#1, 2493.476 MHz
>       .skip_clock_count              : 32696
>       .skip_clock_recent_max         : 9959118
>       .skip_clock_max                : 35074771
>     cpu#2, 2493.476 MHz
>       .skip_clock_count              : 31742
>       .skip_clock_recent_max         : 9788654
>       .skip_clock_max                : 24821765
>     cpu#3, 2493.476 MHz
>       .skip_clock_count              : 31123
>       .skip_clock_recent_max         : 9858546
>       .skip_clock_max                : 44276033
>     cpu#4, 2493.476 MHz
>       .skip_clock_count              : 28346
>       .skip_clock_recent_max         : 10000775
>       .skip_clock_max                : 18681753
>     cpu#5, 2493.476 MHz
>       .skip_clock_count              : 29421
>       .skip_clock_recent_max         : 9997656
>       .skip_clock_max                : 138473407
>     cpu#6, 2493.476 MHz
>       .skip_clock_count              : 27721
>       .skip_clock_recent_max         : 9992074
>       .skip_clock_max                : 53436918
>     cpu#7, 2493.476 MHz
>       .skip_clock_count              : 29637
>       .skip_clock_recent_max         : 9994516
>       .skip_clock_max                : 566793528
> 
> These numbers were recorded with the below patch.
> 
> Please let me know if I can help by testing or tracing something else.
> 
> Thanks,
> Bjoern
> 
> ---
> sched: show length of runqueue clock deactivation in /proc/sched_debug
> 
> The runqueue clock update should obviously not be skipped for
> prolonged times (otherwise the consumed time is not correctly kept
> track of). This patch measures the time between setting and clearing
> the rq->skip_clock_update flag. The maximum observed value is exported
> in /proc/sched_debug.
> ---
>  kernel/sched.c       |   30 +++++++++++++++++++++++++++---
>  kernel/sched_debug.c |    4 ++++
>  2 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 29509e1..08839ce 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -541,6 +541,11 @@ struct rq {
>  	unsigned long long rq_cpu_time;
>  	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */
> 
> +	u64 skip_clock_max;
> +	u64 skip_clock_recent_max;
> +	u64 skip_clock_set;
> +	unsigned int skip_clock_count;
> +
>  	/* sys_sched_yield() stats */
>  	unsigned int yld_count;
> 
> @@ -639,6 +644,22 @@ static inline struct task_group *task_group(struct task_struct *p)
>  static u64 irq_time_cpu(int cpu);
>  static void sched_irq_time_avg_update(struct rq *rq, u64 irq_time);
> 
> +static void clear_skip_clock_update(struct rq *rq)
> +{
> +#ifdef CONFIG_SCHEDSTATS
> +	if (unlikely(rq->skip_clock_update)) {
> +		u64 skipped = sched_clock_cpu(cpu_of(rq)) - rq->skip_clock_set;
> +		rq->skip_clock_max = max(rq->skip_clock_max, skipped);
> +		/* reset infrequently to expose changes */
> +		if (!(++rq->skip_clock_count % 10000))
> +			rq->skip_clock_recent_max = 0;
> +		rq->skip_clock_recent_max = max(rq->skip_clock_recent_max,
> +						skipped);
> +	}
> +#endif
> +	rq->skip_clock_update = 0;
> +}
> +
>  inline void update_rq_clock(struct rq *rq)
>  {
>  	if (!rq->skip_clock_update) {
> @@ -652,7 +673,7 @@ inline void update_rq_clock(struct rq *rq)
> 
>  		sched_irq_time_avg_update(rq, irq_time);
>  	}
> -	rq->skip_clock_update = 0;
> +	clear_skip_clock_update(rq);
>  }
> 
>  /*
> @@ -2130,8 +2151,11 @@ static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
>  	 * A queue event has occurred, and we're going to schedule.  In
>  	 * this case, we can save a useless back to back clock update.
>  	 */
> -	if (test_tsk_need_resched(rq->curr))
> +	if (test_tsk_need_resched(rq->curr)) {
> +		schedstat_set(rq->skip_clock_set,
> +			      sched_clock_cpu(cpu_of(rq)));
>  		rq->skip_clock_update = 1;
> +	}
>  }
> 
>  #ifdef CONFIG_SMP
> @@ -3938,7 +3962,7 @@ need_resched_nonpreemptible:
>  		 * Clock updates should not be skipped while we're away.
>  		 */
>  		clear_tsk_need_resched(prev);
> -		rq->skip_clock_update = 0;
> +		clear_skip_clock_update(rq);
>  	}
> 
>  	put_prev_task(rq, prev);
> diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
> index 2e1b0d1..8924be2 100644
> --- a/kernel/sched_debug.c
> +++ b/kernel/sched_debug.c
> @@ -298,6 +298,10 @@ static void print_cpu(struct seq_file *m, int cpu)
> 
>  	P(bkl_count);
> 
> +	P(skip_clock_count);
> +	P64(skip_clock_recent_max);
> +	P64(skip_clock_max);
> +
>  #undef P
>  #endif
>  	print_cfs_stats(m, cpu);
> -- 
> 1.7.3.1

