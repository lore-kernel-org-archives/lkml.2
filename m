Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1LLEoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 23:44:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45041 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127Ab1LLEoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 23:44:44 -0500
Date: Mon, 12 Dec 2011 12:44:38 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        linaro-dev@lists.linaro.org, arnd@arndb.de, eric.miao@linaro.org
Subject: Re: [PATCH 01/06] MFD: DA9052/53 MFD core module v9
Message-ID: <20111212044437.GB2806@opensource.wolfsonmicro.com>
References: <1323440144.23171.69.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323440144.23171.69.camel@dhruva>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 07:45:44PM +0530, Ashish Jangam wrote:
> The DA9052/53 is a highly integrated PMIC subsystem with supply domain
> flexibility to support wide range of high performance application.

This looks pretty good now.  There's a few issues below but with those
corrected the driver looks good.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> +int da9052_add_regulator_devices(struct da9052 *da9052)
> +{
> +	struct platform_device *pdev;
> +	int i, ret;
> +
> +	for (i = 0; i < DA9052_MAX_REGULATORS; i++) {
> +		pdev = platform_device_alloc("da9052-regulator", i);
> +		if (!pdev)
> +			return -ENOMEM;
> +
> +		pdev->dev.parent = da9052->dev;
> +		ret = platform_device_add(pdev);
> +		if (ret) {
> +			platform_device_put(pdev);
> +			return ret;
> +		}
> +	}

Same comment as ever about these - just make them normal MFD children.

> +	if (!pdata && !pdata->irq_base)
> +		da9052->irq_base = -1;

The above should be || not && - you want to set irq_base to -1 if you
don't have one provided.

> +static inline int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
> +				     unsigned char bit_mask,
> +				     unsigned char reg_val)
> +{
> +	if (reg > DA9052_MAX_REG_CNT) {
> +		dev_err(da9052->dev, "invalid reg %x\n", reg);
> +		return -EINVAL;
> +	}

regmap will do this for you if you tell it max_register, this will also
get you the ability to inspect the device registers via debugfs which
can be very helpful.  I'd also encourage you to enable cache support, it
should make system performance better.
