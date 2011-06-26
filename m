Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1FZRbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 13:31:43 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:34655 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab1FZRaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 13:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BpmFG/qVQmyLJgjP6+9SciaB3cE7bQ7rdoaJnkIL3akPtvtxWpCi+M32zeKQc7ditk
         vy2idMxTw5jcADWX7WspG28PwqLd3/bHH5mUruqGSLGLP++fWHkfDZVE1Tk08Oz9/oWN
         QkXeE5iu3Tk2UDj8dFn/a1Ufis6Ux6BBqGV7k=
Message-ID: <4E076CC5.3000908@gmail.com>
Date: Sun, 26 Jun 2011 19:30:45 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: EXYNOS4: Support for generic I/O power domains on
 EXYNOS4210
References: <4E0461BE.5030304@samsung.com>
In-Reply-To: <4E0461BE.5030304@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/24/2011 12:06 PM, Chanwoo Choi wrote:
> Use the generic power domains support to implement support
> for power domain on EXYNOS4210.
> 
> This patch is based on your "pm-domains" branch.(v7)
> 
> Signed-off-by: Chanwoo Choi<cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham<myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin.park<kyungmin.park@samsung.com>
> ---
>   arch/arm/mach-exynos4/Kconfig                      |    1 +
>   arch/arm/mach-exynos4/Makefile                     |    1 +
>   arch/arm/mach-exynos4/include/mach/pm-exynos4210.h |   78 ++++++++++++
>   arch/arm/mach-exynos4/mach-nuri.c                  |   20 +++
>   arch/arm/mach-exynos4/pm-exynos4210.c              |  131 ++++++++++++++++++++
>   5 files changed, 231 insertions(+), 0 deletions(-)
>   create mode 100644 arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
>   create mode 100644 arch/arm/mach-exynos4/pm-exynos4210.c
> 
...

