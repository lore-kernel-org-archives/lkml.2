Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab2F0JtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:49:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab2F0JtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:49:13 -0400
Date: Wed, 27 Jun 2012 12:49:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 5/6] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120627094911.GG17507@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
 <20120627050952.23698.37235.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627050952.23698.37235.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:10:08PM -0600, Alex Williamson wrote:
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

Suggest you try running this with various lock checking
enabled. You should see interesting things, at least
one of which I found and point out below :)

> ---
> 
>  Documentation/virtual/kvm/api.txt |   24 +++++
>  arch/x86/kvm/x86.c                |    1 
>  include/linux/kvm.h               |   14 +++
>  include/linux/kvm_host.h          |   13 +++
>  virt/kvm/eventfd.c                |  189 +++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c               |   11 ++
>  6 files changed, 250 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index b216709..87a2558 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1987,6 +1987,30 @@ interrupts with those injected through KVM_IRQ_LINE.  IRQFDs created
>  with KVM_IRQFD_FLAG_LEVEL must also set this flag when de-assiging.
>  KVM_IRQFD_FLAG_LEVEL support is indicated by KVM_CAP_IRQFD_LEVEL.
>  
> +4.77 KVM_EOIFD
> +
> +Capability: KVM_CAP_EOIFD
> +Architectures: x86
> +Type: vm ioctl
> +Parameters: struct kvm_eoifd (in)
> +Returns: 0 on success, -1 on error
> +
> +KVM_EOIFD allows userspace to receive EOI notification through an
> +eventfd for level triggered irqchip interrupts.  Behavior for edge
> +triggered interrupts is undefined.  kvm_eoifd.fd specifies the eventfd
> +used for notification and kvm_eoifd.gsi specifies the irchip pin,
> +similar to KVM_IRQFD.  KVM_EOIFD_FLAG_DEASSIGN is used to deassign
> +a previously enabled eoifd and should also set fd and gsi to match.
> +
> +The KVM_EOIFD_FLAG_LEVEL_IRQFD flag indicates that the EOI is for
> +a level triggered EOI and the kvm_eoifd structure includes
> +kvm_eoifd.irqfd,

Actually it is always level, right? So we can just call it
KVM_EOIFD_FLAG_IRQFD?

> which must be previously configured using KVM_IRQFD
> +with the KVM_IRQFD_FLAG_LEVEL flag.  This allows both EOI notification
> +through kvm_eoifd.fd as well as automatically de-asserting level
> +irqfds on EOI.  Both KVM_EOIFD_FLAG_DEASSIGN and
> +KVM_EOIFD_FLAG_LEVEL_IRQFD should be used to de-assign an eoifd
> +initially setup with KVM_EOIFD_FLAG_LEVEL_IRQFD.

