Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab1GAQjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:39:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41006 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169Ab1GAQjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:39:51 -0400
Date: Fri, 1 Jul 2011 17:39:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jin Park <jinyoungp@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Richard Purdie <rpurdie@rpsys.net>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] regulator: aat2870: Add AAT2870 regulator driver
Message-ID: <20110701163946.GB13009@sirena.org.uk>
References: <1309356412-23881-1-git-send-email-jinyoungp@nvidia.com> <1309356412-23881-4-git-send-email-jinyoungp@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309356412-23881-4-git-send-email-jinyoungp@nvidia.com>
X-Cookie: micro:
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 11:06:52PM +0900, Jin Park wrote:

> +config REGULATOR_AAT2870
> +	bool "AnalogicTech AAT2870 Regulators"

Why bool?

> +static int aat2870_ldo_set_voltage(struct regulator_dev *rdev,
> +				   int min_uV, int max_uV, unsigned *selector)
> +{
> +	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
> +	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
> +	u8 val;
> +	int uV;
> +	int i;
> +
> +	if ((min_uV < ri->min_uV) || (max_uV > ri->max_uV)) {
> +		dev_err(&rdev->dev,
> +			"Invalid voltage, min %duV(>=%duV), max %duV(<=%duV)\n",
> +			min_uV, ri->min_uV, max_uV, ri->max_uV);
> +		return -EDOM;
> +	}
> +
> +	for (i = 0; i < ri->desc.n_voltages; i++) {
> +		uV = ri->voltages[i];
> +		if ((min_uV <= uV) && (uV <= max_uV)) {
> +			val = (i << ri->voltage_shift) & ri->voltage_mask;
> +			break;
> +		}
> +	}

This should be a set_voltage_sel(), the core will do all the above for
you and the driver only needs to worry about the register writes.  Note
also that the first test isn't well formed - so long as we can select a
voltage between min_uV and max_uV we're fine even if one or both of
those limits is outside the valid range.

> +static int aat2870_ldo_get_voltage(struct regulator_dev *rdev)
> +{
> +	struct aat2870_regulator *ri = rdev_get_drvdata(rdev);
> +	struct aat2870_data *aat2870 = dev_get_drvdata(ri->pdev->dev.parent);
> +	u8 val;
> +	int ret;
> +
> +	ret = aat2870->read(aat2870, ri->voltage_addr, &val);
> +	if (ret)
> +		return ret;
> +
> +	val = (val & ri->voltage_mask) >> ri->voltage_shift;
> +	if (val >= ri->desc.n_voltages)
> +		return -EIO;
> +
> +	return ri->voltages[val];

Again, get_voltage_sel().

> +static int aat2870_regulator_probe(struct platform_device *pdev)
> +{
> +	struct regulator_init_data *init_data = pdev->dev.platform_data;
> +	struct aat2870_regulator *ri;
> +	struct regulator_dev *rdev;
> +
> +	if (!init_data) {
> +		dev_err(&pdev->dev, "No regulator init data\n");
> +		return -ENXIO;
> +	}

Let the core worry about this.
