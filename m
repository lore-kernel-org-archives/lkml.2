Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab2AMAhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 19:37:31 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51526 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab2AMAh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 19:37:27 -0500
Message-ID: <4F0F7CC5.5080900@gmail.com>
Date: Thu, 12 Jan 2012 18:37:25 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, sfr@canb.auug.org.au
Subject: Re: [RFC 12/14] irq_domain: Add support for base irq and hwirq in
 legacy mappings
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca> <1326313337-24603-13-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1326313337-24603-13-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 02:22 PM, Grant Likely wrote:
> Add support for a legacy mapping where irq = (hwirq - first_hwirq + first_irq)
> so that a controller driver can allocate a fixed range of irq_descs and use
> a simple calculation to translate back and forth between linux and hw irq
> numbers.  This is needed to use an irq_domain with many of the ARM interrupt
> controller drivers that manage their own irq_desc allocations.  Ultimately
> the goal is to migrate those drivers to use the linear revmap, but doing it
> this way allows each driver to be converted separately which makes the
> migration path easier.
> 
> This patch generalizes the IRQ_DOMAIN_MAP_LEGACY method to use
> (first_irq-first_hwirq) as the offset between hwirq and linux irq number,
> and adds checks to make sure that the hwirq number does not exceed range
> assigned to the controller.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  arch/powerpc/include/asm/irq.h   |    3 -
>  arch/powerpc/sysdev/i8259.c      |    2 +-
>  arch/powerpc/sysdev/tsi108_pci.c |    2 +-
>  include/linux/irqdomain.h        |   20 +++++++++-
>  kernel/irq/irqdomain.c           |   78 +++++++++++++++++++++++++-------------
>  5 files changed, 73 insertions(+), 32 deletions(-)
> 

snip...

> @@ -454,8 +477,11 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
>  		return 0;
>  
>  	/* legacy -> bail early */
> -	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
> -		return hwirq;
> +	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY) {
> +		if (hwirq > domain->revmap_data.legacy.size)
> +			return 0;
> +		return domain->revmap_data.legacy.first_irq + hwirq;

This needs a "- domain->revmap_data.legacy.first_hwirq"

Rob

> +	}
>  
>  	/* Slow path does a linear search of the map */
>  	if (hint < NUM_ISA_INTERRUPTS)
