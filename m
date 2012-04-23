Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab2DWS7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:59:47 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:45906 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236Ab2DWS7q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:59:46 -0400
MIME-Version: 1.0
In-Reply-To: <13629551.hP3ZV1ajDo@vclass>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
	<1328203851-20435-12-git-send-email-tarun.kanti@ti.com>
	<13629551.hP3ZV1ajDo@vclass>
Date: Tue, 24 Apr 2012 00:24:26 +0530
Message-ID: <CAC83ZvK630=6B-k2TfV3XBg8w7ZosLVDNE4ezjDYnn=hcXA48Q@mail.gmail.com>
Subject: Re: [PATCH v9 11/25] gpio/omap: cleanup omap_gpio_mod_init function
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-omap@vger.kernel.org, grant.likely@secretlab.ca, khilman@ti.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Charulatha V <charu@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 7:33 PM, Janusz Krzysztofik
<jkrzyszt@tis.icnet.pl> wrote:
> On Thursday 02 of February 2012 23:00:37 Tarun Kanti DebBarma wrote:
>> With register offsets now defined for respective OMAP versions we can get rid
>> of cpu_class_* checks. This function now has common initialization code for
>> all OMAP versions...
>>
>> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
>> Signed-off-by: Charulatha V <charu@ti.com>
>> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Acked-by: Tony Lindgren <tony@atomide.com>
>
> Sorry for being so late with my comment for chanes already present in
> mainline, but this patch breaks GPIO on Amstrad Delta at least, and I
> have neither enough spare time nor enough experience with non OMAP1
> machines to provide a solution myself.
Yes, I looked at the omap_gpio_mod_init() and OMAP1 configurations are
overwritten.
Also looks like there is issue in making distinction between omap15xx
and omap16xx.
I will post a patch and you can help me testing it in OMAP1 platform.
Thanks for pointing this out.
--
Tarun
>
>> ---
>>  arch/arm/mach-omap1/gpio16xx.c |   35 +++++++++++++++++-
>>  drivers/gpio/gpio-omap.c       |   77 ++++++++++++----------------------------
>>  2 files changed, 57 insertions(+), 55 deletions(-)
> ...
>> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
>> index f39d9e4..a948351 100644
>> --- a/drivers/gpio/gpio-omap.c
>> +++ b/drivers/gpio/gpio-omap.c
> ...
>> @@ -898,62 +896,30 @@ static void __init omap_gpio_show_rev(struct gpio_bank *bank)
>>   */
>>  static struct lock_class_key gpio_lock_class;
>>
>> -/* TODO: Cleanup cpu_is_* checks */
>>  static void omap_gpio_mod_init(struct gpio_bank *bank)
>>  {
>> -     if (cpu_class_is_omap2()) {
>> -             if (cpu_is_omap44xx()) {
>> -                     __raw_writel(0xffffffff, bank->base +
>> -                                     OMAP4_GPIO_IRQSTATUSCLR0);
>> -                     __raw_writel(0x00000000, bank->base +
>> -                                      OMAP4_GPIO_DEBOUNCENABLE);
>> -                     /* Initialize interface clk ungated, module enabled */
>> -                     __raw_writel(0, bank->base + OMAP4_GPIO_CTRL);
>> -             } else if (cpu_is_omap34xx()) {
>> -                     __raw_writel(0x00000000, bank->base +
>> -                                     OMAP24XX_GPIO_IRQENABLE1);
>> -                     __raw_writel(0xffffffff, bank->base +
>> -                                     OMAP24XX_GPIO_IRQSTATUS1);
>> -                     __raw_writel(0x00000000, bank->base +
>> -                                     OMAP24XX_GPIO_DEBOUNCE_EN);
>> -
>> -                     /* Initialize interface clk ungated, module enabled */
>> -                     __raw_writel(0, bank->base + OMAP24XX_GPIO_CTRL);
>> -             }
>> -     } else if (cpu_class_is_omap1()) {
>> -             if (bank_is_mpuio(bank)) {
>> -                     __raw_writew(0xffff, bank->base +
>> -                             OMAP_MPUIO_GPIO_MASKIT / bank->stride);
>> -                     mpuio_init(bank);
>> -             }
>> -             if (cpu_is_omap15xx() && bank->method == METHOD_GPIO_1510) {
>> -                     __raw_writew(0xffff, bank->base
>> -                                             + OMAP1510_GPIO_INT_MASK);
>> -                     __raw_writew(0x0000, bank->base
>> -                                             + OMAP1510_GPIO_INT_STATUS);
>> -             }
>> -             if (cpu_is_omap16xx() && bank->method == METHOD_GPIO_1610) {
>> -                     __raw_writew(0x0000, bank->base
>> -                                             + OMAP1610_GPIO_IRQENABLE1);
>> -                     __raw_writew(0xffff, bank->base
>> -                                             + OMAP1610_GPIO_IRQSTATUS1);
>> -                     __raw_writew(0x0014, bank->base
>> -                                             + OMAP1610_GPIO_SYSCONFIG);
>> +     void __iomem *base = bank->base;
>> +     u32 l = 0xffffffff;
>>
>> -                     /*
>> -                      * Enable system clock for GPIO module.
>> -                      * The CAM_CLK_CTRL *is* really the right place.
>> -                      */
>> -                     omap_writel(omap_readl(ULPD_CAM_CLK_CTRL) | 0x04,
>> -                                             ULPD_CAM_CLK_CTRL);
>> -             }
>> -             if (cpu_is_omap7xx() && bank->method == METHOD_GPIO_7XX) {
>> -                     __raw_writel(0xffffffff, bank->base
>> -                                             + OMAP7XX_GPIO_INT_MASK);
>> -                     __raw_writel(0x00000000, bank->base
>> -                                             + OMAP7XX_GPIO_INT_STATUS);
>> -             }
>> +     if (bank->width == 16)
>> +             l = 0xffff;
>> +
>> +     if (bank_is_mpuio(bank)) {
>> +             __raw_writel(l, bank->base + bank->regs->irqenable);
>> +             return;
>>       }
>> +
>> +     _gpio_rmw(base, bank->regs->irqenable, l, bank->regs->irqenable_inv);
>> +     _gpio_rmw(base, bank->regs->irqstatus, l,
>> +                                     bank->regs->irqenable_inv == false);
>> +     _gpio_rmw(base, bank->regs->irqenable, l, bank->regs->debounce_en != 0);
>> +     _gpio_rmw(base, bank->regs->irqenable, l, bank->regs->ctrl != 0);
>
> bank->regs->irqenable trgister is manipulated 3 times in a row, each
> time based on different criteria. This breaks GPIO on Amstrad Delta at
> least, and generally looks wrong. I was only able to verify that
> commenting out the above two lines fixes the issue with Amstrad Delta for
> me.
>
>> +     if (bank->regs->debounce_en)
>> +             _gpio_rmw(base, bank->regs->debounce_en, 0, 1);
>
> This also looks suspicious, I guess the second line should rather be:
>
>                _gpio_rmw(base, bank->regs->debounce, 0, 1);
>
>> +
>> +      /* Initialize interface clk ungated, module enabled */
>> +     if (bank->regs->ctrl)
>> +             _gpio_rmw(base, bank->regs->ctrl, 0, 1);
>
> Is bank->regs->ctrl a flag, or a register offset? If the latter, is that
> offset guaranteed to never take a valid value of 0?
>
> Thanks,
> Janusz
