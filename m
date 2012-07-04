Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2GDOA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:00:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab2GDOAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:00:25 -0400
Date: Wed, 4 Jul 2012 17:00:40 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v3 2/2] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120704140040.GA26485@redhat.com>
References: <20120703191106.6735.78272.stgit@bling.home>
 <20120703192127.6735.76953.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120703192127.6735.76953.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 01:21:29PM -0600, Alex Williamson wrote:
> This new ioctl enables an eventfd to be triggered when an EOI is
> written for a specified irqchip pin.  By default this is a simple
> notification, but we can also tie the eoifd to a level irqfd, which
> enables the irqchip pin to be automatically de-asserted on EOI.
> This mode is particularly useful for device-assignment applications
> where the unmask and notify triggers a hardware unmask.  The default
> mode is most applicable to simple notify with no side-effects for
> userspace usage, such as Qemu.
> 
> Here we make use of the reference counting of the _irq_source
> object allowing us to share it with an irqfd and cleanup regardless
> of the release order.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  Documentation/virtual/kvm/api.txt |   21 ++++
>  arch/x86/kvm/x86.c                |    1 
>  include/linux/kvm.h               |   14 ++
>  include/linux/kvm_host.h          |   13 ++
>  virt/kvm/eventfd.c                |  208 +++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c               |   11 ++
>  6 files changed, 266 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index c7267d5..a38af14 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1988,6 +1988,27 @@ to independently assert level interrupts.  The KVM_IRQFD_FLAG_LEVEL
>  is only necessary on setup, teardown is identical to that above.
>  KVM_IRQFD_FLAG_LEVEL support is indicated by KVM_CAP_IRQFD_LEVEL.
>  
> +4.77 KVM_EOIFD
> +
> +Capability: KVM_CAP_EOIFD

Maybe add a specific capability KVM_CAP_EOIFD_LEVEL_IRQFD too?

> +Architectures: x86
> +Type: vm ioctl
> +Parameters: struct kvm_eoifd (in)
> +Returns: 0 on success, -1 on error
> +
> +KVM_EOIFD allows userspace to receive interrupt EOI notification
> +through an eventfd.  kvm_eoifd.fd specifies the eventfd used for
> +notification and kvm_eoifd.gsi specifies the irchip pin, similar to
> +KVM_IRQFD.  The eoifd is removed using the KVM_EOIFD_FLAG_DEASSIGN
> +flag, specifying both kvm_eoifd.fd and kvm_eoifd.gsi.

This text reads like it would give you EOIs for any GSI,
but you haven't actually implemented this for edge GSIs - and
making it work would bloat the datapath for fast (edge) interrupts.

What's the intended use of this part of the interface? qemu with
irqchip disabled?

> +
> +The KVM_EOIFD_FLAG_LEVEL_IRQFD flag indicates that the provided
> +kvm_eoifd stucture includes a valid kvm_eoifd.irqfd file descriptor
> +for a level irqfd configured using the KVM_IRQFD_FLAG_LEVEL flag.
> +In this mode the level interrupt is de-asserted prior to EOI eventfd
> +notification.  The KVM_EOIFD_FLAG_LEVEL_IRQFD is only necessary on
> +setup, teardown is identical to that above.

It seems a single fd can not be used multiple times for
different irqfds? In that case:
1. Need to document this limitation
2. This differs from other notifiers e.g.  ioeventfd.

Pls note: if you decide to remove this limitation, we need
to add some other limit on the # of EOIFDs that VM can have
as won't be limited by # of fds anymore.

