Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2HOTXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:23:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab2HOTX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:23:28 -0400
Date: Wed, 15 Aug 2012 22:24:33 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/6] kvm: Allow filtering of acked irqs
Message-ID: <20120815192432.GC5670@redhat.com>
References: <20120810223633.809.44188.stgit@bling.home>
 <20120810223714.809.25474.stgit@bling.home>
 <20120815122708.GA3068@redhat.com>
 <1345049258.4683.394.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345049258.4683.394.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 10:47:38AM -0600, Alex Williamson wrote:
> On Wed, 2012-08-15 at 15:27 +0300, Michael S. Tsirkin wrote:
> > On Fri, Aug 10, 2012 at 04:37:17PM -0600, Alex Williamson wrote:
> > > Registering an kvm_irq_ack_notifier with kian.irq_source_id < 0
> > > retains existing behavior, filling in the actual irq_source_id results
> > > in the callback only being called when the specified irq_source_id is
> > > asserting the given gsi.
> > > 
> > > The i8254 PIT remains unfiltered because it de-asserts it's irq source
> > > id, so it's notifier would never get called otherwise.  KVM device
> > > assignment gets filtering as it de-asserts the GSI in it's notifier.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > 
> > Looks good to me. For the record, I expect this to help if
> > - an assigned device interrupt is shared in host
> >   so we use slow config cycles in the ack notifier
> > - said device is sharing interrupt with another device in guest
> > - said another device is actually driving most interrupts
> > For example, I think this could be tested
> > by booting guest with pci=nomsi.
> 
> Yes, that's how I do most of my testing of legacy interrupts with
> vfio-pci.  KVM assignment is smart enough not to do config access unless
> the irq is marked as disabled, but it does eliminate an unnecessary
> de-assert and a couple spinlocks in assignment code.

Hmm this is less than I thought. Any performance numbers?

