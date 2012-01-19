Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2ASO2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:28:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab2ASO2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:28:20 -0500
Date: Thu, 19 Jan 2012 16:30:33 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] kvm: deliver msix interrupts from irq handler
Message-ID: <20120119143032.GC5294@redhat.com>
References: <20120118181023.GA4140@redhat.com>
 <4F1806D0.9020208@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1806D0.9020208@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 01:04:32PM +0100, Jan Kiszka wrote:
> On 2012-01-18 19:10, Michael S. Tsirkin wrote:
> > We can deliver certain interrupts, notably MSIX,
> > from atomic context.  Add a new API kvm_set_irq_inatomic,
> > that does exactly that, and use it to implement
> > an irq handler for msi.
> > 
> > This reduces the pressure on scheduler in case
> > where host and guest irq share a host cpu.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > Untested.
> > Note: this is on top of my host irq patch.
> > Probably needs to be rebased to be independent
> > and split up to new API + usage.
> > 
> > ---
> >  include/linux/kvm_host.h |    2 +
> >  virt/kvm/assigned-dev.c  |   31 +++++++++++++++++++++++++-
> >  virt/kvm/irq_comm.c      |   52 ++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 83 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index f0361bc..e2b89ea 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -548,6 +548,8 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
> >  #endif
> >  int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
> >  		int host_irq);
> > +int kvm_set_irq_inatomic(struct kvm *kvm, int irq_source_id, u32 irq, int level,
> > +			 int host_irq);
> >  int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
> >  		int irq_source_id, int level, int host_irq);
> >  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
> > diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> > index cc4bb7a..73bb001 100644
> > --- a/virt/kvm/assigned-dev.c
> > +++ b/virt/kvm/assigned-dev.c
> > @@ -57,6 +57,14 @@ static int find_index_from_host_irq(struct kvm_assigned_dev_kernel
> >  	return index;
> >  }
> >  
> > +static irqreturn_t kvm_assigned_dev_msi(int irq, void *dev_id)
> > +{
> > +	int ret = kvm_set_irq_inatomic(assigned_dev->kvm,
> > +				       assigned_dev->irq_source_id,
> > +				       assigned_dev->guest_irq, 1, irq);
> > +	return unlikely(ret == -EWOULDBLOCK) ? IRQ_WAKE_THREAD : IRQ_HANDLED;
> > +}
> 
> This function gets unused (in theory) if !__KVM_HAVE_MSIX &&
> !__KVM_HAVE_MSI. Should be fixed for consistency reasons.

Does kvm still build with this !__KVM_HAVE_MSI? It does not look like
it would ...


> > +
> >  static irqreturn_t kvm_assigned_dev_thread(int irq, void *dev_id)
> >  {
> >  	struct kvm_assigned_dev_kernel *assigned_dev = dev_id;
> > @@ -75,6 +83,23 @@ static irqreturn_t kvm_assigned_dev_thread(int irq, void *dev_id)
> >  }
> >  
> >  #ifdef __KVM_HAVE_MSIX
> > +static irqreturn_t kvm_assigned_dev_msix(int irq, void *dev_id)
> > +{
> > +	struct kvm_assigned_dev_kernel *assigned_dev = dev_id;
> > +	int index = find_index_from_host_irq(assigned_dev, irq);
> > +	u32 vector;
> > +	int ret = 0;
> > +
> > +	if (index >= 0) {
> > +		vector = assigned_dev->guest_msix_entries[index].vector;
> > +		ret = kvm_set_irq_inatomic(assigned_dev->kvm,
> > +					   assigned_dev->irq_source_id,
> > +					   vector, 1, irq);
> > +	}
> > +
> > +	return unlikely(ret == -EWOULDBLOCK) ? IRQ_WAKE_THREAD : IRQ_HANDLED;
> > +}
> > +
> >  static irqreturn_t kvm_assigned_dev_thread_msix(int irq, void *dev_id)
> >  {
> >  	struct kvm_assigned_dev_kernel *assigned_dev = dev_id;
> > @@ -266,7 +291,8 @@ static int assigned_device_enable_host_msi(struct kvm *kvm,
> >  	}
> >  
> >  	dev->host_irq = dev->dev->irq;
> > -	if (request_threaded_irq(dev->host_irq, NULL, kvm_assigned_dev_thread,
> > +	if (request_threaded_irq(dev->host_irq, kvm_assigned_dev_msi,
> > +				 kvm_assigned_dev_thread,
> >  				 0, dev->irq_name, dev)) {
> >  		pci_disable_msi(dev->dev);
> >  		return -EIO;
> > @@ -293,7 +319,8 @@ static int assigned_device_enable_host_msix(struct kvm *kvm,
> >  
> >  	for (i = 0; i < dev->entries_nr; i++) {
> >  		r = request_threaded_irq(dev->host_msix_entries[i].vector,
> > -					 NULL, kvm_assigned_dev_thread_msix,
> > +					 kvm_assigned_dev_msix,
> > +					 kvm_assigned_dev_thread_msix,
> >  					 0, dev->irq_name, dev);
> >  		if (r)
> >  			goto err;
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
> > +
> > +/*
> > + * Deliver an IRQ in an atomic context if we can, or return a failure,
> > + * user can retry in a process context.
> > + * Return value:
> > + *  -EWOULDBLOCK	Can't deliver in atomic context
> > + *  < 0			Interrupt was ignored (masked or not delivered for other reasons)
> > + *  = 0			Interrupt was coalesced (previous irq is still pending)
> > + *  > 0			Number of CPUs interrupt was delivered to
> 
> Where do you make use of =0 vs. >0? Not in this patch at least. Do you
> consider using it for the APIC timer as well?

I think it might be handy in the future. It's an internal function
(not exported) so I just return what I get without worrying about it
too much: I didn't need to add code to get this :)

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
> >  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
> >  {
> >  	struct kvm_irq_ack_notifier *kian;
> 
> Highly welcome feature!
> 
> Jan

I think we need to fix MSIX masking now, otherwise delivering interrupt
faster might get us a storm of interrupts.

> -- 
> Siemens AG, Corporate Technology, CT T DE IT 1
> Corporate Competence Center Embedded Linux
