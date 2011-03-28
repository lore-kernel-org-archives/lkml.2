Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1C1U5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 16:57:24 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50665 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab1C1U5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 16:57:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6299"; a="82560204"
Message-ID: <4D90F631.908@codeaurora.org>
Date: Mon, 28 Mar 2011 13:57:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Anirudh Ghayal <aghayal@codeaurora.org>
CC: linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trilok Soni <tsoni@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 2/3] input: pmic8xxx_pwrkey: Add support for power key
References: <1301158345-22206-1-git-send-email-aghayal@codeaurora.org> <1301158345-22206-3-git-send-email-aghayal@codeaurora.org>
In-Reply-To: <1301158345-22206-3-git-send-email-aghayal@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/2011 9:52 AM, Anirudh Ghayal wrote:
> +static void pmic8xxx_pwrkey_timer(unsigned long handle)
> +{
> +	unsigned long flags;
> +	struct pmic8xxx_pwrkey *pwrkey = (struct pmic8xxx_pwrkey *)handle;
> +
> +	spin_lock_irqsave(&pwrkey->lock, flags);
> +	pwrkey->key_pressed = true;
> +
> +	input_report_key(pwrkey->pwr, KEY_POWER, 1);
> +	input_sync(pwrkey->pwr);
> +	spin_unlock_irqrestore(&pwrkey->lock, flags);
> +}
> +
>
[snip]
> +
> +static irqreturn_t pwrkey_release_irq(int irq, void *_pwrkey)
> +{
> +	struct pmic8xxx_pwrkey *pwrkey = _pwrkey;
> +	unsigned long flags;
> +
> +	/* no pwrkey time, means no delay in pwr key reporting */
> +	if (!pwrkey->pdata->pwrkey_time_ms) {
> +		input_report_key(pwrkey->pwr, KEY_POWER, 0);
> +		input_sync(pwrkey->pwr);
> +		return IRQ_HANDLED;
> +	}
> +
> +	spin_lock_irqsave(&pwrkey->lock, flags);
> +	del_timer_sync(&pwrkey->timer);

Can you call del_timer_sync() while holding the lock that your timer
function also acquires? I thought lockdep would have complained loudly
about that but I'm not sure. It looks like a deadlock scenario.

> +static int __devinit pmic8xxx_pwrkey_probe(struct platform_device *pdev)
> +{
>
[snip]
> +
> +	if (pdata->kpd_trigger_delay_us > 62500) {
> +		dev_err(&pdev->dev, "invalid pwr key trigger delay\n");

Nitpick: Can you spell out "power" here instead of pwr? Or use
"kpd_trigger_delay_us" instead.

> +		return -EINVAL;
> +	}
> +
> +	if (pdata->pwrkey_time_ms &&
> +	     (pdata->pwrkey_time_ms < 500 || pdata->pwrkey_time_ms > 1000)) {
> +		dev_err(&pdev->dev, "invalid pwr key time supplied\n");

Ditto

> +
> +	pon_cntl &= ~PON_CNTL_TRIG_DELAY_MASK;
> +	pon_cntl |= (delay & PON_CNTL_TRIG_DELAY_MASK);
> +	pon_cntl |= (pdata->pull_up ? PON_CNTL_PULL_UP : ~PON_CNTL_PULL_UP);

Did you just set a bunch of bits you didn't want to when pdata->pull_up
== false?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

