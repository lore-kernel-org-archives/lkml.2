Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab0FZDfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 23:35:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab0FZDfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 23:35:38 -0400
Date: Fri, 25 Jun 2010 23:35:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100626033509.GA2435@redhat.com>
References: <20100621094828.GA30748@lst.de>
 <4C1F3916.4070608@kernel.dk>
 <20100621110436.GA4056@lst.de>
 <4C1FB5F7.3070908@kernel.dk>
 <20100621191410.GA24213@lst.de>
 <20100621213618.GC6474@redhat.com>
 <20100623100138.GA9575@lst.de>
 <20100624014420.GB3297@redhat.com>
 <20100625110319.GA12855@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100625110319.GA12855@lst.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 01:03:20PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 23, 2010 at 09:44:20PM -0400, Vivek Goyal wrote:
> > Let me explain the general idling logic and then see if it makes sense in case
> > of WRITE_SYNC.
> > 
> > Once a request has completed, if the cfq queue is empty, we have two choices.
> > Either expire the cfq queue and move on to dispatch requests from a
> > different queue or we idle on the queue hoping we will get more IO from
> > same process/queue.
> 
> queues are basically processes in this context?

Yes. Basically IO context. Generally one per process but multiple threads
can also share the IO context and requests from all the threads will go
into single cfq queue.

> 
> > Idling can help (on SATA disks with high seek cost), if
> > our guess was right and soon we got another request from same process. We
> > cut down on number of seeks hence increased throghput.
> 
> I don't really understand the logic behind this.  If we lots of I/O
> that actually is close to each other we should generally submit it in
> one batch.  That is true for pagecache writeback, that is true for
> metadata (at least in XFS..), and it's true for any sane application
> doing O_DIRECT / O_SYNC style I/O.
> 
> What workloads produde I/O that is local (not random) writes with small
> delays between the I/O requests?
> 

That's a good question. I don't have an answer for that. I have most of the
time done my testing using fio where one can create synthetic workload of
doing O_DIRECT/O_SYNC sequential/local writes after small delays.

I think I need to run blktrace on some of the real life workloads and monitor
for WRITE_SYNC pattern.

> I see the point of this logic for reads where various workloads have
> dependent reads that might be close to each other, but I don't really
> see any point for writes.
> 
> > So looks like fsync path will do bunch of IO and then will wait for jbd thread
> > to finish the work. In this case idling is waste of time.
> 
> Given that ->writepage already does WRITE_SYNC_PLUG I/O which includes
> REQ_NODILE I'm still confused why we still have that issue.

In current form, cfq honors REQ_NOIDLE conditionally and that's why we
still have the issue. If you look at cfq_completed_request(), we continue
to idle in following two cases.

- If we classifed the queue as SYNC_WORKLOAD.
- If there is another random read/write happening on sync-noidle service
  tree.

SYNC_WORKLOAD means that cfq thinks this particular queue is doing sequential
IO. For random IO queues, we don't idle on each individual queue but a
group of queue.

In jeff's testing, fsync thread/queue sometimes is viewed as sequential
workload and goes on SYNC_WORKLOAD tree. In that case even if request is
REQ_NOIDLE, we will continue to idle hence fsync issue.

This logic was introduced by corrado to ensure WRITE_SYNC does not
lose fair share. Now we are back to the same question, what is the workload
which does that.

8e55063 cfq-iosched: fix corner cases in idling logic

Before this patch, we will simply not do any idling on WRITE_SYNC. That
means no idling on O_SYNC/fsync paths but still idle on direct IO
WRITE_SYNC. Which is a bit of discrepancy.

> 
> > I guess same will
> > be true for umount and sync() path. But same probably is not necessarily true
> > for a O_DIRECT writer (database comes to mind), and for O_SYNC writer
> > (virtual machines?).
> 
> For virtual machines idling seems like a waste of ressources.  If we
> have sequential I/O we dispatch in batches - in fact qemu even merges
> sequential small block I/O it gets from the guest into one large request
> we hand off to the host kernel.  For reads the same caveat as above
> applies as read requests as handed through 1:1 from the guest.
> 

