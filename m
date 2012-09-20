Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2ITRfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:35:41 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40711 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2ITRfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:35:39 -0400
Date: Thu, 20 Sep 2012 10:34:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v2 PATCH 04/21] x86: Avoid RCU warnings on slave CPUs
Message-ID: <20120920173419.GH2449@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120906112718.13320.8231.stgit@kvmdev>
 <20120906112739.13320.53090.stgit@kvmdev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906112739.13320.53090.stgit@kvmdev>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092017-5406-0000-0000-00000074C2CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 08:27:40PM +0900, Tomoki Sekiyama wrote:
> Initialize rcu related variables to avoid warnings about RCU usage while
> slave CPUs is running specified functions. Also notify RCU subsystem before
> the slave CPU is entered into idle state.

Hello, Tomoki,

A few questions and comments interspersed below.

							Thanx, Paul

> Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
> 
>  arch/x86/kernel/smpboot.c |    4 ++++
>  kernel/rcutree.c          |   14 ++++++++++++++
>  2 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index e8cfe377..45dfc1d 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -382,6 +382,8 @@ notrace static void __cpuinit start_slave_cpu(void *unused)
>  		f = per_cpu(slave_cpu_func, cpu);
>  		per_cpu(slave_cpu_func, cpu).func = NULL;
> 
> +		rcu_note_context_switch(cpu);
> +

Why not use rcu_idle_enter() and rcu_idle_exit()?  These would tell
RCU to ignore the slave CPU for the duration of its idle period.
The way you have it, if a slave CPU stayed idle for too long, you
would get RCU CPU stall warnings, and possibly system hangs as well.

Or is this being called from some task that is not the idle task?
If so, you instead want the new rcu_user_enter() and rcu_user_exit()
that are hopefully on their way into 3.7.  Or maybe better, use a real
idle task, so that idle_task(smp_processor_id()) returns true and RCU
stops complaining.  ;-)

Note that CPUs that RCU believes to be idle are not permitted to contain
RCU read-side critical sections, which in turn means no entering the
scheduler, no sleeping, and so on.  There is an RCU_NONIDLE() macro
to tell RCU to pay attention to the CPU only for the duration of the
statement passed to RCU_NONIDLE, and there are also an _rcuidle variant
of the tracing statement to allow tracing from idle.

>  		if (!f.func) {
>  			native_safe_halt();
>  			continue;
> @@ -1005,6 +1007,8 @@ int __cpuinit slave_cpu_up(unsigned int cpu)
>  	if (IS_ERR(idle))
>  		return PTR_ERR(idle);
> 
> +	slave_cpu_notify(CPU_SLAVE_UP_PREPARE, cpu);
> +
>  	ret = __native_cpu_up(cpu, idle, 1);
> 
>  	cpu_maps_update_done();
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index f280e54..31a7c8c 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -2589,6 +2589,9 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
>  	switch (action) {
>  	case CPU_UP_PREPARE:
>  	case CPU_UP_PREPARE_FROZEN:
> +#ifdef CONFIG_SLAVE_CPU
> +	case CPU_SLAVE_UP_PREPARE:
> +#endif

Why do you need #ifdef here?  Why not define CPU_SLAVE_UP_PREPARE
unconditionally?  Then if CONFIG_SLAVE_CPU=n, rcu_cpu_notify() would
never be invoked with CPU_SLAVE_UP_PREPARE, so no problems.

>  		rcu_prepare_cpu(cpu);
>  		rcu_prepare_kthreads(cpu);
>  		break;
> @@ -2603,6 +2606,9 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
>  		break;
>  	case CPU_DYING:
>  	case CPU_DYING_FROZEN:
> +#ifdef CONFIG_SLAVE_CPU
> +	case CPU_SLAVE_DYING:
> +#endif

Same here.

>  		/*
>  		 * The whole machine is "stopped" except this CPU, so we can
>  		 * touch any data without introducing corruption. We send the
> @@ -2616,6 +2622,9 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
>  	case CPU_DEAD_FROZEN:
>  	case CPU_UP_CANCELED:
>  	case CPU_UP_CANCELED_FROZEN:
> +#ifdef CONFIG_SLAVE_CPU
> +	case CPU_SLAVE_DEAD:
> +#endif

And here.

>  		for_each_rcu_flavor(rsp)
>  			rcu_cleanup_dead_cpu(cpu, rsp);
>  		break;
> @@ -2797,6 +2806,10 @@ static void __init rcu_init_geometry(void)
>  	rcu_num_nodes -= n;
>  }
> 
> +static struct notifier_block __cpuinitdata rcu_slave_nb = {
> +	.notifier_call = rcu_cpu_notify,
> +};
> +
>  void __init rcu_init(void)
>  {
>  	int cpu;
> @@ -2814,6 +2827,7 @@ void __init rcu_init(void)
>  	 * or the scheduler are operational.
>  	 */
>  	cpu_notifier(rcu_cpu_notify, 0);
> +	register_slave_cpu_notifier(&rcu_slave_nb);
>  	for_each_online_cpu(cpu)
>  		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
>  	check_cpu_stall_init();
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

