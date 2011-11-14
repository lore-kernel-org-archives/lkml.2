Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1KNRED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:04:03 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51868 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab1KNREB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:04:01 -0500
Date: Mon, 14 Nov 2011 09:03:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: oskar.andero@sonyericsson.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        aghayal@codeaurora.org,
        Courtney Cavin <courtney.cavin@sonyericsson.com>
Subject: Re: [PATCH v2] input: add driver support for Sharp gp2ap002a00f
 proximity sensor
Message-ID: <20111114170352.GA12659@core.coreip.homeip.net>
References: <1321285158-7123-1-git-send-email-oskar.andero@sonyericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321285158-7123-1-git-send-email-oskar.andero@sonyericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Courtney,

On Mon, Nov 14, 2011 at 04:39:18PM +0100, oskar.andero@sonyericsson.com wrote:
> From: Courtney Cavin <courtney.cavin@sonyericsson.com>
> 

The driver looks much better, a few more comments still.

> +
> +#include <linux/i2c.h>
> +#include <linux/irq.h>
> +#include <linux/slab.h>
> +#include <linux/input.h>
> +#include <linux/module.h>
> +#include <linux/workqueue.h>

As Shubhrajyoti mentioned workqueue.h is probably not needed.

> +#include <linux/interrupt.h>
> +#include <linux/gpio.h>
> +#include <linux/delay.h>
> +#include <linux/input/gp2ap002a00f.h>
> +
> +struct gp2a_data {
> +	struct input_dev *device;
> +	const struct gp2a_platform_data *pdata;
> +	struct i2c_client *i2c_client;
> +};
> +
> +enum gp2a_addr {
> +	GP2A_ADDR_PROX	= 0x0,
> +	GP2A_ADDR_GAIN	= 0x1,
> +	GP2A_ADDR_HYS	= 0x2,
> +	GP2A_ADDR_CYCLE	= 0x3,
> +	GP2A_ADDR_OPMOD	= 0x4,
> +	GP2A_ADDR_CON	= 0x6
> +};
> +
> +enum gp2a_controls {
> +	GP2A_CTRL_SSD	= 0x01
> +};
> +
> +static int gp2a_enable(struct gp2a_data *dt)
> +{
> +	return i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_OPMOD,
> +					 GP2A_CTRL_SSD);
> +}
> +
> +static int gp2a_disable(struct gp2a_data *dt)
> +{
> +	return i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_OPMOD,
> +					 0x00);
> +}
> +
> +static int __devinit gp2a_initialize(struct gp2a_data *dt)
> +{
> +	int error;
> +
> +	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_GAIN,
> +					  0x08);
> +	if (error < 0)
> +		return error;
> +
> +	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_HYS,
> +					  0xc2);
> +	if (error < 0)
> +		return error;
> +
> +	error = i2c_smbus_write_byte_data(dt->i2c_client, GP2A_ADDR_CYCLE,
> +					  0x04);
> +	if (error < 0)
> +		return error;
> +
> +	error = gp2a_disable(dt);
> +
> +	return error;
> +}
> +
> +static int gp2a_report(struct gp2a_data *dt)
> +{
> +	int vo = gpio_get_value(dt->pdata->vout_gpio);
> +
> +	input_report_key(dt->device, SW_FRONT_PROXIMITY, !vo);

Switch is not a key, so please use input_report_switch().

> +	input_sync(dt->device);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t gp2a_irq(int irq, void *handle)
> +{
> +	struct gp2a_data *dt = handle;
> +
> +	gp2a_report(dt);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int gp2a_device_open(struct input_dev *dev)
> +{
> +	struct gp2a_data *dt = input_get_drvdata(dev);
> +	int error;
> +
> +	error = gp2a_enable(dt);
> +	if (error < 0) {
> +		dev_err(&dev->dev, "unable to activate, err %d\n", error);
> +		return error;
> +	}
> +
> +	gp2a_report(dt);
> +
> +	return 0;
> +}
> +
> +static void gp2a_device_close(struct input_dev *dev)
> +{
> +	struct gp2a_data *dt = input_get_drvdata(dev);
> +	int error;
> +
> +	error = gp2a_disable(dt);
> +	if (error < 0)
> +		dev_err(&dev->dev, "unable to deactivate, err %d\n", error);
> +}
> +
> +static int __devinit gp2a_probe(struct i2c_client *client,
> +				const struct i2c_device_id *id)
> +{
> +	const struct gp2a_platform_data *pdata;
> +	struct gp2a_data *dt;
> +	int error;
> +
> +	pdata = client->dev.platform_data;
> +	if (!pdata)
> +		return -EINVAL;
> +
> +	if (pdata->hw_setup) {
> +		error = pdata->hw_setup(client);
> +		if (error < 0)
> +			return error;
> +	}
> +
> +	error = gpio_direction_input(pdata->vout_gpio);
> +	if (error < 0)
> +		goto err_hw_shutdown;
> +
> +	dt = kzalloc(sizeof(struct gp2a_data), GFP_KERNEL);
> +	if (!dt) {
> +		error = -ENOMEM;
> +		goto err_hw_shutdown;
> +	}
> +
> +	dt->pdata = pdata;
> +	dt->i2c_client = client;
> +	i2c_set_clientdata(client, dt);
> +
> +	error = gp2a_initialize(dt);
> +	if (error < 0)
> +		goto err_free_dt;
> +
> +	dt->device = input_allocate_device();
> +	if (!dt->device) {
> +		error = -ENOMEM;
> +		goto err_free_dt;
> +	}
> +	input_set_drvdata(dt->device, dt);
> +
> +	error = request_threaded_irq(client->irq, NULL,
> +			gp2a_irq, IRQF_TRIGGER_RISING |
> +			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +			GP2A_I2C_NAME, dt);
> +	if (error) {
> +		dev_err(&dt->device->dev, "irq request failed\n");

You are leaking dt->device here. Please add a separate label for
input_free_device(dt->device).

> +		goto err_free_dt;
> +	}
> +
> +	dt->device->open = gp2a_device_open;
> +	dt->device->close = gp2a_device_close;
> +	dt->device->name = GP2A_I2C_NAME;
> +	dt->device->id.bustype = BUS_I2C;
> +
> +	input_set_capability(dt->device, EV_KEY, SW_FRONT_PROXIMITY);

Should be EV_SW instead of EV_KEY.

> +
> +	error = input_register_device(dt->device);
> +	if (error) {
> +		dev_err(&dt->device->dev, "device registration failed\n");
> +		input_free_device(dt->device);

If you swap request_threaded_irq() and input_register_device() so that
registration is the last action error handling will be much simpler.

> +		goto err_free_irq;
> +	}
> +
> +	device_init_wakeup(&client->dev, pdata->wakeup);
> +
> +	return 0;
> +
> +err_free_irq:
> +	free_irq(client->irq, dt);
> +err_free_dt:
> +	kfree(dt);
> +err_hw_shutdown:
> +	if (pdata->hw_shutdown)
> +		pdata->hw_shutdown(client);
> +	return error;
> +}
> +
> +static int __devexit gp2a_remove(struct i2c_client *client)
> +{
> +	struct gp2a_data *dt = i2c_get_clientdata(client);
> +
> +	device_init_wakeup(&client->dev, false);
> +
> +	free_irq(client->irq, dt);
> +	input_unregister_device(dt->device);
> +	if (dt->pdata->hw_shutdown)
> +		dt->pdata->hw_shutdown(client);
> +	kfree(dt);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int gp2a_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct gp2a_data *dt = i2c_get_clientdata(client);
> +	int error;
> +
> +	if (device_may_wakeup(&client->dev)) {
> +		enable_irq_wake(client->irq);
> +	} else {

This needs locking WRT open/close. Please acquire dt->device->mutex and
only disable if dt->device->users != 0. Similar shoudl be done for
resume.

> +		error = gp2a_disable(dt);
> +		if (error < 0)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> +
> +static int gp2a_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct gp2a_data *dt = i2c_get_clientdata(client);
> +	int error;
> +
> +	if (device_may_wakeup(&client->dev)) {
> +		disable_irq_wake(client->irq);
> +	} else {
> +		error = gp2a_enable(dt);
> +		if (error < 0)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(gp2a_pm, gp2a_suspend, gp2a_resume);
> +
> +static const struct i2c_device_id gp2a_i2c_id[] = {
> +	{ GP2A_I2C_NAME, 0 },
> +	{ }
> +};
> +
> +static struct i2c_driver gp2a_i2c_driver = {
> +	.driver = {
> +		.name	= GP2A_I2C_NAME,
> +		.owner	= THIS_MODULE,
> +		.pm	= &gp2a_pm
> +	},
> +	.probe		= gp2a_probe,
> +	.remove		= __devexit_p(gp2a_remove),
> +	.id_table	= gp2a_i2c_id
> +};
> +
> +static int __init gp2a_init(void)
> +{
> +	return i2c_add_driver(&gp2a_i2c_driver);
> +}
> +
> +static void __exit gp2a_exit(void)
> +{
> +	i2c_del_driver(&gp2a_i2c_driver);
> +}
> +
> +module_init(gp2a_init);
> +module_exit(gp2a_exit);
> +
> +MODULE_AUTHOR("Courtney Cavin <courtney.cavin@sonyericsson.com>");
> +MODULE_DESCRIPTION("Sharp GP2AP002A00F I2C Proximity/Opto sensor driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/input/gp2ap002a00f.h b/include/linux/input/gp2ap002a00f.h
> new file mode 100644
> index 0000000..aad2fd4
> --- /dev/null
> +++ b/include/linux/input/gp2ap002a00f.h
> @@ -0,0 +1,22 @@
> +#ifndef _GP2AP002A00F_H_
> +#define _GP2AP002A00F_H_
> +
> +#include <linux/i2c.h>
> +
> +#define GP2A_I2C_NAME "gp2ap002a00f"
> +
> +/**
> + * struct gp2a_platform_data - Sharp gp2ap002a00f proximity platform data
> + * @vout_gpio: The gpio connected to the object detected pin (VOUT)
> + * @wakeup: Set to true if the proximity can wake the device from suspend
> + * @hw_setup: Callback for setting up hardware such as gpios and vregs
> + * @hw_shutdown: Callback for properly shutting down hardware
> + */
> +struct gp2a_platform_data {
> +	int vout_gpio;
> +	bool wakeup;
> +	int (*hw_setup)(struct i2c_client *client);
> +	int (*hw_shutdown)(struct i2c_client *client);
> +};
> +
> +#endif
> -- 
> 1.7.7
> 

Thanks.

-- 
Dmitry
