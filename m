Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab2FYMnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 08:43:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55702 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab2FYMnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 08:43:13 -0400
Message-ID: <4FE85CDC.1090604@gmail.com>
Date: Mon, 25 Jun 2012 07:43:08 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>, JJ Ding <dgdunix@gmail.com>,
        Roland Stigge <stigge@antcom.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH RESEND] input: gpio_keys_polled: convert to dt
References: <1340192062-10565-1-git-send-email-aletes.xgr@gmail.com>
In-Reply-To: <1340192062-10565-1-git-send-email-aletes.xgr@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 06:34 AM, Alexandre Pereira da Silva wrote:
> Add device tree support to gpio_keys_polled.c
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> Tested-by: Roland Stigge <stigge@antcom.de>
> ---
>  drivers/input/keyboard/gpio_keys_polled.c |  121 +++++++++++++++++++++++++++--
>  1 file changed, 113 insertions(+), 8 deletions(-)

Needs binding documentation.

> 
> diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
> index 20c8ab1..a64b361 100644
> --- a/drivers/input/keyboard/gpio_keys_polled.c
> +++ b/drivers/input/keyboard/gpio_keys_polled.c
> @@ -25,6 +25,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/gpio.h>
>  #include <linux/gpio_keys.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_gpio.h>
>  
>  #define DRV_NAME	"gpio-keys-polled"
>  
> @@ -38,7 +40,7 @@ struct gpio_keys_button_data {
>  struct gpio_keys_polled_dev {
>  	struct input_polled_dev *poll_dev;
>  	struct device *dev;
> -	struct gpio_keys_platform_data *pdata;
> +	struct gpio_keys_platform_data pdata;
>  	struct gpio_keys_button_data data[0];
>  };
>  
> @@ -67,11 +69,11 @@ static void gpio_keys_polled_check_state(struct input_dev *input,
>  static void gpio_keys_polled_poll(struct input_polled_dev *dev)
>  {
>  	struct gpio_keys_polled_dev *bdev = dev->private;
> -	struct gpio_keys_platform_data *pdata = bdev->pdata;
> +	struct gpio_keys_platform_data *pdata = &bdev->pdata;
>  	struct input_dev *input = dev->input;
>  	int i;
>  
> -	for (i = 0; i < bdev->pdata->nbuttons; i++) {
> +	for (i = 0; i < pdata->nbuttons; i++) {
>  		struct gpio_keys_button_data *bdata = &bdev->data[i];
>  
>  		if (bdata->count < bdata->threshold)
> @@ -85,7 +87,7 @@ static void gpio_keys_polled_poll(struct input_polled_dev *dev)
>  static void gpio_keys_polled_open(struct input_polled_dev *dev)
>  {
>  	struct gpio_keys_polled_dev *bdev = dev->private;
> -	struct gpio_keys_platform_data *pdata = bdev->pdata;
> +	struct gpio_keys_platform_data *pdata = &bdev->pdata;
>  
>  	if (pdata->enable)
>  		pdata->enable(bdev->dev);
> @@ -94,23 +96,125 @@ static void gpio_keys_polled_open(struct input_polled_dev *dev)
>  static void gpio_keys_polled_close(struct input_polled_dev *dev)
>  {
>  	struct gpio_keys_polled_dev *bdev = dev->private;
> -	struct gpio_keys_platform_data *pdata = bdev->pdata;
> +	struct gpio_keys_platform_data *pdata = &bdev->pdata;
>  
>  	if (pdata->disable)
>  		pdata->disable(bdev->dev);
>  }
> +#ifdef CONFIG_OF
> +static int gpio_keys_polled_get_devtree_pdata(struct device *dev,
> +			    struct gpio_keys_platform_data *pdata)
> +{
> +	struct device_node *node, *pp;
> +	int i;
> +	struct gpio_keys_button *buttons;
> +	u32 reg;
> +
> +	node = dev->of_node;
> +	if (node == NULL)
> +		return -ENODEV;
> +
> +	memset(pdata, 0, sizeof *pdata);

parentheses around *pdata.

> +
> +	pdata->rep = !!of_get_property(node, "autorepeat", NULL);
> +
> +	if (of_property_read_u32(node, "poll-interval", &reg) == 0)
> +		pdata->poll_interval = reg;

You can just do this instead of the if:

of_property_read_u32(node, "poll-interval", &pdata->poll_interval);


> +
> +	/* First count the subnodes */
> +	pdata->nbuttons = 0;

You already to this to 0.

> +	pp = NULL;
> +	while ((pp = of_get_next_child(node, pp)))
> +		pdata->nbuttons++;

of_get_child_count()

> +
> +	if (pdata->nbuttons == 0)
> +		return -ENODEV;
> +
> +	buttons = kzalloc(pdata->nbuttons * (sizeof *buttons), GFP_KERNEL);
> +	if (!buttons)
> +		return -ENOMEM;
> +
> +	pp = NULL;
> +	i = 0;
> +	while ((pp = of_get_next_child(node, pp))) {

for_each_child_of_node

> +		enum of_gpio_flags flags;
> +
> +		if (!of_find_property(pp, "gpios", NULL)) {
> +			pdata->nbuttons--;
> +			dev_warn(dev, "Found button without gpios\n");
> +			continue;
> +		}
> +		buttons[i].gpio = of_get_gpio_flags(pp, 0, &flags);
> +		buttons[i].active_low = flags & OF_GPIO_ACTIVE_LOW;
> +
> +		if (of_property_read_u32(pp, "linux,code", &reg)) {
> +			dev_err(dev, "Button without keycode: 0x%x\n", buttons[i].gpio);
> +			goto out_fail;
> +		}
> +		buttons[i].code = reg;
> +
> +		buttons[i].desc = of_get_property(pp, "label", NULL);
> +
> +		if (of_property_read_u32(pp, "linux,input-type", &reg) == 0)
> +			buttons[i].type = reg;
> +		else
> +			buttons[i].type = EV_KEY;

if (of_property_read_u32(pp, "linux,input-type", &buttons[i].type))
	buttons[i].type = EV_KEY;

> +
> +		buttons[i].wakeup = !!of_get_property(pp, "gpio-key,wakeup", NULL);
> +
> +		if (of_property_read_u32(pp, "debounce-interval", &reg) == 0)
> +			buttons[i].debounce_interval = reg;
> +		else
> +			buttons[i].debounce_interval = 5;

ditto

> +
> +		i++;
> +	}
> +
> +	pdata->buttons = buttons;
> +
> +	return 0;
> +
> +out_fail:
> +	kfree(buttons);
> +	return -ENODEV;
> +}
> +
> +static struct of_device_id gpio_keys_polled_of_match[] = {
> +	{ .compatible = "gpio-keys-polled", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, gpio_keys_polled_of_match);
> +#else
> +
> +static int gpio_keys_polled_get_devtree_pdata(struct device *dev,
> +			    struct gpio_keys_platform_data *altp)
> +{
> +	return -ENODEV;
> +}
> +
> +#define gpio_keys_polled_of_match NULL
> +
> +#endif
>  
>  static int __devinit gpio_keys_polled_probe(struct platform_device *pdev)
>  {
>  	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
>  	struct device *dev = &pdev->dev;
> +	struct gpio_keys_platform_data alt_pdata;
>  	struct gpio_keys_polled_dev *bdev;
>  	struct input_polled_dev *poll_dev;
>  	struct input_dev *input;
>  	int error;
>  	int i;
>  
> -	if (!pdata || !pdata->poll_interval)
> +	if (!pdata) {
> +	    error = gpio_keys_polled_get_devtree_pdata(dev, &alt_pdata);
> +		if (error)
> +			return error;
> +		pdata = &alt_pdata;
> +	}
> +
> +	if (!pdata->poll_interval)
>  		return -EINVAL;
>  
>  	bdev = kzalloc(sizeof(struct gpio_keys_polled_dev) +
> @@ -184,7 +288,7 @@ static int __devinit gpio_keys_polled_probe(struct platform_device *pdev)
>  
>  	bdev->poll_dev = poll_dev;
>  	bdev->dev = dev;
> -	bdev->pdata = pdata;
> +	bdev->pdata = *pdata;
>  	platform_set_drvdata(pdev, bdev);
>  
>  	error = input_register_polled_device(poll_dev);
> @@ -217,7 +321,7 @@ err_free_bdev:
>  static int __devexit gpio_keys_polled_remove(struct platform_device *pdev)
>  {
>  	struct gpio_keys_polled_dev *bdev = platform_get_drvdata(pdev);
> -	struct gpio_keys_platform_data *pdata = bdev->pdata;
> +	struct gpio_keys_platform_data *pdata = &bdev->pdata;
>  	int i;
>  
>  	input_unregister_polled_device(bdev->poll_dev);
> @@ -239,6 +343,7 @@ static struct platform_driver gpio_keys_polled_driver = {
>  	.driver	= {
>  		.name	= DRV_NAME,
>  		.owner	= THIS_MODULE,
> +		.of_match_table = gpio_keys_polled_of_match,
>  	},
>  };
>  module_platform_driver(gpio_keys_polled_driver);
