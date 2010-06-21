Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0FUJcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 05:32:19 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:56013 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab0FUJcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 05:32:12 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C1F30F8.70807@jic23.retrosnub.co.uk>
Date: Mon, 21 Jun 2010 10:29:28 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>, Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <sameo@linux.intel.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] hwmon: Driver for SMM665 Six-Channel Active DC
 Output Controller/Monitor
References: <1277061575-13831-1-git-send-email-guenter.roeck@ericsson.com> <1277061575-13831-2-git-send-email-guenter.roeck@ericsson.com>
In-Reply-To: <1277061575-13831-2-git-send-email-guenter.roeck@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/10 20:19, Guenter Roeck wrote:
> This driver adds support for the monitoring features of the Summit
> Microelectronics SMM665 Six-Channel Active DC Output Controller/Monitor.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>

Hi Guenter,

Few more comments below.  Please don't eat errors when there
is no reason to do so.

Also I would hold this driver for a few days to see if anyone
has comments on the critical values attributes.  It would be
good to see them supported as well (afterall you have pretty
much all the code here anyway!)

Jonathan
> ---
>  drivers/hwmon/Kconfig  |   15 +
>  drivers/hwmon/Makefile |    1 +
>  drivers/hwmon/smm665.c |  681 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 697 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/smm665.c
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index e19cf8e..c45c17e 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -739,6 +739,21 @@ config SENSORS_SIS5595
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called sis5595.
>  
> +config SENSORS_SMM665
> +	tristate "Summit Microelectronics SMM665"
> +	depends on I2C && EXPERIMENTAL
> +	default n
> +	help
> +	  If you say yes here you get support for the hardware monitoring
> +	  features of the Summit Microelectronics SMM665/SMM665B Six-Channel
> +	  Active DC Output Controller / Monitor.
> +
> +	  Other supported chips are SMM465, SMM665C, SMM764, and SMM766.
> +	  Support for those chips is untested.
> +
> +	  This driver can also be built as a module. If so, the module will
> +	  be called smm665.
> +
>  config SENSORS_DME1737
>  	tristate "SMSC DME1737, SCH311x and compatibles"
>  	depends on I2C && EXPERIMENTAL
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 2138ceb..55b0940 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -86,6 +86,7 @@ obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
>  obj-$(CONFIG_SENSORS_S3C)	+= s3c-hwmon.o
>  obj-$(CONFIG_SENSORS_SHT15)	+= sht15.o
>  obj-$(CONFIG_SENSORS_SIS5595)	+= sis5595.o
> +obj-$(CONFIG_SENSORS_SMM665)	+= smm665.o
>  obj-$(CONFIG_SENSORS_SMSC47B397)+= smsc47b397.o
>  obj-$(CONFIG_SENSORS_SMSC47M1)	+= smsc47m1.o
>  obj-$(CONFIG_SENSORS_SMSC47M192)+= smsc47m192.o
> diff --git a/drivers/hwmon/smm665.c b/drivers/hwmon/smm665.c
> new file mode 100644
> index 0000000..b4e7c8f
> --- /dev/null
> +++ b/drivers/hwmon/smm665.c
> @@ -0,0 +1,681 @@
> +/*
> + * Driver for SMM665 Power Controller / Monitor
> + *
> + * Copyright (C) 2010 Ericsson AB.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This driver should also work for SMM465, SMM764, and SMM766, but is untested
> + * for those chips. Only monitoring functionality is implemented.
> + *
> + * Datasheets:
> + * http://www.summitmicro.com/prod_select/summary/SMM665/SMM665B_2089_20.pdf
> + * http://www.summitmicro.com/prod_select/summary/SMM766B/SMM766B_2122.pdf
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/delay.h>
> +
> +/* Internal reference voltage (VREF, x 1000 */
> +#define SMM665_VREF_ADC_X1000	1250
> +
> +/* module parameters */
> +static int vref = SMM665_VREF_ADC_X1000;
> +module_param(vref, int, 0);
> +MODULE_PARM_DESC(vref, "Reference voltage in mV");
> +
> +enum chips { smm465, smm665, smm665c, smm764, smm766 };
> +
> +/*
> + * ADC channel addresses
> + */
> +#define	SMM665_MISC16_ADC_DATA_A	0x00
> +#define	SMM665_MISC16_ADC_DATA_B	0x01
> +#define	SMM665_MISC16_ADC_DATA_C	0x02
> +#define	SMM665_MISC16_ADC_DATA_D	0x03
> +#define	SMM665_MISC16_ADC_DATA_E	0x04
> +#define	SMM665_MISC16_ADC_DATA_F	0x05
> +#define	SMM665_MISC16_ADC_DATA_VDD	0x06
> +#define	SMM665_MISC16_ADC_DATA_12V	0x07
> +#define	SMM665_MISC16_ADC_DATA_INT_TEMP	0x08
> +#define	SMM665_MISC16_ADC_DATA_AIN1	0x09
> +#define	SMM665_MISC16_ADC_DATA_AIN2	0x0a
> +
> +/*
> + * Command registers
> + */
> +#define	SMM665_MISC8_CMD_STS		0x80
> +#define	SMM665_MISC8_STATUS1		0x81
> +#define	SMM665_MISC8_STATUSS2		0x82
> +#define	SMM665_MISC8_IO_POLARITY	0x83
> +#define	SMM665_MISC8_PUP_POLARITY	0x84
> +#define	SMM665_MISC8_ADOC_STATUS1	0x85
> +#define	SMM665_MISC8_ADOC_STATUS2	0x86
> +#define	SMM665_MISC8_WRITE_PROT		0x87
> +#define	SMM665_MISC8_STS_TRACK		0x88
> +
> +/*
> + * Configuration registers and register groups
> + */
> +#define SMM665_ADOC_ENABLE		0x0d
> +#define SMM665_LIMIT_BASE		0x80	/* First limit register */
> +
> +/*
> + * Limit register bit masks
> + */
> +#define SMM665_TRIGGER_RST		0x8000
> +#define SMM665_TRIGGER_HEALTHY		0x4000
> +#define SMM665_TRIGGER_POWEROFF		0x2000
> +#define SMM665_TRIGGER_SHUTDOWN		0x1000
> +#define SMM665_ADC_MASK			0x03ff
> +
> +#define smm665_is_critical(lim)	((lim) & (SMM665_TRIGGER_RST \
> +					| SMM665_TRIGGER_POWEROFF \
> +					| SMM665_TRIGGER_SHUTDOWN))
> +/*
> + * Fault register bit definitions
> + * Values are merged from status registers 1/2,
> + * with status register 1 providing the upper 8 bits.
> + */
> +#define SMM665_FAULT_A		0x0001
> +#define SMM665_FAULT_B		0x0002
> +#define SMM665_FAULT_C		0x0004
> +#define SMM665_FAULT_D		0x0008
> +#define SMM665_FAULT_E		0x0010
> +#define SMM665_FAULT_F		0x0020
> +#define SMM665_FAULT_VDD	0x0040
> +#define SMM665_FAULT_12V	0x0080
> +#define SMM665_FAULT_TEMP	0x0100
> +#define SMM665_FAULT_AIN1	0x0200
> +#define SMM665_FAULT_AIN2	0x0400
> +
> +/*
> + * I2C Register addresses
> + *
> + * The configuration register needs to be the configured base register.
> + * The command/status register address is derived from it.
> + */
> +#define SMM665_REGMASK		0x78
> +#define SMM665_CMDREG_BASE	0x48
> +#define SMM665_CONFREG_BASE	0x50
> +
> +/*
> + *  Equations given by chip manufacturer to calculate voltage/temperature values
> + *  vref = Reference voltage on VREF_ADC pin (module parameter)
> + *  adc  = 10bit ADC value read back from registers
> + */
> +
> +/* Voltage A-F and VDD */
> +#define SMM665_VMON_ADC_TO_VOLTS(adc)  ((adc) * vref / 256)
> +
> +/* Voltage 12VIN */
> +#define SMM665_12VIN_ADC_TO_VOLTS(adc) ((adc) * vref * 3 / 256)
> +
> +/* Voltage AIN1, AIN2 */
> +#define SMM665_AIN_ADC_TO_VOLTS(adc)   ((adc) * vref / 512)
> +
> +/* Temp Sensor */
> +#define SMM665_TEMP_ADC_TO_CELSIUS(adc) ((adc) <= 511) ?		   \
> +					 ((int)(adc) * 1000 / 4) :	   \
> +					 (((int)(adc) - 0x400) * 1000 / 4)
> +
> +#define SMM665_NUM_ADC		11
> +
> +/*
> + * Chip dependent ADC conversion time, in uS
> + */
> +#define SMM665_ADC_WAIT_SMM665	70
> +#define SMM665_ADC_WAIT_SMM766	185
> +
> +struct smm665_data {
> +	enum chips type;
> +	int conversion_time;		/* ADC conversion time */
> +	struct device *hwmon_dev;
> +	struct mutex update_lock;
> +	bool valid;
> +	unsigned long last_updated;	/* in jiffies */
> +	u16 adc[SMM665_NUM_ADC];	/* adc values (raw) */
> +	u16 faults;			/* fault status */
> +	/* The following values are in mV */
> +	int critical_under_limit[SMM665_NUM_ADC];
> +	int alarm_under_limit[SMM665_NUM_ADC];
> +	int critical_over_limit[SMM665_NUM_ADC];
> +	int alarm_over_limit[SMM665_NUM_ADC];
> +	struct i2c_client *cmdreg;
> +};
> +
> +/*
> + * smm665_read16()
> + *
> + * Read 16 bit value from <reg>, <reg+1>. Upper 8 bits are in <reg>.
> + */
> +static int smm665_read16(struct i2c_client *client, int reg)
> +{
> +	int rv, val;
> +
> +	rv = i2c_smbus_read_byte_data(client, reg);
> +	if (rv < 0)
> +		return rv;
> +	val = rv << 8;
> +	rv = i2c_smbus_read_byte_data(client, reg + 1);
> +	if (rv < 0)
> +		return rv;
> +	val |= rv;
> +	return val;
> +}
> +
> +/*
> + * Read adc value.
> + */
> +static int smm665_read_adc(struct smm665_data *data, int adc)
> +{
> +	struct i2c_client *client = data->cmdreg;
> +	int rv;
> +	int radc;
> +
> +	/*
> +	 * Algorithm for reading ADC, per SMM665 datasheet
> +	 *
> +	 *  {[S][addr][W][Ack]} {[offset][Ack]} {[S][addr][R][Nack]}
> +	 * [wait conversion time]
> +	 *  {[S][addr][R][Ack]} {[datahi][Ack]} {[datalo][Ack][P]}
> +	 *
> +	 * To implement the first part of this exchange,
> +	 * do a full read transaction and expect a failure/Nack.
> +	 * This sets up the address pointer on the SMM665
> +	 * and starts the ADC conversion.
> +	 * Then do a two-byte read transaction.
> +	 */
> +	rv = i2c_smbus_read_byte_data(client, adc << 3);
> +	if (rv != -ENXIO) {
> +		/*
> +		 * We expect ENXIO to reflect NACK
> +		 * (per Documentation/i2c/fault-codes).
> +		 * Everything else is an error.
> +		 */
> +		dev_dbg(&client->dev,
> +			"Unexpected return code %d when setting ADC index", rv);
Better to pass on the return code rather than eat it like this.
> +		return -1;
> +	}
> +
> +	udelay(data->conversion_time);
> +
> +	/*
> +	 * Now read two bytes.
> +	 *
> +	 * Neither i2c_smbus_read_byte() nor
> +	 * i2c_smbus_read_block_data() worked here,
> +	 * so use i2c_smbus_read_word_data() instead.
> +	 * We could also try to use i2c_master_recv(),
> +	 * but that is not always supported.
> +	 */
> +	rv = i2c_smbus_read_word_data(client, 0);
> +	if (rv < 0) {
> +		dev_dbg(&client->dev, "Failed to read ADC value: error %d", rv);
> +		return -1;
Again, don't eat return codes.  Pass them on as far as you can
> +	}
> +	/*
> +	 * Validate/verify readback adc channel (in bit 11..14).
> +	 * High byte is in lower 8 bit of rv, so only shift by 3.
> +	 */
> +	radc = (rv >> 3) & 0x0f;
> +	if (radc != adc) {
> +		dev_dbg(&client->dev, "Unexpected RADC: Expected %d got %d",
> +			adc, radc);
Not quite sure what the right error code here would be...
> +		return -1;
> +	}
> +	/*
> +	 * Chip replies with H/L, while SMBus expects L/H.
> +	 * Thus, byte order is reversed, and we have to swap
> +	 * the result.
> +	 */
> +	rv = swab16(rv) & SMM665_ADC_MASK;
> +
> +	return rv;
> +}
> +
> +static struct smm665_data *smm665_update_device(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct smm665_data *data = i2c_get_clientdata(client);
> +
> +	mutex_lock(&data->update_lock);
> +
> +	if (time_after(jiffies, data->last_updated + HZ) || !data->valid) {
> +		int i, faults;
> +
> +		/*
> +		 * read status registers
> +		 */
> +		faults = smm665_read16(client, SMM665_MISC8_STATUS1);
> +		if (unlikely(faults < 0))
> +			data->faults = 0;
> +		else
> +			data->faults = faults;
> +
> +		/* Read adc registers */
> +		for (i = 0; i < SMM665_NUM_ADC; i++) {
> +			int val = smm665_read_adc(data, i);
> +			if (unlikely(val < 0))
So this is going to keep hammering a device that has already reported
an error. Ideally this would drop out and pass the error code all
the way up to user space.
> +				data->adc[i] = 0;
> +			else
> +				data->adc[i] = val;
> +		}
> +
> +		data->last_updated = jiffies;
> +		data->valid = 1;
> +	}
> +
> +	mutex_unlock(&data->update_lock);
> +
> +	return data;
> +}
> +
> +/* Return converted value from given adc */
> +static int smm665_convert(u16 adcval, int index)
> +{
> +	int val = 0;
> +
> +	switch (index) {
> +	case SMM665_MISC16_ADC_DATA_12V:
> +		val = SMM665_12VIN_ADC_TO_VOLTS(adcval & SMM665_ADC_MASK);
> +		break;
> +
> +	case SMM665_MISC16_ADC_DATA_VDD:
> +	case SMM665_MISC16_ADC_DATA_A:
> +	case SMM665_MISC16_ADC_DATA_B:
> +	case SMM665_MISC16_ADC_DATA_C:
> +	case SMM665_MISC16_ADC_DATA_D:
> +	case SMM665_MISC16_ADC_DATA_E:
> +	case SMM665_MISC16_ADC_DATA_F:
> +		val = SMM665_VMON_ADC_TO_VOLTS(adcval & SMM665_ADC_MASK);
> +		break;
> +
> +	case SMM665_MISC16_ADC_DATA_AIN1:
> +	case SMM665_MISC16_ADC_DATA_AIN2:
> +		val = SMM665_AIN_ADC_TO_VOLTS(adcval & SMM665_ADC_MASK);
> +		break;
> +
> +	case SMM665_MISC16_ADC_DATA_INT_TEMP:
> +		val = SMM665_TEMP_ADC_TO_CELSIUS(adcval & SMM665_ADC_MASK);
> +		break;
> +
> +	default:
> +		/* If we get here, the developer messed up */
> +		WARN_ON_ONCE(1);
> +		break;
> +	}
> +
> +	return val;
> +}
> +
> +/* Return converted value from given adc */
> +static int smm665_get_input(struct device *dev, int adc)
> +{
> +	struct smm665_data *data = smm665_update_device(dev);
> +
> +	return smm665_convert(data->adc[adc], adc);
> +}
> +
> +static int smm665_get_min(struct device *dev, int index)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct smm665_data *data = i2c_get_clientdata(client);
> +
> +	return data->alarm_under_limit[index];
> +}
> +
> +static int smm665_get_max(struct device *dev, int index)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct smm665_data *data = i2c_get_clientdata(client);
> +
> +	return data->alarm_over_limit[index];
> +}
> +
> +static int smm665_get_crit(struct device *dev, int index)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct smm665_data *data = i2c_get_clientdata(client);
> +
> +	return data->critical_over_limit[index];
> +}
> +
> +static int smm665_get_fault(struct device *dev, int index)
> +{
> +	struct smm665_data *data = smm665_update_device(dev);
> +
> +	if (data->faults & (1 << index))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +#define SMM665_SHOW(what) \
> +  static ssize_t smm665_show_##what(struct device *dev, \
> +				    struct device_attribute *da, char *buf) \
> +{ \
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(da); \
> +	const int val = smm665_get_##what(dev, attr->index); \
> +	return snprintf(buf, PAGE_SIZE, "%d\n", val); \
> +}
> +
> +SMM665_SHOW(input);
> +SMM665_SHOW(min);
> +SMM665_SHOW(max);
> +SMM665_SHOW(crit);
> +SMM665_SHOW(fault);
> +
> +/* These macros are used below in constructing device attribute objects
> + * for use with sysfs_create_group() to make a sysfs device file
> + * for each register.
> + */
> +
> +#define SMM665_ATTR(name, type, cmd_idx) \
> +	static SENSOR_DEVICE_ATTR(name##_##type, S_IRUGO, \
> +				  smm665_show_##type, NULL, cmd_idx)
> +
> +/* Construct a sensor_device_attribute structure for each register */
> +
> +/* Input voltages */
> +SMM665_ATTR(in1, input, SMM665_MISC16_ADC_DATA_12V);
> +SMM665_ATTR(in2, input, SMM665_MISC16_ADC_DATA_VDD);
> +SMM665_ATTR(in3, input, SMM665_MISC16_ADC_DATA_A);
> +SMM665_ATTR(in4, input, SMM665_MISC16_ADC_DATA_B);
> +SMM665_ATTR(in5, input, SMM665_MISC16_ADC_DATA_C);
> +SMM665_ATTR(in6, input, SMM665_MISC16_ADC_DATA_D);
> +SMM665_ATTR(in7, input, SMM665_MISC16_ADC_DATA_E);
> +SMM665_ATTR(in8, input, SMM665_MISC16_ADC_DATA_F);
> +SMM665_ATTR(in9, input, SMM665_MISC16_ADC_DATA_AIN1);
> +SMM665_ATTR(in10, input, SMM665_MISC16_ADC_DATA_AIN2);
> +
> +/* Input voltages min */
> +SMM665_ATTR(in1, min, SMM665_MISC16_ADC_DATA_12V);
> +SMM665_ATTR(in2, min, SMM665_MISC16_ADC_DATA_VDD);
> +SMM665_ATTR(in3, min, SMM665_MISC16_ADC_DATA_A);
> +SMM665_ATTR(in4, min, SMM665_MISC16_ADC_DATA_B);
> +SMM665_ATTR(in5, min, SMM665_MISC16_ADC_DATA_C);
> +SMM665_ATTR(in6, min, SMM665_MISC16_ADC_DATA_D);
> +SMM665_ATTR(in7, min, SMM665_MISC16_ADC_DATA_E);
> +SMM665_ATTR(in8, min, SMM665_MISC16_ADC_DATA_F);
> +SMM665_ATTR(in9, min, SMM665_MISC16_ADC_DATA_AIN1);
> +SMM665_ATTR(in10, min, SMM665_MISC16_ADC_DATA_AIN2);
> +
> +/* Input voltages max */
> +SMM665_ATTR(in1, max, SMM665_MISC16_ADC_DATA_12V);
> +SMM665_ATTR(in2, max, SMM665_MISC16_ADC_DATA_VDD);
> +SMM665_ATTR(in3, max, SMM665_MISC16_ADC_DATA_A);
> +SMM665_ATTR(in4, max, SMM665_MISC16_ADC_DATA_B);
> +SMM665_ATTR(in5, max, SMM665_MISC16_ADC_DATA_C);
> +SMM665_ATTR(in6, max, SMM665_MISC16_ADC_DATA_D);
> +SMM665_ATTR(in7, max, SMM665_MISC16_ADC_DATA_E);
> +SMM665_ATTR(in8, max, SMM665_MISC16_ADC_DATA_F);
> +SMM665_ATTR(in9, max, SMM665_MISC16_ADC_DATA_AIN1);
> +SMM665_ATTR(in10, max, SMM665_MISC16_ADC_DATA_AIN2);
> +
> +/* Faults */
> +SMM665_ATTR(in1, fault, SMM665_FAULT_12V);
> +SMM665_ATTR(in2, fault, SMM665_FAULT_VDD);
> +SMM665_ATTR(in3, fault, SMM665_FAULT_A);
> +SMM665_ATTR(in4, fault, SMM665_FAULT_B);
> +SMM665_ATTR(in5, fault, SMM665_FAULT_C);
> +SMM665_ATTR(in6, fault, SMM665_FAULT_D);
> +SMM665_ATTR(in7, fault, SMM665_FAULT_E);
> +SMM665_ATTR(in8, fault, SMM665_FAULT_F);
> +SMM665_ATTR(in9, fault, SMM665_FAULT_AIN1);
> +SMM665_ATTR(in10, fault, SMM665_FAULT_AIN2);
> +
> +/* Temperature */
> +SMM665_ATTR(temp1, input, SMM665_MISC16_ADC_DATA_INT_TEMP);
> +SMM665_ATTR(temp1, min, SMM665_MISC16_ADC_DATA_INT_TEMP);
> +SMM665_ATTR(temp1, max, SMM665_MISC16_ADC_DATA_INT_TEMP);

Why have critical here and nowhere else?
> +SMM665_ATTR(temp1, crit, SMM665_MISC16_ADC_DATA_INT_TEMP);
> +SMM665_ATTR(temp1, fault, SMM665_FAULT_TEMP);
> +
> +/*
> + * Finally, construct an array of pointers to members of the above objects,
> + * as required for sysfs_create_group()
> + */
> +static struct attribute *smm665_attributes[] = {
> +	&sensor_dev_attr_in1_input.dev_attr.attr,
> +	&sensor_dev_attr_in1_min.dev_attr.attr,
> +	&sensor_dev_attr_in1_max.dev_attr.attr,
> +	&sensor_dev_attr_in1_fault.dev_attr.attr,
> +
> +	&sensor_dev_attr_in2_input.dev_attr.attr,
> +	&sensor_dev_attr_in2_min.dev_attr.attr,
> +	&sensor_dev_attr_in2_max.dev_attr.attr,
> +	&sensor_dev_attr_in2_fault.dev_attr.attr,
> +
> +	&sensor_dev_attr_in3_input.dev_attr.attr,
> +	&sensor_dev_attr_in3_min.dev_attr.attr,
> +	&sensor_dev_attr_in3_max.dev_attr.attr,
> +	&sensor_dev_attr_in3_fault.dev_attr.attr,
> +
> +	&sensor_dev_attr_in4_input.dev_attr.attr,
> +	&sensor_dev_attr_in4_min.dev_attr.attr,
> +	&sensor_dev_attr_in4_max.dev_attr.attr,
> +	&sensor_dev_attr_in4_fault.dev_attr.attr,
> +
> +	&sensor_dev_attr_in5_input.dev_attr.attr,
> +	&sensor_dev_attr_in5_min.dev_attr.attr,
> +	&sensor_dev_attr_in5_max.dev_attr.attr,
> +	&sensor_dev_attr_in5_fault.dev_attr.attr,
> +
> +	&sensor_dev_attr_in6_input.dev_attr.attr,
> +	&sensor_dev_attr_in6_min.dev_attr.attr,
> +	&sensor_dev_attr_in6_max.dev_attr.attr,
> +	&sensor_dev_attr_in6_fault.dev_attr.attr,
> +
> +	&sensor_dev_attr_in7_input.dev_attr.attr,
> +	&sensor_dev_attr_in7_min.dev_attr.attr,
> +	&sensor_dev_attr_in7_max.dev_attr.attr,
> +	&sensor_dev_attr_in7_fault.dev_attr.attr,
> +
> +	&sensor_dev_attr_in8_input.dev_attr.attr,
> +	&sensor_dev_attr_in8_min.dev_attr.attr,
> +	&sensor_dev_attr_in8_max.dev_attr.attr,
> +	&sensor_dev_attr_in8_fault.dev_attr.attr,
> +
> +	&sensor_dev_attr_in9_input.dev_attr.attr,
> +	&sensor_dev_attr_in9_min.dev_attr.attr,
> +	&sensor_dev_attr_in9_max.dev_attr.attr,
> +	&sensor_dev_attr_in9_fault.dev_attr.attr,
> +
> +	&sensor_dev_attr_in10_input.dev_attr.attr,
> +	&sensor_dev_attr_in10_min.dev_attr.attr,
> +	&sensor_dev_attr_in10_max.dev_attr.attr,
> +	&sensor_dev_attr_in10_fault.dev_attr.attr,
> +
> +	&sensor_dev_attr_temp1_input.dev_attr.attr,
> +	&sensor_dev_attr_temp1_min.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max.dev_attr.attr,
> +	&sensor_dev_attr_temp1_crit.dev_attr.attr,
> +	&sensor_dev_attr_temp1_fault.dev_attr.attr,
> +
> +	NULL,
> +};
> +
> +static const struct attribute_group smm665_group = {
> +	.attrs = smm665_attributes,
> +};
> +
> +static int smm665_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct i2c_adapter *adapter = client->adapter;
> +	struct smm665_data *data;
> +	int i, ret;
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA
> +				     | I2C_FUNC_SMBUS_WORD_DATA))
> +		return -ENODEV;
> +
> +	if (i2c_smbus_read_byte_data(client, SMM665_ADOC_ENABLE) < 0)
> +		return -ENODEV;
> +
> +	ret = -ENOMEM;
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		goto out_kzalloc;
> +
> +	i2c_set_clientdata(client, data);
> +	mutex_init(&data->update_lock);
> +
> +	data->type = id->driver_data;
> +	data->cmdreg = i2c_new_dummy(adapter, (client->addr & ~SMM665_REGMASK)
> +				     | SMM665_CMDREG_BASE);
> +	if (!data->cmdreg)
> +		goto out_new_dummy;
> +
> +	switch (data->type) {
> +	case smm465:
> +	case smm665:
> +		data->conversion_time = SMM665_ADC_WAIT_SMM665;
> +		break;
> +	case smm665c:
> +	case smm764:
> +	case smm766:
> +		data->conversion_time = SMM665_ADC_WAIT_SMM766;
> +		break;
> +	}
> +
> +	ret = -ENODEV;
> +	if (i2c_smbus_read_byte_data(data->cmdreg, SMM665_MISC8_CMD_STS) < 0)
> +		goto out_sysfs_create_group;
> +
> +	/*
> +	 * Read limits.
> +	 *
> +	 * Limit registers start with register SMM665_LIMIT_BASE.
> +	 * Each channel uses 8 registers, providing four limit values
> +	 * per channel. Each limit value requires two registers, with the
> +	 * high byte in the first register and the low byte in the second
> +	 * register. The first two limits are under limit values, followed
> +	 * by two over limit values.
> +	 *
> +	 * Limit register order matches the ADC register order, so we use
> +	 * ADC register defines throughout the code to index limit registers.
> +	 *
> +	 * We save the first retrieved value both as "critical" and "alarm"
> +	 * value. The second value overwrites either the critical or the
> +	 * alarm value, depending on its configuration. This ensures that both
> +	 * critical and alarm values are initialized, even if both registers are
> +	 * configured as critical or non-critical.
> +	 *
> +	 * Note: Critical values for voltage channels are saved, even though
> +	 * this information is currently not used by the driver. This is mostly
> +	 * for consistency, though it might eventually be useful if future APIs
> +	 * support reporting "critical" voltage values.
> +	 */
> +	for (i = 0; i < SMM665_NUM_ADC; i++) {
> +		int val;
> +
> +		val = smm665_read16(client, SMM665_LIMIT_BASE + i * 8);
> +		if (unlikely(val < 0))
> +			goto out_sysfs_create_group;
> +		data->critical_under_limit[i] = data->alarm_under_limit[i]
> +		  = smm665_convert(val, i);
> +		val = smm665_read16(client, SMM665_LIMIT_BASE + i * 8 + 2);
> +		if (unlikely(val < 0))
> +			goto out_sysfs_create_group;
> +		if (smm665_is_critical(val))
> +			data->critical_under_limit[i] = smm665_convert(val, i);
> +		else
> +			data->alarm_under_limit[i] = smm665_convert(val, i);
> +		val = smm665_read16(client, SMM665_LIMIT_BASE + i * 8 + 4);
> +		if (unlikely(val < 0))
> +			goto out_sysfs_create_group;
> +		data->critical_over_limit[i] = data->alarm_over_limit[i]
> +		  = smm665_convert(val, i);
> +		val = smm665_read16(client, SMM665_LIMIT_BASE + i * 8 + 6);
> +		if (unlikely(val < 0))
> +			goto out_sysfs_create_group;
> +		if (smm665_is_critical(val))
> +			data->critical_over_limit[i] = smm665_convert(val, i);
> +		else
> +			data->alarm_over_limit[i] = smm665_convert(val, i);
> +	}
> +
> +	/* Register sysfs hooks */
> +	ret = sysfs_create_group(&client->dev.kobj, &smm665_group);
> +	if (ret)
> +		goto out_sysfs_create_group;
> +
> +	data->hwmon_dev = hwmon_device_register(&client->dev);
> +	if (IS_ERR(data->hwmon_dev)) {
> +		ret = PTR_ERR(data->hwmon_dev);
> +		goto out_hwmon_device_register;
> +	}
> +
> +	return 0;
> +
> +out_hwmon_device_register:
> +	sysfs_remove_group(&client->dev.kobj, &smm665_group);
> +out_sysfs_create_group:
> +	i2c_unregister_device(data->cmdreg);
> +out_new_dummy:
> +	kfree(data);
> +out_kzalloc:
> +	return ret;
> +}
> +
> +static int smm665_remove(struct i2c_client *client)
> +{
> +	struct smm665_data *data = i2c_get_clientdata(client);
> +
> +	i2c_unregister_device(data->cmdreg);
> +	hwmon_device_unregister(data->hwmon_dev);
> +	sysfs_remove_group(&client->dev.kobj, &smm665_group);
> +
> +	kfree(data);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id smm665_id[] = {
> +	{"smm465", smm465},
> +	{"smm665", smm665},
> +	{"smm665c", smm665c},
> +	{"smm764", smm764},
> +	{"smm766", smm766},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, smm665_id);
> +
> +/* This is the driver that will be inserted */
> +static struct i2c_driver smm665_driver = {
> +	.driver = {
> +		   .name = "smm665",
> +		   },
> +	.probe = smm665_probe,
> +	.remove = smm665_remove,
> +	.id_table = smm665_id,
> +};
> +
> +static int __init smm665_init(void)
> +{
> +	return i2c_add_driver(&smm665_driver);
> +}
> +
> +static void __exit smm665_exit(void)
> +{
> +	i2c_del_driver(&smm665_driver);
> +}
> +
> +MODULE_AUTHOR("Guenter Roeck");
> +MODULE_DESCRIPTION("SMM665 driver");
> +MODULE_LICENSE("GPL");
> +
> +module_init(smm665_init);
> +module_exit(smm665_exit);

