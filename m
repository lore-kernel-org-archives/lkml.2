Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab2GQOJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:09:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab2GQOJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:09:38 -0400
Date: Tue, 17 Jul 2012 17:10:02 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v5 2/4] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120717141002.GC10822@redhat.com>
References: <20120716202711.1752.71007.stgit@bling.home>
 <20120716203353.1752.19127.stgit@bling.home>
 <20120717102139.GG7949@redhat.com>
 <1342533556.3229.7.camel@ul30vt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342533556.3229.7.camel@ul30vt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 07:59:16AM -0600, Alex Williamson wrote:
> On Tue, 2012-07-17 at 13:21 +0300, Michael S. Tsirkin wrote:
> > On Mon, Jul 16, 2012 at 02:33:55PM -0600, Alex Williamson wrote:
> > > +	if (args->flags & KVM_EOIFD_FLAG_LEVEL_IRQFD) {
> > > +		struct _irqfd *irqfd = _irqfd_fdget_lock(kvm, args->irqfd);
> > > +		if (IS_ERR(irqfd)) {
> > > +			ret = PTR_ERR(irqfd);
> > > +			goto fail;
> > > +		}
> > > +
> > > +		gsi = irqfd->gsi;
> > > +		level_irqfd = eventfd_ctx_get(irqfd->eventfd);
> > > +		source = _irq_source_get(irqfd->source);
> > > +		_irqfd_put_unlock(irqfd);
> > > +		if (!source) {
> > > +			ret = -EINVAL;
> > > +			goto fail;
> > > +		}
> > > +	} else {
> > > +		ret = -EINVAL;
> > > +		goto fail;
> > > +	}
> > > +
> > > +	INIT_LIST_HEAD(&eoifd->list);
> > > +	eoifd->kvm = kvm;
> > > +	eoifd->eventfd = eventfd;
> > > +	eoifd->source = source;
> > > +	eoifd->level_irqfd = level_irqfd;
> > > +	eoifd->notifier.gsi = gsi;
> > > +	eoifd->notifier.irq_acked = eoifd_event;
> > 
> > OK so this means eoifd keeps a reference to the irqfd.
> > And since this is the case, can't we drop the reference counting
> > around source ids now? Everything is referenced through irqfd.
> 
> Holding a reference and using it as a reference count are not the same
> thing.  What if another module holds a reference to this eventfd?  How
> do we do anything on release?

We don't as there is no release, and using kref on source id does not
help: it just never gets invoked.

-- 
MST

