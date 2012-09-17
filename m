Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab2IQQNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 12:13:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396Ab2IQQNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 12:13:21 -0400
Message-ID: <1347898400.486.69.camel@bling.home>
Subject: Re: [PATCH v9 2/2] kvm: On Ack, De-assert & Notify KVM_IRQFD
 extension
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 17 Sep 2012 10:13:20 -0600
In-Reply-To: <5047686D.8060606@redhat.com>
References: <20120821190800.24958.74812.stgit@bling.home>
	 <20120821192911.24958.38609.stgit@bling.home> <5047686D.8060606@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 17:57 +0300, Avi Kivity wrote:
> On 08/21/2012 10:29 PM, Alex Williamson wrote:
> > For VFIO based device assignment we'd like a mechanism to allow level
> > triggered interrutps to be directly injected into KVM.  KVM_IRQFD
> > already allows this for edge triggered interrupts, but for level, we
> > need to watch for acknowledgement of the interrupt from the guest to
> > provide us a hint when to test the device and allow it to re-assert
> > if necessary.  To do this, we create a new KVM_IRQFD mode called
> > "On Ack, De-assert & Notify", or OADN.  In this mode, an interrupt
> > injection provides only a gsi assertion.  We then hook into the IRQ
> > ACK notifier, which when triggered de-asserts the gsi and notifies
> > via another eventfd.  It's then the responsibility of the user to
> > re-assert the interrupt is service is still required.
> > 
> > 
> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > index bf33aaa..87d7321 100644
> > --- a/Documentation/virtual/kvm/api.txt
> > +++ b/Documentation/virtual/kvm/api.txt
> > @@ -1946,6 +1946,19 @@ the guest using the specified gsi pin.  The irqfd is removed using
> >  the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
> >  and kvm_irqfd.gsi.
> >  
> > +With KVM_CAP_IRQFD_OADN, KVM_IRQFD supports an "On Ack, De-assert &
> > +Notify" option that allows emulation of level-triggered interrupts.
> > +When kvm_irqfd.fd is triggered, the requested gsi is asserted and
> > +remains asserted until interaction with the irqchip indicates the
> > +VM has acknowledged the interrupt, such as an EOI.  On acknoledgement
> > +the gsi is automatically de-asserted and the user is notified via
> > +kvm_irqfd.notifyfd.  The user is then required to re-assert the
> > +interrupt if the associated device still requires service.  To enable
> > +this mode, configure the KVM_IRQFD using the KVM_IRQFD_FLAG_OADN flag
> > +and specify kvm_irqfd.notifyfd.  Note that closing kvm_irqfd.notifyfd
> > +while configured in this mode does not disable the irqfd.  The
> > +KVM_IRQFD_FLAG_OADN flag is only necessary on assignment.
> 
> Under my suggested naming, this would be called a "resampling irqfd",
> with resampling requested via kvm_irqfd.resamplefd.
> 
> > diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> > index 2245cfa..dfdb5b2 100644
> > --- a/virt/kvm/eventfd.c
> > +++ b/virt/kvm/eventfd.c
> > @@ -43,6 +43,23 @@
> >   * --------------------------------------------------------------------
> >   */
> >  
> > +/*
> > + * OADN irqfds (On Ack, De-assert & Notify) are a special variety of
> > + * irqfds that assert an interrupt to the irqchip on eventfd trigger,
> > + * receieve notification when userspace acknowledges the interrupt,
> > + * automatically de-asserts the irqchip level, and notifies userspace
> > + * via the oadn_eventfd.  This object helps to provide one-to-many
> > + * deassert-to-notify so we can share a single irq source ID per OADN.
> > + */
> > +struct _irqfd_oadn {
> > +	struct kvm *kvm;
> > +	int irq_source_id; /* IRQ source ID shared by these irqfds */
> > +	struct list_head irqfds; /* list of irqfds using this object */
> > +	struct kvm_irq_ack_notifier notifier; /* IRQ ACK notification */
> > +	struct kref kref; /* Race-free removal */
> > +	struct list_head list;
> > +};
> 
> 
> Why do you need per-gsi irq source IDs?  irq source ids only matter
> within a gsi.  For example KVM_IRQ_LINE shares one source ID for all
> lines (with result that userspace is forced to manage the ORing of
> shared inputs itself).

Right, but locking makes it difficult to tear down a resample irqfd
without potentially racing creation of a new one, which I tried to
explain here:

http://www.spinics.net/lists/kvm/msg78460.html

This can cause a de-assert w/o ack as we briefly have multiple resample
irqfds on the same gsi, irq source id pair.  That can dead lock a vfio
device.  Using a new irq source ID ensures that the old resample irqfd
doesn't interfere with the new one.  We count on the final clear or the
gsi assertion when releasing the irq source id, so we can't share it
among other resample irqfds on other gsis with different life cycles.

Michael has suggested re-architecting the locking around some structure,
but I'm not sure it's worth it.  AFAICT we have more irq source IDs than
we could consume if resample irqfds on the same gsi share an irq source
id.  Thanks,

Alex

