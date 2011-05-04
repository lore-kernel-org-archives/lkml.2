Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1EDFsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 01:48:53 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17509 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab1EDFsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 01:48:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6335"; a="89181150"
Message-ID: <44d061723df8c01f27f3d95a944356eb.squirrel@www.codeaurora.org>
In-Reply-To: <20110502145855.GB8222@sortiz-mobl>
References: <1303452952-20499-1-git-send-email-wruan@codeaurora.org>
    <20110502145855.GB8222@sortiz-mobl>
Date: Tue, 3 May 2011 22:48:24 -0700 (PDT)
Subject: Re: [PATCH 1/2] mfd: pm8xxx-pwm: add pm8xxx PWM driver
From: "Willie Ruan" <wruan@codeaurora.org>
To: "Samuel Ortiz" <sameo@linux.intel.com>
Cc: "Willie Ruan" <wruan@codeaurora.org>,
        "David Brown" <davidb@codeaurora.org>,
        "Daniel Walker" <dwalker@fifo99.com>,
        "Bryan Huntsman" <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Thank you for reviewing my patches. I'll make the two functions smaller by
creating sub routines as you suggested.

pm8xxx_pwm_calc_period()
pm8xxx_pwm_configure()

Other comments below.

> Hi Willie,
>
> On Thu, Apr 21, 2011 at 11:15:51PM -0700, Willie Ruan wrote:
>> Qualcomm PM8xxx chips, such as PM8058 and PM8921, have 8 channels of
>> PWM, also called LPG (Light Pulse Generator) in HW specs. All PWM
>> channels can be used as simple PWM machine or as a more advanced PWM
>> pattern generator using programmed lookup table.
>>
>> This patch supports all APIs listed in <linux/pwm.h> with a small
>> difference. The two parameters (duty_ns and period_ns) in pwm_config()
>> are used as values in microseconds instead of nanoseconds. Otherwise a
>> 32-bit integer can't fit for a range of 7 us to 300+ seconds.
> I can only lament the fact that we're still lacking a proper PWM API.
> Besides
> that, I have a couple comments:

I agree. Hopefully someone would create a better PWM API soon for us to
use. Fortunately PWM driver and API are not hard for our customers.

