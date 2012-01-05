Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab2AEG3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 01:29:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47507 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758035Ab2AEG3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 01:29:21 -0500
Date: Thu, 5 Jan 2012 06:29:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan.com@nvidia.com>
Cc: lrg@slimlogic.co.uk, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        ldewangan@nvidia.com
Subject: Re: [PATCH V1] TPS62360: Add tps62360 regulator driver
Message-ID: <20120105062919.GI11867@opensource.wolfsonmicro.com>
References: <1325668818-1096-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325668818-1096-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 02:50:18PM +0530, Laxman Dewangan wrote:
> Change-Id: I93739aad865401047738f899b2248f2714d824ea

Don't include gerritt droppings in upstream submissions.

> +/* Supported voltage values for regulators */
> +static const u16 TPS62360_VOLTAGES[] = {
> +	 770,  780,  790,  800,  810,  820,  830,  840,  850,  860,
> +	 870,  880,  890,  900,  910,  920,  930,  940,  950,  960,
> +	 970,  980,  990, 1000, 1010, 1020, 1030, 1040, 1050, 1060,
> +	1070, 1080, 1090, 1110, 1110, 1120, 1130, 1140, 1150, 1160,
> +	1170, 1180, 1190, 1200, 1210, 1220, 1230, 1240, 1250, 1260,
> +	1270, 1280, 1290, 1300, 1310, 1320, 1330, 1340, 1350, 1360,
> +	1370, 1380, 1390, 1400,
> +};

Why are you using a lookup table here?  Just calaculate the values.
This is a pervasive problem with the TI drivers which leads me to
suspect cut'n'paste and therefore an opportunity to factor some code
out.

> +static int tps62360_reg_modify_bits(struct tps62360_chip *tps, u8 reg,
> +		u8 set_mask, u8 clear_mask)
> +{

There's a lot of code in this driver that looks like it could be
factored out by using the regmap API, not just the register I/O but also
the cache.

> +static int tps62360_dcdc_is_enabled(struct regulator_dev *dev)
> +{
> +	/**
> +	 * Always return 1 as the EN is not controlled by register
> +	 * programming */
> +	return 1;
> +}

Don't implement unsupported operations.

> +
> +	for (vsel = 0; vsel < tps->desc.n_voltages; ++vsel) {
> +		int uV = tps->voltages[vsel] * 1000;
> +		if (min_uV <= uV && uV <= max_uV) {

Not only do all the drivers coming in for these devices use lookup
tables they also all open code the lookup :/

> +	init_data = &pdata->reg_init_data;
> +	tps = kzalloc(sizeof(*tps), GFP_KERNEL);
> +	if (!tps) {

Use devm_kzalloc(), saves having to worry about cleanup.

> +static void tps62360_shutdown(struct i2c_client *client)
> +{
> +	struct tps62360_chip *tps = i2c_get_clientdata(client);
> +	int st;
> +
> +	if (!tps->en_discharge)
> +		return;
> +
> +	/* Configure the output discharge path */
> +	st = tps62360_reg_modify_bits(tps, REG_RAMPCTRL, BIT(2), BIT(2));
> +	if (st < 0)
> +		dev_err(tps->dev, "%s() fails in updating reg %d\n",
> +			__func__, REG_RAMPCTRL);
> +}

I rather suspect that if this is worth doing it's also worth doing over
suspend...

> +MODULE_DESCRIPTION("TPS62360 voltage regulator driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:tps62360");

This isn't a platform driver, it's a driver for an I2C device.

> + * @vsel: Select the voltage id register.

What's this?

> + * @init_uV: initial micro volts which need to be set.

No, there's no way stuff like this should be being open coded in
individual regulator drivers - this isn't at all specific to this
regulator so it should be (and is) supported by the standard
constraints.
