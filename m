Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab2JBBTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 21:19:33 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57556 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2JBBTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 21:19:32 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 1 Oct 2012 18:20:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org,
        Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        Steve Hardy <shardy@redhat.com>
Subject: Re: [PATCH v2 2/2] hwmon: (ads7828) add support for ADS7830
Message-ID: <20121002012007.GC2437@roeck-us.net>
References: <1349133384-5181-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1349133384-5181-2-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349133384-5181-2-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 07:16:24PM -0400, Vivien Didelot wrote:
> From: Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>
> 
> The ADS7830 device is almost the same as the ADS7828,
> except that it does 8-bit sampling, instead of 12-bit.
> This patch extends the ads7828 driver to support this chip.
> 
> Signed-off-by: Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Hi Guillaume,
Hi Vivien,

couple of comments below.

> ---
>  Documentation/hwmon/ads7828 | 12 ++++++++--
>  drivers/hwmon/Kconfig       |  7 +++---
>  drivers/hwmon/ads7828.c     | 58 ++++++++++++++++++++++++++++++++-------------
>  3 files changed, 55 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/hwmon/ads7828 b/Documentation/hwmon/ads7828
> index 2bbebe6..4366a87 100644
> --- a/Documentation/hwmon/ads7828
> +++ b/Documentation/hwmon/ads7828
> @@ -8,8 +8,15 @@ Supported chips:
>      Datasheet: Publicly available at the Texas Instruments website :
>                 http://focus.ti.com/lit/ds/symlink/ads7828.pdf
>  
> +  * Texas Instruments ADS7830
> +    Prefix: 'ads7830'
> +    Addresses scanned: I2C 0x48, 0x49, 0x4a, 0x4b
> +    Datasheet: Publicly available at the Texas Instruments website:
> +               http://focus.ti.com/lit/ds/symlink/ads7830.pdf
> +
>  Authors:
>          Steve Hardy <shardy@redhat.com>
> +        Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>
>  
>  Module Parameters
>  -----------------
> @@ -24,9 +31,10 @@ Module Parameters
>  Description
>  -----------
>  
> -This driver implements support for the Texas Instruments ADS7828.
> +This driver implements support for the Texas Instruments ADS7828, and ADS7830.
>  

s/,//

> -This device is a 12-bit 8-channel A-D converter.
> +The ADS7828 device is a 12-bit 8-channel A/D converter, while the ADS7830 does
> +8-bit sampling.
>  
>  It can operate in single ended mode (8 +ve inputs) or in differential mode,
>  where 4 differential pairs can be measured.
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 83e3e9d..960c8c5 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1060,11 +1060,12 @@ config SENSORS_ADS1015
>  	  will be called ads1015.
>  
>  config SENSORS_ADS7828
> -	tristate "Texas Instruments ADS7828"
> +	tristate "Texas Instruments ADS7828 and compatibles"
>  	depends on I2C
>  	help
> -	  If you say yes here you get support for Texas Instruments ADS7828
> -	  12-bit 8-channel ADC device.
> +	  If you say yes here you get support for Texas Instruments ADS7828 and
> +	  ADS7830 8-channel A/D converters. ADS7828 resolution is 12-bit, while
> +	  it is 8-bit on ADS7830.
>  
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called ads7828.
> diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
> index fb3010d..91fc629 100644
> --- a/drivers/hwmon/ads7828.c
> +++ b/drivers/hwmon/ads7828.c
> @@ -1,11 +1,13 @@
>  /*
> - * ads7828.c - lm_sensors driver for ads7828 12-bit 8-channel ADC
> + * ads7828.c - driver for TI ADS7828 8-channel A/D converter and compatibles
>   * (C) 2007 EADS Astrium
>   *
>   * This driver is based on the lm75 and other lm_sensors/hwmon drivers
>   *
>   * Written by Steve Hardy <shardy@redhat.com>
>   *
> + * ADS7830 support by Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>
> + *
>   * For further information, see the Documentation/hwmon/ads7828 file.
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -41,6 +43,9 @@
>  #define ADS7828_CMD_PD3		0x0C	/* Internal ref ON && A/D ON */
>  #define ADS7828_INT_VREF_MV	2500	/* Internal vref is 2.5V, 2500mV */
>  
> +/* List of supported devices */
> +enum ads7828_chips { ads7828, ads7830 };
> +
>  /* Addresses to scan */
>  static const unsigned short normal_i2c[] = { 0x48, 0x49, 0x4a, 0x4b,
>  	I2C_CLIENT_END };
> @@ -53,9 +58,7 @@ module_param(se_input, bool, S_IRUGO);
>  module_param(int_vref, bool, S_IRUGO);
>  module_param(vref_mv, int, S_IRUGO);
>  
> -/* Global Variables */
>  static u8 ads7828_cmd_byte; /* cmd byte without channel bits */

