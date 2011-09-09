Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab1IISvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:51:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36588 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759579Ab1IISvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:51:06 -0400
Date: Fri, 9 Sep 2011 11:50:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: m.grzeschik@pengutronix.de, randy.dunlap@oracle.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch v2 08/11] Touch: DA9052 touchscreen driver
Message-ID: <20110909185058.GI32383@core.coreip.homeip.net>
References: <1313157026.5312.1.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313157026.5312.1.camel@L-0532.kpit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

On Fri, Aug 12, 2011 at 07:20:26PM +0530, ashishj3 wrote:
> This driver add support for DA9052 4-wire resistive ADC interfaced touchscreen
> controller.
> 
> DA9052 is a MFD therefore this driver depends on DA9052 core driver for core
> functionalities.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
> Changes since v2:
> - Replace kthreads with workqueue
> - Remove kfifos
> - Remove extra struct memebers
> - Taken care for bus type
> - Replace da9052_set/clear function with da9052_reg_update ( as DA9052 MFD got modified)
> - Add open and close functionality
> ---
>  drivers/input/touchscreen/Kconfig      |    7 +
>  drivers/input/touchscreen/Makefile     |    1 +
>  drivers/input/touchscreen/da9052_tsi.c |  400 ++++++++++++++++++++++++++++++++
>  3 files changed, 408 insertions(+), 0 deletions(-)
>  create mode 100755 drivers/input/touchscreen/da9052_tsi.c
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index cabd9e5..a5d2e7b 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -144,6 +144,13 @@ config TOUCHSCREEN_DA9034
>  	  Say Y here to enable the support for the touchscreen found
>  	  on Dialog Semiconductor DA9034 PMIC.
>  
> +config TOUCHSCREEN_DA9052
> +	tristate "Dialog DA9052 TSI"
> +	depends on PMIC_DA9052
> +	help
> +	  Say y here to support the touchscreen found on
> +	  Dialog Semiconductor DA9052 PMIC
> +
>  config TOUCHSCREEN_DYNAPRO
>  	tristate "Dynapro serial touchscreen"
>  	select SERIO
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index 282d6f7..a4aeb25 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -18,6 +18,7 @@ obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
>  obj-$(CONFIG_TOUCHSCREEN_BU21013)       += bu21013_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_CY8CTMG110)	+= cy8ctmg110_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_DA9034)	+= da9034-ts.o
> +obj-$(CONFIG_TOUCHSCREEN_DA9052)	+= da9052_tsi.o
>  obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)	+= dynapro.o
>  obj-$(CONFIG_TOUCHSCREEN_HAMPSHIRE)	+= hampshire.o
>  obj-$(CONFIG_TOUCHSCREEN_GUNZE)		+= gunze.o
> diff --git a/drivers/input/touchscreen/da9052_tsi.c b/drivers/input/touchscreen/da9052_tsi.c
> new file mode 100755
> index 0000000..1b31dd1
> --- /dev/null
> +++ b/drivers/input/touchscreen/da9052_tsi.c
> @@ -0,0 +1,400 @@
> +/*
> + * TSI driver for Dialog DA9052
> + *
> + * Copyright(c) 2011 Dialog Semiconductor Ltd.
> + *
> + * Author: David Dajun Chen <dchen@diasemi.com>
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + */
> +#include <linux/module.h>
> +#include <linux/input.h>
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>
> +
> +#include <linux/mfd/da9052/reg.h>
> +#include <linux/mfd/da9052/da9052.h>
> +
> +struct da9052_tsi_reg {
> +	u16	x;
> +	u16	y;
> +	u16	z;
> +};
> +
> +struct da9052_tsi {
> +	struct da9052	*da9052;
> +	struct input_dev *dev;
> +	struct workqueue_struct *ts_workq;
> +	struct work_struct ts_report_penup;
> +	int irq_pendwn;
> +	int irq_datardy;
> +	int pendown;

Bool maybe?

> +	int workschd;
> +	uint8_t lsb;
> +};
> +
> +static int da9052_ts_start(struct da9052_tsi *tsi)
> +{
> +	return da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG,
> +				 1 << 0, 1 << 0);
> +}
> +
> +static int da9052_ts_stop(struct da9052_tsi *tsi)
> +{
> +	return da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG, 1 << 0, 0);
> +}
> +
> +static irqreturn_t da9052_ts_pendwn_irq(int irq, void *data)
> +{
> +	struct da9052_tsi *tsi = (struct da9052_tsi *)data;

No need to cast.

> +	struct da9052 *da9052 = tsi->da9052;
> +	int ret;
> +
> +	/* Mask PEN_DOWN event and unmask TSI_READY event */
> +	da9052->events_mask |= DA9052_E_PEN_DOWN;
> +	da9052->events_mask &= ~DA9052_E_TSI_READY;
> +	ret = da9052_reg_update(da9052, DA9052_IRQ_MASK_B_REG, 0x80, 0x40);
> +	if (ret < 0)
> +		return IRQ_NONE;
> +
> +	da9052_ts_start(tsi);
> +	tsi->pendown = 1;
> +
> +	input_report_key(tsi->dev, BTN_TOUCH, 1);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int da9052_ts_read(struct da9052_tsi *tsi)
> +{
> +	struct da9052_tsi_reg co_ord = {0, 0, 0};
> +	int ret;
> +	uint8_t _x, _y, _z, _v;
> +
> +	ret = da9052_reg_read(tsi->da9052, DA9052_TSI_X_MSB_REG);
> +	if (ret < 0)
> +		return ret;
> +
> +	_x = (uint8_t) ret;
> +
> +	ret = da9052_reg_read(tsi->da9052, DA9052_TSI_Y_MSB_REG);
> +	if (ret < 0)
> +		return ret;
> +
> +	_y = (uint8_t) ret;
> +
> +	ret = da9052_reg_read(tsi->da9052, DA9052_TSI_Z_MSB_REG);
> +	if (ret < 0)
> +		return ret;
> +
> +	_z = (uint8_t) ret;
> +
> +	ret = da9052_reg_read(tsi->da9052, DA9052_TSI_LSB_REG);
> +	if (ret < 0)
> +		return ret;
> +
> +	_v = tsi->lsb = (uint8_t) ret;
> +
> +	co_ord.x = ((_x << 2) & 0x3fc) | (_v & 0x3);
> +	co_ord.y = ((_y << 2) & 0x3fc) | ((_v & 0xc) >> 2);
> +	co_ord.z = ((_z << 2) & 0x3fc) | ((_v & 0x30) >> 4);
> +
> +	input_report_abs(tsi->dev, ABS_X, co_ord.x);
> +	input_report_abs(tsi->dev, ABS_Y, co_ord.y);
> +	input_report_abs(tsi->dev, ABS_PRESSURE, co_ord.z);
> +	input_report_key(tsi->dev, BTN_TOUCH, 1);
> +	input_sync(tsi->dev);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t da9052_ts_datardy_irq(int irq, void *data)
> +{
> +	struct da9052_tsi *tsi = (struct da9052_tsi *)data;

No need to cast.

> +
> +	/* Avoid multiple schedule of queue */
> +	if (tsi->pendown && !tsi->workschd)
> +		queue_work(tsi->ts_workq, &tsi->ts_report_penup);

Workqueue infrastructure will not reschedule work if it is already
scheduled, you do not need to check your own flags here.

> +	return IRQ_HANDLED;
> +}
> +
> +static void da9052_ts_report_penup(struct work_struct *work)
> +{
> +	struct da9052_tsi *tsi = container_of(work, struct da9052_tsi,
> +					      ts_report_penup);
> +	struct input_dev *ip_dev = tsi->dev;
> +	struct da9052 *da9052 = tsi->da9052;
> +
> +	/* Work queue is scheduled */
> +	tsi->workschd = 1;
> +
> +	do {
> +		da9052_ts_read(tsi);
> +
> +		/* FixMe: At times TSI RDY IRQ does not get cleared causing
> +		 * toss to the PEN Detect Circuitry. Its safe to clear event
> +		 * here.
> +		*/
> +		da9052_reg_update(tsi->da9052, DA9052_EVENT_B_REG, 0x80, 0x80);
> +
> +	} while (tsi->lsb & 0x40);

How long will it be spinning? Until you release the pen? You should
reschedule the work if pen is still touching the surface.

> +
> +	/* Pen up Detected */
> +	tsi->pendown = 0;
> +	/* Leaving work queue */
> +	tsi->workschd = 0 ;
> +
> +	da9052_ts_stop(tsi);
> +
> +	/* Unmask PEN_DOWN event */
> +	da9052->events_mask &= ~DA9052_E_PEN_DOWN;
> +	da9052_reg_update(da9052, DA9052_IRQ_MASK_B_REG, 0x40, 0);
> +
> +	input_report_abs(ip_dev, ABS_PRESSURE, 0);
> +	input_report_key(ip_dev, BTN_TOUCH, 0);
> +	input_sync(ip_dev);
> +}
> +
> +static int da9052_ts_configure_gpio(struct da9052 *da9052)

__devinit.

> +{
> +	int ret;
> +
> +	ret = da9052_reg_update(da9052, DA9052_GPIO_2_3_REG, 0x30, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = da9052_reg_update(da9052, DA9052_GPIO_4_5_REG, 0x33, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = da9052_reg_update(da9052, DA9052_GPIO_6_7_REG, 0x33, 0);
> +
> +	return ret;
> +}
> +
> +static int __init da9052_configure_tsi(struct da9052_tsi *tsi)

__devinit.

> +{
> +	ssize_t ret;
> +	struct da9052 *da9052 = tsi->da9052;
> +
> +	ret = da9052_ts_configure_gpio(tsi->da9052);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Measure TSI sample every 1ms */
> +	ret = da9052_reg_update(tsi->da9052, DA9052_ADC_CONT_REG,
> +				1 << 6, 1 << 6);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* TSI_DELAY: 3 slots, TSI_SKIP: 0 slots, TSI_MODE: XYZP */
> +	ret = da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG, 0xFC, 0xC0);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Mask TSI_READY event */
> +	da9052->events_mask |= DA9052_E_TSI_READY;
> +	ret = da9052_reg_update(da9052, DA9052_IRQ_MASK_B_REG, 0, 0x80);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*Supply TSIRef through LD09 */
> +	ret = da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x59);
> +
> +	return ret;
> +}
> +
> +static int da9052_ts_input_open(struct input_dev *input_dev)
> +{
> +	struct da9052_tsi *tsi = input_get_drvdata(input_dev);
> +
> +	/* Enable Pen Detect Circuit */
> +	return da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG,
> +				1 << 1, 1 << 1);
> +}
> +
> +static void da9052_ts_input_close(struct input_dev *input_dev)
> +{
> +	struct da9052_tsi *tsi = input_get_drvdata(input_dev);
> +
> +	/* Disable Pen Detect Circuit */
> +	da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG, 1 << 1, 0);

You should also wait for your dataready interrupt to complete and cancel
your work.

> +}
> +
> +static s32 __devinit da9052_ts_probe(struct platform_device *pdev)

