Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1I3VAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 17:00:13 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:51743 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544Ab1I3VAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 17:00:10 -0400
From: Kevin Hilman <khilman@ti.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <paul@pwsan.com>,
        <aneesh@ti.com>, <santosh.shilimkar@ti.com>,
        <christian.gmeiner@gmail.com>, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: Re: [PATCH v5 2/3] omap_twl: Prevent SR to enable for am3517/am3505 devices
Organization: Texas Instruments, Inc.
References: <1317363153-10259-1-git-send-email-abhilash.kv@ti.com>
	<1317363153-10259-2-git-send-email-abhilash.kv@ti.com>
	<1317363153-10259-3-git-send-email-abhilash.kv@ti.com>
Date: Fri, 30 Sep 2011 14:00:04 -0700
In-Reply-To: <1317363153-10259-3-git-send-email-abhilash.kv@ti.com> (Abhilash
	K. V.'s message of "Fri, 30 Sep 2011 11:42:32 +0530")
Message-ID: <87r52xhhkb.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhilash K V <abhilash.kv@ti.com> writes:

> From: Abhilash K V <abhilash.kv@ti.com>
>
> In case of AM3517 & AM3505, SmartReflex is not applicable so
> we must not enable it. So omap3_twl_init() is now not called
> when the processor does not support SR.

This still isn't right.

The reason to skip the TWL PMIC init is not because SR is not available
(TWL PMICs are quite usable without SR).  The reason to skip TWL PMIC
init is because the PMIC is not present.

Instead, we need to fix up the TWL/PMIC init so that TWL-specifics are
only registered if a TWL driver is registered.

So, please drop hunk #2 from this patch, and just make this patch add a
new feature for the existence of SmartReflex.  Removing the assumptions
and init for the existence of the TWL is a separate problem.

Kevin

> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> ---
>  arch/arm/mach-omap2/id.c              |    2 +-
>  arch/arm/mach-omap2/pm.c              |    3 ++-
>  arch/arm/plat-omap/include/plat/cpu.h |    2 ++
>  3 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
> index d27daf9..b7e3082 100644
> --- a/arch/arm/mach-omap2/id.c
> +++ b/arch/arm/mach-omap2/id.c
> @@ -188,7 +188,7 @@ static void __init omap3_check_features(void)
>  	if (cpu_is_omap3630())
>  		omap_features |= OMAP3_HAS_192MHZ_CLK;
>  	if (!cpu_is_omap3505() && !cpu_is_omap3517())
> -		omap_features |= OMAP3_HAS_IO_WAKEUP;
> +		omap_features |= (OMAP3_HAS_IO_WAKEUP | OMAP3_HAS_SR);
>  
>  	omap_features |= OMAP3_HAS_SDRC;
>  
> diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
> index 0844e2e..6835198 100644
> --- a/arch/arm/mach-omap2/pm.c
> +++ b/arch/arm/mach-omap2/pm.c
> @@ -250,7 +250,8 @@ postcore_initcall(omap2_common_pm_init);
>  static int __init omap2_common_pm_late_init(void)
>  {
>  	/* Init the OMAP TWL parameters */
> -	omap3_twl_init();
> +	if (omap3_has_sr())
> +		omap3_twl_init();
>  	omap4_twl_init();
>  
>  	/* Init the voltage layer */
> diff --git a/arch/arm/plat-omap/include/plat/cpu.h b/arch/arm/plat-omap/include/plat/cpu.h
> index 2f90269..cc6fcd3 100644
> --- a/arch/arm/plat-omap/include/plat/cpu.h
> +++ b/arch/arm/plat-omap/include/plat/cpu.h
> @@ -413,6 +413,7 @@ extern u32 omap_features;
>  #define OMAP4_HAS_MPU_1GHZ		BIT(8)
>  #define OMAP4_HAS_MPU_1_2GHZ		BIT(9)
>  #define OMAP4_HAS_MPU_1_5GHZ		BIT(10)
> +#define OMAP3_HAS_SR			BIT(11)
>  
>  
>  #define OMAP3_HAS_FEATURE(feat,flag)			\
> @@ -429,6 +430,7 @@ OMAP3_HAS_FEATURE(isp, ISP)
>  OMAP3_HAS_FEATURE(192mhz_clk, 192MHZ_CLK)
>  OMAP3_HAS_FEATURE(io_wakeup, IO_WAKEUP)
>  OMAP3_HAS_FEATURE(sdrc, SDRC)
> +OMAP3_HAS_FEATURE(sr, SR)
>  
>  /*
>   * Runtime detection of OMAP4 features
