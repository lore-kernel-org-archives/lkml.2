Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2FRNOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:14:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59654 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2FRNOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:14:03 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: RE: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Thread-Topic: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Thread-Index: AQHNSRRxSJBCL2eqoUaZnppvZVbxc5cABuwQ
Date: Mon, 18 Jun 2012 13:13:56 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9D859D@DBDE01.ent.ti.com>
References: <1339558031.26190.4.camel@phoenix>
In-Reply-To: <1339558031.26190.4.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

Thanks for the patch.

Tested-by: AnilKumar Ch <anilkumar@ti.com>

On Wed, Jun 13, 2012 at 08:57:11, Axel Lin wrote:
> This patch converts .is_enabled and .get_voltage_sel to
> regulator_is_enabled_regmap and regulator_get_voltage_sel_regmap.
> 
> For .enable, .disable, and .set_voltage_sel, the write protect level is either
> 1 or 2. So we cannot use regulator_[enable|disable|set_voltage_sel]_regmap.
> 
> Now we store the enable reg/mask and vsel reg/mask in regulator_desc,
> so we can remove enable_mask, set_vout_reg, and set_vout_mask from
> struct tps_info.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Hi AnilKumar,
> Any chance to test this patch on your hardware?
> 
> Thanks,
> Axel
> 
>  drivers/regulator/tps65217-regulator.c |  114 ++++++++++++--------------------
>  include/linux/mfd/tps65217.h           |    6 --
>  2 files changed, 42 insertions(+), 78 deletions(-)
> 
> diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
> index 9d371d2..f5fa05b 100644
> --- a/drivers/regulator/tps65217-regulator.c
> +++ b/drivers/regulator/tps65217-regulator.c
> @@ -26,7 +26,7 @@
>  #include <linux/regulator/machine.h>
>  #include <linux/mfd/tps65217.h>
>  
> -#define TPS65217_REGULATOR(_name, _id, _ops, _n)	\
> +#define TPS65217_REGULATOR(_name, _id, _ops, _n, _vr, _vm, _em)	\
>  	{						\
>  		.name		= _name,		\
>  		.id		= _id,			\
> @@ -34,9 +34,13 @@
>  		.n_voltages	= _n,			\
>  		.type		= REGULATOR_VOLTAGE,	\
>  		.owner		= THIS_MODULE,		\
> +		.vsel_reg	= _vr,			\
> +		.vsel_mask	= _vm,			\
> +		.enable_reg	= TPS65217_REG_ENABLE,	\
> +		.enable_mask	= _em,			\
>  	}						\
>  
> -#define TPS65217_INFO(_nm, _min, _max, _f1, _f2, _t, _n, _em, _vr, _vm)	\
> +#define TPS65217_INFO(_nm, _min, _max, _f1, _f2, _t, _n)\
>  	{						\
>  		.name		= _nm,			\
>  		.min_uV		= _min,			\
> @@ -45,9 +49,6 @@
>  		.uv_to_vsel	= _f2,			\
>  		.table		= _t,			\
>  		.table_len	= _n,			\
> -		.enable_mask	= _em,			\
> -		.set_vout_reg	= _vr,			\
> -		.set_vout_mask	= _vm,			\
>  	}
>  
>  static const int LDO1_VSEL_table[] = {
> @@ -127,46 +128,21 @@ static int tps65217_uv_to_vsel2(int uV, unsigned int *vsel)
>  
>  static struct tps_info tps65217_pmic_regs[] = {
>  	TPS65217_INFO("DCDC1", 900000, 1800000, tps65217_vsel_to_uv1,
> -			tps65217_uv_to_vsel1, NULL, 64, TPS65217_ENABLE_DC1_EN,
> -			TPS65217_REG_DEFDCDC1, TPS65217_DEFDCDCX_DCDC_MASK),
> +			tps65217_uv_to_vsel1, NULL, 64),
>  	TPS65217_INFO("DCDC2", 900000, 3300000, tps65217_vsel_to_uv1,
> -			tps65217_uv_to_vsel1, NULL, 64, TPS65217_ENABLE_DC2_EN,
> -			TPS65217_REG_DEFDCDC2, TPS65217_DEFDCDCX_DCDC_MASK),
> +			tps65217_uv_to_vsel1, NULL, 64),
>  	TPS65217_INFO("DCDC3", 900000, 1500000, tps65217_vsel_to_uv1,
> -			tps65217_uv_to_vsel1, NULL, 64, TPS65217_ENABLE_DC3_EN,
> -			TPS65217_REG_DEFDCDC3, TPS65217_DEFDCDCX_DCDC_MASK),
> +			tps65217_uv_to_vsel1, NULL, 64),
>  	TPS65217_INFO("LDO1", 1000000, 3300000, NULL, NULL, LDO1_VSEL_table,
> -			16, TPS65217_ENABLE_LDO1_EN, TPS65217_REG_DEFLDO1,
> -			TPS65217_DEFLDO1_LDO1_MASK),
> +			16),
>  	TPS65217_INFO("LDO2", 900000, 3300000, tps65217_vsel_to_uv1,
> -			tps65217_uv_to_vsel1, NULL, 64, TPS65217_ENABLE_LDO2_EN,
> -			TPS65217_REG_DEFLDO2, TPS65217_DEFLDO2_LDO2_MASK),
> +			tps65217_uv_to_vsel1, NULL, 64),
>  	TPS65217_INFO("LDO3", 1800000, 3300000, tps65217_vsel_to_uv2,
> -			tps65217_uv_to_vsel2, NULL, 32,
> -			TPS65217_ENABLE_LS1_EN | TPS65217_DEFLDO3_LDO3_EN,
> -			TPS65217_REG_DEFLS1, TPS65217_DEFLDO3_LDO3_MASK),
> +			tps65217_uv_to_vsel2, NULL, 32),
>  	TPS65217_INFO("LDO4", 1800000, 3300000, tps65217_vsel_to_uv2,
> -			tps65217_uv_to_vsel2, NULL, 32,
> -			TPS65217_ENABLE_LS2_EN | TPS65217_DEFLDO4_LDO4_EN,
> -			TPS65217_REG_DEFLS2, TPS65217_DEFLDO4_LDO4_MASK),
> +			tps65217_uv_to_vsel2, NULL, 32),
>  };
>  
> -static int tps65217_pmic_is_enabled(struct regulator_dev *dev)
> -{
> -	int ret;
> -	struct tps65217 *tps = rdev_get_drvdata(dev);
> -	unsigned int data, rid = rdev_get_id(dev);
> -
> -	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
> -		return -EINVAL;
> -
> -	ret = tps65217_reg_read(tps, TPS65217_REG_ENABLE, &data);
> -	if (ret)
> -		return ret;
> -
> -	return (data & tps->info[rid]->enable_mask) ? 1 : 0;
> -}
> -
>  static int tps65217_pmic_enable(struct regulator_dev *dev)
>  {
>  	struct tps65217 *tps = rdev_get_drvdata(dev);
> @@ -177,9 +153,8 @@ static int tps65217_pmic_enable(struct regulator_dev *dev)
>  
>  	/* Enable the regulator and password protection is level 1 */
>  	return tps65217_set_bits(tps, TPS65217_REG_ENABLE,
> -				tps->info[rid]->enable_mask,
> -				tps->info[rid]->enable_mask,
> -				TPS65217_PROTECT_L1);
> +				 dev->desc->enable_mask, dev->desc->enable_mask,
> +				 TPS65217_PROTECT_L1);
>  }
>  
>  static int tps65217_pmic_disable(struct regulator_dev *dev)
> @@ -192,25 +167,7 @@ static int tps65217_pmic_disable(struct regulator_dev *dev)
>  
>  	/* Disable the regulator and password protection is level 1 */
>  	return tps65217_clear_bits(tps, TPS65217_REG_ENABLE,
> -			tps->info[rid]->enable_mask, TPS65217_PROTECT_L1);
> -}
> -
> -static int tps65217_pmic_get_voltage_sel(struct regulator_dev *dev)
> -{
> -	int ret;
> -	struct tps65217 *tps = rdev_get_drvdata(dev);
> -	unsigned int selector, rid = rdev_get_id(dev);
> -
> -	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
> -		return -EINVAL;
> -
> -	ret = tps65217_reg_read(tps, tps->info[rid]->set_vout_reg, &selector);
> -	if (ret)
> -		return ret;
> -
> -	selector &= tps->info[rid]->set_vout_mask;
> -
> -	return selector;
> +				   dev->desc->enable_mask, TPS65217_PROTECT_L1);
>  }
>  
>  static int tps65217_pmic_set_voltage_sel(struct regulator_dev *dev,
> @@ -221,8 +178,7 @@ static int tps65217_pmic_set_voltage_sel(struct regulator_dev *dev,
>  	unsigned int rid = rdev_get_id(dev);
>  
>  	/* Set the voltage based on vsel value and write protect level is 2 */
> -	ret = tps65217_set_bits(tps, tps->info[rid]->set_vout_reg,
> -				tps->info[rid]->set_vout_mask,
> +	ret = tps65217_set_bits(tps, dev->desc->vsel_reg, dev->desc->vsel_mask,
>  				selector, TPS65217_PROTECT_L2);
>  
>  	/* Set GO bit for DCDCx to initiate voltage transistion */
> @@ -285,10 +241,10 @@ static int tps65217_pmic_list_voltage(struct regulator_dev *dev,
>  
>  /* Operations permitted on DCDCx, LDO2, LDO3 and LDO4 */
>  static struct regulator_ops tps65217_pmic_ops = {
> -	.is_enabled		= tps65217_pmic_is_enabled,
> +	.is_enabled		= regulator_is_enabled_regmap,
>  	.enable			= tps65217_pmic_enable,
>  	.disable		= tps65217_pmic_disable,
> -	.get_voltage_sel	= tps65217_pmic_get_voltage_sel,
> +	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
>  	.set_voltage_sel	= tps65217_pmic_set_voltage_sel,
>  	.list_voltage		= tps65217_pmic_list_voltage,
>  	.map_voltage		= tps65217_pmic_map_voltage,
> @@ -296,22 +252,36 @@ static struct regulator_ops tps65217_pmic_ops = {
>  
>  /* Operations permitted on LDO1 */
>  static struct regulator_ops tps65217_pmic_ldo1_ops = {
> -	.is_enabled		= tps65217_pmic_is_enabled,
> +	.is_enabled		= regulator_is_enabled_regmap,
>  	.enable			= tps65217_pmic_enable,
>  	.disable		= tps65217_pmic_disable,
> -	.get_voltage_sel	= tps65217_pmic_get_voltage_sel,
> +	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
>  	.set_voltage_sel	= tps65217_pmic_set_voltage_sel,
>  	.list_voltage		= tps65217_pmic_list_voltage,
>  };
>  
>  static const struct regulator_desc regulators[] = {
> -	TPS65217_REGULATOR("DCDC1", TPS65217_DCDC_1, tps65217_pmic_ops, 64),
> -	TPS65217_REGULATOR("DCDC2", TPS65217_DCDC_2, tps65217_pmic_ops, 64),
> -	TPS65217_REGULATOR("DCDC3", TPS65217_DCDC_3, tps65217_pmic_ops, 64),
> -	TPS65217_REGULATOR("LDO1", TPS65217_LDO_1, tps65217_pmic_ldo1_ops, 16),
> -	TPS65217_REGULATOR("LDO2", TPS65217_LDO_2, tps65217_pmic_ops, 64),
> -	TPS65217_REGULATOR("LDO3", TPS65217_LDO_3, tps65217_pmic_ops, 32),
> -	TPS65217_REGULATOR("LDO4", TPS65217_LDO_4, tps65217_pmic_ops, 32),
> +	TPS65217_REGULATOR("DCDC1", TPS65217_DCDC_1, tps65217_pmic_ops, 64,
> +			   TPS65217_REG_DEFDCDC1, TPS65217_DEFDCDCX_DCDC_MASK,
> +			   TPS65217_ENABLE_DC1_EN),
> +	TPS65217_REGULATOR("DCDC2", TPS65217_DCDC_2, tps65217_pmic_ops, 64,
> +			   TPS65217_REG_DEFDCDC2, TPS65217_DEFDCDCX_DCDC_MASK,
> +			   TPS65217_ENABLE_DC2_EN),
> +	TPS65217_REGULATOR("DCDC3", TPS65217_DCDC_3, tps65217_pmic_ops, 64,
> +			   TPS65217_REG_DEFDCDC3, TPS65217_DEFDCDCX_DCDC_MASK,
> +			   TPS65217_ENABLE_DC3_EN),
> +	TPS65217_REGULATOR("LDO1", TPS65217_LDO_1, tps65217_pmic_ldo1_ops, 16,
> +			   TPS65217_REG_DEFLDO1, TPS65217_DEFLDO1_LDO1_MASK,
> +			   TPS65217_ENABLE_LDO1_EN),
> +	TPS65217_REGULATOR("LDO2", TPS65217_LDO_2, tps65217_pmic_ops, 64,
> +			   TPS65217_REG_DEFLDO2, TPS65217_DEFLDO2_LDO2_MASK,
> +			   TPS65217_ENABLE_LDO2_EN),
> +	TPS65217_REGULATOR("LDO3", TPS65217_LDO_3, tps65217_pmic_ops, 32,
> +			   TPS65217_REG_DEFLS1, TPS65217_DEFLDO3_LDO3_MASK,
> +			   TPS65217_ENABLE_LS1_EN | TPS65217_DEFLDO3_LDO3_EN),
> +	TPS65217_REGULATOR("LDO4", TPS65217_LDO_4, tps65217_pmic_ops, 32,
> +			   TPS65217_REG_DEFLS2, TPS65217_DEFLDO4_LDO4_MASK,
> +			   TPS65217_ENABLE_LS2_EN | TPS65217_DEFLDO4_LDO4_EN),
>  };
>  
>  static int __devinit tps65217_regulator_probe(struct platform_device *pdev)
> diff --git a/include/linux/mfd/tps65217.h b/include/linux/mfd/tps65217.h
> index e030ef9..4e035a4 100644
> --- a/include/linux/mfd/tps65217.h
> +++ b/include/linux/mfd/tps65217.h
> @@ -229,9 +229,6 @@ struct tps65217_board {
>   * @uv_to_vsel:		Function pointer to get selector from voltage
>   * @table:		Table for non-uniform voltage step-size
>   * @table_len:		Length of the voltage table
> - * @enable_mask:	Regulator enable mask bits
> - * @set_vout_reg:	Regulator output voltage set register
> - * @set_vout_mask:	Regulator output voltage set mask
>   *
>   * This data is used to check the regualtor voltage limits while setting.
>   */
> @@ -243,9 +240,6 @@ struct tps_info {
>  	int (*uv_to_vsel)(int uV, unsigned int *vsel);
>  	const int *table;
>  	unsigned int table_len;
> -	unsigned int enable_mask;
> -	unsigned int set_vout_reg;
> -	unsigned int set_vout_mask;
>  };
>  
>  /**
> -- 
> 1.7.9.5
> 
> 
> 
> 

