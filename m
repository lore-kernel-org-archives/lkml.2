Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab0IPJDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 05:03:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab0IPJC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 05:02:58 -0400
Date: Thu, 16 Sep 2010 11:02:56 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
Message-ID: <20100916090256.GU3008@redhat.com>
References: <20100915185417.GA3924@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915185417.GA3924@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 08:54:17PM +0200, Michael S. Tsirkin wrote:
> To avoid bouncing irqfd injection out to workqueue context,
> we must support injecting irqs from local interrupt
> context. Doing this seems to only require disabling
> irqs locally.
> 
> RFC, completely untested, x86 only.
> 
> Thoughts?
> 
We do not want to disable irqs for a long time and some of code paths
under lock involve looping over all cpus. For MSI injection path is
lockless and this is the only case that matters, so inject irqs from
local interrupt context if it is MSI or from workqueue otherwise.

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/x86/kvm/i8259.c |   12 ++++++++++++
>  virt/kvm/eventfd.c   |   30 +++++++++---------------------
>  virt/kvm/ioapic.c    |   34 ++++++++++++++++++++--------------
>  3 files changed, 41 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index 8d10c06..294fa36 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -198,8 +198,10 @@ void kvm_pic_update_irq(struct kvm_pic *s)
>  int kvm_pic_set_irq(void *opaque, int irq, int level)
>  {
>  	struct kvm_pic *s = opaque;
> +	unsigned long flags;
>  	int ret = -1;
>  
> +	local_irq_save(flags);
>  	pic_lock(s);
>  	if (irq >= 0 && irq < PIC_NUM_PINS) {
>  		ret = pic_set_irq1(&s->pics[irq >> 3], irq & 7, level);
> @@ -208,6 +210,7 @@ int kvm_pic_set_irq(void *opaque, int irq, int level)
>  				      s->pics[irq >> 3].imr, ret == 0);
>  	}
>  	pic_unlock(s);
> +	local_irq_restore(flags);
>  
>  	return ret;
>  }
> @@ -235,8 +238,10 @@ static inline void pic_intack(struct kvm_kpic_state *s, int irq)
>  int kvm_pic_read_irq(struct kvm *kvm)
>  {
>  	int irq, irq2, intno;
> +	unsigned long flags;
>  	struct kvm_pic *s = pic_irqchip(kvm);
>  
> +	local_irq_save(flags);
>  	pic_lock(s);
>  	irq = pic_get_irq(&s->pics[0]);
>  	if (irq >= 0) {
> @@ -263,6 +268,7 @@ int kvm_pic_read_irq(struct kvm *kvm)
>  	}
>  	pic_update_irq(s);
>  	pic_unlock(s);
> +	local_irq_restore(flags);
>  
>  	return intno;
>  }
> @@ -476,6 +482,7 @@ static int picdev_write(struct kvm_io_device *this,
>  {
>  	struct kvm_pic *s = to_pic(this);
>  	unsigned char data = *(unsigned char *)val;
> +	unsigned long flags;
>  	if (!picdev_in_range(addr))
>  		return -EOPNOTSUPP;
>  
> @@ -484,6 +491,7 @@ static int picdev_write(struct kvm_io_device *this,
>  			printk(KERN_ERR "PIC: non byte write\n");
>  		return 0;
>  	}
> +	local_irq_save(flags);
>  	pic_lock(s);
>  	switch (addr) {
>  	case 0x20:
> @@ -498,6 +506,7 @@ static int picdev_write(struct kvm_io_device *this,
>  		break;
>  	}
>  	pic_unlock(s);
> +	local_irq_restore(flags);
>  	return 0;
>  }
>  
> @@ -506,6 +515,7 @@ static int picdev_read(struct kvm_io_device *this,
>  {
>  	struct kvm_pic *s = to_pic(this);
>  	unsigned char data = 0;
> +	unsigned long flags;
>  	if (!picdev_in_range(addr))
>  		return -EOPNOTSUPP;
>  
> @@ -514,6 +524,7 @@ static int picdev_read(struct kvm_io_device *this,
>  			printk(KERN_ERR "PIC: non byte read\n");
>  		return 0;
>  	}
> +	local_irq_save(flags);
>  	pic_lock(s);
>  	switch (addr) {
>  	case 0x20:
> @@ -529,6 +540,7 @@ static int picdev_read(struct kvm_io_device *this,
>  	}
>  	*(unsigned char *)val = data;
>  	pic_unlock(s);
> +	local_irq_restore(flags);
>  	return 0;
>  }
>  
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 66cf65b..30ede90 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -50,22 +50,11 @@ struct _irqfd {
>  	struct list_head          list;
>  	poll_table                pt;
>  	wait_queue_t              wait;
> -	struct work_struct        inject;
>  	struct work_struct        shutdown;
>  };
>  
>  static struct workqueue_struct *irqfd_cleanup_wq;
>  
> -static void
> -irqfd_inject(struct work_struct *work)
> -{
> -	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
> -	struct kvm *kvm = irqfd->kvm;
> -
> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> -}
> -
>  /*
>   * Race-free decouple logic (ordering is critical)
>   */
> @@ -82,12 +71,6 @@ irqfd_shutdown(struct work_struct *work)
>  	eventfd_ctx_remove_wait_queue(irqfd->eventfd, &irqfd->wait, &cnt);
>  
>  	/*
> -	 * We know no new events will be scheduled at this point, so block
> -	 * until all previously outstanding events have completed
> -	 */
> -	flush_work(&irqfd->inject);
> -
> -	/*
>  	 * It is now safe to release the object's resources
>  	 */
>  	eventfd_ctx_put(irqfd->eventfd);
> @@ -128,7 +111,8 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>  
>  	if (flags & POLLIN)
>  		/* An event has been signaled, inject an interrupt */
> -		schedule_work(&irqfd->inject);
> +		kvm_set_irq(irqfd->kvm, KVM_USERSPACE_IRQ_SOURCE_ID,
> +			    irqfd->gsi, 1);
>  
>  	if (flags & POLLHUP) {
>  		/* The eventfd is closing, detach from KVM */
> @@ -179,7 +163,6 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>  	irqfd->kvm = kvm;
>  	irqfd->gsi = gsi;
>  	INIT_LIST_HEAD(&irqfd->list);
> -	INIT_WORK(&irqfd->inject, irqfd_inject);
>  	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
>  
>  	file = eventfd_fget(fd);
> @@ -218,14 +201,19 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>  	events = file->f_op->poll(file, &irqfd->pt);
>  
>  	list_add_tail(&irqfd->list, &kvm->irqfds.items);
> -	spin_unlock_irq(&kvm->irqfds.lock);
>  
>  	/*
>  	 * Check if there was an event already pending on the eventfd
>  	 * before we registered, and trigger it as if we didn't miss it.
> +	 *
> +	 * Do this under irqfds.lock, this way we can be sure
> +	 * the irqfd is not going away.
>  	 */
>  	if (events & POLLIN)
> -		schedule_work(&irqfd->inject);
> +		kvm_set_irq(irqfd->kvm, KVM_USERSPACE_IRQ_SOURCE_ID,
> +			    irqfd->gsi, 1);
> +
> +	spin_unlock_irq(&kvm->irqfds.lock);
>  
>  	/*
>  	 * do not drop the file until the irqfd is fully initialized, otherwise
> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 0b9df83..cc1d2fe 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -197,8 +197,9 @@ int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
>  	u32 mask = 1 << irq;
>  	union kvm_ioapic_redirect_entry entry;
>  	int ret = 1;
> +	unsigned long flags;
>  
> -	spin_lock(&ioapic->lock);
> +	spin_lock_irqsave(&ioapic->lock, flags);
>  	old_irr = ioapic->irr;
>  	if (irq >= 0 && irq < IOAPIC_NUM_PINS) {
>  		entry = ioapic->redirtbl[irq];
> @@ -216,7 +217,7 @@ int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
>  		}
>  		trace_kvm_ioapic_set_irq(entry.bits, irq, ret == 0);
>  	}
> -	spin_unlock(&ioapic->lock);
> +	spin_unlock_irqrestore(&ioapic->lock, flags);
>  
>  	return ret;
>  }
> @@ -240,9 +241,9 @@ static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int vector,
>  		 * is dropped it will be put into irr and will be delivered
>  		 * after ack notifier returns.
>  		 */
> -		spin_unlock(&ioapic->lock);
> +		spin_unlock_irqrestore(&ioapic->lock, flags);
>  		kvm_notify_acked_irq(ioapic->kvm, KVM_IRQCHIP_IOAPIC, i);
> -		spin_lock(&ioapic->lock);
> +		spin_lock_irqsave(&ioapic->lock, flags);
>  
>  		if (trigger_mode != IOAPIC_LEVEL_TRIG)
>  			continue;
> @@ -257,13 +258,14 @@ static void __kvm_ioapic_update_eoi(struct kvm_ioapic *ioapic, int vector,
>  void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode)
>  {
>  	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
> +	unsigned long flags;
>  
>  	smp_rmb();
>  	if (!test_bit(vector, ioapic->handled_vectors))
>  		return;
> -	spin_lock(&ioapic->lock);
> +	spin_lock_irqsave(&ioapic->lock, flags);
>  	__kvm_ioapic_update_eoi(ioapic, vector, trigger_mode);
> -	spin_unlock(&ioapic->lock);
> +	spin_unlock_irqrestore(&ioapic->lock, flags);
>  }
>  
>  static inline struct kvm_ioapic *to_ioapic(struct kvm_io_device *dev)
> @@ -281,6 +283,7 @@ static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
>  			    void *val)
>  {
>  	struct kvm_ioapic *ioapic = to_ioapic(this);
> +	unsigned long flags;
>  	u32 result;
>  	if (!ioapic_in_range(ioapic, addr))
>  		return -EOPNOTSUPP;
> @@ -289,7 +292,7 @@ static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
>  	ASSERT(!(addr & 0xf));	/* check alignment */
>  
>  	addr &= 0xff;
> -	spin_lock(&ioapic->lock);
> +	spin_lock_irqsave(&ioapic->lock, flags);
>  	switch (addr) {
>  	case IOAPIC_REG_SELECT:
>  		result = ioapic->ioregsel;
> @@ -303,7 +306,7 @@ static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
>  		result = 0;
>  		break;
>  	}
> -	spin_unlock(&ioapic->lock);
> +	spin_unlock_irqrestore(&ioapic->lock, flags);
>  
>  	switch (len) {
>  	case 8:
> @@ -324,6 +327,7 @@ static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
>  			     const void *val)
>  {
>  	struct kvm_ioapic *ioapic = to_ioapic(this);
> +	unsigned long flags;
>  	u32 data;
>  	if (!ioapic_in_range(ioapic, addr))
>  		return -EOPNOTSUPP;
> @@ -340,7 +344,7 @@ static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
>  	}
>  
>  	addr &= 0xff;
> -	spin_lock(&ioapic->lock);
> +	spin_lock_irqsave(&ioapic->lock, flags);
>  	switch (addr) {
>  	case IOAPIC_REG_SELECT:
>  		ioapic->ioregsel = data;
> @@ -358,7 +362,7 @@ static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
>  	default:
>  		break;
>  	}
> -	spin_unlock(&ioapic->lock);
> +	spin_unlock_irqrestore(&ioapic->lock, flags);
>  	return 0;
>  }
>  
> @@ -418,24 +422,26 @@ void kvm_ioapic_destroy(struct kvm *kvm)
>  int kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state)
>  {
>  	struct kvm_ioapic *ioapic = ioapic_irqchip(kvm);
> +	unsigned long flags;
>  	if (!ioapic)
>  		return -EINVAL;
>  
> -	spin_lock(&ioapic->lock);
> +	spin_lock_irqsave(&ioapic->lock, flags);
>  	memcpy(state, ioapic, sizeof(struct kvm_ioapic_state));
> -	spin_unlock(&ioapic->lock);
> +	spin_unlock_irqrestore(&ioapic->lock, flags);
>  	return 0;
>  }
>  
>  int kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state)
>  {
>  	struct kvm_ioapic *ioapic = ioapic_irqchip(kvm);
> +	unsigned long flags;
>  	if (!ioapic)
>  		return -EINVAL;
>  
> -	spin_lock(&ioapic->lock);
> +	spin_lock_irqsave(&ioapic->lock, flags);
>  	memcpy(ioapic, state, sizeof(struct kvm_ioapic_state));
>  	update_handled_vectors(ioapic);
> -	spin_unlock(&ioapic->lock);
> +	spin_unlock_irqrestore(&ioapic->lock, flags);
>  	return 0;
>  }
> -- 
> 1.7.3.rc1.5.ge5969

--
			Gleb.
