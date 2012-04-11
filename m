Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab2DKJDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:03:39 -0400
Received: from csmtp2.one.com ([91.198.169.22]:38593 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab2DKJDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:03:33 -0400
From: "Henrik Rydberg" <rydberg@bitmath.se>
Date: Wed, 11 Apr 2012 11:05:56 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 03/16 v2] Input: atmel_mxt_ts - refactor
 mxt_read/write_reg to take a length
Message-ID: <20120411090556.GA32061@polaris.bitmath.org>
References: <1333039766-8617-1-git-send-email-djkurtz@chromium.org>
 <1333039766-8617-4-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333039766-8617-4-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> The i2c bus requires 5 bytes to do a 1 byte read (1-byte i2c address + 2
> byte offset + 1-byte i2c address + 1 byte data), or 4 bytes to do a
> 1-byte write (1 byte i2c address + 2 byte offset + 1 byte data).
> 
> By taking a length with reads and writes, the driver can amortize
> transaction overhead by performing larger transactions where appropriate.
> 
> This patch just sets up the new API.  Later patches refactor reads/writes
> to take advantage of the larger transactions.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |   47 +++++++++++++----------------
>  1 files changed, 21 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 15ae6fd..971f9dc 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -397,8 +397,7 @@ static int mxt_fw_write(struct i2c_client *client,
>  	return 0;
>  }
>  
> -static int __mxt_read_reg(struct i2c_client *client,
> -			       u16 reg, u16 len, void *val)
> +static int mxt_read_reg(struct i2c_client *client, u16 reg, u16 len, void *val)
>  {
>  	struct i2c_msg xfer[2];
>  	u8 buf[2];
> @@ -419,28 +418,25 @@ static int __mxt_read_reg(struct i2c_client *client,
>  	xfer[1].buf = val;
>  
>  	if (i2c_transfer(client->adapter, xfer, 2) != 2) {
> -		dev_err(&client->dev, "%s: i2c transfer failed\n", __func__);
> +		dev_err(&client->dev, "%s: i2c read failed\n", __func__);
>  		return -EIO;
>  	}
>  
>  	return 0;
>  }
>  
> -static int mxt_read_reg(struct i2c_client *client, u16 reg, u8 *val)
> +static int mxt_write_reg(struct i2c_client *client, u16 reg, u16 len,
> +			 const void *val)
>  {
> -	return __mxt_read_reg(client, reg, 1, val);
> -}
> -
> -static int mxt_write_reg(struct i2c_client *client, u16 reg, u8 val)
> -{
> -	u8 buf[3];
> +	size_t count = 2 + len;		/* + 2-byte offset */
> +	u8 buf[count];

How much stack space are you planning to use here?

>  
>  	buf[0] = reg & 0xff;
>  	buf[1] = (reg >> 8) & 0xff;
> -	buf[2] = val;
> +	memcpy(&buf[2], val, len);
>  
> -	if (i2c_master_send(client, buf, 3) != 3) {
> -		dev_err(&client->dev, "%s: i2c send failed\n", __func__);
> +	if (i2c_master_send(client, buf, count) != count) {
> +		dev_err(&client->dev, "%s: i2c write failed\n", __func__);
>  		return -EIO;
>  	}
>  
> @@ -450,8 +446,7 @@ static int mxt_write_reg(struct i2c_client *client, u16 reg, u8 val)
>  static int mxt_read_object_table(struct i2c_client *client,
>  				      u16 reg, u8 *object_buf)
>  {
> -	return __mxt_read_reg(client, reg, MXT_OBJECT_SIZE,
> -				   object_buf);
> +	return mxt_read_reg(client, reg, MXT_OBJECT_SIZE, object_buf);
>  }
>  
>  static struct mxt_object *
> @@ -481,8 +476,8 @@ static int mxt_read_message(struct mxt_data *data,
>  		return -EINVAL;
>  
>  	reg = object->start_address;
> -	return __mxt_read_reg(data->client, reg,
> -			sizeof(struct mxt_message), message);
> +	return mxt_read_reg(data->client, reg, sizeof(struct mxt_message),
> +			    message);
>  }
>  
>  static int mxt_read_object(struct mxt_data *data,
> @@ -496,7 +491,7 @@ static int mxt_read_object(struct mxt_data *data,
>  		return -EINVAL;
>  
>  	reg = object->start_address;
> -	return __mxt_read_reg(data->client, reg + offset, 1, val);
> +	return mxt_read_reg(data->client, reg + offset, 1, val);
>  }
>  
>  static int mxt_write_object(struct mxt_data *data,
> @@ -510,7 +505,7 @@ static int mxt_write_object(struct mxt_data *data,
>  		return -EINVAL;
>  
>  	reg = object->start_address;
> -	return mxt_write_reg(data->client, reg + offset, val);
> +	return mxt_write_reg(data->client, reg + offset, 1, &val);
>  }
>  
>  static void mxt_input_report(struct mxt_data *data, int single_id)
> @@ -757,27 +752,27 @@ static int mxt_get_info(struct mxt_data *data)
>  	int error;
>  	u8 val;
>  
> -	error = mxt_read_reg(client, MXT_FAMILY_ID, &val);
> +	error = mxt_read_reg(client, MXT_FAMILY_ID, 1, &val);
>  	if (error)
>  		return error;
>  	info->family_id = val;
>  
> -	error = mxt_read_reg(client, MXT_VARIANT_ID, &val);
> +	error = mxt_read_reg(client, MXT_VARIANT_ID, 1, &val);
>  	if (error)
>  		return error;
>  	info->variant_id = val;
>  
> -	error = mxt_read_reg(client, MXT_VERSION, &val);
> +	error = mxt_read_reg(client, MXT_VERSION, 1, &val);
>  	if (error)
>  		return error;
>  	info->version = val;
>  
> -	error = mxt_read_reg(client, MXT_BUILD, &val);
> +	error = mxt_read_reg(client, MXT_BUILD, 1, &val);
>  	if (error)
>  		return error;
>  	info->build = val;
>  
> -	error = mxt_read_reg(client, MXT_OBJECT_NUM, &val);
> +	error = mxt_read_reg(client, MXT_OBJECT_NUM, 1, &val);
>  	if (error)
>  		return error;
>  	info->object_num = val;
> @@ -860,12 +855,12 @@ static int mxt_initialize(struct mxt_data *data)
>  	msleep(MXT_RESET_TIME);
>  
>  	/* Update matrix size at info struct */
> -	error = mxt_read_reg(client, MXT_MATRIX_X_SIZE, &val);
> +	error = mxt_read_reg(client, MXT_MATRIX_X_SIZE, 1, &val);
>  	if (error)
>  		return error;
>  	info->matrix_xsize = val;
>  
> -	error = mxt_read_reg(client, MXT_MATRIX_Y_SIZE, &val);
> +	error = mxt_read_reg(client, MXT_MATRIX_Y_SIZE, 1, &val);
>  	if (error)
>  		return error;
>  	info->matrix_ysize = val;
> -- 
> 1.7.7.3
> 

Thanks,
Henrik