And do you also need to pass in same irqfd?

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
> index 18cc284..02ca50f 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -62,8 +62,7 @@ static void put_irq_source(struct _irq_source *source)
>  		kref_put(&source->kref, release_irq_source);
>  }
>  
> -static struct _irq_source *__attribute__ ((used)) /* white lie for now */
> -get_irq_source(struct _irq_source *source)
> +static struct _irq_source *get_irq_source(struct _irq_source *source)
>  {
>  	if (source)
>  		kref_get(&source->kref);
> @@ -118,6 +117,41 @@ struct _irqfd {
>  	struct work_struct shutdown;
>  };
>  
> +static struct _irq_source *get_irq_source_from_irqfd(struct kvm *kvm, int fd)
> +{
> +	struct file *file;
> +	struct eventfd_ctx *eventfd;
> +	struct _irqfd *irqfd;
> +	struct _irq_source *source = NULL;
> +
> +	file = fget(fd);
> +	if (!file)
> +		return ERR_PTR(-EBADF);
> +
> +	eventfd = eventfd_ctx_fileget(file);
> +	if (IS_ERR(eventfd)) {
> +		fput(file);
> +		return (struct _irq_source *)eventfd;
> +	}
> +
> +	spin_lock_irq(&kvm->irqfds.lock);
> +
> +	list_for_each_entry(irqfd, &kvm->irqfds.items, list) {
> +		if (irqfd->eventfd != eventfd)
> +			continue;
> +
> +		source = get_irq_source(irqfd->source);
> +		break;
> +	}
> +
> +	spin_unlock_irq(&kvm->irqfds.lock);
> +
> +	eventfd_ctx_put(eventfd);
> +	fput(file);
> +
> +	return source ? source : ERR_PTR(-ENODEV);
> +}
> +
>  static struct workqueue_struct *irqfd_cleanup_wq;
>  
>  static void
> @@ -375,6 +409,8 @@ kvm_eventfd_init(struct kvm *kvm)
>  	spin_lock_init(&kvm->irqfds.lock);
>  	INIT_LIST_HEAD(&kvm->irqfds.items);
>  	INIT_LIST_HEAD(&kvm->ioeventfds);
> +	spin_lock_init(&kvm->eoifds.lock);
> +	INIT_LIST_HEAD(&kvm->eoifds.items);
>  }
>  
>  /*
> @@ -743,3 +779,152 @@ kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
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
> +	struct kvm *kvm;
> +	struct eventfd_ctx *eventfd;
> +	struct _irq_source *source;

Need to document what this field does (ideally other
fields too). I think this is source we should clear?
So call it source_to_clear or something like that?

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
> +	if (eoifd->source)
> +		kvm_set_irq(eoifd->kvm, eoifd->source->id,
> +			    eoifd->notifier.gsi, 0);
> +
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
> +		source = get_irq_source_from_irqfd(kvm, args->irqfd);
> +		if (IS_ERR(source))
> +			return PTR_ERR(source);
> +	}
> +
> +	eventfd = eventfd_ctx_fdget(args->fd);
> +	if (IS_ERR(eventfd)) {
> +		put_irq_source(source);
> +		return PTR_ERR(eventfd);
> +	}
> +
> +	eoifd = kzalloc(sizeof(*eoifd), GFP_KERNEL);
> +	if (!eoifd) {
> +		put_irq_source(source);
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
> +		put_irq_source(source);
> +		eventfd_ctx_put(eventfd);
> +		kfree(eoifd);
> +		return -EBUSY;
> +	}
> +
> +	list_add_tail(&eoifd->list, &kvm->eoifds.items);
> +	kvm_register_irq_ack_notifier(kvm, &eoifd->notifier);
> +
> +	spin_unlock_irq(&kvm->eoifds.lock);
> +
> +	return 0;
> +}
> +
> +static void eoifd_deactivate(struct kvm *kvm, struct _eoifd *eoifd)
> +{
> +	list_del(&eoifd->list);
> +	kvm_unregister_irq_ack_notifier(kvm, &eoifd->notifier);

This can sleep so eoifd_deactivate can too.

> +	put_irq_source(eoifd->source);
> +	eventfd_ctx_put(eoifd->eventfd);
> +	kfree(eoifd);
> +}
> +
> +void kvm_eoifd_release(struct kvm *kvm)
> +{
> +	struct _eoifd *eoifd, *tmp;
> +
> +	spin_lock_irq(&kvm->eoifds.lock);
> +
> +	list_for_each_entry_safe(eoifd, tmp, &kvm->eoifds.items, list)
> +		eoifd_deactivate(kvm, eoifd);

sleeping function called under a spinlock here.

> +
> +	spin_unlock_irq(&kvm->eoifds.lock);
> +}
> +
> +static int kvm_deassign_eoifd(struct kvm *kvm, struct kvm_eoifd *args)
> +{
> +	struct eventfd_ctx *eventfd;
> +	struct _eoifd *eoifd;
> +	bool uses_source = (args->flags & KVM_EOIFD_FLAG_LEVEL_IRQFD) != 0;
> +	int ret = -ENODEV;
> +
> +	eventfd = eventfd_ctx_fdget(args->fd);
> +	if (IS_ERR(eventfd))
> +		return PTR_ERR(eventfd);
> +
> +	spin_lock_irq(&kvm->eoifds.lock);
> +
> +	list_for_each_entry(eoifd, &kvm->eoifds.items, list) {
> +		/*
> +		 * Matching eventfd is unique since we don't allow dulicates,


typo

> +		 * the rest is sanitizing the calling parameters.
> +		 */
> +		if (eoifd->eventfd == eventfd &&
> +		    eoifd->notifier.gsi == args->gsi &&
> +		    uses_source == (eoifd->source != NULL)) {
> +			eoifd_deactivate(kvm, eoifd);
> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	spin_unlock_irq(&kvm->eoifds.lock);
> +
> +	eventfd_ctx_put(eventfd);
> +
> +	return ret;
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
