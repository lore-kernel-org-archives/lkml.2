Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab0EUNN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:13:26 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:42489 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab0EUNNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:13:25 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BF687A0.4040203@jic23.retrosnub.co.uk>
Date: Fri, 21 May 2010 14:16:16 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [RFC] [PATCH] TMP105 : Driver support for the temperature sensor
References: <0680EC522D0CC943BC586913CF3768C003B32B3AC4@dbde02.ent.ti.com>
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003B32B3AC4@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/10 13:17, Datta, Shubhrajyoti wrote:
> 
> Adds the driver support for the TMP105 temperature sensor device. The interface is I2C.The driver supports the read of the temperature values.
> 
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
This device looks at first glance to be pretty similar to the TMP101 as supported
by the lm75 driver.  Would it make more sense to merge this support into that
driver?

I've not read the data sheets that closely so may have missed something!

Couple of nitpicks below.
> ---
>  drivers/hwmon/Kconfig  |   10 ++
>  drivers/hwmon/Makefile |    1 +
>  drivers/hwmon/tmp105.c |  326 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 337 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/tmp105.c
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 68cf877..a4a5352 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1076,6 +1076,16 @@ config SENSORS_MC13783_ADC
>          help
>            Support for the A/D converter on MC13783 PMIC.
>  
> +config SENSORS_TMP105
> +	tristate "Texas Instruments TMP421 and compatible"
 TMP105 or TMP421? 
