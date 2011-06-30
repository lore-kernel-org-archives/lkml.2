Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab1F3Fh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:37:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34684 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752705Ab1F3FhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:37:19 -0400
Date: Wed, 29 Jun 2011 22:37:12 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: jic23@cam.ac.uk, linux-kernel@vger.kernel.org,
        Dajun <dajun.chen@diasemi.com>, grant@secretlab.ca
Subject: Re: [PATCH 02/11] GPIO: DA9052 GPIO module v1
Message-ID: <20110630053711.GB796@opensource.wolfsonmicro.com>
References: <1309355591.2344.4.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309355591.2344.4.camel@L-0532.kpit.com>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 07:23:11PM +0530, ashishj3 wrote:

> DA9052 PMIC has 16 bit GPIO bus for peripheral control.
> 
> This patch add support for the GPIO pins on the DA9052.

You need to send this to Grant, the GPIO maintainer.  CCed him.

> +config GPIO_DA9052
> +	bool "Dialog DA9052 GPIO"
> +	depends on PMIC_DA9052
> +	help
> +	  Say yes here to enable the GPIO driver for the DA9052 chip.
> +

Why only bool?

> diff --git a/drivers/gpio/da9052-gpio.c b/drivers/gpio/da9052-gpio.c
> new file mode 100755
> index 0000000..3e1f854

gpio-da9052.c

> +static int da9052_gpio_get(struct gpio_chip *gc, unsigned offset)
> +{
> +	struct da9052_gpio *gpio = to_da9052_gpio(gc);
> +	int da9052_port_direction = 0;
> +	int ret;
> +
> +	ret = da9052_reg_read(gpio->da9052,
> +			      DA9052_GPIO_0_1_REG + (offset >> 1));
> +	if (ret < 0)
> +		return ret;
> +
> +	if (da9052_gpio_port_odd(offset)) {
> +		da9052_port_direction = ret & DA9052_GPIO_ODD_PORT_PIN;
> +		da9052_port_direction >>= 4;
> +		}
> +	else
> +		da9052_port_direction = ret & DA9052_GPIO_EVEN_PORT_PIN;

The indentation here needs to be checked up.

> +static int da9052_gpio_to_irq(struct gpio_chip *gc, u32 offset)
> +{
> +	struct da9052_gpio *gpio;
> +	gpio = to_da9052_gpio(gc);
> +
> +	return gpio->gp.base + offset;
> +}

This looks like it's returning a GPIO number...  If nothing else "base"
is confusingly named and should be something like irq_base.

> +	gpio->da9052 = dev_get_drvdata(pdev->dev.parent);
> +	pdata = gpio->da9052->dev->platform_data;
> +
> +	if (pdata == NULL) {
> +		dev_err(&pdev->dev, "Failed no platform data for GPIO\n");
> +		ret = -ENOMEM;
> +		goto err_mem;
> +	}

Why insist on platform data?  gpiolib can dynamically allocate a GPIO
range to the device.
