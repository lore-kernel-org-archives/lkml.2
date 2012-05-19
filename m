Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab2ESUXD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 16:23:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51658 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab2ESUXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 16:23:01 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] irq_domain: Standardise legacy/linear domain selection
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1337428920-7674-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1337428920-7674-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Sat, 19 May 2012 14:22:58 -0600
Message-Id: <20120519202258.D9B903E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2012 13:02:00 +0100, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> A large proportion of interrupt controllers that support legacy mappings
> do so because non-DT systems need to use fixed IRQ numbers when registering
> devices via buses but can otherwise use a linear mapping. The interrupt
> controller itself typically is not affected by the mapping used and best
> practice is to use a linear mapping where possible so drivers frequently
> select at runtime depending on if a legacy range has been allocated to
> them.
> 
> Standardise this behaviour by providing irq_domain_register_simple() which
> will allocate a linear mapping unless a positive first_irq is provided in
> which case it will fall back to a legacy mapping. This helps make best
> practice for irq_domain adoption clearer.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  Documentation/IRQ-domain.txt |    5 +++++
>  include/linux/irqdomain.h    |    5 +++++
>  kernel/irq/irqdomain.c       |   30 ++++++++++++++++++++++++++++++
>  3 files changed, 40 insertions(+)

I'm looking at killing the legacy mapping entirely which will push
changing all the users anyway.  I'm going to hold off on applying this
one for a day or so until I'm sure of what it will look like.

g.

> 
> diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
> index 27dcaab..1401cec 100644
> --- a/Documentation/IRQ-domain.txt
> +++ b/Documentation/IRQ-domain.txt
> @@ -93,6 +93,7 @@ Linux IRQ number into the hardware.
>  Most drivers cannot use this mapping.
>  
>  ==== Legacy ====
> +irq_domain_add_simple()
>  irq_domain_add_legacy()
>  irq_domain_add_legacy_isa()
>  
> @@ -115,3 +116,7 @@ The legacy map should only be used if fixed IRQ mappings must be
>  supported.  For example, ISA controllers would use the legacy map for
>  mapping Linux IRQs 0-15 so that existing ISA drivers get the correct IRQ
>  numbers.
> +
> +Most users of legacy mappings should use irq_domain_add_simple() which
> +will use a legacy domain only if an IRQ range is supplied by the
> +system and will otherwise use a linear domain mapping.
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index c65740d..fcf4142 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -112,6 +112,11 @@ struct irq_domain {
>  };
>  
>  #ifdef CONFIG_IRQ_DOMAIN
> +struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
> +					 unsigned int size,
> +					 unsigned int first_irq,
> +					 const struct irq_domain_ops *ops,
> +					 void *host_data);
>  struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
>  					 unsigned int size,
>  					 unsigned int first_irq,
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index d0e50eb..86ae10f 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -77,6 +77,36 @@ static unsigned int irq_domain_legacy_revmap(struct irq_domain *domain,
>  }
>  
>  /**
> + * irq_domain_add_simple() - Allocate and register a simple irq_domain.
> + * @of_node: pointer to interrupt controller's device tree node.
> + * @size: total number of irqs in mapping
> + * @first_irq: first number of irq block assigned to the domain
> + * @ops: map/unmap domain callbacks
> + * @host_data: Controller private data pointer
> + *
> + * Allocates a legacy irq_domain if irq_base is positive or a linear
> + * domain otherwise.
> + *
> + * This is intended to implement the expected behaviour for most
> + * interrupt controllers which is that a linear mapping should
> + * normally be used unless the system requires a legacy mapping in
> + * order to support supplying interrupt numbers during non-DT
> + * registration of devices.
> + */
> +struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
> +					 unsigned int size,
> +					 unsigned int first_irq,
> +					 const struct irq_domain_ops *ops,
> +					 void *host_data)
> +{
> +	if (first_irq > 0)
> +		return irq_domain_add_legacy(of_node, size, first_irq, 0,
> +					     ops, host_data);
> +	else
> +		return irq_domain_add_linear(of_node, size, ops, host_data);
> +}
> +
> +/**
>   * irq_domain_add_legacy() - Allocate and register a legacy revmap irq_domain.
>   * @of_node: pointer to interrupt controller's device tree node.
>   * @size: total number of irqs in legacy mapping
> -- 
> 1.7.10
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
