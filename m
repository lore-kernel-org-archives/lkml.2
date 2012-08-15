Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2HORF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:05:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab2HORFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:05:24 -0400
Message-ID: <1345050323.4683.409.camel@ul30vt.home>
Subject: Re: [PATCH v8 2/6] kvm: Expose IRQ source IDs to userspace
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 15 Aug 2012 11:05:23 -0600
In-Reply-To: <20120815125915.GB3068@redhat.com>
References: <20120810223633.809.44188.stgit@bling.home>
	 <20120810223723.809.33669.stgit@bling.home>
	 <20120815125915.GB3068@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 15:59 +0300, Michael S. Tsirkin wrote:
> On Fri, Aug 10, 2012 at 04:37:25PM -0600, Alex Williamson wrote:
> > Introduce KVM_IRQ_SOURCE_ID and KVM_CAP_NR_IRQ_SOURCE_ID to allow
> > user allocation of IRQ source IDs and querying both the capability
> > and the total count of IRQ source IDs.  These will later be used
> > by interfaces for setting up level IRQs.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> >  Documentation/virtual/kvm/api.txt |   20 ++++++++++++++++++++
> >  arch/x86/kvm/Kconfig              |    1 +
> >  arch/x86/kvm/x86.c                |    3 +++
> >  include/linux/kvm.h               |   11 +++++++++++
> >  include/linux/kvm_host.h          |    1 +
> >  virt/kvm/Kconfig                  |    3 +++
> >  virt/kvm/irq_comm.c               |   22 ++++++++++++++++++++++
> >  virt/kvm/kvm_main.c               |   16 ++++++++++++++++
> >  8 files changed, 77 insertions(+)
> > 
> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > index bf33aaa..062cfd5 100644
> > --- a/Documentation/virtual/kvm/api.txt
> > +++ b/Documentation/virtual/kvm/api.txt
> > @@ -1980,6 +1980,26 @@ return the hash table order in the parameter.  (If the guest is using
> >  the virtualized real-mode area (VRMA) facility, the kernel will
> >  re-create the VMRA HPTEs on the next KVM_RUN of any vcpu.)
> >  
> > +4.77 KVM_IRQ_SOURCE_ID
> > +
> > +Capability: KVM_CAP_NR_IRQ_SOURCE_ID
> > +Architectures: x86
> > +Type: vm ioctl
> > +Parameters: struct kvm_irq_source_id (in/out)
> > +Returns: 0 on success, -errno on error
> > +
> > +Allows allocating and freeing IRQ source IDs.  Each IRQ source ID
> > +represents a complete set of irqchip pin inputs which are logically
> > +OR'd with other IRQ source IDs for determining the final assertion
> > +level of a pin.  The flag KVM_IRQ_SOURCE_ID_FLAG_DEASSIGN indicates
> > +whether the call is for an allocation or deallocation.
> > +kvm_irq_source_id.irq_source_id returns the allocated IRQ source ID
> > +on success and specifies the freed IRQ source ID on deassign.  The
> > +return value of KVM_CAP_NR_IRQ_SOURCE_ID indicates the total number
> > +of IRQ source IDs.  These IDs are also shared with KVM internal users
> > +(ex. KVM assigned devices, PIT, shared user ID), therefore not all IDs
> > +may be allocated through this interface.
> > +
> >  5. The kvm_run structure
> >  ------------------------
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index a28f338..bfd2082 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -37,6 +37,7 @@ config KVM
> >  	select TASK_DELAY_ACCT
> >  	select PERF_EVENTS
> >  	select HAVE_KVM_MSI
> > +	select HAVE_KVM_IRQ_SOURCE_ID
> >  	---help---
> >  	  Support hosting fully virtualized guest machines using hardware
> >  	  virtualization extensions.  You will need a fairly recent
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 42bce48..75e743e 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2209,6 +2209,9 @@ int kvm_dev_ioctl_check_extension(long ext)
> >  	case KVM_CAP_TSC_DEADLINE_TIMER:
> >  		r = boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER);
> >  		break;
> > +	case KVM_CAP_NR_IRQ_SOURCE_ID:
> > +		r = BITS_PER_LONG; /* kvm->arch.irq_sources_bitmap */
> > +		break;
> >  	default:
> >  		r = 0;
> >  		break;
> > diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> > index 2ce09aa..67b6b49 100644
> > --- a/include/linux/kvm.h
> > +++ b/include/linux/kvm.h
> > @@ -618,6 +618,7 @@ struct kvm_ppc_smmu_info {
> >  #define KVM_CAP_PPC_GET_SMMU_INFO 78
> >  #define KVM_CAP_S390_COW 79
> >  #define KVM_CAP_PPC_ALLOC_HTAB 80
> > +#define KVM_CAP_NR_IRQ_SOURCE_ID 81
> >  
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >  
> > @@ -691,6 +692,14 @@ struct kvm_irqfd {
> >  	__u8  pad[20];
> >  };
> >  
> > +#define KVM_IRQ_SOURCE_ID_FLAG_DEASSIGN (1 << 0)
> > +
> > +struct kvm_irq_source_id {
> > +	__u32 flags;
> > +	__u32 irq_source_id;
> > +	__u8 pad[24];
> > +};
> > +
> >  struct kvm_clock_data {
> >  	__u64 clock;
> >  	__u32 flags;
> > @@ -831,6 +840,8 @@ struct kvm_s390_ucas_mapping {
> >  #define KVM_PPC_GET_SMMU_INFO	  _IOR(KVMIO,  0xa6, struct kvm_ppc_smmu_info)
> >  /* Available with KVM_CAP_PPC_ALLOC_HTAB */
> >  #define KVM_PPC_ALLOCATE_HTAB	  _IOWR(KVMIO, 0xa7, __u32)
> > +/* Available with KVM_CAP_IRQ_SOURCE_ID */
> > +#define KVM_IRQ_SOURCE_ID         _IOWR(KVMIO, 0xa8, struct kvm_irq_source_id)
> >  
> >  /*
> >   * ioctls for vcpu fds
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 2ad3e4a..ea6d7a1 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -636,6 +636,7 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
> >  				   struct kvm_irq_ack_notifier *kian);
> >  int kvm_request_irq_source_id(struct kvm *kvm);
> >  void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
> > +int kvm_irq_source_id(struct kvm *kvm, struct kvm_irq_source_id *id);
> >  
> >  /* For vcpu->arch.iommu_flags */
> >  #define KVM_IOMMU_CACHE_COHERENCY	0x1
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 28694f4..b7e0d4d 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -21,3 +21,6 @@ config KVM_ASYNC_PF
> >  
> >  config HAVE_KVM_MSI
> >         bool
> > +
> > +config HAVE_KVM_IRQ_SOURCE_ID
> > +       bool
> > diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> > index 7d75126..44d40c9 100644
> > --- a/virt/kvm/irq_comm.c
> > +++ b/virt/kvm/irq_comm.c
> > @@ -254,6 +254,28 @@ unlock:
> >  	mutex_unlock(&kvm->irq_lock);
> >  }
> >  
> > +int kvm_irq_source_id(struct kvm *kvm, struct kvm_irq_source_id *id)
> > +{
> > +	int irq_source_id;
> > +
> > +	if (id->flags & ~KVM_IRQ_SOURCE_ID_FLAG_DEASSIGN)
> > +		return -EINVAL;
> > +
> > +	if (id->flags & KVM_IRQ_SOURCE_ID_FLAG_DEASSIGN) {
> > +		if (id->irq_source_id == KVM_USERSPACE_IRQ_SOURCE_ID)
> > +			return -EINVAL;
> 
> This validation here is probably a work around
> for assert in kvm_free_irq_source_id?
> It would be good to add a comment explaining this,
> or just drop assert in kvm_free_irq_source_id.

I think we have to keep KVM_USERSPACE_IRQ_SOURCE_ID protected, but maybe
the way to do that would be to keep a bitmap of user allocated IDs so
that userspace can only free the correct IDs.

> Also, kvm_free_irq_source_id prints error messages
> if you give it an invalid value, so
> this let userspace flood kernel log with error messages.

This would also be prevented with the bitmap I mention above.

> > +		kvm_free_irq_source_id(kvm, id->irq_source_id);
> > +		return 0;
> > +	}
> > +
> 
> Hmm. This will let buggy userspace deassign IDs such as PIT that it
> never assigned. I think it will only break itself so it should be
> harmless, but it would seem to work with subtle
> interrupt-losing races, so maybe it would be nicer if we could
> validate the ID was actually given to userspace at some point.

Yep, we need to keep a bitmap.

> > +	irq_source_id = kvm_request_irq_source_id(kvm);
> 
> kvm_request_irq_source_id was not intended to be called
> by userspace so it behaves a bit strangely:
> - If you call this too many times you let userspace flood
>   kernel log with warnings

This printk would need to go away, returning error should be sufficient.

> - return value is -EFAULT which is ignored by another caller
>   but passed to userspace here, arguably wrong

ENOSPC would be a more appropriate return from
kvm_request_irq_source_id.  I'm not seeing which user ignores the return
value, pit returns NULL and device assignment returns the error value.

> > +	if (irq_source_id < 0)
> > +		return irq_source_id;
> > +
> > +	id->irq_source_id = irq_source_id;
> > +	return 0;
> > +}
> > +
> 
> There is a minor bug here: if you call this too many times then following
> PIT and assigned device allocation will fail.
> 
> This is in contrast to documentation which says that
> getting source id will fail in this case,
> and generally gives userspace no way to detect
> what went wrong and recover: it only sees ENOMEM.

Seems like a pit bug for the return value.  I agree though, it's
difficult to debug.

> 
> One solution I see is split the source ID space, give half to userspace
> and half to internal users.

I agree that pit should have priority and maybe x86 should hard code
which source ID it makes use of like KVM_USERSPACE_IRQ_SOURCE_ID.  It
could be statically reserved.  KVM device assignment doesn't deserve
reserved IDs though, it's the same class of device as the intended
caller of these interfaces.  

Summary:
      * Need bitmap for tracking user allocated/freed IDs
      * Reserve ID for PIT
      * Evaluate return values

Thanks,

Alex

> >  void kvm_register_irq_mask_notifier(struct kvm *kvm, int irq,
> >  				    struct kvm_irq_mask_notifier *kimn)
> >  {
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 2468523..e120cb3 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2093,6 +2093,22 @@ static long kvm_vm_ioctl(struct file *filp,
> >  		break;
> >  	}
> >  #endif
> > +#ifdef CONFIG_HAVE_KVM_IRQ_SOURCE_ID
> > +	case KVM_IRQ_SOURCE_ID: {
> > +		struct kvm_irq_source_id id;
> > +
> > +		r = -EFAULT;
> > +		if (copy_from_user(&id, argp, sizeof(id)))
> > +			goto out;
> > +
> > +		r = kvm_irq_source_id(kvm, &id);
> > +		if (!r && copy_to_user(argp, &id, sizeof(id))) {
> > +			r = -EFAULT;
> > +			goto out;
> > +		}
> > +		break;
> > +	}
> > +#endif
> >  	default:
> >  		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
> >  		if (r == -ENOTTY)



