Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab2IFKvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 06:51:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab2IFKvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 06:51:44 -0400
Date: Thu, 6 Sep 2012 13:53:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: rusty@rustcorp.com.au, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
Message-ID: <20120906105301.GC32325@redhat.com>
References: <1346917610-14568-1-git-send-email-pbonzini@redhat.com>
 <20120906084736.GF17656@redhat.com>
 <50486BB2.7070108@redhat.com>
 <20120906094442.GA22816@redhat.com>
 <50487382.8030303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50487382.8030303@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 11:57:22AM +0200, Paolo Bonzini wrote:
> Il 06/09/2012 11:44, Michael S. Tsirkin ha scritto:
> >> In fact, it's not clear how the driver should use the feature.  My guess
> >> is that, if it wants to use silent deflate, it tries to negotiate
> >> VIRTIO_BALLOON_F_MUST_TELL_HOST, and can use silent deflate if
> >> negotiation fails.  This is against the logic of all other features.
> > 
> > Let's take a step back from the implementation details.
> > You are trying to add a new feature bit, after all.
> > Why? Why is silent deflate useful? This is what is
> > missing in all this discussion. If it is not useful
> > we do not need a bit for it.
> 
> It is useful because it lets guests inflate the balloon aggressively,
> and then use ballooned-out pages even in places where the guest OS
> cannot sleep, such as kmalloc(GFP_ATOMIC).

Interesting.
Do you intend to develop a driver patch using this?  I'd like to see how
that works.  Because if not, IMO it's best to wait until someone asks
for it.

> >>> Can you show a scenario with old driver/new hypervisor or
> >>> new driver/old hypervisor that fails?
> >
> > Sorry this is not the example I asked for.  Please give and example
> > without migration.
> > 
> > Migration is qemu's problem: it is hypervisor's job to
> > make sure guest sees no change during migration.
> 
> Quoting my message: "Of course you can just teach QEMU to be smarter,
> but that would be a one-off hack for the only ill-defined feature that
> says something is _not_ supported".
>
> Currently migration works the same way for all virtio devices,
> and
> assumes that features are defined only in the "positive" direction:
> drivers request features if they want to use it, devices provide
> features to say they support something.

Well this approach is buggy. If I reread features after migration what
do I see? Something changed right? So this is a bug. Migration should
not change hardware. And it is not a "one off" thing it is
fundamental for any hardware.

Fix that in qemu, and the problem goes away without spec changes.

> Instead, in the case of this feature, the driver requests it before
> relying on its lack (which is odd);

Which code in driver do you refer to?

> the device provides if they do not
> support something (which is wrong).

Not support?
It just seems to be asking guest to tell it about deflates.
If guest acks the bit, we know it will. If it does not,
it will not.

>  You can see that this just cannot
> provide backwards-compatibility in the device;

Sorry I do not understand this meta argument.
There should be an example where a driver and device
fail to work together. And without migration: as
I showed migration is simply broken atm for
an unrelated reason. Otherwise all's well.

> it happens to work only
> because the feature was there in the first version of the spec.

This is how we do compatiblity in virtio. If we want driver to do
something, we add a feature and it can ack, if it does we know it will
do what we want.  Another example is network announce bit.  If driver
acks it, we know we do not need to send gratitious arp from qemu.  You
are saying it is also broken?

> > It should be able to do this with any hardware it emulates,
> > there should be no need to change hardware to make it
> > "migrateable" somehow.
> 
> Of course, but if we can fix the hardware with no bad effects, let's do
> that instead.
> 
> Paolo

Don't fix what is not broken. We get to carry compatibility
in both driver and host for a long time for each feature.

Note: adding
new features adds zero value in this respect - it will not
allow simplifying the hypervisor.
-- 
MST
