Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1LIJ7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:59:01 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52381 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1LIJ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:59:00 -0500
Date: Fri, 9 Dec 2011 09:58:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
Message-ID: <20111209095855.GA1876@sirena.org.uk>
References: <1323422140-31332-1-git-send-email-dg77.kim@samsung.com>
 <1323422140-31332-2-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323422140-31332-2-git-send-email-dg77.kim@samsung.com>
X-Cookie: This screen intentionally left blank.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 06:15:39PM +0900, Donggeun Kim wrote:

Overall this looks good - a few small nits below.

> +int max77693_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
> +{
> +	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
> +	int ret;
> +
> +	mutex_lock(&max77693->iolock);
> +	ret = i2c_smbus_read_byte_data(i2c, reg);
> +	mutex_unlock(&max77693->iolock);
> +	if (ret < 0)
> +		return ret;

Might be worth considering regmap - should be a bit less code and the
register cache is likely to make performance a bit better.

> +	if (max77693_read_reg(i2c, MAX77693_PMIC_REG_PMIC_ID2, &reg_data) < 0) {
> +		dev_err(max77693->dev,
> +			"device not found on this channel\n");
> +		ret = -ENODEV;
> +		goto err;
> +	}

I'd suggest also verifying that the ID register has the expected value.
If there's a chip reision register logging it can be helpful.

> +	max77693->muic = i2c_new_dummy(i2c->adapter, I2C_ADDR_MUIC);
> +	i2c_set_clientdata(max77693->muic, max77693);
> +
> +	max77693->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
> +	i2c_set_clientdata(max77693->haptic, max77693);

> +	pm_runtime_set_active(max77693->dev);


> +	kfree(max77693);

devm_kzalloc().
