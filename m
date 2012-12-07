Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965016Ab2LGCt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:49:27 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50155 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2LGCtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:49:25 -0500
X-Originating-IP: 108.223.40.66
Date: Thu, 6 Dec 2012 18:49:47 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gnurou@gmail.com
Subject: Re: [RFC] gpiolib: introduce descriptor-based GPIO interface
Message-ID: <20121207024947.GA25121@roeck-us.net>
References: <1354779918-4028-1-git-send-email-acourbot@nvidia.com>
 <1354779918-4028-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354779918-4028-2-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 04:45:18PM +0900, Alexandre Courbot wrote:
> With the current API, GPIOs are manipulated through an integer which
> represents their unique number across the system. This poses problems in
> terms of portability, scalability and flexibility: for instance, the
> number of valid GPIOs for a given system is fixed at system time, and a
> large array of that size is statically allocated to hold the GPIO
> descriptors. Worse, GPIOs can be used without being properly allocated.
> 
> In order to improve the situation, the integer namespace must first get
> away. This patch introduces an alternative GPIO API that uses opaque
> handlers and refactor gpiolib's internals to work with these handlers
> instead of GPIO numbers. The former integer-based API is still available
> as a light wrapper around this new API.
> 
> This first step will then us to build more improvements for gpiolib,
> like proper GPIO lookup functions per device and provider, and getting
> rid of the static GPIO array and the ARCH_NR_GPIO configuration option.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

I like the idea, especially getting rid of ARCH_NR_GPIO. I have a system with
1000+ GPIO pins, so that will come handy.

My own idea for a solution was to keep integer based handles, but replace
gpio_desc[] with a hash table. But ultimately I don't really care how
it is done.

Do you have a solution for gpiochip_find_base() in mind, and how to handle
reservations ? I had thought about using bit maps, but maybe there is
a better solution.

If/when you have some code to test, please let me know.

Couple of comments below.

Guenter

