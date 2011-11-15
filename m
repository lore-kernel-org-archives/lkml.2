Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab1KOI3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 03:29:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64096 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab1KOI3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 03:29:32 -0500
Date: Tue, 15 Nov 2011 00:29:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: oskar.andero@sonyericsson.com
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonyericsson.com>
Subject: Re: [PATCH v2] input: add driver support for Sharp gp2ap002a00f
 proximity sensor
Message-ID: <20111115082926.GA13157@core.coreip.homeip.net>
References: <1321285158-7123-1-git-send-email-oskar.andero@sonyericsson.com>
 <20111114170352.GA12659@core.coreip.homeip.net>
 <20111115075629.GE9307@caracas.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115075629.GE9307@caracas.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 08:56:29AM +0100, oskar.andero@sonyericsson.com wrote:
> Hi again Dmitry,
> 
> Just a quick question before I post v3.
> 
> On 18:03 Mon 14 Nov     , Dmitry Torokhov wrote:
> > Hi Courtney,
> > 
> > On Mon, Nov 14, 2011 at 04:39:18PM +0100, oskar.andero@sonyericsson.com wrote:
> > > From: Courtney Cavin <courtney.cavin@sonyericsson.com>
> > > 
> > 
> > The driver looks much better, a few more comments still.
> > 
> > > +
> > > +#include <linux/i2c.h>
> > > +#include <linux/irq.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/input.h>
> > > +#include <linux/module.h>
> > > +#include <linux/workqueue.h>
> > 
> > As Shubhrajyoti mentioned workqueue.h is probably not needed.
> > 
> > > +#include <linux/interrupt.h>
> > > +#include <linux/gpio.h>
> > > +#include <linux/delay.h>
> > > +#include <linux/input/gp2ap002a00f.h>
> > > +
> > > +struct gp2a_data {
> > > +	struct input_dev *device;
> > > +	const struct gp2a_platform_data *pdata;
> > > +	struct i2c_client *i2c_client;
> > > +};
> > > +
> > > +enum gp2a_addr {
> > > +	GP2A_ADDR_PROX	= 0x0,
> > > +	GP2A_ADDR_GAIN	= 0x1,
> > > +	GP2A_ADDR_HYS	= 0x2,
> > > +	GP2A_ADDR_CYCLE	= 0x3,
> > > +	GP2A_ADDR_OPMOD	= 0x4,
> > > +	GP2A_ADDR_CON	= 0x6
> > > +};
> > > +
> > > +enum gp2a_controls {
> > > +	GP2A_CTRL_SSD	= 0x01
> > > +};
> > > +
> > > +static int gp2a_enable(struct gp2a_data *dt)
> > > +{
> > > +	return i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_OPMOD,
> > > +					 GP2A_CTRL_SSD);
> > > +}
> > > +
> > > +static int gp2a_disable(struct gp2a_data *dt)
> > > +{
> > > +	return i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_OPMOD,
> > > +					 0x00);
> > > +}
> > > +
> > > +static int __devinit gp2a_initialize(struct gp2a_data *dt)
> > > +{
> > > +	int error;
> > > +
> > > +	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_GAIN,
> > > +					  0x08);
> > > +	if (error < 0)
> > > +		return error;
> > > +
> > > +	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_HYS,
> > > +					  0xc2);
> > > +	if (error < 0)
> > > +		return error;
> > > +
> > > +	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_CYCLE,
> > > +					  0x04);
> > > +	if (error < 0)
> > > +		return error;
> > > +
> > > +	error = gp2a_disable(dt);
> > > +
> > > +	return error;
> > > +}
> > > +
> > > +static int gp2a_report(struct gp2a_data *dt)
> > > +{
> > > +	int vo = gpio_get_value(dt->pdata->vout_gpio);
> > > +
> > > +	input_report_key(dt->device, SW_FRONT_PROXIMITY, !vo);
> > 
> > Switch is not a key, so please use input_report_switch().
> > 
> > > +	input_sync(dt->device);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static irqreturn_t gp2a_irq(int irq, void *handle)
> > > +{
> > > +	struct gp2a_data *dt = handle;
> > > +
> > > +	gp2a_report(dt);
> > > +
> > > +	return IRQ_HANDLED;
> > > +}
> > > +
> > > +static int gp2a_device_open(struct input_dev *dev)
> > > +{
> > > +	struct gp2a_data *dt = input_get_drvdata(dev);
> > > +	int error;
> > > +
> > > +	error = gp2a_enable(dt);
> > > +	if (error < 0) {
> > > +		dev_err(&dev->dev, "unable to activate, err %d\n", error);
> > > +		return error;
> > > +	}
> > > +
> > > +	gp2a_report(dt);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static void gp2a_device_close(struct input_dev *dev)
> > > +{
> > > +	struct gp2a_data *dt = input_get_drvdata(dev);
> > > +	int error;
> > > +
> > > +	error = gp2a_disable(dt);
> > > +	if (error < 0)
> > > +		dev_err(&dev->dev, "unable to deactivate, err %d\n", error);
> > > +}
> > > +
> > > +static int __devinit gp2a_probe(struct i2c_client *client,
> > > +				const struct i2c_device_id *id)
> > > +{
> > > +	const struct gp2a_platform_data *pdata;
> > > +	struct gp2a_data *dt;
> > > +	int error;
> > > +
> > > +	pdata = client->dev.platform_data;
> > > +	if (!pdata)
> > > +		return -EINVAL;
> > > +
> > > +	if (pdata->hw_setup) {
> > > +		error = pdata->hw_setup(client);
> > > +		if (error < 0)
> > > +			return error;
> > > +	}
> > > +
> > > +	error = gpio_direction_input(pdata->vout_gpio);
> > > +	if (error < 0)
> > > +		goto err_hw_shutdown;
> > > +
> > > +	dt = kzalloc(sizeof(struct gp2a_data), GFP_KERNEL);
> > > +	if (!dt) {
> > > +		error = -ENOMEM;
> > > +		goto err_hw_shutdown;
> > > +	}
> > > +
> > > +	dt->pdata = pdata;
> > > +	dt->i2c_client = client;
> > > +	i2c_set_clientdata(client, dt);
> > > +
> > > +	error = gp2a_initialize(dt);
> > > +	if (error < 0)
> > > +		goto err_free_dt;
> > > +
> > > +	dt->device = input_allocate_device();
> > > +	if (!dt->device) {
> > > +		error = -ENOMEM;
> > > +		goto err_free_dt;
> > > +	}
> > > +	input_set_drvdata(dt->device, dt);
> > > +
> > > +	error = request_threaded_irq(client->irq, NULL,
> > > +			gp2a_irq, IRQF_TRIGGER_RISING |
> > > +			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> > > +			GP2A_I2C_NAME, dt);
> > > +	if (error) {
> > > +		dev_err(&dt->device->dev, "irq request failed\n");
> > 
> > You are leaking dt->device here. Please add a separate label for
> > input_free_device(dt->device).
> > 
> > > +		goto err_free_dt;
> > > +	}
> > > +
> > > +	dt->device->open = gp2a_device_open;
> > > +	dt->device->close = gp2a_device_close;
> > > +	dt->device->name = GP2A_I2C_NAME;
> > > +	dt->device->id.bustype = BUS_I2C;
> > > +
> > > +	input_set_capability(dt->device, EV_KEY, SW_FRONT_PROXIMITY);
> > 
> > Should be EV_SW instead of EV_KEY.
> > 
> > > +
> > > +	error = input_register_device(dt->device);
> > > +	if (error) {
> > > +		dev_err(&dt->device->dev, "device registration failed\n");
> > > +		input_free_device(dt->device);
> > 
> > If you swap request_threaded_irq() and input_register_device() so that
> > registration is the last action error handling will be much simpler.
> >
> 
> I am getting a bit confused here, since you asked me to swap the order
> of request_threaded_irq() and input_register_device() in my previous
> version as well. Swapping again will take us back to square one or maybe
> I am misinterpreting your comment?

Gah, sorry, a bit of boilerplate slipped in. You already have the calls
in right order, you just need proper labels.


	input_dev = input_allocate_device();
	if (!input_dev) {
		dev_err(...);
		error = -ENOMEM;
		goto err_free_mem;
	}

	... set up input device fully ...

	error = request_threaded_irq(...);
	if (error) {
		dev_err(...);
		goto err_free_input_dev;
	}

	error = input_register_device(input_dev);
	if (error) {
		dev_err(...);
		goto err_free_irq;
	}

	i2c_set_clientdata(client, dt);

	return 0;

err_free_irq:
	free_irq(client->irq, dt);
err_free_input_dev:
	input_free_device(input_dev);
err_free_mem:
	kfree(dt);
err_hw_shutdown:
	...
	return error;
}

-- 
Dmitry
