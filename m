Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab1LFJ6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:58:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018Ab1LFJ6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:58:31 -0500
Message-ID: <4EDDE73D.1080209@redhat.com>
Date: Tue, 06 Dec 2011 11:58:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect
 descriptors
References: <1322669511.3985.8.camel@lappy> <87wrahrp0u.fsf@rustcorp.com.au> <20111201075847.GA5479@redhat.com> <1322726977.3259.3.camel@lappy> <20111201102640.GB8822@redhat.com> <87zkfbre9x.fsf@rustcorp.com.au> <1322913028.3782.4.camel@lappy> <4EDB5EF0.2010909@redhat.com> <20111204120132.GB18758@redhat.com> <4EDB624A.3030403@redhat.com> <20111204151148.GA21851@redhat.com> <4EDB8EEB.4070309@redhat.com> <87bornri92.fsf@rustcorp.com.au> <4EDC9476.3000301@redhat.com> <87pqg2p9t8.fsf@rustcorp.com.au>
In-Reply-To: <87pqg2p9t8.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 07:07 AM, Rusty Russell wrote:
> On Mon, 05 Dec 2011 11:52:54 +0200, Avi Kivity <avi@redhat.com> wrote:
> > On 12/05/2011 02:10 AM, Rusty Russell wrote:
> > > On Sun, 04 Dec 2011 17:16:59 +0200, Avi Kivity <avi@redhat.com> wrote:
> > > > On 12/04/2011 05:11 PM, Michael S. Tsirkin wrote:
> > > > > > There's also the used ring, but that's a
> > > > > > mistake if you have out of order completion.  We should have used copying.
> > > > >
> > > > > Seems unrelated... unless you want used to be written into
> > > > > descriptor ring itself?
> > > > 
> > > > The avail/used rings are in addition to the regular ring, no?  If you
> > > > copy descriptors, then it goes away.
> > >
> > > There were two ideas which drove the current design:
> > >
> > > 1) The Van-Jacobson style "no two writers to same cacheline makes rings
> > >    fast" idea.  Empirically, this doesn't show any winnage.
> > 
> > Write/write is the same as write/read or read/write.  Both cases have to
> > send a probe and wait for the result.  What we really need is to
> > minimize cache line ping ponging, and the descriptor pool fails that
> > with ooo completion.  I doubt it's measurable though except with the
> > very fastest storage providers.
>
> The claim was that going exclusive->shared->exclusive was cheaper than
> exclusive->invalid->exclusive.  When VJ said it, it seemed convincing :)

IIRC at some point in time certain transitions were forced to go through
main memory; perhaps that was behind this.  I think these days
everything goes through the coherency protocol; not sure though.

> > > 2) Allowing a generic inter-guest copy mechanism, so we could have
> > >    genuinely untrusted driver domains.  Yet noone ever did this so it's
> > >    hardly a killer feature :(
> > 
> > It's still a goal, though not an important one.  But we have to
> > translate rings anyway, don't, since buffers are in guest physical
> > addresses, and we're moving into an address space that doesn't map those.
>
> Yes, but the hypervisor/trusted party would simply have to do the copy;
> the rings themselves would be shared A would say "copy this to/from B's
> ring entry N" and you know that A can't have changed B's entry.

Sorry, I don't follow.  How can the rings be shared?  If A puts a gpa in
A's address space into the ring, there's no way B can do anything with
it, it's an opaque number.  Xen solves this with an extra layer of
indirection (grant table handles) that cost extra hypercalls to map or copy.

> > I thought of having a vhost-copy driver that could do ring translation,
> > using a dma engine for the copy.
>
> As long as we get the length of data written from the vhost-copy driver
> (ie. not just the network header).  Otherwise a malicious other guest
> can send short packets, and a local process can read uninitialized
> memory.  And pre-zeroing the buffers for this corner case sucks.

Right.  It's important to get the metadata visible at the right layer.

> > Also, stuff the cookie into len_and_flags as well.
>
> Every driver really wants to put a pointer in there.  We have an array
> to map desc. numbers to cookies inside the virtio core.
>
> We really want 64 bits.

With multiqueue, it may be cheaper to do the extra translation locally
than to ship the cookie across cores (or, more likely, it will make no
difference).

However, moving pointers only works if you trust the other side.  That
doesn't work if we manage to share a ring.

> > > 2) Stick with physically-contiguous rings, but use them of size (2^n)-1.
> > >    Makes the indexing harder, but that -1 lets us stash the indices in
> > >    the first entry and makes the ring a nice 2^n size.
> > 
> > Allocate at lease a cache line for those.  The 2^n size is not really
> > material, a division is never necessary.
>
> We free-run our indices, so we *do* a division (by truncation).  If we
> limit indices to ringsize, then we have to handle empty/full confusion.
>
> It's nice for simple OSes if things pack nicely into pages, but it's not
> a killer feature IMHO.

Agree.

> > > > > > 16kB worth of descriptors is 1024 entries.  With 4kB buffers, that's 4MB
> > > > > > worth of data, or 4 ms at 10GbE line speed.  With 1500 byte buffers it's
> > > > > > just 1.5 ms.  In any case I think it's sufficient.
> > > > >
> > > > > Right. So I think that without indirect, we waste about 3 entries
> > > > > per packet for virtio header and transport etc headers.
> > > > 
> > > > That does suck.  Are there issues in increasing the ring size?  Or
> > > > making it discontiguous?
> > >
> > > Because the qemu implementation is broken.  
> > 
> > I was talking about something else, but this is more important.  Every
> > time we make a simplifying assumption, it turns around and bites us, and
> > the code becomes twice as complicated as it would have been in the first
> > place, and the test matrix explodes.
>
> True, though we seem to be improving.  But this is why I don't want
> optional features in the spec; I want us always to exercise all of it.

Yes, and I think the main reason we're improving is that we actually
have a spec these days.  Agree about optional features, though of course
we accumulate them by not thinking of everything ahead of time, I don't
see how we can fix that.

> > > We currently use small rings: the guest can't negotiate so qemu has to
> > > offer a lowest-common-denominator value.  The new virtio-pci layout
> > > fixes this, and lets the guest set the ring size.
> > 
> > Ok good.  Note the figuring out the best ring size needs some info from
> > the host, but that can be had from other channels.
>
> We have a ringsize field; should the host initialize it as a hint?  Or
> as a maximum allowable?
>
> I'm just not sure how the host would even know to hint.

For JBOD storage, a good rule of thumb is (number of spindles) x 3. 
With less, you might leave an idle spindle; with more, you're just
adding latency.  This assumes you're using indirects so ring entry ==
request.  The picture is muddier with massive battery-backed RAID
controllers or flash.

For networking, you want (ring size) * min(expected packet size, page
size) / (link bandwidth) to be something that doesn't get the
bufferbloat people after your blood.

> > > > Can you take a peek at how Xen manages its rings?  They have the same
> > > > problems we do.
> > >
> > > Yes, I made some mistakes, but I did steal from them in the first
> > > place...
> > 
> > There was a bit of second system syndrome there.
>
> But also some third syndrome: Xen had gone through their great device
> rewrite, and things like feature bits were a direct response against
> that complexity.  We did well there.

Yes, feature bits really proved themselves.

-- 
error compiling committee.c: too many arguments to function

