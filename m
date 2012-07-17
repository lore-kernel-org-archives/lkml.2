Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab2GQWWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:22:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab2GQWWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:22:13 -0400
Message-ID: <1342563730.2229.170.camel@bling.home>
Subject: Re: [PATCH v5 3/4] kvm: Create kvm_clear_irq()
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Tue, 17 Jul 2012 16:22:10 -0600
In-Reply-To: <20120717220552.GG1868@redhat.com>
References: <20120717155701.GB12001@redhat.com>
	 <1342541301.2229.125.camel@bling.home> <20120717161452.GA12114@redhat.com>
	 <1342541823.2229.127.camel@bling.home> <20120717162115.GC12114@redhat.com>
	 <1342543552.2229.136.camel@bling.home> <20120717185542.GB13066@redhat.com>
	 <1342554687.2229.144.camel@bling.home> <20120717210543.GA1868@redhat.com>
	 <1342562500.2229.158.camel@bling.home> <20120717220552.GG1868@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 01:05 +0300, Michael S. Tsirkin wrote:
> On Tue, Jul 17, 2012 at 04:01:40PM -0600, Alex Williamson wrote:
> > On Wed, 2012-07-18 at 00:05 +0300, Michael S. Tsirkin wrote:
> > > On Tue, Jul 17, 2012 at 01:51:27PM -0600, Alex Williamson wrote:
> > > > On Tue, 2012-07-17 at 21:55 +0300, Michael S. Tsirkin wrote:
> > > > > On Tue, Jul 17, 2012 at 10:45:52AM -0600, Alex Williamson wrote:
> > > > > > On Tue, 2012-07-17 at 19:21 +0300, Michael S. Tsirkin wrote:
> > > > > > > On Tue, Jul 17, 2012 at 10:17:03AM -0600, Alex Williamson wrote:
> > > > > > > > > > > > > > >   And current code looks buggy if yes we need to fix it somehow.
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > Which to me seems to indicate this should be handled as a separate
> > > > > > > > > > > > > > effort.
> > > > > > > > > > > > > 
> > > > > > > > > > > > > A separate patchset, sure. But likely a prerequisite: we still need to
> > > > > > > > > > > > > look at all the code. Let's not copy bugs, need to fix them.
> > > > > > > > > > > > 
> > > > > > > > > > > > This looks tangential to me unless you can come up with an actual reason
> > > > > > > > > > > > the above spinlock usage is incorrect or insufficient.
> > > > > > > > > > > 
> > > > > > > > > > > You copy the same pattern that seems racy. So you double the
> > > > > > > > > > > amount of code that woul need to be fixed.
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > _Seems_ racy, or _is_ racy?  Please identify the race.
> > > > > > > > > 
> > > > > > > > > Look at this:
> > > > > > > > > 
> > > > > > > > > static inline int kvm_irq_line_state(unsigned long *irq_state,
> > > > > > > > >                                      int irq_source_id, int level)
> > > > > > > > > {
> > > > > > > > >         /* Logical OR for level trig interrupt */
> > > > > > > > >         if (level)
> > > > > > > > >                 set_bit(irq_source_id, irq_state);
> > > > > > > > >         else
> > > > > > > > >                 clear_bit(irq_source_id, irq_state);
> > > > > > > > > 
> > > > > > > > >         return !!(*irq_state);
> > > > > > > > > }
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > Now:
> > > > > > > > > If other CPU changes some other bit after the atomic change,
> > > > > > > > > it looks like !!(*irq_state) might return a stale value.
> > > > > > > > > 
> > > > > > > > > CPU 0 clears bit 0. CPU 1 sets bit 1. CPU 1 sets level to 1.
> > > > > > > > > If CPU 0 sees a stale value now it will return 0 here
> > > > > > > > > and interrupt will get cleared.
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > Maybe this is not a problem. But in that case IMO it needs
> > > > > > > > > a comment explaining why and why it's not a problem in
> > > > > > > > > your code.
> > > > > > > > 
> > > > > > > > So you want to close the door on anything that uses kvm_set_irq until
> > > > > > > > this gets fixed... that's insane.
> > > > > > > 
> > > > > > > What does kvm_set_irq use have to do with it?  You posted this patch:
> > > > > > > 
> > > > > > > +static int kvm_clear_pic_irq(struct kvm_kernel_irq_routing_entry *e,
> > > > > > > +                            struct kvm *kvm, int irq_source_id)
> > > > > > > +{
> > > > > > > +#ifdef CONFIG_X86
> > > > > > > +       struct kvm_pic *pic = pic_irqchip(kvm);
> > > > > > > +       int level =
> > > > > > > kvm_clear_irq_line_state(&pic->irq_states[e->irqchip.pin],
> > > > > > > +                                            irq_source_id);
> > > > > > > +       if (level)
> > > > > > > +               kvm_pic_set_irq(pic, e->irqchip.pin,
> > > > > > > +                               !!pic->irq_states[e->irqchip.pin]);
> > > > > > > +       return level;
> > > > > > > +#else
> > > > > > > +       return -1;
> > > > > > > +#endif
> > > > > > > +}
> > > > > > > +
> > > > > > > 
> > > > > > > it seems racy in the same way.
> > > > > > 
> > > > > > Now you're just misrepresenting how we got here, which was:
> > > > > > 
> > > > > > > > > > > > IMHO, we're going off into the weeds again with these last
> > > > > > > > > > > > two patches.  It may be a valid optimization, but it really has no
> > > > > > > > > > > > bearing on the meat of the series (and afaict, no significant
> > > > > > > > > > > > performance difference either).
> > > > > > > > > > > 
> > > > > > > > > > > For me it's not a performance thing. IMO code is cleaner without this locking:
> > > > > > > > > > > we add a lock but only use it in some cases, so the rules become really
> > > > > > > > > > > complex.
> > > > > > 
> > > > > > So I'm happy to drop the last 2 patches, which were done at your request
> > > > > > anyway, but you've failed to show how the locking in patches 1&2 is
> > > > > > messy, inconsistent, or complex and now you're asking to block all
> > > > > > progress.
> > > > > 
> > > > > I'm asking for bugs to get fixed and not duplicated. Adding more bugs is
> > > > > not progress. Or maybe there is no bug. Let's see why and add a comment.
> > > > > 
> > > > > >  Those patches are just users of kvm_set_irq.
> > > > > 
> > > > > 
> > > > > Well these add calls to kvm_set_irq which scans all vcpus under
> > > > > spinlock. In the past Avi thought this is not a good idea too.
> > > > > Maybe things changed.
> > > > 
> > > > We can drop the spinlock if we don't care about spurious EOIs, which is
> > > > only a theoretical scalability problem anyway.
> > > 
> > > Not theoretical at all IMO. We see the problem with virtio with old
> > > guests today.
> > 
> > And how are you injecting level interrupts with virtio today w/o this
> > interface?
> 
> Not well at all. Bad performance with interrupt sharing.
> 
> > > > We're talking about
> > > > level interrupts here, how scalable do we need to be?
> > > > 
> > > 
> > > The reason we are moving them into kernel at all is for speed, no?
> > 
> > Come on, if we take that approach why aren't we writing all of this in
> > assembly for speed?!  All I'm suggesting is there's a limit to return on
> > investment at some point.  Maybe it's here.
> 
> Well I am just warning about known problems: don't wake up (typically)
> many eoifds on a single interrupt or you will have scalability
> problems that we already see with emulated devices.

Well, that's why we don't want to bounce back to userspace.  All we need
to do in VFIO for each callback is note that the interrupt wasn't
previously masked and do nothing.  So we're talking about acquiring a
spinlock and a few data references.  Sure, I'd like to avoid doing that,
but not if it means blocking this patch series until some unknown number
of patches fixes all the tangential problems you find.

