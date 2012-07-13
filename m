Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030525Ab2GMRtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 13:49:18 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:44043 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2GMRtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 13:49:17 -0400
X-IronPort-AV: E=Sophos;i="4.77,579,1336348800"; 
   d="scan'208";a="13526587"
Date: Fri, 13 Jul 2012 18:48:35 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen/events: fix unmask_evtchn for PV on HVM
 guests
In-Reply-To: <20120709141915.GB9580@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1207131821250.23783@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com> <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1206221722040.27860@kaball.uk.xensource.com> <20120709141915.GB9580@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, Konrad Rzeszutek Wilk wrote:
> On Fri, Jun 22, 2012 at 05:26:07PM +0100, Stefano Stabellini wrote:
> > When unmask_evtchn is called, if we already have an event pending, we
> > just set evtchn_pending_sel waiting for local_irq_enable to be called.
> > That is because PV guests set the irq_enable pvops to
> 
> Can you point out where the PV guests do that please? Even just
> including a snippet of code would be nice so that somebody
> in the future has an idea of where it was/is.

Do you mean where PV guests set the irq_enable pvop?

That would be in xen_setup_vcpu_info_placement.
irq_enable is set to xen_irq_enable_direct that is implemented in
assembly in arch/x86/xen/xen-asm.S: it tests for XEN_vcpu_info_pending
and call xen_force_evtchn_callback.


> > xen_irq_enable_direct that also handles pending events.
> > 
> > However HVM guests (and ARM guests) do not change or do not have the
> > irq_enable pvop, so evtchn_unmask cannot work properly for them.
> 
> Duh!
> > 
> > Considering that having the pending_irq bit set when unmask_evtchn is
> > called is not very common, and it is simpler to keep the
> 
> Unless you pin the guests on the vCPUS on which domain0 is not present..

Considering that __xen_evtchn_do_upcall keeps looping around until no
more events are set in the shared_info page and also that
xen_dynamic_chip and xen_pirq_chip only mask irqs on irq_mask, the only
way that pending_irq can be set before unmask_evtchn is called is when
the guest receives multiple notifications for the same event before
acking the first one.
Arguably it is not a extremely common case at least in domUs.


> > native_irq_enable implementation for HVM guests (and ARM guests), the
> > best thing to do is just use the EVTCHNOP_unmask hypercall (Xen
> > re-injects pending events in response).
> 
> And by re-injects you mean than the IOAPIC or (whatever it is on ARM)
> is armed to show that there is a pending interrupt, right?

Right. A new notification is going to be sent by Xen to the guest, via
the best mechanism available. On X86 it could be a vector callback.


> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  drivers/xen/events.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index eae0d0b..0132505 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -372,8 +372,11 @@ static void unmask_evtchn(int port)
> >  
> >  	BUG_ON(!irqs_disabled());
> >  
> > -	/* Slow path (hypercall) if this is a non-local port. */
> > -	if (unlikely(cpu != cpu_from_evtchn(port))) {
> > +	/* Slow path (hypercall) if this is a non-local port or if this is
> > +	 * an hvm domain and an event is pending (hvm domains don't have
> > +	 * their own implementation of irq_enable). */
> > +	if (unlikely((cpu != cpu_from_evtchn(port)) ||
> > +			(xen_hvm_domain() && sync_test_bit(port, &s->evtchn_pending[0])))) {
> >  		struct evtchn_unmask unmask = { .port = port };
> 
> We already have two seperate acks - for when there is an GMFN APIC bitmap and
> when there is not. Can we also have to seperate unmask_evtchn then? And
> just have the HVM and ARM just do a straightforward unmaks_evtchn while
> the PV remains the same?

Do you mean HVM and ARM do a straightforward EVTCHNOP_unmask hypercall?

In that case we would lose performances because most of the time an
hypercall won't be necessary.
If we keep the code as it is, it makes sense to have the PV and PVHVM
cases in the same function.


> >  		(void)HYPERVISOR_event_channel_op(EVTCHNOP_unmask, &unmask);
> >  	} else {
> > 
> 
