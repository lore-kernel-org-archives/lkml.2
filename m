Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921Ab1GOCy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 22:54:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64844 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964803Ab1GOCxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 22:53:31 -0400
Date: Thu, 14 Jul 2011 20:53:28 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: Convert tps65023 to use regmap API
Message-ID: <20110715025328.GJ2927@ponder.secretlab.ca>
References: <20110709044923.GB13074@opensource.wolfsonmicro.com>
 <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310187044-13269-4-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310187044-13269-4-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 01:50:44PM +0900, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Liam Girdwood <lrg@ti.com>
> ---
>  drivers/regulator/Kconfig              |    1 +
>  drivers/regulator/tps65023-regulator.c |   98 +++++++++-----------------------
>  2 files changed, 28 insertions(+), 71 deletions(-)

Nice diffstat.  :-)

> 
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index 065892a..8128db3 100644
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

Yeah, if this usage is typical, the caller will always know exactly
what kind of regmap it needs to set up because it had an i2c_client or
an spi_device instance.  I think it would be better to drop the
central registration of regmap bus types and use bus-specific init
variant.  It just makes for one more bit of registration
infrastructure that needs to be setup before any drivers us it.

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
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
