Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412Ab0FRSM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 14:12:58 -0400
Received: from ppsw-31.csi.cam.ac.uk ([131.111.8.131]:51355 "EHLO
	ppsw-31.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab0FRSMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 14:12:44 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C1BB698.2090003@cam.ac.uk>
Date: Fri, 18 Jun 2010 19:10:32 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
CC: Guenter Roeck <guenter.roeck@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Hans de Goede <hdegoede@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [lm-sensors] [PATCH 1/3] hwmon: Driver for SMM665 Six-Channel
 Active DC Output Controller/Monitor
References: <1276877194-28214-1-git-send-email-guenter.roeck@ericsson.com>	<1276877194-28214-2-git-send-email-guenter.roeck@ericsson.com> <4C1BB2AC.4090308@jic23.retrosnub.co.uk>
In-Reply-To: <4C1BB2AC.4090308@jic23.retrosnub.co.uk>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/10 18:53, Jonathan Cameron wrote:
> 
> Hi,
> 
> I've taken a quick look through this code.
> 
> One or two specific comments below.
> 
> Only big question is why have the limit functionality in this driver?
> Given the device has no hardware support and you don't have any form
> of regular polling (I think) then these limits will only be noticed if
> you query them. Hence why not leave this job to userspace?
> 
> I'm not saying you are wrong to do this. Just that you need to explain
> your reasoning alongside the patch.

Another quick query.  Are the _min / _max attributes as defined in the
abi meant for alarms?  I always thought they were to tell userspace the
limits on measurement?

Either way, one of us has misunderstood so perhaps the documentation needs
to be more specific....
> 
> 
> On 06/18/10 17:06, Guenter Roeck wrote:
>> This driver adds support for the monitoring features of the Summit
>> Microelectronics SMM665 Six-Channel Active DC Output Controller/Monitor.
>>
>> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
>> ---
>>  drivers/hwmon/Kconfig  |   12 +
>>  drivers/hwmon/Makefile |    1 +
>>  drivers/hwmon/smm665.c |  739 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 752 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/hwmon/smm665.c
>>
>> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
>> index e19cf8e..fc5e229 100644
>> --- a/drivers/hwmon/Kconfig
>> +++ b/drivers/hwmon/Kconfig
>> @@ -739,6 +739,18 @@ config SENSORS_SIS5595
>>  	  This driver can also be built as a module.  If so, the module
>>  	  will be called sis5595.
>>  
>> +config SENSORS_SMM665
>> +	tristate "Summit Microelectronics SMM665"
>> +	depends on I2C && EXPERIMENTAL
>> +	default n
>> +	help
>> +	  If you say yes here you get support for the hardware monitoring
>> +	  features of the Summit Microelectronics SMM665 Six-Channel
>> +	  Active DC Output Controller / Monitor.
>> +
>> +	  This driver can also be built as a module. If so, the module will
>> +	  be called smm665.
>> +
>>  config SENSORS_DME1737
>>  	tristate "SMSC DME1737, SCH311x and compatibles"
>>  	depends on I2C && EXPERIMENTAL
>> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
>> index 2138ceb..8a5c9f5 100644
>> --- a/drivers/hwmon/Makefile
>> +++ b/drivers/hwmon/Makefile
>> @@ -76,6 +76,7 @@ obj-$(CONFIG_SENSORS_LM93)	+= lm93.o
>>  obj-$(CONFIG_SENSORS_LM95241)	+= lm95241.o
>>  obj-$(CONFIG_SENSORS_LTC4215)	+= ltc4215.o
>>  obj-$(CONFIG_SENSORS_LTC4245)	+= ltc4245.o
>> +obj-$(CONFIG_SENSORS_SMM665)	+= smm665.o
>>  obj-$(CONFIG_SENSORS_MAX1111)	+= max1111.o
>>  obj-$(CONFIG_SENSORS_MAX1619)	+= max1619.o
>>  obj-$(CONFIG_SENSORS_MAX6650)	+= max6650.o
>> diff --git a/drivers/hwmon/smm665.c b/drivers/hwmon/smm665.c
>> new file mode 100644
>> index 0000000..84d9d21
>> --- /dev/null
>> +++ b/drivers/hwmon/smm665.c
>> @@ -0,0 +1,739 @@
>> +/*
>> + * Driver for SMM665 Power Controller / Monitor
>> + *
>> + * Copyright (C) 2010 Ericsson AB.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * This driver should with no or minor modifications also work for SMM766,
>> + * SMM764, and SMM465. Only monitoring functionality is implemented.
>> + *
>> + * Datasheets:
>> + * http://www.summitmicro.com/prod_select/summary/SMM665/SMM665B_2089_20.pdf
>> + * http://www.summitmicro.com/prod_select/summary/SMM766B/SMM766B_2122.pdf
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/err.h>
>> +#include <linux/slab.h>
>> +#include <linux/i2c.h>
>> +#include <linux/hwmon.h>
>> +#include <linux/hwmon-sysfs.h>
>> +#include <linux/delay.h>
>> +
> 
> Personally I'd be more inclined to do these as a whole lot
> of '#define's.  You never use the enum type for anything
> so why bother?
> 
>> +/* ADC channel addresses */
>> +enum smm665_adcregs {
>> +	SMM665_MISC16_ADC_DATA_A = 0x00,
>> +	SMM665_MISC16_ADC_DATA_B = 0x01,
>> +	SMM665_MISC16_ADC_DATA_C = 0x02,
>> +	SMM665_MISC16_ADC_DATA_D = 0x03,
>> +	SMM665_MISC16_ADC_DATA_E = 0x04,
>> +	SMM665_MISC16_ADC_DATA_F = 0x05,
>> +	SMM665_MISC16_ADC_DATA_VDD = 0x06,
>> +	SMM665_MISC16_ADC_DATA_12V = 0x07,
>> +	SMM665_MISC16_ADC_DATA_INT_TEMP = 0x08,
>> +	SMM665_MISC16_ADC_DATA_AIN1 = 0x09,
>> +	SMM665_MISC16_ADC_DATA_AIN2 = 0x0a,
>> +};
>> +
>> +enum smm665_cmdregs {
>> +	SMM665_MISC8_CMD_STS = 0x80,
>> +	SMM665_MISC8_STATUS1 = 0x81,
>> +	SMM665_MISC8_STATUSS2 = 0x82,
>> +	SMM665_MISC8_IO_POLARITY = 0x83,
>> +	SMM665_MISC8_PUP_POLARITY = 0x84,
>> +	SMM665_MISC8_ADOC_STATUS1 = 0x85,
>> +	SMM665_MISC8_ADOC_STATUS2 = 0x86,
>> +	SMM665_MISC8_WRITE_PROT = 0x87,
>> +	SMM665_MISC8_STS_TRACK = 0x88,
>> +};
>> +
>> +/*
>> + * Configuration registers and register groups
>> + */
>> +#define SMM665_ADOC_ENABLE		0x0d
>> +#define SMM665_LIMIT_BASE		0x80
>> +
>> +/*
>> + * Limit register bit masks
>> + */
>> +#define SMM665_TRIGGER_RST	0x8000
>> +#define SMM665_TRIGGER_HEALTHY	0x4000
>> +#define SMM665_TRIGGER_POWEROFF	0x2000
>> +#define SMM665_TRIGGER_SHUTDOWN	0x1000
>> +#define SMM665_ADC_MASK		0x03ff
>> +
>> +#define smm665_is_critical(lim)	((lim) & (SMM665_TRIGGER_RST \
>> +					| SMM665_TRIGGER_POWEROFF \
>> +					| SMM665_TRIGGER_SHUTDOWN))
>> +/*
>> + * Fault register bit definitions
>> + * Values are merged from status registers 1/2,
>> + * with status register 1 providing the upper 8 bits.
>> + */
>> +#define SMM665_FAULT_A		0x0001
>> +#define SMM665_FAULT_B		0x0002
>> +#define SMM665_FAULT_C		0x0004
>> +#define SMM665_FAULT_D		0x0008
>> +#define SMM665_FAULT_E		0x0010
>> +#define SMM665_FAULT_F		0x0020
>> +#define SMM665_FAULT_VDD	0x0040
>> +#define SMM665_FAULT_12V	0x0080
>> +#define SMM665_FAULT_TEMP	0x0100
>> +#define SMM665_FAULT_AIN1	0x0200
>> +#define SMM665_FAULT_AIN2	0x0400
>> +
>> +/*
>> + * I2C Register addresses
>> + *
>> + * The configuration register needs to be the configured base register.
>> + * The command/status register address is derived from it.
>> + */
>> +#define SMM665_REGMASK		0x78
>> +#define SMM665_CMDREG_BASE	0x48
>> +#define SMM665_CONFREG_BASE	0x50
>> +
>> +/* Internal reference voltage (VREF, x 1000 */
>> +#define SMM665_VREF_ADC_X1000	1250
>> +
>> +/*
>> + *  Equations given by chip manufacturer to calculate voltage/temperature values
>> + *  vref = Reference voltage on VREF_ADC pin
>> + *  adc  = 10bit ADC value read back from registers
>> + */
>> +
> I guess these are handy if you ever intend to allow different reference voltages,
> but right now they add code and reduce readability.  Obviously leave be if the
> intent is add that vref control in a later patch!
>> +/* Voltage A-F and VDD */
>> +#define SMM665_VMON_ADC_TO_VOLTS(vref, adc)  ((adc) * (vref) / 256)
>> +
>> +/* Voltage 12VIN */
>> +#define SMM665_12VIN_ADC_TO_VOLTS(vref, adc) ((adc) * (vref) * 3 / 256)
>> +
>> +/* Voltage AIN1, AIN2 */
>> +#define SMM665_AIN_ADC_TO_VOLTS(vref, adc)   ((adc) * (vref) / 512)
>> +
>> +/* Temp Sensor */
>> +#define SMM665_TEMP_ADC_TO_CELSIUS(adc)      ((adc) <= 511) ?		   \
>> +					      ((int)(adc) * 1000 / 4) :	   \
>> +					      (((int)(adc) - 0x400) * 1000 / 4)
>> +
>> +#define SMM665_NUM_ADC		11
>> +#define SMM665_ADC_RETRIES	5
>> +#define SMM665_ADC_WAIT		100	/* conversion time is 70 uS for SMM665B,
>> +					   182 uS for SMM766 */
>> +
>> +struct smm665_data {
>> +	struct device *hwmon_dev;
>> +
>> +	struct mutex update_lock;
>> +	bool valid;
>> +	unsigned long last_updated;	/* in jiffies */
>> +	u16 adc[SMM665_NUM_ADC];	/* adc values (raw) */
>> +	u16 faults;			/* fault status */
> 
> Given these aren't used often, I'd prefer more meaningful variable names.
>> +	int cu[SMM665_NUM_ADC];		/* critical under limit (converted) */
>> +	int au[SMM665_NUM_ADC];		/* alarm under limit (converted) */
>> +	int co[SMM665_NUM_ADC];		/* critical over limit (converted) */
>> +	int ao[SMM665_NUM_ADC];		/* alarm over limit (converted) */
>> +	struct i2c_client *cmdreg;
>> +};
>> +
>> +/*
>> + * smm665_read16()
>> + *
>> + * Read 16 bit value from <reg>, <reg+1>. Upper 8 bits are in <reg>.
>> + */
>> +static int smm665_read16(struct i2c_client *client, int reg)
>> +{
>> +	int rv, val;
>> +
>> +	rv = i2c_smbus_read_byte_data(client, reg);
>> +	if (rv < 0)
>> +		return rv;
>> +	val = rv << 8;
>> +	rv = i2c_smbus_read_byte_data(client, reg + 1);
>> +	if (rv < 0)
>> +		return rv;
>> +	val |= rv;
>> +	return val;
>> +}
>> +
>> +/*
>> + * Read adc value.
>> + */
>> +static int smm665_read_adc(struct i2c_client *client, int adc)
>> +{
>> +	int rv = -1;
>> +	int retries;
>> +
> Why the retries?  If there is a reason for this to sometimes fail, please
> add a comment explaining what it is! If it is a hardware bug, then tell us!
>> +	for (retries = 0; retries < SMM665_ADC_RETRIES; retries++) {
>> +		int radc;
>> +
>> +		/*
>> +		 * Algorithm for reading ADC, per SMM665 datasheet
>> +		 *
>> +		 *  {[S][addr][W][Ack]} {[offset][Ack]} {[S][addr][R][Nack]}
>> +		 * [wait 70 uS]
>> +		 *  {[S][addr][R][Ack]} {[datahi][Ack]} {[datalo][Ack][P]}
>> +		 *
>> +		 * To implement the first part of this exchange,
>> +		 * do a full read transaction and expect a failure/Nack.
>> +		 * This sets up the address pointer on the SMM665
>> +		 * and starts the ADC conversion.
>> +		 * Then do a two-byte read transaction.
>> +		 */
> Is there no better way of handling this? There are protocol mangling hacks
> to tell the i2c core to ignore a NAKs under some circumstances.
> 
>> +		rv = i2c_smbus_read_byte_data(client, adc << 3);
>> +		if (rv >= 0) {
>> +			/* No error, something is wrong. Retry. */
>> +			rv = -1;
>> +			continue;
>> +		}
>> +		udelay(SMM665_ADC_WAIT);
>> +		/*
>> +		 * Now read two bytes.
>> +		 *
>> +		 * Neither i2c_smbus_read_byte() nor
>> +		 * i2c_smbus_read_block_data() worked here,
>> +		 * so use i2c_smbus_read_word_data() instead.
>> +		 * We could also try to use i2c_master_recv(),
>> +		 * but that is not always supported.
>> +		 */
>> +		rv = i2c_smbus_read_word_data(client, 0);
>> +		if (rv < 0)
>> +			continue;
>> +		/*
>> +		 * Validate/verify readback adc channel (in bit 11..14)
>> +		 * High byte is in lower 8 bit of rv, so only shift by 3.
>> +		 */
>> +		radc = (rv >> 3) & 0x0f;
>> +		if (radc != adc) {
>> +			rv = -1;
>> +			continue;
>> +		}
>> +
>> +		/* Byte order is reversed, need to swap. */
> Isn't this endian dependent?
>> +		rv = swab16(rv) & SMM665_ADC_MASK;
>> +		break;
>> +	}
>> +	return rv;
>> +}
>> +
>> +static struct smm665_data *smm665_update_device(struct device *dev)
>> +{
>> +	struct i2c_client *client = to_i2c_client(dev);
>> +	struct smm665_data *data = i2c_get_clientdata(client);
>> +
>> +	mutex_lock(&data->update_lock);
>> +
>> +	if (time_after(jiffies, data->last_updated + HZ) || !data->valid) {
>> +		int i, faults;
>> +
>> +		/*
>> +		 * read status registers
>> +		 */
>> +		faults = smm665_read16(client, SMM665_MISC8_STATUS1);
>> +		if (unlikely(faults < 0))
>> +			data->faults = 0;
>> +		else
>> +			data->faults = faults;
>> +
>> +		/* Read adc registers */
>> +		for (i = 0; i < SMM665_NUM_ADC; i++) {
>> +			int val = smm665_read_adc(data->cmdreg, i);
>> +			if (unlikely(val < 0))
>> +				data->adc[i] = 0;
>> +			else
>> +				data->adc[i] = val;
>> +		}
>> +
>> +		data->last_updated = jiffies;
>> +		data->valid = 1;
>> +	}
>> +
>> +	mutex_unlock(&data->update_lock);
>> +
>> +	return data;
>> +}
>> +
>> +/* Return converted value from given adc */
>> +static int smm665_convert(u16 adcval, int index)
>> +{
>> +	int val = 0;
>> +
>> +	switch (index) {
>> +	case SMM665_MISC16_ADC_DATA_12V:
>> +		val = SMM665_12VIN_ADC_TO_VOLTS(SMM665_VREF_ADC_X1000,
>> +						adcval & SMM665_ADC_MASK);
>> +		break;
>> +
>> +	case SMM665_MISC16_ADC_DATA_VDD:
>> +	case SMM665_MISC16_ADC_DATA_A:
>> +	case SMM665_MISC16_ADC_DATA_B:
>> +	case SMM665_MISC16_ADC_DATA_C:
>> +	case SMM665_MISC16_ADC_DATA_D:
>> +	case SMM665_MISC16_ADC_DATA_E:
>> +	case SMM665_MISC16_ADC_DATA_F:
>> +		val = SMM665_VMON_ADC_TO_VOLTS(SMM665_VREF_ADC_X1000,
>> +					       adcval & SMM665_ADC_MASK);
>> +		break;
>> +
>> +	case SMM665_MISC16_ADC_DATA_AIN1:
>> +	case SMM665_MISC16_ADC_DATA_AIN2:
>> +		val = SMM665_AIN_ADC_TO_VOLTS(SMM665_VREF_ADC_X1000,
>> +					      adcval & SMM665_ADC_MASK);
>> +		break;
>> +
>> +	case SMM665_MISC16_ADC_DATA_INT_TEMP:
>> +		val = SMM665_TEMP_ADC_TO_CELSIUS(adcval & SMM665_ADC_MASK);
>> +		break;
>> +
>> +	default:
>> +		/* If we get here, the developer messed up */
>> +		WARN_ON_ONCE(1);
>> +		break;
>> +	}
>> +
>> +	return val;
>> +}
>> +
>> +/* Return converted value from given adc */
>> +static int smm665_get_input(struct device *dev, int adc)
>> +{
>> +	struct smm665_data *data = smm665_update_device(dev);
>> +
>> +	return smm665_convert(data->adc[adc], adc);
>> +}
>> +
>> +static int smm665_get_min(struct device *dev, int index)
>> +{
>> +	struct i2c_client *client = to_i2c_client(dev);
>> +	struct smm665_data *data = i2c_get_clientdata(client);
>> +
>> +	return data->au[index];
>> +}
>> +
>> +static int smm665_get_max(struct device *dev, int index)
>> +{
>> +	struct i2c_client *client = to_i2c_client(dev);
>> +	struct smm665_data *data = i2c_get_clientdata(client);
>> +
>> +	return data->ao[index];
>> +}
>> +
>> +static int smm665_get_crit(struct device *dev, int index)
>> +{
>> +	struct i2c_client *client = to_i2c_client(dev);
>> +	struct smm665_data *data = i2c_get_clientdata(client);
>> +
>> +	return data->co[index];
>> +}
>> +
> 
> I'm confused.  So these alarms are purely software constructs.
> Given I don't think the device does regular polling, why not
> leave this to userspace?
> 
>> +static int smm665_get_min_alarm(struct device *dev, int index)
>> +{
>> +	struct smm665_data *data = smm665_update_device(dev);
>> +	int val = smm665_convert(data->adc[index], index);
>> +
>> +	/*
>> +	 * Look for lower alarm limit. Report alarm if the current
>> +	 * adc value is equal to or lower than the specified limit.
>> +	 */
>> +	if (val <= data->au[index])
>> +		return 1;
> (nitpick) Inconsistent spacing between this and the next function.
>> +	return 0;
>> +}
>> +
>> +static int smm665_get_max_alarm(struct device *dev, int index)
>> +{
>> +	struct smm665_data *data = smm665_update_device(dev);
>> +	int val = smm665_convert(data->adc[index], index);
>> +
>> +	/*
>> +	 * Look for upper alarm limit. Report alarm if the current
>> +	 * adc value is equal to or larger than the specified limit.
>> +	 */
>> +	if (val >= data->ao[index])
>> +		return 1;
>> +
>> +	return 0;
>> +}
>> +
>> +static int smm665_get_fault(struct device *dev, int index)
>> +{
>> +	struct smm665_data *data = smm665_update_device(dev);
>> +
>> +	if (data->faults & (1 << index))
>> +		return 1;
>> +
>> +	return 0;
>> +}
>> +
>> +#define SMM665_SHOW(what) \
>> +  static ssize_t smm665_show_##what(struct device *dev, \
>> +				    struct device_attribute *da, char *buf) \
>> +{ \
>> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(da); \
>> +	const int val = smm665_get_##what(dev, attr->index); \
>> +	return snprintf(buf, PAGE_SIZE, "%d\n", val); \
>> +}
>> +
>> +SMM665_SHOW(input);
>> +SMM665_SHOW(min);
>> +SMM665_SHOW(max);
>> +SMM665_SHOW(crit);
>> +SMM665_SHOW(fault);
>> +SMM665_SHOW(min_alarm);
>> +SMM665_SHOW(max_alarm);
>> +
>> +/* These macros are used below in constructing device attribute objects
>> + * for use with sysfs_create_group() to make a sysfs device file
>> + * for each register.
>> + */
>> +
>> +#define SMM665_ATTR(name, type, cmd_idx) \
>> +	static SENSOR_DEVICE_ATTR(name##_##type, S_IRUGO, \
>> +				  smm665_show_##type, NULL, cmd_idx)
>> +
>> +/* Construct a sensor_device_attribute structure for each register */
>> +
>> +/* Input voltages */
>> +SMM665_ATTR(in1, input, SMM665_MISC16_ADC_DATA_12V);
>> +SMM665_ATTR(in2, input, SMM665_MISC16_ADC_DATA_VDD);
>> +SMM665_ATTR(in3, input, SMM665_MISC16_ADC_DATA_A);
>> +SMM665_ATTR(in4, input, SMM665_MISC16_ADC_DATA_B);
>> +SMM665_ATTR(in5, input, SMM665_MISC16_ADC_DATA_C);
>> +SMM665_ATTR(in6, input, SMM665_MISC16_ADC_DATA_D);
>> +SMM665_ATTR(in7, input, SMM665_MISC16_ADC_DATA_E);
>> +SMM665_ATTR(in8, input, SMM665_MISC16_ADC_DATA_F);
>> +SMM665_ATTR(in9, input, SMM665_MISC16_ADC_DATA_AIN1);
>> +SMM665_ATTR(in10, input, SMM665_MISC16_ADC_DATA_AIN2);
>> +
>> +/* Input voltages min */
>> +SMM665_ATTR(in1, min, SMM665_MISC16_ADC_DATA_12V);
>> +SMM665_ATTR(in2, min, SMM665_MISC16_ADC_DATA_VDD);
>> +SMM665_ATTR(in3, min, SMM665_MISC16_ADC_DATA_A);
>> +SMM665_ATTR(in4, min, SMM665_MISC16_ADC_DATA_B);
>> +SMM665_ATTR(in5, min, SMM665_MISC16_ADC_DATA_C);
>> +SMM665_ATTR(in6, min, SMM665_MISC16_ADC_DATA_D);
>> +SMM665_ATTR(in7, min, SMM665_MISC16_ADC_DATA_E);
>> +SMM665_ATTR(in8, min, SMM665_MISC16_ADC_DATA_F);
>> +SMM665_ATTR(in9, min, SMM665_MISC16_ADC_DATA_AIN1);
>> +SMM665_ATTR(in10, min, SMM665_MISC16_ADC_DATA_AIN2);
>> +
>> +/* Input voltages max */
>> +SMM665_ATTR(in1, max, SMM665_MISC16_ADC_DATA_12V);
>> +SMM665_ATTR(in2, max, SMM665_MISC16_ADC_DATA_VDD);
>> +SMM665_ATTR(in3, max, SMM665_MISC16_ADC_DATA_A);
>> +SMM665_ATTR(in4, max, SMM665_MISC16_ADC_DATA_B);
>> +SMM665_ATTR(in5, max, SMM665_MISC16_ADC_DATA_C);
>> +SMM665_ATTR(in6, max, SMM665_MISC16_ADC_DATA_D);
>> +SMM665_ATTR(in7, max, SMM665_MISC16_ADC_DATA_E);
>> +SMM665_ATTR(in8, max, SMM665_MISC16_ADC_DATA_F);
>> +SMM665_ATTR(in9, max, SMM665_MISC16_ADC_DATA_AIN1);
>> +SMM665_ATTR(in10, max, SMM665_MISC16_ADC_DATA_AIN2);
>> +
>> +/* Input voltage min alarms */
>> +SMM665_ATTR(in1, min_alarm, SMM665_MISC16_ADC_DATA_12V);
>> +SMM665_ATTR(in2, min_alarm, SMM665_MISC16_ADC_DATA_VDD);
>> +SMM665_ATTR(in3, min_alarm, SMM665_MISC16_ADC_DATA_A);
>> +SMM665_ATTR(in4, min_alarm, SMM665_MISC16_ADC_DATA_B);
>> +SMM665_ATTR(in5, min_alarm, SMM665_MISC16_ADC_DATA_C);
>> +SMM665_ATTR(in6, min_alarm, SMM665_MISC16_ADC_DATA_D);
>> +SMM665_ATTR(in7, min_alarm, SMM665_MISC16_ADC_DATA_E);
>> +SMM665_ATTR(in8, min_alarm, SMM665_MISC16_ADC_DATA_F);
>> +SMM665_ATTR(in9, min_alarm, SMM665_MISC16_ADC_DATA_AIN1);
>> +SMM665_ATTR(in10, min_alarm, SMM665_MISC16_ADC_DATA_AIN2);
>> +
>> +/* Input voltage max alarms */
>> +SMM665_ATTR(in1, max_alarm, SMM665_MISC16_ADC_DATA_12V);
>> +SMM665_ATTR(in2, max_alarm, SMM665_MISC16_ADC_DATA_VDD);
>> +SMM665_ATTR(in3, max_alarm, SMM665_MISC16_ADC_DATA_A);
>> +SMM665_ATTR(in4, max_alarm, SMM665_MISC16_ADC_DATA_B);
>> +SMM665_ATTR(in5, max_alarm, SMM665_MISC16_ADC_DATA_C);
>> +SMM665_ATTR(in6, max_alarm, SMM665_MISC16_ADC_DATA_D);
>> +SMM665_ATTR(in7, max_alarm, SMM665_MISC16_ADC_DATA_E);
>> +SMM665_ATTR(in8, max_alarm, SMM665_MISC16_ADC_DATA_F);
>> +SMM665_ATTR(in9, max_alarm, SMM665_MISC16_ADC_DATA_AIN1);
>> +SMM665_ATTR(in10, max_alarm, SMM665_MISC16_ADC_DATA_AIN2);
>> +
>> +/* Faults */
>> +SMM665_ATTR(in1, fault, SMM665_FAULT_12V);
>> +SMM665_ATTR(in2, fault, SMM665_FAULT_VDD);
>> +SMM665_ATTR(in3, fault, SMM665_FAULT_A);
>> +SMM665_ATTR(in4, fault, SMM665_FAULT_B);
>> +SMM665_ATTR(in5, fault, SMM665_FAULT_C);
>> +SMM665_ATTR(in6, fault, SMM665_FAULT_D);
>> +SMM665_ATTR(in7, fault, SMM665_FAULT_E);
>> +SMM665_ATTR(in8, fault, SMM665_FAULT_F);
>> +SMM665_ATTR(in9, fault, SMM665_FAULT_AIN1);
>> +SMM665_ATTR(in10, fault, SMM665_FAULT_AIN2);
>> +
>> +/* Temperature */
>> +SMM665_ATTR(temp1, input, SMM665_MISC16_ADC_DATA_INT_TEMP);
>> +SMM665_ATTR(temp1, min, SMM665_MISC16_ADC_DATA_INT_TEMP);
>> +SMM665_ATTR(temp1, max, SMM665_MISC16_ADC_DATA_INT_TEMP);
>> +SMM665_ATTR(temp1, crit, SMM665_MISC16_ADC_DATA_INT_TEMP);
>> +SMM665_ATTR(temp1, min_alarm, SMM665_MISC16_ADC_DATA_INT_TEMP);
>> +SMM665_ATTR(temp1, max_alarm, SMM665_MISC16_ADC_DATA_INT_TEMP);
>> +SMM665_ATTR(temp1, fault, SMM665_FAULT_TEMP);
>> +
>> +/*
>> + * Finally, construct an array of pointers to members of the above objects,
>> + * as required for sysfs_create_group()
>> + */
>> +static struct attribute *smm665_attributes[] = {
>> +	&sensor_dev_attr_in1_input.dev_attr.attr,
>> +	&sensor_dev_attr_in1_min.dev_attr.attr,
>> +	&sensor_dev_attr_in1_max.dev_attr.attr,
>> +	&sensor_dev_attr_in1_min_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in1_max_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in1_fault.dev_attr.attr,
>> +
>> +	&sensor_dev_attr_in2_input.dev_attr.attr,
>> +	&sensor_dev_attr_in2_min.dev_attr.attr,
>> +	&sensor_dev_attr_in2_max.dev_attr.attr,
>> +	&sensor_dev_attr_in2_min_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in2_max_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in2_fault.dev_attr.attr,
>> +
>> +	&sensor_dev_attr_in3_input.dev_attr.attr,
>> +	&sensor_dev_attr_in3_min.dev_attr.attr,
>> +	&sensor_dev_attr_in3_max.dev_attr.attr,
>> +	&sensor_dev_attr_in3_min_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in3_max_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in3_fault.dev_attr.attr,
>> +
>> +	&sensor_dev_attr_in4_input.dev_attr.attr,
>> +	&sensor_dev_attr_in4_min.dev_attr.attr,
>> +	&sensor_dev_attr_in4_max.dev_attr.attr,
>> +	&sensor_dev_attr_in4_min_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in4_max_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in4_fault.dev_attr.attr,
>> +
>> +	&sensor_dev_attr_in5_input.dev_attr.attr,
>> +	&sensor_dev_attr_in5_min.dev_attr.attr,
>> +	&sensor_dev_attr_in5_max.dev_attr.attr,
>> +	&sensor_dev_attr_in5_min_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in5_max_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in5_fault.dev_attr.attr,
>> +
>> +	&sensor_dev_attr_in6_input.dev_attr.attr,
>> +	&sensor_dev_attr_in6_min.dev_attr.attr,
>> +	&sensor_dev_attr_in6_max.dev_attr.attr,
>> +	&sensor_dev_attr_in6_min_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in6_max_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in6_fault.dev_attr.attr,
>> +
>> +	&sensor_dev_attr_in7_input.dev_attr.attr,
>> +	&sensor_dev_attr_in7_min.dev_attr.attr,
>> +	&sensor_dev_attr_in7_max.dev_attr.attr,
>> +	&sensor_dev_attr_in7_min_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in7_max_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in7_fault.dev_attr.attr,
>> +
>> +	&sensor_dev_attr_in8_input.dev_attr.attr,
>> +	&sensor_dev_attr_in8_min.dev_attr.attr,
>> +	&sensor_dev_attr_in8_max.dev_attr.attr,
>> +	&sensor_dev_attr_in8_min_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in8_max_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in8_fault.dev_attr.attr,
>> +
>> +	&sensor_dev_attr_in9_input.dev_attr.attr,
>> +	&sensor_dev_attr_in9_min.dev_attr.attr,
>> +	&sensor_dev_attr_in9_max.dev_attr.attr,
>> +	&sensor_dev_attr_in9_min_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in9_max_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in9_fault.dev_attr.attr,
>> +
>> +	&sensor_dev_attr_in10_input.dev_attr.attr,
>> +	&sensor_dev_attr_in10_min.dev_attr.attr,
>> +	&sensor_dev_attr_in10_max.dev_attr.attr,
>> +	&sensor_dev_attr_in10_min_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in10_max_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_in10_fault.dev_attr.attr,
>> +
>> +	&sensor_dev_attr_temp1_input.dev_attr.attr,
>> +	&sensor_dev_attr_temp1_min.dev_attr.attr,
>> +	&sensor_dev_attr_temp1_max.dev_attr.attr,
>> +	&sensor_dev_attr_temp1_crit.dev_attr.attr,
>> +	&sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
>> +	&sensor_dev_attr_temp1_fault.dev_attr.attr,
>> +
>> +	NULL,
>> +};
>> +
>> +static const struct attribute_group smm665_group = {
>> +	.attrs = smm665_attributes,
>> +};
>> +
>> +static int smm665_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *id)
>> +{
>> +	struct i2c_adapter *adapter = client->adapter;
>> +	struct smm665_data *data;
>> +	int i, ret;
>> +
>> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA
>> +				     | I2C_FUNC_SMBUS_WORD_DATA))
>> +		return -ENODEV;
>> +
>> +	if (i2c_smbus_read_byte_data(client, SMM665_ADOC_ENABLE) < 0)
>> +		return -ENODEV;
>> +
>> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
>> +	if (!data) {
>> +		ret = -ENOMEM;
>> +		goto out_kzalloc;
>> +	}
>> +
>> +	i2c_set_clientdata(client, data);
>> +	mutex_init(&data->update_lock);
>> +
>> +	data->cmdreg = i2c_new_dummy(adapter, (client->addr & ~SMM665_REGMASK)
>> +				     | SMM665_CMDREG_BASE);
>> +	if (!data->cmdreg) {
>> +		ret = -ENOMEM;
>> +		goto out_new_dummy;
>> +	}
>> +	if (i2c_smbus_read_byte_data(data->cmdreg, SMM665_MISC8_CMD_STS) < 0) {
>> +		ret = -ENODEV;
>> +		goto out_sysfs_create_group;
>> +	}
>> +
>> +	/*
>> +	 * Read limits.
>> +	 *
>> +	 * Limit registers start with register SMM665_LIMIT_BASE.
>> +	 * Each channel uses 8 registers, providing four limit values
>> +	 * per channel.
>> +	 *
>> +	 * Available limits from chip registers, per channel:
> A simple statement of endianess and number of bytes would do the job.
>> +	 *  u1: under limit 1
>> +	 *  u2: under limit 2
>> +	 *  o1: over limit 1
>> +	 *  o2: over limit 2
>> +	 *
>> +	 * Register address offsets:
>> +	 * +0:  u1[h]
>> +	 * +1:  u1[l]
>> +	 * +2:  u2[h]
>> +	 * +3:  u2[l]
>> +	 * +4:  o1[h]
>> +	 * +5:  o1[l]
>> +	 * +6:  o2[h]
>> +	 * +7:  o2[l]
>> +	 *
>> +	 * Limit register order is as defined with smm665_adcregs,
>> +	 * so we use smm665_adcregs values throughout the code to index
>> +	 * limit registers.
>> +	 *
>> +	 * We save the first retrieved value both as "critical" and "alarm"
>> +	 * value. The second value overwrites either the critical or the
>> +	 * alarm value, depending on its configuration. This ensures that both
>> +	 * critical and alarm values are initialized, even if both registers are
>> +	 * configured as critical or non-critical.
>> +	 *
>> +	 * Note: Critical values for voltage channels are saved, even though
>> +	 * this information is currently not used by the driver. This is mostly
>> +	 * for consistency, though it might eventually be useful if future APIs
>> +	 * support reporting "critical" voltage values.
>> +	 */
>> +	ret = -ENODEV;
>> +	for (i = 0; i < SMM665_NUM_ADC; i++) {
>> +		int val;
>> +
>> +		val = smm665_read16(client, SMM665_LIMIT_BASE + i * 8);
>> +		if (unlikely(val < 0))
>> +			goto out_sysfs_create_group;
>> +		data->cu[i] = data->au[i] = smm665_convert(val, i);
>> +		val = smm665_read16(client, SMM665_LIMIT_BASE + i * 8 + 2);
>> +		if (unlikely(val < 0))
>> +			goto out_sysfs_create_group;
>> +		if (smm665_is_critical(val))
>> +			data->cu[i] = smm665_convert(val, i);
>> +		else
>> +			data->au[i] = smm665_convert(val, i);
>> +		val = smm665_read16(client, SMM665_LIMIT_BASE + i * 8 + 4);
>> +		if (unlikely(val < 0))
>> +			goto out_sysfs_create_group;
>> +		data->co[i] = data->ao[i] = smm665_convert(val, i);
>> +		val = smm665_read16(client, SMM665_LIMIT_BASE + i * 8 + 6);
>> +		if (unlikely(val < 0))
>> +			goto out_sysfs_create_group;
>> +		if (smm665_is_critical(val))
>> +			data->co[i] = smm665_convert(val, i);
>> +		else
>> +			data->ao[i] = smm665_convert(val, i);
>> +	}
>> +
>> +	/* Register sysfs hooks */
>> +	ret = sysfs_create_group(&client->dev.kobj, &smm665_group);
>> +	if (ret)
>> +		goto out_sysfs_create_group;
>> +
>> +	data->hwmon_dev = hwmon_device_register(&client->dev);
>> +	if (IS_ERR(data->hwmon_dev)) {
>> +		ret = PTR_ERR(data->hwmon_dev);
>> +		goto out_hwmon_device_register;
>> +	}
>> +
>> +	return 0;
>> +
>> +out_hwmon_device_register:
>> +	sysfs_remove_group(&client->dev.kobj, &smm665_group);
>> +out_sysfs_create_group:
>> +	i2c_unregister_device(data->cmdreg);
>> +out_new_dummy:
>> +	kfree(data);
>> +out_kzalloc:
>> +	return ret;
>> +}
>> +
>> +static int smm665_remove(struct i2c_client *client)
>> +{
>> +	struct smm665_data *data = i2c_get_clientdata(client);
>> +
>> +	i2c_unregister_device(data->cmdreg);
>> +	hwmon_device_unregister(data->hwmon_dev);
>> +	sysfs_remove_group(&client->dev.kobj, &smm665_group);
>> +
>> +	kfree(data);
>> +
>> +	return 0;
>> +}
>> +
> 
> Personally I'd be cynical.  If the other devices you list above
> should work. I'd add them to the id table and Kconfig description
> and just put a note saying they are untested.
> 
> Obviously don't do this if you have any reason to suspect they
> are not fully compatible.
> 
> But then that is me :)
> 
>> +static const struct i2c_device_id smm665_id[] = {
>> +	{"smm665", 0},
>> +	{}
>> +};
>> +
>> +MODULE_DEVICE_TABLE(i2c, smm665_id);
>> +
>> +/* This is the driver that will be inserted */
>> +static struct i2c_driver smm665_driver = {
>> +	.driver = {
>> +		   .name = "smm665",
>> +		   },
>> +	.probe = smm665_probe,
>> +	.remove = smm665_remove,
>> +	.id_table = smm665_id,
>> +};
>> +
>> +static int __init smm665_init(void)
>> +{
>> +	return i2c_add_driver(&smm665_driver);
>> +}
>> +
>> +static void __exit smm665_exit(void)
>> +{
>> +	i2c_del_driver(&smm665_driver);
>> +}
>> +
>> +MODULE_AUTHOR("Guenter Roeck");
>> +MODULE_DESCRIPTION("SMM665 driver");
>> +MODULE_LICENSE("GPL");
>> +
>> +module_init(smm665_init);
>> +module_exit(smm665_exit);
> 
> 
> _______________________________________________
> lm-sensors mailing list
> lm-sensors@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/lm-sensors
> 

