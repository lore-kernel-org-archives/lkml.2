Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1HWNoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:44:05 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:53555 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755331Ab1HWNn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:43:58 -0400
From: Vishwanath Sripathy <vishwanath.bs@ti.com>
References: <1314105680-17426-1-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
In-reply-to: <1314105680-17426-1-git-send-email-abhilash.kv@ti.com>
Thread-Index: Acxhl7C86Qx/pCSfRPKoo2cxwZ7RVQAAkm8w
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Date: Tue, 23 Aug 2011 19:14:03 +0530
Message-ID: <24b1eaea368d2a7a692dc5455aa8b255@mail.gmail.com>
Subject: RE: [PATCH v2 2/2] omap_twl: Prevent SR to enable for am3517/am3505devices
To: Abhilash Koyamangalath <abhilash.kv@ti.com>, linux-omap@vger.kernel.org
Cc: paul@pwsan.com, linux@arm.linux.org.uk, Benoit Cousson <b-cousson@ti.com>,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-
> arm-kernel-bounces@lists.infradead.org] On Behalf Of Abhilash K V
> Sent: Tuesday, August 23, 2011 6:51 PM
> To: linux-omap@vger.kernel.org
> Cc: paul@pwsan.com; linux@arm.linux.org.uk; b-cousson@ti.com;
> tony@atomide.com; linux-kernel@vger.kernel.org; Vaibhav Hiremath;
> Abhilash K V; linux-arm-kernel@lists.infradead.org
> Subject: [PATCH v2 2/2] omap_twl: Prevent SR to enable for
> am3517/am3505devices
>
> From: Vaibhav Hiremath <hvaibhav@ti.com>
>
> In case of AM3517 & AM3505, Smart Reflex is not applicable so
> we must not enable it. So add check for absence of SR feature
> in omap3_twl_init() and return -ENODEV if absence, else continue.
>
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> ---
>  arch/arm/mach-omap2/id.c              |    2 +-
>  arch/arm/mach-omap2/omap_twl.c        |    8 ++++++++
>  arch/arm/plat-omap/include/plat/cpu.h |    2 ++
>  3 files changed, 11 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
> index 37efb86..da71098 100644
> --- a/arch/arm/mach-omap2/id.c
> +++ b/arch/arm/mach-omap2/id.c
> @@ -202,7 +202,7 @@ static void __init omap3_check_features(void)
>  	if (cpu_is_omap3630())
>  		omap_features |= OMAP3_HAS_192MHZ_CLK;
>  	if (!cpu_is_omap3505() && !cpu_is_omap3517())
> -		omap_features |= OMAP3_HAS_IO_WAKEUP;
> +		omap_features |= (OMAP3_HAS_IO_WAKEUP | OMAP3_HAS_SR);
>
>  	omap_features |= OMAP3_HAS_SDRC;
>
> diff --git a/arch/arm/mach-omap2/omap_twl.c b/arch/arm/mach-
> omap2/omap_twl.c
> index 07d6140..47e27b5 100644
> --- a/arch/arm/mach-omap2/omap_twl.c
> +++ b/arch/arm/mach-omap2/omap_twl.c
> @@ -269,6 +269,14 @@ int __init omap3_twl_init(void)
>  	if (!cpu_is_omap34xx())
>  		return -ENODEV;
>
> +	/*
> +	 * In case of AM3517/AM3505 we should not be going down
> +	 * further, since SR is not applicable there.
> +	 */
> +	if (!omap3_has_sr()) {
> +		return -ENODEV;
> +	}
I do not understand what has vp_max and vp_min configuration to do with
SR. This parameter indicates the maximum and minimum voltage supported by
respective PM IC.

Vishwa

> +
>  	if (cpu_is_omap3630()) {
>  		omap3_mpu_volt_info.vp_vddmin =
> OMAP3630_VP1_VLIMITTO_VDDMIN;
>  		omap3_mpu_volt_info.vp_vddmax =
> OMAP3630_VP1_VLIMITTO_VDDMAX;
> diff --git a/arch/arm/plat-omap/include/plat/cpu.h b/arch/arm/plat-
> omap/include/plat/cpu.h
> index 67b3d75..294e015 100644
> --- a/arch/arm/plat-omap/include/plat/cpu.h
> +++ b/arch/arm/plat-omap/include/plat/cpu.h
> @@ -491,6 +491,7 @@ extern u32 omap_features;
>  #define OMAP4_HAS_MPU_1GHZ		BIT(8)
>  #define OMAP4_HAS_MPU_1_2GHZ		BIT(9)
>  #define OMAP4_HAS_MPU_1_5GHZ		BIT(10)
> +#define OMAP3_HAS_SR			BIT(11)
>
>
>  #define OMAP3_HAS_FEATURE(feat,flag)			\
> @@ -507,6 +508,7 @@ OMAP3_HAS_FEATURE(isp, ISP)
>  OMAP3_HAS_FEATURE(192mhz_clk, 192MHZ_CLK)
>  OMAP3_HAS_FEATURE(io_wakeup, IO_WAKEUP)
>  OMAP3_HAS_FEATURE(sdrc, SDRC)
> +OMAP3_HAS_FEATURE(sr, SR)
>
>  /*
>   * Runtime detection of OMAP4 features
> --
> 1.7.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
