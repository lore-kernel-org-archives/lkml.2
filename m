Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab2BMVSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:18:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64513 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab2BMVSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:18:11 -0500
Date: Mon, 13 Feb 2012 14:18:09 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: linus.walleij@stericsson.com, dunlap@xenotime.net, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1 2/3] Documentation: gpio: Add details of open-drain
 configuration
Message-ID: <20120213211809.GI11077@ponder.secretlab.ca>
References: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com>
 <1329114588-15430-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329114588-15430-3-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 11:59:47AM +0530, Laxman Dewangan wrote:
> Adding details of open drain configuration of the gpio so that
> client can set the pin as open drain at the time of gpio request.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Implicitly, the gpio api already supports open-drain and several drivers
make use of it.  Instead of being a separate flag; users who need open
drain will set the pin to input.  For example, see the i2c-gpio driver.

I'm not convinced this is needed; but my opinion could be swayed.

Linus mentioned that this should be part of pinctrl instead of the gpio API,
but I think there is an argument for making it part of the gpio API,
particularly since open-drain is pretty much a universal concept that all
gpio controllers can support (unlike driver strength) and as I said above, it
is already implicitly supported by gpiolib.  The difference with this
method is it would allow drivers like the gpio-i2c.c driver to set the
flag at gpio request time and then be able to always use gpio_set_value()
regardless of the pin mode.

However, I'm not thrilled about adding things to the already-horrible sysfs
abi.  Please drop that hunk entirely or put it into a separate patch so it
doesn't block the core functionality.

Also, you should include a patch to make i2c-gpio.c use this new
functionality as a proof-of-concept.  You may not be able to test it,
but it will make it a lot easier to justify merging by showing how it
cleans up a gpio user.

Have you though about support for lines that are pulled low instead of
high?  Those aren't as common, but it is conceivable that some
hardware would need it.

g.

> ---
>  Documentation/gpio.txt |   21 +++++++++++++++++++--
>  1 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
> index 792faa3..b08933c 100644
> --- a/Documentation/gpio.txt
> +++ b/Documentation/gpio.txt
> @@ -302,6 +302,7 @@ where 'flags' is currently defined to specify the following properties:
>  
>  	* GPIOF_INIT_LOW	- as output, set initial level to LOW
>  	* GPIOF_INIT_HIGH	- as output, set initial level to HIGH
> +	* GPIOF_OD		- gpio pin is open drain type.
>  
>  since GPIOF_INIT_* are only valid when configured as output, so group valid
>  combinations as:
> @@ -310,8 +311,7 @@ combinations as:
>  	* GPIOF_OUT_INIT_LOW	- configured as output, initial level LOW
>  	* GPIOF_OUT_INIT_HIGH	- configured as output, initial level HIGH
>  
> -In the future, these flags can be extended to support more properties such
> -as open-drain status.
> +In the future, these flags can be extended to support more properties.
>  
>  Further more, to ease the claim/release of multiple GPIOs, 'struct gpio' is
>  introduced to encapsulate all three fields as:
> @@ -641,6 +641,13 @@ and have the following read/write attributes:
>  		for "rising" and "falling" edges will follow this
>  		setting.
>  
> +	"open_drain" ... reads as either 0 (false) or 1 (true).  Write
> +		any nonzero value to make the pin in open drain.
> +		By setting open drain to true, the output can be set
> +		to HIGH by external PULL UP and setting direction to input.
> +		The output will be set to LOW by setting direction to
> +		output with value is 0.
> +
>  GPIO controllers have paths like /sys/class/gpio/gpiochip42/ (for the
>  controller implementing GPIOs starting at #42) and have the following
>  read-only attributes:
> @@ -679,6 +686,9 @@ requested using gpio_request():
>  	/* change the polarity of a GPIO node in sysfs */
>  	int gpio_sysfs_set_active_low(unsigned gpio, int value);
>  
> +	/* change the pin to open drain in sysfs */
> +	int gpio_sysfs_set_open_drain(unsigned gpio, int value);
> +
>  After a kernel driver requests a GPIO, it may only be made available in
>  the sysfs interface by gpio_export().  The driver can control whether the
>  signal direction may change.  This helps drivers prevent userspace code
> @@ -698,3 +708,10 @@ differences between boards from user space.  This only affects the
>  sysfs interface.  Polarity change can be done both before and after
>  gpio_export(), and previously enabled poll(2) support for either
>  rising or falling edge will be reconfigured to follow this setting.
> +
> +Drivers can use gpio_sysfs_set_open_drain() to enable/disable the open
> +drain property of that pins. This only affect the sysfs interface.
> +The flag will be set as open drain if thsi function is called with value
> +of 1. It is recommended to set the open drain property before setting
> +the value in output mode so that pin state cn be set properly based
> +on the value.
> -- 
> 1.7.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
