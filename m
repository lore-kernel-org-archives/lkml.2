Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab2HQMIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 08:08:06 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:38256 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab2HQMH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 08:07:59 -0400
Date: Fri, 17 Aug 2012 14:07:55 +0200 (CEST)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Thorsten Nowak <not@iis.fhg.de>
cc: Thorsten Nowak <thorsten.nowak@iis.fraunhofer.de>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: iio: Integration gyroscope itg3200
In-Reply-To: <1345192038-5665-1-git-send-email-not@iis.fhg.de>
Message-ID: <alpine.DEB.2.01.1208171335130.13532@pmeerw.net>
References: <1345192038-5665-1-git-send-email-not@iis.fhg.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> InvenSense ITG3200 Digital 3-Axis Gyroscope I2C driver
> 
> Signed-off-by: Thorsten Nowak <not@iis.fhg.de>
> ---
>  drivers/staging/iio/gyro/Kconfig           |   11 +
>  drivers/staging/iio/gyro/Makefile          |    4 +
>  drivers/staging/iio/gyro/itg3200.h         |  161 ++++++++
>  drivers/staging/iio/gyro/itg3200_buffer.c  |  171 ++++++++
>  drivers/staging/iio/gyro/itg3200_core.c    |  592 ++++++++++++++++++++++++++++
>  drivers/staging/iio/gyro/itg3200_trigger.c |   90 +++++
>  6 files changed, 1029 insertions(+)
>  create mode 100644 drivers/staging/iio/gyro/itg3200.h
>  create mode 100644 drivers/staging/iio/gyro/itg3200_buffer.c
>  create mode 100644 drivers/staging/iio/gyro/itg3200_core.c
>  create mode 100644 drivers/staging/iio/gyro/itg3200_trigger.c
> 
> diff --git a/drivers/staging/iio/gyro/Kconfig b/drivers/staging/iio/gyro/Kconfig
> index ea295b2..47b383d 100644
> --- a/drivers/staging/iio/gyro/Kconfig
> +++ b/drivers/staging/iio/gyro/Kconfig
> @@ -46,4 +46,15 @@ config ADXRS450
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called adxrs450.
>  
> +config ITG3200
> +	tristate "InvenSense ITG3200 Digital 3-Axis Gyroscope I2C driver"
> +	depends on I2C
> +	select IIO_KFIFO_BUF if IIO_BUFFER
> +	help
> +	  Say Y here to add support for the InvenSense ITG3200 digital
> +	  3-axis gyroscope sensor.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called itg3200.
> +
>  endmenu
> diff --git a/drivers/staging/iio/gyro/Makefile b/drivers/staging/iio/gyro/Makefile
> index 9ba5ec1..7567a50 100644
> --- a/drivers/staging/iio/gyro/Makefile
> +++ b/drivers/staging/iio/gyro/Makefile
> @@ -20,3 +20,7 @@ obj-$(CONFIG_ADIS16251) += adis16251.o
>  
>  adxrs450-y             := adxrs450_core.o
>  obj-$(CONFIG_ADXRS450) += adxrs450.o
> +
> +itg3200-y               := itg3200_core.o
> +itg3200-$(CONFIG_IIO_BUFFER) += itg3200_buffer.o itg3200_trigger.o
> +obj-$(CONFIG_ITG3200)   += itg3200.o
> diff --git a/drivers/staging/iio/gyro/itg3200.h b/drivers/staging/iio/gyro/itg3200.h
> new file mode 100644
> index 0000000..a98d37d
> --- /dev/null
> +++ b/drivers/staging/iio/gyro/itg3200.h
> @@ -0,0 +1,161 @@
> +/*
> + * itg3200.h -- support InvenSense ITG3200
> + *              Digital 3-Axis Gyroscope driver
> + *
> + * Copyright (c) 2011 Christian Strobel <christian.strobel@iis.fraunhofer.de>
> + * Copyright (c) 2011 Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
> + * Copyright (c) 2012 Thorsten Nowak <thorsten.nowak@iis.fraunhofer.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef I2C_ITG3200_H_
> +#define I2C_ITG3200_H_
> +
> +#include <linux/iio/iio.h>
> +#include "../ring_sw.h"
> +
> +/* Register with I2C address (34h) */
> +#define ITG3200_REG_ADDRESS             0x00
> +
> +/* Sample rate divider
> + * Range: 0 to 255
> + * Default value: 0x00 */
> +#define ITG3200_REG_SAMPLE_RATE_DIV         0x15
> +
> +/* Digital low pass filter settings */
> +#define ITG3200_REG_DLPF                0x16
> +/* DLPF full scale range */
> +#define ITG3200_DLPF_FS_SEL_2000            0x18
> +/* Bandwidth (Hz) and internal sample rate
> + * (kHz) of DLPF */
> +#define ITG3200_DLPF_256_8              0x00
> +#define ITG3200_DLPF_188_1              0x01
> +#define ITG3200_DLPF_98_1               0x02
> +#define ITG3200_DLPF_42_1               0x03
> +#define ITG3200_DLPF_20_1               0x04
> +#define ITG3200_DLPF_10_1               0x05
> +#define ITG3200_DLPF_5_1                0x06
> +
> +#define ITG3200_DLPF_CFG_MASK               0x07
> +
> +/* Configuration for interrupt operations */
> +#define ITG3200_REG_IRQ_CONFIG              0x17
> +/* Logic level */
> +#define ITG3200_IRQ_ACTIVE_LOW              0x80
> +#define ITG3200_IRQ_ACTIVE_HIGH             0x00
> +/* Drive type */
> +#define ITG3200_IRQ_OPEN_DRAIN              0x40
> +#define ITG3200_IRQ_PUSH_PULL               0x00
> +/* Latch mode */
> +#define ITG3200_IRQ_LATCH_UNTIL_CLEARED         0x20
> +#define ITG3200_IRQ_LATCH_50US_PULSE            0x00
> +/* Latch clear method */
> +#define ITG3200_IRQ_LATCH_CLEAR_ANY         0x10
> +#define ITG3200_IRQ_LATCH_CLEAR_STATUS          0x00
> +/* Enable interrupt when device is ready */
> +#define ITG3200_IRQ_DEVICE_RDY_ENABLE           0x04
> +/* Enable interrupt when data is available */
> +#define ITG3200_IRQ_DATA_RDY_ENABLE         0x01
> +
> +/* Determine the status of ITG-3200 interrupts */
> +#define ITG3200_REG_IRQ_STATUS              0x1A
> +/* Status of 'device is ready'-interrupt */
> +#define ITG3200_IRQ_DEVICE_RDY_STATUS           0x04
> +/* Status of 'data is available'-interrupt */
> +#define ITG3200_IRQ_DATA_RDY_STATUS         0x01
> +
> +/* Sensor registers */
> +#define ITG3200_REG_TEMP_OUT_H              0x1B
> +#define ITG3200_REG_TEMP_OUT_L              0x1C
> +#define ITG3200_REG_GYRO_XOUT_H             0x1D
> +#define ITG3200_REG_GYRO_XOUT_L             0x1E
> +#define ITG3200_REG_GYRO_YOUT_H             0x1F
> +#define ITG3200_REG_GYRO_YOUT_L             0x20
> +#define ITG3200_REG_GYRO_ZOUT_H             0x21
> +#define ITG3200_REG_GYRO_ZOUT_L             0x22
> +
> +/* Power management */
> +#define ITG3200_REG_POWER_MANAGEMENT            0x3E
> +/* Reset device and internal registers to the
> + * power-up-default settings */
> +#define ITG3200_RESET                   0x80
> +/* Enable low power sleep mode */
> +#define ITG3200_SLEEP                   0x40
> +/* Put according gyroscope in standby mode */
> +#define ITG3200_STANDBY_GYRO_X              0x20
> +#define ITG3200_STANDBY_GYRO_Y              0x10
> +#define ITG3200_STANDBY_GYRO_Z              0x08
> +/* Determine the device clock source */
> +#define ITG3200_CLK_INTERNAL                0x00
> +#define ITG3200_CLK_GYRO_X              0x01
> +#define ITG3200_CLK_GYRO_Y              0x02
> +#define ITG3200_CLK_GYRO_Z              0x03
> +#define ITG3200_CLK_EXT_32K             0x04
> +#define ITG3200_CLK_EXT_19M             0x05
> +
> +#define ITG3200_MAX_TX 1
> +#define ITG3200_MAX_RX 16 /* 4 * 16bit + 64bit timestamp */
> +
> +/**
> + * struct itg3200_state - device instance specific data
> + * @i2c:    actual i2c_client
> + * @trig:   data ready trigger registered with iio
> + **/

