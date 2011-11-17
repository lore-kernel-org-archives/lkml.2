Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab1KQP3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:29:25 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:45030
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932128Ab1KQP3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:29:24 -0500
Message-ID: <4EC52842.8020906@compulab.co.il>
Date: Thu, 17 Nov 2011 17:29:06 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2] pinctrl: indicate GPIO direction on single GPIO request
References: <1321537582-8624-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1321537582-8624-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

You haven't responded to my request for the previous version...
Pleaser, see below:

On 11/17/11 15:46, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> When requesting a single GPIO pin to be muxed in, some controllers
> will need to poke a different value into the control register
> depending on whether the pin will be used for GPIO output or GPIO
> input. So pass this info along for the gpio_request_enable()
> function, we assume this is not needed for the gpio_free_disable()
> function for the time being.
> 
> ChangeLog V1->V2:
> - This also amends the documentation to make it clear the this
>   function and associated machinery is *ONLY* intended as a backend
>   to gpiolib machinery, not for everyone and his dog to start playing
>   around with pins.
> 
> Suggested-by: Thomas Abraham <thomas.abraham@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  Documentation/pinctrl.txt      |   30 +++++++++++++++++++++---------
>  drivers/pinctrl/pinmux.c       |   26 +++++++++++++++++++++-----
>  include/linux/pinctrl/pinmux.h |   14 ++++++++++----
>  3 files changed, 52 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index 214b961..226f252 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -645,6 +645,15 @@ All the above functions are mandatory to implement for a pinmux driver.
>  Pinmux interaction with the GPIO subsystem
>  ==========================================
>  
> +The public pinmux API contains two functions named pinmux_request_gpio()
> +and pinmux_free_gpio(). These two functions shall *ONLY* be called from
> +gpiolib-based drivers as part of their gpio_request() and
> +gpio_direction_[input|output() semantics.
> +
> +NOTE that platforms and individual driver shall *NOT* request GPIO pins to be
> +muxed in. Instead, implement a proper gpiolib driver hand have that driver
> +request proper muxing for its pins.
> +
>  The function list could become long, especially if you can convert every
>  individual pin into a GPIO pin independent of any other pins, and then try
>  the approach to define every pin as a function.
> @@ -652,19 +661,22 @@ the approach to define every pin as a function.
>  In this case, the function array would become 64 entries for each GPIO
>  setting and then the device functions.
>  
> -For this reason there is an additional function a pinmux driver can implement
> -to enable only GPIO on an individual pin: .gpio_request_enable(). The same
> -.free() function as for other functions is assumed to be usable also for
> -GPIO pins.
> +For this reason there are two functions a pinmux driver can implement
> +to enable only GPIO on an individual pin: .gpio_request_enable() and
> +.gpio_disable_free().
>  
>  This function will pass in the affected GPIO range identified by the pin
>  controller core, so you know which GPIO pins are being affected by the request
> -operation.
> +operation. The gpio_request_enable() call will also indicate if the pin shall
> +be multiplexed for input or output as some pin controllers have different
> +multiplexing settings for these two cases.
>  
> -Alternatively it is fully allowed to use named functions for each GPIO
> -pin, the pinmux_request_gpio() will attempt to obtain the function "gpioN"
> -where "N" is the global GPIO pin number if no special GPIO-handler is
> -registered.
> +Alternatively to using these special functions, it is fully allowed to use
> +named functions for each GPIO pin, the pinmux_request_gpio() will attempt to
> +obtain the function "gpioN" where "N" is the global GPIO pin number if no
> +special GPIO-handler is registered.
> +
> +The public functions to enable a certain GPIO pin
>  
>  
>  Pinmux board/machine configuration
> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> index d27b77d..9c46e5e 100644
> --- a/drivers/pinctrl/pinmux.c
> +++ b/drivers/pinctrl/pinmux.c
> @@ -100,10 +100,13 @@ struct pinmux_hog {
>   *	means that you want to mux in the pin for use as GPIO number NN
>   * @gpio_range: the range matching the GPIO pin if this is a request for a
>   *	single GPIO pin
> + * @gpio_direction: if the pin is muxed for GPIO, this provides the direction
> + *	of the GPIO @true means output, @false means input
>   */
>  static int pin_request(struct pinctrl_dev *pctldev,
>  		       int pin, const char *function,
> -		       struct pinctrl_gpio_range *gpio_range)
> +		       struct pinctrl_gpio_range *gpio_range,
> +		       bool gpio_direction)

can this (and other instances) be:
s/gpio_direction/gpio_direction_out/
?
Because "gpio_direction == true/false" does not make much sense.
OTOH, "gpio_direction_out == true/false" does make sense.

>  {
>  	struct pin_desc *desc;
>  	const struct pinmux_ops *ops = pctldev->desc->pmxops;
> @@ -148,7 +151,8 @@ static int pin_request(struct pinctrl_dev *pctldev,
>  	 */
>  	if (gpio_range && ops->gpio_request_enable)
>  		/* This requests and enables a single GPIO pin */
> -		status = ops->gpio_request_enable(pctldev, gpio_range, pin);
> +	  status = ops->gpio_request_enable(pctldev, gpio_range, pin,
> +					    gpio_direction);
>  	else if (ops->request)
>  		status = ops->request(pctldev, pin);
>  	else
> @@ -218,8 +222,15 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
>  /**
>   * pinmux_request_gpio() - request a single pin to be muxed in as GPIO
>   * @gpio: the GPIO pin number from the GPIO subsystem number space
> + * @direction: the direction of the GPIO, @true means output, @false
> + *	means input
> + *
> + * This function should *ONLY* be used from gpiolib-based GPIO drivers,
> + * as part of their gpio_request() and gpio_direction_[input|output()
> + * semantics, platforms and individual driver shall *NOT* request GPIO pins to
> + * be muxed in.
>   */
> -int pinmux_request_gpio(unsigned gpio)
> +int pinmux_request_gpio(unsigned gpio, bool direction)
>  {
>  	char gpiostr[16];
>  	const char *function;
> @@ -242,7 +253,7 @@ int pinmux_request_gpio(unsigned gpio)
>  	if (!function)
>  		return -EINVAL;
>  
> -	ret = pin_request(pctldev, pin, function, range);
> +	ret = pin_request(pctldev, pin, function, range, direction);
>  	if (ret < 0)
>  		kfree(function);
>  
> @@ -253,6 +264,11 @@ EXPORT_SYMBOL_GPL(pinmux_request_gpio);
>  /**
>   * pinmux_free_gpio() - free a single pin, currently used as GPIO
>   * @gpio: the GPIO pin number from the GPIO subsystem number space
> + *
> + * This function should *ONLY* be used from gpiolib-based GPIO drivers,
> + * as part of their gpio_request() and gpio_direction_[input|output()
> + * semantics, platforms and individual driver shall *NOT* request GPIO pins to
> + * be muxed in.
>   */
>  void pinmux_free_gpio(unsigned gpio)
>  {
> @@ -360,7 +376,7 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
>  
>  	/* Try to allocate all pins in this group, one by one */
>  	for (i = 0; i < num_pins; i++) {
> -		ret = pin_request(pctldev, pins[i], func, NULL);
> +	  ret = pin_request(pctldev, pins[i], func, NULL, false);
>  		if (ret) {
>  			dev_err(&pctldev->dev,
>  				"could not get pin %d for function %s "
> diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
> index bb7a979..7d3841f 100644
> --- a/include/linux/pinctrl/pinmux.h
> +++ b/include/linux/pinctrl/pinmux.h
> @@ -54,7 +54,12 @@ struct pinctrl_dev;
>   *	Implement this only if you can mux every pin individually as GPIO. The
>   *	affected GPIO range is passed along with an offset(pin number) into that
>   *	specific GPIO range - function selectors and pin groups are orthogonal
> - *	to this, the core will however make sure the pins do not collide
> + *	to this, the core will however make sure the pins do not collide. Since
> + *	controllers may be needing different configurations depending on
> + *	whether the GPIO is configured as input or output, a direction
> + *	indicator is passed along
> + * @gpio_disable_free: free up GPIO muxing on a certain pin, the reverse of
> + *	@gpio_request_enable
>   */
>  struct pinmux_ops {
>  	int (*request) (struct pinctrl_dev *pctldev, unsigned offset);
> @@ -72,14 +77,15 @@ struct pinmux_ops {
>  			 unsigned group_selector);
>  	int (*gpio_request_enable) (struct pinctrl_dev *pctldev,
>  				    struct pinctrl_gpio_range *range,
> -				    unsigned offset);
> +				    unsigned offset,
> +				    bool direction);
>  	void (*gpio_disable_free) (struct pinctrl_dev *pctldev,
>  				   struct pinctrl_gpio_range *range,
>  				   unsigned offset);
>  };
>  
>  /* External interface to pinmux */
> -extern int pinmux_request_gpio(unsigned gpio);
> +extern int pinmux_request_gpio(unsigned gpio, bool direction);
>  extern void pinmux_free_gpio(unsigned gpio);
>  extern struct pinmux * __must_check pinmux_get(struct device *dev, const char *name);
>  extern void pinmux_put(struct pinmux *pmx);
> @@ -88,7 +94,7 @@ extern void pinmux_disable(struct pinmux *pmx);
>  
>  #else /* !CONFIG_PINMUX */
>  
> -static inline int pinmux_request_gpio(unsigned gpio)
> +static inline int pinmux_request_gpio(unsigned gpio, bool direction)
>  {
>  	return 0;
>  }

-- 
Regards,
Igor.
