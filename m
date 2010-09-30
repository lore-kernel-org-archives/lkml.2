Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab0I3Mgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:36:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45423 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0I3Mge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:36:34 -0400
Subject: Re: high power consumption in recent kernels
From: Peter Zijlstra <peterz@infradead.org>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: Norbert Preining <preining@logic.at>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>, "Li, Shaohua" <shaohua.li@intel.com>,
        tglx <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>
In-Reply-To: <1285835230.21962.1290.camel@debian>
References: <EA929A9653AAE14F841771FB1DE5A1366008738EC2@rrsmsx501.amr.corp.intel.com>
	 <20100909205115.GD11053@gamma.logic.tuwien.ac.at>
	 <1284107099.402.30.camel@laptop>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B2991AF14FD@shsmsx502.ccr.corp.intel.com>
	 <20100910145451.GB21450@gamma.logic.tuwien.ac.at>
	 <1284355277.26157.8109.camel@debian>
	 <20100922154452.GA9080@gamma.logic.tuwien.ac.at>
	 <1285670426.21962.43.camel@debian> <4CA34F95.30400@logic.at>
	 <1285807841.21962.1147.camel@debian>
	 <20100930065902.GC15882@gamma.logic.tuwien.ac.at>
	 <1285835230.21962.1290.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Sep 2010 14:36:25 +0200
Message-ID: <1285850185.2144.49.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-30 at 16:27 +0800, Alex,Shi wrote:
> Thanks Norbert! 
> Mike&Peter:
> would you like to add signed-off for the following patch?

I would really rather see the nohz decision move into the whole cpuidle
governor thing, which can make a much better cost vs benefit decision.

Thomas, Arjan?

> ---
>     sched: nohz_ratelimit function refresh
>     
>     The nohz_ratelimit() function that written by Mike Galbraith
>     can bring about more than 10% throughput for netperf TCP/UDP RR
>     when scheduling cross-cpu. It did this by reducing down to nohz
>     mode chance.
>     But the patch also reduce CPU chance to nohz mode after
>     interrupt processed, that cause Norbert's system have 4 watts power
>     increase(the system have about 100 int/sec and with a light load).
>     That is not acceptable for a laptop.
>     
>     So, I remove the nohz_ratelimit from irq_exit(). and then the
>     Norbert's system back to low power consumption.
>     
>     Tested-by: Norbert Preining <preining@logic.at>
>     Signed-off-by: Alex Shi <alex.shi@intel.com>
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 1e2a6db..a4dbb37 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -274,8 +274,13 @@ extern cpumask_var_t nohz_cpu_mask;
>  #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
>  extern void select_nohz_load_balancer(int stop_tick);
>  extern int get_nohz_timer_target(void);
> +extern int nohz_ratelimit(int cpu);
>  #else
>  static inline void select_nohz_load_balancer(int stop_tick) { }
> +static inline int nohz_ratelimit(int cpu)
> +{
> +	return 0;
> +}
>  #endif
>  
>  /*
> diff --git a/kernel/sched.c b/kernel/sched.c
> index dc85ceb..132a21c 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1182,6 +1182,16 @@ static void resched_task(struct task_struct *p)
>  		smp_send_reschedule(cpu);
>  }
>  
> +int nohz_ratelimit(int cpu)
> +{
> +	struct rq *rq = cpu_rq(cpu);
> +	u64 diff = rq->clock - rq->nohz_stamp;
> +
> +	rq->nohz_stamp = rq->clock;
> +
> +	return diff < (NSEC_PER_SEC / HZ) >> 1;
> +}
> +
>  static void resched_cpu(int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 3e216e0..19a7914 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -325,7 +325,7 @@ void tick_nohz_stop_sched_tick(int inidle)
>  	} while (read_seqretry(&xtime_lock, seq));
>  
>  	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
> -	    arch_needs_cpu(cpu)) {
> +		arch_needs_cpu(cpu) || (inidle && nohz_ratelimit(cpu))) {
>  		next_jiffies = last_jiffies + 1;
>  		delta_jiffies = 1;
>  	} else {
> 
> 


