Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab2HORRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:17:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab2HORRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:17:48 -0400
Message-ID: <1345051067.4683.421.camel@ul30vt.home>
Subject: Re: [PATCH v8 5/6] kvm: KVM_IRQ_ACKFD
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 15 Aug 2012 11:17:47 -0600
In-Reply-To: <20120815140554.GD3068@redhat.com>
References: <20120810223633.809.44188.stgit@bling.home>
	 <20120810223746.809.87948.stgit@bling.home>
	 <20120815140554.GD3068@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 17:05 +0300, Michael S. Tsirkin wrote:
> On Fri, Aug 10, 2012 at 04:37:48PM -0600, Alex Williamson wrote:
> > Enable a mechanism for IRQ ACKs to be exposed through an eventfd.  The
> > user can specify the GSI and optionally an IRQ source ID and have the
> > provided eventfd trigger whenever the irqchip resamples it's inputs,
> > for instance on EOI.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> >  Documentation/virtual/kvm/api.txt |   18 ++
> >  arch/x86/kvm/x86.c                |    2 
> >  include/linux/kvm.h               |   16 ++
> >  include/linux/kvm_host.h          |   13 ++
> >  virt/kvm/eventfd.c                |  285 +++++++++++++++++++++++++++++++++++++
> >  virt/kvm/kvm_main.c               |   10 +
> >  6 files changed, 344 insertions(+)
> > 
> > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > index 17cd599..77b4837 100644
> > --- a/Documentation/virtual/kvm/api.txt
> > +++ b/Documentation/virtual/kvm/api.txt
> > @@ -2011,6 +2011,24 @@ of IRQ source IDs.  These IDs are also shared with KVM internal users
> >  (ex. KVM assigned devices, PIT, shared user ID), therefore not all IDs
> >  may be allocated through this interface.
> >  
> > +4.78 KVM_IRQ_ACKFD
> > +
> > +Capability: KVM_CAP_IRQ_ACKFD
> > +Architectures: x86
> > +Type: vm ioctl
> > +Parameters: struct kvm_irq_ackfd (in)
> > +Returns: 0 on success, -errno on error
> > +
> > +Allows userspace notification of IRQ ACKs, or resampling of irqchip
> > +inputs, often associated with an EOI.  User provided kvm_irq_ackfd.fd
> > +and kvm_irq_ackfd.gsi are required and result in an eventfd trigger
> > +whenever the GSI is acknowledged.  When KVM_CAP_IRQ_ACKFD_IRQ_SOURCE_FD
> > +is available, KVM_IRQ_ACKFD supports the KVM_IRQ_ACKFD_FLAG_IRQ_SOURCE_ID
> > +flag which indicates kvm_irqfd.irq_source_id is provided.  With this,
> > +the eventfd is only triggered when the specified IRQ source ID is
> > +pending.  On deassign, fd, gsi, and irq_source_id (if provided on assign)
> > +must be provided.
> > +
> >
> 
> This seems to imply that ACKFD can be used with edge
> GSIs, but this does not actually work: with source ID
> because of the filtering, and without because of PV EOI.
> It seems that what we are really tracking is
> level change 1->0. For edge no level -> no notification?
> 
> Or does 'resampling of irqchip inputs' imply level somehow?

AIUI, there's some sort of resampling for edge inputs, but I'm by no
means an expert.  In earlier versions I defined this as level-only,
undefined results for edge, but Gleb thought it might be useful for
clock drift problems.  There seem to be other complications for using it
for that, so maybe we can go back to this being defined for level-only
and undefined for edge.  I'd probably vote for a documentation-only
change vs trying to validate that a irqchip pin is programmed for level
at the time of this ioctl.

...
> > +static int kvm_assign_irq_ackfd(struct kvm *kvm, struct kvm_irq_ackfd *args)
> > +{
> > +	struct file *file = NULL;
> > +	struct eventfd_ctx *eventfd = NULL;
> > +	struct _irq_ackfd *ackfd = NULL, *tmp;
> > +	int ret;
> > +	u64 cnt;
> > +
> > +	file = eventfd_fget(args->fd);
> > +	if (IS_ERR(file)) {
> > +		ret = PTR_ERR(file);
> > +		goto fail;
> > +	}
> > +
> > +	eventfd = eventfd_ctx_fileget(file);
> > +	if (IS_ERR(eventfd)) {
> > +		ret = PTR_ERR(eventfd);
> > +		goto fail;
> > +	}
> > +
> > +	ackfd = kzalloc(sizeof(*ackfd), GFP_KERNEL);
> > +	if (!ackfd) {
> > +		ret = -ENOMEM;
> > +		goto fail;
> > +	}
> > +
> > +	INIT_LIST_HEAD(&ackfd->list);
> > +	INIT_WORK(&ackfd->shutdown, irq_ackfd_shutdown);
> > +	ackfd->kvm = kvm;
> > +	ackfd->eventfd = eventfd;
> > +	ackfd->notifier.gsi = args->gsi;
> > +	if (args->flags & KVM_IRQ_ACKFD_FLAG_IRQ_SOURCE_ID)
> > +		ackfd->notifier.irq_source_id = args->irq_source_id;
> > +	else
> > +		ackfd->notifier.irq_source_id = -1;
> > +	ackfd->notifier.irq_acked = irq_ackfd_acked;
> > +
> > +	/*
> > +	 * Install our own custom wake-up handling so we are notified via
> > +	 * a callback whenever someone releases the underlying eventfd
> > +	 */
> > +	init_waitqueue_func_entry(&ackfd->wait, irq_ackfd_wakeup);
> > +	init_poll_funcptr(&ackfd->pt, irq_ackfd_ptable_queue_proc);
> > +
> > +	/*
> > +	 * Install the wait queue function to allow cleanup when the
> > +	 * eventfd is closed by the user.  This grabs the wqh lock, so
> > +	 * we do it out of spinlock, holding the file reference ensures
> > +	 * we won't see a POLLHUP until setup is complete.
> > +	 */
> > +	file->f_op->poll(file, &ackfd->pt);
> > +
> > +	spin_lock_irq(&kvm->irq_ackfds.lock);
> > +
> > +	/* Check for duplicates.  */
> > +	list_for_each_entry(tmp, &kvm->irq_ackfds.items, list) {
> > +		if (ackfd->eventfd == tmp->eventfd &&
> > +		    ackfd->notifier.gsi == tmp->notifier.gsi &&
> > +		    ackfd->notifier.irq_source_id ==
> > +		    tmp->notifier.irq_source_id) {
> > +			spin_unlock_irq(&kvm->irq_ackfds.lock);
> > +			ret = -EBUSY;
> > +			goto fail_unqueue;
> > +		}
> > +	}
> > +
> 
> So source ID is not validated at all, this means there are
> 4G ways for the same eventfd to be registered,
> drinking up unlimited kernel memory by means of kzalloc above.

Bitmap and cross-referencing mentioned in earlier patches also fix this.
Thanks,

Alex


