Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab1BNLsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:48:45 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:57946 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab1BNLsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:48:42 -0500
X-IronPort-AV: E=Sophos;i="4.60,468,1291611600"; 
   d="scan'208";a="28684117"
Message-ID: <4D5914A8.9030809@analog.com>
Date: Mon, 14 Feb 2011 12:40:24 +0100
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: "Cai, Cliff" <Cliff.Cai@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: test <test@analog.com>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drivers <Drivers@analog.com>, "Cai, Cliff" <Cliff.Cai@analog.com>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [Device-drivers-devel] [PATCH] IIO driver for Analog Devices
 Digital Output Gyroscope ADXRS450
References: <1297676849-28704-1-git-send-email-test@ten.analog.com>
In-Reply-To: <1297676849-28704-1-git-send-email-test@ten.analog.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cliff,

Exposing every single register to user space is not an acceptable driver.
Ideally a user of this driver doesn't need to read the datasheet, only
the IIO ABI Documentation.
This driver can also benefit from triggered sampling/ring buffer support.

please see comments below.

On 02/14/2011 10:47 AM, test wrote:
> From: Cliff Cai <cliff.cai@analog.com>
>
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> ---
>  drivers/staging/iio/gyro/Kconfig         |   10 +
>  drivers/staging/iio/gyro/Makefile        |    3 +
>  drivers/staging/iio/gyro/adxrs450.h      |   48 +++
>  drivers/staging/iio/gyro/adxrs450_core.c |  471 ++++++++++++++++++++++++++++++
>  4 files changed, 532 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/iio/gyro/adxrs450.h
>  create mode 100644 drivers/staging/iio/gyro/adxrs450_core.c
>
> diff --git a/drivers/staging/iio/gyro/Kconfig b/drivers/staging/iio/gyro/Kconfig
> index 236f15f..3432967 100644
> --- a/drivers/staging/iio/gyro/Kconfig
> +++ b/drivers/staging/iio/gyro/Kconfig
> @@ -45,3 +45,13 @@ config ADIS16251
>
>           This driver can also be built as a module.  If so, the module
>           will be called adis16251.
> +
> +config ADXRS450
> +       tristate "Analog Devices ADXRS450 Digital Output Gyroscope SPI driver"
> +       depends on SPI
> +       help
> +         Say yes here to build support for Analog Devices ADXRS450 programmable
> +         digital output gyroscope.
> +
> +         This driver can also be built as a module.  If so, the module
> +         will be called adxrs450.
> diff --git a/drivers/staging/iio/gyro/Makefile b/drivers/staging/iio/gyro/Makefile
> index 2764c15..2212240 100644
> --- a/drivers/staging/iio/gyro/Makefile
> +++ b/drivers/staging/iio/gyro/Makefile
> @@ -17,3 +17,6 @@ obj-$(CONFIG_ADIS16260) += adis16260.o
>
>  adis16251-y             := adis16251_core.o
>  obj-$(CONFIG_ADIS16251) += adis16251.o
> +
> +adxrs450-y             := adxrs450_core.o
> +obj-$(CONFIG_ADXRS450) += adxrs450.o
> diff --git a/drivers/staging/iio/gyro/adxrs450.h b/drivers/staging/iio/gyro/adxrs450.h
> new file mode 100644
> index 0000000..5d8566a
> --- /dev/null
> +++ b/drivers/staging/iio/gyro/adxrs450.h
> @@ -0,0 +1,48 @@
> +#ifndef SPI_ADXRS450_H_
> +#define SPI_ADXRS450_H_
> +
> +#define ADXRS450_STARTUP_DELAY 50 /* ms */
> +
> +/* The MSB for the spi commands */
> +#define ADXRS450_SENSOR_DATA    (0x2 << 27 | 0x1)
> +#define ADXRS450_READ_REG(a)    ((0x20 << 26) | (a << 17) | 0x1)
> +#define ADXRS450_WRITE_REG(a, value) \
> +               ((0x10 << 26) | (a << 17) | (value << 1) | 0x1)
> +
> +#define ADXRS450_RATE1 0x00    /* Rate Registers */
> +#define ADXRS450_TEMP1 0x02    /* Temperature Registers */
> +#define ADXRS450_LOCST1        0x04    /* Low CST Memory Registers */
> +#define ADXRS450_HICST1        0x06    /* High CST Memory Registers */
> +#define ADXRS450_QUAD1 0x08    /* Quad Memory Registers */
> +#define ADXRS450_FAULT1        0x0A    /* Fault Registers */
> +#define ADXRS450_PID1  0x0C    /* Part ID Registers */
> +#define ADXRS450_SNH   0x0E    /* Serial Number Registers, 4 bytes */
> +#define ADXRS450_SNL   0x10
> +#define ADXRS450_DNC1  0x12    /* Dynamic Null Correction Registers */
> +
> +#define ADXRS450_WRERR_MASK    (0x7 << 29)
> +
> +#define ADXRS450_MAX_RX 1
> +#define ADXRS450_MAX_TX 1
> +
> +#define ADXRS450_SPI_SLOW      (u32)(300 * 1000)
> +#define ADXRS450_SPI_FAST      (u32)(2000 * 1000)
> +#define ADXRS450_GET_ST(a)     ((a >> 26) & 0x3)
> +
> +/**
> + * struct adxrs450_state - device instance specific data
> + * @us:                        actual spi_device
> + * @indio_dev:         industrial I/O device structure
> + * @tx:                        transmit buffer
> + * @rx:                        recieve buffer
> + * @buf_lock:          mutex to protect tx and rx
> + **/
> +struct adxrs450_state {
> +       struct spi_device               *us;
> +       struct iio_dev                  *indio_dev;
> +       u32                             *tx;
> +       u32                             *rx;
> +       struct mutex                    buf_lock;
> +};
> +
> +#endif /* SPI_ADXRS450_H_ */
> diff --git a/drivers/staging/iio/gyro/adxrs450_core.c b/drivers/staging/iio/gyro/adxrs450_core.c
> new file mode 100644
> index 0000000..4feb653
> --- /dev/null
> +++ b/drivers/staging/iio/gyro/adxrs450_core.c
> @@ -0,0 +1,471 @@
> +/*
> + * ADXRS450 Digital Output Gyroscope Driver
> + *
> + * Copyright 2010 Analog Devices Inc.
> + *
> + * Licensed under the GPL-2 or later.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/gpio.h>
> +#include <linux/delay.h>
> +#include <linux/mutex.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/spi/spi.h>
> +#include <linux/slab.h>
> +#include <linux/sysfs.h>
> +#include <linux/list.h>
> +
> +#include "../iio.h"
> +#include "../sysfs.h"
> +#include "gyro.h"
> +#include "../adc/adc.h"
> +
> +#include "adxrs450.h"
> +
> +#define DRIVER_NAME            "adxrs450"
> +
> +/* ADXRS450 only support 32-bit spi transfer, all the registers are read only */
> +
> +
> +/**
> + * adxrs450_spi_read_reg_16() - read 2 bytes from a register pair
> + * @dev: device associated with child of actual device (iio_dev or iio_trig)
> + * @reg_address: the address of the lower of the two registers,which should be an even address,
> + * Second register's address is reg_address + 1.
> + * @val: somewhere to pass back the value read
> + **/
> +static int adxrs450_spi_read_reg_16(struct device *dev,
> +               u8 reg_address,
> +               u16 *val)
> +{
> +       struct spi_message msg;
> +       struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +       struct adxrs450_state *st = iio_dev_get_devdata(indio_dev);
> +       int ret;
>   
> +       struct spi_transfer xfers[] = {
> +               {
> +                       .tx_buf = st->tx,
> +                       .bits_per_word = 32,
> +                       .len = 4,
> +                       .cs_change = 1,
> +               }, {
> +                       .rx_buf = st->rx,
> +                       .bits_per_word = 32,
> +                       .len = 4,
> +                       .cs_change = 1,
>   
I don't think you want cs_change = 1 in the last transfer of an message!
It'll cause bad behavior, since cs_will be asserted after the message
finishes.

> +               },
> +       };
> +
> +       mutex_lock(&st->buf_lock);
> +       st->tx[0] = ADXRS450_READ_REG(reg_address);
>   
Endianess?

Please make sure that this driver works on both LE/BE

> +       spi_message_init(&msg);
> +       spi_message_add_tail(&xfers[0], &msg);
> +       spi_message_add_tail(&xfers[1], &msg);
> +       ret = spi_sync(st->us, &msg);
> +       if (ret) {
> +               dev_err(&st->us->dev, "problem while reading 16 bit register 0x%02x\n",
> +                               reg_address);
> +               goto error_ret;
> +       }
> +       *val = (st->rx[0] >> 5);
> +
> +error_ret:
> +       mutex_unlock(&st->buf_lock);
> +       return ret;
> +}
> +
> +/**
> + * adxrs450_spi_sensor_data() - read 2 bytes sensor data
> + * @dev: device associated with child of actual device (iio_dev or iio_trig)
> + * @val: somewhere to pass back the value read
> + **/
> +static int adxrs450_spi_sensor_data(struct device *dev,
> +               u32 *val, char chk)
> +{
> +       struct spi_message msg;
> +       struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +       struct adxrs450_state *st = iio_dev_get_devdata(indio_dev);
> +       int ret;
> +       struct spi_transfer xfers[] = {
> +               {
> +                       .tx_buf = st->tx,
> +                       .bits_per_word = 32,
> +                       .len = 4,
> +                       .cs_change = 1,
> +               }, {
> +                       .rx_buf = st->rx,
> +                       .bits_per_word = 32,
> +                       .len = 4,
> +                       .cs_change = 1,
> +               },
> +       };
> +
> +       mutex_lock(&st->buf_lock);
> +       st->tx[0] = ADXRS450_SENSOR_DATA;
> +       if (chk)
> +               st->tx[0] |= 0x2;
> +       spi_message_init(&msg);
> +       spi_message_add_tail(&xfers[0], &msg);
> +       spi_message_add_tail(&xfers[1], &msg);
> +       ret = spi_sync(st->us, &msg);
> +       if (ret) {
> +               dev_err(&st->us->dev, "problem while reading sensor data\n");
> +               goto error_ret;
> +       }
> +
> +       *val = st->rx[0];
> +
> +error_ret:
> +       mutex_unlock(&st->buf_lock);
> +       return ret;
> +}
> +
> +static ssize_t adxrs450_read_rate(struct device *dev,
> +               struct device_attribute *attr,
> +               char *buf)
> +{
> +       int ret, len = 0;
> +       u16 t;
> +       ret = adxrs450_spi_read_reg_16(dev,
> +                       ADXRS450_RATE1,
> +                       &t);
> +       if (ret)
> +               return ret;
> +       len = sprintf(buf, "%d\n", t);
> +       return len;
> +}
> +
> +static ssize_t adxrs450_read_temp(struct device *dev,
> +               struct device_attribute *attr,
> +               char *buf)
> +{
> +       int ret, len = 0;
> +       u16 t;
> +       ret = adxrs450_spi_read_reg_16(dev,
> +                       ADXRS450_TEMP1,
> +                       &t);
> +       if (ret)
> +               return ret;
> +       len = sprintf(buf, "%d\n", t);
> +       return len;
> +}
> +
> +static ssize_t adxrs450_read_locst(struct device *dev,
> +               struct device_attribute *attr,
> +               char *buf)
> +{
> +       int ret, len = 0;
> +       u16 t;
> +       ret = adxrs450_spi_read_reg_16(dev,
> +                       ADXRS450_LOCST1,
> +                       &t);
> +       if (ret)
> +               return ret;
> +       len = sprintf(buf, "%d\n", t);
> +       return len;
> +}
> +
> +static ssize_t adxrs450_read_hicst(struct device *dev,
> +               struct device_attribute *attr,
> +               char *buf)
> +{
> +       int ret, len = 0;
> +       u16 t;
> +       ret = adxrs450_spi_read_reg_16(dev,
> +                       ADXRS450_HICST1,
> +                       &t);
> +       if (ret)
> +               return ret;
> +       len = sprintf(buf, "%d\n", t);
> +       return len;
> +}
> +
> +static ssize_t adxrs450_read_quad(struct device *dev,
> +               struct device_attribute *attr,
> +               char *buf)
> +{
> +       int ret, len = 0;
> +       u16 t;
> +       ret = adxrs450_spi_read_reg_16(dev,
> +                       ADXRS450_QUAD1,
> +                       &t);
> +       if (ret)
> +               return ret;
> +       len = sprintf(buf, "%d\n", t);
> +       return len;
> +}
> +
> +static ssize_t adxrs450_read_fault(struct device *dev,
> +               struct device_attribute *attr,
> +               char *buf)
> +{
> +       int ret, len = 0;
> +       u16 t;
> +       ret = adxrs450_spi_read_reg_16(dev,
> +                       ADXRS450_FAULT1,
> +                       &t);
> +       if (ret)
> +               return ret;
> +       len = sprintf(buf, "%d\n", t);
> +       return len;
> +}
> +
> +static ssize_t adxrs450_read_pid(struct device *dev,
> +               struct device_attribute *attr,
> +               char *buf)
> +{
> +       int ret, len = 0;
> +       u16 t;
> +       ret = adxrs450_spi_read_reg_16(dev,
> +                       ADXRS450_PID1,
> +                       &t);
> +       if (ret)
> +               return ret;
> +       len = sprintf(buf, "%d\n", t);
> +       return len;
> +}
> +
> +static ssize_t adxrs450_read_sn(struct device *dev,
> +               struct device_attribute *attr,
> +               char *buf)
> +{
> +       int ret, len = 0;
> +       u16 t0, t1;
> +       u32 t;
> +       ret = adxrs450_spi_read_reg_16(dev,
> +                       ADXRS450_SNH,
> +                       &t0);
> +       if (ret)
> +               return ret;
> +
> +       ret = adxrs450_spi_read_reg_16(dev,
> +                       ADXRS450_SNL,
> +                       &t1);
> +       if (ret)
> +               return ret;
> +       t = (t0 << 16) | t1;
> +       len = sprintf(buf, "%d\n", t);
> +       return len;
> +}
> +
> +static ssize_t adxrs450_read_dnc(struct device *dev,
> +               struct device_attribute *attr,
> +               char *buf)
> +{
> +       int ret, len = 0;
> +       u16 t;
> +       ret = adxrs450_spi_read_reg_16(dev,
> +                       ADXRS450_DNC1,
> +                       &t);
> +       if (ret)
> +               return ret;
> +       len = sprintf(buf, "%d\n", t);
> +       return len;
> +}
> +
> +static ssize_t adxrs450_read_sensor_data(struct device *dev,
> +               struct device_attribute *attr,
> +               char *buf)
> +{
> +       int ret, len = 0;
> +       u32 t;
> +       u16 data;
> +       ret = adxrs450_spi_sensor_data(dev, &t, 0);
> +       if (ret)
> +               return ret;
> +       data = (u16)(t >> 10);
> +       len = sprintf(buf, "%d\n", data);
> +       return len;
> +}
> +
> +/* Recommeded Startup Sequence by spec */
> +static int adxrs450_initial_setup(struct adxrs450_state *st)
> +{
> +       u32 t;
> +       int ret;
> +       struct device *dev = &st->indio_dev->dev;
> +       /* use low spi speed for init */
> +       st->us->max_speed_hz = ADXRS450_SPI_SLOW;
> +       st->us->chip_select = 4;
>   
Don't hardcode the chip_select
> +       st->us->mode = SPI_MODE_0;
>   
Does the part work in other SPI modes as well?
If so, don't hard code.

> +       spi_setup(st->us);
>   
Check return value.
> +
> +       msleep(ADXRS450_STARTUP_DELAY*2);
> +
> +       ret = adxrs450_spi_sensor_data(dev, &t, 1);
> +       if (ret)
> +               return ret;
> +       if (t != 0x00000001)
> +               return -ENODEV;
> +
> +       msleep(ADXRS450_STARTUP_DELAY);
> +       ret = adxrs450_spi_sensor_data(dev, &t, 0);
> +       if (ret)
> +               return ret;
> +       msleep(ADXRS450_STARTUP_DELAY);
> +       ret = adxrs450_spi_sensor_data(dev, &t, 0);
> +       if (ret)
> +               return ret;
> +       if (((t & 0xff) != 0xff) && (ADXRS450_GET_ST(t) != 2))
> +               return -EIO;
> +       ret = adxrs450_spi_sensor_data(dev, &t, 0);
> +       if (ret)
> +               return ret;
> +       if (((t & 0xff) != 0xff) && (ADXRS450_GET_ST(t) != 2))
> +               return -EIO;
> +
> +       printk(KERN_INFO DRIVER_NAME ": at CS%d\n",
> +                       st->us->chip_select);
>   
Don't use printk!
use dev_dbg, dev_info, dev_warn, dev_err, etc.

> +
> +       return 0;
> +}
> +
>   

