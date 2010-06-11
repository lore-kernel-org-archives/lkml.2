Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745Ab0FKLE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 07:04:27 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:47070 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab0FKLEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 07:04:25 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C1217E9.80606@jic23.retrosnub.co.uk>
Date: Fri, 11 Jun 2010 12:03:05 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: Luotao Fu <l.fu@pengutronix.de>
CC: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: add STMPE811 core support
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de> <1276251195-22981-2-git-send-email-l.fu@pengutronix.de>
In-Reply-To: <1276251195-22981-2-git-send-email-l.fu@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/10 11:13, Luotao Fu wrote:

Hi couple of really minor comments inline.

Looks good to me,

Acked-by: Jonathan Cameron<jic23@cam.ac.uk>

> STMPE811 is a multifunction device, which contains a GPIO controller, a
> Touchscreen controller, an ADC and a temperature sensor. This patch adds a core
> driver for this device. The driver provides core functionalities like accessing
> the registers and management of subdevices. The device supports communication
> through SPI and I2C interface. Currently we only support I2C.
> 
> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
> ---
>  drivers/mfd/Kconfig          |    8 +
>  drivers/mfd/Makefile         |    1 +
>  drivers/mfd/stmpe811-core.c  |  369 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/stmpe811.h |  126 ++++++++++++++
>  4 files changed, 504 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/stmpe811-core.c
>  create mode 100644 include/linux/mfd/stmpe811.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 9da0e50..2c5388b 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -482,6 +482,14 @@ config MFD_JANZ_CMODIO
>  	  host many different types of MODULbus daughterboards, including
>  	  CAN and GPIO controllers.
>  
> +config MFD_STMPE811
> +	tristate "STMicroelectronics STMPE811"
> +	depends on I2C
> +	select MFD_CORE
> +	help
> +	  This is the core driver for the stmpe811 GPIO expander with touchscreen
> +	  controller, ADC and temperature sensor.
> +
>  endif # MFD_SUPPORT
>  
>  menu "Multimedia Capabilities Port drivers"
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index fb503e7..6a7ad83 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -71,3 +71,4 @@ obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
>  obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
>  obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
>  obj-$(CONFIG_MFD_JANZ_CMODIO)	+= janz-cmodio.o
> +obj-$(CONFIG_MFD_STMPE811)	+= stmpe811-core.o
> diff --git a/drivers/mfd/stmpe811-core.c b/drivers/mfd/stmpe811-core.c
> new file mode 100644
> index 0000000..080b3d7
> --- /dev/null
> +++ b/drivers/mfd/stmpe811-core.c
> @@ -0,0 +1,369 @@
> +/*
> + * stmpe811-core.c  --  core support for STMicroelectronics STMPE811 chip.
> + *
> + * based on pcf50633-core.c by Harald Welte <laforge@openmoko.org> and
> + * Balaji Rao <balajirrao@openmoko.org>
> + *
> + * (c)2010 Luotao Fu <l.fu@pengutronix.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/i2c.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/stmpe811.h>
> +
> +static inline int __stmpe811_i2c_reads(struct i2c_client *client, int reg,
> +				       int len, u8 *val)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_read_i2c_block_data(client, reg, len, val);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "failed reading from 0x%02x\n", reg);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static struct mfd_cell stmpe811_ts_dev = {
> +	.name = "stmpe811-ts",
> +};
> +
> +static struct mfd_cell stmpe811_gpio_dev = {
> +	.name = "stmpe811-gpio",
> +};
> +
> +static void stmpe811_irq_worker(struct work_struct *work)
> +{
> +	struct stmpe811 *stm;
> +	int ret, bit;
> +	u8 int_stat;
> +	irq_handler_t handler;
> +	void *data;
> +
> +	stm = container_of(work, struct stmpe811, irq_work);
> +
> +	ret = stmpe811_reg_read(stm, STMPE811_REG_INT_STA, &int_stat);
> +	if (ret) {
> +		dev_err(stm->dev, "Error reading INT registers\n");
> +		goto out;
> +	}
> +
> +	dev_dbg(stm->dev, "%s int_stat 0x%02x\n", __func__, int_stat);
> +
> +	for_each_set_bit(bit, (unsigned long *)&int_stat, STMPE811_NUM_IRQ) {
> +		handler = stm->irqhandler[bit];
> +		data = stm->irqdata[bit];
> +		if (handler) {
> +			/* mask the interrupt while calling handler */
> +			stmpe811_reg_clear_bits(stm, STMPE811_REG_INT_EN,
> +						1 << bit);
> +			/* call handler and acknowledge the interrupt */
> +			handler(bit, data);
> +			stmpe811_reg_set_bits(stm, STMPE811_REG_INT_STA,
> +					      (1 << bit));
small formatting quirk. Why the brackets in the above?
> +			/* demask the interrupt */
> +			stmpe811_reg_set_bits(stm, STMPE811_REG_INT_EN,
> +					      1 << bit);
> +		}
> +	}
> +out:
> +	put_device(stm->dev);
> +	enable_irq(stm->irq);
> +
bonus white line.
> +}
> +
> +static irqreturn_t stmpe811_irq(int irq, void *data)
> +{
> +	struct stmpe811 *stm = data;
> +
> +	get_device(stm->dev);
> +	disable_irq_nosync(stm->irq);
> +	queue_work(stm->work_queue, &stm->irq_work);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static inline int __stmpe811_i2c_read(struct i2c_client *client,
> +				      int reg, u8 *val)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_read_byte_data(client, reg);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "failed reading at 0x%02x\n", reg);
> +		return ret;
> +	}
> +	dev_dbg(&client->dev, "%s: value 0x%x from 0x%x\n", __func__, ret, reg);
> +
> +	*val = (u8) ret;
> +	return 0;
> +}
> +
> +static inline int __stmpe811_i2c_write(struct i2c_client *client,
> +				       int reg, u8 val)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_write_byte_data(client, reg, val);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "failed writing 0x%02x to 0x%02x\n",
> +			val, reg);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +int stmpe811_block_read(struct stmpe811 *stm, u8 reg, uint len, u8 *val)
> +{
> +	int ret;
> +
> +	mutex_lock(&stm->io_lock);
> +	ret = __stmpe811_i2c_reads(stm->i2c_client, reg, len, val);
> +	mutex_unlock(&stm->io_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(stmpe811_block_read);
> +
> +int stmpe811_reg_read(struct stmpe811 *stm, u8 reg, u8 *val)
> +{
> +	int ret;
> +
> +	mutex_lock(&stm->io_lock);
> +	ret = __stmpe811_i2c_read(stm->i2c_client, reg, val);
> +	mutex_unlock(&stm->io_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(stmpe811_reg_read);
> +
> +int stmpe811_reg_write(struct stmpe811 *stm, u8 reg, u8 val)
> +{
> +	int ret;
> +
> +	mutex_lock(&stm->io_lock);
> +	ret = __stmpe811_i2c_write(stm->i2c_client, reg, val);
> +	mutex_unlock(&stm->io_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(stmpe811_reg_write);
> +
> +int stmpe811_reg_set_bits(struct stmpe811 *stm, u8 reg, u8 val)
> +{
> +	int ret;
> +	u8 tmp;
> +
> +	mutex_lock(&stm->io_lock);
> +	ret = __stmpe811_i2c_read(stm->i2c_client, reg, &tmp);
> +	if (ret < 0)
> +		goto out;
> +
> +	tmp |= val;
> +	ret = __stmpe811_i2c_write(stm->i2c_client, reg, tmp);
> +
> +out:
> +	mutex_unlock(&stm->io_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(stmpe811_reg_set_bits);
> +
> +int stmpe811_reg_clear_bits(struct stmpe811 *stm, u8 reg, u8 val)
> +{
> +	int ret;
> +	u8 tmp;
> +
> +	mutex_lock(&stm->io_lock);
> +	ret = __stmpe811_i2c_read(stm->i2c_client, reg, &tmp);
> +	if (ret < 0)
> +		goto out;
> +
> +	tmp &= ~val;
> +	ret = __stmpe811_i2c_write(stm->i2c_client, reg, tmp);
> +
> +out:
> +	mutex_unlock(&stm->io_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(stmpe811_reg_clear_bits);
> +
> +int stmpe811_register_irq(struct stmpe811 *stm, int irq,
> +			  irq_handler_t handler, void *data)
> +{
> +	if (irq < 0 || irq > STMPE811_NUM_IRQ || !handler)
> +		return -EINVAL;
> +
> +	if (WARN_ON(stm->irqhandler[irq]))
> +		return -EBUSY;
> +
> +	stm->irqhandler[irq] = handler;
> +	stm->irqdata[irq] = data;
> +	/* unmask the irq */
> +	return stmpe811_reg_set_bits(stm, STMPE811_REG_INT_EN, 1 << irq);
> +}
> +EXPORT_SYMBOL_GPL(stmpe811_register_irq);
> +
> +int stmpe811_free_irq(struct stmpe811 *stm, int irq)
> +{
> +	if (irq < 0 || irq > STMPE811_NUM_IRQ)
> +		return -EINVAL;
> +
> +	stm->irqhandler[irq] = NULL;
> +
> +	return stmpe811_reg_clear_bits(stm, STMPE811_REG_INT_EN, 1 << irq);
> +}
> +EXPORT_SYMBOL_GPL(stmpe811_free_irq);
> +
> +static int __devinit stmpe811_probe(struct i2c_client *client,
> +				    const struct i2c_device_id *ids)
> +{
> +	struct stmpe811 *stm;
> +	struct stmpe811_platform_data *pdata = client->dev.platform_data;
> +	int ret = 0;
> +	u8 chip_id[2], chip_ver = 0;
> +
> +	if (!client->irq) {
> +		dev_err(&client->dev, "Missing IRQ\n");
> +		return -ENOENT;
> +	}
> +
> +	stm = kzalloc(sizeof(*stm), GFP_KERNEL);
> +	if (!stm)
> +		return -ENOMEM;
> +
> +	stm->pdata = pdata;
> +
> +	mutex_init(&stm->io_lock);
> +
> +	i2c_set_clientdata(client, stm);
> +	stm->dev = &client->dev;
> +	stm->i2c_client = client;
> +	stm->irq = client->irq;
> +	stm->work_queue = create_singlethread_workqueue("stmpe811");
> +
> +	if (!stm->work_queue) {
> +		dev_err(&client->dev, "Failed to alloc workqueue\n");
> +		ret = -ENOMEM;
> +		goto err_free;
> +	}
> +
> +	INIT_WORK(&stm->irq_work, stmpe811_irq_worker);
> +
> +	ret = stmpe811_block_read(stm, STMPE811_REG_CHIP_ID, 2, chip_id);
> +	if ((ret < 0) || (((chip_id[0] << 8) | chip_id[1]) != 0x811)) {
> +		dev_err(&client->dev, "could not verify  stmpe811 chip id\n");
> +		ret = -ENODEV;
> +		goto err_destroy_workqueue;
> +	}
> +
> +	stmpe811_reg_read(stm, STMPE811_REG_ID_VER, &chip_ver);
> +	dev_info(&client->dev, "found stmpe811 chip id 0x%x version 0x%x\n",
> +		 (chip_id[0] << 8) | chip_id[1], chip_ver);
> +
> +	/* reset the device */
> +	stmpe811_reg_write(stm, STMPE811_REG_SYS_CTRL1,
> +			   STMPE811_SYS_CTRL1_SOFT_RESET);
> +
> +	/* setup platform specific interrupt control flags and enable global
> +	 * interrupt */
> +	stmpe811_reg_write(stm, STMPE811_REG_INT_CTRL,
> +			   STMPE811_INT_CTRL_GLOBAL_INT | pdata->int_conf);
> +	ret =
> +	    request_irq(client->irq, stmpe811_irq, pdata->irq_flags, "stmpe811",
> +			stm);
> +	if (ret) {
> +		dev_err(stm->dev, "Failed to request IRQ %d\n", ret);
> +		goto err_destroy_workqueue;
> +	}
> +
> +	if (pdata->flags & STMPE811_USE_TS)
> +		ret =
> +		    mfd_add_devices(&client->dev, -1, &stmpe811_ts_dev, 1, NULL,
> +				    0);
> +	if (ret != 0)
> +		goto err_release_irq;
> +
> +	if (pdata->flags & STMPE811_USE_GPIO)
> +		ret =
> +		    mfd_add_devices(&client->dev, -1, &stmpe811_gpio_dev, 1,
> +				    NULL, 0);
> +	if (ret != 0)
> +		goto err_remove_mfd_devices;
> +
> +	return ret;
> +
> +err_remove_mfd_devices:
> +	mfd_remove_devices(&client->dev);
> +err_release_irq:
> +	free_irq(client->irq, stm);
> +err_destroy_workqueue:
> +	destroy_workqueue(stm->work_queue);
> +err_free:
> +	mutex_destroy(&stm->io_lock);
> +	i2c_set_clientdata(client, NULL);
> +	kfree(stm);
> +
> +	return ret;
> +}
> +
> +static int __devexit stmpe811_remove(struct i2c_client *client)
> +{
> +	struct stmpe811 *stm = i2c_get_clientdata(client);
> +
> +	stmpe811_reg_write(stm, STMPE811_REG_SYS_CTRL1,
> +			   STMPE811_SYS_CTRL1_HIBERNATE);
> +
> +	free_irq(stm->irq, stm);
> +	destroy_workqueue(stm->work_queue);
> +
> +	mfd_remove_devices(&client->dev);
> +
> +	kfree(stm);
> +
> +	return 0;
> +}
> +
> +static struct i2c_device_id stmpe811_id_table[] = {
> +	{"stmpe811", 0x88},
> +	{ /* end of list */ }
> +};
> +
> +static struct i2c_driver stmpe811_driver = {
> +	.driver = {
> +		   .name = "stmpe811",
> +		   .owner = THIS_MODULE,
> +		   },
> +	.probe = stmpe811_probe,
> +	.remove = __devexit_p(stmpe811_remove),
> +	.id_table = stmpe811_id_table,
> +};
> +
> +static int __init stmpe811_init(void)
> +{
> +	return i2c_add_driver(&stmpe811_driver);
> +}
> +
> +subsys_initcall(stmpe811_init);
> +
> +static void __exit stmpe811_exit(void)
> +{
> +	i2c_del_driver(&stmpe811_driver);
> +}
> +
> +module_exit(stmpe811_exit);
> +
> +MODULE_DESCRIPTION
> +    ("CORE Driver for STMPE811 Touch screen controller with GPIO expander");
> +MODULE_AUTHOR("Luotao Fu <l.fu@pengutronix.de>");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/mfd/stmpe811.h b/include/linux/mfd/stmpe811.h
> new file mode 100644
> index 0000000..ab2808a
> --- /dev/null
> +++ b/include/linux/mfd/stmpe811.h
> @@ -0,0 +1,126 @@
> +#ifndef __LINUX_MFD_STMPE811_H
> +#define __LINUX_MFD_STMPE811_H
> +
> +#include <linux/i2c.h>
> +#include <linux/workqueue.h>
> +

Personally I'd be inclined to put these in the
subdevice drivers that care about them.

Just keep the ones used by multiple subdevices
in here...

> +#define STMPE811_REG_CHIP_ID		0x00
> +#define STMPE811_REG_ID_VER		0x02
> +#define STMPE811_REG_SYS_CTRL1		0x03
> +#define STMPE811_REG_SYS_CTRL2		0x04
> +#define STMPE811_REG_SPI_CFG		0x08
> +#define STMPE811_REG_INT_CTRL		0x09
> +#define STMPE811_REG_INT_EN		0x0A
> +#define STMPE811_REG_INT_STA		0x0B
> +#define STMPE811_REG_GPIO_EN		0x0C
> +#define STMPE811_REG_GPIO_INT_STA	0x0D
> +#define STMPE811_REG_ADC_INT_EN		0x0E
> +#define STMPE811_REG_ADC_INT_STA	0x0F
> +#define STMPE811_REG_GPIO_SET_PIN	0x10
> +#define STMPE811_REG_GPIO_CLR_PIN	0x11
> +#define STMPE811_REG_GPIO_MP_STA	0x12
> +#define STMPE811_REG_GPIO_DIR		0x13
> +#define STMPE811_REG_GPIO_ED		0x14
> +#define STMPE811_REG_GPIO_RE		0x15
> +#define STMPE811_REG_GPIO_FE		0x16
> +#define STMPE811_REG_GPIO_AF		0x17
> +#define STMPE811_REG_ADC_CTRL1		0x20
> +#define STMPE811_REG_ADC_CTRL2		0x21
> +#define STMPE811_REG_ADC_CAPT		0x22
> +#define STMPE811_REG_ADC_DATA_CH0	0x30
> +#define STMPE811_REG_ADC_DATA_CH1	0x32
> +#define STMPE811_REG_ADC_DATA_CH2	0x34
> +#define STMPE811_REG_ADC_DATA_CH3	0x36
> +#define STMPE811_REG_ADC_DATA_CH4	0x38
> +#define STMPE811_REG_ADC_DATA_CH5	0x3A
> +#define STMPE811_REG_ADC_DATA_CH6	0x3C
> +#define STMPE811_REG_ADC_DATA_CH7	0x3E
> +#define STMPE811_REG_TSC_CTRL		0x40
> +#define STMPE811_REG_TSC_CFG		0x41
> +#define STMPE811_REG_WDW_TR_X		0x42
> +#define STMPE811_REG_WDW_TR_Y		0x44
> +#define STMPE811_REG_WDW_BL_X		0x46
> +#define STMPE811_REG_WDW_BL_Y		0x48
> +#define STMPE811_REG_FIFO_TH		0x4A
> +#define STMPE811_REG_FIFO_STA		0x4B
> +#define STMPE811_REG_FIFO_SIZE		0x4C
> +#define STMPE811_REG_TSC_DATA_X		0x4D
> +#define STMPE811_REG_TSC_DATA_Y		0x4F
> +#define STMPE811_REG_TSC_DATA_Z		0x51
> +#define STMPE811_REG_TSC_DATA_XYZ	0x52
> +#define STMPE811_REG_TSC_FRACTION_Z	0x56
> +#define STMPE811_REG_TSC_DATA		0x57
> +#define STMPE811_REG_TSC_DATA_SINGLE	0xD7
> +#define STMPE811_REG_TSC_I_DRIVE	0x58
> +#define STMPE811_REG_TSC_SHIELD		0x59
> +#define STMPE811_REG_TEMP_CTRL		0x60
> +
> +#define STMPE811_IRQ_TOUCH_DET		0
> +#define STMPE811_IRQ_FIFO_TH		1
> +#define STMPE811_IRQ_FIFO_OFLOW		2
> +#define STMPE811_IRQ_FIFO_FULL		3
> +#define STMPE811_IRQ_FIFO_EMPTY		4
> +#define STMPE811_IRQ_TEMP_SENS		5
> +#define STMPE811_IRQ_ADC		6
> +#define STMPE811_IRQ_GPIO		7
> +#define STMPE811_NUM_IRQ		8
> +
> +#define STMPE811_SYS_CTRL1_HIBERNATE	(1<<0)
> +#define STMPE811_SYS_CTRL1_SOFT_RESET	(1<<1)
> +
> +#define STMPE811_SYS_CTRL2_ADC_OFF	(1<<0)
> +#define STMPE811_SYS_CTRL2_TSC_OFF	(1<<1)
> +#define STMPE811_SYS_CTRL2_GPIO_OFF	(1<<2)
> +#define STMPE811_SYS_CTRL2_TS_OFF	(1<<3)
> +
> +#define STMPE811_INT_CTRL_GLOBAL_INT	(1<<0)
> +#define STMPE811_INT_CTRL_INT_TYPE	(1<<1)
> +#define STMPE811_INT_CTRL_INT_POLARITY	(1<<2)
> +
> +#define STMPE811_FIFO_STA_OFLOW		(1<<7)
> +#define STMPE811_FIFO_STA_FULL		(1<<6)
> +#define STMPE811_FIFO_STA_EMPTY		(1<<5)
> +#define STMPE811_FIFO_STA_TH_TRIG	(1<<4)
> +#define STMPE811_FIFO_STA_RESET		(1<<0)
> +
> +#define STMPE811_USE_TS			(1<<0)
> +#define STMPE811_USE_GPIO		(1<<1)
> +
> +struct stmpe811 {
> +	struct device *dev;
> +	struct i2c_client *i2c_client;
> +
> +	struct stmpe811_platform_data *pdata;
> +	int irq;
> +	irq_handler_t irqhandler[STMPE811_NUM_IRQ];
> +	void *irqdata[STMPE811_NUM_IRQ];
> +	struct work_struct irq_work;
> +	struct workqueue_struct *work_queue;
> +	struct mutex io_lock;
> +	u8 active_flag;
> +};
> +
> +struct stmpe811_gpio_platform_data {
> +	unsigned int gpio_base;
> +	int (*setup) (struct stmpe811 *stm);
> +	void (*remove) (struct stmpe811 *stm);
> +};
> +
> +struct stmpe811_platform_data {
> +	unsigned int flags;
> +	unsigned int irq_flags;
> +	unsigned int int_conf;
> +	struct stmpe811_gpio_platform_data *gpio_pdata;
> +};
> +
> +int stmpe811_block_read(struct stmpe811 *stm, u8 reg, uint len, u8 *val);
> +int stmpe811_reg_read(struct stmpe811 *pcf, u8 reg, u8 *val);
> +int stmpe811_reg_write(struct stmpe811 *stm, u8 reg, u8 val);
> +int stmpe811_reg_set_bits(struct stmpe811 *stm, u8 reg, u8 val);
> +int stmpe811_reg_clear_bits(struct stmpe811 *stm, u8 reg, u8 val);
> +
> +int stmpe811_register_irq(struct stmpe811 *stm, int irq,
> +			  irq_handler_t handler, void *data);
> +int stmpe811_free_irq(struct stmpe811 *stm, int irq);
> +
> +#endif

