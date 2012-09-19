Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab2IST5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:57:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab2IST5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 15:57:36 -0400
Date: Wed, 19 Sep 2012 22:59:09 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/2] kvm: Add resampling irqfds for level triggered
 interrupts
Message-ID: <20120919195909.GA1279@redhat.com>
References: <20120918031156.12021.27838.stgit@bling.home>
 <20120918031626.12021.90083.stgit@bling.home>
 <50598975.50503@redhat.com>
 <1348078993.28860.37.camel@bling.home>
 <20120919184818.GB312@redhat.com>
 <1348082615.28860.58.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348082615.28860.58.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 01:23:35PM -0600, Alex Williamson wrote:
> On Wed, 2012-09-19 at 21:48 +0300, Michael S. Tsirkin wrote:
> > On Wed, Sep 19, 2012 at 12:23:13PM -0600, Alex Williamson wrote:
> > > On Wed, 2012-09-19 at 11:59 +0300, Avi Kivity wrote:
> > > > On 09/18/2012 06:16 AM, Alex Williamson wrote:
> > > > > @@ -92,6 +156,43 @@ irqfd_shutdown(struct work_struct *work)
> > > > >  	 */
> > > > >  	flush_work_sync(&irqfd->inject);
> > > > >  
> > > > > +	if (irqfd->resampler) {
> > > > > +		struct _irqfd_resampler *resampler = irqfd->resampler;
> > > > > +		struct kvm *kvm = resampler->kvm;
> > > > > +
> > > > > +		mutex_lock(&kvm->irq_lock);
> > > > > +		spin_lock_irq(&irqfd->kvm->irqfds.lock);
> > > > > +
> > > > > +		list_del_rcu(&irqfd->resampler_list);
> > > > > +
> > > > > +		/*
> > > > > +		 * On removal of the last irqfd in the resampler list,
> > > > > +		 * remove the resampler and unregister the irq ack
> > > > > +		 * notifier.  It's possible to race the ack of the final
> > > > > +		 * injection here, so manually de-assert the gsi to avoid
> > > > > +		 * leaving an unmanaged, asserted interrupt line.
> > > > > +		 */
> > > > > +		if (list_empty(&resampler->irqfds)) {
> > > > > +			list_del(&resampler->list);
> > > > > +			__kvm_unregister_irq_ack_notifier(kvm,
> > > > > +							  &resampler->notifier);
> > > > > +			kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
> > > > > +				    resampler->notifier.gsi, 0);
> > > > > +			kfree(resampler);
> > > > 
> > > > Is this rcu safe?
> > > 
> > > No it's not and unfortunately this also points out another race in
> > > trying to use a single source ID...
> > > 
> > > > > +		}
> > > > > +
> > > > > +		spin_unlock_irq(&irqfd->kvm->irqfds.lock);
> > > > > +		mutex_unlock(&kvm->irq_lock);
> > > > > +
> > > > > +		/*
> > > > > +		 * Both list_del_rcu & __kvm_unregister_irq_ack_notifier
> > > > > +		 * require an rcu grace period/
> > > > > +		 */
> > > > > +		synchronize_rcu();
> > > 
> > > The kfree can't be done until here and we also have to assume that ack
> > > notifies are firing until here.  That means that between the
> > > mutex_unlock and the end of synchronize_rcu another resampling irqfd can
> > > be registered, post an interrupt, and have it de-asserted by the wrong
> > > resampler.  Maybe the conversion wasn't as clean as I first thought :(
> > > > Quite ugly to expose the internals this way.
> > > 
> > > Yep.  I don't know how to clean it up though; between all the different
> > > rcu operations and locks, it's a mess.  Thanks,
> > > 
> > > Alex
> > 
> > Add another mutex for the resamplers, keep it during the whole
> > operation? This also removes the need for exposing the internals.
> > If you do pls document lock nesting rules.
> 
> How does that hide the internals?

You can call kvm_unregister_irq_ack_notifier now.

> Seems like we'd just wrap this in yet
> another mutex, but be largely the same.

The key is synchronize_rcu is under mutex.

>  Thanks,
> 
> Alex
