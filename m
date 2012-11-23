Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2KWPxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:53:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61988 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2KWPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:53:51 -0500
Date: Fri, 23 Nov 2012 15:53:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH 4/5] Input: Enable STMPE keypad driver for Device Tree
Message-ID: <20121123155346.GF28552@gmail.com>
References: <1352900837-20759-1-git-send-email-lee.jones@linaro.org>
 <1352900837-20759-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352900837-20759-5-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Lee Jones wrote:

> This patch allows the STMPE driver to be successfully probed and
> initialised when Device Tree support is enabled. Besides the usual
> platform data changes, we also separate the process of filling in
> the 'in use' pin bitmap, as we have to extract the information from
> Device Tree in the DT boot case.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/input/keyboard/stmpe-keypad.c |   67 ++++++++++++++++++++++++++++-----
>  drivers/mfd/stmpe.c                   |    1 +
>  2 files changed, 59 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/input/keyboard/stmpe-keypad.c b/drivers/input/keyboard/stmpe-keypad.c
> index 470a877..4ae01d5 100644
> --- a/drivers/input/keyboard/stmpe-keypad.c
> +++ b/drivers/input/keyboard/stmpe-keypad.c
> @@ -257,19 +257,73 @@ static int __devinit stmpe_keypad_chip_init(struct stmpe_keypad *keypad)
>  			      (plat->debounce_ms << 1));
>  }
>  
> +static int stmpe_keypad_fill_used_pins(struct platform_device *pdev,
> +				struct stmpe_keypad *keypad,
> +				struct stmpe_keypad_platform_data *plat)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	unsigned int proplen;
> +	const __be32 *prop;
> +	int i;
> +
> +	if (np) {
> +		prop = of_get_property(np, "linux,keymap", &proplen);
> +		if (!prop) {
> +			dev_err(&pdev->dev,
> +				"linux,keymap property not defined\n");
> +			return -EINVAL;
> +		}
> +
> +		for (i = 0; i < proplen / sizeof(u32); i++) {
> +			unsigned int key = be32_to_cpup(prop + i);
> +
> +			keypad->cols |= 1 << KEY_COL(key);
> +			keypad->rows |= 1 << KEY_ROW(key);
> +		}
> +	} else {
> +		for (i = 0; i < plat->keymap_data->keymap_size; i++) {
> +			unsigned int key = plat->keymap_data->keymap[i];
> +
> +			keypad->cols |= 1 << KEY_COL(key);
> +			keypad->rows |= 1 << KEY_ROW(key);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void __devinit stmpe_keypad_of_probe(struct device_node *np,
> +				struct stmpe_keypad_platform_data *plat)
> +{
> +	of_property_read_u32(np, "debounce-interval", &plat->debounce_ms);
> +	of_property_read_u32(np, "st,scan-count", &plat->scan_count);
> +
> +	if (of_get_property(np, "st,no-autorepeat", NULL))
> +		plat->no_autorepeat = true;
> +}
> +
>  static int __devinit stmpe_keypad_probe(struct platform_device *pdev)
>  {
>  	struct stmpe *stmpe = dev_get_drvdata(pdev->dev.parent);
>  	struct stmpe_keypad_platform_data *plat;
> +	struct device_node *np = pdev->dev.of_node;
>  	struct stmpe_keypad *keypad;
>  	struct input_dev *input;
>  	int ret;
>  	int irq;
> -	int i;
>  
>  	plat = stmpe->pdata->keypad;
> -	if (!plat)
> -		return -ENODEV;
> +	if (!plat) {
> +		if (np) {
> +			plat = devm_kzalloc(&pdev->dev,
> +					sizeof(*plat), GFP_KERNEL);
> +			if (!plat)
> +				return -ENOMEM;
> +
> +			stmpe_keypad_of_probe(np, plat);
> +		} else
> +			return -ENODEV;
> +	}
>  
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0)
> @@ -300,12 +354,7 @@ static int __devinit stmpe_keypad_probe(struct platform_device *pdev)
>  	if (!plat->no_autorepeat)
>  		__set_bit(EV_REP, input->evbit);
>  
> -	for (i = 0; i < plat->keymap_data->keymap_size; i++) {
> -		unsigned int key = plat->keymap_data->keymap[i];
> -
> -		keypad->cols |= 1 << KEY_COL(key);
> -		keypad->rows |= 1 << KEY_ROW(key);
> -	}
> +	stmpe_keypad_fill_used_pins(pdev, keypad, plat);
>  
>  	keypad->stmpe = stmpe;
>  	keypad->plat = plat;
> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
> index ba157d4..b03cc64 100644
> --- a/drivers/mfd/stmpe.c
> +++ b/drivers/mfd/stmpe.c
> @@ -321,6 +321,7 @@ static struct resource stmpe_keypad_resources[] = {
>  
>  static struct mfd_cell stmpe_keypad_cell = {
>  	.name		= "stmpe-keypad",
> +	.of_compatible  = "st,stmpe-keypad",
>  	.resources	= stmpe_keypad_resources,
>  	.num_resources	= ARRAY_SIZE(stmpe_keypad_resources),
>  };
> -- 
> 1.7.9.5
> 

You guessed it, friendly poke for Dmitry.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
