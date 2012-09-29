Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2I2KCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 06:02:10 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38646 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab2I2KCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 06:02:08 -0400
Message-ID: <5066C71E.9030302@kernel.org>
Date: Sat, 29 Sep 2012 11:02:06 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 07/12] staging/iio/lis3l02dq: fix building without irq_to_gpio
References: <1348868177-21205-1-git-send-email-arnd@arndb.de> <1348868177-21205-8-git-send-email-arnd@arndb.de>
In-Reply-To: <1348868177-21205-8-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 10:36 PM, Arnd Bergmann wrote:
> The driver has not been building for some time after the
> irq_to_gpio function has been removed from the kernel.
> 
> The only board in the upstream kernel that provides
> this device is the "Stargate 2", which is also maintained
> by Jonathan Cameron. Rather than working around the problem
> by adding new platform data for this driver, this patch
> uses the of_gpio framework to get to the gpio number.
> 
> However, the stargate2 code does not (yet) use DT based
> probing, so it is still broken, but at least building
> allyesconfig works again.
Will be optimistic to think anyone will convert a platform
that no one still makes (stargate 2 was pretty much intel
research only + some they gave to accademics - imote2 has
been dropped by memsic for a while now.)  If nothing else
there is little chance anyone will bother porting a remotely
up to date bootloader to these boards given how few people
are still using them for anything.

I'm happy enough with this patch.  Would prefer to
take it post merge window as a fix than now given timing.

Long run this driver will hopefully get replaced by the
unified driver for all the st accelerometers (assuming that
ever gets back to this long obsolete part).

Thanks for the patch Arnd, I've been ignoring this one on
the basis it would go away for far too long. Sorry about that!

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/iio/accel/lis3l02dq.h      |    1 +
>  drivers/staging/iio/accel/lis3l02dq_core.c |   10 ++++++----
>  drivers/staging/iio/accel/lis3l02dq_ring.c |    2 +-
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/iio/accel/lis3l02dq.h b/drivers/staging/iio/accel/lis3l02dq.h
> index f9bcd41..2bac722 100644
> --- a/drivers/staging/iio/accel/lis3l02dq.h
> +++ b/drivers/staging/iio/accel/lis3l02dq.h
> @@ -158,6 +158,7 @@ struct lis3l02dq_state {
>  	struct spi_device		*us;
>  	struct iio_trigger		*trig;
>  	struct mutex			buf_lock;
> +	int				gpio;
>  	bool				trigger_on;
>  
>  	u8	tx[LIS3L02DQ_MAX_RX] ____cacheline_aligned;
> diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
> index 21b0469..d13c7e9 100644
> --- a/drivers/staging/iio/accel/lis3l02dq_core.c
> +++ b/drivers/staging/iio/accel/lis3l02dq_core.c
> @@ -15,6 +15,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
>  #include <linux/gpio.h>
> +#include <linux/of_gpio.h>
>  #include <linux/mutex.h>
>  #include <linux/device.h>
>  #include <linux/kernel.h>
> @@ -690,6 +691,7 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
>  	spi_set_drvdata(spi, indio_dev);
>  
>  	st->us = spi;
> +	st->gpio = of_get_gpio(spi->dev.of_node, 0);
>  	mutex_init(&st->buf_lock);
>  	indio_dev->name = spi->dev.driver->name;
>  	indio_dev->dev.parent = &spi->dev;
> @@ -711,7 +713,7 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
>  		goto error_unreg_buffer_funcs;
>  	}
>  
> -	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0) {
> +	if (spi->irq) {
>  		ret = request_threaded_irq(st->us->irq,
>  					   &lis3l02dq_th,
>  					   &lis3l02dq_event_handler,
> @@ -738,10 +740,10 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
>  	return 0;
>  
>  error_remove_trigger:
> -	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)))
> +	if (spi->irq)
>  		lis3l02dq_remove_trigger(indio_dev);
>  error_free_interrupt:
> -	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0)
> +	if (spi->irq)
>  		free_irq(st->us->irq, indio_dev);
>  error_uninitialize_buffer:
>  	iio_buffer_unregister(indio_dev);
> @@ -790,7 +792,7 @@ static int __devexit lis3l02dq_remove(struct spi_device *spi)
>  	lis3l02dq_disable_all_events(indio_dev);
>  	lis3l02dq_stop_device(indio_dev);
>  
> -	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0)
> +	if (spi->irq)
>  		free_irq(st->us->irq, indio_dev);
>  
>  	lis3l02dq_remove_trigger(indio_dev);
> diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
> index fa4190d..13c0b4b 100644
> --- a/drivers/staging/iio/accel/lis3l02dq_ring.c
> +++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
> @@ -263,7 +263,7 @@ static int lis3l02dq_trig_try_reen(struct iio_trigger *trig)
>  	/* If gpio still high (or high again)
>  	 * In theory possible we will need to do this several times */
>  	for (i = 0; i < 5; i++)
> -		if (gpio_get_value(irq_to_gpio(st->us->irq)))
> +		if (gpio_get_value(st->gpio))
>  			lis3l02dq_read_all(indio_dev, NULL);
>  		else
>  			break;
> 
