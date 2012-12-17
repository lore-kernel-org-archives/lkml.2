Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2LQVfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:35:05 -0500
Received: from antcom.de ([188.40.178.216]:57160 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab2LQVfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:35:03 -0500
Message-ID: <50CF8FA9.8050609@antcom.de>
Date: Mon, 17 Dec 2012 22:33:29 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>
CC: rmallon@gmail.com, gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        broonie@opensource.wolfsonmicro.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        daniel-gl@gmx.net, sr@denx.de, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, highguy@gmail.com
Subject: Re: [PATCH RESEND 0/6 v10] gpio: Add block GPIO
References: <1355495185-24220-1-git-send-email-stigge@antcom.de> <50CB68AB.5070806@grandegger.com> <50CBBB25.20002@antcom.de> <50CF03FB.2030100@grandegger.com> <50CF0744.7040404@grandegger.com> <50CF1EF1.2070601@antcom.de> <50CF237E.5020409@antcom.de> <50CF4838.9000401@grandegger.com> <50CF5327.6070205@antcom.de> <50CF584E.1040601@grandegger.com> <50CF5E45.5030104@antcom.de> <50CF76D3.9030708@grandegger.com>
In-Reply-To: <50CF76D3.9030708@grandegger.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/12/12 20:47, Wolfgang Grandegger wrote:
> On 12/17/2012 07:02 PM, Roland Stigge wrote:
>> On 12/17/2012 06:37 PM, Wolfgang Grandegger wrote:
>>> 	/* Do synchronous data output with a single write access */
>>> 	__raw_writel(~mask, pio + PIO_OWDR);
>>> 	__raw_writel(mask, pio + PIO_OWER);
>>> 	__raw_writel(val, pio + PIO_ODSR);
>>>
>>> For caching we would need a storage. Not sure if it's worth compared to
>>> a context switch into the kernel.
>>
>> Block GPIO is not only for you in userspace. ;-) You can also implement
>> efficient n-bit bus I/O in kernel drivers, n-bit-banging. :-) So not
>> always context switches involved.
> 
> OK, what do you think about the following untested patch:

Looks good!

Why "untested"? ;-)

Thanks,

Roland

>>From b44cad16cbbca84715dffd4cb5268497216add25 Mon Sep 17 00:00:00 2001
> From: Wolfgang Grandegger <wg@grandegger.com>
> Date: Mon, 3 Dec 2012 08:31:55 +0100
> Subject: [PATCH 1/2] gpio: add GPIO block callback functions for AT91
> 
> Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
> ---
>  arch/arm/mach-at91/gpio.c |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
> index be42cf0..cf6bd45 100644
> --- a/arch/arm/mach-at91/gpio.c
> +++ b/arch/arm/mach-at91/gpio.c
> @@ -42,13 +42,16 @@ struct at91_gpio_chip {
>  	void __iomem		*regbase;	/* PIO bank virtual address */
>  	struct clk		*clock;		/* associated clock */
>  	struct irq_domain	*domain;	/* associated irq domain */
> +	unsigned long		mask_shadow;	/* synchronous data output */
>  };
>  
>  #define to_at91_gpio_chip(c) container_of(c, struct at91_gpio_chip, chip)
>  
>  static void at91_gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip);
>  static void at91_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val);
> +static void at91_gpiolib_set_block(struct gpio_chip *chip, unsigned long mask, unsigned long val);
>  static int at91_gpiolib_get(struct gpio_chip *chip, unsigned offset);
> +static unsigned long at91_gpiolib_get_block(struct gpio_chip *chip, unsigned long mask);
>  static int at91_gpiolib_direction_output(struct gpio_chip *chip,
>  					 unsigned offset, int val);
>  static int at91_gpiolib_direction_input(struct gpio_chip *chip,
> @@ -62,7 +65,9 @@ static int at91_gpiolib_to_irq(struct gpio_chip *chip, unsigned offset);
>  			.direction_input  = at91_gpiolib_direction_input, \
>  			.direction_output = at91_gpiolib_direction_output, \
>  			.get		  = at91_gpiolib_get,		\
> +			.get_block	  = at91_gpiolib_get_block,	\
>  			.set		  = at91_gpiolib_set,		\
> +			.set_block	  = at91_gpiolib_set_block,	\
>  			.dbg_show	  = at91_gpiolib_dbg_show,	\
>  			.to_irq		  = at91_gpiolib_to_irq,	\
>  			.ngpio		  = nr_gpio,			\
> @@ -896,6 +901,16 @@ static int at91_gpiolib_get(struct gpio_chip *chip, unsigned offset)
>  	return (pdsr & mask) != 0;
>  }
>  
> +static unsigned long at91_gpiolib_get_block(struct gpio_chip *chip, unsigned long mask)
> +{
> +	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> +	void __iomem *pio = at91_gpio->regbase;
> +	u32 pdsr;
> +
> +	pdsr = __raw_readl(pio + PIO_PDSR);
> +	return pdsr & mask;
> +}
> +
>  static void at91_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val)
>  {
>  	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> @@ -905,6 +920,20 @@ static void at91_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val)
>  	__raw_writel(mask, pio + (val ? PIO_SODR : PIO_CODR));
>  }
>  
> +static void at91_gpiolib_set_block(struct gpio_chip *chip, unsigned long mask, unsigned long val)
> +{
> +	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> +	void __iomem *pio = at91_gpio->regbase;
> +
> +	/* Do synchronous data output with a single write access */
> +	if (mask != at91_gpio->mask_shadow) {
> +		at91_gpio->mask_shadow = mask;
> +		__raw_writel(~mask, pio + PIO_OWDR);
> +		__raw_writel(mask, pio + PIO_OWER);
> +	}
> +	__raw_writel(val, pio + PIO_ODSR);
> +}
> +
>  static void at91_gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  {
>  	int i;

