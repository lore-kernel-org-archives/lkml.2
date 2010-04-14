Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0DNOJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:09:24 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:40310 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab0DNOJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:09:18 -0400
X-Greylist: delayed 1420 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2010 10:09:17 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BC5C7A8.1040807@cam.ac.uk>
Date: Wed, 14 Apr 2010 14:48:24 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: linux-i2c@vger.kernel.org, khali@linux-fr.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hmc6352: Add driver for the HMC6352 compass
References: <20100414124913.23181.75903.stgit@localhost.localdomain> <20100414125136.23181.16788.stgit@localhost.localdomain>
In-Reply-To: <20100414125136.23181.16788.stgit@localhost.localdomain>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Alan, Kalhan, 

Couple of comments below.
On 04/14/10 13:51, Alan Cox wrote:
> From: Kalhan Trisal <kalhan.trisal@intel.com>
> 
> This driver will report the heading values in degrees to the sysfs interface.
> The values returned are headings . e.g. 245.6
> 
> (Some cleanups from Alan Cox)
> 
> Signed-off-by: Kalhan Trisal <kalhan.trisal@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/hwmon/Kconfig   |    7 +
>  drivers/hwmon/Makefile  |    1 
>  drivers/hwmon/hmc6352.c |  235 +++++++++++++++++++++++++++++++++++++++++++++++
This is in no way a hwmon chip.  Surely misc is a better location for now
(pending the usual discussion about all singing all dancing sensors frameworks).

