Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab0HaIYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 04:24:39 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:5065 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab0HaIYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 04:24:35 -0400
Date: Tue, 31 Aug 2010 10:24:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: cbouatmailru@gmail.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, achew@nvidia.com
Subject: Re: [PATCH 1/1] power supply: add driver for TI BQ20Z75 gas gauge
 IC
Message-ID: <20100831102421.17e73b5d@hyperion.delvare>
In-Reply-To: <1282949443-8052-1-git-send-email-rklein@nvidia.com>
References: <1282949443-8052-1-git-send-email-rklein@nvidia.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rhyland,

On Fri, 27 Aug 2010 15:50:43 -0700, rklein@nvidia.com wrote:
> From: Rhyland Klein <rklein@nvidia.com>
> 
> this driver depends on I2C and uses SMBUS for communication with the host.

Quick review (I am not familiar with the power supply API):

> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
>  drivers/power/Kconfig   |    7 +
>  drivers/power/Makefile  |    1 +
>  drivers/power/bq20z75.c |  403 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 411 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/power/bq20z75.c
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 8e9ba17..c72e628 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -142,4 +142,11 @@ config CHARGER_PCF50633
>  	help
>  	 Say Y to include support for NXP PCF50633 Main Battery Charger.
>  
> +config BQ20Z75_GASGAUGE

Following the naming used for other options in this menu, this would be
BATTERY_BQ20Z75.

> +        tristate "TI BQ20Z75 GAS GAUGE"

Not all capitals, please.

> +        depends on I2C
> +        help
> +         Say Y to include support for TI BQ20Z75 SBS-compliant
> +         gas gauge and protection IC.
> +
>  endif # POWER_SUPPLY
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index 0005080..98abc31 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -34,3 +34,4 @@ obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
>  obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
>  obj-$(CONFIG_BATTERY_Z2)	+= z2_battery.o
>  obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
> +obj-$(CONFIG_BQ20Z75_GASGAUGE)  += bq20z75.o
> diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
> new file mode 100644
> index 0000000..4eb6638
> --- /dev/null
> +++ b/drivers/power/bq20z75.c
> @@ -0,0 +1,403 @@
> +/*
> + * drivers/power/bq20z75.c

Please remove, this doesn't add much value and is likely to get
outdated at some point.

> + *
> + * Gas Gauge driver for TI's BQ20Z75
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
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/err.h>
> +#include <linux/debugfs.h>

I don't think you need this one?

> +#include <linux/power_supply.h>
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +
> +enum {
> +	REG_MANUFACTURER_DATA,
> +	REG_TEMPERATURE,
> +	REG_VOLTAGE,
> +	REG_CURRENT,
> +	REG_CAPACITY,
> +	REG_TIME_TO_EMPTY,
> +	REG_TIME_TO_FULL,
> +	REG_STATUS,
> +	REG_CYCLE_COUNT,
> +	REG_SERIAL_NUMBER,
> +	REG_MAX
> +};
> +
> +#define BATTERY_MANUFACTURER_SIZE	12
> +#define BATTERY_NAME_SIZE		8

You don't use these anywhere?

> +
> +/* manufacturer access defines */
> +#define MANUFACTURER_ACCESS_STATUS	0x0006
> +#define MANUFACTURER_ACCESS_SLEEP	0x0011
> +
> +/* battery status value bits */
> +#define BATTERY_CHARGING		0x40
> +#define BATTERY_FULL_CHARGED		0x20
> +#define BATTERY_FULL_DISCHARGED		0x10
> +
> +#define BQ20Z75_DATA(_psp, _addr, _min_value, _max_value) { \
> +	.psp = _psp, \
> +	.addr = _addr, \
> +	.min_value = _min_value, \
> +	.max_value = _max_value, \
> +}
> +
> +static struct bq20z75_device_data {

This could be const.

> +	enum power_supply_property psp;
> +	u8 addr;
> +	int min_value;
> +	int max_value;
> +} bq20z75_data[] = {
> +	[REG_MANUFACTURER_DATA] =
> +		BQ20Z75_DATA(POWER_SUPPLY_PROP_PRESENT, 0x00, 0, 65535),
> +	[REG_TEMPERATURE] =
> +		BQ20Z75_DATA(POWER_SUPPLY_PROP_TEMP, 0x08, 0, 65535),
> +	[REG_VOLTAGE] =
> +		BQ20Z75_DATA(POWER_SUPPLY_PROP_VOLTAGE_NOW, 0x09, 0, 20000),
> +	[REG_CURRENT] =
> +		BQ20Z75_DATA(POWER_SUPPLY_PROP_CURRENT_NOW, 0x0A, -32768, \
> +			32767),

You don't need the backslash at the end of the line.

> +	[REG_CAPACITY] =
> +		BQ20Z75_DATA(POWER_SUPPLY_PROP_CAPACITY, 0x0e, 0, 100),

Please be consistent with case in hexadecimal numbers.

> +	[REG_TIME_TO_EMPTY] =
> +		BQ20Z75_DATA(POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG, 0x12, 0, \
> +			65535),
> +	[REG_TIME_TO_FULL] =
> +		BQ20Z75_DATA(POWER_SUPPLY_PROP_TIME_TO_FULL_AVG, 0x13, 0, \
> +			65535),
> +	[REG_STATUS] =
> +		BQ20Z75_DATA(POWER_SUPPLY_PROP_STATUS, 0x16, 0, 65535),
> +	[REG_CYCLE_COUNT] =
> +		BQ20Z75_DATA(POWER_SUPPLY_PROP_CYCLE_COUNT, 0x17, 0, 65535),
> +	[REG_SERIAL_NUMBER] =
> +		BQ20Z75_DATA(POWER_SUPPLY_PROP_SERIAL_NUMBER, 0x1C, 0, 65535),
> +};
> +
> +static enum power_supply_property bq20z75_properties[] = {
> +	POWER_SUPPLY_PROP_STATUS,
> +	POWER_SUPPLY_PROP_HEALTH,
> +	POWER_SUPPLY_PROP_PRESENT,
> +	POWER_SUPPLY_PROP_TECHNOLOGY,
> +	POWER_SUPPLY_PROP_CYCLE_COUNT,
> +	POWER_SUPPLY_PROP_VOLTAGE_NOW,
> +	POWER_SUPPLY_PROP_CURRENT_NOW,
> +	POWER_SUPPLY_PROP_CAPACITY,
> +	POWER_SUPPLY_PROP_TEMP,
> +	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
> +	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
> +	POWER_SUPPLY_PROP_SERIAL_NUMBER,
> +};
> +
> +static int bq20z75_get_property(struct power_supply *psy,
> +	enum power_supply_property psp, union power_supply_propval *val);
> +
> +static struct power_supply bq20z75_supply = {
> +	.name = "battery",
> +	.type = POWER_SUPPLY_TYPE_BATTERY,
> +	.properties = bq20z75_properties,
> +	.num_properties = ARRAY_SIZE(bq20z75_properties),
> +	.get_property = bq20z75_get_property,
> +};
> +
> +struct bq20z75_device_info {
> +	struct i2c_client	*client;
> +} *bq20z75_device;

