Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab1ADLBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 06:01:44 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52598 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1ADLBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 06:01:42 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6215"; a="69189019"
Message-ID: <4D22FE0F.7010206@codeaurora.org>
Date: Tue, 04 Jan 2011 16:31:35 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: fabien.marteau@armadeus.com
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: joystick:   Adding Austria Microsystem AS5011
 joystick driver (third version)
References: <4D22ECB6.6090800@armadeus.com>
In-Reply-To: <4D22ECB6.6090800@armadeus.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabien,

On 1/4/2011 3:17 PM, Fabien Marteau wrote:
>  Driver for EasyPoint AS5011 2 axis joystick chip. This chip is plugged
>  on an I2C bus. It has been tested on ARM processor (i.MX27).
> 
> Third version, according to Dmitry Torokhov and Trilok Soni comments.
> 
> 
> Signed-off-by: Fabien Marteau <fabien.marteau@armadeus.com>
> ---

Looks good. Few comments.

>  drivers/input/joystick/Kconfig  |    9 +
>  drivers/input/joystick/Makefile |    1 +
>  drivers/input/joystick/as5011.c |  377 +++++++++++++++++++++++++++++++++++++++
>  include/linux/as5011.h          |   35 ++++

How about moving it to include/linux/input?

> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/string.h>
> +#include <linux/list.h>
> +#include <linux/sysfs.h>
> +#include <linux/ctype.h>
> +#include <linux/hwmon-sysfs.h>

Are you using anything from this file? Please audit this list and remove
the files which are not used. Thanks.

> +
> +#define SIZE_NAME 30
> +#define SIZE_EVENT_PATH 40

I don't find anybody using these #defines. Please remove the defines which
are not used.

> +#define AS5011_MAX_AXIS	80
> +#define AS5011_MIN_AXIS	(-80)
> +#define AS5011_FUZZ	8
> +#define AS5011_FLAT	40
> +
> +static int as5011_i2c_write(struct i2c_client *client,
> +			    uint8_t aregaddr,
> +			    uint8_t avalue)
> +{
> +	int ret;
> +	uint8_t data[2] = { aregaddr, avalue };
> +
> +	struct i2c_msg msg = {	client->addr,
> +				I2C_M_IGNORE_NAK,
> +				2,
> +				(uint8_t *)data };
> +
> +	ret = i2c_transfer(client->adapter, &msg, 1);
> +
> +	if (ret < 0)
> +		return ret;
> +	return 1;
> +}

We return '0' on success and negative error code for error.

