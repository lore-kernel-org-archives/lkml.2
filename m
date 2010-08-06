Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934923Ab0HFMoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 08:44:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48497 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab0HFMn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 08:43:57 -0400
Date: Fri, 6 Aug 2010 08:43:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Stodden <daniel.stodden@citrix.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>
Subject: Re: commit "xen/blkfront: use tagged queuing for barriers"
Message-ID: <20100806124353.GD9606@infradead.org>
References: <20100804115124.GA1496@infradead.org>
 <4C596252.9010806@fusionio.com>
 <20100804164441.GA7838@infradead.org>
 <4C5AF01C.3040601@goop.org>
 <20100805171944.GA28446@infradead.org>
 <1281042462.4659.87.camel@agari.van.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281042462.4659.87.camel@agari.van.xensource.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 02:07:42PM -0700, Daniel Stodden wrote:
> That one is read and well understood.

Given that xen blkfront does not actually implement cache flushes
correctly that doesn't seem to be the case.

> I presently don't see a  point in having the frontend perform its own
> pre or post flushes as long as there's a single queue in the block
> layer. But if the kernel drops the plain _TAG mode, there is no  problem
> with that. Essentially the frontend may drain the queue as much as as it
> wants. It just won't buy you much if the backend I/O was actually
> buffered, other than adding latency to the transport.

You do need the _FLUSH or _FUA modes (either with TAGs or DRAIN) to get
the block layer to send you pure cache flush requests (aka "empty
barriers") without this they don't work.  They way the current barrier
code is implemented means you will always get manual cache flushes
before the actual barrier requests once you implement that.  By using
the _FUA mode you can still do your own post flush.

I've been through doing all this, and given how hard it is to do a
semi-efficient drain in a backend driver, and given that non-Linux
guests don't even benefit from it just leaving the draining to the
guest is the easiest solution.  If you already have the draining around
and are confident that it gets all corner cases right you can of
course keep it and use the QUEUE_ORDERED_TAG_FLUSH/QUEUE_ORDERED_TAG_FUA
modes.  But from dealing with data integrity issues in virtualized
environment I'm not confident that things will just work, both on the
backend side, especially if image formats are around, and also on the
guest side given that QUEUE_ORDERED_TAG* has zero real life testing.

> Not sure if I understand your above comment regarding the flush and fua
> bits. Did you mean to indicate that _TAG on the frontend's request_queue
> is presently not coming up with the empty barrier request to make
> _explicit_ cache flushes happen?

Yes.

> That would be something which
> definitely needs a workaround in the frontend then. In that case, would
> PRE/POSTFLUSH help, to get a call into prepare_flush_fn, which might
> insert the tag itself then? It's sounds a bit over the top to combine
> this with a queue drain on the transport, but I'm rather after
> correctness.

prepare_flush_fn is gone now.

> I wonder if there's a userspace solution for that. Does e.g. fdatasync()
> deal with independent invocations other than serializing?

fsync/fdatasync is serialized by i_mutex.

> The blktap userspace component presently doesn't buffer, so a _DRAIN is
> sufficient. But if it did, then it'd be kinda cool if handled more
> carefully. If the kernel does it, all the better.

Doesn't buffer as in using O_SYNC/O_DYSNC or O_DIRECT?  You still need
to call fdatsync for the latter, to flush out transaction for block
allocations in sparse / fallocated images and to flush the volatile
write cache of the host disks.

