Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2GOQXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 12:23:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab2GOQXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 12:23:32 -0400
Date: Sun, 15 Jul 2012 19:23:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v4 2/3] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120715162344.GA17995@redhat.com>
References: <20120713192625.5474.60777.stgit@bling.home>
 <20120713194103.5474.54352.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713194103.5474.54352.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 01:41:05PM -0600, Alex Williamson wrote:
> This new ioctl enables an eventfd to be triggered when an EOI is
> written for a specified irqchip pin.  The first user of this will
> be external device assignment through VFIO, using a level irqfd
> for asserting a PCI INTx interrupt and this interface for de-assert
> and notification once the interrupt is serviced.
> 
> Here we make use of the reference counting of the _irq_source
> object allowing us to share it with an irqfd and cleanup regardless
> of the release order.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  Documentation/virtual/kvm/api.txt |   21 +++
>  arch/x86/kvm/x86.c                |    2 
>  include/linux/kvm.h               |   15 ++
>  include/linux/kvm_host.h          |   13 ++
>  virt/kvm/eventfd.c                |  226 +++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c               |   11 ++
>  6 files changed, 286 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index c7267d5..d5be635 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1988,6 +1988,27 @@ to independently assert level interrupts.  The KVM_IRQFD_FLAG_LEVEL
>  is only necessary on setup, teardown is identical to that above.
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
> +KVM_EOIFD allows userspace to receive interrupt EOI notification
> +through an eventfd.  kvm_eoifd.fd specifies the eventfd used for
> +notification.  KVM_EOIFD_FLAG_DEASSIGN is used to de-assign an eoifd
> +once assigned.  KVM_EOIFD also requires additional bits set in
> +kvm_eoifd.flags to bind to the proper interrupt line.  The
> +KVM_EOIFD_FLAG_LEVEL_IRQFD indicates that kvm_eoifd.irqfd is provided
> +and is an irqfd for a level triggered interrupt (configured from
> +KVM_IRQFD using KVM_IRQFD_FLAG_LEVEL).  The EOI notification is bound
> +to the same GSI and irqchip input as the irqfd.  Both kvm_eoifd.irqfd
> +and KVM_EOIFD_FLAG_LEVEL_IRQFD must be specified both on assignment
> +and de-assignment of KVM_EOIFD.  KVM_CAP_EOIFD_LEVEL_IRQFD indicates
> +support of KVM_EOIFD_FLAG_LEVEL_IRQFD.
> +
>  5. The kvm_run structure
>  ------------------------
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 80bed07..cc47e31 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2149,6 +2149,8 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_PCI_2_3:
>  	case KVM_CAP_KVMCLOCK_CTRL:
>  	case KVM_CAP_IRQFD_LEVEL:
> +	case KVM_CAP_EOIFD:
> +	case KVM_CAP_EOIFD_LEVEL_IRQFD:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index b2e6e4f..5ca887d 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -619,6 +619,8 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_S390_COW 79
>  #define KVM_CAP_PPC_ALLOC_HTAB 80
>  #define KVM_CAP_IRQFD_LEVEL 81
> +#define KVM_CAP_EOIFD 82
> +#define KVM_CAP_EOIFD_LEVEL_IRQFD 83
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -694,6 +696,17 @@ struct kvm_irqfd {
>  	__u8  pad[20];
>  };
>  
> +#define KVM_EOIFD_FLAG_DEASSIGN (1 << 0)
> +/* Available with KVM_CAP_EOIFD_LEVEL_IRQFD */
> +#define KVM_EOIFD_FLAG_LEVEL_IRQFD (1 << 1)
> +
> +struct kvm_eoifd {
> +	__u32 fd;
> +	__u32 flags;
> +	__u32 irqfd;
> +	__u8 pad[20];
> +};
> +
>  struct kvm_clock_data {
>  	__u64 clock;
>  	__u32 flags;
> @@ -834,6 +847,8 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_PPC_GET_SMMU_INFO	  _IOR(KVMIO,  0xa6, struct kvm_ppc_smmu_info)
>  /* Available with KVM_CAP_PPC_ALLOC_HTAB */
>  #define KVM_PPC_ALLOCATE_HTAB	  _IOWR(KVMIO, 0xa7, __u32)
> +/* Available with KVM_CAP_EOIFD */
> +#define KVM_EOIFD                 _IOW(KVMIO,  0xa8, struct kvm_eoifd)
>  
>  /*
>   * ioctls for vcpu fds
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae3b426..a7661c0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -285,6 +285,10 @@ struct kvm {
>  		struct list_head  items;
>  	} irqfds;
>  	struct list_head ioeventfds;
> +	struct {
> +		struct mutex lock;
> +		struct list_head items;
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
> index ecdbfea..2fae198 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -65,8 +65,7 @@ static void _irq_source_put(struct _irq_source *source)
>  		kref_put(&source->kref, _irq_source_release);
>  }
>  
> -static struct _irq_source *__attribute__ ((used)) /* white lie for now */
> -_irq_source_get(struct _irq_source *source)
> +static struct _irq_source *_irq_source_get(struct _irq_source *source)
>  {
>  	if (source)
>  		kref_get(&source->kref);
> @@ -123,6 +122,39 @@ struct _irqfd {
>  	struct work_struct shutdown;
>  };
>  
> +static struct _irqfd *_irqfd_fdget_lock(struct kvm *kvm, int fd)
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
> +	if (!irqfd) {
> +		spin_unlock_irq(&kvm->irqfds.lock);
> +		eventfd_ctx_put(eventfd);
> +		return ERR_PTR(-ENODEV);
> +	}
> +
> +	return irqfd;
> +}
> +
> +static void _irqfd_put_unlock(struct _irqfd *irqfd)
> +{
> +	eventfd_ctx_put(irqfd->eventfd);
> +	spin_unlock_irq(&irqfd->kvm->irqfds.lock);
> +}
> +
>  static struct workqueue_struct *irqfd_cleanup_wq;
>  
>  static void
> @@ -398,6 +430,8 @@ kvm_eventfd_init(struct kvm *kvm)
>  	spin_lock_init(&kvm->irqfds.lock);
>  	INIT_LIST_HEAD(&kvm->irqfds.items);
>  	INIT_LIST_HEAD(&kvm->ioeventfds);
> +	mutex_init(&kvm->eoifds.lock);
> +	INIT_LIST_HEAD(&kvm->eoifds.items);
>  }
>  
>  /*
> @@ -764,3 +798,191 @@ kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
>  
>  	return kvm_assign_ioeventfd(kvm, args);
>  }
> +
> +/*
> + * --------------------------------------------------------------------
> + *  eoifd: Translate KVM APIC/IOAPIC EOI into eventfd signal.
> + *
> + *  userspace can register with an eventfd for receiving
> + *  notification when an EOI occurs.
> + * --------------------------------------------------------------------
> + */
> +
> +struct _eoifd {
> +	/* eventfd triggered on EOI */
> +	struct eventfd_ctx *eventfd;
> +	/* irq source ID de-asserted on EOI */
> +	struct _irq_source *source;
> +	struct kvm *kvm;
> +	struct kvm_irq_ack_notifier notifier;
> +	/* reference to irqfd eventfd for de-assign matching */
> +	struct eventfd_ctx *level_irqfd;
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
> +	 * Ack notifier is per GSI, which may be shared with others.
> +	 * Only de-assert and send EOI if our source ID is asserted.
> +	 * User needs to re-assert if device still requires service.
> +	 */
> +	spin_lock(&eoifd->source->lock);
> +	if (eoifd->source->level_asserted) {
> +		kvm_set_irq(eoifd->kvm,
> +			    eoifd->source->id, eoifd->notifier.gsi, 0);


How about we add "clear" pic callback, in addition to set, and implement
kvm_set_irq with kvm_clear_irq which returns current status?

This would avoid the need for level_asserted and for locks, won't it?

-- 
MST
