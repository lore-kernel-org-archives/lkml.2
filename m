Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2KZJbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:31:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47032 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2KZJbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:31:38 -0500
Message-ID: <50B336F5.1010302@ti.com>
Date: Mon, 26 Nov 2012 10:31:33 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 2/3] pwm: New driver to support PWMs on TWL4030/6030
 series of PMICs
References: <1353405382-9226-1-git-send-email-peter.ujfalusi@ti.com> <1353405382-9226-3-git-send-email-peter.ujfalusi@ti.com> <20121123145844.GA16810@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121123145844.GA16810@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 03:58 PM, Thierry Reding wrote:
> On Tue, Nov 20, 2012 at 10:56:21AM +0100, Peter Ujfalusi wrote:
>> The driver supports the following PWM outputs:
>> TWL4030 PWM0 and PWM1
>> TWL6030 PWM1 and PWM2
>>
>> On TWL4030 the PWM signals are muxed. Upon requesting the PWM the driver
>> will select the correct mux so the PWM can be used. When the PWM has been
>> freed the original configuration going to be restored.
> 
> "configuration is going to be"

Yes, I'll fix it.

> 
>> +config PWM_TWL
>> +	tristate "TWL4030/6030 PWM support"
>> +	select HAVE_PWM
> 
> Why do you select HAVE_PWM?

LEDS_PWM driver for example depends on this option. Not sure why we have this
in the first place, why PWM alone is not good enough?
we could also select HAVE_PWM when the CONFIG_PWM is enabled to cut back on
duplicated lines in the Kconfig.


>> +static int twl_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>> +			      int duty_ns, int period_ns)
>> +{
>> +	int duty_cycle = DIV_ROUND_UP(duty_ns * TWL_PWM_MAX, period_ns);
>> +	u8 pwm_config[2] = {1, 0};
>> +	int base, ret;
>> +
>> +	/*
>> +	 * To configure the duty period:
>> +	 * On-cycle is set to 1 (the minimum allowed value)
>> +	 * The off time of 0 is not configurable, so the mapping is:
>> +	 * 0 -> off cycle = 2,
>> +	 * 1 -> off cycle = 2,
>> +	 * 2 -> off cycle = 3,
>> +	 * 126 - > off cycle 127,
>> +	 * 127 - > off cycle 1
>> +	 * When on cycle == off cycle the PWM will be always on
>> +	 */
>> +	duty_cycle += 1;
> 
> The canonical form to write this would be "duty_cycle++", but maybe it
> would even be better to add it to the expression that defines
> duty_cycle?

True. This is actually a leftover from a previous version I had for the
calculation. Will change it.

> 
>> +static int twl4030_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +	int ret;
>> +	u8 val;
>> +
>> +	ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_GPBR1_REG);
>> +	if (ret < 0) {
>> +		dev_err(chip->dev, "%s: Failed to read GPBR1\n", pwm->label);
>> +		return ret;
>> +	}
>> +
>> +	val |= TWL4030_PWM_TOGGLE(pwm->hwpwm, TWL4030_PWMXCLK_ENABLE);
>> +
>> +	ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_GPBR1_REG);
>> +	if (ret < 0)
>> +		dev_err(chip->dev, "%s: Failed to enable PWM\n", pwm->label);
>> +
>> +	val |= TWL4030_PWM_TOGGLE(pwm->hwpwm, TWL4030_PWMX_ENABLE);
>> +
>> +	ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_GPBR1_REG);
>> +	if (ret < 0)
>> +		dev_err(chip->dev, "%s: Failed to enable PWM\n", pwm->label);
>> +
>> +	return ret;
>> +}
> 
> Does this perhaps need some locking to make sure the read-modify-write
> sequence isn't interrupted?

I'll add locking (mutex) to both drivers.

