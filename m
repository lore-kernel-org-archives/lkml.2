Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2G3R0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:26:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38092 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab2G3R0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:26:35 -0400
Message-ID: <5016C3C7.7090207@gmail.com>
Date: Mon, 30 Jul 2012 19:26:31 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
        Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH 1/2] onewire: w1-gpio: add ext_pullup_enable pin in platform
 data
References: <1343249670-14985-1-git-send-email-zonque@gmail.com>
In-Reply-To: <1343249670-14985-1-git-send-email-zonque@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

On 25.07.2012 22:54, Daniel Mack wrote:
> In the process of porting boards to devicetree implemenation, we should
> keep information about external circuitry where they belong - the
> individual drivers.
> 
> This patch adds a way to specify a GPIO to drive the (optional) external
> pull-up logic, rather than using a function pointer for that.
> 
> Signed-off-by: Daniel Mack <zonque@gmail.com>
> Cc: Evgeniy Polyakov <zbr@ioremap.net>
> Cc: Ville Syrjala <syrjala@sci.fi>
> ---
>  drivers/w1/masters/w1-gpio.c |   18 +++++++++++++++++-
>  include/linux/w1-gpio.h      |    1 +
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
> index df600d1..dac88ff 100644
> --- a/drivers/w1/masters/w1-gpio.c
> +++ b/drivers/w1/masters/w1-gpio.c
> @@ -59,6 +59,13 @@ static int __init w1_gpio_probe(struct platform_device *pdev)
>  	if (err)
>  		goto free_master;
>  
> +	if (gpio_is_valid(pdata->ext_pullup_enable_pin)) {
> +		err = gpio_request_one(pdata->ext_pullup_enable_pin,
> +				       GPIOF_INIT_LOW, "w1 pullup");
> +		if (err < 0)
> +			goto free_gpio;
> +	}
> +
>  	master->data = pdata;
>  	master->read_bit = w1_gpio_read_bit;
>  
> @@ -72,15 +79,21 @@ static int __init w1_gpio_probe(struct platform_device *pdev)
>  
>  	err = w1_add_master_device(master);
>  	if (err)
> -		goto free_gpio;
> +		goto free_gpio_ext_pu;
>  
>  	if (pdata->enable_external_pullup)
>  		pdata->enable_external_pullup(1);
>  
> +	if (gpio_is_valid(pdata->ext_pullup_enable_pin))
> +		gpio_set_value(pdata->ext_pullup_enable_pin, 1);
> +
>  	platform_set_drvdata(pdev, master);
>  
>  	return 0;
>  
> + free_gpio_ext_pu:
> +	if (gpio_is_valid(pdata->ext_pullup_enable_pin))
> +		gpio_free(pdata->ext_pullup_enable_pin);
>   free_gpio:
>  	gpio_free(pdata->pin);
>   free_master:
> @@ -97,6 +110,9 @@ static int __exit w1_gpio_remove(struct platform_device *pdev)
>  	if (pdata->enable_external_pullup)
>  		pdata->enable_external_pullup(0);
>  
> +	if (gpio_is_valid(pdata->ext_pullup_enable_pin))
> +		gpio_set_value(pdata->ext_pullup_enable_pin, 0);
> +
>  	w1_remove_master_device(master);
>  	gpio_free(pdata->pin);
>  	kfree(master);
> diff --git a/include/linux/w1-gpio.h b/include/linux/w1-gpio.h
> index 3adeff8..065e3ae 100644
> --- a/include/linux/w1-gpio.h
> +++ b/include/linux/w1-gpio.h
> @@ -19,6 +19,7 @@ struct w1_gpio_platform_data {
>  	unsigned int pin;
>  	unsigned int is_open_drain:1;
>  	void (*enable_external_pullup)(int enable);
> +	unsigned int ext_pullup_enable_pin;
>  };
>  
>  #endif /* _LINUX_W1_GPIO_H */
> 

