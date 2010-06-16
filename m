Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab0FPNLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:11:05 -0400
Received: from poutre.nerim.net ([62.4.16.124]:57981 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab0FPNLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:11:03 -0400
Date: Wed, 16 Jun 2010 15:10:56 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hmc6352: Add driver for the HMC6352 compass
Message-ID: <20100616151056.181234b0@hyperion.delvare>
In-Reply-To: <20100616121534.26294.12540.stgit@localhost.localdomain>
References: <20100616121534.26294.12540.stgit@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, 16 Jun 2010 13:16:14 +0100, Alan Cox wrote:
> From: Kalhan Trisal <kalhan.trisal@intel.com>
> 
> This driver will report the heading values in degrees to the sysfs interface.
> The values returned are headings . e.g. 245.6
> 
> Cleanups requested now all folded in and a sysfs descriptio to keep Andrew
> happy.

Typo: description.

Quick review:

> Signed-off-by: Kalhan Trisal <kalhan.trisal@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  .../ABI/testing/sysfs-bus-i2c-devices-hm6352       |   21 ++
>  drivers/misc/Kconfig                               |    7 +
>  drivers/misc/Makefile                              |    1 
>  drivers/misc/hmc6352.c                             |  199 ++++++++++++++++++++
>  4 files changed, 228 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c-devices-hm6352
>  create mode 100644 drivers/misc/hmc6352.c
> 
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-i2c-devices-hm6352 b/Documentation/ABI/testing/sysfs-bus-i2c-devices-hm6352
> new file mode 100644
> index 0000000..fbedf77
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-i2c-devices-hm6352
> @@ -0,0 +1,21 @@
> +Where:		/sys/bus/i2c/devices/.../heading
> +Date:		April 2010
> +Kernel Version: 2.6.36?
> +Contact:	alan.cox@intel.com
> +Description:	Reports the current heading from the compass as a floating
> +		point value in degrees.
> +
> +Where:		/sys/bus/i2c/devices/.../power_state
> +Date:		April 2010
> +Kernel Version: 2.6.36?
> +Contact:	alan.cox@intel.com
> +Description:	Sets the power state of the device. 0 sets the device into
> +		sleep mode, 1 wakes it up.
> +
> +Where:		/sys/bus/i2c/devices/.../calibration
> +Date:		April 2010
> +Kernel Version: 2.6.36?
> +Contact:	alan.cox@intel.com
> +Description:	Sets the calibration on or off (1 = on, 0 = off). See the
> +		chip data sheet.
> +
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 26386a9..9e825cb 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -304,6 +304,13 @@ config SENSORS_TSL2550
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
> index 6ed06a1..48597df 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -28,6 +28,7 @@ obj-$(CONFIG_DS1682)		+= ds1682.o
>  obj-$(CONFIG_TI_DAC7512)	+= ti_dac7512.o
>  obj-$(CONFIG_C2PORT)		+= c2port/
>  obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
> +obj-$(CONFIG_HMC6352)		+= hmc6352.o
>  obj-y				+= eeprom/
>  obj-y				+= cb710/
>  obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
> diff --git a/drivers/misc/hmc6352.c b/drivers/misc/hmc6352.c
> new file mode 100644
> index 0000000..a62a03b
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

It's quite overkill IMHO to have two messages here. In the end you send
only one. It would make sense if you made these messages static const,
but you didn't. If you use local variables, then the following is more
efficient:

	char  cmd;
	struct i2c_msg msg[] = {
		{ client->addr, 0, 1, &cmd },
	};

	if (val == 1)
		cmd = 'C';	/* Calibrate */
	else
		cmd = 'E';	/* Exit calibration mode */
	else
		return -EINVAL;

	(etc.)

> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +	if (val == 1) {
> +		ret = i2c_transfer(client->adapter, msg, 1);
> +		if (ret != 1) {
> +			dev_warn(dev, "i2c calib start cmd failed\n");
> +			return ret;
> +		}
> +	} else if (val == 2) {
> +		ret = i2c_transfer(client->adapter, msg1, 1);
> +		if (ret != 1) {
> +			dev_warn(dev, "i2c calib stop cmd failed\n");
> +			return ret;
> +		}

Note that for single-message transactions, i2c_master_send() and
i2c_master_recv() are easier to use than i2c_transfer().

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
> +		dev_warn(dev, "i2c cmd 0x41 failed\n");
> +		return ret;
> +	}
> +	msleep(10); /* sending 0x41 cmd we need to wait for 7-10 milli seconds */
> +	ret = i2c_transfer(client->adapter, msg1, 1);
> +	if (ret != 1) {
> +		dev_warn(dev, "i2c read data cmd failed\n");
> +		return ret;
> +	}

Don't you need some form of locking here? Multiple concurrent users can
access the sysfs files. What if 2 users access the file 5 ms apart?

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

Same comment as in compass_calibration_store().

> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +
> +	if (val == 0) {
> +		ret = i2c_transfer(client->adapter, msg, 1);
> +		if (ret != 1)
> +			dev_warn(dev, "i2c cmd  sleep mode failed\n");
> +	} else if (val == 1) {
> +		ret = i2c_transfer(client->adapter, msg1, 1);
> +		if (ret != 1)
> +			dev_warn(dev, "i2c cmd active mode failed\n");
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

Could be const.

> +	.name = "hmc6352",
> +	.attrs = mid_att_compass
> +};
> +
> +static int  hmc6352_probe(struct i2c_client *client,

Double space.

> +					const struct i2c_device_id *id)
> +{
> +	int res;
> +
> +	res = sysfs_create_group(&client->dev.kobj, &m_compass_gr);
> +	if (res) {
> +		dev_err(&client->dev, "device_create_file failed\n");
> +		return res;
> +	}
> +	dev_info(&client->dev, "%s HMC6352 compass chip found\n",
> +							client->name);
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
> +		.name = "hmc6352",
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

-- 
Jean Delvare
