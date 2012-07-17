Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab2GQWY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:24:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab2GQWYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:24:24 -0400
Date: Wed, 18 Jul 2012 01:24:55 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v5 2/4] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120717222455.GI1868@redhat.com>
References: <20120717151327.GC11587@redhat.com>
 <1342539669.2229.114.camel@bling.home>
 <20120717155325.GA12001@redhat.com>
 <1342541161.2229.123.camel@bling.home>
 <20120717161919.GB12114@redhat.com>
 <1342543936.2229.138.camel@bling.home>
 <20120717185803.GC13066@redhat.com>
 <1342555385.2229.152.camel@bling.home>
 <20120717212314.GB1868@redhat.com>
 <1342562965.2229.162.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342562965.2229.162.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 04:09:25PM -0600, Alex Williamson wrote:
> On Wed, 2012-07-18 at 00:23 +0300, Michael S. Tsirkin wrote:
> > On Tue, Jul 17, 2012 at 02:03:05PM -0600, Alex Williamson wrote:
> > > On Tue, 2012-07-17 at 21:58 +0300, Michael S. Tsirkin wrote:
> > > > On Tue, Jul 17, 2012 at 10:52:16AM -0600, Alex Williamson wrote:
> > > > > On Tue, 2012-07-17 at 19:19 +0300, Michael S. Tsirkin wrote:
> > > > > > On Tue, Jul 17, 2012 at 10:06:01AM -0600, Alex Williamson wrote:
> > > > > > > On Tue, 2012-07-17 at 18:53 +0300, Michael S. Tsirkin wrote:
> > > > > > > > On Tue, Jul 17, 2012 at 09:41:09AM -0600, Alex Williamson wrote:
> > > > > > > > > On Tue, 2012-07-17 at 18:13 +0300, Michael S. Tsirkin wrote:
> > > > > > > > > > On Tue, Jul 17, 2012 at 08:57:04AM -0600, Alex Williamson wrote:
> > > > > > > > > > > On Tue, 2012-07-17 at 17:42 +0300, Michael S. Tsirkin wrote:
> > > > > > > > > > > > On Tue, Jul 17, 2012 at 08:29:43AM -0600, Alex Williamson wrote:
> > > > > > > > > > > > > On Tue, 2012-07-17 at 17:10 +0300, Michael S. Tsirkin wrote:
> > > > > > > > > > > > > > On Tue, Jul 17, 2012 at 07:59:16AM -0600, Alex Williamson wrote:
> > > > > > > > > > > > > > > On Tue, 2012-07-17 at 13:21 +0300, Michael S. Tsirkin wrote:
> > > > > > > > > > > > > > > > On Mon, Jul 16, 2012 at 02:33:55PM -0600, Alex Williamson wrote:
> > > > > > > > > > > > > > > > > +	if (args->flags & KVM_EOIFD_FLAG_LEVEL_IRQFD) {
> > > > > > > > > > > > > > > > > +		struct _irqfd *irqfd = _irqfd_fdget_lock(kvm, args->irqfd);
> > > > > > > > > > > > > > > > > +		if (IS_ERR(irqfd)) {
> > > > > > > > > > > > > > > > > +			ret = PTR_ERR(irqfd);
> > > > > > > > > > > > > > > > > +			goto fail;
> > > > > > > > > > > > > > > > > +		}
> > > > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > > > +		gsi = irqfd->gsi;
> > > > > > > > > > > > > > > > > +		level_irqfd = eventfd_ctx_get(irqfd->eventfd);
> > > > > > > > > > > > > > > > > +		source = _irq_source_get(irqfd->source);
> > > > > > > > > > > > > > > > > +		_irqfd_put_unlock(irqfd);
> > > > > > > > > > > > > > > > > +		if (!source) {
> > > > > > > > > > > > > > > > > +			ret = -EINVAL;
> > > > > > > > > > > > > > > > > +			goto fail;
> > > > > > > > > > > > > > > > > +		}
> > > > > > > > > > > > > > > > > +	} else {
> > > > > > > > > > > > > > > > > +		ret = -EINVAL;
> > > > > > > > > > > > > > > > > +		goto fail;
> > > > > > > > > > > > > > > > > +	}
> > > > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > > > +	INIT_LIST_HEAD(&eoifd->list);
> > > > > > > > > > > > > > > > > +	eoifd->kvm = kvm;
> > > > > > > > > > > > > > > > > +	eoifd->eventfd = eventfd;
> > > > > > > > > > > > > > > > > +	eoifd->source = source;
> > > > > > > > > > > > > > > > > +	eoifd->level_irqfd = level_irqfd;
> > > > > > > > > > > > > > > > > +	eoifd->notifier.gsi = gsi;
> > > > > > > > > > > > > > > > > +	eoifd->notifier.irq_acked = eoifd_event;
> > > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > > OK so this means eoifd keeps a reference to the irqfd.
> > > > > > > > > > > > > > > > And since this is the case, can't we drop the reference counting
> > > > > > > > > > > > > > > > around source ids now? Everything is referenced through irqfd.
> > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > Holding a reference and using it as a reference count are not the same
> > > > > > > > > > > > > > > thing.  What if another module holds a reference to this eventfd?  How
> > > > > > > > > > > > > > > do we do anything on release?
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > We don't as there is no release, and using kref on source id does not
> > > > > > > > > > > > > > help: it just never gets invoked.
> > > > > > > > > > > > > 
> > > > > > > > > > > > > Please work out how you think it should work and let me know, I don't
> > > > > > > > > > > > > see it.  We have an irq source id that needs to be allocated by irqfd
> > > > > > > > > > > > > and returned when it's unused.  It becomes unused when neither irqfd nor
> > > > > > > > > > > > > eoifd are making use of it.  irqfd and eoifd may be closed in any order.
> > > > > > > > > > > > > Use of the source id is what we're reference counting, which is why it's
> > > > > > > > > > > > > in struct _irq_source.  How can I use an eventfd reference for the same?
> > > > > > > > > > > > > I don't know when it's unused.  I don't know who else holds a reference
> > > > > > > > > > > > > to it...  Doesn't make sense to me.  Feels like attempting to squat on
> > > > > > > > > > > > > someone else's object.
> > > > > > > > > > > > > 
> > > > > > > > > > > > > 
> > > > > > > > > > > > 
> > > > > > > > > > > > eoifd should prevent irqfd from being released.
> > > > > > > > > > > 
> > > > > > > > > > > Why?  Note that this is actually quite difficult too.  We can't fail a
> > > > > > > > > > > release, nobody checks close(3p) return.  Blocking a release is likely
> > > > > > > > > > > to cause all sorts of problems, so what you mean is that irqfd should
> > > > > > > > > > > linger around until there are no references to it... but that's exactly
> > > > > > > > > > > what struct _irq_source is for, is to hold the bits that we care about
> > > > > > > > > > > references to and automatically release it when there are none.
> > > > > > > > > > 
> > > > > > > > > > No no. You *already* prevent it. You take a reference to the eventfd
> > > > > > > > > > context.
> > > > > > > > > 
> > > > > > > > > Right, which keeps the fd from going away, not the struct _irqfd.
> > > > > > > > 
> > > > > > > > _irqfd too.
> > > > > > > 
> > > > > > > 
> > > > > > > How so?
> > > > > > 
> > > > > > Normally irqfd_wakeup is called with POLLHUP and calls irqfd_deactivate.
> > > > > > If you get a ctx reference this does not happen.
> > > > > 
> > > > > I think you're mistaken.  wake_up_poll(,POLLHUP) is called from
> > > > > eventfd_release (file_operations.release), not from ctx reference
> > > > > release.
> > > > 
> > > > True. I was wrong. so close has the same bug as deassign. To fix,
> > > > how about eoifd will hold a reference to the irqfd instead of the
> > > > eventfd context?
> > > 
> > > What does it mean to hold a reference to the irqfd?
> > 
> > I meant file *reference: eventfd_fget. But there are other options see
> > below.
> 
> That's no better than the eventfd context we already hold.

