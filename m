Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab2HUUkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:40:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab2HUUkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:40:23 -0400
Date: Tue, 21 Aug 2012 23:41:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 1/2] kvm: Use a reserved IRQ source ID for irqfd
Message-ID: <20120821204125.GF9027@redhat.com>
References: <20120821190800.24958.74812.stgit@bling.home>
 <20120821192903.24958.90138.stgit@bling.home>
 <20120821195813.GD9027@redhat.com>
 <1345579579.29292.67.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345579579.29292.67.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 02:06:19PM -0600, Alex Williamson wrote:
> On Tue, 2012-08-21 at 22:58 +0300, Michael S. Tsirkin wrote:
> > On Tue, Aug 21, 2012 at 01:29:06PM -0600, Alex Williamson wrote:
> > > KVM_IRQFD currently uses the reserved KVM_USERSPACE_IRQ_SOURCE_ID
> > > which is also shared with userspace injection methods like
> > > KVM_IRQ_LINE.  This can cause a conflict if an irqfd triggers on
> > > a GSI asserted through KVM_IRQ_LINE.
> > 
> > What kind of conflict do you envision?  Pls note level interrupts are
> > unsupported ATM.
> 
> If KVM_IRQ_LINE asserts a level interrupt and KVM_IRQFD triggers on the
> same GSI then the pin is no longer asserted as userspace thinks it is.
> Do we just chalk this up to userspace error?

Yes: using a level GSI with current irqfd is a userspace error
because you can lose interrupts anyway.

Are edge GSIs affected?

> > > Move irqfd to it's own reserved IRQ source ID.  Add a capability for
> > > userspace to test for this fix.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---
> > > 
> > >  arch/x86/kvm/x86.c       |    3 +++
> > >  include/linux/kvm.h      |    1 +
> > >  include/linux/kvm_host.h |    1 +
> > >  virt/kvm/eventfd.c       |    6 +++---
> > >  4 files changed, 8 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 42bce48..cd98673 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -2174,6 +2174,7 @@ int kvm_dev_ioctl_check_extension(long ext)
> > >  	case KVM_CAP_GET_TSC_KHZ:
> > >  	case KVM_CAP_PCI_2_3:
> > >  	case KVM_CAP_KVMCLOCK_CTRL:
> > > +	case KVM_CAP_IRQFD_IRQ_SOURCE_ID:
> > >  		r = 1;
> > >  		break;
> > >  	case KVM_CAP_COALESCED_MMIO:
> > > @@ -6258,6 +6259,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> > >  
> > >  	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
> > >  	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
> > > +	/* Reserve bit 1 of irq_sources_bitmap for irqfd irq source */
> > > +	set_bit(KVM_IRQFD_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
> > >  
> > >  	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
> > >  
> > > diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> > > index 2ce09aa..ae66b9c 100644
> > > --- a/include/linux/kvm.h
> > > +++ b/include/linux/kvm.h
> > > @@ -618,6 +618,7 @@ struct kvm_ppc_smmu_info {
> > >  #define KVM_CAP_PPC_GET_SMMU_INFO 78
> > >  #define KVM_CAP_S390_COW 79
> > >  #define KVM_CAP_PPC_ALLOC_HTAB 80
> > > +#define KVM_CAP_IRQFD_IRQ_SOURCE_ID 81
> > >  
> > >  #ifdef KVM_CAP_IRQ_ROUTING
> > >  
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index b70b48b..b763230 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -71,6 +71,7 @@
> > >  #define KVM_REQ_PMI               17
> > >  
> > >  #define KVM_USERSPACE_IRQ_SOURCE_ID	0
> > > +#define KVM_IRQFD_IRQ_SOURCE_ID		1
> > >  
> > >  struct kvm;
> > >  struct kvm_vcpu;
> > 
> > Above looks fine but I'm not sure why is the below needed.
> > This changes irqfd behaviour for edge GSIs slightly
> > in a userspace-visible way. Maybe make it a separate patch
> > so it can be considered on merits?
> 
> Hmm, the above does nothing without the below.

Yes. But you can use the above with the new irqfds you are adding.

> I thought I was just
> implementing your idea that IRQFDs should all share a single IRQ source
> ID...

Sorry I only meant for level irqfds. You are changing edge here.

> why is that no longer a good idea?  Thanks,
> 
> Alex

Maybe it is a good idea. I am just asking for the motivation.

> > > diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> > > index 7d7e2aa..2245cfa 100644
> > > --- a/virt/kvm/eventfd.c
> > > +++ b/virt/kvm/eventfd.c
> > > @@ -67,8 +67,8 @@ irqfd_inject(struct work_struct *work)
> > >  	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
> > >  	struct kvm *kvm = irqfd->kvm;
> > >  
> > > -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
> > > -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> > > +	kvm_set_irq(kvm, KVM_IRQFD_IRQ_SOURCE_ID, irqfd->gsi, 1);
> > > +	kvm_set_irq(kvm, KVM_IRQFD_IRQ_SOURCE_ID, irqfd->gsi, 0);
> > >  }
> > >  
> > >  /*
> > > @@ -138,7 +138,7 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
> > >  		irq = rcu_dereference(irqfd->irq_entry);
> > >  		/* An event has been signaled, inject an interrupt */
> > >  		if (irq)
> > > -			kvm_set_msi(irq, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1);
> > > +			kvm_set_msi(irq, kvm, KVM_IRQFD_IRQ_SOURCE_ID, 1);
> > >  		else
> > >  			schedule_work(&irqfd->inject);
> > >  		rcu_read_unlock();
> 
> 
