Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab2BFNUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 08:20:08 -0500
Received: from smtp-out-106.synserver.de ([212.40.185.106]:1074 "EHLO
	smtp-out-106.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab2BFNUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 08:20:07 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 21228
Message-ID: <4F2FD3D9.6060407@metafoo.de>
Date: Mon, 06 Feb 2012 14:21:29 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
CC: rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCH 03/07] LEDS: LED module for DA9052/53 PMIC v1
References: <1328532157.30549.75.camel@dhruva>
In-Reply-To: <1328532157.30549.75.camel@dhruva>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 01:42 PM, Ashish Jangam wrote:
> LED Driver for Dialog Semiconductor DA9052/53 PMICs.
[...]
> +
> +static int da9052_set_led_brightness(struct da9052_led *led)
> +{
> +	u8 val;
> +	int error;
> +
> +	val = (led->brightness * 0x5f / LED_FULL) & 0x7f;

If the maximum brightness value is 0x5f, just set it as the max_brightness
field value, instead of scaling the value.

> +	val |= DA9052_LED_CONT_DIM;
> +
> +	error = da9052_reg_write(led->da9052, led_reg[led->led_index], val);
> +	if (error < 0)
> +		dev_err(led->da9052->dev, "Failed to set led brightness, %d\n",
> +			error);
> +	return error;
> +}
> +
[...]
> +
> +static int da9052_configure_leds(struct da9052_led *led)

Since this function doesn't confgiure one specific led I think it is better
to just pass the pointer to the da9052 struct instead of a led.

> +{
> +	int error;
> +	unsigned char register_value = DA9052_OPENDRAIN_OUTPUT | 1 << 3;

1 << 3 is sort of a magic value, would be nice to have either a comment
explaining what it does or have a define for it.

> +
> +	error = da9052_reg_update(led->da9052, DA9052_GPIO_14_15_REG,
> +				  DA9052_MASK_LOWER_NIBBLE,
> +				  register_value);
> +
> +	if (error < 0) {
> +		dev_err(led->da9052->dev, "Failed to write GPIO 14-15 reg, %d\n",
> +			error);
> +		return error;
> +	}
> +
> +	error = da9052_reg_update(led->da9052, DA9052_GPIO_14_15_REG,
> +				  DA9052_MASK_UPPER_NIBBLE,
> +				  register_value << DA9052_NIBBLE_SHIFT);
> +	if (error < 0)
> +		dev_err(led->da9052->dev, "Failed to write GPIO 14-15 reg, %d\n",
> +			error);
> +
> +	return error;
> +}
> +
> +static int __devinit da9052_led_probe(struct platform_device *pdev)
> +{
> +	struct da9052_pdata *pdata;
> +	struct da9052 *da9052;
> +	struct led_platform_data *pled;
> +	struct da9052_led *led = NULL;
> +	int error;
> +	int i;
> +
> +	da9052 = dev_get_drvdata(pdev->dev.parent);
> +	pdata = da9052->dev->platform_data;
> +	if (pdata == NULL) {
> +		dev_err(&pdev->dev, "No platform data\n");
> +		error = -ENODEV;
> +		goto err_mem;

Nothing has been allocated yet, so there shouldn't be anything to free either.

> +	}
> +
> +	pled = pdata->pled;
> +	if (pled == NULL) {
> +		dev_err(&pdev->dev, "Failed no platform data for LED\n");
> +		return -ENOMEM;
> +	}
> +
> +	led = devm_kzalloc(&pdev->dev,
> +			   sizeof(struct da9052_led) * pled->num_leds,
> +			   GFP_KERNEL);
> +	if (led == NULL) {
> +		dev_err(&pdev->dev, "Failed to alloc memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	for (i = 0; i < pled->num_leds; i++) {
> +		led[i].cdev.name = pled->leds[i].name;
> +		led[i].cdev.brightness_set = da9052_led_set;
> +		led[i].cdev.brightness = LED_OFF;
> +		led[i].brightness = LED_OFF;
> +		led[i].led_index = pled->leds[i].flags;
> +		led[i].da9052 = dev_get_drvdata(pdev->dev.parent);
> +		INIT_WORK(&led[i].work, da9052_led_work);
> +
> +		error = led_classdev_register(pdev->dev.parent, &led[i].cdev);
> +		if (error) {
> +			dev_err(&pdev->dev, "Failed to register led %d\n",
> +				led[i].led_index);
> +			goto err_register;
> +		}
> +
> +		error = da9052_set_led_brightness(&led[i]);
> +		if (error) {
> +			dev_err(&pdev->dev, "Unable to init led %d\n",
> +				led[i].led_index);
> +			continue;
> +		}
> +	}
> +	error = da9052_configure_leds(led);
> +	if (error) {
> +		dev_err(&pdev->dev, "Failed to configure GPIO Led,%d\n", error);
> +		goto err_register;
> +	}
> +
> +	platform_set_drvdata(pdev, led);
> +
> +	return 0;
> +
> +err_register:
> +	for (i = i - 1; i >= 0; i--) {
> +		led_classdev_unregister(&led[i].cdev);
> +		cancel_work_sync(&led[i].work);
> +	}
> +err_mem:
> +	devm_kfree(&pdev->dev, led);

You shouldn't need this. If probe fails all devm resource will be freed.

> +	return error;
> +}
> +
> +static int __devexit da9052_led_remove(struct platform_device *pdev)
> +{
> +	struct da9052_led *led = platform_get_drvdata(pdev);
> +	struct da9052_pdata *pdata;
> +	struct da9052 *da9052;
> +	struct led_platform_data *pled;
> +	int i;
> +
> +	da9052 = dev_get_drvdata(pdev->dev.parent);
> +	pdata = da9052->dev->platform_data;
> +	pled = pdata->pled;
> +
> +	for (i = 0; i < pled->num_leds; i++) {
> +		led[i].brightness = 0;
> +		da9052_set_led_brightness(&led[i]);
> +		led_classdev_unregister(&led[i].cdev);
> +		cancel_work_sync(&led[i].work);
> +	}
> +
> +	devm_kfree(&pdev->dev, led);

Neither this, that's the whole point of devm

> +
> +	return 0;
> +}
> +
[...]

