Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab2HOOKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:10:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab2HOOKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:10:13 -0400
Date: Wed, 15 Aug 2012 17:11:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 6/6] kvm: Add de-assert option to KVM_IRQ_ACKFD
Message-ID: <20120815141113.GE3068@redhat.com>
References: <20120810223633.809.44188.stgit@bling.home>
 <20120810223754.809.60610.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120810223754.809.60610.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 04:37:56PM -0600, Alex Williamson wrote:
> It's likely (vfio) that one of the reasons to watch for an IRQ ACK
> is to de-assert and re-enable an interrupt.  As the IRQ ACK notfier
> is already watching a GSI for an IRQ source ID we can easily couple
> these together.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

This source id is required the only way to assert
in the 1st place is with irqfd.
So why is this an ackfd flag and not an irqfd flag?
I am guessing because this way you do not need
an extra ack notifier, but isn't this an internal
optimization leaking out to userspace?

> ---
> 
>  Documentation/virtual/kvm/api.txt |    4 ++++
>  arch/x86/kvm/x86.c                |    1 +
>  include/linux/kvm.h               |    3 +++
>  virt/kvm/eventfd.c                |   14 +++++++++++++-
>  4 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 77b4837..128d4c3 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2029,6 +2029,10 @@ the eventfd is only triggered when the specified IRQ source ID is
>  pending.  On deassign, fd, gsi, and irq_source_id (if provided on assign)
>  must be provided.
>  
> +When KVM_CAP_IRQ_ACKFD_DEASSERT is available the flag
> +KVM_IRQ_ACKFD_FLAG_IRQ_DEASSERT may be used on assignment to specify
> +that the GSI should be de-asserted prior to eventfd notification.
> +This flag requires an IRQ source ID to be provided as described above.
>  
>  5. The kvm_run structure
>  ------------------------
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3d98e59..691b00d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2178,6 +2178,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_IRQFD_ASSERT_ONLY:
>  	case KVM_CAP_IRQ_ACKFD:
>  	case KVM_CAP_IRQ_ACKFD_IRQ_SOURCE_ID:
> +	case KVM_CAP_IRQ_ACKFD_DEASSERT:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 0f53bd5..331631e 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -623,6 +623,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_IRQFD_ASSERT_ONLY 83
>  #define KVM_CAP_IRQ_ACKFD 84
>  #define KVM_CAP_IRQ_ACKFD_IRQ_SOURCE_ID 85
> +#define KVM_CAP_IRQ_ACKFD_DEASSERT 86
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -712,6 +713,8 @@ struct kvm_irq_source_id {
>  #define KVM_IRQ_ACKFD_FLAG_DEASSIGN (1 << 0)
>  /* Available with KVM_CAP_IRQ_ACKFD_IRQ_SOURCE_ID */
>  #define KVM_IRQ_ACKFD_FLAG_IRQ_SOURCE_ID (1 << 1)
> +/* Available with KVM_CAP_IRQ_ACKFD_DEASSERT */
> +#define KVM_IRQ_ACKFD_FLAG_DEASSERT (1 << 2)
>  
>  struct kvm_irq_ackfd {
>  	__u32 flags;
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index ff5c784..ffc6a13 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -682,6 +682,7 @@ kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
>  
>  struct _irq_ackfd {
>  	struct kvm *kvm;
> +	bool deassert; /* de-assert on ack? */
>  	struct eventfd_ctx *eventfd; /* signaled on ack */
>  	struct kvm_irq_ack_notifier notifier;
>  	/* Setup/shutdown */
> @@ -805,6 +806,10 @@ static void irq_ackfd_acked(struct kvm_irq_ack_notifier *notifier)
>  
>  	ackfd = container_of(notifier, struct _irq_ackfd, notifier);
>  
> +	if (ackfd->deassert)
> +		kvm_set_irq(ackfd->kvm, ackfd->notifier.irq_source_id,
> +			    ackfd->notifier.gsi, 0);
> +
>  	eventfd_signal(ackfd->eventfd, 1);
>  }
>  
> @@ -845,6 +850,12 @@ static int kvm_assign_irq_ackfd(struct kvm *kvm, struct kvm_irq_ackfd *args)
>  		ackfd->notifier.irq_source_id = -1;
>  	ackfd->notifier.irq_acked = irq_ackfd_acked;
>  
> +	ackfd->deassert = args->flags & KVM_IRQ_ACKFD_FLAG_DEASSERT;
> +	if (ackfd->deassert && ackfd->notifier.irq_source_id < 0) {
> +		ret = -EINVAL;
> +		goto fail;
> +	}
> +
>  	/*
>  	 * Install our own custom wake-up handling so we are notified via
>  	 * a callback whenever someone releases the underlying eventfd
> @@ -945,7 +956,8 @@ fail:
>  int kvm_irq_ackfd(struct kvm *kvm, struct kvm_irq_ackfd *args)
>  {
>  	if (args->flags & ~(KVM_IRQ_ACKFD_FLAG_DEASSIGN |
> -			    KVM_IRQ_ACKFD_FLAG_IRQ_SOURCE_ID))
> +			    KVM_IRQ_ACKFD_FLAG_IRQ_SOURCE_ID |
> +			    KVM_IRQ_ACKFD_FLAG_DEASSERT))
>  		return -EINVAL;
>  
>  	if (args->flags & KVM_IRQ_ACKFD_FLAG_DEASSIGN)
