Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861Ab2IGOYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:24:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab2IGOY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:24:29 -0400
Date: Fri, 7 Sep 2012 17:25:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org, yvugenfi@redhat.com,
        vrozenfe@redhat.com
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
Message-ID: <20120907142545.GC17397@redhat.com>
References: <87wr06hg0l.fsf@rustcorp.com.au>
 <20120907054202.GA3452@redhat.com>
 <87vcfqfia1.fsf@rustcorp.com.au>
 <5049BE0E.6040202@redhat.com>
 <20120907105335.GB17211@redhat.com>
 <5049D899.60705@redhat.com>
 <20120907121712.GA17397@redhat.com>
 <5049E717.8080307@redhat.com>
 <20120907124432.GB17397@redhat.com>
 <5049FEDD.40303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5049FEDD.40303@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 04:04:13PM +0200, Paolo Bonzini wrote:
> Il 07/09/2012 14:44, Michael S. Tsirkin ha scritto:
> >> Well, according to your reading of the spec.
> >>
> >> In the spec I'm reading "Host must be told before pages from the balloon
> >> are used".  Doesn't say anything about the guest.
> > 
> > No? How is host told then? By divine force?
> 
> For a simple madvise-based implementation such as the one in QEMU, the
> host doesn't need to be told about anything (except periodic updating of
> the "actual" field, or the statsq).
> 
> The guest doesn't need at all to use the deflateq in fact.
> 
> >> Now, indeed a very free interpretation is "Guest will tell host before
> >> pages from the balloon are used".  It turns out that it's exactly what
> >> guests have been doing, hence that's exactly what I'm proposing now:
> >> rename the feature to VIRTIO_BALLOON_F_WILL_TELL_HOST.
> > 
> > Rename is fine.
> 
> Cool.
> 
> >> Yes, that part we agree on I think.  We disagree that (after the rename)
> >> QEMU should start always proposing VIRTIO_BALLOON_F_WILL_TELL_HOST.
> > 
> > Not always. It must be off if compatibility with old qemu is disabled.
> 
> Yes, of course.
> 
> >> _Plus_ adding the new feature bit, which is needed to actually tell the
> > 
> > This part I do not get.  What is silent deflate, why is it useful
> > and what it has to do with what we are discussing here?
> 
> Silent deflate is deflating just by using the page, without using the
> deflateq at all.  So it can be done even from GFP_ATOMIC context.

BTW I don't see a need to avoid deflateq.
Without MUST_TELL_HOST you can just deflate and then
bounce telling the host out to a thread.

> But knowing that the guest will _not_ deflate silently also benefits the
> host. This is the cause of unpinning ballooned pages and pinning them
> again upon deflation. This allows cooperative memory overcommit even if
> the guests' memory is pinned, similar to what Xen did before it
> supported overcommit.  This is the second feature bit.

This is the MUST_TELL_HOST.

> There are three cases:
> 
> * guest will never do silent deflation: current Linux driver.  Host may
> do munlock/mlock dance.  Negotiates VIRTIO_BALLOON_F_WILL_TELL_HOST
> only, features = VIRTIO_BALLOON_F_WILL_TELL_HOST.
> 
> * guest will always do silent deflation: current Windows driver.

Not exactly. It is not silent. It tells host
just after use.

> Negotiates nothing, or if it cares it can negotiate
> VIRTIO_BALLOON_F_SILENT_DEFLATE.  Host mustn't do munlock/mlock dance.
>
> * guest may do silent deflation if available: combo of Linux driver +
> Frank's driver.  Negotiates both features, looks at
> VIRTIO_BALLOON_F_SILENT_DEFLATE host feature to decide how to behave:
> 
>   ** If PCI passthrough, the host will not negotiate
>      VIRTIO_BALLOON_F_SILENT_DEFLATE.  The driver will behave as the
>      current Linux driver, the host can do the munlock/mlock dance.

So this case is just existing interface. OK.

>   ** If no PCI passthrough, the host will negotiate
>      VIRTIO_BALLOON_F_SILENT_DEFLATE, and the driver can balloon more
>      aggressively and not use the deflateq.
> 
> Paolo

This last trickery confuses me.  It just does not make sense to set both
SILENT and TELL: either you are silent or you tell.

What is the benefit of avoiding host notification?
It seems cleaner for the host to know the state.



-- 
MST
