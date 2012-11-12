Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab2KLM3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 07:29:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53444 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2KLM3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 07:29:03 -0500
Date: Mon, 12 Nov 2012 13:28:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Laxman Dewangan <ldewangan@nvidia.com>
cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/2] regulator: tps80031: add regulator driver for
 tps80031
In-Reply-To: <1352646721-8350-3-git-send-email-ldewangan@nvidia.com>
Message-ID: <Pine.LNX.4.64.1211121249000.29665@axis700.grange>
References: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com>
 <1352646721-8350-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:AqzGKCe9R2QkuogP6QI33eIv0Cf4/g6QtMUHtIcDQOm
 PupDNpg4MiEqypQzEJXu8NyY0ERcRvejfQFeU+x1XxTNadM829
 50VR3I7R8pbuzEAO4LonzWNP3Vq8038wS8MOdUL1CvydUGjMYs
 y9uC5pkgW49BJWcCxz17dy9yffu8tl/uQxq54xzrtw+7EEGc2V
 apVmOMzfjF1r5HjCgaDjTWne3ELfIwxr3hPOAj/kXbTAVvrVPk
 zHk2SuO+4Hm0QB3ERuKDSJPW55ReOTzmmQL890c/kTMlq1WFBa
 /MUwfJzixPfla13mlyt7NMl7AcuFCNkXeHqhpHYokay6QhBsyd
 gb6eXJ/J2TugW/FOm+5Vndynlprar1smicHuZ3ieFX3KRPstEz
 0VrhpHWoz7AGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman

A couple of nit-picks below.

On Sun, 11 Nov 2012, Laxman Dewangan wrote:

> Add regulator driver for Texas Instrument TPS80031/TPS80032 device.
> TPS80031/ TPS80032 Fully Integrated Power Management with Power
> Path and Battery Charger. It has 5 configurable step-down
> converters, 11 general purpose LDOs, VBUS generator and digital
> output to control regulators.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1: 
> - Rewrite dcdc get voltage apis.
> - Remove -1 and +1 in vsel.
> - Correct the vbus ops for sw and hw based.
> 
> Changes from V2:
> - Move header file changes to first patch so easy to apply on subsystem tree.
> 
>  drivers/regulator/Kconfig              |    9 +
>  drivers/regulator/Makefile             |    1 +
>  drivers/regulator/tps80031-regulator.c |  789 ++++++++++++++++++++++++++++++++
>  3 files changed, 799 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/regulator/tps80031-regulator.c
> 

[snip]

> diff --git a/drivers/regulator/tps80031-regulator.c b/drivers/regulator/tps80031-regulator.c
> new file mode 100644
> index 0000000..0484478
> --- /dev/null
> +++ b/drivers/regulator/tps80031-regulator.c
> @@ -0,0 +1,789 @@

[snip]

> +static inline struct device *to_tps80031_dev(struct regulator_dev *rdev)

"inline" is not needed, the compiler will decide by itself.

> +{
> +	return rdev_get_dev(rdev)->parent->parent;
> +}

[snip]

> +static int tps80031_dcdc_get_voltage_sel(struct regulator_dev *rdev)
> +{
> +	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
> +	struct device *parent = to_tps80031_dev(rdev);
> +	uint8_t vsel = 0;

don't think you need to initialise vsel - if tps80031_read() returns 
success, vsel will be set.

> +	int ret;
> +
> +	if (ri->rinfo->force_reg) {
> +		ret = tps80031_read(parent, ri->rinfo->volt_id,
> +						ri->rinfo->force_reg, &vsel);
> +		if (ret < 0) {
> +			dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
> +					ri->rinfo->force_reg, ret);
> +			return ret;
> +		}
> +
> +		if (!(vsel & SMPS_CMD_MASK))
> +			return vsel & SMPS_VSEL_MASK;
> +	}
> +	ret = tps80031_read(parent, ri->rinfo->volt_id,
> +				ri->rinfo->volt_reg, &vsel);
> +	if (ret < 0) {
> +		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
> +			ri->rinfo->volt_reg, ret);
> +		return ret;
> +	}
> +	return vsel & SMPS_VSEL_MASK;
> +}

