Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940Ab1JDXk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 19:40:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48994 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933838Ab1JDXk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 19:40:28 -0400
Date: Tue, 4 Oct 2011 17:39:53 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, jamie@jamieiles.com, b-cousson@ti.com,
        shawn.guo@linaro.org, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/3] irq: support domains with non-zero hwirq base
Message-ID: <20111004233953.GE3009@ponder.secretlab.ca>
References: <1317410880-24828-1-git-send-email-robherring2@gmail.com>
 <1317410880-24828-2-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317410880-24828-2-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 02:27:58PM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Interrupt controllers can have non-zero starting value for h/w irq numbers.
> Adding support in irq_domain allows the domain hwirq numbering to match
> the interrupt controllers' numbering.
> 
> As this makes looping over irqs for a domain more complicated, add loop
> iterators to iterate over all hwirqs and irqs for a domain.
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
>  include/linux/irqdomain.h |   16 +++++++++++++++-
>  kernel/irq/irqdomain.c    |   12 ++++++------
>  2 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> index 3ad553e..c0026b6 100644
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
> +	if (hwirq < d->hwirq_base)
> +		return NO_IRQ;

NO_IRQ is probably not available on x86.  Also, if this condition
is hit then something is definitely wrong.  You should WARN() and
return 0.

Otherwise looks good and you can add my a-b:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

