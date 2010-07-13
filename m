Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0GMJz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:55:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55948 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752231Ab0GMJz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:55:58 -0400
Date: Tue, 13 Jul 2010 10:55:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: lrg@slimlogic.co.uk, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Acked-By: Bengt JONSSON" <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 2/3] regulator: add support for regulators on the
 ab8500 MFD
Message-ID: <20100713095556.GB12686@rakim.wolfsonmicro.main>
References: <1279002090-11234-1-git-send-email-sundar.iyer@stericsson.com>
 <1279002090-11234-3-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279002090-11234-3-git-send-email-sundar.iyer@stericsson.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 11:51:29AM +0530, Sundar Iyer wrote:

> + * @mask: mask to enable/disable regulator
> + * @enable: enable bits to enable the regulator

Presumably these two will always be identical?

> + * @typical_voltages: typical supported voltage table

Why typical - might the set of supported values change, and if they do
how will that be detected and handled?

> +	ret = ab8500_read(info->ab8500, info->update_reg);
> +	if (ret < 0)
> +		dev_dbg(rdev_get_dev(rdev),
> +			"couldnt read 0x%x register\n", info->update_reg);
> +
> +	if (ret & info->mask)
> +		return true;
> +	else
> +		return false;

This should return the error code if the read failed.

> +static int ab8500_get_best_voltage_index(struct regulator_dev *rdev,
> +		int min_uV, int max_uV)
> +{
> +	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
> +	int i;
> +
> +	/* check the supported voltage */
> +	for (i = 0; i < info->voltages_len; i++) {
> +		if ((info->typical_voltages[i] >= min_uV) &&
> +			(info->typical_voltages[i] <= max_uV))
> +			return i;

The indentation here is confusing - the second line of the if () is
aligned with the return statement not the first line.

> +	/* get the appropriate voltages within the range */
> +	ret = ab8500_get_best_voltage_index(rdev, min_uV, max_uV);
> +	if (ret < 0) {
> +		dev_dbg(rdev_get_dev(rdev),
> +				"coudlnt get best voltage for regulator\n");
> +	}

Should return an error here.

> +	/* set the registers for the request */
> +	ret = ab8500_set_bits(info->ab8500, info->voltage_reg,
> +				info->voltage_mask, ret);
> +	if (ret < 0) {
> +		dev_dbg(rdev_get_dev(rdev),
> +		"couldnt set voltage reg for regulator\n");
> +		return -EINVAL;

Should return the error you got back from set_bits() to provide maximum
information to the caller (besides, this isn't an invalid value - it's
an I/O issue).

> +static int ab8500_fixed_get_voltage(struct regulator_dev *rdev)
> +{
> +	int regulator_id;
> +	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
> +
> +	regulator_id = rdev_get_id(rdev);
> +	if (regulator_id >= AB8500_NUM_REGULATORS)
> +		return -EINVAL;
> +
> +	return info->fixed_uV;
> +}
> +
> +static struct regulator_ops ab8500_ldo_fixed_ops = {
> +	.enable		= ab8500_regulator_enable,
> +	.disable	= ab8500_regulator_disable,
> +	.is_enabled	= ab8500_regulator_is_enabled,
> +	.get_voltage	= ab8500_fixed_get_voltage,
> +};

Should have list_voltage() support also ideally.
