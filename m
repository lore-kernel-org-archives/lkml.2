Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0JEOFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 10:05:22 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:50202 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233Ab0JEOFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 10:05:21 -0400
Message-ID: <4CAB3074.5010106@stericsson.com>
Date: Tue, 5 Oct 2010 16:04:36 +0200
From: Linus Walleij <linus.walleij@stericsson.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Gary King <gking@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Rabin VINCENT <rabin.vincent@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>
Subject: Re: [PATCH 1/2] gic: Add functions to save and restore gic state
References: <1285901335-26354-1-git-send-email-ccross@android.com>
In-Reply-To: <1285901335-26354-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin Cross wrote:

> on systems with idle states which power-gate the logic including
> the gic, such as tegra, the gic distributor needs to be shut down
> and restored on entry and exit from the architecture idle code

Nice!

> +
> +#ifdef CONFIG_PM
> +void gic_dist_save(unsigned int gic_nr)
> +{
> +	unsigned int max_irq = gic_data[gic_nr].max_irq;
> +	void __iomem *dist_base = gic_data[gic_nr].dist_base;
> +	int i;
> +
> +	if (gic_nr >= MAX_GIC_NR)
> +		BUG();
> +
> +	_gic_dist_exit(gic_nr);
> +
> +	for (i = 0; i < DIV_ROUND_UP(max_irq, 16); i++)
> +		gic_data[gic_nr].saved_conf[i] =
> +			readl(dist_base + GIC_DIST_CONFIG + i * 4);
> +
> +	for (i = 0; i < DIV_ROUND_UP(max_irq, 4); i++)
> +		gic_data[gic_nr].saved_pri[i] =
> +			readl(dist_base + GIC_DIST_PRI + i * 4);
> +
> +	for (i = 0; i < DIV_ROUND_UP(max_irq, 4); i++)
> +		gic_data[gic_nr].saved_target[i] =
> +			readl(dist_base + GIC_DIST_TARGET + i * 4);
> +
> +	for (i = 0; i < DIV_ROUND_UP(max_irq, 32); i++)
> +		gic_data[gic_nr].saved_enable[i] =
> +			readl(dist_base + GIC_DIST_ENABLE_SET + i * 4);
> +}
> +
> +void gic_dist_restore(unsigned int gic_nr)
> +{
> +	unsigned int max_irq;
> +	unsigned int i;
> +	void __iomem *dist_base;
> +	void __iomem *cpu_base;
> +
> +	if (gic_nr >= MAX_GIC_NR)
> +		BUG();
> +
> +	_gic_dist_init(gic_nr);
> +
> +	max_irq = gic_data[gic_nr].max_irq;
> +	dist_base = gic_data[gic_nr].dist_base;
> +	cpu_base = gic_data[gic_nr].cpu_base;
> +
> +	for (i = 0; i < DIV_ROUND_UP(max_irq, 16); i++)
> +		writel(gic_data[gic_nr].saved_conf[i],
> +			dist_base + GIC_DIST_CONFIG + i * 4);
> +
> +	for (i = 0; i < DIV_ROUND_UP(max_irq, 4); i++)
> +		writel(gic_data[gic_nr].saved_pri[i],
> +			dist_base + GIC_DIST_PRI + i * 4);
> +
> +	for (i = 0; i < DIV_ROUND_UP(max_irq, 4); i++)
> +		writel(gic_data[gic_nr].saved_target[i],
> +			dist_base + GIC_DIST_TARGET + i * 4);
> +
> +	for (i = 0; i < DIV_ROUND_UP(max_irq, 32); i++)
> +		writel(gic_data[gic_nr].saved_enable[i],
> +			dist_base + GIC_DIST_ENABLE_SET + i * 4);
> +
> +	writel(1, dist_base + GIC_DIST_CTRL);
> +	writel(0xf0, cpu_base + GIC_CPU_PRIMASK);
> +	writel(1, cpu_base + GIC_CPU_CTRL);
> +}
> +#endif

For gic_dist_save()/gic_dist_restore() can you write some
comment to each function about the implicit semantics for
calling them?

If I *guess* correctly gic_dist_save() must be called in
something like a platform idle function after disabling all
IRQs but before sleeping, conversely gic_dist_restort()
must be called after sleeping but before re-enabling the
IRQs.

Apart from that it looks good to me so with this
simple comment-fix it's:
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
