Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab1FWIG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 04:06:29 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:15706 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab1FWIG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 04:06:28 -0400
Date: Thu, 23 Jun 2011 10:06:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ankur Patel <bkankur@gmail.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HWMON: TMP102 - Added support for 12 bit data
Message-ID: <20110623100616.4573741f@endymion.delvare>
In-Reply-To: <1308709299-24539-1-git-send-email-bkankur@gmail.com>
References: <1308709299-24539-1-git-send-email-bkankur@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 07:51:39 +0530, Ankur Patel wrote:
> From: Ankur Patel <ankur.patel@quipment.in>
> 
> In the tmp102.ko driver support for 12 bit data is added. Also, the
> sysfs names are replaced with the actual chip supported fuctionality
> names.

Nack. These attribute names are standard, see
Documentation/hwmon/sysfs-interface. You don't get to change them.

What problem were you trying to solve? libsensors expects the attribute
names which are in use today.

> 
> Signed-off-by: Ankur Patel <ankur.patel@quipment.in>
> ---
>  drivers/hwmon/tmp102.c |   40 ++++++++++++++++++++++++++--------------
>  1 files changed, 26 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
> index 5bd1949..a13b572 100644
> --- a/drivers/hwmon/tmp102.c
> +++ b/drivers/hwmon/tmp102.c
> @@ -47,6 +47,9 @@
>  #define	TMP102_TLOW_REG			0x02
>  #define	TMP102_THIGH_REG		0x03
>  
> +#define TMP102_CONFIG  (TMP102_CONF_TM | TMP102_CONF_EM | TMP102_CONF_CR1)
> +#define TMP102_CONFIG_RD_ONLY (TMP102_CONF_R0 | TMP102_CONF_R1 | TMP102_CONF_AL)
> +
>  struct tmp102 {
>  	struct device *hwmon_dev;
>  	struct mutex lock;
> @@ -68,16 +71,26 @@ static inline int tmp102_write_reg(struct i2c_client *client, u8 reg, u16 val)
>  	return i2c_smbus_write_word_data(client, reg, swab16(val));
>  }
>  
> -/* convert left adjusted 13-bit TMP102 register value to milliCelsius */
> +/* convert left adjusted TMP102 register value to milliCelsius for 13 bit &
> + * 12 bit by dividing with 128 & 256 respectively*/
>  static inline int tmp102_reg_to_mC(s16 val)
>  {
> -	return ((val & ~0x01) * 1000) / 128;
> +	#if TMP102_CONFIG & TMP102_CONF_EM
> +		return ((val & ~0x01) * 1000) / 128;
> +	#else
> +		return ((val & ~0x01) * 1000) / 256;
> +	#endif
>  }
>  
> -/* convert milliCelsius to left adjusted 13-bit TMP102 register value */
> +/* convert milliCelsius to left adjusted TMP102 register value for 13 bit &
> + * 12 bit by multiplying with 128 & 256 respectivley*/
>  static inline u16 tmp102_mC_to_reg(int val)
>  {
> -	return (val * 128) / 1000;
> +	#if TMP102_CONFIG & TMP102_CONF_EM
> +		return (val * 128) / 1000;
> +	#else
> +		return (val * 256) / 1000;
> +	#endif
>  }
>  
>  static const u8 tmp102_reg[] = {
> @@ -126,7 +139,9 @@ static ssize_t tmp102_set_temp(struct device *dev,
>  
>  	if (strict_strtol(buf, 10, &val) < 0)
>  		return -EINVAL;
> -	val = SENSORS_LIMIT(val, -256000, 255000);
> +	/* It will limit the Input temperature range to -55 Deg. Cel to
> +	 * 150 Deg. Cel */
> +	val = val = SENSORS_LIMIT(val, -55000, 150000);
>  
>  	mutex_lock(&tmp102->lock);
>  	tmp102->temp[sda->index] = val;
> @@ -138,16 +153,16 @@ static ssize_t tmp102_set_temp(struct device *dev,
>  
>  static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, tmp102_show_temp, NULL , 0);
>  
> -static SENSOR_DEVICE_ATTR(temp1_max_hyst, S_IWUSR | S_IRUGO, tmp102_show_temp,
> -			  tmp102_set_temp, 1);
> +static SENSOR_DEVICE_ATTR(temp1_low_thresold, S_IWUSR | S_IRUGO,
> +					tmp102_show_temp, tmp102_set_temp, 1);
>  
> -static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, tmp102_show_temp,
> -			  tmp102_set_temp, 2);
> +static SENSOR_DEVICE_ATTR(temp1_max_thresold, S_IWUSR | S_IRUGO,
> +\					tmp102_show_temp, tmp102_set_temp, 2);
>  
>  static struct attribute *tmp102_attributes[] = {
>  	&sensor_dev_attr_temp1_input.dev_attr.attr,
> -	&sensor_dev_attr_temp1_max_hyst.dev_attr.attr,
> -	&sensor_dev_attr_temp1_max.dev_attr.attr,
> +	&sensor_dev_attr_temp1_low_thresold.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max_thresold.dev_attr.attr,
>  	NULL
>  };
>  
> @@ -155,9 +170,6 @@ static const struct attribute_group tmp102_attr_group = {
>  	.attrs = tmp102_attributes,
>  };
>  
> -#define TMP102_CONFIG  (TMP102_CONF_TM | TMP102_CONF_EM | TMP102_CONF_CR1)
> -#define TMP102_CONFIG_RD_ONLY (TMP102_CONF_R0 | TMP102_CONF_R1 | TMP102_CONF_AL)
> -
>  static int __devinit tmp102_probe(struct i2c_client *client,
>  				  const struct i2c_device_id *id)
>  {


-- 
Jean Delvare
