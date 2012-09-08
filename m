Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2IHWVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 18:21:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab2IHWVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 18:21:04 -0400
Date: Sun, 9 Sep 2012 01:22:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org, yvugenfi@redhat.com,
        vrozenfe@redhat.com
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
Message-ID: <20120908222221.GA20588@redhat.com>
References: <87vcfqfia1.fsf@rustcorp.com.au>
 <5049BE0E.6040202@redhat.com>
 <20120907105335.GB17211@redhat.com>
 <5049D899.60705@redhat.com>
 <20120907121712.GA17397@redhat.com>
 <5049E717.8080307@redhat.com>
 <20120907124432.GB17397@redhat.com>
 <5049FEDD.40303@redhat.com>
 <20120907142545.GC17397@redhat.com>
 <504A0858.4080508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504A0858.4080508@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 04:44:40PM +0200, Paolo Bonzini wrote:
> Il 07/09/2012 16:25, Michael S. Tsirkin ha scritto:
> >> > Silent deflate is deflating just by using the page, without using the
> >> > deflateq at all.  So it can be done even from GFP_ATOMIC context.
> > BTW I don't see a need to avoid deflateq.
> > Without MUST_TELL_HOST you can just deflate and then
> > bounce telling the host out to a thread.
> 
> Yes, that's fine too.

OK so it's preferable: will work on existing hypervisors.

> >> > But knowing that the guest will _not_ deflate silently also benefits the
> >> > host. This is the cause of unpinning ballooned pages and pinning them
> >> > again upon deflation. This allows cooperative memory overcommit even if
> >> > the guests' memory is pinned, similar to what Xen did before it
> >> > supported overcommit.  This is the second feature bit.
> > This is the MUST_TELL_HOST.
> 
> Almost.  One is "the guest, if really needed, can tell the host of
> pages".  If not negotiated, and the host does not support it, the host
> must break the guest (e.g. fail to offer any virtqueues).

There is no way in spec to break the guest.
You can not fail to offer virtqueues.
Besides, there is no guarantee that virtqueue setup
happens after feature negotiation.

> The other is "the guest, though, would prefer not to do so".  It is
> different because the guest can proceed in a fallback mode even if the
> host doesn't offer it.

I think I get what your proposed SILENT means what I do not get
is the motivation. It looks like a premature optimization to me.

> You're interpreting features as something that dictates behavior, but
> they're really just advisory.

The spec is pretty clear that if guest acks feature it
is a contract that dictates behaviour.
If it doesn't it is either ignored or just informative
depending on feature.

>  You could negotiate VIRTIO_BLK_F_TOPOLOGY
> and end up never reading the fields; you could negotiate
> VIRTIO_NET_F_GUEST_ANNOUNCE and never send a guest announcement.


Block example is just informative. It does not need to be
negotiated even to be used.
But last example is wrong.
If you ack GUEST_ANNOUNCE hypervisor assumes guest will
announce self, if guest does not do it this break migration.


> >> > * guest will always do silent deflation: current Windows driver.
> > Not exactly. It is not silent. It tells host
> > just after use.
> 
> Yeah, but no difference from the POV of the driver.
> 
> Delaying or avoiding is the same in the end.  The spec says it well: "In
> this case, deflation advice is merely a courtesy".

So it looks like we don't need a new bit to leak in atomic ctx.
Just do not ack MUST_TELL_HOST and delay telling host to a wq.
IMO we should not add random stuff to spec like this just because it
seems like a good idea.

> >> > Negotiates nothing, or if it cares it can negotiate
> >> > VIRTIO_BALLOON_F_SILENT_DEFLATE.  Host mustn't do munlock/mlock dance.
> >> >
> >> > * guest may do silent deflation if available: combo of Linux driver +
> >> > Frank's driver.  Negotiates both features, looks at
> >> > VIRTIO_BALLOON_F_SILENT_DEFLATE host feature to decide how to behave:
> >> > 
> >> >   ** If PCI passthrough, the host will not negotiate
> >> >      VIRTIO_BALLOON_F_SILENT_DEFLATE.  The driver will behave as the
> >> >      current Linux driver, the host can do the munlock/mlock dance.
> > So this case is just existing interface. OK.
> > 
> >> >   ** If no PCI passthrough, the host will negotiate
> >> >      VIRTIO_BALLOON_F_SILENT_DEFLATE, and the driver can balloon more
> >> >      aggressively and not use the deflateq.
> >> > 
> > This last trickery confuses me.  It just does not make sense to set both
> > SILENT and TELL: either you are silent or you tell.
> 
> "I can be chatty if you ask me, but I'd rather be silent if you let me".
> 
> TELL is a request of the host to the guest; the guest can agree or not.
> 
> SILENT is a request of the guest to the host; the host can agree or not.

OK so TELL says *when* to notify host, SILENT if set allows guest
to skip leak notifications? In this case TELL should just be ignored
when SILENT is set. Otherwise it's a reasonable extension.
But I am still not sure *why* do we need SILENT - any data showing
that avoiding these notifications is a win?
Let's not add new features until we see an actual use.


> > It seems cleaner for the host to know the state.
> 
> Yeah, if you want to do it you can.
> 
> Paolo

IMHO, renaming is fine since there is confusion.
But WILL_TELL is also not all that clear imho.

I think the confusion is that TELL_HOST seems to
imply we can avoid telling host at all.
How about being explicit?

VIRTIO_BALLOON_F_HOST_ACK_BEFORE_DEFLATE

Hmm?


"MUST" "WILL" are not really informative.

Also some confusion I think is from spec text saying "feature is set"
in many cases where it really almost always means "feature is negotiated".

Let's address?

-- 
MSt
