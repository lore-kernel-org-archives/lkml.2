Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1BNKWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:22:40 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:23627 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab1BNKWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:22:38 -0500
Date: Mon, 14 Feb 2011 11:22:28 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dirk Eibach <eibach@gdsys.de>
Cc: linux-kernel@vger.kernel.org, guenter.roeck@ericsson.com,
        lm-sensors@lm-sensors.org, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] hwmon: Add support for Texas Instruments ADS1015
Message-ID: <20110214112228.59269651@endymion.delvare>
In-Reply-To: <1297675581-17691-1-git-send-email-eibach@gdsys.de>
References: <1297675581-17691-1-git-send-email-eibach@gdsys.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dirk,

On Mon, 14 Feb 2011 10:26:21 +0100, Dirk Eibach wrote:
> Signed-off-by: Dirk Eibach <eibach@gdsys.de>
> ---
>  Documentation/hwmon/ads1015 |   31 +++++
>  drivers/hwmon/Kconfig       |   10 ++
>  drivers/hwmon/Makefile      |    1 +
>  drivers/hwmon/ads1015.c     |  269 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 311 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/hwmon/ads1015
>  create mode 100644 drivers/hwmon/ads1015.c
> 
> diff --git a/Documentation/hwmon/ads1015 b/Documentation/hwmon/ads1015
> new file mode 100644
> index 0000000..3772816
> --- /dev/null
> +++ b/Documentation/hwmon/ads1015
> @@ -0,0 +1,31 @@
> +Kernel driver ads1015
> +=====================
> +
> +Supported chips:
> +  * Texas Instruments ADS1015
> +    Prefix: 'ads1015'
> +    Addresses scanned: I2C 0x48, 0x49, 0x4a, 0x4b
> +    Datasheet: Publicly available at the Texas Instruments website :
> +               http://focus.ti.com/lit/ds/symlink/ads1015.pdf
> +
> +Authors:
> +        Dirk Eibach, Guntermann & Drunck GmbH <eibach@gdsys.de>
> +
> +Description
> +-----------
> +
> +This driver implements support for the Texas Instruments ADS1015.
> +
> +This device is a 12-bit A-D converter with 4 inputs.
> +
> +The inputs can be used single ended or in certain differential combinations.
> +
> +The driver offers access to all available combinations by 7 "virtual" inputs:

I count 8.

> +in0: Voltage over AIN0 and AIN1.
> +in1: Voltage over AIN0 and AIN3.
> +in2: Voltage over AIN1 and AIN3.
> +in3: Voltage over AIN2 and AIN3.
> +in4: Voltage over AIN0 and GND.
> +in5: Voltage over AIN1 and GND.
> +in6: Voltage over AIN2 and GND.
> +in7: Voltage over AIN3 and GND.

This seems wrong. All 8 attributes can't possibly report sane values
for a given hardware setup, right? I think it would be much better to
have the platform provide setup data to the driver, telling it how the
chip is used and which input configurations should be exposed to
user-space.

> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 773e484..7e247f7 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -871,6 +871,16 @@ config SENSORS_SMSC47B397
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called smsc47b397.
>  
> +config SENSORS_ADS1015
> +	tristate "Texas Instruments ADS1015"
> +	depends on I2C
> +	help
> +	  If you say yes here you get support for Texas Instruments ADS1015
> +	  12-bit 4-input ADC device.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called ads1015.
> +
>  config SENSORS_ADS7828
>  	tristate "Texas Instruments ADS7828"
>  	depends on I2C
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index dde02d9..aae4036 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -29,6 +29,7 @@ obj-$(CONFIG_SENSORS_ADM1026)	+= adm1026.o
>  obj-$(CONFIG_SENSORS_ADM1029)	+= adm1029.o
>  obj-$(CONFIG_SENSORS_ADM1031)	+= adm1031.o
>  obj-$(CONFIG_SENSORS_ADM9240)	+= adm9240.o
> +obj-$(CONFIG_SENSORS_ADS1015)	+= ads1015.o
>  obj-$(CONFIG_SENSORS_ADS7828)	+= ads7828.o
>  obj-$(CONFIG_SENSORS_ADS7871)	+= ads7871.o
>  obj-$(CONFIG_SENSORS_ADT7411)	+= adt7411.o
> diff --git a/drivers/hwmon/ads1015.c b/drivers/hwmon/ads1015.c
> new file mode 100644
> index 0000000..675fdfe
> --- /dev/null
> +++ b/drivers/hwmon/ads1015.c
> @@ -0,0 +1,269 @@
> +/*
> + * ads1015.c - lm_sensors driver for ads1015 12-bit 4-input ADC
> + * (C) Copyright 2010
> + * Dirk Eibach, Guntermann & Drunck GmbH <eibach@gdsys.de>
> + *
> + * Based on the ads7828 driver by Steve Hardy.
> + *
> + * Datasheet available at: http://focus.ti.com/lit/ds/symlink/ads1015.pdf
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
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/jiffies.h>
> +#include <linux/i2c.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +
> +/* ADS1015 registers */
> +enum {
> +	ADS1015_CONVERSION = 0,
> +	ADS1015_CONFIG = 1,
> +	ADS1015_LO_THRESH = 2,
> +	ADS1015_HI_THRESH = 3,
> +};

