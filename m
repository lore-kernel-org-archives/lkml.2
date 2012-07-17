Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2GQFVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:21:38 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6434 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab2GQFVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:21:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 16 Jul 2012 22:21:05 -0700
Message-ID: <5004F638.6020301@nvidia.com>
Date: Tue, 17 Jul 2012 10:50:56 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "rnayak@ti.com" <rnayak@ti.com>, "paul@pwsan.com" <paul@pwsan.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "ccross@android.com" <ccross@android.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] [RFC] cpufreq: omap: scale regulator from clk notifier
References: <1342225001-22962-1-git-send-email-mturquette@linaro.org> <1342225001-22962-3-git-send-email-mturquette@linaro.org>
In-Reply-To: <1342225001-22962-3-git-send-email-mturquette@linaro.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 July 2012 05:46 AM, Mike Turquette wrote:
> This patch moves direct control of the MPU voltage regulator out of the
> cpufreq driver .target callback and instead puts that logic into a clock
> rate change notifier callback.
>
> The same frequency/voltage lookup via the OPP library is present, except
> that the calls to regulator_set_voltage are done from the clock
> framework instead of cpufreq.
>
> Ideally it would be nice to reduce the .target callback for OMAP's
> cpufreq driver to a simple call to clk_set_rate.  For now there is still
> some other stuff needed there (jiffies per loop, rounding the rate, etc
> etc).
>
> Not-signed-off-by: Mike Turquette<mturquette@linaro.org>
> ---
>   drivers/cpufreq/omap-cpufreq.c |  154 +++++++++++++++++++++++++---------------
>   1 file changed, 96 insertions(+), 58 deletions(-)
>

<snip>

>
> -static int __init omap_cpufreq_init(void)
> +static int mpu_clk_volt_scale_handler(struct notifier_block *nb,
> +	unsigned long flags, void *data)
>   {
> -	if (cpu_is_omap24xx())
> -		mpu_clk_name = "virt_prcm_set";
> -	else if (cpu_is_omap34xx())
> -		mpu_clk_name = "dpll1_ck";
> -	else if (cpu_is_omap44xx())
> -		mpu_clk_name = "dpll_mpu_ck";
> +	struct clk_notifier_data *cnd = data;
> +	unsigned long tol;
> +	int ret, volt_new, volt_old;
> +	struct opp *opp;
>
> -	if (!mpu_clk_name) {
> -		pr_err("%s: unsupported Silicon?\n", __func__);
> -		return -EINVAL;
> +	volt_old = regulator_get_voltage(mpu_reg);
> +	opp = opp_find_freq_exact(mpu_dev, cnd->new_rate, true);
> +	volt_new = opp_get_voltage(opp);
> +
> +	tol = volt_new * OPP_TOLERANCE / 100;
> +
> +	/* scaling up?  scale voltage before frequency */
> +	if (cnd->new_rate>  cnd->old_rate) {
> +		dev_dbg(mpu_dev, "cpufreq-omap: %d mV -->  %d mV\n",
> +				volt_old, volt_new);
> +
> +		ret = regulator_set_voltage(mpu_reg, volt_new - tol, volt_new + tol);
> +
> +		if (ret<  0) {
> +			dev_warn(mpu_dev, "%s: unable to scale voltage up.\n",
> +				 __func__);
> +			return NOTIFY_BAD;
> +		}
> +	}
> +
> +	/* scaling down?  scale voltage after frequency */
> +	if (cnd->new_rate<  cnd->old_rate) {
> +		dev_dbg(mpu_dev, "cpufreq-omap: %d mV -->  %d mV\n",
> +				volt_old, volt_new);
> +
> +		ret = regulator_set_voltage(mpu_reg, volt_new - tol, volt_new + tol);
> +
> +		if (ret<  0) {
> +			dev_warn(mpu_dev, "%s: unable to scale voltage down.\n",
> +				 __func__);
> +			return NOTIFY_BAD;
> +		}
>   	}

How are you checking pre and post rate change condition here? Need 
switch case for event?

>
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block mpu_clk_volt_scale_nb = {
> +	.notifier_call = mpu_clk_volt_scale_handler,
> +};
> +
> +

