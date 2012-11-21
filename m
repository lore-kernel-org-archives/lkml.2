Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab2KUJqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:46:21 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53174 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2KUJqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:46:18 -0500
MIME-Version: 1.0
In-Reply-To: <1353390792.3833.1.camel@rzhang1-mobl4>
References: <007301cdc6ba$067107e0$135317a0$%choi@samsung.com>
	<CAH9JG2UYsQ6VFMO4COyEr9fBzCL03+37bXTN=AgjKbD7NjR1MA@mail.gmail.com>
	<1353390792.3833.1.camel@rzhang1-mobl4>
Date: Wed, 21 Nov 2012 15:16:17 +0530
Message-ID: <CAK44p20ko1cqiVkYc4-4W9RN01kwfffnDf9-fNdPZt+oOF9igQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] thermal: exynos: Fix wrong bit to control tmu core
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        "jonghwa3.lee" <jonghwa3.lee@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>, dg77.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2012 11:23, Zhang Rui <rui.zhang@intel.com> wrote:
> On Tue, 2012-11-20 at 10:39 +0900, Kyungmin Park wrote:
>> On 11/20/12, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
>> > [0]bit is used to enable/disable tmu core. [1] bit is a reserved bit.
>> >
>> > Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> Amit and Donggeun Kim,
>
> any comments on this patch?
>
> thanks,
> rui
Hi Riu,

This patch is according to the suggestion I made earlier and looks fine.
Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Thanks,
Amit Daniel
>
>> > ---
>> >  drivers/thermal/exynos_thermal.c |   16 ++++++++++++----
>> >  1 files changed, 12 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/drivers/thermal/exynos_thermal.c
>> > b/drivers/thermal/exynos_thermal.c
>> > index 6dd29e4..129e827 100644
>> > --- a/drivers/thermal/exynos_thermal.c
>> > +++ b/drivers/thermal/exynos_thermal.c
>> > @@ -52,9 +52,12 @@
>> >
>> >  #define EXYNOS_TMU_TRIM_TEMP_MASK      0xff
>> >  #define EXYNOS_TMU_GAIN_SHIFT          8
>> > +#define EXYNOS_TMU_GAIN_MASK           (0xF << EXYNOS_TMU_GAIN_SHIFT)
>> >  #define EXYNOS_TMU_REF_VOLTAGE_SHIFT   24
>> > -#define EXYNOS_TMU_CORE_ON             3
>> > -#define EXYNOS_TMU_CORE_OFF            2
>> > +#define EXYNOS_TMU_REF_VOLTAGE_MASK    (0x1F <<
>> > EXYNOS_TMU_REF_VOLTAGE_SHIFT)
>> > +#define EXYNOS_TMU_CORE_ON             BIT(0)
>> > +#define EXYNOS_TMU_CORE_ON_SHIFT       0
>> > +#define EXYNOS_TMU_CORE_ON_MASK                (0x1 <<
>> > EXYNOS_TMU_CORE_ON_SHIFT)
>> >  #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50
>> >
>> >  /* Exynos4210 specific registers */
>> > @@ -85,7 +88,9 @@
>> >  #define EXYNOS_TMU_CLEAR_FALL_INT      (0x111 << 16)
>> >  #define EXYNOS_MUX_ADDR_VALUE          6
>> >  #define EXYNOS_MUX_ADDR_SHIFT          20
>> > +#define EXYNOS_MUX_ADDR_MASK           (0x7 << EXYNOS_MUX_ADDR_SHIFT)
>> >  #define EXYNOS_TMU_TRIP_MODE_SHIFT     13
>> > +#define EXYNOS_TMU_TRIP_MODE_MASK      (0x7 << EXYNOS_TMU_TRIP_MODE_SHIFT)
>> >
>> >  #define EFUSE_MIN_VALUE 40
>> >  #define EFUSE_MAX_VALUE 100
>> > @@ -650,10 +655,14 @@ static void exynos_tmu_control(struct platform_device
>> > *pdev, bool on)
>> >         mutex_lock(&data->lock);
>> >         clk_enable(data->clk);
>> >
>> > -       con = pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT |
>> > +       con = readl(data->base + EXYNOS_TMU_REG_CONTROL);
>> > +       con &= ~(EXYNOS_TMU_REF_VOLTAGE_MASK | EXYNOS_TMU_GAIN_MASK |
>> > +               EXYNOS_TMU_CORE_ON_MASK);
>> > +       con |= pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT |
>> >                 pdata->gain << EXYNOS_TMU_GAIN_SHIFT;
>> >
>> >         if (data->soc == SOC_ARCH_EXYNOS) {
>> > +               con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
>> >                 con |= pdata->noise_cancel_mode <<
>> > EXYNOS_TMU_TRIP_MODE_SHIFT;
>> >                 con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
>> >         }
>> > @@ -665,7 +674,6 @@ static void exynos_tmu_control(struct platform_device
>> > *pdev, bool on)
>> >                         pdata->trigger_level1_en << 4 |
>> >                         pdata->trigger_level0_en;
>> >         } else {
>> > -               con |= EXYNOS_TMU_CORE_OFF;
>> >                 interrupt_en = 0; /* Disable all interrupts */
>> >         }
>> >         writel(interrupt_en, data->base + EXYNOS_TMU_REG_INTEN);
>> > --
>> > 1.7.4.1
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>
>
