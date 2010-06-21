Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab0FUKEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 06:04:10 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60466 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab0FUKEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 06:04:07 -0400
Message-ID: <4C1F3916.4070608@kernel.dk>
Date: Mon, 21 Jun 2010 12:04:06 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
References: <20100621094828.GA30748@lst.de>
In-Reply-To: <20100621094828.GA30748@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-21 11:48, Christoph Hellwig wrote:
> Hi Jens,
> 
> I'm trying to understand the "sync" and "meta" flags we add to bios /
> requests and the more I look into the more I get confused.  Let's start
> with the simple bits:
> 
>  - REQ_META
> 
> 	Only really used for READ_META.  There's a WRITE_META that I
> 	added a while ago, but the actual users of it are gone again
> 	now.
> 
> 	The READ_META is used by ext3 and ext4 for reading inodes,
> 	and for all reads of directory blocks.  XFS has a place that
> 	sets READ_META, but it's unreachable now.  GFS2 on the other
> 	hand uses REQ_META directly, and ORs it into just about every
> 	other kind of READ/WRITE request: WRITE_BARRIER,
> 	WRITE_SYNC_PLUG, WRITE, READ_SYNC.
> 
>  - REQ_SYNC
> 
> 	Used for READ_SYNC / WRITE_SYNC_PLUG / WRITE_SYNC /
> 	WRITE_ODIRECT_PLUG / WRITE_BARRIER and the SWRITE variants.
> 
> 	READ_SYNC is used by GFS2 in a few spots, but always together
> 	with REQ_META, and by jfs and xfs for the code reading the log
> 	during recovery.
> 	(S)WRITE_SYNC_PLUG is used for ->writepage instances with
> 	the WB_SYNC_ALL sync_mode, and random pieces of journal /
> 	metadata I/O in gfs2 and jbd(2) as well as fsync_buffers_list().
> 	Note that the SWRITE_SYNC_PLUG uses actually degenerate to WRITE
> 	in ll_rw_block.c due to what seems to be a bug in that code.
> 	WRITE_SYNC is used by xfs for the log write if barriers are not
> 	supported, by jfs for all log writes, by gfs2 for at least some
> 	log writes, by btrfs for data writeout in some cases.
> 	SWRITE_SYNC is entirely unused.
> 	WRITE_ODIRECT_PLUG is used for O_DIRECT writes, and
> 	WRITE_BARRIER is used for anything using barriers.
> 
>  - REQ_NOIDLE
> 
> 	Used for WRITE_SYNC_PLUG / WRITE_SYNC / WRITE_BARRIER and
> 	SWRITE variants.  See the description above for details.
> 
>  - REQ_UNPLUG
> 
> 	Used for READ_SYNC, WRITE_SYNC and WRITE_BARRIER.
> 
> Now how do we use these flags in the block layer?
>  
>  - REQ_META
> 
> 	The only place where we ever use this flag is inside the
> 	cfq scheduler. In cfq_choose_req we use it to give a meta
> 	request priority over one that doesn't have it.  But before
> 	that we already do the same preference check with rw_is_sync,
> 	which evaluates to true for requests with that are either
> 	reads or have REQ_SYNC set.  So for reads the REQ_META flag
> 	here effectively is a no-op, and for writes it gives less
> 	priority than REQ_SYNC.
> 	In addition to that we use it to account for pending metadata
> 	requests in cfq_rq_enqueued/cfq_remove_request which gets
> 	checked in cfq_should_preempt to give priority to a meta
> 	request if the other queue doesn't have any pending meta
> 	requests.  But again this priority comes after a similar
> 	check for sync requests that checks if the other queue has
> 	been marked to have sync requests pending.

It's also annotation for blktrace, so you can tell which parts of the IO
is meta data etc. The scheduler impact is questionable, I doubt it makes
a whole lot of difference.

>  - REQ_SYNC
> 
> 	This one is used in quite a few places, with many of them
> 	obsfucated by macros like rw_is_sync, rq_is_sync and
> 	cfq_bio_sync.  In general all uses seem to imply giving
> 	a write request the same priority as a read request and
> 	treat it as synchronous.  I could not spot a place where
> 	it actually has any effect on reads.

Reads are sync by nature in the block layer, so they don't get that
special annotation.

>  - REQ_NOIDLE
> 
> 	Only used inside the cfq I/O scheduler in one place:
> 	cfq_completed_request.  Only used for READ or synchronous
> 	request.  I can't figure out what's actually going on in
> 	details here.

For a sync request, CFQ will idle the disk waiting for another one that
is close to the completed request. This is what keeps up high throughput
for read or sync write workloads, if you have more than one stream
going.

> Now the big questions:
> 
> 	What eactly is the REQ_META flag for?  Even after going
> 	through all the things I mentioned above I don't quite
> 	understand it.  It's only used for reads, and doesn't seem
> 	to give any major priority.  Should it be used for all metadata
> 	reads or just some?  Currently it's not actually very widely
> 	used.
> 
> 	Should we allow REQ_META on writes, but ignore it except for
> 	blktrace?  If the answer above is we want to tag all metadata
> 	reads as REQ_META that would allow easily spotting all metadata
> 	I/O in blktrace.

For analysis purposes, annotating all meta data IOs as such would be
beneficial (reads as well as writes). As mentioned above, the current
scheduler impact isn't huge. There may be some interesting test and
benchmarks there for improving that part.

> 	Is there any point in keeping the READ_SYNC?  If the users
> 	really want to keep the direct unplugging semantics we can
> 	just write READ | REQ_UNPLUG, but even that seems to be wrong
> 	for the log recvoery callers.
> 
> 	Similarly is there a point in keeping WRITE_SYNC?  Most callers
> 	really want WRITE_SYNC_PLUG semantics, and the current naming
> 	is extremtly confusing.  I'd much rather see the callers
> 	specify explicitly using REQ_UNPLUG if they want to unplug
> 	the queue.

So a large part of that problem is the overloaded meaning of sync. For
some cases it means "unplug on issue", and for others it means that the
IO itself is syncronous. The other nasty bit is the implicit plugging
that happens behind the back of the submitter, but that's an issue to
tackle separately. I'd suggest avoiding unnecessary churn in naming of
those.

> 	Why do O_DIRECT writes not want to set REQ_NOIDLE (and that
> 	exactly does REQ_NOIDLE mean anyway).  It's the only sync writes
> 	that do not set it, so if this special case went away we
> 	could get rid of the flag and key it off REQ_SYNC.

See above for NOIDLE. You kill O_DIRECT write throughput if you don't
idle at the end of a write, if you have other activity on the disk.

> 	Do we really need to keep the SWRITE flags?  I'd rather
> 	make that an additional flag to ll_rw_block, or even better
> 	split ll_rw_block into two helpers for the guaranteed locking
> 	or not case.

No, lets kill those.

-- 
Jens Axboe

