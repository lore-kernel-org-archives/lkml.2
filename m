Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030466Ab2B1U3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:29:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53005 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025Ab2B1U3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:29:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of james@albanarts.com designates 10.216.139.29 as permitted sender) smtp.mail=james@albanarts.com
Date: Tue, 28 Feb 2012 20:29:45 +0000
From: James Hogan <james@albanarts.com>
To: Ravi Kumar V <kumarrav@codeaurora.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jarod Wilson <jarod@redhat.com>, Anssi Hannula <anssi.hannula@iki.fi>,
        "Juan J. Garcia de Soria" <skandalfo@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tsoni@codeaurora.org, davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/1] rc: Add support for GPIO based IR Receiver driver.
Message-ID: <20120228202944.GA9373@balrog>
References: <1330408300-21939-1-git-send-email-kumarrav@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330408300-21939-1-git-send-email-kumarrav@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 11:21:40AM +0530, Ravi Kumar V wrote:
> Adds GPIO based IR Receiver driver. It decodes signals using decoders
> available in rc framework.
> 
> Signed-off-by: Ravi Kumar V <kumarrav@codeaurora.org>

Looks good to me (but I'm no expert).

Cheers
James

> ---
>  drivers/media/rc/Kconfig        |    9 ++
>  drivers/media/rc/Makefile       |    1 +
>  drivers/media/rc/gpio-ir-recv.c |  205 +++++++++++++++++++++++++++++++++++++++
>  include/media/gpio-ir-recv.h    |   22 ++++
>  4 files changed, 237 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/rc/gpio-ir-recv.c
>  create mode 100644 include/media/gpio-ir-recv.h
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index aeb7f43..6f63ded 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -256,4 +256,13 @@ config RC_LOOPBACK
>  	   To compile this driver as a module, choose M here: the module will
>  	   be called rc_loopback.
>  
> +config IR_GPIO_CIR
> +	tristate "GPIO IR remote control"
> +	depends on RC_CORE
> +	---help---
> +	   Say Y if you want to use GPIO based IR Receiver.
> +
> +	   To compile this driver as a module, choose M here: the module will
> +	   be called gpio-ir-recv.
> +
>  endif #RC_CORE
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index 2156e78..9b3568e 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -25,3 +25,4 @@ obj-$(CONFIG_IR_REDRAT3) += redrat3.o
>  obj-$(CONFIG_IR_STREAMZAP) += streamzap.o
>  obj-$(CONFIG_IR_WINBOND_CIR) += winbond-cir.o
>  obj-$(CONFIG_RC_LOOPBACK) += rc-loopback.o
> +obj-$(CONFIG_IR_GPIO_CIR) += gpio-ir-recv.o
> diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
> new file mode 100644
> index 0000000..6744479
> --- /dev/null
> +++ b/drivers/media/rc/gpio-ir-recv.c
> @@ -0,0 +1,205 @@
> +/* Copyright (c) 2012, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/gpio.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/irq.h>
> +#include <media/rc-core.h>
> +#include <media/gpio-ir-recv.h>
> +
> +#define GPIO_IR_DRIVER_NAME	"gpio-rc-recv"
> +#define GPIO_IR_DEVICE_NAME	"gpio_ir_recv"
> +
> +struct gpio_rc_dev {
> +	struct rc_dev *rcdev;
> +	unsigned int gpio_nr;
> +	bool active_low;
> +};
> +
> +static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
> +{
> +	struct gpio_rc_dev *gpio_dev = dev_id;
> +	unsigned int gval;
> +	int rc = 0;
> +	enum raw_event_type type = IR_SPACE;
> +
> +	gval = gpio_get_value_cansleep(gpio_dev->gpio_nr);
> +
> +	if (gval < 0)
> +		goto err_get_value;
> +
> +	if (gpio_dev->active_low)
> +		gval = !gval;
> +
> +	if (gval == 1)
> +		type = IR_PULSE;
> +
> +	rc = ir_raw_event_store_edge(gpio_dev->rcdev, type);
> +	if (rc < 0)
> +		goto err_get_value;
> +
> +	ir_raw_event_handle(gpio_dev->rcdev);
> +
> +err_get_value:
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
> +{
> +	struct gpio_rc_dev *gpio_dev;
> +	struct rc_dev *rcdev;
> +	const struct gpio_ir_recv_platform_data *pdata =
> +					pdev->dev.platform_data;
> +	int rc;
> +
> +	if (!pdata)
> +		return -EINVAL;
> +
> +	if (pdata->gpio_nr < 0)
> +		return -EINVAL;
> +
> +	gpio_dev = kzalloc(sizeof(struct gpio_rc_dev), GFP_KERNEL);
> +	if (!gpio_dev)
> +		return -ENOMEM;
> +
> +	rcdev = rc_allocate_device();
> +	if (!rcdev) {
> +		rc = -ENOMEM;
> +		goto err_allocate_device;
> +	}
> +
> +	rcdev->driver_type = RC_DRIVER_IR_RAW;
> +	rcdev->allowed_protos = RC_TYPE_ALL;
> +	rcdev->input_name = GPIO_IR_DEVICE_NAME;
> +	rcdev->input_id.bustype = BUS_HOST;
> +	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
> +	rcdev->map_name = RC_MAP_EMPTY;
> +
> +	gpio_dev->rcdev = rcdev;
> +	gpio_dev->gpio_nr = pdata->gpio_nr;
> +	gpio_dev->active_low = pdata->active_low;
> +
> +	rc = gpio_request(pdata->gpio_nr, "gpio-ir-recv");
> +	if (rc < 0)
> +		goto err_gpio_request;
> +	rc  = gpio_direction_input(pdata->gpio_nr);
> +	if (rc < 0)
> +		goto err_gpio_direction_input;
> +
> +	rc = rc_register_device(rcdev);
> +	if (rc < 0) {
> +		dev_err(&pdev->dev, "failed to register rc device\n");
> +		goto err_register_rc_device;
> +	}
> +
> +	platform_set_drvdata(pdev, gpio_dev);
> +
> +	rc = request_any_context_irq(gpio_to_irq(pdata->gpio_nr),
> +				gpio_ir_recv_irq,
> +			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> +					"gpio-ir-recv-irq", gpio_dev);
> +	if (rc < 0)
> +		goto err_request_irq;
> +
> +	return 0;
> +
> +err_request_irq:
> +	platform_set_drvdata(pdev, NULL);
> +	rc_unregister_device(rcdev);
> +err_register_rc_device:
> +err_gpio_direction_input:
> +	gpio_free(pdata->gpio_nr);
> +err_gpio_request:
> +	rc_free_device(rcdev);
> +	rcdev = NULL;
> +err_allocate_device:
> +	kfree(gpio_dev);
> +	return rc;
> +}
> +
> +static int __devexit gpio_ir_recv_remove(struct platform_device *pdev)
> +{
> +	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
> +
> +	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
> +	platform_set_drvdata(pdev, NULL);
> +	rc_unregister_device(gpio_dev->rcdev);
> +	gpio_free(gpio_dev->gpio_nr);
> +	rc_free_device(gpio_dev->rcdev);
> +	kfree(gpio_dev);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int gpio_ir_recv_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
> +
> +	if (device_may_wakeup(dev))
> +		enable_irq_wake(gpio_to_irq(gpio_dev->gpio_nr));
> +	else
> +		disable_irq(gpio_to_irq(gpio_dev->gpio_nr));
> +
> +	return 0;
> +}
> +
> +static int gpio_ir_recv_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
> +
> +	if (device_may_wakeup(dev))
> +		disable_irq_wake(gpio_to_irq(gpio_dev->gpio_nr));
> +	else
> +		enable_irq(gpio_to_irq(gpio_dev->gpio_nr));
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops gpio_ir_recv_pm_ops = {
> +	.suspend        = gpio_ir_recv_suspend,
> +	.resume         = gpio_ir_recv_resume,
> +};
> +#endif
> +
> +static struct platform_driver gpio_ir_recv_driver = {
> +	.probe  = gpio_ir_recv_probe,
> +	.remove = __devexit_p(gpio_ir_recv_remove),
> +	.driver = {
> +		.name   = GPIO_IR_DRIVER_NAME,
> +		.owner  = THIS_MODULE,
> +#ifdef CONFIG_PM
> +		.pm	= &gpio_ir_recv_pm_ops,
> +#endif
> +	},
> +};
> +
> +static int __init gpio_ir_recv_init(void)
> +{
> +	return platform_driver_register(&gpio_ir_recv_driver);
> +}
> +module_init(gpio_ir_recv_init);
> +
> +static void __exit gpio_ir_recv_exit(void)
> +{
> +	platform_driver_unregister(&gpio_ir_recv_driver);
> +}
> +module_exit(gpio_ir_recv_exit);
> +
> +MODULE_DESCRIPTION("GPIO IR Receiver driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/media/gpio-ir-recv.h b/include/media/gpio-ir-recv.h
> new file mode 100644
> index 0000000..61a7fbb
> --- /dev/null
> +++ b/include/media/gpio-ir-recv.h
> @@ -0,0 +1,22 @@
> +/* Copyright (c) 2012, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __GPIO_IR_RECV_H__
> +#define __GPIO_IR_RECV_H__
> +
> +struct gpio_ir_recv_platform_data {
> +	unsigned int gpio_nr;
> +	bool active_low;
> +};
> +
> +#endif /* __GPIO_IR_RECV_H__ */
> +
> -- 
> Sent by a consultant of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
