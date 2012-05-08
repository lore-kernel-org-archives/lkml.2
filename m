Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab2EHUQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:16:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab2EHUQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:16:46 -0400
Date: Tue, 8 May 2012 13:16:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, durgadoss.r@intel.com,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v3 6/6] ARM: exynos: Add thermal sensor driver platform
 data support
Message-Id: <20120508131644.e2e92f3e.akpm@linux-foundation.org>
In-Reply-To: <1336493898-7039-7-git-send-email-amit.kachhap@linaro.org>
References: <1336493898-7039-1-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-2-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-3-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-4-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-5-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-6-git-send-email-amit.kachhap@linaro.org>
	<1336493898-7039-7-git-send-email-amit.kachhap@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 May 2012 21:48:18 +0530
Amit Daniel Kachhap <amit.kachhap@linaro.org> wrote:

> This patch adds necessary default platform data support needed for TMU driver.
> This dt/non-dt values are tested for origen exynos4210 and smdk exynos5250 platforms.
> 
>
> ...
>
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -646,14 +646,117 @@ static irqreturn_t exynos_tmu_irq(int irq, void *id)
>  static struct thermal_sensor_conf exynos_sensor_conf = {
>  	.name			= "exynos-therm",
>  	.read_temperature	= (int (*)(void *))exynos_tmu_read,
> +};
> +
> +#if defined(CONFIG_CPU_EXYNOS4210)
> +static struct exynos_tmu_platform_data exynos4_default_tmu_data = {

Again, make it const if possible.

> +	.threshold = 80,
> +	.trigger_levels[0] = 5,
> +	.trigger_levels[1] = 20,
> +	.trigger_levels[2] = 30,
> +	.trigger_level0_en = 1,
> +	.trigger_level1_en = 1,
> +	.trigger_level2_en = 1,
> +	.trigger_level3_en = 0,
> +	.gain = 15,
> +	.reference_voltage = 7,
> +	.cal_type = TYPE_ONE_POINT_TRIMMING,
> +	.freq_tab[0] = {
> +		.freq_clip_max = 800 * 1000,
> +	},
> +	.freq_tab[1] = {
> +		.freq_clip_max = 200 * 1000,
> +	},
> +	.freq_tab_count = 2,
> +	.type = SOC_ARCH_EXYNOS4,
> +};
> +#define EXYNOS4_TMU_DRV_DATA ((kernel_ulong_t)&exynos4_default_tmu_data)
> +#else
> +#define EXYNOS4_TMU_DRV_DATA ((kernel_ulong_t)NULL)
> +#endif

See below.

> +#if defined(CONFIG_SOC_EXYNOS5250)
> +static struct exynos_tmu_platform_data exynos5_default_tmu_data = {
> +	.trigger_levels[0] = 85,
> +	.trigger_levels[1] = 103,
> +	.trigger_levels[2] = 110,
> +	.trigger_level0_en = 1,
> +	.trigger_level1_en = 1,
> +	.trigger_level2_en = 1,
> +	.trigger_level3_en = 0,
> +	.gain = 8,
> +	.reference_voltage = 16,
> +	.noise_cancel_mode = 4,
> +	.cal_type = TYPE_ONE_POINT_TRIMMING,
> +	.efuse_value = 55,
> +	.freq_tab[0] = {
> +		.freq_clip_max = 800 * 1000,
> +	},
> +	.freq_tab[1] = {
> +		.freq_clip_max = 200 * 1000,
> +	},
> +	.freq_tab_count = 2,
> +	.type = SOC_ARCH_EXYNOS5,
> +};
> +#define EXYNOS5_TMU_DRV_DATA ((kernel_ulong_t)&exynos5_default_tmu_data)

The use of kernel_ulong_t is unexpected.

I suspect you could remove this cast altogether.  Or make it void*.

> +#else
> +#define EXYNOS5_TMU_DRV_DATA ((kernel_ulong_t)NULL)

And remove this cast too.  Rely upon void* magic.

> +#endif
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id exynos_tmu_match[] = {
> +	{
> +		.compatible = "samsung,exynos4-tmu",
> +		.data = (void *)EXYNOS4_TMU_DRV_DATA,

No cast is needed if EXYNOS4_TMU_DRV_DATA has a pointer type.

> +	},
> +	{
> +		.compatible = "samsung,exynos5-tmu",
> +		.data = (void *)EXYNOS5_TMU_DRV_DATA,

No cast is needed if EXYNOS4_TMU_DRV_DATA has a pointer type.

> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_tmu_match);
> +#else
> +#define  exynos_tmu_match NULL
> +#endif
> +
>
> ...
>

