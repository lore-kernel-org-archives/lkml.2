Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2IHWgN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 18:36:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab2IHWgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 18:36:07 -0400
Date: Sun, 9 Sep 2012 01:37:24 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org, yvugenfi@redhat.com,
        vrozenfe@redhat.com
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
Message-ID: <20120908223724.GB20588@redhat.com>
References: <50486BB2.7070108@redhat.com>
 <20120906094442.GA22816@redhat.com>
 <50487382.8030303@redhat.com>
 <20120906105301.GC32325@redhat.com>
 <5048935A.8090308@redhat.com>
 <87wr06hg0l.fsf@rustcorp.com.au>
 <20120907054202.GA3452@redhat.com>
 <87vcfqfia1.fsf@rustcorp.com.au>
 <20120907104306.GA17211@redhat.com>
 <87sjatf6iv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjatf6iv.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 02:36:00PM +0930, Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > On Fri, Sep 07, 2012 at 04:09:50PM +0930, Rusty Russell wrote:
> >> > So it looks like a bug: we should teach driver to tell host first on leak?
> >> > Yan, Vadim, can you comment please?
> >> >
> >> > Also if true, looks like this bit will be useful to detect a fixed driver on
> >> > the hypervisor side - to avoid unmapping such pages? Rusty what do you
> >> > think?
> >> 
> >> So, feature is unimplemented in qemu, and broken in drivers.  I starting
> >> to share Paolo's dislike of it.
> >
> > What is broken in drivers?
> 
> Because supporting the feature is *not* optional for a driver.
> 
> If the device said MUST_TELL_HOST, it meant that the driver *had* to
> tell the host before it touched the page, otherwise Bad Things might
> happen.  It was in the original spec precisely to allow devices to
> actually *remove* pages.
> 
> Noone ever noticed the windows driver didn't support it, because qemu
> never requires MUST_TELL_HOST.
> 
> So in practice, it's now an optional feature.  Since no device used it
> anyway, we're better off discarding it than trying to fix it.

I trust you this was not the intent. But it seems to be
the intent in spec, because almost all features are optional.

And so windows driver authors interpreted it
this way. And it is *useful* like this.  See below.

> If someone wants an *optional* "tell me first" feature later, that's
> easy to add, but I don't see why they'd want to.

Suggested use is for device assignment which needs all guest memory
locked.  hypervisor can unlock pages in balloon but guest must wait for
hypervisor to lock them back before use.

when a hypervisor implements this,
this will work with linux guests but not windows
guests and the existing bit fits exactly the purpose.


> > Do we really know there are no hypervisors implementing it?
> 
> As much as can be known.  Qemu doesn't, lkvm doesn't.

But we can add it in qemu and it will be a useful feature.

> > As I said above drivers do have support.
> 
> Not the windows drivers.  So it's optional, thus removing it will likely
> harm noone.
> 
> Cheers,
> Rusty.

I think the issue is that kvm always locked all guest memory
for assignment. This restriction is removed
with vfio which has separate page tables.
Now that vfio is upstream and work on qemu integration
is being worked on, we might finally see people using this bit
to allow memory overcommit with device assignment.

So let's not remove yet, there is no rush.
Let's document it that this feature is optional,
maybe renaming as Paolo suggests.

-- 
MST
