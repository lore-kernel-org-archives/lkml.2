Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab0KJSwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:52:38 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:50930 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714Ab0KJSwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:52:37 -0500
Message-ID: <4CDAE9D7.3060007@euromail.se>
Date: Wed, 10 Nov 2010 19:52:07 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (applesmc) Fix checkpatch errors
References: <1289415200-4928-1-git-send-email-guenter.roeck@ericsson.com>
In-Reply-To: <1289415200-4928-1-git-send-email-guenter.roeck@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PGFmC-0001ZA-At.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PGFmC-0001ZA-At 592c8433f0766755e834e47512fde267
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 07:53 PM, Guenter Roeck wrote:

> Fix all checkpatch errors and most of the warnings.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
>  drivers/hwmon/applesmc.c |   40 +++++++++++++++++++++-------------------
>  1 files changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index 1e49b30..365761b 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -174,9 +174,8 @@ static int __wait_status(u8 val)
>  
>  	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
>  		udelay(us);
> -		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val) {
> +		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val)
>  			return 0;
> -		}
>  	}
>  
>  	return -EIO;
> @@ -431,7 +430,7 @@ static int applesmc_has_key(const char *key, bool *value)
>  /*
>   * applesmc_read_motion_sensor - Read motion sensor (X, Y or Z).
>   */
> -static int applesmc_read_motion_sensor(int index, s16* value)
> +static int applesmc_read_motion_sensor(int index, s16 *value)
>  {
>  	u8 buffer[2];
>  	int ret;
> @@ -779,14 +778,12 @@ static ssize_t applesmc_store_fan_speed(struct device *dev,
>  					const char *sysfsbuf, size_t count)
>  {
>  	int ret;
> -	u32 speed;
> +	unsigned long speed;
>  	char newkey[5];
>  	u8 buffer[2];
>  
> -	speed = simple_strtoul(sysfsbuf, NULL, 10);
> -
> -	if (speed > 0x4000) /* Bigger than a 14-bit value */
> -		return -EINVAL;
> +	if (strict_strtoul(sysfsbuf, 10, &speed) < 0 || speed >= 0x4000)
> +		return -EINVAL;		/* Bigger than a 14-bit value */


Thanks for the bug fix, I forgot to include it.

>
>  	sprintf(newkey, fan_speed_fmt[to_option(attr)], to_index(attr));
>  
> @@ -822,10 +819,11 @@ static ssize_t applesmc_store_fan_manual(struct device *dev,
>  {
>  	int ret;
>  	u8 buffer[2];
> -	u32 input;
> +	unsigned long input;
>  	u16 val;
>  
> -	input = simple_strtoul(sysfsbuf, NULL, 10);
> +	if (strict_strtoul(sysfsbuf, 10, &input) < 0)
> +		return -EINVAL;
>  
>  	ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
>  	val = (buffer[0] << 8 | buffer[1]);
> @@ -977,7 +975,11 @@ static ssize_t applesmc_key_at_index_show(struct device *dev,
>  static ssize_t applesmc_key_at_index_store(struct device *dev,
>  	struct device_attribute *attr, const char *sysfsbuf, size_t count)
>  {
> -	key_at_index = simple_strtoul(sysfsbuf, NULL, 10);
> +	unsigned long newkey;
> +
> +	if (strict_strtoul(sysfsbuf, 10, &newkey) < 0)
> +		return -EINVAL;
> +	key_at_index = newkey;


Crash alert - key_at_index is not range checked, and the remake uses this value
as an array index...

>  	return count;
>  }
> @@ -1193,24 +1195,24 @@ static __initdata struct dmi_system_id applesmc_whitelist[] = {
>  	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
>  	},
>  	{ applesmc_dmi_match, "Apple MacBook Pro", {
> -	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> -	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
> +	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro") },
>  	},
>  	{ applesmc_dmi_match, "Apple MacBook", {
> -	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> -	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
> +	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBook") },
>  	},
>  	{ applesmc_dmi_match, "Apple Macmini", {
> -	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> -	  DMI_MATCH(DMI_PRODUCT_NAME,"Macmini") },
> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
> +	  DMI_MATCH(DMI_PRODUCT_NAME, "Macmini") },
>  	},
>  	{ applesmc_dmi_match, "Apple MacPro", {
>  	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
>  	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro") },
>  	},
>  	{ applesmc_dmi_match, "Apple iMac", {
> -	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> -	  DMI_MATCH(DMI_PRODUCT_NAME,"iMac") },
> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
> +	  DMI_MATCH(DMI_PRODUCT_NAME, "iMac") },
>  	},
>  	{ .ident = NULL }
>  };


Thanks,
Henrik
