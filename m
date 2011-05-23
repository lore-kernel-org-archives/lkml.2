Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab1EWEjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 00:39:24 -0400
Received: from imr3.ericy.com ([198.24.6.13]:52381 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1EWEjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 00:39:20 -0400
Date: Sun, 22 May 2011 21:37:11 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "sdevrien@cisco.com" <sdevrien@cisco.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH] Add support for the Philips SA56004
 temperature sensor.
Message-ID: <20110523043711.GA4890@ericsson.com>
References: <1305814253-12528-1-git-send-email-sdevrien@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1305814253-12528-1-git-send-email-sdevrien@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:10:53AM -0400, sdevrien@cisco.com wrote:
> From: Stijn Devriendt <sdevrien@cisco.com>
> 
> Add support for the Philips SA56004, an LM86
> compatible temperature sensor.
> 
> Signed-off-by: Stijn Devriendt <sdevrien@cisco.com>
> ---
>  drivers/hwmon/Kconfig |    2 +-
>  drivers/hwmon/lm90.c  |   47 ++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 45 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 50e40db..11c9339 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -620,7 +620,7 @@ config SENSORS_LM90
>  	  LM86, LM89 and LM99, Analog Devices ADM1032, ADT7461, and ADT7461A,
>  	  Maxim MAX6646, MAX6647, MAX6648, MAX6649, MAX6657, MAX6658, MAX6659,
>  	  MAX6680, MAX6681, MAX6692, MAX6695, MAX6696, ON Semiconductor NCT1008,
> -	  and Winbond/Nuvoton W83L771W/G/AWG/ASG sensor chips.
> +	  Winbond/Nuvoton W83L771W/G/AWG/ASG and Philips SA56004 sensor chips.
>  
Please also update Documentation/hwmon/lm90.

