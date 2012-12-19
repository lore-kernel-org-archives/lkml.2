Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab2LSPEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:04:47 -0500
Received: from 2.mo2.mail-out.ovh.net ([188.165.53.149]:38627 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750996Ab2LSPEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:04:37 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 10:04:37 EST
Message-ID: <50D1CACC.8090309@overkiz.com>
Date: Wed, 19 Dec 2012 15:10:20 +0100
From: Boris BREZILLON <linux-arm@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v3] pwm: atmel: add Timer Counter Block PWM driver
References: <1355742810-4241-1-git-send-email-linux-arm@overkiz.com> <20121219112610.GA22613@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121219112610.GA22613@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 14619247341372093462
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomhepuehorhhishcuueftgfgkkffnnffqpfcuoehlihhnuhigqdgrrhhmsehovhgvrhhkihiirdgtohhmqeenucfjughrpefkfffhfgggvffufhgjtgfgsehtjegrtddtfedu
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomhepuehorhhishcuueftgfgkkffnnffqpfcuoehlihhnuhigqdgrrhhmsehovhgvrhhkihiirdgtohhmqeenucfjughrpefkfffhfgggvffufhgjtgfgsehtjegrtddtfedu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/2012 12:26, Thierry Reding wrote:
> On Mon, Dec 17, 2012 at 12:13:30PM +0100, Boris BREZILLON wrote:
>> Hello,
>>
>> This patch adds a PWM driver based on Atmel Timer Counter Block.
>> Timer Counter Block is used in Waveform generator mode.
>>
>> A Timer Counter Block provides up to 6 PWM devices grouped by 2:
>> * group 0 = PWM 0 and 1
>> * group 1 = PWM 1 and 2
>> * group 2 = PMW 3 and 4
>>
>> PWM devices in a given group must be configured with the same
>> period value.
>> If a PWM device in a group tries to change the period value and
>> the other device is already configured with a different value an
>> error will be returned.
>>
>> This driver requires device tree support.
>> The Timer Counter Block number used to create a PWM chip is
>> given by tc-block field in an "atmel,pwm-tcb" compatible node.
> 
> The device tree binding says that the compatible value should be
> "atmel,tcb-pwm", not "atmel,pwm-tcb".
> 
>> diff --git a/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
>> new file mode 100644
>> index 0000000..bd99fdd
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
>> @@ -0,0 +1,18 @@
>> +Atmel TCB PWM controller
>> +
>> +Required properties:
>> +- compatible: should be "atmel,tcb-pwm"
>> +- #pwm-cells: should be 3.  The first cell specifies the per-chip index
> 
> "Should be 3." Capital S since you terminate the sentence with a full
> stop.
> 
>> +  of the PWM to use, the second cell is the period in nanoseconds and
>> +  bit 0 in the third cell is used to encode the polarity of PWM output.
>> +  Set bit 0 of the third in PWM specifier to 1 for inverse polarity &
> 
> "of the third cell"
> 
>> +  set to 0 for normal polarity.
>> +- tc-block: the Timer Counter block to use as a PWM chip.
> 
> Also: "The Timer Counter..." because of the terminating full stop.
> 
>> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
>> index e513cd9..2f4941b 100644
>> --- a/drivers/pwm/Kconfig
>> +++ b/drivers/pwm/Kconfig
>> @@ -37,6 +37,18 @@ config PWM_AB8500
>>  	  To compile this driver as a module, choose M here: the module
>>  	  will be called pwm-ab8500.
>>  
>> +config PWM_ATMEL_TCB
>> +	tristate "TC Block PWM"
>> +	depends on ATMEL_TCLIB && OF
>> +	help
>> +	  Generic PWM framework driver for Atmel Timer Counter Block.
>> +
>> +	  A Timer Counter Block provides 6 PWM devices grouped by 2.
>> +	  Devices in a given group must have the same period.
>> +
>> +	  To compile this driver as a module, choose M here: the module
>> +	  will be called pwm-atmel-tc.
> 
> The Makefile says it is called pwm-atmel-tc_b_.
> 
>> diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
> [...]
>> +static int atmel_tcb_pwm_set_polarity(struct pwm_chip *chip,
>> +					  struct pwm_device *pwm,
>> +					  enum pwm_polarity polarity)
> 
> The arguments are no longer properly aligned.
> 
>> +static int atmel_tcb_pwm_request(struct pwm_chip *chip,
>> +					  struct pwm_device *pwm)
> 
> Same here.
> 
>> +	} else
>> +		cmr = 0;
>> +	cmr |= ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO | ATMEL_TC_EEVT_XC0;
> 
> There should be a blank line between the above two lines for better
> readability.
> 
>> +	/* If duty is 0 reverse polarity */
>> +	if (tcbpwm->duty == 0)
>> +		polarity = !polarity;
>> +
>> +	if (polarity == PWM_POLARITY_INVERSED) {
>> +		if (index == 0)
>> +			newcmr |= ATMEL_TC_ASWTRG_CLEAR;
>> +		else
>> +			newcmr |= ATMEL_TC_BSWTRG_CLEAR;
>> +	} else {
>> +		if (index == 0)
>> +			newcmr |= ATMEL_TC_ASWTRG_SET;
>> +		else
>> +			newcmr |= ATMEL_TC_BSWTRG_SET;
>> +	}
>> +
>> +	spin_lock(&tcbpwmc->lock);
>> +	cmr = __raw_readl(regs + ATMEL_TC_REG(group, CMR));
>> +
>> +	/* flush old setting */
>> +	if (index == 0)
>> +		cmr &= ~(ATMEL_TC_ACPA | ATMEL_TC_ACPC |
>> +				ATMEL_TC_AEEVT | ATMEL_TC_ASWTRG);
>> +	else
>> +		cmr &= ~(ATMEL_TC_BCPB | ATMEL_TC_BCPC |
>> +				ATMEL_TC_BEEVT | ATMEL_TC_BSWTRG);
> 
> These should be aligned differently:
> 
> 		cmr &= ~(ATMEL_TC_ACPA | ATMEL_TC_ACPC | ATMEL_TC_AEEVT |
> 			 ATMEL_TC_ASWTRG);
> 
> Although maybe you should define a mask for this since you reuse the
> exact same sequence in atmel_tcb_pwm_enable().
> 
>> +
>> +	/* configure new setting */
>> +	cmr |= newcmr;
>> +	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));
> 
> I wonder why you bother setting newcmr and OR'ing it into cmr. Couldn't
> you just mask all previous settings in cmr first, then OR the new bits?

