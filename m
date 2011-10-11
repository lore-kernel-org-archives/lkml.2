Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab1JKNTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:19:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38864 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab1JKNTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:19:02 -0400
Message-ID: <4E944242.10606@gmail.com>
Date: Tue, 11 Oct 2011 08:18:58 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] irq: support domains with non-zero hwirq base
References: <20111004233953.GE3009@ponder.secretlab.ca> <1317783380-773-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1317783380-773-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On 10/04/2011 09:56 PM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Interrupt controllers can have non-zero starting value for h/w irq numbers.
> Adding support in irq_domain allows the domain hwirq numbering to match
> the interrupt controllers' numbering.
> 
> As this makes looping over irqs for a domain more complicated, add loop
> iterators to iterate over all hwirqs and irqs for a domain.
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
> Thomas,
> 
> Please ack. I'm dependent on this for adding Calxeda highbank support, so
> I'd like to take this thru arm-soc tree.
> 

Can you please comment?

Rob

> v2:
> - Rebase to tglx's changes in my previous irq domain commit:
> irq: Fix check for already initialized irq_domain in irq_domain_add
> - drop NO_IRQ and add WARN_ON in irq_domain_to_irq
> 
> Rob
> 
>  include/linux/irqdomain.h |   16 +++++++++++++++-
>  kernel/irq/irqdomain.c    |   12 ++++++------
>  2 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index 3ad553e..99834e58 100644
> --- a/include/linux/irqdomain.h
> +++ b/include/linux/irqdomain.h
> @@ -47,6 +47,7 @@ struct irq_domain_ops {
>   *            of the irq_domain is responsible for allocating the array of
>   *            irq_desc structures.
>   * @nr_irq: Number of irqs managed by the irq domain
> + * @hwirq_base: Starting number for hwirqs managed by the irq domain
>   * @ops: pointer to irq_domain methods
>   * @priv: private data pointer for use by owner.  Not touched by irq_domain
>   *        core code.
> @@ -57,6 +58,7 @@ struct irq_domain {
>  	struct list_head list;
>  	unsigned int irq_base;
>  	unsigned int nr_irq;
> +	unsigned int hwirq_base;
>  	const struct irq_domain_ops *ops;
>  	void *priv;
>  	struct device_node *of_node;
> @@ -72,9 +74,21 @@ struct irq_domain {
>  static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
>  					     unsigned long hwirq)
>  {
> -	return d->ops->to_irq ? d->ops->to_irq(d, hwirq) : d->irq_base + hwirq;
> +	if (d->ops->to_irq)
> +		return d->ops->to_irq(d, hwirq);
> +	if (WARN_ON(hwirq < d->hwirq_base))
> +		return 0;
> +	return d->irq_base + hwirq - d->hwirq_base;
>  }
>  
> +#define irq_domain_for_each_hwirq(d, hw) \
> +	for (hw = d->hwirq_base; hw < d->hwirq_base + d->nr_irq; hw++)
> +
> +#define irq_domain_for_each_irq(d, hw, irq) \
> +	for (hw = d->hwirq_base, irq = irq_domain_to_irq(d, hw); \
> +	     hw < d->hwirq_base + d->nr_irq; \
> +	     hw++, irq = irq_domain_to_irq(d, hw))
> +
>  extern void irq_domain_add(struct irq_domain *domain);
>  extern void irq_domain_del(struct irq_domain *domain);
>  #endif /* CONFIG_IRQ_DOMAIN */
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index b57a377..200ce83 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -20,15 +20,15 @@ static DEFINE_MUTEX(irq_domain_mutex);
>  void irq_domain_add(struct irq_domain *domain)
>  {
>  	struct irq_data *d;
> -	int hwirq;
> +	int hwirq, irq;
>  
>  	/*
>  	 * This assumes that the irq_domain owner has already allocated
>  	 * the irq_descs.  This block will be removed when support for dynamic
>  	 * allocation of irq_descs is added to irq_domain.
>  	 */
> -	for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
> -		d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
> +	irq_domain_for_each_irq(domain, hwirq, irq) {
> +		d = irq_get_irq_data(irq);
>  		if (!d) {
>  			WARN(1, "error: assigning domain to non existant irq_desc");
>  			return;
> @@ -54,15 +54,15 @@ void irq_domain_add(struct irq_domain *domain)
>  void irq_domain_del(struct irq_domain *domain)
>  {
>  	struct irq_data *d;
> -	int hwirq;
> +	int hwirq, irq;
>  
>  	mutex_lock(&irq_domain_mutex);
>  	list_del(&domain->list);
>  	mutex_unlock(&irq_domain_mutex);
>  
>  	/* Clear the irq_domain assignments */
> -	for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
> -		d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
> +	irq_domain_for_each_irq(domain, hwirq, irq) {
> +		d = irq_get_irq_data(irq);
>  		d->domain = NULL;
>  	}
>  }

