Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab2GRTQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 15:16:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab2GRTQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 15:16:27 -0400
Date: Wed, 18 Jul 2012 22:16:59 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v5 1/4] kvm: Extend irqfd to support level interrupts
Message-ID: <20120718191659.GG2498@redhat.com>
References: <20120718113910.GA5135@redhat.com>
 <20120718114844.GH26120@redhat.com>
 <20120718120705.GB5184@redhat.com>
 <1342622843.2229.200.camel@bling.home>
 <20120718153822.GC1777@redhat.com>
 <1342626481.2229.205.camel@bling.home>
 <20120718155823.GG1777@redhat.com>
 <20120718184209.GA14053@amt.cnet>
 <1342638437.2229.213.camel@bling.home>
 <1342638786.2229.216.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342638786.2229.216.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 01:13:06PM -0600, Alex Williamson wrote:
> On Wed, 2012-07-18 at 13:07 -0600, Alex Williamson wrote:
> > On Wed, 2012-07-18 at 15:42 -0300, Marcelo Tosatti wrote:
> > > On Wed, Jul 18, 2012 at 06:58:24PM +0300, Michael S. Tsirkin wrote:
> > > > > > > > > Back to original point though current
> > > > > > > > > situation is that calling kvm_set_irq() under spinlock is not worse for
> > > > > > > > > scalability than calling it not under one.
> > > > > > > > 
> > > > > > > > Yes. Still the specific use can just use an atomic flag,
> > > > > > > > lock+bool is not needed, and we won't need to undo it later.
> > > > > > > 
> > > > > > > 
> > > > > > > Actually, no, replacing it with an atomic is racy.
> > > > > > > 
> > > > > > > CPU0 (inject)                       CPU1 (EOI)
> > > > > > > atomic_cmpxchg(&asserted, 0, 1)
> > > > > > >                                     atomic_cmpxchg(&asserted, 1, 0)
> > > > > > >                                     kvm_set_irq(0)
> > > > > > > kvm_set_irq(1)
> > > > > > >                                     eventfd_signal
> > > > > > > 
> > > > > > > The interrupt is now stuck on until another interrupt is injected.
> > > > > > > 
> > > > > > 
> > > > > > Well EOI somehow happened here before interrupt so it's a bug somewhere
> > > > > > else?
> > > > > 
> > > > > Interrupts can be shared.  We also can't guarantee that the guest won't
> > > > > write a bogus EOI to the ioapic.  The irq ack notifier doesn't filter on
> > > > > irq source id... I'm not sure it can.
> > > > 
> > > > I guess if Avi OKs adding another kvm_set_irq under spinlock that's
> > > > the best we can do for now.
> > > 
> > > Why can't a mutex be used instead of a spinlock again?
> > 
> > eventfd_signal calls the inject function from atomic context.
> 
> Actually, that's called from a workq.  I'll have to switch it back and
> turn on lockdep to remember why I couldn't sleep there.


I'll try to fix kvm_set_irq so it returns 0 if level was already 0.
Then you do not need extra state.

-- 
MST