trigger_on, tx and rx are not documented

> +struct itg3200_state {
> +	struct i2c_client   *i2c;
> +	struct iio_trigger  *trig;
> +	bool            trigger_on;
> +	u8      tx[ITG3200_MAX_TX] ____cacheline_aligned;
> +	__be16      rx[ITG3200_MAX_RX] ____cacheline_aligned;
> +};
> +
> +int itg3200_read_irq_status(struct iio_dev *indio_dev);
> +
> +int itg3200_set_irq_data_rdy(struct iio_dev *indio_dev, bool enable);
> +
> +enum ITG3200_CHANNELS {
> +	ITG3200_TEMP,
> +	ITG3200_GYRO_X,
> +	ITG3200_GYRO_Y,
> +	ITG3200_GYRO_Z,
> +	ITG3200_SCAN_ELEMENTS = 4,
> +};
> +
> +#ifdef CONFIG_IIO_BUFFER
> +
> +void itg3200_remove_trigger(struct iio_dev *indio_dev);
> +int itg3200_probe_trigger(struct iio_dev *indio_dev);
> +
> +int itg3200_buffer_configure(struct iio_dev *indio_dev);
> +void itg3200_buffer_unconfigure(struct iio_dev *indio_dev);
> +
> +#define itg3200_free_buf iio_sw_rb_free
> +#define itg3200_alloc_buf iio_sw_rb_allocate
> +#define itg3200_access_funcs ring_sw_access_funcs
> +
> +#else /* CONFIG_IIO_BUFFER */
> +
> +static inline void itg3200_remove_trigger(struct iio_dev *indio_dev)
> +{
> +}
> +
> +static inline int itg3200_probe_trigger(struct iio_dev *indio_dev)
> +{
> +	return 0;
> +}
> +
> +static inline int itg3200_buffer_configure(struct iio_dev *indio_dev)
> +{
> +	return 0;
> +}
> +
> +static inline void itg3200_buffer_unconfigure(struct iio_dev *indio_dev)
> +{
> +}
> +
> +#endif  /* CONFIG_IIO_RING_BUFFER */
> +
> +#endif /* ITG3200_H_ */
> diff --git a/drivers/staging/iio/gyro/itg3200_buffer.c b/drivers/staging/iio/gyro/itg3200_buffer.c
> new file mode 100644
> index 0000000..07596d3
> --- /dev/null
> +++ b/drivers/staging/iio/gyro/itg3200_buffer.c
> @@ -0,0 +1,171 @@
> +/*
> + * itg3200_ring.c -- support InvenSense ITG3200
> + *                   Digital 3-Axis Gyroscope driver
> + *
> + * Copyright (c) 2011 Christian Strobel <christian.strobel@iis.fraunhofer.de>
> + * Copyright (c) 2011 Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
> + * Copyright (c) 2012 Thorsten Nowak <thorsten.nowak@iis.fraunhofer.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
> +#include <linux/iio/kfifo_buf.h>
> +#include <linux/iio/trigger_consumer.h>
> +
> +#include "itg3200.h"
> +
> +static irqreturn_t itg3200_trigger_handler(int irq, void *p)
> +{
> +	struct iio_poll_func *pf = p;
> +	struct iio_dev *indio_dev = pf->indio_dev;
> +	struct itg3200_state *st = iio_priv(indio_dev);
> +	struct iio_buffer *buffer = indio_dev->buffer;
> +	int len = 0;
> +
> +	/* Clear IRQ */
> +	itg3200_read_irq_status(indio_dev);
> +
> +	if (!bitmap_empty(indio_dev->active_scan_mask, indio_dev->masklength)) {
> +		int ret;
> +		unsigned i, j = 0;
> +		st->tx[0] = 0x80 | ITG3200_REG_TEMP_OUT_H;
> +		ret = i2c_master_send(st->i2c, st->tx, 1);
> +		if (ret != 1)
> +			goto error_ret;
> +
> +		/* Receive all scan elements */
> +		ret = i2c_master_recv(st->i2c, (u8 *)st->rx,
> +				ITG3200_SCAN_ELEMENTS * 2);
> +		if (ret < 0)
> +			goto error_ret;
> +
> +		/* Select only active scan elements */
> +		for (i = 0; i < ITG3200_SCAN_ELEMENTS; i++)
> +			if (iio_scan_mask_query(indio_dev, buffer, i))
> +				st->rx[j++] = st->rx[i];
> +
> +		len = j * sizeof(u16);
> +	}
> +	/* Guaranteed to be aligned with 8 byte boundary */
> +	if (buffer->scan_timestamp)
> +		*(s64 *)(((phys_addr_t)st->rx + len
> +					+ sizeof(s64) - 1) & ~(sizeof(s64) - 1))

