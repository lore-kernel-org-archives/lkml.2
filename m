Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab1DFFKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 01:10:31 -0400
Received: from imr4.ericy.com ([198.24.6.8]:43542 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab1DFFK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 01:10:29 -0400
Date: Tue, 5 Apr 2011 22:09:29 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "achew@nvidia.com" <achew@nvidia.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "w30289@motorola.com" <w30289@motorola.com>,
        "toddpoynor@google.com" <toddpoynor@google.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "olofj@chromium.org" <olofj@chromium.org>
Subject: Re: [PATCH 1/1] [hwmon] nct1008: Initial NCT1008 driver
Message-ID: <20110406050929.GA22741@ericsson.com>
References: <1302059183-29631-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1302059183-29631-1-git-send-email-achew@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 11:06:23PM -0400, achew@nvidia.com wrote:
> From: Andrew Chew <achew@nvidia.com>
> 
> This is a digital temperature sensor I2C peripheral from ON Semiconductor.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>

Comments inline. Note that this is not a complete review.

> ---
>  drivers/hwmon/Kconfig   |   11 ++
>  drivers/hwmon/Makefile  |    1 +
>  drivers/hwmon/nct1008.c |  423 +++++++++++++++++++++++++++++++++++++++++++++++

Documentation/hwmon/nct1008 is missing.

>  3 files changed, 435 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/nct1008.c
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 060ef63..daa6159 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -738,6 +738,17 @@ config SENSORS_MAX6650
>           This driver can also be built as a module.  If so, the module
>           will be called max6650.
> 
> +config SENSORS_NCT1008
> +       tristate "ON Semiconductor Temperature Sensor"
> +       default n
> +       depends on I2C
> +       help
> +         Say yes here if you wish to include the ON Semiconductor
> +         NCT1008 Temperature sensor.
> +
> +         This driver can also be built as a module.  If so, the module
> +         will be called nct1008.
> +
>  config SENSORS_PC87360
>         tristate "National Semiconductor PC87360 family"
>         select HWMON_VID
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 967d0ea..803893c 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -87,6 +87,7 @@ obj-$(CONFIG_SENSORS_MAX1619) += max1619.o
>  obj-$(CONFIG_SENSORS_MAX6639)  += max6639.o
>  obj-$(CONFIG_SENSORS_MAX6650)  += max6650.o
>  obj-$(CONFIG_SENSORS_MC13783_ADC)+= mc13783-adc.o
> +obj-$(CONFIG_SENSORS_NCT1008)  += nct1008.o
>  obj-$(CONFIG_SENSORS_PC87360)  += pc87360.o
>  obj-$(CONFIG_SENSORS_PC87427)  += pc87427.o
>  obj-$(CONFIG_SENSORS_PCF8591)  += pcf8591.o
> diff --git a/drivers/hwmon/nct1008.c b/drivers/hwmon/nct1008.c
> new file mode 100644
> index 0000000..ebae3b6
> --- /dev/null
> +++ b/drivers/hwmon/nct1008.c
> @@ -0,0 +1,423 @@
> +/*
> + * Driver for NCT1008, temperature monitoring device from ON Semiconductors
> + *
> + * Copyright (c) 2010, NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +
> +
> +#include <linux/interrupt.h>
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/gpio.h>
> +
Extra / unnecessary blank line.

> +#include <linux/nct1008.h>

This include file is missing from the patch (and it should probably be in
include/linux/i2c).

If it is defined / maintained in some other branch, at least let us know 
where to get it from. But since it contains the platform data for_this_
driver, it should be defined in this patch and not elsewhere.

> +#include <linux/hwmon.h>
> +
> +#define DRIVER_NAME "nct1008"
> +
> +/* Register Addresses */
> +#define LOCAL_TEMP_RD                  0x00
> +#define EXT_HI_TEMP_RD                 0x01
> +#define EXT_LO_TEMP_RD                 0x10
> +#define STATUS_RD                      0x02
> +#define CONFIG_RD                      0x03
> +
> +#define CONFIG_WR                      0x09
> +#define CONV_RATE_WR                   0x0A
> +#define LOCAL_TEMP_HI_LIMIT_WR         0x0B
> +#define EXT_TEMP_HI_LIMIT_HI_BYTE      0x0D
> +#define OFFSET_WR                      0x11
> +#define EXT_THERM_LIMIT_WR             0x19
> +#define LOCAL_THERM_LIMIT_WR           0x20
> +#define THERM_HYSTERESIS_WR            0x21
> +
> +/* Configuration Register Bits */
> +#define EXTENDED_RANGE_BIT             (0x1 << 2)
> +#define THERM2_BIT                     (0x1 << 5)
> +#define STANDBY_BIT                    (0x1 << 6)
> +
> +/* Max Temperature Measurements */
> +#define EXTENDED_RANGE_OFFSET          64U
> +#define STANDARD_RANGE_MAX             127U
> +#define EXTENDED_RANGE_MAX             (150U + EXTENDED_RANGE_OFFSET)
> +
> +static inline u8 temperature_to_value(bool extended, u8 temp);
> +
Please no forward declarations.

> +struct nct1008_data {
> +       struct device *hwmon_dev;
> +       struct work_struct work;
> +       struct i2c_client *client;
> +       struct mutex mutex;
> +       u8 config;
> +       void (*alarm_fn)(bool raised);
> +};
> +
> +static ssize_t nct1008_show_temp(struct device *dev,
> +       struct device_attribute *attr, char *buf)
> +{
> +       struct i2c_client *client = to_i2c_client(dev);
> +       signed int temp_value = 0;
> +       u8 data = 0;
> +
> +       if (!dev || !buf || !attr)

Those checks are unnecessary.

> +               return -EINVAL;
> +
> +       data = i2c_smbus_read_byte_data(client, LOCAL_TEMP_RD);
> +       if (data < 0) {

'data" is defined as u8 and will never be < 0.

> +               dev_err(&client->dev, "%s: failed to read "
> +                       "temperature\n", __func__);

Should manage to specify this line w/o having to break the string in two lines.
Usage of __func__ is discouraged.

> +               return -EINVAL;
> +       }
> +
> +       temp_value = (signed int)data;
> +       return sprintf(buf, "%d\n", temp_value);

temp_value and the type cast are completely unnecessary. And the displayed
result is wrong if the selected temperature range is extended. Plus it is displayed
in degrees C instead of milli-degrees C.

> +}
> +
> +static ssize_t nct1008_show_ext_temp(struct device *dev,
> +       struct device_attribute *attr, char *buf)
> +{
> +       struct i2c_client *client = to_i2c_client(dev);
> +       signed int temp_value = 0;
> +       u8 data = 0;
> +
> +       if (!dev || !buf || !attr)
> +               return -EINVAL;
> +
Those checks are unnecessary.

> +       data = i2c_smbus_read_byte_data(client, EXT_HI_TEMP_RD);
> +       if (data < 0) {

Will never be < 0. Wonder why gcc doesn't complain. Or does it ?

> +               dev_err(&client->dev, "%s: failed to read "
> +                       "ext_temperature\n", __func__);

Another unnecessary string break. Usage of __func__ is discouraged.

> +               return -EINVAL;
> +       }
> +
> +       temp_value = (signed int)data;
> +
Why not assign to the "real" variable right away ?

> +       data = i2c_smbus_read_byte_data(client, EXT_LO_TEMP_RD);
> +
> +       return sprintf(buf, "%d.%d\n", temp_value, (25 * (data >> 6)));

So you expect to get something like -25.-13 ? Odd. Wrong anyway, since you are expected to display 
the result in milli-degrees C and the extended range offset (if configured) is not taken 
into account. 

> +}
> +
> +static ssize_t nct1008_store_throttle_ext_limit(struct device *dev,
> +       struct device_attribute *attr, const char *buf, size_t count)
> +{
> +       struct i2c_client *client = to_i2c_client(dev);
> +       struct nct1008_platform_data *pdata = client->dev.platform_data;
> +       unsigned long res;
> +       u8 ext_limit;
> +       u8 value;
> +       int err;
> +
> +       err = strict_strtoul(buf, 0, &res);
> +       if (err)
> +               return -EINVAL;
> +
> +       ext_limit = (u8)res;
> +
Truncates everything entered to [0..255]. 257 becomes 1. Odd. Use SENSORS_LIMIT.
The extended range would be -64 .. +191 degreec C and should be supported.

> +       /* External Temperature Throttling limit */
> +       value = temperature_to_value(pdata->ext_range, ext_limit);

The following lines need to be mutex protected.

> +       err = i2c_smbus_write_byte_data(client,
> +                                       EXT_TEMP_HI_LIMIT_HI_BYTE, value);
> +       if (err < 0)
> +               return -EINVAL;
> +
> +       pdata->throttling_ext_limit = ext_limit;

Storing limits in platform data ? This is really quite unusual.

> +       return count;
> +}
> +
> +static ssize_t nct1008_show_throttle_ext_limit(struct device *dev,
> +       struct device_attribute *attr, char *buf)
> +{
> +       struct i2c_client *client = to_i2c_client(dev);
> +       struct nct1008_platform_data *pdata = client->dev.platform_data;
> +       u8 ext_limit = 0;
> +
> +       if (!dev || !buf || !attr)
> +               return -EINVAL;

Unnecessary.

> +
> +       ext_limit = pdata->throttling_ext_limit;
> +
> +       return sprintf(buf, "%d\n", ext_limit);

Unnecessary variable. Display expected to be in milli-degrees C. Since ext_limit type
is u8, %u would be appropriate. 


> +}
> +
> +static DEVICE_ATTR(temperature, S_IRUGO, nct1008_show_temp, NULL);
> +static DEVICE_ATTR(ext_temperature, S_IRUGO, nct1008_show_ext_temp, NULL);
> +static DEVICE_ATTR(throttle_ext_limit, S_IRUGO | S_IWUSR,
> +                  nct1008_show_throttle_ext_limit,
> +                  nct1008_store_throttle_ext_limit);
> +

Use standard sysfs attributes. 

FWIW, throttling is not a chip functionality - maybe it is what
your HW implementation does if the limit is exceeded, but it is not
a chip function. Function names should not reflect what a specific 
HW using the chip does, but chip functionality. 

The chip supports low limits. The driver should support those too.
The same is true for alarms.

> +static struct attribute *nct1008_attributes[] = {
> +       &dev_attr_temperature.attr,
> +       &dev_attr_ext_temperature.attr,
> +       &dev_attr_throttle_ext_limit.attr,
> +       NULL
> +};
> +
> +static const struct attribute_group nct1008_attr_group = {
> +       .attrs = nct1008_attributes,
> +};
> +
> +static void nct1008_enable(struct i2c_client *client)
> +{
> +       struct nct1008_data *data = i2c_get_clientdata(client);
> +
> +       i2c_smbus_write_byte_data(client, CONFIG_WR,
> +                                 data->config & ~STANDBY_BIT);
> +}
> +
> +static void nct1008_disable(struct i2c_client *client)
> +{
> +       struct nct1008_data *data = i2c_get_clientdata(client);
> +
> +       i2c_smbus_write_byte_data(client, CONFIG_WR,
> +                                 data->config | STANDBY_BIT);
> +}
> +
> +
> +static void nct1008_work_func(struct work_struct *work)
> +{
> +       struct nct1008_data *data =
> +               container_of(work, struct nct1008_data, work);
> +       int irq = data->client->irq;
> +
> +       mutex_lock(&data->mutex);
> +
> +       if (data->alarm_fn) {
> +               /* Therm2 line is active low */
> +               data->alarm_fn(!gpio_get_value(irq_to_gpio(irq)));

	Substantial context assumption here. How does the driver know
	that the irq maps to a gpio pin, and that the value read from 
	this gpio pin needs to be passed to the alarm function ?

	This is really very HW specific. Play with gpio pins in the alarm
	function itself, and just pass the irq from here.

> +       }
> +
> +       mutex_unlock(&data->mutex);
> +}
> +
> +static irqreturn_t nct1008_irq(int irq, void *dev_id)
> +{
> +       struct nct1008_data *data = dev_id;
> +       schedule_work(&data->work);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static inline u8 value_to_temperature(bool extended, u8 value)
> +{
> +       return extended ? (u8)(value - EXTENDED_RANGE_OFFSET) : value;

So, say, 32 is converted to (256 - 32) = 224. Does this really make sense ?
I would say no, since the extended range starts at -64 degrees C and one would assume
that -64 should be displayed if the value is 0, not 224.

Btw, this function is never called.

> +}
> +
> +static inline u8 temperature_to_value(bool extended, u8 temp)
> +{
> +       return extended ? (u8)(temp + EXTENDED_RANGE_OFFSET) : temp;
> +}
> +
> +static int __devinit nct1008_configure_sensor(struct nct1008_data* data)
> +{
> +       struct i2c_client *client           = data->client;
> +       struct nct1008_platform_data *pdata = client->dev.platform_data;
> +       u8 value;
> +       int err;
> +
> +       if (!pdata || !pdata->supported_hwrev)
> +               return -ENODEV;
> +
Odd flag (supported_hwrev). What is the point of such a flag ? Just don't 
instantiate the device if it isn't supported. Actually, I would argue that such
a flag should not exist at all. If the chip is there, it is by definition 
supported.

Odd place to check if pdata exists.

> +       /*
> +        * Initial Configuration - device is placed in standby and
> +        * ALERT/THERM2 pin is configured as THERM2
> +        */
> +       data->config = value = pdata->ext_range ?
> +               (STANDBY_BIT | THERM2_BIT | EXTENDED_RANGE_BIT) :
> +               (STANDBY_BIT | THERM2_BIT);
> +
> +       err = i2c_smbus_write_byte_data(client, CONFIG_WR, value);
> +       if (err < 0)
> +               goto error;
> +
> +       /* Temperature conversion rate */
> +       err = i2c_smbus_write_byte_data(client, CONV_RATE_WR, pdata->conv_rate);
> +       if (err < 0)
> +               goto error;
> +
Standard attribute exists, please define and use it.

> +       /* External temperature h/w shutdown limit */
> +       value = temperature_to_value(pdata->ext_range,
> +                                    pdata->shutdown_ext_limit);
> +       err = i2c_smbus_write_byte_data(client, EXT_THERM_LIMIT_WR, value);
> +       if (err < 0)
> +               goto error;
> +
> +       /* Local temperature h/w shutdown limit */
> +       value = temperature_to_value(pdata->ext_range,
> +                                    pdata->shutdown_local_limit);
> +       err = i2c_smbus_write_byte_data(client, LOCAL_THERM_LIMIT_WR, value);
> +       if (err < 0)
> +               goto error;
> +
> +       /* External Temperature Throttling limit */
> +       value = temperature_to_value(pdata->ext_range,
> +                                    pdata->throttling_ext_limit);
> +       err = i2c_smbus_write_byte_data(client, EXT_TEMP_HI_LIMIT_HI_BYTE,
> +                                       value);
> +       if (err < 0)
> +               goto error;
> +
> +       /* Local Temperature Throttling limit */
> +       value = pdata->ext_range ? EXTENDED_RANGE_MAX : STANDARD_RANGE_MAX;
> +       err = i2c_smbus_write_byte_data(client, LOCAL_TEMP_HI_LIMIT_WR, value);
> +       if (err < 0)
> +               goto error;
> +
> +       /* Remote channel offset */
> +       err = i2c_smbus_write_byte_data(client, OFFSET_WR, pdata->offset);
> +       if (err < 0)
> +               goto error;
> +
> +       /* THERM hysteresis */
> +       err = i2c_smbus_write_byte_data(client, THERM_HYSTERESIS_WR,
> +                                       pdata->hysteresis);

There is a standard sysfs attribute for this. Please define and use it.

> +       if (err < 0)
> +               goto error;
> +
> +       data->alarm_fn = pdata->alarm_fn;
> +       return 0;
> +error:
> +       return err;
> +}
> +
> +static int __devinit nct1008_configure_irq(struct nct1008_data *data)
> +{
> +       INIT_WORK(&data->work, nct1008_work_func);
> +
> +       return request_irq(data->client->irq, nct1008_irq, IRQF_TRIGGER_RISING |
> +                               IRQF_TRIGGER_FALLING, DRIVER_NAME, data);
> +}
> +

The chip has manufacturer ID and die revision (chip revision) registers,
so there should be a _detect function, and the driver should not depend
on the existence of platform data. Instead, if platform data does not exist,
it should be assumed that the chip is already configured, and configuration data
(limits etc) should be retrieved from it.

Of course that means you should not use platform data but store/copy information
from platform data in nct1008_data instead. This is the common approach anyway.


> +static int __devinit nct1008_probe(struct i2c_client *client,
> +                                  const struct i2c_device_id *id)
> +{
> +       struct nct1008_data *data;
> +       int err;
> +
> +       data = kzalloc(sizeof(struct nct1008_data), GFP_KERNEL);
> +
Unnecessary blank line.

> +       if (!data)
> +               return -ENOMEM;
> +
> +       data->client = client;
> +       i2c_set_clientdata(client, data);
> +       mutex_init(&data->mutex);
> +
> +       err = nct1008_configure_sensor(data);   /* sensor is in standby */
> +       if (err < 0)
> +               goto error;
> +
Hard assumption that the sensor has not yet been configured. Not necessarily true.

> +       err = nct1008_configure_irq(data);
> +       if (err < 0)
> +               goto error;
> +
Do you actually enable the interrupt anywhere (other than in _resume) ? 
Or is it auto-enabled ?

A generic driver should not make the assumption that there is an irq line
in the first place. The driver should also work without an irq.

> +       data->hwmon_dev = hwmon_device_register(&client->dev);
> +       if (IS_ERR(data->hwmon_dev)) {
> +               err = PTR_ERR(data->hwmon_dev);
> +               dev_err(&client->dev, "%s: hwmon_device_register "
> +                       "failed\n", __func__);

Another unnecessary string break.

> +               goto error;
> +       }
> +
> +       /* register sysfs hooks */
> +       err = sysfs_create_group(&client->dev.kobj, &nct1008_attr_group);
> +       if (err < 0)
> +               goto fail_sys;
> +
> +       nct1008_enable(client);         /* sensor is running */
> +
Race condition (the chip is already visible to userland, and chip functions
may be called in parallel). Please enable the chip before registering it.

> +       schedule_work(&data->work);             /* check initial state */
> +
All the worker function does is to check if the alarm function needs to be called,
and to call it if that is the case. If there is no alarm function (or no irq),
scheduling the work function is unnecessary. 

> +       return 0;
> +
> +fail_sys:
> +       hwmon_device_unregister(data->hwmon_dev);
> +error:
> +       kfree(data);
> +       return err;
> +}
> +
> +static int __devexit nct1008_remove(struct i2c_client *client)
> +{
> +       struct nct1008_data *data = i2c_get_clientdata(client);
> +
> +       free_irq(data->client->irq, data);
> +       cancel_work_sync(&data->work);
> +       hwmon_device_unregister(data->hwmon_dev);
> +       sysfs_remove_group(&client->dev.kobj, &nct1008_attr_group);
> +       kfree(data);
> +
> +       return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int nct1008_suspend(struct i2c_client *client, pm_message_t state)
> +{
> +       disable_irq(client->irq);
> +       nct1008_disable(client);
> +
> +       return 0;
> +}
> +
> +static int nct1008_resume(struct i2c_client *client)
> +{
> +       struct nct1008_data *data = i2c_get_clientdata(client);
> +
> +       nct1008_enable(client);
> +       enable_irq(client->irq);
> +       schedule_work(&data->work);
> +
> +       return 0;
> +}
> +#endif
> +
> +static const struct i2c_device_id nct1008_id[] = {
> +       { DRIVER_NAME, 0 },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(i2c, nct1008_id);
> +
> +static struct i2c_driver nct1008_driver = {
> +       .driver = {
> +               .name   = DRIVER_NAME,
> +       },
> +       .probe          = nct1008_probe,
> +       .remove         = __devexit_p(nct1008_remove),
> +       .id_table       = nct1008_id,
> +#ifdef CONFIG_PM
> +       .suspend        = nct1008_suspend,
> +       .resume         = nct1008_resume,
> +#endif
> +};
> +
> +static int __init nct1008_init(void)
> +{
> +       return i2c_add_driver(&nct1008_driver);
> +}
> +
> +static void __exit nct1008_exit(void)
> +{
> +       i2c_del_driver(&nct1008_driver);
> +}
> +
> +MODULE_DESCRIPTION("Temperature sensor driver for OnSemi NCT1008");
> +MODULE_LICENSE("GPL");
> +
> +module_init(nct1008_init);
> +module_exit(nct1008_exit);
> --
> 1.7.0.4
> 
