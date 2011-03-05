Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648Ab1CEBHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:07:53 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34543 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760639Ab1CEBHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:07:50 -0500
Date: Fri, 4 Mar 2011 18:07:46 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 06/12] MIPS: Octeon: Add a
 irq_create_of_mapping() implementation.
Message-ID: <20110305010746.GD7579@angua.secretlab.ca>
References: <1299267744-17278-1-git-send-email-ddaney@caviumnetworks.com>
 <1299267744-17278-7-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299267744-17278-7-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 11:42:18AM -0800, David Daney wrote:
> This is needed for Octeon to use the Device Tree.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> ---
>  arch/mips/cavium-octeon/octeon-irq.c |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
> index b365710..b0a9261 100644
> --- a/arch/mips/cavium-octeon/octeon-irq.c
> +++ b/arch/mips/cavium-octeon/octeon-irq.c
> @@ -8,7 +8,9 @@
>  
>  #include <linux/interrupt.h>
>  #include <linux/bitops.h>
> +#include <linux/module.h>
>  #include <linux/percpu.h>
> +#include <linux/of_irq.h>
>  #include <linux/irq.h>
>  #include <linux/smp.h>
>  
> @@ -64,6 +66,29 @@ static void __init octeon_irq_set_ciu_mapping(int irq, int line, int bit,
>  	octeon_irq_ciu_to_irq[line][bit] = irq;
>  }
>  
> +/*
> + * irq_create_of_mapping - Hook to resolve OF irq specifier into a Linux irq#
> + *
> + * Octeon irq maps are a pair of indexes.  The first selects either
> + * ciu0 or ciu1, the second is the bit within the ciu register.
> + */

Is each 'ciu' an interrupt controller, or a 'bank' within the
controller?  Also, it is typical to have another cell for specifying
flags if there is any kind of configuration for each irq line, like
edge vs. level and active high or active low.  (the counter example is
PCI which doesn't use a flags cell because all PCI irqs are level
active.

You'll need to supply documentation for the ciu binding to
Documentation/devicetree/bindings before this patch gets merged.

> +unsigned int irq_create_of_mapping(struct device_node *controller,
> +				   const u32 *intspec, unsigned int intsize)
> +{
> +	int ciu, bit;
> +	unsigned int irq = 0;
> +
> +	ciu = be32_to_cpup(intspec);
> +	bit = be32_to_cpup(intspec + 1);
> +
> +	if (ciu < 8 && bit < 64)
> +		irq = octeon_irq_ciu_to_irq[ciu][bit];
> +
> +	return irq;
> +}
> +EXPORT_SYMBOL_GPL(irq_create_of_mapping);
> +
> +
>  static int octeon_coreid_for_cpu(int cpu)
>  {
>  #ifdef CONFIG_SMP
> -- 
> 1.7.2.3
> 