> diff --git a/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h b/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
> new file mode 100644
> index 0000000..fa1c7a0
> --- /dev/null
> +++ b/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
> @@ -0,0 +1,78 @@
> +/* linux/arch/arm/mach-exynos4/include/mach/pm-exynos4.h
> + *
> + * Exynos4 Power management support
> + *
> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __PM_EXYNOS4210_H__
> +#define __PM_EXYNOS4210_H__
> +
> +#include<linux/pm_domain.h>
> +
> +struct platform_device;
> +
> +struct exynos4210_pm_domain {
> +	struct generic_pm_domain genpd;
> +
> +	const char *name;
> +	void __iomem *base;
> +	int boot_on;
> +};
> +
> +static inline struct exynos4210_pm_domain *to_exynos4210_pd(
> +		struct generic_pm_domain *pd)
> +{
> +	return container_of(pd, struct exynos4210_pm_domain, genpd);
> +}
> +
> +#ifdef CONFIG_PM
> +enum exynos4210_pd_data {
> +	EXYNOS4210_PD_MFC,
> +	EXYNOS4210_PD_G3D,
> +	EXYNOS4210_PD_LCD0,
> +	EXYNOS4210_PD_LCD1,
> +	EXYNOS4210_PD_TV,
> +	EXYNOS4210_PD_CAM,
> +	EXYNOS4210_PD_GPS,
> +	EXYNOS4210_PD_MAX_NUM
> +};
> +
> +extern struct exynos4210_pm_domain exynos4210_pd_list[EXYNOS4210_PD_MAX_NUM];

Could this array be made static in ../pm-exynos4210.c ?
It looks like all functions using it are there. Plus you have already
enum exynos4210_pd_data to identify each power domain.

> +#define EXYNOS4210_MFC		(&exynos4210_pd_list[EXYNOS4210_PD_MFC])
> +#define EXYNOS4210_G3D		(&exynos4210_pd_list[EXYNOS4210_PD_G3D])
> +#define EXYNOS4210_LCD0		(&exynos4210_pd_list[EXYNOS4210_PD_LCD0])
> +#define EXYNOS4210_LCD1		(&exynos4210_pd_list[EXYNOS4210_PD_LCD1])
> +#define EXYNOS4210_TV		(&exynos4210_pd_list[EXYNOS4210_PD_TV])
> +#define EXYNOS4210_CAM		(&exynos4210_pd_list[EXYNOS4210_PD_CAM])
> +#define EXYNOS4210_GPS		(&exynos4210_pd_list[EXYNOS4210_PD_GPS])
> +
> +extern int exynos4210_pd_init(struct exynos4210_pm_domain *domain);
> +extern int exynos4210_add_device_to_domain(struct exynos4210_pm_domain *domain,
> +				struct platform_device *pdev);

Is there any advantage of having these functions marked as "extern" ?

> +#else
> +#define EXYNOS4210_MFC		NULL
> +#define EXYNOS4210_G3D		NULL
> +#define EXYNOS4210_LCD0		NULL
> +#define EXYNOS4210_LCD1		NULL
> +#define EXYNOS4210_TV		NULL
> +#define EXYNOS4210_CAM		NULL
> +#define EXYNOS4210_GPS		NULL
> +
> +extern int exynos4210_pd_init(struct exynos4210_pm_domain *domain)

Shouldn't it be "static inline" instead ?

> +{
> +	return 0;
> +}
> +extern int exynos4_add_device_to_domain(struct exynos4210_pm_domain *domain,
> +				struct platform_device *pdev)

Ditto.

...
> diff --git a/arch/arm/mach-exynos4/mach-nuri.c b/arch/arm/mach-exynos4/mach-nuri.c
> index 642702b..3e5c42c 100644
> --- a/arch/arm/mach-exynos4/mach-nuri.c
> +++ b/arch/arm/mach-exynos4/mach-nuri.c
> @@ -37,6 +37,7 @@
>   #include<plat/iic.h>
> 
>   #include<mach/map.h>
> +#include<mach/pm-exynos4210.h>
> 
>   /* Following are default values for UCON, ULCON and UFCON UART registers */
>   #define NURI_UCON_DEFAULT	(S3C2410_UCON_TXILEVEL |	\
> @@ -376,6 +377,23 @@ static struct platform_device *nuri_devices[] __initdata = {
>   	&nuri_backlight_device,
>   };
> 
> +static void __init nuri_power_domain_init(void)
> +{
> +	int i;
> +
> +	for (i = 0 ; i<  EXYNOS4210_PD_MAX_NUM ; i++)
> +		exynos4210_pd_init(&exynos4210_pd_list[i]);
> +
> +	/* Add device to power-domain */
> +	exynos4210_add_device_to_domain(EXYNOS4210_MFC, NULL);
> +	exynos4210_add_device_to_domain(EXYNOS4210_G3D, NULL);
> +	exynos4210_add_device_to_domain(EXYNOS4210_LCD0,&nuri_lcd_device);
> +	exynos4210_add_device_to_domain(EXYNOS4210_LCD1, NULL);
> +	exynos4210_add_device_to_domain(EXYNOS4210_TV, NULL);
> +	exynos4210_add_device_to_domain(EXYNOS4210_CAM, NULL);
> +	exynos4210_add_device_to_domain(EXYNOS4210_GPS, NULL);
> +}
> +
>   static void __init nuri_map_io(void)
>   {
>   	s5p_init_io(NULL, 0, S5P_VA_CHIPID);
> @@ -398,6 +416,8 @@ static void __init nuri_machine_init(void)
> 
>   	/* Last */
>   	platform_add_devices(nuri_devices, ARRAY_SIZE(nuri_devices));
> +
> +	nuri_power_domain_init();
>   }
> 
>   MACHINE_START(NURI, "NURI")
> diff --git a/arch/arm/mach-exynos4/pm-exynos4210.c b/arch/arm/mach-exynos4/pm-exynos4210.c
> new file mode 100644
> index 0000000..8e95d49
> --- /dev/null
> +++ b/arch/arm/mach-exynos4/pm-exynos4210.c
> @@ -0,0 +1,131 @@
> +/* linux/arch/arm/mach-exynos4/pm-exynos4210.c
> + *
...
> +
> +struct exynos4210_pm_domain exynos4210_pd_list[] = {
> +	{
> +		.name		= "PD_MFC",
> +		.base		= S5P_PMU_MFC_CONF,
> +		.boot_on	= 0,
> +	}, {
> +		.name		= "PD_G3D",
> +		.base		= S5P_PMU_G3D_CONF,
> +		.boot_on	= 0,
> +	}, {
...
> +
> +int exynos4210_pd_init(struct exynos4210_pm_domain *domain)
> +{
> +	struct generic_pm_domain *genpd =&domain->genpd;
> +
> +	pm_genpd_init(genpd, NULL, false);
> +
> +	genpd->stop_device = pm_runtime_clk_suspend;
> +	genpd->start_device = pm_runtime_clk_resume;

Have you considered handling the S5P_CLKGATE_BLOCK register to make
sure the clock domains are enabled ? AFAICS it is not properly handled
by current clock API on mach-exynos4. Thus if bootloader clears
S5P_CLKGATE_BLOCK register clocks remain globally masked.

This issue have been attempted to be resolved in this patch:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/commit/39a81876d034dcbdc2a4c4c4b847b3b49e38870c

While at here, it might be good to resolve this either on power domains
or the clock API level.

> +	genpd->power_off = pd_power_down;
> +	genpd->power_on = pd_power_up;
> +
> +	if (domain->boot_on)
> +		pd_power_up(genpd);
> +
> +	return 0;
> +}
> +
> +int exynos4210_add_device_to_domain(struct exynos4210_pm_domain *domain,
> +				struct platform_device *pdev)
> +{
> +	struct device *dev =&pdev->dev;
> +	struct generic_pm_domain *genpd =&domain->genpd;
> +
> +	if (pdev != NULL)
> +		return pm_genpd_add_device(genpd, dev);
> +	else
> +		return -EINVAL;

You could do instead:

+	if (pdev)
+		return pm_genpd_add_device(genpd, dev);
+
+	return -EINVAL;

> +}

--
Regards,
Sylwester
