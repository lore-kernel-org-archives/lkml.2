Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019Ab2J3RQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:16:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20743 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933788Ab2J3RQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:16:16 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0tQZt0S44S8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=F1WC6xGaTykA:10 a=8ytGH_i8geNbr58q-J8A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351617374.8467.125.camel@gandalf.local.home>
Subject: Re: [PATCH 02/32] cpuset: Set up interface for nohz flag
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
Date: Tue, 30 Oct 2012 13:16:14 -0400
In-Reply-To: <20121029203846.951402615@goodmis.org>
References: <20121029202711.062749374@goodmis.org>
	 <20121029203846.951402615@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 16:27 -0400, Steven Rostedt wrote:

>  #ifdef CONFIG_CPUSETS
>  
> @@ -235,4 +236,34 @@ static inline bool put_mems_allowed(unsigned int seq)
>  
>  #endif /* !CONFIG_CPUSETS */
>  
> +#ifdef CONFIG_CPUSETS_NO_HZ
> +
> +DECLARE_PER_CPU(atomic_t, cpu_adaptive_nohz_ref);
> +
> +static inline bool cpuset_cpu_adaptive_nohz(int cpu)
> +{
> +	atomic_t *ref = &per_cpu(cpu_adaptive_nohz_ref, cpu);
> +
> +	if (atomic_add_return(0, ref) > 0)

I'm assuming you do the atomic_add_return() for the implicit memory
barrier? Yuck!

Please comment this. I see that rcutree.c does the same thing without a
comment. Bad Paul, bad!


> +		return true;
> +
> +	return false;
> +}
> +
> +static inline bool cpuset_adaptive_nohz(void)
> +{
> +	/*
> +	 * We probably want to do atomic_read() when we read
> +	 * locally to avoid the overhead of an ordered add.
> +	 * For that we have to do the dec of the ref locally as
> +	 * well.

Does it matter if we miss the dec? What other synchronization is used?

	CPU 1					CPU 2
	------					-----
	var = atomic_add_return(0, ref)
						atomic_dec(ref);
	if (var > 0)

returns true.

For local cases, as this seems to be in a fast path, we should use
this_cpu_read() as well.

	
> +	 */
> +	return cpuset_cpu_adaptive_nohz(smp_processor_id());
> +}
> +#else
> +static inline bool cpuset_cpu_adaptive_nohz(int cpu) { return false; }
> +static inline bool cpuset_adaptive_nohz(void) { return false; }
> +
> +#endif /* CONFIG_CPUSETS_NO_HZ */
> +
>  #endif /* _LINUX_CPUSET_H */
> diff --git a/init/Kconfig b/init/Kconfig
> index 6fdd6e3..ffdeeab 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -749,6 +749,14 @@ config PROC_PID_CPUSET
>  	depends on CPUSETS
>  	default y
>  
> +config CPUSETS_NO_HZ
> +       bool "Tickless cpusets"
> +       depends on CPUSETS && HAVE_CPUSETS_NO_HZ
> +       help
> +         This options let you apply a nohz property to a cpuset such
> +	 that the periodic timer tick tries to be avoided when possible on
> +	 the concerned CPUs.
> +
>  config CGROUP_CPUACCT
>  	bool "Simple CPU accounting cgroup subsystem"
>  	help
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index f33c715..6319d8e 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -145,6 +145,7 @@ typedef enum {
>  	CS_SCHED_LOAD_BALANCE,
>  	CS_SPREAD_PAGE,
>  	CS_SPREAD_SLAB,
> +	CS_ADAPTIVE_NOHZ,
>  } cpuset_flagbits_t;
>  
>  /* the type of hotplug event */
> @@ -189,6 +190,11 @@ static inline int is_spread_slab(const struct cpuset *cs)
>  	return test_bit(CS_SPREAD_SLAB, &cs->flags);
>  }
>  
> +static inline int is_adaptive_nohz(const struct cpuset *cs)
> +{
> +	return test_bit(CS_ADAPTIVE_NOHZ, &cs->flags);
> +}

We can move this into the #ifdef CONFIG_CPUSETS_NO_HZ as well, and have
the #else version just return zero. Why use test_bit() when we already
know the answer?

> +
>  static struct cpuset top_cpuset = {
>  	.flags = ((1 << CS_CPU_EXCLUSIVE) | (1 << CS_MEM_EXCLUSIVE)),
>  };
> @@ -1190,6 +1196,32 @@ static void cpuset_change_flag(struct task_struct *tsk,
>  	cpuset_update_task_spread_flag(cgroup_cs(scan->cg), tsk);
>  }
>  
> +#ifdef CONFIG_CPUSETS_NO_HZ
> +
> +DEFINE_PER_CPU(atomic_t, cpu_adaptive_nohz_ref);
> +
> +static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
> +{
> +	int cpu;
> +	int val;
> +
> +	if (is_adaptive_nohz(old_cs) == is_adaptive_nohz(cs))
> +		return;
> +
> +	for_each_cpu(cpu, cs->cpus_allowed) {
> +		atomic_t *ref = &per_cpu(cpu_adaptive_nohz_ref, cpu);
> +		if (is_adaptive_nohz(cs))
> +			atomic_inc(ref);
> +		else
> +			atomic_dec(ref);
> +	}
> +}
> +#else
> +static inline void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
> +{
> +}
> +#endif
> +

-- Steve


