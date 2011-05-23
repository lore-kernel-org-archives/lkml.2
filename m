Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab1EWQyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:54:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33209 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab1EWQyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:54:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RlYTMB0KwOr7S9lVJ6nde78TyaAS6jFmQFEwm4qgXbDheBonUDgJZIgU2U42nEGK8h
         Ya0ZJ/o1UGCM5sG8WuwNYAXSjPbZlIC/vj4B1XEItRgwfzhk1C1ZmhwYzryXlSJDzlOW
         h3YYeeKPgYy95RqMn933KMl0tm7yhHFIHXa/w=
Date: Mon, 23 May 2011 09:54:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv3 11/11 ] ONKEY: Removed extra schedule call
Message-ID: <20110523165445.GD20397@core.coreip.homeip.net>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BDC3BBC@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BDC3BBC@KCINPUNHJCMS01.kpit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

On Fri, May 20, 2011 at 03:10:47PM +0530, Ashish Jangam wrote:
> Hi Dmitry,
> 
> Delay time to query the power release button has been increased from 10ms to 50ms.
> Removed extra schedule; now "onkey work" is called from the threaded irq itself.
> Kconfig has been updated with the statement "To compile this module..."
> 
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> 		   David Dajun Chen <dajun.chen@diasemi.com>

This should be 2 separate signed-off-by lines, the first one by David
and the 2nd one is yours. Otherwise:

Acked-by: Dmitry Torokhov <dtor@mail.ru>

I assume it will be merged with the rest of DA9052 code through Samuel's
MFD tree, right?

Thanks.

