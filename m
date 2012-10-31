Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112Ab2JaTNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 15:13:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60977 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab2JaTN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 15:13:27 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 4/4] input: misc: introduce retu-pwrbutton
Date: Wed, 31 Oct 2012 12:13:23 -0700
Message-ID: <5231769.AbPKHSmERx@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.9.2 (Linux/3.7.0-rc3+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1351706626-32186-5-git-send-email-aaro.koskinen@iki.fi>
References: <1351706626-32186-1-git-send-email-aaro.koskinen@iki.fi> <1351706626-32186-5-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaro,

On Wednesday, October 31, 2012 08:03:46 PM Aaro Koskinen wrote:
> Add Retu power button driver.
> 
> Cc: linux-input@vger.kernel.org
> Acked-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> ---
>  drivers/input/misc/Kconfig          |   10 +++
>  drivers/input/misc/Makefile         |    1 +
>  drivers/input/misc/retu-pwrbutton.c |  118
> +++++++++++++++++++++++++++++++++++ 3 files changed, 129 insertions(+), 0
> deletions(-)
>  create mode 100644 drivers/input/misc/retu-pwrbutton.c
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 7c0f1ec..e5be189 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -367,6 +367,16 @@ config INPUT_CM109
>  	  To compile this driver as a module, choose M here: the module will be
>  	  called cm109.
> 
> +config INPUT_RETU_PWRBUTTON
> +	tristate "Retu Power button Driver"
> +	depends on MFD_RETU
> +	help
> +	  Say Y here if you want to enable power key reporting via the
> +	  Retu chips found in Nokia Internet Tablets (770, N800, N810).
> +
> +	  To compile this driver as a module, choose M here. The module will
> +	  be called retu-pwrbutton.
> +
>  config INPUT_TWL4030_PWRBUTTON
>  	tristate "TWL4030 Power button Driver"
>  	depends on TWL4030_CORE
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 83fe6f5..4fbee0d 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -45,6 +45,7 @@ obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)	+= pmic8xxx-pwrkey.o
>  obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
>  obj-$(CONFIG_INPUT_PWM_BEEPER)		+= pwm-beeper.o
>  obj-$(CONFIG_INPUT_RB532_BUTTON)	+= rb532_button.o
> +obj-$(CONFIG_INPUT_RETU_PWRBUTTON)	+= retu-pwrbutton.o
>  obj-$(CONFIG_INPUT_GPIO_ROTARY_ENCODER)	+= rotary_encoder.o
>  obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
>  obj-$(CONFIG_INPUT_SPARCSPKR)		+= sparcspkr.o
> diff --git a/drivers/input/misc/retu-pwrbutton.c
> b/drivers/input/misc/retu-pwrbutton.c new file mode 100644
> index 0000000..51e94a7
> --- /dev/null
> +++ b/drivers/input/misc/retu-pwrbutton.c
> @@ -0,0 +1,118 @@
> +/*
> + * Retu power button driver.
> + *
> + * Copyright (C) 2004-2010 Nokia Corporation
> + *
> + * Original code written by Ari Saastamoinen, Juha Yrjölä and Felipe Balbi.
> + * Rewritten by Aaro Koskinen.
> + *
> + * This file is subject to the terms and conditions of the GNU General
> + * Public License. See the file "COPYING" in the main directory of this
> + * archive for more details.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/irq.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/errno.h>
> +#include <linux/input.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mfd/retu.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +
> +#define RETU_STATUS_PWRONX (1 << 5)
> +
> +struct retu_pwrbutton {
> +	struct input_dev	*idev;
> +	struct retu_dev		*rdev;
> +	struct device		*dev;

I do not thhink you are using it anywhere.

> +	bool			pressed;
> +	int			irq;

You do not need to store IRQ is you are using devm_* to mamage it.

> +};

Come to think of it you do not need separate retu_pwrbutton structure,
you can just allocate input device and do input_set_drvdata(input, rdev).

> +
> +static irqreturn_t retu_pwrbutton_irq(int irq, void *_pwr)
> +{
> +	struct retu_pwrbutton *pwr = _pwr;
> +	bool state;
> +
> +	state = !(retu_read(pwr->rdev, RETU_REG_STATUS) & RETU_STATUS_PWRONX);
> +
> +	if (pwr->pressed != state) {
> +		input_report_key(pwr->idev, KEY_POWER, state);
> +		input_sync(pwr->idev);
> +		pwr->pressed = state;
> +	}

No need to suppress duplicate events, input core will do it for you.

> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit retu_pwrbutton_probe(struct platform_device *pdev)
> +{
> +	struct retu_dev *rdev = dev_get_drvdata(pdev->dev.parent);
> +	struct retu_pwrbutton *pwr;
> +	int ret;
> +
> +	pwr = devm_kzalloc(&pdev->dev, sizeof(*pwr), GFP_KERNEL);
> +	if (!pwr)
> +		return -ENOMEM;
> +
> +	pwr->rdev = rdev;
> +	pwr->dev  = &pdev->dev;
> +	pwr->irq  = platform_get_irq(pdev, 0);
> +	platform_set_drvdata(pdev, pwr);
> +
> +	ret = devm_request_threaded_irq(&pdev->dev, pwr->irq, NULL,
> +					retu_pwrbutton_irq, 0, "retu-pwrbutton",
> +					pwr);
> +	if (ret < 0)
> +		return ret;

You just crashed here if button was pressed.

> +
> +	pwr->idev = input_allocate_device();
> +	if (!pwr->idev)
> +		return -ENOMEM;
> +
> +	pwr->idev->evbit[0]			= BIT_MASK(EV_KEY);
> +	pwr->idev->keybit[BIT_WORD(KEY_POWER)]	= BIT_MASK(KEY_POWER);
> +	pwr->idev->name				= "retu-pwrbutton";
> +
> +	ret = input_register_device(pwr->idev);
> +	if (ret < 0) {
> +		input_free_device(pwr->idev);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __devexit retu_pwrbutton_remove(struct platform_device *pdev)
> +{
> +	struct retu_pwrbutton *pwr = platform_get_drvdata(pdev);
> +
> +	input_unregister_device(pwr->idev);

And here (if button was pressed).

> +	input_free_device(pwr->idev);

And here as it is double-free.

The good news is that input core is getting devm_ support so you can allocate
input device with devm_input_allocate_device() and then not bother with either
input_unregister_device or input_free_device.

> +
> +	return 0;
> +}
> +
> +static struct platform_driver retu_pwrbutton_driver = {
> +	.probe		= retu_pwrbutton_probe,
> +	.remove		= __devexit_p(retu_pwrbutton_remove),
> +	.driver		= {
> +		.name	= "retu-pwrbutton",
		.owner	= THIS_MODULE,

> +	},
> +};
> +module_platform_driver(retu_pwrbutton_driver);
> +
> +MODULE_ALIAS("platform:retu-pwrbutton");
> +MODULE_DESCRIPTION("Retu Power Button");
> +MODULE_AUTHOR("Ari Saastamoinen");
> +MODULE_AUTHOR("Felipe Balbi");
> +MODULE_AUTHOR("Aaro Koskinen <aaro.koskinen@iki.fi>");
> +MODULE_LICENSE("GPL");

Thanks.

-- 
Dmitry
