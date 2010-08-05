Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab0HERTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:19:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33040 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab0HERTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:19:48 -0400
Date: Thu, 5 Aug 2010 13:19:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org,
        Daniel Stodden <daniel.stodden@citrix.com>, kraxel@redhat.com
Subject: Re: commit "xen/blkfront: use tagged queuing for barriers"
Message-ID: <20100805171944.GA28446@infradead.org>
References: <20100804115124.GA1496@infradead.org>
 <4C596252.9010806@fusionio.com>
 <20100804164441.GA7838@infradead.org>
 <4C5AF01C.3040601@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5AF01C.3040601@goop.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 10:08:44AM -0700, Jeremy Fitzhardinge wrote:
>  On 08/04/2010 09:44 AM, Christoph Hellwig wrote:
> >>But either the blkfront patch is wrong and it needs to be fixed,
> >Actually both the old and the new one are wrong, but I'd say the new
> >one is even more wrong.
> >
> >_TAG implies that the device can do ordering by tag.  And at least the
> >qemu xen_disk backend doesn't when it advertizes this feature.
> 
> We don't use qemu at all for block storage; qemu (afaik) doesn't
> have a blkback protocol implementation in it.  I'm guessing xen_disk
> is to allow kvm to be compatible with Xen disk images?  It certainly
> isn't a reference implementation.

Disk images formats have nothing to do with the I/O interface.  I
believe Gerd added it for running unmodified Xen guests in qemu,
but he can explain more of it.

I've only mentioned it here because it's the one I easily have access
to.  Given Xen's about 4 different I/O backends and the various forked
trees it's rather hard to find the official reference.

> >I'm pretty sure most if not all of the original Xen backends do the
> >same.  Given that I have tried to implement tagged ordering in qemu
> >I know that comes down to doing exactly the same draining we already
> >do in the kernel, just duplicated in the virtual disk backend.  That
> >is for a userspace implementation - for a kernel implementation only
> >using block devices we could in theory implement it using barriers,
> >but that would be even more inefficient.  And last time I looked
> >at the in-kernel xen disk backed it didn't do that either.
> 
> blkback - the in-kernel backend - does generate barriers when it
> receives one from the guest.  Could you expand on why passing a
> guest barrier through to the host IO stack would be bad for
> performance?  Isn't this exactly the same as a local writer
> generating a barrier?

If you pass it on it has the same semantics, but given that you'll
usually end up having multiple guest disks on a single volume using
lvm or similar you'll end up draining even more I/O as there is one
queue for all of them.  That way you can easily have one guest starve
others.

Note that we're going to get rid of the draining for common cases
anyway, but that's a separate discussion thread the "relaxed barriers"
one.

> It's true that a number of the Xen backends end up implementing
> barriers via drain for simplicity's sake, but there's no inherent
> reason why they couldn't implement a more complete tagged model.

If they are in Linux/Posix userspace they can't because there are
not system calls to archive that.  And then again there really is
no need to implement all this in the host anyway - the draining
is something we enforced on ourselves in Linux without good reason,
which we're trying to get rid of and no other OS ever did.

> >Now where both old and new one are buggy is that that they don't
> >include the QUEUE_ORDERED_DO_PREFLUSH  and
> >QUEUE_ORDERED_DO_POSTFLUSH/QUEUE_ORDERED_DO_FUA which mean any
> >explicit cache flush (aka empty barrier) is silently dropped, making
> >fsync and co not preserve data integrity.
> 
> Ah, OK, something specific.  What level ends up dropping the empty
> barrier?  Certainly an empty WRITE_BARRIER operation to the backend
> will cause all prior writes to be durable, which should be enough.
> Are you saying that there's an extra flag we should be passing to
> blk_queue_ordered(), or is there some other interface we should be
> implementing for explicit flushes?
> 
> Is there a good reference implementation we can use as a model?

Just read Documentation/block/barriers.txt, it's very well described
there.  Even the naming of the various ORDERED constant should
give enough hints.

> As I said before, the qemu xen backend is irrelevent.

It's one of the many backends written to the protocol specification,
I don't think it's fair to call it irrelevant.  And as mentioned before
I'd be very surprised if the other backends all get it right.  If you
send me pointers to one or two backends you considered "relevent" I'm
happy to look at them.