> ---
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index f9cf088..cf687a2 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -353,6 +353,16 @@ config INPUT_RB532_BUTTON
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called rb532_button.
> 
> +config INPUT_DA9052_ONKEY
> +	tristate "Dialog DA9052 Onkey"
> +	depends on PMIC_DA9052
> +	help
> +	  Support the ONKEY of Dialog DA9052 PMICs as an input device
> +	  reporting power button status.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called da9052_onkey.
> +
>  config INPUT_DM355EVM
>  	tristate "TI DaVinci DM355 EVM Keypad and IR Remote"
>  	depends on MFD_DM355EVM_MSP
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index e3f7984..d35d466 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -21,6 +21,7 @@ obj-$(CONFIG_INPUT_CM109)		+= cm109.o
>  obj-$(CONFIG_INPUT_CMA3000)		+= cma3000_d0x.o
>  obj-$(CONFIG_INPUT_CMA3000_I2C)	+= cma3000_d0x_i2c.o
>  obj-$(CONFIG_INPUT_COBALT_BTNS)	+= cobalt_btns.o
> +obj-$(CONFIG_INPUT_DA9052_ONKEY)	+= da9052_onkey.o
>  obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
>  obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
>  obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
> diff --git a/drivers/input/misc/da9052_onkey.c b/drivers/input/misc/da9052_onkey.c
> new file mode 100755
> index 0000000..83b1693
> --- /dev/null
> +++ b/drivers/input/misc/da9052_onkey.c
> @@ -0,0 +1,180 @@
> +/*
> + * ON pin driver for Dialog DA9052 PMICs
> + *
> + * Copyright(c) 2011 Dialog Semiconductor Ltd.
> + *
> + * Author: David Dajun Chen <dchen@diasemi.com>
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/input.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/workqueue.h>
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
> +static void da9052_onkey_query(struct da9052_onkey *onkey)
> +{
> +	int ret;
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
> +		schedule_delayed_work(&onkey->work, msecs_to_jiffies(50));
> +}
> +
> +static void da9052_onkey_work(struct work_struct *work)
> +{
> +	struct da9052_onkey *onkey = container_of(work, struct da9052_onkey,
> +						  work.work);
> +
> +	da9052_onkey_query(onkey);
> +}
> +
> +static irqreturn_t da9052_onkey_irq(int irq, void *data)
> +{
> +	struct da9052_onkey *onkey = data;
> +
> +	da9052_onkey_work(&onkey->work.work);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit da9052_onkey_probe(struct platform_device *pdev)
> +{
> +	struct da9052_onkey *onkey;
> +	int error;
> +
> +	onkey = kzalloc(sizeof(*onkey), GFP_KERNEL);
> +	if (!onkey) {
> +		dev_err(&pdev->dev, "Failed to allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	onkey->input = input_allocate_device();
> +	if (!onkey->input) {
> +		error = -ENOMEM;
> +		dev_err(&pdev->dev, "Failed to allocate input device, %d\n",
> +			error);
> +		goto err_mem;
> +	}
> +
> +	onkey->da9052 = dev_get_drvdata(pdev->dev.parent);
> +	if (!onkey->da9052) {
> +		error = -ENOMEM;
> +		dev_err(&pdev->dev, "Failed to get the driver's data, %d\n",
> +			error);
> +		goto err_input;
> +	}
> +
> +	onkey->irq = platform_get_irq_byname(pdev, "ONKEY");
> +	if (onkey->irq < 0) {
> +		error = -ENXIO;
> +		dev_err(&pdev->dev,
> +			"Failed to get an IRQ for input device, %d\n",
> +			onkey->irq);
> +		goto err_input;
> +	}
> +
> +	onkey->input->evbit[0] = BIT_MASK(EV_KEY);
> +	onkey->input->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
> +	onkey->input->name = "da9052-onkey";
> +	onkey->input->phys = "da9052-onkey/input0";
> +	onkey->input->dev.parent = &pdev->dev;
> +
> +	INIT_DELAYED_WORK(&onkey->work, da9052_onkey_work);
> +
> +	error = request_threaded_irq(onkey->da9052->irq_base + onkey->irq, NULL,
> +				     da9052_onkey_irq,
> +				     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +				     "ONKEY", onkey);
> +	if (error < 0) {
> +		dev_err(onkey->da9052->dev,
> +			"Failed to register ONKEY IRQ %d, error = %d\n",
> +			onkey->da9052->irq_base + onkey->irq, error);
> +		goto err_req_irq;
> +	}
> +
> +	error = input_register_device(onkey->input);
> +	if (error) {
> +		dev_err(&pdev->dev, "Unable to register input device, %d\n",
> +			error);
> +		goto err_irq;
> +	}
> +
> +	platform_set_drvdata(pdev, onkey);
> +
> +	return 0;
> +
> +err_irq:
> +	free_irq(onkey->da9052->irq_base + onkey->irq, onkey);
> +err_req_irq:
> +	cancel_delayed_work_sync(&onkey->work);
> +err_input:
> +	input_free_device(onkey->input);
> +err_mem:
> +	kfree(onkey);
> +	return error;
> +}
> +
> +static int __devexit da9052_onkey_remove(struct platform_device *pdev)
> +{
> +	struct da9052_onkey *onkey = platform_get_drvdata(pdev);
> +
> +	free_irq(onkey->da9052->irq_base + onkey->irq, onkey);
> +	cancel_delayed_work_sync(&onkey->work);
> +	input_unregister_device(onkey->input);
> +	kfree(onkey);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver da9052_onkey_driver = {
> +	.driver = {
> +		.name		= "da9052-onkey",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe	= da9052_onkey_probe,
> +	.remove	= __devexit_p(da9052_onkey_remove),
> +};
> +
> +static int __init da9052_onkey_init(void)
> +{
> +	return platform_driver_register(&da9052_onkey_driver);
> +}
> +module_init(da9052_onkey_init);
> +
> +static void __exit da9052_onkey_exit(void)
> +{
> +	platform_driver_unregister(&da9052_onkey_driver);
> +}
> +module_exit(da9052_onkey_exit);
> +
> +MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
> +MODULE_DESCRIPTION("Onkey driver for DA9052");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:da9052-onkey");
> 
> 
> Regards,
> Ashish
> 
> 

-- 
Dmitry
