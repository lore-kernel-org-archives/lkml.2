Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab0JFLmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 07:42:23 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:59637 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0JFLmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 07:42:20 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CAC61E9.6010806@cam.ac.uk>
Date: Wed, 06 Oct 2010 12:47:53 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100928 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: rklein@nvidia.com
CC: joe@perches.com, achew@nvidia.com, olof@lixom.net,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, ldewangan@nvidia.com
Subject: Re: [PATCH v3] iio: light: Adding driver for ISL29018 ALS
References: <1286318566-9782-1-git-send-email-rklein@nvidia.com>
In-Reply-To: <1286318566-9782-1-git-send-email-rklein@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/10 23:42, rklein@nvidia.com wrote:
> From: Rhyland Klein <rklein@nvidia.com>
Hi Ryland,

Thanks for doing the documentation. It is a good base to build up a
full description of these sensors' abi.  Once this is in place, I'll
document the other stuff the tsl2563 has as a separate patch.

Few minor changes requested below in the docs.

Also in driver, please add a range_available attribute to say what values
are possible for that parameter.  The IIO_CONST_ATTR macros make this nice
and easy to do (see comment inline).

So as far as I'm concerned, do the minor doc fixes + the range_available
attribute then send on to Greg KH (greg@kroah.com) with 

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Thanks,

