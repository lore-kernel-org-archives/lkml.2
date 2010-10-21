Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0JURWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:22:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13631 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab0JURWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:22:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Thu, 21 Oct 2010 10:22:23 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Andrew Chew <AChew@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 21 Oct 2010 10:22:12 -0700
Subject: RE: [PATCH] POWER: Add gpio chager driver
Thread-Topic: [PATCH] POWER: Add gpio chager driver
Thread-Index: ActxKj0imvuAocoZSJCc/nriBlaW5QAGie9A
Message-ID: <E88A1D35AF5437468E5B14C7C4BA61C702D37CAAE8@HQMAIL01.nvidia.com>
References: <4CC02FF9.3050804@metafoo.de>
 <1287663957-30099-1-git-send-email-lars@metafoo.de>
 <20101021141407.GA26602@oksana.dev.rtsoft.ru>
In-Reply-To: <20101021141407.GA26602@oksana.dev.rtsoft.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9LHMgWq005280

> From: Anton Vorontsov [mailto:cbouatmailru@gmail.com]
> Sent: Thursday, October 21, 2010 7:14 AM
> To: Lars-Peter Clausen
> Cc: Rhyland Klein; broonie@opensource.wolfsonmicro.com; Andrew Chew;
> olof@lixom.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] POWER: Add gpio chager driver
> 
> On Thu, Oct 21, 2010 at 02:25:57PM +0200, Lars-Peter Clausen wrote:
> > This patch adds a simple driver for chargers indicating their online
> status
> > through a GPIO pin.
> >
> > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> I agree, the GPIO name fits better. Rhyland, are you OK with that
> driver, does it fit your needs?

This would be great. I will give it a test but from reading over it, it sounds perfect for my needs.

