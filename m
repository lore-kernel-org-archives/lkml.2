Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0INJTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 05:19:08 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:44623 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab0INJTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 05:19:03 -0400
Date: Tue, 14 Sep 2010 11:18:39 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] hwmon: (lm90) Simplify set_temp11 register
 calculations
Message-ID: <20100914111839.1ef08638@hyperion.delvare>
In-Reply-To: <1284038750-8833-5-git-send-email-guenter.roeck@ericsson.com>
References: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
	<1284038750-8833-5-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010 06:25:47 -0700, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
>  drivers/hwmon/lm90.c |   55 +++++++++++++++++++++++++------------------------
>  1 files changed, 28 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index f21dde5..11b5701 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c
> @@ -418,7 +418,7 @@ static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
>  static ssize_t show_temp11(struct device *dev, struct device_attribute *devattr,
>  			   char *buf)
>  {
> -	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> +	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
>  	struct lm90_data *data = lm90_update_device(dev);
>  	int temp;
>  
> @@ -439,19 +439,20 @@ static ssize_t show_temp11(struct device *dev, struct device_attribute *devattr,
>  static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>  			  const char *buf, size_t count)
>  {
> -	static const u8 reg[6] = {
> -		LM90_REG_W_REMOTE_LOWH,
> -		LM90_REG_W_REMOTE_LOWL,
> -		LM90_REG_W_REMOTE_HIGHH,
> -		LM90_REG_W_REMOTE_HIGHL,
> -		LM90_REG_W_REMOTE_OFFSH,
> -		LM90_REG_W_REMOTE_OFFSL,
> +	struct {
> +		u8 high;
> +		u8 low;
> +	} reg[3] = {
> +		{ LM90_REG_W_REMOTE_LOWH, LM90_REG_W_REMOTE_LOWL },
> +		{ LM90_REG_W_REMOTE_HIGHH, LM90_REG_W_REMOTE_HIGHL },
> +		{ LM90_REG_W_REMOTE_OFFSH, LM90_REG_W_REMOTE_OFFSL }
>  	};
>  
> -	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> +	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
>  	struct i2c_client *client = to_i2c_client(dev);
>  	struct lm90_data *data = i2c_get_clientdata(client);
> -	int nr = attr->index;
> +	int nr = attr->nr;
> +	int index = attr->index;
>  	long val;
>  	int err;
>  
> @@ -460,24 +461,24 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>  		return err;
>  
>  	/* +16 degrees offset for temp2 for the LM99 */
> -	if (data->kind == lm99 && attr->index <= 2)
> +	if (data->kind == lm99 && index <= 2)
>  		val -= 16000;
>  
>  	mutex_lock(&data->update_lock);
>  	if (data->kind == adt7461)
> -		data->temp11[nr] = temp_to_u16_adt7461(data, val);
> +		data->temp11[index] = temp_to_u16_adt7461(data, val);
>  	else if (data->kind == max6646)
> -		data->temp11[nr] = temp_to_u8(val) << 8;
> +		data->temp11[index] = temp_to_u8(val) << 8;
>  	else if (!(data->flags & LM90_HAVE_REM_LIMIT_EXT))
> -		data->temp11[nr] = temp_to_s8(val) << 8;
> +		data->temp11[index] = temp_to_s8(val) << 8;
>  	else
> -		data->temp11[nr] = temp_to_s16(val);
> +		data->temp11[index] = temp_to_s16(val);
>  
> -	i2c_smbus_write_byte_data(client, reg[(nr - 1) * 2],
> -				  data->temp11[nr] >> 8);
> +	i2c_smbus_write_byte_data(client, reg[nr].high,
> +				  data->temp11[index] >> 8);
>  	if (data->flags & LM90_HAVE_REM_LIMIT_EXT)
> -		i2c_smbus_write_byte_data(client, reg[(nr - 1) * 2 + 1],
> -					  data->temp11[nr] & 0xff);
> +		i2c_smbus_write_byte_data(client, reg[nr].low,
> +					  data->temp11[index] & 0xff);
>  	mutex_unlock(&data->update_lock);
>  	return count;
>  }
> @@ -549,16 +550,16 @@ static ssize_t show_alarm(struct device *dev, struct device_attribute
>  	return sprintf(buf, "%d\n", (data->alarms >> bitnr) & 1);
>  }
>  
> -static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp11, NULL, 4);
> -static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, show_temp11, NULL, 0);
> +static SENSOR_DEVICE_ATTR_2(temp1_input, S_IRUGO, show_temp11, NULL, 0, 4);
> +static SENSOR_DEVICE_ATTR_2(temp2_input, S_IRUGO, show_temp11, NULL, 0, 0);
>  static SENSOR_DEVICE_ATTR(temp1_min, S_IWUSR | S_IRUGO, show_temp8,
>  	set_temp8, 0);
> -static SENSOR_DEVICE_ATTR(temp2_min, S_IWUSR | S_IRUGO, show_temp11,
> -	set_temp11, 1);
> +static SENSOR_DEVICE_ATTR_2(temp2_min, S_IWUSR | S_IRUGO, show_temp11,
> +	set_temp11, 0, 1);
>  static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp8,
>  	set_temp8, 1);
> -static SENSOR_DEVICE_ATTR(temp2_max, S_IWUSR | S_IRUGO, show_temp11,
> -	set_temp11, 2);
> +static SENSOR_DEVICE_ATTR_2(temp2_max, S_IWUSR | S_IRUGO, show_temp11,
> +	set_temp11, 1, 2);
>  static SENSOR_DEVICE_ATTR(temp1_crit, S_IWUSR | S_IRUGO, show_temp8,
>  	set_temp8, 2);
>  static SENSOR_DEVICE_ATTR(temp2_crit, S_IWUSR | S_IRUGO, show_temp8,
> @@ -566,8 +567,8 @@ static SENSOR_DEVICE_ATTR(temp2_crit, S_IWUSR | S_IRUGO, show_temp8,
>  static SENSOR_DEVICE_ATTR(temp1_crit_hyst, S_IWUSR | S_IRUGO, show_temphyst,
>  	set_temphyst, 2);
>  static SENSOR_DEVICE_ATTR(temp2_crit_hyst, S_IRUGO, show_temphyst, NULL, 3);
> -static SENSOR_DEVICE_ATTR(temp2_offset, S_IWUSR | S_IRUGO, show_temp11,
> -	set_temp11, 3);
> +static SENSOR_DEVICE_ATTR_2(temp2_offset, S_IWUSR | S_IRUGO, show_temp11,
> +	set_temp11, 2, 3);
>  
>  /* Individual alarm files */
>  static SENSOR_DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL, 0);

Looks good, applied, thanks.

-- 
Jean Delvare
