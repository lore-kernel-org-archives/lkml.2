Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0LaPCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 10:02:14 -0500
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:47539 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0LaPCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 10:02:13 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D1DF097.1080200@cam.ac.uk>
Date: Fri, 31 Dec 2010 15:02:47 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Urs Fleisch <urs.fleisch@gmail.com>
CC: linux-kernel@vger.kernel.org, LM Sensors <lm-sensors@lm-sensors.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] hwmon: driver for Sensirion SHT21 humidity and temperature
 sensor
References: <20101229134511.cc466ac0.urs.fleisch@gmail.com>
In-Reply-To: <20101229134511.cc466ac0.urs.fleisch@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/10 12:45, Urs Fleisch wrote:
> Hi,
> 
> This is a driver for the new humidity and temperature sensors SHT21 and SHT25 from Sensirion.
Firstly, I've cc'd the relevant mailing list and maintainers for hwmon drivers.
Next, there are some bits in here that won't have passed through a run
of checkpatch.pl so I'm guessing you haven't followed all the steps
in Documentation/SubmittingPatches or the checklist.  All these steps
make for a cleaner path into the kernel.

Nice to see sensiron have finally adopted a standard bus type, much nicer
driver than the mess that was needed for the sht15 :)  I see from the
datasheet that you can also use that protocol to talk to this device
but people should definitely use this nice i2c driver if they can!

Excellent to see Sensiron producing drivers for their parts.

Other than formatting cleanups and requests for clarification my
only real issue is the magic numbers involved in that user register.
That must be broken out into easy to understand attributes.  For those
elements not covered by current hwmon standards, you should propose
an option on the mailing lists along with appropriate documentation
updates.  If you are unsure on what these should be, please consult
the maintainers cc'd to this email, they are both extremely helpful!

All in all, a nice simple driver that should be easy to fix up.

Thanks,

