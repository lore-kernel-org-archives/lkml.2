Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2KWPwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:52:17 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60065 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2KWPwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:52:15 -0500
Date: Fri, 23 Nov 2012 15:52:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/5] Input: bu21013_ts - Move GPIO init and exit
 functions into the driver
Message-ID: <20121123155210.GD28552@gmail.com>
References: <1352900837-20759-1-git-send-email-lee.jones@linaro.org>
 <1352900837-20759-3-git-send-email-lee.jones@linaro.org>
 <20121122121030.GG4328@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121122121030.GG4328@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012, Lee Jones wrote:

> Author: Lee Jones <lee.jones@linaro.org>
> Date:   Fri Sep 28 10:29:07 2012 +0100
> 
>     Input: bu21013_ts - Move GPIO init and exit functions into the driver
>     
>     These GPIO init and exit functions have no place in platform data.
>     Instead they should be part of the driver. This patch moves them to
>     their rightful place, which subsequently elevates platform data of
>     yet more cruft.
>     
>     Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>     Cc: linux-input@vger.kernel.org
>     Acked-by: Arnd Bergmann <arnd@arndb.de>
>     Acked-by: Linus Walleij <linus.walleij@linaro.org>
>     Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> diff --git a/arch/arm/mach-ux500/board-mop500-stuib.c b/arch/arm/mach-ux500/board-mop500-stuib.c
> index 564f57d..eb19a7e 100644
> --- a/arch/arm/mach-ux500/board-mop500-stuib.c
> +++ b/arch/arm/mach-ux500/board-mop500-stuib.c
> @@ -77,9 +77,6 @@ static struct i2c_board_info __initdata mop500_i2c0_devices_stuib[] = {
>   * BU21013 ROHM touchscreen interface on the STUIBs
>   */
>  
> -/* tracks number of bu21013 devices being enabled */
> -static int bu21013_devices;
> -
>  #define TOUCH_GPIO_PIN  84
>  
>  #define TOUCH_XMAX	384
> @@ -88,73 +85,8 @@ static int bu21013_devices;
>  #define PRCMU_CLOCK_OCR		0x1CC
>  #define TSC_EXT_CLOCK_9_6MHZ	0x840000
>  
> -/**
> - * bu21013_gpio_board_init : configures the touch panel.
> - * @reset_pin: reset pin number
> - * This function can be used to configures
> - * the voltage and reset the touch panel controller.
> - */
> -static int bu21013_gpio_board_init(int reset_pin)
> -{
> -	int retval = 0;
> -
> -	bu21013_devices++;
> -	if (bu21013_devices == 1) {
> -		retval = gpio_request(reset_pin, "touchp_reset");
> -		if (retval) {
> -			printk(KERN_ERR "Unable to request gpio reset_pin");
> -			return retval;
> -		}
> -		retval = gpio_direction_output(reset_pin, 1);
> -		if (retval < 0) {
> -			printk(KERN_ERR "%s: gpio direction failed\n",
> -					__func__);
> -			return retval;
> -		}
> -	}
> -
> -	return retval;
> -}
> -
> -/**
> - * bu21013_gpio_board_exit : deconfigures the touch panel controller
> - * @reset_pin: reset pin number
> - * This function can be used to deconfigures the chip selection
> - * for touch panel controller.
> - */
> -static int bu21013_gpio_board_exit(int reset_pin)
> -{
> -	int retval = 0;
> -
> -	if (bu21013_devices == 1) {
> -		retval = gpio_direction_output(reset_pin, 0);
> -		if (retval < 0) {
> -			printk(KERN_ERR "%s: gpio direction failed\n",
> -					__func__);
> -			return retval;
> -		}
> -		gpio_set_value(reset_pin, 0);
> -	}
> -	bu21013_devices--;
> -
> -	return retval;
> -}
> -
> -/**
> - * bu21013_read_pin_val : get the interrupt pin value
> - * This function can be used to get the interrupt pin value for touch panel
> - * controller.
> - */
> -static int bu21013_read_pin_val(void)
> -{
> -	return gpio_get_value(TOUCH_GPIO_PIN);
> -}
> -
>  static struct bu21013_platform_device tsc_plat_device = {
> -	.cs_en = bu21013_gpio_board_init,
> -	.cs_dis = bu21013_gpio_board_exit,
> -	.irq_read_val = bu21013_read_pin_val,
> -	.irq = NOMADIK_GPIO_TO_IRQ(TOUCH_GPIO_PIN),
> +	.touch_pin = TOUCH_GPIO_PIN,
>  	.touch_x_max = TOUCH_XMAX,
>  	.touch_y_max = TOUCH_YMAX,
>  	.ext_clk = false,
> diff --git a/drivers/input/touchscreen/bu21013_ts.c b/drivers/input/touchscreen/bu21013_ts.c
> index 2fae682..08ffb19 100644
> --- a/drivers/input/touchscreen/bu21013_ts.c
> +++ b/drivers/input/touchscreen/bu21013_ts.c
> @@ -14,6 +14,7 @@
>  #include <linux/slab.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/module.h>
> +#include <linux/gpio.h>
>  
>  #define PEN_DOWN_INTR	0
>  #define MAX_FINGERS	2
> @@ -262,7 +263,7 @@ static irqreturn_t bu21013_gpio_irq(int irq, void *device_data)
>  			return IRQ_NONE;
>  		}
>  
> -		data->intr_pin = data->chip->irq_read_val();
> +		data->intr_pin = gpio_get_value(data->chip->touch_pin);
>  		if (data->intr_pin == PEN_DOWN_INTR)
>  			wait_event_timeout(data->wait, data->touch_stopped,
>  					   msecs_to_jiffies(2));
> @@ -272,6 +273,54 @@ static irqreturn_t bu21013_gpio_irq(int irq, void *device_data)
>  }
>  
>  /**
> + * bu21013_gpio_board_init() - configures the touch panel
> + * @reset_pin: reset pin number
> + *
> + * This function is used to configure the voltage and
> + * reset the touch panel controller.
> + */
> +static int bu21013_gpio_board_init(int reset_pin)
> +{
> +	int retval = 0;
> +
> +	retval = gpio_request(reset_pin, "touchp_reset");
> +	if (retval) {
> +		printk(KERN_ERR "Unable to request gpio reset_pin");
> +		return retval;
> +	}
> +	retval = gpio_direction_output(reset_pin, 1);
> +	if (retval < 0) {
> +		printk(KERN_ERR "%s: gpio direction failed\n",
> +		       __func__);
> +		return retval;
> +	}
> +
> +	return retval;
> +}
> +
> +/**
> + * bu21013_gpio_board_exit() - deconfigures the touch panel controller
> + * @reset_pin: reset pin number
> + *
> + * This function is used to deconfigure the chip selection
> + * for touch panel controller.
> + */
> +static int bu21013_gpio_board_exit(int reset_pin)
> +{
> +	int retval = 0;
> +
> +	retval = gpio_direction_output(reset_pin, 0);
> +	if (retval < 0) {
> +		printk(KERN_ERR "%s: gpio direction failed\n",
> +		       __func__);
> +		return retval;
> +	}
> +	gpio_set_value(reset_pin, 0);
> +
> +	return retval;
> +}
> +
> +/**
>   * bu21013_init_chip() - power on sequence for the bu21013 controller
>   * @data: device structure pointer
>   *
> @@ -449,6 +498,8 @@ static int __devinit bu21013_probe(struct i2c_client *client,
>  		return -EINVAL;
>  	}
>  
> +	pdata->irq = gpio_to_irq(pdata->touch_pin);
> +
>  	bu21013_data = kzalloc(sizeof(struct bu21013_ts_data), GFP_KERNEL);
>  	in_dev = input_allocate_device();
>  	if (!bu21013_data || !in_dev) {
> @@ -478,12 +529,10 @@ static int __devinit bu21013_probe(struct i2c_client *client,
>  	init_waitqueue_head(&bu21013_data->wait);
>  
>  	/* configure the gpio pins */
> -	if (pdata->cs_en) {
> -		error = pdata->cs_en(pdata->cs_pin);
> -		if (error < 0) {
> -			dev_err(&client->dev, "chip init failed\n");
> -			goto err_disable_regulator;
> -		}
> +	error = bu21013_gpio_board_init(pdata->cs_pin);
> +	if (error < 0) {
> +		dev_err(&client->dev, "chip init failed\n");
> +		goto err_disable_regulator;
>  	}
>  
>  	/* configure the touch panel controller */
> @@ -531,7 +580,7 @@ static int __devinit bu21013_probe(struct i2c_client *client,
>  err_free_irq:
>  	bu21013_free_irq(bu21013_data);
>  err_cs_disable:
> -	pdata->cs_dis(pdata->cs_pin);
> +	bu21013_gpio_board_exit(pdata->cs_pin);
>  err_disable_regulator:
>  	regulator_disable(bu21013_data->regulator);
>  err_put_regulator:
> @@ -555,7 +604,7 @@ static int __devexit bu21013_remove(struct i2c_client *client)
>  
>  	bu21013_free_irq(bu21013_data);
>  
> -	bu21013_data->chip->cs_dis(bu21013_data->chip->cs_pin);
> +	bu21013_gpio_board_exit(bu21013_data->chip->cs_pin);
>  
>  	input_unregister_device(bu21013_data->in_dev);
>  
> diff --git a/include/linux/input/bu21013.h b/include/linux/input/bu21013.h
> index 05e0328..01a2975 100644
> --- a/include/linux/input/bu21013.h
> +++ b/include/linux/input/bu21013.h
> @@ -9,13 +9,11 @@
>  
>  /**
>   * struct bu21013_platform_device - Handle the platform data
> - * @cs_en:	pointer to the cs enable function
> - * @cs_dis:	pointer to the cs disable function
> - * @irq_read_val:    pointer to read the pen irq value function
>   * @touch_x_max: touch x max
>   * @touch_y_max: touch y max
>   * @cs_pin: chip select pin
>   * @irq: irq pin
> + * @touch_pin: touch gpio pin
>   * @ext_clk: external clock flag
>   * @x_flip: x flip flag
>   * @y_flip: y flip flag
> @@ -24,13 +22,11 @@
>   * This is used to handle the platform data
>   */
>  struct bu21013_platform_device {
> -	int (*cs_en)(int reset_pin);
> -	int (*cs_dis)(int reset_pin);
> -	int (*irq_read_val)(void);
>  	int touch_x_max;
>  	int touch_y_max;
>  	unsigned int cs_pin;
>  	unsigned int irq;
> +	unsigned int touch_pin;
>  	bool ext_clk;
>  	bool x_flip;
>  	bool y_flip;

Friendly poke for Dmitry.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
