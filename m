Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab0H0LqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:46:17 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:20195 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab0H0LqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:46:14 -0400
Date: Fri, 27 Aug 2010 13:45:23 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        "Darrick J. Wong" <djwong@us.ibm.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: Fix checkpatch errors in lm90 driver
Message-ID: <20100827134523.6bcc70aa@hyperion.delvare>
In-Reply-To: <1282838076-7175-1-git-send-email-guenter.roeck@ericsson.com>
References: <1282838076-7175-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Thu, 26 Aug 2010 08:54:36 -0700, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
> The main rationale for this cleanup is to prepare the driver for adding max6696
> support.

I'm fine with mostly anything, except...

>  drivers/hwmon/lm90.c |  110 +++++++++++++++++++++++++++++++++----------------
>  1 files changed, 74 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index 760ef72..58a5605 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c
> @@ -387,8 +387,13 @@ static ssize_t set_temp8(struct device *dev, struct device_attribute *devattr,
>  	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>  	struct i2c_client *client = to_i2c_client(dev);
>  	struct lm90_data *data = i2c_get_clientdata(client);
> -	long val = simple_strtol(buf, NULL, 10);
>  	int nr = attr->index;
> +	long val;
> +	int err;
> +
> +	err = strict_strtol(buf, 10, &val);
> +	if (err < 0)
> +		return err;
>  
>  	/* +16 degrees offset for temp2 for the LM99 */
>  	if (data->kind == lm99 && attr->index == 3)
> @@ -442,8 +447,13 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>  	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>  	struct i2c_client *client = to_i2c_client(dev);
>  	struct lm90_data *data = i2c_get_clientdata(client);
> -	long val = simple_strtol(buf, NULL, 10);
>  	int nr = attr->index;
> +	long val;
> +	int err;
> +
> +	err = strict_strtol(buf, 10, &val);
> +	if (err < 0)
> +		return err;
>  
>  	/* +16 degrees offset for temp2 for the LM99 */
>  	if (data->kind == lm99 && attr->index <= 2)
> @@ -469,7 +479,8 @@ static ssize_t set_temp11(struct device *dev, struct device_attribute *devattr,
>  	return count;
>  }
>  
> -static ssize_t show_temphyst(struct device *dev, struct device_attribute *devattr,
> +static ssize_t show_temphyst(struct device *dev,
> +			     struct device_attribute *devattr,
>  			     char *buf)
>  {
>  	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> @@ -495,9 +506,14 @@ static ssize_t set_temphyst(struct device *dev, struct device_attribute *dummy,
>  {
>  	struct i2c_client *client = to_i2c_client(dev);
>  	struct lm90_data *data = i2c_get_clientdata(client);
> -	long val = simple_strtol(buf, NULL, 10);
> +	long val;
> +	int err;
>  	int temp;
>  
> +	err = strict_strtol(buf, 10, &val);
> +	if (err < 0)
> +		return err;
> +
>  	mutex_lock(&data->update_lock);
>  	if (data->kind == adt7461)
>  		temp = temp_from_u8_adt7461(data, data->temp8[2]);
> @@ -600,7 +616,12 @@ static ssize_t set_pec(struct device *dev, struct device_attribute *dummy,
>  		       const char *buf, size_t count)
>  {
>  	struct i2c_client *client = to_i2c_client(dev);
> -	long val = simple_strtol(buf, NULL, 10);
> +	long val;
> +	int err;
> +
> +	err = strict_strtol(buf, 10, &val);
> +	if (err < 0)
> +		return err;
>  
>  	switch (val) {
>  	case 0:
> @@ -622,8 +643,10 @@ static DEVICE_ATTR(pec, S_IWUSR | S_IRUGO, show_pec, set_pec);
>   * Real code
>   */
>  
> -/* The ADM1032 supports PEC but not on write byte transactions, so we need
> -   to explicitly ask for a transaction without PEC. */
> +/*
> + * The ADM1032 supports PEC but not on write byte transactions, so we need
> + * to explicitly ask for a transaction without PEC.
> + */
>  static inline s32 adm1032_write_byte(struct i2c_client *client, u8 value)
>  {
>  	return i2c_smbus_xfer(client->adapter, client->addr,
> @@ -631,20 +654,22 @@ static inline s32 adm1032_write_byte(struct i2c_client *client, u8 value)
>  			      I2C_SMBUS_WRITE, value, I2C_SMBUS_BYTE, NULL);
>  }
>  
> -/* It is assumed that client->update_lock is held (unless we are in
> -   detection or initialization steps). This matters when PEC is enabled,
> -   because we don't want the address pointer to change between the write
> -   byte and the read byte transactions. */
> -static int lm90_read_reg(struct i2c_client* client, u8 reg, u8 *value)
> +/*
> + * It is assumed that client->update_lock is held (unless we are in
> + * detection or initialization steps). This matters when PEC is enabled,
> + * because we don't want the address pointer to change between the write
> + * byte and the read byte transactions.
> + */
> +static int lm90_read_reg(struct i2c_client *client, u8 reg, u8 *value)
>  {
>  	int err;
>  
> - 	if (client->flags & I2C_CLIENT_PEC) {
> - 		err = adm1032_write_byte(client, reg);
> - 		if (err >= 0)
> - 			err = i2c_smbus_read_byte(client);
> - 	} else
> - 		err = i2c_smbus_read_byte_data(client, reg);
> +	if (client->flags & I2C_CLIENT_PEC) {
> +		err = adm1032_write_byte(client, reg);
> +		if (err >= 0)
> +			err = i2c_smbus_read_byte(client);
> +	} else
> +		err = i2c_smbus_read_byte_data(client, reg);
>  
>  	if (err < 0) {
>  		dev_warn(&client->dev, "Register %#02x read failed (%d)\n",
> @@ -669,14 +694,21 @@ static int lm90_detect(struct i2c_client *new_client,
>  		return -ENODEV;
>  
>  	/* detection and identification */
> -	if ((man_id = i2c_smbus_read_byte_data(new_client,
> -						LM90_REG_R_MAN_ID)) < 0
> -	 || (chip_id = i2c_smbus_read_byte_data(new_client,
> -						LM90_REG_R_CHIP_ID)) < 0
> -	 || (reg_config1 = i2c_smbus_read_byte_data(new_client,
> -						LM90_REG_R_CONFIG1)) < 0
> -	 || (reg_convrate = i2c_smbus_read_byte_data(new_client,
> -						LM90_REG_R_CONVRATE)) < 0)
> +	man_id = i2c_smbus_read_byte_data(new_client, LM90_REG_R_MAN_ID);
> +	if (man_id < 0)
> +		return -ENODEV;
> +
> +	chip_id = i2c_smbus_read_byte_data(new_client, LM90_REG_R_CHIP_ID);
> +	if (chip_id < 0)
> +		return -ENODEV;
> +
> +	reg_config1 = i2c_smbus_read_byte_data(new_client, LM90_REG_R_CONFIG1);
> +	if (reg_config1 < 0)
> +		return -ENODEV;
> +
> +	reg_convrate = i2c_smbus_read_byte_data(new_client,
> +						LM90_REG_R_CONVRATE);
> +	if (reg_convrate < 0)
>  		return -ENODEV;

... this. I think this check should be relaxed a bit, cascaded error
checking is done in many drivers and I don't think this is anything to
worry about.

No need to resend, I've just dropped the two chunks I don't like, and
applied the resulting patch. Thanks!

>  
>  	if ((address == 0x4C || address == 0x4D)
> @@ -826,16 +858,18 @@ static int lm90_probe(struct i2c_client *new_client,
>  	lm90_init_client(new_client);
>  
>  	/* Register sysfs hooks */
> -	if ((err = sysfs_create_group(&new_client->dev.kobj, &lm90_group)))
> +	err = sysfs_create_group(&new_client->dev.kobj, &lm90_group);
> +	if (err)
>  		goto exit_free;
>  	if (new_client->flags & I2C_CLIENT_PEC) {
> -		if ((err = device_create_file(&new_client->dev,
> -					      &dev_attr_pec)))
> +		err = device_create_file(&new_client->dev, &dev_attr_pec);
> +		if (err)
>  			goto exit_remove_files;
>  	}
>  	if (data->kind != max6657 && data->kind != max6646) {
> -		if ((err = device_create_file(&new_client->dev,
> -				&sensor_dev_attr_temp2_offset.dev_attr)))
> +		err = device_create_file(&new_client->dev,
> +					&sensor_dev_attr_temp2_offset.dev_attr);
> +		if (err)
>  			goto exit_remove_files;
>  	}
>  
> @@ -883,9 +917,8 @@ static void lm90_init_client(struct i2c_client *client)
>  	 * 0.125 degree resolution) and range (0x08, extend range
>  	 * to -64 degree) mode for the remote temperature sensor.
>  	 */
> -	if (data->kind == max6680) {
> +	if (data->kind == max6680)
>  		config |= 0x18;
> -	}
>  
>  	config &= 0xBF;	/* run */
>  	if (config != data->config_orig) /* Only write if changed */
> @@ -961,9 +994,14 @@ static int lm90_read16(struct i2c_client *client, u8 regh, u8 regl, u16 *value)
>  	 * we have to read the low byte again, and now we believe we have a
>  	 * correct reading.
>  	 */
> -	if ((err = lm90_read_reg(client, regh, &oldh))
> -	 || (err = lm90_read_reg(client, regl, &l))
> -	 || (err = lm90_read_reg(client, regh, &newh)))
> +	err = lm90_read_reg(client, regh, &oldh);
> +	if (err)
> +		return err;
> +	err = lm90_read_reg(client, regl, &l);
> +	if (err)
> +		return err;
> +	err = lm90_read_reg(client, regh, &newh);
> +	if (err)
>  		return err;
>  	if (oldh != newh) {
>  		err = lm90_read_reg(client, regl, &l);


-- 
Jean Delvare
