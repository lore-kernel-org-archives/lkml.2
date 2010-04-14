Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab0DNWpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:45:51 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:57160 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0DNWpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:45:49 -0400
Date: Thu, 15 Apr 2010 00:45:42 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, khali@linux-fr.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 2/4] isl29020: ambient light sensor
Message-ID: <20100414224542.GX30807@buzzloop.caiaq.de>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
 <20100414125147.23181.5817.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414125147.23181.5817.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 01:51:49PM +0100, Alan Cox wrote:
> The LS driver will read the latest Lux measurement based upon the
> light brightness and will report the LUX output through sysfs interface.
> 
> Signed-off-by: Kalhan Trisal <kalhan.trisal@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/hwmon/Kconfig    |    9 ++
>  drivers/hwmon/Makefile   |    1 
>  drivers/hwmon/isl29020.c |  243 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 253 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/isl29020.c

Would it be possible to make the existing driver for the ISL29003
support the ISL29020 as well?

Also note that there is a ALS (ambient light sensor) framework pending.
So patches against the 29003 driver should apply to this tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/jic23/als.git

I copied the maintainer to this mail. Jonathan, any plans when ALS will
be merged?

Thanks,
Daniel



> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 74f672d..1fa2533 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1095,6 +1095,15 @@ config SENSORS_HMC6352
>  	  This driver provides support for the Honeywell HMC6352 compass,
>  	  providing configuration and heading data via sysfs.
>  
> +config SENSORS_ISL29020
> +	tristate "Intersil ISL29020 ALS"
> +	depends on I2C
> +	help
> +	  If you say yes here you get support for the ALS Devices
> +	  Ambient Light Sensor monitoring chip.
> +	  Range values can be configured using sysfs.
> +	  Lux data is accessible via sysfs.
> +
>  if ACPI
>  
>  comment "ACPI drivers"
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index ad2ed36..13d6832 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -53,6 +53,7 @@ obj-$(CONFIG_SENSORS_HMC6352)	+= hmc6352.o
>  obj-$(CONFIG_SENSORS_I5K_AMB)	+= i5k_amb.o
>  obj-$(CONFIG_SENSORS_IBMAEM)	+= ibmaem.o
>  obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
> +obj-$(CONFIG_SENSORS_ISL29020)	+= isl29020.o
>  obj-$(CONFIG_SENSORS_IT87)	+= it87.o
>  obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
>  obj-$(CONFIG_SENSORS_K10TEMP)	+= k10temp.o
> diff --git a/drivers/hwmon/isl29020.c b/drivers/hwmon/isl29020.c
> new file mode 100644
> index 0000000..458140d
> --- /dev/null
> +++ b/drivers/hwmon/isl29020.c
> @@ -0,0 +1,243 @@
> +/*
> + * isl29020.c - Intersil  ALS Driver
> + *
> + * Copyright (C) 2008 Intel Corp
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
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/hwmon-vid.h>
> +#include <linux/err.h>
> +#include <linux/delay.h>
> +#include <linux/mutex.h>
> +#include <linux/sysfs.h>
> +
> +
> +#define ALS_MIN_RANGE_VAL 0
> +#define ALS_MAX_RANGE_VAL 5
> +
> +struct als_data {
> +	struct device *hwmon_dev;
> +};
> +
> +static unsigned int i2c_write_current_data(struct i2c_client *client,
> +					unsigned int reg, unsigned int value)
> +{
> +	int ret_val;
> +
> +	ret_val = i2c_smbus_write_byte_data(client, reg, value);
> +	return ret_val;
> +}
> +
> +static ssize_t als_sensing_range_show(struct device *dev,
> +			struct device_attribute *attr,  char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	int  val;
> +
> +	val = i2c_smbus_read_byte_data(client, 0x00);
> +	return sprintf(buf, "%d000\n", 1 << (2 * (val & 3)));
> +
> +}
> +
> +static ssize_t als_lux_output_data_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	unsigned int ret_val, val;
> +	unsigned long int lux, max_count;
> +	int tempv1, tempv2;
> +
> +	max_count = 65535;
> +	tempv1 = i2c_smbus_read_byte_data(client, 0x02); /* MSB data */
> +	tempv2 = i2c_smbus_read_byte_data(client, 0x01); /* LSB data */
> +	ret_val = tempv1;
> +	ret_val = (ret_val << 8 | tempv2);
> +	val = i2c_smbus_read_byte_data(client, 0x00);
> +	lux = ((((1 << (2 * (val & 3))))*1000) * ret_val) / max_count;
> +	return sprintf(buf, "%ld\n", lux);
> +}
> +
> +static ssize_t als_sensing_range_store(struct device *dev,
> +		struct device_attribute *attr, const  char *buf, size_t count)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	unsigned int ret_val, set_val = 0;
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +	ret_val = i2c_smbus_read_byte_data(client, 0x00);
> +	ret_val = ret_val & 0xFC; /*reset the bit before setting them */
> +	if (val == 1)
> +		set_val = (ret_val | 0x00); /* setting the 1:0  bit */
> +	else if (val == 2)
> +		set_val = (ret_val | 0x01);
> +	else if (val == 3)
> +		set_val = (ret_val | 0x02);
> +	else if (val == 4)
> +		set_val = (ret_val | 0x03);
> +	else
> +		goto invarg;
> +	i2c_write_current_data(client, 0x00, set_val);
> +	return count;
> +invarg:
> +	return -EINVAL;
> +}
> +
> +static ssize_t als_power_status_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	int ret_val;
> +
> +	ret_val = i2c_smbus_read_byte_data(client, 0x00);
> +	ret_val = ret_val & 0x80;
> +	if (ret_val == 0x80)
> +		ret_val = 1;
> +	return sprintf(buf, "%x", ret_val);
> +}
> +
> +static ssize_t als_power_status_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	unsigned long val = 0;
> +	char curr_val;
> +
> +	if (strict_strtoul(buf, 10, &val))
> +		return -EINVAL;
> +
> +	curr_val = i2c_smbus_read_byte_data(client, 0x00);
> +	if (val == 1)
> +		curr_val = curr_val | 0x80;
> +	else if (val == 0)
> +		curr_val = curr_val & 0x7F;
> +	else
> +		return -EINVAL;
> +	i2c_write_current_data(client, 0x00, curr_val);
> +	return count;
> +}
> +
> +static DEVICE_ATTR(sensing_range, S_IRUGO | S_IWUSR,
> +	als_sensing_range_show, als_sensing_range_store);
> +static DEVICE_ATTR(lux_output, S_IRUGO, als_lux_output_data_show, NULL);
> +static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR,
> +	als_power_status_show, als_power_status_store);
> +
> +static struct attribute *mid_att_als[] = {
> +	&dev_attr_sensing_range.attr,
> +	&dev_attr_lux_output.attr,
> +	&dev_attr_power_state.attr,
> +	NULL
> +};
> +
> +static struct attribute_group m_als_gr = {
> +	.name = "isl29020",
> +	.attrs = mid_att_als
> +};
> +
> +static void als_set_default_config(struct i2c_client *client)
> +{
> +	i2c_write_current_data(client, 0x00, 0xc0);
> +}
> +
> +static int  isl29020_probe(struct i2c_client *client,
> +					const struct i2c_device_id *id)
> +{
> +	int res;
> +	struct als_data *data;
> +
> +	data = kzalloc(sizeof(struct als_data), GFP_KERNEL);
> +	if (data == NULL) {
> +		printk(KERN_WARNING " isl29020: out of memory");
> +		return -ENOMEM;
> +	}
> +	i2c_set_clientdata(client, data);
> +
> +	res = sysfs_create_group(&client->dev.kobj, &m_als_gr);
> +	if (res) {
> +		printk(KERN_WARNING "isl29020: device create file failed!!\n");
> +		goto als_error1;
> +	}
> +	data->hwmon_dev = hwmon_device_register(&client->dev);
> +	if (IS_ERR(data->hwmon_dev)) {
> +		res = PTR_ERR(data->hwmon_dev);
> +		data->hwmon_dev = NULL;
> +		sysfs_remove_group(&client->dev.kobj, &m_als_gr);
> +		printk(KERN_ERR "isl29020:unable to register hwmon device\n");
> +		goto als_error1;
> +	}
> +	dev_info(&client->dev, "%s isl29020: ALS chip found\n", client->name);
> +	als_set_default_config(client);
> +	return res;
> +
> +als_error1:
> +	i2c_set_clientdata(client, NULL);
> +	kfree(data);
> +	return res;
> +}
> +
> +static int isl29020_remove(struct i2c_client *client)
> +{
> +	struct als_data *data = i2c_get_clientdata(client);
> +
> +	hwmon_device_unregister(data->hwmon_dev);
> +	sysfs_remove_group(&client->dev.kobj, &m_als_gr);
> +	kfree(data);
> +	return 0;
> +}
> +
> +static struct i2c_device_id isl29020_id[] = {
> +	{ "i2c_als", 0 },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, isl29020_id);
> +
> +static struct i2c_driver isl29020_driver = {
> +	.driver = {
> +	.name = "isl29020",
> +	},
> +	.probe = isl29020_probe,
> +	.remove = isl29020_remove,
> +	.id_table = isl29020_id,
> +};
> +
> +static int __init sensor_isl29020_init(void)
> +{
> +	return i2c_add_driver(&isl29020_driver);
> +}
> +
> +static void  __exit sensor_isl29020_exit(void)
> +{
> +	i2c_del_driver(&isl29020_driver);
> +}
> +
> +module_init(sensor_isl29020_init);
> +module_exit(sensor_isl29020_exit);
> +
> +MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com");
> +MODULE_DESCRIPTION("Intersil isl29020 ALS Driver");
> +MODULE_LICENSE("GPL v2");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
