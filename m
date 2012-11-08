Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2KHLXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 06:23:48 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49706 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab2KHLXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 06:23:42 -0500
MIME-Version: 1.0
In-Reply-To: <00f501cdb733$9c1eed20$d45cc760$%choi@samsung.com>
References: <00f501cdb733$9c1eed20$d45cc760$%choi@samsung.com>
Date: Thu, 8 Nov 2012 16:53:41 +0530
Message-ID: <CAK44p23pb8jXsvbezdG-B2D_U79AH8gy_ummprFFyWX95ozmyg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] thermal: exynos: Fix wrong bit to control tmu core
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: open list <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 31 October 2012 12:17, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> [0]bit is used to enable/disable tmu core. [1] bit is a reserved bit.
>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/thermal/exynos_thermal.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/thermal/exynos_thermal.c
> b/drivers/thermal/exynos_thermal.c
> index fd03e85..6ce6667 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -53,8 +53,8 @@
>  #define EXYNOS_TMU_TRIM_TEMP_MASK      0xff
>  #define EXYNOS_TMU_GAIN_SHIFT          8
>  #define EXYNOS_TMU_REF_VOLTAGE_SHIFT   24
> -#define EXYNOS_TMU_CORE_ON             3
> -#define EXYNOS_TMU_CORE_OFF            2
> +#define EXYNOS_TMU_CORE_ON             1
> +#define EXYNOS_TMU_CORE_OFF            0
Hi Jonghwan,

Only this much change is not sufficient. Also you need to do like below,

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index eebd4e5..4575144 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -52,9 +52,11 @@

 #define EXYNOS_TMU_TRIM_TEMP_MASK      0xff
 #define EXYNOS_TMU_GAIN_SHIFT          8
+#define EXYNOS_TMU_GAIN_MASK           (0xF << 8)
 #define EXYNOS_TMU_REF_VOLTAGE_SHIFT   24
-#define EXYNOS_TMU_CORE_ON             3
-#define EXYNOS_TMU_CORE_OFF            2
+#define EXYNOS_TMU_REF_VOLTAGE_MASK    (0x1F << 24)
+#define EXYNOS_TMU_CORE_ON             1
+#define EXYNOS_TMU_CORE_OFF            0
 #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50

 /* Exynos4210 specific registers */
@@ -85,7 +87,9 @@
 #define EXYNOS_TMU_CLEAR_FALL_INT      (0x111 << 16)
 #define EXYNOS_MUX_ADDR_VALUE          6
 #define EXYNOS_MUX_ADDR_SHIFT          20
+#define EXYNOS_MUX_ADDR_MASK           (0xFF << 16)
 #define EXYNOS_TMU_TRIP_MODE_SHIFT     13
+#define EXYNOS_TMU_TRIP_MODE_MASK      (0x7 << 13)

 #define EFUSE_MIN_VALUE 40
 #define EFUSE_MAX_VALUE 100
@@ -658,10 +662,13 @@ static void exynos_tmu_control(struct
platform_device *pdev, bool on)
        mutex_lock(&data->lock);
        clk_enable(data->clk);

-       con = pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT |
+       con = readl(data->base + EXYNOS_TMU_REG_CONTROL);
+       con &= ~(EXYNOS_TMU_REF_VOLTAGE_MASK | EXYNOS_TMU_GAIN_MASK);
+       con |= pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT |
                pdata->gain << EXYNOS_TMU_GAIN_SHIFT;

        if (data->soc == SOC_ARCH_EXYNOS) {
+               con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
                con |= pdata->noise_cancel_mode << EXYNOS_TMU_TRIP_MODE_SHIFT;
                con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
        }

Thanks,
Amit Daniel

>  #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50
>
>  /* Exynos4210 specific registers */
> --
> 1.7.4.1
>
