Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab2BBWxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:53:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39533 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab2BBWxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:53:16 -0500
MIME-Version: 1.0
In-Reply-To: <1328194978-20064-1-git-send-email-stigge@antcom.de>
References: <1328194978-20064-1-git-send-email-stigge@antcom.de>
Date: Thu, 2 Feb 2012 14:53:15 -0800
Message-ID: <CADEiroq7=c6gqc-nT3V_HHDWhExfWw=hFY4XVz+-7UYd4Zze4w@mail.gmail.com>
Subject: Re: [PATCH] ARM: LPC32xx: ADC support
From: Kevin Wells <wellsk40@gmail.com>
To: stigge@antcom.de
Cc: w.sang@pengutronix.de, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, jic23@cam.ac.uk,
        gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 7:02 AM,  <stigge@antcom.de> wrote:
> This patch adds a 3-channel ADC driver for the LPC32xx ARM SoC
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>
>
> diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock.c
> index c269ef5..9cda6fa 100644
> --- a/arch/arm/mach-lpc32xx/clock.c
> +++ b/arch/arm/mach-lpc32xx/clock.c
> @@ -760,6 +760,36 @@ static struct clk clk_tsc = {
>        .get_rate       = local_return_parent_rate,
>  };
>
> +static int adc_onoff_enable(struct clk *clk, int enable)
> +{
> +       u32 tmp;
> +
> +       /* Use PERIPH_CLOCK */
> +       tmp = __raw_readl(LPC32XX_CLKPWR_ADC_CLK_CTRL_1);
> +       tmp |= LPC32XX_CLKPWR_ADCCTRL1_PCLK_SEL;
> +       /*
> +        * Set clock divider so that we have equal to or less than
> +        * 4.5MHz clock at ADC
> +        */
> +       tmp |= clk->get_rate(clk) / 4500000 + 1;
> +       __raw_writel(tmp, LPC32XX_CLKPWR_ADC_CLK_CTRL_1);

For this clock, also set clk->rate = (actual rate of the ADC input clock).
Something like clk->rate = clk->get_rate(clk->parent) / (computed divider)
If the clk->rate stays at 0, the clk_get_rate() function for the ADC will
return 13Mhz instead of around 4.5MHz.

(I know the driver doesn't use clk_get_rate(), but this might save some
debugging later if it ever does).

> +
> +       if (enable == 0)
> +               __raw_writel(0, clk->enable_reg);
> +       else
> +               __raw_writel(clk->enable_mask, clk->enable_reg);
> +
> +       return 0;
> +}
> +

...
...

> +config LPC32XX_ADC
> +       tristate "NXP LPC32XX ADC"
> +       depends on ARCH_LPC32XX && !TOUCHSCREEN_LPC32XX
> +       help
> +         Say yes here to build support for the integrated ADC inside the
> +         LPC32XX SoC. Note that this feature uses the same hardware as the
> +         touchscreen driver, so you can only select one of the two drivers
> +         (lpc32xx_adc or lpc32xx_ts). Provides direct access via sysfs.

I like how clean this driver is. Thanks for taking the time to write and submit
this.

> +
>  endmenu
> diff --git a/drivers/staging/iio/adc/Makefile b/drivers/staging/iio/adc/Makefile
> index ceee7f3..f83ab95 100644
> --- a/drivers/staging/iio/adc/Makefile
> +++ b/drivers/staging/iio/adc/Makefile
> @@ -37,3 +37,4 @@ obj-$(CONFIG_AD7192) += ad7192.o

...
...

> +       platform_set_drvdata(pdev, info);
> +
> +       device_init_wakeup(&pdev->dev, 1);

I don't think you need this for this driver.

> +       init_completion(&info->completion);
> +
> +       printk(KERN_INFO "LPC32XX ADC driver loaded, IRQ %d\n", info->irq);

dev_info instead of printk

> +
> +       return 0;
> +
> +errout6:
> +       clk_disable(info->clk);
> +       clk_put(info->clk);
> +errout5:
> +       iio_device_unregister(info->dev);
> +errout4:
> +       iounmap(info->adc_base);
> +errout3:
> +       iio_free_device(info->dev);
> +errout1:
> +       return retval;
> +}
> +
> +static int __devexit lpc32xx_adc_remove(struct platform_device *pdev)
> +{
> +       struct lpc32xx_adc_info *info = platform_get_drvdata(pdev);
> +
> +       free_irq(info->irq, info->dev);
> +       platform_set_drvdata(pdev, NULL);
> +       clk_disable(info->clk);
> +       clk_put(info->clk);
> +       iio_device_unregister(info->dev);
> +       iio_free_device(info->dev);
> +       iounmap(info->adc_base);
> +       kfree(info);

This may be ok. Needs a sanity check only.
kfree() is used in remove() but not used in probe() failure path. Might be
missing in probe() or not needed here.

> +
> +       printk(KERN_INFO "LPC32XX ADC driver unloaded\n");

dev_info()

> +
> +       return 0;
> +}
> +
> +#if defined(CONFIG_SUSPEND)
> +static int lpc32xx_adc_suspend(struct device *dev)
> +{
> +       struct lpc32xx_adc_info *info = dev_get_drvdata(dev);
> +
> +       clk_disable(info->clk);

The ADC block doesn't have to remain clocked when it's not being used.
You might just encapsulate the main ADC read code with clock enable/disable
and remove the suspend code and enable/disable code in probe/remove.
This should save a little power when the ADC is idle.

> +       return 0;
> +}
> +
> +static int lpc32xx_adc_resume(struct device *dev)
> +{
> +       struct lpc32xx_adc_info *info = dev_get_drvdata(dev);
> +
> +       clk_enable(info->clk);
> +       return 0;
> +}
> +
> +static const struct dev_pm_ops lpc32xx_adc_pm_ops = {
> +       .suspend        = lpc32xx_adc_suspend,
> +       .resume         = lpc32xx_adc_resume,
> +};
> +#define LPC32XX_ADC_PM_OPS (&lpc32xx_adc_pm_ops)
> +#else
> +#define LPC32XX_ADC_PM_OPS NULL
> +#endif
> +
> +static struct platform_driver lpc32xx_adc_driver = {
> +       .probe          = lpc32xx_adc_probe,
> +       .remove         = __devexit_p(lpc32xx_adc_remove),
> +       .driver         = {
> +               .name   = MOD_NAME,
> +               .owner  = THIS_MODULE,
> +               .pm     = LPC32XX_ADC_PM_OPS,
> +       },
> +};
> +
> +static int __init lpc32xx_adc_init(void)
> +{
> +       return platform_driver_register(&lpc32xx_adc_driver);
> +}
> +
> +static void __exit lpc32xx_adc_exit(void)
> +{
> +       platform_driver_unregister(&lpc32xx_adc_driver);
> +}
> +
> +module_init(lpc32xx_adc_init);
> +module_exit(lpc32xx_adc_exit);
> +
> +MODULE_AUTHOR("Roland Stigge <stigge@antcom.de>");
> +MODULE_DESCRIPTION("LPC32XX ADC driver");
> +MODULE_LICENSE("GPL");
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