>  3 files changed, 243 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/hmc6352.c
> 
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index d38447f..74f672d 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1088,6 +1088,13 @@ config SENSORS_MC13783_ADC
>          help
>            Support for the A/D converter on MC13783 PMIC.
>  
> +config SENSORS_HMC6352
> +	tristate "Honeywell HMC6352 compass"
> +	depends on I2C
> +	help
> +	  This driver provides support for the Honeywell HMC6352 compass,
> +	  providing configuration and heading data via sysfs.
> +
>  if ACPI
>  
>  comment "ACPI drivers"
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 4aa1a3d..ad2ed36 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -49,6 +49,7 @@ obj-$(CONFIG_SENSORS_GL518SM)	+= gl518sm.o
>  obj-$(CONFIG_SENSORS_GL520SM)	+= gl520sm.o
>  obj-$(CONFIG_SENSORS_ULTRA45)	+= ultra45_env.o
>  obj-$(CONFIG_SENSORS_HDAPS)	+= hdaps.o
> +obj-$(CONFIG_SENSORS_HMC6352)	+= hmc6352.o
>  obj-$(CONFIG_SENSORS_I5K_AMB)	+= i5k_amb.o
>  obj-$(CONFIG_SENSORS_IBMAEM)	+= ibmaem.o
>  obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
> diff --git a/drivers/hwmon/hmc6352.c b/drivers/hwmon/hmc6352.c
> new file mode 100644
> index 0000000..926982f
> --- /dev/null
> +++ b/drivers/hwmon/hmc6352.c
> @@ -0,0 +1,235 @@
> +/*
> + * hmc6352.c - Honeywell Compass Driver
> + *
> + * Copyright (C) 2009 Intel Corp
> + *
> + *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/hwmon.h>

Why these extra hwmon includes?  At least at first glance I can't see
any uses of them.  The only call to hwmon is to stick this in the
hwmon class.
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/hwmon-vid.h>
> +#include <linux/err.h>
> +#include <linux/delay.h>
or any mutex usage?
> +#include <linux/mutex.h>
> +#include <linux/sysfs.h>
> +

I guess this makes the driver look like many others, but why bother with
the wrapping structure?  This is only used to keep track of the hwmon
device to be able to remove it later.
> +struct compass_data {
> +	struct device *hwmon_dev;
> +};
> +
> +static ssize_t compass_calibration_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	int ret;
> +	unsigned long val;
Personally I'd have gone with a couple of chars then passed their address into
the i2c_msg initializations.  Guess it doesn't matter either way though!
> +	char  cmd[] = {0x43};
> +	char  cmd1[] = {0x45};
> +	struct i2c_msg msg[] = {
> +		{ client->addr, 0, 1, cmd },
> +	};
> +	struct i2c_msg msg1[] = {
> +		{ client->addr, 0, 1, cmd1 },
> +	};
> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +	if (val == 1) {
These address changes looking a little unusual to me.  They may well be needed, but
if so can we have an explanatory comment?

> +		client->addr = 0x21;
> +		ret = i2c_transfer(client->adapter, msg, 1);
> +		if (ret != 1) {
> +			dev_warn(dev, "hmc6352_comp : i2c callib start cmd failed\n");
> +			return ret;
> +		}
> +	} else if (val == 2) {
> +		client->addr = 0x21;
> +		ret = i2c_transfer(client->adapter, msg1, 1);
> +		if (ret != 1) {
> +			dev_warn(dev, "hmc6352_comp : i2c callib stop cmd failed\n");
> +			return ret;
> +		}
> +	} else
> +		return -EINVAL;
> +
> +	return count;
> +}
> +
> +static ssize_t compass_heading_data_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +
> +	struct i2c_client *client = to_i2c_client(dev);
> +	static char cmd[] = { 0x41 };
> +	unsigned char i2c_data[2];
> +	unsigned int ret, ret_val;
> +	struct i2c_msg msg[] = {
> +		{ client->addr, 0, 1, cmd },
> +	};
> +	struct i2c_msg msg1[] = {
> +		{ client->addr, I2C_M_RD, 2, i2c_data },
> +	};
> +
> +	client->addr = 0x21;
> +	ret = i2c_transfer(client->adapter, msg, 1);
> +	if (ret != 1) {
> +		dev_warn(dev, "hmc6352 : i2c cmd  0x41 failed\n");
> +		return ret;
> +	}
> +	msleep(10); /* sending 0x41 cmd we need to wait for 7-10 milli second*/
> +	ret = i2c_transfer(client->adapter, msg1, 1);
> +	if (ret != 1) {
> +		dev_warn(dev, "hmc6352 : i2c read data cmd failed\n");
> +		return ret;
> +	}
> +	ret_val = i2c_data[0];
> +	ret_val = ((ret_val << 8) | i2c_data[1]);
> +	return sprintf(buf, "%d.%d\n", ret_val/10, ret_val%10);
> +}
> +
> +static ssize_t compass_power_mode_store(struct device *dev,
> +		struct device_attribute *attr, const  char *buf, size_t count)
> +{
> +
> +	struct i2c_client *client = to_i2c_client(dev);
> +	unsigned long val;
> +	unsigned int ret;
> +	static char cmd[] = { 0x53 };
> +	static char cmd1[] = { 0x57 };
> +	struct i2c_msg msg[] = {
> +		{ client->addr, 0, 1, cmd },
> +	};
> +	struct i2c_msg msg1[] = {
> +		{ client->addr, 0, 1, cmd1 },
> +	};
> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +
> +	if (val == 0) {
> +		ret = i2c_transfer(client->adapter, msg, 1);
> +		if (ret != 1)
> +			dev_warn(dev, "hmc6352: i2c cmd  sleep mode failed\n");
> +	} else if (val == 1) {
> +		ret = i2c_transfer(client->adapter, msg1, 1);
> +		if (ret != 1)
> +			dev_warn(dev, "hmc6352: i2c cmd active mode failed\n");
> +	} else
> +		return -EINVAL;
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(heading, S_IRUGO, compass_heading_data_show, NULL);
> +static DEVICE_ATTR(calibration, S_IWUSR, NULL, compass_calibration_store);
> +static DEVICE_ATTR(power_state, S_IWUSR, NULL, compass_power_mode_store);
> +
> +static struct attribute *mid_att_compass[] = {
> +	&dev_attr_heading.attr,
> +	&dev_attr_calibration.attr,
> +	&dev_attr_power_state.attr,
> +	NULL
> +};
> +
> +static struct attribute_group m_compass_gr = {
> +	.name = "hmc6352",
> +	.attrs = mid_att_compass
> +};
> +
> +static int  hmc6352_probe(struct i2c_client *client,
> +					const struct i2c_device_id *id)
> +{
> +	int res;
> +	struct compass_data *data;
> +
> +	data = kzalloc(sizeof(struct compass_data), GFP_KERNEL);
> +	if (data == NULL) {
> +		dev_err(&client->dev, "hmc6352: out of memory");
> +		return -ENOMEM;
> +	}
> +	i2c_set_clientdata(client, data);
> +
> +	res = sysfs_create_group(&client->dev.kobj, &m_compass_gr);
> +	if (res) {
> +		dev_err(&client->dev, "hmc6352: device_create_file failed\n");
> +		goto compass_error1;
> +	}
> +	data->hwmon_dev = hwmon_device_register(&client->dev);
> +	if (IS_ERR(data->hwmon_dev)) {
> +		res = PTR_ERR(data->hwmon_dev);
> +		data->hwmon_dev = NULL;
> +		dev_err(&client->dev, "hmc6352: fail to register hwmon device\n");
> +		sysfs_remove_group(&client->dev.kobj, &m_compass_gr);
> +		goto compass_error1;
> +	}
> +	dev_info(&client->dev, "%s HMC6352 compass chip found\n",
> +		client->name);
> +	return res;
> +
> +compass_error1:
> +	i2c_set_clientdata(client, NULL);
> +	kfree(data);
> +	return res;
> +}
> +
> +static int hmc6352_remove(struct i2c_client *client)
> +{
> +	struct compass_data *data = i2c_get_clientdata(client);
> +
> +	hwmon_device_unregister(data->hwmon_dev);
> +	sysfs_remove_group(&client->dev.kobj, &m_compass_gr);
> +	kfree(data);
> +	return 0;
> +}
> +

Why i2c_compass for the name? 
> +static struct i2c_device_id hmc6352_id[] = {
> +	{ "i2c_compass", 0 },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, hmc6352_id);
> +
> +static struct i2c_driver hmc6352_driver = {
> +	.driver = {
> +	.name = "hmc6352",
> +	},
> +	.probe = hmc6352_probe,
> +	.remove = hmc6352_remove,
> +	.id_table = hmc6352_id,
> +};
> +
> +static int __init _hmc6352_init(void)
> +{
> +	return i2c_add_driver(&hmc6352_driver);
> +}
> +
> +static void  __exit sensor_hmc6352_exit(void)
> +{
> +	i2c_del_driver(&hmc6352_driver);
> +}
> +
> +module_init(sensor_hmc6352_init);
> +module_exit(sensor_hmc6352_exit);
> +
> +MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com");
> +MODULE_DESCRIPTION("hmc6352 Compass Driver");
> +MODULE_LICENSE("GPL v2");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

