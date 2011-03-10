Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1CJImN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:42:13 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:8531 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab1CJImL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:42:11 -0500
X-IronPort-AV: E=Sophos;i="4.62,295,1297036800"; 
   d="scan'208";a="4713370"
Subject: Re: [PATCH 09/14] xen: events: push setup of
 irq<->{evtchn,ipi,virq,pirq} maps into irq_info init functions
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110310045647.GA10574@dumpdata.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
	 <1299692486-28634-9-git-send-email-ian.campbell@citrix.com>
	 <20110310045647.GA10574@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 10 Mar 2011 08:42:08 +0000
Message-ID: <1299746528.17339.721.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 04:56 +0000, Konrad Rzeszutek Wilk wrote:
> On Wed, Mar 09, 2011 at 05:41:21PM +0000, Ian Campbell wrote:
> > Encapsulate setup of XXX_to_irq array in the relevant
> > xen_irq_info_*_init function.
> > 
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > ---
> >  drivers/xen/events.c |   42 +++++++++++++++++++++---------------------
> >  1 files changed, 21 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index 72725fa..cf372d4 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -126,6 +126,7 @@ static struct irq_info *info_for_irq(unsigned irq)
> >  
> >  /* Constructors for packed IRQ information. */
> >  static void xen_irq_info_common_init(struct irq_info *info,
> > +				     unsigned irq,
> >  				     enum xen_irq_type type,
> >  				     unsigned short evtchn,
> >  				     unsigned short cpu)
> > @@ -136,6 +137,8 @@ static void xen_irq_info_common_init(struct irq_info *info,
> >  	info->type = type;
> >  	info->evtchn = evtchn;
> >  	info->cpu = cpu;
> > +
> > +	evtchn_to_irq[evtchn] = irq;
> 
> Is there any case where this would lead to an over-write? Should we
> have an
>   WARN_ON(evtchn_to_irq[evtchn] != -1)
> 
> just to check?

This patch is pure code motion so there should be no more need for a
check than there was before.

I don't think it can happen, the callers are either running in a context
where the evtchn mapping has just been zapped (e.g. resume) or they
include an explicit check of evtchn_to_irq before getting this far (e.g.
bind_evtchn_to_irq and friends).

In any case, not much further down the series this switches to
initialising a recently allocated irq_info structure so we wouldn't
catch any errors this way.

Ian.

> >  }
> >  
> >  static void xen_irq_info_evtchn_init(unsigned irq,
> > @@ -143,29 +146,35 @@ static void xen_irq_info_evtchn_init(unsigned irq,
> >  {
> >  	struct irq_info *info = info_for_irq(irq);
> >  
> > -	xen_irq_info_common_init(info, IRQT_EVTCHN, evtchn, 0);
> > +	xen_irq_info_common_init(info, irq, IRQT_EVTCHN, evtchn, 0);
> >  }
> >  
> > -static void xen_irq_info_ipi_init(unsigned irq,
> > +static void xen_irq_info_ipi_init(unsigned cpu,
> > +				  unsigned irq,
> >  				  unsigned short evtchn,
> >  				  enum ipi_vector ipi)
> >  {
> >  	struct irq_info *info = info_for_irq(irq);
> >  
> > -	xen_irq_info_common_init(info, IRQT_IPI, evtchn, 0);
> > +	xen_irq_info_common_init(info, irq, IRQT_IPI, evtchn, 0);
> >  
> >  	info->u.ipi = ipi;
> > +
> > +	per_cpu(ipi_to_irq, cpu)[ipi] = irq;
> 
> Ditto. Should we do a check first to see if we are overwritting anything
> but the default value of -1?
> >  }
> >  
> > -static void xen_irq_info_virq_init(unsigned irq,
> > +static void xen_irq_info_virq_init(unsigned cpu,
> > +				   unsigned irq,
> >  				   unsigned short evtchn,
> >  				   unsigned short virq)
> >  {
> >  	struct irq_info *info = info_for_irq(irq);
> >  
> > -	xen_irq_info_common_init(info, IRQT_VIRQ, evtchn, 0);
> > +	xen_irq_info_common_init(info, irq, IRQT_VIRQ, evtchn, 0);
> >  
> >  	info->u.virq = virq;
> > +
> > +	per_cpu(virq_to_irq, cpu)[virq] = irq;
> >  }
> >  
> >  static void xen_irq_info_pirq_init(unsigned irq,
> > @@ -177,12 +186,14 @@ static void xen_irq_info_pirq_init(unsigned irq,
> >  {
> >  	struct irq_info *info = info_for_irq(irq);
> >  
> > -	xen_irq_info_common_init(info, IRQT_PIRQ, evtchn, 0);
> > +	xen_irq_info_common_init(info, irq, IRQT_PIRQ, evtchn, 0);
> >  
> >  	info->u.pirq.pirq = pirq;
> >  	info->u.pirq.gsi = gsi;
> >  	info->u.pirq.vector = vector;
> >  	info->u.pirq.flags = flags;
> > +
> > +	pirq_to_irq[pirq] = irq;
> >  }
> >  
> >  /*
> > @@ -644,7 +655,6 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
> >  
> >  	xen_irq_info_pirq_init(irq, 0, pirq, gsi, irq_op.vector,
> >  			       shareable ? PIRQ_SHAREABLE : 0);
> > -	pirq_to_irq[pirq] = irq;
> >  
> >  out:
> >  	spin_unlock(&irq_mapping_update_lock);
> > @@ -682,7 +692,6 @@ int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
> >  				      handle_level_irq, name);
> >  
> >  	xen_irq_info_pirq_init(irq, 0, pirq, 0, vector, 0);
> > -	pirq_to_irq[pirq] = irq;
> >  	ret = set_irq_msi(irq, msidesc);
> >  	if (ret < 0)
> >  		goto error_irq;
> > @@ -746,7 +755,6 @@ int bind_evtchn_to_irq(unsigned int evtchn)
> >  		set_irq_chip_and_handler_name(irq, &xen_dynamic_chip,
> >  					      handle_fasteoi_irq, "event");
> >  
> > -		evtchn_to_irq[evtchn] = irq;
> >  		xen_irq_info_evtchn_init(irq, evtchn);
> >  	}
> >  
> > @@ -779,9 +787,7 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
> >  			BUG();
> >  		evtchn = bind_ipi.port;
> >  
> > -		evtchn_to_irq[evtchn] = irq;
> > -		xen_irq_info_ipi_init(irq, evtchn, ipi);
> > -		per_cpu(ipi_to_irq, cpu)[ipi] = irq;
> > +		xen_irq_info_ipi_init(cpu, irq, evtchn, ipi);
> >  
> >  		bind_evtchn_to_cpu(evtchn, cpu);
> >  	}
> > @@ -814,10 +820,7 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
> >  			BUG();
> >  		evtchn = bind_virq.port;
> >  
> > -		evtchn_to_irq[evtchn] = irq;
> > -		xen_irq_info_virq_init(irq, evtchn, virq);
> > -
> > -		per_cpu(virq_to_irq, cpu)[virq] = irq;
> > +		xen_irq_info_virq_init(cpu, irq, evtchn, virq);
> >  
> >  		bind_evtchn_to_cpu(evtchn, cpu);
> >  	}
> > @@ -1120,7 +1123,6 @@ void rebind_evtchn_irq(int evtchn, int irq)
> >  	   so there should be a proper type */
> >  	BUG_ON(info->type == IRQT_UNBOUND);
> >  
> > -	evtchn_to_irq[evtchn] = irq;
> >  	xen_irq_info_evtchn_init(irq, evtchn);
> >  
> >  	spin_unlock(&irq_mapping_update_lock);
> > @@ -1288,8 +1290,7 @@ static void restore_cpu_virqs(unsigned int cpu)
> >  		evtchn = bind_virq.port;
> >  
> >  		/* Record the new mapping. */
> > -		evtchn_to_irq[evtchn] = irq;
> > -		xen_irq_info_virq_init(irq, evtchn, virq);
> > +		xen_irq_info_virq_init(cpu, irq, evtchn, virq);
> >  		bind_evtchn_to_cpu(evtchn, cpu);
> >  	}
> >  }
> > @@ -1313,8 +1314,7 @@ static void restore_cpu_ipis(unsigned int cpu)
> >  		evtchn = bind_ipi.port;
> >  
> >  		/* Record the new mapping. */
> > -		evtchn_to_irq[evtchn] = irq;
> > -		xen_irq_info_ipi_init(irq, evtchn, ipi);
> > +		xen_irq_info_ipi_init(cpu, irq, evtchn, ipi);
> >  		bind_evtchn_to_cpu(evtchn, cpu);
> >  	}
> >  }
> > -- 
> > 1.5.6.5


