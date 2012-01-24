Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab2AXWKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:10:08 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46385 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2AXWKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:10:06 -0500
Message-ID: <4F1F2C3A.3060607@gmail.com>
Date: Tue, 24 Jan 2012 16:10:02 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        benh@kernel.crashing.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFCv2 13/14] irq_domain: Remove 'new' irq_domain in favour of
 the ppc one
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca> <1327352870-14687-14-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1327352870-14687-14-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2012 03:07 PM, Grant Likely wrote:
> This patch removes the simplistic implementation of irq_domains and enables
> the powerpc infrastructure for all irq_domain users.  The powerpc
> infrastructure includes support for complex mappings between Linux and
> hardware irq numbers, and can manage allocation of irq_descs.
> 
> This patch also converts the few users of irq_domain_add()/irq_domain_del()
> to call irq_domain_add_legacy() instead.
> 
> v2: Fix removal of irq_alloc_descs() call in gic driver
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/arm/common/gic.c               |   85 ++++++++-----------
>  arch/arm/common/vic.c               |   16 +---
>  arch/arm/include/asm/hardware/gic.h |    4 +-
>  arch/arm/include/asm/hardware/vic.h |    2 +
>  arch/arm/mach-exynos/common.c       |    2 +-
>  arch/arm/mach-versatile/core.c      |    5 +-
>  drivers/mfd/twl-core.c              |   12 +--
>  include/linux/irqdomain.h           |   45 +---------
>  kernel/irq/irqdomain.c              |  159 +++--------------------------------
>  9 files changed, 69 insertions(+), 261 deletions(-)
> 
> diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c

snip

> @@ -716,17 +708,17 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>  		gic_irqs = 1020;
>  	gic->gic_irqs = gic_irqs;
>  
> -	domain->nr_irq = gic_irqs - domain->hwirq_base;
> -	domain->irq_base = irq_alloc_descs(irq_start, 16, domain->nr_irq,
> -					   numa_node_id());
> -	if (IS_ERR_VALUE(domain->irq_base)) {
> +	irq_base = irq_alloc_descs(irq_start, 16, gic_irqs - hwirq_base,
> +				   numa_node_id());
> +	if (IS_ERR_VALUE(irq_base)) {
>  		WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
>  		     irq_start);
> -		domain->irq_base = irq_start;
> +		irq_base = irq_start;
>  	}
> -	domain->host_data = gic;
> -	domain->ops = &gic_irq_domain_ops;
> -	irq_domain_add(domain);
> +	gic->domain = irq_domain_add_legacy(node, gic_irqs, irq_base,

gic_irqs is wrong here. It needs 16 or 32 subtracted off. This patch
will fix things:

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 44bf4e7..5fc0c97 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -707,8 +707,9 @@ void __init gic_init_bases(unsigned int gic_nr, int
irq_start,
        if (gic_irqs > 1020)
                gic_irqs = 1020;
        gic->gic_irqs = gic_irqs;
+       gic_irqs -= hwirq_base;

-       irq_base = irq_alloc_descs(irq_start, 16, gic_irqs - hwirq_base,
+       irq_base = irq_alloc_descs(irq_start, 16, gic_irqs,
                                   numa_node_id());
        if (IS_ERR_VALUE(irq_base)) {
                WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming
pre-allocated\n",

> +				    hwirq_base, &gic_irq_domain_ops, gic);
> +	if (WARN_ON(!gic->domain))
> +		return;
>  
>  	gic_chip.flags |= gic_arch_extn.flags;
>  	gic_dist_init(gic);