At some point we may have to look into the configuration ... using module
parameters doesn't seem to be right here. Should be platform data or device
tree. But that is for later ... just something to keep in mind.

> -static unsigned int ads7828_lsb_resol; /* resolution of the ADC sample lsb */
>  
>  /**
>   * struct ads7828_data - client specific data
> @@ -64,6 +67,8 @@ static unsigned int ads7828_lsb_resol; /* resolution of the ADC sample lsb */
>   * @valid:		Validity flag.
>   * @last_updated:	Last updated time (in jiffies).
>   * @adc_input:		ADS7828_NCH samples.
> + * @lsb_resol:		Resolution of the A/D converter sample LSB.
> + * @read_channel:	Function used to read a channel.
>   */
>  struct ads7828_data {
>  	struct device *hwmon_dev;
> @@ -71,6 +76,8 @@ struct ads7828_data {
>  	char valid;
>  	unsigned long last_updated;
>  	u16 adc_input[ADS7828_NCH];
> +	unsigned int lsb_resol;
> +	s32 (*read_channel)(const struct i2c_client *client, u8 command);
>  };
>  
>  static inline u8 channel_cmd_byte(int ch)
> @@ -96,8 +103,7 @@ static struct ads7828_data *ads7828_update_device(struct device *dev)
>  
>  		for (ch = 0; ch < ADS7828_NCH; ch++) {
>  			u8 cmd = channel_cmd_byte(ch);
> -			data->adc_input[ch] =
> -				i2c_smbus_read_word_swapped(client, cmd);
> +			data->adc_input[ch] = data->read_channel(client, cmd);
>  		}
>  		data->last_updated = jiffies;
>  		data->valid = 1;
> @@ -115,8 +121,8 @@ static ssize_t show_in(struct device *dev, struct device_attribute *da,
>  	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
>  	struct ads7828_data *data = ads7828_update_device(dev);
>  	/* Print value (in mV as specified in sysfs-interface documentation) */
> -	return sprintf(buf, "%d\n", (data->adc_input[attr->index] *
> -		ads7828_lsb_resol)/1000);
> +	return sprintf(buf, "%d\n",
> +		       (data->adc_input[attr->index] * data->lsb_resol) / 1000);
>  }
>  
>  #define in_reg(offset) \
> @@ -162,6 +168,7 @@ static int ads7828_detect(struct i2c_client *client,
>  {
>  	struct i2c_adapter *adapter = client->adapter;
>  	int ch;
> +	bool is_8bit = false;
>  
>  	/* Check we have a valid client */
>  	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_READ_WORD_DATA))
> @@ -172,20 +179,30 @@ static int ads7828_detect(struct i2c_client *client,
>  	 * dedicated register so attempt to sanity check using knowledge of
>  	 * the chip
>  	 * - Read from the 8 channel addresses
> -	 * - Check the top 4 bits of each result are not set (12 data bits)
> +	 * - Check the top 4 bits of each result:
> +	 *   - They should not be set in case of 12-bit samples
> +	 *   - The two bytes should be equal in case of 8-bit samples
>  	 */
>  	for (ch = 0; ch < ADS7828_NCH; ch++) {
>  		u16 in_data;
>  		u8 cmd = channel_cmd_byte(ch);
>  		in_data = i2c_smbus_read_word_swapped(client, cmd);

What if it is < 0, ie if there was a read error since the device does not exist ?

in_data should be defined as int, and you should check for an error and
abort if there is one (previously that was covered in the "& 0xF000", but that
is no longer the case).

>  		if (in_data & 0xF000) {
> -			pr_debug("%s : Doesn't look like an ads7828 device\n",
> -				 __func__);
> -			return -ENODEV;
> +			if ((in_data >> 8) == (in_data & 0xFF)) {
> +				/* Seems to be an ADS7830 (8-bit sample) */
> +				is_8bit = true;
> +			} else {
> +				dev_dbg(&client->dev, "doesn't look like an "
> +					"ADS7828 compatible device\n");

WARNING: quoted string split across lines
#190: FILE: drivers/hwmon/ads7828.c:196:
+                               dev_dbg(&client->dev, "doesn't look like an "
+                                       "ADS7828 compatible device\n");

Better:
				dev_dbg(&client->dev,
					"doesn't look like an ADS7828 compatible device\n");

> +				return -ENODEV;
> +			}
>  		}
>  	}
>  
> -	strlcpy(info->type, "ads7828", I2C_NAME_SIZE);
> +	if (is_8bit)
> +		strlcpy(info->type, "ads7830", I2C_NAME_SIZE);
> +	else
> +		strlcpy(info->type, "ads7828", I2C_NAME_SIZE);
>  
>  	return 0;
>  }
> @@ -202,6 +219,15 @@ static int ads7828_probe(struct i2c_client *client,
>  		goto exit;
>  	}
>  
> +	/* ADS7828 uses 12-bit samples, while ADS7830 is 8-bit */
> +	if (id->driver_data == ads7828) {
> +		data->read_channel = i2c_smbus_read_word_swapped;
> +		data->lsb_resol = (vref_mv * 1000) / 4096;
> +	} else {
> +		data->read_channel = i2c_smbus_read_byte_data;
> +		data->lsb_resol = (vref_mv * 1000) / 256;

Just wondering ... does that introduce a rounding error ?
Would DIV_ROUND_CLOSEST be better ?

> +	}
> +
>  	i2c_set_clientdata(client, data);
>  	mutex_init(&data->update_lock);
>  
> @@ -227,7 +253,8 @@ exit:
>  }
>  
>  static const struct i2c_device_id ads7828_ids[] = {
> -	{ "ads7828", 0 },
> +	{ "ads7828", ads7828 },
> +	{ "ads7830", ads7830 },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(i2c, ads7828_ids);
> @@ -250,9 +277,6 @@ static int __init sensors_ads7828_init(void)
>  	ads7828_cmd_byte = se_input ? ADS7828_CMD_SD_SE : ADS7828_CMD_SD_DIFF;
>  	ads7828_cmd_byte |= int_vref ? ADS7828_CMD_PD3 : ADS7828_CMD_PD1;
>  
> -	/* Calculate the LSB resolution */
> -	ads7828_lsb_resol = (vref_mv*1000)/4096;
> -
>  	return i2c_add_driver(&ads7828_driver);
>  }
>  
> @@ -262,7 +286,7 @@ static void __exit sensors_ads7828_exit(void)
>  }
>  
>  MODULE_AUTHOR("Steve Hardy <shardy@redhat.com>");
> -MODULE_DESCRIPTION("Driver for TI ADS7828 A/D converter");
> +MODULE_DESCRIPTION("Driver for TI ADS7828 A/D converter and compatibles");
>  MODULE_LICENSE("GPL");
>  
>  module_init(sensors_ads7828_init);
> -- 
> 1.7.11.4
> 
> 
