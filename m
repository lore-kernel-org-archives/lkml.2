Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab0FUJsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 05:48:32 -0400
Received: from verein.lst.de ([213.95.11.210]:41786 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab0FUJsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 05:48:30 -0400
Date: Mon, 21 Jun 2010 11:48:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100621094828.GA30748@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 2.442 (**) BAYES_80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I'm trying to understand the "sync" and "meta" flags we add to bios /
requests and the more I look into the more I get confused.  Let's start
with the simple bits:

 - REQ_META

	Only really used for READ_META.  There's a WRITE_META that I
	added a while ago, but the actual users of it are gone again
	now.

	The READ_META is used by ext3 and ext4 for reading inodes,
	and for all reads of directory blocks.  XFS has a place that
	sets READ_META, but it's unreachable now.  GFS2 on the other
	hand uses REQ_META directly, and ORs it into just about every
	other kind of READ/WRITE request: WRITE_BARRIER,
	WRITE_SYNC_PLUG, WRITE, READ_SYNC.

 - REQ_SYNC

	Used for READ_SYNC / WRITE_SYNC_PLUG / WRITE_SYNC /
	WRITE_ODIRECT_PLUG / WRITE_BARRIER and the SWRITE variants.

	READ_SYNC is used by GFS2 in a few spots, but always together
	with REQ_META, and by jfs and xfs for the code reading the log
	during recovery.
	(S)WRITE_SYNC_PLUG is used for ->writepage instances with
	the WB_SYNC_ALL sync_mode, and random pieces of journal /
	metadata I/O in gfs2 and jbd(2) as well as fsync_buffers_list().
	Note that the SWRITE_SYNC_PLUG uses actually degenerate to WRITE
	in ll_rw_block.c due to what seems to be a bug in that code.
	WRITE_SYNC is used by xfs for the log write if barriers are not
	supported, by jfs for all log writes, by gfs2 for at least some
	log writes, by btrfs for data writeout in some cases.
	SWRITE_SYNC is entirely unused.
	WRITE_ODIRECT_PLUG is used for O_DIRECT writes, and
	WRITE_BARRIER is used for anything using barriers.

 - REQ_NOIDLE

	Used for WRITE_SYNC_PLUG / WRITE_SYNC / WRITE_BARRIER and
	SWRITE variants.  See the description above for details.

 - REQ_UNPLUG

	Used for READ_SYNC, WRITE_SYNC and WRITE_BARRIER.

Now how do we use these flags in the block layer?
 
 - REQ_META

	The only place where we ever use this flag is inside the
	cfq scheduler. In cfq_choose_req we use it to give a meta
	request priority over one that doesn't have it.  But before
	that we already do the same preference check with rw_is_sync,
	which evaluates to true for requests with that are either
	reads or have REQ_SYNC set.  So for reads the REQ_META flag
	here effectively is a no-op, and for writes it gives less
	priority than REQ_SYNC.
	In addition to that we use it to account for pending metadata
	requests in cfq_rq_enqueued/cfq_remove_request which gets
	checked in cfq_should_preempt to give priority to a meta
	request if the other queue doesn't have any pending meta
	requests.  But again this priority comes after a similar
	check for sync requests that checks if the other queue has
	been marked to have sync requests pending.

 - REQ_SYNC

	This one is used in quite a few places, with many of them
	obsfucated by macros like rw_is_sync, rq_is_sync and
	cfq_bio_sync.  In general all uses seem to imply giving
	a write request the same priority as a read request and
	treat it as synchronous.  I could not spot a place where
	it actually has any effect on reads.

 - REQ_NOIDLE

	Only used inside the cfq I/O scheduler in one place:
	cfq_completed_request.  Only used for READ or synchronous
	request.  I can't figure out what's actually going on in
	details here.
 
 - REQ_UNPLUG

	Used to call __generic_unplug_device at the end of
	__make_reques, and one probably wrong usage in drbd (but given
	what a big piece of junk drbd is I refuse to step into that).

That's how far I got to understand this.

Now the big questions:

	What eactly is the REQ_META flag for?  Even after going
	through all the things I mentioned above I don't quite
	understand it.  It's only used for reads, and doesn't seem
	to give any major priority.  Should it be used for all metadata
	reads or just some?  Currently it's not actually very widely
	used.

	Should we allow REQ_META on writes, but ignore it except for
	blktrace?  If the answer above is we want to tag all metadata
	reads as REQ_META that would allow easily spotting all metadata
	I/O in blktrace.

	Is there any point in keeping the READ_SYNC?  If the users
	really want to keep the direct unplugging semantics we can
	just write READ | REQ_UNPLUG, but even that seems to be wrong
	for the log recvoery callers.

	Similarly is there a point in keeping WRITE_SYNC?  Most callers
	really want WRITE_SYNC_PLUG semantics, and the current naming
	is extremtly confusing.  I'd much rather see the callers
	specify explicitly using REQ_UNPLUG if they want to unplug
	the queue.

	Why do O_DIRECT writes not want to set REQ_NOIDLE (and that
	exactly does REQ_NOIDLE mean anyway).  It's the only sync writes
	that do not set it, so if this special case went away we
	could get rid of the flag and key it off REQ_SYNC.

	Do we really need to keep the SWRITE flags?  I'd rather
	make that an additional flag to ll_rw_block, or even better
	split ll_rw_block into two helpers for the guaranteed locking
	or not case.
