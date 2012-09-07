Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612Ab2IGMQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:16:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760592Ab2IGMP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:15:56 -0400
Date: Fri, 7 Sep 2012 15:17:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org, yvugenfi@redhat.com,
        vrozenfe@redhat.com
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
Message-ID: <20120907121712.GA17397@redhat.com>
References: <20120906094442.GA22816@redhat.com>
 <50487382.8030303@redhat.com>
 <20120906105301.GC32325@redhat.com>
 <5048935A.8090308@redhat.com>
 <87wr06hg0l.fsf@rustcorp.com.au>
 <20120907054202.GA3452@redhat.com>
 <87vcfqfia1.fsf@rustcorp.com.au>
 <5049BE0E.6040202@redhat.com>
 <20120907105335.GB17211@redhat.com>
 <5049D899.60705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5049D899.60705@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 01:20:57PM +0200, Paolo Bonzini wrote:
> Il 07/09/2012 12:53, Michael S. Tsirkin ha scritto:
> > Let us start with what is broken currently. Looking at
> > it very closely, I think the answer is nothing.
> > Even migration in qemu is not broken as you claimed initially.
> 
> Correct, migration would be broken as soon as QEMU starts using
> MUST_TELL_HOST.  I'm trying to think ahead, since we have many ideas
> floating around on the implementation of ballooning.
> 
> If you implement the mlock/munlock trick, you must start using
> MUST_TELL_HOST in QEMU to advertise it to guests, and migration breaks.

Migration does not break.

Since I wrote this code in qemu let me explain what is going on.

qemu requires that local and remote side are started with
same feature bits.
To support cross version migration, code in hw/pc_piix.c
disables features if you require migration from/to old qemu.

At some point I added a sanity check:
if we get guest features we know that any bit
set there must be set in host features.
Yes, this catches some user mistakes.

This was never intended as a compatibility guarantee.
User is still required to start qemu such
that host features match exactly, anything else
can lead to failures some of them hard to debug.

Here is a simple example:

1. guest reads host features
2. guest is migrated - check passes since no features are acked
3. guest acks features -> failure

This applies to any feature. Nothing special with this one.

Yes, we can if we want to make this more robust
against user errors, e.g. by migrating host feature
bits. Patches welcome. If we do it will help all
features, not just this one.


> > Next, consider the interface proposed here. You defacto declare
> > all existing drivers buggy.
> 
> No, only Windows (and it is buggy, it calls tell_host last).

It is not buggy. It does not ack MUST_TELL_HOST. So it is free to tell
host at any point, it behaves exactly
to spec. You can not retroactively declare drivers buggy like that.

>  Linux and
> BSD drivers do negotiate MUST_TELL_HOST, and are not buggy.
> 
> > This is a wrong thing to do.
> > You also use two feature bits for a single simple thing,
> > this is inelegant.
> 
> True, but the choice is:
> 
> 1) add a once-only hack to QEMU that fixes migration of
> VIRTIO_BALLOON_F_MUST_TELL_HOST;
> 
> 2) always advertise VIRTIO_BALLOON_F_MUST_TELL_HOST.  If you do this,
> guests cannot use anymore silent deflate, which is a regression.
> 
> 3) use two bits.  One tells the device that the driver supports chatty
> deflate; one tells the driver that the device supports silent deflate.

The right thing to do is either
4. realize we can not address all user errors, so no real issue
5. address this class of user errors by migrating host features

> So in the end you do use two feature bits for two different things.
> Plus, both feature bits are "positive" and I'm happy.

I am not happy.
We lose compatibility with all existing drivers
so it will take years until the feature is actually
useful.

> > Last, let us consider how existing feature can be used
> > in the hypervisor. If driver did not ack
> > MUST_TELL_HOST, it is *not* buggy but it means we can not
> > do munlock. This applies to current windows drivers.
> > If driver *did* ack MUST_TELL_HOST, we can munlock
> > and mlock back on leak.
> > Seems useful, driver support is already there,
> > so removing the MUST_TELL_HOST bit seems like a bad idea.
> 
> Indeed, repurposing MUST_TELL_HOST to WILL_TELL_HOST is better than
> killing it.
> 
> Paolo

Is this just a matter of naming? Same functionality:
driver that acks this bit will tell host first,
driver that does not will not?

If yes that is fine.

-- 
MST
