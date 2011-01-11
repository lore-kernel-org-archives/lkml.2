Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab1AKWDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 17:03:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42622 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab1AKWDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 17:03:21 -0500
Date: Tue, 11 Jan 2011 15:03:17 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 04/15] x86/dtb: add irq domain abstraction
Message-ID: <20110111220317.GA2131@angua.secretlab.ca>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-5-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292600033-12271-5-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 04:33:42PM +0100, Sebastian Andrzej Siewior wrote:
> The here introduced irq_domain abstraction represents a generic irq
> controller. It is a subset of powerpc's irq_host which is going to be
> renamed to irq_domain and then become generic. This implementation will
> be removed once it is generic.
> 
> The xlate callback is resposible to parse irq informations like irq type
> and number and returns the hardware irq number which is reported by the
> hardware as active.
> 
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  arch/x86/include/asm/irq_controller.h |   12 ++++++++
>  arch/x86/include/asm/prom.h           |    2 +
>  arch/x86/kernel/prom.c                |   47 ++++++++++++++++++++++++++++++++-
>  3 files changed, 60 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/include/asm/irq_controller.h
> 
> diff --git a/arch/x86/include/asm/irq_controller.h b/arch/x86/include/asm/irq_controller.h
> new file mode 100644
> index 0000000..423bbbd
> --- /dev/null
> +++ b/arch/x86/include/asm/irq_controller.h
> @@ -0,0 +1,12 @@
> +#ifndef __IRQ_CONTROLLER__
> +#define __IRQ_CONTROLLER__
> +
> +struct irq_domain {
> +	int (*xlate)(struct irq_domain *h, const u32 *intspec, u32 intsize,
> +			u32 *out_hwirq, u32 *out_type);
> +	void *priv;
> +	struct device_node *controller;
> +	struct list_head l;
> +};

True, it's not a full implementation, but I'd rather the same
structure be used for both powerpc and x86.

Thomas, this only touches x86, so I have no objection to you merging
it, but I'd like to see a follow up patch to merge the x86 and powerpc
irq_host/irq_domain structures.

However, there is a defect below that must be fixed first....

>  unsigned int irq_create_of_mapping(struct device_node *controller,
>  		const u32 *intspec, unsigned int intsize)
>  {
> -	return intspec[0];
> +	struct irq_domain *ih;
> +	u32 virq;
> +	u32 type;
> +	int ret;
>  
> +	ih = get_ih_from_node(controller);
> +	if (!ih)
> +		return -ENODEV;

Return value is an unsigned int.  0 or NO_IRQ is the correct thing to
return if an IRQ cannot be mapped.

> +	ret = ih->xlate(ih, intspec, intsize, &virq, &type);
> +	if (ret)
> +		return ret;

Ditto here.  xlate is also supposed to return a virq number, not an
error code, so the failure condition must be "if (!ret)" or
"if (reg == NO_IRQ)".  The former is preferred since we're trying to
eliminate references to NO_IRQ, not add more of them.

> +	if (type == IRQ_TYPE_NONE)
> +		return virq;
> +	/* set the mask if it is different from current */
> +	if (type == (irq_to_desc(virq)->status & IRQF_TRIGGER_MASK))
> +		set_irq_type(virq, type);
> +	return virq;
>  }
>  EXPORT_SYMBOL_GPL(irq_create_of_mapping);
>  
> -- 
> 1.7.3.2
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
