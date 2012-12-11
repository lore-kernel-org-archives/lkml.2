Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab2LKIak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:30:40 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54537 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2LKIaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:30:39 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] No need to call irq_domain_legacy_revmap() for twice
To: Mike <qiudayu@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, benh@kernel.crashing.org
In-Reply-To: <1353980506.2309.13.camel@localhost>
References: <1348479475-13074-1-git-send-email-qiudayu@linux.vnet.ibm.com> <20121126201739.13F213E09C2@localhost> <1353980506.2309.13.camel@localhost>
Date: Tue, 11 Dec 2012 08:30:23 +0000
Message-Id: <20121211083023.5C5D03E076D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2012 09:41:46 +0800, Mike <qiudayu@linux.vnet.ibm.com> wrote:
> 在 2012-11-26一的 20:17 +0000，Grant Likely写道：
> > On Mon, 24 Sep 2012 17:37:55 +0800, Mike Qiu <qiudayu@linux.vnet.ibm.com> wrote:
> > > Function irq_create_mapping() calls irq_find_mapping(). The later
> > > function has checked if the indicated IRQ domain has hw IRQ mapped to
> > > virtual IRQ through legacy mode or not and return the value of the
> > > legacy irq number by call irq_domain_legacy_revmap(). We needn't
> > > to call irq_domain_legacy_revmap() to do same check in
> > > irq_create_mapping() again.
> > > 
> > > The patch removes the duplicate call.
> > > 
> > > Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
> > > ---
> > >  kernel/irq/irqdomain.c |    7 +++++--
> > >  1 files changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> > > index 49a7772..286d672 100644
> > > --- a/kernel/irq/irqdomain.c
> > > +++ b/kernel/irq/irqdomain.c
> > > @@ -547,9 +547,12 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
> > >  		return virq;
> > >  	}
> > >  
> > > -	/* Get a virtual interrupt number */
> > > +	/*
> > > +	 * For IRQ domain with type of IRQ_DOMAIN_MAP_LEGACY, we needn't
> > > +	 * create the IRQ mapping for non-existing one, so just return 0.
> > > +	 */
> > >  	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
> > > -		return irq_domain_legacy_revmap(domain, hwirq);
> > > +		return 0;
> > 
> > But it does need to return the virq assigned to the hwirq. That is why
> > it has to call the revmap function.
> > 
> Yes, thanks
> 
> this judgment has been done in
>  /*Check if mapping already exists*/
> virq = irq_find_mapping(domain, hwirq);
> 
> if the virq equals none zero, the func irq_create_mapping will 
> return the virq value directly(already exists).
> 
> otherwise, that means virq equals zero, this has two meanings, one is
> haven't find the already exist mapping, the other one is in
> irq_find_mapping()
> 	case IRQ_DOMAIN_MAP_LEGACY:
> 		return irq_domain_legacy_revmap(domain, hwirq); 
> this may return zero.
> 
> So, when we check if it is a IRQ_DOMAIN_MAP_LEGACY, we just return zero
> is OK. because if it is none zero, it will be return after check if
> mapping already exists, and never come here. also we never try to assign
> the virq for the legacy map.
> 
> I don't know if you have understand my explanation.

Yes, your explanation makes sense and you are correct. I'm not going to
apply this for v3.8 (I've left it too late before the merge window), but
I'll look again after the merge window closes.

g.

