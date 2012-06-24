Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2FXV7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 17:59:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab2FXV7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 17:59:32 -0400
Message-ID: <1340575167.5076.165.camel@bling.home>
Subject: Re: [PATCH 3/4] kvm: Extend irqfd to support level interrupts
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Sun, 24 Jun 2012 15:59:27 -0600
In-Reply-To: <20120624154938.GE2851@redhat.com>
References: <20120622220040.9858.43665.stgit@bling.home>
	 <20120622221559.9858.59593.stgit@bling.home> <4FE6EC20.5030502@redhat.com>
	 <1340551118.14120.66.camel@bling.home> <20120624154938.GE2851@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-06-24 at 18:49 +0300, Michael S. Tsirkin wrote:
> On Sun, Jun 24, 2012 at 09:18:38AM -0600, Alex Williamson wrote:
> > > > @@ -242,7 +299,8 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
> > > >  
> > > >  	ret = 0;
> > > >  	list_for_each_entry(tmp, &kvm->irqfds.items, list) {
> > > > -		if (irqfd->eventfd != tmp->eventfd)
> > > > +		if (irqfd->eventfd != tmp->eventfd &&
> > > > +		    irqfd->eventfd != tmp->eoi_eventfd)
> > > >  			continue;
> > > 
> > > So we allow duplicate irqfd with differing eoifd (or edge-triggered and
> > > level-triggered irqfd on the same context).
> > > 
> > > (why the check in the first place? just so we can have a reliable
> > > deassign or is it avoiding a deeper problem?)
> > 
> > I really wasn't sure to what extent we wanted to prevent duplicates.  My
> > guess was that we don't want to have an irqfd trigger more than one
> > thing.  That seems to be what the current code does.  I don't see any
> > problems with multiple irqfds triggering the same eventfd though.  I
> > only added a test that a new irqfd can't be triggered by an existing
> > eoi_eventfd as that could make a nasty loop.
> 
> How would that make a loop? You can have the same thing
> with e.g. ioeventfd - why isn't it a problem there?

eoi_eventfd1 -> irqfd2 [eoi] eoi_eventfd2 -> irqfd1 [eoi] eoi_eventfd1 ->...

Yes, in reality we'd need to search fds from all the interfaces and come
up with some grossly complicated truth table of what's allowed and
what's not.  The original code didn't go to that kind of extreme, so I
just added something that seemed like a reasonable case
we'd want to prevent.  Thanks,

Alex