Jonathan
> 
> Regards,
> Urs
> 
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 95ccbe3..4a96429 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -688,6 +688,16 @@ config SENSORS_SHT15
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called sht15.
>  
> +config SENSORS_SHT21
> +	tristate "Sensiron humidity and temperature sensors. SHT21 and compat."
> +	depends on I2C
> +	help
> +	  If you say yes here you get support for the Sensiron SHT21, SHT25
> +	  humidity and temperature sensors.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called sht21.
> +
>  config SENSORS_S3C
>  	tristate "S3C24XX/S3C64XX Inbuilt ADC"
>  	depends on ARCH_S3C2410
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 33c2ee1..7439653 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -80,6 +80,7 @@ obj-$(CONFIG_SENSORS_PC87427)	+= pc87427.o
>  obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
>  obj-$(CONFIG_SENSORS_S3C)	+= s3c-hwmon.o
>  obj-$(CONFIG_SENSORS_SHT15)	+= sht15.o
> +obj-$(CONFIG_SENSORS_SHT21)	+= sht21.o
>  obj-$(CONFIG_SENSORS_SIS5595)	+= sis5595.o
>  obj-$(CONFIG_SENSORS_SMM665)	+= smm665.o
>  obj-$(CONFIG_SENSORS_SMSC47B397)+= smsc47b397.o
> diff --git a/drivers/hwmon/sht21.c b/drivers/hwmon/sht21.c
> new file mode 100644
> index 0000000..7d3ec82
> --- /dev/null
> +++ b/drivers/hwmon/sht21.c
> @@ -0,0 +1,392 @@
> +/* Sensirion SHT21 humidity and temperature sensor driver
> + *
> + * Copyright (C) 2010 Urs Fleisch <urs.fleisch@sensirion.com>
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
> + * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA
> + *
> + * Data sheet available (5/2010) at
> + * http://www.sensirion.com/en/pdf/product_information/Datasheet-humidity-sensor-SHT21.pdf
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/device.h>
> +
> +/* I2C commands bytes */
> +enum sht21_command {
These are certainly not a natural enum.  A set of '#define's
will be clearer.

> +	SHT21_TRIG_T_MEASUREMENT_HM    = 0xe3,
> +	SHT21_TRIG_RH_MEASUREMENT_HM   = 0xe5,
> +	SHT21_TRIG_T_MEASUREMENT_POLL  = 0xf3,
> +	SHT21_TRIG_RH_MEASUREMENT_POLL = 0xf5,
> +	SHT21_USER_REG_W               = 0xe6,
> +	SHT21_USER_REG_R               = 0xe7,
> +	SHT21_SOFT_RESET               = 0xfe
> +};
> +
> +/* User register bit masks */
> +enum sht21_userreg {
Same, here. This really isn't a sensible enum.
> +	SHT21_RES_12_14BIT   = 0x00,
> +	SHT21_RES_8_12BIT    = 0x01,
> +	SHT21_RES_10_13BIT   = 0x80,
> +	SHT21_RES_11_11BIT   = 0x81,
> +	SHT21_RES_MASK       = 0x81,
> +	SHT21_END_OF_BATTERY = 0x40,
> +	SHT21_ENABLE_HEATER  = 0x04,
> +	SHT21_WRITABLE_MASK  = 0x87
> +};
> +
> +/* Types of measurements */
> +enum sht21_measurement_index {
> +	SHT21_TEMPERATURE,
> +	SHT21_HUMIDITY,
> +	SHT21_NUM_MEASUREMENTS
> +};
> +
> +/**
> + * struct sht21 - SHT21 device specific data
> + * @hwmon_dev: device registered with hwmon
> + * @lock: mutex to ensure only one I2C transfer in progress at a time
Comment probably wants clarifying. I2C transfers can only happen one at a time
anyway. What you are actually protecting is the value of control registers
when you do a read - modify - write. It also protects various bits of this
structure.

> + * @userreg_orig: original value of user register
Why is this cached in here? Looks to be used as temporary cache inside probe
then set back on the driver being removed?  Is this appropriate? Typically
unless there is a strong reason why things like the default value of this
register are provided by plaform data for a given board.

> + * @valid: !=0 if measurements are valid
Perhaps ammend the comment to say they are only invalid before the first
measurement is taken?
> + * @last_update: time of last update (jiffies)
> + * @measurements: cached measurement values, temperature and humidity
> + */
> +struct sht21 {
> +	struct device *hwmon_dev;
> +	struct mutex lock;
> +	u8 userreg_orig;
> +	char valid;
> +	unsigned long last_update;
> +	int measurements[SHT21_NUM_MEASUREMENTS];
> +};
> +
> +/* I2C command to be used for a specifc measurement */
const as well I think? Actually, given we only have one use of
this I'd loose this array and simply have a switch (or if / else)
inline.
> +static u8 sht21_measurement_commands[SHT21_NUM_MEASUREMENTS] = {
> +	SHT21_TRIG_T_MEASUREMENT_HM,
> +	SHT21_TRIG_RH_MEASUREMENT_HM
> +};
> +
> +/**
> + * sht21_temp_ticks_to_millicelsius() - convert raw temperature ticks to
> + * milli celsius
> + * @ticks: temperature ticks value received from sensor
> + */
> +static int sht21_temp_ticks_to_millicelsius(int ticks)
> +{
> +	ticks &= ~0x0003; /* clear status bits */
> +	/* Formula T = -46.85 + 175.72 * ST / 2^16 from data sheet 6.2,
> +	   optimized for integer fixed point (3 digits) arithmetic */
> +	return ((21965 * ticks) >> 13) - 46850;
> +}
> +
> +/**
> + * sht21_rh_ticks_to_per_cent_mille() - convert raw humidity ticks to
> + * one-thousandths of a percent relative humidity
> + * @ticks: humidity ticks value received from sensor
> + */
> +static int sht21_rh_ticks_to_per_cent_mille(int ticks)
> +{
> +	ticks &= ~0x0003; /* clear status bits */
> +	/* Formula RH = -6 + 125 * SRH / 2^16 from data sheet 6.1,
> +	   optimized for integer fixed point (3 digits) arithmetic */
> +	return ((15625 * ticks) >> 13) - 6000;
> +}
> +
> +typedef int (*convert_func)(int);
Don't do this. It just makes the code harder to read. Again, only
used once so I'd just use a switch or if /else inline and get
rid of this array.
> +
> +/* Conversion function to be used for a specifc measurement */
> +static convert_func sht21_convert_raw_value[SHT21_NUM_MEASUREMENTS] = {
> +	sht21_temp_ticks_to_millicelsius,
> +	sht21_rh_ticks_to_per_cent_mille
> +};
> +
> +/**
> + * sht21_update_measurements() - get updated measurements from device
> + * @client: I2C client device
> + *
> + * Returns SHT21 client data containing measurements.
> + */
> +static struct sht21 *sht21_update_measurements(struct i2c_client *client)
> +{
> +	struct sht21 *sht21 = i2c_get_clientdata(client);
> +
> +	mutex_lock(&sht21->lock);
> +	/* Data sheet 2.4:
> +	 * SHT2x should not be active for more than 10% of the time - e.g. maximum
> +	 * two measurements per second at 12bit accuracy shall be made. */
> +	if (time_after(jiffies, sht21->last_update + HZ / 2) || !sht21->valid) {
> +		int meas_idx;
> +		for (meas_idx = 0; meas_idx < SHT21_NUM_MEASUREMENTS; ++meas_idx) {
> +			int result = i2c_smbus_read_word_data(client,
> +			  sht21_measurement_commands[meas_idx]);. 
> +			/* SMBus specifies low byte first, but the SHT21 returns MSB first,
> +			 * so we have to swab16 the values */
> +			if (result >= 0)
> +				sht21->measurements[meas_idx] =
> +				  sht21_convert_raw_value[meas_idx](swab16(result));
> +		}
> +		sht21->last_update = jiffies;
> +		sht21->valid = 1;
> +	}
> +	mutex_unlock(&sht21->lock);
> +
> +	return sht21;
> +}
> +
> +/**
> + * sht21_show_measurement() - show measurement value in sysfs
> + * @dev: device
> + * @attr: device attribute
> + * @buf: sysfs buffer (PAGE_SIZE) where measurement values are written to
> + *
> + * Will be called on read access to a measurement sysfs attribute.
> + * Returns number of bytes written into buffer.
> + */
> +static ssize_t sht21_show_measurement(struct device *dev,
> +        struct device_attribute *attr,
> +        char *buf)
> +{
> +	struct sensor_device_attribute *sda = to_sensor_dev_attr(attr);
> +	struct sht21 *sht21 = sht21_update_measurements(to_i2c_client(dev));
> +
> +	return sprintf(buf, "%d\n", sht21->measurements[sda->index]);
> +}
> +
> +/**
> + * sht21_show_userreg() - show user register value in sysfs
Sorry, but this isn't going to be acceptable.  Classic case of magic numbers.
This needs to be broken up into several different attributes.
We have:
* control over the measurement resolution (which is somewhat fiddly
on this device)
* Battery voltage threshold > 2.25V
* Enable on chip heater
* OTP stuff. I think this basically a 'one shot' mode where the device
flips back to default status after a single reading. Unless you have
a user of this, I'd be tempted to just ignore that bit.
> + * @dev: device
> + * @attr: device attribute
> + * @buf: sysfs buffer (PAGE_SIZE) where user register value is written to
> + *
> + * Will be called on read access to user_register sysfs attribute.
> + * Returns number of bytes written into buffer, -EIO on error.
> + */
> +static ssize_t sht21_show_userreg(struct device *dev,
> +        struct device_attribute *attr,
> +        char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct sht21 *sht21 = i2c_get_clientdata(client);
> +	int result;
> +	mutex_lock(&sht21->lock);
> +	result = i2c_smbus_read_byte_data(client, SHT21_USER_REG_R);
> +	mutex_unlock(&sht21->lock);
> +
> +	return result >= 0 ? sprintf(buf, "%d\n", result) : -EIO;
> +}
> +
> +/**
> + * sht21_store_userreg() - store sysfs value in user register
> + * @dev: device
> + * @attr: device attribute
> + * @buf: sysfs buffer containing value as string
> + * @count: number of characters in @buf
> + *
> + * Will be called on write access to user_register sysfs attribute.
> + * Returns @count, -EIO on error.
> + */
> +static ssize_t sht21_store_userreg(struct device *dev, struct device_attribute *attr,
> +        const char *buf, size_t count)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct sht21 *sht21 = i2c_get_clientdata(client);
> +	int result;
> +	char *endptr;
> +	unsigned long value = simple_strtoul(buf, &endptr, 0);
> +	if (endptr == buf || value > 0xff)
> +		return -EINVAL;
> +
> +	mutex_lock(&sht21->lock);
> +	result = i2c_smbus_read_byte_data(client, SHT21_USER_REG_R);
> +	if (result >= 0)
> +		result = i2c_smbus_write_byte_data(client, SHT21_USER_REG_W,
> +		  (result & ~SHT21_WRITABLE_MASK) | (value & SHT21_WRITABLE_MASK));
> +	mutex_unlock(&sht21->lock);
> +
> +	return result >= 0 ? count : -EIO;
> +}
> +
> +/* sysfs attributes */
> +static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, sht21_show_measurement,
> +  NULL, SHT21_TEMPERATURE);
> +static SENSOR_DEVICE_ATTR(humidity1_input, S_IRUGO, sht21_show_measurement,
> +  NULL, SHT21_HUMIDITY);

