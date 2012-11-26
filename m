Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab2KZVd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:33:58 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34141 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab2KZVd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:33:56 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/4] irqdomain: augment add_simple() to allocate descs
To: Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Lee Jones <lee.jones@linaro.org>
In-Reply-To: <506457A1.8050404@gmail.com>
References: <1348751625-17420-1-git-send-email-linus.walleij@stericsson.com> <506457A1.8050404@gmail.com>
Date: Mon, 26 Nov 2012 20:22:59 +0000
Message-Id: <20121126202259.190243E09E6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012 08:41:53 -0500, Rob Herring <robherring2@gmail.com> wrote:
> On 09/27/2012 08:13 AM, Linus Walleij wrote:
> > ---
> >  kernel/irq/irqdomain.c | 21 ++++++++++++++++-----
> >  1 file changed, 16 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> > index 49a7772..a0655b6 100644
> > --- a/kernel/irq/irqdomain.c
> > +++ b/kernel/irq/irqdomain.c
> > @@ -148,7 +148,8 @@ static unsigned int irq_domain_legacy_revmap(struct irq_domain *domain,
> >   * @host_data: Controller private data pointer
> >   *
> >   * Allocates a legacy irq_domain if irq_base is positive or a linear
> > - * domain otherwise.
> > + * domain otherwise. For the legacy domain, IRQ descriptors will also
> > + * be allocated.
> >   *
> >   * This is intended to implement the expected behaviour for most
> >   * interrupt controllers which is that a linear mapping should
> > @@ -162,11 +163,21 @@ struct irq_domain *irq_domain_add_simple(struct device_node *of_node,
> >  					 const struct irq_domain_ops *ops,
> >  					 void *host_data)
> >  {
> > -	if (first_irq > 0)
> > -		return irq_domain_add_legacy(of_node, size, first_irq, 0,
> > +	if (first_irq > 0) {
> > +		int irq_base;
> > +
> > +		irq_base = irq_alloc_descs(first_irq, 0, size, numa_node_id());
> 
> This will always fail for !SPARSE_IRQ, so we probably don't want warn in
> that case. So perhaps something like this:
> 
> int irq_base = first_irq;
> 
> if (is_enabled(CONFIG_SPARSE_IRQ)) {
> 	irq_base = irq_alloc_descs(first_irq, 0, size, numa_node_id());
> 	if (irq_base < 0) {
> 		WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
> 		     first_irq);
> 		irq_base = first_irq;
> 	}
> }

Also, warn seems a little over-loud in this case. If the controller is
legitimately claiming irqs in the reserved range, then dumping out a
backtrace is kind of nasty.

g.
