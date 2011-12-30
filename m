Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab1L3FvC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 00:51:02 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40329 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1L3Fu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 00:50:59 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-61-4efd5141cdbd
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: lrg@ti.com, sameo@linux.intel.com, linux-kernel@vger.kernel.org
References: <1325112925-9140-1-git-send-email-sbkim73@samsung.com>
 <20111229105729.GF2909@opensource.wolfsonmicro.com>
In-reply-to: <20111229105729.GF2909@opensource.wolfsonmicro.com>
Subject: RE: [PATCH v3 RESEND] regulator: Add S5M8767A regulator driver
Date: Fri, 30 Dec 2011 14:50:59 +0900
Message-id: <002901ccc6b7$0180e100$0482a300$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczGGKxaq1BXDLEYTnClUIQwQeNhhQAazsqw
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 07:58 PM, Mark Brown wrote:
> > +static int s5m8767_get_voltage_sel(struct regulator_dev *rdev)
> > +{
> 
> ...
> 
> > +	if (rdev->desc && rdev->desc->ops && rdev->desc->ops->list_voltage)
> > +		return rdev->desc->ops->list_voltage(rdev, val);
> > +
> > +	return val;
> > +}
> 
> This looks really strange - get_voltage_sel() should return a selector
> but the return value of list_voltage() is a voltage.
I misunderstood this function.
I will change code to return a selector.

> > +static int s5m8767_reg_disable_suspend(struct regulator_dev *rdev)
> > +{
> > +	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
> > +	int ret, reg;
> > +	int  mask = 0, pattern = 0;
> > +	int reg_id = s5m8767_get_reg_id(rdev);
> > +
> > +	switch (reg_id) {
> > +	case S5M8767_LDO1 ... S5M8767_LDO28:
> > +		mask = 0xc0;
> > +		pattern = 0xc0;
> > +		break;
> > +	case S5M8767_BUCK1 ... S5M8767_BUCK9:
> > +		mask = 0xc0;
> > +		pattern = 0xc0;
> > +		break;
> > +	}
> 
> Looks like mask and pattern are always the same?  Shouldn't this return
> an error if reg_id is out of bounds?
On Initial version of S5M8767, Each mask and pattern of 
LDO and BUCK is different.
But, New version of S5M8767, that is S5M8767A, 
which has same mask and pattern.

> > +	ret = s5m8767_get_register(rdev, &reg);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return s5m_reg_update(s5m8767->iodev, reg, ~pattern, mask);
> 
> The above looks like it's going to update the same registers as the
> regular enable and disable which isn't right, this function is for
> updating suspend mode configuration.

What's exact meaning of updating suspend mode configuration?
As I know, The purpose of set_suspend_enable is that
enabling voltage output during suspend mode.
So, I implement same register enable and disable.

> > +static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
> > +					     unsigned int old_sel,
> > +					     unsigned int new_sel)
> > +{
> 
> > +	s5m_reg_read(s5m8767->iodev, reg, &val);
> > +	val = val & mask;
> > +
> > +	if (old_sel < new_sel)
> > +		return DIV_ROUND_UP(desc->step * (i - val),
> > +					s5m8767->ramp_delay);
> > +	else
> > +		return 0;
> 
> Why does this function need to read from the hardware?  It's not
> reading a ramp configuration from the hardware and the start and finish
> selectors are both supplied as arguments.
It is just for verification.
I will change it with no h/w reading.

> > +	size = sizeof(struct regulator_dev *) * S5M8767_REG_MAX;
> > +	s5m8767->rdev = kzalloc(size, GFP_KERNEL);
> > +	if (!s5m8767->rdev) {
> > +		kfree(s5m8767);
> 
> You shouldn't mix devm_ and regular functions.
> 
> > +		return -ENOMEM;
> > +	}
> 
> Why not use devm_kzalloc() for this too?
> 
> > +	s5m8767->num_regulators = pdata->num_regulators;
> 
> Just pass in fixed size arrays of regulator configurations - the core
> can handle unconfigured regulators.
Ok, I will change it.

> > +	do {
> > +		ret = s5m_reg_read(s5m8767->iodev, reg, &val);
> > +		if (ret)
> > +			return ret;
> > +
> > +		s5m_reg_update(s5m8767->iodev, reg,
> > +				((val & 0x3f) | 0x40), 0xff);
> > +		reg++;
> > +		if ((reg == S5M8767_REG_LDO9CTRL) ||
> > +			(reg == S5M8767_REG_LDO11CTRL) ||
> > +			(reg == S5M8767_REG_LDO13CTRL) ||
> > +			(reg == S5M8767_REG_LDO17CTRL))
> > +			reg++;
> > +	} while (reg <= S5M8767_REG_LDO16CTRL);
> 
> What does this do?
This is SMDK4412 specific code.
I will delete it for the general purpose.

> > +	if (s5m8767->buck2_ramp || s5m8767->buck3_ramp
> > +		|| s5m8767->buck4_ramp) {
> > +		if (s5m8767->ramp_delay < 15)
> > +			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
> > +					s5m8767->ramp_delay - 1, 0xf0);
> > +		else if (s5m8767->ramp_delay == 15)
> > +			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
> > +					0xc0, 0xf0);
> > +		else if (s5m8767->ramp_delay == 25)
> > +			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
> > +					0xd0, 0xf0);
> > +		else if (s5m8767->ramp_delay == 50)
> > +			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
> > +					0xe0, 0xf0);
> > +		else if (s5m8767->ramp_delay == 100)
> > +			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
> > +					0xf0, 0xf0);
> > +		else
> > +			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
> > +					0x90, 0xf0);
> > +	}
> 
> This looks like a switch statement.
I will change it with switch statement.

Thanks for your good review.
Happy New year Mark,

Sangbeom.

