Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab2ISJHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 05:07:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab2ISJHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 05:07:12 -0400
Date: Wed, 19 Sep 2012 12:08:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/2] kvm: Add resampling irqfds for level triggered
 interrupts
Message-ID: <20120919090845.GA26517@redhat.com>
References: <20120918031156.12021.27838.stgit@bling.home>
 <20120918031626.12021.90083.stgit@bling.home>
 <50598975.50503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50598975.50503@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 11:59:33AM +0300, Avi Kivity wrote:
> > @@ -247,9 +383,36 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
> >  		/* This fd is used for another irq already. */
> >  		ret = -EBUSY;
> >  		spin_unlock_irq(&kvm->irqfds.lock);
> > +		mutex_unlock(&kvm->irq_lock);
> >  		goto fail;
> >  	}
> >  
> > +	if (resampler) {
> > +		struct _irqfd_resampler *resampler_tmp;
> > +
> > +		/*
> > +		 * Re-use a resampler if it's already registered on the
> > +		 * gsi we need.  Free the one we created above if found,
> > +		 * otherwise add to the list and setup the irq ack notifier.
> > +		 */
> > +		list_for_each_entry(resampler_tmp,
> > +				    &kvm->irqfds.resamplers, list) {
> > +			if (resampler_tmp->notifier.gsi == irqfd->gsi) {
> > +				irqfd->resampler = resampler_tmp;
> > +				break;
> > +			}
> > +		}
> > +
> > +		if (irqfd->resampler == resampler) {
> > +			list_add(&resampler->list, &kvm->irqfds.resamplers);
> > +			__kvm_register_irq_ack_notifier(kvm,
> > +							&resampler->notifier);
> > +		} else
> > +			kfree(resampler);
> > +
> > +		list_add_rcu(&irqfd->resampler_list, &irqfd->resampler->irqfds);
> > +	}
> > +
> 
> Whoa.  Can't we put the resampler entry somewhere we don't need to
> search for it?  Like a kvm_kernel_irq_routing_entry, that's indexed by
> gsi already (kvm_irq_routing_table::rt_entries[gsi]).

I'm not sure why would we bother optimizing this,
but if we do, I guess we could look for the irq notifier
which is already indexed by gsi.


> 
> 
> -- 
> error compiling committee.c: too many arguments to function
