Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2FPGAU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:00:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:60709 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab2FPGAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:00:18 -0400
Message-ID: <1339826385.9220.222.camel@pasglop>
Subject: Re: [PATCH 07/12] irqdomain: Make ops->map hook optional
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Date: Sat, 16 Jun 2012 15:59:45 +1000
In-Reply-To: <1339822897-15840-8-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
	 <1339822897-15840-8-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 23:01 -0600, Grant Likely wrote:
> There isn't a really compelling reason to force ->map to be populated,
> so allow it to be left unset.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Paul Mundt <lethal@linux-sh.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Rob Herring <rob.herring@calxeda.com>
> ---
>  kernel/irq/irqdomain.c |   14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 00c383b..e88a7b0 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -205,7 +205,8 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
>  		 * one can then use irq_create_mapping() to
>  		 * explicitly change them
>  		 */
> -		ops->map(domain, irq, hwirq);
> +		if (ops->map)
> +			ops->map(domain, irq, hwirq);
>  
>  		/* Clear norequest flags */
>  		irq_clear_status_flags(irq, IRQ_NOREQUEST);
> @@ -402,8 +403,8 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
>  
>  		irq_data->hwirq = hwirq;
>  		irq_data->domain = domain;
> -		if (domain->ops->map(domain, virq, hwirq)) {
> -			pr_debug("irq-%i==>hwirq-0x%lx mapping failed\n", virq, hwirq);
> +		if (domain->ops->map && domain->ops->map(domain, virq, hwirq)) {
> +			pr_err("irq-%i==>hwirq-0x%lx mapping failed\n", virq, hwirq);
>  			irq_data->domain = NULL;
>  			irq_data->hwirq = 0;
>  			goto err_unmap;
> @@ -783,12 +784,6 @@ static int __init irq_debugfs_init(void)
>  __initcall(irq_debugfs_init);
>  #endif /* CONFIG_IRQ_DOMAIN_DEBUG */
>  
> -static int irq_domain_simple_map(struct irq_domain *d, unsigned int irq,
> -				 irq_hw_number_t hwirq)
> -{
> -	return 0;
> -}
> -
>  /**
>   * irq_domain_xlate_onecell() - Generic xlate for direct one cell bindings
>   *
> @@ -851,7 +846,6 @@ int irq_domain_xlate_onetwocell(struct irq_domain *d,
>  EXPORT_SYMBOL_GPL(irq_domain_xlate_onetwocell);
>  
>  const struct irq_domain_ops irq_domain_simple_ops = {
> -	.map = irq_domain_simple_map,
>  	.xlate = irq_domain_xlate_onetwocell,
>  };
>  EXPORT_SYMBOL_GPL(irq_domain_simple_ops);


