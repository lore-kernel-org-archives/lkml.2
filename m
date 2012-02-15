Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2BOU3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:29:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34950 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2BOU3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:29:52 -0500
Date: Wed, 15 Feb 2012 13:29:46 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 25/25] irq_domain: mostly eliminate slow-path revmap
 lookups
Message-ID: <20120215202946.GI25779@ponder.secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <1327700179-17454-26-git-send-email-grant.likely@secretlab.ca>
 <4F3BDF1E.4040506@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3BDF1E.4040506@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 05:36:46PM +0100, Nicolas Ferre wrote:
> Grant,
> 
> I do not know if it is the latest revision but I have identified some
> issues on error/slow paths...
> 
> 
> On 01/27/2012 10:36 PM, Grant Likely :
> > With the current state of irq_domain, the reverse map is always used when
> > new IRQs get mapped.  This means that the irq_find_mapping() function
> > can be simplified to always call out to the revmap-specific lookup function.
> > 
> > This patch adds lookup functions for the revmaps that don't yet have one
> > and removes the slow path lookup from most of the code paths.  The only
> > place where the slow path legitimately remains is when the linear map
> > is used with a hwirq number larger than the revmap size.
> > 
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Milton Miller <miltonm@bga.com>
> > ---
> >  arch/powerpc/sysdev/xics/xics-common.c |    3 -
> >  include/linux/irqdomain.h              |    3 +-
> >  kernel/irq/irqdomain.c                 |   94 +++++++++++++++++---------------
> >  3 files changed, 51 insertions(+), 49 deletions(-)
> > 
> > diff --git a/arch/powerpc/sysdev/xics/xics-common.c b/arch/powerpc/sysdev/xics/xics-common.c
> > index ea5e204..1d7067d 100644
> > --- a/arch/powerpc/sysdev/xics/xics-common.c
> > +++ b/arch/powerpc/sysdev/xics/xics-common.c
> > @@ -330,9 +330,6 @@ static int xics_host_map(struct irq_domain *h, unsigned int virq,
> >  
> >  	pr_devel("xics: map virq %d, hwirq 0x%lx\n", virq, hw);
> >  
> > -	/* Insert the interrupt mapping into the radix tree for fast lookup */
> > -	irq_radix_revmap_insert(xics_host, virq, hw);
> > -
> >  	/* They aren't all level sensitive but we just don't really know */
> >  	irq_set_status_flags(virq, IRQ_LEVEL);
> >  
> > diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> > index 0b00f83..38314f2 100644
> > --- a/include/linux/irqdomain.h
> > +++ b/include/linux/irqdomain.h
> > @@ -93,6 +93,7 @@ struct irq_domain {
> >  	struct list_head link;
> >  
> >  	/* type of reverse mapping_technique */
> > +	unsigned int (*revmap)(struct irq_domain *host, irq_hw_number_t hwirq);
> >  	unsigned int revmap_type;
> >  	union {
> >  		struct {
> > @@ -155,8 +156,6 @@ extern void irq_dispose_mapping(unsigned int virq);
> >  extern unsigned int irq_find_mapping(struct irq_domain *host,
> >  				     irq_hw_number_t hwirq);
> >  extern unsigned int irq_create_direct_mapping(struct irq_domain *host);
> > -extern void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
> > -				    irq_hw_number_t hwirq);
> >  extern unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
> >  					    irq_hw_number_t hwirq);
> >  extern unsigned int irq_linear_revmap(struct irq_domain *host,
> > diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> > index 5b4fc4d..91c1cb7 100644
> > --- a/kernel/irq/irqdomain.c
> > +++ b/kernel/irq/irqdomain.c
> > @@ -104,6 +104,7 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
> >  	domain->revmap_data.legacy.first_irq = first_irq;
> >  	domain->revmap_data.legacy.first_hwirq = first_hwirq;
> >  	domain->revmap_data.legacy.size = size;
> > +	domain->revmap = irq_domain_legacy_revmap;
> >  
> >  	mutex_lock(&irq_domain_mutex);
> >  	/* Verify that all the irqs are available */
> > @@ -174,18 +175,35 @@ struct irq_domain *irq_domain_add_linear(struct device_node *of_node,
> >  	}
> >  	domain->revmap_data.linear.size = size;
> >  	domain->revmap_data.linear.revmap = revmap;
> > +	domain->revmap = irq_linear_revmap;
> >  	irq_domain_add(domain);
> >  	return domain;
> >  }
> >  
> > +static unsigned int irq_domain_nomap_revmap(struct irq_domain *domain,
> > +					    irq_hw_number_t hwirq)
> > +{
> > +	struct irq_data *data = irq_get_irq_data(hwirq);
> > +
> > +	if (WARN_ON_ONCE(domain->revmap_type != IRQ_DOMAIN_MAP_NOMAP))
> > +		return irq_find_mapping(domain, hwirq);
> 
> Should be:
> 		return irq_find_mapping_slow(domain, hwirq);
> 
> Recursion otherwise...

Good catch; but it's not the whole story.  Part of the problem when looking
at the other revmap functions is that the revmaps can be called by external
code and there is the possibility that the wrong revmap got called.  In that
case, calling the normal path is the right thing to do.  However, it is also
possible (but unlikely) to have a ->revmap() and ->revmap_type mismatch where
calling the normal path would indeed cause a recursion.

So, the whole ->revmap thing is a weak design and needs to be rethought.

However, for the time being, I'll change all the revmaps to use the slow
path because it is safer.

g.
