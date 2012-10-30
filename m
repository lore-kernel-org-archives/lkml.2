Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148Ab2J3Rdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:33:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26550 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965086Ab2J3Rda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:33:30 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=CA4-hnql-eEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=opcKsn9pyUEA:10 a=EZLMGzQlz8Gwk4z_waEA:9 a=PUjeQqilurYA:10 a=38c3c6iKqE23mSbT:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351618408.8467.132.camel@gandalf.local.home>
Subject: Re: [PATCH 03/32] nohz: Try not to give the timekeeping duty to an
 adaptive tickless cpu
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Date: Tue, 30 Oct 2012 13:33:28 -0400
In-Reply-To: <20121029203847.098399427@goodmis.org>
References: <20121029202711.062749374@goodmis.org>
	 <20121029203847.098399427@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 16:27 -0400, Steven Rostedt wrote:

>  kernel/time/tick-sched.c |   52 ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 41 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index d6d16fe..c7a78c6 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -20,6 +20,7 @@
>  #include <linux/profile.h>
>  #include <linux/sched.h>
>  #include <linux/module.h>
> +#include <linux/cpuset.h>
>  
>  #include <asm/irq_regs.h>
>  
> @@ -789,6 +790,45 @@ void tick_check_idle(int cpu)
>  	tick_check_nohz(cpu);
>  }
>  
> +#ifdef CONFIG_CPUSETS_NO_HZ
> +
> +/*
> + * Take the timer duty if nobody is taking care of it.
> + * If a CPU already does and and it's in a nohz cpuset,

and and

> + * then take the charge so that it can switch to nohz mode.
> + */
> +static void tick_do_timer_check_handler(int cpu)
> +{
> +	int handler = tick_do_timer_cpu;
> +
> +	if (unlikely(handler == TICK_DO_TIMER_NONE)) {
> +		tick_do_timer_cpu = cpu;

I take it that this is the forced (no one has it, so I'll take it?)

Perhaps we should do a:

	WARN_ON(cpuset_cpu_adaptive_nohz(cpu));


> +	} else {
> +		if (!cpuset_adaptive_nohz() &&
> +		    cpuset_cpu_adaptive_nohz(handler))
> +			tick_do_timer_cpu = cpu;

Shouldn't this be
		if (!cpuset_cpu_adaptive_nohz(cpu) && ...

Otherwise, we should have it go to smp_processor_id()?


OK, looking further down, the only caller of it passes
smp_processor_id() to the function. But we still shouldn't assume this.
Either, have the function use smp_processor_id() explicitly, or let it
use any cpu. Otherwise it just confuses people, and is prone to be buggy
if in the future something calls it with a cpu that's not the local cpu.

-- Steve

> +	}
> +}
> +
> +#else
> +
> +static void tick_do_timer_check_handler(int cpu)
> +{
> +#ifdef CONFIG_NO_HZ
> +	/*
> +	 * Check if the do_timer duty was dropped. We don't care about
> +	 * concurrency: This happens only when the cpu in charge went
> +	 * into a long sleep. If two cpus happen to assign themself to
> +	 * this duty, then the jiffies update is still serialized by
> +	 * xtime_lock.
> +	 */
> +	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
> +		tick_do_timer_cpu = cpu;
> +#endif
> +}
> +
> +#endif /* CONFIG_CPUSETS_NO_HZ */
> +
>  /*
>   * High resolution timer specific code
>   */
> @@ -805,17 +845,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
>  	ktime_t now = ktime_get();
>  	int cpu = smp_processor_id();
>  
> -#ifdef CONFIG_NO_HZ
> -	/*
> -	 * Check if the do_timer duty was dropped. We don't care about
> -	 * concurrency: This happens only when the cpu in charge went
> -	 * into a long sleep. If two cpus happen to assign themself to
> -	 * this duty, then the jiffies update is still serialized by
> -	 * xtime_lock.
> -	 */
> -	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
> -		tick_do_timer_cpu = cpu;
> -#endif
> +	tick_do_timer_check_handler(cpu);
>  
>  	/* Check, if the jiffies need an update */
>  	if (tick_do_timer_cpu == cpu)


