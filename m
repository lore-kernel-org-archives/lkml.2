Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab2LJOJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:09:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34480 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab2LJOJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:09:46 -0500
Message-ID: <50C5ED3E.2050308@ti.com>
Date: Mon, 10 Dec 2012 19:40:06 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>
CC: Boojin Kim <boojin.kim@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Subject: Re: [PATCH 1/3] ARM: MM: Add the workaround of Errata 774769
References: <001701cdd669$19e8cdd0$4dba6970$%kim@samsung.com>
In-Reply-To: <001701cdd669$19e8cdd0$4dba6970$%kim@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2012 05:28 AM, Boojin Kim wrote:
> This patch adds the workaround of Errata 774769 that configures write streaming
> on versions of A15 affected by this erratum such that no streaming-write ever
> allocates into the L2 cache.
>
> Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
> ---
>   arch/arm/Kconfig             |   11 +++++++++++
>   arch/arm/mach-exynos/Kconfig |    1 +
>   arch/arm/mm/proc-v7.S        |   16 ++++++++++++++--
>   3 files changed, 26 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 9759fec..11a57e2 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1417,6 +1417,17 @@ config ARM_ERRATA_775420
>   	 to deadlock. This workaround puts DSB before executing ISB if
>   	 an abort may occur on cache maintenance.
>
> +config ARM_ERRATA_774769
> +	bool "ARM errata: data corruption may occur with store streaming in a system"
> +	depends on CPU_V7
> +	help
> +	  This option enables the workaround for the erratum 774769 affecting
> +	  Cortex-A15 (r0p4).
> +	  External memory may be corrupted on erratum 774769.
> +	  The workaround is to configure write streaming on versions of A15
> +	  affected by this erratum such that no streaming-write ever allocates
> +	  into the L2 cache.
> +
>   endmenu
>
>   source "arch/arm/common/Kconfig"
> diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> index da55107..e1168fb 100644
> --- a/arch/arm/mach-exynos/Kconfig
> +++ b/arch/arm/mach-exynos/Kconfig
> @@ -22,6 +22,7 @@ config ARCH_EXYNOS4
>   config ARCH_EXYNOS5
>   	bool "SAMSUNG EXYNOS5"
>   	select HAVE_SMP
> +	select ARM_ERRATA_774769
>   	help
>   	  Samsung EXYNOS5 (Cortex-A15) SoC based systems
>
> diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
> index 846d279..06cbdfa 100644
> --- a/arch/arm/mm/proc-v7.S
> +++ b/arch/arm/mm/proc-v7.S
> @@ -208,7 +208,7 @@ __v7_setup:
>   	orreq	r10, r10, #(1 << 22)		@ set the Write Allocate disable bit
>   	mcreq	p15, 1, r10, c9, c0, 2		@ write the L2 cache aux ctrl register
>   #endif
> -	b	3f
> +	b	4f
>
>   	/* Cortex-A9 Errata */
>   2:	ldr	r10, =0x00000c09		@ Cortex-A9 primary part number
> @@ -243,8 +243,20 @@ __v7_setup:
>   	mcrlt	p15, 0, r10, c15, c0, 1		@ write diagnostic register
>   1:
>   #endif
> +	b	4f
>
> -3:	mov	r10, #0
> +	/* Cortex-A15 Errata */
> +3:	ldr	r10, =0x00000c0f		@ Cortex-A15 primary part number
> +	teq	r0, r10
> +	bne	4f
> +#ifdef CONFIG_ARM_ERRATA_774769
> +	teq	r6, #0x4			@ present in r0p4
> +	mrceq	p15, 0, r10, c1, c0, 1		@ read aux control register
> +	orreq	r10, r10, #1 << 25		@ set bit #25
> +	mcreq	p15, 0, r10, c1, c0, 1		@ write aux control register
This will fault on kernels booted in non-secure mode. The comment is
applicable for other two patches in series as well.

Russell/Catalin,
Whats the stand on such erratas ? I saw on one of thread one of
you suggesting to stop patching kernel where secure/non-secure
kernel will need different errata WA.

Regards
Santosh