>  	  This driver can also be built as a module.  If so, the module
>  	  will be called lm90.
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index 2f94f95..2910791 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c
> @@ -54,6 +54,9 @@
>   * and extended mode. They are mostly compatible with LM90 except for a data
>   * format difference for the temperature value registers.
>   *
> + * This driver also supports the SA56004 from Philips. This device is
> + * pin-compatible with the LM86, the ED/EDP parts are also address-compatible.
> + *
>   * Since the LM90 was the first chipset supported by this driver, most
>   * comments will refer to this chipset, but are actually general and
>   * concern all supported chipsets, unless mentioned otherwise.
> @@ -96,13 +99,15 @@
>   * MAX6659 can have address 0x4c, 0x4d or 0x4e.
>   * MAX6680 and MAX6681 can have address 0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b,
>   * 0x4c, 0x4d or 0x4e.
> + * SA56004 can have address 0x48 through 0x4F.
>   */
>  
>  static const unsigned short normal_i2c[] = {
> -	0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b, 0x4c, 0x4d, 0x4e, I2C_CLIENT_END };
> +	0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 
> +	0x4d, 0x4e, 0x4f, I2C_CLIENT_END };
>  
>  enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
> -	max6646, w83l771, max6696 };
> +	max6646, w83l771, max6696, sa56004 };
>  
>  /*
>   * The LM90 registers
> @@ -152,6 +157,10 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
>  #define MAX6659_REG_R_LOCAL_EMERG	0x17
>  #define MAX6659_REG_W_LOCAL_EMERG	0x17
>  
> +/*  SA56004 registers */
> +
> +#define SA56004_REG_R_LOCAL_TEMPL 0x22
> +
>  #define LM90_DEF_CONVRATE_RVAL	6	/* Def conversion rate register value */
>  #define LM90_MAX_CONVRATE_MS	16000	/* Maximum conversion rate in ms */
>  
> @@ -192,6 +201,7 @@ static const struct i2c_device_id lm90_id[] = {
>  	{ "max6696", max6696 },
>  	{ "nct1008", adt7461 },
>  	{ "w83l771", w83l771 },
> +	{ "sa56004", sa56004 },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(i2c, lm90_id);
> @@ -204,6 +214,8 @@ struct lm90_params {
>  	u16 alert_alarms;	/* Which alarm bits trigger ALERT# */
>  				/* Upper 8 bits for max6695/96 */
>  	u8 max_convrate;	/* Maximum conversion rate register value */
> +	u8 local_ext_offset;	/* Local extension register if 
> +				   LM90_HAVE_LOCAL_EXT is set*/

I really dislike this variable name. "offset" is used as "temperature offset"
in the driver, and means a temperature offset, not a register offset (from 0).
Something like reg_local_ext or reg_local_templ would be better.

>  };
>  
>  static const struct lm90_params lm90_params[] = {
> @@ -238,6 +250,7 @@ static const struct lm90_params lm90_params[] = {
>  		.flags = LM90_HAVE_LOCAL_EXT,
>  		.alert_alarms = 0x7c,
>  		.max_convrate = 6,
> +		.local_ext_offset = MAX6657_REG_R_LOCAL_TEMPL,
>  	},
>  	[max6657] = {
>  		.flags = LM90_HAVE_LOCAL_EXT,
> @@ -248,6 +261,7 @@ static const struct lm90_params lm90_params[] = {
>  		.flags = LM90_HAVE_LOCAL_EXT | LM90_HAVE_EMERGENCY,
>  		.alert_alarms = 0x7c,
>  		.max_convrate = 8,
> +		.local_ext_offset = MAX6657_REG_R_LOCAL_TEMPL,
>  	},
>  	[max6680] = {
>  		.flags = LM90_HAVE_OFFSET,
> @@ -259,12 +273,20 @@ static const struct lm90_params lm90_params[] = {
>  		  | LM90_HAVE_EMERGENCY_ALARM | LM90_HAVE_TEMP3,
>  		.alert_alarms = 0x187c,
>  		.max_convrate = 6,
> +		.local_ext_offset = MAX6657_REG_R_LOCAL_TEMPL,
>  	},
>  	[w83l771] = {
>  		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT,
>  		.alert_alarms = 0x7c,
>  		.max_convrate = 8,
>  	},
> +	[sa56004] = {
> +		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
> +		  | LM90_HAVE_LOCAL_EXT,
> +		.alert_alarms = 0x7b,
> +		.max_convrate = 9,
> +		.local_ext_offset = SA56004_REG_R_LOCAL_TEMPL,
> +	},
>  };
>  
>  /*
> @@ -286,6 +308,7 @@ struct lm90_data {
>  	u16 alert_alarms;	/* Which alarm bits trigger ALERT# */
>  				/* Upper 8 bits for max6695/96 */
>  	u8 max_convrate;	/* Maximum conversion rate */
> +	u8 local_ext_offset;	/* local extension register offset */
>  
Same here (variable name).

>  	/* registers values */
>  	s8 temp8[8];	/* 0: local low limit
> @@ -454,7 +477,7 @@ static struct lm90_data *lm90_update_device(struct device *dev)
>  
>  		if (data->flags & LM90_HAVE_LOCAL_EXT) {
>  			lm90_read16(client, LM90_REG_R_LOCAL_TEMP,
> -				    MAX6657_REG_R_LOCAL_TEMPL,
> +				    data->local_ext_offset,
>  				    &data->temp11[4]);
>  		} else {
>  			if (lm90_read_reg(client, LM90_REG_R_LOCAL_TEMP,
> @@ -1263,6 +1286,12 @@ static int lm90_detect(struct i2c_client *new_client,
>  				name = "w83l771";
>  			}
>  		}
> +	} else
> +	if (man_id == 0xA1) { /*  NXP Semiconductor/Philips */
> +		if (chip_id == 0x00
> +		 && address >= 0x48 && address <= 0x4F) {

This multi-line split is unnecessary.

> +			name = "sa56004";
> +		}
>  	}
>  
>  	if (!name) { /* identification failed */
> @@ -1372,6 +1401,18 @@ static int lm90_probe(struct i2c_client *new_client,
>  	/* Set maximum conversion rate */
>  	data->max_convrate = lm90_params[data->kind].max_convrate;
>  
> +	if (data->flags & LM90_HAVE_LOCAL_EXT) {
> +		if (lm90_params[data->kind].local_ext_offset > 0)
> +			data->local_ext_offset = 
> +				lm90_params[data->kind].local_ext_offset;
> +		else {
> +			dev_err(&new_client->dev,
> +			  "Invalid temperature extension register. "
> +			  "Accuracy may be limited.\n");
> +			data->flags &= (~LM90_HAVE_LOCAL_EXT);
> +		}

Either { } in both branches of the if statement, or none.
( ) around ~LM90_HAVE_LOCAL_EXT is unnecessary.

I see it as BUG if LM90_HAVE_LOCAL_EXT is set but local_ext_offset isn't.
That should be found during coding (or code review), and not be exported
to the user. So, from my perspective, the check is unnecessary. I'll leave
that up to Jean to decide, though.

In addition to the above, your patch generates several checkpatch errors
(trailing whitespace). Please fix.

Thanks,
Guenter
