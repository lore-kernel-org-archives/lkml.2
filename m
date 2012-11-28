Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab2K1LVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 06:21:12 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49206 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab2K1LVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 06:21:10 -0500
MIME-Version: 1.0
In-Reply-To: <000101cdcb75$c03344d0$4099ce70$%choi@samsung.com>
References: <000101cdcb75$c03344d0$4099ce70$%choi@samsung.com>
Date: Wed, 28 Nov 2012 16:51:09 +0530
Message-ID: <CAK44p21a0A8SZei5-uX2LG0mScbz54hWAZW_7nV-BWx+5xOCLw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] therma: exynos: Supports thermal tripping
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2012 07:01, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> TMU urgently sends active-high signal (thermal trip) to PMU,
> and thermal tripping by hardware logic i.e PMU is performed.
> Thermal tripping means that PMU cut off the whole power of SoC
> by controlling external voltage regulator.
>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/thermal/exynos_thermal.c |   21 +++++++++++++++++----
>  1 files changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/thermal/exynos_thermal.c
> b/drivers/thermal/exynos_thermal.c
> index 129e827..f0ce099 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -631,6 +631,12 @@ static int exynos_tmu_initialize(struct platform_device
> *pdev)
>                         goto out;
>                 }
>                 rising_threshold |= (threshold_code << 16);
> +               threshold_code = temp_to_code(data,
> pdata->trigger_levels[3]);
> +               if (threshold_code < 0) {
> +                       ret = threshold_code;
> +                       goto out;
> +               }
> +               rising_threshold |= (threshold_code << 24);
>
>                 writel(rising_threshold,
>                                 data->base + EXYNOS_THD_TEMP_RISE);
> @@ -669,10 +675,14 @@ static void exynos_tmu_control(struct platform_device
> *pdev, bool on)
>
>         if (on) {
>                 con |= EXYNOS_TMU_CORE_ON;
> -               interrupt_en = pdata->trigger_level3_en << 12 |
> -                       pdata->trigger_level2_en << 8 |
> +               interrupt_en = pdata->trigger_level2_en << 8 |
>                         pdata->trigger_level1_en << 4 |
>                         pdata->trigger_level0_en;
> +
> +               if (data->soc == SOC_ARCH_EXYNOS4210)
> +                       interrupt_en |= pdata->trigger_level3_en << 12;
> +               else
> +                       con |= pdata->trigger_level3_en << 12;
>         } else {
>                 interrupt_en = 0; /* Disable all interrupts */
>         }
> @@ -770,6 +780,7 @@ static struct exynos_tmu_platform_data const
> exynos_default_tmu_data = {
>         .trigger_levels[0] = 85,
>         .trigger_levels[1] = 103,
>         .trigger_levels[2] = 110,
> +       .trigger_levels[3] = 120,
>         .trigger_level0_en = 1,
>         .trigger_level1_en = 1,
>         .trigger_level2_en = 1,
> @@ -917,8 +928,10 @@ static int __devinit exynos_tmu_probe(struct
> platform_device *pdev)
>         /* Register the sensor with thermal management interface */
>         (&exynos_sensor_conf)->private_data = data;
>         exynos_sensor_conf.trip_data.trip_count = pdata->trigger_level0_en +
> -                       pdata->trigger_level1_en + pdata->trigger_level2_en
> +
> -                       pdata->trigger_level3_en;
> +                       pdata->trigger_level1_en + pdata->trigger_level2_en;
> +
> +       if (data->soc == SOC_ARCH_EXYNOS4210)
> +               exynos_sensor_conf.trip_data.trip_count +=
> pdata->trigger_level3_en;

Hi Choi,

Your changes looks fine but I guess we are changing a common code. I
(Along with  jonghwa3.lee@samsung.com ) have submitted a patchset
which will simplify this and now this 4th trip point code addition for
exynos4210 will be mostly platform data addition, So let Zhang Ru
comment on my changes because this will cause merge conflict.

Thanks,
Amit D
>
>         for (i = 0; i < exynos_sensor_conf.trip_data.trip_count; i++)
>                 exynos_sensor_conf.trip_data.trip_val[i] =
> --
> 1.7.4.1
>