So this one is the only one I have problem with. Other two attributes are
standard (well humidity is pretty unusual but no one ever complained about
the sht15 afaik!)
> +static SENSOR_DEVICE_ATTR(user_register, S_IRUGO | S_IWUSR, sht21_show_userreg,
> +  sht21_store_userreg, 0);
> +
> +static struct attribute *sht21_attributes[] = {
> +	&sensor_dev_attr_temp1_input.dev_attr.attr,
> +	&sensor_dev_attr_humidity1_input.dev_attr.attr,
> +	&sensor_dev_attr_user_register.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group sht21_attr_group = {
> +	.attrs = sht21_attributes,
> +};
> +
> +/**
> + * sht21_probe() - probe device
> + * @client: I2C client device
> + * @id: device ID
> + *
> + * Called by the I2C core when an entry in the ID table matches a
> + * device's name.
> + * Returns 0 on success.
> + */
> +static int __devinit sht21_probe(struct i2c_client *client,
> +        const struct i2c_device_id *id)
> +{
> +	struct sht21 *sht21;
> +	int status;
> +	u8 userreg_changed;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> +		dev_err(&client->dev, "adapter does not support SMBus word transactions\n");
> +		return -ENODEV;
> +	}
> +
> +	sht21 = kzalloc(sizeof(*sht21), GFP_KERNEL);
> +	if (!sht21) {
> +		dev_dbg(&client->dev, "kzalloc failed\n");
> +		return -ENOMEM;
> +	}
> +	i2c_set_clientdata(client, sht21);
> +
> +	status = i2c_smbus_read_byte_data(client, SHT21_USER_REG_R);
> +	if (status < 0) {
> +		dev_err(&client->dev, "error reading user register\n");
> +		goto fail_free;
> +	}
> +	sht21->userreg_orig = status;
> +
> +	userreg_changed = status ^ SHT21_RES_MASK;
This needs a comment.  Why exclusive or with a mask?

> +	status = i2c_smbus_write_byte_data(client, SHT21_USER_REG_W, userreg_changed);
> +	if (status < 0) {
> +		dev_err(&client->dev, "error writing user register\n");
> +		goto fail_restore_config;
> +	}
> +	status = i2c_smbus_read_byte_data(client, SHT21_USER_REG_R);
> +	if (status < 0) {
> +		dev_err(&client->dev, "error reading user register\n");
> +		goto fail_restore_config;
> +	}
> +	if (status != userreg_changed) {
> +		dev_err(&client->dev, "user register settings did not stick\n");
This does seem a somewhat paranoid check. Is it really needed in
a production driver?  If this has been seen in the wild, then fair enough!
> +		status = -ENODEV;
> +		goto fail_restore_config;
> +	}
> +	status = i2c_smbus_write_byte_data(client, SHT21_USER_REG_W, sht21->userreg_orig);
> +	if (status < 0) {
> +		dev_err(&client->dev, "error restoring user register\n");
> +		goto fail_restore_config;
> +	}
comment to explain this please.  We don't have an update so why are we setting
last_update?  Obviously valid will ensure we do a new capture whatever this
value is set to.
> +	sht21->last_update = jiffies - HZ;
> +	mutex_init(&sht21->lock);
> +
> +	status = sysfs_create_group(&client->dev.kobj, &sht21_attr_group);
> +	if (status) {
> +		dev_dbg(&client->dev, "could not create sysfs files\n");
> +		goto fail_restore_config;
> +	}
> +	sht21->hwmon_dev = hwmon_device_register(&client->dev);
> +	if (IS_ERR(sht21->hwmon_dev)) {
> +		dev_dbg(&client->dev, "unable to register hwmon device\n");
> +		status = PTR_ERR(sht21->hwmon_dev);
> +		goto fail_remove_sysfs;
> +	}
> +
> +	dev_info(&client->dev, "initialized\n");
> +
> +	return 0;
> +
> +fail_remove_sysfs:
> +	sysfs_remove_group(&client->dev.kobj, &sht21_attr_group);
> +fail_restore_config:
> +	i2c_smbus_write_byte_data(client, SHT21_USER_REG_W, sht21->userreg_orig);
> +fail_free:
> +	kfree(sht21);
> +
> +	return status;
> +}
> +
> +/**
> + * sht21_remove() - remove device
> + * @client: I2C client device
> + */
> +static int __devexit sht21_remove(struct i2c_client *client)
> +{
> +	struct sht21 *sht21 = i2c_get_clientdata(client);
> +	int status;
> +
> +	hwmon_device_unregister(sht21->hwmon_dev);
> +	sysfs_remove_group(&client->dev.kobj, &sht21_attr_group);
> +
> +	status = i2c_smbus_read_byte_data(client, SHT21_USER_REG_R);
> +	if (status >= 0 && status != sht21->userreg_orig) {
> +		i2c_smbus_write_byte_data(client, SHT21_USER_REG_W, sht21->userreg_orig);
Superflous brackets.
> +	}
> +
> +	kfree(sht21);
> +
> +	return 0;
> +}
> +
> +/* Device ID table */
> +static const struct i2c_device_id sht21_id[] = {
> +	{ "sht21", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, sht21_id);
> +
> +static struct i2c_driver sht21_driver = {
> +	.driver.name = "sht21",
> +	.probe       = sht21_probe,
> +	.remove      = __devexit_p(sht21_remove),
> +	.id_table    = sht21_id,
> +};
> +
> +/**
> + * sht21_init() - initialize driver
> + *
> + * Called when kernel is booted or module is inserted.
> + * Returns 0 on success.
> + */
> +static int __init sht21_init(void)
> +{
> +	return i2c_add_driver(&sht21_driver);
> +}
> +module_init(sht21_init);
> +
> +/**
> + * sht21_init() - clean up driver
> + *
> + * Called when module is removed.
> + */
> +static void __exit sht21_exit(void)
> +{
> +	i2c_del_driver(&sht21_driver);
> +}
> +module_exit(sht21_exit);
> +
> +MODULE_AUTHOR("Urs Fleisch <urs.fleisch@sensirion.com>");
> +MODULE_DESCRIPTION("Sensirion SHT21 humidity and temperature sensor driver");
> +MODULE_LICENSE("GPL");