> 
>> +static void twl4030_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +	int ret;
>> +	u8 val;
>> +
>> +	ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_GPBR1_REG);
>> +	if (ret < 0) {
>> +		dev_err(chip->dev, "%s: Failed to read GPBR1\n", pwm->label);
>> +		return;
>> +	}
>> +
>> +	val &= ~TWL4030_PWM_TOGGLE(pwm->hwpwm, TWL4030_PWMX_ENABLE);
>> +
>> +	ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_GPBR1_REG);
>> +	if (ret < 0)
>> +		dev_err(chip->dev, "%s: Failed to disable PWM\n", pwm->label);
>> +
>> +	val &= ~TWL4030_PWM_TOGGLE(pwm->hwpwm, TWL4030_PWMXCLK_ENABLE);
>> +
>> +	ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_GPBR1_REG);
>> +	if (ret < 0)
>> +		dev_err(chip->dev, "%s: Failed to disable PWM\n", pwm->label);
>> +}
> 
> Same here.
> 
>> +static int twl4030_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +	struct twl_pwm_chip *twl = container_of(chip, struct twl_pwm_chip,
>> +						chip);
> 
> This could use a macro like to_twl(chip).

Does the macro really makes it more readable?

> 
>> +	int ret;
>> +	u8 val, mask, bits;
>> +
>> +	ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_PMBR1_REG);
>> +	if (ret < 0) {
>> +		dev_err(chip->dev, "%s: Failed to read PMBR1\n", pwm->label);
>> +		return ret;
>> +	}
>> +
>> +	if (pwm->hwpwm) {
>> +		/* PWM 1 */
>> +		mask = TWL4030_GPIO7_VIBRASYNC_PWM1_MASK;
>> +		bits = TWL4030_GPIO7_VIBRASYNC_PWM1_PWM1;
>> +	} else {
>> +		/* PWM 0 */
>> +		mask = TWL4030_GPIO6_PWM0_MUTE_MASK;
>> +		bits = TWL4030_GPIO6_PWM0_MUTE_PWM0;
>> +	}
>> +
>> +	/* Save the current MUX configuration for the PWM */
>> +	twl->twl4030_pwm_mux &= ~mask;
>> +	twl->twl4030_pwm_mux |= (val & mask);
>> +
>> +	/* Select PWM functionality */
>> +	val &= ~mask;
>> +	val |= bits;
>> +
>> +	ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_PMBR1_REG);
>> +	if (ret < 0)
>> +		dev_err(chip->dev, "%s: Failed to request PWM\n", pwm->label);
>> +
>> +	return ret;
>> +}
> 
> Again, more read-modify-write without locking.
> 
>> +
>> +static void twl4030_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +	struct twl_pwm_chip *twl = container_of(chip, struct twl_pwm_chip,
>> +						chip);
>> +	int ret;
>> +	u8 val, mask;
>> +
>> +	ret = twl_i2c_read_u8(TWL4030_MODULE_INTBR, &val, TWL4030_PMBR1_REG);
>> +	if (ret < 0) {
>> +		dev_err(chip->dev, "%s: Failed to read PMBR1\n", pwm->label);
>> +		return;
>> +	}
>> +
>> +	if (pwm->hwpwm)
>> +		/* PWM 1 */
>> +		mask = TWL4030_GPIO7_VIBRASYNC_PWM1_MASK;
>> +	else
>> +		/* PWM 0 */
>> +		mask = TWL4030_GPIO6_PWM0_MUTE_MASK;
> 
> I'm not sure how useful these comments are. You have both an explicit
> check for pwm->hwpwm to make it obvious that it isn't 0 and the mask
> macros contain the PWM0 and PWM1 substrings respectively.
> 
> You could make it even more explicit perhaps by turning the check into:
> 
> 	if (pwm->hwpwm == 1)
> 
> But either way I think you can drop the /* PWM 1 */ and /* PWM 0 */
> comments.

OK will drop the comment.