int.

> +{
> +	struct da9052_tsi *tsi;
> +	struct input_dev *input_dev;
> +	struct da9052 *da9052;
> +	int ret;
> +
> +	tsi = kzalloc(sizeof(struct da9052_tsi), GFP_KERNEL);
> +	if (!tsi)
> +		return -ENOMEM;
> +
> +	da9052 = dev_get_drvdata(pdev->dev.parent);
> +	if (da9052 == NULL) {
> +		dev_err(tsi->da9052->dev, "Failed to get driver's data\n");
> +		ret = -EINVAL;
> +		goto err_mem;
> +	}

You might want to check this first, before allocating memory.

> +
> +	input_dev = input_allocate_device();
> +	if (!input_dev) {
> +		dev_err(tsi->da9052->dev, "Failed to allocate input device\n");
> +		ret = -ENOMEM;
> +		goto err_mem;
> +	}
> +
> +	tsi->ts_workq = create_singlethread_workqueue("kda9052");
> +	if (tsi->ts_workq == NULL) {
> +		dev_err(tsi->da9052->dev, "Failed to create workqueue\n");
> +		ret = -EINVAL;
> +		goto err_input;
> +	}

Why do you need a separate workqueue? In mainline kernel we now have
concurrency-managed workqueues so you should be able to use system
workqueue.

> +
> +	INIT_WORK(&tsi->ts_report_penup, da9052_ts_report_penup);
> +
> +	tsi->da9052 = da9052;
> +
> +	input_dev->id.version = 0x0101;
> +	input_dev->id.vendor = 0x15B6;
> +	input_dev->id.product = 0x9052;
> +	input_dev->id.bustype = tsi->da9052->bustype;
> +	input_dev->name = "Dialog DA9052 TouchScreen Driver";
> +	input_dev->dev.parent = &pdev->dev;
> +	input_dev->open = da9052_ts_input_open;
> +	input_dev->close = da9052_ts_input_close;
> +	__set_bit(EV_ABS, input_dev->evbit);
> +	__set_bit(EV_KEY, input_dev->evbit);
> +	__set_bit(BTN_TOUCH, input_dev->keybit);
> +	__set_bit(ABS_X, input_dev->absbit);
> +	__set_bit(ABS_Y, input_dev->absbit);
> +	__set_bit(ABS_PRESSURE, input_dev->absbit);
> +
> +	input_set_abs_params(input_dev, ABS_X, 0, 1023, 0, 0);
> +	input_set_abs_params(input_dev, ABS_Y, 0, 1023, 0, 0);
> +	input_set_abs_params(input_dev, ABS_PRESSURE, 0, 1023, 0, 0);
> +
> +	tsi->dev = input_dev;
> +	input_set_drvdata(input_dev, tsi);
> +
> +	tsi->pendown = tsi->workschd = 0;
> +
> +	tsi->irq_pendwn = platform_get_irq_byname(pdev, "PENDWN");
> +	if (tsi->irq_pendwn < 0) {
> +		ret = tsi->irq_pendwn;
> +		goto err_workq;
> +	}
> +
> +	ret = request_threaded_irq(tsi->da9052->irq_base + tsi->irq_pendwn,
> +				NULL, da9052_ts_pendwn_irq,
> +				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +				"PENDWN", tsi);
> +	if (ret < 0) {
> +		dev_err(tsi->da9052->dev,
> +			"Failed to register %s IRQ %d, error = %d\n", "PENDWN",
> +			tsi->da9052->irq_base + tsi->irq_pendwn, ret);
> +		goto err_workq;
> +	}
> +
> +	tsi->irq_datardy = platform_get_irq_byname(pdev, "TSIRDY");
> +	if (tsi->irq_datardy < 0) {
> +		ret = tsi->irq_datardy;
> +		goto err_pendwn_irq;
> +	}
> +
> +	ret = request_threaded_irq(tsi->da9052->irq_base + tsi->irq_datardy,
> +				NULL, da9052_ts_datardy_irq,
> +				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +				"TSIRDY", tsi);
> +	if (ret < 0) {
> +		dev_err(tsi->da9052->dev,
> +			"Failed to register %s IRQ %d, error = %d\n", "TSIRDY",
> +			tsi->da9052->irq_base + tsi->irq_datardy, ret);
> +		goto err_pendwn_irq;
> +	}
> +
> +	ret = da9052_configure_tsi(tsi);
> +	if (ret < 0)
> +		goto err_datardy_irq;
> +
> +	ret = input_register_device(tsi->dev);
> +	if (ret < 0)
> +		goto err_datardy_irq;
> +
> +	platform_set_drvdata(pdev, tsi);
> +
> +	return 0;
> +
> +err_datardy_irq:
> +	free_irq(tsi->da9052->irq_base + tsi->irq_datardy, tsi);
> +err_pendwn_irq:
> +	free_irq(tsi->da9052->irq_base + tsi->irq_pendwn, tsi);
> +err_workq:
> +	destroy_workqueue(tsi->ts_workq);
> +err_input:
> +	input_free_device(input_dev);
> +err_mem:
> +	kfree(tsi);
> +	return ret;
> +}
> +
> +static int  __devexit da9052_ts_remove(struct platform_device *pdev)
> +{
> +	struct da9052_tsi *tsi = platform_get_drvdata(pdev);
> +	s32 ret;
> +
> +	ret = da9052_reg_update(tsi->da9052, DA9052_TSI_CONT_A_REG, 1 << 0, 0);
> +	if (ret < 0)
> +		return ret;

You are doing this in da9052_ts_close() so you do not need to do it
here.

> +
> +	ret = da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x19);
> +	if (ret < 0)
> +		return ret;
> +
> +	cancel_work_sync(&tsi->ts_report_penup);

This should be moved into da9052_ts_close().

> +	destroy_workqueue(tsi->ts_workq);
> +
> +	free_irq(tsi->da9052->irq_base + tsi->irq_pendwn, tsi);
> +	free_irq(tsi->da9052->irq_base + tsi->irq_datardy, tsi);
> +
> +	input_unregister_device(tsi->dev);
> +
> +	platform_set_drvdata(pdev, NULL);
> +
> +	kfree(tsi);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver da9052_tsi_driver = {
> +
> +	.probe = da9052_ts_probe,
> +	.remove = __devexit_p(da9052_ts_remove),
> +	.driver = {
> +		.name = "da9052-tsi",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +static int __init da9052_ts_init(void)
> +{
> +	return platform_driver_register(&da9052_tsi_driver);
> +}
> +module_init(da9052_ts_init);
> +
> +static void __exit da9052_ts_exit(void)
> +{
> +	platform_driver_unregister(&da9052_tsi_driver);
> +}
> +module_exit(da9052_ts_exit);
> +
> +MODULE_DESCRIPTION("Touchscreen driver for Dialog Semiconductor DA9052");
> +MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:da9052-tsi");
> 
> 

Thanks.

-- 
Dmitry
