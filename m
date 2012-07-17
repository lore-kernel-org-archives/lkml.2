Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2GQRJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:09:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab2GQRJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:09:08 -0400
Date: Tue, 17 Jul 2012 20:09:03 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v5 3/4] kvm: Create kvm_clear_irq()
Message-ID: <20120717170903.GE6479@redhat.com>
References: <1342533369.3229.4.camel@ul30vt>
 <20120717140858.GB10822@redhat.com>
 <1342534911.3229.26.camel@ul30vt>
 <20120717145313.GB11516@redhat.com>
 <1342538411.2229.106.camel@bling.home>
 <20120717153620.GB11849@redhat.com>
 <1342540301.2229.117.camel@bling.home>
 <20120717155701.GB12001@redhat.com>
 <1342541301.2229.125.camel@bling.home>
 <20120717163649.GA12304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717163649.GA12304@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 07:36:49PM +0300, Michael S. Tsirkin wrote:
> On Tue, Jul 17, 2012 at 10:08:21AM -0600, Alex Williamson wrote:
> > On Tue, 2012-07-17 at 18:57 +0300, Michael S. Tsirkin wrote:
> > > On Tue, Jul 17, 2012 at 09:51:41AM -0600, Alex Williamson wrote:
> > > > On Tue, 2012-07-17 at 18:36 +0300, Michael S. Tsirkin wrote:
> > > > > On Tue, Jul 17, 2012 at 09:20:11AM -0600, Alex Williamson wrote:
> > > > > > On Tue, 2012-07-17 at 17:53 +0300, Michael S. Tsirkin wrote:
> > > > > > > On Tue, Jul 17, 2012 at 08:21:51AM -0600, Alex Williamson wrote:
> > > > > > > > On Tue, 2012-07-17 at 17:08 +0300, Michael S. Tsirkin wrote:
> > > > > > > > > On Tue, Jul 17, 2012 at 07:56:09AM -0600, Alex Williamson wrote:
> > > > > > > > > > On Tue, 2012-07-17 at 13:14 +0300, Michael S. Tsirkin wrote:
> > > > > > > > > > > On Mon, Jul 16, 2012 at 02:34:03PM -0600, Alex Williamson wrote:
> > > > > > > > > > > > This is an alternative to kvm_set_irq(,,,0) which returns the previous
> > > > > > > > > > > > assertion state of the interrupt and does nothing if it isn't changed.
> > > > > > > > > > > > 
> > > > > > > > > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > > > > > > ---
> > > > > > > > > > > > 
> > > > > > > > > > > >  include/linux/kvm_host.h |    3 ++
> > > > > > > > > > > >  virt/kvm/irq_comm.c      |   78 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > > > > > > > > >  2 files changed, 81 insertions(+)
> > > > > > > > > > > > 
> > > > > > > > > > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > > > > > > > > > index a7661c0..6c168f1 100644
> > > > > > > > > > > > --- a/include/linux/kvm_host.h
> > > > > > > > > > > > +++ b/include/linux/kvm_host.h
> > > > > > > > > > > > @@ -219,6 +219,8 @@ struct kvm_kernel_irq_routing_entry {
> > > > > > > > > > > >  	u32 type;
> > > > > > > > > > > >  	int (*set)(struct kvm_kernel_irq_routing_entry *e,
> > > > > > > > > > > >  		   struct kvm *kvm, int irq_source_id, int level);
> > > > > > > > > > > > +	int (*clear)(struct kvm_kernel_irq_routing_entry *e,
> > > > > > > > > > > > +		     struct kvm *kvm, int irq_source_id);
> > > > > > > > > > > >  	union {
> > > > > > > > > > > >  		struct {
> > > > > > > > > > > >  			unsigned irqchip;
> > > > > > > > > > > > @@ -629,6 +631,7 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
> > > > > > > > > > > >  				   unsigned long *deliver_bitmask);
> > > > > > > > > > > >  #endif
> > > > > > > > > > > >  int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level);
> > > > > > > > > > > > +int kvm_clear_irq(struct kvm *kvm, int irq_source_id, u32 irq);
> > > > > > > > > > > >  int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
> > > > > > > > > > > >  		int irq_source_id, int level);
> > > > > > > > > > > >  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
> > > > > > > > > > > > diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> > > > > > > > > > > > index 5afb431..76e8f22 100644
> > > > > > > > > > > > --- a/virt/kvm/irq_comm.c
> > > > > > > > > > > > +++ b/virt/kvm/irq_comm.c
> > > > > > > > > > > > @@ -68,6 +68,42 @@ static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
> > > > > > > > > > > >  	return kvm_ioapic_set_irq(ioapic, e->irqchip.pin, level);
> > > > > > > > > > > >  }
> > > > > > > > > > > >  
> > > > > > > > > > > > +static inline int kvm_clear_irq_line_state(unsigned long *irq_state,
> > > > > > > > > > > > +					    int irq_source_id)
> > > > > > > > > > > > +{
> > > > > > > > > > > > +	return !!test_and_clear_bit(irq_source_id, irq_state);
> > > > > > > > > > > > +}
> > > > > > > > > > > > +
> > > > > > > > > > > > +static int kvm_clear_pic_irq(struct kvm_kernel_irq_routing_entry *e,
> > > > > > > > > > > > +			     struct kvm *kvm, int irq_source_id)
> > > > > > > > > > > > +{
> > > > > > > > > > > > +#ifdef CONFIG_X86
> > > > > > > > > > > > +	struct kvm_pic *pic = pic_irqchip(kvm);
> > > > > > > > > > > > +	int level = kvm_clear_irq_line_state(&pic->irq_states[e->irqchip.pin],
> > > > > > > > > > > > +					     irq_source_id);
> > > > > > > > > > > > +	if (level)
> > > > > > > > > > > > +		kvm_pic_set_irq(pic, e->irqchip.pin,
> > > > > > > > > > > > +				!!pic->irq_states[e->irqchip.pin]);
> > > > > > > > > > > > +	return level;
> > > > > > > > > > > 
> > > > > > > > > > > I think I begin to understand: if (level) checks it was previously set,
> > > > > > > > > > > and then we clear if needed?
> > > > > > > > > > 
> > > > > > > > > > It's actually very simple, if we change anything in irq_states, then
> > > > > > > > > > update via the chip specific set_irq function.
> > > > > > > > > > 
> > > > > > > > > > >  I think it's worthwhile to rename
> > > > > > > > > > > level to orig_level and rewrite as:
> > > > > > > > > > > 
> > > > > > > > > > > 	if (orig_level && !pic->irq_states[e->irqchip.pin])
> > > > > > > > > > > 		kvm_pic_set_irq(pic, e->irqchip.pin, 0);
> > > > > > > > > > > 
> > > > > > > > > > > This both makes the logic clear without need for comments and
> > > > > > > > > > > saves some cycles on pic in case nothing actually changed.
> > > > > > > > > > 
> > > > > > > > > > That may work, but it's not actually the same thing.  kvm_set_irq(,,,0)
> > > > > > > > > > will clear the bit and call kvm_pic_set_irq with the new irq_states
> > > > > > > > > > value, whether it's 0 or 1.  The optimization I make is to only call
> > > > > > > > > > kvm_pic_set_irq if we've "changed" irq_states.  You're taking that one
> > > > > > > > > > step further to "changed and is now 0".  I don't know if that's correct
> > > > > > > > > > behavior.
> > > > > > > > > 
> > > > > > > > > If not then I don't understand. You clear a bit
> > > > > > > > > in a word. You never change it to 1, do you?
> > > > > > > > 
> > > > > > > > Correct, but kvm_set_irq(,,,0) may call kvm_pic_set_irq(,,1) if other
> > > > > > > > source IDs are still asserting the interrupt.  Your proposal assumes
> > > > > > > > that unless irq_states is also 0 we don't need to call kvm_pic_set_irq,
> > > > > > > > and I don't know if that's correct.
> > > > > > > 
> > > > > > > Well you are asked to clear some id and level was 1. So we know
> > > > > > > interrupt was asserted. Either we clear it or we don't. No?
> > > > > > > 
> > > > > > > > > 
> > > > > > > > > But this brings another question:
> > > > > > > > > 
> > > > > > > > > static inline int kvm_irq_line_state(unsigned long *irq_state,
> > > > > > > > >                                      int irq_source_id, int level)
> > > > > > > > > {
> > > > > > > > >         /* Logical OR for level trig interrupt */
> > > > > > > > >         if (level)
> > > > > > > > >                 set_bit(irq_source_id, irq_state);
> > > > > > > > >         else
> > > > > > > > >                 clear_bit(irq_source_id, irq_state);
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > ^^^^^^^^^^^
> > > > > > > > > above uses locked instructions
> > > > > > > > > 
> > > > > > > > >         return !!(*irq_state);
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > above doesn't
> > > > > > > > > 
> > > > > > > > > }
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > why the insonsistency?
> > > > > > > > 
> > > > > > > > Note that set/clear_bit are not locked instructions,
> > > > > > > 
> > > > > > > On x86 they are:
> > > > > > > static __always_inline void
> > > > > > > set_bit(unsigned int nr, volatile unsigned long *addr)
> > > > > > > {
> > > > > > >         if (IS_IMMEDIATE(nr)) {
> > > > > > >                 asm volatile(LOCK_PREFIX "orb %1,%0"
> > > > > > >                         : CONST_MASK_ADDR(nr, addr)
> > > > > > >                         : "iq" ((u8)CONST_MASK(nr))
> > > > > > >                         : "memory");
> > > > > > >         } else {
> > > > > > >                 asm volatile(LOCK_PREFIX "bts %1,%0"
> > > > > > >                         : BITOP_ADDR(addr) : "Ir" (nr) : "memory");
> > > > > > >         }
> > > > > > > }
> > > > > > > 
> > > > > > > > but atomic
> > > > > > > > instructions and it could be argued that reading the value is also
> > > > > > > > atomic.  At least that was my guess when I stumbled across the same
> > > > > > > > yesterday.  IMHO, we're going off into the weeds again with these last
> > > > > > > > two patches.  It may be a valid optimization, but it really has no
> > > > > > > > bearing on the meat of the series (and afaict, no significant
> > > > > > > > performance difference either).
> > > > > > > 
> > > > > > > For me it's not a performance thing. IMO code is cleaner without this locking:
> > > > > > > we add a lock but only use it in some cases, so the rules become really
> > > > > > > complex.
> > > > > > 
> > > > > > Seriously?
> > > > > > 
> > > > > >         spin_lock(&irqfd->source->lock);
> > > > > >         if (!irqfd->source->level_asserted) {
> > > > > >                 kvm_set_irq(irqfd->kvm, irqfd->source->id, irqfd->gsi, 1);
> > > > > >                 irqfd->source->level_asserted = true;
> > > > > >         }
> > > > > >         spin_unlock(&irqfd->source->lock);
> > > > > > 
> > > > > > ...
> > > > > > 
> > > > > >         spin_lock(&eoifd->source->lock);
> > > > > >         if (eoifd->source->level_asserted) {
> > > > > >                 kvm_set_irq(eoifd->kvm,
> > > > > >                             eoifd->source->id, eoifd->notifier.gsi, 0);
> > > > > >                 eoifd->source->level_asserted = false;
> > > > > >                 eventfd_signal(eoifd->eventfd, 1);
> > > > > >         }
> > > > > >         spin_unlock(&eoifd->source->lock);
> > > > > > 
> > > > > > 
> > > > > > Locking doesn't get much more straightforward than that
> > > > > 
> > > > > Don't look at it in isolation. You are now calling kvm_set_irq
> > > > > from under a spinlock. You are saying it is always safe but
> > > > > this seems far from obvious. kvm_set_irq used to be
> > > > > unsafe from an atomic context.
> > > > 
> > > > Device assignment has been calling kvm_set_irq from atomic context for
> > > > quite a long time.
> > > 
> > > Only for MSI. That's an exception (and it's also a messy one).
> > 
> > Nope, I see past code that used it for INTx as well.
> 
> While this looks like it will not crash, this scans all vcpus under a
> spinlock. A problem for big VMs.
> Again, yes we have such uses now but we are looking for ways
> to fix them and not be adding more.
> 
> 
Same as with MSI.

--
			Gleb.
