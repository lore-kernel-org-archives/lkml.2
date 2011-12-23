Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab1LWLPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 06:15:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54581 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754211Ab1LWLPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 06:15:42 -0500
Date: Fri, 23 Dec 2011 11:15:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, nsekhar@ti.com
Subject: Re: [PATCH 2/2] TPS65217: Add tps65217 regulator driver
Message-ID: <20111223111538.GE2834@opensource.wolfsonmicro.com>
References: <1324617696-14350-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324617696-14350-1-git-send-email-anilkumar@ti.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 10:51:36AM +0530, AnilKumar Ch wrote:

Again there really ought to be some opportunity for code sharing here.

> +	help
> +	  This driver supports TPS65217 voltage regulator chips. TPS65217 provides
> +	  three step-down converters and four general-purpose LDO voltage regulators.
> +	  It supports software based voltage control for different voltage domains

This needs word wrapping.

> +/* Supported voltage values for regulators (in milliVolts) */
> +static const u16 VDCDC1_VSEL_table[] = {
> +	900, 925, 950, 975,
> +	1000, 1025, 1050, 1075,
> +	1100, 1125, 1150, 1175,
> +	1200, 1225, 1250, 1275,
> +	1300, 1325, 1350, 1375,
> +	1400, 1425, 1450, 1475,
> +	1500, 1550, 1600, 1650,
> +	1700, 1750, 1800,
> +};

You should replace all these vsel tables with calculations in the code,
they're all regular steps and some of the tables are getting a bit
large.

> +static inline int tps65217_pmic_read(struct tps65217_pmic *tps, u8 reg)
> +{
> +	u8 val;
> +	int err;
> +
> +	err = tps->mfd->read_dev(tps->mfd, reg, 1, &val);
> +	if (err)
> +		return err;
> +
> +	return val;
> +}

There's no way stuff like this should be open coded in each driver using
the MFD, basic register I/O stuff should be implemented in a single
place in the MFD core driver.  All this I/O code should be there.

> +static int tps65217_pmic_reg_read(struct tps65217_pmic *tps, u8 reg)
> +{
> +	int data;
> +
> +	mutex_lock(&tps->io_lock);
> +
> +	data = tps65217_pmic_read(tps, reg);
> +	if (data < 0)
> +		dev_err(tps->mfd->dev, "Read from reg 0x%x failed\n", reg);
> +
> +	mutex_unlock(&tps->io_lock);
> +	return data;
> +}

Three levels of read and write functions seems excessive...

> +	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
> +		return -EINVAL;
> +
> +	switch (dcdc) {
> +	case TPS65217_DCDC_1:
> +		mask = TPS65217_ENABLE_DC1_EN;
> +		break;
> +	case TPS65217_DCDC_2:
> +		mask = TPS65217_ENABLE_DC2_EN;
> +		break;
> +	case TPS65217_DCDC_3:
> +		mask = TPS65217_ENABLE_DC3_EN;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}

You may as well just use the switch statements to check if the
regulators are supported given the way this is coded.  Though it would
be even better to just have an array with the per regulator data which
you look up (or use shifting to work out the bit if that's possible).

> +	/* password protected register write level 1 setting */
> +	tps->wp_level = TPS65217_PROTECT_L1;
> +
> +	return tps65217_pmic_set_bits(tps, TPS65217_REG_ENABLE, mask);

This looks like there's an abstraction problem somewhere along the line
- wp_level is a member of the struct but it's basically being used as a
parameter.  Indeed perhaps the write function ought to just do this all
by itself.

> +	/* password protected register write level 1 setting */
> +	tps->wp_level = TPS65217_PROTECT_L1;

You should use these constants consistently through the driver, in other
places you're using magic numbers directly.

> +	for (vsel = 0; vsel < tps->info[dcdc]->table_len; vsel++) {
> +		int mV = tps->info[dcdc]->table[vsel];
> +		int uV = mV * 1000;
> +
> +		/* Break at the first in-range value */
> +		if (min_uV <= uV && uV <= max_uV)
> +			break;
> +	}

If you are going to use a table you should implement set_voltage_sel()
which will do the table walk for you, but like I say you should just be
using a calculation.

> +	tps = kzalloc(sizeof(*tps), GFP_KERNEL);
> +	if (!tps)
> +		return -ENOMEM;

Use devm_kzalloc().