> +	depends on I2C
> +	help
> +	  If you say yes here you get support for Texas Instruments TMP105
> +	  temperature sensor chips.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called tmp105.
> +
>  if ACPI
>  
>  comment "ACPI drivers"
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 4bc215c..2c4e7a5 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -99,6 +99,7 @@ obj-$(CONFIG_SENSORS_W83L785TS)	+= w83l785ts.o
>  obj-$(CONFIG_SENSORS_W83L786NG)	+= w83l786ng.o
>  obj-$(CONFIG_SENSORS_WM831X)	+= wm831x-hwmon.o
>  obj-$(CONFIG_SENSORS_WM8350)	+= wm8350-hwmon.o
> +obj-$(CONFIG_SENSORS_TMP105)    += tmp105.o
>  
>  ifeq ($(CONFIG_HWMON_DEBUG_CHIP),y)
>  EXTRA_CFLAGS += -DDEBUG
> diff --git a/drivers/hwmon/tmp105.c b/drivers/hwmon/tmp105.c
> new file mode 100644
> index 0000000..8765b11
> --- /dev/null
> +++ b/drivers/hwmon/tmp105.c
> @@ -0,0 +1,326 @@
> +/*
> + * tmp105.c
> + *
> + * TMP105 temperature sensor driver
> + *
> + * Copyright (C) 2010 Texas Instruments
> + *
> + * Author: Shubhrajyoti Datta <a0393217@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> +*/
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/kernel.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +
> +/* Registers */
> +#define		TMP105_TEMP_REG		0x00
> +#define		TMP105_CONF_REG		0x01
> +#define		TMP105_TLOW_REG		0x02
> +#define		TMP105_THIGH_REG	0x03
> +
> +/* Configuration register parameters */
> +#define		TMP105_CONF_SD		0x01
> +#define		TMP105_CONF_TM		0x02
> +#define		TMP105_CONF_POL		0x04
> +#define		TMP105_CONF_F0		0x08
> +#define		TMP105_CONF_F1		0x10
> +#define		TMP105_CONF_R0		0x20
> +#define		TMP105_CONF_R1		0x40
> +#define		TMP105_CONF_OS		0x80
> +
> +#define 	TMP105_I2C_ADDRESS	0x48
> +
> +#define         MAX_TEMP		128
> +#define         MIN_TEMP		-55
> +
> +/* Each client has this additional data */
> +struct tmp105_data {
> +	struct i2c_client *client;
> +	/* mutex for sysfs operations */
> +	struct mutex lock;
> +	struct device *hwmon_dev;
> +	s16 temp[3];
> +	unsigned long last_updated;
> +	u8 configuration_setting;
> +};
> +
> +static const u8 tmp105_reg[] = {
> +	TMP105_TEMP_REG,
> +	TMP105_TLOW_REG,
> +	TMP105_THIGH_REG,
> +};
> +
> +static void tmp105_init_client(struct i2c_client *client);
> +
> +static signed long tmp105_reg_to_mC(s16 val)
> +{
> +	signed long temp_mC;
> +	if (val  & 0x800)
> +		val = val - 0x1000 ;
Stray space.

> +	 temp_mC = (val * 64000) / 1024;
> +	 return temp_mC;
> +}
> +
> +static u16 tmp105_C_to_reg(signed long val)
> +{
> +	val =  (val * 1024) / 64000;
> +	if (val < 0)
> +		val = val + 0x1000;
> +	return (u16)val;
> +}
> +
> +static s16 *tmp105_update_device(struct i2c_client *client,
> +						int  index)
> +{
> +	struct tmp105_data *data = i2c_get_clientdata(client);
> +	u8 tmp[2];
> +
> +	mutex_lock(&data->lock);
> +
> +	if (time_after(jiffies, data->last_updated +  HZ/4)) {
> +		i2c_smbus_read_i2c_block_data(client,
> +						tmp105_reg[index], 2, tmp);
> +		data->temp[index] = ((tmp[0] << 4) | ((tmp[1] & 0xF0) >> 4));
> +		printk(KERN_INFO "Raw temperature: %u\n", data->temp[index]);
> +		data->last_updated = jiffies;
> +	}
> +
> +	mutex_unlock(&data->lock);
> +	return data->temp[index] ;
> +}
> +
> +static ssize_t show_temp_value(struct device *dev,
> +			       struct device_attribute *devattr, char *buf)
> +{
> +	struct sensor_device_attribute *sda = to_sensor_dev_attr(devattr);
> +	struct i2c_client *client = to_i2c_client(dev);
> +	s16 temperature = tmp105_update_device(client , sda->index);
> +	signed long temp_in_mC;
> +
> +	temp_in_mC = tmp105_reg_to_mC(temperature);
> +
> +	return sprintf(buf, "%d\n", temp_in_mC);
> +}
> +
> +static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp_value, NULL , 0);
> +
> +static ssize_t tmp105_set_temp(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	struct sensor_device_attribute *sda = to_sensor_dev_attr(attr);
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct tmp105_data *tmp105 = i2c_get_clientdata(client);
> +	signed long val;
> +	int status = 0;
> +	u16 temp;
> +
> +	if ((strict_strtol(buf, 10, &val) < 0))
> +		return -EINVAL;
> +
> +	SENSORS_LIMIT(val , MIN_TEMP , MAX_TEMP);
> +
> +	mutex_lock(&tmp105->lock);
> +
> +	temp = tmp105_C_to_reg(val);
> +	temp = ((temp & 0xFF0) >> 4) | ((temp & 0xF)<<12);
Random spacing 

> +
> +	status = i2c_smbus_write_word_data(client, tmp105_reg[sda->index],
> +			temp);
> +
> +	tmp105->temp[sda->index] = temp;
> +	mutex_unlock(&tmp105->lock);
> +	return status ? : count;
> +}
> +
> +static SENSOR_DEVICE_ATTR(temp1_min, S_IWUSR | S_IRUGO, show_temp_value,
> +	tmp105_set_temp, 1);
> +static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp_value,
> +	tmp105_set_temp, 2);
> +
> +/* sysfs call */
> +static ssize_t set_configuration(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	s32 status;
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct tmp105_data *data = i2c_get_clientdata(client);
> +	data->configuration_setting = simple_strtoul(buf, NULL, 10);
> +	/* I2C write to the configuration register */
> +	status = i2c_smbus_write_byte_data(client, TMP105_CONF_REG,
> +			data->configuration_setting);
What's status for given you don't take any notice of it?

> +	return count;
> +}
> +
> +static ssize_t show_configuration(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct tmp105_data *data = i2c_get_clientdata(client);
> +	u8 tmp;
> +	i2c_smbus_read_i2c_block_data(client, TMP105_CONF_REG, 1, &tmp);
> +	data->configuration_setting = tmp;
> +	return sprintf(buf, "%u\n", data->configuration_setting);
> +}
> +static DEVICE_ATTR(configuration, S_IWUSR | S_IRUGO, show_configuration,
> +		set_configuration);
> +
> +
> +static struct attribute *tmp105_attributes[] = {
> +	&dev_attr_configuration.attr,
> +	&sensor_dev_attr_temp1_input.dev_attr.attr,
> +	&sensor_dev_attr_temp1_min.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group tmp105_attr_group = {
> +	.attrs = tmp105_attributes,
> +};
> +
> +static int tmp105_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct tmp105_data *tmp105_data;
> +	int err;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		dev_dbg(&client->dev, "adapter doesn't support I2C\n");
> +		return -ENODEV;
> +	}
> +
> +	tmp105_data = kzalloc(sizeof(struct tmp105_data), GFP_KERNEL);
> +	if (!tmp105_data) {
> +		err = -ENOMEM;
> +		goto exit;
> +	}
> +	tmp105_data->client = client;
> +
> +	i2c_set_clientdata(client, tmp105_data);
> +	mutex_init(&tmp105_data->lock);
> +
> +	/* Initialize the TMP105 chip */
> +	tmp105_init_client(client);
> +
> +	/* Register sysfs hooks */
> +	err = sysfs_create_group(&client->dev.kobj, &tmp105_attr_group);
> +	if (err)
> +		goto exit_free;
> +	tmp105_data->hwmon_dev = hwmon_device_register(&client->dev);
> +	if (IS_ERR(tmp105_data->hwmon_dev)) {
> +		err = PTR_ERR(tmp105_data->hwmon_dev);
> +		tmp105_data->hwmon_dev = NULL;
> +		goto exit_remove;
> +	}
> +	return 0;
> +
> +exit_remove:
> +	sysfs_remove_group(&client->dev.kobj, &tmp105_attr_group);
> +exit_free:
> +	i2c_set_clientdata(client, NULL);
> +	kfree(tmp105_data);
> +exit:
> +	return err;
> +}
> +
> +static int tmp105_remove(struct i2c_client *client)
> +{
> +	struct tmp105_data *tmp105 = i2c_get_clientdata(client);
> +	hwmon_device_unregister(tmp105->hwmon_dev);
> +
> +	sysfs_remove_group(&client->dev.kobj, &tmp105_attr_group);
> +	i2c_set_clientdata(client, NULL);
> +	kfree(tmp105);
> +	return 0;
> +}
> +
> +/* Called when we have found a new TMP105. */
> +static void tmp105_init_client(struct i2c_client *client)
> +{
> +	struct tmp105_data *data = i2c_get_clientdata(client);
> +	data->last_updated = jiffies - HZ;
> +	mutex_init(&data->lock);
> +}
> +
> +static const struct i2c_device_id tmp105_id[] = {
> +	{ "tmp105", 0 },
> +	{ }
> +};
> +
> +#ifdef CONFIG_PM
> +static int tmp105_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	u8 config_reg;
> +	i2c_smbus_read_i2c_block_data(client, TMP105_CONF_REG, 1, &config_reg);
> +	config_reg = config_reg | TMP102_CONF_SD;
> +	i2c_smbus_write_byte_data(client, TMP105_CONF_REG, TMP102_CONF_SD);
> +	return 0;
> +}
> +
> +static int tmp105_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	i2c_smbus_read_i2c_block_data(client, TMP105_CONF_REG, 1, &config_reg);
> +	config_reg = config_reg & ~TMP102_CONF_SD;
> +	i2c_smbus_write_byte_data(client, TMP105_CONF_REG, TMP102_CONF_SD);
> +}
> +
> +static struct dev_pm_ops tmp105_dev_pm_ops = {
> +	.suspend = tmp105_suspend,
> +	.resume = tmp105_resume,
> +};
> +
> +#define TMP105_DEV_PM_OPS (&tmp105_dev_pm_ops)
> +#else
> +#define TMP105_DEV_PM_OPS NULL
> +#endif /* CONFIG_PM */
> +
> +
> +static struct i2c_driver tmp105_driver = {
> +	.driver = {
> +		.name	= "tmp105",
> +		.owner = THIS_MODULE,
> +		.pm = TMP105_DEV_PM_OPS,
> +	},
> +	.probe		= tmp105_probe,
> +	.remove		= tmp105_remove,
> +	.id_table	= tmp105_id,
> +	.class = I2C_CLASS_HWMON,
> +};
> +
> +static int __init tmp105_init(void)
> +{
> +	return i2c_add_driver(&tmp105_driver);
> +}
> +
> +static void __exit tmp105_exit(void)
> +{
> +	i2c_del_driver(&tmp105_driver);
> +}
> +
> +MODULE_DESCRIPTION("TMP105 driver");
> +MODULE_LICENSE("GPL");
> +
> +module_init(tmp105_init);
> +module_exit(tmp105_exit);
> +

