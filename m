Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab2BITsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 14:48:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53021 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490Ab2BITsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:48:14 -0500
Date: Thu, 9 Feb 2012 11:48:07 -0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, b-cousson@ti.com,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v6] irq: add irq_domain support to generic-chip
Message-ID: <20120209194806.GA2493@r65073-Latitude-D630>
References: <1328308512-22594-1-git-send-email-robherring2@gmail.com>
 <1328741722-1254-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328741722-1254-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 04:55:22PM -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Add irq domain support to irq generic-chip. This enables users of
> generic-chip to support dynamic irq assignment needed for DT interrupt
> binding.
> 
> Thanks to Shawn Guo for fixes and testing.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
> Here's the latest version. This has fixes from Shawn Guo, so should be
> working. This version is also available here:
> 
Rob, yes it's working.  But I think it should be working in a better
way after I play it a little bit more.  See comment below.
...
> +int irq_setup_generic_chip_domain(const char *name, struct device_node *node,
> +				int num_ct, unsigned int irq_base,
> +				void __iomem *reg_base,
> +				irq_flow_handler_t handler, u32 hwirq_cnt,
> +				enum irq_gc_flags flags, unsigned int clr,
> +				unsigned int set,
> +				void (*gc_init_cb)(struct irq_chip_generic *),
> +				void *private)
> +{
> +	int ret, i;
> +	struct irq_chip_generic **gc;
> +	struct irq_domain *d;
> +	int num_gc = ALIGN(hwirq_cnt, 32) / 32;
> +
> +	gc = kzalloc(num_gc * sizeof(struct irq_chip_generic *), GFP_KERNEL);
> +	if (!gc)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < num_gc; i++) {
> +		gc[i] = irq_alloc_generic_chip(name, num_ct, irq_base,
> +			       reg_base, handler);
> +		if (!gc[i]) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +		gc[i]->hwirq_base = i * 32;
> +		gc[i]->private = private;
> +
> +		gc_init_cb(gc[i]);
> +
> +		irq_setup_generic_chip(gc[i], 0, flags, clr, set);
> +	}
> +
> +	if (node)
> +		d = irq_domain_add_linear(node, hwirq_cnt,
> +					  &irq_gc_irq_domain_ops, gc);
> +	else
> +		d = irq_domain_add_legacy(node, hwirq_cnt, irq_base, 0,
> +					  &irq_gc_irq_domain_ops, gc);
> +
I do not think it's good to make this decision based on whether it's
dt or non-dt case.  That said, it's fairly valid and actually
encouraged that non-dt users use linear domain too, and also the
irqdomain core has no limit on dt users to use legacy domain.  Instead,
it's much more reasonable to make this decision based on if irq_base,
something like you did in your v3 patch.

 
-       if (node)
+       if ((int) irq_base < 0)

Otherwise,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

Tested on imx51 with tzic and gpio interrupt controller.

Regards,
Shawn

> +	for (i = 0; i < num_gc; i++)
> +		gc[i]->domain = d;
> +
> +	return 0;
> +
> + err:
> +	for ( ; i >= 0; i--)
> +		kfree(gc[i]);
> +	kfree(gc);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(irq_setup_generic_chip_domain);
> +#endif
> +