I did this to keep the locked portion of code as small as possible:
I prepare the mask to apply to cmr register before getting the lock.

But I can do it this way if you prefer:

	spin_lock(&tcbpwmc->lock);
	cmr = __raw_readl(regs + ATMEL_TC_REG(group, CMR));

	/* flush old setting and set the new one */
	if (index == 0) {
		cmr &= ~ATMEL_TC_A_MASK;
		if (polarity == PWM_POLARITY_INVERSED)
			cmr |= ATMEL_TC_ASWTRG_CLEAR;
		else
			cmr |= ATMEL_TC_ASWTRG_SET;
	} else {
		cmr &= ~ATMEL_TC_B_MASK;
		if (polarity == PWM_POLARITY_INVERSED)
			cmr |= ATMEL_TC_BSWTRG_CLEAR;
		else
			cmr |= ATMEL_TC_BSWTRG_SET;
	}

	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));

> 
>> +
>> +	/*
>> +	 * Use software trigger to apply the new setting.
>> +	 * If both pwm devices in this group are disabled we stop the clock.
> 
> "both PWM devices"
> 
>> +	 */
>> +	if (!(cmr & (ATMEL_TC_ACPC | ATMEL_TC_BCPC)))
>> +		__raw_writel(ATMEL_TC_SWTRG | ATMEL_TC_CLKDIS,
>> +				regs + ATMEL_TC_REG(group, CCR));
>> +	else
>> +		__raw_writel(ATMEL_TC_SWTRG, regs +
>> +				ATMEL_TC_REG(group, CCR));
>> +	spin_unlock(&tcbpwmc->lock);
> 
> This could use another blank line.
> 
>> +	/*
>> +	 * If duty is 0 or equal to period there's no need to register
>> +	 * a specific action on RA/RB and RC compare.
>> +	 * The output will be configured on software trigger and keep
>> +	 * this config till next config call.
>> +	 */
>> +	if (tcbpwm->duty != tcbpwm->period && tcbpwm->duty > 0) {
>> +		if (polarity == PWM_POLARITY_INVERSED) {
>> +			if (index == 0)
>> +				newcmr |=
>> +					ATMEL_TC_ACPA_SET | ATMEL_TC_ACPC_CLEAR;
>> +			else
>> +				newcmr |=
>> +					ATMEL_TC_BCPB_SET | ATMEL_TC_BCPC_CLEAR;
>> +		} else {
>> +			if (index == 0)
>> +				newcmr |=
>> +					ATMEL_TC_ACPA_CLEAR | ATMEL_TC_ACPC_SET;
>> +			else
>> +				newcmr |=
>> +					ATMEL_TC_BCPB_CLEAR | ATMEL_TC_BCPC_SET;
> 
> If you can get rid of newcmr and OR directly into cmr instead, these
> will fit on one line.

I'm not sure I understand how you would do this.
Here is the same function without the newcmr variable:

static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
{
	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
	struct atmel_tcb_pwm_device *tcbpwm = pwm_get_chip_data(pwm);
	struct atmel_tc *tc = tcbpwmc->tc;
	void __iomem *regs = tc->regs;
	unsigned group = pwm->hwpwm / 2;
	unsigned index = pwm->hwpwm % 2;
	u32 cmr;
	enum pwm_polarity polarity = tcbpwm->polarity;

	/* If duty is 0 reverse polarity */
	if (tcbpwm->duty == 0)
		polarity = !polarity;

	spin_lock(&tcbpwmc->lock);
	cmr = __raw_readl(regs + ATMEL_TC_REG(group, CMR));

	/* flush old setting and set the new one */
	cmr &= ~ATMEL_TC_TCCLKS;
	if (index == 0) {
		cmr &= ~ATMEL_TC_A_MASK;

		/* Set CMR flags according to given polarity */
		if (polarity == PWM_POLARITY_INVERSED) {
			cmr |= ATMEL_TC_ASWTRG_CLEAR;

			/*
			 * If duty is 0 or equal to period there's no need to register
			 * a specific action on RA/RB and RC compare.
			 * The output will be configured on software trigger and keep
			 * this config till next config call.
			 */
			if (tcbpwm->duty != tcbpwm->period && tcbpwm->duty > 0)
				cmr |= ATMEL_TC_ACPA_SET | ATMEL_TC_ACPC_CLEAR;
		} else {
			cmr |= ATMEL_TC_ASWTRG_SET;
			if (tcbpwm->duty != tcbpwm->period && tcbpwm->duty > 0)
				cmr |= ATMEL_TC_ACPA_CLEAR | ATMEL_TC_ACPC_SET;
		}
	} else {
		cmr &= ~ATMEL_TC_B_MASK;
		if (polarity == PWM_POLARITY_INVERSED) {
			cmr |= ATMEL_TC_BSWTRG_CLEAR;
			if (tcbpwm->duty != tcbpwm->period && tcbpwm->duty > 0)
				cmr |= ATMEL_TC_BCPB_SET | ATMEL_TC_BCPC_CLEAR;
		} else {
			cmr |= ATMEL_TC_BSWTRG_SET;
			if (tcbpwm->duty != tcbpwm->period && tcbpwm->duty > 0)
				cmr |= ATMEL_TC_BCPA_CLEAR | ATMEL_TC_BCPC_SET;
		}
	}

	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));

	if (index == 0)
		__raw_writel(tcbpwm->duty, regs + ATMEL_TC_REG(group, RA));
	else
		__raw_writel(tcbpwm->duty, regs + ATMEL_TC_REG(group, RB));

	__raw_writel(tcbpwm->period, regs + ATMEL_TC_REG(group, RC));

	/* Use software trigger to apply the new setting */
	__raw_writel(ATMEL_TC_CLKEN | ATMEL_TC_SWTRG,
			regs + ATMEL_TC_REG(group, CCR));
	spin_unlock(&tcbpwmc->lock);
	return 0;
}


