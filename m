Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab2GIO1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:27:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38049 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab2GIO1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:27:39 -0400
Date: Mon, 9 Jul 2012 10:19:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen/events: fix unmask_evtchn for PV on HVM
 guests
Message-ID: <20120709141915.GB9580@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>
 <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <alpine.DEB.2.02.1206221722040.27860@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1206221722040.27860@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 05:26:07PM +0100, Stefano Stabellini wrote:
> When unmask_evtchn is called, if we already have an event pending, we
> just set evtchn_pending_sel waiting for local_irq_enable to be called.
> That is because PV guests set the irq_enable pvops to

Can you point out where the PV guests do that please? Even just
including a snippet of code would be nice so that somebody
in the future has an idea of where it was/is.

> xen_irq_enable_direct that also handles pending events.
> 
> However HVM guests (and ARM guests) do not change or do not have the
> irq_enable pvop, so evtchn_unmask cannot work properly for them.

Duh!
> 
> Considering that having the pending_irq bit set when unmask_evtchn is
> called is not very common, and it is simpler to keep the

Unless you pin the guests on the vCPUS on which domain0 is not present..

> native_irq_enable implementation for HVM guests (and ARM guests), the
> best thing to do is just use the EVTCHNOP_unmask hypercall (Xen
> re-injects pending events in response).

And by re-injects you mean than the IOAPIC or (whatever it is on ARM)
is armed to show that there is a pending interrupt, right?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/xen/events.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index eae0d0b..0132505 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -372,8 +372,11 @@ static void unmask_evtchn(int port)
>  
>  	BUG_ON(!irqs_disabled());
>  
> -	/* Slow path (hypercall) if this is a non-local port. */
> -	if (unlikely(cpu != cpu_from_evtchn(port))) {
> +	/* Slow path (hypercall) if this is a non-local port or if this is
> +	 * an hvm domain and an event is pending (hvm domains don't have
> +	 * their own implementation of irq_enable). */
> +	if (unlikely((cpu != cpu_from_evtchn(port)) ||
> +			(xen_hvm_domain() && sync_test_bit(port, &s->evtchn_pending[0])))) {
>  		struct evtchn_unmask unmask = { .port = port };

We already have two seperate acks - for when there is an GMFN APIC bitmap and
when there is not. Can we also have to seperate unmask_evtchn then? And
just have the HVM and ARM just do a straightforward unmaks_evtchn while
the PV remains the same?

>  		(void)HYPERVISOR_event_channel_op(EVTCHNOP_unmask, &unmask);
>  	} else {
> 