> > A minor suggestions below but
> > nothing that needs to block this patch.
> > 
> > > ---
> > > 
> > >  arch/x86/kvm/i8254.c     |    1 +
> > >  arch/x86/kvm/i8259.c     |    8 +++++++-
> > >  include/linux/kvm_host.h |    4 +++-
> > >  virt/kvm/assigned-dev.c  |    1 +
> > >  virt/kvm/ioapic.c        |    5 ++++-
> > >  virt/kvm/irq_comm.c      |    6 ++++--
> > >  6 files changed, 20 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> > > index adba28f..2355d19 100644
> > > --- a/arch/x86/kvm/i8254.c
> > > +++ b/arch/x86/kvm/i8254.c
> > > @@ -709,6 +709,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
> > >  	hrtimer_init(&pit_state->pit_timer.timer,
> > >  		     CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
> > >  	pit_state->irq_ack_notifier.gsi = 0;
> > > +	pit_state->irq_ack_notifier.irq_source_id = -1; /* No filter */
> > 
> > A bit prettier would be to
> > #define KVM_NO_IRQ_SOURCE_ID     (-1)
> > and test for it explicitly.
> 
> Ok.  I'll add a define and resend this one.  Thanks,
> 
> Alex
> 
> > >  	pit_state->irq_ack_notifier.irq_acked = kvm_pit_ack_irq;
> > >  	kvm_register_irq_ack_notifier(kvm, &pit_state->irq_ack_notifier);
> > >  	pit_state->pit_timer.reinject = true;
> > > diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> > > index e498b18..d2175a9 100644
> > > --- a/arch/x86/kvm/i8259.c
> > > +++ b/arch/x86/kvm/i8259.c
> > > @@ -74,9 +74,14 @@ static void pic_unlock(struct kvm_pic *s)
> > >  
> > >  static void pic_clear_isr(struct kvm_kpic_state *s, int irq)
> > >  {
> > > +	unsigned long irq_source_ids;
> > > +
> > >  	s->isr &= ~(1 << irq);
> > >  	if (s != &s->pics_state->pics[0])
> > >  		irq += 8;
> > > +
> > > +	irq_source_ids = s->pics_state->irq_states[irq];
> > > +
> > >  	/*
> > >  	 * We are dropping lock while calling ack notifiers since ack
> > >  	 * notifier callbacks for assigned devices call into PIC recursively.
> > > @@ -84,7 +89,8 @@ static void pic_clear_isr(struct kvm_kpic_state *s, int irq)
> > >  	 * it should be safe since PIC state is already updated at this stage.
> > >  	 */
> > >  	pic_unlock(s->pics_state);
> > > -	kvm_notify_acked_irq(s->pics_state->kvm, SELECT_PIC(irq), irq);
> > > +	kvm_notify_acked_irq(s->pics_state->kvm, SELECT_PIC(irq), irq,
> > > +			     irq_source_ids);
> > >  	pic_lock(s->pics_state);
> > >  }
> > >  
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index b70b48b..2ad3e4a 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -577,6 +577,7 @@ int kvm_is_mmio_pfn(pfn_t pfn);
> > >  
> > >  struct kvm_irq_ack_notifier {
> > >  	struct hlist_node link;
> > > +	int irq_source_id;
> > >  	unsigned gsi;
> > >  	void (*irq_acked)(struct kvm_irq_ack_notifier *kian);
> > >  };
> > > @@ -627,7 +628,8 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
> > >  int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level);
> > >  int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
> > >  		int irq_source_id, int level);
> > > -void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
> > > +void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin,
> > > +			  unsigned long irq_source_ids);
> > >  void kvm_register_irq_ack_notifier(struct kvm *kvm,
> > >  				   struct kvm_irq_ack_notifier *kian);
> > >  void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
> > > diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> > > index 23a41a9..a08c9c1 100644
> > > --- a/virt/kvm/assigned-dev.c
> > > +++ b/virt/kvm/assigned-dev.c
> > > @@ -407,6 +407,7 @@ static int assigned_device_enable_guest_intx(struct kvm *kvm,
> > >  {
> > >  	dev->guest_irq = irq->guest_irq;
> > >  	dev->ack_notifier.gsi = irq->guest_irq;
> > > +	dev->ack_notifier.irq_source_id = dev->irq_source_id;
> > >  	return 0;
> > >  }
> > >  
> > > diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> > > index ef61d52..1a9f445 100644
> > > --- a/virt/kvm/ioapic.c
> > > +++ b/virt/kvm/ioapic.c
> > > @@ -241,10 +241,12 @@ static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int vector,
> > >  
> > >  	for (i = 0; i < IOAPIC_NUM_PINS; i++) {
> > >  		union kvm_ioapic_redirect_entry *ent = &ioapic->redirtbl[i];
> > > +		unsigned long irq_source_ids;
> > >  
> > >  		if (ent->fields.vector != vector)
> > >  			continue;
> > >  
> > > +		irq_source_ids = ioapic->irq_states[i];
> > >  		/*
> > >  		 * We are dropping lock while calling ack notifiers because ack
> > >  		 * notifier callbacks for assigned devices call into IOAPIC
> > > @@ -254,7 +256,8 @@ static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int vector,
> > >  		 * after ack notifier returns.
> > >  		 */
> > >  		spin_unlock(&ioapic->lock);
> > > -		kvm_notify_acked_irq(ioapic->kvm, KVM_IRQCHIP_IOAPIC, i);
> > > +		kvm_notify_acked_irq(ioapic->kvm, KVM_IRQCHIP_IOAPIC, i,
> > > +				     irq_source_ids);
> > >  		spin_lock(&ioapic->lock);
> > >  
> > >  		if (trigger_mode != IOAPIC_LEVEL_TRIG)
> > > diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> > > index 83402d7..7d75126 100644
> > > --- a/virt/kvm/irq_comm.c
> > > +++ b/virt/kvm/irq_comm.c
> > > @@ -173,7 +173,8 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level)
> > >  	return ret;
> > >  }
> > >  
> > > -void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
> > > +void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin,
> > > +			  unsigned long irq_source_ids)
> > >  {
> > >  	struct kvm_irq_ack_notifier *kian;
> > >  	struct hlist_node *n;
> > > @@ -186,7 +187,8 @@ void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
> > >  	if (gsi != -1)
> > >  		hlist_for_each_entry_rcu(kian, n, &kvm->irq_ack_notifier_list,
> > >  					 link)
> > > -			if (kian->gsi == gsi)
> > > +			if (kian->gsi == gsi && (kian->irq_source_id < 0 ||
> > > +			    test_bit(kian->irq_source_id, &irq_source_ids)))
> > >  				kian->irq_acked(kian);
> > >  	rcu_read_unlock();
> > >  }
> > 
> 
> 