> +
>  5. The kvm_run structure
>  ------------------------
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 80bed07..62d6eca 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2149,6 +2149,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_PCI_2_3:
>  	case KVM_CAP_KVMCLOCK_CTRL:
>  	case KVM_CAP_IRQFD_LEVEL:
> +	case KVM_CAP_EOIFD:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index b2e6e4f..7567e7d 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -619,6 +619,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_S390_COW 79
>  #define KVM_CAP_PPC_ALLOC_HTAB 80
>  #define KVM_CAP_IRQFD_LEVEL 81
> +#define KVM_CAP_EOIFD 82
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -694,6 +695,17 @@ struct kvm_irqfd {
>  	__u8  pad[20];
>  };
>  
> +#define KVM_EOIFD_FLAG_DEASSIGN (1 << 0)
> +#define KVM_EOIFD_FLAG_LEVEL_IRQFD (1 << 1)
> +
> +struct kvm_eoifd {
> +	__u32 fd;
> +	__u32 gsi;
> +	__u32 flags;
> +	__u32 irqfd;
> +	__u8 pad[16];
> +};
> +
>  struct kvm_clock_data {
>  	__u64 clock;
>  	__u32 flags;
> @@ -834,6 +846,8 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_PPC_GET_SMMU_INFO	  _IOR(KVMIO,  0xa6, struct kvm_ppc_smmu_info)
>  /* Available with KVM_CAP_PPC_ALLOC_HTAB */
>  #define KVM_PPC_ALLOCATE_HTAB	  _IOWR(KVMIO, 0xa7, __u32)
> +/* Available with KVM_CAP_EOIFD */
> +#define KVM_EOIFD                 _IOW(KVMIO,  0xa8, struct kvm_eoifd)
>  
>  /*
>   * ioctls for vcpu fds
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae3b426..83472eb 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -285,6 +285,10 @@ struct kvm {
>  		struct list_head  items;
>  	} irqfds;
>  	struct list_head ioeventfds;
> +	struct {
> +		spinlock_t        lock;

Can't this be a mutex? It seems that code will be much simpler
if you can just take the mutex, do everything and unlock.
For example you could prevent changing eoifds while irqfds
are changed.

> +		struct list_head  items;
> +	} eoifds;
>  #endif
>  	struct kvm_vm_stat stat;
>  	struct kvm_arch arch;
> @@ -828,6 +832,8 @@ int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args);
>  void kvm_irqfd_release(struct kvm *kvm);
>  void kvm_irq_routing_update(struct kvm *, struct kvm_irq_routing_table *);
>  int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
> +int kvm_eoifd(struct kvm *kvm, struct kvm_eoifd *args);
> +void kvm_eoifd_release(struct kvm *kvm);
>  
>  #else
>  
> @@ -853,6 +859,13 @@ static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
>  	return -ENOSYS;
>  }
>  
> +static inline int kvm_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
> +{
> +	return -ENOSYS;
> +}
> +
> +static inline void kvm_eoifd_release(struct kvm *kvm) {}
> +
>  #endif /* CONFIG_HAVE_KVM_EVENTFD */
>  
>  #ifdef CONFIG_KVM_APIC_ARCHITECTURE
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 92aa5ba..2bc9768 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -62,8 +62,7 @@ static void _irq_source_put(struct _irq_source *source)
>  		kref_put(&source->kref, _irq_source_release);
>  }
>  
> -static struct _irq_source *__attribute__ ((used)) /* white lie for now */
> -_irq_source_get(struct _irq_source *source)
> +static struct _irq_source *_irq_source_get(struct _irq_source *source)
>  {
>  	if (source)
>  		kref_get(&source->kref);
> @@ -119,6 +118,39 @@ struct _irqfd {
>  	struct work_struct shutdown;
>  };
>  
> +static struct _irqfd *_irqfd_fdget(struct kvm *kvm, int fd)
> +{
> +	struct eventfd_ctx *eventfd;
> +	struct _irqfd *tmp, *irqfd = NULL;
> +
> +	eventfd = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(eventfd))
> +		return (struct _irqfd *)eventfd;
> +
> +	spin_lock_irq(&kvm->irqfds.lock);
> +
> +	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
> +		if (tmp->eventfd == eventfd) {
> +			irqfd = tmp;
> +			break;
> +		}
> +	}
> +
> +	spin_unlock_irq(&kvm->irqfds.lock);
> +
> +	if (!irqfd) {
> +		eventfd_ctx_put(eventfd);
> +		return ERR_PTR(-ENODEV);
> +	}

Can irqfd get dassigned at this point?
Could one way to fix be to take eoifd.lock in kvm_irqfd?