Please read iio/Documentation and conform with the ABI.

> +static IIO_DEVICE_ATTR(sensor_data, S_IRUGO,
> +               adxrs450_read_sensor_data, NULL, 0);
> +static IIO_DEVICE_ATTR(rate, S_IRUGO,
> +               adxrs450_read_rate, NULL, 0);
>   
 Use gyro_z_raw. I don't think we need both here.

> +static IIO_DEVICE_ATTR(temperature, S_IRUGO,
> +               adxrs450_read_temp, NULL, 0);
>   
Use temp or temp_raw.

> +static IIO_DEVICE_ATTR(low_cst, S_IRUGO,
> +               adxrs450_read_locst, NULL, 0);
> +static IIO_DEVICE_ATTR(high_cst, S_IRUGO,
> +               adxrs450_read_hicst, NULL, 0);
>   
I don't think we need the self-test registers exposed this way.
We could create a new file self_test, and implement the complete self
test sequence.
Then just return success.

> +static IIO_DEVICE_ATTR(quad, S_IRUGO,
> +               adxrs450_read_quad, NULL, 0);
> +static IIO_DEVICE_ATTR(fault, S_IRUGO,
> +               adxrs450_read_fault, NULL, 0);
>   
Don't expose the fault register.
The FAULT0 register is appended to the end of every device data
transmission.
Check for error status and return -EFAULT, in case of an error.
During probe check for POR, PLL, etc. errors and abort in case of errors.


