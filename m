Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1DZLXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:23:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45177 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753840Ab1DZLXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:23:40 -0400
Date: Tue, 26 Apr 2011 12:23:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv1 -next] MFD: MFD module of DA9052 PMIC driver
Message-ID: <20110426112337.GA11848@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B89B13B@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B89B13B@KCINPUNHJCMS01.kpit.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 04:19:03PM +0530, Ashish Jangam wrote:

> +#define DA9052_SUBDEV(_name, _pdata, _pdata_sz, _res, _res_sz) \
> +       {                                       \
> +               .name = "da9052-"#_name,        \
> +               .platform_data = _pdata,        \
> +               .data_size = _pdata_sz,         \
> +               .num_resources = _res_sz,               \
> +               .resources = _res,              \
> +       }
> +/* As the function does not use global variable and

You need more blank lines in this driver than you have.

> +   da9052_reg_read() function has lock features an additional
> +   lock is not provided to access 'da9052_adc_manual_read' function to
> +   prevent concurrency issues */

This comment doesn't address the concurrency issue.  The issue is that:

> +       ret = da9052_reg_write(da9052, DA9052_ADC_MAN_REG,
> +                                       mux_sel);
> +               if (ret < 0)
> +                       return ret;

You write to select the input to read from here...

> +
> +       do {
> +               msleep(10);
> +
> +               ret = da9052_reg_read(da9052, DA9052_ADC_MAN_REG);
> +               if (ret < 0)
> +                       return ret;

...then wait for the result.  If something else comes in and tries to do
another ADC reading simultaneously you're in trouble.

> +static int da9052_add_subdevs(struct da9052 *da9052)
> +{
> +       struct da9052_pdata *pdata = da9052->dev->platform_data;
> +       int ret = 0;
> +
> +       struct mfd_cell da9052_subdev_info[] = {
> +               DA9052_SUBDEV(onkey, NULL, 0, &da9052_onkey_resource, 1),
> +               DA9052_SUBDEV(rtc, NULL, 0, &da9052_rtc_resource, 1),
> +               DA9052_SUBDEV(gpio, NULL, 0, NULL, 0),
> +               DA9052_SUBDEV(hwmon, NULL, 0, NULL, 0),
> +               DA9052_SUBDEV(leds, pdata->pled,
> +                                       sizeof(struct led_platform_data),
> +                                       NULL, 0),
> +               DA9052_SUBDEV(WLED1, NULL, 0, NULL, 0),
> +               DA9052_SUBDEV(WLED2, NULL, 0, NULL, 0),
> +               DA9052_SUBDEV(WLED3, NULL, 0, NULL, 0),
> +               DA9052_SUBDEV(tsi, pdata->ptsi,
> +                               sizeof(struct da9052_tsi_platform_data),
> +                                       da9052_tsi_resources,
> +                                       ARRAY_SIZE(da9052_tsi_resources)),
> +               DA9052_SUBDEV(bat, NULL, 0, da9052_power_resources,
> +                                         ARRAY_SIZE(da9052_power_resources)),
> +               DA9052_SUBDEV(watchdog, pdata->pwdt,
> +                       sizeof(struct da9052_wdt_platform_data), NULL, 0),

That's a large array to be allocating on the stack, and it's not obvious
why it isn't just static initdata anyway?

> +static struct i2c_device_id da9052_i2c_id[] = {
> +       { "da9052_i2c"},
> +};

As previously pointed out this would generally just be "da9052", the
fact that it's an I2C device is obvious from the fact that this is an
i2c_device_id being used by an i2c_driver.

> +MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
> +MODULE_DESCRIPTION("I2C driver for Dialog DA9052 PMIC");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:da9052_i2c");

This isn't a platform device.

> +int da9052_read_events(struct da9052 *da9052, unsigned char reg ,
> +                             unsigned int *events)
> +{
> +       uint8_t v[4] = {0, 0, 0, 0};
> +       int ret;
> +
> +       ret = da9052_group_read(da9052, reg, 4, v);
> +       if (ret < 0)
> +               return ret;
> +
> +       *events = (v[3] << 24) | (v[2] << 16) | (v[1] << 8) | v[0];
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(da9052_read_events);

This looks *incredibly* suspicious, why would anything outside the
interrupt code be looking at this?  There's also the fact that it's
separate to the set and clear functions in the main driver.

> +config PMIC_DA9052
> +       tristate "Support Dialog DA9052 PMIC"
> +       select MFD_CORE
> +       help
> +         Say yes here to support for Dialog semiconductor Da9052, Power
> +         Management IC. This option enables the SSC communication type
> +         needed to communicate with DA9052 PMIC.
> +choice
> +       prompt "DA9052 SSC support"
> +       depends on PMIC_DA9052
> +config MFD_DA9052_SPI
> +       bool "SPI"
> +       depends on SPI_MASTER=y
> +       help
> +         Say Y  to select SPI serial interface for DA9052 chip
> +config MFD_DA9052_I2C
> +       bool "I2C"
> +       depends on I2C=y
> +       help
> +         Say Y  to select I2C serial interface for DA9052 chip
> +endchoice
> +

This will prevent users building a kernel that supports both I2C and SPI
simultaneously.  You also want some blank lines in here.

> +
> +ifeq ($(CONFIG_MFD_DA9052_SPI),y)
> +da9052-objs                    := da9052-spi.o da9052-core.o da9052-irq.o
> +obj-$(CONFIG_PMIC_DA9052)      += da9052.o
> +endif
> +ifeq ($(CONFIG_MFD_DA9052_I2C),y)
> +da9052-objs                    := da9052-i2c.o da9052-core.o da9052-irq.o
> +obj-$(CONFIG_PMIC_DA9052)      += da9052.o
> +endif
> +

Why combine these into a single module?

> +struct da9052_pdata {
> +       struct led_platform_data *pled;
> +       struct da9052_wdt_platform_data *pwdt;
> +       struct da9052_tsi_platform_data *ptsi;
> +       int (*init) (struct da9052 *da9052);
> +       int irq;
> +       int irq_base;
> +       int num_subdevs;

Why is num_subdevs in the platform data?  That looks wrong...
