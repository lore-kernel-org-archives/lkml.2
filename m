Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0EGNb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 09:31:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41566 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab0EGNb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 09:31:56 -0400
Message-ID: <5421.10.24.255.18.1273239114.squirrel@dbdmail.itg.ti.com>
In-Reply-To: <12046.10.24.255.18.1272638611.squirrel@dbdmail.itg.ti.com>
References: <12046.10.24.255.18.1272638611.squirrel@dbdmail.itg.ti.com>
Date: Fri, 7 May 2010 19:01:54 +0530 (IST)
Subject: Re: [RFC] [PATCH 1/2]  CMA3000 Accelerometer Driver
From: "Hemanth V" <hemanthv@ti.com>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From d2842ba67e142e78b2554cebb01341c76b84b693 Mon Sep 17 00:00:00 2001
> From: Hemanth V <hemanthv@ti.com>
> Date: Fri, 30 Apr 2010 11:55:10 +0530
> Subject: [PATCH] CMA3000 Accelerometer Driver
>
> This patch adds support for CMA3000 Tri-axis accelerometer, which
> supports Motion detect, Measurement and Free fall modes.
> CMA3000 supports both I2C/SPI bus for communication, currently the
> driver supports I2C based communication.

Dimitry, Did you get a chance to look at this
series.

Thanks
Hemanth

