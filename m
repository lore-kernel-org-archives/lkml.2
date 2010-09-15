Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0IOLUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:20:55 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:23154 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0IOLUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:20:53 -0400
Date: Wed, 15 Sep 2010 13:20:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] hwmon: (lm90) Add support for max6695 and
 max6696
Message-ID: <20100915132029.4c708c7d@hyperion.delvare>
In-Reply-To: <1284038750-8833-8-git-send-email-guenter.roeck@ericsson.com>
References: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
	<1284038750-8833-8-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Sorry for the slow review, I am in the process of reinstalling my
workstation entirely, and this keeps be busy.

On Thu, 9 Sep 2010 06:25:50 -0700, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
>  Documentation/hwmon/lm90 |   17 ++++
>  drivers/hwmon/Kconfig    |    4 +-
>  drivers/hwmon/lm90.c     |  240 +++++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 237 insertions(+), 24 deletions(-)
> 
> diff --git a/Documentation/hwmon/lm90 b/Documentation/hwmon/lm90
> index bc2c2b4..5554bea 100644
> --- a/Documentation/hwmon/lm90
> +++ b/Documentation/hwmon/lm90
> @@ -84,6 +84,17 @@ Supported chips:
>      Addresses scanned: I2C 0x4c
>      Datasheet: Publicly available at the Maxim website
>                 http://www.maxim-ic.com/quick_view2.cfm/qv_pk/3500
> +  * Maxim MAX6695
> +    Prefix: 'max6695'
> +    Addresses scanned: I2C 0x18
> +    Datasheet: Publicly available at the Maxim website
> +               http://www.maxim-ic.com/datasheet/index.mvp/id/4199
> +  * Maxim MAX6696
> +    Prefix: 'max6695'
> +    Addresses scanned: I2C 0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b,
> +                           0x4c, 0x4d and 0x4e
> +    Datasheet: Publicly available at the Maxim website
> +               http://www.maxim-ic.com/datasheet/index.mvp/id/4199
>    * Winbond/Nuvoton W83L771AWG/ASG
>      Prefix: 'w83l771'
>      Addresses scanned: I2C 0x4c
> @@ -152,6 +163,12 @@ MAX6680 and MAX6681:
>    * Selectable address
>    * Remote sensor type selection
>  
> +MAX6695 and MAX6696:
> +  * Better local resolution
> +  * Selectable address

MAX6696 only?

> +  * Second critical temperature limit
> +  * Two remote sensors
> +
>  W83L771AWG/ASG
>    * The AWG and ASG variants only differ in package format.
>    * Filter and alert configuration register at 0xBF
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 4d4d09b..17c719b 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -605,8 +605,8 @@ config SENSORS_LM90
>  	  If you say yes here you get support for National Semiconductor LM90,
>  	  LM86, LM89 and LM99, Analog Devices ADM1032 and ADT7461, Maxim
>  	  MAX6646, MAX6647, MAX6648, MAX6649, MAX6657, MAX6658, MAX6659,
> -	  MAX6680, MAX6681 and MAX6692, and Winbond/Nuvoton W83L771AWG/ASG
> -	  sensor chips.
> +	  MAX6680, MAX6681, MAX6692, MAX6695, MAX6696, and Winbond/Nuvoton
> +	  W83L771AWG/ASG sensor chips.
>  
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called lm90.
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index 690949b..61256e9 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c
> @@ -42,6 +42,11 @@
>   * chips. The MAX6680 and MAX6681 only differ in the pinout so they can
>   * be treated identically.
>   *
> + * This driver also supports the MAX6695 and MAX6696, two other sensor
> + * chips made by Maxim. These are also quite similar to other Maxim
> + * chips, but support three temperature sensors instead of two. MAX6695
> + * and MAX6696 only differ in the pinout so they can be treated identically.
> + *
>   * This driver also supports the ADT7461 chip from Analog Devices.
>   * It's supported in both compatibility and extended mode. It is mostly
>   * compatible with LM90 except for a data format difference for the
> @@ -94,7 +99,7 @@ static const unsigned short normal_i2c[] = {
>  	0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b, 0x4c, 0x4d, 0x4e, I2C_CLIENT_END };
>  
>  enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
> -	w83l771, max6659 };
> +	w83l771, max6659, max6695 };

How much time before we mix max6659 and max6695? ;) It might make sense
to decide to go with max6696 for the latter, to work around this
potential issue.

