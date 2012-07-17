Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2GQCmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:42:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab2GQCmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:42:18 -0400
Message-ID: <1342492934.3880.69.camel@ul30vt>
Subject: Re: [PATCH v5 3/4] kvm: Create kvm_clear_irq()
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Mon, 16 Jul 2012 20:42:14 -0600
In-Reply-To: <20120717005159.GA7949@redhat.com>
References: <20120716202711.1752.71007.stgit@bling.home>
	 <20120716203401.1752.78276.stgit@bling.home>
	 <20120717005159.GA7949@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 03:51 +0300, Michael S. Tsirkin wrote:
> On Mon, Jul 16, 2012 at 02:34:03PM -0600, Alex Williamson wrote:
> > This is an alternative to kvm_set_irq(,,,0) which returns the previous
> > assertion state of the interrupt and does nothing if it isn't changed.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> >  include/linux/kvm_host.h |    3 ++
> >  virt/kvm/irq_comm.c      |   78 ++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 81 insertions(+)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index a7661c0..6c168f1 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -219,6 +219,8 @@ struct kvm_kernel_irq_routing_entry {
> >  	u32 type;
> >  	int (*set)(struct kvm_kernel_irq_routing_entry *e,
> >  		   struct kvm *kvm, int irq_source_id, int level);
> > +	int (*clear)(struct kvm_kernel_irq_routing_entry *e,
> > +		     struct kvm *kvm, int irq_source_id);
> >  	union {
> >  		struct {
> >  			unsigned irqchip;
> > @@ -629,6 +631,7 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
> >  				   unsigned long *deliver_bitmask);
> >  #endif
> >  int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level);
> > +int kvm_clear_irq(struct kvm *kvm, int irq_source_id, u32 irq);
> >  int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
> >  		int irq_source_id, int level);
> >  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
> > diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> > index 5afb431..76e8f22 100644
> > --- a/virt/kvm/irq_comm.c
> > +++ b/virt/kvm/irq_comm.c
> > @@ -68,6 +68,42 @@ static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
> >  	return kvm_ioapic_set_irq(ioapic, e->irqchip.pin, level);
> >  }
> >  
> > +static inline int kvm_clear_irq_line_state(unsigned long *irq_state,
> > +					    int irq_source_id)
> > +{
> > +	return !!test_and_clear_bit(irq_source_id, irq_state);
> > +}
> > +
> > +static int kvm_clear_pic_irq(struct kvm_kernel_irq_routing_entry *e,
> > +			     struct kvm *kvm, int irq_source_id)
> > +{
> > +#ifdef CONFIG_X86
> > +	struct kvm_pic *pic = pic_irqchip(kvm);
> > +	int level = kvm_clear_irq_line_state(&pic->irq_states[e->irqchip.pin],
> > +					     irq_source_id);
> > +	if (level)
> > +		kvm_pic_set_irq(pic, e->irqchip.pin,
> > +				!!pic->irq_states[e->irqchip.pin]);
> > +	return level;
> > +#else
> > +	return -1;
> > +#endif
> 
> What does this ifdef exclude exactly?

No pic on ia64.  Not that it works, but I figured the consistency with
kvm_set_pic_irq would make more sense whenever someone goes through and
cleans out the code.  Thanks,

Alex

> > +}
> > +
> > +static int kvm_clear_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
> > +				struct kvm *kvm, int irq_source_id)
> > +{
> > +	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
> > +	int level;
> > +
> > +	level = kvm_clear_irq_line_state(&ioapic->irq_states[e->irqchip.pin],
> > +					 irq_source_id);
> > +	if (level)
> > +		kvm_ioapic_set_irq(ioapic, e->irqchip.pin,
> > +				   !!ioapic->irq_states[e->irqchip.pin]);
> > +	return level;
> > +}
> > +
> >  inline static bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)
> >  {
> >  #ifdef CONFIG_IA64
> > @@ -190,6 +226,45 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level)
> >  	return ret;
> >  }
> >  
> > +/*
> > + * Return value:
> > + *  < 0   Error
> > + *  = 0   Interrupt was not set, did nothing
> > + *  > 0   Interrupt was pending, cleared
> > + */
> > +int kvm_clear_irq(struct kvm *kvm, int irq_source_id, u32 irq)
> > +{
> > +	struct kvm_kernel_irq_routing_entry *e, irq_set[KVM_NR_IRQCHIPS];
> > +	int ret = -EINVAL, i = 0;
> > +	struct kvm_irq_routing_table *irq_rt;
> > +	struct hlist_node *n;
> > +
> > +	/* Not possible to detect if the guest uses the PIC or the
> > +	 * IOAPIC.  So clear the bit in both. The guest will ignore
> > +	 * writes to the unused one.
> > +	 */
> > +	rcu_read_lock();
> > +	irq_rt = rcu_dereference(kvm->irq_routing);
> > +	if (irq < irq_rt->nr_rt_entries)
> > +		hlist_for_each_entry(e, n, &irq_rt->map[irq], link)
> > +			irq_set[i++] = *e;
> > +	rcu_read_unlock();
> > +
> > +	while (i--) {
> > +		int r = -EINVAL;
> > +
> > +		if (irq_set[i].clear)
> > +			r = irq_set[i].clear(&irq_set[i], kvm, irq_source_id);
> > +
> > +		if (r < 0)
> > +			continue;
> > +
> > +		ret = r + ((ret < 0) ? 0 : ret);
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> >  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
> >  {
> >  	struct kvm_irq_ack_notifier *kian;
> > @@ -344,16 +419,19 @@ static int setup_routing_entry(struct kvm_irq_routing_table *rt,
> >  		switch (ue->u.irqchip.irqchip) {
> >  		case KVM_IRQCHIP_PIC_MASTER:
> >  			e->set = kvm_set_pic_irq;
> > +			e->clear = kvm_clear_pic_irq;
> >  			max_pin = 16;
> >  			break;
> >  		case KVM_IRQCHIP_PIC_SLAVE:
> >  			e->set = kvm_set_pic_irq;
> > +			e->clear = kvm_clear_pic_irq;
> >  			max_pin = 16;
> >  			delta = 8;
> >  			break;
> >  		case KVM_IRQCHIP_IOAPIC:
> >  			max_pin = KVM_IOAPIC_NUM_PINS;
> >  			e->set = kvm_set_ioapic_irq;
> > +			e->clear = kvm_clear_ioapic_irq;
> >  			break;
> >  		default:
> >  			goto out;



