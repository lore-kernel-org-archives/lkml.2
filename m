Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1DFS0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:26:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33344 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab1DFS0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BSFf42UFljQrN/IZNx5V9Qz409Yyh/QkWfPugQPYEvHxjjoIB3hHvJSCXkZBUuR7Sw
         Egwf/+81uQT5Qcx5u/hbm+jzWJl9USg/uHBrv5pivjZLaYh1cmTEuSwfYPYYB3NG5ptP
         Z0y8LvHZO85pEFY4nRLHCfdBrQIdcV82Fi+IE=
Date: Wed, 6 Apr 2011 11:26:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen2@diasemi.com>
Subject: Re: [PATCHv1 11/11] INPUT/MISC/ONKEY: OnKey module of DA9052 PMICs
 driver
Message-ID: <20110406182614.GA17348@core.coreip.homeip.net>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B451E04@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B451E04@KCINPUNHJCMS01.kpit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

On Wed, Apr 06, 2011 at 05:24:23PM +0530, Ashish Jangam wrote:
> Hi Dmitry,
> 
> ONKEY Driver for Dialog Semiconductor DA9052 PMICs.
> 
> Changes made since last submission:
> . read and write operation moved to MFD
> . added workqueue to notify onkey events
> 
> Some additional information of this patch:
> . This patch is thoroughly tested with the Samsung 6410 board using I2C connectivity. 
> . Workqueue is added to toggle the KEY_POWER event.
> 
> Linux Kernel Version: 2.6.37
> 
> Signed-off-by: D. Chen <dchen@diasemi.com>
> ---
> diff -Naur orig_linux-2.6.37/drivers/input/misc/da9052_onkey.c linux-2.6.37/drivers/input/misc/da9052_onkey.c
> --- orig_linux-2.6.37/drivers/input/misc/da9052_onkey.c	1970-01-01 05:00:00.000000000 +0500
> +++ linux-2.6.37/drivers/input/misc/da9052_onkey.c	2011-03-31 19:28:59.000000000 +0500
> @@ -0,0 +1,150 @@
> +/*
> + * da9052_onkey.c  --  ON pin driver for Dialog DA9052 PMICs

Please no filenames in comments.

> + *
> + * Copyright(c) 2009 Dialog Semiconductor Ltd.
> + *
> + * Author: Dajun Chen <dchen@diasemi.com>
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/input.h>
> +#include <linux/workqueue.h>
> +#include <linux/platform_device.h>
> +
> +#include <linux/mfd/da9052/da9052.h>
> +#include <linux/mfd/da9052/reg.h>
> +
> +struct da9052_onkey {
> +	struct da9052 *da9052;
> +	struct input_dev *input;
> +	struct delayed_work work;
> +	int irq;
> +};
> +
> +static void da9052_onkey_work(struct work_struct *work)
> +{
> +	unsigned int ret;

No, not unsigned. Have you ried running it through sparse?

> +	struct da9052_onkey *onkey;
> +	onkey = container_of(work, struct da9052_onkey, work.work);
> +
> +	ret = da9052_reg_read(onkey->da9052, DA9052_EVENT_B_REG);
> +	if (ret < 0) {
> +		dev_err(onkey->da9052->dev,
> +			"da9052_onkey_report_event da9052_reg_read error %d\n",
> +			ret);
> +		ret = 1;
> +	} else {
> +		ret = ret & DA9052_E_nONKEY;
> +		input_report_key(onkey->input, KEY_POWER, ret);
> +		input_sync(onkey->input);
> +	}
> +
> +	if (ret)
> +		schedule_delayed_work(&onkey->work, 10);
> +
> +}
> +
> +
> +static irqreturn_t  da9052_onkey_irq(int irq, void *data)
> +{
> +	struct da9052_onkey *onkey = (struct da9052_onkey *) data;
> +
> +	schedule_delayed_work(&onkey->work, 0);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit da9052_onkey_probe(struct platform_device *pdev)
> +{
> +	struct da9052_onkey *onkey;
> +	unsigned int ret;

It can't be unsigned - error codes are negative. And call it 'error'
please.

> +
> +	onkey = kzalloc(sizeof(*onkey), GFP_KERNEL);
> +	if (!onkey) {
> +		dev_err(&pdev->dev, "Failed to allocate memory \n");
> +		return -ENOMEM;
> +	}
> +	onkey->input = input_allocate_device();
> +	if (!onkey->input) {
> +		ret = -ENOMEM;
> +		dev_err(&pdev->dev, "Failed to allocate input device, %d\n", ret);
> +		goto err_mem;
> +	}
> +	onkey->da9052 = dev_get_drvdata(pdev->dev.parent);
> +	onkey->irq = platform_get_irq_byname(pdev, "ONKEY");

Can it fail?

> +
> +	onkey->input->evbit[0] = BIT_MASK(EV_KEY);
> +	onkey->input->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
> +	onkey->input->name = "da9052-onkey";
> +	onkey->input->phys = "da9052-onkey/input0";
> +	onkey->input->dev.parent = &pdev->dev;
> +
> +	ret = input_register_device(onkey->input);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to register input\

Do not split the message, especially by escaping newline.

> +				device, %d\n", ret);
> +		goto err_input;
> +	}
> +
> +	INIT_DELAYED_WORK(&onkey->work, da9052_onkey_work);
> +
> +	ret = da9052_request_irq(onkey->da9052, onkey->irq,
> +					da9052_onkey_irq, "ONKEY", onkey);
> +	if (ret < 0)
> +		goto err_input;
> +
> +	platform_set_drvdata(pdev, onkey);
> +
> +	return 0;
> +
> +err_input:
> +	input_unregister_device(onkey->input);

If input device was not registered you should be calling
input_free_device(). May I recommend registering input device last?

> +	cancel_delayed_work_sync(&onkey->work);
> +err_mem:
> +	kfree(onkey);
> +	return ret;
> +}
> +
> +static int __devexit da9052_onkey_remove(struct platform_device *pdev)
> +{
> +	struct da9052_onkey *onkey = pdev->dev.platform_data;

This should be platform_get_drvdata() which is different from
pdev->dev.platform_data which is conctant data maintained by vboard
code.

> +
> +	cancel_delayed_work_sync(&onkey->work);
> +	input_unregister_device(onkey->input);

If interrupt comes here you will crash. You need to free IRQ, then
cancel work and only then unregister the device.

> +	da9052_free_irq(onkey->da9052, onkey->irq, NULL);
> +	kfree(onkey);

platform_set_drvdata(pdev, NULL);

> +
> +	return 0;
> +}
> +
> +static struct platform_driver da9052_onkey_driver = {
> +	.driver.name	= "da9052-onkey",
> +	.driver.owner	= THIS_MODULE,
> +	.probe		= da9052_onkey_probe,
> +	.remove		= __devexit_p(da9052_onkey_remove),
> +};
> +
> +static int __init da9052_onkey_init(void)
> +{
> +	return platform_driver_register(&da9052_onkey_driver);
> +}
> +
> +static void __exit da9052_onkey_exit(void)
> +{
> +	platform_driver_unregister(&da9052_onkey_driver);
> +}
> +
> +module_init(da9052_onkey_init);
> +module_exit(da9052_onkey_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
> +MODULE_DESCRIPTION("Onkey driver for DA9052");
> +MODULE_ALIAS("platform:da9052-onkey");
> diff -Naur orig_linux-2.6.37/drivers/input/misc/Kconfig linux-2.6.37/drivers/input/misc/Kconfig
> --- orig_linux-2.6.37/drivers/input/misc/Kconfig	2011-01-05 05:50:19.000000000 +0500
> +++ linux-2.6.37/drivers/input/misc/Kconfig	2011-03-31 19:29:14.000000000 +0500
> @@ -32,6 +32,16 @@
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called ab8500-ponkey.
> 
> +config INPUT_DA9052_ONKEY
> +	tristate "Dialog DA9052 Onkey"
> +	depends on PMIC_DA9052
> +	help
> +	  Support the ONKEY of Dialog DA9052 PMICs as an input device
> +	  reporting power button status.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called da9052_onkey.
> +
>  config INPUT_AD714X
>  	tristate "Analog Devices AD714x Capacitance Touch Sensor"
>  	help
> diff -Naur orig_linux-2.6.37/drivers/input/misc/Makefile linux-2.6.37/drivers/input/misc/Makefile
> --- orig_linux-2.6.37/drivers/input/misc/Makefile	2011-01-05 05:50:19.000000000 +0500
> +++ linux-2.6.37/drivers/input/misc/Makefile	2011-03-31 19:29:21.000000000 +0500
> @@ -5,6 +5,7 @@
>  # Each configuration option enables a list of files.
> 
>  obj-$(CONFIG_INPUT_88PM860X_ONKEY)	+= 88pm860x_onkey.o
> +obj-$(CONFIG_INPUT_DA9052_ONKEY)	+= da9052_onkey.o

Please keep the Makefile and Kconfig sorthed alphabetically.

>  obj-$(CONFIG_INPUT_AB8500_PONKEY)	+= ab8500-ponkey.o
>  obj-$(CONFIG_INPUT_AD714X)		+= ad714x.o
>  obj-$(CONFIG_INPUT_AD714X_I2C)	+= ad714x-i2c.o
> 

Thanks.

-- 
Dmitry
