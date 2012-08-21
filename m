Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab2HUUgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:36:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758322Ab2HUUgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:36:37 -0400
Date: Tue, 21 Aug 2012 23:37:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/2] kvm: On Ack, De-assert & Notify KVM_IRQFD
 extension
Message-ID: <20120821203739.GE9027@redhat.com>
References: <20120821190800.24958.74812.stgit@bling.home>
 <20120821192911.24958.38609.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821192911.24958.38609.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 01:29:14PM -0600, Alex Williamson wrote:
> For VFIO based device assignment we'd like a mechanism to allow level
> triggered interrutps to be directly injected into KVM.  KVM_IRQFD
> already allows this for edge triggered interrupts, but for level, we
> need to watch for acknowledgement of the interrupt from the guest to
> provide us a hint when to test the device and allow it to re-assert
> if necessary.  To do this, we create a new KVM_IRQFD mode called
> "On Ack, De-assert & Notify", or OADN.  In this mode, an interrupt
> injection provides only a gsi assertion.  We then hook into the IRQ
> ACK notifier, which when triggered de-asserts the gsi and notifies
> via another eventfd.  It's then the responsibility of the user to
> re-assert the interrupt is service is still required.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Naming aside, looks good.
I think I see some minor bugs, and I added some improvement
suggestions below.

Thanks!

