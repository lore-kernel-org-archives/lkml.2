Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab2FCIvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 04:51:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57675 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab2FCIv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 04:51:29 -0400
Date: Sun, 3 Jun 2012 16:51:07 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Richard Kuo <rkuo@codeaurora.org>, David Howells <dhowells@redhat.com>,
        Bob Liu <lliubbo@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Richard Weinberger <richard@nod.at>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Matt Turner <mattst88@gmail.com>, nikunj@linux.vnet.ibm.com
Subject: Re: [PATCH 01/27] smpboot: Provide a generic method to boot
 secondary processors
Message-ID: <20120603085107.GD16829@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
 <20120601091008.31979.93586.stgit@srivatsabhat.in.ibm.com>
 <4FC8B0F7.3060705@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FC8B0F7.3060705@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 05:39:27PM +0530, Srivatsa S. Bhat wrote:
> +/* Implement the following functions in your architecture, as appropriate. */
> +
> +/**
> + * __cpu_pre_starting()
> + *
> + * Implement whatever you need to do before the CPU_STARTING notifiers are
> + * invoked. Note that the CPU_STARTING callbacks run *on* the cpu that is
> + * coming up. So that cpu better be prepared! IOW, implement all the early
> + * boot/init code for the cpu here. And do NOT enable interrupts.
> + */
> +#ifndef __cpu_pre_starting

Why the ifndef?

Thanks,
Yong

