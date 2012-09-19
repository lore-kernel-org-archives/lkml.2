Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2ISI7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 04:59:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab2ISI7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 04:59:36 -0400
Message-ID: <50598975.50503@redhat.com>
Date: Wed, 19 Sep 2012 11:59:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/2] kvm: Add resampling irqfds for level triggered
 interrupts
References: <20120918031156.12021.27838.stgit@bling.home> <20120918031626.12021.90083.stgit@bling.home>
In-Reply-To: <20120918031626.12021.90083.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 06:16 AM, Alex Williamson wrote:
> To emulate level triggered interrupts, add a resample option to
> KVM_IRQFD.  When specified, a new resamplefd is provided that notifies
> the user when the irqchip has been resampled by the VM.  This may, for
> instance, indicate an EOI.  Also in this mode, injection of an

s/inject/post (or queue)/ everywhere, please.  'Inject' implies
something immediate, this is very asynchronous both in terms of host and
guest behaviour.  Yes, the existing code is guilty too.

> interrupt through an irqfd only asserts the interrupt.  On resampling,
> the interrupt is automatically de-asserted prior to user notification.
> This enables level triggered interrupts to be injected and re-enabled
> from vfio with no userspace intervention.
> 
> All resampling irqfds can make use of a single irq source ID, so we
> reserve a new one for this interface.
> 
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index bf33aaa..d30af74 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1946,6 +1946,19 @@ the guest using the specified gsi pin.  The irqfd is removed using
>  the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
>  and kvm_irqfd.gsi.
>  
> +With KVM_CAP_IRQFD_RESAMPLE, KVM_IRQFD supports a de-assert and notify
> +mechanism allowing emulation of level-triggered, irqfd-based
> +interrupts.  When KVM_IRQFD_FLAG_RESAMPLE is set the user must pass an
> +additional eventfd in the kvm_irqfd.resamplefd field.  When operating
> +in resample mode, injection of an interrupt through kvm_irq.fd asserts
> +the specified gsi in the irqchip.  When the irqchip is resampled, such
> +as from an EOI, the gsi is de-asserted and the user is notifed via
> +kvm_irqfd.resamplefd.  It is the user's respnosibility to re-inject

responsibility.