Ok, That's good to know.

> > O_SYNC writers will get little disk share in presence of heavy buffered
> > WRITES. If we choose to not special case WRITE_SYNC and continue to
> > idle on the queue then we probably are wasting time and reducing overall
> > throughput. (The fsync() case Jeff is running into).
> 
> Remember that O_SYNC writes are implemented as normal buffered write +
> fsync (a range fsync to be exact, but that doesn't change a thing).
> 
> And that's what they conceptually are anyway, so treating a normal
> buffered write + fsync different from an O_SYNC write is not only wrong
> conceptuall but also in implementation.  You have the exact same issue
> of handing off work to the journal commit thread in extN.

Actually right now I think O_DIRECT is getting different treatment as
it does not mark queue IO as RQ_NOIDLE. As you said O_SYNC is just fsync
on a specific range, so both the paths will mark RQ_NOIDLE and get treated
same in IO scheduler.

Intially Jens treated O_DIRECT differently and then Jeff put a patch which
accidently got rid of that difference and finally I had reintroduced the
O_DIRECT flag.

d9449ce Fix regression in direct writes performance due to WRITE_ODIRECT flag

I have explained the effect of not idling on DIRECT writes in changelog. It
gets very little BW in presence of sequential reads.

With idling on WRITE_SYNC, distribution looks as follows.

    direct writes: aggrb=2,968KB/s
    readers          : aggrb=101MB/s

Without idling on WRITE_SYNC, distribution of BW looks as follows.

    direct write: aggrb=19KB/s
    readers           aggrb=137MB/s

So notice how sequential reads can starve a DIRECT sequential writer. Now
this is a synthetic workload created with the help of fio where sequential
writes are submitted with delay in between (i think so). We are back to
the question that the application should coalesce sequential writes and
submit bigger write requests. Otherwise you will lose share and get
starved out.

So going forward, I think there are few possible options.

- Stop idling on all the WRITE_SYNC IO. There is no reasonable way to 
  tell whether there will be more IO or not from applicatoin. This will
  impact direct writes, O_SYNC writes and fsync().

  If direct IO application is submitting writes with a delay in between
  it can be starved out in presnce of competing workloads.

  In this scheme we get rid of all rq_noidle logic, get rid of separate
  flag for direct IO, WRITE_ODIRECT_PLUG, and also don't need any queue
  yielding patches as we never idle on SYNC_WRITES.

  The important thing to note here is that even direct random writes
  will lose share here if we don't keep the queue busy continuously
  and issue random writes after a delay. (database?).

- Do idling by default on WRITE_SYNC path. Implement Jeff's queue yielding
  patches. That way O_SYNC/fsyn path will call blk_yield() and stop idling.
  Direct IO write path will stil continue to idle (I think if file has already
  been laid out?). 

I have no idea in real world how SYNC_WRITE workloads look like and how
their traffic pattern is. So it is hard to say which scheme to go for.
Jens, what do you think of above?

> Note that
> the log write (or at least parts of it) will always use WRITE_BARRIER,
> which completey bypasses the I/O scheduler.  
> 
> > So one possible way could be that don't try to special case synchronous
> > writes and continue to idle on the queue based on other parameters. If
> > kernel/higher layers have knowledge that we are not going to issue more
> > IO in same context, then they should explicitly call blk_yield(), to
> > stop idling and give up slice.
> 
> We have no way to know what userspace will do if we are doing
> O_SYNC/O_DIRECT style I/O or use fsync.  We know that we will most
> likely continue kicking things from the same queue when doing page
> writeback.  One thing that should help with this is Jens' explicit
> per-process plugging stuff, which I noticed he recently updated to a
> current kernel.

Ok. I will have a look at that.

Thanks
Vivek

