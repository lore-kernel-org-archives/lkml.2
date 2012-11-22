Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2KVSo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:44:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:28343 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab2KVSoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:44:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,297,1352102400"; 
   d="scan'208";a="245619042"
Message-ID: <1353550728.2172.10.camel@rzhang1-mobl4>
Subject: Re: [PATCH v3 1/2] thermal: exynos: Fix wrong bit to control tmu
 core
From: Zhang Rui <rui.zhang@intel.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: "'open list'" <linux-kernel@vger.kernel.org>,
        "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Date: Thu, 22 Nov 2012 10:18:48 +0800
In-Reply-To: <007301cdc6ba$067107e0$135317a0$%choi@samsung.com>
References: <007301cdc6ba$067107e0$135317a0$%choi@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 09:57 +0900, Jonghwan Choi wrote:
> [0]bit is used to enable/disable tmu core. [1] bit is a reserved bit.
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>

I don't know why but the patch format seems to be a mess.
please resend the patch.

thanks,
rui
> ---
>  drivers/thermal/exynos_thermal.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/thermal/exynos_thermal.c
> b/drivers/thermal/exynos_thermal.c
> index 6dd29e4..129e827 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -52,9 +52,12 @@
> 
>  #define EXYNOS_TMU_TRIM_TEMP_MASK      0xff
>  #define EXYNOS_TMU_GAIN_SHIFT          8
> +#define EXYNOS_TMU_GAIN_MASK           (0xF << EXYNOS_TMU_GAIN_SHIFT)
>  #define EXYNOS_TMU_REF_VOLTAGE_SHIFT   24
> -#define EXYNOS_TMU_CORE_ON             3
> -#define EXYNOS_TMU_CORE_OFF            2
> +#define EXYNOS_TMU_REF_VOLTAGE_MASK    (0x1F <<
> EXYNOS_TMU_REF_VOLTAGE_SHIFT)
> +#define EXYNOS_TMU_CORE_ON             BIT(0)
> +#define EXYNOS_TMU_CORE_ON_SHIFT       0
> +#define EXYNOS_TMU_CORE_ON_MASK                (0x1 <<
> EXYNOS_TMU_CORE_ON_SHIFT)
>  #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50
> 
>  /* Exynos4210 specific registers */
> @@ -85,7 +88,9 @@
>  #define EXYNOS_TMU_CLEAR_FALL_INT      (0x111 << 16)
>  #define EXYNOS_MUX_ADDR_VALUE          6
>  #define EXYNOS_MUX_ADDR_SHIFT          20
> +#define EXYNOS_MUX_ADDR_MASK           (0x7 << EXYNOS_MUX_ADDR_SHIFT)
>  #define EXYNOS_TMU_TRIP_MODE_SHIFT     13
> +#define EXYNOS_TMU_TRIP_MODE_MASK      (0x7 << EXYNOS_TMU_TRIP_MODE_SHIFT)
> 
>  #define EFUSE_MIN_VALUE 40
>  #define EFUSE_MAX_VALUE 100
> @@ -650,10 +655,14 @@ static void exynos_tmu_control(struct platform_device
> *pdev, bool on)
>         mutex_lock(&data->lock);
>         clk_enable(data->clk);
> 
> -       con = pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT |
> +       con = readl(data->base + EXYNOS_TMU_REG_CONTROL);
> +       con &= ~(EXYNOS_TMU_REF_VOLTAGE_MASK | EXYNOS_TMU_GAIN_MASK |
> +               EXYNOS_TMU_CORE_ON_MASK);
> +       con |= pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT |
>                 pdata->gain << EXYNOS_TMU_GAIN_SHIFT;
> 
>         if (data->soc == SOC_ARCH_EXYNOS) {
> +               con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
>                 con |= pdata->noise_cancel_mode <<
> EXYNOS_TMU_TRIP_MODE_SHIFT;
>                 con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
>         }
> @@ -665,7 +674,6 @@ static void exynos_tmu_control(struct platform_device
> *pdev, bool on)
>                         pdata->trigger_level1_en << 4 |
>                         pdata->trigger_level0_en;
>         } else {
> -               con |= EXYNOS_TMU_CORE_OFF;
>                 interrupt_en = 0; /* Disable all interrupts */
>         }
>         writel(interrupt_en, data->base + EXYNOS_TMU_REG_INTEN);
> --
> 1.7.4.1
> 