> +
> +static irqreturn_t button_interrupt(int irq, void *dev_id)
> +{
> +	struct as5011_platform_data *plat_dat = dev_id;
> +	int ret;
> +
> +	ret = gpio_get_value(plat_dat->button_gpio);

I don't find gpio_request call for this gpio anywhere in this driver. I prefer
that we do that for each gpio we use in the driver itself. Only muxing stuff
can be left out in your init/exit hooks.

> +	if (ret)
> +		input_report_key(plat_dat->input_dev, BTN_JOYSTICK, 0);
> +	else
> +		input_report_key(plat_dat->input_dev, BTN_JOYSTICK, 1);
> +	input_sync(plat_dat->input_dev);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void as5011_update_axes(struct as5011_platform_data *plat_dat)
> +{
> +	signed char x, y;
> +
> +	x = as5011_i2c_read(plat_dat->i2c_client, AS5011_X_RES_INT);
> +	y = as5011_i2c_read(plat_dat->i2c_client, AS5011_Y_RES_INT);

I prefer that i2c_read wrapper here would return the actual error code instead,
and have one function argument to return the "x, y" co-ordinates, that way
we don't loose the error codes, and return from here itself if i2c read fails.

> +	input_report_abs(plat_dat->input_dev, ABS_X, x);
> +	input_report_abs(plat_dat->input_dev, ABS_Y, y);
> +	input_sync(plat_dat->input_dev);
> +}
> +
> +static irqreturn_t as5011_int_interrupt(int irq, void *dev_id)
> +{
> +	struct as5011_platform_data *plat_dat = dev_id;
> +
> +	mutex_lock(&plat_dat->update_lock);
> +	as5011_update_axes(plat_dat);
> +	mutex_unlock(&plat_dat->update_lock);

Please explain this lock. Sorry if I have missed out your explanation in the earlier threads.

> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit as5011_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct as5011_platform_data *plat_dat = client->dev.platform_data;

const please. 

> +	int retval = 0;
> +
> +	if (!i2c_check_functionality(client->adapter,
> +				     I2C_FUNC_PROTOCOL_MANGLING)) {
> +		dev_err(&client->dev,
> +		"i2c bus does not support protocol mangling, as5011 can't work\n");
> +		retval = -ENODEV;
> +		goto err_out;
> +	}
> +	plat_dat->i2c_client = client;
> +
> +
> +	plat_dat->input_dev = input_allocate_device();
> +	if (plat_dat->input_dev == NULL) {
> +		dev_err(&client->dev,
> +		"not enough memory for input devices structure\n");
> +		retval = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	plat_dat->input_dev->name = "Austria Microsystem as5011 joystick";
> +	plat_dat->input_dev->id.bustype = BUS_I2C;
> +	__set_bit(EV_KEY, plat_dat->input_dev->evbit);
> +	__set_bit(EV_ABS, plat_dat->input_dev->evbit);
> +	__set_bit(BTN_JOYSTICK, plat_dat->input_dev->keybit);
> +
> +	input_set_abs_params(plat_dat->input_dev,
> +			     ABS_X,
> +			     AS5011_MIN_AXIS,
> +			     AS5011_MAX_AXIS,
> +			     AS5011_FUZZ,
> +			     AS5011_FLAT);
> +	input_set_abs_params(plat_dat->input_dev,
> +			     ABS_Y,
> +			     AS5011_MIN_AXIS,
> +			     AS5011_MAX_AXIS,
> +			     AS5011_FUZZ,
> +			     AS5011_FLAT);
> +
> +	retval = request_threaded_irq(plat_dat->button_irq,
> +					NULL, button_interrupt,
> +					0, "as5011_button",
> +					plat_dat);
> +	if (retval < 0) {
> +		dev_err(&client->dev, "Can't allocate irq %d\n",
> +			plat_dat->button_irq);
> +		retval = -EBUSY;

Why don't we return same error code instead of overwriting it here?

> +		goto err_input_free_device;
> +	}
> +
> +	if (plat_dat->init_gpio != NULL) {
> +		retval = plat_dat->init_gpio();
> +		if (retval < 0) {
> +			dev_err(&client->dev, "Failed to init gpios\n");
> +			goto err_free_irq_button_interrupt;
> +		}
> +	}
> +
> +	/* chip soft reset */
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_CTRL1,
> +				  AS5011_CTRL1_SOFT_RST);
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"Soft reset failed\n");
> +		goto err_exit_gpio;
> +	}
> +
> +	mdelay(10);
> +
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_CTRL1,
> +				  AS5011_CTRL1_LP_PULSED |
> +				  AS5011_CTRL1_LP_ACTIVE |
> +				  AS5011_CTRL1_INT_ACT_EN
> +				  );
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"Power config failed\n");
> +		goto err_exit_gpio;
> +	}
> +
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_CTRL2,
> +				  AS5011_CTRL2_INV_SPINNING);
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"Can't invert spinning\n");
> +		goto err_exit_gpio;
> +	}
> +
> +	/* write threshold */
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_XP,
> +				  plat_dat->xp);
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"Can't write threshold\n");
> +		goto err_exit_gpio;
> +	}
> +
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_XN,
> +				  plat_dat->xn);
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"Can't write threshold\n");
> +		goto err_exit_gpio;
> +	}
> +
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_YP,
> +				  plat_dat->yp);
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"Can't write threshold\n");
> +		goto err_exit_gpio;
> +	}
> +
> +	retval = as5011_i2c_write(plat_dat->i2c_client,
> +				  AS5011_YN,
> +				  plat_dat->yn);
> +	if (retval < 0) {
> +		dev_err(&plat_dat->i2c_client->dev,
> +			"Can't write threshold\n");
> +		goto err_exit_gpio;
> +	}
> +
> +	/* to free irq gpio in chip*/
> +	as5011_i2c_read(plat_dat->i2c_client, AS5011_X_RES_INT);

