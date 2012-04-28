Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab2D1WwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 18:52:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:41953 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab2D1WwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 18:52:17 -0400
Message-ID: <1335653506.20866.16.camel@pasglop>
Subject: Re: [tip:smp/hotplug] powerpc: Use generic idle thread allocation
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Date: Sun, 29 Apr 2012 08:51:46 +1000
In-Reply-To: <tip-17e32eacc3543c25a4377bb7ce54026e38db7d20@git.kernel.org>
References: <20120420124557.311212868@linutronix.de>
	 <tip-17e32eacc3543c25a4377bb7ce54026e38db7d20@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-28 at 02:07 -0700, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  17e32eacc3543c25a4377bb7ce54026e38db7d20
> Gitweb:     http://git.kernel.org/tip/17e32eacc3543c25a4377bb7ce54026e38db7d20
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Fri, 20 Apr 2012 13:05:48 +0000
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Thu, 26 Apr 2012 12:06:10 +0200
> 
> powerpc: Use generic idle thread allocation

Ah good, sorry I missed the previous batch. This is the logical
next step after I changed us to do the same as x86 :)

I'll give it a spin tomorrow (monday my time).

Cheers,
Ben.

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Link: http://lkml.kernel.org/r/20120420124557.311212868@linutronix.de
> ---
>  arch/powerpc/Kconfig      |    1 +
>  arch/powerpc/kernel/smp.c |   74 +++-----------------------------------------
>  2 files changed, 6 insertions(+), 69 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index feab3ba..c815535 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -144,6 +144,7 @@ config PPC
>  	select HAVE_BPF_JIT if (PPC64 && NET)
>  	select HAVE_ARCH_JUMP_LABEL
>  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
> +	select GENERIC_SMP_IDLE_THREAD
>  
>  config EARLY_PRINTK
>  	bool
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index d38030f..e4cb343 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -57,27 +57,9 @@
>  #define DBG(fmt...)
>  #endif
>  
> -
> -/* Store all idle threads, this can be reused instead of creating
> -* a new thread. Also avoids complicated thread destroy functionality
> -* for idle threads.
> -*/
>  #ifdef CONFIG_HOTPLUG_CPU
> -/*
> - * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
> - * removed after init for !CONFIG_HOTPLUG_CPU.
> - */
> -static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
> -#define get_idle_for_cpu(x)      (per_cpu(idle_thread_array, x))
> -#define set_idle_for_cpu(x, p)   (per_cpu(idle_thread_array, x) = (p))
> -
>  /* State of each CPU during hotplug phases */
>  static DEFINE_PER_CPU(int, cpu_state) = { 0 };
> -
> -#else
> -static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
> -#define get_idle_for_cpu(x)      (idle_thread_array[(x)])
> -#define set_idle_for_cpu(x, p)   (idle_thread_array[(x)] = (p))
>  #endif
>  
>  struct thread_info *secondary_ti;
> @@ -429,57 +411,16 @@ int generic_check_cpu_restart(unsigned int cpu)
>  }
>  #endif
>  
> -struct create_idle {
> -	struct work_struct work;
> -	struct task_struct *idle;
> -	struct completion done;
> -	int cpu;
> -};
> -
> -static void __cpuinit do_fork_idle(struct work_struct *work)
> +static void cpu_idle_thread_init(unsigned int cpu, struct task_struct *idle)
>  {
> -	struct create_idle *c_idle =
> -		container_of(work, struct create_idle, work);
> -
> -	c_idle->idle = fork_idle(c_idle->cpu);
> -	complete(&c_idle->done);
> -}
> -
> -static int __cpuinit create_idle(unsigned int cpu)
> -{
> -	struct thread_info *ti;
> -	struct create_idle c_idle = {
> -		.cpu	= cpu,
> -		.done	= COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
> -	};
> -	INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
> -
> -	c_idle.idle = get_idle_for_cpu(cpu);
> -
> -	/* We can't use kernel_thread since we must avoid to
> -	 * reschedule the child. We use a workqueue because
> -	 * we want to fork from a kernel thread, not whatever
> -	 * userspace process happens to be trying to online us.
> -	 */
> -	if (!c_idle.idle) {
> -		schedule_work(&c_idle.work);
> -		wait_for_completion(&c_idle.done);
> -	} else
> -		init_idle(c_idle.idle, cpu);
> -	if (IS_ERR(c_idle.idle)) {		
> -		pr_err("Failed fork for CPU %u: %li", cpu, PTR_ERR(c_idle.idle));
> -		return PTR_ERR(c_idle.idle);
> -	}
> -	ti = task_thread_info(c_idle.idle);
> +	struct thread_info *ti = task_thread_info(idle);
>  
>  #ifdef CONFIG_PPC64
> -	paca[cpu].__current = c_idle.idle;
> +	paca[cpu].__current = idle;
>  	paca[cpu].kstack = (unsigned long)ti + THREAD_SIZE - STACK_FRAME_OVERHEAD;
>  #endif
>  	ti->cpu = cpu;
> -	current_set[cpu] = ti;
> -
> -	return 0;
> +	secondary_ti = current_set[cpu] = ti;
>  }
>  
>  int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
> @@ -490,12 +431,7 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
>  	    (smp_ops->cpu_bootable && !smp_ops->cpu_bootable(cpu)))
>  		return -EINVAL;
>  
> -	/* Make sure we have an idle thread */
> -	rc = create_idle(cpu);
> -	if (rc)
> -		return rc;
> -
> -	secondary_ti = current_set[cpu];
> +	cpu_idle_thread_init(cpu, tidle);
>  
>  	/* Make sure callin-map entry is 0 (can be leftover a CPU
>  	 * hotplug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