[snip]

> +static int tps80031_vbus_is_enabled(struct regulator_dev *rdev)
> +{
> +	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
> +	struct device *parent = to_tps80031_dev(rdev);
> +	int ret = -EIO;
> +	uint8_t ctrl1 = 0;
> +	uint8_t ctrl3 = 0;

No need to initialise ret, ctrl1, ctrl3

> +
> +	ret = tps80031_read(parent, SLAVE_ID2,
> +			TPS80031_CHARGERUSB_CTRL1, &ctrl1);
> +	if (ret < 0) {
> +		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
> +			TPS80031_CHARGERUSB_CTRL1, ret);
> +		return ret;
> +	}
> +	ret = tps80031_read(parent, SLAVE_ID2,
> +				TPS80031_CHARGERUSB_CTRL3, &ctrl3);
> +	if (ret < 0) {
> +		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
> +			TPS80031_CHARGERUSB_CTRL1, ret);
> +		return ret;
> +	}
> +	if ((ctrl1 & OPA_MODE_EN) && (ctrl3 & BOOST_HW_PWR_EN))
> +		return 1;
> +	return ret;
> +}
> +
> +static int tps80031_vbus_enable(struct regulator_dev *rdev)
> +{
> +	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
> +	struct device *parent = to_tps80031_dev(rdev);
> +	int ret;
> +
> +	ret = tps80031_set_bits(parent, SLAVE_ID2,
> +				TPS80031_CHARGERUSB_CTRL1, OPA_MODE_EN);
> +	if (ret < 0) {
> +		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
> +					TPS80031_CHARGERUSB_CTRL1, ret);
> +		return ret;
> +	}
> +
> +	ret = tps80031_set_bits(parent, SLAVE_ID2,
> +				TPS80031_CHARGERUSB_CTRL3, BOOST_HW_PWR_EN);
> +	if (ret < 0) {
> +		dev_err(ri->dev, "reg 0x%02x read failed, e = %d\n",
> +			TPS80031_CHARGERUSB_CTRL3, ret);
> +		return ret;
> +	}
> +	return ret;
> +}
> +
> +static int tps80031_vbus_disable(struct regulator_dev *rdev)
> +{
> +	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
> +	struct device *parent = to_tps80031_dev(rdev);
> +	int ret = 0;

Ditto for ret.

> +
> +	if (ri->config_flags & VBUS_DISCHRG_EN_PDN) {
> +		ret = tps80031_write(parent, SLAVE_ID2,
> +			USB_VBUS_CTRL_SET, VBUS_DISCHRG);
> +		if (ret < 0) {
> +			dev_err(ri->dev, "reg 0x%02x write failed, e = %d\n",
> +				USB_VBUS_CTRL_SET, ret);
> +			return ret;
> +		}
> +	}
> +
> +	ret = tps80031_clr_bits(parent, SLAVE_ID2,
> +			TPS80031_CHARGERUSB_CTRL1,  OPA_MODE_EN);
> +	if (ret < 0) {
> +		dev_err(ri->dev, "reg 0x%02x clearbit failed, e = %d\n",
> +				TPS80031_CHARGERUSB_CTRL1, ret);
> +		return ret;
> +	}
> +
> +	ret = tps80031_clr_bits(parent, SLAVE_ID2,
> +				TPS80031_CHARGERUSB_CTRL3, BOOST_HW_PWR_EN);
> +	if (ret < 0) {
> +		dev_err(ri->dev, "reg 0x%02x clearbit failed, e = %d\n",
> +				TPS80031_CHARGERUSB_CTRL3, ret);
> +		return ret;
> +	}
> +
> +	mdelay(DIV_ROUND_UP(ri->rinfo->desc.enable_time, 1000));
> +	if (ri->config_flags & VBUS_DISCHRG_EN_PDN) {
> +		ret = tps80031_write(parent, SLAVE_ID2,
> +			USB_VBUS_CTRL_CLR, VBUS_DISCHRG);
> +		if (ret < 0) {
> +			dev_err(ri->dev, "reg 0x%02x write failed, e = %d\n",
> +					USB_VBUS_CTRL_CLR, ret);
> +			return ret;
> +		}
> +	}
> +	return ret;
> +}

