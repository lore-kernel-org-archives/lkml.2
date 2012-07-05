Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab2GEEZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 00:25:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab2GEEZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 00:25:01 -0400
Message-ID: <1341462294.4400.106.camel@bling.home>
Subject: Re: [PATCH v3 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Wed, 04 Jul 2012 22:24:54 -0600
In-Reply-To: <20120704140040.GA26485@redhat.com>
References: <20120703191106.6735.78272.stgit@bling.home>
	 <20120703192127.6735.76953.stgit@bling.home>
	 <20120704140040.GA26485@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 17:00 +0300, Michael S. Tsirkin wrote:
> On Tue, Jul 03, 2012 at 01:21:29PM -0600, Alex Williamson wrote:
> > This new ioctl enables an eventfd to be triggered when an EOI is
> > written for a specified irqchip pin.  By default this is a simple
> > notification, but we can also tie the eoifd to a level irqfd, which
> > enables the irqchip pin to be automatically de-asserted on EOI.
> > This mode is particularly useful for device-assignment applications
> > where the unmask and notify triggers a hardware unmask.  The default
> > mode is most applicable to simple notify with no side-effects for
> > userspace usage, such as Qemu.
> > 
> > Here we make use of the reference counting of the _irq_source
> > object allowing us to share it with an irqfd and cleanup regardless
> > of the release order.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> >  Documentation/virtual/kvm/api.txt |   21 ++++
> >  arch/x86/kvm/x86.c                |    1 
> >  include/linux/kvm.h               |   14 ++
> >  include/linux/kvm_host.h          |   13 ++
> >  virt/kvm/eventfd.c                |  208 +++++++++++++++++++++++++++++++++++++
> >  virt/kvm/kvm_main.c               |   11 ++
> >  6 files changed, 266 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > index c7267d5..a38af14 100644
> > --- a/Documentation/virtual/kvm/api.txt
> > +++ b/Documentation/virtual/kvm/api.txt
> > @@ -1988,6 +1988,27 @@ to independently assert level interrupts.  The KVM_IRQFD_FLAG_LEVEL
> >  is only necessary on setup, teardown is identical to that above.
> >  KVM_IRQFD_FLAG_LEVEL support is indicated by KVM_CAP_IRQFD_LEVEL.
> >  
> > +4.77 KVM_EOIFD
> > +
> > +Capability: KVM_CAP_EOIFD
> 
> Maybe add a specific capability KVM_CAP_EOIFD_LEVEL_IRQFD too?

Good idea, allows them to be split later.

> > +Architectures: x86
> > +Type: vm ioctl
> > +Parameters: struct kvm_eoifd (in)
> > +Returns: 0 on success, -1 on error
> > +
> > +KVM_EOIFD allows userspace to receive interrupt EOI notification
> > +through an eventfd.  kvm_eoifd.fd specifies the eventfd used for
> > +notification and kvm_eoifd.gsi specifies the irchip pin, similar to
> > +KVM_IRQFD.  The eoifd is removed using the KVM_EOIFD_FLAG_DEASSIGN
> > +flag, specifying both kvm_eoifd.fd and kvm_eoifd.gsi.
> 
> This text reads like it would give you EOIs for any GSI,
> but you haven't actually implemented this for edge GSIs - and
> making it work would bloat the datapath for fast (edge) interrupts.

I do allow you to register any GSI, but you won't be getting EOIs unless
it's operating in level triggered mode.  Perhaps it's best to specify it
as unsupported and let some future patch create a new capability if
support is added.  I'll add a comment.

> What's the intended use of this part of the interface? qemu with
> irqchip disabled?

VFIO should not be dependent on KVM, therefore when kvm is not enabled
we need to add an interface in qemu for devices to be notified of eoi.
This doesn't currently exist.  VFIO can take additional advantage of
irqchip when it is enabled, thus the interface below.  However, I don't
feel I can propose an eoi notifier in qemu that stops working as soon as
irqchip is enabled, even if I'm the only user.  This theoretical qemu
eoi notifier could then use the above when irqchip is enabled.

> > +
> > +The KVM_EOIFD_FLAG_LEVEL_IRQFD flag indicates that the provided
> > +kvm_eoifd stucture includes a valid kvm_eoifd.irqfd file descriptor
> > +for a level irqfd configured using the KVM_IRQFD_FLAG_LEVEL flag.
> > +In this mode the level interrupt is de-asserted prior to EOI eventfd
> > +notification.  The KVM_EOIFD_FLAG_LEVEL_IRQFD is only necessary on
> > +setup, teardown is identical to that above.
> 
> It seems a single fd can not be used multiple times for
> different irqfds? In that case:
> 1. Need to document this limitation

Ok

> 2. This differs from other notifiers e.g.  ioeventfd.

But the same as an irqfd.  Neither use case I'm thinking of needs to
allow eventfds to be re-used and knowing that an eventfd is unique on
our list makes matching it much easier.  For instance, if we have an
eoifd bound to a level irqfd and it's being de-assigned, we'd have to
require the eoifd is de-assigned before the irqfd so that we can
validate matching eventfd, gsi, and irqfd.  That gets very racy when
userspace aborts.

> Pls note: if you decide to remove this limitation, we need
> to add some other limit on the # of EOIFDs that VM can have
> as won't be limited by # of fds anymore.

I don't plan on changing this unless someone has an argument why it
would be useful.

> > +
> >  5. The kvm_run structure
> >  ------------------------
> >  
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 80bed07..62d6eca 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2149,6 +2149,7 @@ int kvm_dev_ioctl_check_extension(long ext)
> >  	case KVM_CAP_PCI_2_3:
> >  	case KVM_CAP_KVMCLOCK_CTRL:
> >  	case KVM_CAP_IRQFD_LEVEL:
> > +	case KVM_CAP_EOIFD:
> >  		r = 1;
> >  		break;
> >  	case KVM_CAP_COALESCED_MMIO:
> > diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> > index b2e6e4f..7567e7d 100644
> > --- a/include/linux/kvm.h
> > +++ b/include/linux/kvm.h
> > @@ -619,6 +619,7 @@ struct kvm_ppc_smmu_info {
> >  #define KVM_CAP_S390_COW 79
> >  #define KVM_CAP_PPC_ALLOC_HTAB 80
> >  #define KVM_CAP_IRQFD_LEVEL 81
> > +#define KVM_CAP_EOIFD 82
> >  
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >  
> > @@ -694,6 +695,17 @@ struct kvm_irqfd {
> >  	__u8  pad[20];
> >  };
> >  
> > +#define KVM_EOIFD_FLAG_DEASSIGN (1 << 0)
> > +#define KVM_EOIFD_FLAG_LEVEL_IRQFD (1 << 1)
> > +
> > +struct kvm_eoifd {
> > +	__u32 fd;
> > +	__u32 gsi;
> > +	__u32 flags;
> > +	__u32 irqfd;
> > +	__u8 pad[16];
> > +};
> > +
> >  struct kvm_clock_data {
> >  	__u64 clock;
> >  	__u32 flags;
> > @@ -834,6 +846,8 @@ struct kvm_s390_ucas_mapping {
> >  #define KVM_PPC_GET_SMMU_INFO	  _IOR(KVMIO,  0xa6, struct kvm_ppc_smmu_info)
> >  /* Available with KVM_CAP_PPC_ALLOC_HTAB */
> >  #define KVM_PPC_ALLOCATE_HTAB	  _IOWR(KVMIO, 0xa7, __u32)
> > +/* Available with KVM_CAP_EOIFD */
> > +#define KVM_EOIFD                 _IOW(KVMIO,  0xa8, struct kvm_eoifd)
> >  
> >  /*
> >   * ioctls for vcpu fds
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index ae3b426..83472eb 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -285,6 +285,10 @@ struct kvm {
> >  		struct list_head  items;
> >  	} irqfds;
> >  	struct list_head ioeventfds;
> > +	struct {
> > +		spinlock_t        lock;
> 
> Can't this be a mutex? It seems that code will be much simpler
> if you can just take the mutex, do everything and unlock.

Yeah, looks like it could.

> For example you could prevent changing eoifds while irqfds
> are changed.

I'm not sure we need to be that strict, but we could be sure to get a
reference to the _source_id using the irqfd lock that way... actually we
could do that in the current locking scheme too.

> > +		struct list_head  items;
> > +	} eoifds;
> >  #endif
> >  	struct kvm_vm_stat stat;
> >  	struct kvm_arch arch;
> > @@ -828,6 +832,8 @@ int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args);
> >  void kvm_irqfd_release(struct kvm *kvm);
> >  void kvm_irq_routing_update(struct kvm *, struct kvm_irq_routing_table *);
> >  int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
> > +int kvm_eoifd(struct kvm *kvm, struct kvm_eoifd *args);
> > +void kvm_eoifd_release(struct kvm *kvm);
> >  
> >  #else
> >  
> > @@ -853,6 +859,13 @@ static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
> >  	return -ENOSYS;
> >  }
> >  
> > +static inline int kvm_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
> > +{
> > +	return -ENOSYS;
> > +}
> > +
> > +static inline void kvm_eoifd_release(struct kvm *kvm) {}
> > +
> >  #endif /* CONFIG_HAVE_KVM_EVENTFD */
> >  
> >  #ifdef CONFIG_KVM_APIC_ARCHITECTURE
> > diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> > index 92aa5ba..2bc9768 100644
> > --- a/virt/kvm/eventfd.c
> > +++ b/virt/kvm/eventfd.c
> > @@ -62,8 +62,7 @@ static void _irq_source_put(struct _irq_source *source)
> >  		kref_put(&source->kref, _irq_source_release);
> >  }
> >  
> > -static struct _irq_source *__attribute__ ((used)) /* white lie for now */
> > -_irq_source_get(struct _irq_source *source)
> > +static struct _irq_source *_irq_source_get(struct _irq_source *source)
> >  {
> >  	if (source)
> >  		kref_get(&source->kref);
> > @@ -119,6 +118,39 @@ struct _irqfd {
> >  	struct work_struct shutdown;
> >  };
> >  
> > +static struct _irqfd *_irqfd_fdget(struct kvm *kvm, int fd)
> > +{
> > +	struct eventfd_ctx *eventfd;
> > +	struct _irqfd *tmp, *irqfd = NULL;
> > +
> > +	eventfd = eventfd_ctx_fdget(fd);
> > +	if (IS_ERR(eventfd))
> > +		return (struct _irqfd *)eventfd;
> > +
> > +	spin_lock_irq(&kvm->irqfds.lock);
> > +
> > +	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
> > +		if (tmp->eventfd == eventfd) {
> > +			irqfd = tmp;
> > +			break;
> > +		}
> > +	}
> > +
> > +	spin_unlock_irq(&kvm->irqfds.lock);
> > +
> > +	if (!irqfd) {
> > +		eventfd_ctx_put(eventfd);
> > +		return ERR_PTR(-ENODEV);
> > +	}
> 
> Can irqfd get dassigned at this point?
> Could one way to fix be to take eoifd.lock in kvm_irqfd?

Yeah, I'm concerned this isn't a sufficient reference to the _irqfd.
I'll play with locking; I think we actually want the reverse, holding
irqfd.lock for the search through getting a reference to the
_irq_source.

> > +
> > +	return irqfd;
> > +}
> > +
> > +static void _irqfd_put(struct _irqfd *irqfd)
> > +{
> > +	eventfd_ctx_put(irqfd->eventfd);
> > +}
> > +
> >  static struct workqueue_struct *irqfd_cleanup_wq;
> >  
> >  static void
> > @@ -387,6 +419,8 @@ kvm_eventfd_init(struct kvm *kvm)
> >  	spin_lock_init(&kvm->irqfds.lock);
> >  	INIT_LIST_HEAD(&kvm->irqfds.items);
> >  	INIT_LIST_HEAD(&kvm->ioeventfds);
> > +	spin_lock_init(&kvm->eoifds.lock);
> > +	INIT_LIST_HEAD(&kvm->eoifds.items);
> >  }
> >  
> >  /*
> > @@ -753,3 +787,173 @@ kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
> >  
> >  	return kvm_assign_ioeventfd(kvm, args);
> >  }
> > +
> > +/*
> > + * --------------------------------------------------------------------
> > + *  eoifd: Translate KVM APIC/IOAPIC EOI into eventfd signal.
> > + *
> > + *  userspace can register GSIs with an eventfd for receiving
> > + *  notification when an EOI occurs.
> > + * --------------------------------------------------------------------
> > + */
> > +
> > +struct _eoifd {
> > +	struct eventfd_ctx *eventfd;
> > +	struct _irq_source *source; /* for de-asserting level irqfd */
> > +	struct kvm *kvm;
> > +	struct kvm_irq_ack_notifier notifier;
> > +	struct list_head list;
> > +};
> > +
> > +static void eoifd_event(struct kvm_irq_ack_notifier *notifier)
> > +{
> > +	struct _eoifd *eoifd;
> > +
> > +	eoifd = container_of(notifier, struct _eoifd, notifier);
> > +
> > +	/*
> > +	 * If the eoifd is tied to a level irqfd we de-assert it here.
> > +	 * The user is responsible for re-asserting it if their device
> > +	 * still needs attention.  For notification-only, skip this.
> > +	 */
> > +	if (eoifd->source)
> > +		kvm_set_irq(eoifd->kvm, eoifd->source->id,
> > +			    eoifd->notifier.gsi, 0);
> > +
> 
> 
> This will fire even if the source in question did not assert an
> interrupt in the first place.  This won't scale well if
> the interrupt is shared. Don't we need to filter by source state?

Extra spurious EOIs are better than dropped EOIs.  However, it does seem
we could add an atomic_t to _irq_source tracking the assertion state of
our source id.  I'll experiment with that.

> > +	eventfd_signal(eoifd->eventfd, 1);
> > +}
> > +
> > +static int kvm_assign_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
> > +{
> > +	struct eventfd_ctx *eventfd;
> > +	struct _eoifd *eoifd, *tmp;
> > +	struct _irq_source *source = NULL;
> > +
> > +	if (args->flags & KVM_EOIFD_FLAG_LEVEL_IRQFD) {
> > +		struct _irqfd *irqfd = _irqfd_fdget(kvm, args->irqfd);
> > +		if (IS_ERR(irqfd))
> > +			return PTR_ERR(irqfd);
> > +
> > +		if (irqfd->gsi != args->gsi) {
> > +			_irqfd_put(irqfd);
> > +			return -EINVAL;
> > +		}
> > +
> 
> This requirement does not seem to be documented.
> If we require this, do we need to pass in gsi at all?

It seemed obvious to me that when using KVM_EOIFD_FLAG_LEVEL_IRQFD the
gsi needs to match that used for the kvm_irqfd.  Suppose I should never
assume anything is obvious in an API spec.  I'll add a comment.  I think
it would make the user interface more confusing to specify that gsi is
not required when using a level irqfd, besides it gives us an easy
sanity check.

> > +		source = _irq_source_get(irqfd->source);
> > +		_irqfd_put(irqfd);
> > +		if (!source)
> > +			return -EINVAL;
> > +	}
> > +
> > +	eventfd = eventfd_ctx_fdget(args->fd);
> > +	if (IS_ERR(eventfd)) {
> > +		_irq_source_put(source);
> > +		return PTR_ERR(eventfd);
> > +	}
> > +
> > +	eoifd = kzalloc(sizeof(*eoifd), GFP_KERNEL);
> > +	if (!eoifd) {
> > +		_irq_source_put(source);
> > +		eventfd_ctx_put(eventfd);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	INIT_LIST_HEAD(&eoifd->list);
> > +	eoifd->kvm = kvm;
> > +	eoifd->eventfd = eventfd;
> > +	eoifd->source = source;
> > +	eoifd->notifier.gsi = args->gsi;
> > +	eoifd->notifier.irq_acked = eoifd_event;
> > +
> > +	spin_lock_irq(&kvm->eoifds.lock);
> > +
> > +	list_for_each_entry(tmp, &kvm->eoifds.items, list) {
> > +		if (eoifd->eventfd != tmp->eventfd)
> > +			continue;
> > +
> > +		spin_unlock_irq(&kvm->eoifds.lock);
> > +		_irq_source_put(source);
> > +		eventfd_ctx_put(eventfd);
> > +		kfree(eoifd);
> > +		return -EBUSY;
> 
> 
> Please rewrite this function using labels for error handling.

Ok

> > +	}
> > +
> > +	list_add_tail(&eoifd->list, &kvm->eoifds.items);
> > +
> > +	spin_unlock_irq(&kvm->eoifds.lock);
> > +
> > +	kvm_register_irq_ack_notifier(kvm, &eoifd->notifier);
> > +
> > +	return 0;
> > +}
> > +
> > +static void eoifd_deactivate(struct kvm *kvm, struct _eoifd *eoifd)
> 
> Pls find a less confusing name for this.
> It just frees the eoifd. No tricky deactivation here (unlike irqfd).

Uh, confusing?  It does actually deactivate it by unregistering the irq
ack notifier.  I was attempting to be consistent with the function
naming by following irqfd_deactivate, I didn't realize there was a
complexity requirement associated with the name.

> > +{
> > +	kvm_unregister_irq_ack_notifier(kvm, &eoifd->notifier);
> > +	_irq_source_put(eoifd->source);
> > +	eventfd_ctx_put(eoifd->eventfd);
> > +	kfree(eoifd);
> > +}
> > +
> > +void kvm_eoifd_release(struct kvm *kvm)
> > +{
> > +	spin_lock_irq(&kvm->eoifds.lock);
> > +
> > +	while (!list_empty(&kvm->eoifds.items)) {
> > +		struct _eoifd *eoifd;
> > +
> > +		eoifd = list_first_entry(&kvm->eoifds.items,
> > +					 struct _eoifd, list);
> > +		list_del(&eoifd->list);
> > +
> > +		/* Drop spinlocks since eoifd_deactivate can sleep */
> > +		spin_unlock_irq(&kvm->eoifds.lock);
> > +		eoifd_deactivate(kvm, eoifd);
> > +		spin_lock_irq(&kvm->eoifds.lock);
> > +	}
> > +
> > +	spin_unlock_irq(&kvm->eoifds.lock);
> > +}
> > +
> > +static int kvm_deassign_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
> > +{
> > +	struct eventfd_ctx *eventfd;
> > +	struct _eoifd *tmp, *eoifd = NULL;
> > +
> > +	eventfd = eventfd_ctx_fdget(args->fd);
> > +	if (IS_ERR(eventfd))
> > +		return PTR_ERR(eventfd);
> > +
> > +	spin_lock_irq(&kvm->eoifds.lock);
> > +
> > +	list_for_each_entry(tmp, &kvm->eoifds.items, list) {
> > +		if (tmp->eventfd == eventfd && tmp->notifier.gsi == args->gsi) {
> 
> This is repeated several times.
> looks like eoifd_collision function is called for.

The tests aren't quite identical.  Here we test eventfd and gsi, the
latter primarily to validate kvm_eoifd parameters.  Further above we
test that eventfd is unique on addition without comparing gsi.  Both of
these match the existing precedent set by irqfd.  With _irqfd_fdget we
do have two searches of the irqfds.items list comparing only eventfd...
I'll see about making a trivial helper there.  Thanks,

Alex

> > +			eoifd = tmp;
> > +			list_del(&eoifd->list);
> > +			break;
> > +		}
> > +	}
> > +
> > +	spin_unlock_irq(&kvm->eoifds.lock);
> > +
> > +	eventfd_ctx_put(eventfd);
> > +
> > +	if (!eoifd)
> > +		return -ENOENT;
> > +
> > +	eoifd_deactivate(kvm, eoifd);
> > +
> > +	return 0;
> > +}
> > +
> > +int kvm_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
> > +{
> > +	if (args->flags & ~(KVM_EOIFD_FLAG_DEASSIGN |
> > +			    KVM_EOIFD_FLAG_LEVEL_IRQFD))
> > +		return -EINVAL;
> > +
> > +	if (args->flags & KVM_EOIFD_FLAG_DEASSIGN)
> > +		return kvm_deassign_eoifd(kvm, args);
> > +
> > +	return kvm_assign_eoifd(kvm, args);
> > +}
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index b4ad14cc..5b41df1 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -620,6 +620,8 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
> >  
> >  	kvm_irqfd_release(kvm);
> >  
> > +	kvm_eoifd_release(kvm);
> > +
> >  	kvm_put_kvm(kvm);
> >  	return 0;
> >  }
> > @@ -2093,6 +2095,15 @@ static long kvm_vm_ioctl(struct file *filp,
> >  		break;
> >  	}
> >  #endif
> > +	case KVM_EOIFD: {
> > +		struct kvm_eoifd data;
> > +
> > +		r = -EFAULT;
> > +		if (copy_from_user(&data, argp, sizeof data))
> > +			goto out;
> > +		r = kvm_eoifd(kvm, &data);
> > +		break;
> > +	}
> >  	default:
> >  		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
> >  		if (r == -ENOTTY)



