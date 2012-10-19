Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab2JSM5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 08:57:30 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49841 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab2JSM52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 08:57:28 -0400
Message-ID: <50814E31.5040905@gmail.com>
Date: Fri, 19 Oct 2012 07:57:21 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: AnilKumar Ch <anilkumar@ti.com>
CC: dmitry.torokhov@gmail.com, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, dgdunix@gmail.com,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: matrix-keypad - Add device tree support
References: <1350630373-24279-1-git-send-email-anilkumar@ti.com> <1350630373-24279-3-git-send-email-anilkumar@ti.com>
In-Reply-To: <1350630373-24279-3-git-send-email-anilkumar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 02:06 AM, AnilKumar Ch wrote:
> Add device tree support to matrix keypad driver and usage details
> are added to device tree documentation. Driver was tested on AM335x
> EVM.
> 
> Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
> ---
>  .../devicetree/bindings/input/matrix-keypad.txt    |   52 ++++++++++
>  drivers/input/keyboard/matrix_keypad.c             |  104 +++++++++++++++++++-
>  2 files changed, 155 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/input/matrix-keypad.txt
> 
> diff --git a/Documentation/devicetree/bindings/input/matrix-keypad.txt b/Documentation/devicetree/bindings/input/matrix-keypad.txt
> new file mode 100644
> index 0000000..50aaa6e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/matrix-keypad.txt
> @@ -0,0 +1,52 @@
> +* GPIO driven matrix keypad device tree bindings
> +
> +GPIO driven matrix keypad is used to interface a SoC with a matrix keypad.
> +The matrix keypad supports multiple row and column lines, a key can be
> +placed at each intersection of a unique row and a unique column. The matrix
> +keypad can sense a key-press and key-release by means of GPIO lines and
> +report the event using GPIO interrupts to the cpu.
> +
> +Required Properties:
> +- compatible:		Should be "matix-keypad"

How about gpio-matrix-keypad?

> +- keypad,num-row-gpios:	Number of row lines connected to the keypad
> +			controller.
> +- keypad,num-col-gpios:	Number of column lines connected to the keypad
> +			controller.

Isn't the number of gpios just the count of gpios listed below? So you
don't need these props.

> +- row-gpios:		List of gpios used as row lines. The gpio specifier
> +			for this property depends on the gpio controller to
> +			which these row lines are connected.
> +- col-gpios:		List of gpios used as column lines. The gpio specifier
> +			for this property depends on the gpio controller to
> +			which these column lines are connected.
> +
> +Optional Properties:
> +- linux,no-autorepeat:	do no enable autorepeat feature.
> +- linux,wakeup:		use any event on keypad as wakeup event.
> +- debounce-delay-ms:	debounce interval in milliseconds
> +- col-scan-delay-us:	delay, measured in microseconds, that is needed
> +			before we can scan keypad after activating column gpio
> +- clustered-irq:	have clustered irq number
> +- clustered-irq-flags:	have clustered irq flags

It's not clear what clustered means here. If I have to go read Linux
code to understand, you are doing it wrong. Describe the h/w, not Linux
data structs.

> +
> +Example:
> +	matrix-keypad {
> +		compatible = "matrix-keypad";
> +		keypad,num-row-gpios = <3>;
> +		keypad,num-col-gpios = <2>;
> +		debounce-delay-ms = <5>;
> +		col-scan-delay-us = <2>;
> +
> +		row-gpios = <&gpio2 25 0
> +			     &gpio2 26 0
> +			     &gpio2 27 0>;
> +
> +		col-gpios = <&gpio2 21 0
> +			     &gpio2 22 0>;
> +
> +		linux,keymap = <0x0000008B
> +				0x0100009E
> +				0x02000069
> +				0x0001006A
> +				0x0101001C
> +				0x0201006C>;
> +	};
> diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
> index 18b7237..39e480d 100644
> --- a/drivers/input/keyboard/matrix_keypad.c
> +++ b/drivers/input/keyboard/matrix_keypad.c
> @@ -23,6 +23,9 @@
>  #include <linux/gpio.h>
>  #include <linux/input/matrix_keypad.h>
>  #include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_platform.h>
>  
>  struct matrix_keypad {
>  	const struct matrix_keypad_platform_data *pdata;
> @@ -394,6 +397,91 @@ static void matrix_keypad_free_gpio(struct matrix_keypad *keypad)
>  		gpio_free(pdata->col_gpios[i]);
>  }
>  
> +#ifdef CONFIG_OF
> +static
> +struct matrix_keypad_platform_data *matrix_keypad_parse_dt(struct device *dev)
> +{
> +	struct matrix_keypad_platform_data *pdata;
> +	struct matrix_keymap_data *keymap_data;
> +	struct device_node *np = dev->of_node;
> +	struct property *prop;
> +	int key_count = 0, length, row, col;
> +	uint32_t *keymap;
> +
> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata) {
> +		dev_err(dev, "could not allocate memory for platform data\n");
> +		return NULL;
> +	}
> +
> +	of_property_read_u32(np, "keypad,num-row-gpios", &pdata->num_row_gpios);
> +	of_property_read_u32(np, "keypad,num-col-gpios", &pdata->num_col_gpios);
> +	if (!pdata->num_row_gpios || !pdata->num_col_gpios) {
> +		dev_err(dev, "number of keypad rows/columns not specified\n");
> +		return NULL;
> +	}
> +
> +	keymap_data = devm_kzalloc(dev, sizeof(*keymap_data), GFP_KERNEL);
> +	if (!keymap_data) {
> +		dev_err(dev, "could not allocate memory for keymap data\n");
> +		return NULL;
> +	}
> +	pdata->keymap_data = keymap_data;
> +
> +	prop = of_find_property(np, "linux,keymap", &length);
> +	if (!prop)
> +		return NULL;
> +
> +	key_count = length / sizeof(u32);
> +	keymap_data->keymap_size = key_count;
> +	keymap = devm_kzalloc(dev, sizeof(uint32_t) * key_count, GFP_KERNEL);
> +	if (!keymap) {
> +		dev_err(dev, "could not allocate memory for keymap\n");
> +		return NULL;
> +	}
> +	keymap_data->keymap = keymap;
> +
> +	of_property_read_u32_array(np, "linux,keymap", keymap, key_count);

