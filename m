Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569Ab2C3Jhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 05:37:42 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:24739
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760552Ab2C3JhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 05:37:21 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz936eK1432N98dKc8kzz1202hzz8275bhz2dh2a8h668h839h93fhd24hd2bh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [PATCH 04/07] Backlight: Backlight module for DA9052/53 PMIC v1
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <rpurdie@rpsys.net>
CC: <tfransosi@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>, <dchen@diasemi.com>, <arnd@arndb.de>,
        <sameo@linux.intel.com>
In-Reply-To: <1331641693.7058.3.camel@dhruva>
References: <1328532352.30549.79.camel@dhruva>
	 <1331641693.7058.3.camel@dhruva>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Mar 2012 15:02:24 +0530
Message-ID: <1333099944.26252.1.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any update on this patch?
On Tue, 2012-03-13 at 17:58 +0530, Ashish Jangam wrote:
> Any update on below patch?
> On Mon, 2012-02-06 at 18:16 +0530, Ashish Jangam wrote:
> > DA9052/53 PMIC has capability to supply power for upto 3 banks of 6
> > white serial LEDS. It can also control intensity of independent banks
> > and to drive these banks boost converter will provide up to 24V and
> > forward current of max. 50mA.
> > 
> > This patch allows to control intensity of the individual WLEDs bank
> > through DA9052/53 PMIC.
> > 
> > This patch is functionally tested on Samsung SMDKV6410.
> > 
> > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > ---
> >  drivers/video/backlight/Kconfig     |    6 +
> >  drivers/video/backlight/Makefile    |    1 +
> >  drivers/video/backlight/da9052_bl.c |  187 +++++++++++++++++++++++++++++++++++
> >  3 files changed, 194 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/video/backlight/da9052_bl.c
> > diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> > index 49e7d83..77a3942 100644
> > --- a/drivers/video/backlight/Kconfig
> > +++ b/drivers/video/backlight/Kconfig
> > @@ -245,6 +245,12 @@ config BACKLIGHT_DA903X
> >  	  If you have a LCD backlight connected to the WLED output of DA9030
> >  	  or DA9034 WLED output, say Y here to enable this driver.
> >  
> > +config BACKLIGHT_DA9052
> > +	tristate "Dialog DA9052/DA9053 WLED"
> > +	depends on PMIC_DA9052
> > +	help
> > +	  Enable the Backlight Driver for DA9052-BC and DA9053-AA/Bx PMICs.
> > +
> >  config BACKLIGHT_MAX8925
> >  	tristate "Backlight driver for MAX8925"
> >  	depends on MFD_MAX8925
> > diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
> > index 0ee06e0..6622f34 100644
> > --- a/drivers/video/backlight/Makefile
> > +++ b/drivers/video/backlight/Makefile
> > @@ -28,6 +28,7 @@ obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
> >  obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
> >  obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
> >  obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
> > +obj-$(CONFIG_BACKLIGHT_DA9052)	+= da9052_bl.o
> >  obj-$(CONFIG_BACKLIGHT_MAX8925)	+= max8925_bl.o
> >  obj-$(CONFIG_BACKLIGHT_APPLE)	+= apple_bl.o
> >  obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
> > diff --git a/drivers/video/backlight/da9052_bl.c b/drivers/video/backlight/da9052_bl.c
> > new file mode 100644
> > index 0000000..b628d68
> > --- /dev/null
> > +++ b/drivers/video/backlight/da9052_bl.c
> > @@ -0,0 +1,187 @@
> > +/*
> > + * Backlight Driver for Dialog DA9052 PMICs
> > + *
> > + * Copyright(c) 2012 Dialog Semiconductor Ltd.
> > + *
> > + * Author: David Dajun Chen <dchen@diasemi.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + */
> > +
> > +#include <linux/backlight.h>
> > +#include <linux/delay.h>
> > +#include <linux/fb.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include <linux/mfd/da9052/da9052.h>
> > +#include <linux/mfd/da9052/reg.h>
> > +
> > +#define DA9052_MAX_BRIGHTNESS		0xFF
> > +
> > +enum {
> > +	DA9052_WLEDS_OFF,
> > +	DA9052_WLEDS_ON,
> > +};
> > +
> > +enum {
> > +	DA9052_TYPE_WLED1,
> > +	DA9052_TYPE_WLED2,
> > +	DA9052_TYPE_WLED3,
> > +};
> > +
> > +static unsigned char wled_bank[] = {
> > +	DA9052_LED1_CONF_REG,
> > +	DA9052_LED2_CONF_REG,
> > +	DA9052_LED3_CONF_REG,
> > +};
> > +
> > +struct da9052_bl {
> > +	struct da9052 *da9052;
> > +	uint brightness;
> > +	uint state;
> > +	uint led_reg;
> > +};
> > +
> > +static int da9052_adjust_wled_brightness(struct da9052_bl *wleds)
> > +{
> > +	unsigned char boost_en;
> > +	unsigned char i_sink;
> > +	int ret;
> > +
> > +	boost_en = 0x3F;
> > +	i_sink = 0xFF;
> > +	if (wleds->state == DA9052_WLEDS_OFF) {
> > +		boost_en = 0x00;
> > +		i_sink = 0x00;
> > +	}
> > +
> > +	ret = da9052_reg_write(wleds->da9052, DA9052_BOOST_REG, boost_en);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = da9052_reg_write(wleds->da9052, DA9052_LED_CONT_REG, i_sink);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = da9052_reg_write(wleds->da9052, wled_bank[wleds->led_reg], 0x0);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	msleep(10);
> > +
> > +	if (wleds->brightness) {
> > +		ret = da9052_reg_write(wleds->da9052, wled_bank[wleds->led_reg],
> > +				       wleds->brightness);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int da9052_backlight_update_status(struct backlight_device *bl)
> > +{
> > +	int brightness = bl->props.brightness;
> > +	struct da9052_bl *wleds = bl_get_data(bl);
> > +
> > +	wleds->brightness = brightness;
> > +	wleds->state = DA9052_WLEDS_ON;
> > +
> > +	return da9052_adjust_wled_brightness(wleds);
> > +}
> > +
> > +static int da9052_backlight_get_brightness(struct backlight_device *bl)
> > +{
> > +	struct da9052_bl *wleds = bl_get_data(bl);
> > +
> > +	return wleds->brightness;
> > +}
> > +
> > +static const struct backlight_ops da9052_backlight_ops = {
> > +	.update_status = da9052_backlight_update_status,
> > +	.get_brightness = da9052_backlight_get_brightness,
> > +};
> > +
> > +static int da9052_backlight_probe(struct platform_device *pdev)
> > +{
> > +	struct backlight_device *bl;
> > +	struct backlight_properties props;
> > +	struct da9052_bl *wleds;
> > +
> > +	wleds = devm_kzalloc(&pdev->dev, sizeof(struct da9052_bl), GFP_KERNEL);
> > +	if (!wleds)
> > +		return -ENOMEM;
> > +
> > +	wleds->da9052 = dev_get_drvdata(pdev->dev.parent);
> > +	wleds->brightness = 0;
> > +	wleds->led_reg = platform_get_device_id(pdev)->driver_data;
> > +	wleds->state = DA9052_WLEDS_OFF;
> > +
> > +	props.type = BACKLIGHT_RAW;
> > +	props.max_brightness = DA9052_MAX_BRIGHTNESS;
> > +
> > +	bl = backlight_device_register(pdev->name, wleds->da9052->dev, wleds,
> > +				       &da9052_backlight_ops, &props);
> > +	if (IS_ERR(bl)) {
> > +		dev_err(&pdev->dev, "Failed to register backlight\n");
> > +		devm_kfree(&pdev->dev, wleds);
> > +		return PTR_ERR(bl);
> > +	}
> > +
> > +	bl->props.max_brightness = DA9052_MAX_BRIGHTNESS;
> > +	bl->props.brightness = 0;
> > +	platform_set_drvdata(pdev, bl);
> > +
> > +	return da9052_adjust_wled_brightness(wleds);
> > +}
> > +
> > +static int da9052_backlight_remove(struct platform_device *pdev)
> > +{
> > +	struct backlight_device *bl = platform_get_drvdata(pdev);
> > +	struct da9052_bl *wleds = bl_get_data(bl);
> > +
> > +	wleds->brightness = 0;
> > +	wleds->state = DA9052_WLEDS_OFF;
> > +	da9052_adjust_wled_brightness(wleds);
> > +	backlight_device_unregister(bl);
> > +	devm_kfree(&pdev->dev, wleds);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_device_id da9052_wled_ids[] = {
> > +	{
> > +		.name		= "da9052-wled1",
> > +		.driver_data	= DA9052_TYPE_WLED1,
> > +	},
> > +	{
> > +		.name		= "da9052-wled2",
> > +		.driver_data	= DA9052_TYPE_WLED2,
> > +	},
> > +	{
> > +		.name		= "da9052-wled3",
> > +		.driver_data	= DA9052_TYPE_WLED3,
> > +	},
> > +};
> > +
> > +static struct platform_driver da9052_wled_driver = {
> > +	.probe		= da9052_backlight_probe,
> > +	.remove		= da9052_backlight_remove,
> > +	.id_table	= da9052_wled_ids,
> > +	.driver	= {
> > +		.name	= "da9052-wled",
> > +		.owner	= THIS_MODULE,
> > +	},
> > +};
> > +
> > +module_platform_driver(da9052_wled_driver);
> > +
> > +MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
> > +MODULE_DESCRIPTION("Backlight driver for DA9052 PMIC");
> > +MODULE_LICENSE("GPL");
> > +MODULE_ALIAS("platform:da9052-backlight");
> > 
> 


