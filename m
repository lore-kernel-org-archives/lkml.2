Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab2BAPDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:03:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab2BAPDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:03:15 -0500
Date: Wed, 1 Feb 2012 10:03:13 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [V2 Patch] nmi watchdog: do not use cpp symbol in Kconfig
Message-ID: <20120201150313.GG5650@redhat.com>
References: <1328099500-15923-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328099500-15923-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 08:31:40PM +0800, Cong Wang wrote:
> V2: Fix subject...
> 
> ARCH_HAS_NMI_WATCHDOG is a macro defined by arch,
> but config HARDLOCKUP_DETECTOR depends on it.
> This is wrong, ARCH_HAS_NMI_WATCHDOG has to be a Kconfig
> config, and arch's need it should select it explicitly.

Seems to make sense.  How did you stumble upon that?

Acked-by: Don Zickus <dzickus@redhat.com>

> 
> Cc: Don Zickus <dzickus@redhat.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
>  arch/Kconfig                          |    3 +++
>  arch/blackfin/Kconfig                 |    1 +
>  arch/blackfin/include/asm/irq.h       |    4 ----
>  arch/mn10300/Kconfig                  |    1 +
>  arch/mn10300/include/asm/reset-regs.h |    4 ----
>  arch/sparc/Kconfig                    |    1 +
>  arch/sparc/include/asm/irq_64.h       |    1 -
>  include/linux/nmi.h                   |    2 +-
>  lib/Kconfig.debug                     |    2 +-
>  9 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 4f55c73..c1a94a7 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -109,6 +109,9 @@ config HAVE_KRETPROBES
>  
>  config HAVE_OPTPROBES
>  	bool
> +
> +config HAVE_NMI_WATCHDOG
> +	bool
>  #
>  # An arch should select this if it provides all these things:
>  #
> diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
> index abe5a9e..c1269a1 100644
> --- a/arch/blackfin/Kconfig
> +++ b/arch/blackfin/Kconfig
> @@ -36,6 +36,7 @@ config BLACKFIN
>  	select GENERIC_ATOMIC64
>  	select GENERIC_IRQ_PROBE
>  	select IRQ_PER_CPU if SMP
> +	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
>  
>  config GENERIC_CSUM
>  	def_bool y
> diff --git a/arch/blackfin/include/asm/irq.h b/arch/blackfin/include/asm/irq.h
> index 12f4060..89de539 100644
> --- a/arch/blackfin/include/asm/irq.h
> +++ b/arch/blackfin/include/asm/irq.h
> @@ -38,8 +38,4 @@
>  
>  #include <asm-generic/irq.h>
>  
> -#ifdef CONFIG_NMI_WATCHDOG
> -# define ARCH_HAS_NMI_WATCHDOG
> -#endif
> -
>  #endif				/* _BFIN_IRQ_H_ */
> diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
> index 8f1c40d..3aa3de0 100644
> --- a/arch/mn10300/Kconfig
> +++ b/arch/mn10300/Kconfig
> @@ -5,6 +5,7 @@ config MN10300
>  	select GENERIC_IRQ_SHOW
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_ARCH_KGDB
> +	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
>  
>  config AM33_2
>  	def_bool n
> diff --git a/arch/mn10300/include/asm/reset-regs.h b/arch/mn10300/include/asm/reset-regs.h
> index 10c7502..8ca2a42 100644
> --- a/arch/mn10300/include/asm/reset-regs.h
> +++ b/arch/mn10300/include/asm/reset-regs.h
> @@ -17,10 +17,6 @@
>  
>  #ifdef __KERNEL__
>  
> -#ifdef CONFIG_MN10300_WD_TIMER
> -#define ARCH_HAS_NMI_WATCHDOG		/* See include/linux/nmi.h */
> -#endif
> -
>  /*
>   * watchdog timer registers
>   */
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index 9665799..53c7c7a 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -29,6 +29,7 @@ config SPARC
>  	select GENERIC_IRQ_SHOW
>  	select USE_GENERIC_SMP_HELPERS if SMP
>  	select GENERIC_PCI_IOMAP
> +	select HAVE_NMI_WATCHDOG if SPARC64
>  
>  config SPARC32
>  	def_bool !64BIT
> diff --git a/arch/sparc/include/asm/irq_64.h b/arch/sparc/include/asm/irq_64.h
> index 16dcae6d..abf6afe 100644
> --- a/arch/sparc/include/asm/irq_64.h
> +++ b/arch/sparc/include/asm/irq_64.h
> @@ -95,7 +95,6 @@ void arch_trigger_all_cpu_backtrace(void);
>  extern void *hardirq_stack[NR_CPUS];
>  extern void *softirq_stack[NR_CPUS];
>  #define __ARCH_HAS_DO_SOFTIRQ
> -#define ARCH_HAS_NMI_WATCHDOG
>  
>  #define NO_IRQ		0xffffffff
>  
> diff --git a/include/linux/nmi.h b/include/linux/nmi.h
> index 2d304ef..db50840 100644
> --- a/include/linux/nmi.h
> +++ b/include/linux/nmi.h
> @@ -14,7 +14,7 @@
>   * may be used to reset the timeout - for code which intentionally
>   * disables interrupts for a long time. This call is stateless.
>   */
> -#if defined(ARCH_HAS_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
> +#if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
>  #include <asm/nmi.h>
>  extern void touch_nmi_watchdog(void);
>  #else
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 8745ac7..2dc65ba 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -181,7 +181,7 @@ config LOCKUP_DETECTOR
>  
>  config HARDLOCKUP_DETECTOR
>  	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI && \
> -		 !ARCH_HAS_NMI_WATCHDOG
> +		 !HAVE_NMI_WATCHDOG
>  
>  config BOOTPARAM_HARDLOCKUP_PANIC
>  	bool "Panic (Reboot) On Hard Lockups"