>
> Driver reports acceleration data through input subsystem and supports
> sysfs for configuration changes.
>
> This chip is currently used with OMAP4 based boards
>
> Thanks to Ossi Kauppinen <Ossi.Kauppinen@vti.fi> for the support
> provided during development
>
> Signed-off-by: Hemanth V <hemanthv@ti.com>
> ---
>  drivers/input/misc/Kconfig           |    9 +
>  drivers/input/misc/Makefile          |    1 +
>  drivers/input/misc/cma3000_d0x.c     |  627 ++++++++++++++++++++++++++++++++++
>  drivers/input/misc/cma3000_d0x.h     |   46 +++
>  drivers/input/misc/cma3000_d0x_i2c.c |  136 ++++++++
>  include/linux/i2c/cma3000.h          |   60 ++++
>  6 files changed, 879 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/misc/cma3000_d0x.c
>  create mode 100644 drivers/input/misc/cma3000_d0x.h
>  create mode 100644 drivers/input/misc/cma3000_d0x_i2c.c
>  create mode 100644 include/linux/i2c/cma3000.h
>
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 16ec523..4752a00 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -319,4 +319,13 @@ config INPUT_PCAP
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called pcap_keys.
>
> +config INPUT_CMA3000_I2C
> +	tristate "VTI CMA3000 Tri-axis accelerometer"
> +	depends on I2C
> +	help
> +	  Say Y here if you want to use VTI CMA3000 Accelerometer
> +	  through I2C interface.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called cma3000_dxx
>  endif
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index a8b8485..94d6eda 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -30,4 +30,4 @@ obj-$(CONFIG_INPUT_WINBOND_CIR)		+= winbond-cir.o
>  obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
>  obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
>  obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
> -
> +obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o cma3000_d0x.o
> diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
> new file mode 100644
> index 0000000..c0d0ea1
> --- /dev/null
> +++ b/drivers/input/misc/cma3000_d0x.c
> @@ -0,0 +1,627 @@
> +/*
> + * cma3000_d0x.c
> + * VTI CMA3000_D0x Accelerometer driver
> + * 	Supports I2C/SPI interfaces
> + *
> + * Copyright (C) 2010 Texas Instruments
> + * Author: Hemanth V <hemanthv@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/input.h>
> +#include <linux/platform_device.h>
> +#include <linux/i2c/cma3000.h>
> +
> +#include "cma3000_d0x.h"
> +
> +#define CMA3000_WHOAMI      0x00
> +#define CMA3000_REVID       0x01
> +#define CMA3000_CTRL        0x02
> +#define CMA3000_STATUS      0x03
> +#define CMA3000_RSTR        0x04
> +#define CMA3000_INTSTATUS   0x05
> +#define CMA3000_DOUTX       0x06
> +#define CMA3000_DOUTY       0x07
> +#define CMA3000_DOUTZ       0x08
> +#define CMA3000_MDTHR       0x09
> +#define CMA3000_MDFFTMR     0x0A
> +#define CMA3000_FFTHR       0x0B
> +
> +#define CMA3000_RANGE2G    (1 << 7)
> +#define CMA3000_RANGE8G    (0 << 7)
> +#define CMA3000_MODEMASK    (7 << 1)
> +#define CMA3000_GRANGEMASK  (1 << 7)
> +
> +#define CMA3000_STATUS_PERR    1
> +#define CMA3000_INTSTATUS_FFDET (1 << 2)
> +
> +/* Settling time delay in ms */
> +#define CMA3000_SETDELAY    30
> +
> +/* Delay for clearing interrupt in us */
> +#define CMA3000_INTDELAY    44
> +
> +
> +/*
> + * Bit weights in mg for each of the seven bits,
> + * eight bit is the sign bit
> + */
> +static int bit_to_2g[7] = {18, 36, 71, 143, 286, 571, 1142};
> +static int bit_to_8g[7] = {71, 143, 286, 571, 1142, 2286, 4571};
> +
> +/*
> + * Conversion for each of the eight modes to g, depending
> + * on G range i.e 2G or 8G
> + */
> +
> +static int *mode_to_mg[8][2] = {
> +	{NULL, NULL },
> +	{bit_to_8g, bit_to_2g},
> +	{bit_to_8g, bit_to_2g},
> +	{bit_to_8g, bit_to_8g},
> +	{bit_to_8g, bit_to_8g},
> +	{bit_to_8g, bit_to_2g},
> +	{bit_to_8g, bit_to_2g},
> +	{NULL, NULL },
> +};
> +
> +static ssize_t cma3000_show_attr_mode(struct device *dev,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	ssize_t ret = 0;
> +	uint8_t mode;
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +
> +	mode = cma3000_read(data, CMA3000_CTRL, "ctrl");
> +	ret = sprintf(buf, "%d\n", (mode & CMA3000_MODEMASK) >> 1);
> +	return ret;
> +}
> +
> +static ssize_t cma3000_store_attr_mode(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	int error;
> +	uint8_t ctrl;
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	if (val < CMAMODE_DEFAULT || val > CMAMODE_POFF)
> +		return -EINVAL;
> +
> +	mutex_lock(&data->mutex);
> +	val &= (CMA3000_MODEMASK >> 1);
> +	ctrl = cma3000_read(data, CMA3000_CTRL, "ctrl");
> +	ctrl &= ~CMA3000_MODEMASK;
> +	ctrl |= (val << 1);
> +
> +	data->pdata.mode = val;
> +
> +	disable_irq(data->client->irq);
> +	cma3000_set(data, CMA3000_CTRL, ctrl, "ctrl");
> +
> +	/* Settling time delay required after mode change */
> +	msleep(CMA3000_SETDELAY);
> +
> +	enable_irq(data->client->irq);
> +	mutex_unlock(&data->mutex);
> +
> +	return count;
> +}
> +
> +static ssize_t cma3000_show_attr_grange(struct device *dev,
> +				       struct device_attribute *attr,
> +				       char *buf)
> +{
> +	ssize_t ret = 0;
> +	uint8_t mode;
> +	int g_range;
> +
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +
> +	mode = cma3000_read(data, CMA3000_CTRL, "ctrl");
> +	g_range = (mode & CMA3000_GRANGEMASK) ? CMARANGE_2G : CMARANGE_8G;
> +	ret = sprintf(buf, "%d\n", g_range);
> +
> +	return ret;
> +}
> +
> +static ssize_t cma3000_store_attr_grange(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	int error, g_range, fuzz_x, fuzz_y, fuzz_z;
> +	uint8_t ctrl;
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&data->mutex);
> +	ctrl = cma3000_read(data, CMA3000_CTRL, "ctrl");
> +	ctrl &= ~CMA3000_GRANGEMASK;
> +
> +	if (val == CMARANGE_2G) {
> +		ctrl |= CMA3000_RANGE2G;
> +		data->pdata.g_range = CMARANGE_2G;
> +	} else if (val == CMARANGE_8G) {
> +		ctrl |= CMA3000_RANGE8G;
> +		data->pdata.g_range = CMARANGE_8G;
> +	} else {
> +		error = -EINVAL;
> +		goto err_op_failed;
> +	}
> +
> +	g_range = data->pdata.g_range;
> +	fuzz_x = data->pdata.fuzz_x;
> +	fuzz_y = data->pdata.fuzz_y;
> +	fuzz_z = data->pdata.fuzz_z;
> +
> +	disable_irq(data->client->irq);
> +	cma3000_set(data, CMA3000_CTRL, ctrl, "ctrl");
> +
> +	input_set_abs_params(data->input_dev, ABS_X, -g_range,
> +				g_range, fuzz_x, 0);
> +	input_set_abs_params(data->input_dev, ABS_Y, -g_range,
> +				g_range, fuzz_y, 0);
> +	input_set_abs_params(data->input_dev, ABS_Z, -g_range,
> +				g_range, fuzz_z, 0);
> +
> +	enable_irq(data->client->irq);
> +	mutex_unlock(&data->mutex);
> +
> +	return count;
> +
> +err_op_failed:
> +	mutex_unlock(&data->mutex);
> +	return error;
> +}
> +
> +static ssize_t cma3000_show_attr_mdthr(struct device *dev,
> +				      struct device_attribute *attr,
> +				      char *buf)
> +{
> +	ssize_t ret = 0;
> +	uint8_t mode;
> +
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +
> +	mode = cma3000_read(data, CMA3000_MDTHR, "mdthr");
> +	ret = sprintf(buf, "%d\n", mode);
> +
> +	return ret;
> +}
> +
> +static ssize_t cma3000_store_attr_mdthr(struct device *dev,
> +				       struct device_attribute *attr,
> +				       const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	int error;
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&data->mutex);
> +	data->pdata.mdthr = val;
> +
> +	disable_irq(data->client->irq);
> +	cma3000_set(data, CMA3000_MDTHR, val, "mdthr");
> +	enable_irq(data->client->irq);
> +	mutex_unlock(&data->mutex);
> +
> +	return count;
> +}
> +
> +static ssize_t cma3000_show_attr_mdfftmr(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	ssize_t ret = 0;
> +	uint8_t mode;
> +
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +
> +	mode = cma3000_read(data, CMA3000_MDFFTMR, "mdfftmr");
> +	ret = sprintf(buf, "%d\n", mode);
> +
> +	return ret;
> +}
> +
> +static ssize_t cma3000_store_attr_mdfftmr(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	int error;
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&data->mutex);
> +	data->pdata.mdfftmr = val;
> +
> +	disable_irq(data->client->irq);
> +	cma3000_set(data, CMA3000_MDFFTMR, val, "mdthr");
> +	enable_irq(data->client->irq);
> +	mutex_unlock(&data->mutex);
> +
> +	return count;
> +}
> +
> +static ssize_t cma3000_show_attr_ffthr(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	ssize_t ret = 0;
> +	uint8_t mode;
> +
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +
> +	mode = cma3000_read(data, CMA3000_FFTHR, "ffthr");
> +	ret = sprintf(buf, "%d\n", mode);
> +
> +	return ret;
> +}
> +
> +static ssize_t cma3000_store_attr_ffthr(struct device *dev,
> +				       struct device_attribute *attr,
> +				       const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	int error;
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&data->mutex);
> +	data->pdata.ffthr = val;
> +
> +	disable_irq(data->client->irq);
> +	cma3000_set(data, CMA3000_FFTHR, val, "mdthr");
> +	enable_irq(data->client->irq);
> +	mutex_unlock(&data->mutex);
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(mode, S_IWUSR | S_IRUGO,
> +		cma3000_show_attr_mode, cma3000_store_attr_mode);
> +
> +static DEVICE_ATTR(grange, S_IWUSR | S_IRUGO,
> +		cma3000_show_attr_grange, cma3000_store_attr_grange);
> +
> +static DEVICE_ATTR(mdthr, S_IWUSR | S_IRUGO,
> +		cma3000_show_attr_mdthr, cma3000_store_attr_mdthr);
> +
> +static DEVICE_ATTR(mdfftmr, S_IWUSR | S_IRUGO,
> +		cma3000_show_attr_mdfftmr, cma3000_store_attr_mdfftmr);
> +
> +static DEVICE_ATTR(ffthr, S_IWUSR | S_IRUGO,
> +		cma3000_show_attr_ffthr, cma3000_store_attr_ffthr);
> +
> +
> +static struct attribute *cma_attrs[] = {
> +	&dev_attr_mode.attr,
> +	&dev_attr_grange.attr,
> +	&dev_attr_mdthr.attr,
> +	&dev_attr_mdfftmr.attr,
> +	&dev_attr_ffthr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group cma3000_attr_group = {
> +	.attrs = cma_attrs,
> +};
> +
> +static void cma3000_create_sysfs(struct cma3000_accl_data *data)
> +{
> +	int ret;
> +	ret = sysfs_create_group(&data->client->dev.kobj, &cma3000_attr_group);
> +	if (ret)
> +		dev_err(&data->client->dev,
> +			"failed to create sysfs entries\n");
> +
> +}
> +
> +static void cma3000_remove_sysfs(struct cma3000_accl_data *data)
> +{
> +	sysfs_remove_group(&data->client->dev.kobj, &cma3000_attr_group);
> +}
> +
> +static void decode_mg(struct cma3000_accl_data *data, int *datax,
> +				int *datay, int *dataz)
> +{
> +	int i, tmpx = 0, tmpy = 0, tmpz = 0;
> +
> +	for (i = 0; i < 7; ++i) {
> +		tmpx += (((*datax) & BIT(i)) >> i) * (data->bit_to_mg[i]);
> +		tmpy += (((*datay) & BIT(i)) >> i) * (data->bit_to_mg[i]);
> +		tmpz += (((*dataz) & BIT(i)) >> i) * (data->bit_to_mg[i]);
> +
> +	}
> +
> +	if ((*datax) & BIT(7))
> +		*datax = -tmpx;
> +	else
> +		*datax = tmpx;
> +
> +	if ((*datay) & BIT(7))
> +		*datay = -tmpy;
> +	else
> +		*datay = tmpy;
> +
> +	if ((*dataz) & BIT(7))
> +		*dataz = -tmpz;
> +	else
> +		*dataz = tmpz;
> +}
> +
> +static irqreturn_t cma3000_thread_irq(int irq, void *dev_id)
> +{
> +	struct cma3000_accl_data *data = dev_id;
> +	int  datax, datay, dataz;
> +	u8 ctrl, mode, range, intr_status;
> +
> +	intr_status = cma3000_read(data, CMA3000_INTSTATUS, "interrupt status");
> +
> +	/* Check if free fall is detected, report immediately */
> +	if (intr_status & CMA3000_INTSTATUS_FFDET) {
> +		input_report_abs(data->input_dev, ABS_MISC, 1);
> +		input_sync(data->input_dev);
> +	} else {
> +		input_report_abs(data->input_dev, ABS_MISC, 0);
> +	}
> +
> +
> +	/* Delay required between each read for interrupt clearing */
> +	datax = cma3000_read(data, CMA3000_DOUTX, "X");
> +	udelay(CMA3000_INTDELAY);
> +	datay = cma3000_read(data, CMA3000_DOUTY, "Y");
> +	udelay(CMA3000_INTDELAY);
> +	dataz = cma3000_read(data, CMA3000_DOUTZ, "Z");
> +
> +	ctrl = cma3000_read(data, CMA3000_CTRL, "ctrl");
> +	mode = (ctrl & CMA3000_MODEMASK) >> 1;
> +	range = (ctrl & CMA3000_GRANGEMASK) >> 7;
> +
> +	data->bit_to_mg = mode_to_mg[mode][range];
> +
> +	/* Interrupt not for this device */
> +	if (data->bit_to_mg == NULL)
> +		return IRQ_NONE;
> +
> +	/* Decode register values to milli g */
> +	decode_mg(data, &datax, &datay, &dataz);
> +
> +	input_report_abs(data->input_dev, ABS_X, datax);
> +	input_report_abs(data->input_dev, ABS_Y, datay);
> +	input_report_abs(data->input_dev, ABS_Z, dataz);
> +	input_sync(data->input_dev);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int cma3000_reset(struct cma3000_accl_data *data)
> +{
> +	int ret;
> +
> +	/* Reset sequence */
> +	cma3000_set(data, CMA3000_RSTR, 0x02, "Reset");
> +	cma3000_set(data, CMA3000_RSTR, 0x0A, "Reset");
> +	cma3000_set(data, CMA3000_RSTR, 0x04, "Reset");
> +
> +	/* Settling time delay */
> +	mdelay(10);
> +
> +	ret = cma3000_read(data, CMA3000_STATUS, "Status");
> +	if ((ret < 0) || (ret & CMA3000_STATUS_PERR)) {
> +		dev_err(&data->client->dev, "Reset failed\n");
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +int cma3000_poweron(struct cma3000_accl_data *data)
> +{
> +	uint8_t ctrl = 0, mdthr, mdfftmr, ffthr, mode;
> +	int g_range, ret;
> +
> +	g_range = data->pdata.g_range;
> +	mode = data->pdata.mode;
> +	mdthr = data->pdata.mdthr;
> +	mdfftmr = data->pdata.mdfftmr;
> +	ffthr = data->pdata.ffthr;
> +
> +	if (mode < CMAMODE_DEFAULT || mode > CMAMODE_POFF) {
> +		data->pdata.mode = CMAMODE_MOTDET;
> +		mode = data->pdata.mode;
> +		dev_info(&data->client->dev,
> +			"Invalid mode specified, assuming Motion Detect\n");
> +	}
> +
> +	if (g_range == CMARANGE_2G) {
> +		ctrl = (mode << 1) | CMA3000_RANGE2G;
> +	} else if (g_range == CMARANGE_8G) {
> +		ctrl = (mode << 1) | CMA3000_RANGE8G;
> +	} else {
> +		dev_info(&data->client->dev,
> +			"Invalid G range specified, assuming 8G\n");
> +		ctrl = (mode << 1) | CMA3000_RANGE8G;
> +		data->pdata.g_range = CMARANGE_8G;
> +	}
> +
> +
> +	cma3000_set(data, CMA3000_MDTHR, mdthr, "Motion Detect Threshold");
> +	cma3000_set(data, CMA3000_MDFFTMR, mdfftmr, "Time register");
> +	cma3000_set(data, CMA3000_FFTHR, ffthr, "Free fall threshold");
> +	ret = cma3000_set(data, CMA3000_CTRL, ctrl, "Mode setting");
> +	if (ret < 0)
> +		return -EIO;
> +
> +	mdelay(CMA3000_SETDELAY);
> +
> +	return 0;
> +}
> +
> +int cma3000_poweroff(struct cma3000_accl_data *data)
> +{
> +	int ret;
> +
> +	ret = cma3000_set(data, CMA3000_CTRL, CMAMODE_POFF, "Mode setting");
> +	mdelay(CMA3000_SETDELAY);
> +
> +	return ret;
> +}
> +
> +int cma3000_init(struct cma3000_accl_data *data)
> +{
> +	int ret = 0, fuzz_x, fuzz_y, fuzz_z, g_range;
> +	uint32_t irqflags;
> +
> +	if (data->client->dev.platform_data == NULL) {
> +		dev_err(&data->client->dev, "platform data not found \n");
> +		goto err_op2_failed;
> +	}
> +
> +	memcpy(&(data->pdata), data->client->dev.platform_data,
> +		sizeof(struct cma3000_platform_data));
> +
> +	ret = cma3000_reset(data);
> +	if (ret)
> +		goto err_op2_failed;
> +
> +	ret = cma3000_read(data, CMA3000_REVID, "Revid");
> +	if (ret < 0)
> +		goto err_op2_failed;
> +
> +	pr_info("CMA3000 Acclerometer : Revision %x\n", ret);
> +
> +	/* Bring it out of default power down state */
> +	ret = cma3000_poweron(data);
> +	if (ret < 0)
> +		goto err_op2_failed;
> +
> +	fuzz_x = data->pdata.fuzz_x;
> +	fuzz_y = data->pdata.fuzz_y;
> +	fuzz_z = data->pdata.fuzz_z;
> +	g_range = data->pdata.g_range;
> +	irqflags = data->pdata.irqflags;
> +
> +	data->input_dev = input_allocate_device();
> +	if (data->input_dev == NULL) {
> +		ret = -ENOMEM;
> +		dev_err(&data->client->dev,
> +			"Failed to allocate input device\n");
> +		goto err_op2_failed;
> +	}
> +
> +	data->input_dev->name = "cma3000-acclerometer";
> +
> +#ifdef CONFIG_INPUT_CMA3000_I2C
> +	data->input_dev->id.bustype = BUS_I2C;
> +#endif
> +
> +	 __set_bit(EV_ABS, data->input_dev->evbit);
> +	 __set_bit(EV_MSC, data->input_dev->evbit);
> +
> +	input_set_abs_params(data->input_dev, ABS_X, -g_range,
> +				g_range, fuzz_x, 0);
> +	input_set_abs_params(data->input_dev, ABS_Y, -g_range,
> +				g_range, fuzz_y, 0);
> +	input_set_abs_params(data->input_dev, ABS_Z, -g_range,
> +				g_range, fuzz_z, 0);
> +	input_set_abs_params(data->input_dev, ABS_MISC, 0,
> +				1, 0, 0);
> +
> +	ret = input_register_device(data->input_dev);
> +	if (ret) {
> +		dev_err(&data->client->dev,
> +			"Unable to register input device\n");
> +		goto err_op2_failed;
> +	}
> +
> +	mutex_init(&data->mutex);
> +
> +	if (data->client->irq) {
> +		ret = request_threaded_irq(data->client->irq, NULL,
> +					cma3000_thread_irq,
> +					irqflags | IRQF_ONESHOT,
> +					data->client->name, data);
> +
> +		if (ret < 0) {
> +			dev_err(&data->client->dev,
> +				"request_threaded_irq failed\n");
> +			goto err_op1_failed;
> +		}
> +	}
> +
> +	cma3000_create_sysfs(data);
> +
> +	return 0;
> +
> +err_op1_failed:
> +	mutex_destroy(&data->mutex);
> +	input_unregister_device(data->input_dev);
> +err_op2_failed:
> +	if (data != NULL) {
> +		if (data->input_dev != NULL)
> +			input_free_device(data->input_dev);
> +	}
> +
> +	return ret;
> +}
> +
> +int cma3000_exit(struct cma3000_accl_data *data)
> +{
> +	int ret;
> +
> +	ret = cma3000_poweroff(data);
> +
> +	if (data->client->irq)
> +		free_irq(data->client->irq, data);
> +
> +	mutex_destroy(&data->mutex);
> +	input_unregister_device(data->input_dev);
> +	input_free_device(data->input_dev);
> +	cma3000_remove_sysfs(data);
> +
> +	return ret;
> +}
> diff --git a/drivers/input/misc/cma3000_d0x.h b/drivers/input/misc/cma3000_d0x.h
> new file mode 100644
> index 0000000..906d29e
> --- /dev/null
> +++ b/drivers/input/misc/cma3000_d0x.h
> @@ -0,0 +1,46 @@
> +/*
> + * cma3000_d0x.h
> + * VTI CMA3000_D0x Accelerometer driver
> + *
> + * Copyright (C) 2010 Texas Instruments
> + * Author: Hemanth V <hemanthv@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef INPUT_CMA3000_H
> +#define INPUT_CMA3000_H
> +
> +#include <linux/i2c.h>
> +#include <linux/input.h>
> +
> +struct cma3000_accl_data {
> +#ifdef CONFIG_INPUT_CMA3000_I2C
> +	struct i2c_client *client;
> +#endif
> +	struct input_dev *input_dev;
> +	struct cma3000_platform_data pdata;
> +
> +	/* mutex for sysfs operations */
> +	struct mutex mutex;
> +	int *bit_to_mg;
> +};
> +
> +int cma3000_set(struct cma3000_accl_data *, u8, u8, char *);
> +int cma3000_read(struct cma3000_accl_data *, u8, char *);
> +int cma3000_init(struct cma3000_accl_data *);
> +int cma3000_exit(struct cma3000_accl_data *);
> +int cma3000_poweron(struct cma3000_accl_data *);
> +int cma3000_poweroff(struct cma3000_accl_data *);
> +
> +#endif
> diff --git a/drivers/input/misc/cma3000_d0x_i2c.c b/drivers/input/misc/cma3000_d0x_i2c.c
> new file mode 100644
> index 0000000..d2ad638
> --- /dev/null
> +++ b/drivers/input/misc/cma3000_d0x_i2c.c
> @@ -0,0 +1,136 @@
> +/*
> + * cma3000_d0x_i2c.c
> + *
> + * Implements I2C interface for VTI CMA300_D0x Accelerometer driver
> + *
> + * Copyright (C) 2010 Texas Instruments
> + * Author: Hemanth V <hemanthv@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c/cma3000.h>
> +#include "cma3000_d0x.h"
> +
> +int cma3000_set(struct cma3000_accl_data *accl, u8 reg, u8 val, char *msg)
> +{
> +	int ret = i2c_smbus_write_byte_data(accl->client, reg, val);
> +	if (ret < 0)
> +		dev_err(&accl->client->dev,
> +			"i2c_smbus_write_byte_data failed (%s)\n", msg);
> +	return ret;
> +}
> +
> +int cma3000_read(struct cma3000_accl_data *accl, u8 reg, char *msg)
> +{
> +	int ret = i2c_smbus_read_byte_data(accl->client, reg);
> +	if (ret < 0)
> +		dev_err(&accl->client->dev,
> +			"i2c_smbus_read_byte_data failed (%s)\n", msg);
> +	return ret;
> +}
> +
> +static int __devinit cma3000_accl_probe(struct i2c_client *client,
> +					const struct i2c_device_id *id)
> +{
> +	int ret;
> +	struct cma3000_accl_data *data = NULL;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (data == NULL) {
> +		ret = -ENOMEM;
> +		goto err_op_failed;
> +	}
> +
> +	data->client = client;
> +	i2c_set_clientdata(client, data);
> +
> +	ret = cma3000_init(data);
> +	if (ret)
> +		goto err_op_failed;
> +
> +	return 0;
> +
> +err_op_failed:
> +
> +	if (data != NULL)
> +		kfree(data);
> +
> +	return ret;
> +}
> +
> +static int __devexit cma3000_accl_remove(struct i2c_client *client)
> +{
> +	struct cma3000_accl_data *data = i2c_get_clientdata(client);
> +	int ret;
> +
> +	ret = cma3000_exit(data);
> +	i2c_set_clientdata(client, NULL);
> +	kfree(data);
> +
> +	return ret;
> +}
> +
> +#ifdef CONFIG_PM
> +static int cma3000_accl_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +	struct cma3000_accl_data *data = i2c_get_clientdata(client);
> +
> +	return cma3000_poweroff(data);
> +}
> +
> +static int cma3000_accl_resume(struct i2c_client *client)
> +{
> +	struct cma3000_accl_data *data = i2c_get_clientdata(client);
> +
> +	return cma3000_poweron(data);
> +}
> +#endif
> +
> +static const struct i2c_device_id cma3000_id[] = {
> +	{ "cma3000_accl", 0 },
> +	{ },
> +};
> +
> +static struct i2c_driver cma3000_accl_driver = {
> +	.probe		= cma3000_accl_probe,
> +	.remove		= cma3000_accl_remove,
> +	.id_table	= cma3000_id,
> +#ifdef CONFIG_PM
> +	.suspend	= cma3000_accl_suspend,
> +	.resume		= cma3000_accl_resume,
> +#endif
> +	.driver = {
> +		.name = "cma3000_accl"
> +	},
> +};
> +
> +static int __init cma3000_accl_init(void)
> +{
> +
> +	return i2c_add_driver(&cma3000_accl_driver);
> +}
> +
> +static void __exit cma3000_accl_exit(void)
> +{
> +	i2c_del_driver(&cma3000_accl_driver);
> +}
> +
> +module_init(cma3000_accl_init);
> +module_exit(cma3000_accl_exit);
> +
> +MODULE_DESCRIPTION("CMA3000-D0x Accelerometer Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Hemanth V <hemanthv@ti.com>");
> diff --git a/include/linux/i2c/cma3000.h b/include/linux/i2c/cma3000.h
> new file mode 100644
> index 0000000..50aa3fc
> --- /dev/null
> +++ b/include/linux/i2c/cma3000.h
> @@ -0,0 +1,60 @@
> +/*
> + * cma3000.h
> + * VTI CMA300_Dxx Accelerometer driver
> + *
> + * Copyright (C) 2010 Texas Instruments
> + * Author: Hemanth V <hemanthv@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef _LINUX_CMA3000_I2C_H
> +#define _LINUX_CMA3000_I2C_H
> +
> +#define CMAMODE_DEFAULT    0
> +#define CMAMODE_MEAS100    1
> +#define CMAMODE_MEAS400    2
> +#define CMAMODE_MEAS40     3
> +#define CMAMODE_MOTDET     4
> +#define CMAMODE_FF100      5
> +#define CMAMODE_FF400      6
> +#define CMAMODE_POFF       7
> +
> +#define CMARANGE_2G   2000
> +#define CMARANGE_8G   8000
> +
> +/**
> + * struct cma3000_i2c_platform_data - CMA3000 Platform data
> + * @fuzz_x: Noise on X Axis
> + * @fuzz_y: Noise on Y Axis
> + * @fuzz_z: Noise on Z Axis
> + * @g_range: G range in milli g i.e 2000 or 8000
> + * @mode: Operating mode
> + * @mdthr: Motion detect threshold value
> + * @mdfftmr: Motion detect and free fall time value
> + * @ffthr: Free fall threshold value
> + */
> +
> +struct cma3000_platform_data {
> +	int fuzz_x;
> +	int fuzz_y;
> +	int fuzz_z;
> +	int g_range;
> +	uint8_t  mode;
> +	uint8_t  mdthr;
> +	uint8_t  mdfftmr;
> +	uint8_t  ffthr;
> +	uint32_t  irqflags;
> +};
> +
> +#endif
> --
> 1.5.6.3
>
>
>
>


