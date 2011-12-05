Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1LEAWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 19:22:34 -0500
Received: from ozlabs.org ([203.10.76.45]:57530 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab1LEAWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 19:22:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect descriptors
In-Reply-To: <4EDB8EEB.4070309@redhat.com>
References: <1322669511.3985.8.camel@lappy> <87wrahrp0u.fsf@rustcorp.com.au> <20111201075847.GA5479@redhat.com> <1322726977.3259.3.camel@lappy> <20111201102640.GB8822@redhat.com> <87zkfbre9x.fsf@rustcorp.com.au> <1322913028.3782.4.camel@lappy> <4EDB5EF0.2010909@redhat.com> <20111204120132.GB18758@redhat.com> <4EDB624A.3030403@redhat.com> <20111204151148.GA21851@redhat.com> <4EDB8EEB.4070309@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 05 Dec 2011 10:40:01 +1030
Message-ID: <87bornri92.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Dec 2011 17:16:59 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/04/2011 05:11 PM, Michael S. Tsirkin wrote:
> > > There's also the used ring, but that's a
> > > mistake if you have out of order completion.  We should have used copying.
> >
> > Seems unrelated... unless you want used to be written into
> > descriptor ring itself?
> 
> The avail/used rings are in addition to the regular ring, no?  If you
> copy descriptors, then it goes away.

There were two ideas which drove the current design:

1) The Van-Jacobson style "no two writers to same cacheline makes rings
   fast" idea.  Empirically, this doesn't show any winnage.
2) Allowing a generic inter-guest copy mechanism, so we could have
   genuinely untrusted driver domains.  Yet noone ever did this so it's
   hardly a killer feature :(

So if we're going to revisit and drop those requirements, I'd say:

1) Shared device/driver rings like Xen.  Xen uses device-specific ring
   contents, I'd be tempted to stick to our pre-headers, and a 'u64
   addr; u64 len_and_flags; u64 cookie;' generic style.  Then use
   the same ring for responses.  That's a slight space-win, since
   we're 24 bytes vs 26 bytes now.

2) Stick with physically-contiguous rings, but use them of size (2^n)-1.
   Makes the indexing harder, but that -1 lets us stash the indices in
   the first entry and makes the ring a nice 2^n size.

> > > 16kB worth of descriptors is 1024 entries.  With 4kB buffers, that's 4MB
> > > worth of data, or 4 ms at 10GbE line speed.  With 1500 byte buffers it's
> > > just 1.5 ms.  In any case I think it's sufficient.
> >
> > Right. So I think that without indirect, we waste about 3 entries
> > per packet for virtio header and transport etc headers.
> 
> That does suck.  Are there issues in increasing the ring size?  Or
> making it discontiguous?

Because the qemu implementation is broken.  We can often put the virtio
header at the head of the packet.  In practice, the qemu implementation
insists the header be a single descriptor.

(At least, it used to, perhaps it has now been fixed.  We need a
VIRTIO_NET_F_I_NOW_CONFORM_TO_THE_DAMN_SPEC_SORRY_I_SUCK bit).

We currently use small rings: the guest can't negotiate so qemu has to
offer a lowest-common-denominator value.  The new virtio-pci layout
fixes this, and lets the guest set the ring size.

> Can you take a peek at how Xen manages its rings?  They have the same
> problems we do.

Yes, I made some mistakes, but I did steal from them in the first
place...

Cheers,
Rusty.
