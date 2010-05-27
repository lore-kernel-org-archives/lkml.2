Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab0E0Pgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:36:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31067 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab0E0Pge (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 27 May 2010 11:36:34 -0400
Date: Thu, 27 May 2010 11:36:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>
Subject: Re: [Xen-devel] [PATCH 04/11] Fix find_unbound_irq in presence of
	ioapic irqs.
Message-ID: <20100527153601.GC4342@phenom.dumpdata.com>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop> <1274725657-1149-4-git-send-email-stefano.stabellini@eu.citrix.com> <20100526182649.GF5188@phenom.dumpdata.com> <alpine.DEB.2.00.1005271505200.25605@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1005271505200.25605@kaball-desktop>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BFE9173.01DF:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 03:49:12PM +0100, Stefano Stabellini wrote:
> On Wed, 26 May 2010, Konrad Rzeszutek Wilk wrote:
> > On Mon, May 24, 2010 at 07:27:30PM +0100, Stefano Stabellini wrote:
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > Can you provide a more detailed description of why this is needed?
> > 
> 
> We need it because we don't want to break the assumption that the first
> 16 irqs are ISA irqs, and among the other irqs we actually want to be
> sure they are available before using them.

Interesting. So with this commit: 482839e7 and bfbc226d
where we try our best to allocate IRQs for Xen starting from high and
then going down (so that when we are running in PV context with Xen PCI
passthrough we can allocate IRQs for physical devices above IRQ 16 and
not collide with Xen event channels), this would still work.

But we actually wouldn't test the availability of the first sixteen IRQ
for a long time (or never).

> 
> 
> > > ---
> > >  drivers/xen/events.c |   11 ++++++++++-
> > >  1 files changed, 10 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > > index 8b68fc4..1356fa2 100644
> > > --- a/drivers/xen/events.c
> > > +++ b/drivers/xen/events.c
> > > @@ -339,9 +339,18 @@ static int find_unbound_irq(void)
> > >  	int irq;
> > >  	struct irq_desc *desc;
> > >  
> > > -	for (irq = 0; irq < nr_irqs; irq++)
> > > +	for (irq = 0; irq < nr_irqs; irq++) {
> > > +		desc = irq_to_desc(irq);
> > > +		/* only 0->15 have init'd desc; handle irq > 16 */
> > > +		if (desc == NULL)
> > > +			break;
> > > +		if (desc->chip == &no_irq_chip)
> > > +			break;
> > > +		if (desc->chip != &xen_dynamic_chip)
> > > +			continue;
> > >  		if (irq_info[irq].type == IRQT_UNBOUND)
> > >  			break;
> > > +	}
> > >  
> > >  	if (irq == nr_irqs)
> > >  		panic("No available IRQ to bind to: increase nr_irqs!\n");
> > > -- 
> > > 1.5.4.3
> > > 
> > > 
> > > _______________________________________________
> > > Xen-devel mailing list
> > > Xen-devel@lists.xensource.com
> > > http://lists.xensource.com/xen-devel
> > 
