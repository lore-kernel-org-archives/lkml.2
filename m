Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1LZL0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 06:26:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35695 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754208Ab1LZL0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 06:26:11 -0500
Date: Mon, 26 Dec 2011 11:26:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] regulator: Add S5M8767 regulator driver
Message-ID: <20111226112605.GD8722@opensource.wolfsonmicro.com>
References: <1324628892-12170-1-git-send-email-sbkim73@samsung.com>
 <1324628892-12170-5-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324628892-12170-5-git-send-email-sbkim73@samsung.com>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 05:28:11PM +0900, Sangbeom Kim wrote:

> +	ret = s5m_reg_read(s5m8767->iodev, reg, &val);
> +	if (ret)
> +		return ret;
> +
> +	val &= mask;
> +
> +	if (rdev->desc && rdev->desc->ops && rdev->desc->ops->list_voltage)
> +		return rdev->desc->ops->list_voltage(rdev, val);
> +
> +	return s5m8767_list_voltage(rdev, val);

This looks really weird, I'm not sure why you're looking directly in the
descriptor.  In any case, just implement get_voltage_sel() rather than
plain get_voltage() and the core will do the lookup for you.

> +	s5m_reg_read(s5m8767->iodev, reg, &val);
> +	val = val & mask;
> +
> +	ret = s5m_reg_update(s5m8767->iodev, reg, i, mask);
> +	*selector = i;

This looks odd - shouldn't reg_update() already be masking things for
you.

> +
> +	if (val < i){
> +		udelay(DIV_ROUND_UP(desc->step * (i - val),
> +			s5m8767->ramp_delay));
> +	}

You should implement set_voltage_time_sel() and drop this, the core will
add the delay for you.

Also note the odd indentation and whitespace with a lot of this code.

> +	case S5M8767_BUCK2:
> +		if(s5m8767->buck2_gpiodvs){
> +			while ( s5m8767->buck2_vol[i] != new_val )
> +				i++;

This has some of the other odd whitespace - not enough spaces on the
line with the if () but extras inside the () on the while.

> +	s5m8767 = kzalloc(sizeof(struct s5m8767_info), GFP_KERNEL);
> +	if (!s5m8767)
> +		return -ENOMEM;

devm_kzalloc().

> +	size = sizeof(struct regulator_dev *) * pdata->num_regulators;

Just have fixed size arrays for the regulators and always register them
- it's less error prone and makes the code simpler.