>  
>  /*
>   * The LM90 registers
> @@ -135,9 +140,10 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
>  #define LM90_REG_R_TCRIT_HYST		0x21
>  #define LM90_REG_W_TCRIT_HYST		0x21
>  
> -/* MAX6646/6647/6649/6657/6658/6659 registers */
> +/* MAX6646/6647/6649/6657/6658/6659/6695/6696 registers */
>  
>  #define MAX6657_REG_R_LOCAL_TEMPL	0x11
> +#define MAX6695_REG_R_STATUS2		0x12
>  #define MAX6659_REG_R_REMOTE_EMERG	0x16
>  #define MAX6659_REG_W_REMOTE_EMERG	0x16
>  #define MAX6659_REG_R_LOCAL_EMERG	0x17
> @@ -152,6 +158,8 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
>  #define	LM90_HAVE_LOCAL_EXT	0x04	/* extended local temperature	*/
>  #define	LM90_HAVE_REM_LIMIT_EXT	0x08	/* extended remote limit	*/
>  #define	LM90_HAVE_EMERGENCY	0x10	/* 3rd upper (emergency) limit	*/
> +#define	LM90_HAVE_EMERGENCY_ALARM 0x20	/* emergency alarm		*/
> +#define	LM90_HAVE_TEMP3		0x40	/* 3rd temperature sensor	*/

Use one space after #define.