> +void __weak __cpu_pre_starting(void *arg) {}
> +#endif
> +
> +/**
> + *  __cpu_pre_online()
> + *
> + * Implement whatever you need to do before the upcoming CPU is set in the
> + * cpu_online_mask. (Setting the cpu in the cpu_online_mask is like an
> + * announcement that the cpu has come up, because it would be publicly
> + * visible now). Again, don't enable interrupts.
> + */
> +#ifndef __cpu_pre_online
> +void __weak __cpu_pre_online(void *arg) {}
> +#endif
> +
> +/**
> + * __cpu_post_online()
> + *
> + * Implement whatever you need to do after the CPU has been set in the
> + * cpu_online_mask, and before enabling interrupts and calling cpu_idle().
> + * Ideally, it is preferable if you don't have anything to do here.
> + * We want to move to a model where setting cpu_online_mask is pretty
> + * much the final step. Again, don't enable interrupts.
> + */
> +#ifndef __cpu_post_online
> +void __weak __cpu_post_online(void *arg) {}
> +#endif
> +
> +
> +/**
> + * smpboot_start_secondary - Generic way to boot secondary processors
> + */
> +void __cpuinit smpboot_start_secondary(void *arg)
> +{
> +	unsigned int cpu;
> +
> +	/*
> +	 * SMP booting is extremely fragile in some architectures. So run
> +	 * the cpu initialization code first before anything else.
> +	 */
> +	__cpu_pre_starting(arg);
> +
> +	preempt_disable();
> +	cpu = smp_processor_id();
> +
> +	/* Invoke the CPU_STARTING notifier callbacks */
> +	notify_cpu_starting(cpu);
> +
> +	__cpu_pre_online(arg);
> +
> +	/* Set the CPU in the cpu_online_mask */
> +	set_cpu_online(cpu, true);
> +
> +	__cpu_post_online(arg);
> +
> +	/* Enable local interrupts now */
> +	local_irq_enable();
> +
> +	wmb();
> +	cpu_idle();
> +
> +	/* We should never reach here! */
> +	BUG();
> +}
> diff --git a/kernel/smpboot.h b/kernel/smpboot.h
> index 80c0acf..9753cc0 100644
> --- a/kernel/smpboot.h
> +++ b/kernel/smpboot.h
> @@ -1,5 +1,5 @@
> -#ifndef SMPBOOT_H
> -#define SMPBOOT_H
> +#ifndef __SMPBOOT_H
> +#define __SMPBOOT_H
>  
>  struct task_struct;
>  
> 
> 
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH 02/27] smpboot: Add provisions for arch-specific locking around cpu_online_mask
> 
> We want to make smp booting as generic as possible and remove code
> duplication in arch/ directories.
> 
> While manipulating the cpu_online_mask, x86 uses an additional lock, i.e.,
> 'vector_lock'. So provide a generic way to implement such arch-specific
> extra locking, by providing weakly defined functions arch_vector_lock()
> and arch_vector_unlock() which can be overriden by different architectures
> suitably.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Venkatesh Pallipadi <venki@google.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  kernel/smpboot.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/smpboot.c b/kernel/smpboot.c
> index 6c26133..5ae1805 100644
> --- a/kernel/smpboot.c
> +++ b/kernel/smpboot.c
> @@ -107,6 +107,13 @@ void __weak __cpu_pre_online(void *arg) {}
>  void __weak __cpu_post_online(void *arg) {}
>  #endif
>  
> +/*
> + * Optional arch-specific locking for manipulating cpu_online_mask while
> + * bringing up secondary CPUs.
> + */
> +void __weak arch_vector_lock(void) {}
> +void __weak arch_vector_unlock(void) {}
> +
>  
>  /**
>   * smpboot_start_secondary - Generic way to boot secondary processors
> @@ -129,8 +136,10 @@ void __cpuinit smpboot_start_secondary(void *arg)
>  
>  	__cpu_pre_online(arg);
>  
> -	/* Set the CPU in the cpu_online_mask */
> +	/* Set the CPU in the cpu_online_mask with required locks held */
> +	arch_vector_lock();
>  	set_cpu_online(cpu, true);
> +	arch_vector_unlock();
>  
>  	__cpu_post_online(arg);
>  
> 
> 
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH 03/27] smpboot: Define and use cpu_state per-cpu variable in generic code
> 
> The per-cpu variable cpu_state is used in x86 and also used in other
> architectures, to track the state of the cpu during bringup and hotplug.
> Pull it out into generic code.
> 
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Venkatesh Pallipadi <venki@google.com>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: linux-ia64@vger.kernel.org
> Cc: linux-mips@linux-mips.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-sh@vger.kernel.org
> Cc: xen-devel@lists.xensource.com
> Cc: virtualization@lists.linux-foundation.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  arch/ia64/include/asm/cpu.h   |    2 --
>  arch/ia64/kernel/process.c    |    1 +
>  arch/ia64/kernel/smpboot.c    |    6 +-----
>  arch/mips/cavium-octeon/smp.c |    4 +---
>  arch/powerpc/kernel/smp.c     |    6 +-----
>  arch/sh/include/asm/smp.h     |    2 --
>  arch/sh/kernel/smp.c          |    4 +---
>  arch/tile/kernel/smpboot.c    |    4 +---
>  arch/x86/include/asm/cpu.h    |    2 --
>  arch/x86/kernel/smpboot.c     |    4 +---
>  arch/x86/xen/smp.c            |    1 +
>  include/linux/smpboot.h       |    1 +
>  kernel/smpboot.c              |    4 ++++
>  13 files changed, 13 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/ia64/include/asm/cpu.h b/arch/ia64/include/asm/cpu.h
> index fcca30b..1c3acac 100644
> --- a/arch/ia64/include/asm/cpu.h
> +++ b/arch/ia64/include/asm/cpu.h
> @@ -12,8 +12,6 @@ struct ia64_cpu {
>  
>  DECLARE_PER_CPU(struct ia64_cpu, cpu_devices);
>  
> -DECLARE_PER_CPU(int, cpu_state);
> -
>  #ifdef CONFIG_HOTPLUG_CPU
>  extern int arch_register_cpu(int num);
>  extern void arch_unregister_cpu(int);
> diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
> index 5e0e86d..32566c7 100644
> --- a/arch/ia64/kernel/process.c
> +++ b/arch/ia64/kernel/process.c
> @@ -29,6 +29,7 @@
>  #include <linux/kdebug.h>
>  #include <linux/utsname.h>
>  #include <linux/tracehook.h>
> +#include <linux/smpboot.h>
>  
>  #include <asm/cpu.h>
>  #include <asm/delay.h>
> diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
> index 963d2db..df00a3c 100644
> --- a/arch/ia64/kernel/smpboot.c
> +++ b/arch/ia64/kernel/smpboot.c
> @@ -39,6 +39,7 @@
>  #include <linux/efi.h>
>  #include <linux/percpu.h>
>  #include <linux/bitops.h>
> +#include <linux/smpboot.h>
>  
>  #include <linux/atomic.h>
>  #include <asm/cache.h>
> @@ -111,11 +112,6 @@ extern unsigned long ia64_iobase;
>  
>  struct task_struct *task_for_booting_cpu;
>  
> -/*
> - * State for each CPU
> - */
> -DEFINE_PER_CPU(int, cpu_state);
> -
>  cpumask_t cpu_core_map[NR_CPUS] __cacheline_aligned;
>  EXPORT_SYMBOL(cpu_core_map);
>  DEFINE_PER_CPU_SHARED_ALIGNED(cpumask_t, cpu_sibling_map);
> diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
> index 97e7ce9..93cd4b0 100644
> --- a/arch/mips/cavium-octeon/smp.c
> +++ b/arch/mips/cavium-octeon/smp.c
> @@ -13,6 +13,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/sched.h>
>  #include <linux/module.h>
> +#include <linux/smpboot.h>
>  
>  #include <asm/mmu_context.h>
>  #include <asm/time.h>
> @@ -252,9 +253,6 @@ static void octeon_cpus_done(void)
>  
>  #ifdef CONFIG_HOTPLUG_CPU
>  
> -/* State of each CPU. */
> -DEFINE_PER_CPU(int, cpu_state);
> -
>  extern void fixup_irqs(void);
>  
>  static DEFINE_SPINLOCK(smp_reserve_lock);
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index e1417c4..1928058a 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -31,6 +31,7 @@
>  #include <linux/cpu.h>
>  #include <linux/notifier.h>
>  #include <linux/topology.h>
> +#include <linux/smpboot.h>
>  
>  #include <asm/ptrace.h>
>  #include <linux/atomic.h>
> @@ -57,11 +58,6 @@
>  #define DBG(fmt...)
>  #endif
>  
> -#ifdef CONFIG_HOTPLUG_CPU
> -/* State of each CPU during hotplug phases */
> -static DEFINE_PER_CPU(int, cpu_state) = { 0 };
> -#endif
> -
>  struct thread_info *secondary_ti;
>  
>  DEFINE_PER_CPU(cpumask_var_t, cpu_sibling_map);
> diff --git a/arch/sh/include/asm/smp.h b/arch/sh/include/asm/smp.h
> index 78b0d0f4..bda041e 100644
> --- a/arch/sh/include/asm/smp.h
> +++ b/arch/sh/include/asm/smp.h
> @@ -31,8 +31,6 @@ enum {
>  	SMP_MSG_NR,	/* must be last */
>  };
>  
> -DECLARE_PER_CPU(int, cpu_state);
> -
>  void smp_message_recv(unsigned int msg);
>  void smp_timer_broadcast(const struct cpumask *mask);
>  
> diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
> index b86e9ca..8e0fde0 100644
> --- a/arch/sh/kernel/smp.c
> +++ b/arch/sh/kernel/smp.c
> @@ -22,6 +22,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
>  #include <linux/atomic.h>
> +#include <linux/smpboot.h>
>  #include <asm/processor.h>
>  #include <asm/mmu_context.h>
>  #include <asm/smp.h>
> @@ -34,9 +35,6 @@ int __cpu_logical_map[NR_CPUS];		/* Map logical to physical */
>  
>  struct plat_smp_ops *mp_ops = NULL;
>  
> -/* State of each CPU */
> -DEFINE_PER_CPU(int, cpu_state) = { 0 };
> -
>  void __cpuinit register_smp_ops(struct plat_smp_ops *ops)
>  {
>  	if (mp_ops)
> diff --git a/arch/tile/kernel/smpboot.c b/arch/tile/kernel/smpboot.c
> index e686c5a..24a9c06 100644
> --- a/arch/tile/kernel/smpboot.c
> +++ b/arch/tile/kernel/smpboot.c
> @@ -25,13 +25,11 @@
>  #include <linux/delay.h>
>  #include <linux/err.h>
>  #include <linux/irq.h>
> +#include <linux/smpboot.h>
>  #include <asm/mmu_context.h>
>  #include <asm/tlbflush.h>
>  #include <asm/sections.h>
>  
> -/* State of each CPU. */
> -static DEFINE_PER_CPU(int, cpu_state) = { 0 };
> -
>  /* The messaging code jumps to this pointer during boot-up */
>  unsigned long start_cpu_function_addr;
>  
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index 4564c8e..2d0b239 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -30,8 +30,6 @@ extern int arch_register_cpu(int num);
>  extern void arch_unregister_cpu(int);
>  #endif
>  
> -DECLARE_PER_CPU(int, cpu_state);
> -
>  int mwait_usable(const struct cpuinfo_x86 *);
>  
>  #endif /* _ASM_X86_CPU_H */
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index bfbe30e..269bc1f 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -51,6 +51,7 @@
>  #include <linux/stackprotector.h>
>  #include <linux/gfp.h>
>  #include <linux/cpuidle.h>
> +#include <linux/smpboot.h>
>  
>  #include <asm/acpi.h>
>  #include <asm/desc.h>
> @@ -73,9 +74,6 @@
>  #include <asm/smpboot_hooks.h>
>  #include <asm/i8259.h>
>  
> -/* State of each CPU */
> -DEFINE_PER_CPU(int, cpu_state) = { 0 };
> -
>  #ifdef CONFIG_HOTPLUG_CPU
>  /*
>   * We need this for trampoline_base protection from concurrent accesses when
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 2ef5948..09a7199 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -16,6 +16,7 @@
>  #include <linux/err.h>
>  #include <linux/slab.h>
>  #include <linux/smp.h>
> +#include <linux/smpboot.h>
>  
>  #include <asm/paravirt.h>
>  #include <asm/desc.h>
> diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
> index 63bbedd..834d90c 100644
> --- a/include/linux/smpboot.h
> +++ b/include/linux/smpboot.h
> @@ -5,6 +5,7 @@
>  #ifndef SMPBOOT_H
>  #define SMPBOOT_H
>  
> +DECLARE_PER_CPU(int, cpu_state);
>  extern void smpboot_start_secondary(void *arg);
>  
>  #endif
> diff --git a/kernel/smpboot.c b/kernel/smpboot.c
> index 5ae1805..0df43b0 100644
> --- a/kernel/smpboot.c
> +++ b/kernel/smpboot.c
> @@ -67,6 +67,8 @@ void __init idle_threads_init(void)
>  }
>  #endif
>  
> +/* State of each CPU during bringup/teardown */
> +DEFINE_PER_CPU(int, cpu_state) = { 0 };
>  
>  /* Implement the following functions in your architecture, as appropriate. */
>  
> @@ -141,6 +143,8 @@ void __cpuinit smpboot_start_secondary(void *arg)
>  	set_cpu_online(cpu, true);
>  	arch_vector_unlock();
>  
> +	per_cpu(cpu_state, cpu) = CPU_ONLINE;
> +
>  	__cpu_post_online(arg);
>  
>  	/* Enable local interrupts now */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
