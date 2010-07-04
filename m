Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab0GDWHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 18:07:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:42338 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744Ab0GDWHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 18:07:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,536,1272870000"; 
   d="scan'208";a="582851148"
Date: Mon, 5 Jul 2010 00:07:33 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: Implement set_debounce for WM831x GPIOs
Message-ID: <20100704220732.GA3443@sortiz-mobl>
References: <1278164456-15801-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278164456-15801-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 03:40:56PM +0200, Mark Brown wrote:
> The debounce times are approximate, they can be selected using the two
> input functions.
Thanks Mark, patch applied.

Cheers,
Samuel.

 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/gpio/wm831x-gpio.c |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/wm831x-gpio.c b/drivers/gpio/wm831x-gpio.c
> index 1fa449a..309644c 100644
> --- a/drivers/gpio/wm831x-gpio.c
> +++ b/drivers/gpio/wm831x-gpio.c
> @@ -108,6 +108,37 @@ static int wm831x_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
>  	return wm831x->irq_base + WM831X_IRQ_GPIO_1 + offset;
>  }
>  
> +static int wm831x_gpio_set_debounce(struct gpio_chip *chip, unsigned offset,
> +				    unsigned debounce)
> +{
> +	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
> +	struct wm831x *wm831x = wm831x_gpio->wm831x;
> +	int reg = WM831X_GPIO1_CONTROL + offset;
> +	int ret, fn;
> +
> +	ret = wm831x_reg_read(wm831x, reg);
> +	if (ret < 0)
> +		return ret;
> +
> +	switch (ret & WM831X_GPN_FN_MASK) {
> +	case 0:
> +	case 1:
> +		break;
> +	default:
> +		/* Not in GPIO mode */
> +		return -EBUSY;
> +	}
> +
> +	if (debounce >= 32 && debounce <= 64)
> +		fn = 0;
> +	else if (debounce >= 4000 && debounce <= 8000)
> +		fn = 1;
> +	else
> +		return -EINVAL;
> +
> +	return wm831x_set_bits(wm831x, reg, WM831X_GPN_FN_MASK, fn);
> +}
> +
>  #ifdef CONFIG_DEBUG_FS
>  static void wm831x_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  {
> @@ -208,6 +239,7 @@ static struct gpio_chip template_chip = {
>  	.direction_output	= wm831x_gpio_direction_out,
>  	.set			= wm831x_gpio_set,
>  	.to_irq			= wm831x_gpio_to_irq,
> +	.set_debounce		= wm831x_gpio_set_debounce,
>  	.dbg_show		= wm831x_gpio_dbg_show,
>  	.can_sleep		= 1,
>  };
> -- 
> 1.7.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
