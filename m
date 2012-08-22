Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab2HVON1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:13:27 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27325 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2HVONY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:13:24 -0400
Date: Wed, 22 Aug 2012 10:03:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen/events: fix unmask_evtchn for PV on HVM
 guests
Message-ID: <20120822140315.GC30964@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>
 <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <alpine.DEB.2.02.1206221722040.27860@kaball.uk.xensource.com>
 <20120709141915.GB9580@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207131821250.23783@kaball.uk.xensource.com>
 <20120716151441.GD552@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207181851010.23783@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1208221217290.15568@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1208221217290.15568@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 12:20:09PM +0100, Stefano Stabellini wrote:
> Konrad,
> I cannot see this patch anywhere in your trees. Did I miss it?
> Or maybe it just fell through the cracks?

Fell through the cracks.. Was there a new version of this? Can you
send me a subset of the patches you want me to pick up?

> Let me know if you want me to do anything more.
> Cheers,
> Stefano
> 
> On Wed, 18 Jul 2012, Stefano Stabellini wrote:
> > xen/events: fix unmask_evtchn for PV on HVM guests
> > 
> > When unmask_evtchn is called, if we already have an event pending, we
> > just set evtchn_pending_sel waiting for local_irq_enable to be called.
> > That is because PV guests set the irq_enable pvops to
> > xen_irq_enable_direct in xen_setup_vcpu_info_placement:
> > xen_irq_enable_direct is implemented in assembly in
> > arch/x86/xen/xen-asm.S and call xen_force_evtchn_callback if
> > XEN_vcpu_info_pending is set.
> > 
> > However HVM guests (and ARM guests) do not change or do not have the
> > irq_enable pvop, so evtchn_unmask cannot work properly for them.
> > 
> > Considering that having the pending_irq bit set when unmask_evtchn is
> > called is not very common, and it is simpler to keep the
> > native_irq_enable implementation for HVM guests (and ARM guests), the
> > best thing to do is just use the EVTCHNOP_unmask hypercall (Xen
> > re-injects pending events in response).
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  drivers/xen/events.c |   17 ++++++++++++++---
> >  1 files changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index 0a8a17c..d75cc39 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -373,11 +373,22 @@ static void unmask_evtchn(int port)
> >  {
> >  	struct shared_info *s = HYPERVISOR_shared_info;
> >  	unsigned int cpu = get_cpu();
> > +	int do_hypercall = 0, evtchn_pending = 0;
> >  
> >  	BUG_ON(!irqs_disabled());
> >  
> > -	/* Slow path (hypercall) if this is a non-local port. */
> > -	if (unlikely(cpu != cpu_from_evtchn(port))) {
> > +	if (unlikely((cpu != cpu_from_evtchn(port))))
> > +		do_hypercall = 1;
> > +	else
> > +		evtchn_pending = sync_test_bit(port, &s->evtchn_pending[0]);
> > +
> > +	if (unlikely(evtchn_pending && xen_hvm_domain()))
> > +		do_hypercall = 1;
> > +
> > +	/* Slow path (hypercall) if this is a non-local port or if this is
> > +	 * an hvm domain and an event is pending (hvm domains don't have
> > +	 * their own implementation of irq_enable). */
> > +	if (do_hypercall) {
> >  		struct evtchn_unmask unmask = { .port = port };
> >  		(void)HYPERVISOR_event_channel_op(EVTCHNOP_unmask, &unmask);
> >  	} else {
> > @@ -390,7 +401,7 @@ static void unmask_evtchn(int port)
> >  		 * 'hw_resend_irq'. Just like a real IO-APIC we 'lose
> >  		 * the interrupt edge' if the channel is masked.
> >  		 */
> > -		if (sync_test_bit(port, &s->evtchn_pending[0]) &&
> > +		if (evtchn_pending &&
> >  		    !sync_test_and_set_bit(port / BITS_PER_LONG,
> >  					   &vcpu_info->evtchn_pending_sel))
> >  			vcpu_info->evtchn_upcall_pending = 1;
> > -- 
> > 1.7.2.5
> > 
