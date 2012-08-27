Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2H0XFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:05:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39875 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab2H0XFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:05:17 -0400
Date: Tue, 28 Aug 2012 07:05:13 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: HACHIMI Samir <shachimi@adeneo-embedded.com>
Cc: thierry.reding@avionic-design.de, linux-arm-kernel@lists.infradead.org,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Enable Stop_enable mode during configuration of
 pwm.
Message-ID: <20120827230511.GG2281@r65073-Latitude-D630>
References: <1346081672-27866-1-git-send-email-shachimi@adeneo-embedded.com>
 <3465D313FDFB824F9A9C8CD24FA4F6BCB4ACFE@frontmail.adetel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3465D313FDFB824F9A9C8CD24FA4F6BCB4ACFE@frontmail.adetel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 05:34:32PM +0200, HACHIMI Samir wrote:
> From: Samir Hachimi <shachimi@adeneo-embedded.com>
> 
>  Enable Stop_enable mode during configuration of pwm.
>  Check architecture by looking in driver_data instead of cpu_is_xxx.

It does 2 things, and should be split into 2 patches.  Also you should
have a better commit log for the thing you are doing.  For example, why
you need to enable STOPEN during configuration, what problem you are
running into without doing so, etc.

> 
> Signed-off-by: Samir Hachimi <shachimi@adeneo-embedded.com>
> ---
>  drivers/pwm/pwm-imx.c |   59 +++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 43 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
> index 0519bf2..7df919f 100644
> --- a/drivers/pwm/pwm-imx.c
> +++ b/drivers/pwm/pwm-imx.c
> @@ -32,6 +32,7 @@
>  #define MX3_PWMSAR                0x0C    /* PWM Sample Register */
>  #define MX3_PWMPR                 0x10    /* PWM Period Register */
>  #define MX3_PWMCR_PRESCALER(x)    (((x - 1) & 0xFFF) << 4)
> +#define MX3_PWMCR_STOPEN		(1 << 25)
>  #define MX3_PWMCR_DOZEEN                (1 << 24)
>  #define MX3_PWMCR_WAITEN                (1 << 23)
>  #define MX3_PWMCR_DBGEN			(1 << 22)
> @@ -39,6 +40,16 @@
>  #define MX3_PWMCR_CLKSRC_IPG      (1 << 16)
>  #define MX3_PWMCR_EN              (1 << 0)
>  
> +/* Use the platform_id to distinguish different Archs. */
> +#define IS_MX1			0x0
> +#define IS_MX21			0x1
> +#define IS_MX25			0x2
> +#define IS_MX6Q			0x3

I prefer to use enum for these ...

> +#define PWM_IS_MX1(x)		((x)->id_entry->driver_data == IS_MX1)
> +#define PWM_IS_MX21(x)		((x)->id_entry->driver_data == IS_MX21)
> +#define PWM_IS_MX25(x)		((x)->id_entry->driver_data == IS_MX25)
> +#define PWM_IS_MX6Q(x)		((x)->id_entry->driver_data == IS_MX6Q)
> +

... and inline function for these.  drivers/mmc/host/sdhci-esdhc-imx.c
could be an example here.

Also, I see PWM_IS_MX6Q used nowhere, which probably means the pwm on
imx6q is compatible with imx25 one, and we should not introduce MX6Q
type at all.

