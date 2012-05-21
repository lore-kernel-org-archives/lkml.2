Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab2EUEzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 00:55:21 -0400
Received: from linux-sh.org ([111.68.239.195]:42248 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab2EUEzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 00:55:18 -0400
Date: Mon, 21 May 2012 13:55:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] irqdomain: Support identity mapped VIRQ allocation.
Message-ID: <20120521045515.GD31763@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
 <1337407908-7421-7-git-send-email-lethal@linux-sh.org>
 <20120519202140.7B0973E03B8@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120519202140.7B0973E03B8@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 02:21:40PM -0600, Grant Likely wrote:
> On Sat, 19 May 2012 15:11:46 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> > This adds a new irq_create_identity_mapping() routine to permit platforms
> > to utilize 1:1 identity mapping between hardware and linux IRQs for
> > domain population. The same semantics as irq_create_mapping() apply,
> > though in this case we only support irqdesc allocation at a static
> > location, rather than falling back on dynamic lookup.
> > 
> How about the following for an API (omitting error checking, and the
> actual names are up for debate):
> 
> int irq_domain_associate_many(struct irq_domain *domain,
> 				unsigned int irq_base,
> 				irq_hw_number_t hwirq_base,
> 				int count)
> {
> 	int i;
> 	for (i = 0; i < count; i++)
> 		irq_setup_virq(domain, irq_base + i, hwirq_base + i);
> }
> int irq_create_strict_mappings(struct irq_domain *domain,
> 				unsigned int irq_base,
> 				irq_hw_number_t hwirq_base,
> 				int count)
> {
> 	/* Allows for non-identity, but still static mappings of a
> 	 * range of irq numbers */
> 	irq_alloc_descs(irq_base, irq_base, irq_domain_nid(domain->of_node));
> 	irq_domain_associate_many(domain, irq_base, hwirq, count);
> 	...
> }
> 
> /* in header */
> static int irq_create_identity_mapping(struct irq_domain *domain,
> 					irq_hw_number_t hwirq_base)
> {
> 	irq_create_strict_mappings(domain, hwirq_base, hwirq_base, 1);
> }
> 
> That would give the ability to either associated for pre-allocated
> irq_descs, or strict map for allocating a specific range of irqs.
> 
That's cleaner than what I had, so it looks good to me. This is what I've
implemented in the updated patch.

I've still provided irq_domain_associate() in addition to the _many()
case to support non-linear association. I'll probably start out by doing
the sh intc conversion using this API alongside the radix tree, and then
gradually converting over to having the irqdomain code do all of my irq
desc management for me.

> This is a new API, and I'm not a fan of the irq_default_domain usage
> so I'd like just drop the above too lines.  My opinion is that if your
> calling into get a mapping, then the code really should know what
> domain it is requesting from.  If a default domain really is needed,
> then there it should be explicit for the caller to find the default
> domain and then pass that in to this function.
> 
Yes, agreed. Adding something like irq_get_default_domain() is trivial if
and when a need arises.

Updated patches to follow.
