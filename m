Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0KYLAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:00:01 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:27723 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab0KYLAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:00:00 -0500
X-IronPort-AV: E=Sophos;i="4.59,253,1288569600"; 
   d="scan'208";a="3040602"
Date: Thu, 25 Nov 2010 10:59:42 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [Xen-devel] [PATCH v2] Use PHYSDEVOP_get_free_pirq to implement
 find_unbound_pirq
In-Reply-To: <4CED6E08.4030407@goop.org>
Message-ID: <alpine.DEB.2.00.1011251057430.2373@kaball-desktop>
References: <alpine.DEB.2.00.1011241918290.2373@kaball-desktop> <4CED6E08.4030407@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Jeremy Fitzhardinge wrote:
> On 11/24/2010 11:22 AM, Stefano Stabellini wrote:
> > Use PHYSDEVOP_get_free_pirq to implement find_unbound_pirq
> >
> > Use the new hypercall PHYSDEVOP_get_free_pirq to ask Xen to allocate a
> > pirq. Remove the unsupported PHYSDEVOP_get_nr_pirqs hypercall to get the
> > amount of pirq available.
> >
> > Changes since v1:
> >
> > - if PHYSDEVOP_get_free_pirq is not implemented, start pirq allocation
> > from 0 instead of 16. The pirq number 16 is not actually meaningful for
> > Xen.
> >
> > - Remove nr_pirqs, it is not needed anymore. Add a comment to specify
> > that we don't actually know the upper limit of the pirq number range.
> >
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> >
> >
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index 2811bb9..072af50 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -105,7 +105,6 @@ struct irq_info
> >  
> >  static struct irq_info *irq_info;
> >  static int *pirq_to_irq;
> > -static int nr_pirqs;
> >  
> >  static int *evtchn_to_irq;
> >  struct cpu_evtchn_s {
> > @@ -385,12 +384,17 @@ static int get_nr_hw_irqs(void)
> >  	return ret;
> >  }
> >  
> > -/* callers of this function should make sure that PHYSDEVOP_get_nr_pirqs
> > - * succeeded otherwise nr_pirqs won't hold the right value */
> > -static int find_unbound_pirq(void)
> > +static int find_unbound_pirq(int type)
> >  {
> > -	int i;
> > -	for (i = nr_pirqs-1; i >= 0; i--) {
> > +	int rc, i;
> > +	struct physdev_get_free_pirq op_get_free_pirq;
> > +	op_get_free_pirq.type = type;
> > +
> > +	rc = HYPERVISOR_physdev_op(PHYSDEVOP_get_free_pirq, &op_get_free_pirq);
> > +	if (!rc)
> > +		return op_get_free_pirq.pirq;
> > +
> > +	for (i = 0; i <= nr_irqs-1; i++) {
> 
> That seems needlessly complex.  What's wrong with "i < nr_irqs"?  Are
> you trying to express something specific with this?

Yeah, good point.


> >  		if (pirq_to_irq[i] < 0)
> >  			return i;
> >  	}
> > @@ -611,9 +615,9 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
> >  
> >  	spin_lock(&irq_mapping_update_lock);
> >  
> > -	if ((pirq > nr_pirqs) || (gsi > nr_irqs)) {
> > +	if ((pirq > nr_irqs) || (gsi > nr_irqs)) {
> >  		printk(KERN_WARNING "xen_map_pirq_gsi: %s %s is incorrect!\n",
> > -			pirq > nr_pirqs ? "nr_pirqs" :"",
> > +			pirq > nr_irqs ? "nr_pirqs" :"",
> >  			gsi > nr_irqs ? "nr_irqs" : "");
> >  		goto out;
> >  	}
> > @@ -672,7 +676,7 @@ void xen_allocate_pirq_msi(char *name, int *irq, int *pirq)
> >  	if (*irq == -1)
> >  		goto out;
> >  
> > -	*pirq = find_unbound_pirq();
> > +	*pirq = find_unbound_pirq(MAP_PIRQ_TYPE_MSI);
> >  	if (*pirq == -1)
> >  		goto out;
> >  
> > @@ -1506,26 +1510,17 @@ void xen_callback_vector(void) {}
> >  
> >  void __init xen_init_IRQ(void)
> >  {
> > -	int i, rc;
> > -	struct physdev_nr_pirqs op_nr_pirqs;
> > +	int i;
> >  
> >  	cpu_evtchn_mask_p = kcalloc(nr_cpu_ids, sizeof(struct cpu_evtchn_s),
> >  				    GFP_KERNEL);
> >  	irq_info = kcalloc(nr_irqs, sizeof(*irq_info), GFP_KERNEL);
> >  
> > -	rc = HYPERVISOR_physdev_op(PHYSDEVOP_get_nr_pirqs, &op_nr_pirqs);
> > -	if (rc < 0) {
> > -		nr_pirqs = nr_irqs;
> > -		if (rc != -ENOSYS)
> > -			printk(KERN_WARNING "PHYSDEVOP_get_nr_pirqs returned rc=%d\n", rc);
> > -	} else {
> > -		if (xen_pv_domain() && !xen_initial_domain())
> > -			nr_pirqs = max((int)op_nr_pirqs.nr_pirqs, nr_irqs);
> > -		else
> > -			nr_pirqs = op_nr_pirqs.nr_pirqs;
> > -	}
> > -	pirq_to_irq = kcalloc(nr_pirqs, sizeof(*pirq_to_irq), GFP_KERNEL);
> > -	for (i = 0; i < nr_pirqs; i++)
> > +	/* We are using nr_irqs as the maximum number of pirq available but
> > +	 * that number is actually chosen by Xen and we don't know exactly
> > +	 * what it is. Be careful choosing high pirq numbers. */
> > +	pirq_to_irq = kcalloc(nr_irqs, sizeof(*pirq_to_irq), GFP_KERNEL);
> > +	for (i = 0; i < nr_irqs; i++)
> >  		pirq_to_irq[i] = -1;
> >  
> >  	evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
> > diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> > index 2b2c66c..534cac8 100644
> > --- a/include/xen/interface/physdev.h
> > +++ b/include/xen/interface/physdev.h
> > @@ -188,6 +188,16 @@ struct physdev_nr_pirqs {
> >      uint32_t nr_pirqs;
> >  };
> >  
> > +/* type is MAP_PIRQ_TYPE_GSI or MAP_PIRQ_TYPE_MSI
> > + * the hypercall returns a free pirq */
> > +#define PHYSDEVOP_get_free_pirq    23
> > +struct physdev_get_free_pirq {
> 
> I guess it doesn't really matter, and it's probably a bit late, but this
> seems like an odd name.  Normally I'd think of this as an allocation, so
> something like PHYSDEVOP_alloc_pirq.
 
Unfortunately it is too late for that, unless we want to name this
hypercall differently between Xen and Linux and I don't think it is
a good idea.
