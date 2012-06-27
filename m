Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab2F0WIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:08:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab2F0WID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:08:03 -0400
Date: Thu, 28 Jun 2012 00:14:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 4/6] kvm: Extend irqfd to support level interrupts
Message-ID: <20120627211413.GE27746@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
 <20120627050937.23698.68442.stgit@bling.home>
 <20120627095137.GH17507@redhat.com>
 <1340830749.1207.236.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340830749.1207.236.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 02:59:09PM -0600, Alex Williamson wrote:
> On Wed, 2012-06-27 at 12:51 +0300, Michael S. Tsirkin wrote:
> > On Tue, Jun 26, 2012 at 11:09:46PM -0600, Alex Williamson wrote:
> > > In order to inject an interrupt from an external source using an
> > > irqfd, we need to allocate a new irq_source_id.  This allows us to
> > > assert and (later) de-assert an interrupt line independently from
> > > users of KVM_IRQ_LINE and avoid lost interrupts.
> > > 
> > > We also add what may appear like a bit of excessive infrastructure
> > > around an object for storing this irq_source_id.  However, notice
> > > that we only provide a way to assert the interrupt here.  A follow-on
> > > interface will make use of the same irq_source_id to allow de-assert.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---
> > > 
> > >  Documentation/virtual/kvm/api.txt |    5 ++
> > >  arch/x86/kvm/x86.c                |    1 
> > >  include/linux/kvm.h               |    3 +
> > >  virt/kvm/eventfd.c                |   95 +++++++++++++++++++++++++++++++++++--
> > >  4 files changed, 99 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > > index ea9edce..b216709 100644
> > > --- a/Documentation/virtual/kvm/api.txt
> > > +++ b/Documentation/virtual/kvm/api.txt
> > > @@ -1981,6 +1981,11 @@ the guest using the specified gsi pin.  The irqfd is removed using
> > >  the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
> > >  and kvm_irqfd.gsi.
> > >  
> > > +With KVM_IRQFD_FLAG_LEVEL KVM_IRQFD allocates a new IRQ source ID for
> > > +the requested irqfd.  This is necessary to share level triggered
> > > +interrupts with those injected through KVM_IRQ_LINE.  IRQFDs created
> > > +with KVM_IRQFD_FLAG_LEVEL must also set this flag when de-assiging.
> > > +KVM_IRQFD_FLAG_LEVEL support is indicated by KVM_CAP_IRQFD_LEVEL.
> > 
> > Note that if my patch removing auto-deassert gets accepted,
> > this is not needed at all: we can just look at the GSI
> > to see if it's level or edge.
> 
> I'm not sure this is a good idea.  I know from vfio that I'm injecting a
> level interrupt regardless of how the guest has the pic/ioapic
> programmed at the time I'm calling this ioctl.  Peeking across address
> spaces to get to the right pin on the right pic/ioapic and see how it's
> currently programmed seems fragile.  Thanks,
> 
> Alex

Fragile? If you set eventfd as LEVEL but GSI is really edge then
it all explodes, right? So why give users the option to shoot
themselves in the foot?


-- 
MST
