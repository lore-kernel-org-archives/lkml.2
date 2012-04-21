Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2DUOE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 10:04:56 -0400
Received: from d1.icnet.pl ([212.160.220.21]:60751 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab2DUOEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 10:04:54 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: linux-omap@vger.kernel.org, grant.likely@secretlab.ca, khilman@ti.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Charulatha V <charu@ti.com>
Subject: Re: [PATCH v9 11/25] gpio/omap: cleanup omap_gpio_mod_init function
Date: Sat, 21 Apr 2012 16:03:36 +0200
Message-ID: <13629551.hP3ZV1ajDo@vclass>
Organization: Tele-Info-System, Poznan, PL
User-Agent: KMail/4.7.4 (Linux/3.1.10-gentoo-r1; KDE/4.7.4; i686; ; )
In-Reply-To: <1328203851-20435-12-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com> <1328203851-20435-12-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 of February 2012 23:00:37 Tarun Kanti DebBarma wrote:
> With register offsets now defined for respective OMAP versions we can get rid
> of cpu_class_* checks. This function now has common initialization code for
> all OMAP versions...
> 
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> Signed-off-by: Charulatha V <charu@ti.com>
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Sorry for being so late with my comment for chanes already present in 
mainline, but this patch breaks GPIO on Amstrad Delta at least, and I 
have neither enough spare time nor enough experience with non OMAP1 
machines to provide a solution myself.

> ---
>  arch/arm/mach-omap1/gpio16xx.c |   35 +++++++++++++++++-
>  drivers/gpio/gpio-omap.c       |   77 ++++++++++++----------------------------
>  2 files changed, 57 insertions(+), 55 deletions(-)
...
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index f39d9e4..a948351 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
...
> @@ -898,62 +896,30 @@ static void __init omap_gpio_show_rev(struct gpio_bank *bank)
>   */
>  static struct lock_class_key gpio_lock_class;
>  
> -/* TODO: Cleanup cpu_is_* checks */
>  static void omap_gpio_mod_init(struct gpio_bank *bank)
>  {
> -	if (cpu_class_is_omap2()) {
> -		if (cpu_is_omap44xx()) {
> -			__raw_writel(0xffffffff, bank->base +
> -					OMAP4_GPIO_IRQSTATUSCLR0);
> -			__raw_writel(0x00000000, bank->base +
> -					 OMAP4_GPIO_DEBOUNCENABLE);
> -			/* Initialize interface clk ungated, module enabled */
> -			__raw_writel(0, bank->base + OMAP4_GPIO_CTRL);
> -		} else if (cpu_is_omap34xx()) {
> -			__raw_writel(0x00000000, bank->base +
> -					OMAP24XX_GPIO_IRQENABLE1);
> -			__raw_writel(0xffffffff, bank->base +
> -					OMAP24XX_GPIO_IRQSTATUS1);
> -			__raw_writel(0x00000000, bank->base +
> -					OMAP24XX_GPIO_DEBOUNCE_EN);
> -
> -			/* Initialize interface clk ungated, module enabled */
> -			__raw_writel(0, bank->base + OMAP24XX_GPIO_CTRL);
> -		}
> -	} else if (cpu_class_is_omap1()) {
> -		if (bank_is_mpuio(bank)) {
> -			__raw_writew(0xffff, bank->base +
> -				OMAP_MPUIO_GPIO_MASKIT / bank->stride);
> -			mpuio_init(bank);
> -		}
> -		if (cpu_is_omap15xx() && bank->method == METHOD_GPIO_1510) {
> -			__raw_writew(0xffff, bank->base
> -						+ OMAP1510_GPIO_INT_MASK);
> -			__raw_writew(0x0000, bank->base
> -						+ OMAP1510_GPIO_INT_STATUS);
> -		}
> -		if (cpu_is_omap16xx() && bank->method == METHOD_GPIO_1610) {
> -			__raw_writew(0x0000, bank->base
> -						+ OMAP1610_GPIO_IRQENABLE1);
> -			__raw_writew(0xffff, bank->base
> -						+ OMAP1610_GPIO_IRQSTATUS1);
> -			__raw_writew(0x0014, bank->base
> -						+ OMAP1610_GPIO_SYSCONFIG);
> +	void __iomem *base = bank->base;
> +	u32 l = 0xffffffff;
>  
> -			/*
> -			 * Enable system clock for GPIO module.
> -			 * The CAM_CLK_CTRL *is* really the right place.
> -			 */
> -			omap_writel(omap_readl(ULPD_CAM_CLK_CTRL) | 0x04,
> -						ULPD_CAM_CLK_CTRL);
> -		}
> -		if (cpu_is_omap7xx() && bank->method == METHOD_GPIO_7XX) {
> -			__raw_writel(0xffffffff, bank->base
> -						+ OMAP7XX_GPIO_INT_MASK);
> -			__raw_writel(0x00000000, bank->base
> -						+ OMAP7XX_GPIO_INT_STATUS);
> -		}
> +	if (bank->width == 16)
> +		l = 0xffff;
> +
> +	if (bank_is_mpuio(bank)) {
> +		__raw_writel(l, bank->base + bank->regs->irqenable);
> +		return;
>  	}
> +
> +	_gpio_rmw(base, bank->regs->irqenable, l, bank->regs->irqenable_inv);
> +	_gpio_rmw(base, bank->regs->irqstatus, l,
> +					bank->regs->irqenable_inv == false);
> +	_gpio_rmw(base, bank->regs->irqenable, l, bank->regs->debounce_en != 0);
> +	_gpio_rmw(base, bank->regs->irqenable, l, bank->regs->ctrl != 0);

bank->regs->irqenable trgister is manipulated 3 times in a row, each 
time based on different criteria. This breaks GPIO on Amstrad Delta at 
least, and generally looks wrong. I was only able to verify that 
commenting out the above two lines fixes the issue with Amstrad Delta for 
me.

> +	if (bank->regs->debounce_en)
> +		_gpio_rmw(base, bank->regs->debounce_en, 0, 1);

This also looks suspicious, I guess the second line should rather be:

		_gpio_rmw(base, bank->regs->debounce, 0, 1);

> +
> +	 /* Initialize interface clk ungated, module enabled */
> +	if (bank->regs->ctrl)
> +		_gpio_rmw(base, bank->regs->ctrl, 0, 1);

Is bank->regs->ctrl a flag, or a register offset? If the latter, is that 
offset guaranteed to never take a valid value of 0?

Thanks,
Janusz