Would you prefer to move some of the initialization of the chip except
reset of controller to open() call, so that if there is no user of this
device than we don't need to leave this device left configured?

> +
> +	/* initialize mutex */
> +	mutex_init(&plat_dat->update_lock);
> +
> +	if (request_threaded_irq(plat_dat->int_irq, NULL,
> +				as5011_int_interrupt,
> +				0, "as5011_joystick", plat_dat)) {
> +		dev_err(&client->dev, "Can't allocate int irq %d\n",
> +			plat_dat->int_irq);
> +		retval = -EBUSY;
> +		goto err_exit_gpio;
> +	}
> +
> +	retval = input_register_device(plat_dat->input_dev);
> +	if (retval) {
> +		dev_err(&client->dev, "Failed to register device\n");
> +		goto err_free_irq_int;
> +	}
> +
> +	return 0;
> +
> +	/* Error management */
> +err_free_irq_int:
> +	free_irq(plat_dat->int_irq, as5011_int_interrupt);
> +err_exit_gpio:
> +	if (plat_dat->exit_gpio != NULL)
> +		plat_dat->exit_gpio();
> +err_free_irq_button_interrupt:
> +	free_irq(plat_dat->button_irq, button_interrupt);
> +err_input_free_device:
> +	input_free_device(plat_dat->input_dev);
> +err_out:
> +	return retval;
> +}
> +static int as5011_remove(struct i2c_client *client)
> +{
> +	struct as5011_platform_data *plat_dat = client->dev.platform_data;
> +
> +	input_unregister_device(plat_dat->input_dev);
> +	free_irq(plat_dat->button_irq, plat_dat);
> +	free_irq(plat_dat->int_irq, plat_dat);
> +	if (plat_dat->exit_gpio != NULL)
> +		plat_dat->exit_gpio();
> +
> +	return 0;
> +}
> +static const struct i2c_device_id as5011_id[] = {
> +	{ MODULE_DEVICE_ALIAS, 0 },
> +	{ }
> +};
> +
> +static struct i2c_driver as5011_driver = {
> +	.driver = {
> +		.name = "as5011",
> +	},
> +	.probe		= as5011_probe,
> +	.remove		= __devexit_p(as5011_remove),
> +	.id_table	= as5011_id,
> +};
> +
> +static int __init as5011_init(void)
> +{
> +	return i2c_add_driver(&as5011_driver);
> +}
> +
> +static void __exit as5011_exit(void)
> +{
> +	i2c_del_driver(&as5011_driver);
> +}
> +
> +module_init(as5011_init);
> +module_exit(as5011_exit);

nit-pick: I prefer that we put module_init/exit macros with their relevant functions.

> +#include <linux/mutex.h>
> +
> +#define AS5011_MAX_NAME_LENGTH	64
> +
> +struct as5011_platform_data {
> +	/* public */
> +	int button_gpio;
> +	int button_irq;
> +	int int_gpio;
> +	int int_irq;
> +	char xp, xn; /* threshold for x axis */
> +	char yp, yn; /* threshold for y axis */
> +
> +	int (*init_gpio)(void); /* init interrupts gpios */
> +	void (*exit_gpio)(void);/* exit gpios */
> +
> +	/* private */
> +	struct input_dev *input_dev;
> +	struct i2c_client *i2c_client;
> +	char name[AS5011_MAX_NAME_LENGTH];
> +	struct mutex update_lock;

These private stuff should not be part of your platform data structure. When we say
platform data meaning that it will be all public with "const". Please allocate
local data structure in the probe itself with these private members. You can refer
other drivers.


---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
