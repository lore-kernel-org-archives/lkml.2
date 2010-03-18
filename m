Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0CRHll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 03:41:41 -0400
Received: from poutre.nerim.net ([62.4.16.124]:63615 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab0CRHlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 03:41:40 -0400
Date: Thu, 18 Mar 2010 08:41:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Add basic support for lm64 to
 lm63.c
Message-ID: <20100318084135.15fb1996@hyperion.delvare>
In-Reply-To: <1268855722-18457-1-git-send-email-mjg@redhat.com>
References: <1268855722-18457-1-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Wed, 17 Mar 2010 15:55:22 -0400, Matthew Garrett wrote:
> The lm64 appears to be an lm63 with added gpio lines. Add support for the
> hwmon functionality - gpio can be added at some later stage if someone
> has a need for them.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  Documentation/hwmon/lm63 |    7 +++++++
>  drivers/hwmon/lm63.c     |   19 +++++++++++++++----
>  2 files changed, 22 insertions(+), 4 deletions(-)

Can you please send me a dump of your LM64 chip?

Review:

> 
> diff --git a/Documentation/hwmon/lm63 b/Documentation/hwmon/lm63
> index 31660bf..b6f0495 100644
> --- a/Documentation/hwmon/lm63
> +++ b/Documentation/hwmon/lm63
> @@ -7,6 +7,11 @@ Supported chips:
>      Addresses scanned: I2C 0x4c
>      Datasheet: Publicly available at the National Semiconductor website
>                 http://www.national.com/pf/LM/LM63.html
> +  * National Semiconductor LM64
> +    Prefix: 'lm64'
> +    Addresses scanned: I2C 0x18 and 0x4e
> +    Datasheet: Publicly available at the National Semiconductor website
> +               http://www.national.com/pf/LM/LM64.html
>  
>  Author: Jean Delvare <khali@linux-fr.org>
>  
> @@ -55,3 +60,5 @@ The lm63 driver will not update its values more frequently than every
>  second; reading them more often will do no harm, but will return 'old'
>  values.
>  
> +The lm64 is effectively an lm63 with gpio lines. The driver does not
> +support these gpio lines at present.

Please use "LM64" and "LM63" when referring to the devices themselves.
And spell GPIO with capitals, too. Same applies to the patch
description, BTW.

> \ No newline at end of file

Please add the missing newline.

> diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
> index bf81aff..01b23ef 100644
> --- a/drivers/hwmon/lm63.c
> +++ b/drivers/hwmon/lm63.c
> @@ -53,7 +53,7 @@
>   * Address is fully defined internally and cannot be changed.
>   */
>  
> -static const unsigned short normal_i2c[] = { 0x4c, I2C_CLIENT_END };
> +static const unsigned short normal_i2c[] = { 0x18, 0x4c, 0x4e, I2C_CLIENT_END };
>  
>  /*
>   * The LM63 registers
> @@ -131,12 +131,15 @@ static struct lm63_data *lm63_update_device(struct device *dev);
>  static int lm63_detect(struct i2c_client *client, struct i2c_board_info *info);
>  static void lm63_init_client(struct i2c_client *client);
>  
> +enum chips { lm63, lm64 };
> +
>  /*
>   * Driver data (common to all clients)
>   */
>  
>  static const struct i2c_device_id lm63_id[] = {
> -	{ "lm63", 0 },
> +	{ "lm63", lm63 },
> +	{ "lm64", lm64 },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(i2c, lm63_id);
> @@ -177,6 +180,7 @@ struct lm63_data {
>  			   2: remote high limit */
>  	u8 temp2_crit_hyst;
>  	u8 alarms;
> +	int kind;
>  };
>  
>  /*
> @@ -422,6 +426,7 @@ static int lm63_detect(struct i2c_client *new_client,
>  	struct i2c_adapter *adapter = new_client->adapter;
>  	u8 man_id, chip_id, reg_config1, reg_config2;
>  	u8 reg_alert_status, reg_alert_mask;
> +	int address = new_client->addr;
>  
>  	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
>  		return -ENODEV;
> @@ -439,7 +444,6 @@ static int lm63_detect(struct i2c_client *new_client,
>  			 LM63_REG_ALERT_MASK);
>  
>  	if (man_id != 0x01 /* National Semiconductor */
> -	 || chip_id != 0x41 /* LM63 */
>  	 || (reg_config1 & 0x18) != 0x00
>  	 || (reg_config2 & 0xF8) != 0x00
>  	 || (reg_alert_status & 0x20) != 0x00
> @@ -450,7 +454,12 @@ static int lm63_detect(struct i2c_client *new_client,
>  		return -ENODEV;
>  	}
>  
> -	strlcpy(info->type, "lm63", I2C_NAME_SIZE);
> +	if (chip_id == 0x41 && address == 0x4c)
> +		strlcpy(info->type, "lm63", I2C_NAME_SIZE);
> +	else if (chip_id == 0x51 && (address == 0x18 || address == 0x4e))
> +		strlcpy(info->type, "lm64", I2C_NAME_SIZE);
> +	else
> +		return -ENODEV;
>  
>  	return 0;
>  }
> @@ -471,6 +480,8 @@ static int lm63_probe(struct i2c_client *new_client,
>  	data->valid = 0;
>  	mutex_init(&data->update_lock);
>  
> +	data->kind = id->driver_data;

You don't use this value anywhere, so why bother storing it?

> +
>  	/* Initialize the LM63 chip */
>  	lm63_init_client(new_client);
>  

Your patch is missing an update to drivers/hwmon/Kconfig.

Please submit an updated patch and I'll apply it.

-- 
Jean Delvare
