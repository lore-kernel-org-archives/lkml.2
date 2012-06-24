Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab2FXKaB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 06:30:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517Ab2FXK37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 06:29:59 -0400
Message-ID: <4FE6EC20.5030502@redhat.com>
Date: Sun, 24 Jun 2012 13:29:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        mst@redhat.com
Subject: Re: [PATCH 3/4] kvm: Extend irqfd to support level interrupts
References: <20120622220040.9858.43665.stgit@bling.home> <20120622221559.9858.59593.stgit@bling.home>
In-Reply-To: <20120622221559.9858.59593.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2012 01:16 AM, Alex Williamson wrote:
> KVM_IRQFD currently only supports edge triggered interrupts,
> asserting then immediately deasserting an interrupt.  There are a
> couple ways we can emulate level triggered interrupts using
> discrete events depending on the usage model we expect from drivers.
> This patch implements a level emulation model useful for external
> assigned device drivers, like VFIO.  The irqfd is used to assert
> the interrupt.  When the guest issues an EOI for the interrupt, the
> level is automatically deasserted and the irqfd user is notified via
> an eventfd.  This is therefore the LEVEL_EOI extension to KVM_IRQFD.
> To do this, we need to allocate a new irq source ID for the interrupt
> so we don't get interference from userspace.
> 
>  
> +With KVM_CAP_IRQFD_LEVEL_EOI KVM_IRQFD is able to support a level
> +triggered interrupt model where the irqchip pin (kvm_irqfd.gsi) is
> +asserted from the kvm_irqfd.fd eventfd and remain asserted until the
> +guest issues an EOI for the irqchip pin.  The level interrupt is
> +then de-asserted and the caller is notified via the eventfd specified
> +by kvm_irqfd.fd2.  Note that users of this interface are responsible
> +for re-asserting the interrupt if their device still requires service
> +after receiving the EOI notification.  Additionally, users must not
> +re-assert an interrupt until after receiving an EOI.  

What happens if this is violated?

> When available,
> +this feature is enabled using the KVM_IRQFD_FLAG_LEVEL_EOI flag.
> +De-assigning an irqfd setup using this flag should include both
> +KVM_IRQFD_FLAG_DEASSIGN and KVM_IRQFD_FLAG_LEVEL_EOI and will be
> +matched using kvm_irqfd.fd, kvm_irqfd.gsi, and kvm_irqfd.fd2.
> +De-assigning automatically de-asserts the interrupt line setup through
> +this interface.
>  
> @@ -203,8 +232,8 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  	struct kvm_irq_routing_table *irq_rt;
>  	struct _irqfd *irqfd, *tmp;
>  	struct file *file = NULL;
> -	struct eventfd_ctx *eventfd = NULL;
> -	int ret;
> +	struct eventfd_ctx *eventfd = NULL, *eoi_eventfd = NULL;
> +	int ret, irq_source_id = -1;
>  	unsigned int events;
>  
>  	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
> @@ -214,7 +243,30 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  	irqfd->kvm = kvm;
>  	irqfd->gsi = args->gsi;
>  	INIT_LIST_HEAD(&irqfd->list);
> -	INIT_WORK(&irqfd->inject, irqfd_inject);
> +
> +	if (args->flags & KVM_IRQFD_FLAG_LEVEL_EOI) {
> +		irq_source_id = kvm_request_irq_source_id(kvm);
> +		if (irq_source_id < 0) {
> +			ret = irq_source_id;
> +			goto fail;

'file' is NULL at this point, and fput() doesn't test for NULL.

> +		}
> +
> +		eoi_eventfd = eventfd_ctx_fdget(args->fd2);
> +		if (IS_ERR(eoi_eventfd)) {
> +			ret = PTR_ERR(eoi_eventfd);
> +			goto fail;

Same.

> +		}
> +
> +		irqfd->irq_source_id = irq_source_id;
> +		irqfd->eoi_eventfd = eoi_eventfd;
> +		irqfd->notifier.gsi = args->gsi;
> +		irqfd->notifier.irq_acked = irqfd_ack_level;
> +		kvm_register_irq_ack_notifier(kvm, &irqfd->notifier);
> +
> +		INIT_WORK(&irqfd->inject, irqfd_inject_level);
> +	} else
> +		INIT_WORK(&irqfd->inject, irqfd_inject_edge);
> +
>  	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
>  
>  	file = eventfd_fget(args->fd);