*(s64 *)((u8 *)st->rx + ALIGN(len, sizeof(s64)))

> +		= pf->timestamp;
> +	buffer->access->store_to(buffer, (u8 *)st->rx, pf->timestamp);
> +
> +	iio_trigger_notify_done(indio_dev->trig);
> +error_ret:
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> +static int itg3200_ring_postenable(struct iio_dev *indio_dev)
> +{
> +	u8 t;
> +	int ret;
> +
> +	ret = itg3200_spi_read_reg_8(indio_dev,
> +				     ITG3200_REG_POWER_MANAGEMENT,
> +				     &t);
> +	if (ret)
> +		goto error_ret;
> +
> +	if (iio_scan_mask_query(indio_dev->ring, 1))
> +		t &= ~ITG3200_STANDBY_GYRO_X;
> +	else
> +		t |= ~ITG3200_STANDBY_GYRO_X;
> +
> +	if (iio_scan_mask_query(indio_dev->ring, 2))
> +		t &= ~ITG3200_STANDBY_GYRO_Y;
> +	else
> +		t |= ITG3200_STANDBY_GYRO_Y;
> +
> +	if (iio_scan_mask_query(indio_dev->ring, 3))
> +		t &= ITG3200_STANDBY_GYRO_Z;
> +	else
> +		t |= ITG3200_STANDBY_GYRO_Z;
> +
> +	ret = itg3200_spi_write_reg_8(indio_dev,
> +				      ITG3200_REG_POWER_MANAGEMENT,
> +				      t);
> +	if (ret)
> +		goto error_ret;
> +
> +	return iio_triggered_ring_postenable(indio_dev);
> +error_ret:
> +	return ret;
> +}
> +
> +static int itg3200_ring_predisable(struct iio_dev *indio_dev)
> +{
> +	u8 t;
> +	int ret;
> +
> +	ret = iio_triggered_ring_predisable(indio_dev);
> +	if (ret)
> +		goto error_ret;
> +
> +	ret = itg3200_spi_read_reg_8(indio_dev,
> +				     ITG3200_REG_POWER_MANAGEMENT,
> +				     &t);
> +	if (ret)
> +		goto error_ret;
> +	t &= ~(ITG3200_STANDBY_GYRO_X |
> +		ITG3200_STANDBY_GYRO_Y |
> +		ITG3200_STANDBY_GYRO_Z);
> +
> +	ret = itg3200_spi_write_reg_8(indio_dev,
> +		ITG3200_REG_POWER_MANAGEMENT, t);
> +
> +error_ret:
> +	return ret;
> +}
> +*/
> +static const struct iio_buffer_setup_ops itg3200_buffer_setup_ops = {
> +	.preenable = &iio_sw_buffer_preenable,
> +	.postenable = &iio_triggered_buffer_postenable,
> +	.predisable = &iio_triggered_buffer_predisable,
> +};
> +
> +int itg3200_buffer_configure(struct iio_dev *indio_dev)
> +{
> +	int ret = 0;
> +	struct iio_buffer *buffer;
> +
> +	buffer = iio_kfifo_allocate(indio_dev);
> +	if (!buffer)
> +		return -ENOMEM;
> +
> +	/* buffer->access = &kfifo_access_funcs; */
> +	indio_dev->buffer = buffer;
> +	indio_dev->setup_ops = &itg3200_buffer_setup_ops;
> +	indio_dev->pollfunc = iio_alloc_pollfunc(&iio_pollfunc_store_time,
> +			&itg3200_trigger_handler, IRQF_ONESHOT,
> +			indio_dev, "itg3200_consumer%d", indio_dev->id);

maybe iio_triggered_buffer_setup() can be used?

> +	if (!indio_dev->pollfunc) {
> +		ret = -ENOMEM;
> +		goto error_free_buffer;
> +	}
> +
> +	indio_dev->modes |= INDIO_BUFFER_TRIGGERED;
> +	return 0;
> +
> +error_free_buffer:
> +	iio_kfifo_free(indio_dev->buffer);
> +	return ret;
> +}
> +
> +void itg3200_buffer_unconfigure(struct iio_dev *indio_dev)
> +{
> +	iio_dealloc_pollfunc(indio_dev->pollfunc);
> +	iio_kfifo_free(indio_dev->buffer);
> +}
> diff --git a/drivers/staging/iio/gyro/itg3200_core.c b/drivers/staging/iio/gyro/itg3200_core.c
> new file mode 100644
> index 0000000..0096b38
> --- /dev/null
> +++ b/drivers/staging/iio/gyro/itg3200_core.c
> @@ -0,0 +1,592 @@
> +/*
> + * itg3200_core.c -- support InvenSense ITG3200
> + *                   Digital 3-Axis Gyroscope driver
> + *
> + * Copyright (c) 2011 Christian Strobel <christian.strobel@iis.fraunhofer.de>
> + * Copyright (c) 2011 Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
> + * Copyright (c) 2012 Thorsten Nowak <thorsten.nowak@iis.fraunhofer.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#define DEBUG
> +
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/i2c.h>
> +#include <linux/gpio.h>
> +#include <linux/slab.h>
> +#include <linux/stat.h>
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
> +#include <linux/iio/events.h>
> +#include <linux/iio/buffer.h>
> +
> +#include "itg3200.h"
> +
> +/* Copied from: linux-source-3.2/arch/arm/plat-omap/include/plat/gpio.h */
> +/* Wrappers for "new style" GPIO calls, using the new infrastructure
> + * which lets us plug in FPGA, I2C, and other implementations.
> + * *
> + * The original OMAP-specific calls should eventually be removed.
> + */
> +
> +#include <linux/errno.h>
> +#include <asm-generic/gpio.h>
> +
> +static inline int irq_to_gpio(unsigned irq)
> +{
> +	int tmp;
> +
> +	/* omap1 SOC mpuio */
> +	if (cpu_class_is_omap1() && (irq < (IH_MPUIO_BASE + 16)))
> +		return (irq - IH_MPUIO_BASE) + OMAP_MAX_GPIO_LINES;
> +
> +	/* SOC gpio */
> +	tmp = irq - IH_GPIO_BASE;
> +	if (tmp < OMAP_MAX_GPIO_LINES)
> +		return tmp;
> +
> +	/* we don't supply reverse mappings for non-SOC gpios */
> +	return -EIO;
> +}

