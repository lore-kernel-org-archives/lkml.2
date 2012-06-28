Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab2F1Qz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:55:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab2F1Qz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:55:27 -0400
Date: Thu, 28 Jun 2012 19:55:30 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 5/6] kvm: KVM_EOIFD, an eventfd for EOIs
Message-ID: <20120628165530.GA14382@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
 <20120627050952.23698.37235.stgit@bling.home>
 <20120627135811.GE6533@redhat.com>
 <1340807344.1207.207.camel@bling.home>
 <20120627145135.GF6533@redhat.com>
 <1340855744.1207.303.camel@bling.home>
 <20120628131140.GB13724@redhat.com>
 <20120628140804.GE2596@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628140804.GE2596@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 05:08:04PM +0300, Gleb Natapov wrote:
> On Thu, Jun 28, 2012 at 04:11:40PM +0300, Michael S. Tsirkin wrote:
> > On Wed, Jun 27, 2012 at 09:55:44PM -0600, Alex Williamson wrote:
> > > On Wed, 2012-06-27 at 17:51 +0300, Gleb Natapov wrote:
> > > > On Wed, Jun 27, 2012 at 08:29:04AM -0600, Alex Williamson wrote:
> > > > > On Wed, 2012-06-27 at 16:58 +0300, Gleb Natapov wrote:
> > > > > > On Tue, Jun 26, 2012 at 11:10:08PM -0600, Alex Williamson wrote:
> > > > > > > This new ioctl enables an eventfd to be triggered when an EOI is
> > > > > > > written for a specified irqchip pin.  By default this is a simple
> > > > > > > notification, but we can also tie the eoifd to a level irqfd, which
> > > > > > > enables the irqchip pin to be automatically de-asserted on EOI.
> > > > > > > This mode is particularly useful for device-assignment applications
> > > > > > > where the unmask and notify triggers a hardware unmask.  The default
> > > > > > > mode is most applicable to simple notify with no side-effects for
> > > > > > > userspace usage, such as Qemu.
> > > > > > > 
> > > > > > > Here we make use of the reference counting of the _irq_source
> > > > > > > object allowing us to share it with an irqfd and cleanup regardless
> > > > > > > of the release order.
> > > > > > > 
> > > > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > ---
> > > > > > > 
> > > > > > >  Documentation/virtual/kvm/api.txt |   24 +++++
> > > > > > >  arch/x86/kvm/x86.c                |    1 
> > > > > > >  include/linux/kvm.h               |   14 +++
> > > > > > >  include/linux/kvm_host.h          |   13 +++
> > > > > > >  virt/kvm/eventfd.c                |  189 +++++++++++++++++++++++++++++++++++++
> > > > > > >  virt/kvm/kvm_main.c               |   11 ++
> > > > > > >  6 files changed, 250 insertions(+), 2 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> > > > > > > index b216709..87a2558 100644
> > > > > > > --- a/Documentation/virtual/kvm/api.txt
> > > > > > > +++ b/Documentation/virtual/kvm/api.txt
> > > > > > > @@ -1987,6 +1987,30 @@ interrupts with those injected through KVM_IRQ_LINE.  IRQFDs created
> > > > > > >  with KVM_IRQFD_FLAG_LEVEL must also set this flag when de-assiging.
> > > > > > >  KVM_IRQFD_FLAG_LEVEL support is indicated by KVM_CAP_IRQFD_LEVEL.
> > > > > > >  
> > > > > > > +4.77 KVM_EOIFD
> > > > > > > +
> > > > > > > +Capability: KVM_CAP_EOIFD
> > > > > > > +Architectures: x86
> > > > > > > +Type: vm ioctl
> > > > > > > +Parameters: struct kvm_eoifd (in)
> > > > > > > +Returns: 0 on success, -1 on error
> > > > > > > +
> > > > > > > +KVM_EOIFD allows userspace to receive EOI notification through an
> > > > > > > +eventfd for level triggered irqchip interrupts.  Behavior for edge
> > > > > > > +triggered interrupts is undefined.  kvm_eoifd.fd specifies the eventfd
> > > > > > Lets make it defined. EOI notification can be used by userspace to fix
> > > > > > time drift due to lost interrupts. But than userspace needs to know
> > > > > > which vcpu did EOI.
> > > > > 
> > > > > Hmm, do we need an additional flag and field in kvm_eoifd to filter by
> > > > > vCPU then?
> > > > > 
> > > > This will be enough for a use case I am aware of. Don't know if this
> > > > interface is generic enough for all possible use cases.
> > > 
> > > That's generally a hard prediction to make ;)  We currently don't pass a
> > > kvm_vcpu anywhere close to the irq ack notifier.  The ioapic path could
> > > be relatively trivial, but the pic path is a bit further disconnected.
> > > If we had that plumbing, a KVM_CAP plus vcpu filter flag and specifying
> > > the vcpu using some of the padding space seems like it's sufficient.
> > > I'll drop mention of level-only from the description, but the plumbing
> > > and vcpu filtering can be a follow-on.  Thanks,
> > > 
> > > Alex
> > 
> > If we don't implement what's needed for timedrift to be fixed,
> > then IMO it's better to simply require an IRQFD for EOIFD for now,
> > and limit this to level. Otherwise when we actually try to implement
> > we might find issues.
> > 
> > Another reason to explicitly say EOI is not supported for edge is that
> > EOI might not get invoked at all with PV EOI.
> > 
> Good point, but easily addressable by disabling PV EOI for a GSI that
> has EOI notifier registered.

This patch doesn't do this though, so it will need a separate
patch and a separate capability.

> --
> 			Gleb.
