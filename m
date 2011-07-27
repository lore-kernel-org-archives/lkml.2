Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab1G0Wed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:34:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031Ab1G0Wea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 18:34:30 -0400
Date: Wed, 27 Jul 2011 15:34:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org, rpurdie@rpsys.net,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] leds: Renesas TPU LED driver V2
Message-Id: <20110727153414.80f810e7.akpm@linux-foundation.org>
In-Reply-To: <20110713105203.5481.94746.sendpatchset@t400s>
References: <20110713105203.5481.94746.sendpatchset@t400s>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 19:52:03 +0900
Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
> 
> This patch adds V2 of the LED driver for a single timer channel
> for the TPU hardware block commonly found in Renesas SoCs.
> 
> The driver has been written with optimal Power Management in
> mind, so to save power the LED is driven as a regular GPIO pin
> in case of maximum brightness and power off which allows the
> TPU hardware to be idle and which in turn allows the clocks to
> be stopped and the power domain to be turned off transparently.
> 
> Any other brightness level requires use of the TPU hardware
> in PWM mode. TPU hardware device clocks and power are managed
> through Runtime PM. System suspend and resume is known to be
> working - during suspend the LED is set to off by the generic
> LED code.
> 
> The TPU hardware timer is equipeed with a 16-bit counter together
> with an up-to-divide-by-64 prescaler which makes the hardware
> suitable for brightness control. Hardware blink is unsupported.
> 
> The LED PWM waveform has been verified with a Fluke 123 Scope
> meter on a sh7372 Mackerel board. Tested with experimental sh7372
> A3SP power domain patches. Platform device bind/unbind tested ok.
> 
> V2 has been tested on the DS2 LED of the sh73a0-based AG5EVM.
> 
>
> ...
>
> +static int r_tpu_enable(struct r_tpu_priv *p, enum led_brightness brightness)
> +{
> +	struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
> +	int prescaler[] = { 1, 4, 16, 64 };
> +	int k, ret;
> +	unsigned long rate, tmp;
> +
> +	if (p->timer_state == R_TPU_TIMER_ON)
> +		return 0;

Is timer_state actually needed?  It looks like it's covering up bugs:
callers enabling an already-enabled device or disabling an
already-diabled one.

Also it might be a bit racy.

> +	/* wake up device and enable clock */
> +	pm_runtime_get_sync(&p->pdev->dev);
> +	ret = clk_enable(p->clk);
> +	if (ret) {
> +		dev_err(&p->pdev->dev, "cannot enable clock\n");
> +		return ret;
> +	}
> +
> +	/* make sure channel is disabled */
> +	r_tpu_start_stop_ch(p, 0);
> +
> +	/* get clock rate after enabling it */
> +	rate = clk_get_rate(p->clk);
> +
> +	/* pick the lowest acceptable rate */
> +	for (k = 0; k < ARRAY_SIZE(prescaler); k++)
> +		if ((rate / prescaler[k]) < p->min_rate)
> +			break;
> +
> +	if (!k) {
> +		dev_err(&p->pdev->dev, "clock rate mismatch\n");
> +		goto err0;
> +	}
> +	dev_dbg(&p->pdev->dev, "rate = %lu, prescaler %u\n",
> +		rate, prescaler[k - 1]);
> +
> +	/* clear TCNT on TGRB match, count on rising edge, set prescaler */
> +	r_tpu_write(p, TCR, 0x0040 | (k - 1));
> +
> +	/* output 0 until TGRA, output 1 until TGRB */
> +	r_tpu_write(p, TIOR, 0x0002);
> +
> +	rate /= prescaler[k - 1] * p->refresh_rate;
> +	r_tpu_write(p, TGRB, rate);
> +	dev_dbg(&p->pdev->dev, "TRGB = 0x%04lx\n", rate);
> +
> +	tmp = (cfg->max_brightness - brightness) * rate;
> +	r_tpu_write(p, TGRA, tmp / cfg->max_brightness);
> +	dev_dbg(&p->pdev->dev, "TRGA = 0x%04lx\n", tmp / cfg->max_brightness);
> +
> +	/* PWM mode */
> +	r_tpu_write(p, TMDR, 0x0002);
> +
> +	/* enable channel */
> +	r_tpu_start_stop_ch(p, 1);
> +
> +	p->timer_state = R_TPU_TIMER_ON;
> +	return 0;
> + err0:
> +	clk_disable(p->clk);
> +	pm_runtime_put_sync(&p->pdev->dev);
> +	return -ENOTSUPP;
> +}
> +
>
> ...
>