irq_to_gpio() is doomed, no?
shouldn't the gpio be passed to the driver and then mapped to an irq with 
gpio_to_irq()?

> +
> +
> +static int itg3200_write_reg_8(struct iio_dev *indio_dev,
> +		u8 reg_address, u8 val)
> +{
> +	struct itg3200_state *st = iio_priv(indio_dev);
> +	int ret;
> +
> +	u8 buf[2];
> +
> +	buf[0] = 0x80 | reg_address;
> +	buf[1] = val;
> +
> +	ret = i2c_master_send(st->i2c, buf, sizeof(buf));
> +
> +	return (ret == sizeof(buf)) ? 0 : ret;
> +}
> +
> +static int itg3200_read_reg_8(struct iio_dev *indio_dev,
> +		u8 reg_address, u8 *val)
> +{
> +	struct itg3200_state *st = iio_priv(indio_dev);
> +	struct i2c_client *client = st->i2c;
> +	int ret;
> +
> +	struct i2c_msg msg[2];
> +
> +	msg[0].addr = client->addr;
> +	msg[0].flags = client->flags & I2C_M_TEN;
> +	msg[0].len = 1;
> +	msg[0].buf = (char *)&reg_address;
> +
> +	msg[1].addr = client->addr;
> +	msg[1].flags = client->flags & I2C_M_TEN;
> +	msg[1].flags |= I2C_M_RD;
> +	msg[1].len = 1;
> +	msg[1].buf = (char *)val;
> +
> +	reg_address |= 0x80;
> +	ret = i2c_transfer(client->adapter, msg, 2);
> +	return (ret == 2) ? 0 : ret;
> +}
> +
> +static int itg3200_read_reg_s16(struct iio_dev *indio_dev, u8 lower_reg_address,
> +		int *val)
> +{
> +	struct itg3200_state *st = iio_priv(indio_dev);
> +	struct i2c_client *client = st->i2c;
> +	int ret;
> +	s16 out;
> +
> +	struct i2c_msg msg[2];
> +
> +	msg[0].addr = client->addr;
> +	msg[0].flags = client->flags & I2C_M_TEN;
> +	msg[0].len = 1;
> +	msg[0].buf = (char *)&lower_reg_address;
> +
> +	msg[1].addr = client->addr;
> +	msg[1].flags = client->flags & I2C_M_TEN;
> +	msg[1].flags |= I2C_M_RD;
> +	msg[1].len = 2;
> +	msg[1].buf = (char *)&out;
> +
> +	lower_reg_address |= 0x80;
> +	ret = i2c_transfer(client->adapter, msg, 2);
> +	be16_to_cpus(&out);
> +	*val = out;
> +
> +	return (ret == 2) ? 0 : ret;
> +}
> +
> +static int itg3200_read_raw(struct iio_dev *indio_dev,
> +		struct iio_chan_spec const *chan,
> +		int *val, int *val2, long mask)
> +{
> +	ssize_t ret = 0;
> +	u8 reg;
> +
> +	switch (mask) {
> +	case 0:
> +		reg = (u8)chan->address;
> +		/* Take the iio_dev status lock */
> +		mutex_lock(&indio_dev->mlock);
> +		ret = itg3200_read_reg_s16(indio_dev, reg, val);
> +		mutex_unlock(&indio_dev->mlock);
> +		return IIO_VAL_INT;
> +	case IIO_CHAN_INFO_SCALE:
> +		*val = 0;
> +		if (chan->scan_index == ITG3200_TEMP)
> +			*val2 = 1000000000/280;
> +		else
> +			*val2 = 1214142;
> +		return IIO_VAL_INT_PLUS_NANO;
> +	case IIO_CHAN_INFO_OFFSET:
> +		if (chan->scan_index == ITG3200_TEMP)
> +			*val = 13200;
> +		return IIO_VAL_INT;
> +	}
> +
> +	return ret;
> +}
> +
> +static ssize_t itg3200_read_frequency(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	int ret, len = 0;
> +	u8 val;
> +	int sps;
> +
> +	ret = itg3200_read_reg_8(indio_dev, ITG3200_REG_DLPF, &val);
> +	if (ret)
> +		return ret;
> +
> +	sps = (val & ITG3200_DLPF_CFG_MASK) ? 1000 : 8000;
> +
> +	ret = itg3200_read_reg_8(indio_dev, ITG3200_REG_SAMPLE_RATE_DIV, &val);
> +	if (ret)
> +		return ret;
> +
> +	sps /= val + 1;
> +
> +	len = sprintf(buf, "%d\n", sps);
> +	return len;
> +}
> +
> +static ssize_t itg3200_write_frequency(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf,
> +		size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	long val;
> +	int ret;
> +	u8 t;
> +
> +	ret = kstrtol(buf, 10, &val);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&indio_dev->mlock);
> +
> +	ret = itg3200_read_reg_8(indio_dev, ITG3200_REG_DLPF, &t);
> +	if (ret)
> +		goto err_ret;
> +
> +	t = ((t & ITG3200_DLPF_CFG_MASK) ? 1000 : 8000) / val - 1;
> +
> +	ret = itg3200_write_reg_8(indio_dev, ITG3200_REG_SAMPLE_RATE_DIV, t);
> +
> +err_ret:
> +	mutex_unlock(&indio_dev->mlock);
> +
> +	return ret ? ret : len;
> +}
> +
> +int itg3200_read_irq_status(struct iio_dev *indio_dev)
> +{
> +	u8 val;
> +	int ret;
> +
> +	ret = itg3200_read_reg_8(indio_dev, ITG3200_REG_IRQ_STATUS, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	return val;
> +}
> +
> +int itg3200_set_irq_data_rdy(struct iio_dev *indio_dev, bool enable)
> +{
> +	struct itg3200_state *st = iio_priv(indio_dev);
> +	int ret;
> +	u8 msc;
> +
> +	dev_dbg(&st->i2c->dev, "set data ready %s", enable ? "on" : "off");
> +
> +	ret = itg3200_read_reg_8(indio_dev, ITG3200_REG_IRQ_CONFIG, &msc);
> +	if (ret)
> +		goto error_ret;
> +
> +	if (enable)
> +		msc |= ITG3200_IRQ_DATA_RDY_ENABLE;
> +	else
> +		msc &= ~ITG3200_IRQ_DATA_RDY_ENABLE;
> +
> +	ret = itg3200_write_reg_8(indio_dev, ITG3200_REG_IRQ_CONFIG, msc);
> +	if (ret)
> +		goto error_ret;
> +
> +error_ret:
> +	return ret;
> +}
> +
> +/* Power down the device */
> +static int itg3200_stop_device(struct iio_dev *indio_dev)
> +{
> +	struct itg3200_state *st = iio_priv(indio_dev);
> +	int ret;
> +
> +	dev_dbg(&st->i2c->dev, "suspend device");
> +
> +	/* Set device in low power mode */
> +	ret = itg3200_write_reg_8(indio_dev,
> +			ITG3200_REG_POWER_MANAGEMENT,
> +			ITG3200_SLEEP);
> +
> +	if (ret)
> +		dev_err(&st->i2c->dev, "problem with turning device off: SLEEP");
> +
> +	return 0;
> +}
> +
> +/* Reset device and internal registers to the power-up-default settings
> + * Use the gyro clock as reference, as suggested by the datasheet */
> +static int itg3200_reset(struct iio_dev *indio_dev)
> +{
> +	struct itg3200_state *st = iio_priv(indio_dev);
> +	int ret;
> +
> +	dev_dbg(&st->i2c->dev, "reset device");
> +
> +	ret = itg3200_write_reg_8(indio_dev,
> +			ITG3200_REG_POWER_MANAGEMENT,
> +			ITG3200_RESET);
> +	if (ret) {
> +		dev_err(&st->i2c->dev, "error resetting device");
> +		goto error_ret;
> +	}
> +
> +	/* Wait for PLL (1ms according to datasheet) */
> +	udelay(1500);
> +
> +	ret = itg3200_write_reg_8(indio_dev,
> +			ITG3200_REG_IRQ_CONFIG,
> +			ITG3200_IRQ_LATCH_50US_PULSE |
> +			ITG3200_IRQ_LATCH_CLEAR_ANY |
> +			ITG3200_IRQ_DEVICE_RDY_ENABLE |
> +			ITG3200_IRQ_DATA_RDY_ENABLE);
> +
> +	if (ret)
> +		dev_err(&st->i2c->dev, "error init device");
> +
> +error_ret:
> +	return ret;
> +}
> +
> +static ssize_t itg3200_write_reset(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	int ret = -EINVAL;
> +	if (len < 1)
> +		goto error_ret;
> +
> +	switch (buf[0]) {
> +	case '1':
> +	case 'y':
> +	case 'Y':
> +		ret = itg3200_reset(indio_dev);
> +		if (ret < 0)
> +			goto error_ret;
> +		return len;
> +	}
> +error_ret:
> +	return ret;
> +}
> +
> +static int itg3200_enable_full_scale(struct iio_dev *indio_dev)
> +{
> +	u8 val;
> +	int ret;
> +
> +	ret = itg3200_read_reg_8(indio_dev, ITG3200_REG_DLPF, &val);
> +	if (ret)
> +		goto err_ret;
> +
> +	val |= ITG3200_DLPF_FS_SEL_2000;
> +	return itg3200_write_reg_8(indio_dev, ITG3200_REG_DLPF, val);
> +
> +err_ret:
> +	return ret;
> +}
> +
> +static int itg3200_initial_setup(struct iio_dev *indio_dev)
> +{
> +	struct itg3200_state *st = iio_priv(indio_dev);
> +	int ret;
> +
> +	u8 val;
> +	ret = itg3200_read_reg_8(indio_dev, ITG3200_REG_ADDRESS, &val);
> +	if (ret)
> +		goto err_ret;
> +
> +	if (((val >> 1) & 0x3f) != 0x34) {
> +		dev_err(&st->i2c->dev, "invalid reg value 0x%02x", val);
> +		/*
> +		ret = -EINVAL;
> +		goto err_ret;
> +		*/
> +	}
> +
> +	ret = itg3200_reset(indio_dev);
> +	if (ret)
> +		goto err_ret;
> +
> +	ret = itg3200_enable_full_scale(indio_dev);
> +
> +err_ret:
> +	return ret;
> +}
> +
> +#define ITG3200_TEMP_INFO_MASK	(IIO_CHAN_INFO_OFFSET_SHARED_BIT | \
> +				 IIO_CHAN_INFO_SCALE_SHARED_BIT)
> +#define ITG3200_INFO_MASK	IIO_CHAN_INFO_SCALE_SHARED_BIT
> +
> +#define ITG3200_ST						\
> +	{ .sign = 's', .realbits = 16, .storagebits = 16, .endianness = IIO_BE }
> +
> +static const struct iio_chan_spec itg3200_channels[] = {
> +	{
> +		.type = IIO_TEMP,
> +		.output = 0,
> +		.modified = 0,
> +		.indexed = 0,
> +		.extend_name = NULL,
> +		.channel = 0,
> +		.channel2 = IIO_NO_MOD,
> +		.info_mask = ITG3200_TEMP_INFO_MASK,
> +		.address = ITG3200_REG_TEMP_OUT_H,
> +		.scan_index = ITG3200_TEMP,
> +		.scan_type = ITG3200_ST,
> +		.event_mask = 0
> +	},
> +	{
> +		.type = IIO_ANGL_VEL,
> +		.output = 0,
> +		.modified = 1,
> +		.indexed = 0,
> +		.extend_name = NULL,
> +		.channel = 0,
> +		.channel2 = IIO_MOD_X,
> +		.info_mask = ITG3200_INFO_MASK,
> +		.address = ITG3200_REG_GYRO_XOUT_H,
> +		.scan_index = ITG3200_GYRO_X,
> +		.scan_type = ITG3200_ST,
> +		.event_mask = 0
> +	},
> +	{
> +		.type = IIO_ANGL_VEL,
> +		.output = 0,
> +		.modified = 1,
> +		.indexed = 0,
> +		.extend_name = NULL,
> +		.channel = 0,
> +		.channel2 = IIO_MOD_Y,
> +		.info_mask = ITG3200_INFO_MASK,
> +		.address = ITG3200_REG_GYRO_YOUT_H,
> +		.scan_index = ITG3200_GYRO_Y,
> +		.scan_type = ITG3200_ST,
> +		.event_mask = 0
> +	},
> +	{
> +		.type = IIO_ANGL_VEL,
> +		.output = 0,
> +		.modified = 1,
> +		.indexed = 0,
> +		.extend_name = NULL,
> +		.channel = 0,
> +		.channel2 = IIO_MOD_Z,
> +		.info_mask = ITG3200_INFO_MASK,
> +		.address = ITG3200_REG_GYRO_ZOUT_H,
> +		.scan_index = ITG3200_GYRO_Z,
> +		.scan_type = ITG3200_ST,
> +		.event_mask = 0
> +	},
> +	IIO_CHAN_SOFT_TIMESTAMP(4),
> +};
> +
> +/* IIO device attributes */
> +static IIO_DEV_ATTR_SAMP_FREQ(S_IWUSR | S_IRUGO, itg3200_read_frequency,
> +		itg3200_write_frequency);
> +
> +static IIO_DEVICE_ATTR(reset, S_IWUSR, NULL, itg3200_write_reset, 0);
> +
> +static struct attribute *itg3200_attributes[] = {
> +	&iio_dev_attr_sampling_frequency.dev_attr.attr,
> +	&iio_dev_attr_reset.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group itg3200_attribute_group = {
> +	.attrs = itg3200_attributes,
> +};
> +
> +static const struct iio_info itg3200_info = {
> +	.read_raw = &itg3200_read_raw,
> +	/*
> +	.write_raw = &itg3200_write_raw,
> +	.read_event_value = &itg3200_read_thresh,
> +	.write_event_value = &itg3200_write_thresh,
> +	.write_event_config = &itg3200_write_event_config,
> +	.read_event_config = &itg3200_read_event_config,
> +	*/
> +	.driver_module = THIS_MODULE,
> +	.attrs = &itg3200_attribute_group,
> +};
> +
> +static int __devinit itg3200_probe(struct i2c_client *client,
> +		const struct i2c_device_id *id)
> +{
> +	int ret = 0;
> +	struct itg3200_state *st;
> +	struct iio_dev *indio_dev;
> +
> +	dev_dbg(&client->dev, "probe I2C dev with IRQ %i", client->irq);
> +
> +	indio_dev = iio_device_alloc(sizeof(*st));
> +	if (indio_dev == NULL) {
> +		ret =  -ENOMEM;
> +		goto error_ret;
> +	}
> +
> +	st = iio_priv(indio_dev);
> +
> +	i2c_set_clientdata(client, indio_dev);
> +	st->i2c = client;
> +
> +	indio_dev->dev.parent = &client->dev;
> +	indio_dev->name = client->dev.driver->name;
> +	indio_dev->channels = itg3200_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(itg3200_channels);
> +	indio_dev->info = &itg3200_info;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +
> +	ret = itg3200_buffer_configure(indio_dev);
> +	if (ret)
> +		goto error_free_dev;
> +
> +	ret = iio_buffer_register(indio_dev,
> +			indio_dev->channels,
> +			ARRAY_SIZE(itg3200_channels));
> +	if (ret)
> +		goto error_unconfigure_buffer;
> +
> +	if (client->irq && gpio_is_valid(irq_to_gpio(client->irq)) > 0) {
> +		ret = itg3200_probe_trigger(indio_dev);
> +		if (ret)
> +			goto error_unregister_buffer;
> +	}

the lis3l02dq iio driver uses this as well and fails to compile due to 
irq_to_gpio() with certain configurations

> +
> +	ret = itg3200_initial_setup(indio_dev);
> +	if (ret)
> +		goto error_remove_trigger;
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret)
> +		goto error_remove_trigger;
> +
> +	return 0;
> +
> +error_remove_trigger:
> +	if (client->irq && gpio_is_valid(irq_to_gpio(client->irq)) > 0)
> +		itg3200_remove_trigger(indio_dev);
> +error_unregister_buffer:
> +	iio_buffer_unregister(indio_dev);
> +error_unconfigure_buffer:
> +	itg3200_buffer_unconfigure(indio_dev);
> +error_free_dev:
> +	iio_device_free(indio_dev);
> +error_ret:
> +	return ret;
> +}
> +
> +static int itg3200_remove(struct i2c_client *client)
> +{
> +	/* int ret; */
> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> +
> +	iio_device_unregister(indio_dev);
> +
> +	/*
> +	ret = itg3200_stop_device(indio_dev);
> +	if (ret)
> +		goto err_ret;
> +	*/
> +
> +	if (client->irq && gpio_is_valid(irq_to_gpio(client->irq)) > 0)
> +		itg3200_remove_trigger(indio_dev);
> +
> +	iio_buffer_unregister(indio_dev);
> +	itg3200_buffer_unconfigure(indio_dev);
> +
> +	iio_device_free(indio_dev);
> +
> +	return 0;
> +
> +	/*
> +	err_ret:
> +	    return ret;
> +	*/
> +}
> +
> +static const struct i2c_device_id itg3200_id[] = {
> +	{ "itg3200", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, itg3200_id);
> +
> +static struct i2c_driver itg3200_driver = {
> +	.driver = {
> +		.owner  = THIS_MODULE,
> +		.name	= "itg3200",
> +	},
> +	.id_table	= itg3200_id,
> +	.probe		= itg3200_probe,
> +	.remove		= itg3200_remove,
> +};
> +
> +static int __init itg3200_init(void)
> +{
> +	return i2c_add_driver(&itg3200_driver);
> +}
> +module_init(itg3200_init);
> +
> +static void __exit itg3200_exit(void)
> +{
> +	i2c_del_driver(&itg3200_driver);
> +}
> +module_exit(itg3200_exit);
> +
> +MODULE_AUTHOR("Christian Strobel <christian.strobel@iis.fraunhofer.de>");
> +MODULE_DESCRIPTION("ITG3200 Gyroscope I2C driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/staging/iio/gyro/itg3200_trigger.c b/drivers/staging/iio/gyro/itg3200_trigger.c
> new file mode 100644
> index 0000000..18f10a2
> --- /dev/null
> +++ b/drivers/staging/iio/gyro/itg3200_trigger.c
> @@ -0,0 +1,90 @@
> +/*
> + * itg3200_trigger.c -- support InvenSense ITG3200
> + *                      Digital 3-Axis Gyroscope driver
> + *
> + * Copyright (c) 2011 Christian Strobel <christian.strobel@iis.fraunhofer.de>
> + * Copyright (c) 2011 Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
> + * Copyright (c) 2012 Thorsten Nowak <thorsten.nowak@iis.fraunhofer.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +
> +#include <linux/iio/iio.h>
> +#include <linux/iio/trigger.h>
> +
> +#include "itg3200.h"
> +
> +static irqreturn_t itg3200_data_rdy_trig_poll(int irq, void *private)
> +{
> +	struct iio_dev *indio_dev = private;
> +	struct itg3200_state *st = iio_priv(indio_dev);
> +
> +	iio_trigger_poll(st->trig, iio_get_time_ns());
> +	return IRQ_HANDLED;
> +}
> +
> +/**
> + * itg3200_data_rdy_trigger_set_state() set datardy interrupt state
> + */
> +static int itg3200_data_rdy_trigger_set_state(struct iio_trigger *trig,
> +	bool state)
> +{
> +	struct iio_dev *indio_dev = trig->private_data;
> +	return itg3200_set_irq_data_rdy(indio_dev, state);
> +}
> +
> +static const struct iio_trigger_ops itg3200_trigger_ops = {
> +	.owner = THIS_MODULE,
> +	.set_trigger_state = &itg3200_data_rdy_trigger_set_state,
> +};
> +
> +int itg3200_probe_trigger(struct iio_dev *indio_dev)
> +{
> +	int ret;
> +	struct itg3200_state *st = iio_priv(indio_dev);
> +
> +	ret = request_irq(st->i2c->irq, &itg3200_data_rdy_trig_poll,
> +			IRQF_TRIGGER_HIGH, "itg3200_data_rdy", indio_dev);
> +	if (ret)
> +		goto error_ret;
> +
> +	st->trig = iio_trigger_alloc("itg3200-dev%d", indio_dev->id);
> +	if (!st->trig) {
> +		ret = -ENOMEM;
> +		goto error_free_irq;
> +	}
> +
> +	st->trig->dev.parent = &st->i2c->dev;
> +	st->trig->ops = &itg3200_trigger_ops;
> +	st->trig->private_data = indio_dev;
> +	ret = iio_trigger_register(st->trig);
> +	if (ret)
> +		goto error_free_trig;
> +
> +	/* select default trigger */
> +	indio_dev->trig = st->trig;
> +
> +	return 0;
> +
> +error_free_trig:
> +	iio_trigger_free(st->trig);
> +error_free_irq:
> +	free_irq(st->i2c->irq, indio_dev);
> +error_ret:
> +	return ret;
> +}
> +
> +void itg3200_remove_trigger(struct iio_dev *indio_dev)
> +{
> +	struct itg3200_state *st = iio_priv(indio_dev);
> +
> +	iio_trigger_unregister(st->trig);
> +	iio_trigger_free(st->trig);
> +	free_irq(st->i2c->irq, indio_dev);
> +}
> 

-- 

Peter Meerwald
+43-664-2444418 (mobile)