[snip]

> +static int tps80031_power_req_config(struct device *parent,
> +		struct tps80031_regulator *ri,
> +		struct tps80031_regulator_platform_data *tps80031_pdata)
> +{
> +	int ret = 0;

Ditto for ret.

> +
> +	if (ri->rinfo->preq_bit < 0)
> +		goto skip_pwr_req_config;
> +
> +	ret = tps80031_ext_power_req_config(parent, ri->ext_ctrl_flag,
> +			ri->rinfo->preq_bit, ri->rinfo->state_reg,
> +			ri->rinfo->trans_reg);
> +	if (ret < 0) {
> +		dev_err(ri->dev, "ext powerreq config failed, err = %d\n", ret);
> +		return ret;
> +	}
> +
> +skip_pwr_req_config:
> +	if (tps80031_pdata->ext_ctrl_flag & PWR_ON_ON_SLEEP) {
> +		ret = tps80031_update(parent, SLAVE_ID1, ri->rinfo->trans_reg,
> +				TRANS_SLEEP_ON, TRANS_SLEEP_MASK);
> +		if (ret < 0) {
> +			dev_err(ri->dev, "Reg 0x%02x update failed, e %d\n",
> +					ri->rinfo->trans_reg, ret);
> +			return ret;
> +		}
> +	}
> +	return ret;
> +}
> +
> +static int tps80031_regulator_config(struct device *parent,
> +		struct tps80031_regulator *ri,
> +		struct tps80031_regulator_platform_data *tps80031_pdata)
> +{
> +	int ret = 0;

Ditto

> +
> +	switch (ri->rinfo->desc.id) {
> +	case TPS80031_REGULATOR_LDOUSB:
> +		if (ri->config_flags &
> +			(USBLDO_INPUT_VSYS | USBLDO_INPUT_PMID)) {
> +			unsigned val = 0;

Ditto

> +			if (ri->config_flags & USBLDO_INPUT_VSYS)
> +				val = MISC2_LDOUSB_IN_VSYS;
> +			else
> +				val = MISC2_LDOUSB_IN_PMID;
> +
> +			ret = tps80031_update(parent, SLAVE_ID1,
> +				TPS80031_MISC2, val, MISC2_LDOUSB_IN_MASK);
> +			if (ret < 0) {
> +				dev_err(ri->dev,
> +					"LDOUSB config failed, e= %d\n", ret);
> +				return ret;
> +			}
> +		}
> +		break;
> +
> +	case TPS80031_REGULATOR_LDO3:
> +		if (ri->config_flags & LDO3_OUTPUT_VIB) {
> +			ret = tps80031_update(parent, SLAVE_ID1,
> +				TPS80031_MISC2, MISC2_LDO3_SEL_VIB_VAL,
> +				MISC2_LDO3_SEL_VIB_MASK);
> +			if (ret < 0) {
> +				dev_err(ri->dev,
> +					"LDO3 config failed, e = %d\n", ret);
> +				return ret;
> +			}
> +		}
> +		break;
> +
> +	case TPS80031_REGULATOR_VBUS:
> +		/* Provide SW control Ops if VBUS is SW control */
> +		if (!(ri->config_flags & VBUS_SW_ONLY))
> +			ri->rinfo->desc.ops = &tps80031_vbus_sw_ops;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	/* Configure Active state to ON, SLEEP to OFF and OFF_state to OFF */
> +	ret = tps80031_update(parent, SLAVE_ID1, ri->rinfo->trans_reg,
> +		TRANS_ACTIVE_ON | TRANS_SLEEP_OFF | TRANS_OFF_OFF,
> +		TRANS_ACTIVE_MASK | TRANS_SLEEP_MASK | TRANS_OFF_MASK);
> +	if (ret < 0) {
> +		dev_err(ri->dev, "trans reg update failed, e %d\n", ret);
> +		return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +static int check_smps_mode_mult(struct device *parent,
> +	struct tps80031_regulator *ri)
> +{
> +	int mult_offset;
> +	int ret;
> +	u8 smps_offset;
> +	u8 smps_mult;
> +
> +	ret = tps80031_read(parent, SLAVE_ID1,
> +			TPS80031_SMPS_OFFSET, &smps_offset);
> +	if (ret < 0) {
> +		dev_err(parent, "Error in reading smps offset register\n");
> +		return ret;
> +	}
> +
> +	ret = tps80031_read(parent, SLAVE_ID1,
> +			TPS80031_SMPS_MULT, &smps_mult);
> +	if (ret < 0) {
> +		dev_err(parent, "Error in reading smps mult register\n");
> +		return ret;
> +	}
> +
> +	switch (ri->rinfo->desc.id) {
> +	case TPS80031_REGULATOR_VIO:
> +		mult_offset = SMPS_MULTOFFSET_VIO;
> +		break;
> +	case TPS80031_REGULATOR_SMPS1:
> +		mult_offset = SMPS_MULTOFFSET_SMPS1;
> +		break;
> +	case TPS80031_REGULATOR_SMPS2:
> +		mult_offset = SMPS_MULTOFFSET_SMPS2;
> +		break;
> +	case TPS80031_REGULATOR_SMPS3:
> +		mult_offset = SMPS_MULTOFFSET_SMPS3;
> +		break;
> +	case TPS80031_REGULATOR_SMPS4:
> +		mult_offset = SMPS_MULTOFFSET_SMPS4;
> +		break;
> +	case TPS80031_REGULATOR_LDO2:
> +		ri->device_flags = smps_mult & BIT(5) ? TRACK_MODE_ENABLE : 0;
> +		/* TRACK mode the ldo2 varies from 600mV to 1300mV */
> +		if (ri->device_flags & TRACK_MODE_ENABLE) {
> +			ri->rinfo->desc.min_uV = 600000;
> +			ri->rinfo->desc.uV_step = 12500;
> +			ri->rinfo->desc.n_voltages = 57;
> +			ri->rinfo->desc.vsel_mask = LDO_TRACK_VSEL_MASK;
> +		}
> +		return 0;
> +	default:
> +		return 0;
> +	}
> +
> +	ri->device_flags = (smps_offset & mult_offset) ? DCDC_OFFSET_EN : 0;
> +	ri->device_flags |= (smps_mult & mult_offset) ? DCDC_EXTENDED_EN : 0;
> +	switch (ri->device_flags) {
> +	case 0:
> +		ri->rinfo->desc.min_uV = 607700;
> +		ri->rinfo->desc.uV_step = 12660;
> +		break;
> +	case DCDC_OFFSET_EN:
> +		ri->rinfo->desc.min_uV = 700000;
> +		ri->rinfo->desc.uV_step = 12500;
> +		break;
> +	case DCDC_EXTENDED_EN:
> +		ri->rinfo->desc.min_uV = 1852000;
> +		ri->rinfo->desc.uV_step = 38600;
> +		break;
> +	case DCDC_OFFSET_EN | DCDC_EXTENDED_EN:
> +		ri->rinfo->desc.min_uV = 2161000;
> +		ri->rinfo->desc.uV_step = 38600;
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int __devinit tps80031_regulator_probe(struct platform_device *pdev)
> +{
> +	struct tps80031_platform_data *pdata;
> +	struct tps80031_regulator_platform_data *tps_pdata;
> +	struct tps80031_regulator_info *rinfo;
> +	struct tps80031_regulator *ri;
> +	struct tps80031_regulator *pmic;
> +	struct regulator_dev *rdev;
> +	struct regulator_config config = { };
> +	int ret;
> +	int num;
> +
> +	pdata = dev_get_platdata(pdev->dev.parent);
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "No platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	pmic = devm_kzalloc(&pdev->dev,
> +			TPS80031_REGULATOR_MAX * sizeof(*pmic), GFP_KERNEL);
> +	if (!pmic) {
> +		dev_err(&pdev->dev, "mem alloc for pmic failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	for (num = 0; num < TPS80031_REGULATOR_MAX; ++num) {
> +		tps_pdata = pdata->regulator_pdata[num];
> +		rinfo = &tps80031_rinfo[num];
> +		ri = &pmic[num];
> +		ri->rinfo = rinfo;
> +		ri->dev = &pdev->dev;
> +
> +		check_smps_mode_mult(pdev->dev.parent, ri);

You might want to check check_smps_mode_mult() return value.

> +		config.dev = &pdev->dev;
> +		config.init_data = NULL;
> +		config.driver_data = ri;
> +		if (tps_pdata) {
> +			config.init_data = tps_pdata->reg_init_data;
> +			ri->config_flags = tps_pdata->config_flags;
> +			ri->ext_ctrl_flag = tps_pdata->ext_ctrl_flag;
> +			ret = tps80031_regulator_config(pdev->dev.parent,
> +					ri, tps_pdata);
> +			if (ret < 0) {
> +				dev_err(&pdev->dev,
> +					"regulator config failed, e %d\n", ret);
> +				goto fail;
> +			}
> +
> +			ret = tps80031_power_req_config(pdev->dev.parent,
> +					ri, tps_pdata);
> +			if (ret < 0) {
> +				dev_err(&pdev->dev,
> +					"pwr_req config failed, err %d\n", ret);
> +				goto fail;
> +			}
> +		}
> +		rdev = regulator_register(&ri->rinfo->desc, &config);
> +		if (IS_ERR_OR_NULL(rdev)) {
> +			dev_err(&pdev->dev,
> +				"register regulator failed %s\n",
> +					ri->rinfo->desc.name);
> +			ret = PTR_ERR(rdev);
> +			goto fail;
> +		}
> +		ri->rdev = rdev;
> +	}
> +
> +	platform_set_drvdata(pdev, pmic);
> +	return 0;
> +fail:
> +	while (--num >= 0) {
> +		ri = &pmic[num];
> +		regulator_unregister(ri->rdev);
> +	}
> +	return ret;
> +}
> +
> +static int __devexit tps80031_regulator_remove(struct platform_device *pdev)
> +{
> +	struct tps80031_regulator *pmic = platform_get_drvdata(pdev);
> +	struct tps80031_regulator *ri = NULL;
> +	int num;
> +
> +	for (num = 0; num < TPS80031_REGULATOR_MAX; ++num) {
> +		ri = &pmic[num];
> +		regulator_unregister(ri->rdev);
> +	}
> +	return 0;
> +}
> +
> +static struct platform_driver tps80031_regulator_driver = {
> +	.driver	= {
> +		.name	= "tps80031-pmic",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= tps80031_regulator_probe,
> +	.remove		= __devexit_p(tps80031_regulator_remove),
> +};
> +
> +static int __init tps80031_regulator_init(void)
> +{
> +	return platform_driver_register(&tps80031_regulator_driver);
> +}
> +subsys_initcall(tps80031_regulator_init);
> +
> +static void __exit tps80031_regulator_exit(void)
> +{
> +	platform_driver_unregister(&tps80031_regulator_driver);
> +}
> +module_exit(tps80031_regulator_exit);
> +
> +MODULE_ALIAS("platform:tps80031-regulator");
> +MODULE_DESCRIPTION("Regulator Driver for TI TPS80031 PMIC");
> +MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
> +MODULE_LICENSE("GPL v2");
> -- 
> 1.7.1.1

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
