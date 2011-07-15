Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965394Ab1GOKbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 06:31:46 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:46044 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965030Ab1GOKbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 06:31:45 -0400
Date: Fri, 15 Jul 2011 12:31:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>, Grant Likely <grant@secretlab.ca>,
        Ben Dooks <ben-linux@fluff.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: Convert tps65023 to use regmap API
Message-ID: <20110715123121.735688a6@endymion.delvare>
In-Reply-To: <1310710992-24462-4-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110715062215.GN32716@opensource.wolfsonmicro.com>
	<1310710992-24462-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<1310710992-24462-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, 15 Jul 2011 15:23:12 +0900, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Liam Girdwood <lrg@ti.com>
> ---
>  drivers/regulator/Kconfig              |    1 +
>  drivers/regulator/tps65023-regulator.c |   98 +++++++++-----------------------
>  2 files changed, 28 insertions(+), 71 deletions(-)
> 
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index d7ed20f..c8dc5f0 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -235,6 +235,7 @@ config REGULATOR_TPS6105X
>  config REGULATOR_TPS65023
>  	tristate "TI TPS65023 Power regulators"
>  	depends on I2C
> +	select REGMAP
>  	help
>  	  This driver supports TPS65023 voltage regulator chips. TPS65023 provides
>  	  three step-down converters and two general-purpose LDO voltage regulators.
> diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
> index fbddc15..3fa3ba5 100644
> --- a/drivers/regulator/tps65023-regulator.c
> +++ b/drivers/regulator/tps65023-regulator.c
> @@ -25,6 +25,7 @@
>  #include <linux/i2c.h>
>  #include <linux/delay.h>
>  #include <linux/slab.h>
> +#include <linux/regmap.h>
>  
>  /* Register definitions */
>  #define	TPS65023_REG_VERSION		0
> @@ -125,93 +126,35 @@ struct tps_pmic {
>  	struct i2c_client *client;
>  	struct regulator_dev *rdev[TPS65023_NUM_REGULATOR];
>  	const struct tps_info *info[TPS65023_NUM_REGULATOR];
> -	struct mutex io_lock;
> +	struct regmap *regmap;
>  };
>  
> -static inline int tps_65023_read(struct tps_pmic *tps, u8 reg)
> -{
> -	return i2c_smbus_read_byte_data(tps->client, reg);
> -}
> -
> -static inline int tps_65023_write(struct tps_pmic *tps, u8 reg, u8 val)
> -{
> -	return i2c_smbus_write_byte_data(tps->client, reg, val);
> -}
> -

The driver was previously using the SMBus API and could thus work with
SMBus (non-I2C) controllers. After your change, an I2C controller is
mandatory. Are you sure this is OK for all users?

At least you should update the adapter functionality check in
tps_65023_probe() accordingly.

As a general comment, this requirement will considerably limit the
interest of regmap for I2C devices (at least in its current form.) Many
systems out there only have SMBus controllers, and more importantly,
most I2C device drivers are meant to be portable across systems and
thus rely on the SMBus API. The i2c documentation encourages driver
authors to do this.

