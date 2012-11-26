Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab2KZKnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:43:49 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53737 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab2KZKns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:43:48 -0500
Date: Mon, 26 Nov 2012 10:43:41 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/5] Input: bu21013_ts - Move GPIO init and exit
 functions into the driver
Message-ID: <20121126104341.GE12782@gmail.com>
References: <1352900837-20759-1-git-send-email-lee.jones@linaro.org>
 <1352900837-20759-3-git-send-email-lee.jones@linaro.org>
 <20121122121030.GG4328@gmail.com>
 <20121124074359.GA24711@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121124074359.GA24711@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012, Dmitry Torokhov wrote:

> Hi Lee,
> 
> On Thu, Nov 22, 2012 at 12:10:30PM +0000, Lee Jones wrote:
> >  
> >  /**
> > + * bu21013_gpio_board_init() - configures the touch panel
> > + * @reset_pin: reset pin number
> > + *
> > + * This function is used to configure the voltage and
> > + * reset the touch panel controller.
> > + */
> > +static int bu21013_gpio_board_init(int reset_pin)
> > +{
> > +	int retval = 0;
> > +
> > +	retval = gpio_request(reset_pin, "touchp_reset");
> > +	if (retval) {
> > +		printk(KERN_ERR "Unable to request gpio reset_pin");
> > +		return retval;
> > +	}
> > +	retval = gpio_direction_output(reset_pin, 1);
> > +	if (retval < 0) {
> > +		printk(KERN_ERR "%s: gpio direction failed\n",
> > +		       __func__);
> > +		return retval;
> > +	}
> 
> gpio_request_one() is handy here.

Okay, I'll look into that.

> > +
> > +	return retval;
> > +}
> > +
> > +/**
> > + * bu21013_gpio_board_exit() - deconfigures the touch panel controller
> > + * @reset_pin: reset pin number
> > + *
> > + * This function is used to deconfigure the chip selection
> > + * for touch panel controller.
> > + */
> > +static int bu21013_gpio_board_exit(int reset_pin)
> > +{
> > +	int retval = 0;
> > +
> > +	retval = gpio_direction_output(reset_pin, 0);
> > +	if (retval < 0) {
> > +		printk(KERN_ERR "%s: gpio direction failed\n",
> > +		       __func__);
> > +		return retval;
> > +	}
> > +	gpio_set_value(reset_pin, 0);
> > +
> 
> You ate forgetting to free gpio here. TBH the original did forget too.
> 
> 
> > +	return retval;
> > +}
> > +
> > +/**
> >   * bu21013_init_chip() - power on sequence for the bu21013 controller
> >   * @data: device structure pointer
> >   *
> > @@ -449,6 +498,8 @@ static int __devinit bu21013_probe(struct i2c_client *client,
> >  		return -EINVAL;
> >  	}
> >  
> > +	pdata->irq = gpio_to_irq(pdata->touch_pin);
> > +
> 
> Does it even compile? pdata is const...
> 
> Does the version below still work for you?

The version I sent you works. I have a working touchscreen.

> Thanks.
> 
> -- 
> Dmitry
> 
> Input: bu21013_ts - move GPIO init and exit functions into the driver
> 
> From: Lee Jones <lee.jones@linaro.org>
> 
> These GPIO init and exit functions have no place in platform data, they
> should be part of the driver instead,
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  arch/arm/mach-ux500/board-mop500-stuib.c |   95 +-----------------------------
>  drivers/input/touchscreen/bu21013_ts.c   |   69 ++++++++++++++++------
>  include/linux/input/bu21013.h            |    9 +--
>  3 files changed, 56 insertions(+), 117 deletions(-)
> 
> diff --git a/arch/arm/mach-ux500/board-mop500-stuib.c b/arch/arm/mach-ux500/board-mop500-stuib.c
> index 8c97977..1243428 100644
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
> @@ -88,85 +85,8 @@ static int bu21013_devices;
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
> -	.touch_x_max = TOUCH_XMAX,
> -	.touch_y_max = TOUCH_YMAX,
> -	.ext_clk = false,
> -	.x_flip = false,
> -	.y_flip = true,
> -};
> -
> -static struct bu21013_platform_device tsc_plat2_device = {
> -	.cs_en = bu21013_gpio_board_init,
> -	.cs_dis = bu21013_gpio_board_exit,
> -	.irq_read_val = bu21013_read_pin_val,
> -	.irq = NOMADIK_GPIO_TO_IRQ(TOUCH_GPIO_PIN),
> +	.touch_pin = TOUCH_GPIO_PIN,
>  	.touch_x_max = TOUCH_XMAX,
>  	.touch_y_max = TOUCH_YMAX,
>  	.ext_clk = false,
> @@ -181,21 +101,14 @@ static struct i2c_board_info __initdata u8500_i2c3_devices_stuib[] = {
>  	},
>  	{
>  		I2C_BOARD_INFO("bu21013_tp", 0x5D),
> -		.platform_data = &tsc_plat2_device,
> +		.platform_data = &tsc_plat_device,
>  	},
> -
>  };
>  
>  void __init mop500_stuib_init(void)
>  {
> -	if (machine_is_hrefv60()) {
> -		tsc_plat_device.cs_pin = HREFV60_TOUCH_RST_GPIO;
> -		tsc_plat2_device.cs_pin = HREFV60_TOUCH_RST_GPIO;
> -	} else {
> -		tsc_plat_device.cs_pin = GPIO_BU21013_CS;
> -		tsc_plat2_device.cs_pin = GPIO_BU21013_CS;
> -
> -	}
> +	tsc_plat_device.cs_pin = machine_is_hrefv60() ?
> +				HREFV60_TOUCH_RST_GPIO : GPIO_BU21013_CS;
>  
>  	mop500_uib_i2c_add(0, mop500_i2c0_devices_stuib,
>  			ARRAY_SIZE(mop500_i2c0_devices_stuib));
> diff --git a/drivers/input/touchscreen/bu21013_ts.c b/drivers/input/touchscreen/bu21013_ts.c
> index 1e8cddd..88f4252 100644
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
> @@ -148,11 +149,12 @@
>  struct bu21013_ts_data {
>  	struct i2c_client *client;
>  	wait_queue_head_t wait;
> -	bool touch_stopped;
>  	const struct bu21013_platform_device *chip;
>  	struct input_dev *in_dev;
> -	unsigned int intr_pin;
>  	struct regulator *regulator;
> +	unsigned int irq;
> +	unsigned int intr_pin;
> +	bool touch_stopped;
>  };
>  
>  /**
> @@ -262,7 +264,7 @@ static irqreturn_t bu21013_gpio_irq(int irq, void *device_data)
>  			return IRQ_NONE;
>  		}
>  
> -		data->intr_pin = data->chip->irq_read_val();
> +		data->intr_pin = gpio_get_value(data->chip->touch_pin);
>  		if (data->intr_pin == PEN_DOWN_INTR)
>  			wait_event_timeout(data->wait, data->touch_stopped,
>  					   msecs_to_jiffies(2));
> @@ -418,10 +420,33 @@ static void bu21013_free_irq(struct bu21013_ts_data *bu21013_data)
>  {
>  	bu21013_data->touch_stopped = true;
>  	wake_up(&bu21013_data->wait);
> -	free_irq(bu21013_data->chip->irq, bu21013_data);
> +	free_irq(bu21013_data->irq, bu21013_data);
>  }
>  
>  /**
> + * bu21013_cs_disable() - deconfigures the touch panel controller
> + * @bu21013_data: device structure pointer
> + *
> + * This function is used to deconfigure the chip selection
> + * for touch panel controller.
> + */
> +static void bu21013_cs_disable(struct bu21013_ts_data *bu21013_data)
> +{
> +	int error;
> +
> +	error = gpio_direction_output(bu21013_data->chip->cs_pin, 0);
> +	if (error < 0)
> +		dev_warn(&bu21013_data->client->dev,
> +			 "%s: gpio direction failed, error: %d\n",
> +			 __func__, error);
> +	else
> +		gpio_set_value(bu21013_data->chip->cs_pin, 0);
> +
> +	gpio_free(bu21013_data->chip->cs_pin);
> +}
> +
> +
> +/**
>   * bu21013_probe() - initializes the i2c-client touchscreen driver
>   * @client: i2c client structure pointer
>   * @id: i2c device id pointer
> @@ -430,7 +455,7 @@ static void bu21013_free_irq(struct bu21013_ts_data *bu21013_data)
>   * driver and returns integer.
>   */
>  static int bu21013_probe(struct i2c_client *client,
> -					const struct i2c_device_id *id)
> +			 const struct i2c_device_id *id)
>  {
>  	struct bu21013_ts_data *bu21013_data;
>  	struct input_dev *in_dev;
> @@ -449,6 +474,11 @@ static int bu21013_probe(struct i2c_client *client,
>  		return -EINVAL;
>  	}
>  
> +	if (!gpio_is_valid(pdata->touch_pin)) {
> +		dev_err(&client->dev, "invalid touch_pin supplied\n");
> +		return -EINVAL;
> +	}
> +
>  	bu21013_data = kzalloc(sizeof(struct bu21013_ts_data), GFP_KERNEL);
>  	in_dev = input_allocate_device();
>  	if (!bu21013_data || !in_dev) {
> @@ -460,6 +490,7 @@ static int bu21013_probe(struct i2c_client *client,
>  	bu21013_data->in_dev = in_dev;
>  	bu21013_data->chip = pdata;
>  	bu21013_data->client = client;
> +	bu21013_data->irq = gpio_to_irq(pdata->touch_pin);
>  
>  	bu21013_data->regulator = regulator_get(&client->dev, "avdd");
>  	if (IS_ERR(bu21013_data->regulator)) {
> @@ -478,12 +509,11 @@ static int bu21013_probe(struct i2c_client *client,
>  	init_waitqueue_head(&bu21013_data->wait);
>  
>  	/* configure the gpio pins */
> -	if (pdata->cs_en) {
> -		error = pdata->cs_en(pdata->cs_pin);
> -		if (error < 0) {
> -			dev_err(&client->dev, "chip init failed\n");
> -			goto err_disable_regulator;
> -		}
> +	error = gpio_request_one(pdata->cs_pin, GPIOF_DIR_OUT | GPIOF_INIT_HIGH,
> +				 "touchp_reset");
> +	if (error < 0) {
> +		dev_err(&client->dev, "Unable to request gpio reset_pin\n");
> +		goto err_disable_regulator;
>  	}
>  
>  	/* configure the touch panel controller */
> @@ -508,12 +538,13 @@ static int bu21013_probe(struct i2c_client *client,
>  						pdata->touch_y_max, 0, 0);
>  	input_set_drvdata(in_dev, bu21013_data);
>  
> -	error = request_threaded_irq(pdata->irq, NULL, bu21013_gpio_irq,
> +	error = request_threaded_irq(bu21013_data->irq, NULL, bu21013_gpio_irq,
>  				     IRQF_TRIGGER_FALLING | IRQF_SHARED |
>  					IRQF_ONESHOT,
>  				     DRIVER_TP, bu21013_data);
>  	if (error) {
> -		dev_err(&client->dev, "request irq %d failed\n", pdata->irq);
> +		dev_err(&client->dev, "request irq %d failed\n",
> +			bu21013_data->irq);
>  		goto err_cs_disable;
>  	}
>  
> @@ -531,7 +562,7 @@ static int bu21013_probe(struct i2c_client *client,
>  err_free_irq:
>  	bu21013_free_irq(bu21013_data);
>  err_cs_disable:
> -	pdata->cs_dis(pdata->cs_pin);
> +	bu21013_cs_disable(bu21013_data);
>  err_disable_regulator:
>  	regulator_disable(bu21013_data->regulator);
>  err_put_regulator:
> @@ -555,7 +586,7 @@ static int bu21013_remove(struct i2c_client *client)
>  
>  	bu21013_free_irq(bu21013_data);
>  
> -	bu21013_data->chip->cs_dis(bu21013_data->chip->cs_pin);
> +	bu21013_cs_disable(bu21013_data);
>  
>  	input_unregister_device(bu21013_data->in_dev);
>  
> @@ -584,9 +615,9 @@ static int bu21013_suspend(struct device *dev)
>  
>  	bu21013_data->touch_stopped = true;
>  	if (device_may_wakeup(&client->dev))
> -		enable_irq_wake(bu21013_data->chip->irq);
> +		enable_irq_wake(bu21013_data->irq);
>  	else
> -		disable_irq(bu21013_data->chip->irq);
> +		disable_irq(bu21013_data->irq);
>  
>  	regulator_disable(bu21013_data->regulator);
>  
> @@ -621,9 +652,9 @@ static int bu21013_resume(struct device *dev)
>  	bu21013_data->touch_stopped = false;
>  
>  	if (device_may_wakeup(&client->dev))
> -		disable_irq_wake(bu21013_data->chip->irq);
> +		disable_irq_wake(bu21013_data->irq);
>  	else
> -		enable_irq(bu21013_data->chip->irq);
> +		enable_irq(bu21013_data->irq);
>  
>  	return 0;
>  }
> diff --git a/include/linux/input/bu21013.h b/include/linux/input/bu21013.h
> index 05e0328..3ad1be5 100644
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
> @@ -24,13 +22,10 @@
>   * This is used to handle the platform data
>   */
>  struct bu21013_platform_device {
> -	int (*cs_en)(int reset_pin);
> -	int (*cs_dis)(int reset_pin);
> -	int (*irq_read_val)(void);
>  	int touch_x_max;
>  	int touch_y_max;
>  	unsigned int cs_pin;
> -	unsigned int irq;
> +	unsigned int touch_pin;
>  	bool ext_clk;
>  	bool x_flip;
>  	bool y_flip;

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
