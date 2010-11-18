Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0KRJUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:20:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab0KRJUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:20:45 -0500
Date: Thu, 18 Nov 2010 11:20:39 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: fast-path msi injection with irqfd
Message-ID: <20101118092039.GZ7948@redhat.com>
References: <20101117221254.GA8296@redhat.com>
 <20101118090522.GX7948@redhat.com>
 <20101118091601.GF16832@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118091601.GF16832@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:16:02AM +0200, Michael S. Tsirkin wrote:
> On Thu, Nov 18, 2010 at 11:05:22AM +0200, Gleb Natapov wrote:
> > On Thu, Nov 18, 2010 at 12:12:54AM +0200, Michael S. Tsirkin wrote:
> > > Store irq routing table pointer in the irqfd object,
> > > and use that to inject MSI directly without bouncing out to
> > > a kernel thread.
> > > 
> > > While we touch this structure, rearrange irqfd fields to make fastpath
> > > better packed for better cache utilization.
> > > 
> > > Some notes on the design:
> > > - Use pointer into the rt instead of copying an entry,
> > >   to make it possible to use rcu, thus side-stepping
> > >   locking complexities.  We also save some memory this way.
> > What locking complexity is there with copying entry approach?
> 
> Without RCU, we need two locks:
> 	- irqfd lock to scan the list of irqfds
> 	- eventfd wqh lock in the irqfd to update the entry
> To update all irqfds on list, wqh lock would be nested within irqfd lock.
> 	lock(kvm->irqfds.lock)
> 	list_for_each(irqfd, kvm->irqfds.list)
> 		lock(irqfd->wqh)
> 		update(irqfd)
> 		unlock(irqfd->wqh)
> 	unlock(kvm->irqfds.lock)
> Problem is, irqfd is nested within wqh for cleanup (POLLHUP) path.
> 
> With RCU we do assign and let sync take care of flushing old entries out.
> 
Make sense. What about other comments :)

