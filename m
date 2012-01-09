Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2AIHTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:19:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55103 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493Ab2AIHTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:19:43 -0500
Date: Sun, 8 Jan 2012 23:19:31 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, nsekhar@ti.com
Subject: Re: [PATCH V3 2/2] regulator: tps65217: Add tps65217 regulator driver
Message-ID: <20120109071930.GC22134@opensource.wolfsonmicro.com>
References: <1325670747-31429-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325670747-31429-1-git-send-email-anilkumar@ti.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 03:22:27PM +0530, AnilKumar Ch wrote:

This looks pretty good.  A couple of small issues.

> +static int tps65217_vsel_to_uv_range1(unsigned int vsel)
> +{
> +	int uV = 0;
> +
> +	if (vsel > 15)
> +		return -EINVAL;
> +
> +	if (vsel <= 2)
> +		uV = vsel * 100000 + 1000000;
> +	else if (vsel <= 6)
> +		uV = (vsel - 2) * 50000 + 1200000;
> +	else if (vsel <= 9)
> +		uV = (vsel - 6) * 100000 + 1400000;
> +	else if (vsel == 10)
> +		uV = 2500000;
> +	else if (vsel == 11)
> +		uV = 2750000;
> +	else if (vsel == 12)
> +		uV = 2800000;
> +	else if (vsel == 13)
> +		uV = 3000000;
> +	else if (vsel == 14)
> +		uV = 3100000;
> +	else
> +		uV = 3300000;

This looks like it should actually be a table - there's far too many
irregular steps here.  The other regulators looked to be benefiting from
the use of calculations.

> +static int tps65217_pmic_dcdc_get_voltage(struct regulator_dev *dev)
> +{
> +	int ret;
> +	struct tps65217 *tps = rdev_get_drvdata(dev);
> +	unsigned int data, dcdc = rdev_get_id(dev);
> +
> +	if (dcdc < TPS65217_DCDC_1 || dcdc > TPS65217_DCDC_3)
> +		return -EINVAL;
> +
> +	ret = tps65217_reg_read(tps, tps->info[dcdc]->set_vout_reg, &data);
> +	if (ret)
> +		return ret;
> +
> +	data &= tps->info[dcdc]->set_vout_mask;
> +
> +	ret = tps->info[dcdc]->tps_range(data);
> +	if (ret < 0)
> +		dev_err(&dev->dev, "Failed to get voltage\n");
> +
> +	return ret;

It seems odd to implement this as a vanilla get_voltage()

> +static int tps65217_pmic_dcdc_set_voltage(struct regulator_dev *dev,
> +						unsigned selector)
> +{

but this as set_voltage_sel().  For non table based regulators plain
set_voltage() usually makes a bit more sense as we don't have to iterate
through the selectors looking for a match.
