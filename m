Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab1KJSic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:38:32 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60257 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab1KJSi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:38:29 -0500
Date: Thu, 10 Nov 2011 10:38:07 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: oskar.andero@sonyericsson.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        aghayal@codeaurora.org,
        Courtney Cavin <courtney.cavin@sonyericsson.com>
Subject: Re: [PATCH] input: add driver support for Sharp gp2ap002a00f
 proximity sensor
Message-ID: <20111110183806.GA18002@core.coreip.homeip.net>
References: <1320941273-21228-1-git-send-email-oskar.andero@sonyericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320941273-21228-1-git-send-email-oskar.andero@sonyericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oskar, Courtney,

On Thu, Nov 10, 2011 at 05:07:53PM +0100, oskar.andero@sonyericsson.com wrote:
> From: Courtney Cavin <courtney.cavin@sonyericsson.com>
> 
> Signed-off-by: Courtney Cavin <courtney.cavin@sonyericsson.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>

The driver looks mostly good, just a few comments below.

> +#include <linux/gp2ap002a00f.h>

Probably should reside in include/linux/input/ or include/linux/i2c/

> +
> +struct gp2a_data {
> +	struct input_dev *device;
> +	struct gp2a_platform_data *pdata;

const.

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
> +#define NUM_TRIES 5
> +static int gp2a_write_byte(struct gp2a_data *dt, u8 reg, u8 val)
> +{
> +	int error;
> +	int n;
> +	struct device *dev = &dt->i2c_client->dev;
> +
> +	for (n = 0; n < NUM_TRIES; n++) {
> +		error = i2c_smbus_write_byte_data(dt->i2c_client, reg, val);
> +		if (error < 0)
> +			dev_err(dev, "i2c_smbus write failed, %d\n", error);

Do you actually see errors?

> +		else
> +			return 0;
> +		msleep(10);
> +	}
> +	return error;
> +}
> +
> +static int gp2a_initialize(struct gp2a_data *dt)

__devinit

> +{
> +	int error;
> +
> +	error = gp2a_write_byte(dt, GP2A_ADDR_GAIN, 0x08);
> +	if (error < 0)
> +		return error;
> +
> +	error = gp2a_write_byte(dt, GP2A_ADDR_HYS, 0xc2);
> +	if (error < 0)
> +		return error;
> +
> +	error = gp2a_write_byte(dt, GP2A_ADDR_CYCLE, 0x04);
> +	if (error < 0)
> +		return error;
> +
> +	error = gp2a_write_byte(dt, GP2A_ADDR_OPMOD, 0x00);
> +
> +	return error;
> +}
> +
> +static int gp2a_report(struct gp2a_data *dt)
> +{
> +	int vo = gpio_get_value(dt->pdata->gpio);
> +
> +	input_report_abs(dt->device, ABS_DISTANCE, vo ? 255 : 0);

This doe snot look like real distance, SW_FRONT_PROXIMITY instead?

> +	input_sync(dt->device);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t gp2a_irq(int irq, void *dev_id)
> +{
> +	struct device *dev = dev_id;
> +	struct gp2a_data *dt = dev_get_drvdata(dev);

Prefer to have correct accessor functions, in this case
i2c_get_clientdata().

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
> +	error = gp2a_write_byte(dt, GP2A_ADDR_OPMOD, GP2A_CTRL_SSD);
> +	if (error < 0) {
> +		dev_err(&dev->dev, "Unable to activate, err %d\n", error);
> +		return error;
> +	}
> +
> +	enable_irq(gpio_to_irq(dt->i2c_client->irq));

Are you positive that gpio_to_irq is needed here? Normally i2c client
has proper IRQ number already.

> +
> +	if (dt->pdata->wake)

	if (device_may_wakeup(&client->dev))

and you need to do

	device_init_wakeup(&client->dev, pdata->wake);

in probe().

> +		enable_irq_wake(gpio_to_irq(dt->i2c_client->irq));

Usually you enable wakeups in suspend routine instead of only when
device is opened by userspace.

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
> +	if (dt->pdata->wake)
> +		disable_irq_wake(gpio_to_irq(dt->i2c_client->irq));
> +
> +	disable_irq(gpio_to_irq(dt->i2c_client->irq));
> +	error = gp2a_write_byte(dt, GP2A_ADDR_OPMOD, 0);
> +	if (error < 0)
> +		dev_err(&dev->dev, "Unable to deactivate, err %d\n", error);
> +}
> +
> +static int gp2a_probe(struct i2c_client *client,
> +		      const struct i2c_device_id *id);
> +static int gp2a_remove(struct i2c_client *client);

Instead of having forward declarations just move gp2a_i2c_driver
definition further down.

> +
> +static const struct i2c_device_id gp2a_i2c_id[] = {
> +	{GP2A_I2C_NAME, 0},
> +	{}
> +};
> +
> +static struct i2c_driver gp2a_i2c_driver = {
> +	.driver = {
> +		.name	= GP2A_I2C_NAME,
> +		.owner	= THIS_MODULE
> +	},
> +	.probe		= gp2a_probe,
> +	.remove		= __devexit_p(gp2a_remove),
> +	.id_table	= gp2a_i2c_id
> +};
> +
> +static int gp2a_probe(struct i2c_client *client, const struct i2c_device_id *id)

__devinit

> +{
> +	struct gp2a_platform_data *pdata;

const.

> +	struct gp2a_data *dt;
> +	int error;
> +
> +	pdata = client->dev.platform_data;
> +	if (!pdata)
> +		return -EINVAL;
> +
> +	if (pdata->gpio_setup) {
> +		error = pdata->gpio_setup();
> +		if (error < 0)
> +			return error;
> +	}
> +
> +	error = gpio_direction_input(pdata->gpio);
> +	if (error < 0)
> +		goto err_gpio_shutdown;
> +
> +	dt = kzalloc(sizeof(struct gp2a_data), GFP_KERNEL);
> +	if (!dt) {
> +		error = -ENOMEM;
> +		goto err_gpio_shutdown;
> +	}
> +
> +	client->driver = &gp2a_i2c_driver;

Shoudl no be needed, i2c core will take care of setting driver for you.

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
> +
> +	input_set_drvdata(dt->device, dt);
> +
> +	dt->device->open = gp2a_device_open;
> +	dt->device->close = gp2a_device_close;
> +	dt->device->name = GP2A_I2C_NAME;
> +	dt->device->id.bustype = BUS_I2C;
> +	set_bit(EV_ABS, dt->device->evbit);

	__set_bit()

> +	set_bit(ABS_DISTANCE, dt->device->absbit);

	Not really needed, the call below will take care of this.

> +
> +	input_set_abs_params(dt->device, ABS_DISTANCE, 0, 255, 0, 0);
> +
> +	error = input_register_device(dt->device);
> +	if (error) {
> +		dev_err(&dt->device->dev, "device registration failed\n");
> +		input_free_device(dt->device);
> +		goto err_free_dt;

To avoid dooing partial unwind in error path switch device registration
and request_threaded_irq() around.

> +	}
> +
> +	error = request_threaded_irq(gpio_to_irq(dt->i2c_client->irq), NULL,
> +			gp2a_irq, IRQF_TRIGGER_RISING |
> +			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +			GP2A_I2C_NAME, &dt->i2c_client->dev);

Why are you passing bare device to the interrupt handler instead of 'dt'
whuch is much more useful.

> +	if (error) {
> +		dev_err(&dt->device->dev, "irq request failed\n");
> +		goto err_unreg_input;
> +	}
> +	disable_irq(gpio_to_irq(dt->i2c_client->irq));
> +
> +	return 0;
> +
> +err_unreg_input:
> +	input_unregister_device(dt->device);
> +err_free_dt:
> +	kfree(dt);
> +err_gpio_shutdown:
> +	if (pdata->gpio_shutdown)
> +		pdata->gpio_shutdown();
> +	return error;
> +}
> +
> +static int gp2a_remove(struct i2c_client *client)

__devexit

> +{
> +	struct gp2a_data *dt = i2c_get_clientdata(client);
> +
> +	device_init_wakeup(&client->dev, 0);
> +	if (dt->pdata->gpio_shutdown)
> +		dt->pdata->gpio_shutdown();

Should it be done last, after unregistering the device? You want to let
close() chance to talk to the device.

> +	free_irq(gpio_to_irq(dt->i2c_client->irq), &dt->i2c_client->dev);
> +	input_unregister_device(dt->device);
> +	kfree(dt);
> +
> +	return 0;
> +}
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
> diff --git a/include/linux/gp2ap002a00f.h b/include/linux/gp2ap002a00f.h
> new file mode 100644
> index 0000000..74e2610
> --- /dev/null
> +++ b/include/linux/gp2ap002a00f.h
> @@ -0,0 +1,13 @@
> +#ifndef _GP2AP002A00F_H_
> +#define _GP2AP002A00F_H_
> +
> +#define GP2A_I2C_NAME   "gp2ap002a00f"
> +
> +struct gp2a_platform_data {
> +	int gpio;
> +	int wake;

Bool.

> +	int (*gpio_setup)(void);

Woudl be nice to pass client or something to identify the device you are
workig with; otherwise there is no chance of having more than one such
device in a box.

> +	int (*gpio_shutdown)(void);
> +};
> +
> +#endif
> -- 
> 1.7.7
> 

-- 
Dmitry
