Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab2AKIXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:23:10 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49108 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab2AKIXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:23:07 -0500
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH V3 2/2] regulator: tps65217: Add tps65217 regulator
 driver
Thread-Topic: [PATCH V3 2/2] regulator: tps65217: Add tps65217 regulator
 driver
Thread-Index: AQHMysaSE83cMB9VAEO6PYi4r3FZF5YDTE6AgAOPtrA=
Date: Wed, 11 Jan 2012 08:22:59 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC104BF75@DBDE01.ent.ti.com>
References: <1325670747-31429-1-git-send-email-anilkumar@ti.com>
 <20120109071930.GC22134@opensource.wolfsonmicro.com>
In-Reply-To: <20120109071930.GC22134@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.59]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jan 09, 2012 at 12:49:31, Mark Brown wrote:
> On Wed, Jan 04, 2012 at 03:22:27PM +0530, AnilKumar Ch wrote:
> 
> This looks pretty good.  A couple of small issues.
> 
> > +static int tps65217_vsel_to_uv_range1(unsigned int vsel)
> > +{
> > +	int uV = 0;
> > +
> > +	if (vsel > 15)
> > +		return -EINVAL;
> > +
> > +	if (vsel <= 2)
> > +		uV = vsel * 100000 + 1000000;
> > +	else if (vsel <= 6)
> > +		uV = (vsel - 2) * 50000 + 1200000;
> > +	else if (vsel <= 9)
> > +		uV = (vsel - 6) * 100000 + 1400000;
> > +	else if (vsel == 10)
> > +		uV = 2500000;
> > +	else if (vsel == 11)
> > +		uV = 2750000;
> > +	else if (vsel == 12)
> > +		uV = 2800000;
> > +	else if (vsel == 13)
> > +		uV = 3000000;
> > +	else if (vsel == 14)
> > +		uV = 3100000;
> > +	else
> > +		uV = 3300000;
> 
> This looks like it should actually be a table - there's far too many
> irregular steps here.  The other regulators looked to be benefiting from
> the use of calculations.

Changed to a table for this regulator only. 

> 
> > +static int tps65217_pmic_dcdc_get_voltage(struct regulator_dev *dev)
> > +{
> > +	int ret;
> > +	struct tps65217 *tps = rdev_get_drvdata(dev);
> > +	unsigned int data, dcdc = rdev_get_id(dev);
> > +
> > +	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
> > +		return -EINVAL;
> > +
> > +	ret = tps65217_reg_read(tps, tps->info[dcdc]->set_vout_reg, &data);
> > +	if (ret)
> > +		return ret;
> > +
> > +	data &= tps->info[dcdc]->set_vout_mask;
> > +
> > +	ret = tps->info[dcdc]->tps_range(data);
> > +	if (ret < 0)
> > +		dev_err(&dev->dev, "Failed to get voltage\n");
> > +
> > +	return ret;
> 
> It seems odd to implement this as a vanilla get_voltage()

Agree, changed to get_voltage_sel()

> 
> > +static int tps65217_pmic_dcdc_set_voltage(struct regulator_dev *dev,
> > +						unsigned selector)
> > +{
> 
> but this as set_voltage_sel().  For non table based regulators plain
> set_voltage() usually makes a bit more sense as we don't have to iterate
> through the selectors looking for a match.
> 

I changed the implementation according to your point but the
code size actually increased by 68 lines after fixing these
comments. I will send across the replacement, please see if
you like this one better.

Regards,
AnilKumar
