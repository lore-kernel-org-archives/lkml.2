Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0KTBTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 20:19:34 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:61853 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab0KTBTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 20:19:30 -0500
X-IronPort-AV: E=Sophos;i="4.59,226,1288569600"; 
   d="scan'208";a="2963171"
Date: Sat, 20 Nov 2010 01:19:31 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: use PHYSDEVOP_get_free_pirq to implement
 find_unbound_pirq
In-Reply-To: <20101119162353.GA26747@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1011200115240.2373@kaball-desktop>
References: <alpine.DEB.2.00.1011191350250.2373@kaball-desktop> <20101119162353.GA26747@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010, Konrad Rzeszutek Wilk wrote:
> On Fri, Nov 19, 2010 at 01:58:03PM +0000, Stefano Stabellini wrote:
> > Use PHYSDEVOP_get_free_pirq to implement find_unbound_pirq
> > 
> > Use the new hypercall PHYSDEVOP_get_free_pirq to ask Xen to allocate a
> > pirq. Remove the unsupported PHYSDEVOP_get_nr_pirqs hypercall to get the
> > amount of pirq available.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index 321a0c8..ffd286e 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -382,12 +382,17 @@ static int get_nr_hw_irqs(void)
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
> > +	for (i = 16; i <= nr_pirqs-1; i++) {
> 
> 16? No no. Why not re-use the old loop, like so:
> 
>  	for (i = nr_pirqs-1; i >= 0; i--) {
> 

Because we don't know the real nr_pirqs anymore (PHYSDEVOP_get_nr_pirqs
has been removed), so it is highly possible that starting from the top
down would give us pirq numbers out of range in Xen.  Therefore we need
to start from the bottom up, and the bottom for Xen is 16.


> >  		if (pirq_to_irq[i] < 0)
> >  			return i;
> >  	}
> > @@ -669,7 +674,7 @@ void xen_allocate_pirq_msi(char *name, int *irq, int *pirq)
> >  	if (*irq == -1)
> >  		goto out;
> >  
> > -	*pirq = find_unbound_pirq();
> > +	*pirq = find_unbound_pirq(MAP_PIRQ_TYPE_MSI);
> >  	if (*pirq == -1)
> >  		goto out;
> >  
> > @@ -1504,23 +1509,12 @@ void xen_callback_vector(void) {}
> >  void __init xen_init_IRQ(void)
> >  {
> >  	int i, rc;
> > -	struct physdev_nr_pirqs op_nr_pirqs;
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
> > +	nr_pirqs = nr_irqs;
> 
> Why not just get rid of nr_pirgs altogether then? And use 'nr_irqs' instead?
> 

Yeah, I guess we could do that. I kept it around just to make it more
obvious that the max pirq number is different from nr_irqs and we don't
know what the exact value is.
