Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1DPRcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 13:32:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53702 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750776Ab1DPRb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 13:31:59 -0400
Date: Sat, 16 Apr 2011 18:32:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com, sameo@linux.intel.com,
        gg@slimlogic.co.uk
Subject: Re: [PATCH 4/4] TPS65910: Add tps65910 regulator driver
Message-ID: <20110416173207.GB25811@opensource.wolfsonmicro.com>
References: <126FE558-4518-42B1-8618-4B6B849D5C33@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <126FE558-4518-42B1-8618-4B6B849D5C33@slimlogic.co.uk>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 10:49:39AM -0500, Jorge Eduardo Candelaria wrote:

> +/* supported VDD 1 & 2 voltages (in 0.1 milliVolts) at 1x */
> +static const u16 VDD1_2_VSEL_table[] = {
> +	6000, 6125, 6250, 6375, 6500, 6625, 6750, 6875,
> +	7000, 7125, 7250, 7375, 7500, 7625, 7750, 7875,
> +	8000, 8125, 8250, 8375, 8500, 8625, 8750, 8875,
> +	9000, 9125, 9250, 9375, 9500, 9625, 9750, 9875,
> +	10000, 10125, 10250, 10375, 10500, 10625, 10750, 10875,
> +	11000, 11125, 11250, 11375, 11500, 11625, 11750, 11875,
> +	12000, 12125, 12250, 12375, 12500, 12625, 12750, 12875,
> +	13000, 13125, 13250, 13375, 13500, 13625, 13750, 13875,
> +	14000, 14125, 14250, 14375, 14500, 14625, 14750, 14875,
> +	15000,

This looks like it should be possible to replace it with a calculation?
That'd be more efficient than scanning the array.

> +/* supported VDIG1 voltages in milivolts */
> +static const u16 VDIG1_VSEL_table[] = {
> +	1200, 1500, 1800, 2700,
> +};

Tables are more suitable for voltage ranges like this which are uneven.

> +static int tps65910_set_bits(struct tps65910_reg *pmic, u8 reg, u8 mask)
> +{
> +	int err, data;
> +
> +	mutex_lock(&pmic->mutex);
> +
> +	data = tps65910_read(pmic, reg);
> +	if (data < 0) {
> +		dev_err(pmic->mfd->dev, "Read from reg 0x%x failed\n", reg);
> +		err = data;
> +		goto out;
> +	}
> +
> +	data |= mask;
> +	err = tps65910_write(pmic, reg, data);
> +	if (err)
> +		dev_err(pmic->mfd->dev, "Write for reg 0x%x failed\n", reg);
> +
> +out:
> +	mutex_unlock(&pmic->mutex);
> +	return err;
> +}

No real problem here but it seems like all this register I/O code would
also be useful for other drivers using the chip?

> +	value = tps65910_reg_read(pmic, reg);
> +	if (value < 0)
> +		return value;
> +
> +	value |= TPS65910_SUPPLY_STATE_ENABLED;
> +	return tps65910_reg_write(pmic, reg, value);

There was a set bits operation defined above - it'd make sense to use
that here, similarly for the clear in the disable path and quite a few
other places in the driver.

> +static int tps65910_set_voltage_dcdc_sel(struct regulator_dev *dev,
> +				int selector)
> +{

> +static int tps65910_set_voltage_dcdc(struct regulator_dev *dev,
> +				int min_uV, int max_uV, unsigned * selector)

You only need to implement one of these, the _sel version will be
preferred by the core.

> +static int tps65910_set_voltage(struct regulator_dev *dev,
> +				int min_uV, int max_uV, unsigned *selector)
> +{

...

> +	/* find requested voltage in table */
> +	for (vsel = 0; vsel < pmic->info[id]->table_len; vsel++) {
> +		int mV = pmic->info[id]->table[vsel];
> +		int uV;
> +
> +		uV = mV * 1000;
> +
> +		/* Break at the first in-range value */
> +		if (min_uV <= uV && uV <= max_uV)
> +			break;
> +	}

This should be implemented based on passing in the selector - the core
can do the table iteration for you.

> +	value = tps65910_reg_read(pmic, reg);
> +	if (value < 0)
> +		return value;
> +
> +	switch (id) {
> +	case TPS65910_REG_VDD3:
> +		return 0;

There's a few special cases for VDD3 - it feels like it should have a
custom get voltage operation and no set rather than having this special
case.  There's a similar thing in list_voltage, it feels like we're not
really doing the right thing by providing operations that don't exist.

> +	pmic_plat_data = dev_get_platdata(tps65910->dev);
> +	if (!pmic_plat_data)
> +		return -EINVAL;
> +
> +	reg_data = pmic_plat_data->tps65910_pmic_init_data;
> +	if (!reg_data)
> +		return -EINVAL;

You shouldn't need to check for the regulator_init_data - the core can
do that for you, and could decide to present the regulator to the
application layer for readback for use in diagnostics even if there's
nothing writable about it.
