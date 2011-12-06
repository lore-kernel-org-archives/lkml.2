Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab1LFMJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 07:09:58 -0500
Received: from ozlabs.org ([203.10.76.45]:50607 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933238Ab1LFMJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 07:09:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect descriptors
In-Reply-To: <4EDDE73D.1080209@redhat.com>
References: <1322669511.3985.8.camel@lappy> <87wrahrp0u.fsf@rustcorp.com.au> <20111201075847.GA5479@redhat.com> <1322726977.3259.3.camel@lappy> <20111201102640.GB8822@redhat.com> <87zkfbre9x.fsf@rustcorp.com.au> <1322913028.3782.4.camel@lappy> <4EDB5EF0.2010909@redhat.com> <20111204120132.GB18758@redhat.com> <4EDB624A.3030403@redhat.com> <20111204151148.GA21851@redhat.com> <4EDB8EEB.4070309@redhat.com> <87bornri92.fsf@rustcorp.com.au> <4EDC9476.3000301@redhat.com> <87pqg2p9t8.fsf@rustcorp.com.au> <4EDDE73D.1080209@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 06 Dec 2011 22:33:21 +1030
Message-ID: <87pqg1kiuu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Dec 2011 11:58:21 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/06/2011 07:07 AM, Rusty Russell wrote:
> > Yes, but the hypervisor/trusted party would simply have to do the copy;
> > the rings themselves would be shared A would say "copy this to/from B's
> > ring entry N" and you know that A can't have changed B's entry.
> 
> Sorry, I don't follow.  How can the rings be shared?  If A puts a gpa in
> A's address space into the ring, there's no way B can do anything with
> it, it's an opaque number.  Xen solves this with an extra layer of
> indirection (grant table handles) that cost extra hypercalls to map or
> copy.

It's not symmetric.  B can see the desc and avail pages R/O, and the
used page R/W.  It needs to ask the something to copy in/out of
descriptors, though, because they're an opaque number, and it doesn't
have access.  ie. the existence of the descriptor in the ring *implies*
a grant.

Perhaps this could be generalized further into a "connect these two
rings", but I'm not sure.  Descriptors with both read and write parts
are tricky.

> > Every driver really wants to put a pointer in there.  We have an array
> > to map desc. numbers to cookies inside the virtio core.
> >
> > We really want 64 bits.
> 
> With multiqueue, it may be cheaper to do the extra translation locally
> than to ship the cookie across cores (or, more likely, it will make no
> difference).

Indeed.

> However, moving pointers only works if you trust the other side.  That
> doesn't work if we manage to share a ring.

Yes, that part needs to be trusted too.

> > I'm just not sure how the host would even know to hint.
> 
> For JBOD storage, a good rule of thumb is (number of spindles) x 3. 
> With less, you might leave an idle spindle; with more, you're just
> adding latency.  This assumes you're using indirects so ring entry ==
> request.  The picture is muddier with massive battery-backed RAID
> controllers or flash.
> 
> For networking, you want (ring size) * min(expected packet size, page
> size) / (link bandwidth) to be something that doesn't get the
> bufferbloat people after your blood.

OK, so while neither side knows, the host knows slightly more.

Now I think about it, from a spec POV, saying it's a "hint" is useless,
as it doesn't tell the driver what to do with it.  I'll say it's a
maximum, which keeps it simple.

Cheers,
Rusty.