> ---
>  drivers/gpio/gpiolib.c        | 302 ++++++++++++++++++++++--------------------
>  include/asm-generic/gpio.h    |  74 ++++++++---
>  include/linux/gpio/consumer.h |  45 +++++++
>  3 files changed, 261 insertions(+), 160 deletions(-)
>  create mode 100644 include/linux/gpio/consumer.h
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 1c8d9e3..bf32511 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -83,6 +83,32 @@ static inline void desc_set_label(struct gpio_desc *d, const char *label)
>  #endif
>  }
>  
> +/**
> + * Convert a GPIO descriptor to the integer namespace.
> + * This should disappear in the future but is needed since we still
> + * use GPIO numbers for error messages and sysfs nodes
> + */
> +static inline int desc_to_gpio(struct gpio_desc *desc)
> +{
> +	return desc - &gpio_desc[0];
> +}
> +
> +/**
> + * Return the GPIO number of the passed descriptor relative to its chip
> + */
> +int gpio_chip_offset(struct gpio_desc *desc)
> +{
> +	return (desc - &gpio_desc[0]) - desc->chip->base;
> +}
> +
> +/**
> + * Convert a GPIO number to its descriptor
> + */
> +struct gpio_desc *gpio_to_desc(unsigned gpio)
> +{
> +	return &gpio_desc[gpio];
> +}
> +
>  /* Warn when drivers omit gpio_request() calls -- legal but ill-advised
>   * when setting direction, and otherwise illegal.  Until board setup code
>   * and drivers use explicit requests everywhere (which won't happen when
> @@ -94,10 +120,10 @@ static inline void desc_set_label(struct gpio_desc *d, const char *label)
>   * only "legal" in the sense that (old) code using it won't break yet,
>   * but instead only triggers a WARN() stack dump.
>   */
> -static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
> +static int gpio_ensure_requested(struct gpio_desc *desc)
>  {
>  	const struct gpio_chip *chip = desc->chip;
> -	const int gpio = chip->base + offset;
> +	const int gpio = desc_to_gpio(desc);
>  
>  	if (WARN(test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0,
>  			"autorequest GPIO-%d\n", gpio)) {
> @@ -116,9 +142,9 @@ static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
>  }
>  
>  /* caller holds gpio_lock *OR* gpio is marked as requested */
> -struct gpio_chip *gpio_to_chip(unsigned gpio)
> +struct gpio_chip *gpiod_to_chip(struct gpio_desc *desc)
>  {
> -	return gpio_desc[gpio].chip;
> +	return desc->chip;
>  }
>  
>  /* dynamic allocation of GPIOs, e.g. on a hotplugged device */
> @@ -684,10 +710,9 @@ static struct class gpio_class = {
>  	.class_attrs =	gpio_class_attrs,
>  };
>  
> -
>  /**
> - * gpio_export - export a GPIO through sysfs
> - * @gpio: gpio to make available, already requested
> + * gpiod_export - export a GPIO through sysfs
> + * @desc: descriptor of gpio to make available, already requested
>   * @direction_may_change: true if userspace may change gpio direction
>   * Context: arch_initcall or later
>   *
> @@ -700,12 +725,17 @@ static struct class gpio_class = {
>   *
>   * Returns zero on success, else an error.
>   */
> -int gpio_export(unsigned gpio, bool direction_may_change)
> +int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
>  {
>  	unsigned long		flags;
> -	struct gpio_desc	*desc;
>  	int			status = -EINVAL;
>  	const char		*ioname = NULL;
> +	int gpio;
> +
> +	if (!desc)
> +		goto done;
> +
> +	mutex_lock(&sysfs_lock);
>  
>  	/* can't export until sysfs is available ... */
>  	if (!gpio_class.p) {
> @@ -713,13 +743,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
>  		return -ENOENT;


mutex is not released here.

>  	}
>  
> -	if (!gpio_is_valid(gpio))
> -		goto done;
> -
> -	mutex_lock(&sysfs_lock);
> -
>  	spin_lock_irqsave(&gpio_lock, flags);
> -	desc = &gpio_desc[gpio];
>  	if (test_bit(FLAG_REQUESTED, &desc->flags)
>  			&& !test_bit(FLAG_EXPORT, &desc->flags)) {
>  		status = 0;
> @@ -729,6 +753,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
>  	}
>  	spin_unlock_irqrestore(&gpio_lock, flags);
>  
> +	gpio = desc_to_gpio(desc);
>  	if (desc->chip->names && desc->chip->names[gpio - desc->chip->base])
>  		ioname = desc->chip->names[gpio - desc->chip->base];
>  
> @@ -768,7 +793,7 @@ done:
>  
>  	return status;
>  }
> -EXPORT_SYMBOL_GPL(gpio_export);
> +EXPORT_SYMBOL_GPL(gpiod_export);
>  
>  static int match_export(struct device *dev, void *data)
>  {
> @@ -776,28 +801,26 @@ static int match_export(struct device *dev, void *data)
>  }
>  
>  /**
> - * gpio_export_link - create a sysfs link to an exported GPIO node
> + * gpiod_export_link - create a sysfs link to an exported GPIO node
>   * @dev: device under which to create symlink
>   * @name: name of the symlink
> - * @gpio: gpio to create symlink to, already exported
> + * @desc: descriptor of gpio to create symlink to, already exported
>   *
>   * Set up a symlink from /sys/.../dev/name to /sys/class/gpio/gpioN
>   * node. Caller is responsible for unlinking.
>   *
>   * Returns zero on success, else an error.
>   */
> -int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
> +int gpiod_export_link(struct device *dev, const char *name,
> +		      struct gpio_desc *desc)
>  {
> -	struct gpio_desc	*desc;
>  	int			status = -EINVAL;
>  
> -	if (!gpio_is_valid(gpio))
> +	if (!desc)
>  		goto done;
>  
>  	mutex_lock(&sysfs_lock);
>  
> -	desc = &gpio_desc[gpio];
> -
>  	if (test_bit(FLAG_EXPORT, &desc->flags)) {
>  		struct device *tdev;
>  
> @@ -814,16 +837,16 @@ int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
>  
>  done:
>  	if (status)
> -		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
> +		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
> +			 status);
>  
>  	return status;
>  }
> -EXPORT_SYMBOL_GPL(gpio_export_link);
> -
> +EXPORT_SYMBOL_GPL(gpiod_export_link);
>  
>  /**
> - * gpio_sysfs_set_active_low - set the polarity of gpio sysfs value
> - * @gpio: gpio to change
> + * gpiod_sysfs_set_active_low - set the polarity of gpio sysfs value
> + * @desc: descriptor of gpio to change
>   * @value: non-zero to use active low, i.e. inverted values
>   *
>   * Set the polarity of /sys/class/gpio/gpioN/value sysfs attribute.
> @@ -833,19 +856,16 @@ EXPORT_SYMBOL_GPL(gpio_export_link);
>   *
>   * Returns zero on success, else an error.
>   */
> -int gpio_sysfs_set_active_low(unsigned gpio, int value)
> +int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value)
>  {
> -	struct gpio_desc	*desc;
>  	struct device		*dev = NULL;
>  	int			status = -EINVAL;
>  
> -	if (!gpio_is_valid(gpio))
> +	if (!desc)
>  		goto done;
>  
>  	mutex_lock(&sysfs_lock);
>  
> -	desc = &gpio_desc[gpio];
> -
>  	if (test_bit(FLAG_EXPORT, &desc->flags)) {
>  		dev = class_find_device(&gpio_class, NULL, desc, match_export);
>  		if (dev == NULL) {
> @@ -861,33 +881,31 @@ unlock:
>  
>  done:
>  	if (status)
> -		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
> +		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
> +			 status);
>  
>  	return status;
>  }
> -EXPORT_SYMBOL_GPL(gpio_sysfs_set_active_low);
> +EXPORT_SYMBOL_GPL(gpiod_sysfs_set_active_low);
>  
>  /**
> - * gpio_unexport - reverse effect of gpio_export()
> - * @gpio: gpio to make unavailable
> + * gpiod_unexport - reverse effect of gpio_export()
> + * @desc: descriptor of gpio to make unavailable
>   *
>   * This is implicit on gpio_free().
>   */
> -void gpio_unexport(unsigned gpio)
> +void gpiod_unexport(struct gpio_desc *desc)
>  {
> -	struct gpio_desc	*desc;
>  	int			status = 0;
>  	struct device		*dev = NULL;
>  
> -	if (!gpio_is_valid(gpio)) {
> +	if (!desc) {
>  		status = -EINVAL;
>  		goto done;
>  	}
>  
>  	mutex_lock(&sysfs_lock);
>  
> -	desc = &gpio_desc[gpio];
> -
>  	if (test_bit(FLAG_EXPORT, &desc->flags)) {
>  
>  		dev = class_find_device(&gpio_class, NULL, desc, match_export);
> @@ -899,15 +917,17 @@ void gpio_unexport(unsigned gpio)
>  	}
>  
>  	mutex_unlock(&sysfs_lock);
> +
>  	if (dev) {
>  		device_unregister(dev);
>  		put_device(dev);
>  	}
>  done:
>  	if (status)
> -		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
> +		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
> +			 status);
>  }
> -EXPORT_SYMBOL_GPL(gpio_unexport);
> +EXPORT_SYMBOL_GPL(gpiod_unexport);
>  
>  static int gpiochip_export(struct gpio_chip *chip)
>  {
> @@ -1386,7 +1406,6 @@ const char *gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
>  }
>  EXPORT_SYMBOL_GPL(gpiochip_is_requested);
>  
> -
>  /* Drivers MUST set GPIO direction before making get/set calls.  In
>   * some cases this is done in early boot, before IRQs are enabled.
>   *
> @@ -1396,24 +1415,19 @@ EXPORT_SYMBOL_GPL(gpiochip_is_requested);
>   * rely on gpio_request() having been called beforehand.
>   */
>  
> -int gpio_direction_input(unsigned gpio)
> +int gpiod_direction_input(struct gpio_desc *desc)
>  {
>  	unsigned long		flags;
>  	struct gpio_chip	*chip;
> -	struct gpio_desc	*desc = &gpio_desc[gpio];
>  	int			status = -EINVAL;
> +	int gpio;
>  
>  	spin_lock_irqsave(&gpio_lock, flags);
>  
> -	if (!gpio_is_valid(gpio))
> +	if (!desc)
>  		goto fail;
>  	chip = desc->chip;
> -	if (!chip || !chip->get || !chip->direction_input)
> -		goto fail;
> -	gpio -= chip->base;
> -	if (gpio >= chip->ngpio)
> -		goto fail;
> -	status = gpio_ensure_requested(desc, gpio);
> +	status = gpio_ensure_requested(desc);
>  	if (status < 0)
>  		goto fail;
>  
> @@ -1423,6 +1437,8 @@ int gpio_direction_input(unsigned gpio)
>  
>  	might_sleep_if(chip->can_sleep);
>  
> +	gpio = gpio_chip_offset(desc);
> +
>  	if (status) {
>  		status = chip->request(chip, gpio);
>  		if (status < 0) {
> @@ -1449,34 +1465,31 @@ fail:
>  			__func__, gpio, status);
>  	return status;
>  }
> -EXPORT_SYMBOL_GPL(gpio_direction_input);
> +EXPORT_SYMBOL_GPL(gpiod_direction_input);
>  
> -int gpio_direction_output(unsigned gpio, int value)
> +int gpiod_direction_output(struct gpio_desc *desc, int value)
>  {
>  	unsigned long		flags;
>  	struct gpio_chip	*chip;
> -	struct gpio_desc	*desc = &gpio_desc[gpio];
>  	int			status = -EINVAL;
> +	int gpio;
>  
>  	/* Open drain pin should not be driven to 1 */
>  	if (value && test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
> -		return gpio_direction_input(gpio);
> +		return gpiod_direction_input(desc);
>  
>  	/* Open source pin should not be driven to 0 */
>  	if (!value && test_bit(FLAG_OPEN_SOURCE,  &desc->flags))
> -		return gpio_direction_input(gpio);
> +		return gpiod_direction_input(desc);
>  
>  	spin_lock_irqsave(&gpio_lock, flags);
>  
> -	if (!gpio_is_valid(gpio))
> +	if (!desc)
>  		goto fail;
>  	chip = desc->chip;
>  	if (!chip || !chip->set || !chip->direction_output)
>  		goto fail;
> -	gpio -= chip->base;
> -	if (gpio >= chip->ngpio)
> -		goto fail;
> -	status = gpio_ensure_requested(desc, gpio);
> +	status = gpio_ensure_requested(desc);
>  	if (status < 0)
>  		goto fail;
>  
> @@ -1485,6 +1498,7 @@ int gpio_direction_output(unsigned gpio, int value)
>  	spin_unlock_irqrestore(&gpio_lock, flags);
>  
>  	might_sleep_if(chip->can_sleep);
> +	gpio = gpio_chip_offset(desc);
>  
>  	if (status) {
>  		status = chip->request(chip, gpio);
> @@ -1515,28 +1529,26 @@ fail:
>  EXPORT_SYMBOL_GPL(gpio_direction_output);
>  
>  /**
> - * gpio_set_debounce - sets @debounce time for a @gpio
> - * @gpio: the gpio to set debounce time
> + * gpiod_set_debounce - sets @debounce time for a gpio
> + * @desc: descriptor to the gpio to set debounce time
>   * @debounce: debounce time is microseconds
>   */
> -int gpio_set_debounce(unsigned gpio, unsigned debounce)
> +int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
>  {
>  	unsigned long		flags;
>  	struct gpio_chip	*chip;
> -	struct gpio_desc	*desc = &gpio_desc[gpio];
>  	int			status = -EINVAL;
> +	int			gpio;
>  
>  	spin_lock_irqsave(&gpio_lock, flags);
>  
> -	if (!gpio_is_valid(gpio))
> +	if (!desc)
>  		goto fail;
>  	chip = desc->chip;
>  	if (!chip || !chip->set || !chip->set_debounce)
>  		goto fail;
> -	gpio -= chip->base;
> -	if (gpio >= chip->ngpio)
> -		goto fail;
> -	status = gpio_ensure_requested(desc, gpio);
> +
> +	status = gpio_ensure_requested(desc);
>  	if (status < 0)
>  		goto fail;
>  
> @@ -1546,6 +1558,7 @@ int gpio_set_debounce(unsigned gpio, unsigned debounce)
>  
>  	might_sleep_if(chip->can_sleep);
>  
> +	gpio = gpio_chip_offset(desc);
>  	return chip->set_debounce(chip, gpio, debounce);
>  
>  fail:
> @@ -1556,7 +1569,7 @@ fail:
>  
>  	return status;
>  }
> -EXPORT_SYMBOL_GPL(gpio_set_debounce);
> +EXPORT_SYMBOL_GPL(gpiod_set_debounce);
>  
>  /* I/O calls are only valid after configuration completed; the relevant
>   * "is this a valid GPIO" error checks should already have been done.
> @@ -1581,27 +1594,28 @@ EXPORT_SYMBOL_GPL(gpio_set_debounce);
>   */
>  
>  /**
> - * __gpio_get_value() - return a gpio's value
> - * @gpio: gpio whose value will be returned
> + * gpiod_get_value() - return a gpio's value
> + * @desc: descriptor of gpio whose value will be returned
>   * Context: any
>   *
> - * This is used directly or indirectly to implement gpio_get_value().
> - * It returns the zero or nonzero value provided by the associated
> + * Returns the zero or nonzero value provided by the associated
>   * gpio_chip.get() method; or zero if no such method is provided.
>   */
> -int __gpio_get_value(unsigned gpio)
> +int gpiod_get_value(struct gpio_desc *desc)
>  {
>  	struct gpio_chip	*chip;
>  	int value;
> +	int gpio;
>  
> -	chip = gpio_to_chip(gpio);
> +	chip = desc->chip;
> +	gpio = gpio_chip_offset(desc);

Might be better to use a separate variable named 'offset' when dealing with the
offset, to avoid confusion and accidential bugs. You are doing it below, so you
might as well do it everywhere. This would also simplify the code in a couple of
places where gpio is first converted into an offset only to use "chip->base +
gpio" later on.

>  	/* Should be using gpio_get_value_cansleep() */
>  	WARN_ON(chip->can_sleep);
> -	value = chip->get ? chip->get(chip, gpio - chip->base) : 0;
> -	trace_gpio_value(gpio, 1, value);
> +	value = chip->get ? chip->get(chip, gpio) : 0;
> +	trace_gpio_value(gpio + chip->base, 1, value);
>  	return value;
>  }
> -EXPORT_SYMBOL_GPL(__gpio_get_value);
> +EXPORT_SYMBOL_GPL(gpiod_get_value);
>  
>  /*
>   *  _gpio_set_open_drain_value() - Set the open drain gpio's value.
> @@ -1609,23 +1623,25 @@ EXPORT_SYMBOL_GPL(__gpio_get_value);
>   * @chip: Gpio chip.
>   * @value: Non-zero for setting it HIGH otherise it will set to LOW.
>   */
> -static void _gpio_set_open_drain_value(unsigned gpio,
> -			struct gpio_chip *chip, int value)
> +static void _gpio_set_open_drain_value(struct gpio_desc *desc, int value)
>  {
>  	int err = 0;
> +	struct gpio_chip *chip = desc->chip;
> +	int offset = gpio_chip_offset(desc);
> +
>  	if (value) {
> -		err = chip->direction_input(chip, gpio - chip->base);
> +		err = chip->direction_input(chip, offset);
>  		if (!err)
> -			clear_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
> +			clear_bit(FLAG_IS_OUT, &desc->flags);
>  	} else {
> -		err = chip->direction_output(chip, gpio - chip->base, 0);
> +		err = chip->direction_output(chip, offset, 0);
>  		if (!err)
> -			set_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
> +			set_bit(FLAG_IS_OUT, &desc->flags);
>  	}
> -	trace_gpio_direction(gpio, value, err);
> +	trace_gpio_direction(offset + chip->base, value, err);
>  	if (err < 0)
>  		pr_err("%s: Error in set_value for open drain gpio%d err %d\n",
> -					__func__, gpio, err);
> +					__func__, offset + chip->base, err);

I know I am nitpicking, but everywhere in the existing code it is "chip->base + offset/gpio".

>  }
>  
>  /*
> @@ -1634,124 +1650,120 @@ static void _gpio_set_open_drain_value(unsigned gpio,
>   * @chip: Gpio chip.
>   * @value: Non-zero for setting it HIGH otherise it will set to LOW.
>   */
> -static void _gpio_set_open_source_value(unsigned gpio,
> -			struct gpio_chip *chip, int value)
> +static void _gpio_set_open_source_value(struct gpio_desc *desc, int value)
>  {
>  	int err = 0;
> +	struct gpio_chip *chip = desc->chip;
> +	int offset = gpio_chip_offset(desc);
> +
>  	if (value) {
> -		err = chip->direction_output(chip, gpio - chip->base, 1);
> +		err = chip->direction_output(chip, offset, 1);
>  		if (!err)
> -			set_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
> +			set_bit(FLAG_IS_OUT, &desc->flags);
>  	} else {
> -		err = chip->direction_input(chip, gpio - chip->base);
> +		err = chip->direction_input(chip, offset);
>  		if (!err)
> -			clear_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
> +			clear_bit(FLAG_IS_OUT, &desc->flags);
>  	}
> -	trace_gpio_direction(gpio, !value, err);
> +	trace_gpio_direction(offset + chip->base, !value, err);
>  	if (err < 0)
>  		pr_err("%s: Error in set_value for open source gpio%d err %d\n",
> -					__func__, gpio, err);
> +					__func__, offset + chip->base, err);
>  }
>  
> -
>  /**
> - * __gpio_set_value() - assign a gpio's value
> - * @gpio: gpio whose value will be assigned
> + * gpiod_set_value() - assign a gpio's value
> + * @desc: descriptor of gpio whose value will be assigned
>   * @value: value to assign
>   * Context: any
>   *
> - * This is used directly or indirectly to implement gpio_set_value().
> - * It invokes the associated gpio_chip.set() method.
> + * Invokes the associated gpio_chip.set() method.
>   */
> -void __gpio_set_value(unsigned gpio, int value)
> +void gpiod_set_value(struct gpio_desc *desc, int value)
>  {
>  	struct gpio_chip	*chip;
>  
> -	chip = gpio_to_chip(gpio);
> +	chip = desc->chip;
>  	/* Should be using gpio_set_value_cansleep() */
>  	WARN_ON(chip->can_sleep);
> -	trace_gpio_value(gpio, 0, value);
> -	if (test_bit(FLAG_OPEN_DRAIN,  &gpio_desc[gpio].flags))
> -		_gpio_set_open_drain_value(gpio, chip, value);
> -	else if (test_bit(FLAG_OPEN_SOURCE,  &gpio_desc[gpio].flags))
> -		_gpio_set_open_source_value(gpio, chip, value);
> +	trace_gpio_value(desc_to_gpio(desc), 0, value);
> +	if (test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
> +		_gpio_set_open_drain_value(desc, value);
> +	else if (test_bit(FLAG_OPEN_SOURCE,  &desc->flags))
> +		_gpio_set_open_source_value(desc, value);
>  	else
> -		chip->set(chip, gpio - chip->base, value);
> +		chip->set(chip, gpio_chip_offset(desc), value);
>  }
> -EXPORT_SYMBOL_GPL(__gpio_set_value);
> +EXPORT_SYMBOL_GPL(gpiod_set_value);
>  
>  /**
> - * __gpio_cansleep() - report whether gpio value access will sleep
> - * @gpio: gpio in question
> + * gpiod_cansleep() - report whether gpio value access will sleep
> + * @desc: descriptor of gpio in question
>   * Context: any
>   *
> - * This is used directly or indirectly to implement gpio_cansleep().  It
> - * returns nonzero if access reading or writing the GPIO value can sleep.
> + * Returns nonzero if access reading or writing the GPIO value can sleep.
>   */
> -int __gpio_cansleep(unsigned gpio)
> +int gpiod_cansleep(struct gpio_desc *desc)
>  {
> -	struct gpio_chip	*chip;
> -
>  	/* only call this on GPIOs that are valid! */
> -	chip = gpio_to_chip(gpio);
> -
> -	return chip->can_sleep;
> +	return desc->chip->can_sleep;
>  }
> -EXPORT_SYMBOL_GPL(__gpio_cansleep);
> +EXPORT_SYMBOL_GPL(gpiod_cansleep);
>  
>  /**
> - * __gpio_to_irq() - return the IRQ corresponding to a GPIO
> - * @gpio: gpio whose IRQ will be returned (already requested)
> + * gpiod_to_irq() - return the IRQ corresponding to a GPIO
> + * @desc: descriptor of gpio whose IRQ will be returned (already requested)
>   * Context: any
>   *
> - * This is used directly or indirectly to implement gpio_to_irq().
> - * It returns the number of the IRQ signaled by this (input) GPIO,
> + * Returns the number of the IRQ signaled by this (input) GPIO,
>   * or a negative errno.
>   */
> -int __gpio_to_irq(unsigned gpio)
> +int gpiod_to_irq(struct gpio_desc *desc)
>  {
>  	struct gpio_chip	*chip;
> +	int gpio;
>  
> -	chip = gpio_to_chip(gpio);
> +	chip = desc->chip;
> +	gpio = desc_to_gpio(desc);
>  	return chip->to_irq ? chip->to_irq(chip, gpio - chip->base) : -ENXIO;

s/gpio - chip->base/gpio_chip_offset(desc)/

then you don't need gpio at all.

>  }
> -EXPORT_SYMBOL_GPL(__gpio_to_irq);
> -
> -
> +EXPORT_SYMBOL_GPL(gpiod_to_irq);
>  
>  /* There's no value in making it easy to inline GPIO calls that may sleep.
>   * Common examples include ones connected to I2C or SPI chips.
>   */
> -
> -int gpio_get_value_cansleep(unsigned gpio)
> +int gpiod_get_value_cansleep(struct gpio_desc *desc)
>  {
>  	struct gpio_chip	*chip;
>  	int value;
> +	int offset;
>  
>  	might_sleep_if(extra_checks);
> -	chip = gpio_to_chip(gpio);
> -	value = chip->get ? chip->get(chip, gpio - chip->base) : 0;
> -	trace_gpio_value(gpio, 1, value);
> +	chip = desc->chip;
> +	offset = gpio_chip_offset(desc);
> +	value = chip->get ? chip->get(chip, offset) : 0;
> +	trace_gpio_value(offset + chip->base, 1, value);
>  	return value;
>  }
> -EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
> +EXPORT_SYMBOL_GPL(gpiod_get_value_cansleep);
>  
> -void gpio_set_value_cansleep(unsigned gpio, int value)
> +void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
>  {
>  	struct gpio_chip	*chip;
> +	int gpio;
>  
>  	might_sleep_if(extra_checks);
> -	chip = gpio_to_chip(gpio);
> +	chip = desc->chip;
> +	gpio = desc_to_gpio(desc);
>  	trace_gpio_value(gpio, 0, value);
>  	if (test_bit(FLAG_OPEN_DRAIN,  &gpio_desc[gpio].flags))

Use desc directly.

> -		_gpio_set_open_drain_value(gpio, chip, value);
> +		_gpio_set_open_drain_value(desc, value);
>  	else if (test_bit(FLAG_OPEN_SOURCE,  &gpio_desc[gpio].flags))

Use desc directly.

> -		_gpio_set_open_source_value(gpio, chip, value);
> +		_gpio_set_open_source_value(desc, value);
>  	else
>  		chip->set(chip, gpio - chip->base, value);
>  }
> -EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
> -
> +EXPORT_SYMBOL_GPL(gpiod_set_value_cansleep);
>  
>  #ifdef CONFIG_DEBUG_FS
>  
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index a9432fc..30e1a91 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -9,6 +9,7 @@
>  #ifdef CONFIG_GPIOLIB
>  
>  #include <linux/compiler.h>
> +#include <linux/gpio/consumer.h>
>  
>  /* Platforms may implement their GPIO interface with library code,
>   * at a small performance cost for non-inlined operations and some
> @@ -138,7 +139,10 @@ struct gpio_chip {
>  
>  extern const char *gpiochip_is_requested(struct gpio_chip *chip,
>  			unsigned offset);
> -extern struct gpio_chip *gpio_to_chip(unsigned gpio);
> +static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
> +{
> +	return gpiod_to_chip(gpio_to_desc(gpio));
> +}
>  extern int __must_check gpiochip_reserve(int start, int ngpio);
>  
>  /* add/remove chips */
> @@ -155,25 +159,52 @@ extern struct gpio_chip *gpiochip_find(void *data,
>  extern int gpio_request(unsigned gpio, const char *label);
>  extern void gpio_free(unsigned gpio);
>  
> -extern int gpio_direction_input(unsigned gpio);
> -extern int gpio_direction_output(unsigned gpio, int value);
> +static inline int gpio_direction_input(unsigned gpio)
> +{
> +	return gpiod_direction_input(gpio_to_desc(gpio));
> +}
> +static inline int gpio_direction_output(unsigned gpio, int value)
> +{
> +	return gpiod_direction_output(gpio_to_desc(gpio), value);
> +}
>  
> -extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
> +static inline int gpio_set_debounce(unsigned gpio, unsigned debounce)
> +{
> +	return gpiod_set_debounce(gpio_to_desc(gpio), debounce);
> +}
>  
> -extern int gpio_get_value_cansleep(unsigned gpio);
> -extern void gpio_set_value_cansleep(unsigned gpio, int value);
> +static inline int gpio_get_value_cansleep(unsigned gpio)
> +{
> +	return gpiod_get_value_cansleep(gpio_to_desc(gpio));
> +}
> +static inline void gpio_set_value_cansleep(unsigned gpio, int value)
> +{
> +	return gpiod_set_value_cansleep(gpio_to_desc(gpio), value);
> +}
>  
>  
>  /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
>   * the GPIO is constant and refers to some always-present controller,
>   * giving direct access to chip registers and tight bitbanging loops.
>   */
> -extern int __gpio_get_value(unsigned gpio);
> -extern void __gpio_set_value(unsigned gpio, int value);
> +static inline int __gpio_get_value(unsigned gpio)
> +{
> +	return gpiod_get_value(gpio_to_desc(gpio));
> +}
> +static inline void __gpio_set_value(unsigned gpio, int value)
> +{
> +	gpiod_set_value(gpio_to_desc(gpio), value);
> +}
>  
> -extern int __gpio_cansleep(unsigned gpio);
> +static inline int __gpio_cansleep(unsigned gpio)
> +{
> +	return gpiod_cansleep(gpio_to_desc(gpio));
> +}
>  
> -extern int __gpio_to_irq(unsigned gpio);
> +static inline int __gpio_to_irq(unsigned gpio)
> +{
> +	return gpiod_to_irq(gpio_to_desc(gpio));
> +}
>  
>  extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
>  extern int gpio_request_array(const struct gpio *array, size_t num);
> @@ -191,11 +222,24 @@ void devm_gpio_free(struct device *dev, unsigned int gpio);
>   * A sysfs interface can be exported by individual drivers if they want,
>   * but more typically is configured entirely from userspace.
>   */
> -extern int gpio_export(unsigned gpio, bool direction_may_change);
> -extern int gpio_export_link(struct device *dev, const char *name,
> -			unsigned gpio);
> -extern int gpio_sysfs_set_active_low(unsigned gpio, int value);
> -extern void gpio_unexport(unsigned gpio);
> +
> +static inline int gpio_export(unsigned gpio, bool direction_may_change)
> +{
> +	return gpiod_export(gpio_to_desc(gpio), direction_may_change);
> +}
> +static inline int gpio_export_link(struct device *dev, const char *name,
> +			unsigned gpio)
> +{
> +	return gpiod_export_link(dev, name, gpio_to_desc(gpio));
> +}
> +static inline int gpio_sysfs_set_active_low(unsigned gpio, int value)
> +{
> +	return gpiod_sysfs_set_active_low(gpio_to_desc(gpio), value);
> +}
> +static inline void gpio_unexport(unsigned gpio)
> +{
> +	gpiod_unexport(gpio_to_desc(gpio));
> +}
>  
>  #endif	/* CONFIG_GPIO_SYSFS */
>  
> diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
> new file mode 100644
> index 0000000..483be0c
> --- /dev/null
> +++ b/include/linux/gpio/consumer.h
> @@ -0,0 +1,45 @@
> +#ifndef __LINUX_GPIO_CONSUMER_H
> +#define __LINUX_GPIO_CONSUMER_H
> +
> +#ifdef CONFIG_GPIOLIB
> +
> +struct device;
> +struct gpio_chip;
> +
> +/**
> + * Opaque descriptor for a GPIO. These are obtained and manipulated through
> + * the gpiod_* API and are preferable to the old integer-based handles.
> + *
> + * Contrary to integers, a pointer to a gpio_desc is guaranteed to be valid
> + * until the GPIO is released.
> + */
> +struct gpio_desc;
> +
> +extern struct gpio_desc *gpio_to_desc(unsigned gpio);
> +extern int gpio_chip_offset(struct gpio_desc *desc);
> +extern struct gpio_chip *gpiod_to_chip(struct gpio_desc *desc);
> +
> +extern int gpiod_direction_input(struct gpio_desc *desc);
> +extern int gpiod_direction_output(struct gpio_desc *desc, int value);
> +extern int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce);
> +extern int gpiod_get_value_cansleep(struct gpio_desc *desc);
> +extern void gpiod_set_value_cansleep(struct gpio_desc *desc, int value);
> +
> +extern int gpiod_get_value(struct gpio_desc *desc);
> +extern void gpiod_set_value(struct gpio_desc *desc, int value);
> +extern int gpiod_cansleep(struct gpio_desc *desc);
> +extern int gpiod_to_irq(struct gpio_desc *desc);
> +
> +#ifdef CONFIG_GPIO_SYSFS
> +
> +extern int gpiod_export(struct gpio_desc *desc, bool direction_may_change);
> +extern int gpiod_export_link(struct device *dev, const char *name,
> +			struct gpio_desc *desc);
> +extern int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value);
> +extern void gpiod_unexport(struct gpio_desc *desc);
> +
> +#endif /* CONFIG_GPIO_SYSFS */
> +
> +#endif /* CONFIG_GPIOLIB */
> +
> +#endif
> -- 
> 1.8.0.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
