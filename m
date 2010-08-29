Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab0H2StM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:49:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57243 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab0H2StK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:49:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TohDiI9Y/sopdz3o021xksmPUxtdqSuCMUQfw8T6emeA/E1ZZrWDsLOL/Q4Nscitw2
         9qATteKxUDC+4puHCXDq9uP/HBPxbc4y5GB5ZICX+t6Gdy0i2sPWMy4RNheALngwicB9
         +Av8HBuA83lLhVJsnzRX/XS0DvaYvtm8d1EHc=
Date: Sun, 29 Aug 2010 11:49:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hemanth V <hemanthv@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [RFC] [PATCH V2 1/2] input: CMA3000 Accelerometer driver
Message-ID: <20100829184904.GC26209@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hemanth,

On Fri, May 21, 2010 at 12:22:57PM +0530, Hemanth V wrote:
> From: Hemanth V <hemanthv@ti.com>
> Date: Thu, 20 May 2010 20:18:17 +0530
> Subject: [PATCH] input: CMA3000 Accelerometer Driver
> 
> This patch adds support for CMA3000 Tri-axis accelerometer, which
> supports Motion detect, Measurement and Free fall modes.
> CMA3000 supports both I2C/SPI bus for communication, currently the
> driver supports I2C based communication.
> 
> Driver reports acceleration data through input subsystem and supports
> sysfs for configuration changes.
> 
> This is V2 of patch, which fixes open source review comments
> 
> Signed-off-by: Hemanth V <hemanthv@ti.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  Documentation/input/cma3000_d0x.txt  |  112 ++++++
>  drivers/input/misc/Kconfig           |    7 +
>  drivers/input/misc/Makefile          |    1 +
>  drivers/input/misc/cma3000_d0x.c     |  633 ++++++++++++++++++++++++++++++++++
>  drivers/input/misc/cma3000_d0x.h     |   46 +++
>  drivers/input/misc/cma3000_d0x_i2c.c |  136 ++++++++
>  include/linux/i2c/cma3000.h          |   60 ++++
>  7 files changed, 995 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/input/cma3000_d0x.txt
>  create mode 100644 drivers/input/misc/cma3000_d0x.c
>  create mode 100644 drivers/input/misc/cma3000_d0x.h
>  create mode 100644 drivers/input/misc/cma3000_d0x_i2c.c
>  create mode 100644 include/linux/i2c/cma3000.h
> 
> diff --git a/Documentation/input/cma3000_d0x.txt b/Documentation/input/cma3000_d0x.txt
> new file mode 100644
> index 0000000..29ab6b7
> --- /dev/null
> +++ b/Documentation/input/cma3000_d0x.txt
> @@ -0,0 +1,112 @@
> +Kernel driver for CMA3000-D0x
> +============================
> +
> +Supported chips:
> +* VTI CMA3000-D0x
> +Datasheet:
> +  CMA3000-D0X Product Family Specification 8281000A.02.pdf
> +
> +Author: Hemanth V <hemanthv@ti.com>
> +
> +
> +Description
> +-----------
> +CMA3000 Tri-axis accelerometer supports Motion detect, Measurement and
> +Free fall modes.
> +
> +Motion Detect Mode: Its the low power mode where interrupts are generated only
> +when motion exceeds the defined thresholds.
> +
> +Measurement Mode: This mode is used to read the acceleration data on X,Y,Z
> +axis and supports 400, 100, 40 Hz sample frequency.
> +
> +Free fall Mode: This mode is intented to save system resources.
> +
> +Threshold values: Chip supports defining threshold values for above modes
> +which includes time and g value. Refer product specifications for more details.
> +
> +CMA3000 supports both I2C/SPI bus for communication, currently the driver
> +supports I2C based communication.
> +
> +Driver reports acceleration data through input subsystem and supports sysfs
> +for configuration changes. It generates ABS_MISC event with value 1 when
> +free fall is detected.
> +
> +Platform data need to be configured for initial default values.
> +
> +Platform Data
> +-------------
> +fuzz_x: Noise on X Axis
> +
> +fuzz_y: Noise on Y Axis
> +
> +fuzz_z: Noise on Z Axis
> +
> +g_range: G range in milli g i.e 2000 or 8000
> +
> +mode: Default Operating mode
> +
> +mdthr: Motion detect threshold value
> +
> +mdfftmr: Motion detect and free fall time value
> +
> +ffthr: Free fall threshold value
> +
> +Input Interface
> +--------------
> +Input driver version is 1.0.0
> +Input device ID: bus 0x18 vendor 0x0 product 0x0 version 0x0
> +Input device name: "cma3000-acclerometer"
> +Supported events:
> +  Event type 0 (Sync)
> +  Event type 3 (Absolute)
> +    Event code 0 (X)
> +      Value     47
> +      Min    -8000
> +      Max     8000
> +      Fuzz     200
> +    Event code 1 (Y)
> +      Value    -28
> +      Min    -8000
> +      Max     8000
> +      Fuzz     200
> +    Event code 2 (Z)
> +      Value    905
> +      Min    -8000
> +      Max     8000
> +      Fuzz     200
> +    Event code 40 (Misc)
> +      Value      0
> +      Min        0
> +      Max        1
> +  Event type 4 (Misc)
> +
> +Sysfs entries
> +-------------
> +
> +mode:
> +	0: power down mode
> +	1: 100 Hz Measurement mode
> +	2: 400 Hz Measurement mode
> +	3: 40 Hz Measurement mode
> +	4: Motion Detect mode (default)
> +	5: 100 Hz Free fall mode
> +	6: 40 Hz Free fall mode
> +	7: Power off mode
> +
> +grange:
> +	2000: 2000 mg or 2G Range
> +	8000: 8000 mg or 8G Range
> +
> +mdthr:
> +	X: X * 71mg (8G Range)
> +	X: X * 18mg (2G Range)
> +
> +mdfftmr:
> +	X: (X & 0x70) * 100 ms (MDTMR)
> +	   (X & 0x0F) * 2.5 ms (FFTMR 400 Hz)
> +	   (X & 0x0F) * 10 ms  (FFTMR 100 Hz)
> +
> +ffthr:
> +       X: (X >> 2) * 18mg (2G Range)
> +       X: (X & 0x0F) * 71 mg (8G Range)
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 1cf25ee..043ee8d 100755
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -340,4 +340,11 @@
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called pcap_keys.
> 
> +config INPUT_CMA3000_I2C
> +	bool "VTI CMA3000 Tri-axis accelerometer"

