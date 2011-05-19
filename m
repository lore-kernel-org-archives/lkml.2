Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250Ab1ESSQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:16:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35870 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934055Ab1ESSQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:16:20 -0400
Date: Thu, 19 May 2011 12:16:15 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH] gpio: add trace events for setting direction and value
Message-ID: <20110519181615.GB5109@ponder.secretlab.ca>
References: <1297875784-2302-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297875784-2302-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 06:03:04PM +0100, Uwe Kleine-König wrote:
> This patch allows to trace gpio operations using ftrace
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Applied, thanks.

g.

> ---
> Hello,
> 
> two things that could be optimised later are:
> 
>  - combine gpio_direction_output into a single event?
>  - record _cansleep?
> 
> Best regards
> Uwe
> 
>  drivers/gpio/gpiolib.c      |   18 ++++++++++++-
>  include/trace/events/gpio.h |   56 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 72 insertions(+), 2 deletions(-)
>  create mode 100644 include/trace/events/gpio.h
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 649550e..5fc5e2d 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -12,6 +12,8 @@
>  #include <linux/idr.h>
>  #include <linux/slab.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/gpio.h>
>  
>  /* Optional implementation infrastructure for GPIO interfaces.
>   *
> @@ -1404,6 +1406,8 @@ int gpio_direction_input(unsigned gpio)
>  	status = chip->direction_input(chip, gpio);
>  	if (status == 0)
>  		clear_bit(FLAG_IS_OUT, &desc->flags);
> +
> +	trace_gpio_direction(chip->base + gpio, 1, status);
>  lose:
>  	return status;
>  fail:
> @@ -1457,6 +1461,8 @@ int gpio_direction_output(unsigned gpio, int value)
>  	status = chip->direction_output(chip, gpio, value);
>  	if (status == 0)
>  		set_bit(FLAG_IS_OUT, &desc->flags);
> +	trace_gpio_value(chip->base + gpio, 0, value);
> +	trace_gpio_direction(chip->base + gpio, 0, status);
>  lose:
>  	return status;
>  fail:
> @@ -1546,10 +1552,13 @@ EXPORT_SYMBOL_GPL(gpio_set_debounce);
>  int __gpio_get_value(unsigned gpio)
>  {
>  	struct gpio_chip	*chip;
> +	int value;
>  
>  	chip = gpio_to_chip(gpio);
>  	WARN_ON(chip->can_sleep);
> -	return chip->get ? chip->get(chip, gpio - chip->base) : 0;
> +	value = chip->get ? chip->get(chip, gpio - chip->base) : 0;
> +	trace_gpio_value(gpio, 1, value);
> +	return value;
>  }
>  EXPORT_SYMBOL_GPL(__gpio_get_value);
>  
> @@ -1568,6 +1577,7 @@ void __gpio_set_value(unsigned gpio, int value)
>  
>  	chip = gpio_to_chip(gpio);
>  	WARN_ON(chip->can_sleep);
> +	trace_gpio_value(gpio, 0, value);
>  	chip->set(chip, gpio - chip->base, value);
>  }
>  EXPORT_SYMBOL_GPL(__gpio_set_value);
> @@ -1618,10 +1628,13 @@ EXPORT_SYMBOL_GPL(__gpio_to_irq);
>  int gpio_get_value_cansleep(unsigned gpio)
>  {
>  	struct gpio_chip	*chip;
> +	int value;
>  
>  	might_sleep_if(extra_checks);
>  	chip = gpio_to_chip(gpio);
> -	return chip->get ? chip->get(chip, gpio - chip->base) : 0;
> +	value = chip->get ? chip->get(chip, gpio - chip->base) : 0;
> +	trace_gpio_value(gpio, 1, value);
> +	return value;
>  }
>  EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
>  
> @@ -1631,6 +1644,7 @@ void gpio_set_value_cansleep(unsigned gpio, int value)
>  
>  	might_sleep_if(extra_checks);
>  	chip = gpio_to_chip(gpio);
> +	trace_gpio_value(gpio, 0, value);
>  	chip->set(chip, gpio - chip->base, value);
>  }
>  EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
> diff --git a/include/trace/events/gpio.h b/include/trace/events/gpio.h
> new file mode 100644
> index 0000000..927a8ad
> --- /dev/null
> +++ b/include/trace/events/gpio.h
> @@ -0,0 +1,56 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM gpio
> +
> +#if !defined(_TRACE_GPIO_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_GPIO_H
> +
> +#include <linux/tracepoint.h>
> +
> +TRACE_EVENT(gpio_direction,
> +
> +	TP_PROTO(unsigned gpio, int in, int err),
> +
> +	TP_ARGS(gpio, in, err),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned, gpio)
> +		__field(int, in)
> +		__field(int, err)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->gpio = gpio;
> +		__entry->in = in;
> +		__entry->err = err;
> +	),
> +
> +	TP_printk("%u %3s (%d)", __entry->gpio,
> +		__entry->in ? "in" : "out", __entry->err)
> +);
> +
> +TRACE_EVENT(gpio_value,
> +
> +	TP_PROTO(unsigned gpio, int get, int value),
> +
> +	TP_ARGS(gpio, get, value),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned, gpio)
> +		__field(int, get)
> +		__field(int, value)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->gpio = gpio;
> +		__entry->get = get;
> +		__entry->value = value;
> +	),
> +
> +	TP_printk("%u %3s %d", __entry->gpio,
> +		__entry->get ? "get" : "set", __entry->value)
> +);
> +
> +#endif /* if !defined(_TRACE_GPIO_H) || defined(TRACE_HEADER_MULTI_READ) */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> -- 
> 1.7.2.3
> 
