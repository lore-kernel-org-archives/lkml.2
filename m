Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab0JVQOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:14:18 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:49966 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810Ab0JVQOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:14:15 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CC1B9B3.2060402@cam.ac.uk>
Date: Fri, 22 Oct 2010 17:20:03 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Lightning/1.0b3pre Thunderbird/3.1.5
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: eric.piel@tremplin-utc.net, khali@linux-fr.org, guenter.roeck@ericsson.com,
        lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] hwmon: lis3: use block read to access data registers
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com> <1287748654-2626-10-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1287748654-2626-10-git-send-email-samu.p.onkalo@nokia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/10 12:57, Samu Onkalo wrote:
> Add optional blockread function to interface driver. If available
> the chip driver uses it for data register access. For 12 bit device
> it reads 6 bytes to get 3*16bit data. For 8 bit device it reads out
> 5 bytes since every second byte is dummy.
> This optimizes bus usage and reduces number of operations and
> interrupts needed for one data update.
> 
All good now.
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/hwmon/lis3lv02d.c     |   21 ++++++++++++++++++---
>  drivers/hwmon/lis3lv02d.h     |    1 +
>  drivers/hwmon/lis3lv02d_i2c.c |   13 +++++++++++++
>  include/linux/lis3lv02d.h     |    1 +
>  4 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> index 7555091..9fd946c 100644
> --- a/drivers/hwmon/lis3lv02d.c
> +++ b/drivers/hwmon/lis3lv02d.c
> @@ -130,9 +130,24 @@ static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
>  	int position[3];
>  	int i;
>  
> -	position[0] = lis3->read_data(lis3, OUTX);
> -	position[1] = lis3->read_data(lis3, OUTY);
> -	position[2] = lis3->read_data(lis3, OUTZ);
> +	if (lis3->blkread) {
> +		if (lis3_dev.whoami == WAI_12B) {
> +			u16 data[3];
> +			lis3->blkread(lis3, OUTX_L, 6, (u8 *)data);
> +			for (i = 0; i < 3; i++)
> +				position[i] = (s16)le16_to_cpu(data[i]);
> +		} else {
> +			u8 data[5];
> +			/* Data: x, dummy, y, dummy, z */
> +			lis3->blkread(lis3, OUTX, 5, data);
> +			for (i = 0; i < 3; i++)
> +				position[i] = (s8)data[i * 2];
> +		}
> +	} else {
> +		position[0] = lis3->read_data(lis3, OUTX);
> +		position[1] = lis3->read_data(lis3, OUTY);
> +		position[2] = lis3->read_data(lis3, OUTZ);
> +	}
>  
>  	for (i = 0; i < 3; i++)
>  		position[i] = (position[i] * lis3->scale) / LIS3_ACCURACY;
> diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
> index 2ac27b9..d3cb662 100644
> --- a/drivers/hwmon/lis3lv02d.h
> +++ b/drivers/hwmon/lis3lv02d.h
> @@ -225,6 +225,7 @@ struct lis3lv02d {
>  	int (*init) (struct lis3lv02d *lis3);
>  	int (*write) (struct lis3lv02d *lis3, int reg, u8 val);
>  	int (*read) (struct lis3lv02d *lis3, int reg, u8 *ret);
> +	int (*blkread) (struct lis3lv02d *lis3, int reg, int len, u8 *ret);
>  	int (*reg_ctrl) (struct lis3lv02d *lis3, bool state);
>  
>  	int                     *odrs;     /* Supported output data rates */
> diff --git a/drivers/hwmon/lis3lv02d_i2c.c b/drivers/hwmon/lis3lv02d_i2c.c
> index 36171bf..61c109b 100644
> --- a/drivers/hwmon/lis3lv02d_i2c.c
> +++ b/drivers/hwmon/lis3lv02d_i2c.c
> @@ -66,6 +66,14 @@ static inline s32 lis3_i2c_read(struct lis3lv02d *lis3, int reg, u8 *v)
>  	return 0;
>  }
>  
> +static inline s32 lis3_i2c_blockread(struct lis3lv02d *lis3, int reg, int len,
> +				u8 *v)
> +{
> +	struct i2c_client *c = lis3->bus_priv;
> +	reg |= (1 << 7); /* 7th bit enables address auto incrementation */
> +	return i2c_smbus_read_i2c_block_data(c, reg, len, v);
> +}
> +
>  static int lis3_i2c_init(struct lis3lv02d *lis3)
>  {
>  	u8 reg;
> @@ -103,6 +111,11 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
>  		if (pdata->driver_features & LIS3_USE_REGULATOR_CTRL)
>  			lis3_dev.reg_ctrl = lis3_reg_ctrl;
>  
> +		if ((pdata->driver_features & LIS3_USE_BLOCK_READ) &&
> +			(i2c_check_functionality(client->adapter,
> +						I2C_FUNC_SMBUS_I2C_BLOCK)))
> +			lis3_dev.blkread  = lis3_i2c_blockread;
> +
>  		if (pdata->axis_x)
>  			lis3lv02d_axis_map.x = pdata->axis_x;
>  
> diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
> index 18d578f..c949612 100644
> --- a/include/linux/lis3lv02d.h
> +++ b/include/linux/lis3lv02d.h
> @@ -68,6 +68,7 @@ struct lis3lv02d_platform_data {
>  	s8 axis_y;
>  	s8 axis_z;
>  #define LIS3_USE_REGULATOR_CTRL 0x01
> +#define LIS3_USE_BLOCK_READ	0x02
>  	u16 driver_features;
>  	int default_rate;
>  	int (*setup_resources)(void);

