Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab3AHNVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 08:21:49 -0500
Received: from 14.mo4.mail-out.ovh.net ([46.105.40.29]:35282 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755827Ab3AHNVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 08:21:48 -0500
Message-ID: <50EC148C.7080304@overkiz.com>
Date: Tue, 08 Jan 2013 13:43:56 +0100
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
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH v4 RESEND] pwm: atmel: add Timer Counter Block PWM driver
References: <1355994776-4764-1-git-send-email-linux-arm@overkiz.com> <20130108071023.GA2171@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130108071023.GA2171@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 1480839853175911446
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrfeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrfeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 08:10, Thierry Reding wrote:
> On Thu, Dec 20, 2012 at 10:12:56AM +0100, Boris BREZILLON wrote:
>> Hi,
>>
>> Sorry for resend. The previous version still has alignment issues on 
>> atmel_tcb_pwm_set_polarity, atmel_tcb_pwm_request and
>> atmel_tcb_pwm_config function parameters.
>>
>> This patch adds a PWM driver based on Atmel Timer Counter Block.
>> Timer Counter Block is used in Waveform generator mode.
>>
>> A Timer Counter Block provides up to 6 PWM devices grouped by 2:
>> * group 0 = PWM 0 and 1
>> * group 1 = PWM 1 and 2
>> * group 2 = PMW 3 and 4
> 
> Should this be "PWM 2 and 3" and "PWM 4 and 5"? Or is PWM 1 shared
> between groups 0 and 1?
This is a mistake, this should be:
* group 0 = PWM 0 and 1
* group 1 = PWM 2 and 3
* group 2 = PMW 4 and 5
> 
>> +static int atmel_tcb_pwm_request(struct pwm_chip *chip,
>> +				 struct pwm_device *pwm)
>> +{
> [...]
>> +	clk_enable(tc->clk[group]);
> 
> You need to check the return value of clk_enable(). There's always a
> small possibility that it may fail.
> 
>> +static void atmel_tcb_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
> [...]
>> +	/* If duty is 0 reverse polarity */
>> +	if (tcbpwm->duty == 0)
>> +		polarity = !polarity;
> 
> Rather than commenting on what the code does, this should say why it
> does so.
> 

Is this an acceptable explanation ?

	/*
	 * If duty is 0 the timer will be stopped and we have to
	 * configure the output correctly on software trigger:
	 *  - set output to high if PWM_POLARITY_INVERSED
	 *  - set output to low if PWM_POLARITY_NORMAL
	 *
	 * This is why we're reverting polarity in this case.
	 */
>> +static int atmel_tcb_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
> [...]
>> +	/* If duty is 0 reverse polarity */
>> +	if (tcbpwm->duty == 0)
>> +		polarity = !polarity;
> 
> Same here.
> 
>> +static int atmel_tcb_pwm_probe(struct platform_device *pdev)
>> +{
> [...]
>> +	struct atmel_tcb_pwm_chip *tcbpwm;
>> +	struct device_node *np = pdev->dev.of_node;
>> +	struct atmel_tc *tc;
>> +	int err;
>> +	int tcblock;
>> +
>> +	err = of_property_read_u32(np, "tc-block", &tcblock);
>> +	if (err < 0) {
>> +		dev_err(&pdev->dev,
>> +			"failed to get tc block number from device tree (error: %d)\n",
> 
> Maybe: "failed to get Timer Counter Block number..." to make it
> consistent with the error message below:
> 
>> +	tc = atmel_tc_alloc(tcblock, "tcb-pwm");
>> +	if (tc == NULL) {
>> +		dev_err(&pdev->dev, "failed to allocate Timer Counter Block\n");
>> +		return -ENOMEM;
>> +	}
> [...]
>> +static const struct of_device_id atmel_tcb_pwm_dt_ids[] = {
>> +	{ .compatible = "atmel,tcb-pwm", },
>> +	{ /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, mxs_pwm_dt_ids);
> 
> This is still wrong.
> 
>> +static struct platform_driver atmel_tcb_pwm_driver = {
>> +	.driver = {
>> +		.name = "atmel-tcb-pwm",
>> +		.of_match_table = atmel_tcb_pwm_dt_ids,
>> +	},
>> +	.probe = atmel_tcb_pwm_probe,
>> +	.remove = atmel_tcb_pwm_remove,
>> +};
>> +module_platform_driver(atmel_tcb_pwm_driver);
>> +
>> +MODULE_AUTHOR("Boris BREZILLON <b.brezillon@overkiz.com>");
>> +MODULE_DESCRIPTION("Atmel Timer Counter Pulse Width Modulation Driver");
>> +MODULE_ALIAS("platform:atmel-tcb-pwm");
> 
> I don't think you needMODULE_ALIAS() if the alias is the same as the
> driver name.
> 
> Thierry
> 
