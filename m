Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2DPTxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:53:36 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:9632 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754314Ab2DPTxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:53:34 -0400
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F8C78B3.1070002@freescale.com>
Date: Mon, 16 Apr 2012 14:53:23 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH v4 1/4] powerpc/85xx: add HOTPLUG_CPU support
References: <1331889732-25240-1-git-send-email-chenhui.zhao@freescale.com>
In-Reply-To: <1331889732-25240-1-git-send-email-chenhui.zhao@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 04:22 AM, Zhao Chenhui wrote:
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 4eecaaa..3d4c497 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -219,7 +219,8 @@ config ARCH_HIBERNATION_POSSIBLE
>  config ARCH_SUSPEND_POSSIBLE
>  	def_bool y
>  	depends on ADB_PMU || PPC_EFIKA || PPC_LITE5200 || PPC_83xx || \
> -		   (PPC_85xx && !SMP) || PPC_86xx || PPC_PSERIES || 44x || 40x
> +		   (PPC_85xx && !PPC_E500MC) || PPC_86xx || PPC_PSERIES \
> +		   || 44x || 40x
>  
>  config PPC_DCR_NATIVE
>  	bool
> @@ -330,7 +331,8 @@ config SWIOTLB
>  
>  config HOTPLUG_CPU
>  	bool "Support for enabling/disabling CPUs"
> -	depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC || PPC_POWERNV)
> +	depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || \
> +	PPC_PMAC || PPC_POWERNV || PPC_85xx)

No e500mc exclusion on HOTPLUG_CPU?  I don't see where this depends on
ARCH_SUSPEND_POSSIBLE.

>  	---help---
>  	  Say Y here to be able to disable and re-enable individual
>  	  CPUs at runtime on SMP machines.
> diff --git a/arch/powerpc/include/asm/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
> index ab9e402..57b5dd7 100644
> --- a/arch/powerpc/include/asm/cacheflush.h
> +++ b/arch/powerpc/include/asm/cacheflush.h
> @@ -30,6 +30,12 @@ extern void flush_dcache_page(struct page *page);
>  #define flush_dcache_mmap_lock(mapping)		do { } while (0)
>  #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
>  
> +#ifdef CONFIG_FSL_BOOKE
> +extern void flush_disable_L1(void);
> +#else
> +#define flush_disable_L1()		do { } while (0)
> +#endif

When would we want this to be a no-op?  Shouldn't you get an error if
you try to do this without an implementation, rather than silently
corrupt your cache?

There's an existing __flush_disable_L1() for 6xx.  Let's not introduce a
different spelling of the same thing for no good reason -- even if those
leading underscores are annoying and pointless. :-)

> +#ifdef CONFIG_HOTPLUG_CPU
> +	/* Corresponding to generic_set_cpu_dead() */
> +	generic_set_cpu_up(nr);
> +
> +	if (system_state == SYSTEM_RUNNING) {
> +		out_be32(&spin_table->addr_l, 0);
> +
> +		/*
> +		 * We don't set the BPTR register here upon it points
> +		 * to the boot page properly.
> +		 */
> +		mpic_reset_core(hw_cpu);

What if we don't have an MPIC?  What if MPIC support isn't present in
the kernel, even if we never run this code?

Also, can you limit the hard core reset to cases that really need it?

>  struct smp_ops_t smp_85xx_ops = {
>  	.kick_cpu = smp_85xx_kick_cpu,
> -#ifdef CONFIG_KEXEC
> +#ifdef CONFIG_HOTPLUG_CPU
> +	.cpu_disable	= generic_cpu_disable,
> +	.cpu_die	= generic_cpu_die,
> +#endif
>  	.give_timebase	= smp_generic_give_timebase,
>  	.take_timebase	= smp_generic_take_timebase,
> -#endif
>  };

We need to stop using smp_generic_give/take_timebase, not expand its
use.  This stuff breaks under hypervisors where timebase can't be
written.  It wasn't too bad before since we generally didn't enable
CONFIG_KEXEC, but we're more likely to want CONFIG_HOTPLUG_CPU.

Do the timebase sync the way U-Boot does -- if you find the appropriate
guts node in the device tree.

>  
>  #ifdef CONFIG_KEXEC
> @@ -218,8 +283,7 @@ static void mpc85xx_smp_machine_kexec(struct kimage *image)
>  }
>  #endif /* CONFIG_KEXEC */
>  
> -static void __init
> -smp_85xx_setup_cpu(int cpu_nr)
> +static void __cpuinit smp_85xx_setup_cpu(int cpu_nr)
>  {
>  	if (smp_85xx_ops.probe == smp_mpic_probe)
>  		mpic_setup_this_cpu();
> @@ -249,6 +313,10 @@ void __init mpc85xx_smp_init(void)
>  		smp_85xx_ops.cause_ipi = doorbell_cause_ipi;
>  	}
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +	ppc_md.cpu_die		= smp_85xx_mach_cpu_die;
> +#endif

Do not set this unconditionally without checking that you're on
e500v1/e500v2 (or at least that you have the NAP cputable flag, and an
MPIC if you're going to rely on that).

The kconfig exclusion is at best a temporary hack.

-Scott