> 
>> +
>> +	/* Restore the MUX configuration for the PWM */
>> +	val &= ~mask;
>> +	val |= (twl->twl4030_pwm_mux & mask);
>> +
>> +	ret = twl_i2c_write_u8(TWL4030_MODULE_INTBR, val, TWL4030_PMBR1_REG);
>> +	if (ret < 0)
>> +		dev_err(chip->dev, "%s: Failed to free PWM\n", pwm->label);
>> +}
>> +
>> +static int twl6030_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +	struct twl_pwm_chip *twl = container_of(chip, struct twl_pwm_chip,
>> +						chip);
>> +	int ret;
>> +	u8 val;
>> +
>> +	val = twl->twl6030_toggle3;
>> +	val |= TWL6030_PWM_TOGGLE(pwm->hwpwm, TWL6030_PWMXS | TWL6030_PWMXEN);
>> +	val &= ~TWL6030_PWM_TOGGLE(pwm->hwpwm, TWL6030_PWMXR);
>> +
>> +	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, TWL6030_TOGGLE3_REG);
>> +	if (ret < 0) {
>> +		dev_err(chip->dev, "%s: Failed to enable PWM\n", pwm->label);
>> +		return ret;
>> +	}
>> +
>> +	twl->twl6030_toggle3 = val;
>> +
>> +	return 0;
>> +}
>> +
>> +static void twl6030_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +	struct twl_pwm_chip *twl = container_of(chip, struct twl_pwm_chip,
>> +						chip);
>> +	int ret;
>> +	u8 val;
>> +
>> +	val = twl->twl6030_toggle3;
>> +	val |= TWL6030_PWM_TOGGLE(pwm->hwpwm, TWL6030_PWMXR);
>> +	val &= ~TWL6030_PWM_TOGGLE(pwm->hwpwm, TWL6030_PWMXS | TWL6030_PWMXEN);
>> +
>> +	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, TWL6030_TOGGLE3_REG);
>> +	if (ret < 0) {
>> +		dev_err(chip->dev, "%s: Failed to read TOGGLE3\n", pwm->label);
>> +		return;
>> +	}
>> +
>> +	val |= TWL6030_PWM_TOGGLE(pwm->hwpwm, TWL6030_PWMXS | TWL6030_PWMXEN);
>> +
>> +	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, TWL6030_TOGGLE3_REG);
>> +	if (ret < 0) {
>> +		dev_err(chip->dev, "%s: Failed to disable PWM\n", pwm->label);
>> +		return;
>> +	}
>> +
>> +	twl->twl6030_toggle3 = val;
>> +}
>> +
>> +static struct pwm_ops twl_pwm_ops = {
>> +	.config = twl_pwm_config,
>> +};
> 
> It might actually be worth to split this into two pwm_ops structures,
> one for 4030 and one for 6030. In that case you would still be able to
> make them const, which probably outweighs the space savings here.
> 
> Actually, I think this is even potentially buggy since you may have more
> than one instance of this driver. For instance if you have a TWL6030 and
> a TWL4030 in a single system this will break horribly since you'll over-
> write the pwm_ops of one of them.

True, I will split them. However the twl4030 and twl6030 can not be on the
same system. twl4030 is for OMAP3 systems and twl6030 is used only on OMAP4
based devices. But you are right.

> 
>> +	if (twl_class_is_4030()) {
>> +		twl_pwm_ops.enable = twl4030_pwm_enable;
>> +		twl_pwm_ops.disable = twl4030_pwm_disable;
>> +		twl_pwm_ops.request = twl4030_pwm_request;
>> +		twl_pwm_ops.free = twl4030_pwm_free;
> 
> This would become:
> 
> 		twl->chip.ops = &twl4030_pwm_ops;
> 
>> +	} else {
>> +		twl_pwm_ops.enable = twl6030_pwm_enable;
>> +		twl_pwm_ops.disable = twl6030_pwm_disable;
> 
> and:
> 		twl->chip.ops = &twl6030_pwm_ops;
> 
>> +static struct of_device_id twl_pwm_of_match[] = {
>> +	{ .compatible = "ti,twl4030-pwm" },
>> +	{ .compatible = "ti,twl6030-pwm" },
>> +};
>> +
>> +MODULE_DEVICE_TABLE(of, twl_pwm_of_match);
> 
> Nit: I think the blank line between "};" and "MODULE_DEVICE_TABLE(...)"
> can go away.

True.

> And you might want to protect this with an "#ifdef
> CONFIG_OF" since you don't depend on OF.

The of.h already takes care of this when we do not have CONFIG_OF.

Thank you,
Péter
