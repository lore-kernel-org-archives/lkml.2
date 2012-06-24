Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2FXPpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 11:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab2FXPpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 11:45:53 -0400
Date: Sun, 24 Jun 2012 18:45:55 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 3/4] kvm: Extend irqfd to support level interrupts
Message-ID: <20120624154555.GC2851@redhat.com>
References: <20120622220040.9858.43665.stgit@bling.home>
 <20120622221559.9858.59593.stgit@bling.home>
 <20120624082856.GB1712@redhat.com>
 <1340549456.14120.45.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340549456.14120.45.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 08:50:56AM -0600, Alex Williamson wrote:
> On Sun, 2012-06-24 at 11:28 +0300, Michael S. Tsirkin wrote:
> > On Fri, Jun 22, 2012 at 04:16:17PM -0600, Alex Williamson wrote:
> > > diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> > > index 2ce09aa..a916186 100644
> > > --- a/include/linux/kvm.h
> > > +++ b/include/linux/kvm.h
> > > @@ -618,6 +618,7 @@ struct kvm_ppc_smmu_info {
> > >  #define KVM_CAP_PPC_GET_SMMU_INFO 78
> > >  #define KVM_CAP_S390_COW 79
> > >  #define KVM_CAP_PPC_ALLOC_HTAB 80
> > > +#define KVM_CAP_IRQFD_LEVEL_EOI 81
> > >  
> > >  #ifdef KVM_CAP_IRQ_ROUTING
> > >  
> > > @@ -683,12 +684,15 @@ struct kvm_xen_hvm_config {
> > >  #endif
> > >  
> > >  #define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
> > > +/* Available with KVM_CAP_IRQFD_LEVEL_EOI */
> > > +#define KVM_IRQFD_FLAG_LEVEL_EOI (1 << 1)
> > >  
> > >  struct kvm_irqfd {
> > >  	__u32 fd;
> > >  	__u32 gsi;
> > >  	__u32 flags;
> > > -	__u8  pad[20];
> > > +	__u32 fd2;
> > > +	__u8 pad[16];
> > >  };
> > >  
> > >  struct kvm_clock_data {
> > > diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> > > index c307c24..2bc7275 100644
> > > --- a/virt/kvm/eventfd.c
> > > +++ b/virt/kvm/eventfd.c
> > > @@ -49,9 +49,13 @@ struct _irqfd {
> > >  	wait_queue_t wait;
> > >  	/* Update side is protected by irqfds.lock */
> > >  	struct kvm_kernel_irq_routing_entry __rcu *irq_entry;
> > > -	/* Used for level IRQ fast-path */
> > > +	/* Used for IRQ fast-path */
> > >  	int gsi;
> > >  	struct work_struct inject;
> > > +	/* Used for level EOI path */
> > > +	int irq_source_id;
> > > +	struct eventfd_ctx *eoi_eventfd;
> > > +	struct kvm_irq_ack_notifier notifier;
> > >  	/* Used for setup/shutdown */
> > >  	struct eventfd_ctx *eventfd;
> > >  	struct list_head list;
> > > @@ -62,7 +66,7 @@ struct _irqfd {
> > >  static struct workqueue_struct *irqfd_cleanup_wq;
> > >  
> > >  static void
> > > -irqfd_inject(struct work_struct *work)
> > > +irqfd_inject_edge(struct work_struct *work)
> > >  {
> > >  	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
> > >  	struct kvm *kvm = irqfd->kvm;
> > > @@ -71,6 +75,23 @@ irqfd_inject(struct work_struct *work)
> > >  	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
> > >  }
> > >  
> > > +static void
> > > +irqfd_inject_level(struct work_struct *work)
> > > +{
> > > +	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
> > > +
> > > +	kvm_set_irq(irqfd->kvm, irqfd->irq_source_id, irqfd->gsi, 1);
> > > +}
> > > +
> > 
> > I think that we can actually do this for all interrupts
> > unconditionally. We used to need to clear level for edge, but nomore.
> > Once you do this, can't this patch be replaced with 4/4 completely?
> 
> Nope, as described in my reply there, we can't mix IRQFD and IRQ_LINE
> for a level interrupt because we need a separate source id and have no
> way to specify it with IRQ_LINE.  Thanks,
> 
> Alex

OK, so the reason to set a new flag here is to assign
a unique source ID to it? OK, so just store the source
id in irqfd, rest of the code can be shared.
Maybe we can make all irqfds use unique source IDs?
Or is that too expensive for some reason?

-- 
MST
