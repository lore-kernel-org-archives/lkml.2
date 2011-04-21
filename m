Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab1DUPkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:40:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48885 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab1DUPj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WRa/APuDXXQaJtW4j3q3lFJD0hSXcyWRu2g6nrWjUPT3S1ra47VUG0zgfwRcwRMcIp
         qa2WO3Q8WxCQX3srqsG/nnnNx/XGr8mh37Y0OIfwyCeosQVa00VszOdKJJ/ZRRY2Kzks
         h9Td2qM6LCCxBzsFkXdUBKLXDPZv9kWKCXsAw=
MIME-Version: 1.0
In-Reply-To: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 21 Apr 2011 17:39:57 +0200
Message-ID: <BANLkTinrtoGhL3CXJZGWzf8+BwFSRsdk0w@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Stijn Devriendt <highguy@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Just yesterday I wrote pretty much a slimmed version of this on top of
our kernel.

There's a couple of things I added on top of what you already seem to have:
- in include/linux/of_gpio.h the of_gpio_flags were extended to
support open-drain
   in device-trees.
- the debugfs support in gpiolib was also updated to export the current state to
  the user through sysfs.

I'd also like to add (if not already mentioned by others) that in
general drivers that use
GPIOs are unaware of their physical connection on the board. Having
this information
in device-tree or platform-data equivalent solves this.

Secondly I tend to disagree with the "silently ignored" case when the
underlying driver
does not support setting drive mode. You can easily break the chip if
setting the drive
mode fails (although the HW designers may have selected the faulty
chip then ;) ).

Regards,
Stijn Devriendt

