Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2FOIoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 04:44:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52381 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab2FOIoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 04:44:10 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: RE: [PATCH] regulator: add new regulator driver for lp872x
Thread-Topic: [PATCH] regulator: add new regulator driver for lp872x
Thread-Index: Ac04uMpPvW/+MWybQq22BmeDiSvaKP//nWsA/9tptFA=
Date: Fri, 15 Jun 2012 08:44:01 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FB5BB@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998FA17F@DQHE02.ent.ti.com>
 <20120523095808.GD4085@opensource.wolfsonmicro.com>
In-Reply-To: <20120523095808.GD4085@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.173.87]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your feedback and detailed review.
Updated patch will be submitted. (title with 'patch v2')

Thanks & BR
Milo -

> > +static int lp872x_read_byte(struct lp872x *lp, u8 addr, u8 *data)
> > +{
> > +	int ret;
> > +	unsigned int val;
> > +
> > +	mutex_lock(&lp->xfer_lock);
> > +	ret = regmap_read(lp->regmap, addr, &val);
> > +	if (ret < 0) {
> > +		mutex_unlock(&lp->xfer_lock);
> > +		dev_err(lp->dev, "failed to read 0x%.2x\n", addr);
> > +		return ret;
> > +	}
> > +	mutex_unlock(&lp->xfer_lock);
> > +
> > +	*data = (u8)val;
> > +	return 0;
> > +}
> 
> This should just be a trivial wrapper around regmap_read, the regmap
> API
> handles concurrency for you.  Similarly for all your other I/O
> functions.
> 
> > +static int lp872x_ldo_list_voltage(struct regulator_dev *rdev,
> > +				unsigned selector)
> 
> regulator_list_voltage_table() will appear in -next just after the
> merge
> window.
> 
> > +static int lp872x_ldo_set_voltage_sel(struct regulator_dev *rdev,
> > +				unsigned selector)
> 
> regulator_set_voltage_sel_regmap().
> 
> > +static int lp872x_ldo_get_voltage_sel(struct regulator_dev *rdev)
> 
> regulator_get_voltage_sel_regmap().
> 
> > +static int lp872x_regulator_enable(struct regulator_dev *rdev)
> 
> Your ENABLE define made the code a bit obscure but this is
> regulator_enable_regmap()
> 
> > +static int lp872x_regualtor_disable(struct regulator_dev *rdev)
> 
> regulator_disable_regmap()
> 
> > +static int lp872x_regulator_is_enabled(struct regulator_dev *rdev)
> 
> regulator_is_enabled_regmap()
> 
> > +static int lp872x_buck_list_voltage(struct regulator_dev *rdev,
> > +				unsigned selector)
> 
> regulator_list_voltage_table()
> 
> > +	case LP8720_ID_BUCK:
> > +		if (val & LP8720_EXT_DVS_M) {
> > +			pinstate = pdata->get_dvs_pin_state ?
> > +				pdata->get_dvs_pin_state() : DVS_LOW;
> 
> This is a really odd implementation.  Why isn't the driver managing the
> pin and what happens to the consumers that expected to set a voltage
> when the pin gets changed?
> 
> > +static int lp8725_buck_enable(struct regulator_dev *rdev)
> 
> regulator_enable_regmap()
> 
> > +static int lp8725_buck_disable(struct regulator_dev *rdev)
> 
> regulator_disable_regmap()
> 
> > +static int lp8725_buck_is_enabled(struct regulator_dev *rdev)
> 
> regulator_is_enabled_regmap()
> 
> > +	for (i = 0 ; i < num ; i++) {
> > +		regulator_data = lp->pdata->regulator_data + i;
> > +		desc = &lp872x_regulator_desc[regulator_data->id];
> > +		init_data = regulator_data->init_data;
> > +
> > +		rdev = regulator_register(desc, lp->dev, init_data, lp,
> NULL);
> > +		if (IS_ERR(rdev)) {
> > +			dev_err(lp->dev, "regulator register err");
> > +			ret =  PTR_ERR(rdev);
> > +			goto err;
> > +		}
> 
> You should unconditionally register all the regulators the chip has and
> match the init_data to them rather than only registering regulators you
> have init_data.  This allows users to inspect unconfigured regulators
> and allows the core to support things like powering off unused
> regulators.
> 
> > +static const struct regmap_config lp872x_regmap_config = {
> > +	.reg_bits = 8,
> > +	.val_bits = 8,
> > +};
> 
> Setting max_register would get you debugfs inspection of the regmap.
> 
> > +	lp->regmap = regmap_init_i2c(cl, &lp872x_regmap_config);
> 
> devm_regmap_init_i2c().
> 
> > +/**
> > + * lp872x_platform_data
> > + * @general_config    (mandatory) : the value of LP872X_GENERAL_CFG
> register
> 
> Is the chip default never valid?
> 
> > + * @regulator_data    (mandatory) : platform regulator id and init
> data
> > + * @num_regulators    (mandatory) : total number of platform
> regulators
> 
> These should be optional.

