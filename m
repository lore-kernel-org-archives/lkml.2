Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2ISSXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:23:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab2ISSXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:23:14 -0400
Message-ID: <1348078993.28860.37.camel@bling.home>
Subject: Re: [PATCH v10 2/2] kvm: Add resampling irqfds for level triggered
 interrupts
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Sep 2012 12:23:13 -0600
In-Reply-To: <50598975.50503@redhat.com>
References: <20120918031156.12021.27838.stgit@bling.home>
	 <20120918031626.12021.90083.stgit@bling.home> <50598975.50503@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-19 at 11:59 +0300, Avi Kivity wrote:
> On 09/18/2012 06:16 AM, Alex Williamson wrote:
> > @@ -92,6 +156,43 @@ irqfd_shutdown(struct work_struct *work)
> >  	 */
> >  	flush_work_sync(&irqfd->inject);
> >  
> > +	if (irqfd->resampler) {
> > +		struct _irqfd_resampler *resampler = irqfd->resampler;
> > +		struct kvm *kvm = resampler->kvm;
> > +
> > +		mutex_lock(&kvm->irq_lock);
> > +		spin_lock_irq(&irqfd->kvm->irqfds.lock);
> > +
> > +		list_del_rcu(&irqfd->resampler_list);
> > +
> > +		/*
> > +		 * On removal of the last irqfd in the resampler list,
> > +		 * remove the resampler and unregister the irq ack
> > +		 * notifier.  It's possible to race the ack of the final
> > +		 * injection here, so manually de-assert the gsi to avoid
> > +		 * leaving an unmanaged, asserted interrupt line.
> > +		 */
> > +		if (list_empty(&resampler->irqfds)) {
> > +			list_del(&resampler->list);
> > +			__kvm_unregister_irq_ack_notifier(kvm,
> > +							  &resampler->notifier);
> > +			kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
> > +				    resampler->notifier.gsi, 0);
> > +			kfree(resampler);
> 
> Is this rcu safe?

No it's not and unfortunately this also points out another race in
trying to use a single source ID...

> > +		}
> > +
> > +		spin_unlock_irq(&irqfd->kvm->irqfds.lock);
> > +		mutex_unlock(&kvm->irq_lock);
> > +
> > +		/*
> > +		 * Both list_del_rcu & __kvm_unregister_irq_ack_notifier
> > +		 * require an rcu grace period/
> > +		 */
> > +		synchronize_rcu();

The kfree can't be done until here and we also have to assume that ack
notifies are firing until here.  That means that between the
mutex_unlock and the end of synchronize_rcu another resampling irqfd can
be registered, post an interrupt, and have it de-asserted by the wrong
resampler.  Maybe the conversion wasn't as clean as I first thought :(

> Quite ugly to expose the internals this way.

Yep.  I don't know how to clean it up though; between all the different
rcu operations and locks, it's a mess.  Thanks,

Alex