On Sun, Apr 17, 2011 at 11:37 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> This adds two functions for struct gpio_chip chips to provide pin
> bias and drive mode settings for individual pins. Implementers does
> this a bit differently and usually there are a few possible modes you
> can select, I'm providing a few common modes for biasing and driving
> pins.
>
> Since we have no previous hacked-up arch-specific drivers for this
> we can avoid any __override_functions and we just allow this to be
> properly implemented using gpiolib. Further the function is made
> non-mandatory, if it is not defined for the chip it will be silently
> ignored.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/gpiolib.c     |   43 ++++++++++++++++++++++++++++++++++++++
>  include/asm-generic/gpio.h |   12 ++++++++++
>  include/linux/gpio.h       |   49 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 104 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 36a2974..f79f4a3 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1573,6 +1573,49 @@ void __gpio_set_value(unsigned gpio, int value)
>  EXPORT_SYMBOL_GPL(__gpio_set_value);
>
>  /**
> + * gpio_set_bias() - set a gpio's bias
> + * @gpio: gpio whose bias will be set
> + * @bias: bias mode to set
> + * Context: process
> + *
> + * This is used to directly or indirectly to implement gpio_set_bias().
> + * It invokes the associated gpio_chip.set_bias() method. Usually this
> + * applies to input pins.
> + */
> +void gpio_set_bias(unsigned gpio, enum gpio_bias bias)
> +{
> +       struct gpio_chip        *chip;
> +
> +       chip = gpio_to_chip(gpio);
> +       /* Implementing this is not mandatory */
> +       if (chip->set_bias)
> +               chip->set_bias(chip, gpio - chip->base, bias);
> +}
> +EXPORT_SYMBOL_GPL(gpio_set_bias);
> +
> +/**
> + * gpio_set_drive() - set a gpio's drive mode
> + * @gpio: gpio whose drive mode will be set
> + * @drive: drive mode to set
> + * Context: process
> + *
> + * This is used to directly or indirectly to implement gpio_set_drive().
> + * It invokes the associated gpio_chip.set_drive() method. Call this
> + * before the __gpio_set_output() function to enable special drive modes.
> + */
> +void gpio_set_drive(unsigned gpio, enum gpio_drive drive)
> +{
> +       struct gpio_chip        *chip;
> +
> +       chip = gpio_to_chip(gpio);
> +       /* Implementing this is not mandatory */
> +       if (chip->set_drive)
> +               chip->set_drive(chip, gpio - chip->base, drive);
> +}
> +EXPORT_SYMBOL_GPL(gpio_set_drive);
> +
> +
> +/**
>  * __gpio_cansleep() - report whether gpio value access will sleep
>  * @gpio: gpio in question
>  * Context: any
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index ff5c660..b4971b1 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -59,6 +59,8 @@ struct device_node;
>  *     returns either the value actually sensed, or zero
>  * @direction_output: configures signal "offset" as output, or returns error
>  * @set: assigns output value for signal "offset"
> + * @set_bias: set a certain bias for the GPIO
> + * @set_drive: set a certain drive mode for the GPIO
>  * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
>  *     implementation may not sleep
>  * @dbg_show: optional routine to show contents in debugfs; default code
> @@ -109,6 +111,14 @@ struct gpio_chip {
>        void                    (*set)(struct gpio_chip *chip,
>                                                unsigned offset, int value);
>
> +       void                    (*set_bias)(struct gpio_chip *chip,
> +                                               unsigned offset,
> +                                               enum gpio_bias bias);
> +
> +       void                    (*set_drive)(struct gpio_chip *chip,
> +                                               unsigned offset,
> +                                               enum gpio_drive drive);
> +
>        int                     (*to_irq)(struct gpio_chip *chip,
>                                                unsigned offset);
>
> @@ -158,6 +168,8 @@ extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
>  extern int gpio_get_value_cansleep(unsigned gpio);
>  extern void gpio_set_value_cansleep(unsigned gpio, int value);
>
> +extern void gpio_set_bias(unsigned gpio, enum gpio_bias bias);
> +extern void gpio_set_drive(unsigned gpio, enum gpio_drive drive);
>
>  /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
>  * the GPIO is constant and refers to some always-present controller,
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index 32720ba..6b48c15 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -3,6 +3,43 @@
>
>  /* see Documentation/gpio.txt */
>
> +/**
> + * enum gpio_bias - bias modes for GPIOs
> + * @GPIO_BIAS_FLOAT: no specific bias, the GPIO will float or state is no
> + *     controlled by software
> + * @GPIO_BIAS_PULL_UP: the GPIO will be pulled up (usually with high impedance
> + *     to VDD)
> + * @GPIO_BIAS_PULL_DOWN: the GPIO will be pulled down (usually with high
> + *     impedance to GROUND)
> + * @GPIO_BIAS_HIGH: the GPIO will be wired high, connected to VDD
> + * @GPIO_BIAS_GROUND: the GPIO will be grounded, connected to GROUND
> + */
> +enum gpio_bias {
> +       GPIO_BIAS_FLOAT,
> +       GPIO_BIAS_PULL_UP,
> +       GPIO_BIAS_PULL_DOWN,
> +       GPIO_BIAS_HIGH,
> +       GPIO_BIAS_GROUND,
> +};
> +
> +/**
> + * enum gpio_drive - drive modes for GPIOs (output)
> + * @GPIO_DRIVE_PUSH_PULL: the GPIO will be driven actively high and low, this
> + *     is the most typical case and is typically achieved with two active
> + *     transistors on the output
> + * @GPIO_DRIVE_OPEN_DRAIN: the GPIO will be driven with open drain (open
> + *     collector) which means it is usually wired with other output ports
> + *     which are then pulled up with an external resistor
> + * @GPIO_DRIVE_OPEN_SOURCE: the GPIO will be driven with open drain
> + *     (open emitter) which is the same as open drain mutatis mutandis but
> + *     pulled to ground
> + */
> +enum gpio_drive {
> +       GPIO_DRIVE_PUSH_PULL,
> +       GPIO_DRIVE_OPEN_DRAIN,
> +       GPIO_DRIVE_OPEN_SOURCE,
> +};
> +
>  #ifdef CONFIG_GENERIC_GPIO
>  #include <asm/gpio.h>
>
> @@ -90,6 +127,18 @@ static inline void gpio_set_value(unsigned gpio, int value)
>        WARN_ON(1);
>  }
>
> +static inline void gpio_set_bias(unsigned gpio, enum gpio_bias bias)
> +{
> +       /* GPIO can never have been requested */
> +       WARN_ON(1);
> +}
> +
> +static inline void gpio_set_drive(unsigned gpio, enum gpio_drive drive)
> +{
> +       /* GPIO can never have been requested */
> +       WARN_ON(1);
> +}
> +
>  static inline int gpio_cansleep(unsigned gpio)
>  {
>        /* GPIO can never have been requested or set as {in,out}put */
> --
> 1.7.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
