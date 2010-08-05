Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505Ab0HEXMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:12:06 -0400
Received: from claw.goop.org ([74.207.240.146]:36595 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab0HEXMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:12:03 -0400
Message-ID: <4C5B453F.8030401@goop.org>
Date: Thu, 05 Aug 2010 16:11:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        Daniel Stodden <daniel.stodden@citrix.com>, kraxel@redhat.com
Subject: Re: commit "xen/blkfront: use tagged queuing for barriers"
References: <20100804115124.GA1496@infradead.org> <4C596252.9010806@fusionio.com> <20100804164441.GA7838@infradead.org> <4C5AF01C.3040601@goop.org> <20100805171944.GA28446@infradead.org>
In-Reply-To: <20100805171944.GA28446@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/05/2010 10:19 AM, Christoph Hellwig wrote:
>>> I'm pretty sure most if not all of the original Xen backends do the
>>> same.  Given that I have tried to implement tagged ordering in qemu
>>> I know that comes down to doing exactly the same draining we already
>>> do in the kernel, just duplicated in the virtual disk backend.  That
>>> is for a userspace implementation - for a kernel implementation only
>>> using block devices we could in theory implement it using barriers,
>>> but that would be even more inefficient.  And last time I looked
>>> at the in-kernel xen disk backed it didn't do that either.
>> blkback - the in-kernel backend - does generate barriers when it
>> receives one from the guest.  Could you expand on why passing a
>> guest barrier through to the host IO stack would be bad for
>> performance?  Isn't this exactly the same as a local writer
>> generating a barrier?
> If you pass it on it has the same semantics, but given that you'll
> usually end up having multiple guest disks on a single volume using
> lvm or similar you'll end up draining even more I/O as there is one
> queue for all of them.  That way you can easily have one guest starve
> others.

Yes, that's unfortunate.  In the normal case the IO streams would 
actually be independent so they wouldn't need to be serialized with 
respect to each other.  But I don't know if that kind of partial-order 
dependency is possible or on the cards.

> Note that we're going to get rid of the draining for common cases
> anyway, but that's a separate discussion thread the "relaxed barriers"
> one.

Does that mean barriers which enforce ordering without flushing?

>> It's true that a number of the Xen backends end up implementing
>> barriers via drain for simplicity's sake, but there's no inherent
>> reason why they couldn't implement a more complete tagged model.
> If they are in Linux/Posix userspace they can't because there are
> not system calls to archive that.  And then again there really is
> no need to implement all this in the host anyway - the draining
> is something we enforced on ourselves in Linux without good reason,
> which we're trying to get rid of and no other OS ever did.

Userspace might not be relying on the kernel to do storage (it might 
have its own iscsi implementation or something).

>>> Now where both old and new one are buggy is that that they don't
>>> include the QUEUE_ORDERED_DO_PREFLUSH  and
>>> QUEUE_ORDERED_DO_POSTFLUSH/QUEUE_ORDERED_DO_FUA which mean any
>>> explicit cache flush (aka empty barrier) is silently dropped, making
>>> fsync and co not preserve data integrity.
>> Ah, OK, something specific.  What level ends up dropping the empty
>> barrier?  Certainly an empty WRITE_BARRIER operation to the backend
>> will cause all prior writes to be durable, which should be enough.
>> Are you saying that there's an extra flag we should be passing to
>> blk_queue_ordered(), or is there some other interface we should be
>> implementing for explicit flushes?
>>
>> Is there a good reference implementation we can use as a model?
> Just read Documentation/block/barriers.txt, it's very well described
> there.  Even the naming of the various ORDERED constant should
> give enough hints.

I've gone over it a few times.  Since the blkback barriers do both 
ordering and flushing, it seems to me that plain _TAG is the right 
choice; we don't need _TAG_FLUSH or _TAG_FUA.  I still don't understand 
what you mean about "explicit cache flush (aka empty barrier) is 
silently dropped".  Who drops it where?  Do you mean the block subsystem 
will drop an empty write, even if it has a barrier associated with it, 
but if I set PREFLUSH and POSTFLUSH/FUA then those will still come 
through?  If so, isn't dropping a write with a barrier the problem?

> It's one of the many backends written to the protocol specification,
> I don't think it's fair to call it irrelevant.  And as mentioned before
> I'd be very surprised if the other backends all get it right.  If you
> send me pointers to one or two backends you considered "relevent" I'm
> happy to look at them.

You can see the current state in 
git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git 
xen/dom0/backend/blkback is the actual backend part.  It can either 
attach directly to a file/device, or go via blktap for usermode processing.

     J
