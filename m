Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab2GFJZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:25:39 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:25180
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932271Ab2GFJZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:25:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1202h1082kzz8275dhz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Fri, 6 Jul 2012 17:18:04 +0800
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <grant.likely@secretlab.ca>,
        <tglx@linutronix.de>, <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 2/2] irq: add irq_desc_initialize to remove some
 duplicated lines
Message-ID: <20120706091803.GA12558@shlinux2.ap.freescale.net>
References: <1340182831-10477-1-git-send-email-b29396@freescale.com>
 <1340182831-10477-2-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340182831-10477-2-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 05:00:31PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> There're two copies of irq_desc initialization code, reform them into
> an irq_desc_initialize function to call.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
>  kernel/irq/irqdesc.c |   51 +++++++++++++++++++++++++++----------------------
>  1 files changed, 28 insertions(+), 23 deletions(-)
> 
Ping...

Regards
Dong Aisheng

> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> index 192a302..e29db67 100644
> --- a/kernel/irq/irqdesc.c
> +++ b/kernel/irq/irqdesc.c
> @@ -131,34 +131,43 @@ static void free_masks(struct irq_desc *desc)
>  static inline void free_masks(struct irq_desc *desc) { }
>  #endif
>  
> -static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
> +static inline int irq_desc_initialize(struct irq_desc *desc,
> +					int irq, int node, struct module *owner)
>  {
> -	struct irq_desc *desc;
> -	gfp_t gfp = GFP_KERNEL;
> -
> -	desc = kzalloc_node(sizeof(*desc), gfp, node);
> -	if (!desc)
> -		return NULL;
>  	/* allocate based on nr_cpu_ids */
>  	desc->kstat_irqs = alloc_percpu(unsigned int);
>  	if (!desc->kstat_irqs)
> -		goto err_desc;
> +		return -ENOMEM;
>  
> -	if (alloc_masks(desc, gfp, node))
> -		goto err_kstat;
> +	if (alloc_masks(desc, GFP_KERNEL, node)) {
> +		kfree(desc->kstat_irqs);
> +		return -ENOMEM;
> +	}
>  
>  	raw_spin_lock_init(&desc->lock);
>  	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
>  
>  	desc_set_defaults(irq, desc, node, owner);
>  
> -	return desc;
> +	return 0;
> +}
>  
> -err_kstat:
> -	free_percpu(desc->kstat_irqs);
> -err_desc:
> -	kfree(desc);
> -	return NULL;
> +static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
> +{
> +	struct irq_desc *desc;
> +	int ret;
> +
> +	desc = kzalloc_node(sizeof(*desc), GFP_KERNEL, node);
> +	if (!desc)
> +		return NULL;
> +
> +	ret = irq_desc_initialize(desc, irq, node, owner);
> +	if (ret) {
> +		kfree(desc);
> +		return NULL;
> +	}
> +
> +	return desc;
>  }
>  
>  static void free_desc(unsigned int irq)
> @@ -260,13 +269,9 @@ int __init early_irq_init(void)
>  	desc = irq_desc;
>  	count = ARRAY_SIZE(irq_desc);
>  
> -	for (i = 0; i < count; i++) {
> -		desc[i].kstat_irqs = alloc_percpu(unsigned int);
> -		alloc_masks(&desc[i], GFP_KERNEL, node);
> -		raw_spin_lock_init(&desc[i].lock);
> -		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
> -		desc_set_defaults(i, &desc[i], node, NULL);
> -	}
> +	for (i = 0; i < count; i++)
> +		irq_desc_initialize(desc, irq, node, NULL);
> +
>  	return arch_early_irq_init();
>  }
>  
> -- 
> 1.7.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

