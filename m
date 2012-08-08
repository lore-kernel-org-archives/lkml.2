Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab2HHS7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:59:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42388 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758563Ab2HHS7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:59:00 -0400
Message-ID: <5022B6EE.7060006@wwwdotorg.org>
Date: Wed, 08 Aug 2012 12:58:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: vt8500-wm8505-linux-kernel@googlegroups.com, linux-fbdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-doc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, rtc-linux@googlegroups.com,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Eric Andersson <eric.andersson@unixphere.com>,
        linux-serial@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@nvidia.com>, Neil Zhang <zhangwm@marvell.com>,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 6/8] arm: vt8500: Update arch-vt8500 to devicetree support.
References: <1344389967-8465-1-git-send-email-linux@prisktech.co.nz> <1344389967-8465-7-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1344389967-8465-7-git-send-email-linux@prisktech.co.nz>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 07:39 PM, Tony Prisk wrote:
> Merged existing board files to a single dt-capable file.
> Converted irq and timer code to devicetree.
> Removed existing device files that are no longer required with
> devicetree support.
>
> All existing platform devices are converted to devicetree nodes
> except GPIO and PWM.

Perhaps that also explains what I was commenting on in the GPIO driver
patch. Why not convert GPIO too?

> diff --git a/arch/arm/mach-vt8500/irq.c b/arch/arm/mach-vt8500/irq.c

>  /*
> - *  arch/arm/mach-vt8500/irq.c
> + *  arch/arm/mach-vt8500/irq_dt.c

This file didn't get renamed?

> diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c

> +void __init vt8500_init(void)
> +{
> +	struct device_node *np, *fb;
> +	void __iomem *gpio_base;
> +
> +#ifdef CONFIG_FB_VT8500
> +	fb = of_find_compatible_node(NULL, NULL, "via,vt8500-fb");
> +	if (fb) {
> +		np = of_find_compatible_node(NULL, NULL, "via,vt8500-gpio");
> +		if (np) {
> +			gpio_base = of_iomap(np, 0);
> +
> +			if (!gpio_base)
> +				pr_err("%s:of_iomap(gpio_mux) failed\n", __func__);
> +
> +			of_node_put(np);
> +		} else {
> +			gpio_base = ioremap(LEGACY_GPIO_BASE, 0x1000);
> +			if (!gpio_base)
> +				pr_err("%s:ioremap(legacy_gpio_mux) failed\n", __func__);
> +		}
> +		if (gpio_base) {
> +			writel(readl(gpio_base + VT8500_GPIO_MUX_REG) | 1,
> +				gpio_base + VT8500_GPIO_MUX_REG);
> +			iounmap(gpio_base);
> +		} else
> +			pr_err("%s: Could not remap GPIO mux\n", __func__);
> +
> +		of_node_put(fb);
> +	}
> +#endif

That looks quite suspicious. What's it doing? Is this something that
should be part of a pinctrl driver, or the GPIO driver?