> +
> +	return irqfd;
> +}
> +
> +static void _irqfd_put(struct _irqfd *irqfd)
> +{
> +	eventfd_ctx_put(irqfd->eventfd);
> +}
> +
>  static struct workqueue_struct *irqfd_cleanup_wq;
>  
>  static void
> @@ -387,6 +419,8 @@ kvm_eventfd_init(struct kvm *kvm)
>  	spin_lock_init(&kvm->irqfds.lock);
>  	INIT_LIST_HEAD(&kvm->irqfds.items);
>  	INIT_LIST_HEAD(&kvm->ioeventfds);
> +	spin_lock_init(&kvm->eoifds.lock);
> +	INIT_LIST_HEAD(&kvm->eoifds.items);
>  }
>  
>  /*
> @@ -753,3 +787,173 @@ kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
>  
>  	return kvm_assign_ioeventfd(kvm, args);
>  }
> +
> +/*
> + * --------------------------------------------------------------------
> + *  eoifd: Translate KVM APIC/IOAPIC EOI into eventfd signal.
> + *
> + *  userspace can register GSIs with an eventfd for receiving
> + *  notification when an EOI occurs.
> + * --------------------------------------------------------------------
> + */
> +
> +struct _eoifd {
> +	struct eventfd_ctx *eventfd;
> +	struct _irq_source *source; /* for de-asserting level irqfd */
> +	struct kvm *kvm;
> +	struct kvm_irq_ack_notifier notifier;
> +	struct list_head list;
> +};
> +
> +static void eoifd_event(struct kvm_irq_ack_notifier *notifier)
> +{
> +	struct _eoifd *eoifd;
> +
> +	eoifd = container_of(notifier, struct _eoifd, notifier);
> +
> +	/*
> +	 * If the eoifd is tied to a level irqfd we de-assert it here.
> +	 * The user is responsible for re-asserting it if their device
> +	 * still needs attention.  For notification-only, skip this.
> +	 */
> +	if (eoifd->source)
> +		kvm_set_irq(eoifd->kvm, eoifd->source->id,
> +			    eoifd->notifier.gsi, 0);
> +


This will fire even if the source in question did not assert an
interrupt in the first place.  This won't scale well if
the interrupt is shared. Don't we need to filter by source state?

> +	eventfd_signal(eoifd->eventfd, 1);
> +}
> +
> +static int kvm_assign_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
> +{
> +	struct eventfd_ctx *eventfd;
> +	struct _eoifd *eoifd, *tmp;
> +	struct _irq_source *source = NULL;
> +
> +	if (args->flags & KVM_EOIFD_FLAG_LEVEL_IRQFD) {
> +		struct _irqfd *irqfd = _irqfd_fdget(kvm, args->irqfd);
> +		if (IS_ERR(irqfd))
> +			return PTR_ERR(irqfd);
> +
> +		if (irqfd->gsi != args->gsi) {
> +			_irqfd_put(irqfd);
> +			return -EINVAL;
> +		}
> +

This requirement does not seem to be documented.
If we require this, do we need to pass in gsi at all?


> +		source = _irq_source_get(irqfd->source);
> +		_irqfd_put(irqfd);
> +		if (!source)
> +			return -EINVAL;
> +	}
> +
> +	eventfd = eventfd_ctx_fdget(args->fd);
> +	if (IS_ERR(eventfd)) {
> +		_irq_source_put(source);
> +		return PTR_ERR(eventfd);
> +	}
> +
> +	eoifd = kzalloc(sizeof(*eoifd), GFP_KERNEL);
> +	if (!eoifd) {
> +		_irq_source_put(source);
> +		eventfd_ctx_put(eventfd);
> +		return -ENOMEM;
> +	}
> +
> +	INIT_LIST_HEAD(&eoifd->list);
> +	eoifd->kvm = kvm;
> +	eoifd->eventfd = eventfd;
> +	eoifd->source = source;
> +	eoifd->notifier.gsi = args->gsi;
> +	eoifd->notifier.irq_acked = eoifd_event;
> +
> +	spin_lock_irq(&kvm->eoifds.lock);
> +
> +	list_for_each_entry(tmp, &kvm->eoifds.items, list) {
> +		if (eoifd->eventfd != tmp->eventfd)
> +			continue;
> +
> +		spin_unlock_irq(&kvm->eoifds.lock);
> +		_irq_source_put(source);
> +		eventfd_ctx_put(eventfd);
> +		kfree(eoifd);
> +		return -EBUSY;


Please rewrite this function using labels for error handling.


> +	}
> +
> +	list_add_tail(&eoifd->list, &kvm->eoifds.items);
> +
> +	spin_unlock_irq(&kvm->eoifds.lock);
> +
> +	kvm_register_irq_ack_notifier(kvm, &eoifd->notifier);
> +
> +	return 0;
> +}
> +
> +static void eoifd_deactivate(struct kvm *kvm, struct _eoifd *eoifd)