You don't use the last two values anywhere.

> +
> +/* PGA fullscale voltages */
> +static const unsigned int fullscale_table[] = {
> +	6144, 4096, 2048, 1024, 512, 256, 256, 256 };

You'd rather hard-code the table size, as the rest of the code makes
assumptions on it. Please also add a comment stating the unit in which
these constants are expressed. I hope these are mV.

> +
> +/* Addresses to scan */
> +static const unsigned short normal_i2c[] = { 0x48, 0x49, 0x4a, 0x4b,
> +	I2C_CLIENT_END };
> +
> +/* Insmod parameters */
> +I2C_CLIENT_INSMOD_1(ads1015);

This macro was removed in kernel 2.6.33, almost one year ago. Please
provide patches which apply and build on Linus' latest kernel, or the
latest stable kernel at least.

> +
> +/* Each client has this additional data */
> +struct ads1015_data {
> +	struct device *hwmon_dev;
> +	struct mutex update_lock; /* mutex protect updates */
> +};
> +
> +/* Function declaration - necessary due to function dependencies */

No, not necessary at all. Just put the functions and driver declaration
in the right order.

> +static int ads1015_detect(struct i2c_client *client, int kind,
> +			  struct i2c_board_info *info);
> +static int ads1015_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id);
> +
> +
> +static s32 ads1015_read_reg(struct i2c_client *client, unsigned int reg)
> +{
> +	return swab16(i2c_smbus_read_word_data(client, reg));

This is wrong. If i2c_smbus_read_word_data() returns an error, your
function will return crap.

> +}
> +
> +static s32 ads1015_write_reg(struct i2c_client *client, unsigned int reg,
> +			     u16 val)
> +{
> +	return i2c_smbus_write_word_data(client, reg, swab16(val));
> +}
> +
> +static int ads1015_read_value(struct i2c_client *client, unsigned int channel)

Please either document the locking requirements of this function, or
move locking into it.