This structure doesn't seem terribly useful. You typically need the
client to get to this information... And storing the device pointer as
a global is evil anyway, please don't do that.

> +
> +static int bq20z75_get_battery_presence_and_health(
> +	enum power_supply_property psp,	union power_supply_propval *val)
> +{
> +	s32 ret;
> +
> +	/* Write to ManufacturerAccess with
> +	 * ManufacturerAccess command and then
> +	 * read the status */
> +	ret = i2c_smbus_write_word_data(bq20z75_device->client,
> +		bq20z75_data[REG_MANUFACTURER_DATA].addr,
> +		MANUFACTURER_ACCESS_STATUS);
> +	if (ret < 0) {
> +		dev_err(&bq20z75_device->client->dev,
> +			"%s: i2c write for battery presence failed\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +
> +	ret = i2c_smbus_read_word_data(bq20z75_device->client,
> +		bq20z75_data[REG_MANUFACTURER_DATA].addr);
> +	if (ret < 0) {
> +		dev_err(&bq20z75_device->client->dev,
> +			"%s: i2c read for battery presence failed\n",
> +			__func__);
> +		return -EINVAL;
> +	}

-EINVAL doesn't look like the right error code. -ENODEV or -EIO would
seem more appropriate. Same issue several times, please address them
all.

> +
> +	if (ret < bq20z75_data[REG_MANUFACTURER_DATA].min_value ||
> +	    ret > bq20z75_data[REG_MANUFACTURER_DATA].max_value) {
> +		val->intval = 0;
> +		return 0;
> +	}
> +
> +	/* Mask the upper nibble of 2nd byte and
> +	 * lower byte of response then
> +	 * shift the result by 8 to get status*/
> +	ret &= 0x0F00;
> +	ret >>= 8;
> +	if (psp == POWER_SUPPLY_PROP_PRESENT) {
> +		if (ret == 0x0F)
> +			/* battery removed */
> +			val->intval = 0;
> +		else
> +			val->intval = 1;
> +	} else if (psp == POWER_SUPPLY_PROP_HEALTH) {
> +		if (ret == 0x09)
> +			val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
> +		else if (ret == 0x0B)
> +			val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
> +		else if (ret == 0x0C)
> +			val->intval = POWER_SUPPLY_HEALTH_DEAD;
> +		else
> +			val->intval = POWER_SUPPLY_HEALTH_GOOD;
> +	}
> +
> +	return 0;
> +}
> +
> +static int bq20z75_get_battery_property(int reg_offset,
> +	enum power_supply_property psp,
> +	union power_supply_propval *val)
> +{
> +	s32 ret;
> +
> +	ret = i2c_smbus_read_word_data(bq20z75_device->client,
> +		bq20z75_data[reg_offset].addr);
> +	if (ret < 0) {
> +		dev_err(&bq20z75_device->client->dev,
> +			"%s: i2c read for %d failed\n", __func__, reg_offset);
> +		return -EINVAL;
> +	}
> +
> +	if (ret >= bq20z75_data[reg_offset].min_value &&
> +	    ret <= bq20z75_data[reg_offset].max_value) {
> +		val->intval = ret;
> +		if (psp == POWER_SUPPLY_PROP_STATUS) {
> +			/* mask the upper byte and then find the
> +			 * actual status */
> +			ret &= 0x00FF;

As far as I can see, this masking is a no-op.

> +			if (ret & BATTERY_CHARGING)
> +				val->intval = POWER_SUPPLY_STATUS_CHARGING;
> +			else if (ret & BATTERY_FULL_CHARGED)
> +				val->intval = POWER_SUPPLY_STATUS_FULL;
> +			else if (ret & BATTERY_FULL_DISCHARGED)
> +				val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
> +			else
> +				val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
> +		}
> +		/* bq20z75 provides battery tempreture in 0.1Â°K
> +		 * so convert it to Â°C */
> +		else if (psp == POWER_SUPPLY_PROP_TEMP)
> +			val->intval = ret - 2731;
> +	} else {
> +		val->intval = 0;

This should be moved...

> +		if (psp == POWER_SUPPLY_PROP_STATUS)
> +			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;

... here, with a else.

> +	}
> +
> +	return 0;
> +}
> +
> +static int bq20z75_get_battery_capacity(union power_supply_propval *val)
> +{
> +	s32 ret;
> +
> +	ret = i2c_smbus_read_byte_data(bq20z75_device->client,
> +		bq20z75_data[REG_CAPACITY].addr);
> +	if (ret < 0) {
> +		dev_err(&bq20z75_device->client->dev,
> +			"%s: i2c read for %d failed\n", __func__, REG_CAPACITY);
> +		return -EINVAL;
> +	}
> +
> +	/* bq20z75 spec says that this can be >100 %
> +	 * even if max value is 100 % */
> +	val->intval = ((ret >= 100) ? 100 : ret);

Can also be written min(ret, 100).

> +
> +	return 0;
> +}
> +
> +static int bq20z75_get_property(struct power_supply *psy,
> +	enum power_supply_property psp,
> +	union power_supply_propval *val)
> +{
> +	u8 count;

For loops like int better.

> +
> +	switch (psp) {
> +	case POWER_SUPPLY_PROP_PRESENT:
> +	case POWER_SUPPLY_PROP_HEALTH:
> +		if (bq20z75_get_battery_presence_and_health(psp, val))
> +			return -EINVAL;

You should pass down the exact error value returned by the function,
instead of hardcoding it. Same below.

> +		break;
> +
> +	case POWER_SUPPLY_PROP_TECHNOLOGY:
> +		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
> +		break;
> +
> +	case POWER_SUPPLY_PROP_CAPACITY:
> +		if (bq20z75_get_battery_capacity(val))
> +			return -EINVAL;
> +		break;
> +
> +	case POWER_SUPPLY_PROP_STATUS:
> +	case POWER_SUPPLY_PROP_CYCLE_COUNT:
> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> +	case POWER_SUPPLY_PROP_CURRENT_NOW:
> +	case POWER_SUPPLY_PROP_TEMP:
> +	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
> +	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
> +	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
> +		for (count = 0; count < REG_MAX; count++) {
> +			if (psp == bq20z75_data[count].psp)
> +				break;
> +		}
> +
> +		if (bq20z75_get_battery_property(count, psp, val))
> +			return -EINVAL;
> +			break;

Wrong indentation.

> +
> +	default:
> +		dev_err(&bq20z75_device->client->dev,
> +			"%s: INVALID property\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	printk(KERN_INFO "%s: property = %d, value = %d\n", __func__,
> +		psp, val->intval);

Should be turned into dev_dbg().

> +
> +	return 0;
> +}
> +
> +static int bq20z75_probe(struct i2c_client *client,
> +	const struct i2c_device_id *id)
> +{
> +	int rc;
> +
> +	bq20z75_device = kzalloc(sizeof(*bq20z75_device), GFP_KERNEL);
> +	if (!bq20z75_device)
> +		return -ENOMEM;
> +
> +memset(bq20z75_device, 0, sizeof(*bq20z75_device));

Wrong indentation, and useless code, as kzalloc did it for you already.

> +
> +	bq20z75_device->client = client;
> +	i2c_set_clientdata(client, bq20z75_device);
> +
> +	rc = power_supply_register(&client->dev, &bq20z75_supply);
> +	if (rc) {
> +		dev_err(&bq20z75_device->client->dev,
> +			"%s: Failed to register power supply\n", __func__);
> +		kfree(bq20z75_device);
> +		return rc;
> +	}
> +
> +	dev_info(&bq20z75_device->client->dev,
> +		"%s: battery driver registered\n", client->name);

What you did here is register a device, not a driver.

> +
> +	return 0;
> +}
> +
> +static int bq20z75_remove(struct i2c_client *client)
> +{
> +	struct bq20z75_device_info *bq20z75_device = i2c_get_clientdata(client);
> +
> +	power_supply_unregister(&bq20z75_supply);
> +	kfree(bq20z75_device);
> +	bq20z75_device = NULL;
> +
> +	return 0;
> +}
> +
> +#if defined CONFIG_PM
> +static int bq20z75_suspend(struct i2c_client *client,
> +	pm_message_t state)
> +{
> +	s32 ret;
> +	struct bq20z75_device_info *bq20z75_device = i2c_get_clientdata(client);

You get the data from the client...

> +
> +	/* write to manufacture access with sleep command */

(typo: manufacturer)

> +	ret = i2c_smbus_write_word_data(bq20z75_device->client,

... just to get the client from the data. Terribly efficient ;)

> +		bq20z75_data[REG_MANUFACTURER_DATA].addr,
> +		MANUFACTURER_ACCESS_SLEEP);
> +	if (ret < 0) {
> +		dev_err(&bq20z75_device->client->dev,
> +			"%s: i2c write for %d failed\n",
> +			__func__, MANUFACTURER_ACCESS_SLEEP);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/* any smbus transaction will wake up bq20z75 */
> +static int bq20z75_resume(struct i2c_client *client)
> +{
> +	return 0;
> +}
> +#endif
> +
> +static const struct i2c_device_id bq20z75_id[] = {
> +	{ "bq20z75-battery", 0 },

"-battery" is redundant, just use "bq20z75".

> +	{},

Needless comma.

> +};
> +
> +static struct i2c_driver bq20z75_battery_driver = {
> +	.probe		= bq20z75_probe,
> +	.remove		= bq20z75_remove,
> +#if defined CONFIG_PM
> +	.suspend	= bq20z75_suspend,
> +	.resume		= bq20z75_resume,
> +#endif
> +	.id_table	= bq20z75_id,
> +	.driver = {
> +		.name	= "bq20z75-battery",
> +	},
> +};
> +
> +static int __init bq20z75_battery_init(void)
> +{
> +	int ret;
> +
> +	ret = i2c_add_driver(&bq20z75_battery_driver);
> +	if (ret)
> +		dev_err(&bq20z75_device->client->dev,
> +			"%s: i2c_add_driver failed\n", __func__);

This is essentially needless. The kernel will log the failure already.

> +
> +	return ret;
> +}
> +module_init(bq20z75_battery_init);
> +
> +static void __exit bq20z75_battery_exit(void)
> +{
> +	i2c_del_driver(&bq20z75_battery_driver);
> +}
> +module_exit(bq20z75_battery_exit);
> +
> +MODULE_AUTHOR("NVIDIA Graphics Pvt Ltd");
> +MODULE_DESCRIPTION("BQ20z75 battery monitor driver");
> +MODULE_LICENSE("GPL");


-- 
Jean Delvare
