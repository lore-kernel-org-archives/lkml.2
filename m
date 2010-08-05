Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab0HEVR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:17:28 -0400
Received: from smtp.citrix.com ([66.165.176.89]:1825 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab0HEVRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:17:24 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Aug 2010 17:17:24 EDT
X-IronPort-AV: E=Sophos;i="4.55,324,1278302400"; 
   d="scan'208";a="9667362"
Subject: Re: commit "xen/blkfront: use tagged queuing for barriers"
From: Daniel Stodden <daniel.stodden@citrix.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>
In-Reply-To: <20100805171944.GA28446@infradead.org>
References: <20100804115124.GA1496@infradead.org>
	 <4C596252.9010806@fusionio.com> <20100804164441.GA7838@infradead.org>
	 <4C5AF01C.3040601@goop.org>  <20100805171944.GA28446@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 5 Aug 2010 14:07:42 -0700
Message-ID: <1281042462.4659.87.camel@agari.van.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 13:19 -0400, Christoph Hellwig wrote:

> > blkback - the in-kernel backend - does generate barriers when it
> > receives one from the guest.  Could you expand on why passing a
> > guest barrier through to the host IO stack would be bad for
> > performance?  Isn't this exactly the same as a local writer
> > generating a barrier?
> 
> If you pass it on it has the same semantics, but given that you'll
> usually end up having multiple guest disks on a single volume using
> lvm or similar you'll end up draining even more I/O as there is one
> queue for all of them.  That way you can easily have one guest starve
> others.

> > >Now where both old and new one are buggy is that that they don't
> > >include the QUEUE_ORDERED_DO_PREFLUSH  and
> > >QUEUE_ORDERED_DO_POSTFLUSH/QUEUE_ORDERED_DO_FUA which mean any
> > >explicit cache flush (aka empty barrier) is silently dropped, making
> > >fsync and co not preserve data integrity.
> > 
> > Ah, OK, something specific.  What level ends up dropping the empty
> > barrier?  Certainly an empty WRITE_BARRIER operation to the backend
> > will cause all prior writes to be durable, which should be enough.
> > Are you saying that there's an extra flag we should be passing to
> > blk_queue_ordered(), or is there some other interface we should be
> > implementing for explicit flushes?
> > 
> > Is there a good reference implementation we can use as a model?
> 
> Just read Documentation/block/barriers.txt, it's very well described
> there.  Even the naming of the various ORDERED constant should
> give enough hints.

That one is read and well understood.

I presently don't see a  point in having the frontend perform its own
pre or post flushes as long as there's a single queue in the block
layer. But if the kernel drops the plain _TAG mode, there is no  problem
with that. Essentially the frontend may drain the queue as much as as it
wants. It just won't buy you much if the backend I/O was actually
buffered, other than adding latency to the transport.

The only thing which matters is that the frontend lld gets to see the
actual barrier point, anything else needs to be sorted out next to the
physical layer anyway, so it's better left to the backends.

Not sure if I understand your above comment regarding the flush and fua
bits. Did you mean to indicate that _TAG on the frontend's request_queue
is presently not coming up with the empty barrier request to make
_explicit_ cache flushes happen? That would be something which
definitely needs a workaround in the frontend then. In that case, would
PRE/POSTFLUSH help, to get a call into prepare_flush_fn, which might
insert the tag itself then? It's sounds a bit over the top to combine
this with a queue drain on the transport, but I'm rather after
correctness.

Regarding the potential starvation problems when accessing shared
physical storage you mentioned above: Yes, good point, we discussed that
too, although only briefly, and it's a todo which I don't think has been
solved in any present backend. But again, scheduling/merging
drain/flush/fua on shared physical nodes more carefully would be
something better *enforced*. The frontend can't even avoid it.

I wonder if there's a userspace solution for that. Does e.g. fdatasync()
deal with independent invocations other than serializing? Couldn't find
anything which indicates that, but I might not have looked hard enough.
The blktap userspace component presently doesn't buffer, so a _DRAIN is
sufficient. But if it did, then it'd be kinda cool if handled more
carefully. If the kernel does it, all the better.

Thanks,
Daniel


