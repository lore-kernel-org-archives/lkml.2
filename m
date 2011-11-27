Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab1K0PYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 10:24:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32807 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab1K0PYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 10:24:24 -0500
Date: Sun, 27 Nov 2011 15:24:29 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] irq: fix possible null-pointer deref irq_domain_to_irq
Message-ID: <20111127152411.GE28582@gallagher>
References: <1320922383-15312-1-git-send-email-jamie@jamieiles.com>
 <20111110111446.GB16018@totoro>
 <4EBBD39C.9000400@gmail.com>
 <20111123122308.GA7382@totoro>
 <20111125153553.GB8866@totoro>
 <4ED25305.8080605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED25305.8080605@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Sun, Nov 27, 2011 at 09:11:01AM -0600, Rob Herring wrote:
> On 11/25/2011 09:35 AM, Jamie Iles wrote:
> > I wonder if this might make more sense instead.  I'll post a proper 
> > patch if you think so.
> > 
> > Regards,
> > 
> > Jamie
> > 
> > diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> > index 200ce83..92c3484 100644
> > --- a/kernel/irq/irqdomain.c
> > +++ b/kernel/irq/irqdomain.c
> > @@ -143,11 +143,6 @@ int irq_domain_simple_dt_translate(struct irq_domain *d,
> >  	return 0;
> >  }
> >  
> > -struct irq_domain_ops irq_domain_simple_ops = {
> > -	.dt_translate = irq_domain_simple_dt_translate,
> > -};
> > -EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
> > -
> >  /**
> >   * irq_domain_create_simple() - Set up a 'simple' translation range
> >   */
> > @@ -181,4 +176,11 @@ void irq_domain_generate_simple(const struct of_device_id *match,
> >  		pr_info("no node found\n");
> >  }
> >  EXPORT_SYMBOL_GPL(irq_domain_generate_simple);
> > +#else /* CONFIG_OF_IRQ */
> > +#define irq_domain_simple_dt_translate NULL
> >  #endif /* CONFIG_OF_IRQ */
> > +
> > +struct irq_domain_ops irq_domain_simple_ops = {
> > +	.dt_translate = irq_domain_simple_dt_translate,
> 
> .dt_translate is surrounded by CONFIG_OF, so it will break on !CONFIG_OF.

Ahh, good spot!

> > +};
> > +EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
> 
> The extern declaration in irqdomain.h is surrounded by CONFIG_OF_IRQ, so
> it needs to be moved out of that as well.
> 
> On Sparc, CONFIG_OF is true, but CONFIG_OF_IRQ is false. So that
> combination needs to be handled as well.

OK, I'm travelling for a couple of days now, but I'll respin something 
when I'm back.  I guess it's a case of always exporting the simple ops 
when CONFIG_IRQDOMAIN=y, and only setting the .dt_translate when 
CONFIG_OF_IRQ=y though.

Jamie
