Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2BGPLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:11:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab2BGPLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:11:33 -0500
Message-ID: <1328627490.3074.202.camel@bling.home>
Subject: Re: [PATCH v2] KVM: Fix assigned device MSI-X entry setting leak
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Tue, 07 Feb 2012 08:11:30 -0700
In-Reply-To: <20120207063124.GB23369@redhat.com>
References: <20120130210346.22952.5215.stgit@bling.home>
	 <20120131191120.GC3601@redhat.com> <1328564789.3074.145.camel@bling.home>
	 <20120207063124.GB23369@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 08:31 +0200, Michael S. Tsirkin wrote:
> On Mon, Feb 06, 2012 at 02:46:29PM -0700, Alex Williamson wrote:
> > On Tue, 2012-01-31 at 21:11 +0200, Michael S. Tsirkin wrote:
> > > On Mon, Jan 30, 2012 at 02:05:54PM -0700, Alex Williamson wrote:
> > > > We need to prioritize our matching when setting MSI-X vector
> > > > entries.  Unused entries should only be used if we don't find
> > > > an exact match or else we risk duplicating entries.  This was
> > > > causing an ENOSPC return when trying to mask and unmask MSI-X
> > > > vectors based on guest MSI-X table updates.
> > > > 
> > > > The new KVM_CAP_DEVICE_MSIX_MASK extension indicates the
> > > > presence of this fix.
> > > > 
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > ---
> > > > 
> > > > v2: Add capability indicating MSIX_MASKing now works.
> > > > 
> > > > The faulting sequence went something like:
> > > > 
> > > > Start:
> > > > [0] entry 0, vector A
> > > > [1] entry 1, vector B
> > > > [2] entry 2, vector C
> > > > 
> > > > Set entry 1 to 0:
> > > > [0] entry 0, vector A
> > > > [1] entry 1->1, vector B->0
> > > > [2] entry 2, vector C
> > > > 
> > > > Set entry 2 to 0:
> > > > [0] entry 0, vector A
> > > > [1] entry 1->2, vector 0->0 <- incorrectly matched
> > > > [2] entry 2, vector C
> > > > 
> > > > Set entry 2 to C:
> > > > [0] entry 0, vector A
> > > > [1] entry 2->2, vector 0->C <- incorrectly matched again
> > > > [2] entry 2, vector C
> > > > 
> > > > Set entry 1 to B:
> > > > [0] entry 0, vector A
> > > > [1] entry 2, vector C
> > > > [2] entry 2, vector C
> > > > -ENOSPC
> > > > 
> > > >  Documentation/virtual/kvm/api.txt |    5 +++--
> > > >  arch/x86/kvm/x86.c                |    1 +
> > > >  include/linux/kvm.h               |    1 +
> > > >  virt/kvm/assigned-dev.c           |   21 ++++++++++++++-------
> > > >  4 files changed, 19 insertions(+), 9 deletions(-)
> > > 
> > > I don't object to fixing this bug. But I don't think
> > > we need a capability for this. Here's why:
> > > 
> > > setting an entry to zero is not really matching
> > > what devices need, since that would lose interrupts.
> > > What devices need is mask entries to disable them,
> > > then unmask and get an interrupt if it was delayed.
> > > 
> > > So, if we are going to add a new capability, how about
> > > sticking a mask bit in the padding instead?
> > 
> > I'll take a look.  Are you suggesting then that we'd note the masked
> > interrupt was deferred and inject when unmasked?
> > 
> > > As was shown in the past this can even improve performance since we can
> > > propagate the mask bit back to the host device.
> > 
> > I'm dubious whether there's actually a use case that benefits from
> > pushing the mask down to hardware.  The typical mask case is a temporary
> > mask to update the vector data/address then unmask.  We're actually
> > accelerating that by not pushing it down to hardware.  Are there real
> > world drivers that enable a vector and then mask it for an extended
> > period of time?
> 
> I don't know. Shen Yang at some point said:
> "We have also reproduced the issue on some large scale benchmark on the guest with
> "newer kernel like 2.6.30 on Xen, under very high interrupt rate, due to some
> "interrupt rate limitation mechanism in kernel.
> 
> And these patches did push the interrupts down - but not to hardware,
> masking interrupt as pending in kernel only sets a bit, it is only
> pushed down when we next get an interrupt while vector is masked.

I thought the high rate masking was on older guests, but in any case a
reasonable first step is emulated masking in kvm so that we can
re-inject on unmask and not lose interrupts.  That can either lead to
lazy hardware masking with no additional change to the API or if someone
takes the reigns on MSI-X table acceleration, we can head in that
direction.  The MSI-X table interaction I see on an average sized guest
with an assigned 82576 PF certainly isn't calling out for more
acceleration, but 10G devices and beyond could behave differently.
Thanks,

Alex

