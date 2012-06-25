Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2FYT3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:29:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab2FYT3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:29:53 -0400
Message-ID: <1340652590.1207.59.camel@bling.home>
Subject: Re: [PATCH 3/4] kvm: Extend irqfd to support level interrupts
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        mst@redhat.com
Date: Mon, 25 Jun 2012 13:29:50 -0600
In-Reply-To: <1340551118.14120.66.camel@bling.home>
References: <20120622220040.9858.43665.stgit@bling.home>
	 <20120622221559.9858.59593.stgit@bling.home> <4FE6EC20.5030502@redhat.com>
	 <1340551118.14120.66.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-06-24 at 09:18 -0600, Alex Williamson wrote:
> On Sun, 2012-06-24 at 13:29 +0300, Avi Kivity wrote:
> > On 06/23/2012 01:16 AM, Alex Williamson wrote:
> > > KVM_IRQFD currently only supports edge triggered interrupts,
> > > asserting then immediately deasserting an interrupt.  There are a
> > > couple ways we can emulate level triggered interrupts using
> > > discrete events depending on the usage model we expect from drivers.
> > > This patch implements a level emulation model useful for external
> > > assigned device drivers, like VFIO.  The irqfd is used to assert
> > > the interrupt.  When the guest issues an EOI for the interrupt, the
> > > level is automatically deasserted and the irqfd user is notified via
> > > an eventfd.  This is therefore the LEVEL_EOI extension to KVM_IRQFD.
> > > To do this, we need to allocate a new irq source ID for the interrupt
> > > so we don't get interference from userspace.
> > > 
> > >  
> > > +With KVM_CAP_IRQFD_LEVEL_EOI KVM_IRQFD is able to support a level
> > > +triggered interrupt model where the irqchip pin (kvm_irqfd.gsi) is
> > > +asserted from the kvm_irqfd.fd eventfd and remain asserted until the
> > > +guest issues an EOI for the irqchip pin.  The level interrupt is
> > > +then de-asserted and the caller is notified via the eventfd specified
> > > +by kvm_irqfd.fd2.  Note that users of this interface are responsible
> > > +for re-asserting the interrupt if their device still requires service
> > > +after receiving the EOI notification.  Additionally, users must not
> > > +re-assert an interrupt until after receiving an EOI.  
> > 
> > What happens if this is violated?
> 
> Hmm, perhaps nothing.  The only race I see is re-asserting in the gap
> between de-asserting the guest and sending the EOI.  At worst that would
> cause a spurious interrupt, so probably no big deal.
> 
> > > When available,
> > > +this feature is enabled using the KVM_IRQFD_FLAG_LEVEL_EOI flag.
> > > +De-assigning an irqfd setup using this flag should include both
> > > +KVM_IRQFD_FLAG_DEASSIGN and KVM_IRQFD_FLAG_LEVEL_EOI and will be
> > > +matched using kvm_irqfd.fd, kvm_irqfd.gsi, and kvm_irqfd.fd2.
> > > +De-assigning automatically de-asserts the interrupt line setup through
> > > +this interface.
> > >  
> > > @@ -203,8 +232,8 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
> > >  	struct kvm_irq_routing_table *irq_rt;
> > >  	struct _irqfd *irqfd, *tmp;
> > >  	struct file *file = NULL;
> > > -	struct eventfd_ctx *eventfd = NULL;
> > > -	int ret;
> > > +	struct eventfd_ctx *eventfd = NULL, *eoi_eventfd = NULL;
> > > +	int ret, irq_source_id = -1;
> > >  	unsigned int events;
> > >  
> > >  	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
> > > @@ -214,7 +243,30 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
> > >  	irqfd->kvm = kvm;
> > >  	irqfd->gsi = args->gsi;
> > >  	INIT_LIST_HEAD(&irqfd->list);
> > > -	INIT_WORK(&irqfd->inject, irqfd_inject);
> > > +
> > > +	if (args->flags & KVM_IRQFD_FLAG_LEVEL_EOI) {
> > > +		irq_source_id = kvm_request_irq_source_id(kvm);
> > > +		if (irq_source_id < 0) {
> > > +			ret = irq_source_id;
> > > +			goto fail;
> > 
> > 'file' is NULL at this point, and fput() doesn't test for NULL.
> 
> Good catch.  I was looking for an excuse to move the existing code to
> eventfd_ctx_fdget() and avoid the 2 step process it uses now.

Well, we need file later, so a !NULL test will fix it.

...
> 
> > Xen had/has a hack for doing this in a different way, based on ioapic
> > polarity.  When the host takes an interrupt, they reverse the polarity
> > on that ioapic pin, so they get interrupts on both assertion and
> > deassertion.  This is more general and more correct, but waaaaaaaaaaay
> > more intrusive and won't play well with shared host interrupts.  But
> > let's at least consider it.
> 
> Thanks, I'll look for that code.

I can't find the code for it, pointers welcome.  I have a hard time
thinking this is practical for legacy interrupts though.  It sounds more
like an x86 party trick that minimally breaks shared host interrupts,
but more likely is intrusive (hey, why's that PCI driver asking for an
active high interrupt, obviously wrong, BUG) and probably breaks on most
non-x86 platforms.  I just can't imagine the cost/benefit works out for
it with legacy interrupts.  Thanks,

Alex

