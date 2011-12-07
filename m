Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab1LGNh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:37:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005Ab1LGNh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:37:56 -0500
Message-ID: <4EDF6C2C.3050604@redhat.com>
Date: Wed, 07 Dec 2011 15:37:48 +0200
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
References: <1322669511.3985.8.camel@lappy> <87wrahrp0u.fsf@rustcorp.com.au> <20111201075847.GA5479@redhat.com> <1322726977.3259.3.camel@lappy> <20111201102640.GB8822@redhat.com> <87zkfbre9x.fsf@rustcorp.com.au> <1322913028.3782.4.camel@lappy> <4EDB5EF0.2010909@redhat.com> <20111204120132.GB18758@redhat.com> <4EDB624A.3030403@redhat.com> <20111204151148.GA21851@redhat.com> <4EDB8EEB.4070309@redhat.com> <87bornri92.fsf@rustcorp.com.au> <4EDC9476.3000301@redhat.com> <87pqg2p9t8.fsf@rustcorp.com.au> <4EDDE73D.1080209@redhat.com> <87pqg1kiuu.fsf@rustcorp.com.au>
In-Reply-To: <87pqg1kiuu.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 02:03 PM, Rusty Russell wrote:
> On Tue, 06 Dec 2011 11:58:21 +0200, Avi Kivity <avi@redhat.com> wrote:
> > On 12/06/2011 07:07 AM, Rusty Russell wrote:
> > > Yes, but the hypervisor/trusted party would simply have to do the copy;
> > > the rings themselves would be shared A would say "copy this to/from B's
> > > ring entry N" and you know that A can't have changed B's entry.
> > 
> > Sorry, I don't follow.  How can the rings be shared?  If A puts a gpa in
> > A's address space into the ring, there's no way B can do anything with
> > it, it's an opaque number.  Xen solves this with an extra layer of
> > indirection (grant table handles) that cost extra hypercalls to map or
> > copy.
>
> It's not symmetric.  B can see the desc and avail pages R/O, and the
> used page R/W.  It needs to ask the something to copy in/out of
> descriptors, though, because they're an opaque number, and it doesn't
> have access.  ie. the existence of the descriptor in the ring *implies*
> a grant.
>
> Perhaps this could be generalized further into a "connect these two
> rings", but I'm not sure.  Descriptors with both read and write parts
> are tricky.

Okay, I was using a wrong mental model of how this works.  B must be
aware of the translation from A's address space into B.  Both qemu and
the kernel can do this on their own, but if B is another guest, then it
cannot do this except by calling H.

vhost-copy cannot work fully transparently, because you need some memory
to copy into.  Maybe we can have a pci device with a large BAR that
contains buffers for copying, and also a translation from A addresses
into B addresses.  It would work something like this:

  A prepares a request with both out and in buffers
  vhost-copy allocates memory in B's virtio-copy BAR, copies (using a
DMA engine) the out buffers into it, and rewrites the out descriptors to
contain B addresses
  B services the request, and updates the in addresses in the
descriptors to point at B memory
  vhost-copy copies (using a DMA engine) the in buffers into A memory

> > > I'm just not sure how the host would even know to hint.
> > 
> > For JBOD storage, a good rule of thumb is (number of spindles) x 3. 
> > With less, you might leave an idle spindle; with more, you're just
> > adding latency.  This assumes you're using indirects so ring entry ==
> > request.  The picture is muddier with massive battery-backed RAID
> > controllers or flash.
> > 
> > For networking, you want (ring size) * min(expected packet size, page
> > size) / (link bandwidth) to be something that doesn't get the
> > bufferbloat people after your blood.
>
> OK, so while neither side knows, the host knows slightly more.
>
> Now I think about it, from a spec POV, saying it's a "hint" is useless,
> as it doesn't tell the driver what to do with it.  I'll say it's a
> maximum, which keeps it simple.
>

Those rules of thumb always have exceptions, I'd say it's the default
that the guest can override.

-- 
error compiling committee.c: too many arguments to function