> +static IIO_DEVICE_ATTR(part_id, S_IRUGO,
> +               adxrs450_read_pid, NULL, 0);
> +static IIO_DEVICE_ATTR(serial_number, S_IRUGO,
> +               adxrs450_read_sn, NULL, 0);
>   
Don't expose part and serial number.
You could read them during probe and add to the dev_info string.

> +static IIO_DEVICE_ATTR(dynamic_null_correction, S_IRUGO,
> +               adxrs450_read_dnc, NULL, 0);
>   
Please add documentation for this file.
 
> +
> +
> +static IIO_CONST_ATTR(name, "adxrs450");
> +
> +static struct attribute *adxrs450_attributes[] = {
> +
> +       &iio_dev_attr_sensor_data.dev_attr.attr,
> +       &iio_dev_attr_rate.dev_attr.attr,
> +       &iio_dev_attr_temperature.dev_attr.attr,
> +       &iio_dev_attr_low_cst.dev_attr.attr,
> +       &iio_dev_attr_high_cst.dev_attr.attr,
> +       &iio_dev_attr_quad.dev_attr.attr,
> +       &iio_dev_attr_fault.dev_attr.attr,
> +       &iio_dev_attr_part_id.dev_attr.attr,
> +       &iio_dev_attr_serial_number.dev_attr.attr,
> +       &iio_dev_attr_dynamic_null_correction.dev_attr.attr,
> +       &iio_const_attr_name.dev_attr.attr,
> +       NULL
> +};
> +
> +static const struct attribute_group adxrs450_attribute_group = {
> +       .attrs = adxrs450_attributes,
> +};
> +
> +static int __devinit adxrs450_probe(struct spi_device *spi)
> +{
> +       int ret, regdone = 0;
> +       struct adxrs450_state *st = kzalloc(sizeof *st, GFP_KERNEL);
> +       if (!st) {
> +               ret =  -ENOMEM;
> +               goto error_ret;
> +       }
> +       /* this is only used for removal purposes */
> +       spi_set_drvdata(spi, st);
> +
> +       /* Allocate the comms buffers */
> +       st->rx = kzalloc(sizeof(*st->rx)*ADXRS450_MAX_RX, GFP_KERNEL);
> +       if (st->rx == NULL) {
> +               ret = -ENOMEM;
> +               goto error_free_st;
> +       }
> +       st->tx = kzalloc(sizeof(*st->tx)*ADXRS450_MAX_TX, GFP_KERNEL);
> +       if (st->tx == NULL) {
> +               ret = -ENOMEM;
> +               goto error_free_rx;
> +       }
> +       st->us = spi;
> +       mutex_init(&st->buf_lock);
> +       /* setup the industrialio driver allocated elements */
> +       st->indio_dev = iio_allocate_device();
> +       if (st->indio_dev == NULL) {
> +               ret = -ENOMEM;
> +               goto error_free_tx;
> +       }
> +
> +       st->indio_dev->dev.parent = &spi->dev;
> +       st->indio_dev->attrs = &adxrs450_attribute_group;
> +       st->indio_dev->dev_data = (void *)(st);
> +       st->indio_dev->driver_module = THIS_MODULE;
> +       st->indio_dev->modes = INDIO_DIRECT_MODE;
> +
> +       ret = iio_device_register(st->indio_dev);
> +       if (ret)
> +               goto error_free_dev;
> +       regdone = 1;
> +
> +       /* Get the device into a sane initial state */
> +       ret = adxrs450_initial_setup(st);
> +       if (ret)
> +               goto error_initial;
> +       return 0;
> +
> +error_initial:
> +error_free_dev:
> +       if (regdone)
> +               iio_device_unregister(st->indio_dev);
> +       else
> +               iio_free_device(st->indio_dev);
> +error_free_tx:
> +       kfree(st->tx);
> +error_free_rx:
> +       kfree(st->rx);
> +error_free_st:
> +       kfree(st);
> +error_ret:
> +       return ret;
> +}
> +
> +/* fixme, confirm ordering in this function */
> +static int adxrs450_remove(struct spi_device *spi)
> +{
> +       struct adxrs450_state *st = spi_get_drvdata(spi);
> +       struct iio_dev *indio_dev = st->indio_dev;
> +
> +       iio_device_unregister(indio_dev);
> +       kfree(st->tx);
> +       kfree(st->rx);
> +       kfree(st);
> +
> +       return 0;
> +}
> +
> +static struct spi_driver adxrs450_driver = {
> +       .driver = {
> +               .name = "adxrs450",
> +               .owner = THIS_MODULE,
> +       },
> +       .probe = adxrs450_probe,
> +       .remove = __devexit_p(adxrs450_remove),
> +};
> +
> +static __init int adxrs450_init(void)
> +{
> +       return spi_register_driver(&adxrs450_driver);
> +}
> +module_init(adxrs450_init);
> +
> +static __exit void adxrs450_exit(void)
> +{
> +       spi_unregister_driver(&adxrs450_driver);
> +}
> +module_exit(adxrs450_exit);
> +
> +MODULE_AUTHOR("Cliff Cai <cliff.cai@analog.com>");
> +MODULE_DESCRIPTION("Analog Devices ADXRS450 Gyroscope SPI driver");
> +MODULE_LICENSE("GPL v2");
> --
> 1.7.1
>
> _______________________________________________
> Device-drivers-devel mailing list
> Device-drivers-devel@blackfin.uclinux.org
> https://blackfin.uclinux.org/mailman/listinfo/device-drivers-devel
>   


-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif

