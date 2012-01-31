Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab2AaMcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:32:48 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35270 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2AaMcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:32:47 -0500
Date: Tue, 31 Jan 2012 20:45:03 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 14/25] irq_domain: Remove irq_domain_add_simple()
Message-ID: <20120131124500.GA28571@S2101-09.ap.freescale.net>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <1327700179-17454-15-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327700179-17454-15-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 02:36:08PM -0700, Grant Likely wrote:
> irq_domain_add_simple() was a stop-gap measure until complete irq_domain
> support was complete.  This patch removes the irq_domain_add_simple()
> interface.
> 
> v2: Updated to pass in host_data pointer on irq_domain allocation.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Milton Miller <miltonm@bga.com>
> ---
>  arch/arm/mach-imx/mach-imx6q.c      |    3 ++-
>  arch/arm/mach-msm/board-msm8x60.c   |    8 ++------
>  arch/arm/mach-mx5/imx51-dt.c        |    4 ++--
>  arch/arm/mach-mx5/imx53-dt.c        |    4 ++--
>  arch/arm/mach-omap2/board-generic.c |    2 +-
>  arch/arm/mach-prima2/irq.c          |    2 +-
>  drivers/mfd/twl-core.c              |    2 +-
>  include/linux/irqdomain.h           |    1 -
>  kernel/irq/irqdomain.c              |   10 ++--------
>  9 files changed, 13 insertions(+), 23 deletions(-)
> 
...
> --- a/arch/arm/mach-mx5/imx51-dt.c
> +++ b/arch/arm/mach-mx5/imx51-dt.c
> @@ -47,7 +47,7 @@ static const struct of_dev_auxdata imx51_auxdata_lookup[] __initconst = {
>  static int __init imx51_tzic_add_irq_domain(struct device_node *np,
>  				struct device_node *interrupt_parent)
>  {
> -	irq_domain_add_simple(np, 0);
> +	irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops, NULL);
>  	return 0;
>  }
>  
> @@ -57,7 +57,7 @@ static int __init imx51_gpio_add_irq_domain(struct device_node *np,
>  	static int gpio_irq_base = MXC_GPIO_IRQ_START + ARCH_NR_GPIOS;
>  
>  	gpio_irq_base -= 32;
> -	irq_domain_add_simple(np, gpio_irq_base);
> +	irq_domain_add_legacy(np, 32, gpio_irq_base, 0, &irq_domain_simple_ops, NULL);

The tzic on imx5 gets 128 irq lines rather than 32 here.  The current
code will make any hwirq that is > 32 hit the WARN_ON below in
irq_domain_legacy_revmap().

	WARN_ON(hwirq < first_hwirq || hwirq >= first_hwirq + size)

The first_hwirq is 0 and size is 32 in this case.

Changing 32 to 128 seems fixing the problem.

>  
>  	return 0;
>  }
> diff --git a/arch/arm/mach-mx5/imx53-dt.c b/arch/arm/mach-mx5/imx53-dt.c
> index 05ebb3e..89de5d4 100644
> --- a/arch/arm/mach-mx5/imx53-dt.c
> +++ b/arch/arm/mach-mx5/imx53-dt.c
> @@ -51,7 +51,7 @@ static const struct of_dev_auxdata imx53_auxdata_lookup[] __initconst = {
>  static int __init imx53_tzic_add_irq_domain(struct device_node *np,
>  				struct device_node *interrupt_parent)
>  {
> -	irq_domain_add_simple(np, 0);
> +	irq_domain_add_legacy(np, 32, 0, 0, &irq_domain_simple_ops, NULL);

Ditto

Regards,
Shawn

>  	return 0;
>  }
>  
> @@ -61,7 +61,7 @@ static int __init imx53_gpio_add_irq_domain(struct device_node *np,
>  	static int gpio_irq_base = MXC_GPIO_IRQ_START + ARCH_NR_GPIOS;
>  
>  	gpio_irq_base -= 32;
> -	irq_domain_add_simple(np, gpio_irq_base);
> +	irq_domain_add_legacy(np, 32, gpio_irq_base, 0, &irq_domain_simple_ops, NULL);
>  
>  	return 0;
>  }
