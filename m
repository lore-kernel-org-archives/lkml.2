Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760349Ab2IGKwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 06:52:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222Ab2IGKwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 06:52:20 -0400
Date: Fri, 7 Sep 2012 13:53:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org, yvugenfi@redhat.com,
        vrozenfe@redhat.com
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
Message-ID: <20120907105335.GB17211@redhat.com>
References: <20120906084736.GF17656@redhat.com>
 <50486BB2.7070108@redhat.com>
 <20120906094442.GA22816@redhat.com>
 <50487382.8030303@redhat.com>
 <20120906105301.GC32325@redhat.com>
 <5048935A.8090308@redhat.com>
 <87wr06hg0l.fsf@rustcorp.com.au>
 <20120907054202.GA3452@redhat.com>
 <87vcfqfia1.fsf@rustcorp.com.au>
 <5049BE0E.6040202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5049BE0E.6040202@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 11:27:42AM +0200, Paolo Bonzini wrote:
> Il 07/09/2012 08:39, Rusty Russell ha scritto:
> >> > So it looks like a bug: we should teach driver to tell host first on leak?
> >> > Yan, Vadim, can you comment please?
> >> >
> >> > Also if true, looks like this bit will be useful to detect a fixed driver on
> >> > the hypervisor side - to avoid unmapping such pages? Rusty what do you
> >> > think?
> > So, feature is unimplemented in qemu, and broken in drivers.  I starting
> > to share Paolo's dislike of it.
> > 
> > Don't understand why we'd care about fixed drivers though, if we remove
> > the feature bit....
> 
> Hmm, Michael has a point here.  Basically, the Windows driver is using
> silent deflate, but not telling the host (yet) about it.  So, we must
> assume that a driver that does not negotiate
> VIRTIO_BALLOON_F_MUST_TELL_HOST _will_ use silent deflate.
> 
> Here's a way to proceed.
> 
> We add VIRTIO_BALLOON_F_SILENT_DEFLATE, which is negotiated normally.
> If not available, at worst the guest driver may refuse to start, or
> revert to using the deflateq.
> 
> We rename VIRTIO_BALLOON_F_MUST_TELL_HOST to WILL_TELL_HOST, since
> that's how it's being used.  Now for the device there are three cases:
> 
> - does not support silent deflate at all: it should always propose
>   VIRTIO_BALLOON_F_WILL_TELL_HOST; if the (bad) driver does not
>   negotiate it, the device must assume that the guest will use silent
>   deflate, and fail to start the guest if the device does not support
>   silent deflate.
> 
> - optionally supports silent deflate: it should always propose
>   VIRTIO_BALLOON_F_WILL_TELL_HOST; if the (bad) driver does not
>   negotiate it, the device must assume that the guest will use silent
>   deflate
> 
> - always supports silent deflate: does not need to do anything,
>   current behavior works fine.  But the driver might as well propose
>   VIRTIO_BALLOON_F_WILL_TELL_HOST, so that migration works fine.  (This
>   is a hardware change, so it must be versioned, yadda yadda).
> 
> I can prepare a spec patch for this.
> 
> 
> BTW, since we have in the archives an example of using silent deflate,
> here is an example of non-silent deflate.  It may help understanding the
> above with an actual example of a device.  Suppose a guest is using PCI
> passthrough, so it has all memory pinned.
> 
> - If the guest will _not_ use silent deflate, we can unlock memory on
> inflate and lock it back on deflate.  (The question is what to do if
> locking fail; left for when someone actually implements this thing).
> 
> - If the guest will use silent deflate, we cannot do that.
> 
> So this is the second case above.  The device must propose
> VIRTIO_BALLOON_F_WILL_TELL_HOST.  Then:
> 
> - if the guest negotiates VIRTIO_BALLOON_F_SILENT_DEFLATE,
>   we cannot do the munlock/mlock
> 
> - if the guest negotiates VIRTIO_BALLOON_F_WILL_TELL_HOST,
>   we can do the munlock/mlock
> 
> - if the guest does not negotiate either, the driver is buggy
>   and we cannot do the munlock/mlock
> 
> Paolo


Let us start with what is broken currently. Looking at
it very closely, I think the answer is nothing.
Even migration in qemu is not broken as you claimed initially.

Next, consider the interface proposed here. You defacto declare
all existing drivers buggy. This is a wrong thing to do.
You also use two feature bits for a single simple thing,
this is inelegant.

Last, let us consider how existing feature can be used
in the hypervisor. If driver did not ack
MUST_TELL_HOST, it is *not* buggy but it means we can not
do munlock. This applies to current windows drivers.
If driver *did* ack MUST_TELL_HOST, we can munlock
and mlock back on leak.
Seems useful, driver support is already there,
so removing the MUST_TELL_HOST bit seems like a bad idea.

-- 
MST