> ---
> 
>  Documentation/virtual/kvm/api.txt |   13 ++
>  arch/x86/kvm/x86.c                |    1 
>  include/linux/kvm.h               |    6 +
>  include/linux/kvm_host.h          |    1 
>  virt/kvm/eventfd.c                |  193 ++++++++++++++++++++++++++++++++++++-
>  5 files changed, 210 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index bf33aaa..87d7321 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1946,6 +1946,19 @@ the guest using the specified gsi pin.  The irqfd is removed using
>  the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
>  and kvm_irqfd.gsi.
>  
> +With KVM_CAP_IRQFD_OADN, KVM_IRQFD supports an "On Ack, De-assert &
> +Notify" option that allows emulation of level-triggered interrupts.
> +When kvm_irqfd.fd is triggered, the requested gsi is asserted and
> +remains asserted until interaction with the irqchip indicates the
> +VM has acknowledged the interrupt, such as an EOI.  On acknoledgement
> +the gsi is automatically de-asserted and the user is notified via
> +kvm_irqfd.notifyfd.  The user is then required to re-assert the
> +interrupt if the associated device still requires service.  To enable
> +this mode, configure the KVM_IRQFD using the KVM_IRQFD_FLAG_OADN flag
> +and specify kvm_irqfd.notifyfd.  Note that closing kvm_irqfd.notifyfd
> +while configured in this mode does not disable the irqfd.  The
> +KVM_IRQFD_FLAG_OADN flag is only necessary on assignment.
> +
>  4.76 KVM_PPC_ALLOCATE_HTAB
>  
>  Capability: KVM_CAP_PPC_ALLOC_HTAB
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cd98673..fde7b66 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2175,6 +2175,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_PCI_2_3:
>  	case KVM_CAP_KVMCLOCK_CTRL:
>  	case KVM_CAP_IRQFD_IRQ_SOURCE_ID:
> +	case KVM_CAP_IRQFD_OADN:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index ae66b9c..ec0f1d8 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -619,6 +619,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_S390_COW 79
>  #define KVM_CAP_PPC_ALLOC_HTAB 80
>  #define KVM_CAP_IRQFD_IRQ_SOURCE_ID 81
> +#define KVM_CAP_IRQFD_OADN 82
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -684,12 +685,15 @@ struct kvm_xen_hvm_config {
>  #endif
>  
>  #define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
> +/* Availabie with KVM_CAP_IRQFD_OADN */

Need to also explain what it is.

> +#define KVM_IRQFD_FLAG_OADN (1 << 1)
>  
>  struct kvm_irqfd {
>  	__u32 fd;
>  	__u32 gsi;
>  	__u32 flags;
> -	__u8  pad[20];
> +	__u32 notifyfd;

Document that this is only valid with OADN flag.  Might be a good idea
to rename this to deassert_on_ack_notifyfd or oadn_notifyfd
to avoid confusion.


> +	__u8  pad[16];
>  };
>  
>  struct kvm_clock_data {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index b763230..d502d08 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -284,6 +284,7 @@ struct kvm {
>  	struct {
>  		spinlock_t        lock;
>  		struct list_head  items;
> +		struct list_head  oadns;
>  	} irqfds;
>  	struct list_head ioeventfds;
>  #endif
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 2245cfa..dfdb5b2 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -43,6 +43,23 @@
>   * --------------------------------------------------------------------
>   */
>  
> +/*
> + * OADN irqfds (On Ack, De-assert & Notify) are a special variety of
> + * irqfds that assert an interrupt to the irqchip on eventfd trigger,
> + * receieve notification when userspace acknowledges the interrupt,
> + * automatically de-asserts the irqchip level, and notifies userspace
> + * via the oadn_eventfd.  This object helps to provide one-to-many
> + * deassert-to-notify so we can share a single irq source ID per OADN.
> + */
> +struct _irqfd_oadn {
> +	struct kvm *kvm;
> +	int irq_source_id; /* IRQ source ID shared by these irqfds */
> +	struct list_head irqfds; /* list of irqfds using this object */
> +	struct kvm_irq_ack_notifier notifier; /* IRQ ACK notification */
> +	struct kref kref; /* Race-free removal */
> +	struct list_head list;
> +};
> +
>  struct _irqfd {
>  	/* Used for MSI fast-path */
>  	struct kvm *kvm;
> @@ -52,6 +69,10 @@ struct _irqfd {
>  	/* Used for level IRQ fast-path */
>  	int gsi;
>  	struct work_struct inject;
> +	/* Used for OADN (On Ack, De-assert & Notify) path */
> +	struct eventfd_ctx *oadn_eventfd;
> +	struct list_head oadn_list;

Could you document RCU and locking rules for this field please?

> +	struct _irqfd_oadn *oadn;
>  	/* Used for setup/shutdown */
>  	struct eventfd_ctx *eventfd;
>  	struct list_head list;
> @@ -71,6 +92,51 @@ irqfd_inject(struct work_struct *work)
>  	kvm_set_irq(kvm, KVM_IRQFD_IRQ_SOURCE_ID, irqfd->gsi, 0);
>  }
>  
> +static void
> +irqfd_oadn_inject(struct work_struct *work)
> +{
> +	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
> +
> +	kvm_set_irq(irqfd->kvm, irqfd->oadn->irq_source_id, irqfd->gsi, 1);
> +}
> +
> +/*
> + * Since OADN irqfds share an IRQ source ID, we de-assert once then
> + * notify all of the OADN irqfds using this GSI.  We can't do multiple
> + * de-asserts or we risk racing with incoming re-asserts.
> + */
> +static void
> +irqfd_oadn_notify(struct kvm_irq_ack_notifier *kian)
> +{
> +	struct _irqfd_oadn *oadn;
> +	struct _irqfd *irqfd;
> +
> +	oadn = container_of(kian, struct _irqfd_oadn, notifier);
> +
> +	rcu_read_lock();
> +
> +	kvm_set_irq(oadn->kvm, oadn->irq_source_id,
> +		    oadn->notifier.gsi, 0);
> +
> +	list_for_each_entry_rcu(irqfd, &oadn->irqfds, oadn_list)
> +		eventfd_signal(irqfd->oadn_eventfd, 1);
> +
> +	rcu_read_unlock();
> +}
> +
> +/*
> + * Assumes kvm->irqfds.lock is held.  Remove from the list of OADNs, new
> + * users will allocate their own, letting us de-assert this GSI on free,
> + * after the RCU grace period.
> + */
> +static void
> +irqfd_oadn_release(struct kref *kref)
> +{
> +	struct _irqfd_oadn *oadn = container_of(kref, struct _irqfd_oadn, kref);
> +
> +	list_del(&oadn->list);
> +}
> +
>  /*
>   * Race-free decouple logic (ordering is critical)
>   */
> @@ -93,6 +159,35 @@ irqfd_shutdown(struct work_struct *work)
>  	flush_work_sync(&irqfd->inject);
>  
>  	/*
> +	 * OADN irqfds use an RCU list for lockless de-assert and user
> +	 * notification.  Modify the list using RCU under lock and release
> +	 * the OADN object.  Since we later free this irqfd, we must wait
> +	 * for an RCU grace period.  If the OADN was released, we can then
> +	 * unregister the irq ack notifier, free the irq source ID (assuring
> +	 * that the GSI is de-asserted), and free the object.
> +	 */
> +	if (irqfd->oadn) {
> +		struct _irqfd_oadn *oadn = irqfd->oadn;
> +		struct kvm *kvm = oadn->kvm;
> +		bool released;
> +
> +		spin_lock_irq(&irqfd->kvm->irqfds.lock);
> +		list_del_rcu(&irqfd->oadn_list);
> +		released = kref_put(&oadn->kref, irqfd_oadn_release);
> +		spin_unlock_irq(&irqfd->kvm->irqfds.lock);
> +
> +		synchronize_rcu();
> +
> +		if (released) {
> +			kvm_unregister_irq_ack_notifier(kvm, &oadn->notifier);
> +			kvm_free_irq_source_id(kvm, oadn->irq_source_id);
> +			kfree(oadn);
> +		}
> +
> +		eventfd_ctx_put(irqfd->oadn_eventfd);
> +	}
> +
> +	/*
>  	 * It is now safe to release the object's resources
>  	 */
>  	eventfd_ctx_put(irqfd->eventfd);
> @@ -202,8 +297,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  {
>  	struct kvm_irq_routing_table *irq_rt;
>  	struct _irqfd *irqfd, *tmp;
> +	struct _irqfd_oadn *oadn = NULL;
>  	struct file *file = NULL;
> -	struct eventfd_ctx *eventfd = NULL;
> +	struct eventfd_ctx *eventfd = NULL, *oadn_eventfd = NULL;
>  	int ret;
>  	unsigned int events;
>  
> @@ -214,7 +310,49 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  	irqfd->kvm = kvm;
>  	irqfd->gsi = args->gsi;
>  	INIT_LIST_HEAD(&irqfd->list);
> -	INIT_WORK(&irqfd->inject, irqfd_inject);
> +	INIT_LIST_HEAD(&irqfd->oadn_list);
> +
> +	if (args->flags & KVM_IRQFD_FLAG_OADN) {
> +		oadn_eventfd = eventfd_ctx_fdget(args->notifyfd);
> +		if (IS_ERR(oadn_eventfd)) {
> +			ret = PTR_ERR(oadn_eventfd);
> +			goto fail;
> +		}
> +
> +		irqfd->oadn_eventfd = oadn_eventfd;
> +
> +		/*
> +		 * We may be able to share an existing OADN, but we won't
> +		 * know that until we search under spinlock.  We can't get
> +		 * an irq_source_id under spinlock, and we'd prefer not to
> +		 * do an atomic allocation, so prep an object here and free
> +		 * it if we don't need it.
> +		 */

So if everyone uses same source ID this code will be simpler too?

> +		oadn = kzalloc(sizeof(*oadn), GFP_KERNEL);
> +		if (!oadn) {
> +			ret = -ENOMEM;
> +			goto fail;
> +		}
> +
> +		oadn->kvm = kvm;
> +		INIT_LIST_HEAD(&oadn->irqfds);
> +		oadn->notifier.gsi = irqfd->gsi;
> +		oadn->notifier.irq_acked = irqfd_oadn_notify;
> +		kref_init(&oadn->kref);
> +		INIT_LIST_HEAD(&oadn->list);
> +
> +		oadn->irq_source_id = kvm_request_irq_source_id(kvm);
> +		if (oadn->irq_source_id < 0) {
> +			ret = oadn->irq_source_id;
> +			goto fail;
> +		}
> +

This still has the problem that by allocating these
OADN irqfds you can run out of source IDs for other uses.
Why don't OADNs just use KVM_IRQFD_IRQ_SOURCE_ID?
I thought this is why it was introduced in this patchset ...


> +		irqfd->oadn = oadn;
> +
> +		INIT_WORK(&irqfd->inject, irqfd_oadn_inject);
> +	} else
> +		INIT_WORK(&irqfd->inject, irqfd_inject);
> +
>  	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
>  
>  	file = eventfd_fget(args->fd);
> @@ -250,6 +388,27 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  		goto fail;
>  	}
>  
> +	/*
> +	 * When configuring an OADN irqfd, try to re-use an existing OADN.
> +	 */
> +	if (oadn) {
> +		struct _irqfd_oadn *oadn_tmp;
> +
> +		list_for_each_entry(oadn_tmp, &kvm->irqfds.oadns, list) {
> +			if (oadn_tmp->notifier.gsi == irqfd->gsi) {
> +				irqfd->oadn = oadn_tmp;
> +				break;
> +			}
> +		}
> +
> +		if (irqfd->oadn != oadn)
> +			kref_get(&irqfd->oadn->kref);
> +		else
> +			list_add(&oadn->list, &kvm->irqfds.oadns);
> +
> +		list_add_rcu(&irqfd->oadn_list, &irqfd->oadn->irqfds);

Hang on, don't we need irqfds_lock here? 

> +	}
> +
>  	irq_rt = rcu_dereference_protected(kvm->irq_routing,
>  					   lockdep_is_held(&kvm->irqfds.lock));
>  	irqfd_update(kvm, irqfd, irq_rt);
> @@ -267,6 +426,26 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  
>  	spin_unlock_irq(&kvm->irqfds.lock);
>  
> +	if (oadn) {
> +		synchronize_rcu();

Seems unexpected on assign.
What does this synchronize_rcu do?

> +
> +		/*
> +		 * If we weren't able to re-use an OADN, setup the irq ack
> +		 * notifier outside of spinlock.  Our interface requires
> +		 * users to be able to handle spurious de-assert & notifies,
> +		 * so trigger one here to make sure we didn't miss anything.
> +		 * Cleanup unused OADN if we share.
> +		 */
> +		if (irqfd->oadn == oadn)
> +			kvm_register_irq_ack_notifier(kvm, &oadn->notifier);
> +		else {
> +			kvm_free_irq_source_id(kvm, oadn->irq_source_id);

This is unfortunate - so we need a spare source ID for internal use.
Thus if 1 source ID is available, then it is possible that

- allocate irqfd for A
- allocate irqfd for B

succeeds because A uses a shared source id so it is freed here.

While

- allocate irqfd for B
- allocate irqfd for A

fails because B used the last ID and now temporary allocation
above fails.

> +			kfree(oadn);
> +		}
> +
> +		irqfd_oadn_notify(&irqfd->oadn->notifier);
> +	}
> +
>  	/*
>  	 * do not drop the file until the irqfd is fully initialized, otherwise
>  	 * we might race against the POLLHUP
> @@ -276,12 +455,19 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  	return 0;
>  
>  fail:
> +	if (oadn_eventfd && !IS_ERR(oadn_eventfd))
> +		eventfd_ctx_put(oadn_eventfd);
> +
> +	if (oadn && oadn->irq_source_id >= 0)
> +		kvm_free_irq_source_id(kvm, oadn->irq_source_id);
> +

A bit cleaner to have distinct labels for failures
at different stages of the setup.
I know it's not written this way ATM so it's not a must
to address this.

>  	if (eventfd && !IS_ERR(eventfd))
>  		eventfd_ctx_put(eventfd);
>  
>  	if (!IS_ERR(file))
>  		fput(file);
>  
> +	kfree(oadn);
>  	kfree(irqfd);
>  	return ret;
>  }
> @@ -291,6 +477,7 @@ kvm_eventfd_init(struct kvm *kvm)
>  {
>  	spin_lock_init(&kvm->irqfds.lock);
>  	INIT_LIST_HEAD(&kvm->irqfds.items);
> +	INIT_LIST_HEAD(&kvm->irqfds.oadns);
>  	INIT_LIST_HEAD(&kvm->ioeventfds);
>  }
>  
> @@ -340,7 +527,7 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
>  int
>  kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
>  {
> -	if (args->flags & ~KVM_IRQFD_FLAG_DEASSIGN)
> +	if (args->flags & ~(KVM_IRQFD_FLAG_DEASSIGN | KVM_IRQFD_FLAG_OADN))
>  		return -EINVAL;
>  
>  	if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)
