Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1KOMxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:53:05 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18166 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231Ab1KOMxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:53:01 -0500
From: <oskar.andero@sonyericsson.com>
Date: Tue, 15 Nov 2011 13:53:52 +0100
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonyericsson.com>
Subject: Re: [PATCH v3] input: add driver support for Sharp gp2ap002a00f
 proximity sensor
Message-ID: <20111115125352.GA23767@caracas.corpusers.net>
References: <1321349160-2931-1-git-send-email-oskar.andero@sonyericsson.com>
 <20111115094342.GD13157@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111115094342.GD13157@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:43 Tue 15 Nov     , Dmitry Torokhov wrote:
> On Tue, Nov 15, 2011 at 10:26:00AM +0100, oskar.andero@sonyericsson.com wrote:
> > From: Courtney Cavin <courtney.cavin@sonyericsson.com>
> > 
> > Signed-off-by: Courtney Cavin <courtney.cavin@sonyericsson.com>
> > Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
> > ---
> >  drivers/input/misc/Kconfig         |   10 ++
> >  drivers/input/misc/Makefile        |    1 +
> >  drivers/input/misc/gp2ap002a00f.c  |  300 ++++++++++++++++++++++++++++++++++++
> >  include/linux/input/gp2ap002a00f.h |   22 +++
> >  4 files changed, 333 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/input/misc/gp2ap002a00f.c
> >  create mode 100644 include/linux/input/gp2ap002a00f.h
> > 
> > diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> > index c9104bb..3c15c52 100644
> > --- a/drivers/input/misc/Kconfig
> > +++ b/drivers/input/misc/Kconfig
> > @@ -527,4 +527,14 @@ config INPUT_XEN_KBDDEV_FRONTEND
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called xen-kbdfront.
> >  
> > +config INPUT_GP2A
> > +	tristate "Sharp GP2AP002A00F I2C Proximity/Opto sensor driver"
> > +	depends on I2C
> > +	help
> > +	  Say Y here if you have a Sharp GP2AP002A00F proximity/als combo-chip
> > +	  hooked to an I2C bus.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called gp2ap002a00f.
> > +
> >  endif
> > diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> > index 299ad5e..361cf49 100644
> > --- a/drivers/input/misc/Makefile
> > +++ b/drivers/input/misc/Makefile
> > @@ -22,6 +22,7 @@ obj-$(CONFIG_INPUT_CMA3000)		+= cma3000_d0x.o
> >  obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o
> >  obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
> >  obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
> > +obj-$(CONFIG_INPUT_GP2A)		+= gp2ap002a00f.o
> >  obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
> >  obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
> >  obj-$(CONFIG_INPUT_KEYSPAN_REMOTE)	+= keyspan_remote.o
> > diff --git a/drivers/input/misc/gp2ap002a00f.c b/drivers/input/misc/gp2ap002a00f.c
> > new file mode 100644
> > index 0000000..73f866b
> > --- /dev/null
> > +++ b/drivers/input/misc/gp2ap002a00f.c
> > @@ -0,0 +1,300 @@
> > +/*
> > + * Copyright (C) 2011 Sony Ericsson Mobile Communications Inc.
> > + *
> > + * Author: Courtney Cavin <courtney.cavin@sonyericsson.com>
> > + * Prepared for up-stream by: Oskar Andero <oskar.andero@sonyericsson.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2, as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/i2c.h>
> > +#include <linux/irq.h>
> > +#include <linux/slab.h>
> > +#include <linux/input.h>
> > +#include <linux/module.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/gpio.h>
> > +#include <linux/delay.h>
> > +#include <linux/input/gp2ap002a00f.h>
> > +
> > +struct gp2a_data {
> > +	struct input_dev *device;
> > +	const struct gp2a_platform_data *pdata;
> > +	struct i2c_client *i2c_client;
> > +};
> > +
> > +enum gp2a_addr {
> > +	GP2A_ADDR_PROX	= 0x0,
> > +	GP2A_ADDR_GAIN	= 0x1,
> > +	GP2A_ADDR_HYS	= 0x2,
> > +	GP2A_ADDR_CYCLE	= 0x3,
> > +	GP2A_ADDR_OPMOD	= 0x4,
> > +	GP2A_ADDR_CON	= 0x6
> > +};
> > +
> > +enum gp2a_controls {
> > +	/* Software Shutdown control: 0 = shutdown, 1 = normal operation */
> > +	GP2A_CTRL_SSD	= 0x01
> > +};
> > +
> > +static int gp2a_enable(struct gp2a_data *dt)
> > +{
> > +	return i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_OPMOD,
> > +					 GP2A_CTRL_SSD);
> > +}
> > +
> > +static int gp2a_disable(struct gp2a_data *dt)
> > +{
> > +	return i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_OPMOD,
> > +					 0x00);
> > +}
> > +
> > +static int __devinit gp2a_initialize(struct gp2a_data *dt)
> > +{
> > +	int error;
> > +
> > +	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_GAIN,
> > +					  0x08);
> > +	if (error < 0)
> > +		return error;
> > +
> > +	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_HYS,
> > +					  0xc2);
> > +	if (error < 0)
> > +		return error;
> > +
> > +	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_CYCLE,
> > +					  0x04);
> > +	if (error < 0)
> > +		return error;
> > +
> > +	error = gp2a_disable(dt);
> > +
> > +	return error;
> > +}
> > +
> > +static int gp2a_report(struct gp2a_data *dt)
> > +{
> > +	int vo = gpio_get_value(dt->pdata->vout_gpio);
> > +
> > +	input_report_switch(dt->device, SW_FRONT_PROXIMITY, !vo);
> > +	input_sync(dt->device);
> > +
> > +	return 0;
> > +}
> > +
> > +static irqreturn_t gp2a_irq(int irq, void *handle)
> > +{
> > +	struct gp2a_data *dt = handle;
> > +
> > +	gp2a_report(dt);
> > +
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int gp2a_device_open(struct input_dev *dev)
> > +{
> > +	struct gp2a_data *dt = input_get_drvdata(dev);
> > +	int error;
> > +
> > +	error = gp2a_enable(dt);
> > +	if (error < 0) {
> > +		dev_err(&dev->dev, "unable to activate, err %d\n", error);
> > +		return error;
> > +	}
> > +
> > +	gp2a_report(dt);
> > +
> > +	return 0;
> > +}
> > +
> > +static void gp2a_device_close(struct input_dev *dev)
> > +{
> > +	struct gp2a_data *dt = input_get_drvdata(dev);
> > +	int error;
> > +
> > +	error = gp2a_disable(dt);
> > +	if (error < 0)
> > +		dev_err(&dev->dev, "unable to deactivate, err %d\n", error);
> > +}
> > +
> > +static int __devinit gp2a_probe(struct i2c_client *client,
> > +				const struct i2c_device_id *id)
> > +{
> > +	const struct gp2a_platform_data *pdata;
> > +	struct gp2a_data *dt;
> > +	int error;
> > +
> > +	pdata = client->dev.platform_data;
> > +	if (!pdata)
> > +		return -EINVAL;
> > +
> > +	if (pdata->hw_setup) {
> > +		error = pdata->hw_setup(client);
> > +		if (error < 0)
> > +			return error;
> > +	}
> > +
> > +	error = gpio_direction_input(pdata->vout_gpio);
> > +	if (error < 0)
> > +		goto err_hw_shutdown;
> > +
> > +	dt = kzalloc(sizeof(struct gp2a_data), GFP_KERNEL);
> > +	if (!dt) {
> > +		error = -ENOMEM;
> > +		goto err_hw_shutdown;
> > +	}
> > +
> > +	dt->pdata = pdata;
> > +	dt->i2c_client = client;
> > +	i2c_set_clientdata(client, dt);
> > +
> > +	error = gp2a_initialize(dt);
> > +	if (error < 0)
> > +		goto err_free_mem;
> > +
> > +	dt->device = input_allocate_device();
> > +	if (!dt->device) {
> > +		error = -ENOMEM;
> > +		goto err_free_mem;
> > +	}
> > +	input_set_drvdata(dt->device, dt);
> > +
> > +	dt->device->open = gp2a_device_open;
> > +	dt->device->close = gp2a_device_close;
> > +	dt->device->name = GP2A_I2C_NAME;
> > +	dt->device->id.bustype = BUS_I2C;
> > +
> > +	input_set_capability(dt->device, EV_SW, SW_FRONT_PROXIMITY);
> > +
> > +	error = request_threaded_irq(client->irq, NULL,
> > +			gp2a_irq, IRQF_TRIGGER_RISING |
> > +			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> > +			GP2A_I2C_NAME, dt);
> > +	if (error) {
> > +		dev_err(&dt->device->dev, "irq request failed\n");
> > +		goto err_free_input_dev;
> > +	}
> > +
> > +	error = input_register_device(dt->device);
> > +	if (error) {
> > +		dev_err(&dt->device->dev, "device registration failed\n");
> > +		input_free_device(dt->device);
> 
> Here you end up trying to free input device twice.

Of course! Thanks!

> > +		goto err_free_irq;
> > +	}
> > +
> > +	device_init_wakeup(&client->dev, pdata->wakeup);
> > +
> > +	return 0;
> > +
> > +err_free_irq:
> > +	free_irq(client->irq, dt);
> > +err_free_input_dev:
> > +	input_free_device(dt->device);
> > +err_free_mem:
> > +	kfree(dt);
> > +err_hw_shutdown:
> > +	if (pdata->hw_shutdown)
> > +		pdata->hw_shutdown(client);
> > +	return error;
> > +}
> > +
> > +static int __devexit gp2a_remove(struct i2c_client *client)
> > +{
> > +	struct gp2a_data *dt = i2c_get_clientdata(client);
> > +
> > +	device_init_wakeup(&client->dev, false);
> > +
> > +	free_irq(client->irq, dt);
> > +	input_unregister_device(dt->device);
> > +	if (dt->pdata->hw_shutdown)
> > +		dt->pdata->hw_shutdown(client);
> > +	kfree(dt);
> > +
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int gp2a_suspend(struct device *dev)
> > +{
> > +	struct i2c_client *client = to_i2c_client(dev);
> > +	struct gp2a_data *dt = i2c_get_clientdata(client);
> > +	int error;
> > +
> > +	mutex_lock(&dt->device->mutex);
> > +
> > +	if (dt->device->users) {
> > +		if (device_may_wakeup(&client->dev)) {
> > +			enable_irq_wake(client->irq);
> 
> I think this part should happen regardless of whether device has users,
> only non wakeup source case needs it.

Hmm.. why would one want to enable irq_wake when there are no users?
Wouldn't this cause the device to wakeup at every irq and report an
switch event that no one listens to?

> > +		} else {
> > +			error = gp2a_disable(dt);
> > +			if (error < 0)
> > +				return error;
> > +		}
> > +	}
> > +
> > +	mutex_unlock(&dt->device->mutex);
> > +
> > +	return 0;
> > +}
> > +
> > +static int gp2a_resume(struct device *dev)
> > +{
> > +	struct i2c_client *client = to_i2c_client(dev);
> > +	struct gp2a_data *dt = i2c_get_clientdata(client);
> > +	int error;
> > +
> > +	mutex_lock(&dt->device->mutex);
> > +
> > +	if (dt->device->users) {
> > +		if (device_may_wakeup(&client->dev)) {
> > +			disable_irq_wake(client->irq);
> > +		} else {
> > +			error = gp2a_enable(dt);
> > +			if (error < 0)
> > +				return error;
> > +		}
> > +	}
> > +
> > +	mutex_unlock(&dt->device->mutex);
> > +
> > +	return 0;
> > +}
> > +#endif
> > +
> > +static SIMPLE_DEV_PM_OPS(gp2a_pm, gp2a_suspend, gp2a_resume);
> > +
> > +static const struct i2c_device_id gp2a_i2c_id[] = {
> > +	{ GP2A_I2C_NAME, 0 },
> > +	{ }
> > +};
> > +
> > +static struct i2c_driver gp2a_i2c_driver = {
> > +	.driver = {
> > +		.name	= GP2A_I2C_NAME,
> > +		.owner	= THIS_MODULE,
> > +		.pm	= &gp2a_pm
> > +	},
> > +	.probe		= gp2a_probe,
> > +	.remove		= __devexit_p(gp2a_remove),
> > +	.id_table	= gp2a_i2c_id
> > +};
> > +
> > +static int __init gp2a_init(void)
> > +{
> > +	return i2c_add_driver(&gp2a_i2c_driver);
> > +}
> > +
> > +static void __exit gp2a_exit(void)
> > +{
> > +	i2c_del_driver(&gp2a_i2c_driver);
> > +}
> > +
> > +module_init(gp2a_init);
> > +module_exit(gp2a_exit);
> > +
> > +MODULE_AUTHOR("Courtney Cavin <courtney.cavin@sonyericsson.com>");
> > +MODULE_DESCRIPTION("Sharp GP2AP002A00F I2C Proximity/Opto sensor driver");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/include/linux/input/gp2ap002a00f.h b/include/linux/input/gp2ap002a00f.h
> > new file mode 100644
> > index 0000000..aad2fd4
> > --- /dev/null
> > +++ b/include/linux/input/gp2ap002a00f.h
> > @@ -0,0 +1,22 @@
> > +#ifndef _GP2AP002A00F_H_
> > +#define _GP2AP002A00F_H_
> > +
> > +#include <linux/i2c.h>
> > +
> > +#define GP2A_I2C_NAME "gp2ap002a00f"
> > +
> > +/**
> > + * struct gp2a_platform_data - Sharp gp2ap002a00f proximity platform data
> > + * @vout_gpio: The gpio connected to the object detected pin (VOUT)
> > + * @wakeup: Set to true if the proximity can wake the device from suspend
> > + * @hw_setup: Callback for setting up hardware such as gpios and vregs
> > + * @hw_shutdown: Callback for properly shutting down hardware
> > + */
> > +struct gp2a_platform_data {
> > +	int vout_gpio;
> > +	bool wakeup;
> > +	int (*hw_setup)(struct i2c_client *client);
> > +	int (*hw_shutdown)(struct i2c_client *client);
> > +};
> > +
> > +#endif
> > -- 
> > 1.7.7
> > 

-Oskar
