Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab2FYPVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:21:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50355 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab2FYPVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:21:31 -0400
Message-ID: <4FE881F7.8070009@gmail.com>
Date: Mon, 25 Jun 2012 10:21:27 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tobias Klauser <tklauser@distanz.ch>, David Jander <david@protonic.nl>,
        Laxman Dewangan <ldewangan@nvidia.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] input: gpio_keys: Cleanup devicetree parser
References: <1340637423-12072-1-git-send-email-aletes.xgr@gmail.com>
In-Reply-To: <1340637423-12072-1-git-send-email-aletes.xgr@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 10:17 AM, Alexandre Pereira da Silva wrote:
> Fix sizeof in memset.
> Cleanup dt properties extraction.
> Use for_each macro.
> Use of_match_ptr macro.
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
>  drivers/input/keyboard/gpio_keys.c |   30 +++++++++---------------------
>  1 file changed, 9 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
> index 62bfce4..1ef15ae 100644
> --- a/drivers/input/keyboard/gpio_keys.c
> +++ b/drivers/input/keyboard/gpio_keys.c
> @@ -548,22 +548,16 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
>  	struct device_node *node, *pp;
>  	int i;
>  	struct gpio_keys_button *buttons;
> -	u32 reg;
>  
>  	node = dev->of_node;
>  	if (node == NULL)
>  		return -ENODEV;
>  
> -	memset(pdata, 0, sizeof *pdata);
> +	memset(pdata, 0, sizeof(*pdata));
>  
>  	pdata->rep = !!of_get_property(node, "autorepeat", NULL);
>  
> -	/* First count the subnodes */
> -	pdata->nbuttons = 0;
> -	pp = NULL;
> -	while ((pp = of_get_next_child(node, pp)))
> -		pdata->nbuttons++;
> -
> +	pdata->nbuttons = of_get_child_count(node);
>  	if (pdata->nbuttons == 0)
>  		return -ENODEV;
>  
> @@ -571,9 +565,8 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
>  	if (!buttons)
>  		return -ENOMEM;
>  
> -	pp = NULL;
>  	i = 0;
> -	while ((pp = of_get_next_child(node, pp))) {
> +	for_each_child_of_node(node, pp) {
>  		enum of_gpio_flags flags;
>  
>  		if (!of_find_property(pp, "gpios", NULL)) {
> @@ -584,24 +577,21 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
>  		buttons[i].gpio = of_get_gpio_flags(pp, 0, &flags);
>  		buttons[i].active_low = flags & OF_GPIO_ACTIVE_LOW;
>  
> -		if (of_property_read_u32(pp, "linux,code", &reg)) {
> +		if (of_property_read_u32(pp, "linux,code", &buttons[i].code)) {
>  			dev_err(dev, "Button without keycode: 0x%x\n", buttons[i].gpio);
>  			goto out_fail;
>  		}
> -		buttons[i].code = reg;
>  
>  		buttons[i].desc = of_get_property(pp, "label", NULL);
>  
> -		if (of_property_read_u32(pp, "linux,input-type", &reg) == 0)
> -			buttons[i].type = reg;
> -		else
> +		if (of_property_read_u32(pp, "linux,input-type",
> +			&buttons[i].type))
>  			buttons[i].type = EV_KEY;
>  
>  		buttons[i].wakeup = !!of_get_property(pp, "gpio-key,wakeup", NULL);
>  
> -		if (of_property_read_u32(pp, "debounce-interval", &reg) == 0)
> -			buttons[i].debounce_interval = reg;
> -		else
> +		if (of_property_read_u32(pp, "debounce-interval",
> +			&buttons[i].debounce_interval))
>  			buttons[i].debounce_interval = 5;
>  
>  		i++;
> @@ -630,8 +620,6 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
>  	return -ENODEV;
>  }
>  
> -#define gpio_keys_of_match NULL
> -
>  #endif
>  
>  static void gpio_remove_key(struct gpio_button_data *bdata)
> @@ -823,7 +811,7 @@ static struct platform_driver gpio_keys_device_driver = {
>  		.name	= "gpio-keys",
>  		.owner	= THIS_MODULE,
>  		.pm	= &gpio_keys_pm_ops,
> -		.of_match_table = gpio_keys_of_match,
> +		.of_match_table = of_match_ptr(gpio_keys_of_match),
>  	}
>  };
>  