> +the interrupt if the device making use of it still requires service.
> +Note that closing the resamplefd is not sufficient to disable the
> +irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
> +and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
> +
>  	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
>  
>  
>  struct kvm;
>  struct kvm_vcpu;
> @@ -283,6 +284,7 @@ struct kvm {
>  	struct {
>  		spinlock_t        lock;
>  		struct list_head  items;
> +		struct list_head  resamplers;
>  	} irqfds;
>  	struct list_head ioeventfds;
>  #endif
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 7d7e2aa..822f50a 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -43,6 +43,31 @@
>   * --------------------------------------------------------------------
>   */
>  
> +/*
> + * Resamper irqfds are a special variety of irqfds used to emulate

Resampler (or resampling?)

> + * level triggered interrupts.  The interrupt is asserted on eventfd
> + * trigger.  On acknowledgement through the irq ack notifier, the
> + * interrupt is de-asserted and userspace is notified through the
> + * resamplefd.  All resamplers on the same gsi are de-asserted
> + * together, so we don't need to track the state of each individual
> + * user.  We can also therefore share the same irq source ID.
> + */
> +struct _irqfd_resampler {
> +	struct kvm *kvm;
> +	/*
> +	 * List of resampling irqfds sharing this gsi.
> +	 * RCU list modified under kvm->irqfds.lock
> +	 */
> +	struct list_head irqfds;

Specify the type.

> +	/* The irq ack notifier for this gsi */
> +	struct kvm_irq_ack_notifier notifier;
> +	/*
> +	 * Entry in list of kvm->irqfd.resamplers for shutdown cleanup.
> +	 * Accessed and modified under kvm->irqfds.lock
> +	 */
> +	struct list_head list;

Usually we call those links, (and the real heads, list).

> +};
> +
>  
> +
> +/*
> + * Since resampler irqfds share an IRQ source ID, we de-assert once
> + * then notify all of the resampler irqfds using this GSI.  We can't
> + * do multiple de-asserts or we risk racing with incoming re-asserts.
> + */
> +static void
> +irqfd_resampler_notify(struct kvm_irq_ack_notifier *kian)
> +{
> +	struct _irqfd_resampler *resampler;
> +	struct _irqfd *irqfd;
> +
> +	resampler = container_of(kian, struct _irqfd_resampler, notifier);
> +
> +	rcu_read_lock();
> +
> +	kvm_set_irq(resampler->kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
> +		    resampler->notifier.gsi, 0);

Could be outside the rcu read-side critical section, no?

> +
> +	list_for_each_entry_rcu(irqfd, &resampler->irqfds, resampler_list)
> +		eventfd_signal(irqfd->resamplefd, 1);
> +
> +	rcu_read_unlock();
> +}
> +
>  /*
>   * Race-free decouple logic (ordering is critical)
>   */
> @@ -92,6 +156,43 @@ irqfd_shutdown(struct work_struct *work)
>  	 */
>  	flush_work_sync(&irqfd->inject);
>  
> +	if (irqfd->resampler) {
> +		struct _irqfd_resampler *resampler = irqfd->resampler;
> +		struct kvm *kvm = resampler->kvm;
> +
> +		mutex_lock(&kvm->irq_lock);
> +		spin_lock_irq(&irqfd->kvm->irqfds.lock);
> +
> +		list_del_rcu(&irqfd->resampler_list);
> +
> +		/*
> +		 * On removal of the last irqfd in the resampler list,
> +		 * remove the resampler and unregister the irq ack
> +		 * notifier.  It's possible to race the ack of the final
> +		 * injection here, so manually de-assert the gsi to avoid
> +		 * leaving an unmanaged, asserted interrupt line.
> +		 */
> +		if (list_empty(&resampler->irqfds)) {
> +			list_del(&resampler->list);
> +			__kvm_unregister_irq_ack_notifier(kvm,
> +							  &resampler->notifier);
> +			kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
> +				    resampler->notifier.gsi, 0);
> +			kfree(resampler);

Is this rcu safe?

> +		}
> +
> +		spin_unlock_irq(&irqfd->kvm->irqfds.lock);
> +		mutex_unlock(&kvm->irq_lock);
> +
> +		/*
> +		 * Both list_del_rcu & __kvm_unregister_irq_ack_notifier
> +		 * require an rcu grace period/
> +		 */
> +		synchronize_rcu();

Quite ugly to expose the internals this way.

> +
> +		eventfd_ctx_put(irqfd->resamplefd);
> +	}
> +
>  	/*
>  	 * It is now safe to release the object's resources
>  	 */
> @@ -202,8 +303,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  {
>  	struct kvm_irq_routing_table *irq_rt;
>  	struct _irqfd *irqfd, *tmp;
> +	struct _irqfd_resampler *resampler = NULL;
>  	struct file *file = NULL;
> -	struct eventfd_ctx *eventfd = NULL;
> +	struct eventfd_ctx *eventfd = NULL, *resamplefd = NULL;
>  	int ret;
>  	unsigned int events;
>  
> @@ -214,7 +316,40 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  	irqfd->kvm = kvm;
>  	irqfd->gsi = args->gsi;
>  	INIT_LIST_HEAD(&irqfd->list);
> -	INIT_WORK(&irqfd->inject, irqfd_inject);
> +	INIT_LIST_HEAD(&irqfd->resampler_list);
> +
> +	if (args->flags & KVM_IRQFD_FLAG_RESAMPLE) {
> +		resamplefd = eventfd_ctx_fdget(args->resamplefd);
> +		if (IS_ERR(resamplefd)) {
> +			ret = PTR_ERR(resamplefd);
> +			goto fail;
> +		}
> +
> +		irqfd->resamplefd = resamplefd;
> +
> +		/*
> +		 * We may be able to share an existing resampler, but we
> +		 * won't know that until we search under spinlock.  Setup
> +		 * one here to avoid an atomic allocation later.
> +		 */
> +		resampler = kzalloc(sizeof(*resampler), GFP_KERNEL);
> +		if (!resampler) {
> +			ret = -ENOMEM;
> +			goto fail;
> +		}
> +
> +		resampler->kvm = kvm;
> +		INIT_LIST_HEAD(&resampler->irqfds);
> +		resampler->notifier.gsi = irqfd->gsi;
> +		resampler->notifier.irq_acked = irqfd_resampler_notify;
> +		INIT_LIST_HEAD(&resampler->list);
> +
> +		irqfd->resampler = resampler;
> +
> +		INIT_WORK(&irqfd->inject, irqfd_resampler_inject);
> +	} else
> +		INIT_WORK(&irqfd->inject, irqfd_inject);
> +
>  	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
>  
>  	file = eventfd_fget(args->fd);
> @@ -238,6 +373,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
>  	init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
>  
> +	mutex_lock(&kvm->irq_lock);
>  	spin_lock_irq(&kvm->irqfds.lock);
>  
>  	ret = 0;
> @@ -247,9 +383,36 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  		/* This fd is used for another irq already. */
>  		ret = -EBUSY;
>  		spin_unlock_irq(&kvm->irqfds.lock);
> +		mutex_unlock(&kvm->irq_lock);
>  		goto fail;
>  	}
>  
> +	if (resampler) {
> +		struct _irqfd_resampler *resampler_tmp;
> +
> +		/*
> +		 * Re-use a resampler if it's already registered on the
> +		 * gsi we need.  Free the one we created above if found,
> +		 * otherwise add to the list and setup the irq ack notifier.
> +		 */
> +		list_for_each_entry(resampler_tmp,
> +				    &kvm->irqfds.resamplers, list) {
> +			if (resampler_tmp->notifier.gsi == irqfd->gsi) {
> +				irqfd->resampler = resampler_tmp;
> +				break;
> +			}
> +		}
> +
> +		if (irqfd->resampler == resampler) {
> +			list_add(&resampler->list, &kvm->irqfds.resamplers);
> +			__kvm_register_irq_ack_notifier(kvm,
> +							&resampler->notifier);
> +		} else
> +			kfree(resampler);
> +
> +		list_add_rcu(&irqfd->resampler_list, &irqfd->resampler->irqfds);
> +	}
> +

Whoa.  Can't we put the resampler entry somewhere we don't need to
search for it?  Like a kvm_kernel_irq_routing_entry, that's indexed by
gsi already (kvm_irq_routing_table::rt_entries[gsi]).



-- 
error compiling committee.c: too many arguments to function
