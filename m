Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab2ASNrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 08:47:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab2ASNrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 08:47:46 -0500
Date: Thu, 19 Jan 2012 15:49:57 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, jan.kiszka@siemens.com,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: deliver msix interrupts from irq handler
Message-ID: <20120119134957.GC4009@redhat.com>
References: <20120118181023.GA4140@redhat.com>
 <20120119072123.GE9571@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119072123.GE9571@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 09:21:23AM +0200, Gleb Natapov wrote:
> > diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> > index ba892df..68cd127 100644
> > --- a/virt/kvm/irq_comm.c
> > +++ b/virt/kvm/irq_comm.c
> > @@ -201,6 +201,58 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
> >  	return ret;
> >  }
> >  
> > +static inline struct kvm_kernel_irq_routing_entry *
> > +kvm_get_entry(struct kvm *kvm, struct kvm_irq_routing_table *irq_rq, u32 irq)
> > +{
> > +	struct kvm_kernel_irq_routing_entry *e;
> > +	if (likely(irq < irq_rt->nr_rt_entries))
> > +		hlist_for_each_entry(e, n, &irq_rt->map[irq], link)
> > +			if (e->type == KVM_IRQ_ROUTING_MSI)
> > +				return e;
> > +			else
> > +				return ERR_PTR(-EWOULDBLOCK);
> > +	return ERR_PTR(-EINVAL);
> > +}
> Unused?

Yes, leftovers from an attempt to reuse kvm_set_irq as you suggested
below. It didn't work out - we get much more code this way,
so this needs to be removed.

> > +
> > +/*
> > + * Deliver an IRQ in an atomic context if we can, or return a failure,
> > + * user can retry in a process context.
> > + * Return value:
> > + *  -EWOULDBLOCK	Can't deliver in atomic context
> > + *  < 0			Interrupt was ignored (masked or not delivered for other reasons)
> > + *  = 0			Interrupt was coalesced (previous irq is still pending)
> > + *  > 0			Number of CPUs interrupt was delivered to
> > + */
> > +int kvm_set_irq_inatomic(struct kvm *kvm, int irq_source_id, u32 irq, int level,
> > +			 int host_irq)
> > +{
> > +	struct kvm_kernel_irq_routing_entry *e;
> > +	int ret = -EINVAL;
> > +	struct kvm_irq_routing_table *irq_rt;
> > +	struct hlist_node *n;
> > +
> > +	trace_kvm_set_irq(irq, level, irq_source_id);
> > +
> > +	/*
> > +	 * We know MSI are safe in interrupt context. They are also
> > +	 * easy as there's a single routing entry for these GSIs.
> > +	 * So only handle MSI in an atomic context, for now.
> > +	 */
> > +	rcu_read_lock_bh();
> _bh?
> 
> /**
>  * rcu_read_lock_bh() - mark the beginning of an RCU-bh critical section
>  *
>  * This is equivalent of rcu_read_lock(), but to be used when updates
>  * are being done using call_rcu_bh() or synchronize_rcu_bh().
>  ....
> 
> Since updates to irq routing table are not done using _bh variant I
> doubt rcu_read_lock_bh() is justified here.

Right. Thanks for ppointing this out, I was confused.

> > +	irq_rt = rcu_dereference(kvm->irq_routing);
> > +	if (irq < irq_rt->nr_rt_entries)
> > +		hlist_for_each_entry(e, n, &irq_rt->map[irq], link) {
> > +			if (ei->type == KVM_IRQ_ROUTING_MSI)
> > +				ret = kvm_set_msi(e, kvm, irq_source_id, level,
> > +						  host_irq);
> > +			else
> > +				ret = -EWOULDBLOCK;
> > +			break;
> > +		}
> > +	rcu_read_unlock_bh();
> > +	return ret;
> > +}
> > +
> Share implementation with kvm_set_irq().

I considered this. There are several reasons not to do it:
- Amount of common code is very small
- As it's separate, it's more obvious that it can't block (kvm_set_irq can block)
  We can even tag kvm_set_irq with might_sleep.
- This is way simpler and faster as we can do operations directly,
  instead of copying the irq out, and as it's datapath
  an optimization is I think justified.

> >  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
> >  {
> >  	struct kvm_irq_ack_notifier *kian;
> > -- 
> > 1.7.8.2.325.g247f9
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> 			Gleb.
