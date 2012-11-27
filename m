Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab2K0Bl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:41:57 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:51767 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838Ab2K0Blz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:41:55 -0500
Message-ID: <1353980506.2309.13.camel@localhost>
Subject: Re: [PATCH] No need to call irq_domain_legacy_revmap() for twice
From: Mike <qiudayu@linux.vnet.ibm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, benh@kernel.crashing.org
Date: Tue, 27 Nov 2012 09:41:46 +0800
In-Reply-To: <20121126201739.13F213E09C2@localhost>
References: <1348479475-13074-1-git-send-email-qiudayu@linux.vnet.ibm.com>
	 <20121126201739.13F213E09C2@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
x-cbid: 12112701-2674-0000-0000-000006E2E220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2012-11-26一的 20:17 +0000，Grant Likely写道：
> On Mon, 24 Sep 2012 17:37:55 +0800, Mike Qiu <qiudayu@linux.vnet.ibm.com> wrote:
> > Function irq_create_mapping() calls irq_find_mapping(). The later
> > function has checked if the indicated IRQ domain has hw IRQ mapped to
> > virtual IRQ through legacy mode or not and return the value of the
> > legacy irq number by call irq_domain_legacy_revmap(). We needn't
> > to call irq_domain_legacy_revmap() to do same check in
> > irq_create_mapping() again.
> > 
> > The patch removes the duplicate call.
> > 
> > Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
> > ---
> >  kernel/irq/irqdomain.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> > index 49a7772..286d672 100644
> > --- a/kernel/irq/irqdomain.c
> > +++ b/kernel/irq/irqdomain.c
> > @@ -547,9 +547,12 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
> >  		return virq;
> >  	}
> >  
> > -	/* Get a virtual interrupt number */
> > +	/*
> > +	 * For IRQ domain with type of IRQ_DOMAIN_MAP_LEGACY, we needn't
> > +	 * create the IRQ mapping for non-existing one, so just return 0.
> > +	 */
> >  	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
> > -		return irq_domain_legacy_revmap(domain, hwirq);
> > +		return 0;
> 
> But it does need to return the virq assigned to the hwirq. That is why
> it has to call the revmap function.
> 
Yes, thanks

this judgment has been done in
 /*Check if mapping already exists*/
virq = irq_find_mapping(domain, hwirq);

if the virq equals none zero, the func irq_create_mapping will 
return the virq value directly(already exists).

otherwise, that means virq equals zero, this has two meanings, one is
haven't find the already exist mapping, the other one is in
irq_find_mapping()
	case IRQ_DOMAIN_MAP_LEGACY:
		return irq_domain_legacy_revmap(domain, hwirq); 
this may return zero.

So, when we check if it is a IRQ_DOMAIN_MAP_LEGACY, we just return zero
is OK. because if it is none zero, it will be return after check if
mapping already exists, and never come here. also we never try to assign
the virq for the legacy map.

I don't know if you have understand my explanation.

Thanks 
Mike



> g.
> 


