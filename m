Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1ECQub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:50:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58043 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753896Ab1ECQua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:50:30 -0400
Date: Tue, 3 May 2011 17:50:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH v2 1/2] regulator: pm8921-regulator: Add regulator
 driver for PM8921
Message-ID: <20110503165027.GC1762@opensource.wolfsonmicro.com>
References: <1304438668-23680-1-git-send-email-collinsd@codeaurora.org>
 <1304438756-28125-1-git-send-email-collinsd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304438756-28125-1-git-send-email-collinsd@codeaurora.org>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 09:05:56AM -0700, David Collins wrote:
> Create a regulator driver to control all regulators on a Qualcomm
> PM8921 PMIC chip.  This chip contains many different types of
> regulators with a wide range of abilities and voltage ranges.

This is basically OK but a few comments below.

> Eight different regulator types are available on the PM8921.  These
> are managed via 7 different type values in the driver:
> 
> LDO      - low drop out regulator (supports both NMOS and PMOS LDOs)
> NLDO1200 - 1.2A NMOS LDO (different control structure than other LDOs)
> SMPS     - switched-mode power supply
> FTSMPS   - fast transient SMPS
> VS       - voltage switch
> VS300    - 300mA voltage switch (different control structure than
>              other switches)
> NCP      - negative charge pump

Given that I'm not seeing much code sharing except is_enabled() it might
be nice to split the driver up by regulator, it's very large.

> +		for (i = 0; i < pdata->num_regulators; i++) {
> +			mfd_regulators[i].name = PM8921_REGULATOR_DEV_NAME;
> +			mfd_regulators[i].id = pdata->regulator_pdatas[i].id;
> +			mfd_regulators[i].platform_data =
> +				&(pdata->regulator_pdatas[i]);
> +			mfd_regulators[i].pdata_size =
> +				sizeof(struct pm8921_regulator_platform_data);
> +		}
> +		ret = mfd_add_devices(pmic->dev, 0, mfd_regulators,
> +				pdata->num_regulators, NULL, irq_base);

I'm having a hard time liking this.

> +static int pm8921_vreg_masked_write(struct pm8921_vreg *vreg, u16 addr, u8 val,
> +		u8 mask, u8 *reg_save)
> +{
> +	int rc = 0;
> +	u8 reg;
> +
> +	reg = (*reg_save & ~mask) | (val & mask);
> +	if (reg != *reg_save)
> +		rc = pm8xxx_writeb(vreg->dev->parent, addr, reg);
> +
> +	if (rc)
> +		pr_err("pm8xxx_writeb failed; addr=0x%03X, rc=%d\n", addr, rc);

dev_err or one of your custom error macros.

> +static int _pm8921_vreg_is_enabled(struct pm8921_vreg *vreg)
> +{
> +	int rc = 0;
> +
> +	/*
> +	 * All regulator types except advanced mode SMPS, FTSMPS, and VS300 have
> +	 * enable bit in bit 7 of the control register.
> +	 */
> +	switch (vreg->type) {

If they're all checking bit 7 the switch statement feels a bit odd...

> +static int pm8921_nldo_list_voltage(struct regulator_dev *rdev,
> +				    unsigned selector)
> +{
> +	if (selector >= NLDO_SET_POINTS)
> +		return 0;

That looks like it should be returning an error.  0 is for things that
are in range but can't be set for some reason (it's more intended for
values knocked out by constraints or similar).

> +static int _pm8921_nldo1200_get_voltage(struct pm8921_vreg *vreg)
> +{
> +	int uV = 0;
> +	int vprog;
> +
> +	if (!NLDO1200_IN_ADVANCED_MODE(vreg)) {
> +		pr_warn("%s: currently in legacy mode; voltage unknown.\n",
> +			vreg->name);
> +		return vreg->save_uV;
> +	}
> +
> +	vprog = vreg->ctrl_reg & NLDO1200_CTRL_VPROG_MASK;
> +
> +	if ((vreg->ctrl_reg & NLDO1200_CTRL_RANGE_MASK)
> +	    == NLDO1200_CTRL_RANGE_LOW)
> +		uV = vprog * NLDO1200_LOW_UV_STEP + NLDO1200_LOW_UV_MIN;
> +	else
> +		uV = vprog * NLDO1200_HIGH_UV_STEP + NLDO1200_HIGH_UV_MIN;

Just implement get_voltage_sel() - the same thing applies to most of the
other regulators that have meaningful selectors.

> +		/* Advanced mode */
> +		if ((vreg->test_reg[2] & NLDO1200_ADVANCED_PM_MASK)
> +		    == NLDO1200_ADVANCED_PM_LPM)

Do we need #defines for the indexes into these arrays?  It's a bit magic
and the code is complicated enough.

> +	if (mode != REGULATOR_MODE_NORMAL && mode != REGULATOR_MODE_IDLE) {
> +		vreg_err(vreg, "invalid mode: %u\n", mode);
> +		return -EINVAL;
> +	}

switch would be clearer.

> +/**
> + * struct pm8921_regulator_platform_data - PMIC 8921 regulator platform data
> + * @init_data:		regulator constraints
> + * @id:			regulator id; from enum pm8921_vreg_id
> + * @pull_down_enable:	0 = no pulldown, 1 = pulldown when regulator disabled
> + * @pin_ctrl:		pin control inputs to use for the regulator; should be
> + *			a combination of PM8921_VREG_PIN_CTRL_* values
> + * @pin_fn:		action to perform when pin control pin is active
> + * @system_uA:		current drawn from regulator not accounted for by any
> + *			regulator framework consumer

Having system_uA here seems wrong, this is hardly something that is
specific to this chip.