> @@ -242,7 +299,8 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  
>  	ret = 0;
>  	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
> -		if (irqfd->eventfd != tmp->eventfd)
> +		if (irqfd->eventfd != tmp->eventfd &&
> +		    irqfd->eventfd != tmp->eoi_eventfd)
>  			continue;

So we allow duplicate irqfd with differing eoifd (or edge-triggered and
level-triggered irqfd on the same context).

(why the check in the first place? just so we can have a reliable
deassign or is it avoiding a deeper problem?)

>  		/* This fd is used for another irq already. */
>  		ret = -EBUSY;
> @@ -282,6 +340,14 @@ fail:
>  	if (!IS_ERR(file))
>  		fput(file);
>  
> +	if (eoi_eventfd && !IS_ERR(eoi_eventfd)) {
> +		kvm_unregister_irq_ack_notifier(kvm, &irqfd->notifier);
> +		eventfd_ctx_put(eoi_eventfd);
> +	}
> +
> +	if (irq_source_id >= 0)
> +		kvm_free_irq_source_id(kvm, irq_source_id);
> +
>  	kfree(irqfd);
>  	return ret;
>  }
> @@ -301,16 +367,26 @@ static int
>  kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
>  {
>  	struct _irqfd *irqfd, *tmp;
> -	struct eventfd_ctx *eventfd;
> +	struct eventfd_ctx *eventfd, *eoi_eventfd = NULL;
>  
>  	eventfd = eventfd_ctx_fdget(args->fd);
>  	if (IS_ERR(eventfd))
>  		return PTR_ERR(eventfd);
>  
> +	if (args->flags & KVM_IRQFD_FLAG_LEVEL_EOI) {
> +		eoi_eventfd = eventfd_ctx_fdget(args->fd2);
> +		if (IS_ERR(eoi_eventfd)) {
> +			eventfd_ctx_put(eventfd);
> +			return PTR_ERR(eoi_eventfd);
> +		}
> +	}
> +
>  	spin_lock_irq(&kvm->irqfds.lock);
>  
>  	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
> -		if (irqfd->eventfd == eventfd && irqfd->gsi == args->gsi) {
> +		if (irqfd->eventfd == eventfd &&
> +		    irqfd->gsi == args->gsi &&
> +		    irqfd->eoi_eventfd == eoi_eventfd) {
>  			/*
>  			 * This rcu_assign_pointer is needed for when
>  			 * another thread calls kvm_irq_routing_update before
> @@ -326,6 +402,8 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
>  
>  	spin_unlock_irq(&kvm->irqfds.lock);
>  	eventfd_ctx_put(eventfd);
> +	if (eoi_eventfd)
> +		eventfd_ctx_put(eoi_eventfd);
>  
>  	/*
>  	 * Block until we know all outstanding shutdown jobs have completed

I see there is no check on undefined ->flags that you had to relax.
This means that there could be buggy code out there that sets LEVEL_EOI
and will now get an unexpected error.  I doubt it's the case, but please
add a patch (in front of the series) that adds the check.

Xen had/has a hack for doing this in a different way, based on ioapic
polarity.  When the host takes an interrupt, they reverse the polarity
on that ioapic pin, so they get interrupts on both assertion and
deassertion.  This is more general and more correct, but waaaaaaaaaaay
more intrusive and won't play well with shared host interrupts.  But
let's at least consider it.

-- 
error compiling committee.c: too many arguments to function


