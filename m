Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2KARXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 13:23:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58667 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab2KARXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 13:23:22 -0400
Message-ID: <5092B007.7050609@wwwdotorg.org>
Date: Thu, 01 Nov 2012 11:23:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dmitry Osipenko <digetx@gmail.com>,
        Pritesh Raithatha <praithatha@nvidia.com>
CC: linus.walleij@linaro.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: tegra: add suspend/resume support
References: <1351785186-11431-1-git-send-email-digetx@gmail.com>
In-Reply-To: <1351785186-11431-1-git-send-email-digetx@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 09:53 AM, Dmitry Osipenko wrote:
> Added suspend/resume pm ops. We need to store current regs vals on suspend and
> restore them on resume.

Interesting. Just literally a couple days ago, I was reviewing a patch
to our internal kernel tree that implemented the same thing for the
pinctrl driver, in almost the same way!

> ---
> Tested on my tablet.

I'm curious how; in what environment. As far as I know, the Tegra
support in the mainline kernel doesn't actually support suspend/resume.
I assume you cherry-picked this pinctrl driver into some other kernel,
and tested this patch there?

> +#ifdef CONFIG_PM_SLEEP
> +static int tegra_pinctrl_suspend_noirq(struct device *dev)

The one major different between this patch and the downstream patch I
reviewed is how suspend/resume is triggered. This uses suspend_noirq,
whereas the downstream patch registers the callbacks using
register_syscore_ops(). Apparently the latter is required (at least in
our downstream kernel) in order to ensure that pinctrl gets suspended
after all other drivers.

I Cc'd Pritesh to comment on this.

Still, perhaps device probe ordering should ensure this upstream so
using register_syscore_ops() might not be necessary, although that
relies on drivers probing in the correct order, which they may not
without explicitly pinctrl_get() calls... back to that same problem again!

...
> +static const struct dev_pm_ops tegra_pinctrl_pm_ops = {
> +	.suspend_noirq = tegra_pinctrl_suspend_noirq,
> +	.resume_noirq = tegra_pinctrl_resume_noirq,
> +};
> +#define TEGRA_PINCTRL_PM	(&tegra_pinctrl_pm_ops)
> +#else
> +#define TEGRA_PINCTRL_PM	NULL
> +#endif

I was going to suggest using something like SET_SYSTEM_SLEEP_PM_OPS, but
I guess there's no equivalent for the _noirq variants.

> @@ -752,6 +838,8 @@ int __devinit tegra_pinctrl_probe(struct platform_device *pdev,
>  
>  	platform_set_drvdata(pdev, pmx);
>  
> +	pdev->dev.driver->pm = TEGRA_PINCTRL_PM;

That might be better done in the struct platform_driver initialization
in pinctrl-tegra*.c?
