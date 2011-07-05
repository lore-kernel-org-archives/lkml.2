Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1GEILJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 04:11:09 -0400
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:35872 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1GEILH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 04:11:07 -0400
X-Greylist: delayed 2226 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jul 2011 04:11:06 EDT
Date: Tue, 5 Jul 2011 09:33:54 +0200
From: Rodolfo Giometti <giometti@enneenne.it>
To: James Nuss <jamesnuss@nanometrics.ca>
Cc: linuxpps@ml.enneenne.com, linux-kernel@vger.kernel.org
Message-ID: <20110705073354.GA8353@enneenne.com>
Mail-Followup-To: James Nuss <jamesnuss@nanometrics.ca>,
	linuxpps@ml.enneenne.com, linux-kernel@vger.kernel.org
References: <1309796969-31708-3-git-send-email-jamesnuss@nanometrics.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309796969-31708-3-git-send-email-jamesnuss@nanometrics.ca>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 192.168.32.38
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [LinuxPPS] [PATCH v2 2/2] pps: new client driver using GPIO
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 12:29:29PM -0400, James Nuss wrote:
> This client driver allows you to use a GPIO pin as a source for PPS
> signals. Platform data [1] are used to specify the GPIO pin number, label,
> assert event edge type, and whether clear events are captured.
> 
> This driver is based on the work by Ricardo Martins <rasm@fe.up.pt> who
> submitted an initial implementation [2] of a PPS IRQ client driver to
> the linuxpps mailing-list on Dec 3 2010.
> 
> [1] include/linux/pps-gpio.h
> [2] http://ml.enneenne.com/pipermail/linuxpps/2010-December/004155.html
> 
> Signed-off-by: James Nuss <jamesnuss@nanometrics.ca>
> CC: Ricardo Martins <rasm@fe.up.pt>
> ---
>  drivers/pps/clients/Kconfig    |    9 ++
>  drivers/pps/clients/Makefile   |    1 +
>  drivers/pps/clients/pps-gpio.c |  218 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/pps-gpio.h       |   32 ++++++
>  4 files changed, 260 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/pps/clients/pps-gpio.c
>  create mode 100644 include/linux/pps-gpio.h
> 
> diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
> index 8520a7f..c2e0f1e 100644
> --- a/drivers/pps/clients/Kconfig
> +++ b/drivers/pps/clients/Kconfig
> @@ -29,4 +29,13 @@ config PPS_CLIENT_PARPORT
>  	  If you say yes here you get support for a PPS source connected
>  	  with the interrupt pin of your parallel port.
>  
> +config PPS_CLIENT_GPIO
> +	tristate "PPS client using GPIO"
> +	depends on PPS
> +	help
> +	  If you say yes here you get support for a PPS source using
> +	  GPIO. To be useful you must also register a platform device
> +	  specifying the GPIO pin and other options, usually in your board
> +	  setup.
> +
>  endif
> diff --git a/drivers/pps/clients/Makefile b/drivers/pps/clients/Makefile
> index 4feb7e9..a461d15 100644
> --- a/drivers/pps/clients/Makefile
> +++ b/drivers/pps/clients/Makefile
> @@ -5,5 +5,6 @@
>  obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= pps-ktimer.o
>  obj-$(CONFIG_PPS_CLIENT_LDISC)	+= pps-ldisc.o
>  obj-$(CONFIG_PPS_CLIENT_PARPORT) += pps_parport.o
> +obj-$(CONFIG_PPS_CLIENT_GPIO)	+= pps-gpio.o
>  
>  ccflags-$(CONFIG_PPS_DEBUG) := -DDEBUG
> diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
> new file mode 100644
> index 0000000..fe9d913
> --- /dev/null
> +++ b/drivers/pps/clients/pps-gpio.c
> @@ -0,0 +1,218 @@
> +/*
> + * pps-gpio.c -- PPS client driver using GPIO
> + *
> + *
> + * Copyright (C) 2010 Ricardo Martins <rasm@fe.up.pt>
> + * Copyright (C) 2011 James Nuss <jamesnuss@nanometrics.ca>
> + *
> + *   This program is free software; you can redistribute it and/or modify
> + *   it under the terms of the GNU General Public License as published by
> + *   the Free Software Foundation; either version 2 of the License, or
> + *   (at your option) any later version.
> + *
> + *   This program is distributed in the hope that it will be useful,
> + *   but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *   GNU General Public License for more details.
> + *
> + *   You should have received a copy of the GNU General Public License
> + *   along with this program; if not, write to the Free Software
> + *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/pps_kernel.h>
> +#include <linux/pps-gpio.h>
> +#include <linux/gpio.h>
> +#include <linux/list.h>
> +
> +#define PPS_GPIO_NAME		"pps-gpio"
> +#define PPS_GPIO_VERSION	"1.0.0"
> +
> +/* Info for each registered platform device */
> +struct pps_gpio_device_data {
> +	int irq;			/* IRQ used as PPS source */
> +	struct pps_device *pps;		/* PPS source device */
> +	struct pps_source_info info;	/* PPS source information */
> +	const struct pps_gpio_platform_data *pdata;
> +};
> +
> +/*
> + * Report the PPS event
> + */
> +
> +static irqreturn_t pps_gpio_irq_handler(int irq, void *data)
> +{
> +	const struct pps_gpio_device_data *info;
> +	struct pps_event_time ts;
> +	int rising_edge;
> +
> +	/* Get the time stamp first */
> +	pps_get_ts(&ts);
> +
> +	info = (const struct pps_gpio_device_data *)data;
> +
> +	rising_edge = gpio_get_value(info->pdata->gpio_pin);
> +	if ((rising_edge && !info->pdata->assert_falling_edge) ||
> +			(!rising_edge && info->pdata->assert_falling_edge))
> +		pps_event(info->pps, &ts, PPS_CAPTUREASSERT, NULL);
> +	else if (info->pdata->capture_clear &&
> +			((rising_edge && info->pdata->assert_falling_edge) ||
> +			 (!rising_edge && !info->pdata->assert_falling_edge)))
> +		pps_event(info->pps, &ts, PPS_CAPTURECLEAR, NULL);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int pps_gpio_setup(struct platform_device *pdev)
> +{
> +	int ret;
> +	const struct pps_gpio_platform_data *pdata = pdev->dev.platform_data;
> +
> +	ret = gpio_request(pdata->gpio_pin, pdata->gpio_label);
> +	if (ret) {
> +		pr_warning("failed to request GPIO %u\n", pdata->gpio_pin);
> +		return -1;
> +	}
> +
> +	ret = gpio_direction_input(pdata->gpio_pin);
> +	if (ret) {
> +		pr_warning("failed to set pin direction\n");
> +		return -1;

I think you should release the requested GPIO above before
returning...

> +	}
> +
> +	return 0;
> +}
> +
> +static unsigned long
> +get_irqf_trigger_flags(const struct pps_gpio_platform_data *pdata)
> +{
> +	unsigned long flags = pdata->assert_falling_edge ?
> +		IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING;
> +
> +	if (pdata->capture_clear) {
> +		flags |= ((flags & IRQF_TRIGGER_RISING) ?
> +				IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING);
> +	}
> +
> +	return flags;
> +}
> +
> +static int pps_gpio_probe(struct platform_device *pdev)
> +{
> +	struct pps_gpio_device_data *data;
> +	int irq;
> +	int ret;
> +	int pps_default_params;
> +	const struct pps_gpio_platform_data *pdata = pdev->dev.platform_data;
> +
> +
> +	/* GPIO setup */
> +	ret = pps_gpio_setup(pdev);
> +	if (ret)
> +		return -EINVAL;
> +
> +	/* IRQ setup */
> +	irq = gpio_to_irq(pdata->gpio_pin);
> +	if (irq < 0) {
> +		pr_err("failed to map GPIO to IRQ: %d\n", irq);
> +		return -EINVAL;
> +	}
> +
> +	/* allocate space for device info */
> +	data = kzalloc(sizeof(struct pps_gpio_device_data), GFP_KERNEL);
> +	if (data == NULL)
> +		return -ENOMEM;
> +
> +	/* initialize PPS specific parts of the bookkeeping data structure. */
> +	data->info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT |
> +		PPS_ECHOASSERT | PPS_CANWAIT | PPS_TSFMT_TSPEC;
> +	if (pdata->capture_clear)
> +		data->info.mode |= PPS_CAPTURECLEAR | PPS_OFFSETCLEAR |
> +			PPS_ECHOCLEAR;
> +	data->info.owner = THIS_MODULE;
> +	snprintf(data->info.name, PPS_MAX_NAME_LEN - 1, "%s.%d",
> +		 pdev->name, pdev->id);
> +
> +	/* register PPS source */
> +	pps_default_params = PPS_CAPTUREASSERT | PPS_OFFSETASSERT;
> +	if (pdata->capture_clear)
> +		pps_default_params |= PPS_CAPTURECLEAR | PPS_OFFSETCLEAR;
> +	data->pps = pps_register_source(&data->info, pps_default_params);
> +	if (data->pps == NULL) {
> +		kfree(data);
> +		pr_err("failed to register IRQ %d as PPS source\n", irq);
> +		return -EINVAL;
> +	}
> +
> +	data->irq = irq;
> +	data->pdata = pdata;
> +
> +	/* register IRQ interrupt handler */
> +	ret = request_irq(irq, pps_gpio_irq_handler,
> +			get_irqf_trigger_flags(pdata), data->info.name, data);
> +	if (ret) {
> +		pps_unregister_source(data->pps);
> +		kfree(data);
> +		pr_err("failed to acquire IRQ %d\n", irq);
> +		return -EINVAL;
> +	}
> +
> +	platform_set_drvdata(pdev, data);
> +	dev_info(data->pps->dev, "Registered IRQ %d as PPS source\n", irq);
> +
> +	return 0;
> +}
> +
> +static int pps_gpio_remove(struct platform_device *pdev)
> +{
> +	struct pps_gpio_device_data *data = platform_get_drvdata(pdev);
> +	const struct pps_gpio_platform_data *pdata = data->pdata;
> +
> +	platform_set_drvdata(pdev, NULL);
> +	free_irq(data->irq, data);
> +	gpio_free(pdata->gpio_pin);
> +	pps_unregister_source(data->pps);
> +	pr_info("removed IRQ %d as PPS source\n", data->irq);
> +	kfree(data);
> +	return 0;
> +}
> +
> +static struct platform_driver pps_gpio_driver = {
> +	.probe		= pps_gpio_probe,
> +	.remove		=  __devexit_p(pps_gpio_remove),
> +	.driver		= {
> +		.name	= PPS_GPIO_NAME,
> +		.owner	= THIS_MODULE
> +	},
> +};
> +
> +static int __init pps_gpio_init(void)
> +{
> +	int ret = platform_driver_register(&pps_gpio_driver);
> +	if (ret < 0)
> +		pr_err("failed to register platform driver\n");
> +	return ret;
> +}
> +
> +static void __exit pps_gpio_exit(void)
> +{
> +	platform_driver_unregister(&pps_gpio_driver);
> +	pr_debug("unregistered platform driver\n");
> +}
> +
> +module_init(pps_gpio_init);
> +module_exit(pps_gpio_exit);
> +
> +MODULE_AUTHOR("Ricardo Martins <rasm@fe.up.pt>");
> +MODULE_AUTHOR("James Nuss <jamesnuss@nanometrics.ca>");
> +MODULE_DESCRIPTION("Use GPIO pin as PPS source");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(PPS_GPIO_VERSION);
> diff --git a/include/linux/pps-gpio.h b/include/linux/pps-gpio.h
> new file mode 100644
> index 0000000..0035abe
> --- /dev/null
> +++ b/include/linux/pps-gpio.h
> @@ -0,0 +1,32 @@
> +/*
> + * pps-gpio.h -- PPS client for GPIOs
> + *
> + *
> + * Copyright (C) 2011 James Nuss <jamesnuss@nanometrics.ca>
> + *
> + *   This program is free software; you can redistribute it and/or modify
> + *   it under the terms of the GNU General Public License as published by
> + *   the Free Software Foundation; either version 2 of the License, or
> + *   (at your option) any later version.
> + *
> + *   This program is distributed in the hope that it will be useful,
> + *   but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *   GNU General Public License for more details.
> + *
> + *   You should have received a copy of the GNU General Public License
> + *   along with this program; if not, write to the Free Software
> + *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef _PPS_GPIO_H
> +#define _PPS_GPIO_H
> +
> +struct pps_gpio_platform_data {
> +	bool assert_falling_edge;
> +	bool capture_clear;
> +	unsigned int gpio_pin;
> +	const char *gpio_label;
> +};
> +
> +#endif
> -- 
> 1.7.1

It's ok for me. Fix the above error and resubmit.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
