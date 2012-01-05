Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab2AETJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:09:14 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:62141 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758091Ab2AETJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:09:12 -0500
Message-ID: <4F05F509.6020405@metafoo.de>
Date: Thu, 05 Jan 2012 20:07:53 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Subject: Re: [PATCH] backlight: lcd: add driver for raster-type lcd's with
 gpio controlled panel reset
References: <1325778146-27056-1-git-send-email-thomas.abraham@linaro.org>
In-Reply-To: <1325778146-27056-1-git-send-email-thomas.abraham@linaro.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [...]
> 
> diff --git a/Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt b/Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt
> new file mode 100644
> index 0000000..941e2ff
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt
> @@ -0,0 +1,39 @@
> +* Power controller for simple lcd panels
> +
> +Some LCD panels provide a simple control interface for the host system. The
> +control mechanism would include a nRESET line connected to a gpio of the host
> +system and a Vcc supply line which the host can optionally be controlled using
> +a voltage regulator. Such simple panels do not support serial command
> +interface (such as i2c or spi) or memory-mapped-io interface.
> +
> +Required properties:
> +- compatible: should be 'lcd,powerctrl'
> +- gpios: The GPIO number of the host system used to control the nRESET line.
> +  The format of the gpio specifier depends on the gpio controller of the
> +  host system.
> +
> +Optional properties:
> +- lcd,pwrctrl-nreset-gpio-invert: When the nRESET line is asserted low, the
> +  lcd panel is reset and stays in reset mode as long as the nRESET line is
> +  asserted low. This is the default behaviour of most lcd panels. If a lcd
> +  panel requires the nRESET line to be asserted high for panel reset, then
> +  this property is used.

Maybe use OF_GPIO_ACTIVE_LOW here instead. That would make active high the
default but be a bit more consistent.

> +- lcd,pwrctrl-min-uV: If a regulator controls the Vcc voltage of the lcd panel,
> +  this property specifies the minimum voltage the regulator should supply.
> +  The value of this property should in in micro-volts.
> +- lcd,pwrctrl-max-uV: If a regulator controls the Vcc voltage of the lcd panel,
> +  this property specifies the maximum voltage the regulator should limit to
> +  on the Vcc line. The value of this property should in in micro-volts.

The min and max voltage should rather be specified through the regulator
constraints.


> +- vcc-lcd-supply: phandle of the regulator that controls the vcc supply to
> +  the lcd panel.
> +
[...]
> diff --git a/drivers/video/backlight/lcd_pwrctrl.c b/drivers/video/backlight/lcd_pwrctrl.c
> new file mode 100644
> index 0000000..6f3110b
> --- /dev/null
> +++ b/drivers/video/backlight/lcd_pwrctrl.c
> @@ -0,0 +1,231 @@
> [...]
> +static int lcd_pwrctrl_set_power(struct lcd_device *lcd, int power)
> +{
> +	struct lcd_pwrctrl *lp = lcd_get_data(lcd);
> +	struct lcd_pwrctrl_data *pd = lp->pdata;
> +	int lcd_enable, lcd_reset;
> +
> +	lcd_enable = (power == FB_BLANK_POWERDOWN || lp->suspended) ? 0 : 1;
> +	lcd_reset = (pd->invert) ? !lcd_enable : lcd_enable;
> +
> +	if (IS_ERR(lp->regulator))
> +		goto no_regulator;

I wouldn't use a goto here.

> +
> +	if (lcd_enable) {
> +		if ((pd->min_uV || pd->max_uV) &&
> +			regulator_set_voltage(lp->regulator,
> +						pd->min_uV, pd->max_uV))
> +				dev_info(lp->dev,
> +					"regulator voltage set failed\n");
> +		if (regulator_enable(lp->regulator))
> +			dev_info(lp->dev, "failed to enable regulator\n");
> +	} else {
> +		regulator_disable(lp->regulator);
> +	}

I think you have to make sure that the regulator enable and disable calls are
balanced.

> +
> + no_regulator:
> +	gpio_direction_output(lp->pdata->gpio, lcd_reset);
> +	lp->power = power;
> +	return 0;
> +}
> +
[...]
> +
> +#ifdef CONFIG_OF

I think you can remove all the CONFIG_OF ifdefs, the of API should stub itself out.

