Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab1CFHZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 02:25:13 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36075 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1CFHZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 02:25:11 -0500
Date: Sun, 6 Mar 2011 00:25:05 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH v5 1/4] gpiolib: Add "unknown" direction support
Message-ID: <20110306072505.GC7467@angua.secretlab.ca>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 05:28:17PM -0600, Peter Tyser wrote:
> Previously, gpiolib would unconditionally flag all GPIO pins as inputs,
> regardless of their true state.  This resulted in all GPIO output pins
> initially being incorrectly identified as "input" in the GPIO sysfs.
> 
> Since the direction of GPIOs is not known prior to having their
> direction set, instead set the default direction to "unknown" to prevent
> user confusion.  A pin with an "unknown" direction can not be written or
> read via sysfs; it must first be configured as an input or output before
> it can be used.
> 
> While we're playing with the direction flag in/out defines, rename them to
> a more descriptive FLAG_DIR_* format.

It's well past time for me to weigh in on this debate...

So, basically, adding an 'unknown' state to gpio pins is all about the
sysfs interface.  All of the in-kernel gpio users should already be
setting the pin direction before using the gpio.  The sysfs interface
is currently the only interface that has a method for querying the
direction.

The thing about gpios is that how they are used is entirely dependant
on what they are wired up to.  There is no avoiding the fact that you
*absolutely* must understand the usage model before even considering
fiddling with a gpio (ignoring the "I wonder what this knob does"
use-case such as when reverse engineer a board).  So, while it is nice
to have an 'unknown' state for sysfs to report, it is certainly not
required.  The model still remains that the pin direction must be set
before (or at the same time as) reading/writing the pin.

I'm *not* talking about gpio_request() either.  A gpio request must
not change the state of the pin, and any gpio driver that does is
simply buggy.  gpio_request() must only be used to ensure exclusive
access to the pin.

I'm also not talking about alt_func or pin muxing, or anything
like that.  The gpio api is only concerned about n gpios on a gpio
controller.  Any munging of pin routing to get the gpio to the outside
world is beyond the scope of the GPIO API which doesn't even attempt
to handle or express it.  IMNSHO, that is completely by design.  If a
pin is configured for an alternate function, then it is conceptually
equivalent to the pin being physically disconnected from the gpio
controller.  The gpio is still present and can be twiddled, but it
isn't actually connected to anything, and the gpio controller driver
may or may not be able to know anything about it.  I am not interested
in trying to abstract all the complexity of pin mux into the gpio api.