>  
>  /*
>   * Functions declaration
> @@ -164,6 +172,10 @@ static void lm90_init_client(struct i2c_client *client);
>  static void lm90_alert(struct i2c_client *client, unsigned int flag);
>  static int lm90_remove(struct i2c_client *client);
>  static struct lm90_data *lm90_update_device(struct device *dev);
> +static int lm90_read_reg(struct i2c_client *client, u8 reg, u8 *value);
> +static inline void lm90_select_remote_channel(struct i2c_client *client,
> +					      struct lm90_data *data,
> +					      int channel);

Would it be possible to simply place these functions at the right
location so that forward declarations are not needed? Ideally I would
like to get rid of all these forward declarations.

>  
>  /*
>   * Driver data (common to all clients)
> @@ -184,6 +196,8 @@ static const struct i2c_device_id lm90_id[] = {
>  	{ "max6659", max6659 },
>  	{ "max6680", max6680 },
>  	{ "max6681", max6680 },
> +	{ "max6695", max6695 },
> +	{ "max6696", max6695 },
>  	{ "w83l771", w83l771 },
>  	{ }
>  };
> @@ -215,22 +229,29 @@ struct lm90_data {
>  	int flags;
>  
>  	u8 config_orig;		/* Original configuration register value */
> -	u8 alert_alarms;	/* Which alarm bits trigger ALERT# */
> +	u16 alert_alarms;	/* Which alarm bits trigger ALERT# */
> +				/* Upper 8 bits for max6695/96 */
>  
>  	/* registers values */
> -	s8 temp8[6];	/* 0: local low limit
> +	s8 temp8[8];	/* 0: local low limit
>  			   1: local high limit
>  			   2: local critical limit
>  			   3: remote critical limit
> -			   4: local emergency limit (max6659 only)
> -			   5: remote emergency limit (max6659 only) */
> -	s16 temp11[5];	/* 0: remote input
> +			   4: local emergency limit (max6659 and max6695/96)
> +			   5: remote emergency limit (max6659 and max6695/96)
> +			   6: remote 2 critical limit (max6695/96 only)
> +			   7: remote 2 emergency limit (max6695/96 only) */
> +	s16 temp11[8];	/* 0: remote input
>  			   1: remote low limit
>  			   2: remote high limit
> -			   3: remote offset (except max6646 and max6657/58/59)
> -			   4: local input */
> +			   3: remote offset (except max6646, max6657/58/59,
> +					     and max6695/96)
> +			   4: local input
> +			   5: remote 2 input (max6695/96 only)
> +			   6: remote 2 low limit (max6695/96 only)
> +			   7: remote 2 high limit (ma6695/96 only) */
>  	u8 temp_hyst;
> -	u8 alarms; /* bitvector */
> +	u16 alarms; /* bitvector (upper 8 bits for max6695/96) */
>  };
>  
>  /*
> @@ -388,13 +409,15 @@ static ssize_t show_temp8(struct device *dev, struct device_attribute *devattr,
>  static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
>  			 const char *buf, size_t count)
>  {
> -	static const u8 reg[6] = {
> +	static const u8 reg[8] = {
>  		LM90_REG_W_LOCAL_LOW,
>  		LM90_REG_W_LOCAL_HIGH,
>  		LM90_REG_W_LOCAL_CRIT,
>  		LM90_REG_W_REMOTE_CRIT,
>  		MAX6659_REG_W_LOCAL_EMERG,
>  		MAX6659_REG_W_REMOTE_EMERG,
> +		LM90_REG_W_REMOTE_CRIT,
> +		MAX6659_REG_W_REMOTE_EMERG,
>  	};
>  
>  	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> @@ -419,7 +442,11 @@ static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
>  		data->temp8[nr] = temp_to_u8(val);
>  	else
>  		data->temp8[nr] = temp_to_s8(val);
> +
> +	lm90_select_remote_channel(client, data, nr >= 6);
>  	i2c_smbus_write_byte_data(client, reg[nr], data->temp8[nr]);
> +	lm90_select_remote_channel(client, data, 0);
> +
>  	mutex_unlock(&data->update_lock);
>  	return count;
>  }
> @@ -451,10 +478,13 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>  	struct {
>  		u8 high;
>  		u8 low;
> -	} reg[3] = {
> -		{ LM90_REG_W_REMOTE_LOWH, LM90_REG_W_REMOTE_LOWL },
> -		{ LM90_REG_W_REMOTE_HIGHH, LM90_REG_W_REMOTE_HIGHL },
> -		{ LM90_REG_W_REMOTE_OFFSH, LM90_REG_W_REMOTE_OFFSL }
> +		int channel;
> +	} reg[5] = {
> +		{ LM90_REG_W_REMOTE_LOWH, LM90_REG_W_REMOTE_LOWL, 0 },
> +		{ LM90_REG_W_REMOTE_HIGHH, LM90_REG_W_REMOTE_HIGHL, 0 },
> +		{ LM90_REG_W_REMOTE_OFFSH, LM90_REG_W_REMOTE_OFFSL, 0 },
> +		{ LM90_REG_W_REMOTE_LOWH, LM90_REG_W_REMOTE_LOWL, 1 },
> +		{ LM90_REG_W_REMOTE_HIGHH, LM90_REG_W_REMOTE_HIGHL, 1 }
>  	};
>  
>  	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
> @@ -483,11 +513,14 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>  	else
>  		data->temp11[index] = temp_to_s16(val);
>  
> +	lm90_select_remote_channel(client, data, reg[nr].channel);
>  	i2c_smbus_write_byte_data(client, reg[nr].high,
>  				  data->temp11[index] >> 8);
>  	if (data->flags & LM90_HAVE_REM_LIMIT_EXT)
>  		i2c_smbus_write_byte_data(client, reg[nr].low,
>  					  data->temp11[index] & 0xff);
> +	lm90_select_remote_channel(client, data, 0);
> +
>  	mutex_unlock(&data->update_lock);
>  	return count;
>  }
> @@ -635,6 +668,59 @@ static const struct attribute_group lm90_emergency_group = {
>  	.attrs = lm90_emergency_attributes,
>  };
>  
> +static SENSOR_DEVICE_ATTR(temp1_emergency_alarm, S_IRUGO, show_alarm, NULL, 15);
> +static SENSOR_DEVICE_ATTR(temp2_emergency_alarm, S_IRUGO, show_alarm, NULL, 13);
> +
> +static struct attribute *lm90_emergency_alarm_attributes[] = {
> +	&sensor_dev_attr_temp1_emergency_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp2_emergency_alarm.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group lm90_emergency_alarm_group = {
> +	.attrs = lm90_emergency_alarm_attributes,
> +};
> +
> +/*
> + * Additional attributes for devices with 3 temperature sensors
> + */
> +static SENSOR_DEVICE_ATTR_2(temp3_input, S_IRUGO, show_temp11, NULL, 0, 5);
> +static SENSOR_DEVICE_ATTR_2(temp3_min, S_IWUSR | S_IRUGO, show_temp11,
> +	set_temp11, 3, 6);
> +static SENSOR_DEVICE_ATTR_2(temp3_max, S_IWUSR | S_IRUGO, show_temp11,
> +	set_temp11, 4, 7);
> +static SENSOR_DEVICE_ATTR(temp3_crit, S_IWUSR | S_IRUGO, show_temp8,
> +	set_temp8, 6);
> +static SENSOR_DEVICE_ATTR(temp3_crit_hyst, S_IRUGO, show_temphyst, NULL, 4);

