Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab1ITRhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:37:20 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:40629 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1ITRhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:37:19 -0400
Date: Tue, 20 Sep 2011 11:37:15 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/2] gpio/nomadik: use genirq core to track enablement
Message-ID: <20110920173714.GD7781@ponder.secretlab.ca>
References: <1316508615-20351-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316508615-20351-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 10:50:15AM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Currently the Nomadik GPIO driver tracks enabled/disabled interrupt
> status with a local variable, switch to using the interrupt core.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Applied both, thanks.

g.

> ---
>  drivers/gpio/gpio-nomadik.c |   11 ++---------
>  1 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
> index 97e9be9..0b7ec12 100644
> --- a/drivers/gpio/gpio-nomadik.c
> +++ b/drivers/gpio/gpio-nomadik.c
> @@ -58,7 +58,6 @@ struct nmk_gpio_chip {
>  	u32 rwimsc;
>  	u32 fwimsc;
>  	u32 slpm;
> -	u32 enabled;
>  	u32 pull_up;
>  };
>  
> @@ -605,11 +604,6 @@ static int nmk_gpio_irq_maskunmask(struct irq_data *d, bool enable)
>  	if (!nmk_chip)
>  		return -EINVAL;
>  
> -	if (enable)
> -		nmk_chip->enabled |= bitmask;
> -	else
> -		nmk_chip->enabled &= ~bitmask;
> -
>  	clk_enable(nmk_chip->clk);
>  	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
>  	spin_lock(&nmk_chip->lock);
> @@ -653,7 +647,7 @@ static int nmk_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
>  	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
>  	spin_lock(&nmk_chip->lock);
>  
> -	if (!(nmk_chip->enabled & bitmask))
> +	if (irqd_irq_disabled(d))
>  		__nmk_gpio_set_wake(nmk_chip, gpio, on);
>  
>  	if (on)
> @@ -670,7 +664,7 @@ static int nmk_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
>  
>  static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>  {
> -	bool enabled;
> +	bool enabled = !irqd_irq_disabled(d);
>  	bool wake = irqd_is_wakeup_set(d);
>  	int gpio;
>  	struct nmk_gpio_chip *nmk_chip;
> @@ -691,7 +685,6 @@ static int nmk_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>  	clk_enable(nmk_chip->clk);
>  	spin_lock_irqsave(&nmk_chip->lock, flags);
>  
> -	enabled = !!(nmk_chip->enabled & bitmask);
>  	if (enabled)
>  		__nmk_gpio_irq_modify(nmk_chip, gpio, NORMAL, false);
>  
> -- 
> 1.7.3.2
> 
