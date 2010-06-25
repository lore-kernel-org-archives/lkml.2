Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0FYLDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 07:03:38 -0400
Received: from verein.lst.de ([213.95.11.210]:47796 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0FYLDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:03:36 -0400
Date: Fri, 25 Jun 2010 13:03:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100625110319.GA12855@lst.de>
References: <20100621094828.GA30748@lst.de> <4C1F3916.4070608@kernel.dk> <20100621110436.GA4056@lst.de> <4C1FB5F7.3070908@kernel.dk> <20100621191410.GA24213@lst.de> <20100621213618.GC6474@redhat.com> <20100623100138.GA9575@lst.de> <20100624014420.GB3297@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624014420.GB3297@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 2.142 (**) BAYES_70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 09:44:20PM -0400, Vivek Goyal wrote:
> Let me explain the general idling logic and then see if it makes sense in case
> of WRITE_SYNC.
> 
> Once a request has completed, if the cfq queue is empty, we have two choices.
> Either expire the cfq queue and move on to dispatch requests from a
> different queue or we idle on the queue hoping we will get more IO from
> same process/queue.

queues are basically processes in this context?

> Idling can help (on SATA disks with high seek cost), if
> our guess was right and soon we got another request from same process. We
> cut down on number of seeks hence increased throghput.

I don't really understand the logic behind this.  If we lots of I/O
that actually is close to each other we should generally submit it in
one batch.  That is true for pagecache writeback, that is true for
metadata (at least in XFS..), and it's true for any sane application
doing O_DIRECT / O_SYNC style I/O.

What workloads produde I/O that is local (not random) writes with small
delays between the I/O requests?

I see the point of this logic for reads where various workloads have
dependent reads that might be close to each other, but I don't really
see any point for writes.

> So looks like fsync path will do bunch of IO and then will wait for jbd thread
> to finish the work. In this case idling is waste of time.

Given that ->writepage already does WRITE_SYNC_PLUG I/O which includes
REQ_NODILE I'm still confused why we still have that issue.

> I guess same will
> be true for umount and sync() path. But same probably is not necessarily true
> for a O_DIRECT writer (database comes to mind), and for O_SYNC writer
> (virtual machines?).

For virtual machines idling seems like a waste of ressources.  If we
have sequential I/O we dispatch in batches - in fact qemu even merges
sequential small block I/O it gets from the guest into one large request
we hand off to the host kernel.  For reads the same caveat as above
applies as read requests as handed through 1:1 from the guest.

> O_SYNC writers will get little disk share in presence of heavy buffered
> WRITES. If we choose to not special case WRITE_SYNC and continue to
> idle on the queue then we probably are wasting time and reducing overall
> throughput. (The fsync() case Jeff is running into).

Remember that O_SYNC writes are implemented as normal buffered write +
fsync (a range fsync to be exact, but that doesn't change a thing).

And that's what they conceptually are anyway, so treating a normal
buffered write + fsync different from an O_SYNC write is not only wrong
conceptuall but also in implementation.  You have the exact same issue
of handing off work to the journal commit thread in extN.   Note that
the log write (or at least parts of it) will always use WRITE_BARRIER,
which completey bypasses the I/O scheduler.  

> So one possible way could be that don't try to special case synchronous
> writes and continue to idle on the queue based on other parameters. If
> kernel/higher layers have knowledge that we are not going to issue more
> IO in same context, then they should explicitly call blk_yield(), to
> stop idling and give up slice.

We have no way to know what userspace will do if we are doing
O_SYNC/O_DIRECT style I/O or use fsync.  We know that we will most
likely continue kicking things from the same queue when doing page
writeback.  One thing that should help with this is Jens' explicit
per-process plugging stuff, which I noticed he recently updated to a
current kernel.