>  static int tps_65023_set_bits(struct tps_pmic *tps, u8 reg, u8 mask)
>  {
> -	int err, data;
> -
> -	mutex_lock(&tps->io_lock);
> -
> -	data = tps_65023_read(tps, reg);
> -	if (data < 0) {
> -		dev_err(&tps->client->dev, "Read from reg 0x%x failed\n", reg);
> -		err = data;
> -		goto out;
> -	}
> -
> -	data |= mask;
> -	err = tps_65023_write(tps, reg, data);
> -	if (err)
> -		dev_err(&tps->client->dev, "Write for reg 0x%x failed\n", reg);
> -
> -out:
> -	mutex_unlock(&tps->io_lock);
> -	return err;
> +	return regmap_update_bits(tps->regmap, reg, mask, mask);
>  }
>  
>  static int tps_65023_clear_bits(struct tps_pmic *tps, u8 reg, u8 mask)
>  {
> -	int err, data;
> -
> -	mutex_lock(&tps->io_lock);
> -
> -	data = tps_65023_read(tps, reg);
> -	if (data < 0) {
> -		dev_err(&tps->client->dev, "Read from reg 0x%x failed\n", reg);
> -		err = data;
> -		goto out;
> -	}
> -
> -	data &= ~mask;
> -
> -	err = tps_65023_write(tps, reg, data);
> -	if (err)
> -		dev_err(&tps->client->dev, "Write for reg 0x%x failed\n", reg);
> -
> -out:
> -	mutex_unlock(&tps->io_lock);
> -	return err;
> -
> +	return regmap_update_bits(tps->regmap, reg, mask, 0);
>  }
>  
>  static int tps_65023_reg_read(struct tps_pmic *tps, u8 reg)
>  {
> -	int data;
> +	unsigned int val;
> +	int ret;
>  
> -	mutex_lock(&tps->io_lock);
> +	ret = regmap_read(tps->regmap, reg, &val);
>  
> -	data = tps_65023_read(tps, reg);
> -	if (data < 0)
> -		dev_err(&tps->client->dev, "Read from reg 0x%x failed\n", reg);
> -
> -	mutex_unlock(&tps->io_lock);
> -	return data;
> +	if (ret != 0)
> +		return ret;
> +	else
> +		return val;
>  }
>  
>  static int tps_65023_reg_write(struct tps_pmic *tps, u8 reg, u8 val)
>  {
> -	int err;
> -
> -	mutex_lock(&tps->io_lock);
> -
> -	err = tps_65023_write(tps, reg, val);
> -	if (err < 0)
> -		dev_err(&tps->client->dev, "Write for reg 0x%x failed\n", reg);
> -
> -	mutex_unlock(&tps->io_lock);
> -	return err;
> +	return regmap_write(tps->regmap, reg, val);
>  }
>  
>  static int tps65023_dcdc_is_enabled(struct regulator_dev *dev)
> @@ -463,6 +406,10 @@ static struct regulator_ops tps65023_ldo_ops = {
>  	.list_voltage = tps65023_ldo_list_voltage,
>  };
>  
> +static struct regmap_config tps65023_regmap_config = {
> +	.reg_bits = 8, .val_bits = 8,

One value per line, please.

> +};
> +
>  static int __devinit tps_65023_probe(struct i2c_client *client,
>  				     const struct i2c_device_id *id)
>  {
> @@ -488,7 +435,13 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
>  	if (!tps)
>  		return -ENOMEM;
>  
> -	mutex_init(&tps->io_lock);
> +	tps->regmap = regmap_init(&client->dev, &tps65023_regmap_config);
> +	if (IS_ERR(tps->regmap)) {
> +		error = PTR_ERR(tps->regmap);
> +		dev_err(&client->dev, "Failed to allocate register map: %d\n",
> +			error);
> +		goto fail_alloc;
> +	}
>  
>  	/* common for all regulators */
>  	tps->client = client;
> @@ -523,10 +476,12 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
>  
>  	return 0;
>  
> - fail:
> +fail:

The original style is usually preferred for labels. It lets diff -p
skip them and only display actual function names.

>  	while (--i >= 0)
>  		regulator_unregister(tps->rdev[i]);
>  
> +	regmap_exit(tps->regmap);
> +fail_alloc:
>  	kfree(tps);
>  	return error;
>  }
> @@ -545,6 +500,7 @@ static int __devexit tps_65023_remove(struct i2c_client *client)
>  	for (i = 0; i < TPS65023_NUM_REGULATOR; i++)
>  		regulator_unregister(tps->rdev[i]);
>  
> +	regmap_exit(tps->regmap);
>  	kfree(tps);
>  
>  	return 0;


-- 
Jean Delvare
