Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1F0Ws7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:48:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62257 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1F0WrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:47:25 -0400
Date: Mon, 27 Jun 2011 16:47:22 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH] pch_gpio: transform mutex into spinlock
Message-ID: <20110627224722.GG20865@ponder.secretlab.ca>
References: <1308665847-13924-1-git-send-email-alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308665847-13924-1-git-send-email-alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 04:17:27PM +0200, Alexander Stein wrote:
> gpio_chip.can_sleep is 0, but gpio_set_value & friends lock a mutex. Thus
> those functions are not callable from interrupt context.
> Changing mutex into spinlock.
> 
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>

Tomoya, what do you think of this patch?

> ---
> I just noticed that the patch introduced at
> http://marc.info/?l=linux-kernel&m=130863151431202&w=2
> also added a spinlock. I think those two spinlock can be merged into one.
> 
>  drivers/gpio/pch_gpio.c |   19 +++++++++++--------
>  1 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
> index 36919e7..262c200 100644
> --- a/drivers/gpio/pch_gpio.c
> +++ b/drivers/gpio/pch_gpio.c
> @@ -62,15 +62,16 @@ struct pch_gpio {
>  	struct device *dev;
>  	struct gpio_chip gpio;
>  	struct pch_gpio_reg_data pch_gpio_reg;
> -	struct mutex lock;
> +	struct spinlock lock;
>  };
>  
>  static void pch_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
>  {
>  	u32 reg_val;
> +	unsigned long flags;
>  	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
>  
> -	mutex_lock(&chip->lock);
> +	spin_lock_irqsave(&chip->lock, flags);
>  	reg_val = ioread32(&chip->reg->po);
>  	if (val)
>  		reg_val |= (1 << nr);
> @@ -78,7 +79,7 @@ static void pch_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
>  		reg_val &= ~(1 << nr);
>  
>  	iowrite32(reg_val, &chip->reg->po);
> -	mutex_unlock(&chip->lock);
> +	spin_unlock_irqrestore(&chip->lock, flags);
>  }
>  
>  static int pch_gpio_get(struct gpio_chip *gpio, unsigned nr)
> @@ -94,8 +95,9 @@ static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
>  	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
>  	u32 pm;
>  	u32 reg_val;
> +	unsigned long flags;
>  
> -	mutex_lock(&chip->lock);
> +	spin_lock_irqsave(&chip->lock, flags);
>  	pm = ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS;
>  	pm |= (1 << nr);
>  	iowrite32(pm, &chip->reg->pm);
> @@ -107,7 +109,7 @@ static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
>  		reg_val &= ~(1 << nr);
>  	iowrite32(reg_val, &chip->reg->po);
>  
> -	mutex_unlock(&chip->lock);
> +	spin_unlock_irqrestore(&chip->lock, flags);
>  
>  	return 0;
>  }
> @@ -116,12 +118,13 @@ static int pch_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
>  {
>  	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
>  	u32 pm;
> +	unsigned long flags;
>  
> -	mutex_lock(&chip->lock);
> +	spin_lock_irqsave(&chip->lock, flags);
>  	pm = ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS; /*bits 0-11*/
>  	pm &= ~(1 << nr);
>  	iowrite32(pm, &chip->reg->pm);
> -	mutex_unlock(&chip->lock);
> +	spin_unlock_irqrestore(&chip->lock, flags);
>  
>  	return 0;
>  }
> @@ -194,7 +197,7 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
>  
>  	chip->reg = chip->base;
>  	pci_set_drvdata(pdev, chip);
> -	mutex_init(&chip->lock);
> +	spin_lock_init(&chip->lock);
>  	pch_gpio_setup(chip);
>  	ret = gpiochip_add(&chip->gpio);
>  	if (ret) {
> -- 
> 1.7.3.4
> 