Jonathan
> 
> Adding support for the ISL 29018 ambient light and proximity sensor.
> 
> Addressed comments from reviews by Jonathan Cameron and Joe Perches
>   * Removed some excess dbg prints that only printed function name
>   * Renamed some properties to make them more descriptive
>   * Added a property to list available adc resolutions
>   * Defined arrays for resolutions/ranges as static const
>   * change loops initialization to memset for extensibility.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
>  .../staging/iio/Documentation/sysfs-bus-iio-light  |   59 ++
>  drivers/staging/iio/light/Kconfig                  |   11 +
>  drivers/staging/iio/light/Makefile                 |    1 +
>  drivers/staging/iio/light/isl29018.c               |  563 ++++++++++++++++++++
>  4 files changed, 634 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/iio/Documentation/sysfs-bus-iio-light
>  create mode 100755 drivers/staging/iio/light/isl29018.c
> 
> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> new file mode 100644
> index 0000000..2595020
> --- /dev/null
> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> @@ -0,0 +1,59 @@
> +
> +What:		/sys/bus/iio/devices/device[n]/range
> +KernelVersion:	2.6.35
That's nto right... It's not going to merge until  2.6.37 given we are in
the tail end of 2.6.36 at the moment.  So switch all these to 2.6.37 except
I guess illuminance0 as that's been there a while, just not in the documentation.
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Hardware dependent ADC Full Scale Range used for some ambient
> +		light sensors in calculating lux.
> +
> +What:		/sys/bus/iio/devices/device[n]/adc_resolution
> +KernelVersion:	2.6.35
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Hardware dependent ADC resolution of the ambient light sensor
> +		used in calculating the lux.
> +
> +What:		/sys/bus/iio/devices/device[n]/adc_resolution_available
Feel free to supress more of the name string. So it might be.
/sys/.../device[n]/adc_resolution_available
That will mean fewer line breaks in the names.  Doesn't matter though.  I think
I'm going to post a general RFC asking for opinions on how to format these
compound named attributes in the doc files.  We keep muddling on, but it would
be nice to pin down a more detailed standard.
> +KernelVersion:	2.6.35
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Hardware dependent list of possible values supported for the
> +		adc_resolution of the given sensor.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0
I think illuminance0[_input|_raw] makes the below requirement more apparent.
In general I think we need to get some clarifications on appropriate formatting
of these sorts of parameter.
> +KernelVersion:	2.6.35
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This should return the calculated lux from the light sensor. If
> +		it comes back in SI units, it should also inclue _input else it
typo. inlue-> include.
> +		should include _raw to signify it is not in SI units.
> +
> +What:		/sys/bus/iio/devices/device[n]/
> +		proximity_on_chip_ambient_infrared_supression
> +KernelVersion:	2.6.35
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Hardware dependent mode for an ALS device to calculate the value
> +		in proximity mode. When this is enabled, then the device should
> +		use a infrared sensor reading to remove infrared noise from the
> +		proximity reading. If this is not enabled, the driver can still
> +		do this calculation manually by reading the infrared sensor
> +		value and doing the negation in sw.
> +
> +What:		/sys/bus/iio/devices/device[n]/proximity
> +KernelVersion:	2.6.35
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property is supported by proximity sensors and should be
> +		used to return the value of a reading by the sensor. If this
> +		value is returned in SI units, it should also include _input
> +		but if it is not, then it should include _raw.
> +
> +What:		/sys/bus/iio/devices/device[n]/intensity_infrared
> +KernelVersion:	2.6.35
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property is supported by sensors that have an infrared
> +		sensing mode. This value should be the output from a reading
> +		and if expressed in SI units, should include _input. If this
> +		value is not in SI units, then it should include _raw.
> diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
> index 80cb6e5..09113e4 100644
> --- a/drivers/staging/iio/light/Kconfig
> +++ b/drivers/staging/iio/light/Kconfig
> @@ -13,3 +13,14 @@ config SENSORS_TSL2563
>  	 This driver can also be built as a module.  If so, the module
>  	 will be called tsl2563.
>  
> +config SENSORS_ISL29018
> +        tristate "ISL 29018 light and proximity sensor"
> +        depends on I2C
> +        default n
> +        help
> +         If you say yes here you get support for ambient light sensing and
please spell out ir ->infrared (for consistency within this text)
> +         proximity ir sensing from Intersil ISL29018.
> +         This driver will provide the measurements of ambient light intensity
> +         in lux, proximity infrared sensing and normal infrared sensing.
> +         Data from sensor is accessible via sysfs.
> +
> diff --git a/drivers/staging/iio/light/Makefile b/drivers/staging/iio/light/Makefile
> index 30f3300..9142c0e 100644
> --- a/drivers/staging/iio/light/Makefile
> +++ b/drivers/staging/iio/light/Makefile
> @@ -3,3 +3,4 @@
>  #
>  
>  obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
> +obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
> diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
> new file mode 100755
> index 0000000..ef22a5c
> --- /dev/null
> +++ b/drivers/staging/iio/light/isl29018.c
> @@ -0,0 +1,563 @@
> +/*
> + * A iio driver for the light sensor ISL 29018.
> + *
> + * IIO driver for monitoring ambient light intensity in luxi, proximity
> + * sensing and infrared sensing.
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
> + * 51 Franklin Street, Fifth Floor, Boston, MA	02110-1301, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include "../iio.h"
> +
> +#define CONVERSION_TIME_MS		100
> +
> +#define ISL29018_REG_ADD_COMMAND1	0x00
> +#define COMMMAND1_OPMODE_SHIFT		5
> +#define COMMMAND1_OPMODE_MASK		(7 << COMMMAND1_OPMODE_SHIFT)
> +#define COMMMAND1_OPMODE_POWER_DOWN	0
> +#define COMMMAND1_OPMODE_ALS_ONCE	1
> +#define COMMMAND1_OPMODE_IR_ONCE	2
> +#define COMMMAND1_OPMODE_PROX_ONCE	3
> +
> +#define ISL29018_REG_ADD_COMMANDII	0x01
> +#define COMMANDII_RESOLUTION_SHIFT	2
> +#define COMMANDII_RESOLUTION_MASK	(0x3 << COMMANDII_RESOLUTION_SHIFT)
> +
> +#define COMMANDII_RANGE_SHIFT		0
> +#define COMMANDII_RANGE_MASK		(0x3 << COMMANDII_RANGE_SHIFT)
> +
> +#define COMMANDII_SCHEME_SHIFT		7
> +#define COMMANDII_SCHEME_MASK		(0x1 << COMMANDII_SCHEME_SHIFT)
> +
> +#define ISL29018_REG_ADD_DATA_LSB	0x02
> +#define ISL29018_REG_ADD_DATA_MSB	0x03
> +#define ISL29018_MAX_REGS		ISL29018_REG_ADD_DATA_MSB
> +
> +struct isl29018_chip {
> +	struct iio_dev		*indio_dev;
> +	struct i2c_client	*client;
> +	struct mutex		lock;
> +	unsigned int		range;
> +	unsigned int		adc_bit;
> +	int			prox_scheme;
> +	u8			reg_cache[ISL29018_MAX_REGS];
> +};
> +
> +static int isl29018_write_data(struct i2c_client *client, u8 reg,
> +			u8 val, u8 mask, u8 shift)
> +{
> +	u8 regval;
> +	int ret = 0;
> +	struct isl29018_chip *chip = i2c_get_clientdata(client);
> +
> +	regval = chip->reg_cache[reg];
> +	regval &= ~mask;
> +	regval |= val << shift;
> +
> +	ret = i2c_smbus_write_byte_data(client, reg, regval);
> +	if (ret) {
> +		dev_err(&client->dev, "Write to device fails status %x\n", ret);
> +		return ret;
> +	}
> +	chip->reg_cache[reg] = regval;
> +
> +	return 0;
> +}
> +
> +static int isl29018_set_range(struct i2c_client *client, unsigned long range,
> +		unsigned int *new_range)
> +{
> +	static const unsigned long supp_ranges[] = {1000, 4000, 16000, 64000};
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(supp_ranges); ++i) {
> +		if (range <= supp_ranges[i]) {
> +			*new_range = (unsigned int)supp_ranges[i];
> +			break;
> +		}
> +	}
> +
> +	if (i >= ARRAY_SIZE(supp_ranges))
> +		return -EINVAL;
> +
> +	return isl29018_write_data(client, ISL29018_REG_ADD_COMMANDII,
> +			i, COMMANDII_RANGE_MASK, COMMANDII_RANGE_SHIFT);
> +}
> +
> +static int isl29018_set_resolution(struct i2c_client *client,
> +			unsigned long adcbit, unsigned int *conf_adc_bit)
> +{
> +	static const unsigned long supp_adcbit[] = {16, 12, 8, 4};
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(supp_adcbit); ++i) {
> +		if (adcbit >= supp_adcbit[i]) {
> +			*conf_adc_bit = (unsigned int)supp_adcbit[i];
> +			break;
> +		}
> +	}
> +
> +	if (i >= ARRAY_SIZE(supp_adcbit))
> +		return -EINVAL;
> +
> +	return isl29018_write_data(client, ISL29018_REG_ADD_COMMANDII,
> +			i, COMMANDII_RESOLUTION_MASK,
> +			COMMANDII_RESOLUTION_SHIFT);
> +}
> +
> +static int isl29018_read_sensor_input(struct i2c_client *client, int mode)
> +{
> +	int status;
> +	int lsb;
> +	int msb;
> +
> +	/* Set mode */
> +	status = isl29018_write_data(client, ISL29018_REG_ADD_COMMAND1,
> +			mode, COMMMAND1_OPMODE_MASK, COMMMAND1_OPMODE_SHIFT);
> +	if (status) {
> +		dev_err(&client->dev, "Error in setting operating mode\n");
> +		return status;
> +	}
> +	msleep(CONVERSION_TIME_MS);
> +	lsb = i2c_smbus_read_byte_data(client, ISL29018_REG_ADD_DATA_LSB);
> +	if (lsb < 0) {
> +		dev_err(&client->dev, "Error in reading LSB DATA\n");
> +		return lsb;
> +	}
> +
> +	msb = i2c_smbus_read_byte_data(client, ISL29018_REG_ADD_DATA_MSB);
> +	if (msb < 0) {
> +		dev_err(&client->dev, "Error in reading MSB DATA\n");
> +		return msb;
> +	}
> +	dev_vdbg(&client->dev, "MSB 0x%x and LSB 0x%x\n", msb, lsb);
> +
> +	return (msb << 8) | lsb;
> +}
> +
> +static int isl29018_read_lux(struct i2c_client *client, int *lux)
> +{
> +	int lux_data;
> +	struct isl29018_chip *chip = i2c_get_clientdata(client);
> +
> +	lux_data = isl29018_read_sensor_input(client,
> +				COMMMAND1_OPMODE_ALS_ONCE);
> +
> +	if (lux_data < 0)
> +		return lux_data;
> +
> +	*lux = (lux_data * chip->range) >> chip->adc_bit;
> +
> +	return 0;
> +}
> +
> +static int isl29018_read_ir(struct i2c_client *client, int *ir)
> +{
> +	int ir_data;
> +
> +	ir_data = isl29018_read_sensor_input(client, COMMMAND1_OPMODE_IR_ONCE);
> +
> +	if (ir_data < 0)
> +		return ir_data;
> +
> +	*ir = ir_data;
> +
> +	return 0;
> +}
> +
> +static int isl29018_read_proximity_ir(struct i2c_client *client, int scheme,
> +		int *near_ir)
> +{
> +	int status;
> +	int prox_data = -1;
> +	int ir_data = -1;
> +
> +	/* Do proximity sensing with required scheme */
> +	status = isl29018_write_data(client, ISL29018_REG_ADD_COMMANDII,
> +			scheme, COMMANDII_SCHEME_MASK, COMMANDII_SCHEME_SHIFT);
> +	if (status) {
> +		dev_err(&client->dev, "Error in setting operating mode\n");
> +		return status;
> +	}
> +
> +	prox_data = isl29018_read_sensor_input(client,
> +					COMMMAND1_OPMODE_PROX_ONCE);
> +	if (prox_data < 0)
> +		return prox_data;
> +
> +	if (scheme == 1) {
> +		*near_ir = prox_data;
> +		return 0;
> +	}
> +
> +	ir_data = isl29018_read_sensor_input(client,
> +				COMMMAND1_OPMODE_IR_ONCE);
> +
> +	if (ir_data < 0)
> +		return ir_data;
> +
> +	if (prox_data >= ir_data)
> +		*near_ir = prox_data - ir_data;
> +	else
> +		*near_ir = 0;
> +
> +	return 0;
> +}
> +
> +static ssize_t get_sensor_data(struct device *dev, char *buf, int mode)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +	struct i2c_client *client = chip->client;
> +	int value = 0;
> +	int status;
> +
> +	mutex_lock(&chip->lock);
> +	switch (mode) {
> +	case COMMMAND1_OPMODE_PROX_ONCE:
> +		status = isl29018_read_proximity_ir(client,
> +				chip->prox_scheme, &value);
> +		break;
> +
> +	case COMMMAND1_OPMODE_ALS_ONCE:
> +		status = isl29018_read_lux(client, &value);
> +		break;
> +
> +	case COMMMAND1_OPMODE_IR_ONCE:
> +		status = isl29018_read_ir(client, &value);
> +		break;
> +
> +	default:
> +		dev_err(&client->dev, "Mode %d is not supported\n", mode);
> +		mutex_unlock(&chip->lock);
> +		return -EBUSY;
> +	}
> +	if (status < 0) {
> +		dev_err(&client->dev, "Error in Reading data");
> +		mutex_unlock(&chip->lock);
> +		return status;
> +	}
> +
> +	mutex_unlock(&chip->lock);
> +
> +	return sprintf(buf, "%d\n", value);
> +}
> +
> +/* Sysfs interface */
> +/* range */
> +static ssize_t show_range(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%u\n", chip->range);
> +}
> +
> +static ssize_t store_range(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +	struct i2c_client *client = chip->client;
> +	int status;
> +	unsigned long lval;
> +	unsigned int new_range;
> +
> +	if (strict_strtoul(buf, 10, &lval))
> +		return -EINVAL;
> +
> +	if (!(lval == 1000UL || lval == 4000UL ||
> +			lval == 16000UL || lval == 64000UL)) {
> +		dev_err(dev, "The range is not supported\n");
> +		return -EINVAL;
> +	}
With the hard threshold option (which is fine and my personal preference
- leave rounding up to userspace) we will need to know what is possible.
So please add, 

IIO_CONST_ATTR(range_available, "1000 4000 16000 64000"); 
> +
> +	mutex_lock(&chip->lock);
> +	status = isl29018_set_range(client, lval, &new_range);
> +	if (status < 0) {
> +		mutex_unlock(&chip->lock);
> +		dev_err(dev, "Error in setting max range\n");
> +		return status;
> +	}
> +	chip->range = new_range;
> +	mutex_unlock(&chip->lock);
> +
> +	return count;
> +}
> +
> +/* resolution */
> +static ssize_t show_resolution_available(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
Could we have spaces rather than new lines?  That will match
the other drivers in tree. (though in theory sysfs attributes
should never care as long as their is white space of some type).

Doesn't matter, but you could use the convenient macro for const
string attributes and drop this function.
IIO_CONST_ATTR(resolution_available, "4 8 12 16");
> +	return sprintf(buf, "4\n8\n12\n16\n");
> +}
> +
> +static ssize_t show_resolution(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%u\n", chip->adc_bit);
> +}
> +
> +static ssize_t store_resolution(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +	struct i2c_client *client = chip->client;
> +	int status;
> +	unsigned long lval;
> +	unsigned int new_adc_bit;
> +
> +	if (strict_strtoul(buf, 10, &lval))
> +		return -EINVAL;
> +	if (!(lval == 4 || lval == 8 || lval == 12 || lval == 16)) {
> +		dev_err(dev, "The resolution is not supported\n");
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&chip->lock);
> +	status = isl29018_set_resolution(client, lval, &new_adc_bit);
> +	if (status < 0) {
> +		mutex_unlock(&chip->lock);
> +		dev_err(dev, "Error in setting resolution\n");
> +		return status;
> +	}
> +	chip->adc_bit = new_adc_bit;
> +	mutex_unlock(&chip->lock);
> +
> +	return count;
> +}
> +

