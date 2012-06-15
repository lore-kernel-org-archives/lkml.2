Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab2FOWeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:34:09 -0400
Received: from linux-sh.org ([111.68.239.195]:39198 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758274Ab2FOWeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:34:07 -0400
Date: Sat, 16 Jun 2012 07:34:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] irqdomain: Support one-shot tear down of domain
 mappings.
Message-ID: <20120615223403.GB7357@linux-sh.org>
References: <1339572841-26175-1-git-send-email-lethal@linux-sh.org>
 <1339572841-26175-2-git-send-email-lethal@linux-sh.org>
 <20120615183518.514853E0ACE@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615183518.514853E0ACE@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 12:35:18PM -0600, Grant Likely wrote:
> On Wed, 13 Jun 2012 16:34:01 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> > +/**
> > + * irq_domain_dispose_mappings() - Dispose of all mappings in a domain
> > + * @domain: domain to tear down
> > + */
> > +void irq_domain_dispose_mappings(struct irq_domain *domain)
> > +{
> > +	if (domain->revmap_type == IRQ_DOMAIN_MAP_NOMAP)
> > +		return;
> > +
> > +	if (domain->linear_size) {
> > +		int i;
> > +
> > +		for (i = 0; i < domain->linear_size; i++)
> > +			irq_dispose_mapping(domain->linear_revmap[i]);
> > +	} else {
> 
> The 'else' should be dropped I think.  With the merge of linear and
> tree mappings into the same domain type, it is possible for a domain
> to have both linear and tree mappings in the same instance.  So tree
> needs to be cleared even if linear_size is non-zero.
> 
Ok, that's fine. Though by that same logic wouldn't it also be possible
for a domain to have multiple linear ranges?

> > +		struct irq_data *irq_data_batch[IRQ_DOMAIN_BATCH_IRQS];
> > +		unsigned int nr_found;
> > +		unsigned long index = 0;
> > +
> > +		rcu_read_lock();
> > +
> > +		for (;;) {
> 
> Nit; while not 'while(1)'?
> 
Personal taste, though really it's probably better to just do a
do { ... } while (nr_found == IRQ_DOMAIN_BATCH_IRQS), which will save an
iteration when we've run out of tree.

> > +			int i;
> 
> Nit; move 'i' up with nr_found above.
> 
I prefer to have my variables defined in the scope in which they are
used. Though obviously they'll be the same now with consolidation.

> > +
> > +			nr_found = radix_tree_gang_lookup(&domain->radix_tree,
> > +					(void **)irq_data_batch, index,
> > +					ARRAY_SIZE(irq_data_batch));
> > +			if (!nr_found)
> > +				break;
> 
> Or better:
> 
> 	while (nr_found = radix_tree_gang_lookup(&domain->radix_tree,
> 				(void **)irq_data_batch, index,
> 				ARRAY_SIZE(irq_data_batch))) {
> 
That'll still loop even if nr_found returns less than the batch size
(which only ocurred to me after I sent the patch), so the do { } while
will at least save a superfluous lookup.

I'll respin with the above rework.