> +{
> +	u16 config;
> +	s16 conversion;
> +	unsigned int pga;
> +	int fullscale;
> +	unsigned int k;
> +
> +	/* get fullscale voltage */
> +	config = ads1015_read_reg(client, ADS1015_CONFIG);
> +	pga = (config >> 9) & 0x0007;
> +	fullscale = fullscale_table[pga];
> +
> +	/* set channel and start single conversion */
> +	config &= ~(0x0007 << 12);
> +	config &= ~(0x0001 << 8);

What's the point of clearing a bit you'll set again immediately?

> +	config |= (1 << 15) | (1 << 8) | (channel & 0x0007) << 12;
> +
> +	/* wait until conversion finished */
> +	ads1015_write_reg(client, ADS1015_CONFIG, config);
> +	for (k = 0; k < 5; ++k) {
> +		config = ads1015_read_reg(client, ADS1015_CONFIG);

What is the expected conversion time? Does it really make sense to
attempt a register read right away?

> +		if (config & (1 << 15))
> +			break;
> +		schedule_timeout(msecs_to_jiffies(1));
> +	}

What if k == 5? The conversion did not complete, and you return crap?

> +
> +	conversion = ads1015_read_reg(client, ADS1015_CONVERSION);
> +
> +	return conversion * fullscale / 0x7ff0;

Maybe it would make sense to use DIV_ROUND_CLOSEST?

> +}
> +
> +/* sysfs callback function */
> +static ssize_t show_in(struct device *dev, struct device_attribute *da,
> +	char *buf)
> +{
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct ads1015_data *data = i2c_get_clientdata(client);
> +	int in;
> +
> +	mutex_lock(&data->update_lock);
> +	in = ads1015_read_value(client, attr->index);
> +	mutex_unlock(&data->update_lock);
> +
> +	return sprintf(buf, "%d\n", in);
> +}
> +
> +#define in_reg(offset)\
> +static SENSOR_DEVICE_ATTR(in##offset##_input, S_IRUGO, show_in,\
> +	NULL, offset)
> +
> +in_reg(0);
> +in_reg(1);
> +in_reg(2);
> +in_reg(3);
> +in_reg(4);
> +in_reg(5);
> +in_reg(6);
> +in_reg(7);
> +
> +static struct attribute *ads1015_attributes[] = {
> +	&sensor_dev_attr_in0_input.dev_attr.attr,
> +	&sensor_dev_attr_in1_input.dev_attr.attr,
> +	&sensor_dev_attr_in2_input.dev_attr.attr,
> +	&sensor_dev_attr_in3_input.dev_attr.attr,
> +	&sensor_dev_attr_in4_input.dev_attr.attr,
> +	&sensor_dev_attr_in5_input.dev_attr.attr,
> +	&sensor_dev_attr_in6_input.dev_attr.attr,
> +	&sensor_dev_attr_in7_input.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group ads1015_group = {
> +	.attrs = ads1015_attributes,
> +};
> +
> +static int ads1015_remove(struct i2c_client *client)
> +{
> +	struct ads1015_data *data = i2c_get_clientdata(client);
> +	hwmon_device_unregister(data->hwmon_dev);
> +	sysfs_remove_group(&client->dev.kobj, &ads1015_group);
> +	kfree(i2c_get_clientdata(client));

Please just use "data".

> +	return 0;
> +}
> +
> +static const struct i2c_device_id ads1015_id[] = {
> +	{ "ads1015", ads1015 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, ads1015_id);
> +
> +/* This is the driver that will be inserted */
> +static struct i2c_driver ads1015_driver = {
> +	.class = I2C_CLASS_HWMON,
> +	.driver = {
> +		.name = "ads1015",
> +	},
> +	.probe = ads1015_probe,
> +	.remove = ads1015_remove,
> +	.id_table = ads1015_id,
> +	.detect = ads1015_detect,
> +	.address_data = &addr_data,
> +};
> +
> +/* Return 0 if detection is successful, -ENODEV otherwise */
> +static int ads1015_detect(struct i2c_client *client, int kind,
> +			  struct i2c_board_info *info)
> +{
> +	struct i2c_adapter *adapter = client->adapter;
> +
> +	/* Check we have a valid client */
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_READ_WORD_DATA))
> +		return -ENODEV;
> +
> +	/* Now, we do the remaining detection. There is no identification
> +	dedicated register so attempt to sanity check using knowledge of
> +	the chip
> +	- Read from the 8 channels
> +	- Check the bits 0-3 of each result are not set (12 data bits)
> +	*/
> +	if (kind < 0) {
> +		int ch;
> +		for (ch = 0; ch < 8; ++ch) {
> +			u16 in_data;
> +			in_data = ads1015_read_value(client, ch);
> +			if (in_data & 0x000F) {
> +				printk(KERN_DEBUG
> +				"%s : Doesn't look like an ads1015 device\n",
> +				__func__);
> +				return -ENODEV;
> +			}
> +		}
> +	}
> +
> +	strlcpy(info->type, "ads1015", I2C_NAME_SIZE);
> +
> +	return 0;
> +}

Your device is obviously not easily and reliably detectable, so please
just don't provide a detect function. It's prohibited to write to the
device in detection functions anyway, and you do exactly this.

> +
> +static int ads1015_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct ads1015_data *data;
> +	int err;
> +
> +	data = kzalloc(sizeof(struct ads1015_data), GFP_KERNEL);
> +	if (!data) {
> +		err = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	i2c_set_clientdata(client, data);
> +	mutex_init(&data->update_lock);
> +
> +	/* Register sysfs hooks */
> +	err = sysfs_create_group(&client->dev.kobj, &ads1015_group);
> +	if (err)
> +		goto exit_free;
> +
> +	data->hwmon_dev = hwmon_device_register(&client->dev);
> +	if (IS_ERR(data->hwmon_dev)) {
> +		err = PTR_ERR(data->hwmon_dev);
> +		goto exit_remove;
> +	}
> +
> +	return 0;
> +
> +exit_remove:
> +	sysfs_remove_group(&client->dev.kobj, &ads1015_group);
> +exit_free:
> +	kfree(data);
> +exit:
> +	return err;
> +}
> +
> +static int __init sensors_ads1015_init(void)
> +{
> +	return i2c_add_driver(&ads1015_driver);
> +}
> +
> +static void __exit sensors_ads1015_exit(void)
> +{
> +	i2c_del_driver(&ads1015_driver);
> +}
> +
> +MODULE_AUTHOR("Dirk Eibach <eibach@gdsys.de>");
> +MODULE_DESCRIPTION("ADS1015 driver");
> +MODULE_LICENSE("GPL");
> +
> +module_init(sensors_ads1015_init);
> +module_exit(sensors_ads1015_exit);


-- 
Jean Delvare