>  struct imx_chip {
>  	struct clk	*clk;
>  
> @@ -46,6 +57,7 @@ struct imx_chip {
>  	void __iomem	*mmio_base;
>  
>  	struct pwm_chip	chip;
> +	struct platform_device	*pdev;
>  };
>  
>  #define to_imx_chip(chip)	container_of(chip, struct imx_chip, chip)
> @@ -65,7 +77,7 @@ static int imx_pwm_config(struct pwm_chip *chip,
>  			return rc;
>  	}
>  
> -	if (!(cpu_is_mx1() || cpu_is_mx21())) {
> +	if (!(PWM_IS_MX1(imx->pdev) || PWM_IS_MX21(imx->pdev))) {
>  		unsigned long long c;
>  		unsigned long period_cycles, duty_cycles, prescale;
>  		u32 cr;
> @@ -78,36 +90,33 @@ static int imx_pwm_config(struct pwm_chip *chip,
>  		prescale = period_cycles / 0x10000 + 1;
>  
>  		period_cycles /= prescale;
> -		c = (unsigned long long)period_cycles * duty_ns;
> -		do_div(c, period_ns);
> -		duty_cycles = c;
>  
> -		/*
> -		 * according to imx pwm RM, the real period value should be
> -		 * PERIOD value in PWMPR plus 2.
> +		/* the chip documentation says the counter counts up to
> +		 * period_cycles + 1 and then is reset to 0, so the
> +		 *  actual period of the PWM wave is period_cycles + 2
>  		 */
> -		if (period_cycles > 2)
> -			period_cycles -= 2;
> -		else
> -			period_cycles = 0;
> +		c = (unsigned long long)(period_cycles + 2) * duty_ns;
> +		do_div(c, period_ns);
> +		duty_cycles = c;
>  
>  		writel(duty_cycles, imx->mmio_base + MX3_PWMSAR);
>  		writel(period_cycles, imx->mmio_base + MX3_PWMPR);
>  
>  		cr = MX3_PWMCR_PRESCALER(prescale) |
> -			MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN | MX3_PWMCR_DBGEN;
> +			MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
> +			MX3_PWMCR_DBGEN | MX3_PWMCR_STOPEN;
>  
>  		/* If the PWM is enabled, keep it so. */
>  		if (imx->clk_enabled)
>  			cr |= MX3_PWMCR_EN;
>  
> -		if (cpu_is_mx25())
> +		if (PWM_IS_MX25(imx->pdev))
>  			cr |= MX3_PWMCR_CLKSRC_IPG;
>  		else
>  			cr |= MX3_PWMCR_CLKSRC_IPG_HIGH;
>  
>  		writel(cr, imx->mmio_base + MX3_PWMCR);
> -	} else if (cpu_is_mx1() || cpu_is_mx21()) {
> +	} else if (PWM_IS_MX1(imx->pdev) || PWM_IS_MX21(imx->pdev)) {
>  		/* The PWM subsystem allows for exact frequencies. However,
>  		 * I cannot connect a scope on my device to the PWM line and
>  		 * thus cannot provide the program the PWM controller
> @@ -150,7 +159,7 @@ static int imx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>  	if (rc)
>  		return rc;
>  
> -	if (!(cpu_is_mx1() || cpu_is_mx21())) {
> +	if (!(PWM_IS_MX1(imx->pdev) || PWM_IS_MX21(imx->pdev))) {
>  		u32 cr = readl(imx->mmio_base + MX3_PWMCR);
>  		cr |= MX3_PWMCR_EN;
>  		writel(cr, imx->mmio_base + MX3_PWMCR);
> @@ -167,7 +176,7 @@ static void imx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>  	if (!imx->clk_enabled)
>  		return;
>  
> -	if (!(cpu_is_mx1() || cpu_is_mx21())) {
> +	if (!(PWM_IS_MX1(imx->pdev) || PWM_IS_MX21(imx->pdev))) {
>  		u32 cr = readl(imx->mmio_base + MX3_PWMCR);
>  		cr &= ~MX3_PWMCR_EN;
>  		writel(cr, imx->mmio_base + MX3_PWMCR);
> @@ -207,6 +216,7 @@ static int __devinit imx_pwm_probe(struct platform_device *pdev)
>  	imx->chip.npwm = 1;
>  
>  	imx->clk_enabled = 0;
> +	imx->pdev = pdev;
>  
>  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (r == NULL) {
> @@ -237,9 +247,26 @@ static int __devexit imx_pwm_remove(struct platform_device *pdev)
>  	return pwmchip_remove(&imx->chip);
>  }
>  
> +static const struct platform_device_id pwm_ids[] = {
> +	{ .name = "imx1-pwm", .driver_data = IS_MX1, },
> +	{ .name = "imx21-pwm", .driver_data = IS_MX21, },
> +	{ .name = "imx25-pwm", .driver_data = IS_MX25, },
> +	{ .name = "imx6q-pwm", .driver_data = IS_MX6Q, },
> +	{},
> +};

You are not using the table as .id_table of imx_pwm_driver, so these
PWM_IS_xxx stuff does not work at all.  Also, changing to use
platform_device_id will require updates to machine code that registers
platform_device for non-DT case.

> +
> +static const struct of_device_id mxc_pwm_dt_ids[] = {
> +	{
> +		.compatible = "fsl,imx6q-pwm",
> +		.data = (void *)&pwm_ids[IS_MX6Q]
> +	},
> +	{ /* sentinel */ }
> +};
> +
>  static struct platform_driver imx_pwm_driver = {
>  	.driver		= {
>  		.name	= "mxc_pwm",
> +		.of_match_table = of_match_ptr(mxc_pwm_dt_ids),
>  	},
>  	.probe		= imx_pwm_probe,
>  	.remove		= __devexit_p(imx_pwm_remove),
> -- 
> 1.7.1

-- 
Regards,
Shawn
