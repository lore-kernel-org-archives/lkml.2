Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0INKv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 06:51:59 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:4448 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0INKv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 06:51:59 -0400
Date: Tue, 14 Sep 2010 12:51:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] hwmon: (lm90) Introduce 3rd set of upper
 temperature limits
Message-ID: <20100914125137.0928875b@hyperion.delvare>
In-Reply-To: <1284038750-8833-6-git-send-email-guenter.roeck@ericsson.com>
References: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
	<1284038750-8833-6-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Thu, 9 Sep 2010 06:25:48 -0700, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
>  drivers/hwmon/lm90.c |   34 ++++++++++++++++++++++++++++++++--
>  1 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index 11b5701..d2bcb47 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c
> @@ -147,6 +147,7 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, adt7461, max6680, max6646,
>  #define	LM90_HAVE_OFFSET	0x02	/* temperature offset register	*/
>  #define	LM90_HAVE_LOCAL_EXT	0x04	/* extended local temperature	*/
>  #define	LM90_HAVE_REM_LIMIT_EXT	0x08	/* extended remote limit	*/
> +#define	LM90_HAVE_EMERGENCY	0x10	/* 3rd upper (emergency) limit	*/
>  
>  /*
>   * Functions declaration
> @@ -213,10 +214,12 @@ struct lm90_data {
>  	u8 alert_alarms;	/* Which alarm bits trigger ALERT# */
>  
>  	/* registers values */
> -	s8 temp8[4];	/* 0: local low limit
> +	s8 temp8[6];	/* 0: local low limit
>  			   1: local high limit
>  			   2: local critical limit
> -			   3: remote critical limit */
> +			   3: remote critical limit
> +			   4: local emergency limit
> +			   5: remote emergency limit */
>  	s16 temp11[5];	/* 0: remote input
>  			   1: remote low limit
>  			   2: remote high limit
> @@ -608,6 +611,24 @@ static const struct attribute_group lm90_group = {
>  	.attrs = lm90_attributes,
>  };
>  
> +/*
> + * Additional attributes for devices with emergency sensors
> + */
> +static SENSOR_DEVICE_ATTR(temp1_emergency, S_IWUSR | S_IRUGO, show_temp8,
> +	set_temp8, 4);
> +static SENSOR_DEVICE_ATTR(temp2_emergency, S_IWUSR | S_IRUGO, show_temp8,
> +	set_temp8, 5);
> +
> +static struct attribute *lm90_emergency_attributes[] = {
> +	&sensor_dev_attr_temp1_emergency.dev_attr.attr,
> +	&sensor_dev_attr_temp2_emergency.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group lm90_emergency_group = {
> +	.attrs = lm90_emergency_attributes,
> +};
> +
>  /* pec used for ADM1032 only */
>  static ssize_t show_pec(struct device *dev, struct device_attribute *dummy,
>  			char *buf)
> @@ -818,6 +839,9 @@ static int lm90_detect(struct i2c_client *new_client,
>  
>  static void lm90_remove_files(struct i2c_client *client, struct lm90_data *data)
>  {
> +	if (data->flags & LM90_HAVE_EMERGENCY)
> +		sysfs_remove_group(&client->dev.kobj,
> +				   &lm90_emergency_group);
>  	if (data->flags & LM90_HAVE_OFFSET)
>  		device_remove_file(&client->dev,
>  				   &sensor_dev_attr_temp2_offset.dev_attr);

But this flag is never set?

> @@ -889,6 +913,12 @@ static int lm90_probe(struct i2c_client *new_client,
>  		if (err)
>  			goto exit_remove_files;
>  	}
> +	if (data->flags & LM90_HAVE_EMERGENCY) {
> +		err = sysfs_create_group(&new_client->dev.kobj,
> +					 &lm90_emergency_group);
> +		if (err)
> +			goto exit_remove_files;
> +	}
>  
>  	data->hwmon_dev = hwmon_device_register(&new_client->dev);
>  	if (IS_ERR(data->hwmon_dev)) {

-- 
Jean Delvare