Why is it boolean? It should be possible to configure it as a module.

> +	depends on I2C && SYSFS

Is SYSFS a hard dependency? Why?

Overall I think you should have a symbol enabling CMA3000 core and then
sub-drivers enabling I2C and SPI interface parts. See adxl134x driver
for the pattern I am looking for. Now that I am done reading the driver
you seem to be pretty much there, just Kconfig needs to be massaged a
bit.

> +	help
> +	  Say Y here if you want to use VTI CMA3000 Accelerometer
> +	  through I2C interface.
> +
>  endif
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 07ee237..011161d 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -32,3 +32,4 @@
>  obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
>  obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
>  obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
> +obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x.o cma3000_d0x_i2c.o

Please try keep Makefile and Kconfig alphabetically ordered.

> diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
> new file mode 100644
> index 0000000..812c464
> --- /dev/null
> +++ b/drivers/input/misc/cma3000_d0x.c
> @@ -0,0 +1,633 @@
> +/*
> + * cma3000_d0x.c
> + * VTI CMA3000_D0x Accelerometer driver
> + *	Supports I2C/SPI interfaces
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
> +#define CMA3000_BUSI2C     (0 << 4)
> +#define CMA3000_MODEMASK   (7 << 1)
> +#define CMA3000_GRANGEMASK (1 << 7)
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
> + * Bit weights in mg for bit 0, other bits need
> + * multipy factor 2^n. Eight bit is the sign bit.
> + */
> +#define BIT_TO_2G  18
> +#define BIT_TO_8G  71
> +
> +/*
> + * Conversion for each of the eight modes to g, depending
> + * on G range i.e 2G or 8G. Some modes always operate in
> + * 8G.
> + */
> +
> +static int mode_to_mg[8][2] = {
> +	{0, 0},
> +	{BIT_TO_8G, BIT_TO_2G},
> +	{BIT_TO_8G, BIT_TO_2G},
> +	{BIT_TO_8G, BIT_TO_8G},
> +	{BIT_TO_8G, BIT_TO_8G},
> +	{BIT_TO_8G, BIT_TO_2G},
> +	{BIT_TO_8G, BIT_TO_2G},
> +	{0, 0},
> +};
> +
> +static ssize_t cma3000_show_attr_mode(struct device *dev,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	uint8_t mode;
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +
> +	mode = cma3000_read(data, CMA3000_CTRL, "ctrl");
> +	if (mode < 0)
> +		return mode;
> +
> +	return sprintf(buf, "%d\n", (mode & CMA3000_MODEMASK) >> 1);
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
> +		goto err_op3_failed;
> +
> +	if (val < CMAMODE_DEFAULT || val > CMAMODE_POFF) {
> +		error = -EINVAL;
> +		goto err_op3_failed;
> +	}
> +
> +	mutex_lock(&data->mutex);
> +	val &= (CMA3000_MODEMASK >> 1);
> +	ctrl = cma3000_read(data, CMA3000_CTRL, "ctrl");
> +	if (ctrl < 0) {
> +		error = ctrl;
> +		goto err_op2_failed;
> +	}
> +
> +	ctrl &= ~CMA3000_MODEMASK;
> +	ctrl |= (val << 1);
> +	data->pdata.mode = val;
> +	disable_irq(data->client->irq);
> +
> +	error = cma3000_set(data, CMA3000_CTRL, ctrl, "ctrl");
> +	if (error < 0)
> +		goto err_op1_failed;
> +
> +	/* Settling time delay required after mode change */
> +	msleep(CMA3000_SETDELAY);
> +
> +	enable_irq(data->client->irq);
> +	mutex_unlock(&data->mutex);
> +	return count;
> +
> +err_op1_failed:
> +	enable_irq(data->client->irq);
> +err_op2_failed:
> +	mutex_unlock(&data->mutex);
> +err_op3_failed:
> +	return error;


Do not like repeated release of resources in main and error path... Can
we do it like:

	...
	disable_irq();
	error = cma3000_set(data, CMA3000_CTRL, ctrl, "ctrl");
	if (!error) {
		/* Settling time delay required after mode change */
		msleep(CMA3000_SETDELAY);
	}
	enable_irq();
out:
	mutex_unlock();
	return error ? error : count;


> +}
> +
> +static ssize_t cma3000_show_attr_grange(struct device *dev,
> +				       struct device_attribute *attr,
> +				       char *buf)
> +{
> +	uint8_t mode;
> +	int g_range;
> +
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +
> +	mode = cma3000_read(data, CMA3000_CTRL, "ctrl");
> +	if (mode < 0)
> +		return mode;
> +
> +	g_range = (mode & CMA3000_GRANGEMASK) ? CMARANGE_2G : CMARANGE_8G;
> +	return sprintf(buf, "%d\n", g_range);
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
> +		goto err_op3_failed;
> +
> +	mutex_lock(&data->mutex);
> +	ctrl = cma3000_read(data, CMA3000_CTRL, "ctrl");
> +	if (ctrl < 0) {
> +		error = ctrl;
> +		goto err_op2_failed;
> +	}
> +
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
> +		goto err_op2_failed;
> +	}
> +
> +	g_range = data->pdata.g_range;
> +	fuzz_x = data->pdata.fuzz_x;
> +	fuzz_y = data->pdata.fuzz_y;
> +	fuzz_z = data->pdata.fuzz_z;
> +
> +	disable_irq(data->client->irq);
> +	error = cma3000_set(data, CMA3000_CTRL, ctrl, "ctrl");
> +	if (error < 0)
> +		goto err_op1_failed;
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
> +	return count;
> +
> +err_op1_failed:
> +	enable_irq(data->client->irq);
> +err_op2_failed:
> +	mutex_unlock(&data->mutex);
> +err_op3_failed:
> +	return error;
> +}
> +
> +static ssize_t cma3000_show_attr_mdthr(struct device *dev,
> +				      struct device_attribute *attr,
> +				      char *buf)
> +{
> +	uint8_t mode;
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +
> +	mode = cma3000_read(data, CMA3000_MDTHR, "mdthr");
> +	if (mode < 0)
> +		return mode;
> +
> +	return sprintf(buf, "%d\n", mode);
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
> +	disable_irq(data->client->irq);
> +	error = cma3000_set(data, CMA3000_MDTHR, val, "mdthr");
> +	enable_irq(data->client->irq);
> +	mutex_unlock(&data->mutex);
> +
> +	/* If there was error during write, return error */
> +	if (error < 0)
> +		return error;
> +	else
> +		return count;
> +}
> +
> +static ssize_t cma3000_show_attr_mdfftmr(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	uint8_t mode;
> +
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +
> +	mode = cma3000_read(data, CMA3000_MDFFTMR, "mdfftmr");
> +	if (mode < 0)
> +		return mode;
> +
> +	return sprintf(buf, "%d\n", mode);
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
> +	disable_irq(data->client->irq);
> +	error = cma3000_set(data, CMA3000_MDFFTMR, val, "mdthr");
> +	enable_irq(data->client->irq);
> +	mutex_unlock(&data->mutex);
> +
> +	/* If there was error during write, return error */
> +	if (error < 0)
> +		return error;
> +	else
> +		return count;
> +}
> +
> +static ssize_t cma3000_show_attr_ffthr(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	uint8_t mode;
> +
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +
> +	mode = cma3000_read(data, CMA3000_FFTHR, "ffthr");
> +	if (mode < 0)
> +		return mode;
> +
> +	return sprintf(buf, "%d\n", mode);
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
> +	disable_irq(data->client->irq);
> +	error = cma3000_set(data, CMA3000_FFTHR, val, "mdthr");
> +	enable_irq(data->client->irq);
> +	mutex_unlock(&data->mutex);
> +
> +	/* If there was error during write, return error */
> +	if (error < 0)
> +		return error;
> +	else
> +		return count;
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
> +static void decode_mg(struct cma3000_accl_data *data, int *datax,
> +				int *datay, int *dataz)
> +{
> +	/* Data in 2's complement, convert to mg */
> +	*datax = (((s8)(*datax)) * (data->bit_to_mg));
> +	*datay = (((s8)(*datay)) * (data->bit_to_mg));
> +	*dataz = (((s8)(*dataz)) * (data->bit_to_mg));
> +}
> +
> +static irqreturn_t cma3000_thread_irq(int irq, void *dev_id)
> +{
> +	struct cma3000_accl_data *data = dev_id;
> +	int  datax, datay, dataz;
> +	u8 ctrl, mode, range, intr_status;
> +
> +	intr_status = cma3000_read(data, CMA3000_INTSTATUS, "interrupt status");
> +	if (intr_status < 0)
> +		return IRQ_NONE;
> +
> +	/* Check if free fall is detected, report immediately */
> +	if (intr_status & CMA3000_INTSTATUS_FFDET) {
> +		input_report_abs(data->input_dev, ABS_MISC, 1);
> +		input_sync(data->input_dev);
> +	} else {
> +		input_report_abs(data->input_dev, ABS_MISC, 0);
> +	}
> +
> +	datax = cma3000_read(data, CMA3000_DOUTX, "X");
> +	datay = cma3000_read(data, CMA3000_DOUTY, "Y");
> +	dataz = cma3000_read(data, CMA3000_DOUTZ, "Z");
> +
> +	ctrl = cma3000_read(data, CMA3000_CTRL, "ctrl");
> +	mode = (ctrl & CMA3000_MODEMASK) >> 1;
> +	range = (ctrl & CMA3000_GRANGEMASK) >> 7;
> +
> +	data->bit_to_mg = mode_to_mg[mode][range];
> +
> +	/* Interrupt not for this device */
> +	if (data->bit_to_mg == 0)
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
> +	if (ret < 0) {
> +		dev_err(&data->client->dev, "Reset failed\n");
> +		return ret;
> +	} else if (ret & CMA3000_STATUS_PERR) {
> +		dev_err(&data->client->dev, "Parity Error\n");
> +		return -EIO;
> +	} else {
> +		return 0;
> +	}
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
> +#ifdef CONFIG_INPUT_CMA3000_I2C
> +	ctrl |= CMA3000_BUSI2C;
> +#endif
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
> +		dev_err(&data->client->dev, "platform data not found\n");
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

What is the utility of the driver when there is no IRQ line?

> +
> +	ret = sysfs_create_group(&data->client->dev.kobj, &cma3000_attr_group);
> +	if (ret) {
> +		dev_err(&data->client->dev,
> +			"failed to create sysfs entries\n");
> +		goto err_op1_failed;
> +	}
> +	return 0;
> +
> +err_op1_failed:
> +	mutex_destroy(&data->mutex);
> +	input_unregister_device(data->input_dev);
> +err_op2_failed:
> +	if (data != NULL) {

How can data be NULL here?

> +		if (data->input_dev != NULL)
> +			input_free_device(data->input_dev);

Do not call input_free_device() after input_unregister_device().

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

You should not call input_free_device() after input_unregister_device().

> +	sysfs_remove_group(&data->client->dev.kobj, &cma3000_attr_group);

I'd move this up, before you marked mutex as destroyed...

> +	return ret;
> +}
> diff --git a/drivers/input/misc/cma3000_d0x.h b/drivers/input/misc/cma3000_d0x.h
> new file mode 100644
> index 0000000..12a8faf
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
> +	int bit_to_mg;
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
> index 0000000..41f845c
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
> +#include <linux/slab.h>
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

Do you expect SPI version to have significantly different platform data?
Should it be moved out of include/linux/i2c/?

Thanks.

-- 
Dmitry
