Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab0JXPGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 11:06:49 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:60384 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab0JXPGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 11:06:45 -0400
X-Spam-Flag: NO
X-Spam-Score: -21.89
Message-ID: <4CC449CE.7070607@tremplin-utc.net>
Date: Sun, 24 Oct 2010 16:59:26 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Mandriva/3.1.5-1mdv2011.0 (2011.0) Thunderbird/3.1.5
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: khali@linux-fr.org, guenter.roeck@ericsson.com, jic23@cam.ac.uk,
        lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] hwmon: lis3: regulator control
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com> <1287748654-2626-3-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1287748654-2626-3-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 22-10-10 13:57, Samu Onkalo schreef:
> Based on pm_runtime control, turn lis3 regulators on and off.
> Perform context save and restore on transitions.
>
> Feature is optional and must be enabled in platform data.
>
> Signed-off-by: Samu Onkalo<samu.p.onkalo@nokia.com>
I have very little knowledge about regulators, but for what I could 
understand it looks fine...

Acked-by: Eric Piel <eric.piel@tremplin-utc.net>

> ---
>   drivers/hwmon/lis3lv02d.c     |   52 ++++++++++++++++++++++++++++++++++++++
>   drivers/hwmon/lis3lv02d.h     |   12 +++++++++
>   drivers/hwmon/lis3lv02d_i2c.c |   55 ++++++++++++++++++++++++++++++++++++++++-
>   include/linux/lis3lv02d.h     |    2 +
>   4 files changed, 120 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> index 412ddc3..ade6f3a 100644
> --- a/drivers/hwmon/lis3lv02d.c
> +++ b/drivers/hwmon/lis3lv02d.c
> @@ -31,6 +31,7 @@
>   #include<linux/delay.h>
>   #include<linux/wait.h>
>   #include<linux/poll.h>
> +#include<linux/slab.h>
>   #include<linux/freezer.h>
>   #include<linux/uaccess.h>
>   #include<linux/miscdevice.h>
> @@ -223,10 +224,46 @@ fail:
>   	return ret;
>   }
>
> +/*
> + * Order of registers in the list affects to order of the restore process.
> + * Perhaps it is a good idea to set interrupt enable register as a last one
> + * after all other configurations
> + */
> +static u8 lis3_wai8_regs[] = { FF_WU_CFG_1, FF_WU_THS_1, FF_WU_DURATION_1,
> +			       FF_WU_CFG_2, FF_WU_THS_2, FF_WU_DURATION_2,
> +			       CLICK_CFG, CLICK_SRC, CLICK_THSY_X, CLICK_THSZ,
> +			       CLICK_TIMELIMIT, CLICK_LATENCY, CLICK_WINDOW,
> +			       CTRL_REG1, CTRL_REG2, CTRL_REG3};
> +
> +static u8 lis3_wai12_regs[] = {FF_WU_CFG, FF_WU_THS_L, FF_WU_THS_H,
> +			       FF_WU_DURATION, DD_CFG, DD_THSI_L, DD_THSI_H,
> +			       DD_THSE_L, DD_THSE_H,
> +			       CTRL_REG1, CTRL_REG3, CTRL_REG2};
> +
> +static inline void lis3_context_save(struct lis3lv02d *lis3)
> +{
> +	int i;
> +	for (i = 0; i<  lis3->regs_size; i++)
> +		lis3->read(lis3, lis3->regs[i],&lis3->reg_cache[i]);
> +	lis3->regs_stored = true;
> +}
> +
> +static inline void lis3_context_restore(struct lis3lv02d *lis3)
> +{
> +	int i;
> +	if (lis3->regs_stored)
> +		for (i = 0; i<  lis3->regs_size; i++)
> +			lis3->write(lis3, lis3->regs[i], lis3->reg_cache[i]);
> +}
> +
>   void lis3lv02d_poweroff(struct lis3lv02d *lis3)
>   {
> +	if (lis3->reg_ctrl)
> +		lis3_context_save(lis3);
>   	/* disable X,Y,Z axis and power down */
>   	lis3->write(lis3, CTRL_REG1, 0x00);
> +	if (lis3->reg_ctrl)
> +		lis3->reg_ctrl(lis3, LIS3_REG_OFF);
>   }
>   EXPORT_SYMBOL_GPL(lis3lv02d_poweroff);
>
> @@ -249,6 +286,8 @@ void lis3lv02d_poweron(struct lis3lv02d *lis3)
>   		reg |= CTRL2_BDU;
>   		lis3->write(lis3, CTRL_REG2, reg);
>   	}
> +	if (lis3->reg_ctrl)
> +		lis3_context_restore(lis3);
>   }
>   EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
>
> @@ -640,6 +679,7 @@ int lis3lv02d_remove_fs(struct lis3lv02d *lis3)
>   		pm_runtime_disable(lis3->pm_dev);
>   		pm_runtime_set_suspended(lis3->pm_dev);
>   	}
> +	kfree(lis3->reg_cache);
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
> @@ -719,6 +759,8 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
>   		dev->odrs = lis3_12_rates;
>   		dev->odr_mask = CTRL1_DF0 | CTRL1_DF1;
>   		dev->scale = LIS3_SENSITIVITY_12B;
> +		dev->regs = lis3_wai12_regs;
> +		dev->regs_size = ARRAY_SIZE(lis3_wai12_regs);
>   		break;
>   	case WAI_8B:
>   		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
> @@ -728,6 +770,8 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
>   		dev->odrs = lis3_8_rates;
>   		dev->odr_mask = CTRL1_DR;
>   		dev->scale = LIS3_SENSITIVITY_8B;
> +		dev->regs = lis3_wai8_regs;
> +		dev->regs_size = ARRAY_SIZE(lis3_wai8_regs);
>   		break;
>   	default:
>   		printk(KERN_ERR DRIVER_NAME
> @@ -735,6 +779,14 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
>   		return -EINVAL;
>   	}
>
> +	dev->reg_cache = kzalloc(max(sizeof(lis3_wai8_regs),
> +				     sizeof(lis3_wai12_regs)), GFP_KERNEL);
> +
> +	if (dev->reg_cache == NULL) {
> +		printk(KERN_ERR DRIVER_NAME "out of memory\n");
> +		return -ENOMEM;
> +	}
> +
>   	mutex_init(&dev->mutex);
>
>   	lis3lv02d_add_fs(dev);
> diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
> index 3e8a208..7661e59 100644
> --- a/drivers/hwmon/lis3lv02d.h
> +++ b/drivers/hwmon/lis3lv02d.h
> @@ -20,6 +20,7 @@
>    */
>   #include<linux/platform_device.h>
>   #include<linux/input-polldev.h>
> +#include<linux/regulator/consumer.h>
>
>   /*
>    * This driver tries to support the "digital" accelerometer chips from
> @@ -206,6 +207,11 @@ enum lis3lv02d_click_src_8b {
>   	CLICK_IA	= 0x40,
>   };
>
> +enum lis3lv02d_reg_state {
> +	LIS3_REG_OFF	= 0x00,
> +	LIS3_REG_ON	= 0x01,
> +};
> +
>   struct axis_conversion {
>   	s8	x;
>   	s8	y;
> @@ -218,8 +224,13 @@ struct lis3lv02d {
>   	int (*init) (struct lis3lv02d *lis3);
>   	int (*write) (struct lis3lv02d *lis3, int reg, u8 val);
>   	int (*read) (struct lis3lv02d *lis3, int reg, u8 *ret);
> +	int (*reg_ctrl) (struct lis3lv02d *lis3, bool state);
>
>   	int                     *odrs;     /* Supported output data rates */
> +	u8			*regs;	   /* Regs to store / restore */
> +	int			regs_size;
> +	u8                      *reg_cache;
> +	bool			regs_stored;
>   	u8                      odr_mask;  /* ODR bit mask */
>   	u8			whoami;    /* indicates measurement precision */
>   	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
> @@ -232,6 +243,7 @@ struct lis3lv02d {
>
>   	struct input_polled_dev	*idev;     /* input device */
>   	struct platform_device	*pdev;     /* platform device */
> +	struct regulator_bulk_data regulators[2];
>   	atomic_t		count;     /* interrupt count after last read */
>   	struct axis_conversion	ac;        /* hw ->  logical axis */
>   	int			mapped_btns[3];
> diff --git a/drivers/hwmon/lis3lv02d_i2c.c b/drivers/hwmon/lis3lv02d_i2c.c
> index 6e965d7..98983cc 100644
> --- a/drivers/hwmon/lis3lv02d_i2c.c
> +++ b/drivers/hwmon/lis3lv02d_i2c.c
> @@ -30,10 +30,29 @@
>   #include<linux/err.h>
>   #include<linux/i2c.h>
>   #include<linux/pm_runtime.h>
> +#include<linux/delay.h>
>   #include "lis3lv02d.h"
>
>   #define DRV_NAME 	"lis3lv02d_i2c"
>
> +static const char reg_vdd[]    = "Vdd";
> +static const char reg_vdd_io[] = "Vdd_IO";
> +
> +static int lis3_reg_ctrl(struct lis3lv02d *lis3, bool state)
> +{
> +	int ret;
> +	if (state == LIS3_REG_OFF) {
> +		ret = regulator_bulk_disable(ARRAY_SIZE(lis3->regulators),
> +					lis3->regulators);
> +	} else {
> +		ret = regulator_bulk_enable(ARRAY_SIZE(lis3->regulators),
> +					lis3->regulators);
> +		/* Chip needs time to wakeup. Not mentioned in datasheet */
> +		usleep_range(10000, 20000);
> +	}
> +	return ret;
> +}
> +
>   static inline s32 lis3_i2c_write(struct lis3lv02d *lis3, int reg, u8 value)
>   {
>   	struct i2c_client *c = lis3->bus_priv;
> @@ -52,6 +71,13 @@ static int lis3_i2c_init(struct lis3lv02d *lis3)
>   	u8 reg;
>   	int ret;
>
> +	if (lis3->reg_ctrl)
> +		lis3_reg_ctrl(lis3, LIS3_REG_ON);
> +
> +	lis3->read(lis3, WHO_AM_I,&reg);
> +	if (reg != lis3->whoami)
> +		printk(KERN_ERR "lis3: power on failure\n");
> +
>   	/* power up the device */
>   	ret = lis3->read(lis3, CTRL_REG1,&reg);
>   	if (ret<  0)
> @@ -73,6 +99,10 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
>   	struct lis3lv02d_platform_data *pdata = client->dev.platform_data;
>
>   	if (pdata) {
> +		/* Regulator control is optional */
> +		if (pdata->driver_features&  LIS3_USE_REGULATOR_CTRL)
> +			lis3_dev.reg_ctrl = lis3_reg_ctrl;
> +
>   		if (pdata->axis_x)
>   			lis3lv02d_axis_map.x = pdata->axis_x;
>
> @@ -89,6 +119,16 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
>   			goto fail;
>   	}
>
> +	if (lis3_dev.reg_ctrl) {
> +		lis3_dev.regulators[0].supply = reg_vdd;
> +		lis3_dev.regulators[1].supply = reg_vdd_io;
> +		ret = regulator_bulk_get(&client->dev,
> +					ARRAY_SIZE(lis3_dev.regulators),
> +					lis3_dev.regulators);
> +		if (ret<  0)
> +			goto fail;
> +	}
> +
>   	lis3_dev.pdata	  = pdata;
>   	lis3_dev.bus_priv = client;
>   	lis3_dev.init	  = lis3_i2c_init;
> @@ -99,21 +139,34 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
>   	lis3_dev.pm_dev	  =&client->dev;
>
>   	i2c_set_clientdata(client,&lis3_dev);
> +
> +	/* Provide power over the init call */
> +	if (lis3_dev.reg_ctrl)
> +		lis3_reg_ctrl(&lis3_dev, LIS3_REG_ON);
> +
>   	ret = lis3lv02d_init_device(&lis3_dev);
> +
> +	if (lis3_dev.reg_ctrl)
> +		lis3_reg_ctrl(&lis3_dev, LIS3_REG_OFF);
>   fail:
>   	return ret;
>   }
>
>   static int __devexit lis3lv02d_i2c_remove(struct i2c_client *client)
>   {
> +	struct lis3lv02d *lis3 = i2c_get_clientdata(client);
>   	struct lis3lv02d_platform_data *pdata = client->dev.platform_data;
>
>   	if (pdata&&  pdata->release_resources)
>   		pdata->release_resources();
>
>   	lis3lv02d_joystick_disable();
> +	lis3lv02d_remove_fs(&lis3_dev);
>
> -	return lis3lv02d_remove_fs(&lis3_dev);
> +	if (lis3_dev.reg_ctrl)
> +		regulator_bulk_free(ARRAY_SIZE(lis3->regulators),
> +				lis3_dev.regulators);
> +	return 0;
>   }
>
>   #ifdef CONFIG_PM
> diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
> index 0e8a346..c4a4a52 100644
> --- a/include/linux/lis3lv02d.h
> +++ b/include/linux/lis3lv02d.h
> @@ -64,6 +64,8 @@ struct lis3lv02d_platform_data {
>   	s8 axis_x;
>   	s8 axis_y;
>   	s8 axis_z;
> +#define LIS3_USE_REGULATOR_CTRL 0x01
> +	u16 driver_features;
>   	int (*setup_resources)(void);
>   	int (*release_resources)(void);
>   	/* Limits for selftest are specified in chip data sheet */

