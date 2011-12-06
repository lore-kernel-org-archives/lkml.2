Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1LFFol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 00:44:41 -0500
Received: from ozlabs.org ([203.10.76.45]:49708 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab1LFFok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 00:44:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect descriptors
In-Reply-To: <4EDC9476.3000301@redhat.com>
References: <1322669511.3985.8.camel@lappy> <87wrahrp0u.fsf@rustcorp.com.au> <20111201075847.GA5479@redhat.com> <1322726977.3259.3.camel@lappy> <20111201102640.GB8822@redhat.com> <87zkfbre9x.fsf@rustcorp.com.au> <1322913028.3782.4.camel@lappy> <4EDB5EF0.2010909@redhat.com> <20111204120132.GB18758@redhat.com> <4EDB624A.3030403@redhat.com> <20111204151148.GA21851@redhat.com> <4EDB8EEB.4070309@redhat.com> <87bornri92.fsf@rustcorp.com.au> <4EDC9476.3000301@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 06 Dec 2011 15:37:31 +1030
Message-ID: <87pqg2p9t8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Dec 2011 11:52:54 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/05/2011 02:10 AM, Rusty Russell wrote:
> > On Sun, 04 Dec 2011 17:16:59 +0200, Avi Kivity <avi@redhat.com> wrote:
> > > On 12/04/2011 05:11 PM, Michael S. Tsirkin wrote:
> > > > > There's also the used ring, but that's a
> > > > > mistake if you have out of order completion.  We should have used copying.
> > > >
> > > > Seems unrelated... unless you want used to be written into
> > > > descriptor ring itself?
> > > 
> > > The avail/used rings are in addition to the regular ring, no?  If you
> > > copy descriptors, then it goes away.
> >
> > There were two ideas which drove the current design:
> >
> > 1) The Van-Jacobson style "no two writers to same cacheline makes rings
> >    fast" idea.  Empirically, this doesn't show any winnage.
> 
> Write/write is the same as write/read or read/write.  Both cases have to
> send a probe and wait for the result.  What we really need is to
> minimize cache line ping ponging, and the descriptor pool fails that
> with ooo completion.  I doubt it's measurable though except with the
> very fastest storage providers.

The claim was that going exclusive->shared->exclusive was cheaper than
exclusive->invalid->exclusive.  When VJ said it, it seemed convincing :)

> > 2) Allowing a generic inter-guest copy mechanism, so we could have
> >    genuinely untrusted driver domains.  Yet noone ever did this so it's
> >    hardly a killer feature :(
> 
> It's still a goal, though not an important one.  But we have to
> translate rings anyway, don't, since buffers are in guest physical
> addresses, and we're moving into an address space that doesn't map those.

Yes, but the hypervisor/trusted party would simply have to do the copy;
the rings themselves would be shared A would say "copy this to/from B's
ring entry N" and you know that A can't have changed B's entry.

> I thought of having a vhost-copy driver that could do ring translation,
> using a dma engine for the copy.

As long as we get the length of data written from the vhost-copy driver
(ie. not just the network header).  Otherwise a malicious other guest
can send short packets, and a local process can read uninitialized
memory.  And pre-zeroing the buffers for this corner case sucks.

> > So if we're going to revisit and drop those requirements, I'd say:
> >
> > 1) Shared device/driver rings like Xen.  Xen uses device-specific ring
> >    contents, I'd be tempted to stick to our pre-headers, and a 'u64
> >    addr; u64 len_and_flags; u64 cookie;' generic style.  Then use
> >    the same ring for responses.  That's a slight space-win, since
> >    we're 24 bytes vs 26 bytes now.
> 
> Let's cheat and have inline contents.  Take three bits from
> len_and_flags to specify additional descriptors as inline data.

Nice, I like this optimization.

> Also, stuff the cookie into len_and_flags as well.

Every driver really wants to put a pointer in there.  We have an array
to map desc. numbers to cookies inside the virtio core.

We really want 64 bits.

> > 2) Stick with physically-contiguous rings, but use them of size (2^n)-1.
> >    Makes the indexing harder, but that -1 lets us stash the indices in
> >    the first entry and makes the ring a nice 2^n size.
> 
> Allocate at lease a cache line for those.  The 2^n size is not really
> material, a division is never necessary.

We free-run our indices, so we *do* a division (by truncation).  If we
limit indices to ringsize, then we have to handle empty/full confusion.

It's nice for simple OSes if things pack nicely into pages, but it's not
a killer feature IMHO.

> > > > > 16kB worth of descriptors is 1024 entries.  With 4kB buffers, that's 4MB
> > > > > worth of data, or 4 ms at 10GbE line speed.  With 1500 byte buffers it's
> > > > > just 1.5 ms.  In any case I think it's sufficient.
> > > >
> > > > Right. So I think that without indirect, we waste about 3 entries
> > > > per packet for virtio header and transport etc headers.
> > > 
> > > That does suck.  Are there issues in increasing the ring size?  Or
> > > making it discontiguous?
> >
> > Because the qemu implementation is broken.  
> 
> I was talking about something else, but this is more important.  Every
> time we make a simplifying assumption, it turns around and bites us, and
> the code becomes twice as complicated as it would have been in the first
> place, and the test matrix explodes.

True, though we seem to be improving.  But this is why I don't want
optional features in the spec; I want us always to exercise all of it.

> > We can often put the virtio
> > header at the head of the packet.  In practice, the qemu implementation
> > insists the header be a single descriptor.
> >
> > (At least, it used to, perhaps it has now been fixed.  We need a
> > VIRTIO_NET_F_I_NOW_CONFORM_TO_THE_DAMN_SPEC_SORRY_I_SUCK bit).
> 
> We'll run out of bits in no time.

We had one already: VIRTIO_F_BAD_FEATURE.  We haven't used it in a long
time (if ever), and I just removed it from the latest version of the
spec.

But we can cheat: we can add this as a requirement to The New Ring
Layout.  And document the old behaviour as a footnote.

> > We currently use small rings: the guest can't negotiate so qemu has to
> > offer a lowest-common-denominator value.  The new virtio-pci layout
> > fixes this, and lets the guest set the ring size.
> 
> Ok good.  Note the figuring out the best ring size needs some info from
> the host, but that can be had from other channels.

We have a ringsize field; should the host initialize it as a hint?  Or
as a maximum allowable?

I'm just not sure how the host would even know to hint.

> > > Can you take a peek at how Xen manages its rings?  They have the same
> > > problems we do.
> >
> > Yes, I made some mistakes, but I did steal from them in the first
> > place...
> 
> There was a bit of second system syndrome there.

But also some third syndrome: Xen had gone through their great device
rewrite, and things like feature bits were a direct response against
that complexity.  We did well there.

> And I don't understand how the ring/pool issue didn't surface during
> review, it seems so obvious now but completely eluded me then.

The idea was we'd just enlarge the rings.  Only later did that prove
naive, and many things came in to fix that.  The cacheline issue is
speculative at this point.

But we are learning, and making fewer mistakes; we could have learn some
things earlier (I was remiss in not seeking the Xen devs' advice on the
ring itself, for example).

I honestly don't think it gets much better than this in Real Life.

I'm working on the virtio-pci capability layout patch now, then I'll
look at a ring rewrite.

Thanks,
Rusty.
