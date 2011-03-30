Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab1C3XqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 19:46:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42271 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933031Ab1C3XqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 19:46:11 -0400
Date: Thu, 31 Mar 2011 08:46:14 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: pm8921-regulator: Add regulator driver
 for PM8921
Message-ID: <20110330234613.GA21487@opensource.wolfsonmicro.com>
References: <1301523361-5982-1-git-send-email-collinsd@codeaurora.org>
 <1301523432-6017-1-git-send-email-collinsd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301523432-6017-1-git-send-email-collinsd@codeaurora.org>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 03:17:12PM -0700, David Collins wrote:

> Regulator framework operation callback functions work as expected with
> one exception: pm8921_vreg_get_mode and pm8921_vreg_set_mode.  These
> callbacks are shared by all regulator types in the driver.  The mode
> setting scheme was modified from the normal framework usage to
> accommodate pin control.  Pin control allows a regulator that has been
> disabled by software writing to its control registers to become
> enabled by a hardware pin.  Many of the PM8921 regulators support pin

Don't do this.  There's two problems with it.  One is that you're
abusing a standard API for an unrelated purpose which will confuse
anything that tries to use the API as normal, the other is that this
sounds like a fairly widely supported feature (although normally one
that is used with a GPIO on the CPU, there's a few examples of this in
mainline).

> REGULATOR_MODE_FAST    - set to high power mode (HPM)
> REGULATOR_MODE_NORMAL  - remove a vote for pin control
> REGULATOR_MODE_IDLE    - vote for pin control (ref-counted)
> REGULATOR_MODE_STANDBY - set to low power mode (LPM)

> There is an additional caveat that pin control mode will override LPM
> such that, a set mode call for LPM will be ignored if the pin control
> reference count is greater than 0.  Similarly, HPM will override pin
> control mode.  Transitivity is not maintained though, because the mode
> can be changed from HPM to LPM.  This ensures that it is still
> possible to transition freely between LPM and HPM with calls to
> regulator_set_optimum_mode.

What is the voting that's been referred to here?

