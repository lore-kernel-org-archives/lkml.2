Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab2LLVPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:15:40 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64876 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2LLVPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:15:39 -0500
Message-ID: <50C8F3F8.1020102@gmail.com>
Date: Wed, 12 Dec 2012 15:15:36 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Boojin Kim <boojin.kim@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>
Subject: Re: [PATCH 3/3] ARM: MM: Add the workaround of Errata 766421
References: <001901cdd669$4cd77070$e6865150$%kim@samsung.com>
In-Reply-To: <001901cdd669$4cd77070$e6865150$%kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2012 06:00 PM, Boojin Kim wrote:
> This patch adds the workaround of errata 766421 that adds 'dmb' when changing
> the translation regime after conditions that the errata 766421 may occur.
> Concretely, Add 'dmb' when changing ASID and secure state for cortex-A15 r0p4.
> 
> Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
> ---
>  arch/arm/Kconfig             |   13 +++++++++++++
>  arch/arm/mach-exynos/Kconfig |    1 +
>  arch/arm/mm/proc-v7-2level.S |    2 ++
>  3 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 93397da..9bd34dd 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1417,6 +1417,19 @@ config ARM_ERRATA_775420
>  	 to deadlock. This workaround puts DSB before executing ISB if
>  	 an abort may occur on cache maintenance.
> 
> +config ARM_ERRATA_766421
> +	bool "ARM errata: Strongly-Ordered/Device load or NC LDREX could return incorrect data"
> +	depends on CPU_V7
> +	help
> +	  This option enables the workaround for the erratum 766421 affecting
> +	  Cortex-A15 erratum (r0p4).
> +	  In certain situations, a strongly ordered or device load instruction,
> +	  or a non-cacheable normal memory load-exclusive instruction could
> +	  match multiple fill buffers and return incorrect data.
> +	  This workaround is add DMB instruction when making any change to the
> +	  translation regime and before doing any new loads/stores/preloads
> +	  in the new translation regime.
> +
>  config ARM_ERRATA_773022
>  	bool "ARM errata: incorrect instructions may be executed from loop buffer"
>  	depends on CPU_V7
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index bb92f4c..4e28e1c 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -66,6 +66,7 @@ config SOC_EXYNOS5250
>  	select S5P_PM if PM
>  	select S5P_SLEEP if PM
>  	select SAMSUNG_DMADEV
> +	select ARM_ERRATA_766421
>  	help
>  	  Enable EXYNOS5250 SoC support
> 
> diff --git a/arch/arm/mm/proc-v7-2level.S b/arch/arm/mm/proc-v7-2level.S
> index fd045e7..c663b2e 100644
> --- a/arch/arm/mm/proc-v7-2level.S
> +++ b/arch/arm/mm/proc-v7-2level.S
> @@ -53,6 +53,8 @@ ENTRY(cpu_v7_switch_mm)
>  #endif
>  #ifdef CONFIG_ARM_ERRATA_754322
>  	dsb
> +#elif CONFIG_ARM_ERRATA_766421
> +	dmb

Despite the comments on the 1st patch, this one would still be needed as
it cannot be done before the kernel runs.

However, if you have 754322 and 766421 enabled, we would have dsb and
dmb. We do something like this instead:

#if defined(CONFIG_ARM_ERRATA_754322) || defined(CONFIG_ARM_ERRATA_766421)
  	dsb
#endif

Rob

>  #endif
>  	mcr	p15, 0, r1, c13, c0, 1		@ set context ID
>  	isb
> --
> 1.7.5.4
> 
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

