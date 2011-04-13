Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab1DMNCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:02:34 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:46613 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707Ab1DMNCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:02:33 -0400
Message-ID: <4DA59F08.4000803@metafoo.de>
Date: Wed, 13 Apr 2011 15:03:04 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
CC: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv1 10/11] LEDS: LED module of DA9052 PMIC driver
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B61976E@KCINPUNHJCMS01.kpit.com>
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B61976E@KCINPUNHJCMS01.kpit.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 02:17 PM, Ashish Jangam wrote:
> Hi,
> 
> LED Driver for Dialog Semiconductor DA9052 PMICs.
> 
> Changes made since last submission:
> . Modified the platform data structure
No, you did not.

> . Ported the driver to Linux kernel 2.6.38.2
> 
> Linux Kernel Version: 2.6.38.2
> 
> Signed-off-by: D. Chen <dchen@diasemi.com>

A lot of my comments from my last review are still valid, I won't repeat them
here, I only commented on new issues.

> ---
> diff -Naur linux-2.6.38.2/drivers/leds/leds-da9052.c wrk_linux-2.6.38.2/drivers/leds/leds-da9052.c
> --- linux-2.6.38.2/drivers/leds/leds-da9052.c	1970-01-01 05:00:00.000000000 +0500
> +++ wrk_linux-2.6.38.2/drivers/leds/leds-da9052.c	2011-04-13 15:24:28.000000000 +0500
> @@ -0,0 +1,218 @@
> [...]
> +
> +struct da9052_led_platform_data {
> +		int led_index[2];
> +		struct led_platform_data leds;
> +	};

This is not used. If you intended to use for the platform data, you can use the
'flags' field of struct led_platform_data to pass the led index, so you don't
have to introduce a new struct.

[...]
> +
> +static int __devexit da9052_led_remove(struct platform_device *pdev)
> +{
> +	struct da9052_led *led = NULL;
> +	struct da9052 *da9052;
> +	struct gpio_led_platform_data *pdata = pdev->dev.platform_data;
You don't store the platform_data for this device in pdev->dev.platform_data

> +	int i;
> +
> +	led = platform_get_drvdata(pdev);
> +	da9052 = dev_get_drvdata(pdev->dev.parent);
> +	pdata = da9052->dev->platform_data;
And neither in da9052->dev->platform_data.
It is:

+	struct da9052 *da9052 = dev_get_drvdata(pdev->dev.parent);
+	struct da9052_pdata *pdata = da9052->dev->platform_data;
+	struct gpio_led_platform_data *pled = pdata->pled;


> +
> +	for (i = 0; i < pdata->num_leds; i++) {
> +		led[i].brightness = 0;
> +		da9052_set_led_brightness(&led[i]);
> +		led_classdev_unregister(&led[i].cdev);
> +		cancel_work_sync(&led[i].work);
> +	}
> +
> +	kfree(led);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver da9052_led_driver = {
> +	.driver = {
> +		.name	= "da9052-leds",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= da9052_led_probe,
> +	.remove		= __devexit_p(da9052_led_remove),
> +};
> +
> +static int __init da9052_led_init(void)
> +{
> +	return platform_driver_register(&da9052_led_driver);
> +}
> +module_init(da9052_led_init);
> +
> +static void __exit da9052_led_exit(void)
> +{
> +	platform_driver_unregister(&da9052_led_driver);
> +}
> +module_exit(da9052_led_exit);
> +
> +MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
> +MODULE_DESCRIPTION("LED driver for Dialog DA9052 PMIC");
> +MODULE_LICENSE("GPL v2");
> diff -Naur linux-2.6.38.2/drivers/leds/Makefile wrk_linux-2.6.38.2/drivers/leds/Makefile
> --- linux-2.6.38.2/drivers/leds/Makefile	2011-03-27 23:37:20.000000000 +0500
> +++ wrk_linux-2.6.38.2/drivers/leds/Makefile	2011-04-13 15:24:01.000000000 +0500
> @@ -30,6 +30,7 @@
>  obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
>  obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
>  obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
> +obj-$(CONFIG_LEDS_DA9052)		+= leds-da9052.o
>  obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
>  obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
>  obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o
> 
> Regards,
> Ashish J
> 
> 

