Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab2JHFpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:45:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10241 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2JHFpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:45:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 07 Oct 2012 22:43:10 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Laxman Dewangan <ldewangan@nvidia.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 8 Oct 2012 11:15:15 +0530
Subject: RE: [PATCH 5/5] regulator: tps65090: add external control support
 for DCDC
Thread-Topic: [PATCH 5/5] regulator: tps65090: add external control support
 for DCDC
Thread-Index: Ac2j2nFv7YLxH5wdQlC9RgOfcu2ubABPYo2Q
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDF8AF38E@BGMAIL02.nvidia.com>
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
 <1349536671-31714-7-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1349536671-31714-7-git-send-email-ldewangan@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Laxman Dewangan
> Sent: Saturday, October 06, 2012 8:48 PM
> To: broonie@opensource.wolfsonmicro.com; lrg@ti.com;
> sameo@linux.intel.com
> Cc: Venu Byravarasu; axel.lin@gmail.com; linux-kernel@vger.kernel.org;
> Laxman Dewangan
> Subject: [PATCH 5/5] regulator: tps65090: add external control support for
> DCDC
> 
> The TPS65090's DCDC outut can also be enable/disable through the
> external digital input signal. Add support for enable/disable
> either through register access via I2C or through external
> control inputs. The external control inputs can be driven through
> GPIOs also and hence adding support for passing the GPIO number.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/regulator/tps65090-regulator.c       |  130
> +++++++++++++++++++++++---
>  include/linux/regulator/tps65090-regulator.h |    6 +
>  2 files changed, 122 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/regulator/tps65090-regulator.c
> b/drivers/regulator/tps65090-regulator.c
> index 279154b..e3f130f 100644
> --- a/drivers/regulator/tps65090-regulator.c
> +++ b/drivers/regulator/tps65090-regulator.c
> @@ -18,6 +18,7 @@
> 
>  #include <linux/module.h>
>  #include <linux/init.h>
> +#include <linux/gpio.h>
>  #include <linux/slab.h>
>  #include <linux/err.h>
>  #include <linux/platform_device.h>
> @@ -33,6 +34,18 @@ struct tps65090_regulator {
>  	struct regulator_dev	*rdev;
>  };
> 
> +static inline bool is_dcdc(int id)
> +{
> +	switch (id) {
> +	case TPS65090_REGULATOR_DCDC1:
> +	case TPS65090_REGULATOR_DCDC2:
> +	case TPS65090_REGULATOR_DCDC3:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>  static int tps65090_voltage_get_voltage(struct regulator_dev *rdev)
>  {
>  	struct tps65090_regulator *ri = rdev_get_drvdata(rdev);
> @@ -54,12 +67,17 @@ static int tps65090_voltage_list_voltage(struct
> regulator_dev *rdev,
>  	return ri->microvolts;
>  }
> 
> -static struct regulator_ops tps65090_ops = {
> +static struct regulator_ops tps65090_ext_control_ops = {

Where tps65090_ext_control_ops are used?


> +	.get_voltage	= tps65090_voltage_get_voltage,
> +	.list_voltage	= tps65090_voltage_list_voltage,
> +};
> +
> +static struct regulator_ops tps65090_reg_contol_ops = {
>  	.get_voltage	= tps65090_voltage_get_voltage,
>  	.list_voltage	= tps65090_voltage_list_voltage,
> -	.enable = regulator_enable_regmap,
> -	.disable = regulator_disable_regmap,
> -	.is_enabled = regulator_is_enabled_regmap,
> +	.enable		= regulator_enable_regmap,
> +	.disable	= regulator_disable_regmap,
> +	.is_enabled	= regulator_is_enabled_regmap,
>  };
> 
>  static struct regulator_ops tps65090_ldo_ops = {
> @@ -80,20 +98,76 @@ static struct regulator_ops tps65090_ldo_ops = {
>  }
> 
>  static struct regulator_desc tps65090_regulator_desc[] = {
> -	tps65090_REG_DESC(DCDC1, "vsys1",   0x0C, tps65090_ops),
> -	tps65090_REG_DESC(DCDC2, "vsys2",   0x0D, tps65090_ops),
> -	tps65090_REG_DESC(DCDC3, "vsys3",   0x0E, tps65090_ops),
> -	tps65090_REG_DESC(FET1,  "infet1",  0x0F, tps65090_ops),
> -	tps65090_REG_DESC(FET2,  "infet2",  0x10, tps65090_ops),
> -	tps65090_REG_DESC(FET3,  "infet3",  0x11, tps65090_ops),
> -	tps65090_REG_DESC(FET4,  "infet4",  0x12, tps65090_ops),
> -	tps65090_REG_DESC(FET5,  "infet5",  0x13, tps65090_ops),
> -	tps65090_REG_DESC(FET6,  "infet6",  0x14, tps65090_ops),
> -	tps65090_REG_DESC(FET7,  "infet7",  0x15, tps65090_ops),
> +	tps65090_REG_DESC(DCDC1, "vsys1",   0x0C,
> tps65090_reg_contol_ops),
> +	tps65090_REG_DESC(DCDC2, "vsys2",   0x0D,
> tps65090_reg_contol_ops),
> +	tps65090_REG_DESC(DCDC3, "vsys3",   0x0E,
> tps65090_reg_contol_ops),
> +	tps65090_REG_DESC(FET1,  "infet1",  0x0F,
> tps65090_reg_contol_ops),
> +	tps65090_REG_DESC(FET2,  "infet2",  0x10,
> tps65090_reg_contol_ops),
> +	tps65090_REG_DESC(FET3,  "infet3",  0x11,
> tps65090_reg_contol_ops),
> +	tps65090_REG_DESC(FET4,  "infet4",  0x12,
> tps65090_reg_contol_ops),
> +	tps65090_REG_DESC(FET5,  "infet5",  0x13,
> tps65090_reg_contol_ops),
> +	tps65090_REG_DESC(FET6,  "infet6",  0x14,
> tps65090_reg_contol_ops),
> +	tps65090_REG_DESC(FET7,  "infet7",  0x15,
> tps65090_reg_contol_ops),
>  	tps65090_REG_DESC(LDO1,  "vsys_l1", 0,    tps65090_ldo_ops),
>  	tps65090_REG_DESC(LDO2,  "vsys_l2", 0,    tps65090_ldo_ops),
>  };
> 
> +static int __devinit tps65090_set_ext_control(
> +	struct tps65090_regulator *ri, bool enable)
> +{
> +	int ret;
> +	struct device *parent = ri->dev->parent;
> +	unsigned int reg_en_reg = ri->desc->enable_reg;
> +
> +	if (enable)
> +		ret = tps65090_set_bits(parent, reg_en_reg, 1);
> +	else
> +		ret =  tps65090_clr_bits(parent, reg_en_reg, 1);
> +	if (ret < 0)
> +		dev_err(ri->dev, "Error in updating reg 0x%x\n", reg_en_reg);
> +	return ret;
> +}
> +
> +static int __devinit tps65090_regulator_disable_ext_control(
> +		struct tps65090_regulator *ri,
> +		struct tps65090_regulator_platform_data *tps_pdata)
> +{
> +	int ret = 0;
> +	struct device *parent = ri->dev->parent;
> +	unsigned int reg_en_reg = ri->desc->enable_reg;
> +
> +	/*
> +	 * First enable output for internal control if require.
> +	 * And then disable external control.
> +	 */
> +	if (tps_pdata->reg_init_data->constraints.always_on ||
> +			tps_pdata->reg_init_data->constraints.boot_on) {
> +		ret =  tps65090_set_bits(parent, reg_en_reg, 0);
> +		if (ret < 0) {
> +			dev_err(ri->dev, "Error in set reg 0x%x\n",
> reg_en_reg);
> +			return ret;
> +		}
> +	}
> +
> +	return tps65090_set_ext_control(ri, false);
> +}
> +
> +static void __devinit tps65090_configure_regulator_config(
> +		struct tps65090_regulator_platform_data *tps_pdata,
> +		struct regulator_config *config)
> +{
> +	if (gpio_is_valid(tps_pdata->gpio)) {
> +		int gpio_flag = GPIOF_OUT_INIT_LOW;
> +
> +		if (tps_pdata->reg_init_data->constraints.always_on ||
> +				tps_pdata->reg_init_data-
> >constraints.boot_on)
> +			gpio_flag = GPIOF_OUT_INIT_HIGH;
> +
> +		config->ena_gpio = tps_pdata->gpio;
> +		config->ena_gpio_flags = gpio_flag;
> +	}
> +}
> +
>  static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
>  {
>  	struct tps65090 *tps65090_mfd = dev_get_drvdata(pdev-
> >dev.parent);
> @@ -128,6 +202,23 @@ static int __devinit tps65090_regulator_probe(struct
> platform_device *pdev)
>  		ri->dev = &pdev->dev;
>  		ri->desc = &tps65090_regulator_desc[num];
> 
> +		/* Configure for external control for DCDC*/
> +		if (tps_pdata && is_dcdc(num) && tps_pdata->reg_init_data)
> {
> +			if (tps_pdata->enable_ext_control) {
> +				tps65090_configure_regulator_config(
> +						tps_pdata, &config);
> +				ri->desc->ops = &tps65090_ext_control_ops;
> +			} else {
> +				ret =
> tps65090_regulator_disable_ext_control(
> +						ri, tps_pdata);
> +				if (ret < 0) {
> +					dev_err(&pdev->dev,
> +						"failed disable ext
> control\n");
> +					goto scrub;
> +				}
> +			}
> +		}
> +
>  		config.dev = &pdev->dev;
>  		config.driver_data = ri;
>  		config.regmap = tps65090_mfd->rmap;
> @@ -146,6 +237,17 @@ static int __devinit tps65090_regulator_probe(struct
> platform_device *pdev)
>  			goto scrub;
>  		}
>  		ri->rdev = rdev;
> +
> +		/* Enable external control if it is require */
> +		if (tps_pdata && is_dcdc(num) && tps_pdata->reg_init_data
> &&
> +				tps_pdata->enable_ext_control) {
> +			ret = tps65090_set_ext_control(ri, true);
> +			if (ret < 0) {
> +				/* Increment num to get unregister rdev */
> +				num++;
> +				goto scrub;
> +			}
> +		}
>  	}
> 
>  	platform_set_drvdata(pdev, pmic);
> diff --git a/include/linux/regulator/tps65090-regulator.h
> b/include/linux/regulator/tps65090-regulator.h
> index 0b29ffa..3822136 100644
> --- a/include/linux/regulator/tps65090-regulator.h
> +++ b/include/linux/regulator/tps65090-regulator.h
> @@ -46,11 +46,17 @@ enum {
>   *
>   * @reg_init_data: The regulator init data.
>   * @microvolts: The rail's voltage level.
> + * @enable_ext_control: Enable extrenal control or not. Only available for
> + *	DCDC1, DCDC2 and DCDC3.
> + * @gpio: Gpio number if external control is enabled and controlled through
> + *	gpio.
>   */
> 
>  struct tps65090_regulator_platform_data {
>  	struct regulator_init_data *reg_init_data;
>  	int microvolts;
> +	bool enable_ext_control;
> +	int gpio;
>  };
> 
>  #endif	/* __REGULATOR_TPS65090_H */
> --
> 1.7.1.1

