Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2CLJX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 05:23:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab2CLJX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 05:23:56 -0400
Date: Mon, 12 Mar 2012 11:23:54 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: mtosatti@redhat.com, avi@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH] kvm: ioapic: conditionally delay irq delivery during eoi
 broadcast
Message-ID: <20120312092354.GT17882@redhat.com>
References: <20120312090734.8414.21043.stgit@amd-6168-8-1.englab.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312090734.8414.21043.stgit@amd-6168-8-1.englab.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 05:07:35PM +0800, Jason Wang wrote:
> Currently, we call ioapic_service() immediately when we find the irq is still
> active during eoi broadcast. But for real hardware, there's some dealy between
> the EOI writing and irq delivery (system bus latency?). So we need to emulate
> this behavior. Otherwise, for a guest who haven't register a proper irq handler
> , it would stay in the interrupt routine as this irq would be re-injected
> immediately after guest enables interrupt. This would lead guest can't move
> forward and may miss the possibility to get proper irq handler registered (one
> example is windows guest resuming from hibernation).
> 
Yes, I saw this behaviour with Windows NICs, but it looks like the
guest bug. Does this happen with other kind of devices too? Because
if it does not then the correct hack would be to add a delay between
Windows enabling PHY and sending first interrupt to a guest. This will
model what happens on real HW. NIC does not start receiving packets at
the same moment PHY is enabled. Some time is spent bring up the link.

> As there's no way to differ the unhandled irq from new raised ones, this patch
> solve this problems by scheduling a delayed work when the count of irq injected
> during eoi broadcast exceeds a threshold value. After this patch, the guest can
> move a little forward when there's no suitable irq handler in case it may
> register one very soon and for guest who has a bad irq detection routine ( such
> as note_interrupt() in linux ), this bad irq would be recognized soon as in the
> past.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  virt/kvm/ioapic.c |   47 +++++++++++++++++++++++++++++++++++++++++++++--
>  virt/kvm/ioapic.h |    2 ++
>  2 files changed, 47 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index dcaf272..892253e 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -221,6 +221,24 @@ int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
>  	return ret;
>  }
>  
> +static void kvm_ioapic_eoi_inject_work(struct work_struct *work)
> +{
> +	int i, ret;
> +	struct kvm_ioapic *ioapic = container_of(work, struct kvm_ioapic,
> +						 eoi_inject.work);
> +	spin_lock(&ioapic->lock);
> +	for (i = 0; i < IOAPIC_NUM_PINS; i++) {
> +		union kvm_ioapic_redirect_entry *ent = &ioapic->redirtbl[i];
> +
> +		if (ent->fields.trig_mode != IOAPIC_LEVEL_TRIG)
> +			continue;
> +
> +		if (ioapic->irr & (1 << i) && !ent->fields.remote_irr)
> +			ret = ioapic_service(ioapic, i);
> +	}
> +	spin_unlock(&ioapic->lock);
> +}
> +
>  static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int vector,
>  				     int trigger_mode)
>  {
> @@ -249,8 +267,29 @@ static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int vector,
>  
>  		ASSERT(ent->fields.trig_mode == IOAPIC_LEVEL_TRIG);
>  		ent->fields.remote_irr = 0;
> -		if (!ent->fields.mask && (ioapic->irr & (1 << i)))
> -			ioapic_service(ioapic, i);
> +		if (!ent->fields.mask && (ioapic->irr & (1 << i))) {
> +			++ioapic->irq_eoi;
> +			if (ioapic->irq_eoi == 100) {
> +				/*
> +				 * Real hardware does not deliver the irq so
> +				 * immediately during eoi broadcast, so we need
> +				 * to emulate this behavior. Otherwise, for
> +				 * guests who has not registered handler of a
> +				 * level irq, this irq would be injected
> +				 * immediately after guest enables interrupt
> +				 * (which happens usually at the end of the
> +				 * common interrupt routine). This would lead
> +				 * guest can't move forward and may miss the
> +				 * possibility to get proper irq handler
> +				 * registered. So we need to give some breath to
> +				 * guest. TODO: 1 is too long?
> +				 */
> +				schedule_delayed_work(&ioapic->eoi_inject, 1);
> +				ioapic->irq_eoi = 0;
> +			} else {
> +				ioapic_service(ioapic, i);
> +			}
> +		}
>  	}
>  }
>  
> @@ -375,12 +414,14 @@ void kvm_ioapic_reset(struct kvm_ioapic *ioapic)
>  {
>  	int i;
>  
> +	cancel_delayed_work_sync(&ioapic->eoi_inject);
>  	for (i = 0; i < IOAPIC_NUM_PINS; i++)
>  		ioapic->redirtbl[i].fields.mask = 1;
>  	ioapic->base_address = IOAPIC_DEFAULT_BASE_ADDRESS;
>  	ioapic->ioregsel = 0;
>  	ioapic->irr = 0;
>  	ioapic->id = 0;
> +	ioapic->irq_eoi = 0;
>  	update_handled_vectors(ioapic);
>  }
>  
> @@ -398,6 +439,7 @@ int kvm_ioapic_init(struct kvm *kvm)
>  	if (!ioapic)
>  		return -ENOMEM;
>  	spin_lock_init(&ioapic->lock);
> +	INIT_DELAYED_WORK(&ioapic->eoi_inject, kvm_ioapic_eoi_inject_work);
>  	kvm->arch.vioapic = ioapic;
>  	kvm_ioapic_reset(ioapic);
>  	kvm_iodevice_init(&ioapic->dev, &ioapic_mmio_ops);
> @@ -418,6 +460,7 @@ void kvm_ioapic_destroy(struct kvm *kvm)
>  {
>  	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
>  
> +	cancel_delayed_work_sync(&ioapic->eoi_inject);
>  	if (ioapic) {
>  		kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &ioapic->dev);
>  		kvm->arch.vioapic = NULL;
> diff --git a/virt/kvm/ioapic.h b/virt/kvm/ioapic.h
> index 0b190c3..8938e66 100644
> --- a/virt/kvm/ioapic.h
> +++ b/virt/kvm/ioapic.h
> @@ -47,6 +47,8 @@ struct kvm_ioapic {
>  	void (*ack_notifier)(void *opaque, int irq);
>  	spinlock_t lock;
>  	DECLARE_BITMAP(handled_vectors, 256);
> +	struct delayed_work eoi_inject;
> +	u32 irq_eoi;
>  };
>  
>  #ifdef DEBUG

--
			Gleb.
