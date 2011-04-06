Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab1DFRIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 13:08:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42012 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab1DFRIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 13:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kCPF/WkM7XKjzTB0sDfRPMI++9DNaVLl5JO9oSjgUlgSyXTM4JmOkXJkXx/0+f7+3K
         1Z2LWWeSZ0nxmJUQrQd6P8J8lzDq+l4RK5LPOQk4cqH+MbjFZtNQRyg6tIyaucJjqy3C
         K6grPFNtVPqvO48z/rzjtTFp00+ld5wNE0ZjQ=
Date: Wed, 6 Apr 2011 10:08:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiejing Zhang <kzjeef@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Eric Miao <eric.y.miao@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Jiejing <jiejing.zhang@freescale.com>
Subject: Re: [PATCH] input: add maxim max11801 resistance touchscreen
 controller driver.
Message-ID: <20110406170839.GA5025@core.coreip.homeip.net>
References: <1302105142-12242-1-git-send-email-kzjeef@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302105142-12242-1-git-send-email-kzjeef@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhang,

On Wed, Apr 06, 2011 at 11:52:22PM +0800, Jiejing Zhang wrote:
> From: Zhang Jiejing <jiejing.zhang@freescale.com>
> 
> Add MAXI max11801 resistance touch screen controller driver,
> This driver use Auto Mode and Aperture Mode.
> 
> Other max1180x driver can support in this driver, they use
> almost same register address and define, you can find a table in
> max11801_ts.c
> 
> You can find data sheet under this link:
> http://www.maxim-ic.com/datasheet/index.mvp/id/5943
> 
> Signed-off-by: Zhang Jiejing <jiejing.zhang@freescale.com>
> ---
>  drivers/input/touchscreen/Kconfig       |   12 ++
>  drivers/input/touchscreen/Makefile      |    1 +
>  drivers/input/touchscreen/max11801_ts.c |  293 +++++++++++++++++++++++++++++++
>  3 files changed, 306 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/touchscreen/max11801_ts.c
> 
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index 434fd80..a1067af 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -714,4 +714,16 @@ config TOUCHSCREEN_TPS6507X
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called tps6507x_ts.
>  
> +config TOUCHSCREEN_MAX11801
> +       tristate "MAX11801 based touchscreens"
> +       depends on I2C
> +       help
> +        Say Y here if you have a MAX11801 based touchscreen
> +        controller
> +
> +        If unsure, say N.
> +
> +        To compile this driver as a module, choose M here: the
> +	  module will be called max11801_ts
> +
>  endif
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index ca94098..d2302f9 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -59,3 +59,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_TPS6507X)	+= tps6507x-ts.o
> +obj-$(CONFIG_TOUCHSCREEN_MAX11801)	+= max11801_ts.o
> diff --git a/drivers/input/touchscreen/max11801_ts.c b/drivers/input/touchscreen/max11801_ts.c
> new file mode 100644
> index 0000000..cdbd3c6
> --- /dev/null
> +++ b/drivers/input/touchscreen/max11801_ts.c
> @@ -0,0 +1,293 @@
> +/*
> + * max11801_ts.c - Driver for MAXI MAX11801 - A Resistive touch screen

No filenames in comments please.

> + * controller with i2c interface
> + *
> + * Copyright (C) 2011 Freescale Semiconductor, Inc.
> + * Author: Zhang Jiejing <jiejing.zhang@freescale.com>
> + *
> + * Based on mcs5000_ts.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License.
> + */
> +
> +/* This driver is aim for support the serial of MAXI touch chips
> + * max11801-max11803, the main different of this 4 chips can get from
> + * this table
> + * -----------------------------------------------------
> + * | CHIP     |  AUTO MODE SUPPORT(FIFO) | INTERFACE    |
> + * |----------------------------------------------------|
> + * | max11800 |  YES                     |   SPI        |
> + * | max11801 |  YES                     |   I2C        |
> + * | max11802 |  NO                      |   SPI        |
> + * | max11803 |  NO                      |   I2C        |
> + * ------------------------------------------------------
> + *
> + * Currently, this driver only support max11801.
> + *
> + * Data Sheet:
> + * http://www.maxim-ic.com/datasheet/index.mvp/id/5943
> + * */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/input.h>
> +#include <linux/irq.h>
> +#include <linux/slab.h>
> +#include <linux/bitops.h>
> +#include <linux/delay.h>
> +
> +/* Register Address define */
> +#define GENERNAL_STATUS_REG		0x00
> +#define GENERNAL_CONF_REG		0x01
> +#define MESURE_RES_CONF_REG		0x02
> +#define MESURE_AVER_CONF_REG		0x03
> +#define ADC_SAMPLE_TIME_CONF_REG	0x04
> +#define PANEL_SETUPTIME_CONF_REG	0x05
> +#define DELAY_CONVERSION_CONF_REG	0x06
> +#define TOUCH_DETECT_PULLUP_CONF_REG	0x07
> +#define AUTO_MODE_TIME_CONF_REG		0x08 /* only for max11800/max11801 */
> +#define APERTURE_CONF_REG		0x09 /* only for max11800/max11801 */
> +#define AUX_MESURE_CONF_REG		0x0a
> +#define OP_MODE_CONF_REG		0x0b
> +
> +/* FIFO is only in max11800 & max11801 */
> +#define FIFO_RD_CMD			(0x50 << 1)
> +#define MAX11801_FIFO_INT		(1 << 2)
> +#define MAX11801_FIFO_OVERFLOW		(1 << 3)
> +
> +#define XY_BUFSIZE			4
> +#define XY_BUF_OFFSET			4
> +
> +#define MAX11801_MAX_X			0xfff
> +#define MAX11801_MAX_Y			0xfff
> +
> +#define MEASURE_TAG_OFFSET		2
> +#define MEASURE_TAG_MASK		(3 << MEASURE_TAG_OFFSET)
> +#define EVENT_TAG_OFFSET		0
> +#define EVENT_TAG_MASK			(3 << EVENT_TAG_OFFSET)
> +#define MEASURE_X_TAG			(0 << MEASURE_TAG_OFFSET)
> +#define MEASURE_Y_TAG			(1 << MEASURE_TAG_OFFSET)
> +
> +/* These are the state of touch event state machine */
> +enum {
> +	EVENT_INIT,
> +	EVENT_MIDDLE,
> +	EVENT_RELEASE,
> +	EVENT_FIFO_END
> +};
> +
> +struct max11801_data {
> +	struct i2c_client		*client;
> +	struct input_dev		*input_dev;
> +	struct delayed_work		work;
> +	struct workqueue_struct		*workq;
> +};
> +
> +static u8 read_register(struct i2c_client *client, int addr)
> +{
> +	/* XXX: The chip ignore LSB of register address */

s/ignore/ignores/


> +	return i2c_smbus_read_byte_data(client, addr << 1);
> +}
> +
> +static int max11801_write_reg(struct i2c_client *client, int addr, int data)
> +{
> +	/* XXX: The chip ignore LSB of register address */

s/ignore/ignores/

> +	return i2c_smbus_write_byte_data(client, addr << 1, data);
> +}
> +
> +static void max11801_ts_work(struct work_struct *work)
> +{
> +	struct max11801_data *data = container_of(to_delayed_work(work),
> +						  struct max11801_data, work);
> +	struct i2c_client *client = data->client;
> +	int status, i, ret;
> +	u8 buf[XY_BUFSIZE];
> +	int x = -1;
> +	int y = -1;
> +
> +	status = read_register(data->client, GENERNAL_STATUS_REG);
> +	while (status & (MAX11801_FIFO_INT | MAX11801_FIFO_OVERFLOW)) {
> +		status = read_register(data->client, GENERNAL_STATUS_REG);
> +
> +		ret = i2c_smbus_read_i2c_block_data(client, FIFO_RD_CMD,
> +						    XY_BUFSIZE, buf);
> +
> +		/* We will get 4 bytes buffer that contains X,Y and event tag */
> +		if (ret < XY_BUFSIZE)
> +			continue;
> +
> +		for (i = 0; i < XY_BUFSIZE; i += XY_BUFSIZE / 2) {
> +			if ((buf[i+1] & MEASURE_TAG_MASK) == MEASURE_X_TAG)
> +				x = (buf[i] << XY_BUF_OFFSET) + (buf[i+1] >> XY_BUF_OFFSET);
> +			else if ((buf[i+1] & MEASURE_TAG_MASK) == MEASURE_Y_TAG)
> +				y = (buf[i] << XY_BUF_OFFSET) + (buf[i+1] >> XY_BUF_OFFSET);
> +		}
> +
> +		if ((buf[1] & EVENT_TAG_MASK) != (buf[3] & EVENT_TAG_MASK))
> +			continue;
> +
> +		switch (buf[1] & EVENT_TAG_MASK) { /* What status of current p */
> +		case EVENT_INIT:
> +		case EVENT_MIDDLE:
> +			input_report_abs(data->input_dev, ABS_X, x);
> +			input_report_abs(data->input_dev, ABS_Y, y);
> +			input_report_abs(data->input_dev, ABS_PRESSURE, 1);

If the device does not provide true pressure reading you should not
report fake values. Please do not report ABS_PRESSURE and remove it from
device capabilities.

> +			input_event(data->input_dev, EV_KEY, BTN_TOUCH, 1);
> +			input_sync(data->input_dev);
> +			break;
> +		case EVENT_RELEASE:
> +			input_report_abs(data->input_dev, ABS_PRESSURE, 0);
> +			input_event(data->input_dev, EV_KEY, BTN_TOUCH, 0);
> +			input_sync(data->input_dev);
> +			break;
> +		case EVENT_FIFO_END:
> +			break;
> +		}
> +	}
> +	enable_irq(client->irq);
> +}
> +
> +static void max11801_ts_phy_init(struct max11801_data *data)
> +{
> +	struct i2c_client *client = data->client;
> +
> +	/* Average X,Y, take 16 samples, average eight media sample */
> +	max11801_write_reg(client, MESURE_AVER_CONF_REG, 0xff);
> +	/* X,Y panel setup time set to 20us */
> +	max11801_write_reg(client, PANEL_SETUPTIME_CONF_REG, 0x11);
> +	/* Rough pullup time (2uS), Fine pullup time (10us)  */
> +	max11801_write_reg(client, TOUCH_DETECT_PULLUP_CONF_REG, 0x10);
> +	/* Auto mode init period = 5ms , scan period = 5ms*/
> +	max11801_write_reg(client, AUTO_MODE_TIME_CONF_REG, 0xaa);
> +	/* Aperture X,Y set to +- 4LSB */
> +	max11801_write_reg(client, APERTURE_CONF_REG, 0x33);
> +	/* Enable Power, enable Automode, enable Aperture, enable Average X,Y */
> +	max11801_write_reg(client, OP_MODE_CONF_REG, 0x36);
> +}
> +
> +static irqreturn_t max11801_irq(int irq, void *dev)
> +{
> +	struct max11801_data *data = dev;
> +	disable_irq_nosync(irq);
> +	queue_delayed_work(data->workq, &data->work, 0);
> +	return IRQ_HANDLED;

You should be using request_threaded_irq() and get rid of your private
workqueue.

> +}
> +
> +static int __devinit max11801_ts_probe(struct i2c_client *client,
> +				       const struct i2c_device_id *id)
> +{
> +	struct max11801_data *data;
> +	struct input_dev *input_dev;
> +	int ret;
> +
> +	data = kzalloc(sizeof(struct max11801_data), GFP_KERNEL);
> +	if (!data) {
> +		dev_err(&client->dev, "Failed to allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	input_dev = input_allocate_device();
> +	if (!input_dev) {
> +		dev_err(&client->dev, "Failed to allocate memory\n");
> +		ret = -ENOMEM;
> +		goto err_free_mem;
> +	}
> +
> +	data->client = client;
> +	data->input_dev = input_dev;
> +	max11801_ts_phy_init(data);
> +	INIT_DELAYED_WORK(&data->work, max11801_ts_work);
> +	data->workq = create_singlethread_workqueue("max11801_ts");
> +	if (!data->workq) {
> +		dev_err(&client->dev, "Failed to create workqueue\n");
> +		ret = -ENOMEM;
> +		goto err_free_wq;
> +	}
> +
> +	input_dev->name = "max11801_ts";
> +	input_dev->id.bustype = BUS_I2C;
> +	input_dev->dev.parent = &client->dev;
> +
> +	__set_bit(EV_ABS, input_dev->evbit);
> +	__set_bit(EV_KEY, input_dev->evbit);
> +	__set_bit(BTN_TOUCH, input_dev->keybit);
> +	__set_bit(ABS_X, input_dev->absbit);
> +	__set_bit(ABS_Y, input_dev->absbit);
> +	__set_bit(ABS_PRESSURE, input_dev->absbit);
> +	input_set_abs_params(input_dev, ABS_X, 0, MAX11801_MAX_X, 0, 0);
> +	input_set_abs_params(input_dev, ABS_Y, 0, MAX11801_MAX_Y, 0, 0);
> +	input_set_drvdata(input_dev, data);
> +
> +	ret = request_irq(client->irq, max11801_irq,
> +				   IRQF_TRIGGER_LOW, "max11801_ts", data);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "Failed to register interrupt\n");
> +		goto err_free_dev;
> +	}
> +
> +	ret = input_register_device(data->input_dev);
> +	if (ret < 0)
> +		goto err_free_irq;
> +	i2c_set_clientdata(client, data);
> +	return 0;
> +
> +err_free_irq:
> +	free_irq(client->irq, data);
> +err_free_wq:
> +	destroy_workqueue(data->workq);
> +err_free_dev:
> +	input_free_device(input_dev);
> +err_free_mem:
> +	kfree(data);
> +	return ret;
> +}
> +
> +static __devexit int max11801_ts_remove(struct i2c_client *client)
> +{
> +	struct max11801_data *data = i2c_get_clientdata(client);
> +
> +	free_irq(client->irq, data);
> +	cancel_delayed_work_sync(&data->work);
> +	destroy_workqueue(data->workq);
> +	input_unregister_device(data->input_dev);
> +	input_free_device(data->input_dev);
> +	kfree(data);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id max11801_ts_id[] = {
> +	{"max11801", 0},
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, max11801_ts_id);
> +
> +static struct i2c_driver max11801_ts_driver = {
> +	.probe		= max11801_ts_probe,
> +	.remove		= __devexit_p(max11801_ts_remove),
> +	.driver = {
> +		.name = "max11801_ts",
> +	},
> +	.id_table	= max11801_ts_id,
> +};
> +
> +static int __init max11801_ts_init(void)
> +{
> +	return i2c_add_driver(&max11801_ts_driver);
> +}
> +
> +static void __exit max11801_ts_exit(void)
> +{
> +	i2c_del_driver(&max11801_ts_driver);
> +}
> +
> +module_init(max11801_ts_init);
> +module_exit(max11801_ts_exit);
> +
> +MODULE_AUTHOR("Zhang Jiejing <jiejing.zhang@freescale.com>");
> +MODULE_DESCRIPTION("Touchscreen driver for MAXI MAX11801 controller");
> +MODULE_LICENSE("GPL");

Thanks.

-- 
Dmitry
