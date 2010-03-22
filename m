Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab0CVKXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 06:23:14 -0400
Received: from bamako.nerim.net ([62.4.17.28]:60249 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab0CVKXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 06:23:12 -0400
Date: Mon, 22 Mar 2010 11:23:08 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Giel van Schijndel <me@mortis.eu>
Cc: Hans de Goede <hdegoede@redhat.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Hwmon: f71882fg: use strict_stro(l|ul) instead of
 simple_strto$1
Message-ID: <20100322112308.13d58db4@hyperion.delvare>
In-Reply-To: <1269185834-10266-2-git-send-email-me@mortis.eu>
References: <1269185834-10266-1-git-send-email-me@mortis.eu>
	<1269185834-10266-2-git-send-email-me@mortis.eu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010 16:37:14 +0100, Giel van Schijndel wrote:
> Use the strict_strol and strict_stroul functions instead of simple_strol
> and simple_stroul respectively in sysfs functions.
> 
> Signed-off-by: Giel van Schijndel <me@mortis.eu>
> ---
>  drivers/hwmon/f71882fg.c |   89 ++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 74 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
> index 21bc661..5c725a3 100644
> --- a/drivers/hwmon/f71882fg.c
> +++ b/drivers/hwmon/f71882fg.c
> @@ -1128,7 +1128,10 @@ static ssize_t store_fan_full_speed(struct device *dev,
>  {
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int nr = to_sensor_dev_attr_2(devattr)->index;
> -	long val = simple_strtol(buf, NULL, 10);
> +	long val;
> +
> +	if (strict_strtol(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;

That's not correct. You want to return an error if strict_strtol()
returns _any_ error, not just -EINVAL. Maybe the current implementation
can't return any other error code, but you should not assume this will
always be the case in the future.

>  
>  	val = SENSORS_LIMIT(val, 23, 1500000);
>  	val = fan_to_reg(val);
> @@ -1158,7 +1161,10 @@ static ssize_t store_fan_beep(struct device *dev, struct device_attribute
>  {
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int nr = to_sensor_dev_attr_2(devattr)->index;
> -	unsigned long val = simple_strtoul(buf, NULL, 10);
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
>  
>  	mutex_lock(&data->update_lock);
>  	data->fan_beep = f71882fg_read8(data, F71882FG_REG_FAN_BEEP);
> @@ -1206,7 +1212,12 @@ static ssize_t store_in_max(struct device *dev, struct device_attribute
>  	*devattr, const char *buf, size_t count)
>  {
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
> -	long val = simple_strtol(buf, NULL, 10) / 8;
> +	long val;
> +
> +	if (strict_strtol(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
> +
> +	val /= 8;
>  	val = SENSORS_LIMIT(val, 0, 255);
>  
>  	mutex_lock(&data->update_lock);
> @@ -1234,7 +1245,10 @@ static ssize_t store_in_beep(struct device *dev, struct device_attribute
>  {
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int nr = to_sensor_dev_attr_2(devattr)->index;
> -	unsigned long val = simple_strtoul(buf, NULL, 10);
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
>  
>  	mutex_lock(&data->update_lock);
>  	data->in_beep = f71882fg_read8(data, F71882FG_REG_IN_BEEP);
> @@ -1300,7 +1314,12 @@ static ssize_t store_temp_max(struct device *dev, struct device_attribute
>  {
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int nr = to_sensor_dev_attr_2(devattr)->index;
> -	long val = simple_strtol(buf, NULL, 10) / 1000;
> +	long val;
> +
> +	if (strict_strtol(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
> +
> +	val /= 1000;
>  	val = SENSORS_LIMIT(val, 0, 255);
>  
>  	mutex_lock(&data->update_lock);
> @@ -1334,9 +1353,14 @@ static ssize_t store_temp_max_hyst(struct device *dev, struct device_attribute
>  {
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int nr = to_sensor_dev_attr_2(devattr)->index;
> -	long val = simple_strtol(buf, NULL, 10) / 1000;
>  	ssize_t ret = count;
>  	u8 reg;
> +	long val;
> +
> +	if (strict_strtol(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
> +
> +	val /= 1000;
>  
>  	mutex_lock(&data->update_lock);
>  
> @@ -1373,7 +1397,12 @@ static ssize_t store_temp_crit(struct device *dev, struct device_attribute
>  {
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int nr = to_sensor_dev_attr_2(devattr)->index;
> -	long val = simple_strtol(buf, NULL, 10) / 1000;
> +	long val;
> +
> +	if (strict_strtol(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
> +
> +	val /= 1000;
>  	val = SENSORS_LIMIT(val, 0, 255);
>  
>  	mutex_lock(&data->update_lock);
> @@ -1428,7 +1457,10 @@ static ssize_t store_temp_beep(struct device *dev, struct device_attribute
>  {
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int nr = to_sensor_dev_attr_2(devattr)->index;
> -	unsigned long val = simple_strtoul(buf, NULL, 10);
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
>  
>  	mutex_lock(&data->update_lock);
>  	data->temp_beep = f71882fg_read8(data, F71882FG_REG_TEMP_BEEP);
> @@ -1491,7 +1523,11 @@ static ssize_t store_pwm(struct device *dev,
>  {
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int nr = to_sensor_dev_attr_2(devattr)->index;
> -	long val = simple_strtol(buf, NULL, 10);
> +	long val;
> +
> +	if (strict_strtol(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
> +
>  	val = SENSORS_LIMIT(val, 0, 255);
>  
>  	mutex_lock(&data->update_lock);
> @@ -1552,7 +1588,10 @@ static ssize_t store_pwm_enable(struct device *dev, struct device_attribute
>  {
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int nr = to_sensor_dev_attr_2(devattr)->index;
> -	long val = simple_strtol(buf, NULL, 10);
> +	long val;
> +
> +	if (strict_strtol(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
>  
>  	/* Special case for F8000 pwm channel 3 which only does auto mode */
>  	if (data->type == f8000 && nr == 2 && val != 2)
> @@ -1628,7 +1667,11 @@ static ssize_t store_pwm_auto_point_pwm(struct device *dev,
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int pwm = to_sensor_dev_attr_2(devattr)->index;
>  	int point = to_sensor_dev_attr_2(devattr)->nr;
> -	long val = simple_strtol(buf, NULL, 10);
> +	long val;
> +
> +	if (strict_strtol(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
> +
>  	val = SENSORS_LIMIT(val, 0, 255);
>  
>  	mutex_lock(&data->update_lock);
> @@ -1676,8 +1719,13 @@ static ssize_t store_pwm_auto_point_temp_hyst(struct device *dev,
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int nr = to_sensor_dev_attr_2(devattr)->index;
>  	int point = to_sensor_dev_attr_2(devattr)->nr;
> -	long val = simple_strtol(buf, NULL, 10) / 1000;
>  	u8 reg;
> +	long val;
> +
> +	if (strict_strtol(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
> +
> +	val /= 1000;
>  
>  	mutex_lock(&data->update_lock);
>  	data->pwm_auto_point_temp[nr][point] =
> @@ -1717,7 +1765,10 @@ static ssize_t store_pwm_interpolate(struct device *dev,
>  {
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int nr = to_sensor_dev_attr_2(devattr)->index;
> -	unsigned long val = simple_strtoul(buf, NULL, 10);
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
>  
>  	mutex_lock(&data->update_lock);
>  	data->pwm_auto_point_mapping[nr] =
> @@ -1753,7 +1804,10 @@ static ssize_t store_pwm_auto_point_channel(struct device *dev,
>  {
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int nr = to_sensor_dev_attr_2(devattr)->index;
> -	long val = simple_strtol(buf, NULL, 10);
> +	long val;
> +
> +	if (strict_strtol(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
>  
>  	switch (val) {
>  	case 1:
> @@ -1800,7 +1854,12 @@ static ssize_t store_pwm_auto_point_temp(struct device *dev,
>  	struct f71882fg_data *data = dev_get_drvdata(dev);
>  	int pwm = to_sensor_dev_attr_2(devattr)->index;
>  	int point = to_sensor_dev_attr_2(devattr)->nr;
> -	long val = simple_strtol(buf, NULL, 10) / 1000;
> +	long val;
> +
> +	if (strict_strtol(buf, 10, &val) == -EINVAL)
> +		return -EINVAL;
> +
> +	val /= 1000;
>  
>  	if (data->type == f71889fg)
>  		val = SENSORS_LIMIT(val, -128, 127);


-- 
Jean Delvare