Can't you use matrix_keypad_parse_of_keymap?

> +
> +	if (of_get_property(np, "linux,no-autorepeat", NULL))
> +		pdata->no_autorepeat = true;
> +	if (of_get_property(np, "linux,wakeup", NULL))
> +		pdata->wakeup = true;
> +	if (of_get_property(np, "gpio-activelow", NULL))
> +		pdata->active_low = true;
> +
> +	of_property_read_u32(np, "debounce-delay-ms", &pdata->debounce_ms);
> +	of_property_read_u32(np, "col-scan-delay-us",
> +						&pdata->col_scan_delay_us);
> +	of_property_read_u32(np, "clustered-irq", &pdata->clustered_irq);
> +	of_property_read_u32(np, "clustered-irq-flags",
> +						&pdata->clustered_irq_flags);
> +
> +	pdata->row_gpios = devm_kzalloc(dev, sizeof(unsigned int) *
> +					pdata->num_row_gpios, GFP_KERNEL);
> +	pdata->col_gpios = devm_kzalloc(dev, sizeof(unsigned int) *
> +					pdata->num_col_gpios, GFP_KERNEL);

There's kind of a lot of allocations in this function. It would be good
to combine some of them.

> +	if (!pdata->row_gpios || !pdata->col_gpios) {
> +		dev_err(dev, "could not allocate memory for gpios\n");
> +		return NULL;
> +	}
> +
> +	for (row = 0; row < pdata->num_row_gpios; row++)
> +		pdata->row_gpios[row] = of_get_named_gpio(np, "row-gpios", row);
> +
> +	for (col = 0; col < pdata->num_col_gpios; col++)
> +		pdata->col_gpios[col] = of_get_named_gpio(np, "col-gpios", col);
> +
> +	return pdata;
> +}
> +#else
> +static
> +struct matrix_keypad_platform_data *matrix_keypad_parse_dt(struct device *dev)
> +{
> +	return NULL;
> +}
> +#endif
> +
>  static int __devinit matrix_keypad_probe(struct platform_device *pdev)
>  {
>  	const struct matrix_keypad_platform_data *pdata;
> @@ -404,7 +492,10 @@ static int __devinit matrix_keypad_probe(struct platform_device *pdev)
>  	size_t keymap_size;
>  	int err;
>  
> -	pdata = pdev->dev.platform_data;
> +	if (pdev->dev.of_node)
> +		pdata = matrix_keypad_parse_dt(&pdev->dev);
> +	else
> +		pdata = pdev->dev.platform_data;
>  	if (!pdata) {
>  		dev_err(&pdev->dev, "no platform data defined\n");
>  		return -EINVAL;
> @@ -488,6 +579,16 @@ static int __devexit matrix_keypad_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id matrix_keypad_dt_match[] = {
> +	{ .compatible = "matrix-keypad" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, matrix_keypad_dt_match);
> +#else
> +#define matrix_keypad_dt_match NULL
> +#endif

Use of_match_ptr() and remove the #else

Rob

> +
>  static struct platform_driver matrix_keypad_driver = {
>  	.probe		= matrix_keypad_probe,
>  	.remove		= __devexit_p(matrix_keypad_remove),
> @@ -495,6 +596,7 @@ static struct platform_driver matrix_keypad_driver = {
>  		.name	= "matrix-keypad",
>  		.owner	= THIS_MODULE,
>  		.pm	= &matrix_keypad_pm_ops,
> +		.of_match_table = matrix_keypad_dt_match,
>  	},
>  };
>  module_platform_driver(matrix_keypad_driver);
> 

