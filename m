Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab2DYKxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:53:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49032 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654Ab2DYKxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:53:05 -0400
Date: Wed, 25 Apr 2012 11:52:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sourav Poddar <sourav.poddar@ti.com>, Roland Stigge <stigge@antcom.de>
Cc: devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@xenotime.net>, Felipe Balbi <balbi@ti.com>,
        linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4 1/2] drivers: input: keypad: Add device tree support
Message-ID: <20120425105235.GV24211@n2100.arm.linux.org.uk>
References: <1335346004-18108-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335346004-18108-1-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you and Roland Stigge need to put your heads together and come
up with a common DT binding for matrix keypad devices, rather than
inventing N different platform specific bindings.

On Wed, Apr 25, 2012 at 02:56:43PM +0530, Sourav Poddar wrote:
> Update the Documentation with omap4 keypad device tree
> binding information.
> Add device tree support for omap4 keypad driver.
> 
> Tested on omap4430 sdp with 3.4-rc3.
> 
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
> v3->v4: Fix stephen warren's comment
>  - Made use of the (linux, keymap) bindings as 
>   described in matrix-keyboard binding documentation.
>  
>  .../devicetree/bindings/input/omap-keypad.txt      |   31 +++++
>  drivers/input/keyboard/omap4-keypad.c              |  118 ++++++++++++++++----
>  2 files changed, 126 insertions(+), 23 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/input/omap-keypad.txt
> 
> diff --git a/Documentation/devicetree/bindings/input/omap-keypad.txt b/Documentation/devicetree/bindings/input/omap-keypad.txt
> new file mode 100644
> index 0000000..722425b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/omap-keypad.txt
> @@ -0,0 +1,31 @@
> +* TI's Keypad Controller device tree bindings
> +
> +TI's Keypad controller is used to interface a SoC with a matrix-type
> +keypad device. The keypad controller supports multiple row and column lines.
> +A key can be placed at each intersection of a unique row and a unique column.
> +The keypad controller can sense a key-press and key-release and report the
> +event using a interrupt to the cpu.
> +
> +Required SoC Specific Properties:
> +- compatible: should be one of the following
> +   - "ti,omap4-keypad": For controllers compatible with omap4 keypad
> +      controller.
> +
> +Required Board Specific Properties, in addition to those specified by
> +the shared matrix-keyboard bindings:
> +- keypad,num-rows: Number of row lines connected to the keypad
> +  controller.
> +
> +- keypad,num-columns: Number of column lines connected to the
> +  keypad controller.
> +
> +Optional Properties specific to linux:
> +- linux,keypad-no-autorepeat: do no enable autorepeat feature.
> +
> +Example:
> +        keypad@4ae1c000{
> +                compatible = "ti,omap4-keypad";
> +                keypad,num-rows = <2>;
> +                keypad,num-columns = <8>;
> +		linux,keypad-no-autorepeat;
> +	};
> diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
> index e809ac0..bce300e 100644
> --- a/drivers/input/keyboard/omap4-keypad.c
> +++ b/drivers/input/keyboard/omap4-keypad.c
> @@ -27,6 +27,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/errno.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
>  #include <linux/input.h>
>  #include <linux/slab.h>
>  #include <linux/pm_runtime.h>
> @@ -70,6 +71,7 @@
>  
>  struct omap4_keypad {
>  	struct input_dev *input;
> +	struct matrix_keymap_data *keymap_data;
>  
>  	void __iomem *base;
>  	int irq;
> @@ -77,6 +79,7 @@ struct omap4_keypad {
>  	unsigned int rows;
>  	unsigned int cols;
>  	unsigned int row_shift;
> +	bool no_autorepeat;
>  	unsigned char key_state[8];
>  	unsigned short keymap[];
>  };
> @@ -174,24 +177,101 @@ static void omap4_keypad_close(struct input_dev *input)
>  	pm_runtime_put_sync(input->dev.parent);
>  }
>  
> +static struct omap4_keypad *omap_keypad_parse_dt(struct device *dev)
> +{
> +	struct matrix_keymap_data *keymap_data;
> +	struct device_node *np = dev->of_node;
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct omap4_keypad *keypad_data = platform_get_drvdata(pdev);
> +	uint32_t *keymap;
> +	int proplen = 0, i;
> +	const __be32 *prop = of_get_property(np, "linux,keymap", &proplen);
> +
> +	keymap_data = devm_kzalloc(dev, sizeof(*keymap_data), GFP_KERNEL);
> +	if (!keymap_data) {
> +		dev_err(dev, "could not allocate memory for keymap data\n");
> +		return NULL;
> +	}
> +	keypad_data->keymap_data = keymap_data;
> +
> +	keymap_data->keymap_size = proplen / sizeof(u32);
> +
> +	keymap = devm_kzalloc(dev,
> +		sizeof(uint32_t) * keymap_data->keymap_size, GFP_KERNEL);
> +	if (!keymap) {
> +		dev_err(dev, "could not allocate memory for keymap\n");
> +		return NULL;
> +	}
> +	keypad_data->keymap_data->keymap = keymap;
> +
> +	for (i = 0; i < keymap_data->keymap_size; i++) {
> +		u32 tmp = be32_to_cpup(prop+i);
> +		int key_code, row, col;
> +
> +		row = (tmp >> 24) & 0xff;
> +		col = (tmp >> 16) & 0xff;
> +		key_code = tmp & 0xffff;
> +		*keymap++ = KEY(row, col, key_code);
> +	}
> +
> +	if (of_get_property(np, "linux,input-no-autorepeat", NULL))
> +		keypad_data->no_autorepeat = true;
> +
> +	return keypad_data;
> +}
> +
>  static int __devinit omap4_keypad_probe(struct platform_device *pdev)
>  {
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
>  	const struct omap4_keypad_platform_data *pdata;
>  	struct omap4_keypad *keypad_data;
>  	struct input_dev *input_dev;
>  	struct resource *res;
>  	resource_size_t size;
> -	unsigned int row_shift, max_keys;
> +	unsigned int row_shift = 0, max_keys = 0;
> +	uint32_t num_rows = 0, num_cols = 0;
>  	int irq;
>  	int error;
>  
>  	/* platform data */
>  	pdata = pdev->dev.platform_data;
> -	if (!pdata) {
> +	if (np) {
> +		of_property_read_u32(np, "keypad,num-rows", &num_rows);
> +		of_property_read_u32(np, "keypad,num-columns", &num_cols);
> +		if (!num_rows || !num_cols) {
> +			dev_err(&pdev->dev, "number of keypad rows/columns not specified\n");
> +			return -EINVAL;
> +		}
> +	} else if (pdata) {
> +		num_rows = pdata->rows;
> +		num_cols = pdata->cols;
> +	} else {
>  		dev_err(&pdev->dev, "no platform data defined\n");
>  		return -EINVAL;
>  	}
>  
> +	row_shift = get_count_order(num_cols);
> +	max_keys = num_rows << row_shift;
> +
> +	keypad_data = devm_kzalloc(dev, sizeof(struct omap4_keypad) +
> +			max_keys * sizeof(keypad_data->keymap[0]),
> +				GFP_KERNEL);
> +
> +	if (!keypad_data) {
> +		dev_err(&pdev->dev, "keypad_data memory allocation failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	platform_set_drvdata(pdev, keypad_data);
> +
> +	if (np) {
> +		keypad_data = omap_keypad_parse_dt(&pdev->dev);
> +	} else {
> +		keypad_data->keymap_data =
> +				(struct matrix_keymap_data *)pdata->keymap_data;
> +	}
> +
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res) {
>  		dev_err(&pdev->dev, "no base address specified\n");
> @@ -204,22 +284,6 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	if (!pdata->keymap_data) {
> -		dev_err(&pdev->dev, "no keymap data defined\n");
> -		return -EINVAL;
> -	}
> -
> -	row_shift = get_count_order(pdata->cols);
> -	max_keys = pdata->rows << row_shift;
> -
> -	keypad_data = kzalloc(sizeof(struct omap4_keypad) +
> -				max_keys * sizeof(keypad_data->keymap[0]),
> -			      GFP_KERNEL);
> -	if (!keypad_data) {
> -		dev_err(&pdev->dev, "keypad_data memory allocation failed\n");
> -		return -ENOMEM;
> -	}
> -
>  	size = resource_size(res);
>  
>  	res = request_mem_region(res->start, size, pdev->name);
> @@ -236,10 +300,10 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
>  		goto err_release_mem;
>  	}
>  
> +	keypad_data->rows = num_rows;
> +	keypad_data->cols = num_cols;
>  	keypad_data->irq = irq;
>  	keypad_data->row_shift = row_shift;
> -	keypad_data->rows = pdata->rows;
> -	keypad_data->cols = pdata->cols;
>  
>  	/* input device allocation */
>  	keypad_data->input = input_dev = input_allocate_device();
> @@ -263,13 +327,15 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
>  	input_dev->keycodemax	= max_keys;
>  
>  	__set_bit(EV_KEY, input_dev->evbit);
> -	__set_bit(EV_REP, input_dev->evbit);
> +
> +	if (!keypad_data->no_autorepeat)
> +		__set_bit(EV_REP, input_dev->evbit);
>  
>  	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
>  
>  	input_set_drvdata(input_dev, keypad_data);
>  
> -	matrix_keypad_build_keymap(pdata->keymap_data, row_shift,
> +	matrix_keypad_build_keymap(keypad_data->keymap_data, row_shift,
>  			input_dev->keycode, input_dev->keybit);
>  
>  	error = request_irq(keypad_data->irq, omap4_keypad_interrupt,
> @@ -288,7 +354,6 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
>  		goto err_pm_disable;
>  	}
>  
> -	platform_set_drvdata(pdev, keypad_data);
>  	return 0;
>  
>  err_pm_disable:
> @@ -327,12 +392,19 @@ static int __devexit omap4_keypad_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static const struct of_device_id omap_keypad_dt_match[] = {
> +	{ .compatible = "ti,omap4-keypad" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, omap_keypad_dt_match);
> +
>  static struct platform_driver omap4_keypad_driver = {
>  	.probe		= omap4_keypad_probe,
>  	.remove		= __devexit_p(omap4_keypad_remove),
>  	.driver		= {
>  		.name	= "omap4-keypad",
>  		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(omap_keypad_dt_match),
>  	},
>  };
>  module_platform_driver(omap4_keypad_driver);
> -- 
> 1.7.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
