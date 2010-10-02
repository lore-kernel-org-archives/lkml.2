Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab0JBPk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 11:40:28 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:51452 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755727Ab0JBPk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 11:40:27 -0400
Message-ID: <4CA7524C.9090901@metafoo.de>
Date: Sat, 02 Oct 2010 17:39:56 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: "jianwei.yang" <jianwei.yang@intel.com>
CC: Alan Cox <alan@linux.intel.com>, akpm@osdl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] max7315: Add LED support to the driver
References: <20101001151453.6563.84259.stgit@localhost.localdomain>
In-Reply-To: <20101001151453.6563.84259.stgit@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> From: jianwei.yang <jianwei.yang@intel.com>
> 
> The max7315 also has LED interfaces. Export them as LED class objects when
> we find the device. We don't require the LEDS class is enabled to use this
> driver as it seems preferable not for drag in the layer for those who don't
> need it.
> 
> Signed-off-by: jianwei.yang <jianwei.yang@intel.com>
> [bug fixes]
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> [Some minor tidying]
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/gpio/max7315.h |   82 +++++++++++++++++++
>  drivers/gpio/pca953x.c |  203 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 283 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/gpio/max7315.h
> 
> 
> diff --git a/drivers/gpio/max7315.h b/drivers/gpio/max7315.h
> new file mode 100644
> index 0000000..a917002
> --- /dev/null
> +++ b/drivers/gpio/max7315.h
> @@ -0,0 +1,82 @@
> +/*
> + * max7315.h - GPIO expander MAX7315 driver header
> + *
> + * Copyright (C) 2010 Aava Mobile Oy
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/leds.h>
> +#include <linux/workqueue.h>
> +
> +#define MAX7315_INPUT		0x00
> +#define MAX7315_BLINK0		0x01
> +#define MAX7315_DIRECTION	0x03
> +#define MAX7315_BLINK1		0x09
> +#define MAX7315_MG8		0x0E
> +#define MAX7315_CONF		0x0F
> +#define MAX7315_INTNS0		0x10
> +#define MAX7315_INTNS1		0x11
> +#define MAX7315_INTNS2		0x12
> +#define MAX7315_INTNS3		0x13
> +/* configuration register masks */
> +#define MAX7315_CONF_BEN	0x01
> +#define MAX7315_CONF_BFLIP	0x02
> +#define MAX7315_CONF_GLINTNS	0x04
> +#define MAX7315_CONF_INTEN	0x08
> +#define MAX7315_CONF_INTOC1	0x10
> +#define MAX7315_CONF_INTOC2	0x20
> +#define MAX7315_CONF_RSRVD	0x40
> +#define MAX7315_CONF_INTSTS	0x80
> +/* led pin register mask */
> +#define MAX7315_P2_MASK		0x04
> +/* PWM enable mask */
> +#define MAX7315_PWM_MASK	0xFF
> +/* BLINK mask */
> +#define MAX7315_BLINKMASK_P2	(1 << 2)
> +/* period in ms */
> +#define MAX7315_PERIOD_MIN	0
> +#define MAX7315_PERIOD_MAX	1600
> +/* duty cycle range: 0, 1/16, 2/16, ... 15/16 */
> +#define MAX7315_DCYCLE_MIN	0
> +#define MAX7315_DCYCLE_MAX	100
> +#define MAX7315_BLINK_PRESET0	75
> +#define MAX7315_BLINK_PRESET1	60
> +#define MAX7315_BLINK_PRESET2	15
> +#define MAX7315_BLINK_DELAY0	100
> +#define MAX7315_BLINK_DELAY1	250
> +#define MAX7315_BLINK_DELAY2	500
> +#define MAX7315_DUTY_MAX	0xF
> +
> +/* XXX STATUS_MAX needs to be updated in case more modes are added XXX */
> +
> +#define MAX7315_LED_STATUS_MAX	3
> +#define MAX7315_LEDS_MAX 8
> +
> +enum max7315_status {
> +	MAX7315_LED_STATUS_OFF,
> +	MAX7315_LED_STATUS_ON,
> +	MAX7315_LED_STATUS_BLINK0,
> +	MAX7315_LED_STATUS_BLINK1,
> +};
> +
> +struct max7315_led_data {
> +	u8 id;
> +	const char *name;
> +	enum max7315_status status;
> +	struct led_classdev ldev;
> +	struct i2c_client *client;
> +	struct work_struct work;
> +};
> diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
> index a2b12aa..20bcc96 100644
> --- a/drivers/gpio/pca953x.c
> +++ b/drivers/gpio/pca953x.c
> @@ -24,6 +24,8 @@
>  #include <linux/of_gpio.h>
>  #endif
>  
> +#include "max7315.h"
> +
>  #define PCA953X_INPUT          0
>  #define PCA953X_OUTPUT         1
>  #define PCA953X_INVERT         2
> @@ -31,6 +33,7 @@
>  
>  #define PCA953X_GPIOS	       0x00FF
>  #define PCA953X_INT	       0x0100
> +#define PCA953X_LED	       0x0200
>  
>  static const struct i2c_device_id pca953x_id[] = {
>  	{ "pca9534", 8  | PCA953X_INT, },
> @@ -47,7 +50,7 @@ static const struct i2c_device_id pca953x_id[] = {
>  	{ "max7310", 8, },
>  	{ "max7312", 16 | PCA953X_INT, },
>  	{ "max7313", 16 | PCA953X_INT, },
> -	{ "max7315", 8  | PCA953X_INT, },
> +	{ "max7315", 8  | PCA953X_INT | PCA953X_LED, },
>  	{ "pca6107", 8  | PCA953X_INT, },
>  	{ "tca6408", 8  | PCA953X_INT, },
>  	{ "tca6416", 16 | PCA953X_INT, },
> @@ -74,6 +77,12 @@ struct pca953x_chip {
>  	struct pca953x_platform_data *dyn_pdata;
>  	struct gpio_chip gpio_chip;
>  	const char *const *names;
> +
> +#ifdef CONFIG_LEDS_CLASS
> +	struct max7315_led_data leds[MAX7315_LEDS_MAX];
> +	struct work_struct work;
> +	uint8_t leds_size;
> +#endif
>  };
>  
>  static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
> @@ -483,6 +492,190 @@ pca953x_get_alt_pdata(struct i2c_client *client)
>  }
>  #endif
>  
> +
> +#ifdef CONFIG_LEDS_CLASS
> +
> +/**
> + * Set the led status
> + *
> + * @chip: a pca953x_chip structure
> + * @status: one of MAX7315_LED_STATUS_OFF
> + *                 MAX7315_LED_STATUS_ON
> + *                 MAX7315_LED_STATUS_BLINK0
> + *                 MAX7315_LED_STATUS_BLINK1
> + */
> +static int max7315_led_set(struct max7315_led_data *led, u8 status)
> +{
> +	return 0;
> +}

Looks like the implementation is missing here...

> +
> +static void max7315_led_set_brightness(struct led_classdev *led_cdev,
> +				      enum led_brightness brightness)
> +{
> +	struct max7315_led_data *led =
> +		container_of(led_cdev, struct max7315_led_data, ldev);
> +
> +	dev_dbg(&led->client->dev, "%s: %s, %d\n",
> +		__func__, led_cdev->name, brightness);
> +
> +	led->status = brightness;

This looks wrong. led->status is supposed to hold one of MAX7315_LED_STATUS_*. While
brightness can be any value between 0 and LED_FULL(255).
You probably need an additional field in the max7315_led_data struct for the leds
brightness.
> +	schedule_work(&led->work);
> +}
> +
> +static enum led_brightness
> +	max7315_led_get_brightness(struct led_classdev *led_cdev)
> +{
> +	struct max7315_led_data *led =
> +		container_of(led_cdev, struct max7315_led_data, ldev);
> +
> +	return led->status;
> +}

Same here.

> +
> +static int max7315_led_set_blink(struct led_classdev *led_cdev,
> +				unsigned long *delay_on,
> +				unsigned long *delay_off)
> +{
> +	return 0;
> +}

... and here.

> +
> +static void max7315_led_work(struct work_struct *work)
> +{
> +	struct max7315_led_data *led;
> +
> +	led = container_of(work, struct max7315_led_data, work);
> +	max7315_led_set(led, led->status);
> +}
> +
> +static int max7315_teardown_leds(struct i2c_client *client,
> +		unsigned gpio, unsigned ngpio, void *context)
> +{
> +	int i = 0;
> +	struct pca953x_chip *chip = i2c_get_clientdata(client);
> +	for (i = 0; i < chip->leds_size; i++) {
> +		led_classdev_unregister(&chip->leds[i].ldev);
> +		cancel_work_sync(&chip->leds[i].work);
> +	}
> +	return 0;
> +}
> +
> +/* Initial settings for max7315 leds */
> +static int max7315_setup_leds(struct i2c_client *client,
> +		unsigned gpio, unsigned ngpio, void *context)
> +{
> +	int i = 0, err = 0;
> +	u8 conf_reg = 0;
> +	uint16_t port_reg = 0;
> +	struct pca953x_chip *chip = i2c_get_clientdata(client);
> +
> +	if (!chip) {
> +		dev_err(&client->dev, "%s no client chip data\n", __func__);
> +		goto exit;
> +	}
> +	/* Set master intensity (between 0x10-0xFF) */
> +	err = pca953x_write_reg(chip, MAX7315_MG8, MAX7315_PWM_MASK);
> +	if (err < 0) {
> +		dev_err(&client->dev, "%s couldn't enable PWM\n", __func__);
> +		goto exit;
> +	}
> +	/* Set BLINK1 output */
> +	err = pca953x_read_reg(chip, MAX7315_BLINK1, &port_reg);
> +	if (err) {
> +		dev_err(&client->dev, "%s couldn't read BLINK1\n", __func__);
> +		return err;
> +	}
> +	port_reg |= MAX7315_BLINKMASK_P2;
> +	err = pca953x_write_reg(chip, MAX7315_BLINK1, port_reg);
> +	if (err) {
> +		dev_err(&client->dev, "%s couldn't write BLINK1\n", __func__);
> +		return err;
> +	}
> +
> +	/* Set initial configuration to leds config reg:
> +	 * -no blinking nor blink flip
> +	 * -no global intensity (each port configured separately)
> +	 * -interrupt enable is activated (in INT/O8)
> +	 * -interrupt status is logic 1 until interrupt occurs
> +	 * -conf: 10111000
> +	 * -ports 0,1,4,5,6 inputs (+3,7 not connected)
> +	 * -ports 2,8 outputs
> +	 */
> +	conf_reg |= MAX7315_CONF_INTEN;		/*bit 3*/
> +	conf_reg |= MAX7315_CONF_INTOC1;	/*bit 4*/
> +	conf_reg |= MAX7315_CONF_INTOC2;	/*bit 5*/
> +	conf_reg |= MAX7315_CONF_INTSTS;	/*bit 7*/
> +	conf_reg &= ~MAX7315_CONF_BEN;		/*bit 0*/
> +	conf_reg &= ~MAX7315_CONF_BFLIP;	/*bit 1*/
> +	conf_reg &= ~MAX7315_CONF_GLINTNS;	/*bit 2*/
> +	conf_reg &= ~MAX7315_CONF_RSRVD;	/*bit 6*/
> +	err = pca953x_write_reg(chip, MAX7315_CONF, conf_reg);
> +	chip->leds_size = 1;
Is there really only one output which can be used to drive a LED and supports
blinking and PWM?
> +
> +
> +	for (i = 0; i < chip->leds_size; i++) {
> +		struct max7315_led_data *led = &chip->leds[i];
> +
> +		led->client = client;
> +		led->id = 2;
> +		led->name = dev_name(&client->dev);
> +
> +		led->status = MAX7315_LED_STATUS_OFF;
> +		led->ldev.name = led->name;
> +		led->ldev.max_brightness = LED_FULL;
> +		led->ldev.brightness_set = max7315_led_set_brightness;
> +		led->ldev.blink_set = max7315_led_set_blink;
> +		led->ldev.brightness_get = max7315_led_get_brightness;
> +		led->ldev.flags = LED_CORE_SUSPENDRESUME;
> +
> +		INIT_WORK(&led->work, max7315_led_work);
> +		err = led_classdev_register(&client->dev, &led->ldev);
> +		if (err < 0) {
> +			dev_err(&client->dev,
> +					"couldn't register LED %s\n",
> +					led->ldev.name);
> +			goto exit;
> +		}
> +		/* to expose the default value to userspace */
> +		led->ldev.brightness = led->status;
This should be set before registering the device.
> +
> +		/* Set the default led status */
> +		err = max7315_led_set(led, led->status);
> +		if (err < 0) {
> +			dev_err(&client->dev,
> +					"%s couldn't set STATUS %d\n",
> +					led->ldev.name, led->status);
> +			goto exit;
> +		}
> +
> +	}
> +
> +	/* Set direction and value through gpiolib */
> +	if (gpio_request(chip->gpio_chip.base+2, "max7315")) {
> +		pr_debug("Requesting GPIO%d failed\n",
> +				chip->gpio_chip.base+2);
> +		return -EIO;
> +	}
> +	if (gpio_direction_output(chip->gpio_chip.base+2, 0)) {
> +		pr_debug("Setting GPIO%d to out failed\n",
> +				chip->gpio_chip.base+2);
> +		gpio_free(chip->gpio_chip.base+2);
> +		return -EIO;
> +	}
> +	gpio_free(chip->gpio_chip.base+2);
The gpio should probably not be freed if the output is controlled by the led driver.
You should probably should also probably request the gpio pin before registering the
led device. Otherwise you would have to unregister it if the gpio is not available.
> +
> +	return 0;
> +
> +exit:
> +
> +	if (i > 0)
> +		for (i = i - 1; i >= 0; i--) {
> +			led_classdev_unregister(&chip->leds[i].ldev);
> +			cancel_work_sync(&chip->leds[i].work);
> +		}
> +	return err;
> +}
> +
> +#endif
> +
>  static int __devinit pca953x_probe(struct i2c_client *client,
>  				   const struct i2c_device_id *id)
>  {
> @@ -542,6 +735,13 @@ static int __devinit pca953x_probe(struct i2c_client *client,
>  	if (ret)
>  		goto out_failed;
>  
> +#ifdef CONFIG_LEDS_CLASS
> +	if (id->driver_data & PCA953X_LED) {
> +		pdata->setup = max7315_setup_leds;
> +		pdata->teardown = max7315_teardown_leds;
Is it a good idea to override those callbacks? If they were set by the machine file
it probably expects that it's callback routines are called.
> +	}
> +#endif
> +	i2c_set_clientdata(client, chip);
>  	if (pdata->setup) {
>  		ret = pdata->setup(client, chip->gpio_chip.base,
>  				chip->gpio_chip.ngpio, pdata->context);
> @@ -549,7 +749,6 @@ static int __devinit pca953x_probe(struct i2c_client *client,
>  			dev_warn(&client->dev, "setup failed, %d\n", ret);
>  	}
>  
> -	i2c_set_clientdata(client, chip);
>  	return 0;
>  
>  out_failed:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

