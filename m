Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab2IJFuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 01:50:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab2IJFu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 01:50:29 -0400
Date: Mon, 10 Sep 2012 08:51:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org, yvugenfi@redhat.com,
        vrozenfe@redhat.com
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
Message-ID: <20120910055150.GA16819@redhat.com>
References: <50487382.8030303@redhat.com>
 <20120906105301.GC32325@redhat.com>
 <5048935A.8090308@redhat.com>
 <87wr06hg0l.fsf@rustcorp.com.au>
 <20120907054202.GA3452@redhat.com>
 <87vcfqfia1.fsf@rustcorp.com.au>
 <20120907104306.GA17211@redhat.com>
 <87sjatf6iv.fsf@rustcorp.com.au>
 <20120908223724.GB20588@redhat.com>
 <87fw6qfya7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw6qfya7.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 11:13:12AM +0930, Rusty Russell wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > On Sat, Sep 08, 2012 at 02:36:00PM +0930, Rusty Russell wrote:
> >> "Michael S. Tsirkin" <mst@redhat.com> writes:
> >> > On Fri, Sep 07, 2012 at 04:09:50PM +0930, Rusty Russell wrote:
> >> >> > So it looks like a bug: we should teach driver to tell host first on leak?
> >> >> > Yan, Vadim, can you comment please?
> >> >> >
> >> >> > Also if true, looks like this bit will be useful to detect a fixed driver on
> >> >> > the hypervisor side - to avoid unmapping such pages? Rusty what do you
> >> >> > think?
> >> >> 
> >> >> So, feature is unimplemented in qemu, and broken in drivers.  I starting
> >> >> to share Paolo's dislike of it.
> >> >
> >> > What is broken in drivers?
> >> 
> >> Because supporting the feature is *not* optional for a driver.
> >> 
> >> If the device said MUST_TELL_HOST, it meant that the driver *had* to
> >> tell the host before it touched the page, otherwise Bad Things might
> >> happen.  It was in the original spec precisely to allow devices to
> >> actually *remove* pages.
> >> 
> >> Noone ever noticed the windows driver didn't support it, because qemu
> >> never requires MUST_TELL_HOST.
> >> 
> >> So in practice, it's now an optional feature.  Since no device used it
> >> anyway, we're better off discarding it than trying to fix it.
> >
> > I trust you this was not the intent. But it seems to be
> > the intent in spec, because almost all features are optional.
> >
> > And so windows driver authors interpreted it
> > this way. And it is *useful* like this.  See below.
> 
> ...
> 
> > Suggested use is for device assignment which needs all guest memory
> > locked.  hypervisor can unlock pages in balloon but guest must wait for
> > hypervisor to lock them back before use.
> >
> > when a hypervisor implements this,
> > this will work with linux guests but not windows
> > guests and the existing bit fits exactly the purpose.
> 
> If a hypervisor needs this, and the guest doesn't support it, then
> the hypervisor can only abandon the balloon device.  That's not my
> definition of "optional".
> 
> >> > Do we really know there are no hypervisors implementing it?
> >> 
> >> As much as can be known.  Qemu doesn't, lkvm doesn't.
> >
> > But we can add it in qemu and it will be a useful feature.
> >
> >> > As I said above drivers do have support.
> >> 
> >> Not the windows drivers.  So it's optional, thus removing it will likely
> >> harm noone.
> >> 
> >> Cheers,
> >> Rusty.
> >
> > I think the issue is that kvm always locked all guest memory
> > for assignment. This restriction is removed
> > with vfio which has separate page tables.
> > Now that vfio is upstream and work on qemu integration
> > is being worked on, we might finally see people using this bit
> > to allow memory overcommit with device assignment.
> 
> That was left-field.... so you're saying some guest might pull a page
> from the balloon and DMA to it, and the vfio device needs to know in
> advance that it's going to do it?
> 
> But what will we do if the guest doesn't ack the bit?
> ie. I don't think it can really be optional.
> 
> Cheers,
> Rusty.

We have several options:
1. No memory overcommit feature. This is always the case ATM!
2. Do not hot-plug assigned device.
3. Hot-unplug assigned device.
4. Some assigned devices can be able to handle memory errors
   e.g. using ATS. Limit hotplug to these.

> I don't think it can really be optional.

It is optional *for the device*.

But I don't insist on my patch. I am merely saying that
1. The bit is useful for host to detect guests
which can't combine memory overcommit with device assignment,
and this set of guests is not empty.

2. The fact that this bit is not optional for drivers is not well documented.
The only hint seems the use of words "feature is set" as
opposed to "feature is negoticated" as with other features.
The spec intended
"feature is set in Device Features bits". Drivers interpreted this
as "feature is set in Guest Features bits".

Hard to blame them, let us give them time to address this.

-- 
MST
