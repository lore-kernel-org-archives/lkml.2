Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab2KVS4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:56:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53437 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2KVS4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:56:10 -0500
Date: Thu, 22 Nov 2012 14:51:53 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: Re: [PATCH 2/2] input: gpio-keys: Add runtime support
Message-ID: <20121122145153.GB10986@gmail.com>
References: <1353590617-11466-1-git-send-email-lee.jones@linaro.org>
 <1353590617-11466-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1353590617-11466-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore this.

I've just rebased and the API has changed slightly.

Will fixup and resend.

> From: Jonas Aaberg <jonas.aberg@stericsson.com>
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
> Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
> Reviewed-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
>  drivers/input/keyboard/gpio_keys.c |   17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
> index 2cf6757..cff548c 100644
> --- a/drivers/input/keyboard/gpio_keys.c
> +++ b/drivers/input/keyboard/gpio_keys.c
> @@ -29,6 +29,7 @@
>  #include <linux/of_platform.h>
>  #include <linux/of_gpio.h>
>  #include <linux/spinlock.h>
> +#include <linux/pm_runtime.h>
>  
>  struct gpio_button_data {
>  	const struct gpio_keys_button *button;
> @@ -533,6 +534,7 @@ static int gpio_keys_open(struct input_dev *input)
>  	struct gpio_keys_drvdata *ddata = input_get_drvdata(input);
>  	const struct gpio_keys_platform_data *pdata = ddata->pdata;
>  
> +	pm_runtime_get_sync(input->dev.parent);
>  	ddata->enabled = true;
>  
>  	return pdata->enable ? pdata->enable(input->dev.parent) : 0;
> @@ -547,6 +549,8 @@ static void gpio_keys_close(struct input_dev *input)
>  
>  	if (pdata->disable)
>  		pdata->disable(input->dev.parent);
> +
> +	pm_runtime_put(input->dev.parent);
>  }
>  
>  /*
> @@ -708,6 +712,8 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
>  	input->id.product = 0x0001;
>  	input->id.version = 0x0100;
>  
> +	pm_runtime_enable(&pdev->dev);
> +
>  	/* Enable auto repeat feature of Linux input subsystem */
>  	if (pdata->rep)
>  		__set_bit(EV_REP, input->evbit);
> @@ -773,6 +779,8 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
>  	struct input_dev *input = ddata->input;
>  	int i;
>  
> +	pm_runtime_disable(&pdev->dev);
> +
>  	sysfs_remove_group(&pdev->dev.kobj, &gpio_keys_attr_group);
>  
>  	device_init_wakeup(&pdev->dev, 0);
> @@ -805,8 +813,8 @@ static int gpio_keys_suspend(struct device *dev)
>  		}
>  	} else {
>  		ddata->enable_after_suspend = ddata->enabled;
> -		if (ddata->enabled)
> -			gpio_keys_close(ddata->input);
> +		if (ddata->enabled && ddata->disable)
> +			ddata->disable(dev);
>  	}
>  
>  	return 0;
> @@ -826,8 +834,9 @@ static int gpio_keys_resume(struct device *dev)
>  			gpio_keys_gpio_report_event(bdata);
>  	}
>  
> -	if (!device_may_wakeup(dev) && ddata->enable_after_suspend)
> -		gpio_keys_open(ddata->input);
> +	if (!device_may_wakeup(dev) && ddata->enable_after_suspend
> +	    && ddata->enable)
> +		ddata->enable(dev);
>  
>  	input_sync(ddata->input);
>  
> -- 
> 1.7.9.5
> 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
