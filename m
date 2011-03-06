Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab1CFHaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 02:30:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63780 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1CFHaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 02:30:06 -0500
Date: Sun, 6 Mar 2011 00:30:03 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v5 2/4] gpiolib: Add ability to get GPIO direction
Message-ID: <20110306073003.GA29325@angua.secretlab.ca>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
 <1299022100-14564-2-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1299022100-14564-2-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 05:28:18PM -0600, Peter Tyser wrote:
> Add a new get_direction() function to the gpio_chip structure.  This is
> useful so that the direction of a GPIO can be determined when its
> initially exported.  Previously, the direction defaulted to "unknown"
> regardless of the actual configuration of the GPIO.
> 
> If a GPIO driver implements get_direction(), it is called in
> gpio_request() to set the initial direction of the GPIO accurately.

I don't like this approach.  It effectively creates two methods for
determining the direction of a gpio; either ask the driver, or read
the flags value.  Currently, only gpio_request() actually uses the
first option, but it still leaves the ambiguity.

Instead, the driver should be able to preload the direction flag at or
shortly after gpiochip_add() time.  No need for a new callback hook
from what I can see.

g.

> 
> Cc: Alek Du <alek.du@intel.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> ---
> Changes since v1:
> - Add support for "unknown" direction
> 
> Changes since v2:
>   Based on Wolfram's feedback:
> - Use GPIOF_DIR_* flags as returns from get_direction()
> - Call spin_lock_irqsave() to before setting flags
> 
> Changes since v3:
> - Removed "pin" references from the commit message
> - Added might_sleep() call
> - Made the direction always be set in gpio_request()
> 
> Change since V4:
> - None
> 
>  drivers/gpio/gpiolib.c     |   25 +++++++++++++++++++++++++
>  include/asm-generic/gpio.h |    4 ++++
>  2 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index eb74311..106164f 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1174,6 +1174,7 @@ int gpio_request(unsigned gpio, const char *label)
>  	struct gpio_desc	*desc;
>  	struct gpio_chip	*chip;
>  	int			status = -EINVAL;
> +	int			dir = -1; /* Default to unknown direction */
>  	unsigned long		flags;
>  
>  	spin_lock_irqsave(&gpio_lock, flags);
> @@ -1214,6 +1215,30 @@ int gpio_request(unsigned gpio, const char *label)
>  		}
>  	}
>  
> +	if (chip->get_direction) {
> +		/* chip->get_direction may sleep */
> +		spin_unlock_irqrestore(&gpio_lock, flags);
> +		might_sleep_if(chip->can_sleep);
> +		dir = chip->get_direction(chip, gpio - chip->base);
> +		spin_lock_irqsave(&gpio_lock, flags);
> +	}
> +
> +	switch (dir) {
> +	case GPIOF_DIR_OUT:
> +		set_bit(FLAG_DIR_OUT, &desc->flags);
> +		clear_bit(FLAG_DIR_IN, &desc->flags);
> +		break;
> +	case GPIOF_DIR_IN:
> +		set_bit(FLAG_DIR_IN, &desc->flags);
> +		clear_bit(FLAG_DIR_OUT, &desc->flags);
> +		break;
> +	default:
> +		/* Direction isn't known */
> +		clear_bit(FLAG_DIR_OUT, &desc->flags);
> +		clear_bit(FLAG_DIR_IN, &desc->flags);
> +		break;
> +	}
> +
>  done:
>  	if (status)
>  		pr_debug("gpio_request: gpio-%d (%s) status %d\n",
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index ff5c660..6af5a3e 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -57,6 +57,8 @@ struct device_node;
>   * @direction_input: configures signal "offset" as input, or returns error
>   * @get: returns value for signal "offset"; for output signals this
>   *	returns either the value actually sensed, or zero
> + * @get_direction: optional hook to determine if a GPIO signal is configured
> + *	as an input, output, or unknown
>   * @direction_output: configures signal "offset" as output, or returns error
>   * @set: assigns output value for signal "offset"
>   * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
> @@ -101,6 +103,8 @@ struct gpio_chip {
>  						unsigned offset);
>  	int			(*get)(struct gpio_chip *chip,
>  						unsigned offset);
> +	int			(*get_direction)(struct gpio_chip *chip,
> +						unsigned offset);
>  	int			(*direction_output)(struct gpio_chip *chip,
>  						unsigned offset, int value);
>  	int			(*set_debounce)(struct gpio_chip *chip,
> -- 
> 1.7.0.4
> 
