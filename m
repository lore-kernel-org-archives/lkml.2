Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab2EXRgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:36:01 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21885 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533Ab2EXRf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:35:59 -0400
Date: Thu, 24 May 2012 13:29:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 4/4] xen/events: Add WARN_ON when quick
 lookup found invalid type.
Message-ID: <20120524172921.GD24934@phenom.dumpdata.com>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com>
 <1337795222-29946-5-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1205241154150.26786@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205241154150.26786@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:58:11AM +0100, Stefano Stabellini wrote:
> On Wed, 23 May 2012, Konrad Rzeszutek Wilk wrote:
> > All of the bind_XYZ_to_irq do a quick lookup to see if the
> > event exists. And if they that value is returned instead of
> 
>                            ^

Lack of filters for coffee caused that :-)

> 
> > initialized. This patch adds an extra logic to check that the
> > type returned is the proper one and we can use it to find
> > drivers that are doing something naught.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/xen/events.c |   11 +++++++++--
> >  1 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index faae2f9..093851b 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -827,6 +827,9 @@ int bind_evtchn_to_irq(unsigned int evtchn)
> >  					      handle_edge_irq, "event");
> >  
> >  		xen_irq_info_evtchn_init(irq, evtchn);
> > +	} else {
> > +		struct irq_info *info = info_for_irq(irq);
> > +		WARN_ON(info && info->type != IRQT_EVTCHN);
> >  	}
> 
> considering that when evtchn_to_irq[evtchn] is != -1, a corresponding
> struct irq_info is always supposed to exists, shouldn't this be:
> 
> WARN_ON(info == NULL || info->type != IRQT_EVTCHN);

<nods> Much better. Will do that.

> 
> ?
> 
> 
> >  out:
> > @@ -862,8 +865,10 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
> >  		xen_irq_info_ipi_init(cpu, irq, evtchn, ipi);
> >  
> >  		bind_evtchn_to_cpu(evtchn, cpu);
> > +	} else {
> > +		struct irq_info *info = info_for_irq(irq);
> > +		WARN_ON(info && info->type != IRQT_IPI);
> >  	}
> > -
> >   out:
> >  	mutex_unlock(&irq_mapping_update_lock);
> >  	return irq;
> > @@ -939,8 +944,10 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
> >  		xen_irq_info_virq_init(cpu, irq, evtchn, virq);
> >  
> >  		bind_evtchn_to_cpu(evtchn, cpu);
> > +	} else {
> > +		struct irq_info *info = info_for_irq(irq);
> > +		WARN_ON(info && info->type != IRQT_VIRQ);
> >  	}
> > -
> >  out:
> >  	mutex_unlock(&irq_mapping_update_lock);
> 
> same here
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