If you are respining the patch for whatever reason, it might
be good (for future readers of the code) to rename these scheme
functions to something more obvious or add some comments here
to say what they are doing.

> +/* proximity scheme */
> +static ssize_t show_prox_scheme(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%d\n", chip->prox_scheme);
> +}
> +
> +static ssize_t store_prox_scheme(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +	unsigned long lval;
> +
> +	if (strict_strtoul(buf, 10, &lval))
> +		return -EINVAL;
> +	if (!(lval == 0UL || lval == 1UL)) {
> +		dev_err(dev, "The scheme is not supported\n");
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&chip->lock);
> +	chip->prox_scheme = (int)lval;
> +	mutex_unlock(&chip->lock);
> +
> +	return count;
> +}
> +
> +/* Read lux */
> +static ssize_t show_lux(struct device *dev,
> +		struct device_attribute *devattr, char *buf)
> +{
> +	return get_sensor_data(dev, buf, COMMMAND1_OPMODE_ALS_ONCE);
> +}
> +
> +/* Read ir */
> +static ssize_t show_ir(struct device *dev,
> +		struct device_attribute *devattr, char *buf)
> +{
> +	return get_sensor_data(dev, buf, COMMMAND1_OPMODE_IR_ONCE);
> +}
> +
> +/* Read nearest ir */
> +static ssize_t show_proxim_ir(struct device *dev,
> +		struct device_attribute *devattr, char *buf)
> +{
> +	return get_sensor_data(dev, buf, COMMMAND1_OPMODE_PROX_ONCE);
> +}
> +
> +/* Read name */
> +static ssize_t show_name(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct isl29018_chip *chip = indio_dev->dev_data;
> +
> +	return sprintf(buf, "%s\n", chip->client->name);
> +}
> +
> +static IIO_DEVICE_ATTR(range, S_IRUGO | S_IWUSR, show_range, store_range, 0);
> +static IIO_DEVICE_ATTR(adc_resolution_available, S_IRUGO,
> +					show_resolution_available, NULL, 0);
> +static IIO_DEVICE_ATTR(adc_resolution, S_IRUGO | S_IWUSR,
> +					show_resolution, store_resolution, 0);
> +static IIO_DEVICE_ATTR(proximity_on_chip_ambient_infrared_supression,
> +					S_IRUGO | S_IWUSR, show_prox_scheme,
> +					store_prox_scheme, 0);
> +static IIO_DEVICE_ATTR(illuminance0_input, S_IRUGO, show_lux, NULL, 0);
> +static IIO_DEVICE_ATTR(intensity_infrared_raw, S_IRUGO, show_ir, NULL, 0);
> +static IIO_DEVICE_ATTR(proximity_raw, S_IRUGO, show_proxim_ir, NULL, 0);
> +static IIO_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, 0);
> +
> +#define ISL29018_DEV_ATTR(name) (&iio_dev_attr_##name.dev_attr.attr)
> +static struct attribute *isl29018_attributes[] = {
> +	ISL29018_DEV_ATTR(name),
> +	ISL29018_DEV_ATTR(range),
> +	ISL29018_DEV_ATTR(adc_resolution),
> +	ISL29018_DEV_ATTR(adc_resolution_available),
> +	ISL29018_DEV_ATTR(proximity_on_chip_ambient_infrared_supression),
> +	ISL29018_DEV_ATTR(illuminance0_input),
> +	ISL29018_DEV_ATTR(intensity_infrared_raw),
> +	ISL29018_DEV_ATTR(proximity_raw),
> +	NULL
> +};
> +
> +static const struct attribute_group isl29108_group = {
> +	.attrs = isl29018_attributes,
> +};
> +
> +static int isl29018_chip_init(struct i2c_client *client)
> +{
> +	struct isl29018_chip *chip = i2c_get_clientdata(client);
> +	int status;
> +	int i;
> +	int new_adc_bit;
> +	unsigned int new_range;
> +
> +	memset((void *)chip->reg_cache, 0, ARRAY_SIZE(chip->reg_cache));
> +
> +	/* set defaults */
> +	status = isl29018_set_range(client, chip->range, &new_range);
> +	if (status < 0) {
> +		dev_err(&client->dev, "Init of isl29018 fails\n");
> +		return status;
> +	}
> +
> +	status = isl29018_set_resolution(client, chip->adc_bit,
> +						&new_adc_bit);
> +
> +	return 0;
> +}
> +
> +static int __devinit isl29018_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct isl29018_chip *chip;
> +	int err;
> +
> +	chip = kzalloc(sizeof(struct isl29018_chip), GFP_KERNEL);
> +	if (!chip) {
> +		dev_err(&client->dev, "Memory allocation fails\n");
> +		err = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	i2c_set_clientdata(client, chip);
> +	chip->client = client;
> +
> +	mutex_init(&chip->lock);
> +
> +	chip->range = 1000;
> +	chip->adc_bit = 16;
> +
> +	err = isl29018_chip_init(client);
> +	if (err)
> +		goto exit_free;
> +
> +	chip->indio_dev = iio_allocate_device();
> +	if (!chip->indio_dev) {
> +		dev_err(&client->dev, "iio allocation fails\n");
> +		goto exit_free;
> +	}
> +	chip->indio_dev->attrs = &isl29108_group;
> +	chip->indio_dev->dev.parent = &client->dev;
> +	chip->indio_dev->dev_data = (void *)(chip);
> +	chip->indio_dev->driver_module = THIS_MODULE;
> +	chip->indio_dev->modes = INDIO_DIRECT_MODE;
> +	err = iio_device_register(chip->indio_dev);
> +	if (err) {
> +		dev_err(&client->dev, "iio registration fails\n");
> +		goto exit_iio_free;
> +	}
> +
> +	return 0;
> +exit_iio_free:
> +	iio_free_device(chip->indio_dev);
> +exit_free:
> +	kfree(chip);
> +exit:
> +	return err;
> +}
> +
> +static int __devexit isl29018_remove(struct i2c_client *client)
> +{
> +	struct isl29018_chip *chip = i2c_get_clientdata(client);
> +
> +	dev_dbg(&client->dev, "%s()\n", __func__);
> +	iio_device_unregister(chip->indio_dev);
> +	kfree(chip);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id isl29018_id[] = {
> +	{"isl29018", 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, isl29018_id);
> +
> +static struct i2c_driver isl29018_driver = {
> +	.class	= I2C_CLASS_HWMON,
> +	.driver	 = {
> +			.name = "isl29018",
> +			.owner = THIS_MODULE,
> +		    },
> +	.probe	 = isl29018_probe,
> +	.remove	 = __devexit_p(isl29018_remove),
> +	.id_table = isl29018_id,
> +};
> +
> +static int __init isl29018_init(void)
> +{
> +	return i2c_add_driver(&isl29018_driver);
> +}
> +
> +static void __exit isl29018_exit(void)
> +{
> +	i2c_del_driver(&isl29018_driver);
> +}
> +
> +module_init(isl29018_init);
> +module_exit(isl29018_exit);
> +
> +MODULE_DESCRIPTION("ISL29018 Ambient Light Sensor driver");
> +MODULE_LICENSE("GPL");