> --- a/drivers/mfd/pm8921-core.c
> +++ b/drivers/mfd/pm8921-core.c
> @@ -119,8 +119,9 @@ static int __devinit pm8921_add_subdevices(const struct pm8921_platform_data
>  					   struct pm8921 *pmic,
>  					   u32 rev)
>  {
> -	int ret = 0, irq_base = 0;
> +	int ret = 0, irq_base = 0, i;
>  	struct pm_irq_chip *irq_chip;

Don't mix initialised and non-initialised definitions.

> +	/* Add one device for each regulator used by the board. */
> +	if (pdata->num_regulators > 0 && pdata->regulator_pdatas) {
> +		mfd_regulators = kzalloc(sizeof(struct mfd_cell)
> +					 * (pdata->num_regulators), GFP_KERNEL);
> +		if (!mfd_regulators) {
> +			pr_err("Cannot allocate %d bytes for pm8921 regulator "
> +				"mfd cells\n", sizeof(struct mfd_cell)
> +						* (pdata->num_regulators));
> +			ret = -ENOMEM;
> +			goto bail;
> +		}

I know some devices do follow this pattern but it's simpler to just
register the regulators that are physically present on the device
unconditionally.

> +static int pm8921_vreg_write(struct pm8921_vreg *vreg, u16 addr, u8 val,
> +			     u8 mask, u8 *reg_save)

The function is confusingly named - it's actually a bitmask update but
write() would normally suggest a straight write of an absolute value.

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
> +	else
> +		*reg_save = reg;
> +
> +	return rc;
> +}

This needs locking if any registers are shared between multiple
regulators.

> +	if (min_uV < PLDO_LOW_UV_MIN || min_uV > PLDO_HIGH_UV_MAX) {
> +		vreg_err(vreg, "requested voltage %d is outside of allowed "
> +				"range.\n", min_uV);

Don't split text over multiple lines, it's not helpful when grepping.

> +static int pm8921_nldo1200_set_voltage(struct regulator_dev *rdev, int min_uV,
> +				   int max_uV, unsigned *selector)
> +{
> +	struct pm8921_vreg *vreg = rdev_get_drvdata(rdev);
> +
> +	return _pm8921_nldo1200_set_voltage(vreg, min_uV);
> +}

I have to say I'm not finding the indirection to the _ functions is
actually adding anything to the code here.

> +	/* Round down for set points in the gaps between bands. */
> +	if (uV > FTSMPS_BAND1_UV_MAX && uV < FTSMPS_BAND2_UV_MIN)
> +		uV = FTSMPS_BAND1_UV_MAX;
> +	else if (uV > FTSMPS_BAND2_UV_MAX
> +			&& uV < FTSMPS_BAND3_UV_SETPOINT_MIN)
> +		uV = FTSMPS_BAND2_UV_MAX;

That seems broken - it means you'll go under voltage on what was
requested.  You should ensure that you're always within the requested
range so if the higher band minimum is in the range you should select
that, otherwise you should error out.

In general you're not checking that your voltage selection actually
satisfies the request that went in...

> +static int pm8921_ftsmps_set_voltage(struct regulator_dev *rdev, int min_uV,
> +				     int max_uV, unsigned *selector)
> +{
> +	struct pm8921_vreg *vreg = rdev_get_drvdata(rdev);
> +
> +	return _pm8921_ftsmps_set_voltage(vreg, min_uV, 0);
> +}

...note how you discard the upper limit on the requested voltage here
before going into the implementation.

> +static unsigned int pm8921_vreg_get_optimum_mode(struct regulator_dev *rdev,
> +		int input_uV, int output_uV, int load_uA)
> +{
> +	struct pm8921_vreg *vreg = rdev_get_drvdata(rdev);
> +
> +	vreg->save_uA = load_uA;

What's this about?  There's no other references to save_uA in the driver
and it looks suspicous.

> +	if (load_uA >= vreg->hpm_min_load)
> +		return REGULATOR_MODE_FAST;
> +
> +	return REGULATOR_MODE_STANDBY;

Using an else would be clearer and less error prone.

> +static int pm8921_vreg_enable(struct regulator_dev *rdev)
> +{
> +	struct pm8921_vreg *vreg = rdev_get_drvdata(rdev);
> +	int mode, rc = 0;
> +
> +	mode = pm8921_vreg_get_mode(rdev);
> +
> +	if (mode == REGULATOR_MODE_IDLE) {
> +		/* Turn on pin control. */
> +		rc = pm8921_vreg_set_pin_ctrl(vreg, 1);
> +		if (rc)
> +			goto bail;
> +		return rc;
> +	}

This looks wrong, it's not actually enabling the regulator but putting
it into pin control mode instead.  If something actually wanted the
regulator enabling it's going to be disappointed.

> +	/* Disable in local control register. */
> +	if (vreg->type == REGULATOR_TYPE_SMPS && SMPS_IN_ADVANCED_MODE(vreg)) {
> +		/* Change SMPS to legacy mode before disabling. */
> +		rc = pm8921_smps_set_voltage_legacy(vreg, vreg->save_uV);
> +		if (rc)
> +			goto bail;
> +		rc = pm8921_vreg_write(vreg, vreg->ctrl_addr, REGULATOR_DISABLE,
> +			REGULATOR_ENABLE_MASK, &vreg->ctrl_reg);
> +	} else if (vreg->type == REGULATOR_TYPE_FTSMPS) {

This would all be a lot more legible with a switch statement for the
regulator types.

> +static int __devinit pm8921_vreg_probe(struct platform_device *pdev)
> +{
> +	struct regulator_desc *rdesc;
> +	struct pm8921_vreg *vreg;
> +	const char *reg_name = "";
> +	int rc = 0;
> +
> +	if (pdev == NULL)
> +		return -EINVAL;
> +
> +	if (pdev->id >= 0 && pdev->id < PM8921_VREG_ID_MAX) {
> +		rdesc = &pm8921_vreg_description[pdev->id];
> +		vreg = &pm8921_vreg[pdev->id];
> +		memcpy(&(vreg->pdata), pdev->dev.platform_data,
> +			sizeof(struct pm8921_regulator_platform_data));
> +		reg_name = pm8921_vreg_description[pdev->id].name;
> +		vreg->name = reg_name;
> +		vreg->dev = &pdev->dev;
> +
> +		rc = pm8921_init_regulator(vreg);
> +		if (rc)
> +			goto bail;
> +

This function is just a switch statement per regulator, may aswell expan
ithere.  Or restructure things so that you've got a driver per regulator
type - that would also mean you'd be able to get the device IDs to
correspond to the regulator numbers which would probably be clearer.

> +static int __init pm8921_vreg_init(void)
> +{
> +	return platform_driver_register(&pm8921_vreg_driver);
> +}
> +module_init(pm8921_vreg_init);

subsys_initcall().
