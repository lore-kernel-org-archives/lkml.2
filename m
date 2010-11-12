Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742Ab0KLRIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:08:49 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:41685 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab0KLRIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:08:48 -0500
Date: Fri, 12 Nov 2010 09:08:41 -0800
From: Andres Salomon <dilinger@queued.net>
To: Greg KH <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, cjb@laptop.org, jon.nettleton@gmail.com,
        dsd@laptop.org, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: Re: [PATCH 3/4] cs5535: add some additional cs5535-specific GPIO
 functionality
Message-ID: <20101112090841.2c0e52cc@queued.net>
In-Reply-To: <20100925190712.6aa5c2fc@debxo>
References: <20100925190712.6aa5c2fc@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Does anyone have any comments on this?  Greg, since there's no gpio
maintainer, would you mind picking it up for 2.6.38 (along w/ the
subsequent patch, which allows olpc_dcon to build)?


On Sat, 25 Sep 2010
19:07:12 -0700 Andres Salomon <dilinger@queued.net> wrote:

> 
> This adds (well, re-adds actually) handling for events/IRQs through
> cs5535 GPIOs.  In the wild and wooly world of CS5535, setup_event()
> is for assigning an IRQ to a GPIO filter/event pair, and set_irq()
> sets up the pair to trigger IRQs.
> 
> These should really only be used in highly platform-specific drivers
> (such as OLPC's DCON driver).  Sadly, because set_irq() uses MSRs,
> this causes the driver to become X86-specific.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  drivers/gpio/Kconfig       |    2 +-
>  drivers/gpio/cs5535-gpio.c |   52
> ++++++++++++++++++++++++++++++++++++++++++++
> include/linux/cs5535.h     |    2 + 3 files changed, 55
> insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 510aa20..80f6702 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -271,7 +271,7 @@ comment "PCI GPIO expanders:"
>  
>  config GPIO_CS5535
>  	tristate "AMD CS5535/CS5536 GPIO support"
> -	depends on PCI && !CS5535_GPIO
> +	depends on PCI && X86 && !CS5535_GPIO
>  	help
>  	  The AMD CS5535 and CS5536 southbridges support 28 GPIO
> pins that can be used for quite a number of things.  The CS5535/6 is
> found on diff --git a/drivers/gpio/cs5535-gpio.c
> b/drivers/gpio/cs5535-gpio.c index e23c068..7e5ab74 100644
> --- a/drivers/gpio/cs5535-gpio.c
> +++ b/drivers/gpio/cs5535-gpio.c
> @@ -15,6 +15,7 @@
>  #include <linux/gpio.h>
>  #include <linux/io.h>
>  #include <linux/cs5535.h>
> +#include <asm/msr.h>
>  
>  #define DRV_NAME "cs5535-gpio"
>  #define GPIO_BAR 1
> @@ -121,6 +122,57 @@ int cs5535_gpio_isset(unsigned offset, unsigned
> int reg) }
>  EXPORT_SYMBOL_GPL(cs5535_gpio_isset);
>  
> +int cs5535_gpio_set_irq(unsigned group, unsigned irq)
> +{
> +	uint32_t lo, hi;
> +
> +	if (group > 7 || irq > 15)
> +		return -EINVAL;
> +
> +	rdmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
> +
> +	lo &= ~(0xF << (group * 4));
> +	lo |= (irq & 0xF) << (group * 4);
> +
> +	wrmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(cs5535_gpio_set_irq);
> +
> +void cs5535_gpio_setup_event(unsigned offset, int pair, int pme)
> +{
> +	struct cs5535_gpio_chip *chip = &cs5535_gpio_chip;
> +	uint32_t shift = (offset % 8) * 4;
> +	unsigned long flags;
> +	uint32_t val;
> +
> +	if (offset >= 24)
> +		offset = GPIO_MAP_W;
> +	else if (offset >= 16)
> +		offset = GPIO_MAP_Z;
> +	else if (offset >= 8)
> +		offset = GPIO_MAP_Y;
> +	else
> +		offset = GPIO_MAP_X;
> +
> +	spin_lock_irqsave(&chip->lock, flags);
> +	val = inl(chip->base + offset);
> +
> +	/* Clear whatever was there before */
> +	val &= ~(0xF << shift);
> +
> +	/* Set the new value */
> +	val |= ((pair & 7) << shift);
> +
> +	/* Set the PME bit if this is a PME event */
> +	if (pme)
> +		val |= (1 << (shift + 3));
> +
> +	outl(val, chip->base + offset);
> +	spin_unlock_irqrestore(&chip->lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(cs5535_gpio_setup_event);
> +
>  /*
>   * Generic gpio_chip API support.
>   */
> diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
> index d5a1d48..213cc50 100644
> --- a/include/linux/cs5535.h
> +++ b/include/linux/cs5535.h
> @@ -111,6 +111,8 @@ static inline int cs5535_has_vsa2(void)
>  void cs5535_gpio_set(unsigned offset, unsigned int reg);
>  void cs5535_gpio_clear(unsigned offset, unsigned int reg);
>  int cs5535_gpio_isset(unsigned offset, unsigned int reg);
> +int cs5535_gpio_set_irq(unsigned group, unsigned irq);
> +void cs5535_gpio_setup_event(unsigned offset, int pair, int pme);
>  
>  /* MFGPTs */
>  