Back to sysfs:  The sysfs gpio interface is useful for many reasons,
but it is dangerous much in the same way that /dev/mem is dangerous.
It gives userspace unfettered access to gpio resources without any
clues about how it should be used.  I consider it bad practice to
depend on the gpio sysfs interface for any real system/application.
gpio numbers could easily change or become unavailable if a kernel
driver decides to use them (heck, I'd like to be rid of gpio
numbers entirely, but that's a separate debate).  I'd much rather see
real device drivers be written for gpio interfaces instead of bodging
things together from userspace.  Since the addition of an 'unknown'
direction is solely for benefit of the sysfs interface, I don't (yet)
see a valid argument for adding it.  *Who cares* if sysfs might report
direction as 'input' inaccurately?  It may be mildly inconvenient to a
human reader, but it doesn't change the usage model one iota because
the direction still must be explicitly set before using the gpio.

So, I'm going to say no to this patch.

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
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Alexander Stein <alexander.stein@systec-electronic.com>
> Cc: Ryan Mallon <ryan@bluewatersys.com>
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> ---
> Change since V1:
> - This patch is new and is based on feedback from Alan to support a new
>   "unknown" direction.
> - Rename FLAG_IS_OUT to FLAG_DIR_OUT, and add FLAG_DIR_IN
> 
> Change since V2:
> - None
> 
> Change since V3:
> - None
> 
> Change since V4:
> - None
> 
>  drivers/gpio/gpiolib.c |   91 ++++++++++++++++++++++++++---------------------
>  1 files changed, 50 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 649550e..eb74311 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -49,13 +49,14 @@ struct gpio_desc {
>  	unsigned long		flags;
>  /* flag symbols are bit numbers */
>  #define FLAG_REQUESTED	0
> -#define FLAG_IS_OUT	1
> -#define FLAG_RESERVED	2
> -#define FLAG_EXPORT	3	/* protected by sysfs_lock */
> -#define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
> -#define FLAG_TRIG_FALL	5	/* trigger on falling edge */
> -#define FLAG_TRIG_RISE	6	/* trigger on rising edge */
> -#define FLAG_ACTIVE_LOW	7	/* sysfs value has active low */
> +#define FLAG_DIR_OUT	1	/* pin is an output */
> +#define FLAG_DIR_IN	2	/* pin is an input */
> +#define FLAG_RESERVED	3
> +#define FLAG_EXPORT	4	/* protected by sysfs_lock */
> +#define FLAG_SYSFS	5	/* exported via /sys/class/gpio/control */
> +#define FLAG_TRIG_FALL	6	/* trigger on falling edge */
> +#define FLAG_TRIG_RISE	7	/* trigger on rising edge */
> +#define FLAG_ACTIVE_LOW	8	/* sysfs value has active low */
>  
>  #define ID_SHIFT	16	/* add new flags before this one */
>  
> @@ -220,15 +221,22 @@ static ssize_t gpio_direction_show(struct device *dev,
>  {
>  	const struct gpio_desc	*desc = dev_get_drvdata(dev);
>  	ssize_t			status;
> +	const char		*dir_str;
>  
>  	mutex_lock(&sysfs_lock);
>  
> -	if (!test_bit(FLAG_EXPORT, &desc->flags))
> +	if (!test_bit(FLAG_EXPORT, &desc->flags)) {
>  		status = -EIO;
> -	else
> -		status = sprintf(buf, "%s\n",
> -			test_bit(FLAG_IS_OUT, &desc->flags)
> -				? "out" : "in");
> +	} else {
> +		if (test_bit(FLAG_DIR_OUT, &desc->flags))
> +			dir_str = "out";
> +		else if (test_bit(FLAG_DIR_IN, &desc->flags))
> +			dir_str = "in";
> +		else
> +			dir_str = "unknown";
> +
> +		status = sprintf(buf, "%s\n", dir_str);
> +	}
>  
>  	mutex_unlock(&sysfs_lock);
>  	return status;
> @@ -272,6 +280,9 @@ static ssize_t gpio_value_show(struct device *dev,
>  
>  	if (!test_bit(FLAG_EXPORT, &desc->flags)) {
>  		status = -EIO;
> +	} else if ((!test_bit(FLAG_DIR_OUT, &desc->flags)) &&
> +			(!test_bit(FLAG_DIR_IN, &desc->flags))) {
> +		status = -EPERM;
>  	} else {
>  		int value;
>  
> @@ -297,7 +308,7 @@ static ssize_t gpio_value_store(struct device *dev,
>  
>  	if (!test_bit(FLAG_EXPORT, &desc->flags))
>  		status = -EIO;
> -	else if (!test_bit(FLAG_IS_OUT, &desc->flags))
> +	else if (!test_bit(FLAG_DIR_OUT, &desc->flags))
>  		status = -EPERM;
>  	else {
>  		long		value;
> @@ -741,7 +752,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
>  
>  			if (!status && gpio_to_irq(gpio) >= 0
>  					&& (direction_may_change
> -						|| !test_bit(FLAG_IS_OUT,
> +						|| test_bit(FLAG_DIR_IN,
>  							&desc->flags)))
>  				status = device_create_file(dev,
>  						&dev_attr_edge);
> @@ -1059,22 +1070,10 @@ int gpiochip_add(struct gpio_chip *chip)
>  			break;
>  		}
>  	}
> -	if (status == 0) {
> -		for (id = base; id < base + chip->ngpio; id++) {
> +	if (status == 0)
> +		for (id = base; id < base + chip->ngpio; id++)
>  			gpio_desc[id].chip = chip;
>  
> -			/* REVISIT:  most hardware initializes GPIOs as
> -			 * inputs (often with pullups enabled) so power
> -			 * usage is minimized.  Linux code should set the
> -			 * gpio direction first thing; but until it does,
> -			 * we may expose the wrong direction in sysfs.
> -			 */
> -			gpio_desc[id].flags = !chip->direction_input
> -				? (1 << FLAG_IS_OUT)
> -				: 0;
> -		}
> -	}
> -
>  	of_gpiochip_add(chip);
>  
>  unlock:
> @@ -1402,8 +1401,10 @@ int gpio_direction_input(unsigned gpio)
>  	}
>  
>  	status = chip->direction_input(chip, gpio);
> -	if (status == 0)
> -		clear_bit(FLAG_IS_OUT, &desc->flags);
> +	if (status == 0) {
> +		clear_bit(FLAG_DIR_OUT, &desc->flags);
> +		set_bit(FLAG_DIR_IN, &desc->flags);
> +	}
>  lose:
>  	return status;
>  fail:
> @@ -1455,8 +1456,10 @@ int gpio_direction_output(unsigned gpio, int value)
>  	}
>  
>  	status = chip->direction_output(chip, gpio, value);
> -	if (status == 0)
> -		set_bit(FLAG_IS_OUT, &desc->flags);
> +	if (status == 0) {
> +		clear_bit(FLAG_DIR_IN, &desc->flags);
> +		set_bit(FLAG_DIR_OUT, &desc->flags);
> +	}
>  lose:
>  	return status;
>  fail:
> @@ -1643,21 +1646,27 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  	unsigned		i;
>  	unsigned		gpio = chip->base;
>  	struct gpio_desc	*gdesc = &gpio_desc[gpio];
> -	int			is_out;
> +	const char		*dir_str;
> +	int			unknown = 0;
>  
>  	for (i = 0; i < chip->ngpio; i++, gpio++, gdesc++) {
>  		if (!test_bit(FLAG_REQUESTED, &gdesc->flags))
>  			continue;
>  
> -		is_out = test_bit(FLAG_IS_OUT, &gdesc->flags);
> -		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s",
> -			gpio, gdesc->label,
> -			is_out ? "out" : "in ",
> -			chip->get
> -				? (chip->get(chip, i) ? "hi" : "lo")
> -				: "?  ");
> +		if (test_bit(FLAG_DIR_IN, &gdesc->flags)) {
> +			dir_str = "in ";
> +		} else if (test_bit(FLAG_DIR_OUT, &gdesc->flags)) {
> +			dir_str = "out";
> +		} else {
> +			dir_str = "?  ";
> +			unknown = 1;
> +		}
> +
> +		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s", gpio, gdesc->label,
> +			dir_str, (chip->get && !unknown) ?
> +			(chip->get(chip, i) ? "hi" : "lo") : "?");
>  
> -		if (!is_out) {
> +		if (test_bit(FLAG_DIR_IN, &gdesc->flags)) {
>  			int		irq = gpio_to_irq(gpio);
>  			struct irq_desc	*desc = irq_to_desc(irq);
>  
> -- 
> 1.7.0.4
> 