> +static void __devinit lcd_pwrctrl_parse_dt(struct device *dev,
> +					struct lcd_pwrctrl_data *pdata)
> +{
> +	struct device_node *np = dev->of_node;
> +
> +	pdata->gpio = of_get_gpio(np, 0);
> +	if (of_get_property(np, "lcd,pwrctrl-nreset-gpio-invert", NULL))
> +		pdata->invert = true;
> +	of_property_read_u32(np, "lcd,pwrctrl-min-uV", &pdata->min_uV);
> +	of_property_read_u32(np, "lcd,pwrctrl-max-uV", &pdata->max_uV);
> +}
> +#endif
> +
> +static int __devinit lcd_pwrctrl_probe(struct platform_device *pdev)
> +{
> +	struct lcd_pwrctrl *lp;
> +	struct lcd_pwrctrl_data *pdata = pdev->dev.platform_data;
> +	struct device *dev = &pdev->dev;
> +	int err;
> +
> +#ifdef CONFIG_OF
> +	if (dev->of_node) {
> +		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +		if (!pdata) {
> +			dev_err(dev, "memory allocation for pdata failed\n");
> +			return -ENOMEM;
> +		}
> +		lcd_pwrctrl_parse_dt(dev, pdata);
> +	}
> +#endif
> +
> +	if (!pdata) {
> +		dev_err(dev, "platform data not available\n");
> +		return -EINVAL;
> +	}
> +
> +	err = gpio_request(pdata->gpio, "LCD-nRESET");
> +	if (err) {
> +		dev_err(dev, "gpio [%d] request failed\n", pdata->gpio);
> +		return err;
> +	}
> +
> +	lp = devm_kzalloc(dev, sizeof(struct lcd_pwrctrl), GFP_KERNEL);
> +	if (!lp) {
> +		dev_err(dev, "memory allocation failed for private data\n");
> +		return -ENOMEM;

You are leaking the gpio here.

> +	}
> +
> +	/*
> +	 * If power to lcd and/or lcd interface is controlled using a regulator,
> +	 * get the handle to the regulator for later use during power switching.
> +	 */
> +	lp->regulator = regulator_get(dev, "vcc-lcd");
> +	if (IS_ERR(lp->regulator))
> +		dev_info(dev, "could not find regulator\n");
> +
> +	lp->dev = dev;
> +	lp->pdata = pdata;
> +	lp->lcd = lcd_device_register(dev_name(dev), dev, lp, &lcd_pwrctrl_ops);
> +	if (IS_ERR(lp->lcd)) {
> +		dev_err(dev, "cannot register lcd device\n");
> +		regulator_put(lp->regulator);

And here.

> +		return PTR_ERR(lp->lcd);
> +	}
> +
> +	platform_set_drvdata(pdev, lp);
> +	lcd_pwrctrl_set_power(lp->lcd, FB_BLANK_NORMAL);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id lcd_pwrctrl_match[] = {
> +	{ .compatible = "lcd,powerctrl", },
> +	{},
> +};

MODULE_DEVICE_TABLE(...)

> +#endif


> +static struct platform_driver lcd_pwrctrl_driver = {
> +	.driver		= {
> +		.name	= "lcd-pwrctrl",
> +		.owner	= THIS_MODULE,
> +		.of_match_table	= of_match_ptr(lcd_pwrctrl_match),
> +	},
> +	.probe		= lcd_pwrctrl_probe,
> +	.remove		= lcd_pwrctrl_remove,
> +	.suspend	= lcd_pwrctrl_suspend,
> +	.resume		= lcd_pwrctrl_resume,

please use dev_pm_ops instead of the legacy callbacks

> +};
> +
> +static int __init lcd_pwrctrl_init(void)
> +{
> +	return platform_driver_register(&lcd_pwrctrl_driver);
> +}
> +
> +static void __exit lcd_pwrctrl_cleanup(void)
> +{
> +	platform_driver_unregister(&lcd_pwrctrl_driver);
> +}
> +
> +module_init(lcd_pwrctrl_init);
> +module_exit(lcd_pwrctrl_cleanup);

module_platform_driver(&lcd_pwrctrl_driver);

> +
> +MODULE_AUTHOR("Thomas Abraham <thomas.ab@samsung.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:lcd-pwrctrl");