> 
> Some comments down below.
> 
> [...]
> > +struct gpio_charger {
> > +	const struct gpio_charger_platform_data *pdata;
> > +	int irq;
> 
> This can be unsigned.
> 
> > +
> > +	struct power_supply charger;
> > +};
> > +
> > +static irqreturn_t gpio_charger_irq(int irq, void *devid)
> > +{
> > +	struct power_supply *charger = devid;
> 
> Please add an empty line here.
> 
> > +	power_supply_changed(charger);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static inline struct gpio_charger *psy_to_gpio_charger(struct
> power_supply *psy)
> > +{
> > +	return container_of(psy, struct gpio_charger, charger);
> > +}
> > +
> > +static int gpio_charger_get_property(struct power_supply *psy,
> > +	enum power_supply_property psp, union power_supply_propval *val)
> 
> One more tab for here?
> 
> > +{
> > +	struct gpio_charger *gpio_charger = psy_to_gpio_charger(psy);
> > +	const struct gpio_charger_platform_data *pdata = gpio_charger->pdata;
> > +
> > +	switch (psp) {
> > +	case POWER_SUPPLY_PROP_ONLINE:
> > +		val->intval = gpio_get_value(pdata->gpio);
> > +		val->intval ^= pdata->gpio_active_low;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static enum power_supply_property gpio_charger_properties[] = {
> > +	POWER_SUPPLY_PROP_ONLINE,
> > +};
> > +
> > +static int __devinit gpio_charger_probe(struct platform_device *pdev)
> > +{
> > +	const struct gpio_charger_platform_data *pdata = pdev-
> >dev.platform_data;
> > +	struct gpio_charger *gpio_charger;
> > +	struct power_supply *charger;
> > +	int ret;
> > +
> > +	if (!pdata) {
> > +		dev_err(&pdev->dev, "No platform data");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!gpio_is_valid(pdata->gpio)) {
> > +		dev_err(&pdev->dev, "Invalid gpio pin\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	gpio_charger = kzalloc(sizeof(*gpio_charger), GFP_KERNEL);
> > +
> > +	charger = &gpio_charger->charger;
> > +
> > +	charger->name = pdata->name;
> > +	charger->type = pdata->type;
> > +	charger->properties = gpio_charger_properties;
> > +	charger->num_properties = ARRAY_SIZE(gpio_charger_properties);
> > +	charger->get_property  = gpio_charger_get_property;
> > +	charger->supplied_to = pdata->supplied_to;
> > +	charger->num_supplicants = pdata->num_supplicants;
> > +
> > +	ret = gpio_request(pdata->gpio, dev_name(&pdev->dev));
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to request gpio pin: %d\n", ret);
> > +		goto err_free;
> > +	}
> > +	ret = gpio_direction_input(pdata->gpio);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to set gpio to input: %d\n", ret);
> > +		goto err_gpio_free;
> > +	}
> > +
> > +	gpio_charger->irq = gpio_to_irq(pdata->gpio);
> > +	if (gpio_charger->irq >= 0) {
> 
> 0 isn't valid IRQ number. The check should be just 'if (gpio_charger-
> >irq)'.
> 
> > +		ret = request_irq(gpio_charger->irq, gpio_charger_irq,
> > +				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
> > +				dev_name(&pdev->dev), charger);
> > +		if (ret) {
> > +			dev_warn(&pdev->dev, "Failed to request gpio irq: %d\n",
> ret);
> > +			gpio_charger->irq = -1;
> > +		}
> > +	}
> > +
> > +	gpio_charger->pdata = pdata;
> > +
> > +	ret = power_supply_register(&pdev->dev, charger);
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev, "Failed to register power supply: %d\n",
> ret);
> > +		goto err_irq_free;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, gpio_charger);
> > +
> > +	return 0;
> > +
> > +err_irq_free:
> > +	if (gpio_charger->irq >= 0)
> > +		free_irq(gpio_charger->irq, charger);
> > +err_gpio_free:
> > +	gpio_free(pdata->gpio);
> > +err_free:
> > +	kfree(gpio_charger);
> > +	return ret;
> > +}
> > +
> > +static int __devexit gpio_charger_remove(struct platform_device *pdev)
> > +{
> > +	struct gpio_charger *gpio_charger = platform_get_drvdata(pdev);
> > +	const struct gpio_charger_platform_data *pdata = gpio_charger->pdata;
> > +
> > +	power_supply_unregister(&gpio_charger->charger);
> > +
> > +	if (gpio_charger->irq >= 0)
> > +		free_irq(gpio_charger->irq, &gpio_charger->charger);
> > +	gpio_free(pdata->gpio);
> > +
> > +	platform_set_drvdata(pdev, NULL);
> > +	kfree(gpio_charger);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver  gpio_charger_driver = {
> > +	.probe = gpio_charger_probe,
> > +	.remove = __devexit_p(gpio_charger_remove),
> > +	.driver = {
> > +		.name = "gpio-charger",
> > +		.owner = THIS_MODULE,
> > +	},
> > +};
> > +
> > +static int __init gpio_charger_init(void)
> > +{
> > +	return platform_driver_register(&gpio_charger_driver);
> > +}
> > +module_init(gpio_charger_init);
> > +
> > +static void __exit gpio_charger_exit(void)
> > +{
> > +	platform_driver_unregister(&gpio_charger_driver);
> > +}
> > +module_exit(gpio_charger_exit);
> > +
> > +MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
> > +MODULE_DESCRIPTION("Driver for chargers which report their online status
> through a GPIO");
> > +MODULE_LICENSE("GPL");
> > +MODULE_ALIAS("platform:gpio-charger");
> > diff --git a/include/linux/power/gpio-charger.h
> b/include/linux/power/gpio-charger.h
> > new file mode 100644
> > index 0000000..404d5e6
> > --- /dev/null
> > +++ b/include/linux/power/gpio-charger.h
> > @@ -0,0 +1,39 @@
> > +/*
> > + *  Copyright (C) 2010, Lars-Peter Clausen <lars@metafoo.de>
> > + *
> > + *  This program is free software; you can redistribute	 it and/or
> modify it
> > + *  under  the terms of	 the GNU General  Public License as published
> by the
> > + *  Free Software Foundation;  either version 2 of the	License, or (at
> your
> > + *  option) any later version.
> > + *
> > + *  You should have received a copy of the  GNU General Public License
> along
> > + *  with this program; if not, write  to the Free Software Foundation,
> Inc.,
> > + *  675 Mass Ave, Cambridge, MA 02139, USA.
> > + *
> > + */
> > +
> > +#ifndef __LINUX_POWER_GPIO_CHARGER_H__
> > +#define __LINUX_POWER_GPIO_CHARGER_H__
> > +
> > +/*
> 
> Should be /**
> 
> > + * struct gpio_charger_platform_data - platform_data for gpio_charger
> devices
> > + * @name:		Name for the chargers power_supply device
> > + * @type:		Type of the charger
> > + * @gpio:		GPIO which is used to indicate the chargers status
> > + * @gpio_active_low:	Should be set to 1 if the GPIO is active low
> otherwise 0
> > + * @supplied_to:	Array of battery names to which this chargers
> supplies power
> > + * @num_supplicants:	Number of entries in the supplied_to array
> > + */
> > +
> 
> No need for this empty line.
> 
> > +struct gpio_charger_platform_data {
> > +	const char *name;
> > +	enum power_supply_type type;
> 
> #include <linux/power_supply.h> is needed for this.
> 
> > +
> > +	int gpio;
> > +	int gpio_active_low;
> > +
> > +	char **supplied_to;
> > +	size_t num_supplicants;
> 
> And #include <linux/types.h> for this.
> 
> > +};
> > +
> > +#endif
> 
> Thanks!
> 
> --
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
