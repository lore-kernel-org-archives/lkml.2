Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2HONsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:48:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab2HONsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:48:15 -0400
Date: Wed, 15 Aug 2012 16:49:18 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/6] kvm: Add IRQ source ID option to KVM_IRQFD
Message-ID: <20120815134918.GC3068@redhat.com>
References: <20120810223633.809.44188.stgit@bling.home>
 <20120810223731.809.67249.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120810223731.809.67249.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 04:37:33PM -0600, Alex Williamson wrote:
> This allows specifying an IRQ source ID to be used when injecting an
> interrupt.  When not specified KVM_USERSPACE_IRQ_SOURCE_ID is used.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  Documentation/virtual/kvm/api.txt |    5 +++++
>  arch/x86/kvm/x86.c                |    1 +
>  include/linux/kvm.h               |    6 +++++-
>  virt/kvm/eventfd.c                |   14 ++++++++++----
>  4 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 062cfd5..46f4b4d 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1946,6 +1946,11 @@ the guest using the specified gsi pin.  The irqfd is removed using
>  the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
>  and kvm_irqfd.gsi.
>  
> +When KVM_CAP_IRQFD_IRQ_SOURCE_ID is available, KVM_IRQFD supports the
> +KVM_IRQFD_FLAG_IRQ_SOURCE_ID which can be used to specify an IRQ
> +source ID (see KVM_IRQ_SOURCE_ID) to be used for the guest interrupt.
> +This flag has no effect on deassignment.
> +
>  4.76 KVM_PPC_ALLOCATE_HTAB
>  
>  Capability: KVM_CAP_PPC_ALLOC_HTAB
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 75e743e..946c5bd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2174,6 +2174,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_GET_TSC_KHZ:
>  	case KVM_CAP_PCI_2_3:
>  	case KVM_CAP_KVMCLOCK_CTRL:
> +	case KVM_CAP_IRQFD_IRQ_SOURCE_ID:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 67b6b49..deda8a9 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -619,6 +619,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_S390_COW 79
>  #define KVM_CAP_PPC_ALLOC_HTAB 80
>  #define KVM_CAP_NR_IRQ_SOURCE_ID 81
> +#define KVM_CAP_IRQFD_IRQ_SOURCE_ID 82
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -684,12 +685,15 @@ struct kvm_xen_hvm_config {
>  #endif
>  
>  #define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
> +/* Available with KVM_CAP_IRQFD_IRQ_SOURCE_ID */
> +#define KVM_IRQFD_FLAG_IRQ_SOURCE_ID (1 << 1)
>  
>  struct kvm_irqfd {
>  	__u32 fd;
>  	__u32 gsi;
>  	__u32 flags;
> -	__u8  pad[20];
> +	__u32 irq_source_id;
> +	__u8  pad[16];
>  };
>  
>  #define KVM_IRQ_SOURCE_ID_FLAG_DEASSIGN (1 << 0)
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 7d7e2aa..30150f1 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -51,6 +51,7 @@ struct _irqfd {
>  	struct kvm_kernel_irq_routing_entry __rcu *irq_entry;
>  	/* Used for level IRQ fast-path */
>  	int gsi;
> +	int irq_source_id;
>  	struct work_struct inject;
>  	/* Used for setup/shutdown */
>  	struct eventfd_ctx *eventfd;
> @@ -67,8 +68,8 @@ irqfd_inject(struct work_struct *work)
>  	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
>  	struct kvm *kvm = irqfd->kvm;
>  
> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> +	kvm_set_irq(kvm, irqfd->irq_source_id, irqfd->gsi, 1);
> +	kvm_set_irq(kvm, irqfd->irq_source_id, irqfd->gsi, 0);

Looks like this can lead to kernel data corruption if irq_source_id
specified it out of range?

>  }
>  
>  /*
> @@ -138,7 +139,7 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>  		irq = rcu_dereference(irqfd->irq_entry);
>  		/* An event has been signaled, inject an interrupt */
>  		if (irq)
> -			kvm_set_msi(irq, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1);
> +			kvm_set_msi(irq, kvm, irqfd->irq_source_id, 1);
>  		else
>  			schedule_work(&irqfd->inject);
>  		rcu_read_unlock();
> @@ -213,6 +214,10 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  
>  	irqfd->kvm = kvm;
>  	irqfd->gsi = args->gsi;
> +	if (args->flags & KVM_IRQFD_FLAG_IRQ_SOURCE_ID)
> +		irqfd->irq_source_id = args->irq_source_id;
> +	else
> +		irqfd->irq_source_id = KVM_USERSPACE_IRQ_SOURCE_ID;

As in the previous patch, there is no validation
that source id was previously allocated to userspace, so this makes life
harder for userspace: if it deassigns a used source ID the result is not
a clean failure but hard to find bugs.

>  	INIT_LIST_HEAD(&irqfd->list);
>  	INIT_WORK(&irqfd->inject, irqfd_inject);
>  	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
> @@ -340,7 +345,8 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
>  int
>  kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
>  {
> -	if (args->flags & ~KVM_IRQFD_FLAG_DEASSIGN)
> +	if (args->flags & ~(KVM_IRQFD_FLAG_DEASSIGN |
> +			    KVM_IRQFD_FLAG_IRQ_SOURCE_ID))
>  		return -EINVAL;
>  
>  	if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)
