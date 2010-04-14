Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0DNQgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:36:53 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:58384 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab0DNQgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:36:43 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BC5EFC4.5030802@cam.ac.uk>
Date: Wed, 14 Apr 2010 17:39:32 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hmc6352: Add driver for the HMC6352 compass
References: <20100414124913.23181.75903.stgit@localhost.localdomain>	<20100414125136.23181.16788.stgit@localhost.localdomain>	<4BC5C7A8.1040807@cam.ac.uk>	<20100414153234.22765666@lxorguk.ukuu.org.uk>	<4BC5D681.20707@jic23.retrosnub.co.uk> <20100414161904.713eef78@lxorguk.ukuu.org.uk>
In-Reply-To: <20100414161904.713eef78@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me,

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

On 04/14/10 16:19, Alan Cox wrote:
> Ripping it out of hwmon and applying the hedge trimmers to everything not
> needed and we get this for drivers/misc. I've also swapped the command
> codes to characters as the datasheet specifies them in ascii.
> 
> --------------------------------8<------------------------------
> 
> hmc6352: Add driver for the HMC6352 compass
> 
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
>  drivers/misc/Kconfig   |    7 ++
>  drivers/misc/Makefile  |    1 
>  drivers/misc/hmc6352.c |  199 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 207 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/hmc6352.c
> 
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 2191c8d..e626bac 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -278,6 +278,13 @@ config SENSORS_TSL2550
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called tsl2550.
>  
> +config HMC6352
> +	tristate "Honeywell HMC6352 compass"
> +	depends on I2C
> +	help
> +	  This driver provides support for the Honeywell HMC6352 compass,
> +	  providing configuration and heading data via sysfs.
> +
>  config EP93XX_PWM
>  	tristate "EP93xx PWM support"
>  	depends on ARCH_EP93XX
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 208ae30..620cf0b 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -26,5 +26,6 @@ obj-$(CONFIG_DS1682)		+= ds1682.o
>  obj-$(CONFIG_TI_DAC7512)	+= ti_dac7512.o
>  obj-$(CONFIG_C2PORT)		+= c2port/
>  obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
> +obj-$(CONFIG_HMC6352)		+= hmc6352.o
>  obj-y				+= eeprom/
>  obj-y				+= cb710/
> diff --git a/drivers/misc/hmc6352.c b/drivers/misc/hmc6352.c
> new file mode 100644
> index 0000000..f4162ea
> --- /dev/null
> +++ b/drivers/misc/hmc6352.c
> @@ -0,0 +1,199 @@
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
> +#include <linux/err.h>
> +#include <linux/delay.h>
> +#include <linux/sysfs.h>
> +
> +static ssize_t compass_calibration_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	int ret;
> +	unsigned long val;
> +	char  cmd = 'C';	/* Calibrate */
> +	char  cmd1 = 'E';	/* Exit calibration mode */
> +	struct i2c_msg msg[] = {
> +		{ client->addr, 0, 1, &cmd },
> +	};
> +	struct i2c_msg msg1[] = {
> +		{ client->addr, 0, 1, &cmd1 },
> +	};
> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +	if (val == 1) {
> +		ret = i2c_transfer(client->adapter, msg, 1);
> +		if (ret != 1) {
> +			dev_warn(dev, "hmc6352_comp: i2c calib start cmd failed\n");
> +			return ret;
> +		}
> +	} else if (val == 2) {
> +		ret = i2c_transfer(client->adapter, msg1, 1);
> +		if (ret != 1) {
> +			dev_warn(dev, "hmc6352_comp: i2c calib stop cmd failed\n");
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
> +	static char cmd = 'A';		/* Get Data */
> +	unsigned char i2c_data[2];
> +	unsigned int ret, ret_val;
> +	struct i2c_msg msg[] = {
> +		{ client->addr, 0, 1, &cmd },
> +	};
> +	struct i2c_msg msg1[] = {
> +		{ client->addr, I2C_M_RD, 2, i2c_data },
> +	};
> +
> +	ret = i2c_transfer(client->adapter, msg, 1);
> +	if (ret != 1) {
> +		dev_warn(dev, "hmc6352: i2c cmd 0x41 failed\n");
> +		return ret;
> +	}
> +	msleep(10); /* sending 0x41 cmd we need to wait for 7-10 milli second*/
> +	ret = i2c_transfer(client->adapter, msg1, 1);
> +	if (ret != 1) {
> +		dev_warn(dev, "hmc6352: i2c read data cmd failed\n");
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
> +	static char cmd = 'S';		/* Sleep mode */
> +	static char cmd1 = 'W';		/* Wake up */
> +	struct i2c_msg msg[] = {
> +		{ client->addr, 0, 1, &cmd },
> +	};
> +	struct i2c_msg msg1[] = {
> +		{ client->addr, 0, 1, &cmd1 },
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
> +
> +	res = sysfs_create_group(&client->dev.kobj, &m_compass_gr);
> +	if (res) {
> +		dev_err(&client->dev, "hmc6352: device_create_file failed\n");
> +		return res;
> +	}
> +	dev_info(&client->dev, "%s HMC6352 compass chip found\n",
> +		client->name);
> +	return 0;
> +}
> +
> +static int hmc6352_remove(struct i2c_client *client)
> +{
> +	sysfs_remove_group(&client->dev.kobj, &m_compass_gr);
> +	return 0;
> +}
> +
> +static struct i2c_device_id hmc6352_id[] = {
> +	{ "hmc6352", 0 },
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
> +static int __init sensor_hmc6352_init(void)
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

