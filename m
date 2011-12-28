Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1L1JO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 04:14:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49807 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1L1JOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 04:14:38 -0500
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH 2/2] TPS65217: Add tps65217 regulator driver
Thread-Topic: [PATCH 2/2] TPS65217: Add tps65217 regulator driver
Thread-Index: AQHMwTLAkxbDFSo16kihyaRjndago5Xo6c2AgAahjiA=
Date: Wed, 28 Dec 2011 09:14:31 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC103ECAB@DBDE01.ent.ti.com>
References: <1324617696-14350-1-git-send-email-anilkumar@ti.com>
 <20111223111538.GE2834@opensource.wolfsonmicro.com>
In-Reply-To: <20111223111538.GE2834@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.157.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Dec 23, 2011 at 16:45:39, Mark Brown wrote:
> On Fri, Dec 23, 2011 at 10:51:36AM +0530, AnilKumar Ch wrote:
> 
> Again there really ought to be some opportunity for code sharing here.
> 
> > +	help
> > +	  This driver supports TPS65217 voltage regulator chips. TPS65217 provides
> > +	  three step-down converters and four general-purpose LDO voltage regulators.
> > +	  It supports software based voltage control for different voltage domains
> 
> This needs word wrapping.

Modified

> 
> > +/* Supported voltage values for regulators (in milliVolts) */
> > +static const u16 VDCDC1_VSEL_table[] = {
> > +	900, 925, 950, 975,
> > +	1000, 1025, 1050, 1075,
> > +	1100, 1125, 1150, 1175,
> > +	1200, 1225, 1250, 1275,
> > +	1300, 1325, 1350, 1375,
> > +	1400, 1425, 1450, 1475,
> > +	1500, 1550, 1600, 1650,
> > +	1700, 1750, 1800,
> > +};
> 
> You should replace all these vsel tables with calculations in the code,
> they're all regular steps and some of the tables are getting a bit
> large.

TPS65217 don't have any formula for computing the next voltage value. In
entire voltage scale range there is an inconsistency in the step size.

> 
> > +static inline int tps65217_pmic_read(struct tps65217_pmic *tps, u8 reg)
> > +{
> > +	u8 val;
> > +	int err;
> > +
> > +	err = tps->mfd->read_dev(tps->mfd, reg, 1, &val);
> > +	if (err)
> > +		return err;
> > +
> > +	return val;
> > +}
> 
> There's no way stuff like this should be open coded in each driver using
> the MFD, basic register I/O stuff should be implemented in a single
> place in the MFD core driver.  All this I/O code should be there.

Moved to MFD driver

> 
> > +static int tps65217_pmic_reg_read(struct tps65217_pmic *tps, u8 reg)
> > +{
> > +	int data;
> > +
> > +	mutex_lock(&tps->io_lock);
> > +
> > +	data = tps65217_pmic_read(tps, reg);
> > +	if (data < 0)
> > +		dev_err(tps->mfd->dev, "Read from reg 0x%x failed\n", reg);
> > +
> > +	mutex_unlock(&tps->io_lock);
> > +	return data;
> > +}
> 
> Three levels of read and write functions seems excessive...

Took care of this as well

> 
> > +	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
> > +		return -EINVAL;
> > +
> > +	switch (dcdc) {
> > +	case TPS65217_DCDC_1:
> > +		mask = TPS65217_ENABLE_DC1_EN;
> > +		break;
> > +	case TPS65217_DCDC_2:
> > +		mask = TPS65217_ENABLE_DC2_EN;
> > +		break;
> > +	case TPS65217_DCDC_3:
> > +		mask = TPS65217_ENABLE_DC3_EN;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> 
> You may as well just use the switch statements to check if the
> regulators are supported given the way this is coded.  Though it would
> be even better to just have an array with the per regulator data which
> you look up (or use shifting to work out the bit if that's possible).

Changed to an array which maintaining the mask for different regulators.

> 
> > +	/* password protected register write level 1 setting */
> > +	tps->wp_level = TPS65217_PROTECT_L1;
> > +
> > +	return tps65217_pmic_set_bits(tps, TPS65217_REG_ENABLE, mask);
> 
> This looks like there's an abstraction problem somewhere along the line
> - wp_level is a member of the struct but it's basically being used as a
> parameter.  Indeed perhaps the write function ought to just do this all
> by itself.

Changed by passing the level flag as a parameter instead of a structure
member

> 
> > +	/* password protected register write level 1 setting */
> > +	tps->wp_level = TPS65217_PROTECT_L1;
> 
> You should use these constants consistently through the driver, in other
> places you're using magic numbers directly.
> 
> > +	for (vsel = 0; vsel < tps->info[dcdc]->table_len; vsel++) {
> > +		int mV = tps->info[dcdc]->table[vsel];
> > +		int uV = mV * 1000;
> > +
> > +		/* Break at the first in-range value */
> > +		if (min_uV <= uV && uV <= max_uV)
> > +			break;
> > +	}
> 
> If you are going to use a table you should implement set_voltage_sel()
> which will do the table walk for you, but like I say you should just be
> using a calculation.

As per my understanding set_voltage_sel() is used to set a voltage if we
know the selector. But here it's different case, based on the min and
max voltages we have to identify the selector. For identifying the selector
we have to walk through the table. I did not find any helper functions
for walking through the table.

> 
> > +	tps = kzalloc(sizeof(*tps), GFP_KERNEL);
> > +	if (!tps)
> > +		return -ENOMEM;
> 
> Use devm_kzalloc().
> 

Changed

Regards
AnilKumar
