Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1IVVgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:36:01 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:40290 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939Ab1IVVf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:35:58 -0400
From: Kevin Hilman <khilman@ti.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <paul@pwsan.com>,
        <aneesh@ti.com>, <santosh.shilimkar@ti.com>,
        <christian.gmeiner@gmail.com>, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: Re: [PATCH v4 2/3] omap_twl: Prevent SR to enable for am3517/am3505 devices
Organization: Texas Instruments, Inc.
References: <1316697993-696-1-git-send-email-abhilash.kv@ti.com>
	<1316697993-696-2-git-send-email-abhilash.kv@ti.com>
	<1316697993-696-3-git-send-email-abhilash.kv@ti.com>
Date: Thu, 22 Sep 2011 14:35:53 -0700
In-Reply-To: <1316697993-696-3-git-send-email-abhilash.kv@ti.com> (Abhilash
	K. V.'s message of "Thu, 22 Sep 2011 18:56:32 +0530")
Message-ID: <87zkhws1ja.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhilash K V <abhilash.kv@ti.com> writes:

> In case of AM3517 & AM3505, SmartReflex is not applicable so
> we must not enable it. 

This part is fine, but...

> So omap3_twl_init() is now not called when the processor does not
> support SR.

...I don't think this is right.  DVFS using the PMIC is still doable
without SR.

Are you assuming that no DVFS is done on these devices?

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
> index d34fc52..da71abc 100644
> --- a/arch/arm/mach-omap2/pm.c
> +++ b/arch/arm/mach-omap2/pm.c
> @@ -252,7 +252,8 @@ postcore_initcall(omap2_common_pm_init);
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