It means POLLHUP is not invoked until eoifd is closed.

> > > What state of functionality is an irqfd that has been
> > > closed/de-assigned but is still attached to an eoifd?  It can't
> > > continue to fire interrupts into the guest.
> > >
> > > I don't think close or de-assign have a bug, assign has a bug that it
> > > can allow re-assignment using an in-use eventfd.  I think I'd rather
> > > fix that.
> > 
> > Let me show you that the bug is in deassign:
> > 	assign irqfd for fd=1
> > 	assign for eoifd fd=2, irqfd=1
> > 	deassign irqfd 1
> > 
> > At this point eoifd has no meaning and there is also no way to deassign
> > it,
> 
> Yes, there is.  This is exactly why I hold a reference to the eventfd
> ctx.  It can still be deassigned by passing irqfd=1, we'll do an
> eventfd_ctx_get and match it to that stored.

OK.
What if instead we close irqfd 1?

> >  so the bug already triggered.
> >
> > I can see two ways out:
> > 1. easy way - fail deassign
> 
> Then close() and deassign are not the same.
> 
> > 2. elegant way - shut down eoifd on irqfd deassign too
> 
> Sorry, I've always been told it's a bad idea to have one interface kill
> another from inside the kernel.

Not kill merely deassign.

> Given that your assertion above is incorrect, I still stand by fixing
> assign.

OK, but then you also would need to protect against someone binding
an irqfd that is not level to same GSI.

Also if we go ahead with fixing assign - I do not think we need
to rebind to the same source id - just failing assign
of this irqfd with EBUSY should be enough.

-- 
MST
