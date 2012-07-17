Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2GQLJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 07:09:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab2GQLJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 07:09:28 -0400
Date: Tue, 17 Jul 2012 14:09:52 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Asias He <asias@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, nab@linux-iscsi.org,
        target-devel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH 0/5] Add vhost-blk support
Message-ID: <20120717110951.GA9258@redhat.com>
References: <1342107302-28116-1-git-send-email-asias@redhat.com>
 <CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com>
 <50052276.2080906@redhat.com>
 <500527BA.9000001@redhat.com>
 <20120717094526.GC7949@redhat.com>
 <50053B09.2060703@redhat.com>
 <20120717104920.GJ7949@redhat.com>
 <500544DF.3050400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500544DF.3050400@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 12:56:31PM +0200, Paolo Bonzini wrote:
> Il 17/07/2012 12:49, Michael S. Tsirkin ha scritto:
> >> Ok, that would make more sense.  One difference between vhost-blk and
> >> vhost-net is that for vhost-blk there are also management actions that
> >> would trigger the switch, for example a live snapshot.
> >> So a prerequisite for vhost-blk would be that it is possible to disable
> >> it on the fly while the VM is running, as soon as all in-flight I/O is
> >> completed.
> > 
> > It applies for vhost-net too. For example if you bring link down,
> > we switch to userspace. So vhost-net supports this switch on the fly.
> 
> Cool.
> 
> >> (Note that, however, this is not possible for vhost-scsi, because it
> >> really exposes different hardware to the guest.  It must not happen that
> >> a kernel upgrade or downgrade toggles between userspace SCSI and
> >> vhost-scsi, for example).
> > 
> > I would say this is not a prerequisite for merging in qemu.
> > It might be a required feature for production but it
> > is also solvable at the management level.
> 
> I'm thinking of the level interrupts here.  You cannot make a change in
> the guest, and have it do completely unrelated changes the hardware that
> the guest sees.

Absolutely.

So the right thing for vhost-scsi might be to just support level
(equivalent for "force" flag in vhost-net).
We don't in vhost-net because it is triggered by some old guests
but all virtio-scsi guests use MSI so level is just a spec compatibility
issue.

We might also gain kernel support for level at some point.

> >>>> having to
> >>>> support the API; having to handle transition from one more thing when
> >>>> something better comes out.
> >>>
> >>> Well this is true for any code. If the limited featureset which
> >>> vhost-blk can accelerate is something many people use, then accelerating
> >>> by 5-15% might outweight support costs.
> >>
> >> It is definitely what people use if they are interested in performance.
> > 
> > In that case it seems to me we should stop using the feature set as
> > an argument and focus on whether the extra code is worth the 5-15% gain.
> > No one seems to have commented on that so everyone on list thinks that
> > aspect is OK?
> 
> I would like to see a breakdown of _where_ the 5-15% lies, something
> like http://www.linux-kvm.org/page/Virtio/Block/Latency.

Yes but I think it's also nice to have. It's hard to argue IMO that
virtio as kernel interface cuts out some overhead.

> > Kernel merge windows is coming up and I would like to see whether
> > any of vhost-blk / vhost-scsi is going to be actually used by userspace.
> > I guess we could tag it for staging but would be nice to avoid that.
> 
> Staging would be fine by me for both vhost-blk and vhost-scsi.
> 
> Paolo

The reason I say staging is because there seems to be a deadlock
where userspace waits for kernel to merge a driver and
kernel does not want to commit to an ABI that will then
go unused.

So even if it gets tagged as staging it would only
make sense for it to stay there for one cycle. And then either
get removed if no userspace materializes or lose staging tag
if it does.

-- 
MST
