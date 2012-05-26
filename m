Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab2EZNNA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:13:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64870 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2EZNMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:12:15 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] irqdomain: Support for static IRQ mapping and association.
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <1337576792-5347-2-git-send-email-lethal@linux-sh.org>
References: <1337576792-5347-1-git-send-email-lethal@linux-sh.org> <1337576792-5347-2-git-send-email-lethal@linux-sh.org>
Date: Fri, 25 May 2012 19:50:49 -0600
Message-Id: <20120526015049.1616D3E2336@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012 14:06:32 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> +/**
> + * irq_domain_associate_many() - Associate a range of hw irqs with linux irqs
> + * @domain: domain owning the interrupt range
> + * @irq_base: beginning of linux IRQ range
> + * @hwirq_base: beginning of hardware IRQ range
> + * @count: Number of interrupts to associate
> + *
> + * This routine takes care of creating an association between a range of
> + * hardware and linux IRQs using pre-existing IRQ allocations. For use by
> + * controllers that do their own irq_desc management.
> + */
> +int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
> +			      irq_hw_number_t hwirq_base, int count)
> +{
> +	int i, ret;
> +
> +	for (i = 0; i < count; i++) {
> +		ret = irq_domain_associate(domain, irq_base + i,
> +					   hwirq_base + i);
> +		if (unlikely(ret))
> +			goto unmap;
> +	}
> +
> +	return 0;
> +
> +unmap:
> +	while (--i >= 0) {
> +		if (domain->ops->unmap)
> +			domain->ops->unmap(domain, irq_base + i);
> +
> +		irq_set_status_flags(irq_base + i, IRQ_NOREQUEST);
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(irq_domain_associate_many);

Looks good, but I've flipped around the patch to make
irq_domain_associate() a simple wrapper around
irq_domain_associate_many() instead of the other way around.  It makes
for a bigger change to the existing irq_setup_virq() code, but in the
end I think it makes more to keep all the logic in one place.  I'll
post my revised version.

I've also added sanity checks to make sure only allocated irq_descs
can get associated.  Otherwise the kernel will oops.

> +/**
> + * irq_create_strict_mappings() - Map a range of hw irqs to fixed linux irqs
> + * @domain: domain owning the interrupt range
> + * @irq_base: beginning of linux IRQ range
> + * @hwirq_base: beginning of hardware IRQ range
> + * @count: Number of interrupts to map
> + *
> + * This routine is used for allocating and mapping a range of hardware
> + * irqs to linux irqs where the linux irq numbers are at pre-defined
> + * locations. For use by controllers that already have static mappings
> + * to insert in to the domain.
> + *
> + * Non-linear users can use irq_create_identity_mapping() for IRQ-at-a-time
> + * domain insertion.
> + *
> + * 0 is returned upon success, while any failure to establish a static
> + * mapping is treated as an error.
> + */
> +int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
> +			       irq_hw_number_t hwirq_base, int count)
> +{
> +	int ret;
> +
> +	ret = irq_alloc_descs(irq_base, irq_base, count,
> +			      of_node_to_nid(domain->of_node));
> +	if (unlikely(ret < 0))
> +		return ret;
> +
> +	ret = irq_domain_associate_many(domain, irq_base, hwirq_base, count);
> +	if (unlikely(ret < 0)) {
> +		irq_free_descs(irq_base, count);
> +		return ret;
> +	}

It would be really good to make sure the hwirqs aren't already
associated before trying to associate them again.  Unfortunately that
can't be done (nicely) until I get rid of the slow path lookup.  I've
got a patch for that which I'll rebase on top of this one and post soon.

g.

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(irq_create_strict_mappings);
> +
>  unsigned int irq_create_of_mapping(struct device_node *controller,
>  				   const u32 *intspec, unsigned int intsize)
>  {
> -- 
> 1.7.9.rc0.28.g0e1cf
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
