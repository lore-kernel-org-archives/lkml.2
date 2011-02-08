Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab1BHP3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:29:21 -0500
Received: from imr4.ericy.com ([198.24.6.8]:59348 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab1BHP3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:29:20 -0500
Date: Tue, 8 Feb 2011 07:28:15 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Dirk Eibach <eibach@gdsys.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon: Consider LM64 temperature offset
Message-ID: <20110208152815.GA13436@ericsson.com>
References: <1297170966-13101-1-git-send-email-eibach@gdsys.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1297170966-13101-1-git-send-email-eibach@gdsys.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 08:16:06AM -0500, Dirk Eibach wrote:
> LM64 has 16 degrees Celsius temperature offset on all
> remote sensor registers.
> This was not considered When LM64 support was added to lm63.c.
> 
> Signed-off-by: Dirk Eibach <eibach@gdsys.de>

Comments inline.

> ---
>  drivers/hwmon/lm63.c |   34 +++++++++++++++++++++++++++++-----
>  1 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
> index 776aeb3..87bfefb 100644
> --- a/drivers/hwmon/lm63.c
> +++ b/drivers/hwmon/lm63.c
> @@ -98,6 +98,9 @@ static const unsigned short normal_i2c[] = { 0x18, 0x4c, 0x4e, I2C_CLIENT_END };
>   * value, it uses signed 8-bit values with LSB = 1 degree Celsius.
>   * For remote temperature, low and high limits, it uses signed 11-bit values
>   * with LSB = 0.125 degree Celsius, left-justified in 16-bit registers.
> + * For LM64 the actual remote diode temperature is 16 degree Celsius higher
> + * than the register reading. Remote temperature setpoints have to be
> + * adapted accordingly.
>   */
>  
>  #define FAN_FROM_REG(reg)	((reg) == 0xFFFC || (reg) == 0 ? 0 : \
> @@ -180,6 +183,7 @@ struct lm63_data {
>  			   2: remote high limit */
>  	u8 temp2_crit_hyst;
>  	u8 alarms;
> +	bool is_lm64;

It would be easier to add an offset variable, since all you use it for is
to calculate the offset. Then you can just use data->offset instead of
calculating the offset repeatedly.

>  };
>  
>  /*
> @@ -255,6 +259,17 @@ static ssize_t show_temp8(struct device *dev, struct device_attribute *devattr,
>  	return sprintf(buf, "%d\n", TEMP8_FROM_REG(data->temp8[attr->index]));
>  }
>  
> +static ssize_t show_remote_temp8(struct device *dev,
> +				 struct device_attribute *devattr,
> +				 char *buf)
> +{
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> +	struct lm63_data *data = lm63_update_device(dev);
> +	int offset = data->is_lm64 ? 16000 : 0;
> +	return sprintf(buf, "%d\n",
> +		       TEMP8_FROM_REG(data->temp8[attr->index]) + offset);
> +}

For consistency, if you should name this function to match 
show_temp2_crit_hyst(), ie show_temp2_crit().

> +
>  static ssize_t set_temp8(struct device *dev, struct device_attribute *dummy,
>  			 const char *buf, size_t count)
>  {
> @@ -274,7 +289,9 @@ static ssize_t show_temp11(struct device *dev, struct device_attribute *devattr,
>  {
>  	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>  	struct lm63_data *data = lm63_update_device(dev);
> -	return sprintf(buf, "%d\n", TEMP11_FROM_REG(data->temp11[attr->index]));
> +	int offset = data->is_lm64 ? 16000 : 0;
> +	return sprintf(buf, "%d\n",
> +		       TEMP11_FROM_REG(data->temp11[attr->index]) + offset);
>  }
>  
>  static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
> @@ -292,9 +309,10 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>  	struct lm63_data *data = i2c_get_clientdata(client);
>  	long val = simple_strtol(buf, NULL, 10);
>  	int nr = attr->index;
> +	int offset = data->is_lm64 ? 16000 : 0;
>  
>  	mutex_lock(&data->update_lock);
> -	data->temp11[nr] = TEMP11_TO_REG(val);
> +	data->temp11[nr] = TEMP11_TO_REG(val - offset);
>  	i2c_smbus_write_byte_data(client, reg[(nr - 1) * 2],
>  				  data->temp11[nr] >> 8);
>  	i2c_smbus_write_byte_data(client, reg[(nr - 1) * 2 + 1],
> @@ -309,7 +327,8 @@ static ssize_t show_temp2_crit_hyst(struct device *dev, struct device_attribute
>  				    char *buf)
>  {
>  	struct lm63_data *data = lm63_update_device(dev);
> -	return sprintf(buf, "%d\n", TEMP8_FROM_REG(data->temp8[2])
> +	int offset = data->is_lm64 ? 16000 : 0;
> +	return sprintf(buf, "%d\n", TEMP8_FROM_REG(data->temp8[2]) + offset
>  		       - TEMP8_FROM_REG(data->temp2_crit_hyst));
>  }
>  
> @@ -320,11 +339,12 @@ static ssize_t set_temp2_crit_hyst(struct device *dev, struct device_attribute *
>  {
>  	struct i2c_client *client = to_i2c_client(dev);
>  	struct lm63_data *data = i2c_get_clientdata(client);
> +	int offset = data->is_lm64 ? 16000 : 0;
>  	long val = simple_strtol(buf, NULL, 10);
>  	long hyst;
>  
>  	mutex_lock(&data->update_lock);
> -	hyst = TEMP8_FROM_REG(data->temp8[2]) - val;
> +	hyst = TEMP8_FROM_REG(data->temp8[2]) + offset - val;
>  	i2c_smbus_write_byte_data(client, LM63_REG_REMOTE_TCRIT_HYST,
>  				  HYST_TO_REG(hyst));
>  	mutex_unlock(&data->update_lock);
> @@ -364,7 +384,7 @@ static SENSOR_DEVICE_ATTR(temp2_min, S_IWUSR | S_IRUGO, show_temp11,
>  	set_temp11, 1);
>  static SENSOR_DEVICE_ATTR(temp2_max, S_IWUSR | S_IRUGO, show_temp11,
>  	set_temp11, 2);
> -static SENSOR_DEVICE_ATTR(temp2_crit, S_IRUGO, show_temp8, NULL, 2);
> +static SENSOR_DEVICE_ATTR(temp2_crit, S_IRUGO, show_remote_temp8, NULL, 2);

Any idea why the remote critical limit can not be set ?

>  static DEVICE_ATTR(temp2_crit_hyst, S_IWUSR | S_IRUGO, show_temp2_crit_hyst,
>  	set_temp2_crit_hyst);
>  
> @@ -466,6 +486,7 @@ static int lm63_detect(struct i2c_client *new_client,
>  static int lm63_probe(struct i2c_client *new_client,
>  		      const struct i2c_device_id *id)
>  {
> +	u8 chip_id;
>  	struct lm63_data *data;
>  	int err;
>  
> @@ -479,6 +500,9 @@ static int lm63_probe(struct i2c_client *new_client,
>  	data->valid = 0;
>  	mutex_init(&data->update_lock);
>  
> +	chip_id = i2c_smbus_read_byte_data(new_client, LM63_REG_CHIP_ID);
> +	data->is_lm64 = (chip_id == 0x51);
> +

Chip id is already detected in lm63_detect. You don't need to detect it again.
The more common approach would be something along the line of
	data->kind = id->driver_data;
    You would then use
	if (data->kind == lm64)
    throughout the code. In addition to that, you could define
	data->kind = id->driver_data;
	if (data->kind == lm64)
		data->offset = 16000;
    which would save you the repeated recalculation of offset as mentioned before.

Thanks,
Guenter
