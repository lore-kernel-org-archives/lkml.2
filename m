Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0FPFQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:16:40 -0400
Received: from verein.lst.de ([213.95.11.210]:57893 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab0FPFQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:16:39 -0400
Date: Wed, 16 Jun 2010 07:16:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: always use irq stacks
Message-ID: <20100616051629.GA26012@lst.de>
References: <20100526110923.GA28414@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526110923.GA28414@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?  This just came up again as a side-issue in the direct reclaim
thread.  x86-32 really is the only one out there still having this
compared to the other common architetures like x86-64, powerpc and s390.

On Wed, May 26, 2010 at 01:09:23PM +0200, Christoph Hellwig wrote:
> 
> IRQ stacks provide much better safety against unexpected stack use from
> interrupts, at the minimal downside of slightly higher memory usage.
> Enable irq stacks also for the default 8k stack to minimize the problem
> of stack overflows through interrupt activity.
> 
> This is what x86-64 and various other architectures already do.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/arch/x86/Kconfig.debug
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig.debug	2010-05-25 18:45:43.048276085 +0200
> +++ linux-2.6/arch/x86/Kconfig.debug	2010-05-25 18:45:53.603003841 +0200
> @@ -128,8 +128,7 @@ config 4KSTACKS
>  	  If you say Y here the kernel will use a 4Kb stacksize for the
>  	  kernel stack attached to each process/thread. This facilitates
>  	  running more threads on a system and also reduces the pressure
> -	  on the VM subsystem for higher order allocations. This option
> -	  will also use IRQ stacks to compensate for the reduced stackspace.
> +	  on the VM subsystem for higher order allocations.
>  
>  config DOUBLEFAULT
>  	default y
> Index: linux-2.6/arch/x86/include/asm/irq.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/irq.h	2010-05-25 18:45:43.040025143 +0200
> +++ linux-2.6/arch/x86/include/asm/irq.h	2010-05-25 18:45:53.604003981 +0200
> @@ -19,18 +19,16 @@ static inline int irq_canonicalize(int i
>  # define ARCH_HAS_NMI_WATCHDOG
>  #endif
>  
> -#ifdef CONFIG_4KSTACKS
> -  extern void irq_ctx_init(int cpu);
> -  extern void irq_ctx_exit(int cpu);
> -# define __ARCH_HAS_DO_SOFTIRQ
> +#ifdef CONFIG_X86_32
> +extern void irq_ctx_init(int cpu);
> +extern void irq_ctx_exit(int cpu);
>  #else
>  # define irq_ctx_init(cpu) do { } while (0)
>  # define irq_ctx_exit(cpu) do { } while (0)
> -# ifdef CONFIG_X86_64
> -#  define __ARCH_HAS_DO_SOFTIRQ
> -# endif
>  #endif
>  
> +#define __ARCH_HAS_DO_SOFTIRQ
> +
>  #ifdef CONFIG_HOTPLUG_CPU
>  #include <linux/cpumask.h>
>  extern void fixup_irqs(void);
> Index: linux-2.6/arch/x86/kernel/irq_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/irq_32.c	2010-05-25 18:45:42.981006006 +0200
> +++ linux-2.6/arch/x86/kernel/irq_32.c	2010-05-25 18:45:53.606003632 +0200
> @@ -49,7 +49,6 @@ static inline int check_stack_overflow(v
>  static inline void print_stack_overflow(void) { }
>  #endif
>  
> -#ifdef CONFIG_4KSTACKS
>  /*
>   * per-CPU IRQ handling contexts (thread information and stack)
>   */
> @@ -187,11 +186,6 @@ asmlinkage void do_softirq(void)
>  	local_irq_restore(flags);
>  }
>  
> -#else
> -static inline int
> -execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq) { return 0; }
> -#endif
> -
>  bool handle_irq(unsigned irq, struct pt_regs *regs)
>  {
>  	struct irq_desc *desc;
> Index: linux-2.6/Documentation/x86/x86_64/kernel-stacks
> ===================================================================
> --- linux-2.6.orig/Documentation/x86/x86_64/kernel-stacks	2010-05-25 18:45:55.631004120 +0200
> +++ linux-2.6/Documentation/x86/x86_64/kernel-stacks	2010-05-25 18:46:21.785256528 +0200
> @@ -18,9 +18,9 @@ specialized stacks contain no useful dat
>    Used for external hardware interrupts.  If this is the first external
>    hardware interrupt (i.e. not a nested hardware interrupt) then the
>    kernel switches from the current task to the interrupt stack.  Like
> -  the split thread and interrupt stacks on i386 (with CONFIG_4KSTACKS),
> -  this gives more room for kernel interrupt processing without having
> -  to increase the size of every per thread stack.
> +  the split thread and interrupt stacks on i386, this gives more room
> +  for kernel interrupt processing without having to increase the size
> +  of every per thread stack.
>  
>    The interrupt stack is also used when processing a softirq.
>  
---end quoted text---
