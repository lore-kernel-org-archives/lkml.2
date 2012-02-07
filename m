Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2BGGb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:31:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab2BGGb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:31:26 -0500
Date: Tue, 7 Feb 2012 08:31:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v2] KVM: Fix assigned device MSI-X entry setting leak
Message-ID: <20120207063124.GB23369@redhat.com>
References: <20120130210346.22952.5215.stgit@bling.home>
 <20120131191120.GC3601@redhat.com>
 <1328564789.3074.145.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328564789.3074.145.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 02:46:29PM -0700, Alex Williamson wrote:
> On Tue, 2012-01-31 at 21:11 +0200, Michael S. Tsirkin wrote:
> > On Mon, Jan 30, 2012 at 02:05:54PM -0700, Alex Williamson wrote:
> > > We need to prioritize our matching when setting MSI-X vector
> > > entries.  Unused entries should only be used if we don't find
> > > an exact match or else we risk duplicating entries.  This was
> > > causing an ENOSPC return when trying to mask and unmask MSI-X
> > > vectors based on guest MSI-X table updates.
> > > 
> > > The new KVM_CAP_DEVICE_MSIX_MASK extension indicates the
> > > presence of this fix.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > ---
> > > 
> > > v2: Add capability indicating MSIX_MASKing now works.
> > > 
> > > The faulting sequence went something like:
> > > 
> > > Start:
> > > [0] entry 0, vector A
> > > [1] entry 1, vector B
> > > [2] entry 2, vector C
> > > 
> > > Set entry 1 to 0:
> > > [0] entry 0, vector A
> > > [1] entry 1->1, vector B->0
> > > [2] entry 2, vector C
> > > 
> > > Set entry 2 to 0:
> > > [0] entry 0, vector A
> > > [1] entry 1->2, vector 0->0 <- incorrectly matched
> > > [2] entry 2, vector C
> > > 
> > > Set entry 2 to C:
> > > [0] entry 0, vector A
> > > [1] entry 2->2, vector 0->C <- incorrectly matched again
> > > [2] entry 2, vector C
> > > 
> > > Set entry 1 to B:
> > > [0] entry 0, vector A
> > > [1] entry 2, vector C
> > > [2] entry 2, vector C
> > > -ENOSPC
> > > 
> > >  Documentation/virtual/kvm/api.txt |    5 +++--
> > >  arch/x86/kvm/x86.c                |    1 +
> > >  include/linux/kvm.h               |    1 +
> > >  virt/kvm/assigned-dev.c           |   21 ++++++++++++++-------
> > >  4 files changed, 19 insertions(+), 9 deletions(-)
> > 
> > I don't object to fixing this bug. But I don't think
> > we need a capability for this. Here's why:
> > 
> > setting an entry to zero is not really matching
> > what devices need, since that would lose interrupts.
> > What devices need is mask entries to disable them,
> > then unmask and get an interrupt if it was delayed.
> > 
> > So, if we are going to add a new capability, how about
> > sticking a mask bit in the padding instead?
> 
> I'll take a look.  Are you suggesting then that we'd note the masked
> interrupt was deferred and inject when unmasked?
> 
> > As was shown in the past this can even improve performance since we can
> > propagate the mask bit back to the host device.
> 
> I'm dubious whether there's actually a use case that benefits from
> pushing the mask down to hardware.  The typical mask case is a temporary
> mask to update the vector data/address then unmask.  We're actually
> accelerating that by not pushing it down to hardware.  Are there real
> world drivers that enable a vector and then mask it for an extended
> period of time?

I don't know. Shen Yang at some point said:
"We have also reproduced the issue on some large scale benchmark on the guest with
"newer kernel like 2.6.30 on Xen, under very high interrupt rate, due to some
"interrupt rate limitation mechanism in kernel.

And these patches did push the interrupts down - but not to hardware,
masking interrupt as pending in kernel only sets a bit, it is only
pushed down when we next get an interrupt while vector is masked.

> Thanks,
> 
> Alex
