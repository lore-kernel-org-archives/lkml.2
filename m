Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab0E0OpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:45:17 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:6011 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab0E0OpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:45:13 -0400
X-IronPort-AV: E=Sophos;i="4.53,311,1272844800"; 
   d="scan'208";a="122947"
Date: Thu, 27 May 2010 15:49:12 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>
Subject: Re: [Xen-devel] [PATCH 04/11] Fix find_unbound_irq in presence of
 ioapic irqs.
In-Reply-To: <20100526182649.GF5188@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1005271505200.25605@kaball-desktop>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop> <1274725657-1149-4-git-send-email-stefano.stabellini@eu.citrix.com> <20100526182649.GF5188@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Konrad Rzeszutek Wilk wrote:
> On Mon, May 24, 2010 at 07:27:30PM +0100, Stefano Stabellini wrote:
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Can you provide a more detailed description of why this is needed?
> 

We need it because we don't want to break the assumption that the first
16 irqs are ISA irqs, and among the other irqs we actually want to be
sure they are available before using them.


> > ---
> >  drivers/xen/events.c |   11 ++++++++++-
> >  1 files changed, 10 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index 8b68fc4..1356fa2 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -339,9 +339,18 @@ static int find_unbound_irq(void)
> >  	int irq;
> >  	struct irq_desc *desc;
> >  
> > -	for (irq = 0; irq < nr_irqs; irq++)
> > +	for (irq = 0; irq < nr_irqs; irq++) {
> > +		desc = irq_to_desc(irq);
> > +		/* only 0->15 have init'd desc; handle irq > 16 */
> > +		if (desc == NULL)
> > +			break;
> > +		if (desc->chip == &no_irq_chip)
> > +			break;
> > +		if (desc->chip != &xen_dynamic_chip)
> > +			continue;
> >  		if (irq_info[irq].type == IRQT_UNBOUND)
> >  			break;
> > +	}
> >  
> >  	if (irq == nr_irqs)
> >  		panic("No available IRQ to bind to: increase nr_irqs!\n");
> > -- 
> > 1.5.4.3
> > 
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xensource.com
> > http://lists.xensource.com/xen-devel
> 