>
>> +static void pm8xxx_pwm_calc_period(unsigned int period_us,
>> +					   struct pm8xxx_pwm_config *pwm_conf)
>> +{
>> +	int	n, m, clk, div;
>> +	int	best_m, best_div, best_clk;
>> +	int	last_err, cur_err, better_err, better_m;
>> +	unsigned int	tmp_p, last_p, min_err, period_n;
>> +
>> +	/* PWM Period / N */
>> +	if (period_us < (40 * USEC_PER_SEC)) {  /* ~6-bit max */
>> +		period_n = (period_us * NSEC_PER_USEC) >> 6;
>> +		n = 6;
>> +	} else if (period_us < (274 * USEC_PER_SEC)) { /* overflow threshold
>> */
>> +		period_n = (period_us >> 6) * NSEC_PER_USEC;
>> +		if (period_n >= MAX_MPT) {
>> +			n = 9;
>> +			period_n >>= 3;
>> +		} else
>> +			n = 6;
>> +	} else {
>> +		period_n = (period_us >> 9) * NSEC_PER_USEC;
>> +		n = 9;
>> +	}
>> +
>> +	min_err = MAX_MPT;
>> +	best_m = 0;
>> +	best_clk = 0;
>> +	best_div = 0;
>> +	for (clk = 0; clk < NUM_CLOCKS; clk++) {
>> +		for (div = 0; div < NUM_PRE_DIVIDE; div++) {
>> +			tmp_p = period_n;
>> +			last_p = tmp_p;
>> +			for (m = 0; m <= PM8XXX_PWM_M_MAX; m++) {
>> +				if (tmp_p <= pt_t[div][clk]) {
>> +					/* Found local best */
>> +					if (!m) {
>> +						better_err = pt_t[div][clk] -
>> +							tmp_p;
>> +						better_m = m;
>> +					} else {
>> +						last_err = last_p -
>> +							pt_t[div][clk];
>> +						cur_err = pt_t[div][clk] -
>> +							tmp_p;
>> +
>> +						if (cur_err < last_err) {
>> +							better_err = cur_err;
>> +							better_m = m;
>> +						} else {
>> +							better_err = last_err;
>> +							better_m = m - 1;
>> +						}
>> +					}
>> +
>> +					if (better_err < min_err) {
>> +						min_err = better_err;
>> +						best_m = better_m;
>> +						best_clk = clk;
>> +						best_div = div;
>> +					}
>> +					break;
>> +				} else {
>> +					last_p = tmp_p;
>> +					tmp_p >>= 1;
>> +				}
>> +			}
>> +		}
>> +	}
> This loop needs to be splitted up into 2-3 different routines. Your code
> will be much more readable.

Sure I can change this.

>
>> +static int pm8xxx_pwm_configure(struct pwm_device *pwm,
>> +			 struct pm8xxx_pwm_config *pwm_conf)
>> +{
>> +	int	i, rc, len;
>> +	u8	reg, ramp_enabled = 0;
>> +
>> +	reg = (pwm_conf->pwm_size > 6) ? PM8XXX_PWM_SIZE_9_BIT : 0;
>> +	pwm->pwm_ctl[5] = reg;
>> +
>> +	reg = ((pwm_conf->clk + 1) << PM8XXX_PWM_CLK_SEL_SHIFT)
>> +		& PM8XXX_PWM_CLK_SEL_MASK;
>> +	reg |= (pwm_conf->pre_div << PM8XXX_PWM_PREDIVIDE_SHIFT)
>> +		& PM8XXX_PWM_PREDIVIDE_MASK;
>> +	reg |= pwm_conf->pre_div_exp & PM8XXX_PWM_M_MASK;
>> +	pwm->pwm_ctl[4] = reg;
>> +
>> +	if (pwm_conf->bypass_lut) {
>> +		pwm->pwm_ctl[0] &= PM8XXX_PWM_PWM_START; /* keep enabled */
>> +		pwm->pwm_ctl[1] = PM8XXX_PWM_BYPASS_LUT;
>> +		pwm->pwm_ctl[2] = 0;
>> +
>> +		if (pwm_conf->pwm_size > 6) {
>> +			pwm->pwm_ctl[3] = pwm_conf->pwm_value
>> +						& PM8XXX_PWM_VALUE_BIT7_0;
>> +			pwm->pwm_ctl[4] |= (pwm_conf->pwm_value >> 1)
>> +						& PM8XXX_PWM_VALUE_BIT8;
>> +		} else {
>> +			pwm->pwm_ctl[3] = pwm_conf->pwm_value
>> +						& PM8XXX_PWM_VALUE_BIT5_0;
>> +		}
>> +
>> +		len = 6;
>> +	} else {
>> +		int	pause_cnt, j;
>> +
>> +		/* Linear search for duty time */
>> +		for (i = 0; i < PM8XXX_PWM_1KHZ_COUNT_MAX; i++) {
>> +			if (duty_msec[i] >= pwm_conf->lut_duty_ms)
>> +				break;
>> +		}
>> +
>> +		ramp_enabled = pwm->pwm_ctl[0] & PM8XXX_PWM_RAMP_GEN_START;
>> +		pwm->pwm_ctl[0] &= PM8XXX_PWM_PWM_START; /* keep enabled */
>> +		pwm->pwm_ctl[0] |= (i << PM8XXX_PWM_1KHZ_COUNT_SHIFT) &
>> +					PM8XXX_PWM_1KHZ_COUNT_MASK;
>> +		pwm->pwm_ctl[1] = pwm_conf->lut_hi_index &
>> +					PM8XXX_PWM_HIGH_INDEX_MASK;
>> +		pwm->pwm_ctl[2] = pwm_conf->lut_lo_index &
>> +					PM8XXX_PWM_LOW_INDEX_MASK;
>> +
>> +		if (pwm_conf->flags & PM_PWM_LUT_REVERSE)
>> +			pwm->pwm_ctl[1] |= PM8XXX_PWM_REVERSE_EN;
>> +		if (pwm_conf->flags & PM_PWM_LUT_RAMP_UP)
>> +			pwm->pwm_ctl[2] |= PM8XXX_PWM_RAMP_UP;
>> +		if (pwm_conf->flags & PM_PWM_LUT_LOOP)
>> +			pwm->pwm_ctl[2] |= PM8XXX_PWM_LOOP_EN;
>> +
>> +		/* Pause time */
>> +		if (pwm_conf->flags & PM_PWM_LUT_PAUSE_HI_EN) {
>> +			/* Linear search for pause time */
>> +			pause_cnt = (pwm_conf->lut_pause_hi + duty_msec[i] / 2)
>> +					/ duty_msec[i];
>> +			for (j = 0; j < PM8XXX_PWM_PAUSE_COUNT_MAX; j++) {
>> +				if (pause_count[j] >= pause_cnt)
>> +					break;
>> +			}
>> +			pwm->pwm_ctl[5] = (j <<
>> +					   PM8XXX_PWM_PAUSE_COUNT_HI_SHIFT) &
>> +						PM8XXX_PWM_PAUSE_COUNT_HI_MASK;
>> +			pwm->pwm_ctl[5] |= PM8XXX_PWM_PAUSE_ENABLE_HIGH;
>> +		} else
>> +			pwm->pwm_ctl[5] = 0;
>> +
>> +		if (pwm_conf->flags & PM_PWM_LUT_PAUSE_LO_EN) {
>> +			/* Linear search for pause time */
>> +			pause_cnt = (pwm_conf->lut_pause_lo + duty_msec[i] / 2)
>> +					/ duty_msec[i];
>> +			for (j = 0; j < PM8XXX_PWM_PAUSE_COUNT_MAX; j++) {
>> +				if (pause_count[j] >= pause_cnt)
>> +					break;
>> +			}
>> +			pwm->pwm_ctl[6] = (j <<
>> +					   PM8XXX_PWM_PAUSE_COUNT_LO_SHIFT) &
>> +						PM8XXX_PWM_PAUSE_COUNT_LO_MASK;
>> +			pwm->pwm_ctl[6] |= PM8XXX_PWM_PAUSE_ENABLE_LOW;
>> +		} else
>> +			pwm->pwm_ctl[6] = 0;
>> +
>> +		len = 7;
>> +	}
>> +
>> +	pm8xxx_pwm_bank_sel(pwm);
>> +
>> +	for (i = 0; i < len; i++) {
>> +		rc = pm8xxx_writeb(pwm->chip->dev->parent,
>> +				   SSBI_REG_ADDR_LPG_CTL(i),
>> +				   pwm->pwm_ctl[i]);
>> +		if (rc) {
>> +			pr_err("pm8xxx_write(): rc=%d (PWM Ctl[%d])\n", rc, i);
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (ramp_enabled) {
>> +		pwm->pwm_ctl[0] |= ramp_enabled;
>> +		pm8xxx_writeb(pwm->chip->dev->parent,
>> +			      SSBI_REG_ADDR_LPG_CTL(0),
>> +			      pwm->pwm_ctl[0]);
>> +	}
>> +
>> +	return rc;
>> +}
> I would also appreciate if this routine could be made smaller by having it
> calling sub routines.

I'll add subroutines for this function.

Thank you,
~Willie

>
> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

