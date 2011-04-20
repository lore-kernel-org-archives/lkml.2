Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1DTJVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:21:42 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:58105 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab1DTJVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:21:39 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DAEA618.4040801@cam.ac.uk>
Date: Wed, 20 Apr 2011 10:23:36 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
References: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com>
In-Reply-To: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/11 22:36, Guenter Roeck wrote:
> This driver adds support for Si570, Si571, Si598, and Si599
> programmable XO/VCXO.
cc'd Michael Hennerich, as I would imagine this has some similarities to the DDS
chips we have in IIO (be it a very simple one).

Guenter, what is your use case for this part?

> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
> v2:
> - Fixed checkpatch errors and warnings
> - Moved si570.h platform data include file to include/linux/platform_data
> - Documented reset sysfs attribute
> - Added Documentation/ABI/testing/sysfs-bus-i2c-si570
> 
>  Documentation/ABI/testing/sysfs-bus-i2c-si570 |   21 ++
>  Documentation/misc-devices/si570              |   62 ++++
>  MAINTAINERS                                   |    7 +
>  drivers/misc/Kconfig                          |   10 +
>  drivers/misc/Makefile                         |    1 +
>  drivers/misc/si570.c                          |  398 +++++++++++++++++++++++++
>  include/linux/platform_data/si570.h           |   23 ++
>  7 files changed, 522 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c-si570
>  create mode 100644 Documentation/misc-devices/si570
>  create mode 100644 drivers/misc/si570.c
>  create mode 100644 include/linux/platform_data/si570.h
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-i2c-si570 b/Documentation/ABI/testing/sysfs-bus-i2c-si570
> new file mode 100644
> index 0000000..78c43f7
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-i2c-si570
> @@ -0,0 +1,21 @@
> +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/frequency
> +Date:		April 2011
> +Kernel version:	2.6.40 ?
> +Contact:	Guenter Roeck <guenter.roeck@ericsson.com>
> +Description:
> +		Read or write XO/VCXO frequency of the device in Hz.
> +
> +		Accepted values: 10 MHz to 1400 MHz for Si570 and Si571,
> +		10 MHz to 525 MHz for Si598 and Si599.
> +Users:
> +		Userspace applications interested in knowing or changing the
> +		device frequency.
> +
> +What:		/sys/bus/i2c/devices/<busnum>-<devaddr>/reset
> +Date:		April 2011
> +Kernel Version: 2.6.40 ?
> +Contact:	Guenter Roeck <guenter.roeck@ericsson.com>
> +Description:	Writing a value other than 0 resets the device.
> +		Reading always returns 0 and has no effect.
> +Users:
> +		Userspace applications interested in resetting the device.
> diff --git a/Documentation/misc-devices/si570 b/Documentation/misc-devices/si570
> new file mode 100644
> index 0000000..54e32f7
> --- /dev/null
> +++ b/Documentation/misc-devices/si570
> @@ -0,0 +1,62 @@
> +Kernel driver si570
> +=====================
> +
> +Supported chips:
> +  * Silicon Labs Si570/Si571
> +    Prefix: 'si570'
> +    Addresses scanned: None (see below)
> +    Datasheets:
> +        http://www.silabs.com/Support%20Documents/TechnicalDocs/si570.pdf
> +  * Silicon Labs Si598/Si599
> +    Prefix: 'si598'
> +    Addresses scanned: None (see below)
> +    Datasheets:
> +	http://www.silabs.com/Support%20Documents/TechnicalDocs/si598-99.pdf
> +
> +Author: Guenter Roeck <guenter.roeck@ericsson.com>
> +
> +
> +Description
> +-----------
> +
> +The Si570/Si598 XO and Si571/Si599 VCXO provide a low-jitter clock at any
> +frequency.
> +
> +The Si570/Si571 are user-programmable to any output frequency from 10 to 945 MHz
> +and select frequencies to 1400 MHz with <1 ppb resolution.
> +
> +The Si598/Si599 are user programmable to any output frequency from 10 to 525 MHz
> +with 28 parts per trillion (ppt) resolution.
> +
> +See the datasheets for more information.
> +
> +
> +Sysfs entries
> +-------------
> +
> +frequency	- Selected frequency
> +reset		- Writing a value other than 0 resets the device
> +
> +
> +General Remarks
> +---------------
> +
> +The chips support all valid 7-bit I2C addresses. I2C addresses are assigned
> +during the ordering process.
> +
> +This driver does not auto-detect devices. You will have to instantiate the
> +devices explicitly. Please see Documentation/i2c/instantiating-devices for
> +details.
> +
> +
> +Platform data
> +-------------
> +
> +The devices can be provided with platform data to select the factory default
> +output frequency. If platform data is not specified, the driver will assume a
> +default factory output frequency of 125 MHz for Si570/Si571 and 10 MHz for
> +Si598/Si599.
> +
> +struct si570_platform_data {
> +	unsigned long fout;	/* Factory default output frequency */
> +};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ec36003..4c339ea 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5406,6 +5406,13 @@ L:	linux-serial@vger.kernel.org
>  S:	Maintained
>  F:	drivers/tty/serial
>  
> +SI570 DRIVER
> +M:	Guenter Roeck <guenter.roeck@ericsson.com>
> +L:	linux-kernel@vger.kernel.org
> +S:	Maintained
> +F:	drivers/misc/si570.c
> +F:	include/linux/platform_data/si570.h
> +
>  TIMEKEEPING, NTP
>  M:	John Stultz <johnstul@us.ibm.com>
>  M:	Thomas Gleixner <tglx@linutronix.de>
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 4e007c6..c7041c9 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -475,6 +475,16 @@ config PCH_PHUB
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called pch_phub.
>  
> +config SI570
> +	tristate "Silicon Labs Si570/Si571/Si598/Si599"
> +	depends on I2C && SYSFS && EXPERIMENTAL
> +	help
> +	  This is a driver for Silicon Labs Si570/Si571/Si598/Si599 programmable
> +	  XO/VCXO.
> +
> +	  To compile this driver as a module, choose M here: the module will
> +	  be called si570.
> +
>  source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index f546860..a2397c6 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -41,6 +41,7 @@ obj-$(CONFIG_SPEAR13XX_PCIE_GADGET)	+= spear13xx_pcie_gadget.o
>  obj-$(CONFIG_VMWARE_BALLOON)	+= vmw_balloon.o
>  obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
>  obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
> +obj-$(CONFIG_SI570)		+= si570.o
>  obj-y				+= ti-st/
>  obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
>  obj-y				+= lis3lv02d/
> diff --git a/drivers/misc/si570.c b/drivers/misc/si570.c
> new file mode 100644
> index 0000000..69a3806
> --- /dev/null
> +++ b/drivers/misc/si570.c
> @@ -0,0 +1,398 @@
> +/*
> + * Driver for Silicon Labs Si570/Si571 Programmable XO/VCXO
> + *
> + * Copyright (C) 2011 Ericsson AB.
> + *
> + * Author: Guenter Roeck <guenter.roeck@ericsson.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/jiffies.h>
> +#include <linux/i2c.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/delay.h>
> +#include <linux/log2.h>
> +#include <linux/slab.h>
> +#include <linux/platform_data/si570.h>
> +
> +/* Si570 registers */
> +#define SI570_REG_HS_N1		7
> +#define SI570_REG_N1_RFREQ0	8
> +#define SI570_REG_RFREQ1	9
> +#define SI570_REG_RFREQ2	10
> +#define SI570_REG_RFREQ3	11
> +#define SI570_REG_RFREQ4	12
> +#define SI570_REG_CONTROL	135
> +#define SI570_REG_FREEZE_DCO	137
> +
> +#define HS_DIV_SHIFT		5
> +#define HS_DIV_MASK		0xe0
> +#define HS_DIV_OFFSET		4
> +#define N1_6_2_MASK		0x1f
> +#define N1_1_0_MASK		0xc0
> +#define RFREQ_37_32_MASK	0x3f
> +
> +#define SI570_FOUT_FACTORY_DFLT	125000000LL
> +#define SI598_FOUT_FACTORY_DFLT	10000000LL
> +
> +#define SI570_MIN_FREQ		10000000L
> +#define SI570_MAX_FREQ		1417500000L
> +#define SI598_MAX_FREQ		525000000L
> +
> +#define FDCO_MIN		4850000000LL
> +#define FDCO_MAX		5670000000LL
> +#define FDCO_CENTER		((FDCO_MIN + FDCO_MAX) / 2)
> +
> +#define SI570_CNTRL_RECALL	(1 << 0)
> +#define SI570_CNTRL_FREEZE_ADC	(1 << 4)
> +#define SI570_CNTRL_FREEZE_M	(1 << 5)
> +#define SI570_CNTRL_NEWFREQ	(1 << 6)
> +#define SI570_CNTRL_RESET	(1 << 7)
> +
> +#define SI570_FREEZE_DCO	(1 << 4)
> +
> +struct si570_data {
> +	struct attribute_group attrs;
> +	struct mutex lock;
> +	u64 max_freq;
> +	u64 fout;		/* Factory default frequency */
> +	u64 fxtal;		/* Factory xtal frequency */
> +	unsigned int n1;
> +	unsigned int hs_div;
> +	u64 rfreq;
> +	u64 frequency;
> +};
> +
> +static int si570_get_defaults(struct i2c_client *client)
> +{
> +	struct si570_data *data = i2c_get_clientdata(client);
> +	int reg1, reg2, reg3, reg4, reg5, reg6;
> +	u64 fdco;
> +
> +	i2c_smbus_write_byte_data(client, SI570_REG_CONTROL,
> +				  SI570_CNTRL_RECALL);
> +
> +	reg1 = i2c_smbus_read_byte_data(client, SI570_REG_HS_N1);
> +	if (reg1 < 0)
> +		return reg1;
> +	reg2 = i2c_smbus_read_byte_data(client, SI570_REG_N1_RFREQ0);
> +	if (reg2 < 0)
> +		return reg2;
> +	reg3 = i2c_smbus_read_byte_data(client, SI570_REG_RFREQ1);
> +	if (reg3 < 0)
> +		return reg3;
> +	reg4 = i2c_smbus_read_byte_data(client, SI570_REG_RFREQ2);
> +	if (reg4 < 0)
> +		return reg4;
> +	reg5 = i2c_smbus_read_byte_data(client, SI570_REG_RFREQ3);
> +	if (reg5 < 0)
> +		return reg5;
> +	reg6 = i2c_smbus_read_byte_data(client, SI570_REG_RFREQ4);
> +	if (reg6 < 0)
> +		return reg6;
> +
> +	data->hs_div = ((reg1 & HS_DIV_MASK) >> HS_DIV_SHIFT) + HS_DIV_OFFSET;
> +	data->n1 = ((reg1 & N1_6_2_MASK) << 2) + ((reg2 & N1_1_0_MASK) >> 6)
> +	  + 1;
> +	/* Handle invalid cases */
> +	if (data->n1 > 1)
> +		data->n1 &= ~1;
> +
> +	data->rfreq = reg2 & RFREQ_37_32_MASK;
> +	data->rfreq = (data->rfreq << 8) + reg3;
> +	data->rfreq = (data->rfreq << 8) + reg4;
> +	data->rfreq = (data->rfreq << 8) + reg5;
> +	data->rfreq = (data->rfreq << 8) + reg6;
> +
> +	/*
> +	 * Accept optional precision loss to avoid arithmetic overflows.
> +	 * Acceptable per Silicon Labs Application Note AN334.
> +	 */
> +	fdco = data->fout * data->n1 * data->hs_div;
> +	if (fdco >= (1LL << 36))
> +		data->fxtal = (fdco << 24) / (data->rfreq >> 4);
> +	else
> +		data->fxtal = (fdco << 28) / data->rfreq;
> +
> +	data->frequency = data->fout;
> +
> +	return 0;
> +}
> +
> +/*
> + * Update rfreq registers
> + * This function must be called with update mutex lock held.
> + */
> +static void si570_update_rfreq(struct i2c_client *client,
> +			       struct si570_data *data)
> +{
> +	i2c_smbus_write_byte_data(client, SI570_REG_N1_RFREQ0,
> +				  ((data->n1 - 1) << 6)
> +				  | ((data->rfreq >> 32) & RFREQ_37_32_MASK));
> +	i2c_smbus_write_byte_data(client, SI570_REG_RFREQ1,
> +				  (data->rfreq >> 24) & 0xff);
> +	i2c_smbus_write_byte_data(client, SI570_REG_RFREQ2,
> +				  (data->rfreq >> 16) & 0xff);
> +	i2c_smbus_write_byte_data(client, SI570_REG_RFREQ3,
> +				  (data->rfreq >> 8) & 0xff);
> +	i2c_smbus_write_byte_data(client, SI570_REG_RFREQ4,
> +				  data->rfreq & 0xff);
> +}
> +
> +/*
> + * Update si570 frequency for small frequency changes (< 3,500 ppm)
> + * This function must be called with update mutex lock held.
> + */
> +static int si570_set_frequency_small(struct i2c_client *client,
> +				     struct si570_data *data,
> +				     unsigned long frequency)
> +{
> +	data->frequency = frequency;
> +	data->rfreq = DIV_ROUND_CLOSEST(data->rfreq * frequency,
> +					data->frequency);
> +	i2c_smbus_write_byte_data(client, SI570_REG_CONTROL,
> +				  SI570_CNTRL_FREEZE_M);
> +	si570_update_rfreq(client, data);
> +	i2c_smbus_write_byte_data(client, SI570_REG_CONTROL, 0);
> +
> +	return 0;
> +}
> +
> +const uint8_t si570_hs_div_values[] = { 11, 9, 7, 6, 5, 4 };
> +
> +/*
> + * Set si570 frequency.
> + * This function must be called with update mutex lock held.
> + */
> +static int si570_set_frequency(struct i2c_client *client,
> +			       struct si570_data *data,
> +			       unsigned long frequency)
> +{
> +	int i, n1, hs_div;
> +	u64 fdco, best_fdco = ULLONG_MAX;
> +
> +	for (i = 0; i < ARRAY_SIZE(si570_hs_div_values); i++) {
> +		hs_div = si570_hs_div_values[i];
> +		/* Calculate lowest possible value for n1 */
> +		n1 = FDCO_MIN / (u64)hs_div / (u64)frequency;
> +		if (!n1 || (n1 & 1))
> +			n1++;
> +		while (n1 <= 128) {
> +			fdco = (u64)frequency * (u64)hs_div * (u64)n1;
> +			if (fdco > FDCO_MAX)
> +				break;
> +			if (fdco >= FDCO_MIN && fdco < best_fdco) {
> +				data->n1 = n1;
> +				data->hs_div = hs_div;
> +				data->frequency = frequency;
> +				data->rfreq = (fdco << 28) / data->fxtal;
> +				best_fdco = fdco;
> +			}
> +			n1 += (n1 == 1 ? 1 : 2);
> +		}
> +	}
> +	if (best_fdco == ULLONG_MAX)
> +		return -EINVAL;
> +
> +	i2c_smbus_write_byte_data(client, SI570_REG_FREEZE_DCO,
> +				  SI570_FREEZE_DCO);
> +	i2c_smbus_write_byte_data(client, SI570_REG_HS_N1,
> +				  ((data->hs_div - HS_DIV_OFFSET) <<
> +				   HS_DIV_SHIFT)
> +				  | (((data->n1 - 1) >> 2) & N1_6_2_MASK));
> +	si570_update_rfreq(client, data);
> +	i2c_smbus_write_byte_data(client, SI570_REG_FREEZE_DCO,
> +				  0);
> +	i2c_smbus_write_byte_data(client, SI570_REG_CONTROL,
> +				  SI570_CNTRL_NEWFREQ);
> +	return 0;
> +}
> +
> +/*
> + * Reset chip.
> + * This function must be called with update mutex lock held.
> + */
> +static int si570_reset(struct i2c_client *client, struct si570_data *data)
> +{
> +	i2c_smbus_write_byte_data(client, SI570_REG_CONTROL,
> +				  SI570_CNTRL_RESET);
> +	usleep_range(1000, 5000);
> +	return si570_set_frequency(client, data, data->frequency);
> +}
> +
> +static ssize_t show_frequency(struct device *dev,
> +			      struct device_attribute *devattr,
> +			      char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct si570_data *data = i2c_get_clientdata(client);
> +
> +	return sprintf(buf, "%llu\n", data->frequency);
> +}
> +
> +static ssize_t set_frequency(struct device *dev,
> +			     struct device_attribute *attr,
> +			     const char *buf, size_t count)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct si570_data *data = i2c_get_clientdata(client);
> +	unsigned long val;
> +	int err;
> +
> +	err = strict_strtoul(buf, 10, &val);
> +	if (err)
> +		return err;
> +
> +	if (val < SI570_MIN_FREQ || val > data->max_freq)
> +		return -EINVAL;
> +
> +	mutex_lock(&data->lock);
> +	if (abs(val - data->frequency) * 10000LL / data->frequency < 35)
> +		err = si570_set_frequency_small(client, data, val);
> +	else
> +		err = si570_set_frequency(client, data, val);
> +	mutex_unlock(&data->lock);
> +	if (err)
> +		return err;
> +
> +	return count;
> +}
> +static ssize_t show_reset(struct device *dev,
> +			  struct device_attribute *devattr,
> +			  char *buf)
> +{
> +	return sprintf(buf, "%d\n", 0);
> +}
> +
> +static ssize_t set_reset(struct device *dev,
> +			 struct device_attribute *attr,
> +			 const char *buf, size_t count)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct si570_data *data = i2c_get_clientdata(client);
> +	unsigned long val;
> +	int err;
> +
> +	err = strict_strtoul(buf, 10, &val);
> +	if (err)
> +		return err;
> +	if (val == 0)
> +		goto done;
> +
> +	mutex_lock(&data->lock);
> +	err = si570_reset(client, data);
> +	mutex_unlock(&data->lock);
> +	if (err)
> +		return err;
> +done:
> +	return count;
> +}
> +
> +static DEVICE_ATTR(frequency, S_IWUSR | S_IRUGO, show_frequency, set_frequency);
> +static DEVICE_ATTR(reset, S_IWUSR | S_IRUGO, show_reset, set_reset);
> +
> +static struct attribute *si570_attr[] = {
> +	&dev_attr_frequency.attr,
> +	&dev_attr_reset.attr,
> +	NULL
> +};
> +
> +static const struct i2c_device_id si570_id[] = {
> +	{ "si570", 0 },
> +	{ "si571", 0 },
> +	{ "si598", 1 },
> +	{ "si599", 1 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, si570_id);
> +
> +static int si570_probe(struct i2c_client *client,
> +		       const struct i2c_device_id *id)
> +{
> +	struct si570_platform_data *pdata = client->dev.platform_data;
> +	struct si570_data *data;
> +	int err;
> +
> +	data = kzalloc(sizeof(struct si570_data), GFP_KERNEL);
> +	if (!data) {
> +		err = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	if (id->driver_data) {
> +		data->fout = SI598_FOUT_FACTORY_DFLT;
> +		data->max_freq = SI598_MAX_FREQ;
> +	} else {
> +		data->fout = SI570_FOUT_FACTORY_DFLT;
> +		data->max_freq = SI570_MAX_FREQ;
> +	}
> +
> +	if (pdata && pdata->fout)
> +		data->fout = pdata->fout;
> +
> +	i2c_set_clientdata(client, data);
> +	err = si570_get_defaults(client);
> +	if (err < 0)
> +		goto exit_free;
> +
> +	mutex_init(&data->lock);
> +
> +	/* Register sysfs hooks */
> +	data->attrs.attrs = si570_attr;
> +	err = sysfs_create_group(&client->dev.kobj, &data->attrs);
> +	if (err)
> +		goto exit_free;
> +
> +	return 0;
> +
> +exit_free:
> +	kfree(data);
> +exit:
> +	return err;
> +}
> +
> +static int si570_remove(struct i2c_client *client)
> +{
> +	struct si570_data *data = i2c_get_clientdata(client);
> +
> +	sysfs_remove_group(&client->dev.kobj, &data->attrs);
> +	kfree(data);
> +	return 0;
> +}
> +
> +static struct i2c_driver si570_driver = {
> +	.driver = {
> +		.name	= "si570",
> +	},
> +	.probe		= si570_probe,
> +	.remove		= si570_remove,
> +	.id_table	= si570_id,
> +};
> +
> +static int __init si570_init(void)
> +{
> +	return i2c_add_driver(&si570_driver);
> +}
> +
> +static void __exit si570_exit(void)
> +{
> +	i2c_del_driver(&si570_driver);
> +}
> +
> +MODULE_AUTHOR("Guenter Roeck <guenter.roeck@ericsson.com>");
> +MODULE_DESCRIPTION("Si570 driver");
> +MODULE_LICENSE("GPL");
> +
> +module_init(si570_init);
> +module_exit(si570_exit);
> diff --git a/include/linux/platform_data/si570.h b/include/linux/platform_data/si570.h
> new file mode 100644
> index 0000000..22ec865
> --- /dev/null
> +++ b/include/linux/platform_data/si570.h
> @@ -0,0 +1,23 @@
> +/*
> + * si570.h - Configuration for si570 misc driver.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation (version 2 of the License only).
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __LINUX_SI570_H
> +#define __LINUX_SI570_H
> +
> +#include <linux/types.h>
> +
> +struct si570_platform_data {
> +	unsigned long fout;	/* Factory default output frequency */
> +};
> +
> +#endif /* __LINUX_SI570_H */