4, really? Remote 2 critical limit is 6.

(That's what we get for using bare numbers instead of defining proper
symbols, sigh.)

Also it seems that the hysteresis register applies to both critical and
emergency limits, so it would probably make sense to create (read-only)
temp[1-3]_emergency_hyst attributes.

> +static SENSOR_DEVICE_ATTR(temp3_emergency, S_IWUSR | S_IRUGO, show_temp8,
> +	set_temp8, 7);
> +
> +static SENSOR_DEVICE_ATTR(temp3_crit_alarm, S_IRUGO, show_alarm, NULL, 9);
> +static SENSOR_DEVICE_ATTR(temp3_fault, S_IRUGO, show_alarm, NULL, 10);
> +static SENSOR_DEVICE_ATTR(temp3_min_alarm, S_IRUGO, show_alarm, NULL, 11);
> +static SENSOR_DEVICE_ATTR(temp3_max_alarm, S_IRUGO, show_alarm, NULL, 12);
> +static SENSOR_DEVICE_ATTR(temp3_emergency_alarm, S_IRUGO, show_alarm, NULL, 14);
> +
> +static struct attribute *lm90_temp3_attributes[] = {
> +	&sensor_dev_attr_temp3_input.dev_attr.attr,
> +	&sensor_dev_attr_temp3_min.dev_attr.attr,
> +	&sensor_dev_attr_temp3_max.dev_attr.attr,
> +	&sensor_dev_attr_temp3_crit.dev_attr.attr,
> +	&sensor_dev_attr_temp3_crit_hyst.dev_attr.attr,
> +	&sensor_dev_attr_temp3_emergency.dev_attr.attr,
> +
> +	&sensor_dev_attr_temp3_fault.dev_attr.attr,
> +	&sensor_dev_attr_temp3_min_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp3_max_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp3_crit_alarm.dev_attr.attr,
> +	&sensor_dev_attr_temp3_emergency_alarm.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group lm90_temp3_group = {
> +	.attrs = lm90_temp3_attributes,
> +};
> +
>  /* pec used for ADM1032 only */
>  static ssize_t show_pec(struct device *dev, struct device_attribute *dummy,
>  			char *buf)
> @@ -674,6 +760,22 @@ static DEVICE_ATTR(pec, S_IWUSR | S_IRUGO, show_pec, set_pec);
>   * Real code
>   */
>  

Please document the fact that the following function must be called
with data->update_lock held.

> +static inline void lm90_select_remote_channel(struct i2c_client *client,
> +					      struct lm90_data *data,
> +					      int channel)
> +{
> +	u8 config;
> +
> +	if (data->kind == max6695) {
> +		lm90_read_reg(client, LM90_REG_R_CONFIG1, &config);
> +		config &= ~0x08;
> +		if (channel)
> +			config |= 0x08;
> +		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
> +					  config);
> +	}
> +}
> +
>  /*
>   * The ADM1032 supports PEC but not on write byte transactions, so we need
>   * to explicitly ask for a transaction without PEC.
> @@ -786,6 +888,23 @@ static int lm90_detect(struct i2c_client *new_client,
>  		}
>  	} else
>  	if (man_id == 0x4D) { /* Maxim */
> +		int reg_emerg, reg_emerg2, reg_status2;
> +
> +		/*
> +		 * We read MAX6659_REG_R_REMOTE_EMERG twice, and re-read
> +		 * LM90_REG_R_MAN_ID in between. If MAX6659_REG_R_REMOTE_EMERG
> +		 * exists, both readings will reflect the same value. Otherwise,
> +		 * the readings will be different.
> +		 */
> +		if ((reg_emerg = i2c_smbus_read_byte_data(new_client,
> +						MAX6659_REG_R_REMOTE_EMERG)) < 0
> +		 || i2c_smbus_read_byte_data(new_client, LM90_REG_R_MAN_ID) < 0
> +		 || (reg_emerg2 = i2c_smbus_read_byte_data(new_client,
> +						MAX6659_REG_R_REMOTE_EMERG)) < 0
> +		 || (reg_status2 = i2c_smbus_read_byte_data(new_client,
> +						MAX6695_REG_R_STATUS2)) < 0)
> +			return -ENODEV;
> +
>  		/*
>  		 * The MAX6657, MAX6658 and MAX6659 do NOT have a chip_id
>  		 * register. Reading from that address will return the last
> @@ -809,6 +928,24 @@ static int lm90_detect(struct i2c_client *new_client,
>  				name = "max6659";
>  		} else
>  		/*
> +		 * Even though MAX6695 and MAX6696 do not have a chip ID
> +		 * register, reading it returns 0x01. Bit 4 of the config1
> +		 * register is unused and should return zero when read. Bit 0 of
> +		 * the status2 register is unused and should return zero when
> +		 * read.
> +		 *
> +		 * MAX6695 and MAX6696 have an additional set of temperature
> +		 * limit registers. We can detect those chips by checking if
> +		 * one of those registers exists.
> +		 */
> +		if (chip_id == 0x01
> +		 && (reg_config1 & 0x10) == 0x00
> +		 && (reg_status2 & 0x01) == 0x00
> +		 && reg_emerg == reg_emerg2
> +		 && reg_convrate <= 0x07) {
> +			name = "max6695";
> +		} else
> +		/*
>  		 * The chip_id register of the MAX6680 and MAX6681 holds the
>  		 * revision of the chip. The lowest bit of the config1 register
>  		 * is unused and should return zero when read, so should the
> @@ -853,6 +990,11 @@ static int lm90_detect(struct i2c_client *new_client,
>  
>  static void lm90_remove_files(struct i2c_client *client, struct lm90_data *data)
>  {
> +	if (data->flags & LM90_HAVE_TEMP3)
> +		sysfs_remove_group(&client->dev.kobj, &lm90_temp3_group);
> +	if (data->flags & LM90_HAVE_EMERGENCY_ALARM)
> +		sysfs_remove_group(&client->dev.kobj,
> +				   &lm90_emergency_alarm_group);
>  	if (data->flags & LM90_HAVE_EMERGENCY)
>  		sysfs_remove_group(&client->dev.kobj,
>  				   &lm90_emergency_group);
> @@ -893,6 +1035,9 @@ static int lm90_probe(struct i2c_client *new_client,
>  	case lm86:
>  		data->alert_alarms = 0x7b;
>  		break;
> +	case max6695:
> +		data->alert_alarms = 0x187c;
> +		break;
>  	default:
>  		data->alert_alarms = 0x7c;
>  		break;
> @@ -900,20 +1045,24 @@ static int lm90_probe(struct i2c_client *new_client,
>  
>  	/* Set chip capabilities */
>  	if (data->kind != max6657 && data->kind != max6659
> -	    && data->kind != max6646)
> +	    && data->kind != max6646 && data->kind != max6695)
>  		data->flags |= LM90_HAVE_OFFSET;
>  
>  	if (data->kind == max6657 || data->kind == max6659
> -	    || data->kind == max6646)
> +	    || data->kind == max6646 || data->kind == max6695)
>  		data->flags |= LM90_HAVE_LOCAL_EXT;
>  
>  	if (data->kind != max6657 && data->kind != max6659
> -	    && data->kind != max6646 && data->kind != max6680)
> +	    && data->kind != max6646 && data->kind != max6680
> +	    && data->kind != max6695)
>  		data->flags |= LM90_HAVE_REM_LIMIT_EXT;
>  
> -	if (data->kind == max6659)
> +	if (data->kind == max6659 || data->kind == max6695)
>  		data->flags |= LM90_HAVE_EMERGENCY;
>  
> +	if (data->kind == max6695)
> +		data->flags |= LM90_HAVE_EMERGENCY_ALARM | LM90_HAVE_TEMP3;
> +
>  	/* Initialize the LM90 chip */
>  	lm90_init_client(new_client);
>  
> @@ -938,6 +1087,18 @@ static int lm90_probe(struct i2c_client *new_client,
>  		if (err)
>  			goto exit_remove_files;
>  	}
> +	if (data->flags & LM90_HAVE_EMERGENCY_ALARM) {
> +		err = sysfs_create_group(&new_client->dev.kobj,
> +					 &lm90_emergency_alarm_group);
> +		if (err)
> +			goto exit_remove_files;
> +	}
> +	if (data->flags & LM90_HAVE_TEMP3) {
> +		err = sysfs_create_group(&new_client->dev.kobj,
> +					 &lm90_temp3_group);
> +		if (err)
> +			goto exit_remove_files;
> +	}
>  
>  	data->hwmon_dev = hwmon_device_register(&new_client->dev);
>  	if (IS_ERR(data->hwmon_dev)) {
> @@ -985,6 +1146,12 @@ static void lm90_init_client(struct i2c_client *client)
>  	if (data->kind == max6680)
>  		config |= 0x18;
>  
> +	/*
> +	 * Select external channel 1 for max6695
> +	 */
> +	if (data->kind == max6695)
> +		config &= ~0x08;
> +
>  	config &= 0xBF;	/* run */
>  	if (config != data->config_orig) /* Only write if changed */
>  		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, config);
> @@ -1008,10 +1175,14 @@ static int lm90_remove(struct i2c_client *client)
>  static void lm90_alert(struct i2c_client *client, unsigned int flag)
>  {
>  	struct lm90_data *data = i2c_get_clientdata(client);
> -	u8 config, alarms;
> +	u8 config, alarms, alarms2 = 0;
>  
>  	lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
> -	if ((alarms & 0x7f) == 0) {
> +
> +	if (data->kind == max6695)
> +		lm90_read_reg(client, MAX6695_REG_R_STATUS2, &alarms2);
> +
> +	if ((alarms & 0x7f) == 0 && (alarms2 & 0xfe) == 0) {
>  		dev_info(&client->dev, "Everything OK\n");
>  	} else {
>  		if (alarms & 0x61)
> @@ -1024,6 +1195,10 @@ static void lm90_alert(struct i2c_client *client, unsigned int flag)
>  			dev_warn(&client->dev,
>  				 "temp%d diode open, please check!\n", 2);
>  
> +		if (alarms2 & 0x18)
> +			dev_warn(&client->dev,
> +				 "temp%d out of range, please check!\n", 3);
> +
>  		/* Disable ALERT# output, because these chips don't implement
>  		  SMBus alert correctly; they should only hold the alert line
>  		  low briefly. */
> @@ -1079,6 +1254,7 @@ static struct lm90_data *lm90_update_device(struct device *dev)
>  	if (time_after(jiffies, data->last_updated + HZ / 2 + HZ / 10)
>  	 || !data->valid) {
>  		u8 h, l;
> +		u8 alarms;
>  
>  		dev_dbg(&client->dev, "Updating lm90 data.\n");
>  		lm90_read_reg(client, LM90_REG_R_LOCAL_LOW, &data->temp8[0]);
> @@ -1127,7 +1303,27 @@ static struct lm90_data *lm90_update_device(struct device *dev)
>  			lm90_read_reg(client, MAX6659_REG_R_REMOTE_EMERG,
>  				      &data->temp8[5]);
>  		}
> -		lm90_read_reg(client, LM90_REG_R_STATUS, &data->alarms);
> +		lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
> +		data->alarms = alarms;	/* save as 16 bit value */
> +
> +		if (data->kind == max6695) {
> +			lm90_select_remote_channel(client, data, 1);
> +			lm90_read_reg(client, LM90_REG_R_REMOTE_CRIT,
> +				      &data->temp8[6]);
> +			lm90_read_reg(client, MAX6659_REG_R_REMOTE_EMERG,
> +				      &data->temp8[7]);
> +			lm90_read16(client, LM90_REG_R_REMOTE_TEMPH,
> +				    LM90_REG_R_REMOTE_TEMPL, &data->temp11[5]);
> +			if (!lm90_read_reg(client, LM90_REG_R_REMOTE_LOWH, &h))
> +				data->temp11[6] = h << 8;
> +			if (!lm90_read_reg(client, LM90_REG_R_REMOTE_HIGHH, &h))
> +				data->temp11[7] = h << 8;
> +			lm90_select_remote_channel(client, data, 0);
> +
> +			if (!lm90_read_reg(client, MAX6695_REG_R_STATUS2,
> +					   &alarms))
> +				data->alarms |= alarms << 8;
> +		}
>  
>  		/* Re-enable ALERT# output if it was originally enabled and
>  		 * relevant alarms are all clear */

Code looks overall pretty clean. Great job!

-- 
Jean Delvare