Is that what you're expecting?

> 
>> +		}
>> +	}
>> +
>> +	newcmr |= tcbpwm->clk;
>> +
>> +	spin_lock(&tcbpwmc->lock);
>> +	cmr = __raw_readl(regs + ATMEL_TC_REG(group, CMR));
>> +
>> +	/* flush old setting */
>> +	cmr &= ~ATMEL_TC_TCCLKS;
>> +	if (index == 0)
>> +		cmr &= ~(ATMEL_TC_ACPA | ATMEL_TC_ACPC |
>> +				ATMEL_TC_AEEVT | ATMEL_TC_ASWTRG);
>> +	else
>> +		cmr &= ~(ATMEL_TC_BCPB | ATMEL_TC_BCPC |
>> +				ATMEL_TC_BEEVT | ATMEL_TC_BSWTRG);
>> +
>> +	/* configure new setting */
>> +	cmr |= newcmr;
>> +	__raw_writel(cmr, regs + ATMEL_TC_REG(group, CMR));
>> +
>> +	if (index == 0)
>> +		__raw_writel(tcbpwm->duty, regs + ATMEL_TC_REG(group, RA));
>> +	else
>> +		__raw_writel(tcbpwm->duty, regs + ATMEL_TC_REG(group, RB));
>> +	__raw_writel(tcbpwm->period, regs + ATMEL_TC_REG(group, RC));
> 
> Could use another blank line.
> 
>> +static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>> +		int duty_ns, int period_ns)
> 
> These aren't properly aligned.
> 
>> +{
>> +	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
>> +	struct atmel_tcb_pwm_device *tcbpwm = pwm_get_chip_data(pwm);
>> +	unsigned group = pwm->hwpwm / 2;
>> +	unsigned index = pwm->hwpwm % 2;
>> +	struct atmel_tcb_pwm_device *atcbpwm = NULL;
>> +	struct atmel_tc *tc = tcbpwmc->tc;
>> +	int i;
>> +	int slowclk = 0;
>> +	unsigned period;
>> +	unsigned duty;
>> +	unsigned rate = clk_get_rate(tc->clk[group]);
>> +	unsigned long long min;
>> +	unsigned long long max;
>> +
>> +	/*
>> +	 * Find best clk divisor:
>> +	 * the smallest divisor which can fulfill the period_ns requirements.
>> +	 */
>> +	for (i = 0; i < 5; ++i) {
>> +		if (atmel_tc_divisors[i] == 0) {
>> +			slowclk = i;
>> +			continue;
>> +		}
>> +		min = div_u64((unsigned long long)1000000000 *
>> +						atmel_tc_divisors[i],
>> +						rate);
> 
> Maybe use NSEC_PER_SEC instead? Like this:
> 
> 		min = div_u64((u64)NSEC_PER_SEC * atmel_tc_divisors[i], rate);
> 
>> +		max = min << tc->tcb_config->counter_width;
>> +		if (max >= period_ns)
>> +			break;
>> +	}
>> +
>> +	/*
>> +	 * If none of the divisor are small enough to represent period_ns
>> +	 * take slow clock (32KHz).
>> +	 */
>> +	if (i == 5) {
>> +		i = slowclk;
>> +		rate = 32768;
>> +		min = div_u64(1000000000, rate);
> 
> Again this is NSEC_PER_SEC.
> 
>> +		max = min << 16;
>> +
>> +		/* If period is too big return ERANGE error */
>> +		if (max < period_ns)
>> +			return -ERANGE;
>> +	}
>> +
>> +	duty = div_u64(duty_ns, min);
>> +	period = div_u64(period_ns, min);
>> +
>> +	if (index == 0)
>> +		atcbpwm = tcbpwmc->pwms[pwm->hwpwm + 1];
>> +	else
>> +		atcbpwm = tcbpwmc->pwms[pwm->hwpwm - 1];
>> +
>> +	/*
>> +	 * Check that associated PWM (if present) is configured
>> +	 * with the same period.
>> +	 * If not, return an error.
>> +	 */
>> +	if ((atcbpwm && atcbpwm->duty > 0 &&
>> +			atcbpwm->duty != atcbpwm->period) &&
>> +		(atcbpwm->clk != i || atcbpwm->period != period)) {
>> +		dev_err(chip->dev, "failed to configure period_ns\n");
>> +		return -EINVAL;
>> +	}
> 
> I had to read this a couple of times to figure out that what you check
> for is consistency with the settings of the second PWM of the same
> group. Maybe you can make this a bit clearer in the comment.
> "associated PWM" is a bit vague. Also maybe the error message should
> mention that the reason why the period cannot be configured is that the
> settings for this PWM are incompatible with those of the sibling.
> 
> Also, the atcbpwm->clk field seems to refer to a divider, so renaming it
> to atcbpwm->div might be more appropriate.
> 
>> +
>> +	tcbpwm->period = period;
>> +	tcbpwm->clk = i;
>> +	tcbpwm->duty = duty;
>> +
>> +	/* If the PWM is enabled, call enable to apply the new conf */
>> +	if (test_bit(PWMF_ENABLED, &pwm->flags))
>> +		atmel_tcb_pwm_enable(chip, pwm);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct pwm_ops atmel_tcb_pwm_ops = {
>> +	.set_polarity = atmel_tcb_pwm_set_polarity,
>> +	.request = atmel_tcb_pwm_request,
>> +	.free = atmel_tcb_pwm_free,
>> +	.config = atmel_tcb_pwm_config,
>> +	.enable = atmel_tcb_pwm_enable,
>> +	.disable = atmel_tcb_pwm_disable,
>> +};
> 
> Can you put these in the same order as defined by struct pwm_ops?
> 
>> +
>> +static int atmel_tcb_pwm_probe(struct platform_device *pdev)
>> +{
>> +	struct atmel_tcb_pwm_chip *tcbpwm;
>> +	struct device_node *np = pdev->dev.of_node;
>> +	struct atmel_tc *tc;
>> +	int err;
>> +	int tcblock;
>> +
>> +	err = of_property_read_u32(np, "tc-block", &tcblock);
>> +	if (err < 0) {
>> +		dev_err(&pdev->dev,
>> +				"failed to get tc block number from device tree (error: %d)\n",
>> +				err);
> 
> These should align with &pdev->dev.
> 
>> +		return err;
>> +	}
>> +
>> +	tc = atmel_tc_alloc(tcblock, "tcb-pwm");
>> +	if (tc == NULL) {
>> +		dev_err(&pdev->dev, "failed to allocate Timer Counter Block\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	tcbpwm = devm_kzalloc(&pdev->dev, sizeof(*tcbpwm), GFP_KERNEL);
>> +	if (tcbpwm == NULL) {
>> +		dev_err(&pdev->dev, "failed to allocate memory\n");
>> +		return -ENOMEM;
>> +	}
> 
> Shouldn't you free tc in this case?
> 
>> +
>> +	tcbpwm->chip.dev = &pdev->dev;
>> +	tcbpwm->chip.ops = &atmel_tcb_pwm_ops;
>> +	tcbpwm->chip.of_xlate = of_pwm_xlate_with_flags;
>> +	tcbpwm->chip.of_pwm_n_cells = 3;
>> +	tcbpwm->chip.base = -1;
>> +	tcbpwm->chip.npwm = NPWM;
>> +	tcbpwm->tc = tc;
>> +
>> +	spin_lock_init(&tcbpwm->lock);
>> +
>> +	err = pwmchip_add(&tcbpwm->chip);
>> +	if (err < 0) {
>> +		devm_kfree(&pdev->dev, tcbpwm);
> 
> No need to call this. The whole point of the device-managed functions is
> that you don't have to care about the cleanup in the error path. However
> the atmel_tc_alloc() doesn't seem to be managed, so you should probably
> call atmel_tc_free() to release it, right?
> 
>> +		return err;
>> +	}
>> +
>> +	dev_dbg(&pdev->dev, "pwm probe successful\n");
> 
> I think this can go away now. The kernel will tell you if the driver
> can't be probed successfully, so keeping this isn't useful.
> 
>> +	platform_set_drvdata(pdev, tcbpwm);
>> +
>> +	return 0;
>> +}
>> +
>> +static int atmel_tcb_pwm_remove(struct platform_device *pdev)
>> +{
>> +	struct atmel_tcb_pwm_chip *tcbpwm = platform_get_drvdata(pdev);
>> +	int err;
>> +
>> +	err = pwmchip_remove(&tcbpwm->chip);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	atmel_tc_free(tcbpwm->tc);
>> +
>> +	dev_dbg(&pdev->dev, "pwm driver removed\n");
> 
> Same here, it can go away.
> 
>> +	devm_kfree(&pdev->dev, tcbpwm);
> 
> Again, kfree() will automatically be called on tcbpwm once the .remove()
> function exits.
> 
>> +
>> +	return 0;
>> +}
>> +
>> +static struct of_device_id atmel_tcb_pwm_dt_ids[] = {
> 
> This should probably be "static const". I just noticed that not all
> drivers do this, but they should.
> 
> Thierry
> 
