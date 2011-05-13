Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1EMGHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 02:07:50 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:59334
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab1EMGHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 02:07:49 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz936eK9371O542M1432N98dKc8kzz1202hzz8275bhz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:203.197.93.240;KIP:(null);UIP:(null);IPVD:NLI;H:Kcinpunhjhc01.kpit.com;RD:Kcinpunhjhc01.Kpit.com;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen2@diasemi.com>
Date: Fri, 13 May 2011 11:36:58 +0530
Subject: RE: [PATCHv1 -next] INPUT/MISC/ONKEY: OnKey module of DA9052 PMICs
 driver
Thread-Topic: [PATCHv1 -next] INPUT/MISC/ONKEY: OnKey module of DA9052 PMICs
 driver
Thread-Index: AcwLQP5f3BZHyKcYTBSCANUz+QrUrQF7/OfQ
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BC61BF2@KCINPUNHJCMS01.kpit.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5B899@KCINPUNHJCMS01.kpit.com>
 <20110505162354.GH27251@core.coreip.homeip.net>
In-Reply-To: <20110505162354.GH27251@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4D6815Z012037

Please see the inline comment. 

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Thursday, May 05, 2011 9:54 PM
> To: Ashish Jangam
> Cc: linux-kernel@vger.kernel.org; Dajun Chen
> Subject: Re: [PATCHv1 -next] INPUT/MISC/ONKEY: OnKey module of DA9052 PMICs
> driver
> 
> Hi Ashish,
> 
> On Wed, May 04, 2011 at 02:43:17PM +0530, Ashish Jangam wrote:
> > Hi Dmitry,
> >
> > ONKEY Driver for Dialog Semiconductor DA9052 PMICs.
> >
> > Changes made since last submission:
> > . made changes to error handling in probe function
> > . changed variable names to reflect their use
> >
> > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > ---
> > diff -Naur linux-next-20110421.orig/drivers/input/misc/da9052_onkey.c linux-
> next-20110421/drivers/input/misc/da9052_onkey.c
> > --- linux-next-20110421.orig/drivers/input/misc/da9052_onkey.c	1970-01-01
> 05:00:00.000000000 +0500
> > +++ linux-next-20110421/drivers/input/misc/da9052_onkey.c	2011-04-26
> 11:04:21.000000000 +0500
> > @@ -0,0 +1,165 @@
> > +/*
> > + * ON pin driver for Dialog DA9052 PMICs
> > + *
> > + * Copyright(c) 2011 Dialog Semiconductor Ltd.
> > + *
> > + * Author: David Dajun Chen <dchen@diasemi.com>
> > + *
> > + *  This program is free software; you can redistribute  it and/or modify
> it
> > + *  under  the terms of  the GNU General  Public License as published by
> the
> > + *  Free Software Foundation;  either version 2 of the  License, or (at
> your
> > + *  option) any later version.
> > + *
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/input.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include <linux/mfd/da9052/da9052.h>
> > +#include <linux/mfd/da9052/reg.h>
> > +
> > +struct da9052_onkey {
> > +	struct da9052 *da9052;
> > +	struct input_dev *input;
> > +	struct delayed_work work;
> > +	int irq;
> > +};
> > +
> > +static void da9052_onkey_work(struct work_struct *work)
> > +{
> > +	int ret;
> > +	struct da9052_onkey *onkey;
> > +	onkey = container_of(work, struct da9052_onkey, work.work);
> > +
> > +	ret = da9052_reg_read(onkey->da9052, DA9052_EVENT_B_REG);
> > +	if (ret < 0) {
> > +		dev_err(onkey->da9052->dev,
> > +			"da9052_onkey_report_event da9052_reg_read error %d\n",
> > +			ret);
> > +		ret = 1;
> > +	} else {
> > +		ret = ret & DA9052_E_nONKEY;
> > +		input_report_key(onkey->input, KEY_POWER, ret);
> > +		input_sync(onkey->input);
> > +	}
> > +
> > +	if (ret)
> > +		schedule_delayed_work(&onkey->work, 10);
> 
> The delay here is in jiffies so the duration of the delay is
> will be different for different values of HZ. I think you want
> msecs_to_jiffies(10) here.
> 
> > +
> > +}
> > +
> > +static irqreturn_t da9052_onkey_irq(int irq, void *data)
> > +{
> > +	struct da9052_onkey *onkey = (struct da9052_onkey *) data;
> 
> No need to cast void * pointers.
> 
> > +
> > +	schedule_delayed_work(&onkey->work, 0);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int __devinit da9052_onkey_probe(struct platform_device *pdev)
> > +{
> > +	struct da9052_onkey *onkey;
> > +	int error = 0;
> > +
> > +	onkey = kzalloc(sizeof(*onkey), GFP_KERNEL);
> > +	if (!onkey) {
> > +		dev_err(&pdev->dev, "Failed to allocate memory\n");
> > +		return -ENOMEM;
> > +	}
> > +	onkey->input = input_allocate_device();
> > +	if (!onkey->input) {
> > +		error = -ENOMEM;
> > +		dev_err(&pdev->dev, "Failed to allocate input device, %d\n",
> > +			error);
> > +		goto err_mem;
> > +	}
> > +	onkey->da9052 = dev_get_drvdata(pdev->dev.parent);
> > +	onkey->irq = platform_get_irq_byname(pdev, "ONKEY");
> > +	if (onkey->irq < 0) {
> > +		dev_err(&pdev->dev, "Failed to get an IRQ for input device, %d\n",
> > +			onkey->irq);
> > +		goto err_mem;
> > +	}
> > +
> > +	onkey->input->evbit[0] = BIT_MASK(EV_KEY);
> > +	onkey->input->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
> > +	onkey->input->name = "da9052-onkey";
> > +	onkey->input->phys = "da9052-onkey/input0";
> > +	onkey->input->dev.parent = &pdev->dev;
> > +
> > +	INIT_DELAYED_WORK(&onkey->work, da9052_onkey_work);
> > +
> > +	error = request_threaded_irq(onkey->da9052->irq_base + onkey->irq, NULL,
> > +					da9052_onkey_irq,
> > +					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> > +					"ONKEY", onkey);
> 
> Why is this threaded IRQ if your interrupt handler siumply schedules
> delayed work to actually query the device? Is iut because it is a nested
> interrupt?
>
We have a main line interrupt which gets triggered when DA9052 devices generates events/interrupts.
The oneshot handler for the main interrupt finds out the active interrupts and wake ups the relevant
interrupt threads that are associated with individual DA9052 events. For this reason, onkey device gets register for the threaded interrupt.

> > +	if (error < 0) {
> > +		dev_err(onkey->da9052->dev,
> > +			" Failed to register %s IRQ %d, error = %d\n",
> > +			"ONKEY", onkey->da9052->irq_base + onkey->irq, error);
> > +		goto err_input;
> > +	}
> > +
> > +	error = input_register_device(onkey->input);
> > +	if (error) {
> > +		dev_err(&pdev->dev, "Unable to register input device, %d\n",
> > +			error);
> > +		goto err_reg;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, onkey);
> > +
> > +	return 0;
> > +
> > +err_reg:
> > +	free_irq(onkey->da9052->irq_base + onkey->irq, NULL);
> > +err_input:
> > +	cancel_delayed_work_sync(&onkey->work);
> > +err_mem:
> > +	input_free_device(onkey->input);
> > +	kfree(onkey);
> > +	return error;
> > +}
> > +
> > +static int __devexit da9052_onkey_remove(struct platform_device *pdev)
> > +{
> > +	struct da9052_onkey *onkey = platform_get_drvdata(pdev);
> > +
> > +	free_irq(onkey->da9052->irq_base + onkey->irq, NULL);
> > +	cancel_delayed_work_sync(&onkey->work);
> > +	input_unregister_device(onkey->input);
> > +	kfree(onkey);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver da9052_onkey_driver = {
> > +	.driver = {
> > +		.name		= "da9052-onkey",
> > +		.owner	= THIS_MODULE,
> > +	},
> > +	.probe	= da9052_onkey_probe,
> > +	.remove	= __devexit_p(da9052_onkey_remove),
> > +};
> > +
> > +static int __init da9052_onkey_init(void)
> > +{
> > +	return platform_driver_register(&da9052_onkey_driver);
> > +}
> > +
> > +static void __exit da9052_onkey_exit(void)
> > +{
> > +	platform_driver_unregister(&da9052_onkey_driver);
> > +}
> > +
> > +module_init(da9052_onkey_init);
> > +module_exit(da9052_onkey_exit);
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
> > +MODULE_DESCRIPTION("Onkey driver for DA9052");
> > +MODULE_ALIAS("platform:da9052-onkey");
> > diff -Naur linux-next-20110421.orig/drivers/input/misc/Kconfig linux-next-
> 20110421/drivers/input/misc/Kconfig
> > --- linux-next-20110421.orig/drivers/input/misc/Kconfig	2011-04-26
> 09:32:56.000000000 +0500
> > +++ linux-next-20110421/drivers/input/misc/Kconfig	2011-04-26
> 11:10:59.000000000 +0500
> > @@ -353,6 +353,13 @@
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called rb532_button.
> >
> > +config INPUT_DA9052_ONKEY
> > +	tristate "Dialog DA9052 Onkey"
> > +	depends on PMIC_DA9052
> > +	help
> > +	  Support the ONKEY of Dialog DA9052 PMICs as an input device
> > +	  reporting power button status.
> > +
> >  config INPUT_DM355EVM
> >  	tristate "TI DaVinci DM355 EVM Keypad and IR Remote"
> >  	depends on MFD_DM355EVM_MSP
> > diff -Naur linux-next-20110421.orig/drivers/input/misc/Makefile linux-next-
> 20110421/drivers/input/misc/Makefile
> > --- linux-next-20110421.orig/drivers/input/misc/Makefile	2011-04-26
> 09:32:56.000000000 +0500
> > +++ linux-next-20110421/drivers/input/misc/Makefile	2011-04-26
> 11:06:17.000000000 +0500
> > @@ -21,6 +21,7 @@
> >  obj-$(CONFIG_INPUT_CMA3000)		+= cma3000_d0x.o
> >  obj-$(CONFIG_INPUT_CMA3000_I2C)	+= cma3000_d0x_i2c.o
> >  obj-$(CONFIG_INPUT_COBALT_BTNS)	+= cobalt_btns.o
> > +obj-$(CONFIG_INPUT_DA9052_ONKEY)	+= da9052_onkey.o
> >  obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
> >  obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
> >  obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
> >
> 
> Thanks.
> 
> --
> Dmitry



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