> > > - Old workqueue code is still used for level irqs.
> > >   I don't think we DTRT with level anyway, however,
> > >   it seems easier to keep the code around as
> > >   it has been thought through and debugged, and fix level later than
> > >   rip out and re-instate it later.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > > 
> > > The below is compile tested only.  Sending out for early
> > > flames/feedback.  Please review!
> > > 
> > >  include/linux/kvm_host.h |    4 ++
> > >  virt/kvm/eventfd.c       |   81 +++++++++++++++++++++++++++++++++++++++------
> > >  virt/kvm/irq_comm.c      |    6 ++-
> > >  3 files changed, 78 insertions(+), 13 deletions(-)
> > > 
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index a055742..b6f7047 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -462,6 +462,8 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
> > >  				   unsigned long *deliver_bitmask);
> > >  #endif
> > >  int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level);
> > > +int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
> > > +		int irq_source_id, int level);
> > >  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
> > >  void kvm_register_irq_ack_notifier(struct kvm *kvm,
> > >  				   struct kvm_irq_ack_notifier *kian);
> > > @@ -603,6 +605,7 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
> > >  void kvm_eventfd_init(struct kvm *kvm);
> > >  int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
> > >  void kvm_irqfd_release(struct kvm *kvm);
> > > +void kvm_irqfd_update(struct kvm *kvm, struct kvm_irq_routing_table *irq_rt);
> > >  int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
> > >  
> > >  #else
> > > @@ -614,6 +617,7 @@ static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
> > >  }
> > >  
> > >  static inline void kvm_irqfd_release(struct kvm *kvm) {}
> > > +static inline void kvm_irqfd_update(struct kvm *kvm) {}
> > >  static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
> > >  {
> > >  	return -ENOSYS;
> > > diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> > > index c1f1e3c..49c1864 100644
> > > --- a/virt/kvm/eventfd.c
> > > +++ b/virt/kvm/eventfd.c
> > > @@ -44,14 +44,18 @@
> > >   */
> > >  
> > >  struct _irqfd {
> > > -	struct kvm               *kvm;
> > > -	struct eventfd_ctx       *eventfd;
> > > -	int                       gsi;
> > > -	struct list_head          list;
> > > -	poll_table                pt;
> > > -	wait_queue_t              wait;
> > > -	struct work_struct        inject;
> > > -	struct work_struct        shutdown;
> > > +	/* Used for MSI fast-path */
> > > +	struct kvm *kvm;
> > > +	wait_queue_t wait;
> > > +	struct kvm_kernel_irq_routing_entry __rcu *irq_entry;
> > > +	/* Used for level IRQ fast-path */
> > > +	int gsi;
> > > +	struct work_struct inject;
> > > +	/* Used for setup/shutdown */
> > > +	struct eventfd_ctx *eventfd;
> > > +	struct list_head list;
> > > +	poll_table pt;
> > > +	struct work_struct shutdown;
> > >  };
> > >  
> > >  static struct workqueue_struct *irqfd_cleanup_wq;
> > > @@ -125,10 +129,18 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
> > >  {
> > >  	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
> > >  	unsigned long flags = (unsigned long)key;
> > > +	struct kvm_kernel_irq_routing_entry *irq;
> > >  
> > > -	if (flags & POLLIN)
> > > +	if (flags & POLLIN) {
> > > +		rcu_read_lock();
> > > +		irq = irqfd->irq_entry;
> > Why not rcu_dereference()? And why it can't be zero here?
> > 
> > >  		/* An event has been signaled, inject an interrupt */
> > > -		schedule_work(&irqfd->inject);
> > > +		if (irq)
> > > +			kvm_set_msi(irq, irqfd->kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1);
> > > +		else
> > > +			schedule_work(&irqfd->inject);
> > > +		rcu_read_unlock();
> > > +	}
> > >  
> > >  	if (flags & POLLHUP) {
> > >  		/* The eventfd is closing, detach from KVM */
> > > @@ -166,6 +178,7 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
> > >  static int
> > >  kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
> > >  {
> > > +	struct kvm_irq_routing_table *irq_rt;
> > >  	struct _irqfd *irqfd, *tmp;
> > >  	struct file *file = NULL;
> > >  	struct eventfd_ctx *eventfd = NULL;
> > > @@ -215,6 +228,10 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
> > >  		goto fail;
> > >  	}
> > >  
> > > +	rcu_read_lock();
> > > +	irqfd_update(kvm, irqfd, rcu_dereference(kvm->irq_routing));
> > > +	rcu_read_unlock();
> > > +
> > >  	events = file->f_op->poll(file, &irqfd->pt);
> > >  
> > >  	list_add_tail(&irqfd->list, &kvm->irqfds.items);
> > > @@ -271,8 +288,15 @@ kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
> > >  	spin_lock_irq(&kvm->irqfds.lock);
> > >  
> > >  	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
> > > -		if (irqfd->eventfd == eventfd && irqfd->gsi == gsi)
> > > +		if (irqfd->eventfd == eventfd && irqfd->gsi == gsi) {
> > > +			/* This rcu_assign_pointer is needed for when
> > > +			 * another thread calls kvm_irqfd_update before
> > > +			 * we flush workqueue below.
> > > +			 * It is paired with synchronize_rcu done by caller
> > > +			 * of that function. */
> > > +			rcu_assign_pointer(irqfd->irq_entry, NULL);
> > >  			irqfd_deactivate(irqfd);
> > > +		}
> > >  	}
> > >  
> > >  	spin_unlock_irq(&kvm->irqfds.lock);
> > > @@ -321,6 +345,41 @@ kvm_irqfd_release(struct kvm *kvm)
> > >  
> > >  }
> > >  
> > > +/* Must be called under irqfds.lock */
> > > +static void irqfd_update(struct kvm *kvm, struct _irqfd *irqfd,
> > > +			 struct kvm_irq_routing_table *irq_rt)
> > > +{
> > > +	struct kvm_kernel_irq_routing_entry *e;
> > > +	struct hlist_node *n;
> > > +
> > > +	if (irqfd->gsi >= irq_rt->nr_rt_entries) {
> > > +		rcu_assign_pointer(irqfd->irq_entry, NULL);
> > > +		return;
> > > +	}
> > > +
> > > +	hlist_for_each_entry(e, n, &irq_rt->map[irqfd->gsi], link) {
> > > +		/* Only fast-path MSI. */
> > > +		if (e->type == KVM_IRQ_ROUTING_MSI)
> > > +			rcu_assign_pointer(irqfd->irq_entry, e);
> > > +		else
> > > +			rcu_assign_pointer(irqfd->irq_entry, NULL);
> > > +	}
> > Shouldn't we flush workqueue if routing entry is gone?
> > 
> > > +}
> > > +
> > > +/* Update irqfd after a routing change.  Caller must invoke synchronize_rcu
> > > + * afterwards. */
> > > +void kvm_irqfd_update(struct kvm *kvm, struct kvm_irq_routing_table *irq_rt)
> > > +{
> > > +	struct _irqfd *irqfd;
> > > +
> > > +	spin_lock_irq(&kvm->irqfds.lock);
> > > +
> > > +	list_for_each_entry(irqfd, &kvm->irqfds.items, list)
> > > +		irqfd_update(kvm, irqfd, irq_rt);
> > > +
> > > +	spin_unlock_irq(&kvm->irqfds.lock);
> > > +}
> > > +
> > >  /*
> > >   * create a host-wide workqueue for issuing deferred shutdown requests
> > >   * aggregated from all vm* instances. We need our own isolated single-thread
> > > diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> > > index 8edca91..265ab72 100644
> > > --- a/virt/kvm/irq_comm.c
> > > +++ b/virt/kvm/irq_comm.c
> > > @@ -114,8 +114,8 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
> > >  	return r;
> > >  }
> > >  
> > > -static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> > > -		       struct kvm *kvm, int irq_source_id, int level)
> > > +int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> > > +		struct kvm *kvm, int irq_source_id, int level)
> > >  {
> > >  	struct kvm_lapic_irq irq;
> > >  
> > > @@ -410,7 +410,9 @@ int kvm_set_irq_routing(struct kvm *kvm,
> > >  	mutex_lock(&kvm->irq_lock);
> > >  	old = kvm->irq_routing;
> > >  	rcu_assign_pointer(kvm->irq_routing, new);
> > > +	kvm_irqfd_update(kvm, new);
> > >  	mutex_unlock(&kvm->irq_lock);
> > > +
> > >  	synchronize_rcu();
> > >  
> > >  	new = old;
> > > -- 
> > > 1.7.3.2.91.g446ac
> > 
> > --
> > 			Gleb.

--
			Gleb.
