Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745Ab0JZOS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:18:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55504 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab0JZOS2 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 26 Oct 2010 10:18:28 -0400
Date: Tue, 26 Oct 2010 10:17:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com, Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] Re: [PATCH 1/5] xen: events: use
 irq_alloc_desc(_at) instead of open-coding an IRQ allocator.
Message-ID: <20101026141739.GA9557@dumpdata.com>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
 <1288023813-31989-1-git-send-email-ian.campbell@citrix.com>
 <20101025173522.GA5590@dumpdata.com>
 <4CC60CB7.3070005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC60CB7.3070005@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 04:03:19PM -0700, Jeremy Fitzhardinge wrote:
>  On 10/25/2010 10:35 AM, Konrad Rzeszutek Wilk wrote:
> > On Mon, Oct 25, 2010 at 05:23:29PM +0100, Ian Campbell wrote:
> >> Encapsulate allocate and free in xen_irq_alloc and xen_irq_free.
> >>
> >> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> >> ---
> >>  drivers/xen/events.c |   68 ++++++++++++++++++++-----------------------------
> >>  1 files changed, 28 insertions(+), 40 deletions(-)
> >>
> >> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> >> index 97612f5..c8f3e43 100644
> >> --- a/drivers/xen/events.c
> >> +++ b/drivers/xen/events.c
> >> @@ -394,41 +394,29 @@ static int find_unbound_pirq(void)
> >>  	return -1;
> >>  }
> >>  
> >> -static int find_unbound_irq(void)
> >> +static int xen_irq_alloc(void)
> >>  {
> >> -	struct irq_data *data;
> >> -	int irq, res;
> >> -	int start = get_nr_hw_irqs();
> >> +	int irq = irq_alloc_desc(0);
> >>  
> >> -	if (start == nr_irqs)
> >> -		goto no_irqs;
> >> -
> >> -	/* nr_irqs is a magic value. Must not use it.*/
> >> -	for (irq = nr_irqs-1; irq > start; irq--) {
> >> -		data = irq_get_irq_data(irq);
> >> -		/* only 0->15 have init'd desc; handle irq > 16 */
> >> -		if (!data)
> >> -			break;
> >> -		if (data->chip == &no_irq_chip)
> >> -			break;
> >> -		if (data->chip != &xen_dynamic_chip)
> >> -			continue;
> >> -		if (irq_info[irq].type == IRQT_UNBOUND)
> >> -			return irq;
> >> -	}
> >> -
> >> -	if (irq == start)
> >> -		goto no_irqs;
> >> +	if (irq < 0)
> >> +		panic("No available IRQ to bind to: increase nr_irqs!\n");
> >>  
> >> -	res = irq_alloc_desc_at(irq, 0);
> >> +	return irq;
> >> +}
> > So I am curious what the /proc/interrupts looks?The issue (and the reason
> > for this implementation above) was that under PV with PCI devices we would
> > overlap PCI devices IRQs with Xen event channels. So we could have a USB device
> > at IRQ 16 _and_ also a xen_spinlock4 handler. That would throw off the system
> > since the xen_spinlock4 was an edge type handler while the USB device was an
> > level (at least on my box).
> 
> What?  Why?  How?  Surely if we're asking the irq subsystem to allocate

Imagine a PV guest with PCI passthrough. Normally the first 16 IRQs
are reserved for "legacy" devices. And the IRQs after that are up for grabs.

Since the Xen event channels are initialized much much earlier than
any PCI devices, they end up using the IRQs right after 16 -which is OK
if you don't have any PCI devices. If you have a PCI device that is
using IRQ 17 it ends up colliding with an event channel.

Now, I have to confess I did not look carefully at the sparse_irq rework
so it might be that the IRQ numbur is not as important as it was
before 2.6.37.

> us an irq, it will return a fresh never-before-used (and certainly not
> shared) irq?  Shared irqs only make sense if multiple devices are
> actually sharing, say, a wire on the board.

Right, and in this case we end up trying to use the IRQ for a physical
device and find out that the IRQ has/is being aleady used for an
event channel.

> 
> Or am I missing something?

Event channels are allocated before PCI devices so they get to usurp
the IRQ chip for the IRQ that belongs to the PCI device.

Keep in mind that this is not possible under Dom0, as we have the 
IOAPIC information, so we know that IRQ0-48 are reserved for GSI's
for three of the IOAPIC. In PV with PCI passthrough such information
is not present and the kernel assumes no IOAPICs, and hence no
GSI.

a). Maybe one way to do this is set the GSI high watermark to be the
same as the host (so move it from the legacy IRQ 16 to 48 for example).
This would require fiddling with the shared_info structure..

b) Another approach was to allocate event-channel IRQs and virtual IRQs
from the highest available IRQ and continue down . Physical IRQs would be
allocated from the legacy IRQ up to whatever is available.

c) 2.6.18 kernels made a division right at 255, so anything under 255 was to be
used for physical IRQs, while anything above that for event channels and
vitual IRQs.