Pls find a less confusing name for this.
It just frees the eoifd. No tricky deactivation here (unlike irqfd).

> +{
> +	kvm_unregister_irq_ack_notifier(kvm, &eoifd->notifier);
> +	_irq_source_put(eoifd->source);
> +	eventfd_ctx_put(eoifd->eventfd);
> +	kfree(eoifd);
> +}
> +
> +void kvm_eoifd_release(struct kvm *kvm)
> +{
> +	spin_lock_irq(&kvm->eoifds.lock);
> +
> +	while (!list_empty(&kvm->eoifds.items)) {
> +		struct _eoifd *eoifd;
> +
> +		eoifd = list_first_entry(&kvm->eoifds.items,
> +					 struct _eoifd, list);
> +		list_del(&eoifd->list);
> +
> +		/* Drop spinlocks since eoifd_deactivate can sleep */
> +		spin_unlock_irq(&kvm->eoifds.lock);
> +		eoifd_deactivate(kvm, eoifd);
> +		spin_lock_irq(&kvm->eoifds.lock);
> +	}
> +
> +	spin_unlock_irq(&kvm->eoifds.lock);
> +}
> +
> +static int kvm_deassign_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
> +{
> +	struct eventfd_ctx *eventfd;
> +	struct _eoifd *tmp, *eoifd = NULL;
> +
> +	eventfd = eventfd_ctx_fdget(args->fd);
> +	if (IS_ERR(eventfd))
> +		return PTR_ERR(eventfd);
> +
> +	spin_lock_irq(&kvm->eoifds.lock);
> +
> +	list_for_each_entry(tmp, &kvm->eoifds.items, list) {
> +		if (tmp->eventfd == eventfd && tmp->notifier.gsi == args->gsi) {

This is repeated several times.
looks like eoifd_collision function is called for.

> +			eoifd = tmp;
> +			list_del(&eoifd->list);
> +			break;
> +		}
> +	}
> +
> +	spin_unlock_irq(&kvm->eoifds.lock);
> +
> +	eventfd_ctx_put(eventfd);
> +
> +	if (!eoifd)
> +		return -ENOENT;
> +
> +	eoifd_deactivate(kvm, eoifd);
> +
> +	return 0;
> +}
> +
> +int kvm_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
> +{
> +	if (args->flags & ~(KVM_EOIFD_FLAG_DEASSIGN |
> +			    KVM_EOIFD_FLAG_LEVEL_IRQFD))
> +		return -EINVAL;
> +
> +	if (args->flags & KVM_EOIFD_FLAG_DEASSIGN)
> +		return kvm_deassign_eoifd(kvm, args);
> +
> +	return kvm_assign_eoifd(kvm, args);
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b4ad14cc..5b41df1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -620,6 +620,8 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
>  
>  	kvm_irqfd_release(kvm);
>  
> +	kvm_eoifd_release(kvm);
> +
>  	kvm_put_kvm(kvm);
>  	return 0;
>  }
> @@ -2093,6 +2095,15 @@ static long kvm_vm_ioctl(struct file *filp,
>  		break;
>  	}
>  #endif
> +	case KVM_EOIFD: {
> +		struct kvm_eoifd data;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&data, argp, sizeof data))
> +			goto out;
> +		r = kvm_eoifd(kvm, &data);
> +		break;
> +	}
>  	default:
>  		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
>  		if (r == -ENOTTY)
