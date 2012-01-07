Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2AGKql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 05:46:41 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37469 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2AGKqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 05:46:39 -0500
MIME-Version: 1.0
In-Reply-To: <4F05F509.6020405@metafoo.de>
References: <1325778146-27056-1-git-send-email-thomas.abraham@linaro.org>
	<4F05F509.6020405@metafoo.de>
Date: Sat, 7 Jan 2012 16:16:37 +0530
Message-ID: <CAJuYYwQjQF_6qbPPCG68vcu=xgoj+jRXuTsHBA2VcSiUM95g-g@mail.gmail.com>
Subject: Re: [PATCH] backlight: lcd: add driver for raster-type lcd's with
 gpio controlled panel reset
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On 6 January 2012 00:37, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> [...]
>>
>> diff --git a/Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt b/Documentation/devicetree/bindings/lcd/lcd-pwrctrl.txt
[...]

>> +Optional properties:
>> +- lcd,pwrctrl-nreset-gpio-invert: When the nRESET line is asserted low, the
>> +  lcd panel is reset and stays in reset mode as long as the nRESET line is
>> +  asserted low. This is the default behaviour of most lcd panels. If a lcd
>> +  panel requires the nRESET line to be asserted high for panel reset, then
>> +  this property is used.
>
> Maybe use OF_GPIO_ACTIVE_LOW here instead. That would make active high the
> default but be a bit more consistent.

Thanks for pointing this out. But most of these panels have active low
RESET line. So OF_GPIO_ACTIVE_LOW will need to be added for every lcd
node in dts file. How about adding a new 'OF_GPIO_ACTIVE_HIGH' instead
and keeping active-low the default?

>
>> +- lcd,pwrctrl-min-uV: If a regulator controls the Vcc voltage of the lcd panel,
>> +  this property specifies the minimum voltage the regulator should supply.
>> +  The value of this property should in in micro-volts.
>> +- lcd,pwrctrl-max-uV: If a regulator controls the Vcc voltage of the lcd panel,
>> +  this property specifies the maximum voltage the regulator should limit to
>> +  on the Vcc line. The value of this property should in in micro-volts.
>
> The min and max voltage should rather be specified through the regulator
> constraints.

The min and max voltage is a panel specific property which is used to
configure the regulator. The regulator might be capable of a larger
range but these value is used to setup the regulator to output a
voltage suitable for the panel.

>
>
>> +- vcc-lcd-supply: phandle of the regulator that controls the vcc supply to
>> +  the lcd panel.
>> +
> [...]
>> diff --git a/drivers/video/backlight/lcd_pwrctrl.c b/drivers/video/backlight/lcd_pwrctrl.c
>> new file mode 100644
>> index 0000000..6f3110b
>> --- /dev/null
>> +++ b/drivers/video/backlight/lcd_pwrctrl.c
>> @@ -0,0 +1,231 @@
>> [...]
>> +static int lcd_pwrctrl_set_power(struct lcd_device *lcd, int power)
>> +{
>> +     struct lcd_pwrctrl *lp = lcd_get_data(lcd);
>> +     struct lcd_pwrctrl_data *pd = lp->pdata;
>> +     int lcd_enable, lcd_reset;
>> +
>> +     lcd_enable = (power == FB_BLANK_POWERDOWN || lp->suspended) ? 0 : 1;
>> +     lcd_reset = (pd->invert) ? !lcd_enable : lcd_enable;
>> +
>> +     if (IS_ERR(lp->regulator))
>> +             goto no_regulator;
>
> I wouldn't use a goto here.

Ok. I was not happy either while writing it. I will re-work this.

>
>> +
>> +     if (lcd_enable) {
>> +             if ((pd->min_uV || pd->max_uV) &&
>> +                     regulator_set_voltage(lp->regulator,
>> +                                             pd->min_uV, pd->max_uV))
>> +                             dev_info(lp->dev,
>> +                                     "regulator voltage set failed\n");
>> +             if (regulator_enable(lp->regulator))
>> +                     dev_info(lp->dev, "failed to enable regulator\n");
>> +     } else {
>> +             regulator_disable(lp->regulator);
>> +     }
>
> I think you have to make sure that the regulator enable and disable calls are
> balanced.

Ok. I was check on this and do required changes.

>
>> +
>> + no_regulator:
>> +     gpio_direction_output(lp->pdata->gpio, lcd_reset);
>> +     lp->power = power;
>> +     return 0;
>> +}
>> +
> [...]
>> +
>> +#ifdef CONFIG_OF
>
> I think you can remove all the CONFIG_OF ifdefs, the of API should stub itself out.

This #ifdef is to keep the OF code out in case of non-OF only compilation.

[...]

>> +     err = gpio_request(pdata->gpio, "LCD-nRESET");
>> +     if (err) {
>> +             dev_err(dev, "gpio [%d] request failed\n", pdata->gpio);
>> +             return err;
>> +     }
>> +
>> +     lp = devm_kzalloc(dev, sizeof(struct lcd_pwrctrl), GFP_KERNEL);
>> +     if (!lp) {
>> +             dev_err(dev, "memory allocation failed for private data\n");
>> +             return -ENOMEM;
>
> You are leaking the gpio here.

Ok. I will fix this.

>
>> +     }
>> +
>> +     /*
>> +      * If power to lcd and/or lcd interface is controlled using a regulator,
>> +      * get the handle to the regulator for later use during power switching.
>> +      */
>> +     lp->regulator = regulator_get(dev, "vcc-lcd");
>> +     if (IS_ERR(lp->regulator))
>> +             dev_info(dev, "could not find regulator\n");
>> +
>> +     lp->dev = dev;
>> +     lp->pdata = pdata;
>> +     lp->lcd = lcd_device_register(dev_name(dev), dev, lp, &lcd_pwrctrl_ops);
>> +     if (IS_ERR(lp->lcd)) {
>> +             dev_err(dev, "cannot register lcd device\n");
>> +             regulator_put(lp->regulator);
>
> And here.

Ok. I will fix this.

>
>> +             return PTR_ERR(lp->lcd);
>> +     }
>> +
>> +     platform_set_drvdata(pdev, lp);
>> +     lcd_pwrctrl_set_power(lp->lcd, FB_BLANK_NORMAL);
>> +     return 0;
>> +}
>> +
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id lcd_pwrctrl_match[] = {
>> +     { .compatible = "lcd,powerctrl", },
>> +     {},
>> +};
>
> MODULE_DEVICE_TABLE(...)

Right. I missed that.

>
>> +#endif
>
>
>> +static struct platform_driver lcd_pwrctrl_driver = {
>> +     .driver         = {
>> +             .name   = "lcd-pwrctrl",
>> +             .owner  = THIS_MODULE,
>> +             .of_match_table = of_match_ptr(lcd_pwrctrl_match),
>> +     },
>> +     .probe          = lcd_pwrctrl_probe,
>> +     .remove         = lcd_pwrctrl_remove,
>> +     .suspend        = lcd_pwrctrl_suspend,
>> +     .resume         = lcd_pwrctrl_resume,
>
> please use dev_pm_ops instead of the legacy callbacks

Ok. I will use dev_pm_ops here.

[...]

Thanks for your review Lars.

Regards,
Thomas.
